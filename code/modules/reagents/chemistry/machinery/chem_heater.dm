/obj/machinery/chem_heater
	name = "reaction chamber" //Maybe this name is more accurate?
	density = TRUE
	pass_flags_self = PASSMACHINE | LETPASSTHROW
	icon = 'icons/obj/medical/chemical.dmi'
	icon_state = "mixer0b"
	base_icon_state = "mixer"
	idle_power_usage = BASE_MACHINE_IDLE_CONSUMPTION * 0.4
	resistance_flags = FIRE_PROOF | ACID_PROOF
	circuit = /obj/item/circuitboard/machine/chem_heater

	var/obj/item/reagent_containers/beaker = null
	var/target_temperature = 300
	var/heater_coefficient = 0.05
	var/on = FALSE
	//The list of active clients using this heater, so that we can update the UI on a reaction_step. I assume there are multiple clients possible.
	var/list/ui_client_list

/obj/machinery/chem_heater/deconstruct(disassembled)
	. = ..()
	if(beaker && disassembled)
		UnregisterSignal(beaker.reagents, COMSIG_REAGENTS_REACTION_STEP)
		beaker.forceMove(drop_location())
		beaker = null

/obj/machinery/chem_heater/Destroy()
	if(beaker)
		UnregisterSignal(beaker.reagents, COMSIG_REAGENTS_REACTION_STEP)
		QDEL_NULL(beaker)
	return ..()


/obj/machinery/chem_heater/handle_atom_del(atom/A)
	. = ..()
	if(A == beaker)
		beaker = null
		update_appearance()

/obj/machinery/chem_heater/update_icon_state()
	icon_state = "[base_icon_state][beaker ? 1 : 0]b"
	return ..()

/obj/machinery/chem_heater/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	if(!can_interact(user) || !user.canUseTopic(src, !issilicon(user), FALSE, NO_TK))
		return
	replace_beaker(user)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/machinery/chem_heater/attack_robot_secondary(mob/user, list/modifiers)
	return attack_hand_secondary(user, modifiers)

/obj/machinery/chem_heater/attack_ai_secondary(mob/user, list/modifiers)
	return attack_hand_secondary(user, modifiers)

/obj/machinery/chem_heater/proc/replace_beaker(mob/living/user, obj/item/reagent_containers/new_beaker)
	if(!user)
		return FALSE
	if(beaker)
		try_put_in_hand(beaker, user)
		UnregisterSignal(beaker.reagents, COMSIG_REAGENTS_REACTION_STEP)
		beaker = null
	if(new_beaker)
		beaker = new_beaker
		RegisterSignal(beaker.reagents, COMSIG_REAGENTS_REACTION_STEP, PROC_REF(on_reaction_step))
	update_appearance()
	return TRUE

/obj/machinery/chem_heater/RefreshParts()
	. = ..()
	heater_coefficient = 0.1
	for(var/obj/item/stock_parts/micro_laser/M in component_parts)
		heater_coefficient *= M.rating

/obj/machinery/chem_heater/examine(mob/user)
	. = ..()
	if(in_range(user, src) || isobserver(user))
		. += span_notice("The status display reads: Heating reagents at <b>[heater_coefficient*1000]%</b> speed.")

/obj/machinery/chem_heater/process(delta_time)
	..()

	if(machine_stat & NOPOWER)
		return
	if(on)
		if(beaker?.reagents.total_volume)
			if(beaker.reagents.is_reacting)//on_reaction_step() handles this
				return
			//keep constant with the chemical acclimator please
			beaker.reagents.adjust_thermal_energy((target_temperature - beaker.reagents.chem_temp) * heater_coefficient * delta_time * SPECIFIC_HEAT_DEFAULT * beaker.reagents.total_volume)
			beaker.reagents.handle_reactions()

			use_power(active_power_usage * delta_time)

/obj/machinery/chem_heater/attackby(obj/item/I, mob/user, params)
	if(default_deconstruction_screwdriver(user, "mixer0b", "mixer0b", I))
		return

	if(default_deconstruction_crowbar(I))
		return

	if(is_reagent_container(I) && !(I.item_flags & ABSTRACT) && I.is_open_container())
		. = TRUE //no afterattack
		var/obj/item/reagent_containers/B = I
		if(!user.transferItemToLoc(B, src))
			return
		replace_beaker(user, B)
		to_chat(user, span_notice("You add [B] to [src]."))
		ui_interact(user)
		update_appearance()
		return

	if(beaker)
		if(istype(I, /obj/item/reagent_containers/dropper))
			var/obj/item/reagent_containers/dropper/D = I
			D.afterattack(beaker, user, 1)
			return
		if(istype(I, /obj/item/reagent_containers/syringe))
			var/obj/item/reagent_containers/syringe/S = I
			S.afterattack(beaker, user, 1)
			return
	return ..()

/obj/machinery/chem_heater/on_deconstruction()
	replace_beaker()
	return ..()

///Forces a UI update every time a reaction step happens inside of the beaker it contains. This is so the UI is in sync with the reaction since it's important that the output matches the current conditions for pH adjustment and temperature.
/obj/machinery/chem_heater/proc/on_reaction_step(datum/reagents/holder, num_reactions, delta_time)
	SIGNAL_HANDLER
	if(on)
		holder.adjust_thermal_energy((target_temperature - beaker.reagents.chem_temp) * heater_coefficient * delta_time * SPECIFIC_HEAT_DEFAULT * beaker.reagents.total_volume * (rand(8,11) * 0.1))//Give it a little wiggle room since we're actively reacting
	for(var/ui_client in ui_client_list)
		var/datum/tgui/ui = ui_client
		if(!ui)
			stack_trace("Warning: UI in UI client list is missing in [src] (chem_heater)")
			remove_ui_client_list(ui)
			continue
		ui.send_update()

