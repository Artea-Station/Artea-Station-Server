/datum/preference/choiced/tail_human
	savefile_key = "feature_human_tail"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_APPEARANCE
	can_randomize = FALSE
	relevant_external_organ = /obj/item/organ/external/tail/cat
	should_generate_icons = TRUE
	greyscale_color = "#643f0e"

/datum/preference/choiced/tail_human/init_possible_values()
	. = list()
	for(var/datum/sprite_accessory/tails/tail in GLOB.tails_list)
		.[tail.name] = generate_icon(tail)

/datum/preference/choiced/tail_human/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["tail"] = value

/datum/preference/choiced/tail_human/create_default_value()
	return "None"

/datum/preference/choiced/ears
	savefile_key = "feature_human_ears"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_APPEARANCE
	can_randomize = FALSE
	relevant_mutant_bodypart = "ears"

/datum/preference/choiced/ears/init_possible_values()
	return assoc_to_keys(GLOB.ears_list)

/datum/preference/choiced/ears/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["ears"] = value

/datum/preference/choiced/ears/create_default_value()
	var/datum/sprite_accessory/ears/cat/ears = /datum/sprite_accessory/ears/cat
	return initial(ears.name)
