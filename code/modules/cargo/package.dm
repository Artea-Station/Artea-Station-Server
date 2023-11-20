/obj/item/package
	icon = 'icons/obj/storage/storage.dmi'
	name = "report this to a coder"
	desc = "A package hopefully containing some goodies."
	var/giftwrapped = FALSE
	var/sort_tag = NONE
	var/obj/item/paper/note
	var/obj/item/barcode/sticker

	// List of icon_states to names. This sucks, but making a smarter system is not in my interests right now.
	var/static/list/potential_names = list(
		"deliverycloset" = "packaged closet",
		"deliverycrate" = "packaged crate",
		"deliverybox" = "gigantic box package",
		"deliverypackage5" = "huge package",
		"deliverypackage4" = "big box package",
		"deliverypackage3" = "medium box package",
		"deliverypackage2" = "small box package",
		"deliverypackage1" = "tiny box package",
		"giftdeliverycloset" = "gift packaged closet",
		"giftdeliverycrate" = "gift packaged crate",
		"giftdeliverybox" = "gigantic box gift package",
		"giftdeliverypackage5" = "huge gift package",
		"giftdeliverypackage4" = "big box gift package",
		"giftdeliverypackage3" = "medium box gift package",
		"giftdeliverypackage2" = "small box gift package",
		"giftdeliverypackage1" = "tiny box gift package",
	)
	/// Automatically populated with the values of potential_names.
	var/static/list/potential_name_values

/obj/item/package/Initialize(mapload)
	. = ..()
	RegisterSignal(src, COMSIG_MOVABLE_DISPOSING, PROC_REF(disposal_handling))
	update_appearance(ALL)

/**
 * Initial check if manually unwrapping
 */
/obj/item/package/proc/attempt_pre_unwrap_contents(mob/user)
	to_chat(user, span_notice("You start to unwrap the package..."))
	return do_after(user, 15, target = user)

/**
 * Signals for unwrapping.
 */
/obj/item/package/proc/unwrap_contents()
	if(!sticker)
		return
	for(var/atom/movable/movable_content as anything in contents)
		SEND_SIGNAL(movable_content, COMSIG_ITEM_UNWRAPPED)

/**
 * Effects after completing unwrapping
 */
/obj/item/package/proc/post_unwrap_contents(mob/user)
	var/turf/turf_loc = get_turf(user || src)
	playsound(loc, 'sound/items/poster_ripped.ogg', 50, TRUE)
	new /obj/effect/decal/cleanable/wrapping(turf_loc)

	for(var/atom/movable/movable_content as anything in contents)
		movable_content.forceMove(turf_loc)

	qdel(src)

/obj/item/package/contents_explosion(severity, target)
	switch(severity)
		if(EXPLODE_DEVASTATE)
			SSexplosions.high_mov_atom += contents
		if(EXPLODE_HEAVY)
			SSexplosions.med_mov_atom += contents
		if(EXPLODE_LIGHT)
			SSexplosions.low_mov_atom += contents

/obj/item/package/deconstruct()
	unwrap_contents()
	post_unwrap_contents()
	return ..()

/obj/item/package/examine(mob/user)
	. = ..()
	if(note)
		if(!in_range(user, src))
			. += "There's a [note.name] attached to it. You can't read it from here."
		else
			. += "There's a [note.name] attached to it..."
			. += note.examine(user)
	if(sticker)
		. += "There's a barcode attached to the side."
	if(sort_tag)
		. += "There's a sorting tag with the destination set to [GLOB.TAGGERLOCATIONS[sort_tag]]."

/obj/item/package/proc/disposal_handling(disposal_source, obj/structure/disposalholder/disposal_holder, obj/machinery/disposal/disposal_machine, hasmob)
	SIGNAL_HANDLER
	if(!hasmob)
		disposal_holder.destinationTag = sort_tag

