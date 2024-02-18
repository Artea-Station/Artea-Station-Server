// There's so much fucking copypaste in here

#define CONSTRUCTION_STATE_PLACED 3 // Default
#define CONSTRUCTION_STATE_WRENCHED 2
#define CONSTRUCTION_STATE_WIRED 1
#define CONSTRUCTION_STATE_BUILT 0
#define CONSTRUCTION_STATE_UNSCREWED -1
#define CONSTRUCTION_STATE_WIRECUT -2
#define CONSTRUCTION_STATE_UNWELDED -3
#define CONSTRUCTION_STATE_UNWRENCHED -4

/obj/item/wallframe/airlock_controller
	name = "airlock controller assembly"
	desc = "Makes airlocks go whoosh. Place on a wall."
	icon = 'icons/obj/airlock_machines.dmi'
	icon_state = "airlock_control_open"
	pixel_shift = 24
	result_path = /obj/machinery/airlock_controller

/obj/machinery/airlock_controller
	// I'm only making these hard to remove.
	var/construction_state = CONSTRUCTION_STATE_PLACED

/obj/machinery/airlock_controller/attackby(obj/item/weapon, mob/user, params)
	. = ..()
	if(.)
		return

	var/did_something = FALSE

	switch(weapon.tool_behaviour)
		if(TOOL_WRENCH)
			if(construction_state == CONSTRUCTION_STATE_PLACED && do_after(user, 5 SECONDS, src))
				construction_state = CONSTRUCTION_STATE_WRENCHED
				did_something = TRUE
			else if(construction_state == CONSTRUCTION_STATE_UNWELDED && do_after(user, 5 SECONDS, src))
				construction_state = CONSTRUCTION_STATE_UNWRENCHED
				did_something = TRUE
		if(TOOL_SCREWDRIVER)
			if(construction_state == CONSTRUCTION_STATE_WIRED)
				construction_state = CONSTRUCTION_STATE_BUILT
				did_something = TRUE
			else if(construction_state == CONSTRUCTION_STATE_BUILT && do_after(user, 2 SECONDS, src))
				construction_state = CONSTRUCTION_STATE_UNSCREWED
				did_something = TRUE
			else if(construction_state == CONSTRUCTION_STATE_UNSCREWED)
				construction_state = CONSTRUCTION_STATE_BUILT
				did_something = TRUE
		if(TOOL_WIRECUTTER)
			if(construction_state == CONSTRUCTION_STATE_UNSCREWED && do_after(user, 2 SECONDS, src))
				construction_state = CONSTRUCTION_STATE_WIRECUT
				did_something = TRUE
		if(TOOL_WELDER)
			if(construction_state == CONSTRUCTION_STATE_WIRECUT && do_after(user, 5 SECONDS, src))
				construction_state = CONSTRUCTION_STATE_UNWELDED
				did_something = TRUE
		if(TOOL_CROWBAR)
			if(construction_state == CONSTRUCTION_STATE_UNWRENCHED)
				new /obj/item/wallframe/airlock_controller(get_turf(src))
				qdel(src)
				did_something = TRUE

	if(istype(weapon, /obj/item/stack/cable_coil))
		var/obj/item/stack/cable_coil/cable = weapon
		if(cable.use(5))
			cable.play_tool_sound()
			construction_state = CONSTRUCTION_STATE_WIRED
			did_something = TRUE

	if(.)
		weapon.play_tool_sound(src)
		update_appearance()
	return FALSE

/obj/item/wallframe/airlock_sensor
	name = "airlock sensor assembly"
	desc = "Makes airlocks pressure aware. Place on a wall. One is required inside the airlock chamber."
	icon = 'icons/obj/airlock_machines.dmi'
	icon_state = "airlock_sensor_open"
	pixel_shift = 24
	result_path = /obj/machinery/airlock_sensor

/obj/machinery/airlock_sensor
	// I'm only making these hard to remove.
	var/construction_state = CONSTRUCTION_STATE_PLACED

/obj/machinery/airlock_sensor/attackby(obj/item/weapon, mob/user, params)
	. = ..()
	if(.)
		return

	var/did_something = FALSE

	switch(weapon.tool_behaviour)
		if(TOOL_WRENCH)
			if(construction_state == CONSTRUCTION_STATE_PLACED && do_after(user, 5 SECONDS, src))
				construction_state = CONSTRUCTION_STATE_WRENCHED
				did_something = TRUE
			else if(construction_state == CONSTRUCTION_STATE_UNWELDED && do_after(user, 5 SECONDS, src))
				construction_state = CONSTRUCTION_STATE_UNWRENCHED
				did_something = TRUE
		if(TOOL_SCREWDRIVER)
			if(construction_state == CONSTRUCTION_STATE_WIRED)
				construction_state = CONSTRUCTION_STATE_BUILT
				did_something = TRUE
			else if(construction_state == CONSTRUCTION_STATE_BUILT && do_after(user, 2 SECONDS, src))
				construction_state = CONSTRUCTION_STATE_UNSCREWED
				did_something = TRUE
			else if(construction_state == CONSTRUCTION_STATE_UNSCREWED)
				construction_state = CONSTRUCTION_STATE_BUILT
				did_something = TRUE
		if(TOOL_WIRECUTTER)
			if(construction_state == CONSTRUCTION_STATE_UNSCREWED && do_after(user, 2 SECONDS, src))
				construction_state = CONSTRUCTION_STATE_WIRECUT
				did_something = TRUE
		if(TOOL_WELDER)
			if(construction_state == CONSTRUCTION_STATE_WIRECUT && do_after(user, 5 SECONDS, src))
				construction_state = CONSTRUCTION_STATE_UNWELDED
				did_something = TRUE
		if(TOOL_CROWBAR)
			if(construction_state == CONSTRUCTION_STATE_UNWRENCHED)
				new /obj/item/wallframe/airlock_controller(get_turf(src))
				qdel(src)
				did_something = TRUE

	if(istype(weapon, /obj/item/stack/cable_coil))
		var/obj/item/stack/cable_coil/cable = weapon
		if(cable.use(5))
			cable.play_tool_sound()
			construction_state = CONSTRUCTION_STATE_WIRED
			did_something = TRUE

	if(.)
		weapon.play_tool_sound(src)
		update_appearance()
	return FALSE

#undef CONSTRUCTION_STATE_PLACED
#undef CONSTRUCTION_STATE_WRENCHED
#undef CONSTRUCTION_STATE_WIRED
#undef CONSTRUCTION_STATE_BUILT
#undef CONSTRUCTION_STATE_UNSCREWED
#undef CONSTRUCTION_STATE_WIRECUT
#undef CONSTRUCTION_STATE_UNWELDED
#undef CONSTRUCTION_STATE_UNWRENCHED
