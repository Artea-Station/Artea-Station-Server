#define AROUS_SYS_LITTLE 30
#define AROUS_SYS_STRONG 70
#define AROUS_SYS_READYTOCUM 90
#define PAIN_SYS_LIMIT 50
#define PLEAS_SYS_EDGE 85

#define CUM_MALE 1
#define CUM_FEMALE 2
// #define ITEM_SLOT_PENIS (1<<20)

#define TRAIT_MASOCHISM		"masochism"
#define TRAIT_SADISM		"sadism"
#define TRAIT_NEVERBONER	"neverboner"
#define TRAIT_BIMBO "bimbo"
#define TRAIT_RIGGER		"rigger"
#define TRAIT_ROPEBUNNY		"rope bunny"
#define APHRO_TRAIT			"aphro"				///traits gained by brain traumas, can be removed if the brain trauma is gone
#define LEWDQUIRK_TRAIT		"lewdquirks"		///traits gained by quirks, cannot be removed unless the quirk itself is gone
#define LEWDCHEM_TRAIT		"lewdchem"			///traits gained by chemicals, you get the idea

#define STRAPON_TRAIT 		"strapon"

/*
*	DECALS
*/

/obj/effect/decal/cleanable/cum
	name = "cum"
	desc = "Ew... Gross."
	icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/obj/lewd_decals/lewd_decals.dmi'
	icon_state = "cum_1"
	random_icon_states = list("cum_1", "cum_2", "cum_3", "cum_4")
	beauty = -50

/obj/effect/decal/cleanable/cum/femcum
	name = "female cum"
	desc = "Uhh... Someone had fun..."
	icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/obj/lewd_decals/lewd_decals.dmi'
	icon_state = "femcum_1"
	random_icon_states = list("femcum_1", "femcum_2", "femcum_3", "femcum_4")
	beauty = -50

/*
*	REAGENTS
*/

/datum/reagent/consumable/girlcum
	name = "girlcum"
	description = "Uhh... Someone had fun."
	taste_description = "astringent and sweetish"
	color = "#ffffffb0"
	glass_name = "glass of girlcum"
	glass_desc = "A strange white liquid... Ew!"
	reagent_state = LIQUID
	shot_glass_icon_state = "shotglasswhite"

/datum/reagent/consumable/cum
	name = "cum"
	description = "A fluid secreted by the sexual organs of many species."
	taste_description = "musky and salty"
	color = "#ffffffff"
	glass_name = "glass of cum"
	glass_desc = "O-oh, my...~"
	reagent_state = LIQUID
	shot_glass_icon_state = "shotglasswhite"

/datum/reagent/consumable/breast_milk
	name = "breast milk"
	description = "This looks familiar... Wait, it's milk!"
	taste_description = "warm and creamy"
	color = "#ffffffff"
	glass_icon_state = "glass_white"
	glass_name = "glass of breast milk"
	glass_desc = "almost like normal milk."
	reagent_state = LIQUID

/datum/reagent/drug/dopamine
	name = "dopamine"
	description = "Pure happiness"
	taste_description = "passion fruit, banana and hint of apple"
	color = "#97ffee"
	glass_name = "dopamine"
	glass_desc = "A deliciously flavored reagent. You feel happy even looking at it."
	reagent_state = LIQUID
	overdose_threshold = 10

/datum/reagent/drug/dopamine/on_mob_add(mob/living/carbon/human/affected_mob)
	affected_mob.add_mood_event("[type]_start", /datum/mood_event/orgasm, name)
	..()

/datum/reagent/drug/dopamine/on_mob_life(mob/living/carbon/affected_mob, delta_time, times_fired)
	affected_mob.set_drugginess(2 SECONDS * REM * delta_time)
	if(prob(7))
		affected_mob.try_lewd_autoemote(pick("shaking", "moan"))
	..()

/datum/reagent/drug/dopamine/overdose_start(mob/living/carbon/human/human_mob)
	if(HAS_TRAIT(human_mob, TRAIT_BIMBO))
		return
	to_chat(human_mob, span_userdanger("You don't want to cum anymore!"))
	human_mob.add_mood_event("[type]_overdose", /datum/mood_event/overgasm, name)

/datum/reagent/drug/dopamine/overdose_process(mob/living/carbon/human/affected_mob)
	affected_mob.adjustArousal(0.5)
	affected_mob.adjustPleasure(0.3)
	affected_mob.adjustPain(-0.5)
	if(prob(2))
		affected_mob.try_lewd_autoemote(pick("moan", "twitch_s"))
	return

/*
*	INITIALISE
*/

/obj/item/organ/external/genital
	var/datum/reagents/internal_fluids
	var/list/contained_item
	var/obj/item/inserted_item //Used for toys

