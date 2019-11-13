-- primary keys

ALTER TABLE owner
ADD PRIMARY KEY (owner_id);

ALTER TABLE league
ADD PRIMARY KEY (league_id);

ALTER TABLE player
ADD PRIMARY KEY (player_id);

ALTER TABLE data_source
ADD PRIMARY KEY (data_src_id(20));

ALTER TABLE team
ADD PRIMARY KEY(league_id, team_id);

-- foregn keys

ALTER TABLE points
ADD FOREIGN KEY (league_id) REFERENCES league(league_id);

ALTER TABLE matchup
ADD FOREIGN KEY (league_id) REFERENCES league(league_id);

ALTER TABLE matchup
ADD FOREIGN KEY (home_id) REFERENCES team(team_id);

ALTER TABLE matchup
ADD FOREIGN KEY (away_id) REFERENCES team(team_id);

ALTER TABLE team
ADD FOREIGN KEY (league_id) REFERENCES league(league_id);

ALTER TABLE projection
ADD FOREIGN KEY (league_id) REFERENCES league(league_id);

ALTER TABLE projection
ADD FOREIGN KEY (player_id) REFERENCES league(player_id);

ALTER TABLE data_src_id
ADD FOREIGN KEY (data_source) REFERENCES data_source(data_src_id);

ALTER TABLE rank
ADD FOREIGN KEY (league_id) REFERENCES league(league_id);

ALTER TABLE rank
ADD FOREIGN KEY (team_id) REFERENCES team(team_id);

