//Bureaucracy machine!
//Simply set this up in the hopline and you can serve people based on ticket numbers

/obj/machinery/ticket_machine
	name = "ticket machine"
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "ticketmachine"
	base_icon_state = "ticketmachine"
	desc = "A marvel of bureaucratic engineering encased in an efficient plastic shell. It can be refilled with a hand labeler refill roll and linked to buttons with a multitool."
	density = FALSE
	maptext_height = 26
	maptext_width = 32
	maptext_x = 7
	maptext_y = 10
	layer = HIGH_OBJ_LAYER
	///Increment the ticket number whenever the HOP presses his button
	var/ticket_number = 0
	///What ticket number are we currently serving?
	var/current_number = 0
	///At this point, you need to refill it.
	var/max_number = 100
	var/cooldown = 5 SECONDS
	var/ready = TRUE
	var/id = "ticket_machine_default" //For buttons

/obj/machinery/ticket_machine/Initialize(mapload)
	. = ..()
	update_appearance()

MAPPING_DIRECTIONAL_HELPERS(/obj/machinery/ticket_machine, 32)

/obj/machinery/ticket_machine/examine(mob/user)
	. = ..()
	. += span_notice("The ticket machine shows that ticket #[current_number] is currently being served.")
	. += span_notice("You can take a ticket out with <b>Left-Click</b> to be number [ticket_number + 1] in queue.")

/obj/machinery/ticket_machine/multitool_act(mob/living/user, obj/item/I)
	if(!multitool_check_buffer(user, I)) //make sure it has a data buffer
		return
	var/obj/item/multitool/M = I
	M.buffer = src
	to_chat(user, span_notice("You store linkage information in [I]'s buffer."))
	return TRUE

/obj/machinery/ticket_machine/emag_act(mob/user) //Emag the ticket machine to dispense burning tickets, as well as randomize its number to destroy the HoP's mind.
	if(obj_flags & EMAGGED)
		return
	to_chat(user, span_warning("You overload [src]'s bureaucratic logic circuitry to its MAXIMUM setting."))
	ticket_number = rand(0,max_number)
	current_number = ticket_number
	obj_flags |= EMAGGED
	update_appearance()

///Increments the counter by one, if there is a ticket after the current one we are serving.
///If we have a current ticket, remove it from the top of our tickets list and replace it with the next one if applicable
/obj/machinery/ticket_machine/proc/increment()
	if(current_number < ticket_number)
		current_number ++ //Increment the one we're serving.
		playsound(src, 'sound/misc/announce_dig.ogg', 50, FALSE)
		say("Now serving ticket #[current_number]!")
		update_appearance()
		return TRUE

/obj/machinery/button/ticket_machine
	name = "increment ticket counter"
	desc = "Use this button after you've served someone to tell the next person to come forward."
	device_type = /obj/item/assembly/control/ticket_machine
	req_access = list()
	id = "ticket_machine_default"

/obj/machinery/button/ticket_machine/Initialize(mapload)
	. = ..()
	if(device)
		var/obj/item/assembly/control/ticket_machine/ours = device
		ours.id = id

/obj/machinery/button/ticket_machine/multitool_act(mob/living/user, obj/item/I)
	. = ..()
	if(I.tool_behaviour == TOOL_MULTITOOL)
		var/obj/item/multitool/M = I
		if(M.buffer && !istype(M.buffer, /obj/machinery/ticket_machine))
			return
		var/obj/item/assembly/control/ticket_machine/controller = device
		controller.ticket_machine_ref = WEAKREF(M.buffer)
		id = null
		controller.id = null
		to_chat(user, span_warning("You've linked [src] to [M.buffer]."))

/obj/item/assembly/control/ticket_machine
	name = "ticket machine controller"
	desc = "A remote controller for the HoP's ticket machine."
	///Weakref to our ticket machine
	var/datum/weakref/ticket_machine_ref

/obj/item/assembly/control/ticket_machine/Initialize(mapload)
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/item/assembly/control/ticket_machine/LateInitialize()
	find_machine()

/// Locate the ticket machine to which we're linked by our ID
/obj/item/assembly/control/ticket_machine/proc/find_machine()
	for(var/obj/machinery/ticket_machine/ticketsplease in GLOB.machines)
		if(ticketsplease.id == id)
			ticket_machine_ref = WEAKREF(ticketsplease)
	if(ticket_machine_ref)
		return TRUE
	else
		return FALSE

/obj/item/assembly/control/ticket_machine/activate(mob/activator)
	if(cooldown)
		return
	if(!ticket_machine_ref)
		return
	var/obj/machinery/ticket_machine/machine = ticket_machine_ref.resolve()
	if(!machine)
		return
	cooldown = TRUE
	if(!machine.increment())
		to_chat(activator, span_notice("The button light indicates that there are no more tickets to be processed."))
	addtimer(VARSET_CALLBACK(src, cooldown, FALSE), 10)

