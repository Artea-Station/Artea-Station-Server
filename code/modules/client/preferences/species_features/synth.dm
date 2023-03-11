/datum/preference/choiced/synth_brain
	category = PREFERENCE_CATEGORY_APPEARANCE
	savefile_key = "synth_brain"
	savefile_identifier = PREFERENCE_CHARACTER
	priority = PREFERENCE_PRIORITY_NAMES // Apply after species, cause that's super important.
	should_generate_icons = TRUE

/datum/preference/choiced/synth_brain/init_possible_values()
	return list(ORGAN_PREF_POSI_BRAIN = icon(), ORGAN_PREF_MMI_BRAIN, ORGAN_PREF_CIRCUIT_BRAIN)

/datum/preference/choiced/synth_brain/create_default_value()
	return ORGAN_PREF_CIRCUIT_BRAIN

/datum/preference/choiced/synth_brain/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	if(!issynthetic(target))
		return

	var/obj/item/organ/internal/brain/new_brain

	switch(value)
		if(ORGAN_PREF_CIRCUIT_BRAIN)
			new_brain = /obj/item/organ/internal/brain/synth/circuit
		if(ORGAN_PREF_MMI_BRAIN)
			new_brain = /obj/item/organ/internal/brain/synth/mmi
		if(ORGAN_PREF_POSI_BRAIN)
			new_brain = /obj/item/organ/internal/brain/synth

	var/obj/item/organ/internal/brain/old_brain = target.getorganslot(ORGAN_SLOT_BRAIN)

	if(!new_brain)
		CRASH("Synth brain preference has an invalid value of [value]!")

	if(new_brain == old_brain.type)
		return

	var/datum/mind/keep_me_safe = target.mind

	new_brain = new new_brain()
	new_brain.Insert(target, drop_if_replaced = FALSE)

	// Prefs can be applied to mindless mobs, let's not try to move the non-existent mind back in!
	if(!keep_me_safe)
		return

	keep_me_safe.transfer_to(target, TRUE)

/// IPC Screens

/datum/preference/choiced/mutant/synth_screen
	savefile_key = "feature_ipc_screen"
	main_feature_name = "IPC Screen"
	relevant_mutant_bodypart = MUTANT_SYNTH_SCREEN
	crop_area = list(11, 22, 21, 32) // We want just the head.
	greyscale_color = DEFAULT_SYNTH_SCREEN_COLOR
	color_feature_id = "synth_screen_color"

/datum/preference/choiced/mutant/synth_screen/generate_icon_state(datum/sprite_accessory/sprite_accessory, original_icon_state)
	return "m_ipc_screen_[original_icon_state]_FRONT_UNDER"

/datum/preference/color/mutant/synth_screen_color
	savefile_key = "synth_screen_color"
	relevant_mutant_bodypart = MUTANT_SYNTH_SCREEN

// ARTEA TODO: Emissives but not shit and broken
// /datum/preference/toggle/emissive/ipc_screen_emissive
// 	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
// 	savefile_identifier = PREFERENCE_CHARACTER
// 	savefile_key = "ipc_screen_emissive"
// 	relevant_mutant_bodypart = MUTANT_SYNTH_SCREEN

/// IPC Antennas

/datum/preference/choiced/mutant/synth_antenna
	main_feature_name = "Synth Antennae"
	savefile_key = "feature_ipc_antenna"
	relevant_mutant_bodypart = MUTANT_SYNTH_ANTENNA
	crop_area = list(11, 22, 21, 32) // We want just the head.
	color_feature_id = "ipc_antenna_color"
	greyscale_color = DEFAULT_SYNTH_PART_COLOR

/datum/preference/color/mutant/synth_antenna
	savefile_key = "ipc_antenna_color"
	relevant_mutant_bodypart = MUTANT_SYNTH_ANTENNA