/obj/machinery/chem_heater/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ChemHeater", name)
		ui.open()
		add_ui_client_list(ui)

/obj/machinery/chem_heater/ui_close(mob/user)
	for(var/ui_client in ui_client_list)
		var/datum/tgui/ui = ui_client
		if(ui.user == user)
			remove_ui_client_list(ui)
	return ..()

/*
*This adds an open ui client to the list - so that it can be force updated from reaction mechanisms.
* After adding it to the list, it enables a signal incase the ui is deleted - which will call a method to remove it from the list
* This is mostly to ensure we don't have defunct ui instances stored from any condition.
*/
/obj/machinery/chem_heater/proc/add_ui_client_list(new_ui)
	LAZYADD(ui_client_list, new_ui)
	RegisterSignal(new_ui, COMSIG_PARENT_QDELETING, PROC_REF(on_ui_deletion))

///This removes an open ui instance from the ui list and deregsiters the signal
/obj/machinery/chem_heater/proc/remove_ui_client_list(old_ui)
	UnregisterSignal(old_ui, COMSIG_PARENT_QDELETING)
	LAZYREMOVE(ui_client_list, old_ui)

///This catches a signal and uses it to delete the ui instance from the list
/obj/machinery/chem_heater/proc/on_ui_deletion(datum/tgui/source, force)
	SIGNAL_HANDLER
	remove_ui_client_list(source)

/obj/machinery/chem_heater/ui_assets()
	. = ..() || list()
	. += get_asset_datum(/datum/asset/simple/tutorial_advisors)

/obj/machinery/chem_heater/ui_data(mob/user)
	var/data = list()
	data["targetTemp"] = target_temperature
	data["isActive"] = on
	data["isBeakerLoaded"] = beaker ? 1 : 0

	data["currentTemp"] = beaker ? beaker.reagents.chem_temp : null
	data["beakerCurrentVolume"] = beaker ? round(beaker.reagents.total_volume, 0.01) : null
	data["beakerMaxVolume"] = beaker ? beaker.volume : null
	var/upgrade_level = heater_coefficient*10
	data["upgradeLevel"] = upgrade_level

	var/list/beaker_contents = list()
	for(var/r in beaker?.reagents.reagent_list)
		var/datum/reagent/reagent = r
		beaker_contents.len++
		beaker_contents[length(beaker_contents)] = list("name" = reagent.name, "volume" = round(reagent.volume, 0.01))
	data["beakerContents"] = beaker_contents

	var/list/active_reactions = list()
	var/flashing = DISABLE_FLASHING //for use with alertAfter - since there is no alertBefore, I set the after to 0 if true, or to the max value if false
	for(var/_reaction in beaker?.reagents.reaction_list)
		var/datum/equilibrium/equilibrium = _reaction
		if(!length(beaker.reagents.reaction_list))//I'm not sure why when it explodes it causes the gui to fail (it's missing danger (?) )
			stack_trace("how is this happening??")
			continue
		if(!equilibrium.reaction.results)//Incase of no result reactions
			continue
		var/_reagent = equilibrium.reaction.results[1]
		var/datum/reagent/reagent = beaker?.reagents.get_reagent(_reagent) //Reactions are named after their primary products
		if(!reagent)
			continue
		var/overheat = FALSE
		var/danger = FALSE
		if(!(flashing == ENABLE_FLASHING))//So that the pH meter flashes for ANY reactions out of optimal
			if(beaker.reagents.has_reagent(/datum/reagent/acidic_inversifier))
				flashing = ENABLE_FLASHING
				danger = TRUE
		if(equilibrium.reaction.is_cold_recipe)
			if(equilibrium.reaction.overheat_temp > beaker?.reagents.chem_temp && equilibrium.reaction.overheat_temp != NO_OVERHEAT)
				danger = TRUE
				overheat = TRUE
		else
			if(equilibrium.reaction.overheat_temp < beaker?.reagents.chem_temp)
				danger = TRUE
				overheat = TRUE
		if(equilibrium.reaction.reaction_flags & REACTION_COMPETITIVE) //We have a compeitive reaction - concatenate the results for the different reactions
			for(var/entry in active_reactions)
				if(entry["name"] == reagent.name) //If we have multiple reaction methods for the same result - combine them
					entry["reactedVol"] = equilibrium.reacted_vol
					entry["targetVol"] = round(equilibrium.target_vol, 1)//Use the first result reagent to name the reaction detected
					continue
		active_reactions.len++
		active_reactions[length(active_reactions)] = list("name" = reagent.name, "danger" = danger, "purityAlert" = 2/*same as flashing*/, "overheat" = overheat, "inverse" = reagent.inverse_chem_val, "reactedVol" = equilibrium.reacted_vol, "targetVol" = round(equilibrium.target_vol, 1))//Use the first result reagent to name the reaction detected
	data["activeReactions"] = active_reactions
	data["isFlashing"] = flashing

	return data

/obj/machinery/chem_heater/ui_act(action, params)
	. = ..()
	if(.)
		return
	switch(action)
		if("power")
			on = !on
			. = TRUE
		if("temperature")
			var/target = params["target"]
			if(text2num(target) != null)
				target = text2num(target)
				. = TRUE
			if(.)
				target_temperature = clamp(target, 0, 1000)
		if("eject")
			//Eject doesn't turn it off, so you can preheat for beaker swapping
			replace_beaker(usr)
			. = TRUE

//Has a lot of buffer and is upgraded
/obj/machinery/chem_heater/debug
	name = "Debug Reaction Chamber"
	desc = "Now with even more speed!"

/obj/machinery/chem_heater/debug/Initialize(mapload)
	. = ..()
	heater_coefficient = 0.4 //hack way to upgrade
