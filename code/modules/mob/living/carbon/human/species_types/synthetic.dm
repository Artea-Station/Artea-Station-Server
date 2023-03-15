/datum/species/synthetic
	name = "Synthetic Humanoid"
	id = SPECIES_SYNTH
	say_mod = "beeps"
	inherent_biotypes = MOB_ROBOTIC | MOB_HUMANOID
	inherent_traits = list(
		TRAIT_CAN_STRIP,
		TRAIT_ADVANCEDTOOLUSER,
		TRAIT_RADIMMUNE,
		TRAIT_VIRUSIMMUNE,
		TRAIT_NOBREATH,
		TRAIT_TOXIMMUNE,
		TRAIT_NOCLONELOSS,
		TRAIT_GENELESS,
		TRAIT_STABLEHEART,
		TRAIT_LIMBATTACHMENT,
		TRAIT_LITERATE,
		TRAIT_NOBLOOD,
	)
	species_traits = list(
		ROBOTIC_DNA_ORGANS,
		EYECOLOR,
		HAIR,
		FACEHAIR,
		LIPS,
		ROBOTIC_LIMBS,
		NOTRANSSTING,
	)
	mutant_bodyparts = list(
		"tail" = "None",
		"ears" = "None",
		"legs" = "Normal Legs",
		MUTANT_SYNTH_ANTENNA = "None",
		MUTANT_SYNTH_SCREEN = "None",
		MUTANT_SYNTH_CHASSIS = "Default Chassis",
		MUTANT_SYNTH_HEAD = "Default Head",
	)
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_MAGIC | MIRROR_PRIDE | ERT_SPAWN | RACE_SWAP | SLIME_EXTRACT
	species_language_holder = /datum/language_holder/synthetic
	mutant_organs = list(/obj/item/organ/internal/cyberimp/arm/power_cord)
	mutantbrain = /obj/item/organ/internal/brain/synth
	mutantstomach = /obj/item/organ/internal/stomach/synth
	mutantears = /obj/item/organ/internal/ears/synth
	mutanttongue = /obj/item/organ/internal/tongue/synth
	mutanteyes = /obj/item/organ/internal/eyes/synth
	mutantlungs = /obj/item/organ/internal/lungs/synth
	mutantheart = /obj/item/organ/internal/heart/synth
	mutantliver = /obj/item/organ/internal/liver/synth
	exotic_blood = /datum/reagent/fuel/oil
	bodypart_overrides = list(
		BODY_ZONE_HEAD = /obj/item/bodypart/head/robot/synth,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/robot/synth,
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left/robot/synth,
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right/robot/synth,
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/robot/synth,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/robot/synth,
	)
	digitigrade_customization = DIGITIGRADE_OPTIONAL
	burnmod = 1.3 // Every 0.1 is 10% above the base.
	brutemod = 1.3
	coldmod = 1.2
	heatmod = 2 // TWO TIMES DAMAGE FROM BEING TOO HOT?! WHAT?! No wonder lava is literal instant death for us.
	siemens_coeff = 1.4 // Not more because some shocks will outright crit you, which is very unfun

/datum/species/synthetic/spec_life(mob/living/carbon/human/human)
	if(human.stat == SOFT_CRIT || human.stat == HARD_CRIT)
		human.adjustFireLoss(1) //Still deal some damage in case a cold environment would be preventing us from the sweet release to robot heaven
		human.adjust_bodytemperature(13) //We're overheating!!
		if(prob(10))
			to_chat(human, span_warning("Alert: Critical damage taken! Cooling systems failing!"))
			do_sparks(3, TRUE, human)

/datum/species/synthetic/on_species_gain(mob/living/carbon/human/transformer)
	. = ..()
	var/obj/item/organ/internal/appendix/appendix = transformer.getorganslot(ORGAN_SLOT_APPENDIX)
	if(appendix)
		appendix.Remove(transformer)
		qdel(appendix)

	if(isdummy(transformer)) // This is to make the dummy work properly with the synth parts. Cursed code.
		set_limb_icons(transformer)

/datum/species/synthetic/replace_body(mob/living/carbon/target, datum/species/new_species)
	. = ..()
	set_limb_icons(target)

/datum/species/synthetic/proc/set_limb_icons(mob/living/carbon/target)
	var/head = target.dna.features[MUTANT_SYNTH_HEAD]
	var/chassis = target.dna.features[MUTANT_SYNTH_CHASSIS]
	if(!chassis || !head)
		CRASH("Unable to apply chassis or head due to missing features! ([head] | [chassis])")

	var/datum/sprite_accessory/synth_head/head_of_choice = GLOB.synth_heads[head]
	var/datum/sprite_accessory/synth_chassis/chassis_of_choice = GLOB.synth_chassi[chassis]
	if(!chassis_of_choice || !head_of_choice)
		CRASH("Unable to apply chassis or head due to invalid values! ([head] & [head_of_choice] | [chassis] & [chassis_of_choice])")

	examine_limb_id = chassis_of_choice.icon_state

	if(chassis_of_choice.color_src || head_of_choice.color_src)
		species_traits += MUTCOLORS

	var/head_color = target.dna.features["[MUTANT_SYNTH_HEAD]_color"]
	var/chassis_color = target.dna.features["[MUTANT_SYNTH_CHASSIS]_color"]

	// We want to ensure that the IPC gets their chassis and their head correctly.
	for(var/obj/item/bodypart/limb as anything in target.bodyparts)
		if(initial(limb.limb_id) != SPECIES_SYNTH && initial(limb.limb_id) != "synth_digi") // No messing with limbs that aren't actually synthetic.
			continue

		if(limb.body_zone == BODY_ZONE_HEAD)
			if(head_of_choice.color_src && head_color)
				limb.variable_color = head_color
			else
				limb.variable_color = null
			limb.change_appearance(head_of_choice.icon, head_of_choice.icon_state, !!head_of_choice.color_src, head_of_choice.gender_specific)
			limb.name = "\improper [chassis_of_choice.name] [parse_zone(limb.body_zone)]"
			limb.update_limb(is_creating = TRUE)
			continue

		if(chassis_of_choice.color_src && chassis_color)
			limb.variable_color = chassis_color
		else
			limb.variable_color = null
		limb.change_appearance(chassis_of_choice.icon, chassis_of_choice.icon_state, !!chassis_of_choice.color_src, limb.body_part == CHEST && chassis_of_choice.gender_specific)
		limb.name = "\improper [chassis_of_choice.name] [parse_zone(limb.body_zone)]"
		limb.update_limb(is_creating = TRUE)

/datum/species/synthetic/random_name(gender, unique, lastname)
	var/randname = pick(GLOB.posibrain_names)
	randname = "[randname]-[rand(0, 9)][rand(0, 9)][rand(0, 9)]"
	return randname

/datum/species/synthetic/get_types_to_preload()
	return ..() - typesof(/obj/item/organ/internal/cyberimp/arm/power_cord) // Don't cache things that lead to hard deletions.

/datum/species/synthetic/get_species_description()
	return "Very broad and versitile in appearance and function, synths have been a staple of many a station's crew due to their ease of transport compared to humans."

/datum/species/synthetic/get_species_lore()
	return list("Work in progress.")
