/mob/living/carbon/human/update_clothing(slot_flags)
	if(slot_flags & ITEM_SLOT_BACK)
		update_worn_back()
	if(slot_flags & ITEM_SLOT_MASK)
		update_worn_mask()
	if(slot_flags & ITEM_SLOT_NECK)
		update_worn_neck()
	if(slot_flags & ITEM_SLOT_HANDCUFFED)
		update_worn_handcuffs()
	if(slot_flags & ITEM_SLOT_LEGCUFFED)
		update_worn_legcuffs()
	if(slot_flags & ITEM_SLOT_BELT)
		update_worn_belt()
	if(slot_flags & ITEM_SLOT_ID)
		update_worn_id()
	if(slot_flags & ITEM_SLOT_EARS)
		update_inv_ears()
	if(slot_flags & ITEM_SLOT_EYES)
		update_worn_glasses()
	if(slot_flags & ITEM_SLOT_GLOVES)
		update_worn_gloves()
	if(slot_flags & ITEM_SLOT_HEAD)
		update_worn_head()
	if(slot_flags & ITEM_SLOT_FEET)
		update_worn_shoes()
	if(slot_flags & ITEM_SLOT_OCLOTHING)
		update_worn_oversuit()
	if(slot_flags & ITEM_SLOT_ICLOTHING)
		update_worn_undersuit()
	if(slot_flags & ITEM_SLOT_SUITSTORE)
		update_suit_storage()
	if(slot_flags & ITEM_SLOT_LPOCKET || slot_flags & ITEM_SLOT_RPOCKET)
		update_pockets()

//IMPORTANT: Multiple animate() calls do not stack well, so try to do them all at once if you can.
/mob/living/carbon/perform_update_transform()
	var/matrix/ntransform = matrix(transform) //aka transform.Copy()
	var/final_pixel_y = pixel_y
	var/final_dir = dir
	var/changed = 0
	if(lying_angle != lying_prev && rotate_on_lying)
		changed++
		ntransform.TurnTo(lying_prev , lying_angle)
		if(!lying_angle) //Lying to standing
			final_pixel_y = base_pixel_y
		else //if(lying != 0)
			if(lying_prev == 0) //Standing to lying
				pixel_y = base_pixel_y
				final_pixel_y = base_pixel_y + PIXEL_Y_OFFSET_LYING
				if(dir & (EAST|WEST)) //Facing east or west
					final_dir = pick(NORTH, SOUTH) //So you fall on your side rather than your face or ass
	if(resize != RESIZE_DEFAULT_SIZE)
		changed++
		ntransform.Scale(resize)
		resize = RESIZE_DEFAULT_SIZE

	if(changed)
		SEND_SIGNAL(src, COMSIG_PAUSE_FLOATING_ANIM, 0.3 SECONDS)
		animate(src, transform = ntransform, time = (lying_prev == 0 || lying_angle == 0) ? 2 : 0, pixel_y = final_pixel_y, dir = final_dir, easing = (EASE_IN|EASE_OUT))

/mob/living/carbon
	var/list/overlays_standing[TOTAL_LAYERS]

/mob/living/carbon/proc/apply_overlay(cache_index)
	if((. = overlays_standing[cache_index]))
		add_overlay(.)

/mob/living/carbon/proc/remove_overlay(cache_index)
	var/I = overlays_standing[cache_index]
	if(I)
		cut_overlay(I)
		overlays_standing[cache_index] = null

//used when putting/removing clothes that hide certain mutant body parts to just update those and not update the whole body.
/mob/living/carbon/human/proc/update_mutant_bodyparts()
	dna.species.handle_mutant_bodyparts(src)
	update_body_parts()

/mob/living/carbon/update_body(is_creating = FALSE)
	dna.species.handle_body(src) //This calls `handle_mutant_bodyparts` which calls `update_mutant_bodyparts()`. Don't double call!
	update_body_parts(is_creating)

/mob/living/carbon/regenerate_icons()
	if(notransform)
		return 1
	icon_render_keys = list() //Clear this bad larry out
	update_held_items()
	update_worn_handcuffs()
	update_worn_legcuffs()
	update_fire()
	update_body()

