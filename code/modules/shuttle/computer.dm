#define SHUTTLE_CONSOLE_ACCESSDENIED "accessdenied"
#define SHUTTLE_CONSOLE_ENDGAME "endgame"
#define SHUTTLE_CONSOLE_RECHARGING "recharging"
#define SHUTTLE_CONSOLE_INTRANSIT "intransit"
#define SHUTTLE_CONSOLE_DESTINVALID "destinvalid"
#define SHUTTLE_CONSOLE_SUCCESS "success"
#define SHUTTLE_CONSOLE_ERROR "error"

/obj/machinery/computer/shuttle
	name = "shuttle console"
	desc = "A shuttle control computer."
	icon_screen = "shuttle"
	icon_keyboard = "tech_key"
	light_color = LIGHT_COLOR_CYAN
	req_access = list()
	interaction_flags_machine = INTERACT_MACHINE_ALLOW_SILICON|INTERACT_MACHINE_SET_MACHINE
	/// ID of the attached shuttle
	var/shuttleId
	/// Possible destinations of the attached shuttle
	var/possible_destinations = ""
	/// Variable dictating if the attached shuttle requires authorization from the admin staff to move
	var/admin_controlled = FALSE
	/// Variable dictating if the attached shuttle is forbidden to change destinations mid-flight
	var/no_destination_swap = FALSE
	/// ID of the currently selected destination of the attached shuttle
	var/destination
	/// If the console controls are locked
	var/locked = FALSE
	/// List of head revs who have already clicked through the warning about not using the console
	var/static/list/dumb_rev_heads = list()
	/// Authorization request cooldown to prevent request spam to admin staff
	COOLDOWN_DECLARE(request_cooldown)
	var/uses_overmap = TRUE

/obj/machinery/computer/shuttle/Initialize(mapload)
	. = ..()
	connect_to_shuttle(mapload, SSshuttle.get_containing_shuttle(src))

/obj/machinery/computer/shuttle/ui_interact(mob/user, datum/tgui/ui)
	. = ..()
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, uses_overmap ? "ShuttleConsoleOvermap" : "ShuttleConsole", name)
		ui.open()

/obj/machinery/computer/shuttle/ui_data(mob/user)
	var/list/data = list()
	var/obj/docking_port/mobile/mobile_docking_port = SSshuttle.getShuttle(shuttleId)

	if(!uses_overmap)
		data["docked_location"] = mobile_docking_port ? mobile_docking_port.get_status_text_tgui() : "Unknown"
		data["locations"] = list()
		data["destination"] = destination

	data["locked"] = locked
	data["authorization_required"] = admin_controlled
	data["timer_str"] = mobile_docking_port ? mobile_docking_port.getTimerStr() : "00:00"

	if(!mobile_docking_port)
		data["status"] = "Missing"
		return data

	if(admin_controlled)
		data["status"] = "Unauthorized Access"
	else if(locked)
		data["status"] = "Locked"
	else
		switch(mobile_docking_port.mode)
			if(SHUTTLE_IGNITING)
				data["status"] = "Igniting"
			if(SHUTTLE_IDLE)
				data["status"] = "Idle"
			if(SHUTTLE_RECHARGING)
				data["status"] = "Recharging"
			else
				data["status"] = "In Transit"

	if(!uses_overmap)
		data["locations"] = get_valid_destinations()
		if(length(data["locations"]) == 1)
			for(var/location in data["locations"])
				destination = location["id"]
				data["destination"] = destination
		if(!length(data["locations"]))
			data["locked"] = TRUE
			data["status"] = "Locked"

	return data

/**
 * Checks if we are allowed to launch the shuttle
 *
 * Arguments:
 * * user - The mob trying to initiate the launch
 */
/obj/machinery/computer/shuttle/proc/launch_check(mob/user)
	if(!allowed(user)) //Normally this is already checked via interaction code but some cases may skip that so check it explicitly here (illiterates launching randomly)
		return FALSE
	return TRUE

