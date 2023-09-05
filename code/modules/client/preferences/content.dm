
/datum/preference/toggle/be_victim
	category = PREFERENCE_CATEGORY_CONTENT_LIST
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "be_victim"
	default_value = TRUE

/datum/preference/toggle/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	return

/// Base preference datum for content preferences. All it does is skip applying to character, as these prefs should always be read from file.
/datum/preference/choiced/content
	category = PREFERENCE_CATEGORY_CONTENT_LIST
	savefile_identifier = PREFERENCE_CHARACTER
	abstract_type = /datum/preference/choiced/content

	/// The default value for this pref
	var/default_value

/datum/preference/choiced/content/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	return

/datum/preference/choiced/content/create_default_value()
	if(!default_value)
		CRASH("No default value set for [type]!")
	return default_value

/datum/preference/choiced/content/death
	savefile_key = "content_death"
	default_value = "Unset"

/datum/preference/choiced/content/death/init_possible_values()
	return list(
		"Liked",
		"Yes",
		"Prefer Not",
		"Unset",
	)

/datum/preference/choiced/content/brainwashing
	savefile_key = "content_brainwashing"
	default_value = "Unset"

/datum/preference/choiced/content/brainwashing/init_possible_values()
	return list(
		"Liked",
		"Yes",
		"Prefer Not",
		"No",
		"Unset",
	)

/datum/preference/choiced/content/torture
	savefile_key = "content_torture"
	default_value = "Unset"

/datum/preference/choiced/content/torture/init_possible_values()
	return list(
		"Liked",
		"Yes",
		"Prefer Not",
		"No",
		"Unset",
	)

/datum/preference/choiced/content/isolation
	savefile_key = "content_isolation"
	default_value = "Unset"

/datum/preference/choiced/content/isolation/init_possible_values()
	return list(
		"Liked",
		"Yes",
		"Prefer Not",
		"No",
		"Unset",
	)

/datum/preference/choiced/content/kidnapping
	savefile_key = "content_kidnapping"
	default_value = "Unset"

/datum/preference/choiced/content/kidnapping/init_possible_values()
	return list(
		"Liked",
		"Yes",
		"Prefer Not",
		"No",
		"Unset",
	)

/datum/preference/choiced/content/borging
	savefile_key = "content_borging"
	default_value = "Unset"

/datum/preference/choiced/content/borging/init_possible_values()
	return list(
		"Liked",
		"Yes",
		"Prefer Not",
		"No",
		"Unset",
	)

/datum/preference/choiced/content/round_removal
	savefile_key = "content_round_removal"
	default_value = "Unset"

/datum/preference/choiced/content/round_removal/init_possible_values()
	return list(
		"Liked",
		"Yes",
		"Prefer Not",
		"No",
		"Unset",
	)

/datum/preference/choiced/content/erp_status
	savefile_key = "erp_status"
	default_value = "No"

/datum/preference/choiced/content/erp_status/init_possible_values()
	return list(
		"No",
		"Check OOC Notes",
		"Yes",
		"Yes - Dom",
		"Yes - Dom Lean",
		"Yes - Switch",
		"Yes - Sub Lean",
		"Yes - Sub",
	)
