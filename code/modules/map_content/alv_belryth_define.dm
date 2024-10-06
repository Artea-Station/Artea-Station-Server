/datum/map_config/alv_belryth
	map_name = "ALV Belryth"
	map_path = "map_files/ALV Belryth"
	map_file = "ALV Belryth.dmm"

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
	)
	//central_trading_hub_type = /datum/trade_hub/randomname/large
	overmap_object_type = /datum/overmap_object/shuttle/ship/alv_belryth
	job_faction = FACTION_BELRYTH
	job_changes = list()
	overflow_job = /datum/job/assistant/bearcat
	shuttles = list(
		"cargo" = "cargo_belryth",
		"ferry" = "ferry_kilo",
		"whiteship" = "whiteship_kilo",
		"emergency" = "emergency_kilo",
	)
