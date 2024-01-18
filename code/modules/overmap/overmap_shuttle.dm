/datum/overmap_object/shuttle
	name = "Shuttle"
	visual_type = /obj/effect/abstract/overmap/shuttle
	overmap_process = TRUE

	var/obj/docking_port/mobile/my_shuttle
	var/datum/transit_instance/transit_instance
	var/angle = 0

	var/velocity_x = 0
	var/velocity_y = 0

	var/impulse_power = 1

	var/helm_command = HELM_IDLE
	var/destination_x = 0
	var/destination_y = 0

	/// Otherwise it's abstract and it doesnt have a physical shuttle in transit, or people in it. Maintain this for the purposes of AI raid ships
	var/is_physical = TRUE

	/// If true then it doesn't have a "shuttle" and is not alocated in transit and cannot dock anywhere, but things may dock into it
	var/is_seperate_z_level = FALSE //(This can mean it's several z levels too)

	/// For sensors lock follow
	var/follow_range = 1

	var/shuttle_ui_tab = SHUTTLE_TAB_GENERAL

	/// At which offset range the helm pad will apply at
	var/helm_pad_range = 3
	/// If true, then the applied offsets will be relative to the ship position, instead of direction position
	var/helm_pad_relative_destination = TRUE

	var/helm_pad_engage_immediately = TRUE

	var/open_comms_channel = FALSE
	var/microphone_muted = FALSE

	var/datum/overmap_lock/lock

	var/target_command = TARGET_IDLE

	var/datum/overmap_shuttle_controller/shuttle_controller
	var/uses_rotation = TRUE
	var/fixed_parallax_dir
	var/shuttle_capability = ALL_SHUTTLE_CAPABILITY

	//Extensions
	var/list/all_extensions = list()
	var/list/engine_extensions = list()
	var/list/shield_extensions = list()
	var/list/transporter_extensions = list()
	var/list/weapon_extensions = list()

	var/speed_divisor_from_mass = 1

	//Turf to which you need access range to access in order to do topics (this is done in this way so I dont need to keep track of consoles being in use)
	var/obj/control_console

	var/last_shield_change_state = 0

	var/current_parallax_dir = 0

/datum/overmap_object/shuttle/GetAllAliveClientMobs()
	. = ..()
	if(my_shuttle)
		//About the most efficient way I could think of doing it
		var/datum/space_level/transit_level = SSmapping.transit
		for(var/i in SSmobs.clients_by_zlevel[transit_level.z_value])
			var/mob/iterated_mob = i
			var/turf/mob_turf = get_turf(iterated_mob)
			if(my_shuttle.shuttle_areas[mob_turf.loc])
				. += iterated_mob

/datum/overmap_object/shuttle/GetAllClientMobs()
	. = ..()
	if(my_shuttle)
		//About the most efficient way I could think of doing it
		var/datum/space_level/transit_level = SSmapping.transit
		for(var/i in SSmobs.dead_players_by_zlevel[transit_level.z_value])
			var/mob/iterated_mob = i
			var/turf/mob_turf = get_turf(iterated_mob)
			if(my_shuttle.shuttle_areas[mob_turf.loc])
				. += iterated_mob

/datum/overmap_object/shuttle/proc/GetSensorTargets(target)
	var/list/targets = list()
	for(var/datum/overmap_object/overmap_object as anything in current_system.GetObjectsInRadius(x,y,SENSOR_RADIUS))
		if(overmap_object != src && overmap_object.overmap_flags & OV_SHOWS_ON_SENSORS)
			targets += list(list(
				"id" = overmap_object.id,
				"name" = overmap_object.name,
				"x" = overmap_object.x,
				"y" = overmap_object.y,
				"distance" = FLOOR(TWO_POINT_DISTANCE(x, y, overmap_object.x, overmap_object.y), 1),
				"is_target" = target == overmap_object,
				"in_lock_range" = IN_LOCK_RANGE(src, overmap_object),
				"is_destination" = destination_x == overmap_object.x && destination_y == overmap_object.y,
			))
	targets = sortTim(targets, GLOBAL_PROC_REF(cmp_overmap_target_distance))
	return targets

