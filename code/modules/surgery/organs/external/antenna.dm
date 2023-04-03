/obj/item/organ/external/synth_antenna
	name = "synth antenna"
	preference = "feature_ipc_antenna"
	organ_flags = ORGAN_ROBOTIC

	bodypart_overlay = /datum/bodypart_overlay/mutant/synth_antenna

	zone = BODY_ZONE_HEAD
	slot = MUTANT_SYNTH_ANTENNA

/datum/bodypart_overlay/mutant/synth_antenna
	layers = EXTERNAL_ADJACENT
	feature_key = MUTANT_SYNTH_ANTENNA
	color_source = ORGAN_COLOR_OVERRIDE

/datum/bodypart_overlay/mutant/synth_antenna/get_global_feature_list()
	return GLOB.synth_antennae

/datum/bodypart_overlay/mutant/synth_antenna/override_color(obj/item/bodypart/bodypart)
	return bodypart.owner.dna.features["[MUTANT_SYNTH_ANTENNA]_color"]

/datum/bodypart_overlay/mutant/synth_antenna/can_draw_on_bodypart(mob/living/carbon/human/human)
	if(!(human.head?.flags_inv & HIDEEARS) && !(human.wear_mask?.flags_inv & HIDEEARS))
		return TRUE
	return FALSE