/obj/item/organ/external/genital/breasts/build_from_dna(datum/dna/DNA, associated_key)
	. = ..()
	var/breasts_count = 0
	var/size = 0.5
	if(DNA.features["breasts_size"] > 0)
		size = DNA.features["breasts_size"]

	switch(genital_type)
		if("pair")
			breasts_count = 2
		if("quad")
			breasts_count = 2.5
		if("sextuple")
			breasts_count = 3
	internal_fluids = new /datum/reagents(size * breasts_count * 60)

/obj/item/organ/external/genital/testicles/build_from_dna(datum/dna/DNA, associated_key)
	. = ..()
	var/size = 0.5
	if(DNA.features["balls_size"] > 0)
		size = DNA.features["balls_size"]

	internal_fluids = new /datum/reagents(size * 20)

/obj/item/organ/external/genital/vagina/build_from_dna(datum/dna/DNA, associated_key)
	. = ..()
	internal_fluids = new /datum/reagents(10)

/mob/living/carbon/human
	var/arousal = 0
	var/pleasure = 0
	var/pain = 0

	var/pain_limit = 0
	var/arousal_status = AROUSAL_NONE

/mob/living/carbon/human/Initialize(mapload)
	. = ..()
	if(!istype(src, /mob/living/carbon/human/species/monkey))
		apply_status_effect(/datum/status_effect/aroused)
		apply_status_effect(/datum/status_effect/body_fluid_regen)

/*
*	VERBS
*/

/mob/living/carbon/human/verb/arousal_panel()
	set name = "Climax"
	set category = "IC"

	if(!has_status_effect(/datum/status_effect/climax_cooldown))
		if(tgui_alert(usr, "Are you sure you want to cum?", "Climax", list("Yes", "No")) == "Yes")
			if(stat != CONSCIOUS)
				to_chat(usr, span_warning("You can't climax right now..."))
				return
			else
				climax(TRUE)
	else
		to_chat(src, span_warning("You can't cum right now!"))

//Removing ERP IC verb depending on config
/mob/living/carbon/human/Initialize(mapload)
	. = ..()
	if(CONFIG_GET(flag/disable_erp_preferences))
		verbs -= /mob/living/carbon/human/verb/arousal_panel

/*
*	FLUIDS
*/

/datum/status_effect/body_fluid_regen
	id = "body fluid regen"
	tick_interval = 50
	duration = -1
	alert_type = null

/datum/status_effect/body_fluid_regen/tick()
	var/mob/living/carbon/human/affected_mob = owner
	if(owner.stat != DEAD && affected_mob.client?.prefs?.read_preference(/datum/preference/toggle/erp/sex_toy))
		var/obj/item/organ/external/genital/testicles/balls = owner.getorganslot(ORGAN_SLOT_TESTICLES)
		var/obj/item/organ/external/genital/breasts/breasts = owner.getorganslot(ORGAN_SLOT_BREASTS)
		var/obj/item/organ/external/genital/vagina/vagina = owner.getorganslot(ORGAN_SLOT_VAGINA)

		var/interval = 5
		if(balls)
			if(affected_mob.arousal >= AROUS_SYS_LITTLE)
				var/regen = (affected_mob.arousal / 25) * (balls.internal_fluids.maximum_volume / 235) * interval
				balls.internal_fluids.add_reagent(/datum/reagent/consumable/cum, regen)

		if(breasts)
			if(breasts.lactates == TRUE)
				var/regen = ((owner.nutrition / (NUTRITION_LEVEL_WELL_FED / 100)) / 100) * (breasts.internal_fluids.maximum_volume / 11000) * interval
				if(!breasts.internal_fluids.holder_full())
					owner.adjust_nutrition(-regen / 2)
					breasts.internal_fluids.add_reagent(/datum/reagent/consumable/breast_milk, regen)

		if(vagina)
			if(affected_mob.arousal >= AROUS_SYS_LITTLE)
				var/regen = (affected_mob.arousal / 25) * (vagina.internal_fluids.maximum_volume / 250) * interval
				vagina.internal_fluids.add_reagent(/datum/reagent/consumable/girlcum, regen)
				if(vagina.internal_fluids.holder_full() && regen >= 0.15)
					regen = regen
			else
				vagina.internal_fluids.remove_any(0.05)

/*
*	AROUSAL
*/

/mob/living/carbon/human/proc/get_arousal()
	return arousal

/mob/living/carbon/human/proc/adjustArousal(arous = 0)
	if(stat != DEAD && client?.prefs?.read_preference(/datum/preference/toggle/erp))
		arousal += arous

		var/arousal_flag = AROUSAL_NONE
		if(arousal >= AROUS_SYS_STRONG)
			arousal_flag = AROUSAL_FULL
		else if(arousal >= AROUS_SYS_LITTLE)
			arousal_flag = AROUSAL_PARTIAL

		if(arousal_status != arousal_flag) // Set organ arousal status
			arousal_status = arousal_flag
			if(istype(src, /mob/living/carbon/human))
				var/mob/living/carbon/human/target = src
				for(var/i = 1, i <= target.external_organs.len, i++)
					if(istype(target.external_organs[i], /obj/item/organ/external/genital))
						var/obj/item/organ/external/genital/target_genital = target.external_organs[i]
						if(!target_genital.aroused == AROUSAL_CANT)
							target_genital.aroused = arousal_status
							target_genital.update_sprite_suffix()
				target.update_body()
	else
		arousal -= abs(arous)

		arousal = min(max(arousal, 0), 100)