/proc/cmp_overmap_target_distance(a, b)
	return a["distance"] - b["distance"]

/datum/overmap_object/shuttle/proc/GetCapSpeed()
	var/cap_speed = 0
	for(var/i in engine_extensions)
		var/datum/shuttle_extension/engine/ext = i
		if(!ext.CanOperate())
			continue
		cap_speed += ext.GetCapSpeed(impulse_power)
	return cap_speed / speed_divisor_from_mass

/datum/overmap_object/shuttle/proc/DrawThrustFromAllEngines()
	var/draw_thrust = 0
	for(var/i in engine_extensions)
		var/datum/shuttle_extension/engine/ext = i
		if(!ext.CanOperate())
			continue
		draw_thrust += ext.DrawThrust(impulse_power)
	return draw_thrust / speed_divisor_from_mass

/datum/ui_state/physical_other_obj
	var/obj/other_obj

/datum/ui_state/physical_other_obj/New(obj/other_object)
	. = ..()
	other_obj = other_object

/datum/ui_state/physical_other_obj/can_use_topic(src_object, mob/user)
	. = user.shared_ui_interaction(other_obj)
	if(. > UI_CLOSE)
		return min(., user.physical_can_use_topic(other_obj))

/datum/overmap_object/shuttle/ui_state(mob/user)
	return new /datum/ui_state/physical_other_obj(control_console)

/datum/overmap_object/shuttle/ui_interact(mob/user, datum/tgui/ui, obj/src_object)
	. = ..()
	if(src_object)
		control_console = src_object
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ShuttleOvermapControls", name)
		ui.open()

