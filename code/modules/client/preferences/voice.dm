GLOBAL_LIST_INIT(emote_voices, list(
	EMOTE_VOICE_HUMAN_M,
	EMOTE_VOICE_HUMAN_F,
	EMOTE_VOICE_LIZARD_M,
	EMOTE_VOICE_LIZARD_F,
	EMOTE_VOICE_MOTH_M,
	EMOTE_VOICE_MOTH_F,
	EMOTE_VOICE_ETHEREAL_M,
	EMOTE_VOICE_ETHEREAL_F,
))

GLOBAL_LIST_INIT(say_voices, list(
	"Normal" = 'sound/voice/talksounds/say_normal.ogg',
	"Plain" = 'sound/voice/talksounds/say_plain.ogg',
	"Zoop" = 'sound/voice/talksounds/say_zoop.ogg',
	"Oop" = 'sound/voice/talksounds/say_oop.ogg',
	"Atonal" = 'sound/voice/talksounds/say_atonal.ogg',
))

GLOBAL_LIST_INIT(me_sounds, list(
	"A" = 'sound/voice/talksounds/me_a.ogg',
	"B" = 'sound/voice/talksounds/me_b.ogg',
	"C" = 'sound/voice/talksounds/me_c.ogg',
	"D" = 'sound/voice/talksounds/me_d.ogg',
	"E" = 'sound/voice/talksounds/me_e.ogg',
	"F" = 'sound/voice/talksounds/me_f.ogg',
))

/datum/preference/choiced/emote_voice
	category = PREFERENCE_CATEGORY_APPEARANCE_LIST
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "emote_voice"

/datum/preference/choiced/emote_voice/init_possible_values()
	return GLOB.emote_voices

/datum/preference/choiced/emote_voice/create_default_value()
	return pick(get_choices())

/datum/preference/choiced/emote_voice/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	target.dna.emote_voice_type = value

/datum/preference/choiced/say_voice
	category = PREFERENCE_CATEGORY_APPEARANCE_LIST
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "say_voice"

/datum/preference/choiced/say_voice/init_possible_values()
	return GLOB.say_voices

/datum/preference/choiced/say_voice/create_default_value()
	return pick(get_choices())

/datum/preference/choiced/say_voice/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	target.dna.say_voice_type = value

/datum/preference/choiced/me_sound
	category = PREFERENCE_CATEGORY_APPEARANCE_LIST
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "me_sound"

/datum/preference/choiced/me_sound/init_possible_values()
	return GLOB.me_sounds

/datum/preference/choiced/me_sound/create_default_value()
	return pick(get_choices())

/datum/preference/choiced/me_sound/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	target.dna.me_sound_type = value
