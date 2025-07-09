DROP TABLE IF EXISTS playergame;

CREATE TABLE playergame AS
SELECT
	rd.gsis_id as player_id,
	uni.game_id,
	uni.home_team,
	uni.away_team,
	rd.full_name,
	rd.club_code,
	rd.position,
	rd.week,
	rd.season
FROM rawdepth rd
LEFT JOIN unique_games uni
	ON uni.season = rd.season 
	AND uni.week = rd.week
	AND uni.away_team = rd.club_code

-- There was an OR clause in my join making the query long. This union joins them
UNION ALL

-- Selects data
SELECT 
	rd.gsis_id as player_id,
	uni.game_id,
	uni.home_team,
	uni.away_team,
	rd.full_name,
	rd.club_code,
	rd.position,
	rd.week,
	rd.season
FROM rawdepth rd
JOIN unique_games uni
	ON uni.season = rd.season 
	AND uni.week = rd.week
	AND uni.home_team = rd.club_code;


