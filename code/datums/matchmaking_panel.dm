GLOBAL_LIST_EMPTY(matchmaking_other_players)

GLOBAL_DATUM_INIT(matchmaking_panel, /datum/matchmaking_panel, new)

/datum/matchmaking_panel
	/// Set this var if you want to load someone's data on next open. Use the \ref macro. Open the UI immediately after setting.
	var/ref_to_load

/datum/matchmaking_panel/ui_state(mob/user)
	return GLOB.always_state

/datum/matchmaking_panel/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "MatchmakingPanel")
		ui.open()

/datum/matchmaking_panel/ui_data(mob/user)
	return list(
		"is_victim" = user.client.prefs.read_preference(/datum/preference/toggle/be_victim) ? "Yes" : "No",
		"erp_status" = user.client.prefs.read_preference(/datum/preference/choiced/content/erp_status),
	)

/datum/matchmaking_panel/ui_static_data(mob/user)
	return list(
		"other_players" = get_other_players()
	)

/datum/matchmaking_panel/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()

	switch(action)
		if("refresh") // This is highly unlikely to lag the server, but you never know.
			if(TIMER_COOLDOWN_CHECK(ui.user, COOLDOWN_MATCHMAKING_PANEL_REFRESH))
				to_chat(ui.user, span_warning("You have to wait 5 seconds between each refresh!"))
				return

			update_static_data(ui.user, ui)
			TIMER_COOLDOWN_START(ui.user, COOLDOWN_MATCHMAKING_PANEL_REFRESH, 5 SECONDS)

		if("toggle_victim_status")
			ui.user.client.prefs.write_preference(GLOB.preference_entries[/datum/preference/toggle/be_victim], !ui.user.client.prefs.read_preference(/datum/preference/toggle/be_victim))

/datum/matchmaking_panel/proc/get_other_players()
	var/list/directory_mobs = list()
	for(var/client/client in GLOB.clients)
		if(!isliving(client.mob))
			continue

		// These are the three vars we're trying to find
		// The approach differs based on the mob the client is controlling
		var/name = null
		var/species = null
		var/flavor_text = null

		if(ishuman(client.mob))
			var/mob/living/carbon/human/human = client.mob
			if(!find_record("name", human.real_name, GLOB.data_core.general))
				continue
			name = human.real_name
			species = human.dna.species.name
			flavor_text = human.dna.inspection_text["broad"]

		if(isAI(client.mob))
			var/mob/living/silicon/ai/ai = client.mob
			name = ai.name
			species = "Artificial Intelligence"
			flavor_text = "AI flavour text here"

		if(iscyborg(client.mob))
			var/mob/living/silicon/robot/cyborg = client.mob
			if(cyborg.scrambledcodes || (cyborg.model && cyborg.model.hidden_from_matchmaking))
				continue
			name = cyborg.name
			species = "[cyborg.model.name] [cyborg.braintype]"
			flavor_text = "Borg flavour text here"

		if(!name)
			continue

		directory_mobs += list(list(
			"name" = name,
			"ref" = "\ref[client.mob]",
			"species" = species,
			"ooc_notes" = client.prefs.read_preference(/datum/preference/text/inspection/ooc_notes),
			"is_victim" = client.prefs.read_preference(/datum/preference/toggle/be_victim) ? "Yes" : "No",
			"erp_status" = client.prefs.read_preference(/datum/preference/choiced/content/erp_status),
			"erp_orientation" = client.prefs.read_preference(/datum/preference/choiced/content/erp_orientation),
			"erp_position" = client.prefs.read_preference(/datum/preference/choiced/content/erp_position),
			"erp_non_con" = client.prefs.read_preference(/datum/preference/choiced/content/erp_non_con),
			"brainwashing" = client.prefs.read_preference(/datum/preference/choiced/content/brainwashing),
			"borging" = client.prefs.read_preference(/datum/preference/choiced/content/borging),
			"kidnapping" = client.prefs.read_preference(/datum/preference/choiced/content/kidnapping),
			"isolation" = client.prefs.read_preference(/datum/preference/choiced/content/isolation),
			"torture" = client.prefs.read_preference(/datum/preference/choiced/content/torture),
			"death" = client.prefs.read_preference(/datum/preference/choiced/content/death),
			"round_removal" = client.prefs.read_preference(/datum/preference/choiced/content/round_removal),
			"flavor_text" = flavor_text,
		))
	return directory_mobs
