/obj/machinery/atmospherics/components/trinary/filter
	icon_state = "filter_off-0"
	density = FALSE

	name = "gas filter"
	desc = "Very useful for filtering gasses."

	can_unwrench = TRUE
	construction_type = /obj/item/pipe/trinary/flippable
	pipe_state = "filter"

	///Rate of transfer of the gases to the outputs
	var/transfer_rate = MAX_TRANSFER_RATE
	///What gases are we filtering, by typepath
	var/list/filter_type = list()
	///Frequency id for connecting to the NTNet
	var/frequency = 0
	///Reference to the radio datum
	var/datum/radio_frequency/radio_connection

/obj/machinery/atmospherics/components/trinary/filter/CtrlClick(mob/user)
	if(can_interact(user))
		on = !on
		investigate_log("was turned [on ? "on" : "off"] by [key_name(user)]", INVESTIGATE_ATMOS)
		update_appearance()
	return ..()

/obj/machinery/atmospherics/components/trinary/filter/AltClick(mob/user)
	if(can_interact(user))
		transfer_rate = MAX_TRANSFER_RATE
		investigate_log("was set to [transfer_rate] L/s by [key_name(user)]", INVESTIGATE_ATMOS)
		balloon_alert(user, "volume output set to [transfer_rate] L/s")
		update_appearance()
	return ..()

/obj/machinery/atmospherics/components/trinary/filter/proc/set_frequency(new_frequency)
	SSradio.remove_object(src, frequency)
	frequency = new_frequency
	if(frequency)
		radio_connection = SSradio.add_object(src, frequency, RADIO_ATMOSIA)

/obj/machinery/atmospherics/components/trinary/filter/Destroy()
	SSradio.remove_object(src,frequency)
	return ..()

/obj/machinery/atmospherics/components/trinary/filter/update_overlays()
	. = ..()
	for(var/direction in GLOB.cardinals)
		if(!(direction & initialize_directions))
			continue

		. += get_pipe_image(icon, "cap", direction, pipe_color, piping_layer, TRUE)

/obj/machinery/atmospherics/components/trinary/filter/update_icon_nopipes()
	var/on_state = on && nodes[1] && nodes[2] && nodes[3] && is_operational
	icon_state = "filter_[on_state ? "on" : "off"]-[set_overlay_offset(piping_layer)][flipped ? "_f" : ""]"

/obj/machinery/atmospherics/components/trinary/filter/process_atmos()
	..()
	if(!on || !(nodes[1] && nodes[2] && nodes[3]) || !is_operational)
		return

	//Early return
	var/datum/gas_mixture/air1 = airs[1]
	if(!air1 || air1.temperature <= 0)
		return

	var/datum/gas_mixture/air2 = airs[2]
	var/datum/gas_mixture/air3 = airs[3]

	var/transfer_ratio = transfer_rate / air1.volume

	if(transfer_ratio <= 0)
		return

	// Attempt to transfer the gas.

	// If the main output is full, we try to send filtered output to the side port (air2).
	// If the side output is full, we try to send the non-filtered gases to the main output port (air3).
	// Any gas that can't be moved due to its destination being too full is sent back to the input (air1).

	var/side_output_full = air2.returnPressure() >= MAX_OUTPUT_PRESSURE
	var/main_output_full = air3.returnPressure() >= MAX_OUTPUT_PRESSURE

	// If both output ports are full, there's nothing we can do. Don't bother removing anything from the input.
	if (side_output_full && main_output_full)
		return

	var/datum/gas_mixture/removed = air1.removeRatio(transfer_ratio)

	if(!removed || !removed.get_moles())
		return

	var/filtering = TRUE
	if(!filter_type.len)
		filtering = FALSE

	// Process if we have a filter set.
	// If no filter is set, we just try to forward everything to air3 to avoid gas being outright lost.
	if(filtering)
		var/datum/gas_mixture/filtered_out = new
		var/datum/gas_mixture/merge_to
		// Send things to the side output if we can, return them to the input if we can't.
		// This means that other gases continue to flow to the main output if the side output is blocked.
		if (side_output_full)
			merge_to = air1
		else
			merge_to = air2
		filter_gas(filter_type, removed, filtered_out, removed)
		// Send things to the side output if we can, return them to the input if we can't.
		// This means that other gases continue to flow to the main output if the side output is blocked.
		merge_to.merge(filtered_out)
		// Make sure we don't send any now-empty gas entries to the main output

	// Send things to the main output if we can, return them to the input if we can't.
	// This lets filtered gases continue to flow to the side output in a manner consistent with the main output behavior.
	if (main_output_full)
		air1.merge(removed)
	else
		air3.merge(removed)

	update_parents()