/datum/overmap_object/shuttle/ui_data(mob/user)
	var/list/data = list(
		"can_use_engines" = !!(shuttle_capability & SHUTTLE_CAN_USE_ENGINES),
		"can_sense" = !!(shuttle_capability & SHUTTLE_CAN_USE_SENSORS),
		"can_target" = !!(shuttle_capability & SHUTTLE_CAN_USE_TARGET),
		"can_dock" = !!(shuttle_capability & SHUTTLE_CAN_USE_DOCK),
		"shield_status" = !length(shield_extensions) ? "Not installed" : IsShieldOn() ? "[GetShieldPercent()*100]%" : "Offline",
		"comms_status" = open_comms_channel,
		"mic_status" = !microphone_muted,
		"x" = x,
		"y" = y,
		"destination_x" = destination_x,
		"destination_y" = destination_y,
		"speed" = round(VECTOR_LENGTH(velocity_x, velocity_y), 0.1),
		"impulse_power" = impulse_power * 100,
		"top_speed" = GetCapSpeed(),
		"targets" = GetSensorTargets(lock?.target),
	)

	switch(helm_command)
		if(HELM_IDLE)
			data["helm_command"] = "Idle";
		if(HELM_FULL_STOP)
			data["helm_command"] = "Full stop";
		if(HELM_MOVE_TO_DESTINATION)
			data["helm_command"] = "Move to destination";
		if(HELM_TURN_TO_DESTINATION)
			data["helm_command"] = "Turn to destination";
		if(HELM_FOLLOW_SENSOR_LOCK)
			data["helm_command"] = "Follow sensor lock";
		if(HELM_TURN_TO_SENSOR_LOCK)
			data["helm_command"] = "Turn to sensor lock";
		else
			data["helm_command"] = "Unknown";

	if(engine_extensions.len == 0)
		data["engine_amount"] = 0
		data["engines"] = list()
	else
		var/iterator = 0
		var/engines = list()
		for(var/datum/shuttle_extension/engine/engine_ext as anything in engine_extensions)
			iterator++
			engines += list(list(
				"id" = iterator,
				"name" = engine_ext.name,
				"status" = !engine_ext.CanOperate() ? "Non-Functional" : engine_ext.turned_on ? "Online" : "Offline",
				"fuel_percent" = (engine_ext.current_fuel / engine_ext.maximum_fuel) * 100,
				"efficiency_percent" = engine_ext.current_efficiency * 100,
			))
		data["engine_amount"] = iterator
		data["engines"] = engines

	if(lock)
		var/command
		var/locked_status = "NOT ENGAGED"
		var/locked_and_calibrated = FALSE
		if(lock.is_calibrated)
			locked_and_calibrated = TRUE
			locked_status = "LOCKED"
		else
			locked_status = "CALIBRATING"

		switch(target_command)
			if(TARGET_IDLE)
				command = "Idle."
			if(TARGET_FIRE_ONCE)
				command = "Fire Once!"
			if(TARGET_KEEP_FIRING)
				command = "Keep Firing!"
			if(TARGET_SCAN)
				command = "Scan."
			if(TARGET_BEAM_ON_BOARD)
				command = "Beam on board."
			else
				command = "Unknown."

		data["lock"] = list(
			"name" = lock ? lock.target.name : "NONE",
			"status" = locked_status,
			"calibrated" = locked_and_calibrated,
			"command" = command,
		)

	if(!my_shuttle || is_seperate_z_level)
		data["docking"] = "INVALID"
		return data

	if(VECTOR_LENGTH(velocity_x, velocity_y) > SHUTTLE_MAXIMUM_DOCKING_SPEED)
		return data

	var/list/z_levels = list()
	var/list/nearby_objects = current_system.GetObjectsOnCoords(x,y)
	var/list/freeform_z_levels = list()
	for(var/datum/overmap_object/overmap_object as anything in nearby_objects)
		for(var/level in overmap_object.related_levels)
			var/datum/space_level/iterated_space_level = level
			z_levels["[iterated_space_level.z_value]"] = TRUE
			freeform_z_levels["[iterated_space_level.name]"] = iterated_space_level.z_value

	var/list/obj/docking_port/stationary/docks = list()
	var/list/options = params2list(my_shuttle.possible_destinations)
	for(var/obj/docking_port/stationary/iterated_dock in SSshuttle.stationary_docking_ports)
		if(!z_levels["[iterated_dock.z]"])
			continue
		if(!options.Find(iterated_dock.port_destinations))
			continue
		if(!my_shuttle.check_dock(iterated_dock, silent = TRUE))
			continue
		docks[iterated_dock.name] = iterated_dock.shuttle_id

	data["docking"] = list(
		"docks" = docks,
		"freeforms" = freeform_z_levels,
	)

	return data

/datum/overmap_object/shuttle/proc/DisplayHelmPad(mob/user)
	var/list/dat = list("<center>")
	dat += "<a href='?src=[REF(src)];pad_topic=nw'>O</a><a href='?src=[REF(src)];pad_topic=n'>O</a><a href='?src=[REF(src)];pad_topic=ne'>O</a>"
	dat += "<BR><a href='?src=[REF(src)];pad_topic=w'>O</a><a href='?src=[REF(src)];pad_topic=stop'>O</a><a href='?src=[REF(src)];pad_topic=e'>O</a>"
	dat += "<BR><a href='?src=[REF(src)];pad_topic=sw'>O</a><a href='?src=[REF(src)];pad_topic=s'>O</a><a href='?src=[REF(src)];pad_topic=se'>O</a></center>"
	dat += "<BR>Pad Range: <a href='?src=[REF(src)];pad_topic=range'>[helm_pad_range]</a>"
	dat += "<BR>Relative Destination: <a href='?src=[REF(src)];pad_topic=relative_dir'>[helm_pad_relative_destination ? "Yes" : "No"]</a>"
	dat += "<BR>Engage Immediately: <a href='?src=[REF(src)];pad_topic=engage_immediately'>[helm_pad_engage_immediately ? "Yes" : "No"]</a>"
	dat += "<BR>Pos.: X: [x] , Y: [y]"
	dat += " | Dest.: X: [destination_x] , Y: [destination_y]"
	dat += "<BR><center><a href='?src=[REF(src)];pad_topic=engage'>Engage</a></center>"
	var/datum/browser/popup = new(user, "overmap_helm_pad", "Helm Pad Control", 250, 250)
	popup.set_content(dat.Join())
	popup.open()

