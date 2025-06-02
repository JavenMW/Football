CREATE VIEW modelData AS
SELECT 
	pbp.wp,
	pbp.epa,
	pbp.game_id,
	ro.position
FROM rawpbp pbp
LEFT JOIN rawoff ro ON pbp.passer_id = ro.player_id
GROUP BY QB1, pbp.epa, pbp.wp, pbp.game_id;