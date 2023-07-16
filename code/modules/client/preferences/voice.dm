/datum/preference/choiced/voice
	category = PREFERENCE_CATEGORY_APPEARANCE_LIST
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "voice"

/datum/preference/choiced/voice/init_possible_values()
	return list(
		VOICE_HUMAN_M,
		VOICE_HUMAN_F,
		VOICE_LIZARD_M,
		VOICE_LIZARD_F,
		VOICE_MOTH_M,
		VOICE_MOTH_F,
		VOICE_ETHEREAL_M,
		VOICE_ETHEREAL_F,
	)

/datum/preference/choiced/voice/create_default_value()
	return pick(get_choices())

/datum/preference/choiced/voice/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	target.dna.voice_type = value