/obj/machinery/atmospherics/components/trinary/filter/atmos_init()
	set_frequency(frequency)
	return ..()

/obj/machinery/atmospherics/components/trinary/filter/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AtmosFilter", name)
		ui.open()

/obj/machinery/atmospherics/components/trinary/filter/ui_data()
	var/data = list()
	var/static/all_gases = xgm_gas_data.gases
	data["on"] = on
	data["rate"] = round(transfer_rate)
	data["max_rate"] = round(MAX_TRANSFER_RATE)

	data["filter_types"] = list()
	for(var/gas in ASSORTED_GASES)
		data["filter_types"] += list(list("name" = xgm_gas_data.name[gas], "gas_id" = gas, "enabled" = (gas in filter_type)))

	return data

/obj/machinery/atmospherics/components/trinary/filter/ui_act(action, params)
	. = ..()
	if(.)
		return
	switch(action)
		if("power")
			on = !on
			investigate_log("was turned [on ? "on" : "off"] by [key_name(usr)]", INVESTIGATE_ATMOS)
			. = TRUE
		if("rate")
			var/rate = params["rate"]
			if(rate == "max")
				rate = MAX_TRANSFER_RATE
				. = TRUE
			else if(text2num(rate) != null)
				rate = text2num(rate)
				. = TRUE
			if(.)
				transfer_rate = clamp(rate, 0, MAX_TRANSFER_RATE)
				investigate_log("was set to [transfer_rate] L/s by [key_name(usr)]", INVESTIGATE_ATMOS)
		if("toggle_filter")
			if(!params["val"])
				return TRUE
			filter_type ^= params["val"]
			var/change
			if(params["val"] in filter_type)
				change = "added"
			else
				change = "removed"
			var/gas_name = xgm_gas_data.name[params["val"]]
			investigate_log("[key_name(usr)] [change] [gas_name] from the filter type.", INVESTIGATE_ATMOS)
			. = TRUE
	update_appearance()

/obj/machinery/atmospherics/components/trinary/filter/can_unwrench(mob/user)
	. = ..()
	if(. && on && is_operational)
		to_chat(user, span_warning("You cannot unwrench [src], turn it off first!"))
		return FALSE

// mapping

/obj/machinery/atmospherics/components/trinary/filter/layer2
	piping_layer = 2
	icon_state = "filter_off_map-2"
/obj/machinery/atmospherics/components/trinary/filter/layer4
	piping_layer = 4
	icon_state = "filter_off_map-4"

/obj/machinery/atmospherics/components/trinary/filter/on
	on = TRUE
	icon_state = "filter_on-0"

/obj/machinery/atmospherics/components/trinary/filter/on/layer2
	piping_layer = 2
	icon_state = "filter_on_map-2"
/obj/machinery/atmospherics/components/trinary/filter/on/layer4
	piping_layer = 4
	icon_state = "filter_on_map-4"

/obj/machinery/atmospherics/components/trinary/filter/flipped
	icon_state = "filter_off-0_f"
	flipped = TRUE

/obj/machinery/atmospherics/components/trinary/filter/flipped/layer2
	piping_layer = 2
	icon_state = "filter_off_f_map-2"