/datum/overmap_object/shuttle/proc/InputHelmPadDirection(input_x = 0, input_y = 0)
	if(!input_x && !input_y)
		StopMove()
		return
	if(helm_pad_relative_destination)
		destination_x = x
		destination_y = y
	if(input_x)
		destination_x += input_x * helm_pad_range
		destination_x = clamp(destination_x, 1, current_system.maxx)
	if(input_y)
		destination_y += input_y * helm_pad_range
		destination_y = clamp(destination_y, 1, current_system.maxy)
	if(helm_pad_engage_immediately)
		helm_command = HELM_MOVE_TO_DESTINATION
	return

/datum/overmap_object/shuttle/proc/LockLost()
	target_command = TARGET_IDLE

/datum/overmap_object/shuttle/proc/SetLockTo(datum/overmap_object/ov_obj)
	if(lock)
		if(ov_obj == lock.target)
			return
		else
			QDEL_NULL(lock)
	if(ov_obj && IN_LOCK_RANGE(src,ov_obj))
		lock = new(src, ov_obj)

/datum/overmap_object/shuttle/Topic(href, href_list)
	if(!control_console)
		return
	var/mob/user = usr
	if(!isliving(user) || !user.canUseTopic(control_console, BE_CLOSE, FALSE, NO_TK))
		return
	if(href_list["pad_topic"])
		if(!(shuttle_capability & SHUTTLE_CAN_USE_ENGINES))
			return
		switch(href_list["pad_topic"])
			if("nw")
				InputHelmPadDirection(-1, 1)
			if("n")
				InputHelmPadDirection(0, 1)
			if("ne")
				InputHelmPadDirection(1, 1)
			if("w")
				InputHelmPadDirection(-1, 0)
			if("e")
				InputHelmPadDirection(1, 0)
			if("sw")
				InputHelmPadDirection(-1, -1)
			if("s")
				InputHelmPadDirection(0, -1)
			if("se")
				InputHelmPadDirection(1, -1)
			if("stop")
				InputHelmPadDirection()
			if("engage")
				helm_command = HELM_MOVE_TO_DESTINATION
			if("range")
				var/new_range = input(usr, "Choose new pad range", "Helm Pad Control", helm_pad_range) as num|null
				if(new_range)
					helm_pad_range = new_range
			if("relative_dir")
				helm_pad_relative_destination = !helm_pad_relative_destination
			if("engage_immediately")
				helm_pad_engage_immediately = !helm_pad_engage_immediately
		DisplayHelmPad(usr)

