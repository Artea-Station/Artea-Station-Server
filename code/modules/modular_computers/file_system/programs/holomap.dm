/datum/computer_file/program/holomap
	filename = "statusdisplay"
	program_icon = "map-location-dot"
	program_icon_state = "generic"

	filedesc = "Holomap"
	extended_desc = "A map of your surroundings."
	category = PROGRAM_CATEGORY_CREW
	tgui_id = "NtosHolomap"

	// This could be quite powerful without at least some basic infrastructure.
	// NOTE: Only station and lavaland (filtered to only show the station) levels are generated roundstart, plans are to add mid-round scanning support later, due to the code that would be required.
	requires_ntnet = TRUE

	size = 1
	usage_flags = PROGRAM_ALL

	var/current_z

	/// A static list of base64 strings of maps that have already been seen.
	var/static/list/image_cache = list()

/datum/computer_file/program/holomap/process_tick()
	var/turf/turf = get_turf(computer)
	var/cur_z = turf.z
	if(cur_z != current_z)
		current_z = cur_z
		computer.update_static_data_for_all_viewers()

/datum/computer_file/program/holomap/ui_data(mob/user)
	var/data = ..()
	var/turf/turf = get_turf(computer)
	data["pos_x"] = turf.x
	data["pos_y"] = turf.y
	return data

/datum/computer_file/program/holomap/ui_static_data(mob/user)
	var/turf/turf = get_turf(computer)
	var/cur_z = turf.z
	var/list/data = list()
	if(!image_cache["holo_image"])
		image_cache["holo_image"] = icon2base64(icon(HOLOMAP_ICON, "stationmap"))

	if(!image_cache["[cur_z]"])
		image_cache["[cur_z]"] = icon2base64(SSholomaps.holomaps["[cur_z]"])

	if(!image_cache["[HOLOMAP_EXTRA_STATIONMAPAREAS]_[cur_z]"])
		image_cache["[HOLOMAP_EXTRA_STATIONMAPAREAS]_[cur_z]"] = icon2base64(SSholomaps.extra_holomaps["[HOLOMAP_EXTRA_STATIONMAPAREAS]_[cur_z]"])

	data["static_pos_to_area_name"] = SSholomaps.holomap_position_to_name["[cur_z]"] || "Unknown area!"
	data["static_map_background"] = image_cache["holo_image"]
	data["static_map_icon"] = image_cache["[cur_z]"]
	data["static_map_areas"] = image_cache["[HOLOMAP_EXTRA_STATIONMAPAREAS]_[cur_z]"]
	var/list/overlays = list()
	data["static_overlays"] = overlays

	var/list/subsystem_overlays = SSholomaps.holomap_z_transitions["[cur_z]"]

	for(var/overlay_name as anything in subsystem_overlays)
		var/list/overlay_data = subsystem_overlays[overlay_name]
		if(!overlay_data["color"])
			continue

		var/list/markers = list()
		var/list/processed_overlay = list("color" = overlay_data["color"], "markers" = markers)

		for(var/image/marker as anything in overlay_data["markers"])
			markers += list("[marker.pixel_x],[marker.pixel_y]")

		overlays[overlay_name] = processed_overlay

	return data
