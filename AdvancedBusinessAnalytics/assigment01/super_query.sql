-- let's find the matchups of the round (week) 5
select
	m.league_id, 
	m.week, 
    m.home_id, 
    hmt.team_name as home_team_name, 
    m.away_id, 
    awt.team_name as away_team_name
from matchup m
inner join team hmt on hmt.team_id = m.home_id
inner join team awt on awt.team_id = m.away_id
inner join roster hmr 
on m.league_id=hmr.league_id and m.week=hmr.week and hmt.team_id=hmr.team_id
where m.week=5 and m.league_id=3940933;


-- week team total score
select league_id, week, team_id, sum(points)
from (
	-- join roster with points to get individual player's points in the rosters
	select r.league_id, r.week, r.team_id, r.player_id, r.rosterSlot, p.points
	from roster r inner join points p 
	on r.league_id=p.league_id and r.week=p.week and r.player_id=p.player_id
) roster_points
-- exclude players in the bench, their pontuation don't count as team points
where rosterSlot != "BN" and week=5 and league_id=3940933
group by league_id, week, team_id;


-- round results query
select
 	m.league_id, 
	m.week, 
    m.home_id, 
    hmt.team_name as home_team_name, 
    htpts.total_points as home_team_points,
    m.away_id, 
    awt.team_name as away_team_name,
    awpts.total_points as away_team_points
from matchup m
-- to get tha names of home and visitor teams
inner join team hmt on hmt.team_id = m.home_id
inner join team awt on awt.team_id = m.away_id
-- score for home team
inner join (
	select league_id, week, team_id, round(sum(points),1) as total_points
	from (
		-- join roster with points to get individual player's points in the rosters
		select r.league_id, r.week, r.team_id, r.player_id, r.rosterSlot, p.points
		from roster r inner join points p 
		on r.league_id=p.league_id and r.week=p.week and r.player_id=p.player_id
	) roster_points
	-- exclude players in the bench, their pontuation don't count as team points
	where rosterSlot != "BN"
	group by league_id, week, team_id
) htpts on m.league_id=htpts.league_id and m.week=htpts.week and hmt.team_id=htpts.team_id
-- score for visitor team
inner join (
	select league_id, week, team_id, round(sum(points),1) total_points
	from (
		-- join roster with points to get individual player's points in the rosters
		select r.league_id, r.week, r.team_id, r.player_id, r.rosterSlot, p.points
		from roster r inner join points p 
		on r.league_id=p.league_id and r.week=p.week and r.player_id=p.player_id
	) roster_points
	-- exclude players in the bench, their pontuation don't count as team points
	where rosterSlot != "BN"
	group by league_id, week, team_id
) awpts on m.league_id=awpts.league_id and m.week=awpts.week and awt.team_id=awpts.team_id
-- just from week and league of interest
where m.week=5 and m.league_id=3940933
order by home_team_points desc

