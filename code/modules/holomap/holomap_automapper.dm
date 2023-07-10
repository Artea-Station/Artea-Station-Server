// Doing it via macros is far more readable than doing an entry per.
#define HOLOMAP_SPAWN(name, ar, amt) /datum/area_spawn/holomap_##name {\
	target_areas = list(##ar); \
	desired_atom = /obj/machinery/station_map; \
	mode = AREA_SPAWN_MODE_MOUNT_WALL; \
	amount_to_spawn = amt; }

#define HOLOMAP_SPAWN_ENGI(name, ar, amt) /datum/area_spawn/holomap_##name {\
	target_areas = list(##ar); \
	desired_atom = /obj/machinery/station_map/engineering; \
	mode = AREA_SPAWN_MODE_MOUNT_WALL; \
	amount_to_spawn = amt; }

/obj/machinery/firealarm/Initialize(mapload, dir, building)
	. = ..()
	if(istype(get_area(src), /area/station))
		LAZYADD(GLOB.station_fire_alarms["[z]"], src)

/obj/machinery/firealarm/Destroy()
	LAZYREMOVE(GLOB.station_fire_alarms["[z]"], src)
	. = ..()

#undef HOLOMAP_SPAWN
#undef HOLOMAP_SPAWN_ENGI
