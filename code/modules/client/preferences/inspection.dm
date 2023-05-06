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

/datum/preference/text/inspection/preview
	savefile_key = "preview_inspection_text"
	bodypart = BODY_ZONE_PREVIEW
	maximum_value_length = 128

/datum/preference/text/inspection/broad
	savefile_key = "broad_inspection_text"
	bodypart = BODY_ZONE_BROAD

/datum/preference/text/inspection/face
	savefile_key = "face_inspection_text"
	bodypart = BODY_ZONE_PRECISE_EYES

/datum/preference/text/inspection/head
	savefile_key = "head_inspection_text"
	bodypart = BODY_ZONE_HEAD

/datum/preference/text/inspection/body
	savefile_key = "body_inspection_text"
	bodypart = BODY_ZONE_CHEST

/datum/preference/text/inspection/arms
	savefile_key = "arms_inspection_text"
	bodypart = BODY_ZONE_ARMS

/datum/preference/text/inspection/legs
	savefile_key = "legs_inspection_text"
	bodypart = BODY_ZONE_LEGS

/datum/preference/text/inspection/ooc_notes
	category = PREFERENCE_CATEGORY_OOC_LIST
	savefile_key = "ooc_notes"
