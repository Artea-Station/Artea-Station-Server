/obj/machinery/computer/reactor/control_rods
	name = "Control rod management computer"
	desc = "A computer which can remotely raise / lower the control rods of a reactor."
	icon_screen = "rbmk_rods"

/obj/machinery/computer/reactor/control_rods/attack_hand(mob/living/user)
	. = ..()
	ui_interact(user)

/obj/machinery/computer/reactor/control_rods/ui_interact(mob/user, datum/tgui/ui)
	. = ..()
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "RbmkControlRods")
		ui.open()
		ui.set_autoupdate(TRUE)

/obj/machinery/computer/reactor/control_rods/ui_act(action, params)
	. = ..()
	if(.)
		return

	var/obj/machinery/atmospherics/components/trinary/nuclear_reactor/reactor = reactor_ref?.resolve()
	if(!reactor)
		reactor_ref = null
		return

	if(action == "input")
		var/input = text2num(params["target"])
		reactor.last_user = usr
		reactor.desired_k = clamp(input, 0, 3)

	return TRUE

/obj/machinery/computer/reactor/control_rods/ui_data(mob/user)
	var/list/data = list()
	data["control_rods"] = 0
	data["k"] = 0
	data["desiredK"] = 0
	var/obj/machinery/atmospherics/components/trinary/nuclear_reactor/reactor = reactor_ref?.resolve()
	if(reactor)
		data["k"] = reactor.rate_of_reaction
		data["desiredK"] = reactor.desired_k
		data["control_rods"] = 100 - (reactor.desired_k / 3 * 100) //Rod insertion is extrapolated as a function of the percentage of K
	return data
