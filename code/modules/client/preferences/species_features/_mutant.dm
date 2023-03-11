
/datum/preference/choiced/mutant
	category = PREFERENCE_CATEGORY_APPEARANCE
	should_generate_icons = TRUE
	/// The ID to use for supplemental features. If null, it won't do anything.
	var/color_feature_id
	/// The global list containing the sprite accessories to use.
	var/list/sprite_accessory

/datum/preference/choiced/mutant/create_default_value()
	return "None"

/datum/preference/choiced/mutant/init_possible_values()
	return generate_mutant_valid_values(sprite_accessory, generate_empty = TRUE)

/datum/preference/choiced/mutant/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	if(is_accessible(preferences))
		target.dna.features["[relevant_mutant_bodypart]"] = value

/datum/preference/choiced/mutant/is_accessible(datum/preferences/preferences)
	. = ..()
	var/datum/species/species = preferences.read_preference(/datum/preference/choiced/species)
	species = new species
	if(relevant_mutant_bodypart in species.mutant_bodyparts) // Sadly, hair opacity doesn't work on species without hair, so let's skip the confusion.
		return TRUE

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
