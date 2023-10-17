/datum/preference/choiced/lizard_body_markings
	savefile_key = "feature_lizard_body_markings"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_APPEARANCE
	main_feature_name = "Body markings"
	should_generate_icons = TRUE
	relevant_mutant_bodypart = "body_markings"

/datum/preference/choiced/lizard_body_markings/init_possible_values()
	var/list/values = list()

	var/icon/lizard = icon('icons/mob/species/lizard/bodyparts.dmi', "lizard_chest_m")

	for (var/name in GLOB.body_markings_list)
		var/datum/sprite_accessory/sprite_accessory = GLOB.body_markings_list[name]

		var/icon/final_icon = icon(lizard)

		if (sprite_accessory.icon_state != "none")
			var/icon/body_markings_icon = icon(
				'icons/mob/species/lizard/lizard_misc.dmi',
				"m_body_markings_[sprite_accessory.icon_state]_ADJ",
			)

			final_icon.Blend(body_markings_icon, ICON_OVERLAY)

		final_icon.Blend(COLOR_VIBRANT_LIME, ICON_MULTIPLY)
		final_icon.Crop(10, 8, 22, 23)
		final_icon.Scale(26, 32)
		final_icon.Crop(-2, 1, 29, 32)

		values[name] = final_icon

	return values

/datum/preference/choiced/lizard_body_markings/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	target.dna.features["body_markings"] = value

/datum/preference/choiced/mutant/lizard_frills
	savefile_key = "feature_lizard_frills"
	main_feature_name = "Frills"
	relevant_mutant_bodypart = MUTANT_FRILLS
	should_generate_icons = TRUE
	color_feature_id = "lizard_frills_color"
	organ_to_add = /obj/item/organ/external/frills
	sprite_direction = EAST
	greyscale_color = COLOR_VIBRANT_LIME
	crop_area = list(11, 22, 21, 32) // We want just the head.

MUTANT_CHOICED_NEW(lizard_frills, GLOB.frills_list)

/datum/preference/choiced/mutant/lizard_frills/generate_icon_state(datum/sprite_accessory/sprite_accessory, original_icon_state, suffix)
	return "m_frills_[original_icon_state]_ADJ[suffix]"

/datum/preference/color/mutant/lizard_frills
	savefile_key = "lizard_frills_color"
	relevant_mutant_bodypart = MUTANT_FRILLS
	choiced_preference_datum = /datum/preference/choiced/mutant/lizard_frills

/datum/preference/choiced/lizard_legs
	savefile_key = "feature_lizard_legs"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_APPEARANCE_LIST
	relevant_mutant_bodypart = "legs"

/datum/preference/choiced/lizard_legs/is_accessible(datum/preferences/preferences)
	if(ispath(preferences?.read_preference(/datum/preference/choiced/species), /datum/species/synthetic))
		var/datum/sprite_accessory/synth_chassis/chassis = GLOB.synth_chassi[preferences.read_preference(/datum/preference/choiced/mutant/synth_chassis)]
		if(chassis)
			return initial(chassis.is_digi_compatible)

	return ..()

/datum/preference/choiced/lizard_legs/init_possible_values()
	return assoc_to_keys(GLOB.legs_list)

/datum/preference/choiced/lizard_legs/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	target.dna.features["legs"] = value

/datum/preference/choiced/mutant/lizard_snout
	savefile_key = "feature_lizard_snout"
	main_feature_name = "Snout"
	should_generate_icons = TRUE
	relevant_mutant_bodypart = MUTANT_SNOUT
	color_feature_id = "lizard_snout_color"
	organ_to_add = /obj/item/organ/external/snout
	sprite_direction = EAST
	greyscale_color = COLOR_VIBRANT_LIME
	crop_area = list(14, 22, 24, 32) // We want just the head.

MUTANT_CHOICED_NEW(lizard_snout, GLOB.snouts_list)

/datum/preference/choiced/mutant/lizard_snout/generate_icon_state(datum/sprite_accessory/sprite_accessory, original_icon_state, suffix)
	return "m_snout_[original_icon_state]_ADJ[suffix]"

/datum/preference/choiced/mutant/lizard_snout/create_default_value()
	return pick(sprite_accessory)

/datum/preference/color/mutant/lizard_snout
	savefile_key = "lizard_snout_color"
	relevant_mutant_bodypart = MUTANT_SNOUT
	choiced_preference_datum = /datum/preference/choiced/mutant/lizard_snout

/datum/preference/choiced/lizard_spines
	savefile_key = "feature_lizard_spines"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_APPEARANCE_LIST
	relevant_mutant_bodypart = "spines"

/datum/preference/choiced/lizard_spines/init_possible_values()
	return assoc_to_keys(GLOB.spines_list)

/datum/preference/choiced/lizard_spines/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	target.dna.features["spines"] = value

/datum/preference/choiced/lizard_tail
	savefile_key = "feature_lizard_tail"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_APPEARANCE_LIST
	relevant_external_organ = /obj/item/organ/external/tail/lizard

/datum/preference/choiced/lizard_tail/init_possible_values()
	return assoc_to_keys(GLOB.tails_list_lizard)

/datum/preference/choiced/lizard_tail/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	target.dna.features["tail_lizard"] = value

/datum/preference/choiced/lizard_tail/create_default_value()
	var/datum/sprite_accessory/tails/lizard/smooth/tail = /datum/sprite_accessory/tails/lizard/smooth
	return initial(tail.name)