/mob/living/carbon/update_held_items()
	remove_overlay(HANDS_LAYER)
	if (handcuffed)
		drop_all_held_items()
		return

	var/list/hands = list()
	for(var/obj/item/I in held_items)
		if(client && hud_used && hud_used.hud_version != HUD_STYLE_NOHUD)
			I.screen_loc = ui_hand_position(get_held_index_of_item(I))
			client.screen += I
			if(length(observers))
				for(var/mob/dead/observe as anything in observers)
					if(observe.client && observe.client.eye == src)
						observe.client.screen += I
					else
						observers -= observe
						if(!observers.len)
							observers = null
							break

		var/icon_file = I.lefthand_file
		if(get_held_index_of_item(I) % 2 == 0)
			icon_file = I.righthand_file

		hands += I.build_worn_icon(default_layer = HANDS_LAYER, default_icon_file = icon_file, isinhands = TRUE)

	overlays_standing[HANDS_LAYER] = hands
	apply_overlay(HANDS_LAYER)

/mob/living/carbon/update_fire_overlay(stacks, on_fire, last_icon_state, suffix = "")
	var/fire_icon = "[dna?.species.fire_overlay || "human"]_[stacks > MOB_BIG_FIRE_STACK_THRESHOLD ? "big_fire" : "small_fire"][suffix]"

	if(!GLOB.fire_appearances[fire_icon])
		GLOB.fire_appearances[fire_icon] = mutable_appearance('icons/mob/effects/onfire.dmi', fire_icon, -FIRE_LAYER, appearance_flags = RESET_COLOR)

	if((stacks > 0 && on_fire) || HAS_TRAIT(src, TRAIT_PERMANENTLY_ONFIRE))
		if(fire_icon == last_icon_state)
			return last_icon_state

		remove_overlay(FIRE_LAYER)
		overlays_standing[FIRE_LAYER] = GLOB.fire_appearances[fire_icon]
		apply_overlay(FIRE_LAYER)
		return fire_icon

	if(!last_icon_state)
		return last_icon_state

	remove_overlay(FIRE_LAYER)
	apply_overlay(FIRE_LAYER)
	return null

/mob/living/carbon/update_damage_overlays()
	remove_overlay(DAMAGE_LAYER)

	var/mutable_appearance/damage_overlay = mutable_appearance('icons/mob/effects/dam_mob.dmi', "blank", -DAMAGE_LAYER)
	overlays_standing[DAMAGE_LAYER] = damage_overlay

	for(var/obj/item/bodypart/iter_part as anything in bodyparts)
		if(iter_part.dmg_overlay_type)
			if(iter_part.brutestate)
				damage_overlay.add_overlay("[iter_part.dmg_overlay_type]_[iter_part.body_zone]_[iter_part.brutestate]0") //we're adding icon_states of the base image as overlays
			if(iter_part.burnstate)
				damage_overlay.add_overlay("[iter_part.dmg_overlay_type]_[iter_part.body_zone]_0[iter_part.burnstate]")

	apply_overlay(DAMAGE_LAYER)

/mob/living/carbon/update_wound_overlays()
	remove_overlay(WOUND_LAYER)

	var/mutable_appearance/wound_overlay = mutable_appearance('icons/mob/effects/bleed_overlays.dmi', "blank", -WOUND_LAYER)
	overlays_standing[WOUND_LAYER] = wound_overlay

	for(var/obj/item/bodypart/iter_part as anything in bodyparts)
		if(iter_part.bleed_overlay_icon)
			wound_overlay.add_overlay(iter_part.bleed_overlay_icon)

	apply_overlay(WOUND_LAYER)

/mob/living/carbon/update_worn_mask()
	remove_overlay(FACEMASK_LAYER)

	if(!get_bodypart(BODY_ZONE_HEAD)) //Decapitated
		return

	if(client && hud_used?.inv_slots[TOBITSHIFT(ITEM_SLOT_MASK) + 1])
		var/atom/movable/screen/inventory/inv = hud_used.inv_slots[TOBITSHIFT(ITEM_SLOT_MASK) + 1]
		inv.update_appearance()

	if(wear_mask)
		if(!(check_obscured_slots() & ITEM_SLOT_MASK))
			overlays_standing[FACEMASK_LAYER] = wear_mask.build_worn_icon(default_layer = FACEMASK_LAYER, default_icon_file = 'icons/mob/clothing/mask.dmi')
		update_hud_wear_mask(wear_mask)

	apply_overlay(FACEMASK_LAYER)

