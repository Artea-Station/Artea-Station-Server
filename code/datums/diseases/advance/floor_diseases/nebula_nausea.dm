/// Caused by dirty food. Makes you vomit stars.
/datum/disease/advance/nebula_nausea
	name = "Nebula Nausea"
	desc = "You can't contain the colorful beauty of the cosmos inside."
	form = "Condition"
	agent = "Stars"
	cures = list(/datum/reagent/bluespace)
	viable_mobtypes = list(/mob/living/carbon/human)
	required_organs = list(/obj/item/organ/internal/stomach)
	spread_flags = DISEASE_SPREAD_NON_CONTAGIOUS
	severity = DISEASE_SEVERITY_MEDIUM
	max_stages = 5

/datum/disease/advance/nebula_nausea/New()
	symptoms = list(new/datum/symptom/vomit/nebula)
	..()

/datum/disease/advance/nebula_nausea/GenerateCure()
	cures = list(pick(cures))
	var/datum/reagent/cure = GLOB.chemical_reagents_list[cures[1]]
	cure_text = cure.name

/datum/disease/advance/nebula_nausea/stage_act(delta_time, times_fired)
	. = ..()
	if(!.)
		return

	switch(stage)
		if(2)
			if(DT_PROB(1, delta_time) && affected_mob.stat == CONSCIOUS)
				to_chat(affected_mob, span_warning("The colorful beauty of the cosmos seems to have taken a toll on your equilibrium."))
		if(3)
			if(DT_PROB(1, delta_time) && affected_mob.stat == CONSCIOUS)
				to_chat(affected_mob, span_warning("Your stomach swirls with colors unseen by human eyes."))
		if(4)
			if(DT_PROB(1, delta_time) && affected_mob.stat == CONSCIOUS)
				to_chat(affected_mob, span_warning("It feels like you're floating through a maelstrom of celestial colors."))
		if(5)
			if(DT_PROB(1, delta_time) && affected_mob.stat == CONSCIOUS)
				to_chat(affected_mob, span_warning("Your stomach has become a turbulent nebula, swirling with kaleidoscopic patterns."))
