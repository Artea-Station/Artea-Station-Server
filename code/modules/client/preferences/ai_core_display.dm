/// What to show on the AI screen
/datum/preference/choiced/ai_core_display
	category = PREFERENCE_CATEGORY_MISC_LIST
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "preferred_ai_core_display"
	should_generate_icons = TRUE

/datum/preference/choiced/ai_core_display/init_possible_values()
	var/list/values = list()

	values["Random"] = icon('icons/mob/silicon/ai.dmi', "ai-empty")

	for (var/screen in GLOB.ai_core_display_screens - "Portrait" - "Random")
		values[screen] = icon('icons/mob/silicon/ai.dmi', resolve_ai_icon_sync(screen))

	return values

/datum/preference/choiced/ai_core_display/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	return