/mob/living/carbon/update_worn_neck()
	remove_overlay(NECK_LAYER)

	if(client && hud_used?.inv_slots[TOBITSHIFT(ITEM_SLOT_NECK) + 1])
		var/atom/movable/screen/inventory/inv = hud_used.inv_slots[TOBITSHIFT(ITEM_SLOT_NECK) + 1]
		inv.update_appearance()

	if(wear_neck)
		if(!(check_obscured_slots() & ITEM_SLOT_NECK))
			overlays_standing[NECK_LAYER] = wear_neck.build_worn_icon(default_layer = NECK_LAYER, default_icon_file = 'icons/mob/clothing/neck.dmi')
		update_hud_neck(wear_neck)

	apply_overlay(NECK_LAYER)

/mob/living/carbon/update_worn_back()
	remove_overlay(BACK_LAYER)

	if(client && hud_used?.inv_slots[TOBITSHIFT(ITEM_SLOT_BACK) + 1])
		var/atom/movable/screen/inventory/inv = hud_used.inv_slots[TOBITSHIFT(ITEM_SLOT_BACK) + 1]
		inv.update_appearance()

	if(back)
		overlays_standing[BACK_LAYER] = back.build_worn_icon(default_layer = BACK_LAYER, default_icon_file = 'icons/mob/clothing/back.dmi')
		update_hud_back(back)

	apply_overlay(BACK_LAYER)

/mob/living/carbon/update_worn_head()
	remove_overlay(HEAD_LAYER)

	if(!get_bodypart(BODY_ZONE_HEAD)) //Decapitated
		return

	if(client && hud_used?.inv_slots[TOBITSHIFT(ITEM_SLOT_BACK) + 1])
		var/atom/movable/screen/inventory/inv = hud_used.inv_slots[TOBITSHIFT(ITEM_SLOT_HEAD) + 1]
		inv.update_appearance()

	if(head)
		overlays_standing[HEAD_LAYER] = head.build_worn_icon(default_layer = HEAD_LAYER, default_icon_file = 'icons/mob/clothing/head.dmi')
		update_hud_head(head)

	apply_overlay(HEAD_LAYER)


/mob/living/carbon/update_worn_handcuffs()
	remove_overlay(HANDCUFF_LAYER)
	if(handcuffed)
		var/mutable_appearance/handcuff_overlay = mutable_appearance('icons/mob/simple/mob.dmi', "handcuff1", -HANDCUFF_LAYER)
		if(handcuffed.blocks_emissive)
			handcuff_overlay.overlays += emissive_blocker(handcuff_overlay.icon, handcuff_overlay.icon_state, alpha = handcuff_overlay.alpha)

		overlays_standing[HANDCUFF_LAYER] = handcuff_overlay
		apply_overlay(HANDCUFF_LAYER)


//mob HUD updates for items in our inventory

//update whether handcuffs appears on our hud.
/mob/living/carbon/proc/update_hud_handcuffed()
	if(hud_used)
		for(var/hand in hud_used.hand_slots)
			var/atom/movable/screen/inventory/hand/H = hud_used.hand_slots[hand]
			if(H)
				H.update_appearance()

//update whether our head item appears on our hud.
/mob/living/carbon/proc/update_hud_head(obj/item/I)
	return

//update whether our mask item appears on our hud.
/mob/living/carbon/proc/update_hud_wear_mask(obj/item/I)
	return

//update whether our neck item appears on our hud.
/mob/living/carbon/proc/update_hud_neck(obj/item/I)
	return

//update whether our back item appears on our hud.
/mob/living/carbon/proc/update_hud_back(obj/item/I)
	return



//Overlays for the worn overlay so you can overlay while you overlay
//eg: ammo counters, primed grenade flashing, etc.
//"icon_file" is used automatically for inhands etc. to make sure it gets the right inhand file
/obj/item/proc/worn_overlays(mutable_appearance/standing, isinhands = FALSE, icon_file)
	SHOULD_CALL_PARENT(TRUE)
	RETURN_TYPE(/list)

	. = list()
	if(blocks_emissive)
		. += emissive_blocker(standing.icon, standing.icon_state, src, alpha = standing.alpha)
	SEND_SIGNAL(src, COMSIG_ITEM_GET_WORN_OVERLAYS, ., standing, isinhands, icon_file)