/datum/overmap_object/shuttle/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	playsound(usr, SFX_PDA, 50, TRUE, ignore_walls = FALSE)
	..()
	. = TRUE

	switch(action)
		if("all_on")
			for(var/i in engine_extensions)
				var/datum/shuttle_extension/engine/ext = i
				ext.turned_on = TRUE
		if("all_off")
			for(var/i in engine_extensions)
				var/datum/shuttle_extension/engine/ext = i
				ext.turned_on = FALSE
		if("all_efficiency")
			var/new_eff = input(usr, "Choose new efficiency", "Engine Control") as num|null
			if(new_eff)
				var/new_value = clamp((new_eff/100),0,1)
				for(var/i in engine_extensions)
					var/datum/shuttle_extension/engine/ext = i
					ext.current_efficiency = new_value
		if("toggle_online")
			var/index = text2num(params["engine_index"])
			if(length(engine_extensions) < index)
				return
			var/datum/shuttle_extension/engine/ext = engine_extensions[index]
			ext.turned_on = !ext.turned_on
		if("set_efficiency")
			var/new_eff = input(usr, "Choose new efficiency", "Engine Control") as num|null
			if(new_eff)
				var/index = text2num(params["engine_index"])
				if(length(engine_extensions) < index)
					return
				var/datum/shuttle_extension/engine/ext = engine_extensions[index]
				ext.current_efficiency = clamp((new_eff/100),0,1)
		if("normal_dock")
			if(!(shuttle_capability & SHUTTLE_CAN_USE_DOCK))
				return
			if(VECTOR_LENGTH(velocity_x, velocity_y) > SHUTTLE_MAXIMUM_DOCKING_SPEED)
				return
			if(shuttle_controller.busy)
				return
			var/dock_id = params["dock_id"]
			var/obj/docking_port/stationary/target_dock = SSshuttle.getDock(dock_id)
			if(!target_dock)
				return
			var/datum/space_level/level_of_dock = SSmapping.z_list[target_dock.z]
			var/datum/overmap_object/dock_overmap_object = level_of_dock.related_overmap_object
			if(!dock_overmap_object)
				return
			if(!current_system.ObjectsAdjacent(src, dock_overmap_object))
				return
			switch(SSshuttle.moveShuttle(my_shuttle.shuttle_id, dock_id, 1))
				if(0)
					shuttle_controller.busy = TRUE
					shuttle_controller.RemoveCurrentControl()
					for(var/mob in shuttle_controller.mob_viewers)
						shuttle_controller.RemoveViewer(mob)
		if("freeform_dock")
			if(!(shuttle_capability & SHUTTLE_CAN_USE_DOCK))
				return
			if(VECTOR_LENGTH(velocity_x, velocity_y) > SHUTTLE_MAXIMUM_DOCKING_SPEED)
				return
			if(shuttle_controller.busy)
				return
			if(shuttle_controller.freeform_docker)
				return
			var/z_level = text2num(params["z_value"])
			if(!z_level)
				return
			var/datum/space_level/level_to_freeform = SSmapping.z_list[z_level]
			if(!level_to_freeform)
				return
			var/datum/overmap_object/level_overmap_object = level_to_freeform.related_overmap_object
			if(!level_overmap_object)
				return
			if(!current_system.ObjectsAdjacent(src, level_overmap_object))
				return
			shuttle_controller.SetController(usr)
			shuttle_controller.freeform_docker = new /datum/shuttle_freeform_docker(shuttle_controller, usr, z_level)

		if("disengage_lock")
			if(!(shuttle_capability & SHUTTLE_CAN_USE_TARGET))
				return
			if(!lock)
				return
			SetLockTo(null)
		if("command_idle")
			if(!(shuttle_capability & SHUTTLE_CAN_USE_TARGET))
				return
			if(!lock)
				return
			target_command = TARGET_IDLE
		if("command_fire_once")
			if(!(shuttle_capability & SHUTTLE_CAN_USE_TARGET))
				return
			if(!lock)
				return
			target_command = TARGET_FIRE_ONCE
		if("command_keep_firing")
			if(!(shuttle_capability & SHUTTLE_CAN_USE_TARGET))
				return
			if(!lock)
				return
			target_command = TARGET_KEEP_FIRING
		if("command_scan")
			if(!(shuttle_capability & SHUTTLE_CAN_USE_TARGET))
				return
			if(!lock)
				return
			target_command = TARGET_SCAN
		if("command_beam_on_board")
			if(!(shuttle_capability & SHUTTLE_CAN_USE_TARGET))
				return
			if(!lock)
				return
			target_command = TARGET_BEAM_ON_BOARD
			playsound(usr, 'sound/machines/wewewew.ogg', 70, TRUE)
		if("target")
			if(!(shuttle_capability & SHUTTLE_CAN_USE_SENSORS))
				return
			var/id = text2num(params["target_id"])
			if(!id)
				return
			var/datum/overmap_object/ov_obj = SSovermap.GetObjectByID(id)
			if(!ov_obj)
				return
			SetLockTo(ov_obj)
		if("destination")
			if(!(shuttle_capability & SHUTTLE_CAN_USE_SENSORS))
				return
			var/id = text2num(params["target_id"])
			if(!id)
				return
			var/datum/overmap_object/ov_obj = SSovermap.GetObjectByID(id)
			if(!ov_obj)
				return
			destination_x = ov_obj.x
			destination_y = ov_obj.y
		if("shields")
			var/shields_engaged = IsShieldOn()
			if(shields_engaged)
				TurnShieldsOff()
			else
				TurnShieldsOn()
		if("overmap")
			GrantOvermapView(usr)
		if("microphone_muted")
			microphone_muted = !microphone_muted
		if("comms")
			open_comms_channel = !open_comms_channel
			my_visual.update_appearance()
		if("hail")
			var/hail_msg = input(usr, "Compose a hail message:", "Hail Message")  as text|null
			if(hail_msg)
				hail_msg = sanitize_text(hail_msg, MAX_BROADCAST_LEN, TRUE)

	if(!(shuttle_capability & SHUTTLE_CAN_USE_ENGINES))
		return

	switch(action)
		if("pad")
			DisplayHelmPad(usr)
			return
		if("command_stop")
			helm_command = HELM_FULL_STOP
		if("command_move_dest")
			helm_command = HELM_MOVE_TO_DESTINATION
		if("command_turn_dest")
			helm_command = HELM_TURN_TO_DESTINATION
		if("command_follow_sensor")
			helm_command = HELM_FOLLOW_SENSOR_LOCK
		if("command_turn_sensor")
			helm_command = HELM_TURN_TO_SENSOR_LOCK
		if("command_idle")
			helm_command = HELM_IDLE
		if("change_x")
			var/new_x = input(usr, "Choose new X destination", "Helm Control", destination_x) as num|null
			if(new_x)
				destination_x = clamp(new_x, 1, current_system.maxx)
		if("change_y")
			var/new_y = input(usr, "Choose new Y destination", "Helm Control", destination_y) as num|null
			if(new_y)
				destination_y = clamp(new_y, 1, current_system.maxy)
		if("change_impulse_power")
			var/new_speed = input(usr, "Choose new impulse power (0% - 100%)", "Helm Control", (impulse_power*100)) as num|null
			if(new_speed)
				impulse_power = clamp((new_speed/100), 0, 1)

