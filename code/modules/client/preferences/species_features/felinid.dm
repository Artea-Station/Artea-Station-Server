/datum/preference/choiced/tail_human
	savefile_key = "feature_human_tail"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_APPEARANCE
	can_randomize = FALSE
	relevant_mutant_bodypart = "tail"
	should_generate_icons = TRUE
	greyscale_color = "#643f0e"
	main_feature_name = "Tail"

/datum/preference/choiced/tail_human/generate_icon_state(datum/sprite_accessory/sprite_accessory, original_icon_state)
	return "m_tail_[original_icon_state]_FRONT"

/datum/preference/choiced/tail_human/init_possible_values()
	var/list/tails = list()

	for(var/key in GLOB.tails_list_human)
		if(!key)
			continue
		if(key == "None")
			tails[key] = icon('icons/mob/landmarks.dmi', "x")
			continue
		tails[key] = generate_icon(GLOB.tails_list_human[key], NORTH)

	return tails

/datum/preference/choiced/tail_human/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	if(is_accessible(preferences))
		target.dna.features["tail"] = value

/datum/preference/choiced/tail_human/create_default_value()
	return "None"

/datum/preference/choiced/ears
	savefile_key = "feature_human_ears"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_APPEARANCE
	can_randomize = FALSE
	relevant_mutant_bodypart = "ears"
	should_generate_icons = TRUE
	greyscale_color = "#643f0e"
	main_feature_name = "Ears"

/datum/preference/choiced/ears/generate_icon_state(datum/sprite_accessory/sprite_accessory, original_icon_state)
	return "m_ears_[original_icon_state]_FRONT"

/datum/preference/choiced/ears/init_possible_values()
	var/list/ears = list()

	for(var/key in GLOB.ears_list)
		if(!key)
			continue
		if(key == "None")
			ears[key] = icon('icons/mob/landmarks.dmi', "x")
			continue
		ears[key] = generate_icon(GLOB.ears_list[key])

	return ears

/datum/preference/choiced/ears/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	if(is_accessible(preferences))
		target.dna.features["ears"] = value

/datum/preference/choiced/ears/create_default_value()
	var/datum/sprite_accessory/ears/cat/ears = /datum/sprite_accessory/ears/cat
	return initial(ears.name)
