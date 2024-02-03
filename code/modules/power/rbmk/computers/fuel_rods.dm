

/obj/machinery/computer/reactor/fuel_rods
	name = "Reactor Fuel Management Console"
	desc = "A console which can remotely raise fuel rods out of nuclear reactors."
	icon_screen = "rbmk_fuel"

/obj/machinery/computer/reactor/fuel_rods/attack_hand(mob/living/user)
	. = ..()

	var/obj/machinery/atmospherics/components/trinary/nuclear_reactor/reactor = reactor_ref?.resolve()
	if(!reactor)
		reactor_ref = null
		return FALSE

	if(reactor.power > 20)
		to_chat(user, "<span class='warning'>You cannot remove fuel from [reactor] when it is above 20% power.</span>")
		return FALSE

	if(!reactor.fuel_rods.len)
		to_chat(user, "<span class='warning'>[reactor] does not have any fuel rods loaded.</span>")
		return FALSE

	var/atom/movable/fuel_rod = tgui_input_list(usr, "Select a fuel rod to remove", "[src]", reactor.fuel_rods, null)
	if(!fuel_rod)
		return

	playsound(src, pick('sound/machines/rbmk/switch.ogg','sound/machines/rbmk/switch2.ogg','sound/machines/rbmk/switch3.ogg'), 100, FALSE)
	playsound(reactor, 'sound/machines/rbmk/crane_1.wav', 100, FALSE)
	fuel_rod.forceMove(get_turf(reactor))
	reactor.fuel_rods -= fuel_rod
