
/datum/preference/choiced/mutant
	category = PREFERENCE_CATEGORY_APPEARANCE
	should_generate_icons = TRUE
	/// The ID to use for supplemental features. If null, it won't do anything.
	var/color_feature_id
	/// The bodypart path to use the subtypes of when generating values.
	var/sprite_accessory

/datum/preference/choiced/mutant/create_default_value()
	return "None"

/datum/preference/choiced/mutant/synth_head/init_possible_values()
	return generate_mutant_valid_values(sprite_accessory, generate_empty = TRUE)

/datum/preference/choiced/mutant/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	if(is_accessible(preferences))
		target.dna.features["[relevant_mutant_bodypart]"] = value

/datum/preference/choiced/mutant/compile_constant_data()
	. = ..()
	if(color_feature_id)
		.[SUPPLEMENTAL_FEATURE_KEY] = color_feature_id

/datum/preference/color/mutant
	category = PREFERENCE_CATEGORY_SUPPLEMENTAL_FEATURES
	savefile_identifier = PREFERENCE_CHARACTER

// Mutant color. Used to automagically apply a color to a mutant part. Very nice.
/datum/preference/color/mutant/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	if(is_accessible(preferences))
		target.dna.features["[relevant_mutant_bodypart]_color"] = value
