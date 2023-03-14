/datum/preference/toggle/hair_opacity
	category = PREFERENCE_CATEGORY_APPEARANCE_LIST
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "feature_hair_opacity_toggle"
	default_value = FALSE

/datum/preference/toggle/hair_opacity/is_accessible(datum/preferences/preferences)
	. = ..()
	var/datum/species/species = preferences.read_preference(/datum/preference/choiced/species)
	species = new species
	if(HAIR in species.species_traits) // Sadly, hair opacity doesn't work on species without hair, so let's skip the confusion.
		return TRUE

/datum/preference/toggle/hair_opacity/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	return

/datum/preference/numeric/hair_opacity
	category = PREFERENCE_CATEGORY_APPEARANCE_LIST
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "feature_hair_opacity"
	maximum = 255
	minimum = 40 // Any lower, and hair's borderline invisible on lighter colours.

/datum/preference/numeric/hair_opacity/create_default_value()
	return maximum

/datum/preference/numeric/hair_opacity/is_accessible(datum/preferences/preferences)
	..()
	if(!preferences)
		return FALSE
	var/datum/species/species = preferences.read_preference(/datum/preference/choiced/species)
	if(!species)
		return FALSE // Fuck knows why this would be null, but I'm not risking it.
	species = new species
	return (HAIR in species.species_traits) && preferences.read_preference(/datum/preference/toggle/hair_opacity)

/datum/preference/numeric/hair_opacity/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	if(!preferences || !is_accessible(preferences))
		return FALSE

	target.hair_alpha = value
	return TRUE
