// Action
/datum/action/innate/monitor_change
	name = "Screen Change"
	check_flags = AB_CHECK_CONSCIOUS
	icon_icon = 'icons/mob/actions/actions_silicon.dmi'
	button_icon_state = "drone_vision"

/datum/action/innate/monitor_change/Activate()
	var/mob/living/carbon/human/human = owner
	var/new_ipc_screen = tgui_input_list(usr, "Choose your character's screen:", "Monitor Display", GLOB.synth_screens)

	log_world(new_ipc_screen)

	if(!new_ipc_screen)
		return

	var/obj/item/organ/external/screen/screen = human.getorganslot(MUTANT_SYNTH_SCREEN)
	screen?.switch_to_screen(new_ipc_screen)

// Organ
/obj/item/organ/external/screen
	name = "screen"
	preference = "feature_ipc_screen"
	organ_flags = ORGAN_ROBOTIC

	bodypart_overlay = /datum/bodypart_overlay/mutant/screen

	zone = BODY_ZONE_HEAD
	slot = MUTANT_SYNTH_SCREEN

	/// The innate action that synths get, if they've got a screen selected on species being set.
	var/datum/action/innate/monitor_change/screen
	/// This is the screen that is given to the user after they get revived. On death, their screen is temporarily set to BSOD before it turns off, hence the need for this var.
	var/saved_screen = "Blank"

/obj/item/organ/external/screen/Insert(mob/living/carbon/receiver, special, drop_if_replaced)
	. = ..()

	if(. && !screen)
		screen = new
		screen.Grant(receiver)

/obj/item/organ/external/screen/Remove(mob/living/carbon/organ_owner, special, moving)
	if(screen)
		screen.Remove(organ_owner)
	. = ..()

/obj/item/organ/external/screen/owner_death()
	. = ..()
	if(!owner)
		return
	var/obj/item/organ/external/screen/screen_organ = owner.getorganslot(MUTANT_SYNTH_SCREEN)
	saved_screen = screen_organ.bodypart_overlay?.sprite_datum?.name || "None"
	switch_to_screen("BSOD")
	addtimer(CALLBACK(src, PROC_REF(switch_to_screen), "Blank"), 5 SECONDS)

/obj/item/organ/external/screen/owner_revived()
	. = ..()
	if(!owner)
		return
	switch_to_screen("Console")
	addtimer(CALLBACK(src, PROC_REF(switch_to_screen), saved_screen), 5 SECONDS)
	playsound(owner.loc, 'sound/machines/chime.ogg', 50, TRUE)
	owner.visible_message(span_notice("[owner]'s [owner.getorganslot(MUTANT_SYNTH_SCREEN) ? "monitor lights up" : "eyes flicker to life"]!"), span_notice("All systems nominal. You're back online!"))

/**
 * Simple proc to switch the screen of a monitor-enabled synth, while updating their appearance.
 *
 * Arguments:
 * * screen_name - The name of the screen to switch the ipc_screen mutant bodypart to.
 */
/obj/item/organ/external/screen/proc/switch_to_screen(screen_name)
	if(!screen || !screen_name)
		return

	var/obj/item/organ/external/screen/screen_organ = owner.getorganslot(MUTANT_SYNTH_SCREEN)
	screen_organ?.bodypart_overlay?.set_appearance_from_name(screen_name)
	owner.update_body(TRUE)

// Bodypart overlay
/datum/bodypart_overlay/mutant/screen
	layers = EXTERNAL_FRONT_UNDER_CLOTHES
	feature_key = MUTANT_SYNTH_SCREEN
	color_source = ORGAN_COLOR_OVERRIDE

/datum/bodypart_overlay/mutant/screen/get_global_feature_list()
	return GLOB.synth_screens

/datum/bodypart_overlay/mutant/screen/override_color(obj/item/bodypart/bodypart)
	return sprite_datum.color_src ? bodypart.owner.dna.features["[MUTANT_SYNTH_SCREEN]_color"] : null
