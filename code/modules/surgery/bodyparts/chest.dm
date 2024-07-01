/obj/item/bodypart/chest
	name = BODY_ZONE_CHEST
	desc = "It's impolite to stare at a person's chest."
	icon_state = "default_human_chest"
	max_damage = 200
	body_zone = BODY_ZONE_CHEST
	body_part = CHEST
	plaintext_zone = "chest"
	is_dimorphic = TRUE
	px_x = 0
	px_y = 0
	grind_results = null
	wound_resistance = 10
	bodypart_trait_source = CHEST_TRAIT
	///The bodytype(s) allowed to attach to this chest.
	var/acceptable_bodytype = BODYTYPE_HUMANOID

	var/obj/item/cavity_item

/obj/item/bodypart/chest/can_dismember(obj/item/item)
	if(owner.stat < HARD_CRIT || !get_organs())
		return FALSE
	return ..()

/obj/item/bodypart/chest/Destroy()
	QDEL_NULL(cavity_item)
	return ..()

/obj/item/bodypart/chest/drop_organs(mob/user, violent_removal)
	if(cavity_item)
		cavity_item.forceMove(drop_location())
		cavity_item = null
	return ..()

/obj/item/bodypart/chest/monkey
	icon = 'icons/mob/species/monkey/bodyparts.dmi'
	icon_static = 'icons/mob/species/monkey/bodyparts.dmi'
	icon_husk = 'icons/mob/species/monkey/bodyparts.dmi'
	husk_type = "monkey"
	top_offset = -5
	icon_state = "default_monkey_chest"
	limb_id = SPECIES_MONKEY
	should_draw_greyscale = FALSE
	is_dimorphic = FALSE
	wound_resistance = -10
	bodytype = BODYTYPE_MONKEY | BODYTYPE_ORGANIC
	acceptable_bodytype = BODYTYPE_HUMANOID
	dmg_overlay_type = SPECIES_MONKEY

/obj/item/bodypart/chest/alien
	icon = 'icons/mob/species/alien/bodyparts.dmi'
	icon_static = 'icons/mob/species/alien/bodyparts.dmi'
	icon_state = "alien_chest"
	limb_id = BODYPART_ID_ALIEN
	bodytype = BODYTYPE_HUMANOID | BODYTYPE_ALIEN | BODYTYPE_ORGANIC
	is_dimorphic = FALSE
	should_draw_greyscale = FALSE
	bodypart_flags = BODYPART_UNREMOVABLE
	max_damage = 500
	acceptable_bodytype = BODYTYPE_HUMANOID

/obj/item/bodypart/chest/larva
	icon = 'icons/mob/species/alien/bodyparts.dmi'
	icon_static = 'icons/mob/species/alien/bodyparts.dmi'
	icon_state = "larva_chest"
	limb_id = BODYPART_ID_LARVA
	is_dimorphic = FALSE
	should_draw_greyscale = FALSE
	bodypart_flags = BODYPART_UNREMOVABLE
	max_damage = 50
	bodytype = BODYTYPE_LARVA_PLACEHOLDER | BODYTYPE_ORGANIC
	acceptable_bodytype = BODYTYPE_LARVA_PLACEHOLDER
