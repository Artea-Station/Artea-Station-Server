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
	var/obj/machinery/atmospherics/components/trinary/nuclear_reactor/reactor = null
	var/id = "default_reactor_for_lazy_mappers"

/obj/machinery/computer/reactor/Initialize(mapload, obj/item/circuitboard/C)
	. = ..()
	addtimer(CALLBACK(src, .proc/link_to_reactor), 10 SECONDS)

/obj/machinery/computer/reactor/wrench_act(mob/living/user, obj/item/I)
	to_chat(user, "<span class='notice'>You start [anchored ? "un" : ""]securing [name]...</span>")
	if(I.use_tool(src, user, 40, volume=75))
		to_chat(user, "<span class='notice'>You [anchored ? "un" : ""]secure [name].</span>")
		set_anchored(!anchored)
		return TRUE
	return FALSE

/obj/machinery/computer/reactor/proc/link_to_reactor()
	for(var/obj/machinery/atmospherics/components/trinary/nuclear_reactor/asdf in GLOB.machines)
		if(asdf.id && asdf.id == id)
			reactor = asdf
			return TRUE
	return FALSE