/datum/status_effect/aroused
	id = "aroused"
	tick_interval = 10
	duration = -1
	alert_type = null

/datum/status_effect/aroused/tick()
	var/mob/living/carbon/human/affected_mob = owner
	var/temp_arousal = -0.1
	var/temp_pleasure = -0.5
	var/temp_pain = -0.5
	if(affected_mob.stat != DEAD)

		var/obj/item/organ/external/genital/testicles/balls = affected_mob.getorganslot(ORGAN_SLOT_TESTICLES)
		if(balls)
			if(balls.internal_fluids.holder_full())
				temp_arousal += 0.08

		if(HAS_TRAIT(affected_mob, TRAIT_MASOCHISM))
			temp_pain -= 0.5
		if(HAS_TRAIT(affected_mob, TRAIT_NEVERBONER))
			temp_pleasure -= 50
			temp_arousal -= 50

		if(affected_mob.pain > affected_mob.pain_limit)
			temp_arousal -= 0.1
		if(affected_mob.arousal >= AROUS_SYS_STRONG && affected_mob.stat != DEAD)
			if(prob(3))
				affected_mob.try_lewd_autoemote(pick("moan", "blush"))
			temp_pleasure += 0.1
			//moan
		if(affected_mob.pleasure >= PLEAS_SYS_EDGE && affected_mob.stat != DEAD)
			if(prob(3))
				affected_mob.try_lewd_autoemote(pick("moan", "twitch_s"))
			//moan x2

	affected_mob.adjustArousal(temp_arousal)
	affected_mob.adjustPleasure(temp_pleasure)
	affected_mob.adjustPain(temp_pain)

/*
*	PAIN
*/

/mob/living/carbon/human/proc/get_pain()
	return pain

/mob/living/carbon/human/proc/adjustPain(change_amount = 0)
	if(stat != DEAD && client?.prefs?.read_preference(/datum/preference/toggle/erp))
		if(pain > pain_limit || change_amount > pain_limit / 10) // pain system // YOUR SYSTEM IS PAIN, WHY WE'RE GETTING AROUSED BY STEPPING ON ANTS?!
			if(HAS_TRAIT(src, TRAIT_MASOCHISM))
				var/arousal_adjustment = change_amount - (pain_limit / 10)
				if(arousal_adjustment > 0)
					adjustArousal(-arousal_adjustment)
			else
				if(change_amount > 0)
					adjustArousal(-change_amount)
			if(prob(2) && pain > pain_limit && change_amount > pain_limit / 10)
				try_lewd_autoemote(pick("scream", "shiver")) //SCREAM!!!
		else
			if(change_amount > 0)
				adjustArousal(change_amount)
			if(HAS_TRAIT(src, TRAIT_MASOCHISM))
				var/pleasure_adjustment = change_amount / 2
				adjustPleasure(pleasure_adjustment)
		pain += change_amount
	else
		pain -= abs(change_amount)
	pain = min(max(pain, 0), 100)

/*
*	PLEASURE
*/

/mob/living/carbon/human/proc/get_pleasure()
	return pleasure

/mob/living/carbon/human/proc/adjustPleasure(pleas = 0)
	if(stat != DEAD && client?.prefs?.read_preference(/datum/preference/toggle/erp))
		pleasure += pleas
		if(pleasure >= 100) // lets cum
			climax(FALSE)
	else
		pleasure -= abs(pleas)
	pleasure = min(max(pleasure, 0), 100)

// Get damage for pain system
/datum/species/apply_damage(damage, damagetype, def_zone, blocked, mob/living/carbon/human/affected_mob, forced, spread_damage, wound_bonus, bare_wound_bonus, sharpness, attack_direction)
	. = ..()
	if(!.)
		return
	if(affected_mob.client?.prefs?.read_preference(/datum/preference/toggle/erp/sex_toy))
		return
	var/hit_percent = (100 - (blocked + armor)) / 100
	hit_percent = (hit_percent * (100 - affected_mob.physiology.damage_resistance)) / 100
	switch(damagetype)
		if(BRUTE)
			var/amount = forced ? damage : damage * hit_percent * brutemod * affected_mob.physiology.brute_mod
			INVOKE_ASYNC(affected_mob, TYPE_PROC_REF(/mob/living/carbon/human, adjustPain), amount)
		if(BURN)
			var/amount = forced ? damage : damage * hit_percent * burnmod * affected_mob.physiology.burn_mod
			INVOKE_ASYNC(affected_mob, TYPE_PROC_REF(/mob/living/carbon/human, adjustPain), amount)

/*
*	CLIMAX
*/

/datum/mood_event/orgasm
	description = span_purple("Woah... This pleasant tiredness... I love it.\n")
	timeout = 5 MINUTES

