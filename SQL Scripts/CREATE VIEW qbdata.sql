DROP MATERIALIZED VIEW IF EXISTS qbdata;

CREATE MATERIALIZED VIEW qbdata AS
SELECT DISTINCT ON (game_id)
  g.game_id,
  g.home_team,
  g.away_team,
  pbp.away_score,
  pbp.home_score,
  g.week,
  g.season,
  hqbstats1.player_display_name AS hqb1,
  hqbstats1.completions AS hqb1_completions,
  hqbstats1.passing_epa AS hqb1_passing_epa,
  hqbstats1.attempts AS hqb1_attempts,
  hqbstats1.passing_yards AS hqb1_passing_yards,
  hqbstats1.passing_tds AS hqb1_passing_tds,
  hqbstats1.interceptions AS hqb1_interceptions,
  hqbstats1.sacks AS hqb1_sacks,
  hqbstats1.sack_yards AS hqb1_sack_yards,
  hqbstats1.passing_first_downs AS hqb1_passing_first_downs,
  aqb1stats.player_display_name AS aqb1,
  aqb1stats.completions AS aqb1_completions,
  aqb1stats.passing_epa AS aqb1_passing_epa,
  aqb1stats.attempts AS aqb1_attempts,
  aqb1stats.passing_yards AS aqb1_passing_yards,
  aqb1stats.passing_tds AS aqb1_passing_tds,
  aqb1stats.interceptions AS aqb1_interceptions,
  aqb1stats.sacks AS aqb1_sacks,
  aqb1stats.sack_yards AS aqb1_sack_yards,
  aqb1stats.passing_first_downs AS aqb1_passing_first_downs,

CASE
	WHEN home_score > away_score THEN 'home_team_won'
	ELSE 'away_team_won'
	END AS winner

FROM unique_games g
LEFT JOIN (
  SELECT game_id, away_score, home_score
  FROM rawpbp
) pbp ON pbp.game_id = g.game_id

LEFT JOIN (
  SELECT season, week, club_code, full_name, gsis_id
  FROM rawdepth
  WHERE position = 'QB'
  AND rawdepth.depth_team = 1
) hqb1 ON hqb1.season = g.season AND hqb1.week = g.week AND hqb1.club_code = g.home_team

LEFT JOIN (
  SELECT season, week, player_id, recent_team, attempts, completions, passing_yards, passing_tds, passing_epa, interceptions, sacks, sack_yards, passing_first_downs, player_display_name
  FROM (SELECT *, ROW_NUMBER() OVER (PARTITION BY season, week, recent_team ORDER BY passing_yards DESC) AS qb_rank FROM rawoff WHERE position = 'QB') ranked_qbs
  WHERE qb_rank = 1
) hqbstats1 ON hqbstats1.week = g.week  AND hqbstats1.season = g.season AND hqbstats1.recent_team = g.home_team --ON hqbstats1.player_id = hqb1.gsis_id

LEFT JOIN (
  SELECT season, week, club_code, full_name, gsis_id
  FROM rawdepth
  WHERE position = 'QB'
  AND rawdepth.depth_team = 2
) hqb2 ON hqb2.season = g.season AND hqb2.week = g.week AND hqb2.club_code = g.home_team

LEFT JOIN (
  SELECT season, week, player_id, recent_team, attempts, completions, passing_yards, passing_tds, passing_epa, interceptions, sacks, sack_yards, passing_first_downs, player_display_name
  FROM rawoff
  WHERE rawoff.position = 'QB'
) hqbstats2 ON hqbstats2.player_id = hqb2.gsis_id AND hqbstats2.week = hqb2.week  AND hqbstats2.season = hqb2.season AND hqbstats2.recent_team = hqb2.club_code

LEFT JOIN (
  SELECT season, week, club_code, full_name, gsis_id
  FROM rawdepth
  WHERE position = 'QB'
  AND rawdepth.depth_team = 1
) aqb1 ON aqb1.season = g.season AND aqb1.week = g.week AND aqb1.club_code = g.away_team

LEFT JOIN (
SELECT season, week, player_id, recent_team, attempts, completions, passing_yards, passing_tds, passing_epa, interceptions, sacks, sack_yards, passing_first_downs, player_display_name
FROM (SELECT *, ROW_NUMBER() OVER (PARTITION BY season, week, recent_team ORDER BY passing_yards DESC) AS qb_rank FROM rawoff WHERE position = 'QB') ranked_qbs
WHERE qb_rank = 1
) aqb1stats ON aqb1stats.week = g.week  AND aqb1stats.season = g.season AND aqb1stats.recent_team = g.away_team

LEFT JOIN (
  SELECT season, week, club_code, full_name, gsis_id
  FROM rawdepth
  WHERE position = 'QB'
  AND rawdepth.depth_team = 2
) aqb2 ON aqb2.season = g.season AND aqb2.week = g.week AND aqb2.club_code = g.away_team;