///Checks to see if any bodyparts need to be redrawn, then does so. update_limb_data = TRUE redraws the limbs to conform to the owner.
/mob/living/carbon/proc/update_body_parts(update_limb_data)
	update_damage_overlays()
	update_wound_overlays()
	var/list/needs_update = list()
	var/limb_count_update = FALSE
	for(var/obj/item/bodypart/limb as anything in bodyparts)
		limb.update_limb(is_creating = update_limb_data) //Update limb actually doesn't do much, get_limb_icon is the cpu eater.

		var/old_key = icon_render_keys?[limb.body_zone] //Checks the mob's icon render key list for the bodypart
		icon_render_keys[limb.body_zone] = (limb.is_husked) ? limb.generate_husk_key().Join() : limb.generate_icon_key().Join() //Generates a key for the current bodypart

		if(icon_render_keys[limb.body_zone] != old_key || get_top_offset() != last_top_offset) //If the keys match, that means the limb doesn't need to be redrawn
			needs_update += limb

	var/list/missing_bodyparts = get_missing_limbs()
	if(((dna ? dna.species.max_bodypart_count : BODYPARTS_DEFAULT_MAXIMUM) - icon_render_keys.len) != missing_bodyparts.len) //Checks to see if the target gained or lost any limbs.
		limb_count_update = TRUE
		for(var/missing_limb in missing_bodyparts)
			icon_render_keys -= missing_limb //Removes dismembered limbs from the key list

	if(!needs_update.len && !limb_count_update)
		return

	//GENERATE NEW LIMBS
	var/list/new_limbs = list()
	for(var/obj/item/bodypart/limb as anything in bodyparts)
		if(limb in needs_update)
			var/bodypart_icon = limb.get_limb_icon()
			if(!istype(limb, /obj/item/bodypart/leg))
				var/top_offset = get_top_offset()
				for(var/image/image as anything in bodypart_icon)
					image.pixel_y += top_offset
			new_limbs += bodypart_icon
			limb_icon_cache[icon_render_keys[limb.body_zone]] = bodypart_icon //Caches the icon with the bodypart key, as it is new
		else
			new_limbs += limb_icon_cache[icon_render_keys[limb.body_zone]] //Pulls existing sprites from the cache
		last_top_offset = get_top_offset()


	remove_overlay(BODYPARTS_LAYER)

	if(new_limbs.len)
		overlays_standing[BODYPARTS_LAYER] = new_limbs

	apply_overlay(BODYPARTS_LAYER)

/// This looks at the chest and legs of the mob and decides how much our chest, arms, and head should be adjusted. This is useful for limbs that are larger or smaller than the scope of normal human height while keeping the feet anchored to the bottom of the tile
/mob/living/carbon/proc/get_top_offset()
	var/from_chest
	var/from_leg
	for(var/obj/item/bodypart/leg/leg_checked in bodyparts)
		if(leg_checked.top_offset > from_leg || isnull(from_leg)) // We find the tallest leg available
			from_leg = leg_checked.top_offset
	if(isnull(from_leg))
		from_leg = 0 // If we have no legs, we set this to zero to avoid any math issues that might stem from it being NULL
	for(var/obj/item/bodypart/chest/chest_checked in bodyparts) // Take the height from the chest
		from_chest = chest_checked.top_offset
	return (from_chest + from_leg) // The total hight of the chest and legs together

/////////////////////////
// Limb Icon Cache 2.0 //
/////////////////////////
/**
 * Called from update_body_parts() these procs handle the limb icon cache.
 * the limb icon cache adds an icon_render_key to a human mob, it represents:
 * - Gender, if applicable
 * - The ID of the limb
 * - Draw color, if applicable
 * These procs only store limbs as to increase the number of matching icon_render_keys
 * This cache exists because drawing 6/7 icons for humans constantly is quite a waste
 * See RemieRichards on irc.rizon.net #coderbus (RIP remie :sob:)
**/
/obj/item/bodypart/proc/generate_icon_key()
	RETURN_TYPE(/list)
	. = list()
	if(is_dimorphic)
		. += "[limb_gender]-"
	. += "[limb_id]"
	. += "-[body_zone]"
	if(should_draw_greyscale && draw_color)
		. += "-[draw_color]"
	if(is_invisible)
		. += "-invisible"
	for(var/datum/bodypart_overlay/overlay as anything in bodypart_overlays)
		if(!overlay.can_draw_on_bodypart(owner))
			continue
		. += "-[jointext(overlay.generate_icon_cache(), "-")]"

	return .

