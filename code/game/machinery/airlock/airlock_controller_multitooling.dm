/obj/machinery/airlock_controller/multitool_act(mob/living/user, obj/item/tool)
	if(construction_state != -1)
		to_chat(user, span_warning("Opan the panel first!"))
		return

	if(multitool_check_buffer(user, tool))
		var/obj/item/multitool/multitool = tool
		multitool.buffer = src
		to_chat(user, span_info("Copied data to buffer."))
		return

	return TRUE

/obj/machinery/atmospherics/components/unary/airlock_vent/multitool_act_secondary(mob/living/user, obj/item/tool)
	if(!multitool_check_buffer(user, tool))
		return
	var/obj/item/multitool/multitool = tool
	if(!istype(multitool.buffer, /obj/machinery/airlock_controller))
		to_chat(user, span_warning("There is no airlock controller on the multitool's buffer."))
		return

	var/obj/machinery/airlock_controller/controller = multitool.buffer

	id_tag = controller.airpump_tag
	to_chat(user, span_info("Airlock vent linked."))

/obj/machinery/airlock_sensor/multitool_act_secondary(mob/living/user, obj/item/tool)
	var/static/list/options = list(
		"Interior",
		"Exterior",
		"Chamber",
	)

	if(!multitool_check_buffer(user, tool))
		return
	var/obj/item/multitool/multitool = tool
	if(!istype(multitool.buffer, /obj/machinery/airlock_controller))
		to_chat(user, span_warning("There is no airlock controller on the multitool's buffer."))
		return

	var/obj/machinery/airlock_controller/controller = multitool.buffer

	var/choice = tgui_input_list(user, "What part of the airlock is this sensor part of?", "Pick", options)

	if(!choice)
		return

	switch(choice)
		if("Interior")
			id_tag = controller.interior_sensor_tag
		if("Exterior")
			id_tag = controller.exterior_sensor_tag
		if("Chamber")
			id_tag = controller.sensor_tag

	set_frequency(controller.radio_connection.frequency)

	to_chat(user, span_info("[choice] airlock sensor linked."))

/obj/machinery/door/bulkhead/multitool_act_secondary(mob/living/user, obj/item/tool)
	var/static/list/options = list(
		"Interior (facing the station)" = "Interior",
		"Exterior (facing out of the station)" = "Exterior",
	)

	if(!issilicon(user) && !isAdminGhostAI(user))
		if(isElectrified() && shock(user, 75))
			return
	add_fingerprint(user)

	if(!panel_open)
		to_chat(user, span_warning("The panel needs to be open first!"))
		return
	if(!attempt_wire_interaction(user))
		return

	if(length(req_access) || length(req_one_access))
		to_chat(user, span_warning("Cannot add airlock links to access required doors!"))
		return

	if(!multitool_check_buffer(user, tool))
		return
	var/obj/item/multitool/multitool = tool
	if(!istype(multitool.buffer, /obj/machinery/airlock_controller))
		to_chat(user, span_warning("There is no airlock controller on the multitool's buffer."))
		return

	var/obj/machinery/airlock_controller/controller = multitool.buffer

	var/choice = tgui_input_list(user, "What part of the airlock is this sensor part of?", "Pick", options)

	if(!choice)
		return

	switch(choice)
		if("Interior")
			id_tag = controller.interior_door_tag
		if("Exterior")
			id_tag = controller.exterior_door_tag

	set_frequency(controller.radio_connection.frequency)

	to_chat(user, span_info("[choice] airlock sensor linked."))