/obj/item/package/relay_container_resist_act(mob/living/user, obj/object)
	if(ismovable(loc))
		var/atom/movable/movable_loc = loc //can't unwrap the wrapped container if it's inside something.
		movable_loc.relay_container_resist_act(user, object)
		return
	to_chat(user, span_notice("You lean on the back of [object] and start pushing to rip the wrapping around it."))
	if(do_after(user, 50, target = object))
		if(!user || user.stat != CONSCIOUS || user.loc != object || object.loc != src)
			return
		to_chat(user, span_notice("You successfully removed [object]'s wrapping !"))
		object.forceMove(loc)
		unwrap_contents()
		post_unwrap_contents(user)
	else
		if(user.loc == src) //so we don't get the message if we resisted multiple times and succeeded.
			to_chat(user, span_warning("You fail to remove [object]'s wrapping!"))

/obj/item/package/update_icon_state()
	. = ..()
	// Will be a w_class if non-dense, or a string if dense.
	var/target_state = 0
	var/slowdown = 0
	// I'm putting a lot of trust in coders to not put shit like combat shotguns inside a goody case here.
	for(var/atom/movable/thing as anything in contents)

		if(thing == note) // Don't count the note towards the size.
			continue

		if(isnum(target_state))
			if(istype(thing, /obj/item))
				var/obj/item/item = thing
				target_state += item.w_class
			else if(istype(thing, /obj/structure/closet/crate))
				target_state = "deliverycrate"
			else if(istype(thing, /obj/structure/closet))
				target_state = "deliverycloset"
			else
				target_state = "deliverybox"

			if(isnum(target_state) && target_state > 10) // Wiggle room to make pickupable packages more common.
				target_state = "deliverybox"

		if(istype(thing, /obj))
			var/obj/object = thing
			if(object.drag_slowdown && slowdown < object.drag_slowdown)
				slowdown = object.drag_slowdown

	density = !isnum(target_state)
	// It's possible for this to be empty.
	if(!target_state)
		target_state = 1

	// Yes, I'm updating the item's characteristics here. No, I don't really care. Fragmented code is hell.
	switch(density)
		if(TRUE)
			base_icon_state = target_state
			layer = BELOW_OBJ_LAYER
			pass_flags_self = PASSSTRUCTURE
			interaction_flags_item = NONE
			interaction_flags_atom = INTERACT_ATOM_ATTACK_HAND
		if(FALSE)
			target_state = min(WEIGHT_CLASS_HUGE, target_state)
			base_icon_state = "deliverypackage[target_state]"
			layer = initial(layer)
			pass_flags_self = initial(pass_flags_self)
			interaction_flags_item = initial(interaction_flags_item)
			interaction_flags_atom = initial(interaction_flags_atom)

	icon_state = giftwrapped ? "gift[base_icon_state]" : base_icon_state

	// Sadly, I can't use update_name for this, as it's called before.
	if(!potential_name_values)
		potential_name_values = list(initial(name))
		for(var/entry in potential_names)
			potential_name_values += potential_names[entry]
	if(!(name in potential_name_values))
		return
	name = potential_names[icon_state]


/obj/item/package/update_overlays()
	. = ..()
	if(sort_tag)
		. += "[base_icon_state]_sort"
	if(note)
		. += "[base_icon_state]_note"
	if(sticker)
		. += "[base_icon_state]_tag"