// ARTEA TODO: Emissives but not shit and broken
// /datum/preference/tri_bool/synth_antenna_emissive
// 	category = PREFERENCE_CATEGORY_APPEARANCE_LIST
// 	savefile_identifier = PREFERENCE_CHARACTER
// 	savefile_key = "ipc_antenna_emissive"
// 	relevant_mutant_bodypart = MUTANT_SYNTH_ANTENNA

/// IPC Chassis

/datum/preference/choiced/mutant/synth_chassis
	savefile_key = "feature_ipc_chassis"
	main_feature_name = "Chassis Appearance"
	relevant_mutant_bodypart = MUTANT_SYNTH_CHASSIS
	crop_area = list(8, 8, 24, 24) // We want just the body.
	greyscale_color = DEFAULT_SYNTH_PART_COLOR

/datum/preference/choiced/mutant/synth_chassis/generate_icon_state(datum/sprite_accessory/sprite_accessory, original_icon_state)
	// If this isn't the right type, we have much bigger problems.
	var/datum/sprite_accessory/synth_chassis/chassis = sprite_accessory
	return "[original_icon_state]_chest[chassis.dimorphic ? "_m" : ""]"

/datum/preference/color/mutant/synth_chassis
	category = PREFERENCE_CATEGORY_SUPPLEMENTAL_FEATURES
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "ipc_chassis_color"
	relevant_mutant_bodypart = MUTANT_SYNTH_CHASSIS

/// IPC Head

/datum/preference/choiced/mutant/synth_head
	savefile_key = "feature_ipc_head"
	main_feature_name = "Head Appearance"
	relevant_mutant_bodypart = MUTANT_SYNTH_HEAD
	should_generate_icons = TRUE
	crop_area = list(11, 22, 21, 32) // We want just the head.
	greyscale_color = DEFAULT_SYNTH_PART_COLOR
	color_feature_id = "ipc_head_color"
	sprite_accessory = /datum/sprite_accessory/synth_head

/datum/preference/choiced/mutant/synth_head/generate_icon_state(datum/sprite_accessory/sprite_accessory, original_icon_state)
	// If this isn't the right type, we have much bigger problems.
	var/datum/sprite_accessory/synth_head/head = sprite_accessory
	return "[original_icon_state]_head[head.dimorphic ? "_m" : ""]"

/datum/preference/color/mutant/synth_head
	savefile_key = "ipc_head_color"
	relevant_mutant_bodypart = MUTANT_SYNTH_HEAD

// Synth Hair Opacity

/datum/preference/toggle/hair_opacity
	category = PREFERENCE_CATEGORY_APPEARANCE_LIST
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "feature_hair_opacity_toggle"

/datum/preference/toggle/hair_opacity/is_accessible(datum/preferences/preferences)
	..()
	if(!preferences)
		return FALSE
	var/datum/species/species = preferences.read_preference(/datum/preference/choiced/species)
	if(!species)
		return FALSE // Fuck knows why this would be null, but I'm not risking it.
	var/list/traits = initial(species.species_traits)
	return (HAIR in traits) // Sadly, hair opacity doesn't work on species without hair, so let's skip the confusion.

/datum/preference/numeric/hair_opacity
	category = PREFERENCE_CATEGORY_APPEARANCE_LIST
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "feature_hair_opacity"
	relevant_mutant_bodypart = MUTANT_SYNTH_HAIR
	maximum = 255
	minimum = 40 // Any lower, and hair's borderline invisible on lighter colours.

/datum/preference/numeric/hair_opacity/create_default_value()
	return maximum

/datum/preference/numeric/hair_opacity/is_accessible(datum/preferences/preferences)
	..()
	if(!preferences)
		return FALSE
	var/datum/species/species = preferences.read_preference(/datum/preference/choiced/species)
	if(!species)
		return FALSE // Fuck knows why this would be null, but I'm not risking it.
	var/list/traits = initial(species.species_traits)
	return (HAIR in traits) && preferences.read_preference(/datum/preference/toggle/hair_opacity)

/datum/preference/numeric/hair_opacity/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	if(!preferences || !is_accessible(target, preferences))
		return FALSE

	target.hair_alpha = value
	return TRUE
