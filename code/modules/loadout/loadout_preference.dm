/datum/preference/loadout
	savefile_key = "loadout_list"
	savefile_identifier = PREFERENCE_CHARACTER
	can_randomize = FALSE

// Loadouts are applied with job equip code.
/datum/preference/loadout/apply_to_human(mob/living/carbon/human/target, value)
	return

/datum/preference/loadout/serialize(input, datum/preferences/preferences)
	// Sanitize on save even though it's highly unlikely this will need it
	return sanitize_loadout_list(input)

/datum/preference/loadout/deserialize(input, datum/preferences/preferences)
	// Sanitize on load to ensure no invalid paths from older saves get in
	// Pass in the prefernce owner so they can get feedback messages on stuff that failed to load (if they exist)
	return sanitize_loadout_list(input, preferences.parent?.mob)

// Default value is NULL - the loadout list is a lazylist
/datum/preference/loadout/create_default_value(datum/preferences/preferences)
	return null

/datum/preference/loadout/is_valid(value)
	return isnull(value) || islist(value)
