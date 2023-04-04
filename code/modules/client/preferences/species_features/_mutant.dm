/datum/preference/choiced/mutant
	priority = PREFERENCE_PRIORITY_NAME_MODIFICATIONS // Otherwise organs will get qdel'd on body replacement.
	abstract_type = /datum/preference/choiced/mutant
	category = PREFERENCE_CATEGORY_APPEARANCE
	savefile_identifier = PREFERENCE_CHARACTER
	should_generate_icons = TRUE
	/// The ID to use for supplemental features. If null, it won't do anything.
	var/color_feature_id
	/// The global list containing the sprite accessories to use. Override New to set.
	var/list/sprite_accessory
	/// The typepath of the external organ to add.
	var/organ_to_add
	/// Direction to render the preview on. Can take NORTH, SOUTH, EAST, WEST.
	var/sprite_direction = SOUTH
	/// A list of types to exclude, including their subtypes.
	var/list/accessories_to_ignore

/datum/preference/choiced/mutant/create_default_value()
	return "None"

/datum/preference/choiced/mutant/init_possible_values()
	return generate_mutant_valid_values(sprite_accessory, sprite_direction, accessories_to_ignore)

/datum/preference/choiced/mutant/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	target.dna.features[relevant_mutant_bodypart] = value
	if(organ_to_add)
		var/datum/sprite_accessory/accessory = sprite_accessory[value]
		if(!accessory)
			CRASH("Accessory is null for [value]!")
		if(accessory.name == "None")
			return
		var/obj/item/organ/external/new_organ_to_add = new organ_to_add(FALSE, accessory.type)
		new_organ_to_add.Insert(target, TRUE, FALSE)

/datum/preference/choiced/mutant/is_accessible(datum/preferences/preferences)
	. = ..()
	var/datum/species/species = preferences.read_preference(/datum/preference/choiced/species)
	species = new species
	if(relevant_mutant_bodypart in species.mutant_bodyparts)
		return TRUE

/datum/preference/choiced/mutant/compile_constant_data()
	. = ..()
	if(color_feature_id)
		.[SUPPLEMENTAL_FEATURE_KEY] = color_feature_id

/datum/preference/color/mutant
	category = PREFERENCE_CATEGORY_SUPPLEMENTAL_FEATURES
	abstract_type = /datum/preference/color/mutant
	savefile_identifier = PREFERENCE_CHARACTER

	/// The path of the mutant choice datum to read from. Important.
	var/choiced_preference_datum

/datum/preference/color/mutant/deserialize(input, datum/preferences/preferences)
	return sanitize_hexcolor_list(splittext(input, ";"))

/datum/preference/color/mutant/serialize(input)
	return "[input[1]];[input[2]];[input[3]]"

/// Helper proc that ensures the list is in the correct format. Potentially destructive.
/datum/preference/color/mutant/proc/sanitize_hexcolor_list(list/input)
	if(!islist(input) || length(input) != 3 || "{" == copytext(json_encode(input), 1, 2))
		return create_default_value()

	for(var/index = 1, index < 4, index++)
		input[index] = sanitize_hexcolor(input[index], include_crunch = FALSE, default = random_color())

	return input

/datum/preference/color/mutant/create_default_value()
	return list(random_color(), random_color(), random_color())

// Fuck you, this is sanitized already, so this is pointless.
/datum/preference/color/mutant/is_valid(value)
	return TRUE

// Mutant color. Used to automagically apply a color to a mutant part. Very nice.
/datum/preference/color/mutant/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	target.dna.features["[relevant_mutant_bodypart]_color"] = value

/datum/preference/color/mutant/compile_ui_data(mob/user, value, datum/preferences/preferences)
	var/datum/preference/choiced/mutant/pref = GLOB.preference_entries[choiced_preference_datum]
	var/datum/sprite_accessory/accessory = pref.sprite_accessory[preferences.read_preference(choiced_preference_datum)]

	var/return_value = list()

	for(var/index = 1, index <= max(accessory.color_layer_names.len, 1), index++)
		return_value += value[index]

	return jointext(return_value, ";")
