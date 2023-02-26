/datum/sprite_accessory/ears
	icon = 'icons/mob/species/mutant_bodyparts.dmi'
	em_block = TRUE

/datum/sprite_accessory/ears/none
	name = "Default"
	icon_state = "none"
	organ_type_to_use = /obj/item/organ/internal/ears

/datum/sprite_accessory/ears/cat
	name = "Cat"
	icon_state = "cat"
	hasinner = 1
	color_src = HAIR
	organ_type_to_use = /obj/item/organ/internal/ears/cat
