/datum/greyscale_layer
	var/layer_type
	var/list/color_ids
	var/blend_mode
	var/bitmask = FALSE

	var/static/list/json_readers

/datum/greyscale_layer/New(icon_file, list/json_data)
	if(!json_readers)
		json_readers = list()
		for(var/path in subtypesof(/datum/json_reader))
			json_readers[path] = new path

	json_data -= "type" // This is used to look us up and doesn't need to be verified like the rest of the data

	ReadJsonData(json_data)
	Initialize(icon_file)

/// Override this to do initial set up
/datum/greyscale_layer/proc/Initialize(icon_file)
	return

/// Override this if you need to do something during a full config refresh from disk, return TRUE if something was changed
/datum/greyscale_layer/proc/DiskRefresh()
	return FALSE

/// Handles the processing of the json data and conversion to correct value types.
/// Will error on incorrect, missing, or unexpected values.
/datum/greyscale_layer/proc/ReadJsonData(list/json_data)
	var/list/required_values = list()
	var/list/optional_values = list()
	GetExpectedValues(required_values, optional_values)
	for(var/keyname in json_data)
		if(required_values[keyname] && optional_values[keyname])
			stack_trace("Key '[keyname]' found in both required and optional lists. Make sure keys are only in one or the other.")
			continue
		if(!required_values[keyname] && !optional_values[keyname])
			stack_trace("Unknown key found in json for [src]: '[keyname]'")
			continue
		if(!(keyname in vars))
			stack_trace("[src] expects a value from '[keyname]' but has no var to hold the output.")
			continue
		var/datum/json_reader/reader = required_values[keyname] || optional_values[keyname]
		reader = json_readers[reader]
		if(!reader)
			stack_trace("[src] has an invalid json reader type '[required_values[keyname]]' for key '[keyname]'.")
			continue
		vars[keyname] = reader.ReadJson(json_data[keyname])

	// Final check to make sure we got everything we needed
	for(var/keyname in required_values)
		if(isnull(json_data[keyname]))
			stack_trace("[src] is missing required json data key '[keyname]'.")

/// Gathers information from the layer about what variables are expected in the json.
/// Override and add to the two argument lists if you want extra information in your layer.
/// The lists are formatted like keyname:keytype_define.
/// The key name is assigned to the var named the same on the layer type.
/datum/greyscale_layer/proc/GetExpectedValues(list/required_values, list/optional_values)
	optional_values[NAMEOF(src, color_ids)] = /datum/json_reader/number_color_list
	required_values[NAMEOF(src, blend_mode)] = /datum/json_reader/blend_mode

/// Use this proc for extra verification needed by a particular layer, gets run after all greyscale configs have finished reading their json files.
/datum/greyscale_layer/proc/CrossVerify()
	return

/// Used to actualy create the layer using the given colors
/// Do not override, use InternalGenerate instead
/datum/greyscale_layer/proc/Generate(list/colors, list/render_steps, do_bitmask, bitmask_step)
	var/list/processed_colors = list()
	for(var/i in color_ids)
		if(isnum(i))
			processed_colors += colors[i]
		else
			processed_colors += i
	return InternalGenerate(processed_colors, render_steps, do_bitmask, bitmask_step)

/// Override this to implement layers.
/// The colors var will only contain colors that this layer is configured to use.
/datum/greyscale_layer/proc/InternalGenerate(list/colors, list/render_steps, do_bitmask, bitmask_step)

////////////////////////////////////////////////////////
// Subtypes

/// The most basic greyscale layer; a layer which is created from a single icon_state in the given icon file
/datum/greyscale_layer/icon_state
	layer_type = "icon_state"
	var/icon_state
	var/icon_file
	var/icon/icon
	var/color_id

/datum/greyscale_layer/icon_state/Initialize(icon_file)
	. = ..()
	src.icon_file = icon_file
	var/list/icon_states = icon_states(icon_file)
	var/state_to_check
	if(bitmask)
		state_to_check = "[icon_state]-0"
	else
		state_to_check = icon_state
	if(!(state_to_check in icon_states))
		CRASH("Configured icon state \[[state_to_check]\] was not found in [icon_file]. Double check your json configuration.")
	icon = new(icon_file, state_to_check)

	if(length(color_ids) > 1)
		CRASH("Icon state layers can not have more than one color id")

/datum/greyscale_layer/icon_state/GetExpectedValues(list/required_values, list/optional_values)
	. = ..()
	required_values[NAMEOF(src, icon_state)] = /datum/json_reader/text
	optional_values[NAMEOF(src, bitmask)] = /datum/json_reader/number

/datum/greyscale_layer/icon_state/InternalGenerate(list/colors, list/render_steps, do_bitmask, bitmask_step)
	. = ..()
	var/icon/new_icon
	if(bitmask && do_bitmask)
		new_icon = icon(icon_file, "[icon_state]-[bitmask_step]")
	else
		new_icon = icon(icon)
	if(length(colors))
		new_icon.Blend(colors[1], ICON_MULTIPLY)
	return new_icon

/// A layer created by using another greyscale icon's configuration
/datum/greyscale_layer/reference
	layer_type = "reference"
	var/icon_state
	var/datum/greyscale_config/reference_type

/datum/greyscale_layer/reference/GetExpectedValues(list/required_values, list/optional_values)
	. = ..()
	optional_values[NAMEOF(src, icon_state)] = /datum/json_reader/text
	required_values[NAMEOF(src, reference_type)] = /datum/json_reader/greyscale_config

/datum/greyscale_layer/reference/DiskRefresh()
	. = ..()
	return reference_type.Refresh(loadFromDisk=TRUE)

/datum/greyscale_layer/reference/InternalGenerate(list/colors, list/render_steps, do_bitmask, bitmask_step)
	if(render_steps)
		return reference_type.GenerateBundle(colors, render_steps)
	else
		return reference_type.Generate(colors.Join(), null, do_bitmask, bitmask_step)