/obj/machinery/ticket_machine/update_icon()
	. = ..()
	handle_maptext()

/obj/machinery/ticket_machine/update_icon_state()
	switch(ticket_number) //Gives you an idea of how many tickets are left
		if(0 to 49)
			icon_state = "[base_icon_state]_100"
		if(50 to 99)
			icon_state = "[base_icon_state]_50"
		if(100)
			icon_state = "[base_icon_state]_0"
	return ..()

/obj/machinery/ticket_machine/proc/handle_maptext()
	switch(current_number) //This is here to handle maptext offsets so that the numbers align.
		if(0 to 9)
			maptext_x = 13
		if(10 to 99)
			maptext_x = 10
		if(100)
			maptext_x = 8
	maptext = MAPTEXT(current_number) //Finally, apply the maptext

/obj/machinery/ticket_machine/attackby(obj/item/I, mob/user, params)
	..()
	if(istype(I, /obj/item/hand_labeler_refill))
		if(!(ticket_number >= max_number))
			if(tgui_alert(user, "[src] still has [max_number-ticket_number] ticket[max_number-ticket_number==1 ? null : "s"] left, are you sure you want to refill it?", "Tactical Refill", list("Refill", "Cancel")) != "Refill")
				return //If the user still wants to refill it...
		to_chat(user, span_notice("You start to refill [src]'s ticket holder."))
		if(do_after(user, src, 30))
			to_chat(user, span_notice("You insert [I] into [src] as it whirs nondescriptly."))
			qdel(I)
			ticket_number = 0
			current_number = 0
			update_appearance()
			return

/obj/machinery/ticket_machine/proc/reset_cooldown()
	ready = TRUE

/obj/machinery/ticket_machine/attack_hand(mob/living/carbon/user, list/modifiers)
	. = ..()
	if(!ready)
		to_chat(user,span_warning("You press the button, but nothing happens..."))
		return
	if(ticket_number >= max_number)
		to_chat(user,span_warning("Ticket supply depleted, please refill this unit with a hand labeller refill cartridge!"))
		return
	playsound(src, 'sound/machines/terminal_insert_disc.ogg', 100, FALSE)
	ticket_number++
	to_chat(user, span_notice("You take a ticket from [src], looks like you're ticket number #[ticket_number]..."))
	var/obj/item/ticket_machine_ticket/theirticket = new /obj/item/ticket_machine_ticket(get_turf(src))
	theirticket.name = "Ticket #[ticket_number]"
	theirticket.maptext = MAPTEXT(ticket_number)
	theirticket.saved_maptext = MAPTEXT(ticket_number)
	user.put_in_hands(theirticket)
	update_appearance()
	if(obj_flags & EMAGGED) //Emag the machine to destroy the HOP's life.
		ready = FALSE
		addtimer(CALLBACK(src, PROC_REF(reset_cooldown)), cooldown)//Small cooldown to prevent piles of flaming tickets
		theirticket.fire_act()
		user.dropItemToGround(theirticket)
		user.adjust_fire_stacks(1)
		user.ignite_mob()
	update_appearance()

/obj/item/ticket_machine_ticket
	name = "\improper ticket"
	desc = "A ticket which shows your place in the Head of Personnel's line. Made from Nanotrasen patented NanoPaper®. Though solid, its form seems to shimmer slightly. Feels (and burns) just like the real thing."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "ticket"
	maptext_x = 7
	maptext_y = 10
	w_class = WEIGHT_CLASS_TINY
	resistance_flags = FLAMMABLE
	max_integrity = 50
	var/number
	var/saved_maptext = null

/obj/item/ticket_machine_ticket/Initialize(mapload, num)
	. = ..()
	number = num
	if(!isnull(num))
		name += " #[num]"
		saved_maptext = MAPTEXT(num)
		maptext = saved_maptext

/obj/item/ticket_machine_ticket/examine(mob/user)
	. = ..()
	if(!isnull(number))
		. += span_notice("The ticket reads shimmering text that tells you that you are number [number] in queue.")

/obj/item/ticket_machine_ticket/attack_hand(mob/user, list/modifiers)
	. = ..()
	maptext = saved_maptext //For some reason, storage code removes all maptext off objs, this stops its number from being wiped off when taken out of storage.

/obj/item/ticket_machine_ticket/attackby(obj/item/P, mob/living/carbon/human/user, params) //Stolen from papercode
	if(burn_paper_product_attackby_check(P, user))
		return
	return ..()
