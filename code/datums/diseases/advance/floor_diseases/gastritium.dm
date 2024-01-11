/// Caused by dirty food. Makes you burp out Tritium, sometimes burning hot!
/datum/disease/advance/gastritium
	name = "Gastritium"
	desc = "If left untreated, may manifest in severe Tritium heartburn."
	form = "Infection"
	agent = "Atmobacter Polyri"
	cures = list(/datum/reagent/firefighting_foam)
	viable_mobtypes = list(/mob/living/carbon/human)
	required_organs = list(/obj/item/organ/internal/stomach)
	spread_flags = DISEASE_SPREAD_NON_CONTAGIOUS
	severity = DISEASE_SEVERITY_HARMFUL
	max_stages = 5
	/// The chance of burped out tritium to be hot during max stage
	var/tritium_burp_hot_chance = 10

/datum/disease/advance/gastritium/New()
	symptoms = list(new/datum/symptom/fever)
	..()

/datum/disease/advance/gastritium/GenerateCure()
	cures = list(pick(cures))
	var/datum/reagent/cure = GLOB.chemical_reagents_list[cures[1]]
	cure_text = cure.name

/datum/disease/advance/gastritium/stage_act(delta_time, times_fired)
	. = ..()
	if(!.)
		return

	switch(stage)
		if(2)
			if(DT_PROB(1, delta_time))
				affected_mob.emote("burp")
		if(3)
			if(DT_PROB(1, delta_time) && affected_mob.stat == CONSCIOUS)
				to_chat(affected_mob, span_warning("Your stomach makes turbine noises..."))
			else if(DT_PROB(1, delta_time))
				affected_mob.emote("burp")
		if(4)
			if(DT_PROB(1, delta_time) && affected_mob.stat == CONSCIOUS)
				to_chat(affected_mob, span_warning("You're starting to feel like a burn chamber..."))
			else if(DT_PROB(1, delta_time))
				tritium_burp()
		if(5)
			if(DT_PROB(1, delta_time) && affected_mob.stat == CONSCIOUS)
				to_chat(affected_mob, span_warning("You feel like you're about to delam..."))
			else if(DT_PROB(1, delta_time))
				tritium_burp(hot_chance = TRUE)

/datum/disease/advance/gastritium/proc/tritium_burp(hot_chance = FALSE)
	var/datum/gas_mixture/burp = new
	burp.setGasMoles(GAS_TRITIUM, MOLES_GAS_VISIBLE)
	burp.temperature = affected_mob.bodytemperature
	if(hot_chance && prob(tritium_burp_hot_chance))
		burp.temperature = TRITIUM_MINIMUM_BURN_TEMPERATURE
		if(affected_mob.stat == CONSCIOUS)
			to_chat(affected_mob, span_warning("Your throat feels hot!"))
	affected_mob.visible_message("burps out green gas.", visible_message_flags = EMOTE_MESSAGE)
	affected_mob.loc.assume_air(burp)
