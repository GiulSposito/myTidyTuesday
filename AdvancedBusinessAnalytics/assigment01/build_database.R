library(tidyverse)
library(glue)
library(jsonlite)

# LEAGUE
# shoud be
# league_id
# league_name
league <- tibble(
  league_id = as.integer(3940933),
  league_name = "Its Football Dudes",
  league_url = "https://dudesfootball.netlify.com/" 
)

# teams and owners
json <- fromJSON("./data/ffanalytics/teams.json", simplifyDataFrame = T)
owner <- json$users %>%
  map_df(as_tibble) %>% 
  mutate(
    league_id = league$league_id,  
    owner_id=as.integer(userId) 
  ) %>% 
  select(owner_id, owner_name=name)

team <- json$games$`102019`$leagues$`3940933`$teams %>%
  map_df(as_tibble) %>% 
  mutate( 
    league_id = league$league_id, 
    team_id=as.integer(teamId),
    owner_id=as.integer(ownerUserId)
  ) %>% 
  select(league_id, team_id, owner_id, team_name=name, team_logo_url=imageUrl)

# RANK
rank <- readRDS("./data/ffanalytics/weekly_results.rds") %>% 
  mutate( league_id = league$league_id) %>% 
  mutate( week=as.integer(week),
          team_id=as.integer(id)) %>% 
  select( league_id, week, team_id, rank)

sims <- 1:9 %>% 
  map_df(function(.x) 
    glue("./data/ffanalytics/week{.x}_simulation_v3.rds") %>% 
      readRDS()
  )
  
# MATCHUP
matchup <- sims %>%
  mutate( league_id=league$league_id ) %>%
  select( league_id, week, home.id, home.pts, away.id, away.pts) %>% 
  set_names(str_replace(names(.),"\\.","_"))

# ROSTER
roster <- bind_rows(
  select(sims, week, team_id=home.id, team_roster=home.players),
  select(sims, week, team_id=away.id, team_roster=away.players)
  ) %>% 
  unnest(team_roster) %>% 
  mutate( league_id=league$league_id ) %>%
  select( league_id, week, team_id, player_id=id, rosterSlot)

# PLAYERS
players <- readRDS("./data/ffanalytics/players.rds") %>% 
  select(player_id = playerId, first_name= firstName, last_name=lastName, position, nfl_team_abbr=nflTeamAbbr, 
         injury_status=injuryGameStatus, image_url=imageUrl, bye_week=byeWeek) %>% 
  mutate_at(vars(position, nfl_team_abbr,injury_status), as.character)

# POINTS
points <- readRDS("./data/ffanalytics/players_points.rds") %>% 
  mutate( league_id=league$league_id, nfl_id=as.integer(nfl_id) ) %>%
  select( league_id, week, player_id=nfl_id, points)

# mapping table
# library(ffanalytics)
# carregando tabelas de "de para" correcao do ID de jogadores
load("../ffanalytics/R/sysdata.rda") # <<- Players IDs !!!
id_mapping <- player_ids %>% 
  mutate( 
    id     = as.integer(id), 
    nfl_id = as.integer(nfl_id)
  ) %>%
  mutate(
    nfl_id        = ifelse(id==14600, 2563132,     nfl_id),
    fantasypro_id = ifelse(id==14600, "joey-slye", fantasypro_id),
    fftoday_id    = ifelse(id==14600, "16763",     fftoday_id),
  ) %>%  
  as_tibble() %>% 
  mutate(nfl_id=as.integer(nfl_id)) %>% 
  select(ffanalytics_id=id, player_id=nfl_id)


# PROJECTIONS
projections <- readRDS("./data/ffanalytics/points_projection.rds")
projections <- projections %>% 
  rename(ffanalytics_id=id) %>% 
  inner_join(id_mapping, by = "ffanalytics_id") %>% 
  select( week, data_src_id=data_src, player_id, pts_proj=pts.proj ) %>% 
  mutate( league_id=league$league_id )

# data sources
load("../ffanalytics/data/projection_sources.rda")
data_sources <- projection_sources %>% 
  map(function(.x){
    .x$base    
  }) %>% 
  unlist() %>% 
  tibble(
    data_src_id = names(.),
    data_src_url = .
  )

# clean auxiliry tables
rm(id_mapping)
rm(player_ids)
rm(sims)
rm(projection_sources)
rm(json)


# creating tables
library(dbplyr)
library(DBI)

# connection to sql proxy
con <- DBI::dbConnect(RMariaDB::MariaDB(),
                      host="127.0.0.1",
                      user="root",
                      password="skankdb", # rstudioapi::askForPassword("Database Passaport"),
                      dbname="assign01")

# league
# owner
# team

league
copy_to(con, league, "league",
        temporary = FALSE, 
        overwrite = TRUE,
        unique_indexes = list("league_id"))

owner
copy_to(con, owner, "owner",
        temporary = FALSE, 
        overwrite = TRUE,
        unique_indexes = list("owner_id"))

team
copy_to(con, team, "team", temporary=FALSE, 
        overwrite = TRUE,
        unique_indexes=list("team_id"),
        indexes=list("league_id","owner_id"))

players %>% 
  select(-injury_status) %>% 
  copy_to(con, ., "player", temporary=FALSE, 
          overwrite=TRUE,
          unique_indexes=list("player_id"))

matchup %>% 
  select(-contains("pts")) %>% 
  copy_to(con, ., "matchup", temporary=F,
          overwrite=T, 
          indexes=list("league_id","week","home_id","away_id"))

roster
copy_to(con, roster, "roster", temporary=F, overwrite=T, 
        indexes=list("league_id","week","team_id","player_id"))

data_sources
copy_to(con, data_sources, "data_source", temporary=F, overwrite=T)

projections %>% 
  filter(week %in% 5) %>% 
  copy_to(con, ., "projection", temporary=F, overwrite=T, indexes=list("week","player_id"))

points %>% 
  filter(week == 5) %>% 
  copy_to(con, ., "points", temporary=F, overwrite=T, indexes=list("league_id","week","player_id"))

rank %>% 
  copy_to(con,.,"rank",temporary=F, overwrite=T, indexes=list("league_id","week","team_id"))