///Generates a cache key specifically for husks
/obj/item/bodypart/proc/generate_husk_key()
	RETURN_TYPE(/list)
	. = list()
	. += "[husk_type]"
	. += "-husk"
	. += "-[body_zone]"
	return .

/obj/item/bodypart/head/generate_icon_key()
	. = ..()
	. += "-[facial_hairstyle]"
	. += "-[facial_hair_color]"
	if(facial_hair_gradient_style)
		. += "-[facial_hair_gradient_style]"
		if(hair_gradient_color)
			. += "-[facial_hair_gradient_color]"
	if(facial_hair_hidden)
		. += "-FACIAL_HAIR_HIDDEN"
	if(show_debrained)
		. += "-SHOW_DEBRAINED"
		return .

	. += "-[hair_style]"
	. += "-[fixed_hair_color || override_hair_color || hair_color]"
	if(hair_gradient_style)
		. += "-[hair_gradient_style]"
		if(hair_gradient_color)
			. += "-[hair_gradient_color]"
	if(hair_hidden)
		. += "-HAIR_HIDDEN"

	return .

GLOBAL_LIST_EMPTY(masked_leg_icons_cache)

/**
 * This proc serves as a way to ensure that legs layer properly on a mob.
 * To do this, two separate images are created - A low layer one, and a normal layer one.
 * Each of the image will appropriately crop out dirs that are not used on that given layer.
 *
 * Arguments:
 * * limb_overlay - The limb image being masked, not necessarily the original limb image as it could be an overlay on top of it
 * * image_dir - Direction of the masked images.
 *
 * Returns the list of masked images, or `null` if the limb_overlay didn't exist
 */
/obj/item/bodypart/leg/proc/generate_masked_leg(mutable_appearance/limb_overlay, image_dir = NONE)
	RETURN_TYPE(/list)
	if(!limb_overlay)
		return
	. = list()

	var/icon_cache_key = "[limb_overlay.icon]-[limb_overlay.icon_state]-[body_zone]"
	var/icon/new_leg_icon
	var/icon/new_leg_icon_lower

	//in case we do not have a cached version of the two cropped icons for this key, we have to create it
	if(!GLOB.masked_leg_icons_cache[icon_cache_key])
		var/icon/leg_crop_mask = (body_zone == BODY_ZONE_R_LEG ? icon('icons/mob/leg_masks.dmi', "right_leg") : icon('icons/mob/leg_masks.dmi', "left_leg"))
		var/icon/leg_crop_mask_lower = (body_zone == BODY_ZONE_R_LEG ? icon('icons/mob/leg_masks.dmi', "right_leg_lower") : icon('icons/mob/leg_masks.dmi', "left_leg_lower"))

		new_leg_icon = icon(limb_overlay.icon, limb_overlay.icon_state)
		new_leg_icon.Blend(leg_crop_mask, ICON_MULTIPLY)

		new_leg_icon_lower = icon(limb_overlay.icon, limb_overlay.icon_state)
		new_leg_icon_lower.Blend(leg_crop_mask_lower, ICON_MULTIPLY)

		GLOB.masked_leg_icons_cache[icon_cache_key] = list(new_leg_icon, new_leg_icon_lower)
	new_leg_icon = GLOB.masked_leg_icons_cache[icon_cache_key][1]
	new_leg_icon_lower = GLOB.masked_leg_icons_cache[icon_cache_key][2]

	//this could break layering in oddjob cases, but i'm sure it will work fine most of the time... right?
	var/mutable_appearance/new_leg_appearance = new(limb_overlay)
	new_leg_appearance.icon = new_leg_icon
	new_leg_appearance.layer = -BODYPARTS_LAYER
	new_leg_appearance.dir = image_dir //for some reason, things do not work properly otherwise
	. += new_leg_appearance
	var/mutable_appearance/new_leg_appearance_lower = new(limb_overlay)
	new_leg_appearance_lower.icon = new_leg_icon_lower
	new_leg_appearance_lower.layer = -BODYPARTS_LOW_LAYER
	new_leg_appearance_lower.dir = image_dir
	. += new_leg_appearance_lower
	return .