/**
 * Returns a list of currently valid destinations for this shuttle console,
 * taking into account its list of allowed destinations, their current state, and the shuttle's current location
**/
/obj/machinery/computer/shuttle/proc/get_valid_destinations()
	var/list/destination_list = params2list(possible_destinations)
	var/obj/docking_port/mobile/mobile_docking_port = SSshuttle.getShuttle(shuttleId)
	var/list/valid_destinations = list()
	for(var/obj/docking_port/stationary/stationary_docking_port in SSshuttle.stationary_docking_ports)
		if(!destination_list.Find(stationary_docking_port.port_destinations))
			continue
		if(!mobile_docking_port.check_dock(stationary_docking_port, silent = TRUE))
			continue
		var/list/location_data = list(
			id = stationary_docking_port.shuttle_id,
			name = stationary_docking_port.name
		)
		valid_destinations += list(location_data)
	return valid_destinations

/**
 * Attempts to send the linked shuttle to dest_id, checking various sanity checks to see if it can move or not
 *
 * Arguments:
 * * dest_id - The ID of the stationary docking port to send the shuttle to
 * * user - The mob that used the console
 */
/obj/machinery/computer/shuttle/proc/send_shuttle(dest_id, mob/user)
	if(!launch_check(user))
		return SHUTTLE_CONSOLE_ACCESSDENIED
	var/obj/docking_port/mobile/shuttle_port = SSshuttle.getShuttle(shuttleId)
	if(shuttle_port.launch_status == ENDGAME_LAUNCHED)
		return SHUTTLE_CONSOLE_ENDGAME
	if(no_destination_swap)
		if(shuttle_port.mode == SHUTTLE_RECHARGING)
			return SHUTTLE_CONSOLE_RECHARGING
		if(shuttle_port.mode != SHUTTLE_IDLE)
			return SHUTTLE_CONSOLE_INTRANSIT
	//check to see if the dest_id passed from tgui is actually a valid destination
	var/list/dest_list = get_valid_destinations()
	var/validdest = FALSE
	for(var/list/dest_data in dest_list)
		if(dest_data["id"] == dest_id)
			validdest = TRUE //Found our destination, we can skip ahead now
			break
	if(!validdest) //Didn't find our destination in the list of valid destinations, something bad happening
		log_admin("[user] attempted to href dock exploit on [src] with target location \"[dest_id]\"")
		message_admins("[user] just attempted to href dock exploit on [src] with target location \"[dest_id]\"")
		return SHUTTLE_CONSOLE_DESTINVALID
	switch(SSshuttle.moveShuttle(shuttleId, dest_id, TRUE))
		if(DOCKING_SUCCESS)
			say("Shuttle departing. Please stand away from the doors.")
			log_shuttle("[key_name(user)] has sent shuttle \"[shuttleId]\" towards \"[dest_id]\", using [src].")
			return SHUTTLE_CONSOLE_SUCCESS
		else
			return SHUTTLE_CONSOLE_ERROR

