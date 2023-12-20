// """human""" mutant parts.

/datum/preference/choiced/mutant/tail_human
	savefile_key = "feature_human_tail"
	relevant_mutant_bodypart = MUTANT_TAIL
	greyscale_color = COLOR_DARK_BROWN
	main_feature_name = "Tail"
	color_feature_id = "tail_human_color"
	sprite_direction = NORTH
	accessories_to_ignore = list(/datum/sprite_accessory/tails/lizard)

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
	relevant_mutant_bodypart = MUTANT_EARS
	greyscale_color = COLOR_DARK_BROWN
	main_feature_name = "Ears"
	color_feature_id = "ears_color"
	crop_area = list(11, 22, 21, 32) // We want just the head area.

MUTANT_CHOICED_NEW(ears, GLOB.ears_list)

/datum/preference/choiced/mutant/ears/generate_icon_state(datum/sprite_accessory/sprite_accessory, original_icon_state, suffix)

	if(icon_exists(sprite_accessory.icon, "m_ears_[original_icon_state]_ADJ[suffix]") && !findtext(sprite_accessory.icon_state, "bigwolf")) // Look, don't judge me, this was the easiest way to do it, and I've been dealing with fucking ear code for nearly 4 hours now - Rimi
		return "m_ears_[original_icon_state]_ADJ[suffix]"

	return "m_ears_[original_icon_state]_FRONT[suffix]"

/datum/preference/color/mutant/ears
	savefile_key = "ears_color"
	relevant_mutant_bodypart = MUTANT_EARS
	choiced_preference_datum = /datum/preference/choiced/mutant/ears

/datum/preference/choiced/mutant/horns
	savefile_key = "feature_horns"
	relevant_mutant_bodypart = MUTANT_HORNS
	greyscale_color = COLOR_DARK_BROWN
	main_feature_name = "Horns"
	color_feature_id = "horns_color"
	crop_area = list(11, 22, 21, 32) // We want just the head area.

MUTANT_CHOICED_NEW(horns, GLOB.horns_list)

/datum/preference/choiced/mutant/horns/generate_icon_state(datum/sprite_accessory/sprite_accessory, original_icon_state, suffix)

	if(icon_exists(sprite_accessory.icon, "m_horns_[original_icon_state]_FRONT[suffix]"))
		return "m_horns_[original_icon_state]_FRONT[suffix]"

	return "m_horns_[original_icon_state]_ADJ[suffix]"

/datum/preference/color/mutant/horns/is_accessible(datum/preferences/preferences)
	. = ..()
	if(. || !preferences)
		return

	return preferences.read_preference(/datum/preference/choiced/species) == /datum/species/lizard

/datum/preference/color/mutant/horns
	savefile_key = "horns_color"
	relevant_mutant_bodypart = MUTANT_HORNS
	choiced_preference_datum = /datum/preference/choiced/mutant/horns