/datum/mood_event/climaxself
	description = span_purple("I just came in my own underwear. Messy.\n")
	timeout = 4 MINUTES

/datum/mood_event/overgasm
	description = span_warning("Uhh... I don't want to be horny anymore.\n") //Me too, buddy. Me too.
	timeout = 10 MINUTES

/mob/living/carbon/human/proc/climax(manual = TRUE)
	if (CONFIG_GET(flag/disable_erp_preferences))
		return

	if(!client?.prefs?.read_preference(/datum/preference/toggle/erp/autocum) && manual != TRUE)
		return

	var/obj/item/organ/external/genital/penis/penis = getorganslot(ORGAN_SLOT_PENIS)
	var/obj/item/organ/external/genital/testicles/testicles = getorganslot(ORGAN_SLOT_TESTICLES)
	var/obj/item/organ/external/genital/vagina/vagina = getorganslot(ORGAN_SLOT_VAGINA)

	if(!has_status_effect(/datum/status_effect/climax_cooldown) && client?.prefs?.read_preference(/datum/preference/toggle/erp/sex_toy))
		if(!HAS_TRAIT(src, TRAIT_NEVERBONER) && !has_status_effect(/datum/status_effect/climax_cooldown))
			switch(gender)
				if(MALE)
					playsound(get_turf(src), pick('modular_skyrat/modules/modular_items/lewd_items/sounds/final_m1.ogg',
												'modular_skyrat/modules/modular_items/lewd_items/sounds/final_m2.ogg',
												'modular_skyrat/modules/modular_items/lewd_items/sounds/final_m3.ogg'), 50, TRUE, ignore_walls = FALSE)
				if(FEMALE)
					playsound(get_turf(src), pick('modular_skyrat/modules/modular_items/lewd_items/sounds/final_f1.ogg',
												'modular_skyrat/modules/modular_items/lewd_items/sounds/final_f2.ogg',
												'modular_skyrat/modules/modular_items/lewd_items/sounds/final_f3.ogg'), 50, TRUE, ignore_walls = FALSE)
			if(penis)
				if(!testicles) //If we have no god damn balls, we can't cum anywhere... GET BALLS!
					visible_message(span_userlove("[src] orgasms, but nothing comes out of [p_their()] dick!"), \
						span_userlove("You orgasm, it feels great, but nothing comes out of your dick!"))
					apply_status_effect(/datum/status_effect/climax)
					apply_status_effect(/datum/status_effect/climax_cooldown)
					add_mood_event("orgasm", /datum/mood_event/climaxself)
					return TRUE

				if(!is_bottomless() && penis.visibility_preference != GENITAL_ALWAYS_SHOW)
					visible_message(span_userlove("[src] cums into their clothes!"), \
						span_userlove("You shoot your load, but you weren't naked, so you mess up your clothes!"))
					apply_status_effect(/datum/status_effect/climax)
					apply_status_effect(/datum/status_effect/climax_cooldown)
					add_mood_event("orgasm", /datum/mood_event/climaxself)
					return TRUE

				var/list/interactable_inrange_humans = list()

				for(var/mob/living/carbon/human/iterating_human in view(1, src))
					if(iterating_human == src)
						continue
					//if(iterating_human.client?.prefs?.read_preference(/datum/preference/toggle/erp))
					interactable_inrange_humans[iterating_human.name] = iterating_human

				var/list/buttons = list("On the floor")

				if(interactable_inrange_humans.len)
					buttons += "Inside/on someone"

				var/climax_choice = tgui_alert(src, "You are cumming, choose where to shoot your load.", "Load preference!", buttons)

				visible_message(span_purple("[src] is cumming!"), span_purple("You are cumming!"))

				var/create_cum_decal = FALSE

				if(!climax_choice || climax_choice == "On the floor")
					if(wear_condom())
						var/obj/item/clothing/sextoy/condom/condom = get_item_by_slot(ITEM_SLOT_PENIS)
						if(condom.condom_state == "broken")
							create_cum_decal = TRUE
							visible_message(span_userlove("[src] shoots [p_their()] load into [condom], sending cum onto the floor!"), \
								span_userlove("You shoot string after string of cum, but it sprays out of [condom], hitting the floor!"))
						else
							condom.condom_use()
							visible_message(span_userlove("[src] shoots [p_their()] load into [condom], filling it up!"), \
								span_userlove("You shoot your thick load into [condom] and it catches it all!"))
					else
						create_cum_decal = TRUE
						visible_message(span_userlove("[src] shoots their sticky load onto the floor!"), \
							span_userlove("You shoot string after string of hot cum, hitting the floor!"))
				else
					var/target_choice = tgui_input_list(src, "Choose a person to cum in or on~", "Choose target!", interactable_inrange_humans)
					if(!target_choice)
						create_cum_decal = TRUE
						visible_message(span_userlove("[src] shoots their sticky load onto the floor!"), \
							span_userlove("You shoot string after string of hot cum, hitting the floor!"))
					else
						var/mob/living/carbon/human/target_human = interactable_inrange_humans[target_choice]
						var/obj/item/organ/external/genital/vagina/target_vagina = target_human.getorganslot(ORGAN_SLOT_VAGINA)
						var/obj/item/organ/external/genital/anus/target_anus = target_human.getorganslot(ORGAN_SLOT_ANUS)
						var/obj/item/organ/external/genital/penis/target_penis = target_human.getorganslot(ORGAN_SLOT_PENIS)

						var/list/target_buttons = list()

						if(!target_human.wear_mask)
							target_buttons += "mouth"

						if(target_vagina && target_vagina?.is_exposed())
							target_buttons += "vagina"

						if(target_anus && target_anus?.is_exposed())
							target_buttons += "asshole"

						if(target_penis && target_penis.is_exposed() && target_penis.sheath != "None")
							target_buttons += "sheath"

						target_buttons += "On them"

						var/climax_into_choice = tgui_input_list(src, "Where on or in [target_human] do you wish to cum?", "Final frontier!", target_buttons)

						if(!climax_into_choice)
							create_cum_decal = TRUE
							visible_message(span_userlove("[src] shoots their sticky load onto the floor!"), \
								span_userlove("You shoot string after string of hot cum, hitting the floor!"))
						else if(climax_into_choice == "On them")
							create_cum_decal = TRUE
							visible_message(span_userlove("[src] shoots their sticky load onto the [target_human]!"), \
								span_userlove("You shoot string after string of hot cum onto [target_human]!"))
						else
							visible_message(span_userlove("[src] hilts [p_their()] cock into [target_human]'s [climax_into_choice], shooting cum into it!"), \
								span_userlove("You hilt your cock into [target_human]'s [climax_into_choice], shooting cum into it!"))
							to_chat(target_human, span_userlove("Your [climax_into_choice] fills with warm cum as [src] shoots [p_their()] load into it."))
				try_lewd_autoemote("moan")
				testicles.reagents.remove_all(testicles.reagents.total_volume * 0.6)
				apply_status_effect(/datum/status_effect/climax)
				apply_status_effect(/datum/status_effect/climax_cooldown)
				if(create_cum_decal)
					add_cum_splatter_floor(get_turf(src))
				return TRUE
			if(vagina)
				if(is_bottomless() || vagina.visibility_preference == GENITAL_ALWAYS_SHOW)
					apply_status_effect(/datum/status_effect/climax)
					apply_status_effect(/datum/status_effect/climax_cooldown)
					visible_message(span_purple("[src] is cumming!"), span_purple("You are cumming!"))
					var/turf/our_turf = get_turf(src)
					add_cum_splatter_floor(our_turf, female = TRUE)
				else
					apply_status_effect(/datum/status_effect/climax)
					apply_status_effect(/datum/status_effect/climax_cooldown)
					visible_message(span_purple("[src] cums in their underwear!"), \
								span_purple("You cum in your underwear! Eww."))
					add_mood_event("orgasm", /datum/mood_event/climaxself)
				return TRUE
		else
			visible_message(span_purple("[src] twitches, trying to cum, but with no result."), \
				span_purple("You can't have an orgasm!"))
			return TRUE

