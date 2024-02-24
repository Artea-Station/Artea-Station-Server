// There's so much fucking copypaste in here

/obj/item/wallframe/airlock_controller
	name = "airlock controller assembly"
	desc = "Makes airlocks go whoosh. Place on a wall."
	icon = 'icons/obj/airlock_machines.dmi'
	icon_state = "airlock_control_open"
	pixel_shift = 24
	result_path = /obj/machinery/airlock_controller

/obj/machinery/airlock_controller/attackby(obj/item/weapon, mob/user, params)
	. = ..()
	if(.)
		return

	var/did_something = FALSE

	switch(weapon.tool_behaviour)
		if(TOOL_WRENCH)
			if(construction_state == AIRLOCK_CONSTRUCTION_STATE_PLACED && do_after(user, 5 SECONDS, src))
				construction_state = AIRLOCK_CONSTRUCTION_STATE_WRENCHED
				did_something = TRUE
			else if(construction_state == AIRLOCK_CONSTRUCTION_STATE_UNWELDED && do_after(user, 5 SECONDS, src))
				construction_state = AIRLOCK_CONSTRUCTION_STATE_UNWRENCHED
				did_something = TRUE
		if(TOOL_SCREWDRIVER)
			if(construction_state == AIRLOCK_CONSTRUCTION_STATE_WIRED)
				construction_state = AIRLOCK_CONSTRUCTION_STATE_BUILT
				did_something = TRUE
			else if(construction_state == AIRLOCK_CONSTRUCTION_STATE_BUILT && do_after(user, 2 SECONDS, src))
				construction_state = AIRLOCK_CONSTRUCTION_STATE_UNSCREWED
				did_something = TRUE
			else if(construction_state == AIRLOCK_CONSTRUCTION_STATE_UNSCREWED)
				construction_state = AIRLOCK_CONSTRUCTION_STATE_BUILT
				did_something = TRUE
		if(TOOL_WIRECUTTER)
			if(construction_state == AIRLOCK_CONSTRUCTION_STATE_UNSCREWED && do_after(user, 2 SECONDS, src))
				construction_state = AIRLOCK_CONSTRUCTION_STATE_WIRECUT
				did_something = TRUE
		if(TOOL_WELDER)
			if(construction_state == AIRLOCK_CONSTRUCTION_STATE_WIRECUT && do_after(user, 5 SECONDS, src))
				construction_state = AIRLOCK_CONSTRUCTION_STATE_UNWELDED
				did_something = TRUE
		if(TOOL_CROWBAR)
			if(construction_state == AIRLOCK_CONSTRUCTION_STATE_UNWRENCHED)
				new /obj/item/wallframe/airlock_controller(get_turf(src))
				qdel(src)
				did_something = TRUE

	if(istype(weapon, /obj/item/stack/cable_coil))
		var/obj/item/stack/cable_coil/cable = weapon
		if(cable.use(5))
			cable.play_tool_sound()
			construction_state = AIRLOCK_CONSTRUCTION_STATE_WIRED
			did_something = TRUE

	if(did_something)
		weapon.play_tool_sound(src)
		update_appearance()

	return did_something

/obj/item/wallframe/airlock_sensor
	name = "airlock sensor assembly"
	desc = "Makes airlocks pressure aware. Place on a wall. One is required inside the airlock chamber."
	icon = 'icons/obj/airlock_machines.dmi'
	icon_state = "airlock_sensor_open"
	pixel_shift = 24
	result_path = /obj/machinery/airlock_sensor

/obj/machinery/airlock_sensor/attackby(obj/item/weapon, mob/user, params)
	. = ..()
	if(.)
		return

	var/did_something = FALSE

	switch(weapon.tool_behaviour)
		if(TOOL_WRENCH)
			if(construction_state == AIRLOCK_CONSTRUCTION_STATE_PLACED && do_after(user, 5 SECONDS, src))
				construction_state = AIRLOCK_CONSTRUCTION_STATE_WRENCHED
				did_something = TRUE
			else if(construction_state == AIRLOCK_CONSTRUCTION_STATE_UNWELDED && do_after(user, 5 SECONDS, src))
				construction_state = AIRLOCK_CONSTRUCTION_STATE_UNWRENCHED
				did_something = TRUE
		if(TOOL_SCREWDRIVER)
			if(construction_state == AIRLOCK_CONSTRUCTION_STATE_WIRED)
				construction_state = AIRLOCK_CONSTRUCTION_STATE_BUILT
				did_something = TRUE
			else if(construction_state == AIRLOCK_CONSTRUCTION_STATE_BUILT && do_after(user, 2 SECONDS, src))
				construction_state = AIRLOCK_CONSTRUCTION_STATE_UNSCREWED
				did_something = TRUE
			else if(construction_state == AIRLOCK_CONSTRUCTION_STATE_UNSCREWED)
				construction_state = AIRLOCK_CONSTRUCTION_STATE_BUILT
				did_something = TRUE
		if(TOOL_WIRECUTTER)
			if(construction_state == AIRLOCK_CONSTRUCTION_STATE_UNSCREWED && do_after(user, 2 SECONDS, src))
				construction_state = AIRLOCK_CONSTRUCTION_STATE_WIRECUT
				did_something = TRUE
		if(TOOL_WELDER)
			if(construction_state == AIRLOCK_CONSTRUCTION_STATE_WIRECUT && do_after(user, 5 SECONDS, src))
				construction_state = AIRLOCK_CONSTRUCTION_STATE_UNWELDED
				did_something = TRUE
		if(TOOL_CROWBAR)
			if(construction_state == AIRLOCK_CONSTRUCTION_STATE_UNWRENCHED)
				new /obj/item/wallframe/airlock_controller(get_turf(src))
				qdel(src)
				did_something = TRUE

	if(istype(weapon, /obj/item/stack/cable_coil))
		var/obj/item/stack/cable_coil/cable = weapon
		if(cable.use(5))
			cable.play_tool_sound()
			construction_state = AIRLOCK_CONSTRUCTION_STATE_WIRED
			did_something = TRUE

	if(.)
		weapon.play_tool_sound(src)
		update_appearance()

	return did_something
