-- Flattened view with key positions per team for each game
-- Assumes input table GamePredictorDataNEW has full per-player stats per game

CREATE MATERIALIZED VIEW FlattenedGameData AS
WITH 
qb AS (
  SELECT game_id, club_code, full_name, passing_yards, passing_epa
  FROM GamePredictorDataNEW
  WHERE position = 'QB'
),
rb AS (
  SELECT *, ROW_NUMBER() OVER (PARTITION BY game_id, club_code ORDER BY rushing_epa DESC NULLS LAST) as rb_rank
  FROM GamePredictorDataNEW
  WHERE position = 'RB'
),
wr AS (
  SELECT *, ROW_NUMBER() OVER (PARTITION BY game_id, club_code ORDER BY receiving_epa DESC NULLS LAST) as wr_rank
  FROM GamePredictorDataNEW
  WHERE position = 'WR'
),
te AS (
  SELECT game_id, club_code, full_name, receiving_yards, receiving_epa
  FROM GamePredictorDataNEW
  WHERE position = 'TE'
),
kicker AS (
  SELECT game_id, club_code, full_name
  FROM GamePredictorDataNEW
  WHERE position = 'K'
),
defense AS (
  SELECT *, ROW_NUMBER() OVER (PARTITION BY game_id, club_code ORDER BY def_tackles DESC NULLS LAST) as def_rank
  FROM GamePredictorDataNEW
  WHERE position IN ('CB', 'S', 'LB', 'DE', 'DT', 'OLB', 'MLB', 'FS', 'SS')
)
SELECT 
  g.game_id,
  g.season,
  g.week,
  g.home_team,
  g.away_team,

  -- Home Team
  hqb.full_name AS home_qb,
  hqb.passing_yards AS home_qb_passing_yards,
  hqb.passing_epa AS home_qb_passing_epa,

  hrb1.full_name AS home_rb1,
  hrb2.full_name AS home_rb2,

  hwr1.full_name AS home_wr1,
  hwr2.full_name AS home_wr2,

  hte.full_name AS home_te,
  hk.full_name AS home_kicker,

  hdef1.full_name AS home_def1,
  hdef2.full_name AS home_def2,

  -- Away Team
  aqb.full_name AS away_qb,
  aqb.passing_yards AS away_qb_passing_yards,
  aqb.passing_epa AS away_qb_passing_epa,

  arb1.full_name AS away_rb1,
  arb2.full_name AS away_rb2,

  awr1.full_name AS away_wr1,
  awr2.full_name AS away_wr2,

  ate.full_name AS away_te,
  ak.full_name AS away_kicker,

  adef1.full_name AS away_def1,
  adef2.full_name AS away_def2

FROM (
  SELECT DISTINCT game_id, season, week, home_team, away_team FROM GamePredictorDataNEW
) g
LEFT JOIN qb hqb ON g.game_id = hqb.game_id AND g.home_team = hqb.club_code
LEFT JOIN qb aqb ON g.game_id = aqb.game_id AND g.away_team = aqb.club_code

LEFT JOIN rb hrb1 ON g.game_id = hrb1.game_id AND g.home_team = hrb1.club_code AND hrb1.rb_rank = 1
LEFT JOIN rb hrb2 ON g.game_id = hrb2.game_id AND g.home_team = hrb2.club_code AND hrb2.rb_rank = 2

LEFT JOIN wr hwr1 ON g.game_id = hwr1.game_id AND g.home_team = hwr1.club_code AND hwr1.wr_rank = 1
LEFT JOIN wr hwr2 ON g.game_id = hwr2.game_id AND g.home_team = hwr2.club_code AND hwr2.wr_rank = 2

LEFT JOIN te hte ON g.game_id = hte.game_id AND g.home_team = hte.club_code
LEFT JOIN kicker hk ON g.game_id = hk.game_id AND g.home_team = hk.club_code

LEFT JOIN defense hdef1 ON g.game_id = hdef1.game_id AND g.home_team = hdef1.club_code AND hdef1.def_rank = 1
LEFT JOIN defense hdef2 ON g.game_id = hdef2.game_id AND g.home_team = hdef2.club_code AND hdef2.def_rank = 2

LEFT JOIN rb arb1 ON g.game_id = arb1.game_id AND g.away_team = arb1.club_code AND arb1.rb_rank = 1
LEFT JOIN rb arb2 ON g.game_id = arb2.game_id AND g.away_team = arb2.club_code AND arb2.rb_rank = 2

LEFT JOIN wr awr1 ON g.game_id = awr1.game_id AND g.away_team = awr1.club_code AND awr1.wr_rank = 1
LEFT JOIN wr awr2 ON g.game_id = awr2.game_id AND g.away_team = awr2.club_code AND awr2.wr_rank = 2

LEFT JOIN te ate ON g.game_id = ate.game_id AND g.away_team = ate.club_code
LEFT JOIN kicker ak ON g.game_id = ak.game_id AND g.away_team = ak.club_code

LEFT JOIN defense adef1 ON g.game_id = adef1.game_id AND g.away_team = adef1.club_code AND adef1.def_rank = 1
LEFT JOIN defense adef2 ON g.game_id = adef2.game_id AND g.away_team = adef2.club_code AND adef2.def_rank = 2;