// Let's not force lewd emotes from folk who don't want them, mmm~?
/mob/living/carbon/proc/try_lewd_autoemote(emote)
	if(!client?.prefs?.read_preference(/datum/preference/toggle/erp/autoemote))
		return
	emote(emote)

/datum/status_effect/climax_cooldown
	id = "climax_cooldown"
	tick_interval = 10
	duration = 30 SECONDS
	alert_type = null

/datum/status_effect/climax_cooldown/tick()
	var/obj/item/organ/external/genital/vagina/vagina = owner.getorganslot(ORGAN_SLOT_VAGINA)
	var/obj/item/organ/external/genital/testicles/balls = owner.getorganslot(ORGAN_SLOT_TESTICLES)
	var/obj/item/organ/external/genital/testicles/penis = owner.getorganslot(ORGAN_SLOT_PENIS)
	var/obj/item/organ/external/genital/testicles/anus = owner.getorganslot(ORGAN_SLOT_ANUS)

	if(penis)
		penis.aroused = AROUSAL_NONE
	if(vagina)
		vagina.aroused = AROUSAL_NONE
	if(balls)
		balls.aroused = AROUSAL_NONE
	if(anus)
		anus.aroused = AROUSAL_NONE

/datum/status_effect/masturbation_climax
	id = "climax"
	tick_interval =  10
	duration = 50 //Multiplayer better than singleplayer mode.
	alert_type = null