/datum/overmap_object/shuttle/New()
	. = ..()
	destination_x = x
	destination_y = y
	shuttle_controller = new(src)

/datum/overmap_object/shuttle/proc/RegisterToShuttle(obj/docking_port/mobile/register_shuttle)
	my_shuttle = register_shuttle
	my_shuttle.my_overmap_object = src
	for(var/i in my_shuttle.all_extensions)
		var/datum/shuttle_extension/extension = i
		extension.AddToOvermapObject(src)

	var/obj/docking_port/stationary/transit/my_transit = my_shuttle.assigned_transit
	transit_instance = my_transit.transit_instance
	transit_instance.overmap_shuttle = src

	update_perceived_parallax()

/datum/overmap_object/shuttle/Destroy()
	if(transit_instance)
		transit_instance.overmap_shuttle = null
		transit_instance = null
	control_console = null
	QDEL_NULL(shuttle_controller)
	if(my_shuttle)
		for(var/i in my_shuttle.all_extensions)
			var/datum/shuttle_extension/extension = i
			extension.RemoveFromOvermapObject()
		my_shuttle.my_overmap_object = null
		my_shuttle = null
	engine_extensions = null
	shield_extensions = null
	transporter_extensions = null
	weapon_extensions = null
	all_extensions = null
	return ..()

/datum/overmap_object/shuttle/UpdateVisualOffsets()
	. = ..()
	if(shuttle_controller)
		shuttle_controller.NewVisualOffset(FLOOR(partial_x,1),FLOOR(partial_y,1))

