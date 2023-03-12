/obj/item/organ/external/synth_antenna
	name = "synth antenna"
	preference = "feature_ipc_antenna"
	organ_flags = ORGAN_ROBOTIC

	bodypart_overlay = /datum/bodypart_overlay/mutant/synth_antenna

	zone = BODY_ZONE_HEAD

/datum/bodypart_overlay/mutant/synth_antenna
	sprite_datum = /datum/sprite_accessory/antenna/antennae
	layers = EXTERNAL_ADJACENT
	feature_key = MUTANT_SYNTH_ANTENNA
	color_source = ORGAN_COLOR_OVERRIDE

/datum/bodypart_overlay/mutant/synth_antenna/override_color(obj/item/bodypart/bodypart)
	return bodypart.owner.dna.features["[MUTANT_SYNTH_ANTENNA]_color"]