/datum/status_effect/masturbation_climax/tick() //this one should not leave decals on the floor. Used in case if character cumming in beaker.
	var/mob/living/carbon/human/affected_mob = owner
	if(affected_mob.client?.prefs?.read_preference(/datum/preference/toggle/erp/sex_toy))
		var/temp_arousal = -12
		var/temp_pleasure = -12
		var/temp_stamina = 8

		owner.reagents.add_reagent(/datum/reagent/drug/dopamine, 0.3)
		owner.adjustStaminaLoss(temp_stamina)
		affected_mob.adjustArousal(temp_arousal)
		affected_mob.adjustPleasure(temp_pleasure)

/datum/status_effect/climax
	id = "climax"
	tick_interval =  10
	duration = 100
	alert_type = null

/datum/status_effect/climax/tick()
	var/mob/living/carbon/human/affected_mob = owner
	if(affected_mob.client?.prefs?.read_preference(/datum/preference/toggle/erp/sex_toy))
		var/temp_arousal = -12
		var/temp_pleasure = -12
		var/temp_stamina = 15

		owner.reagents.add_reagent(/datum/reagent/drug/dopamine, 0.5)
		owner.adjustStaminaLoss(temp_stamina)
		affected_mob.adjustArousal(temp_arousal)
		affected_mob.adjustPleasure(temp_pleasure)

/*
*	SPANKING
*/

//Hips are red after spanking
/datum/status_effect/spanked
	id = "spanked"
	duration = 300 SECONDS
	alert_type = null

/mob/living/carbon/human/examine(mob/user)
	. = ..()
	var/mob/living/affected_mob = user
	if(stat != DEAD && !HAS_TRAIT(src, TRAIT_FAKEDEATH) && src != affected_mob)
		if(src != user)
			if(has_status_effect(/datum/status_effect/spanked) && is_bottomless())
				. += span_purple("[user.p_their(TRUE)] butt has a red tint to it.") + "\n"

//Mood boost for masochist
/datum/mood_event/perv_spanked
	description = span_purple("Ah, yes! More! Punish me!\n")
	timeout = 5 MINUTES

/*
*	SUBSPACE EFFECT
*/

/datum/status_effect/subspace
	id = "subspace"
	tick_interval = 10
	duration = 5 MINUTES
	alert_type = null

/datum/status_effect/subspace/on_apply()
	. = ..()
	var/mob/living/carbon/human/target = owner
	target.add_mood_event("subspace", /datum/mood_event/subspace)

/datum/status_effect/subspace/on_remove()
	. = ..()
	var/mob/living/carbon/human/target = owner
	target.clear_mood_event("subspace")

/datum/mood_event/subspace
	description = span_purple("Everything is so woozy... Pain feels so... Awesome.\n")

/datum/status_effect/ropebunny
	id = "ropebunny"
	tick_interval = 10
	duration = INFINITE
	alert_type = null

/datum/status_effect/ropebunny/on_apply()
	. = ..()
	var/mob/living/carbon/human/target = owner
	target.add_mood_event("ropebunny", /datum/mood_event/ropebunny)

/datum/status_effect/ropebunny/on_remove()
	. = ..()
	var/mob/living/carbon/human/target = owner
	target.clear_mood_event("ropebunny")

/datum/mood_event/ropebunny
	description = span_purple("I'm tied! Cannot move! These ropes... Ah!~")
	mood_change = 0 // I don't want to doom the station to sonic-speed perverts, but still want to keep this as mood modifier.

/*
*	AROUSAL INDICATOR
*/

/obj/item/organ/internal/brain/on_life(delta_time, times_fired) //All your horny is here *points to the head*
	. = ..()
	var/mob/living/carbon/human/brain_owner = owner
	if(istype(brain_owner, /mob/living/carbon/human) && brain_owner.client?.prefs?.read_preference(/datum/preference/toggle/erp/sex_toy))
		if(!(organ_flags & ORGAN_FAILING))
			brain_owner.dna.species.handle_arousal(brain_owner, delta_time, times_fired)

//screen alert

/atom/movable/screen/alert/aroused_x
	name = "Aroused"
	desc = "It's a little hot in here"
	icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/obj/lewd_items/lewd_icons.dmi'
	icon_state = "arousal_small"
	var/mutable_appearance/pain_overlay
	var/mutable_appearance/pleasure_overlay
	var/pain_level = "small"
	var/pleasure_level = "small"

/atom/movable/screen/alert/aroused_x/Initialize(mapload)
	.=..()
	pain_overlay = update_pain()
	pleasure_overlay = update_pleasure()

/atom/movable/screen/alert/aroused_x/proc/update_pain()
	if(pain_level)
		return mutable_appearance('modular_skyrat/modules/modular_items/lewd_items/icons/obj/lewd_items/lewd_icons.dmi', "pain_[pain_level]")

/atom/movable/screen/alert/aroused_x/proc/update_pleasure()
	if(pleasure_level)
		return mutable_appearance('modular_skyrat/modules/modular_items/lewd_items/icons/obj/lewd_items/lewd_icons.dmi', "pleasure_[pleasure_level]")