/obj/item/package/attackby(obj/item/item, mob/user, params)
	if(istype(item, /obj/item/dest_tagger))
		var/obj/item/dest_tagger/dest_tagger = item

		if(sort_tag != dest_tagger.currTag)
			var/tag = uppertext(GLOB.TAGGERLOCATIONS[dest_tagger.currTag])
			to_chat(user, span_notice("*[tag]*"))
			sort_tag = dest_tagger.currTag
			playsound(loc, 'sound/machines/twobeep_high.ogg', 100, TRUE)
			update_appearance()
	else if(istype(item, /obj/item/pen))
		if(!user.can_write(item))
			return
		var/str = tgui_input_text(user, "Label text?", "Set label", max_length = MAX_NAME_LEN)
		if(!user.canUseTopic(src, BE_CLOSE))
			return
		if(!str || !length(str))
			to_chat(user, span_warning("Invalid text!"))
			return
		user.visible_message(span_notice("[user] labels [src] as [str]."))
		name = "[name] ([str])"

	else if(istype(item, /obj/item/stack/wrapping_paper) && !giftwrapped)
		var/obj/item/stack/wrapping_paper/wrapping_paper = item
		if(wrapping_paper.use(3))
			user.visible_message(span_notice("[user] wraps the package in festive paper!"))
			giftwrapped = TRUE
			greyscale_config = text2path("/datum/greyscale_config/[icon_state]")
			set_greyscale(colors = wrapping_paper.greyscale_colors)
			update_appearance()
		else
			to_chat(user, span_warning("You need more paper!"))

	else if(istype(item, /obj/item/paper))
		if(note)
			to_chat(user, span_warning("This package already has a note attached!"))
			return
		if(!user.transferItemToLoc(item, src))
			to_chat(user, span_warning("For some reason, you can't attach [item]!"))
			return
		user.visible_message(span_notice("[user] attaches [item] to [src]."), span_notice("You attach [item] to [src]."))
		note = item
		update_appearance()

	else if(istype(item, /obj/item/sales_tagger))
		var/obj/item/sales_tagger/sales_tagger = item
		if(sticker)
			to_chat(user, span_warning("This package already has a barcode attached!"))
			return
		if(!(sales_tagger.payments_acc))
			to_chat(user, span_warning("Swipe an ID on [sales_tagger] first!"))
			return
		if(sales_tagger.paper_count <= 0)
			to_chat(user, span_warning("[sales_tagger] is out of paper!"))
			return
		user.visible_message(span_notice("[user] attaches a barcode to [src]."), span_notice("You attach a barcode to [src]."))
		sales_tagger.paper_count -= 1
		sticker = new /obj/item/barcode(src)
		sticker.payments_acc = sales_tagger.payments_acc	//new tag gets the tagger's current account.
		sticker.cut_multiplier = sales_tagger.cut_multiplier	//same, but for the percentage taken.

		for(var/obj/wrapped_item in get_all_contents())
			if(HAS_TRAIT(wrapped_item, TRAIT_NO_BARCODES))
				continue
			wrapped_item.AddComponent(/datum/component/pricetag, sticker.payments_acc, sales_tagger.cut_multiplier)
		update_appearance()

	else if(istype(item, /obj/item/barcode))
		var/obj/item/barcode/stickerA = item
		if(sticker)
			to_chat(user, span_warning("This package already has a barcode attached!"))
			return
		if(!(stickerA.payments_acc))
			to_chat(user, span_warning("This barcode seems to be invalid. Guess it's trash now."))
			return
		if(!user.transferItemToLoc(item, src))
			to_chat(user, span_warning("For some reason, you can't attach [item]!"))
			return
		sticker = stickerA
		for(var/obj/wrapped_item in get_all_contents())
			if(HAS_TRAIT(wrapped_item, TRAIT_NO_BARCODES))
				continue
			wrapped_item.AddComponent(/datum/component/pricetag, sticker.payments_acc, sticker.cut_multiplier)
		update_appearance()

	else
		return ..()

/obj/item/package/interact(mob/user)
	if(!density)
		return
	if(note)
		user.put_in_hands(note)
		note = null
		update_appearance()
		return
	if(!attempt_pre_unwrap_contents(user))
		return
	unwrap_contents()
	post_unwrap_contents()

/obj/item/package/attack_self(mob/user)
	if(density)
		return
	if(note)
		user.put_in_hands(note)
		note = null
		update_appearance()
		return
	if(!attempt_pre_unwrap_contents(user))
		return
	user.temporarilyRemoveItemFromInventory(src, TRUE)
	unwrap_contents()
	for(var/atom/movable/movable_content as anything in contents)
		user.put_in_hands(movable_content)
	post_unwrap_contents(user)

/// Insert all given atoms. Can be a list.
/obj/item/package/proc/insert(atoms)
	contents += atoms
	if(islist(atoms))
		for(var/atom/movable/thing as anything in atoms)
			thing.forceMove(src)
	else
		var/atom/movable/thing = atoms
		thing.forceMove(src)

	update_appearance()
