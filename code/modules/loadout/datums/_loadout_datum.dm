// -- The loadout item datum and related procs. --

/**
 * # Loadout item datum
 *
 * Singleton that holds all the information about each loadout items, and how to equip them.
 */
/datum/loadout_item
	/// Displayed name of the loadout item.
	var/name
	/// Whether this item has greyscale support.
	/// Only works if the item is compatible with the GAGS system of coloring.
	/// Set automatically to TRUE for all items that have the flag [IS_PLAYER_COLORABLE_1].
	/// If you really want it to not be colorable set this to [LOADOUT_DONT_GREYSCALE]
	var/can_be_greyscale = FALSE
	/// Whether this item can be renamed.
	/// I recommend you apply this sparingly becuase it certainly can go wrong (or get reset / overridden easily)
	var/can_be_named = FALSE
	/// Whether this item can be reskinned.
	/// Only works if the item has a "unique reskin" list set.
	var/can_be_reskinned = FALSE
	/// The category of the loadout item. Set automatically in New
	VAR_FINAL/datum/loadout_category/category
	/// The abstract parent of this loadout item, to determine which items to not instantiate
	var/abstract_type = /datum/loadout_item
	/// The actual item path of the loadout item.
	var/obj/item/item_path
	/// Lazylist of additional text for the tooltip displayed on this item.
	var/list/additional_tooltip_contents
	/// Should this item be always shown? Used for sanity checks.
	var/always_shown = TRUE
	/// Priority of the item. Lower is sorted first.
	var/priority = 0

/datum/loadout_item/New(category)
	src.category = category

	if(!name)
		// Saves a ton of manual data entry. Still leaving the field cause of things like "random x item".
		name = capitalize(initial(item_path.name))

	if(can_be_greyscale == LOADOUT_DONT_GREYSCALE)
		// Explicitly be false if we don't want this to greyscale
		can_be_greyscale = FALSE
	else if(initial(item_path.flags_1) & IS_PLAYER_COLORABLE_1)
		// Otherwise set this automatically to true if it is actually colorable
		can_be_greyscale = TRUE
		// This means that one can add a greyscale item that does not have player colorable set
		// but is still modifyable as a greyscale item in the loadout menu by setting it to true manually
		// Why? I HAVE NO IDEA why you would do that but you sure can

	if(can_be_named)
		// If we're a renamable item, insert the "renamable" tooltip at the beginning of the list.
		add_tooltip(TOOLTIP_RENAMABLE, inverse_order = TRUE)

	if(can_be_greyscale)
		// Likewise, if we're greyscaleable, insert the "greyscaleable" tooltip at the beginning of the list (before renamable)
		add_tooltip(TOOLTIP_GREYSCALE, inverse_order = TRUE)

	if(can_be_reskinned)
		// No need to repeat myself but I will, insert the reskinnable tooltip at the end if we have a reskin available
		add_tooltip(TOOLTIP_RESKINNABLE)

	if(GLOB.all_loadout_datums[item_path])
		stack_trace("Loadout datum collision detected! [item_path] is shared between multiple loadout datums.")
	GLOB.all_loadout_datums[item_path] = src

/datum/loadout_item/Destroy(force, ...)
	if(!force)
		stack_trace("Who's destroying loadout item datums?! This shouldn't really ever be done! (Use FORCE if necessary)")
		return
	GLOB.all_loadout_datums -= item_path
	return ..()

/// Helper to add a tooltip to our tooltip list.
/// If inverse_order is TRUE, we will add to the front instead of the back.
/datum/loadout_item/proc/add_tooltip(tooltip, inverse_order = FALSE)
	LAZYINITLIST(additional_tooltip_contents)

	// No lazyinsert unfortunately
	if(inverse_order)
		additional_tooltip_contents.Insert(1, tooltip)
	else
		additional_tooltip_contents.Add(tooltip)

/**
 * Takes in an action from a loadout manager and applies it
 *
 * Useful for subtypes of loadout items with unique actions
 */
/datum/loadout_item/proc/handle_loadout_action(datum/preference_middleware/loadout/manager, mob/user, action)
	SHOULD_CALL_PARENT(TRUE)

	switch(action)
		if("select_color")
			if(can_be_greyscale)
				set_item_color(manager, user)
				// no update necessary. no change until they interact with the menu

		if("set_name")
			if(can_be_named)
				set_name(manager, user)
				// no update necessary, name is not seen

		if("set_skin")
			if(can_be_reskinned)
				set_skin(manager, user)
				. = TRUE // do an update to show new skin

	return FALSE