/datum/species/proc/throw_arousalalert(level, atom/movable/screen/alert/aroused_x/arousal_alert, mob/living/carbon/human/targeted_human)
	targeted_human.throw_alert("aroused", /atom/movable/screen/alert/aroused_x)
	arousal_alert?.icon_state = level
	arousal_alert?.update_icon()

/datum/species/proc/overlay_pain(level, atom/movable/screen/alert/aroused_x/arousal_alert)
	arousal_alert?.cut_overlay(arousal_alert.pain_overlay)
	arousal_alert?.pain_level = level
	arousal_alert?.pain_overlay = arousal_alert.update_pain()
	arousal_alert?.add_overlay(arousal_alert.pain_overlay)
	arousal_alert?.update_overlays()

/datum/species/proc/overlay_pleasure(level, atom/movable/screen/alert/aroused_x/arousal_alert)
	arousal_alert?.cut_overlay(arousal_alert.pleasure_overlay)
	arousal_alert?.pleasure_level = level
	arousal_alert?.pleasure_overlay = arousal_alert.update_pleasure()
	arousal_alert?.add_overlay(arousal_alert.pleasure_overlay)
	arousal_alert?.update_overlays()

/datum/species/proc/handle_arousal(mob/living/carbon/human/target_human, atom/movable/screen/alert/aroused_x)
	var/atom/movable/screen/alert/aroused_x/arousal_alert = target_human.alerts["aroused"]
	if(target_human.client?.prefs?.read_preference(/datum/preference/toggle/erp/sex_toy))
		switch(target_human.arousal)
			if(-100 to 1)
				target_human.clear_alert("aroused", /atom/movable/screen/alert/aroused_x)
			if(1 to 25)
				throw_arousalalert("arousal_small", arousal_alert, target_human)
			if(25 to 50)
				throw_arousalalert("arousal_medium", arousal_alert, target_human)
			if(50 to 75)
				throw_arousalalert("arousal_high", arousal_alert, target_human)
			if(75 to INFINITY) //to prevent that 101 arousal that can make icon disappear or something.
				throw_arousalalert("arousal_max", arousal_alert, target_human)

		if(target_human.arousal > 1)
			switch(target_human.pain)
				if(-100 to 1) //to prevent same thing with pain
					arousal_alert?.cut_overlay(arousal_alert.pain_overlay)
				if(1 to 25)
					overlay_pain("small", arousal_alert)
				if(25 to 50)
					overlay_pain("medium", arousal_alert)
				if(50 to 75)
					overlay_pain("high", arousal_alert)
				if(75 to INFINITY)
					overlay_pain("max", arousal_alert)

		if(target_human.arousal > 1)
			switch(target_human.pleasure)
				if(-100 to 1) //to prevent same thing with pleasure
					arousal_alert?.cut_overlay(arousal_alert.pleasure_overlay)
				if(1 to 25)
					overlay_pleasure("small", arousal_alert)
				if(25 to 60)
					overlay_pleasure("medium", arousal_alert)
				if(60 to 85)
					overlay_pleasure("high", arousal_alert)
				if(85 to INFINITY)
					overlay_pleasure("max", arousal_alert)
		else
			if(arousal_alert?.pleasure_level in list("small", "medium", "high", "max"))
				arousal_alert.cut_overlay(arousal_alert.pleasure_overlay)
			if(arousal_alert?.pain_level in list("small", "medium", "high", "max"))
				arousal_alert.cut_overlay(arousal_alert.pain_overlay)

/datum/emote/living/cum
	key = "cum"
	key_third_person = "cums"
	cooldown = 30 SECONDS

/datum/emote/living/cum/check_config()
	return !CONFIG_GET(flag/disable_erp_preferences)

/datum/emote/living/cum/can_run_emote(mob/user, status_check = TRUE, intentional = FALSE)
	if (!check_config())
		return FALSE
	. = ..()

/datum/emote/living/cum/run_emote(mob/living/user, params, type_override, intentional)
	if (!check_config())
		return
	. = ..()
	if(!.)
		return


	var/obj/item/coomer = new /obj/item/hand_item/coom(user)
	var/mob/living/carbon/human/target = user
	var/obj/item/held = user.get_active_held_item()
	var/obj/item/unheld = user.get_inactive_held_item()
	if(user.put_in_hands(coomer) && target.dna.species.mutant_bodyparts["testicles"] && target.dna.species.mutant_bodyparts["penis"])
		if(held || unheld)
			if(!((held.name == "cum" && held.item_flags == DROPDEL | ABSTRACT | HAND_ITEM) || (unheld.name == "cum" && unheld.item_flags == DROPDEL | ABSTRACT | HAND_ITEM)))
				to_chat(user, span_notice("You mentally prepare yourself to masturbate."))
			else
				qdel(coomer)
		else
			to_chat(user, span_notice("You mentally prepare yourself to masturbate."))
	else
		qdel(coomer)
		to_chat(user, span_warning("You're incapable of masturbating."))

/obj/item/hand_item/coom
	name = "cum"
	desc = "C-can I watch...?"
	icon = 'icons/obj/hydroponics/harvest.dmi'
	icon_state = "eggplant"
	inhand_icon_state = "nothing"

