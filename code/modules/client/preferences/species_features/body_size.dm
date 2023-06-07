/datum/preference/numeric/body_height
	category = PREFERENCE_CATEGORY_APPEARANCE_LIST
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "body_height"
	minimum = MOB_SCALE_HEIGHT_MIN
	maximum = MOB_SCALE_HEIGHT_MAX

/datum/preference/numeric/body_height/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["body_height"] = value

/datum/preference/numeric/body_height/create_default_value()
	return MOB_SCALE_NORMAL

/datum/preference/numeric/body_width
	category = PREFERENCE_CATEGORY_APPEARANCE_LIST
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "body_width"
	minimum = MOB_SCALE_WIDTH_MIN
	maximum = MOB_SCALE_WIDTH_MAX

/datum/preference/numeric/body_width/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["body_width"] = value

/datum/preference/numeric/body_width/create_default_value()
	return MOB_SCALE_NORMAL