/obj/machinery/computer/shuttle/ui_act(action, params)
	. = ..()
	if(.)
		return
	if(!allowed(usr))
		to_chat(usr, span_danger("Access denied."))
		return

	var/obj/docking_port/mobile/docking_port = SSshuttle.getShuttle(shuttleId)

	switch(action)
		if("move")
			switch (send_shuttle(params["shuttle_id"], usr)) //Try to send the shuttle, tell the user what happened
				if (SHUTTLE_CONSOLE_ACCESSDENIED)
					to_chat(usr, span_warning("Access denied."))
					return
				if (SHUTTLE_CONSOLE_ENDGAME)
					to_chat(usr, span_warning("You've already escaped. Never going back to that place again!"))
					return
				if (SHUTTLE_CONSOLE_RECHARGING)
					to_chat(usr, span_warning("Shuttle engines are not ready for use."))
					return
				if (SHUTTLE_CONSOLE_INTRANSIT)
					to_chat(usr, span_warning("Shuttle already in transit."))
					return
				if (SHUTTLE_CONSOLE_DESTINVALID)
					to_chat(usr, span_warning("Invalid destination."))
					return
				if (SHUTTLE_CONSOLE_ERROR)
					to_chat(usr, span_warning("Unable to comply."))
					return
				if (SHUTTLE_CONSOLE_SUCCESS)
					return TRUE //No chat message here because the send_shuttle proc makes the console itself speak
		if("set_destination")
			var/target_destination = params["destination"]
			if(target_destination)
				destination = target_destination
				return TRUE
		if("request")
			if(!COOLDOWN_FINISHED(src, request_cooldown))
				to_chat(usr, span_warning("CentCom is still processing last authorization request!"))
				return
			COOLDOWN_START(src, request_cooldown, 1 MINUTES)
			to_chat(usr, span_notice("Your request has been received by CentCom."))
			to_chat(GLOB.admins, "<b>SHUTTLE: <font color='#3d5bc3'>[ADMIN_LOOKUPFLW(usr)] (<A HREF='?_src_=holder;[HrefToken()];move_shuttle=[shuttleId]'>Move Shuttle</a>)(<A HREF='?_src_=holder;[HrefToken()];unlock_shuttle=[REF(src)]'>Lock/Unlock Shuttle</a>)</b> is requesting to move or unlock the shuttle.</font>")
			return TRUE
		// OVERMAP SHUTTLE CODE!
		if("engines_off")
			docking_port.TurnEnginesOff()
			say("Engines offline.")
		if("engines_on")
			docking_port.TurnEnginesOn()
			say("Engines online.")
		if("overmap_view")
			if(docking_port.my_overmap_object)
				docking_port.my_overmap_object.GrantOvermapView(usr, get_turf(src))
		if("overmap_ship_controls")
			if(docking_port.my_overmap_object)
				docking_port.my_overmap_object.ui_interact(usr, null, src)
		if("overmap_launch")
			if(!launch_check(usr))
				return
			if(docking_port.launch_status == ENDGAME_LAUNCHED)
				to_chat(usr, "<span class='warning'>You've already escaped. Never going back to that place again!</span>")
				return
			if(no_destination_swap)
				if(docking_port.mode == SHUTTLE_RECHARGING)
					to_chat(usr, "<span class='warning'>Shuttle engines are not ready for use.</span>")
					return
				if(docking_port.mode != SHUTTLE_IDLE)
					to_chat(usr, "<span class='warning'>Shuttle already in transit.</span>")
					return
			if(uses_overmap)
				if(docking_port.DrawDockingThrust())
					docking_port.possible_destinations = possible_destinations
					docking_port.destination = "overmap"
					docking_port.mode = SHUTTLE_IGNITING
					docking_port.setTimer(5 SECONDS)
					say("Shuttle departing. Please stand away from the doors.")
					log_shuttle("[key_name(usr)] has sent shuttle \"[docking_port]\" into the overmap.")
					ui_interact(usr)
				else
					say("Engine power insufficient to take off.")

/obj/machinery/computer/shuttle/emag_act(mob/user)
	if(obj_flags & EMAGGED)
		return
	req_access = list()
	obj_flags |= EMAGGED
	to_chat(user, span_notice("You fried the console's ID checking system."))

/obj/machinery/computer/shuttle/connect_to_shuttle(mapload, obj/docking_port/mobile/port, obj/docking_port/stationary/dock)
	if(!mapload)
		return
	if(!port)
		return
	//Remove old custom port id and ";;"
	var/find_old = findtextEx(possible_destinations, "[shuttleId]_custom")
	if(find_old)
		possible_destinations = replacetext(replacetextEx(possible_destinations, "[shuttleId]_custom", ""), ";;", ";")
	shuttleId = port.shuttle_id
	possible_destinations += ";[port.shuttle_id]_custom"

#undef SHUTTLE_CONSOLE_ACCESSDENIED
#undef  SHUTTLE_CONSOLE_ENDGAME
#undef  SHUTTLE_CONSOLE_RECHARGING
#undef  SHUTTLE_CONSOLE_INTRANSIT
#undef  SHUTTLE_CONSOLE_DESTINVALID
#undef  SHUTTLE_CONSOLE_SUCCESS
#undef  SHUTTLE_CONSOLE_ERROR