/obj/item/hand_item/coom/attack(mob/living/target, mob/user, proximity)
	if (CONFIG_GET(flag/disable_erp_preferences))
		return
	if(!proximity)
		return
	if(!ishuman(target))
		return
	if(user.stat == DEAD)
		return
	var/mob/living/carbon/human/human_cumvictim = target
	if(!human_cumvictim.client)
		to_chat(user, span_warning("You can't cum onto [target]."))
		return
	var/mob/living/carbon/human/affected_human = user
	var/obj/item/organ/external/genital/testicles/testicles = affected_human.getorganslot(ORGAN_SLOT_TESTICLES)
	var/obj/item/organ/external/genital/penis/penis = affected_human.getorganslot(ORGAN_SLOT_PENIS)
	var/datum/sprite_accessory/genital/penis_accessory = GLOB.sprite_accessories["penis"][affected_human.dna.species.mutant_bodyparts["penis"][MUTANT_INDEX_NAME]]
	if(penis_accessory.is_hidden(affected_human))
		to_chat(user, span_notice("You need to expose yourself in order to masturbate."))
		return
	else if(penis.aroused != AROUSAL_FULL)
		to_chat(user, span_notice("You need to be aroused in order to masturbate."))
		return
	var/cum_volume = testicles.genital_size * 5 + 5
	var/datum/reagents/applied_reagents = new/datum/reagents(50)
	applied_reagents.add_reagent(/datum/reagent/consumable/cum, cum_volume)
	if(target == user)
		user.visible_message(span_warning("[user] starts masturbating onto [target.p_them()]self!"), span_danger("You start masturbating onto yourself!"))
	else
		user.visible_message(span_warning("[user] starts masturbating onto [target]!"), span_danger("You start masturbating onto [target]!"))
	if(do_after(user, 60, target))
		if(target == user)
			user.visible_message(span_warning("[user] cums on [target.p_them()]self!"), span_danger("You cum on yourself!"))
		else
			user.visible_message(span_warning("[user] cums on [target]!"), span_danger("You cum on [target]!"))
		applied_reagents.expose(target, TOUCH)
		log_combat(user, target, "came on")
		if(prob(40))
			affected_human.try_lewd_autoemote("moan")
		qdel(src)

// Jerk off into bottles
/obj/item/hand_item/coom/afterattack(obj/target, mob/user, proximity)
	. = ..()
	if (CONFIG_GET(flag/disable_erp_preferences))
		return
	if(!proximity)
		return
	if(ishuman(target))
		return
	if(user.stat == DEAD)
		return
	var/mob/living/carbon/human/affected_human = user
	var/obj/item/organ/external/genital/testicles/testicles = affected_human.getorganslot(ORGAN_SLOT_TESTICLES)
	var/obj/item/organ/external/genital/penis/penis = affected_human.getorganslot(ORGAN_SLOT_PENIS)
	var/datum/sprite_accessory/genital/spriteP = GLOB.sprite_accessories["penis"][affected_human.dna.species.mutant_bodyparts["penis"][MUTANT_INDEX_NAME]]
	if(spriteP.is_hidden(affected_human))
		to_chat(user, span_notice("You need to expose yourself in order to masturbate."))
		return
	else if(penis.aroused != AROUSAL_FULL)
		to_chat(user, span_notice("You need to be aroused in order to masturbate."))
		return
	if(target.is_refillable() && target.is_drainable())
		var/cum_volume = testicles.genital_size*5+5
		if(target.reagents.holder_full())
			to_chat(user, span_warning("[target] is full."))
			return
		var/datum/reagents/applied_reagents = new/datum/reagents(50)
		applied_reagents.add_reagent(/datum/reagent/consumable/cum, cum_volume)
		user.visible_message(span_warning("[user] starts masturbating into [target]!"), span_danger("You start masturbating into [target]!"))
		if(do_after(user, 60))
			user.visible_message(span_warning("[user] cums into [target]!"), span_danger("You cum into [target]!"))
			playsound(target, SFX_DESECRATION, 50, TRUE, ignore_walls = FALSE)
			applied_reagents.trans_to(target, cum_volume)
			if(prob(40))
				affected_human.try_lewd_autoemote("moan")
			qdel(src)
	else
		user.visible_message(span_warning("[user] starts masturbating onto [target]!"), span_danger("You start masturbating onto [target]!"))
		if(do_after(user, 60))
			user.visible_message(span_warning("[user] cums on [target]!"), span_danger("You cum on [target]!"))
			playsound(target, SFX_DESECRATION, 50, TRUE, ignore_walls = FALSE)
			affected_human.add_cum_splatter_floor(get_turf(target))
			if(prob(40))
				affected_human.try_lewd_autoemote("moan")

			if(target.icon_state=="stickyweb1"|target.icon_state=="stickyweb2")
				target.icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/obj/lewd_decals/lewd_decals.dmi'
			qdel(src)