/obj/machinery/atmospherics/components/trinary/filter/flipped/layer4
	piping_layer = 4
	icon_state = "filter_off_f_map-4"

/obj/machinery/atmospherics/components/trinary/filter/flipped/on
	on = TRUE
	icon_state = "filter_on-0_f"

/obj/machinery/atmospherics/components/trinary/filter/flipped/on/layer2
	piping_layer = 2
	icon_state = "filter_on_f_map-2"
/obj/machinery/atmospherics/components/trinary/filter/flipped/on/layer4
	piping_layer = 4
	icon_state = "filter_on_f_map-4"

/obj/machinery/atmospherics/components/trinary/filter/atmos //Used for atmos waste loops
	on = TRUE
	icon_state = "filter_on-0"
/obj/machinery/atmospherics/components/trinary/filter/atmos/n2
	name = "nitrogen filter"
	filter_type = list(GAS_N2O)
/obj/machinery/atmospherics/components/trinary/filter/atmos/o2
	name = "oxygen filter"
	filter_type = list(GAS_OXYGEN)
/obj/machinery/atmospherics/components/trinary/filter/atmos/co2
	name = "carbon dioxide filter"
	filter_type = list(GAS_CO2)
/obj/machinery/atmospherics/components/trinary/filter/atmos/n2o
	name = "nitrous oxide filter"
	filter_type = list(GAS_N2O)
/obj/machinery/atmospherics/components/trinary/filter/atmos/plasma
	name = "plasma filter"
	filter_type = list(GAS_PLASMA)
/*
/obj/machinery/atmospherics/components/trinary/filter/atmos/bz
	name = "bz filter"
	filter_type = list(/datum/gas/bz)
/obj/machinery/atmospherics/components/trinary/filter/atmos/freon
	name = "freon filter"
	filter_type = list(/datum/gas/freon)
/obj/machinery/atmospherics/components/trinary/filter/atmos/halon
	name = "halon filter"
	filter_type = list(/datum/gas/halon)
/obj/machinery/atmospherics/components/trinary/filter/atmos/healium
	name = "healium filter"
	filter_type = list(/datum/gas/healium)
*/
/obj/machinery/atmospherics/components/trinary/filter/atmos/h2
	name = "hydrogen filter"
	filter_type = list(GAS_HYDROGEN)
/*
/obj/machinery/atmospherics/components/trinary/filter/atmos/hypernoblium
	name = "hypernoblium filter"
	filter_type = list(/datum/gas/hypernoblium)
/obj/machinery/atmospherics/components/trinary/filter/atmos/miasma
	name = "miasma filter"
	filter_type = list(/datum/gas/miasma)
/obj/machinery/atmospherics/components/trinary/filter/atmos/no2
	name = "nitrium filter"
	filter_type = list(/datum/gas/nitrium)
/obj/machinery/atmospherics/components/trinary/filter/atmos/pluoxium
	name = "pluoxium filter"
	filter_type = list(/datum/gas/pluoxium)
/obj/machinery/atmospherics/components/trinary/filter/atmos/proto_nitrate
	name = "proto-nitrate filter"
	filter_type = list(/datum/gas/proto_nitrate)
/obj/machinery/atmospherics/components/trinary/filter/atmos/tritium
	name = "tritium filter"
	filter_type = list(/datum/gas/tritium)
/obj/machinery/atmospherics/components/trinary/filter/atmos/h2o
	name = "water vapor filter"
	filter_type = list(/datum/gas/water_vapor)
/obj/machinery/atmospherics/components/trinary/filter/atmos/zauker
	name = "zauker filter"
	filter_type = list(/datum/gas/zauker)

/obj/machinery/atmospherics/components/trinary/filter/atmos/helium
	name = "helium filter"
	filter_type = list(/datum/gas/helium)

/obj/machinery/atmospherics/components/trinary/filter/atmos/antinoblium
	name = "antinoblium filter"
	filter_type = list(/datum/gas/antinoblium)
*/
/obj/machinery/atmospherics/components/trinary/filter/atmos/flipped //This feels wrong, I know
	icon_state = "filter_on-0_f"
	flipped = TRUE
