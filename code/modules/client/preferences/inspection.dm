// Preferences related to inspection text.

/// Base inspection pref datum. Handles heavy lifting for applying inspection text to limbs.
/datum/preference/text/inspection
	category = PREFERENCE_CATEGORY_INSPECTION_LIST
	savefile_identifier = PREFERENCE_CHARACTER
	abstract_type = /datum/preference/text/inspection

	/// Bodypart to apply text to.
	var/bodypart

/datum/preference/text/inspection/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	if(bodypart)
		target.dna.inspection_text[bodypart] = value

/datum/preference/text/inspection/broad
	savefile_key = "broad_inspection_text"
	bodypart = "broad"

/datum/preference/text/inspection/ooc_notes
	savefile_key = "ooc_notes"
