/obj/item/reagent_containers/chem_disp_cartridge
	name = "large chemical dispenser cartridge"
	desc = "This goes in a chemical dispenser."
	icon_state = "cartridge"

	w_class = WEIGHT_CLASS_NORMAL

	volume = CARTRIDGE_VOLUME_LARGE
	amount_per_transfer_from_this = 50
	// Large, but inaccurate. Use a chem dispenser or beaker for accuracy.
	possible_transfer_amounts = list("50", "100")

	resistance_flags = UNACIDABLE
	reagent_flags = OPENCONTAINER

	var/spawn_reagent = null
	var/label = ""

/obj/item/reagent_containers/chem_disp_cartridge/small
	name = "small chemical dispenser cartridge"
	volume = CARTRIDGE_VOLUME_SMALL

/obj/item/reagent_containers/chem_disp_cartridge/medium
	name = "medium chemical dispenser cartridge"
	volume = CARTRIDGE_VOLUME_MEDIUM

/obj/item/reagent_containers/chem_disp_cartridge/New()
	. = ..()
	for(var/path in subtypesof(/datum/reagent))
		log_admin("[path]")
	if(spawn_reagent)
		reagents.add_reagent(spawn_reagent, volume)
		var/datum/reagent/R = spawn_reagent
		setLabel(initial(R.name))

/obj/item/reagent_containers/chem_disp_cartridge/examine(mob/user)
	. = ..()
	to_chat(user, "It has a capacity of [volume] units.")
	if(reagents.total_volume <= 0)
		to_chat(user, "It is empty.")
	else
		to_chat(user, "It contains [reagents.total_volume] units of liquid.")
	if(!is_open_container())
		to_chat(user, "The cap is sealed.")

/obj/item/reagent_containers/chem_disp_cartridge/verb/verb_set_label(L as text)
	set name = "Set Cartridge Label"
	set category = "Object"
	set src in view(usr, 1)

	setLabel(L, usr)

/obj/item/reagent_containers/chem_disp_cartridge/proc/setLabel(L, mob/user = null)
	if(L)
		if(user)
			to_chat(user, span_notice("You set the label on \the [src] to '[L]'."))

		label = L
		name = "[initial(name)] - '[L]'"
	else
		if(user)
			to_chat(user, span_notice("You clear the label on \the [src]."))
		label = ""
		name = initial(name)

/obj/item/reagent_containers/chem_disp_cartridge/attacked_by(obj/item/attacking_item, mob/living/user)
	if(istype(attacking_item, /obj/item/pen))
		setLabel(tgui_input_text(user, "Input (leave blank to clear):", "Set Label Name"))
		return TRUE

	return ..()

// WHY THE FUCK IS THIS NOT A BASETYPE THING?!?!?!
/obj/item/reagent_containers/chem_disp_cartridge/afterattack(obj/target, mob/living/user, proximity)
	. = ..()
	if((!proximity) || !check_allowed_items(target,target_self=1))
		return

	if(target.is_refillable()) //Something like a glass. Player probably wants to transfer TO it.
		if(!reagents.total_volume)
			to_chat(user, span_warning("[src] is empty!"))
			return

		if(target.reagents.holder_full())
			to_chat(user, span_warning("[target] is full."))
			return

		var/trans = reagents.trans_to(target, amount_per_transfer_from_this, transfered_by = user)
		to_chat(user, span_notice("You transfer [trans] unit\s of the solution to [target]."))

	else if(target.is_drainable()) //A dispenser. Transfer FROM it TO us.
		if(!target.reagents.total_volume)
			to_chat(user, span_warning("[target] is empty and can't be refilled!"))
			return

		if(reagents.holder_full())
			to_chat(user, span_warning("[src] is full."))
			return

		var/trans = target.reagents.trans_to(src, amount_per_transfer_from_this, transfered_by = user)
		to_chat(user, span_notice("You fill [src] with [trans] unit\s of the contents of [target]."))

	target.update_appearance()

/obj/item/reagent_containers/chem_disp_cartridge/afterattack_secondary(atom/target, mob/user, proximity_flag, click_parameters)
	if((!proximity_flag) || !check_allowed_items(target,target_self=1))
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

	if(!spillable)
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

	if(target.is_drainable()) //A dispenser. Transfer FROM it TO us.
		if(!target.reagents.total_volume)
			to_chat(user, span_warning("[target] is empty!"))
			return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

		if(reagents.holder_full())
			to_chat(user, span_warning("[src] is full."))
			return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

		var/trans = target.reagents.trans_to(src, amount_per_transfer_from_this, transfered_by = user)
		to_chat(user, span_notice("You fill [src] with [trans] unit\s of the contents of [target]."))

	target.update_appearance()
	return SECONDARY_ATTACK_CONTINUE_CHAIN