/datum/loadout_item/proc/set_item_color(datum/preference_middleware/loadout/manager, mob/user)
	if(manager.greyscaling_menu)
		to_chat(user, span_warning("You already have a greyscaling window open!"))
		return

	var/list/loadout = manager.preferences.read_preference(/datum/preference/loadout)
	var/list/allowed_configs = list()
	if(initial(item_path.greyscale_config))
		allowed_configs += "[initial(item_path.greyscale_config)]"
	if(initial(item_path.greyscale_config_worn))
		allowed_configs += "[initial(item_path.greyscale_config_worn)]"
	if(initial(item_path.greyscale_config_inhand_left))
		allowed_configs += "[initial(item_path.greyscale_config_inhand_left)]"
	if(initial(item_path.greyscale_config_inhand_right))
		allowed_configs += "[initial(item_path.greyscale_config_inhand_right)]"

	var/datum/greyscale_modify_menu/menu = new(
		manager,
		user,
		allowed_configs,
		CALLBACK(src, PROC_REF(set_slot_greyscale), manager),
		starting_icon_state = initial(item_path.icon_state),
		starting_config = initial(item_path.greyscale_config),
		starting_colors = loadout?[item_path]?[LOADOUT_DATA_GREYSCALE] || initial(item_path.greyscale_colors),
	)

	manager.register_greyscale_menu(menu)
	menu.ui_interact(user)

/// Sets [category_slot]'s greyscale colors to the colors in the currently opened [open_menu].
/datum/loadout_item/proc/set_slot_greyscale(datum/preference_middleware/loadout/manager, datum/greyscale_modify_menu/open_menu)
	if(!istype(open_menu))
		CRASH("set_slot_greyscale called without a greyscale menu!")

	var/list/loadout = manager.preferences.read_preference(/datum/preference/loadout)
	if(!loadout?[item_path])
		manager.select_item(src)

	var/list/colors = open_menu.split_colors
	if(!colors)
		return

	loadout[item_path][LOADOUT_DATA_GREYSCALE] = colors.Join("")
	manager.preferences.update_preference(GLOB.preference_entries[/datum/preference/loadout], loadout)
	manager.preferences.character_preview_view.update_body()

/datum/loadout_item/proc/set_name(datum/preference_middleware/loadout/manager, mob/user)
	var/list/loadout = manager.preferences.read_preference(/datum/preference/loadout)
	var/input_name = tgui_input_text(
		user = user,
		message = "What name do you want to give [name]? Leave blank to clear.",
		title = "[name] name",
		default = loadout?[item_path]?[LOADOUT_DATA_NAMED], // plop in existing name (if any)
		max_length = MAX_NAME_LEN,
	)
	if(QDELETED(src) || QDELETED(user) || QDELETED(manager) || QDELETED(manager.preferences))
		return

	if(!islist(loadout?[item_path]))
		manager.select_item(src)

	if(input_name)
		loadout[item_path][LOADOUT_DATA_NAMED] = input_name
	else
		loadout[item_path] -= LOADOUT_DATA_NAMED

	manager.preferences.update_preference(GLOB.preference_entries[/datum/preference/loadout], loadout)

/datum/loadout_item/proc/set_skin(datum/preference_middleware/loadout/manager, mob/user)
	var/list/loadout = manager.preferences.read_preference(/datum/preference/loadout)
	var/static/list/list/cached_reskins = list()
	if(!islist(cached_reskins[item_path]))
		var/obj/item/item_template = new item_path()
		cached_reskins[item_path] = item_template.unique_reskin.Copy()
		qdel(item_template)

	var/list/choices = cached_reskins[item_path].Copy()
	choices["Default"] = TRUE

	var/input_skin = tgui_input_list(
		user = user,
		message = "What skin do you want this to be?",
		title = "Reskin [name]",
		items = choices,
		default = loadout?[item_path]?[LOADOUT_DATA_RESKIN],
	)
	if(QDELETED(src) || QDELETED(user) || QDELETED(manager) || QDELETED(manager.preferences))
		return

	if(!islist(loadout?[item_path]))
		manager.select_item(src)
		if(!islist(loadout?[item_path]))
			user.show_message(span_warning("Unable to apply [name] as chosen loadout item for [category.category_name], aborting!"))
			return

	if(!input_skin || input_skin == "Default")
		loadout[item_path] -= LOADOUT_DATA_RESKIN
	else
		loadout[item_path][LOADOUT_DATA_RESKIN] = input_skin

	manager.preferences.update_preference(GLOB.preference_entries[/datum/preference/loadout], loadout)
	manager.preferences.character_preview_view.update_body()

