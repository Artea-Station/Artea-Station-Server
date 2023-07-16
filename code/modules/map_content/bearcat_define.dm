/datum/map_config/bearcat
	map_name = "ALV Bearcat"
	map_path = "map_files/Bearcat"
	map_file = "Bearcat.dmm"

	traits = list(
		list(
			"Up" = 1,
		),
		list(
			"Up" = 1,
			"Down" = -1,
			"Baseturf" = "/turf/open/openspace",
		),
		list(
			"Up" = 1,
			"Down" = -1,
			"Baseturf" = "/turf/open/openspace",
		),
		list(
			"Down" = -1,
			"Baseturf" = "/turf/open/openspace",
		),
	)
	space_ruin_levels = 3
	global_trading_hub_type = /datum/trade_hub/randomname/large
	overmap_object_type = /datum/overmap_object/shuttle/ship/bearcat
	job_faction = FACTION_BEARCAT