/obj/machinery/atmospherics/components/trinary/filter/atmos/flipped/n2
	name = "nitrogen filter"
	filter_type = list(GAS_NITROGEN)
/obj/machinery/atmospherics/components/trinary/filter/atmos/flipped/o2
	name = "oxygen filter"
	filter_type = list(GAS_OXYGEN)
/obj/machinery/atmospherics/components/trinary/filter/atmos/flipped/co2
	name = "carbon dioxide filter"
	filter_type = list(GAS_CO2)
/obj/machinery/atmospherics/components/trinary/filter/atmos/flipped/n2o
	name = "nitrous oxide filter"
	filter_type = list(GAS_N2O)
/obj/machinery/atmospherics/components/trinary/filter/atmos/flipped/plasma
	name = "plasma filter"
	filter_type = list(GAS_PLASMA)
	/*
/obj/machinery/atmospherics/components/trinary/filter/atmos/flipped/bz
	name = "bz filter"
	filter_type = list(/datum/gas/bz)
/obj/machinery/atmospherics/components/trinary/filter/atmos/flipped/freon
	name = "freon filter"
	filter_type = list(/datum/gas/freon)
/obj/machinery/atmospherics/components/trinary/filter/atmos/flipped/halon
	name = "halon filter"
	filter_type = list(/datum/gas/halon)
/obj/machinery/atmospherics/components/trinary/filter/atmos/flipped/healium
	name = "healium filter"
	filter_type = list(/datum/gas/healium)
*/
/obj/machinery/atmospherics/components/trinary/filter/atmos/flipped/h2
	name = "hydrogen filter"
	filter_type = list(GAS_HYDROGEN)
/*
/obj/machinery/atmospherics/components/trinary/filter/atmos/flipped/hypernoblium
	name = "hypernoblium filter"
	filter_type = list(/datum/gas/hypernoblium)
/obj/machinery/atmospherics/components/trinary/filter/atmos/flipped/miasma
	name = "miasma filter"
	filter_type = list(/datum/gas/miasma)
/obj/machinery/atmospherics/components/trinary/filter/atmos/flipped/no2
	name = "nitrium filter"
	filter_type = list(/datum/gas/nitrium)
/obj/machinery/atmospherics/components/trinary/filter/atmos/flipped/pluoxium
	name = "pluoxium filter"
	filter_type = list(/datum/gas/pluoxium)
/obj/machinery/atmospherics/components/trinary/filter/atmos/flipped/proto_nitrate
	name = "proto-nitrate filter"
	filter_type = list(/datum/gas/proto_nitrate)
/obj/machinery/atmospherics/components/trinary/filter/atmos/flipped/tritium
	name = "tritium filter"
	filter_type = list(/datum/gas/tritium)
/obj/machinery/atmospherics/components/trinary/filter/atmos/flipped/h2o
	name = "water vapor filter"
	filter_type = list(/datum/gas/water_vapor)
/obj/machinery/atmospherics/components/trinary/filter/atmos/flipped/zauker
	name = "zauker filter"
	filter_type = list(/datum/gas/zauker)
/obj/machinery/atmospherics/components/trinary/filter/atmos/flipped/helium
	name = "helium filter"
	filter_type = list(/datum/gas/helium)
/obj/machinery/atmospherics/components/trinary/filter/atmos/flipped/antinoblium
	name = "antinoblium filter"
	filter_type = list(/datum/gas/antinoblium)
*/

// These two filter types have critical_machine flagged to on and thus causes the area they are in to be exempt from the Grid Check event.

/obj/machinery/atmospherics/components/trinary/filter/critical
	critical_machine = TRUE

/obj/machinery/atmospherics/components/trinary/filter/flipped/critical
	critical_machine = TRUE
