/// Which crime is the prisoner permabrigged for. For fluff!
/datum/preference/choiced/prisoner_crime
	category = PREFERENCE_CATEGORY_MISC_LIST
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "prisoner_crime"

/datum/preference/choiced/prisoner_crime/init_possible_values()
	return assoc_to_keys(GLOB.prisoner_crimes) + "Random"

/datum/preference/choiced/prisoner_crime/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	return

/datum/preference/choiced/prisoner_crime/create_default_value()
	return "Random"
