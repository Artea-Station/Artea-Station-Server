//This file is used to contain unique properties of every map, and how we wish to alter them on a per-map basis.
//Use JSON files that match the datum layout and you should be set from there.
//Right now, we default to MetaStation to ensure something does indeed load by default.
//  -san7890 (with regards to Cyberboss)

/datum/map_config
	// Metadata
	var/config_filename = "_maps/metastation.json"
	var/defaulted = TRUE  // set to FALSE by LoadConfig() succeeding
	// Config from maps.txt
	var/config_max_users = 0
	var/config_min_users = 0
	var/voteweight = 1
	var/votable = FALSE

	// Config actually from the JSON - should default to Meta
	var/map_name = "Meta Station"
	var/map_path = "map_files/MetaStation"
	var/map_file = "MetaStation.dmm"

	var/traits = null
	var/space_ruin_levels = 7
	var/space_empty_levels = 1

	var/minetype = "lavaland"

	var/allow_custom_shuttles = TRUE
	var/shuttles = list(
		"cargo" = "cargo_box",
		"ferry" = "ferry_fancy",
		"whiteship" = "whiteship_meta",
		"emergency" = "emergency_meta")

	var/job_faction = FACTION_STATION

	var/overflow_job = /datum/job/assistant

	/// Dictionary of job sub-typepath to template changes dictionary
	var/job_changes = list()
	/// List of additional areas that count as a part of the library
	var/library_areas = list()

	/// Type of the global trading hub that will be created
	var/global_trading_hub_type = /datum/trade_hub/worldwide
	/// A lazylist of types of trading hubs to be spawned
	var/localized_trading_hub_types = list(/datum/trade_hub/randomname, /datum/trade_hub/randomname)

	/// The type of the overmap object the station will act as on the overmap
	var/overmap_object_type = /datum/overmap_object/shuttle/station
	/// The weather controller the station levels will have
	var/weather_controller_type = /datum/weather_controller
	/// Type of the atmosphere that will be loaded on station
	var/atmosphere_type
	/// Possible rock colors of the loaded map
	var/list/rock_color
	/// Possible plant colors of the loaded map
	var/list/plant_color
	/// Possible grass colors of the loaded map
	var/list/grass_color
	/// Possible water colors of the loaded map
	var/list/water_color

	var/amount_of_planets_spawned = 4

	var/ore_node_seeder_type

/datum/map_config/New()
	//Make sure that all levels in station do have this z trait
	. = ..()
	if(islist(traits))
		for(var/level in traits)
			var/list/level_traits = level
			level_traits[ZTRAIT_STATION] = TRUE

/datum/map_config/proc/get_map_info()
	return "You're on board the <b>[map_name]</b>, a top of the class NanoTrasen resesearch station."

/**
 * Proc that simply loads the default map config, which should always be functional.
 */
/proc/load_default_map_config()
	return new /datum/map_config/metastation

/**
 * Proc handling the loading of map configs. Will return the default map config using [/proc/load_default_map_config] if the loading of said file fails for any reason whatsoever, so we always have a working map for the server to run.
 * Arguments:
 * * filename - Name of the config file for the map we want to load. The .json file extension is added during the proc, so do not specify filenames with the extension.
 * * directory - Name of the directory containing our .json - Must be in MAP_DIRECTORY_WHITELIST. We default this to MAP_DIRECTORY_MAPS as it will likely be the most common usecase. If no filename is set, we ignore this.
 * * error_if_missing - Bool that says whether failing to load the config for the map will be logged in log_world or not as it's passed to LoadConfig().
 *
 * Returns the config for the map to load.
 */
/proc/load_map_config(filename = null, directory = null, error_if_missing = TRUE)

	if(filename) // If none is specified, then go to look for next_map.json, for map rotation purposes.

		//Default to MAP_DIRECTORY_MAPS if no directory is passed
		if(directory)
			if(!(directory in MAP_DIRECTORY_WHITELIST))
				log_world("map directory not in whitelist: [directory] for map [filename]")
				return load_default_map_config()
		else
			directory = MAP_DIRECTORY_MAPS

		filename = "[directory]/[filename].json"
	else
		filename = PATH_TO_NEXT_MAP_JSON

	var/datum/map_config/config = LoadConfig(filename, error_if_missing)
	if (!config)
		return load_default_map_config()

	return config

#define CHECK_EXISTS(X) if(!istext(json[X])) { log_world("[##X] missing from json!"); return; }
/proc/LoadConfig(filename, error_if_missing)
	if(!fexists(filename))
		if(error_if_missing)
			log_world("map_config not found: [filename]")
		return

	var/json = file(filename)
	if(!json)
		log_world("Could not open map_config: [filename]")
		return

	json = file2text(json)
	if(!json)
		log_world("map_config is not text: [filename]")
		return

	json = json_decode(json)
	if(!json)
		log_world("map_config is not json: [filename]")
		return

	if(!json["map_type"])
		log_world("map_config doesn't have a map_type to point to its config datum!")
		return

	CHECK_EXISTS("map_type")
	var/type_to_load = text2path(json["map_type"])
	var/datum/map_config/config = new type_to_load()
	config.defaulted = FALSE
	config.config_filename = filename
	return config
#undef CHECK_EXISTS

/datum/map_config/proc/GetFullMapPaths()
	if (istext(map_file))
		return list("_maps/[map_path]/[map_file]")
	. = list()
	for (var/file in map_file)
		. += "_maps/[map_path]/[file]"

/datum/map_config/proc/MakeNextMap()
	return config_filename == PATH_TO_NEXT_MAP_JSON || fcopy(config_filename, PATH_TO_NEXT_MAP_JSON)
