GLOBAL_LIST_EMPTY(matchmaking_other_players)

GLOBAL_DATUM_INIT(matchmaking_panel, /datum/matchmaking_panel, new)

/datum/matchmaking_panel

/datum/matchmaking_panel/ui_state(mob/user)
	return GLOB.always_state

/datum/matchmaking_panel/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "MatchmakingPanel")
		ui.open()

/datum/matchmaking_panel/ui_static_data(mob/user)
	return list(
		"other_players" = get_other_players()
	)

/datum/matchmaking_panel/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()

	switch(action)
		if("refresh")
			update_static_data(ui.user, ui)

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

		directory_mobs.Add(list(list(
			"name" = name,
			"species" = species,
			"ooc_notes" = client.prefs.read_preference(/datum/preference/text/inspection/ooc_notes),
			"is_victim" = client.prefs.read_preference(/datum/preference/toggle/be_victim),
			"erp_status" = client.prefs.read_preference(/datum/preference/choiced/content/erp_status),
			"flavor_text" = flavor_text,
		)))
