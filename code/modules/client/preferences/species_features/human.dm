// """human""" mutant parts.

/datum/preference/choiced/mutant/tail_human
	savefile_key = "feature_human_tail"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_APPEARANCE
	can_randomize = FALSE
	relevant_mutant_bodypart = MUTANT_TAIL
	should_generate_icons = TRUE
	greyscale_color = "#643f0e"
	main_feature_name = "Tail"
	color_feature_id = "tail_human_color"

MUTANT_CHOICED_NEW(tail_human, GLOB.tails_list)

/datum/preference/choiced/mutant/tail_human/generate_icon_state(datum/sprite_accessory/sprite_accessory, original_icon_state, suffix)

	if(icon_exists(sprite_accessory.icon, "m_tail_lizard_[original_icon_state]_FRONT[suffix]"))
		return "m_tail_lizard_[original_icon_state]_FRONT[suffix]"

	return "m_tail_[original_icon_state]_FRONT[suffix]"

/datum/preference/color/mutant/tail_human
	savefile_key = "tail_human_color"
	relevant_mutant_bodypart = MUTANT_TAIL
	choiced_preference_datum = /datum/preference/choiced/mutant/tail_human

/datum/preference/choiced/mutant/ears
	savefile_key = "feature_human_ears"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_APPEARANCE
	can_randomize = FALSE
	relevant_mutant_bodypart = "ears"
	should_generate_icons = TRUE
	greyscale_color = "#643f0e"
	main_feature_name = "Ears"
	color_feature_id = "ears_color"

MUTANT_CHOICED_NEW(ears, GLOB.ears_list)

/datum/preference/choiced/mutant/ears/generate_icon_state(datum/sprite_accessory/sprite_accessory, original_icon_state, suffix)
	return "m_ears_[original_icon_state]_FRONT[suffix]"

/datum/preference/color/mutant/ears
	savefile_key = "ears_color"
	relevant_mutant_bodypart = MUTANT_EARS
	choiced_preference_datum = /datum/preference/choiced/mutant/ears

/datum/preference/choiced/mutant/horns
	savefile_key = "feature_horns"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_APPEARANCE
	main_feature_name = "Horns"
	should_generate_icons = TRUE
	greyscale_color = COLOR_ASSEMBLY_BROWN
	color_feature_id = "horns_color"

MUTANT_CHOICED_NEW(horns, GLOB.horns_list)

/datum/preference/choiced/mutant/horns/generate_icon_state(datum/sprite_accessory/sprite_accessory, original_icon_state, suffix)

	if(icon_exists(sprite_accessory.icon, "m_horns_[original_icon_state]_FRONT[suffix]"))
		return "m_horns_[original_icon_state]_FRONT[suffix]"

	return "m_horns_[original_icon_state]_ADJ[suffix]"

/datum/preference/color/mutant/horns
	savefile_key = "horns_color"
	relevant_mutant_bodypart = MUTANT_HORNS
	choiced_preference_datum = /datum/preference/choiced/mutant/horns
