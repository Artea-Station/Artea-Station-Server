/datum/inspection_panel
	/// Mob that the examine panel belongs to.
	var/mob/living/holder

/datum/inspection_panel/ui_state(mob/user)
	return GLOB.physical_obscured_no_close_state

/datum/inspection_panel/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "InspectionPanel")
		ui.open()

/datum/inspection_panel/ui_data(mob/user)
	if(!ishuman(holder))
		return

	var/list/inspection_data = list()
	var/mob/living/carbon/human/human = holder
	var/is_observer = isobserver(user)

	for(var/zone in list(BODY_ZONE_BROAD, BODY_ZONE_PRECISE_EYES, BODY_ZONE_HEAD, BODY_ZONE_CHEST, BODY_ZONE_ARMS, BODY_ZONE_LEGS))
		inspection_data[zone] = human.bodypart_inspection_text(zone, is_observer)

	var/obscured = (holder.name == "Unknown") && !is_observer

	return list(
		"name" = obscured ? holder.name : holder.real_name,
		"species" = obscured ? "Unknown Species" : human.dna?.species || "Unknown Species",
		"species_lore" = obscured ? list() : human.dna?.species?.get_species_lore() || list(),
		"inspection_data" = inspection_data,
		"show_ooc" = user.client.viewing_ooc_info,
	)

/datum/inspection_panel/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(action == "toggle_ooc_info")
		ui.user.client.viewing_ooc_info = !ui.user.client.viewing_ooc_info
		return TRUE
