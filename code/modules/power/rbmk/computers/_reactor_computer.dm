//Controlling the reactor.

/obj/machinery/computer/reactor
	name = "Reactor control console"
	desc = "Scream"
	light_color = "#55BA55"
	light_power = 1
	light_range = 3
	icon = 'icons/obj/machines/rbmk/rbmk_computer.dmi'
	icon_state = "oldcomp"
	icon_screen = "library"
	icon_keyboard = null
	var/datum/weakref/reactor_ref
	var/id = "rbmk_default"
	var/failed_to_link

/obj/machinery/computer/reactor/Initialize(mapload, obj/item/circuitboard/C)
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(link_to_reactor)), 1 SECONDS)

/obj/machinery/computer/reactor/wrench_act(mob/living/user, obj/item/I)
	to_chat(user, "<span class='notice'>You start [anchored ? "un" : ""]securing [name]...</span>")
	if(I.use_tool(src, user, 4 SECONDS))
		to_chat(user, "<span class='notice'>You [anchored ? "un" : ""]secure [name].</span>")
		set_anchored(!anchored)
		return TRUE
	return FALSE

/obj/machinery/computer/reactor/proc/link_to_reactor()
	for(var/obj/machinery/atmospherics/components/trinary/nuclear_reactor/found_reactor as anything in GLOB.rbmk_reactors)
		if(found_reactor.id && found_reactor.id == id) // You're not controlling this somewhere very far away. Fuck off.
			if(get_dist(src, found_reactor) > 10 || !is_station_level(found_reactor.z))
				failed_to_link = TRUE
				return FALSE

			reactor_ref = WEAKREF(found_reactor)
			return TRUE

	return FALSE

/obj/machinery/computer/reactor/examine(mob/user)
	. = ..()
	if(failed_to_link)
		. += span_warning("This must be within 10 tiles of a connected reactor.")

/obj/machinery/atmospherics/components/trinary/nuclear_reactor/multitool_act(mob/living/user, obj/item/multitool/I)
	if(!istype(I))
		return

	to_chat(user, span_notice("You add \the [src]'s ID into the multitool's buffer."))
	I.buffer = src.id
	return TRUE

/obj/machinery/computer/reactor/multitool_act(mob/living/user, obj/item/multitool/I)
	if(!istype(I))
		return

	to_chat(user, span_notice("You add the reactor's ID to \the [src]"))
	src.id = I.buffer
	link_to_reactor()
	return TRUE
