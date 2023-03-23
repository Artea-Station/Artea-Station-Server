
/datum/preference/toggle/be_victim
	category = PREFERENCE_CATEGORY_CONTENT_LIST
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "be_victim"
	default_value = TRUE

/datum/preference/toggle/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	return

/datum/preference/choiced/content
	category = PREFERENCE_CATEGORY_CONTENT_LIST
	savefile_identifier = PREFERENCE_CHARACTER

/datum/preference/choiced/content/erp_status
	savefile_key = "erp_status"

/datum/preference/choiced/content/erp_status/init_possible_values()
	return list(
		"Yes",
		"Yes - Dom",
		"Yes - Dom Lean",
		"Yes - Switch",
		"Yes - Sub Lean",
		"Yes - Sub Only",
		"Check OOC Notes",
		"No",
	)

/datum/preference/choiced/content/erp_status/create_default_value()
	return "No"
