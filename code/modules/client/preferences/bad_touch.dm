#define DEFAULT_BAD_TOUCH_MESSAGE " seems to really dislike being touched!"


/datum/preference/text/bad_touch_message
	savefile_key = "bad_touch_message"
	category = PREFERENCE_CATEGORY_MISC_LIST
	savefile_identifier = PREFERENCE_CHARACTER
	maximum_value_length = CHAT_MESSAGE_MAX_LENGTH

/datum/preference/text/bad_touch_message/is_accessible(datum/preferences/preferences)
	..()
	return "Bad Touch" in preferences.all_quirks

/datum/preference/text/bad_touch_message/create_default_value()
	return DEFAULT_BAD_TOUCH_MESSAGE

/datum/preference/text/bad_touch_message/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	return FALSE

#undef DEFAULT_BAD_TOUCH_MESSAGE
