/obj/machinery/airlock_controller/multitool_act(mob/living/user, obj/item/tool)
	if(multitool_check_buffer(user, tool))
		var/obj/item/multitool/multitool = tool
		multitool.buffer = src
		to_chat(user, span_info("Copied data to buffer."))
		return TRUE

/obj/machinery/atmospherics/components/unary/airlock_vent/multitool_act_secondary(mob/living/user, obj/item/tool)
	if(!multitool_check_buffer(user, tool))
		return TRUE
	var/obj/item/multitool/multitool = tool
	if(!istype(multitool.buffer, /obj/machinery/airlock_controller))
		to_chat(user, span_warning("There is no airlock controller on the multitool's buffer."))
		return TRUE

	var/obj/machinery/airlock_controller/controller = multitool.buffer

	id_tag = controller.airpump_tag
	to_chat(user, span_info("Airlock vent linked."))
	return TRUE

/obj/machinery/airlock_sensor/multitool_act_secondary(mob/living/user, obj/item/tool)
	var/static/list/options = list(
		"Interior",
		"Exterior",
		"Chamber",
	)

	if(!multitool_check_buffer(user, tool))
		return TRUE
	var/obj/item/multitool/multitool = tool
	if(!istype(multitool.buffer, /obj/machinery/airlock_controller))
		to_chat(user, span_warning("There is no airlock controller on the multitool's buffer."))
		return TRUE

	var/obj/machinery/airlock_controller/controller = multitool.buffer

	var/choice = tgui_input_list(user, "What part of the airlock is this sensor part of?", "Pick", options)

	if(!choice)
		return TRUE

	switch(choice)
		if("Interior")
			id_tag = controller.interior_sensor_tag
		if("Exterior")
			id_tag = controller.exterior_sensor_tag
		if("Chamber")
			id_tag = controller.sensor_tag

	set_frequency(controller.radio_connection.frequency)

	to_chat(user, span_info("[choice] airlock sensor linked."))
	return TRUE

/obj/machinery/door/airlock/multitool_act_secondary(mob/living/user, obj/item/tool)
	var/static/list/options = list(
		"Interior (facing the station)" = "Interior",
		"Exterior (facing out of the station)" = "Exterior",
	)

	if(!issilicon(user) && !isAdminGhostAI(user))
		if(isElectrified() && shock(user, 75))
			return TRUE
	add_fingerprint(user)

	if(!panel_open)
		to_chat(user, span_warning("The panel needs to be open first!"))
	if(!attempt_wire_interaction(user))
		return TRUE

	if(!multitool_check_buffer(user, tool))
		return TRUE
	var/obj/item/multitool/multitool = tool
	if(!istype(multitool.buffer, /obj/machinery/airlock_controller))
		to_chat(user, span_warning("There is no airlock controller on the multitool's buffer."))
		return TRUE

	var/obj/machinery/airlock_controller/controller = multitool.buffer

	var/choice = tgui_input_list(user, "What part of the airlock is this sensor part of?", "Pick", options)

	if(!choice)
		return TRUE

	switch(choice)
		if("Interior")
			id_tag = controller.interior_door_tag
		if("Exterior")
			id_tag = controller.exterior_door_tag

	set_frequency(controller.radio_connection.frequency)

	to_chat(user, span_info("[choice] airlock sensor linked."))
	return TRUE