/**
 * Place our [var/item_path] into [outfit].
 *
 * By default, just adds the item into the outfit's backpack contents, if non-visual.
 *
 * outfit - The outfit we're equipping our items into.
 * equipper - If we're equipping out outfit onto a mob at the time, this is the mob it is equipped on. Can be null.
 * visual - If TRUE, then our outfit is only for visual use (for example, a preview).
 */
/datum/loadout_item/proc/insert_path_into_outfit(datum/outfit/outfit, mob/living/carbon/human/equipper, visuals_only = FALSE)
	if(!visuals_only)
		LAZYADD(outfit.backpack_contents, item_path)

/**
 * Called When the item is equipped on [equipper].
 *
 * preference_source - the datum/preferences our loadout item originated from - cannot be null
 * equipper - the mob we're equipping this item onto - cannot be null
 * visuals_only - whether or not this is only concerned with visual things (not backpack, not renaming, etc)
 */
/datum/loadout_item/proc/on_equip_item(datum/preferences/preference_source, mob/living/carbon/human/equipper, visuals_only = FALSE, list/preference_list)
	var/obj/item/equipped_item = locate(item_path) in equipper.get_all_contents()
	if(!equipped_item && always_shown)
		CRASH("[type] on_equip_item(): Could not locate clothing item (path: [item_path]) in [equipper]'s [visuals_only ? "visible":"all"] contents!")

	var/list/item_details = preference_list[item_path]

	if(can_be_greyscale && item_details?[LOADOUT_DATA_GREYSCALE])
		equipped_item.set_greyscale(item_details[LOADOUT_DATA_GREYSCALE])
		equipper.update_clothing(equipped_item.slot_flags)

	if(can_be_named && item_details?[LOADOUT_DATA_NAMED] && !visuals_only)
		equipped_item.name = item_details[LOADOUT_DATA_NAMED]
		equipped_item.renamedByPlayer = TRUE

	if(can_be_reskinned && item_details?[LOADOUT_DATA_RESKIN])
		var/skin_chosen = item_details[LOADOUT_DATA_RESKIN]
		if(skin_chosen in equipped_item.unique_reskin)
			equipped_item.current_skin = skin_chosen
			equipped_item.icon_state = equipped_item.unique_reskin[skin_chosen]
			equipper.update_clothing(equipped_item.slot_flags)
		else
			// Not valid
			item_details -= LOADOUT_DATA_RESKIN
			preference_source.write_preference(GLOB.preference_entries[/datum/preference/loadout], preference_list)

	return equipped_item

/**
 * Called after the item is equipped on [equipper], at the end of character setup.
 *
 * preference_source - the datum/preferences our loadout item originated from - cannot be null
 * equipper - the mob we're equipping this item onto - cannot be null
 */
/datum/loadout_item/proc/post_equip_item(datum/preferences/preference_source, mob/living/carbon/human/equipper, is_visual = FALSE)
	return FALSE

/// Returns a formatted list of data for this loadout item, for use in UIs
/datum/loadout_item/proc/to_ui_data()
	RETURN_TYPE(/list)
	SHOULD_CALL_PARENT(TRUE)

	var/list/formatted_item = list()
	formatted_item["name"] = name
	formatted_item["path"] = item_path
	formatted_item["buttons"] = get_ui_buttons()
	formatted_item["tooltip_text"] = additional_tooltip_contents
	return formatted_item

/**
 * Returns a list of UI buttons for this loadout item
 * These will automatically be turned into buttons in the UI, according to they icon you provide
 * act_key should match a key to handle in [handle_loadout_action] - this is how you react to the button being pressed
 */
/datum/loadout_item/proc/get_ui_buttons()
	SHOULD_CALL_PARENT(TRUE)
	RETURN_TYPE(/list)

	var/list/button_list = list()

	if(can_be_greyscale)
		button_list += list(list(
			"icon" = FA_ICON_PALETTE,
			"act_key" = "select_color",
		))

	if(can_be_named)
		button_list += list(list(
			"icon" = FA_ICON_PEN,
			"act_key" = "set_name",
		))

	if(can_be_reskinned)
		button_list += list(list(
			"icon" = FA_ICON_THEATER_MASKS,
			"act_key" = "set_skin",
		))

	return button_list
