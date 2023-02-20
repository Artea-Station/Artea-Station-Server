/mob/living/carbon/human/Topic(href, href_list)
	. = ..()

	if(href_list["lookup_info"])
		switch(href_list["lookup_info"])
			if("genitals")
				var/list/line = list()
				for(var/genital in list("penis", "testicles", "vagina", "breasts", "anus"))
					if(!dna.species.mutant_bodyparts[genital])
						continue
					var/datum/sprite_accessory/genital/G = GLOB.sprite_accessories[genital][dna.species.mutant_bodyparts[genital][MUTANT_INDEX_NAME]]
					if(!G)
						continue
					if(G.is_hidden(src))
						continue
					var/obj/item/organ/external/genital/ORG = getorganslot(G.associated_organ_slot)
					if(!ORG)
						continue
					line += ORG.get_description_string(G)
				if(length(line))
					to_chat(usr, span_notice("[jointext(line, "\n")]"))
			if("open_examine_panel")
				tgui.holder = src
				tgui.ui_interact(usr) //datum has a tgui component, here we open the window

/mob/living/carbon/human/species/synthliz
	race = /datum/species/robotic/synthliz

/mob/living/carbon/human/species/vox
	race = /datum/species/vox

/mob/living/carbon/human/species/vox_primalis
	race = /datum/species/vox_primalis

/mob/living/carbon/human/species/ipc
	race = /datum/species/robotic/ipc

/mob/living/carbon/human/species/mammal
	race = /datum/species/mammal

/mob/living/carbon/human/species/podweak
	race = /datum/species/pod/podweak

/mob/living/carbon/human/species/xeno
	race = /datum/species/xeno

/mob/living/carbon/human/species/dwarf
	race = /datum/species/dwarf

/mob/living/carbon/human/species/roundstartslime
	race = /datum/species/jelly/roundstartslime

/mob/living/carbon/human/species/teshari
	race = /datum/species/teshari

/mob/living/carbon/human/verb/toggle_undies()
	set category = "IC"
	set name = "Toggle underwear visibility"
	set desc = "Allows you to toggle which underwear should show or be hidden. Underwear will obscure genitals."

	if(stat != CONSCIOUS)
		to_chat(usr, span_warning("You can't toggle underwear visibility right now..."))
		return

	var/underwear_button = underwear_visibility & UNDERWEAR_HIDE_UNDIES ? "Show underwear" : "Hide underwear"
	var/undershirt_button = underwear_visibility & UNDERWEAR_HIDE_SHIRT ? "Show shirt" : "Hide shirt"
	var/socks_button = underwear_visibility & UNDERWEAR_HIDE_SOCKS ? "Show socks" : "Hide socks"
	var/list/choice_list = list("[underwear_button]" = 1,"[undershirt_button]" = 2,"[socks_button]" = 3,"Show all" = 4, "Hide all" = 5)
	var/picked_visibility = input(src, "Choose visibility setting", "Show/Hide underwear") as null|anything in choice_list
	if(picked_visibility)
		var/picked_choice = choice_list[picked_visibility]
		switch(picked_choice)
			if(1)
				underwear_visibility ^= UNDERWEAR_HIDE_UNDIES
			if(2)
				underwear_visibility ^= UNDERWEAR_HIDE_SHIRT
			if(3)
				underwear_visibility ^= UNDERWEAR_HIDE_SOCKS
			if(4)
				underwear_visibility = NONE
			if(5)
				underwear_visibility = UNDERWEAR_HIDE_UNDIES | UNDERWEAR_HIDE_SHIRT | UNDERWEAR_HIDE_SOCKS
		update_body()
	return

/mob/living/carbon/human/revive(full_heal = FALSE, admin_revive = FALSE)
	. = ..()
	if(.)
		if(dna && dna.species)
			dna.species.spec_revival(src)

/mob/living/carbon/human/verb/toggle_mutant_part_visibility()
	set category = "IC"
	set name = "Show/Hide Mutant Parts"
	set desc = "Allows you to choose to try and hide your mutant bodyparts under your clothes."

	if(stat != CONSCIOUS)
		to_chat(usr, span_warning("You can't do this right now..."))
		return
	if(!try_hide_mutant_parts && !do_after(src, 3 SECONDS,target = src))
		return
	try_hide_mutant_parts = !try_hide_mutant_parts
	to_chat(usr, span_notice("[try_hide_mutant_parts ? "You try and hide your mutant body parts under your clothes." : "You no longer try and hide your mutant body parts"]"))
	update_mutant_bodyparts()

// Feign impairment verb
#define DEFAULT_TIME 30
#define MAX_TIME 36000 // 10 hours

/mob/living/carbon/human/verb/acting()
	set category = "IC"
	set name = "Feign Impairment"
	set desc = "Pretend to be impaired for a defined duration."

	if(stat != CONSCIOUS)
		to_chat(usr, span_warning("You can't do this right now..."))
		return

	var/static/list/choices = list("drunkenness", "stuttering", "jittering")
	var/impairment = tgui_input_list(src, "Select an impairment to perform:", "Impairments", choices)
	if(!impairment)
		return

	var/duration = tgui_input_number(src, "How long would you like to feign [impairment] for?", "Duration in seconds", DEFAULT_TIME, MAX_TIME)
	switch(impairment)
		if("drunkenness")
			var/mob/living/living_user = usr
			if(istype(living_user))
				living_user.add_mood_event("drunk", /datum/mood_event/drunk)
			set_slurring_if_lower(duration SECONDS)
		if("stuttering")
			set_stutter_if_lower(duration SECONDS)
		if("jittering")
			set_dizzy_if_lower(duration SECONDS)

	if(duration)
		addtimer(CALLBACK(src, PROC_REF(acting_expiry), impairment), duration SECONDS)
		to_chat(src, "You are now feigning [impairment].")

/mob/living/carbon/human/proc/acting_expiry(impairment)
	if(impairment)
		// Procs when fake impairment duration ends, useful for calling extra events to wrap up too
		if(impairment == "drunkenness")
			var/mob/living/living_user = usr
			if(istype(living_user))
				living_user.clear_mood_event("drunk")
		// Notify the user
		to_chat(src, "You are no longer feigning [impairment].")

#undef DEFAULT_TIME
#undef MAX_TIME
