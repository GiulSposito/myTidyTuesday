library(tidyverse)
library(glue)

# building league
# shoud be
# league_id
# league_name
league <- tibble(
  league_id = 3940933,
  league_name = "Its Football Dudes",
  league_url = "https://dudesfootball.netlify.com/" 
)

# building team
x <- readRDS("./data/ffanalytics/week1_simulation_v3.rds")
team <- tibble(
  team_id = c(x$away.teamId, x$home.teamId),
  team_name = c(x$away.name, x$home.name),
  team_logo = c(x$away.logo, x$home.logo)
)

matchups <- 1:9 %>% 
  map_df(function(.x) 
    glue("./data/ffanalytics/week{.x}_simulation_v3.rds") %>% 
      readRDS() %>%
      mutate(week=.x)
    ) %>% 
  mutate( league_id=league$league_id ) %>%
  select(league_id, week, home.teamId, home.id, away.teamId, away.id, home.pts, away.pts) %>% 
  mutate( home_id = ifelse(is.na(home.id), home.teamId, home.id),
          away_id = ifelse(is.na(away.id), away.teamId, away.id)) %>% 
  select( league_id, week, away_id, away_pts = away.pts, home_id, home_pts=home.pts)