/datum/overmap_object/shuttle/proc/update_perceived_parallax()
	var/established_direction = FALSE
	if(velocity_y || velocity_x)
		var/absx = abs(velocity_x)
		var/absy = abs(velocity_y)
		if(absy > absx)
			if(velocity_y > 0)
				established_direction = NORTH
			else
				established_direction = SOUTH
		else
			if(velocity_x > 0)
				established_direction = EAST
			else
				established_direction = WEST

	var/changed = FALSE
	if(my_shuttle)
		current_parallax_dir = established_direction ? (my_shuttle.preferred_direction ? my_shuttle.preferred_direction : established_direction) : FALSE
		if(current_parallax_dir != my_shuttle.overmap_parallax_dir)
			my_shuttle.overmap_parallax_dir = current_parallax_dir
			changed = TRUE
			var/area/hyperspace_area = transit_instance.dock.assigned_area
			hyperspace_area.parallax_movedir = current_parallax_dir
	else if (is_seperate_z_level && length(related_levels))
		for(var/i in related_levels)
			var/datum/space_level/level = i
			current_parallax_dir = (established_direction && fixed_parallax_dir) ? fixed_parallax_dir : established_direction
			if(current_parallax_dir != level.parallax_direction_override)
				level.parallax_direction_override = current_parallax_dir
				changed = TRUE

	if(changed)
		for(var/i in GetAllClientMobs())
			var/mob/mob = i
			mob.hud_used.update_parallax()

/datum/overmap_object/shuttle/proc/GrantOvermapView(mob/user, turf/passed_turf)
	//Camera control
	if(!shuttle_controller || !user.client || shuttle_controller.busy)
		return

	if(shuttle_controller.mob_controller && !(user == shuttle_controller.mob_controller) && !shuttle_controller.mob_viewers.Find(user))
		shuttle_controller.AddViewer(user)
		return TRUE

	if(user.client && !shuttle_controller.busy && !shuttle_controller.mob_controller)
		shuttle_controller.SetController(user)
		if(passed_turf)
			shuttle_controller.control_turf = passed_turf
		return TRUE

/datum/overmap_object/shuttle/proc/CommandMove(dest_x, dest_y)
	destination_y = dest_y
	destination_x = dest_x
	helm_command = HELM_MOVE_TO_DESTINATION

/datum/overmap_object/shuttle/proc/StopMove()
	helm_command = HELM_FULL_STOP

/datum/overmap_object/shuttle/relaymove(mob/living/user, direction)
	return

/datum/overmap_object/shuttle/station
	name = "Space Station"
	visual_type = /obj/effect/abstract/overmap/shuttle/station
	is_seperate_z_level = TRUE
	uses_rotation = FALSE
	shuttle_capability = STATION_SHUTTLE_CAPABILITY
	speed_divisor_from_mass = 40
	clears_hazards_on_spawn = TRUE

/datum/overmap_object/shuttle/ship
	name = "Ship"
	visual_type = /obj/effect/abstract/overmap/shuttle/ship
	is_seperate_z_level = TRUE
	shuttle_capability = STATION_SHUTTLE_CAPABILITY
	speed_divisor_from_mass = 20
	clears_hazards_on_spawn = TRUE

/datum/overmap_object/shuttle/ship/bearcat
	name = "ALV Bearcat"
	fixed_parallax_dir = NORTH

/datum/overmap_object/shuttle/planet
	name = "Planet"
	visual_type = /obj/effect/abstract/overmap/shuttle/planet
	is_seperate_z_level = TRUE
	uses_rotation = FALSE
	shuttle_capability = PLANET_SHUTTLE_CAPABILITY
	speed_divisor_from_mass = 1000 //1000 times as harder as a shuttle to move
	clears_hazards_on_spawn = TRUE
	var/planet_color = COLOR_WHITE

/datum/overmap_object/shuttle/planet/New()
	. = ..()
	my_visual.color = planet_color
	if(SSmapping.config.min_planetary_traders_spawned || prob(SSmapping.config.planetary_trader_chance))
		if(SSmapping.config.min_planetary_traders_spawned)
			SSmapping.config.min_planetary_traders_spawned -= 1
		new /datum/overmap_object/trade_hub(SSovermap.main_system, x, y, pick(SSmapping.config.planetary_trading_hub_types), 10, 10)

/datum/overmap_object/shuttle/planet/lavaland
	name = "Lavaland"
	planet_color = LIGHT_COLOR_BLOOD_MAGIC

/datum/overmap_object/shuttle/planet/icebox
	name = "Ice Planet"
	planet_color = COLOR_TEAL

/datum/overmap_object/shuttle/ess_crow
	name = "ESS Crow"
	speed_divisor_from_mass = 4
