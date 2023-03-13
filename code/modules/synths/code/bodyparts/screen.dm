/obj/item/organ/external/screen
	name = "screen"
	preference = "feature_ipc_screen"
	organ_flags = ORGAN_ROBOTIC

	bodypart_overlay = /datum/bodypart_overlay/mutant/screen

	zone = BODY_ZONE_HEAD
	slot = MUTANT_SYNTH_SCREEN

/datum/bodypart_overlay/mutant/screen
	layers = EXTERNAL_FRONT_UNDER_CLOTHES
	feature_key = MUTANT_SYNTH_SCREEN
	color_source = ORGAN_COLOR_OVERRIDE

/datum/bodypart_overlay/mutant/screen/get_global_feature_list()
	return GLOB.synth_screens

/datum/bodypart_overlay/mutant/screen/override_color(obj/item/bodypart/bodypart)
	return sprite_datum.color_src ? bodypart.owner.dna.features["[MUTANT_SYNTH_SCREEN]_color"] : null
