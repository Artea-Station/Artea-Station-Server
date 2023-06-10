/obj/item/reagent_containers/chem_disp_cartridge
	name = "chemical dispenser cartridge"
	desc = "This goes in a chemical dispenser."
	icon_state = "cartridge"

	w_class = WEIGHT_CLASS_NORMAL

	volume = CARTRIDGE_VOLUME_LARGE
	amount_per_transfer_from_this = 50
	// Large, but inaccurate. Use a chem dispenser or beaker for accuracy.
	possible_transfer_amounts = "50;100"

	resistance_flags = UNACIDABLE

	desc_controls = "Right-click to open the lid."

	var/spawn_reagent = null
	var/label = ""
	var/is_open = FALSE

/obj/item/reagent_containers/chem_disp_cartridge/small
	volume = CARTRIDGE_VOLUME_SMALL

/obj/item/reagent_containers/chem_disp_cartridge/medium
	volume = CARTRIDGE_VOLUME_MEDIUM

/obj/item/reagent_containers/chem_disp_cartridge/New()
	. = ..()
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

/obj/item/reagent_containers/chem_disp_cartridge/is_open_container()
	if(!is_open)
		return FALSE

	return ..()

/obj/item/reagent_containers/chem_disp_cartridge/attack_self_secondary(mob/user, modifiers)
	if (is_open)
		to_chat(usr, span_notice("You put the cap on \the [src]."))
		is_open = FALSE
	else
		to_chat(usr, span_notice("You take the cap off \the [src]."))
		is_open = TRUE

/obj/item/reagent_containers/chem_disp_cartridge/attacked_by(obj/item/attacking_item, mob/living/user)
	if(istype(attacking_item, /obj/item/pen))
		setLabel(tgui_input_text(user, "Input (leave blank to clear):", "Set Label Name"))
		return TRUE

	return ..()

/obj/item/reagent_containers/chem_disp_cartridge/afterattack(obj/target, mob/user)
	if (!is_open_container())
		return

	else if(istype(target, /obj/structure/reagent_dispensers)) //A dispenser. Transfer FROM it TO us.
		target.add_fingerprint(user)

		if(!target.reagents.total_volume && target.reagents)
			to_chat(user, span_warning("\The [target] is empty."))
			return

		if(reagents.total_volume >= reagents.maximum_volume)
			to_chat(user, span_warning("\The [src] is full."))
			return

		var/trans = target.reagents.trans_to(src, target:amount_per_transfer_from_this)
		to_chat(user, span_notice("You fill \the [src] with [trans] units of the contents of \the [target]."))

	else if(target.is_open_container() && target.reagents) //Something like a glass. Player probably wants to transfer TO it.

		if(!reagents.total_volume)
			to_chat(user, span_warning("\The [src] is empty."))
			return

		if(target.reagents.total_volume >= target.reagents.maximum_volume)
			to_chat(user, span_warning("\The [target] is full."))
			return

		var/trans = src.reagents.trans_to(target, amount_per_transfer_from_this)
		to_chat(user, span_notice("You transfer [trans] units of the solution to \the [target]."))

	else
		return ..()
