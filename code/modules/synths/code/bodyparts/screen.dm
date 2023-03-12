/obj/item/organ/external/screen
	name = "screen"
	preference = "feature_ipc_screen"
	organ_flags = ORGAN_ROBOTIC

	bodypart_overlay = /datum/bodypart_overlay/mutant/screen

	zone = BODY_ZONE_HEAD

/datum/bodypart_overlay/mutant/screen
	sprite_datum = /datum/sprite_accessory/screen/blue
	layers = EXTERNAL_FRONT_UNDER_CLOTHES
	feature_key = MUTANT_SYNTH_SCREEN
	color_source = ORGAN_COLOR_OVERRIDE

/datum/bodypart_overlay/mutant/screen/override_color(obj/item/bodypart/bodypart)
	return bodypart.owner.dna.features["[MUTANT_SYNTH_SCREEN]_color"]
