/// -- The loadout manager and UI --

/// Global list of all loadout categories singletons
/// This is global (rather than just static on the loadout middleware datum)
/// just so we can ensure it is loaded regardless of whether someone opens the loadout UI
/// (because it also inits our loadout datums)
GLOBAL_LIST_INIT(loadout_categories, init_loadout_categories())

/// Inits the loadout categories list
/proc/init_loadout_categories()
	. = list()
	for(var/category_type in subtypesof(/datum/loadout_category))
		. += new category_type()

/// Datum holder for the loadout manager UI.
/// Future todo: Merge this entirely with the prefs UI
/datum/preference_middleware/loadout
	action_delegations = list(
		"select_item" = PROC_REF(action_select_item),
		"clear_all_items" = PROC_REF(action_clear_all),
		"toggle_job_clothes" = PROC_REF(action_toggle_job_outfit),
		"toggle_loadout_clothes" = PROC_REF(action_toggle_loadout_outfit),
		"pass_to_loadout_item" = PROC_REF(action_pass_to_loadout_item),
	)

	/// Our currently open greyscaling menu.
	VAR_FINAL/datum/greyscale_modify_menu/greyscaling_menu

/datum/preference_middleware/loadout/Destroy(force, ...)
	QDEL_NULL(greyscaling_menu)
	return ..()

/datum/preference_middleware/loadout/proc/action_select_item(list/params, mob/user)
	var/path_to_use = text2path(params["path"])
	var/datum/loadout_item/interacted_item = GLOB.all_loadout_datums[path_to_use]
	if(!istype(interacted_item))
		stack_trace("Failed to locate desired loadout item (path: [params["path"]]) in the global list of loadout datums!")
		return TRUE // update

	if(params["deselect"])
		deselect_item(interacted_item)
	else
		select_item(interacted_item)
	preferences.character_preview_view.update_body()
	return TRUE

/datum/preference_middleware/loadout/proc/action_clear_all(list/params, mob/user)
	preferences.update_preference(GLOB.preference_entries[/datum/preference/loadout], null)
	preferences.character_preview_view.update_body()
	return TRUE

/datum/preference_middleware/loadout/proc/action_toggle_job_outfit(list/params, mob/user)
	preferences.character_preview_view.view_job_clothes = !preferences.character_preview_view.view_job_clothes
	preferences.character_preview_view.update_body()
	return TRUE

/datum/preference_middleware/loadout/proc/action_toggle_loadout_outfit(list/params, mob/user)
	preferences.character_preview_view.view_loadout_clothes = !preferences.character_preview_view.view_loadout_clothes
	preferences.character_preview_view.update_body()
	return TRUE

/datum/preference_middleware/loadout/proc/action_pass_to_loadout_item(list/params, mob/user)
	var/path_to_use = text2path(params["path"])
	var/datum/loadout_item/interacted_item = GLOB.all_loadout_datums[path_to_use]
	if(!istype(interacted_item))
		stack_trace("Failed to locate desired loadout item (path: [params["path"]]) in the global list of loadout datums!")
		return TRUE // update

	if(interacted_item.handle_loadout_action(src, user, params["subaction"]))
		preferences.character_preview_view.update_body()
		return TRUE

	return FALSE

/// Select [path] item to [category_slot] slot.
/datum/preference_middleware/loadout/proc/select_item(datum/loadout_item/selected_item)
	var/list/loadout = preferences.read_preference(/datum/preference/loadout)
	var/list/datum/loadout_item/loadout_datums = loadout_list_to_datums(loadout)
	for(var/datum/loadout_item/item as anything in loadout_datums)
		if(item.category != selected_item.category)
			continue

		if(!item.category.handle_duplicate_entires(src, item, selected_item, loadout_datums))
			return

	LAZYSET(loadout, selected_item.item_path, list())
	preferences.update_preference(GLOB.preference_entries[/datum/preference/loadout], loadout)

/// Deselect [deselected_item].
/datum/preference_middleware/loadout/proc/deselect_item(datum/loadout_item/deselected_item)
	var/list/loadout = preferences.read_preference(/datum/preference/loadout)
	LAZYREMOVE(loadout, deselected_item.item_path)
	preferences.update_preference(GLOB.preference_entries[/datum/preference/loadout], loadout)

/datum/preference_middleware/loadout/proc/register_greyscale_menu(datum/greyscale_modify_menu/open_menu)
	src.greyscaling_menu = open_menu
	RegisterSignal(greyscaling_menu, COMSIG_PARENT_QDELETING, PROC_REF(cleanup_greyscale_menu))

/datum/preference_middleware/loadout/proc/cleanup_greyscale_menu()
	SIGNAL_HANDLER
	greyscaling_menu = null

/datum/preference_middleware/loadout/get_ui_data(mob/user)
	var/list/data = list()

	var/list/all_selected_paths = list()
	for(var/path in preferences.read_preference(/datum/preference/loadout))
		all_selected_paths += path

	data["selected_loadout"] = all_selected_paths
	data["mob_name"] = preferences.read_preference(/datum/preference/name/real_name)
	data["job_clothes"] = preferences.character_preview_view.view_job_clothes
	data["loadout_clothes"] = preferences.character_preview_view.view_loadout_clothes

	return data

/datum/preference_middleware/loadout/get_ui_static_data(mob/user)
	var/list/data = list()

	// This should all be moved to constant data when I figure out how tee hee
	var/static/list/loadout_tabs
	if(isnull(loadout_tabs))
		loadout_tabs = list()
		for(var/datum/loadout_category/category as anything in GLOB.loadout_categories)
			loadout_tabs += list(list(
				"name" = category.category_name,
				"title" = category.ui_title,
				"contents" = category.items_to_ui_data(),
			))

	data["loadout_tabs"] = loadout_tabs
	data["tutorial_text"] = get_tutorial_text()
	return data

/// Returns a formatted string for use in the UI.
/datum/preference_middleware/loadout/proc/get_tutorial_text()
	return {"This is the Loadout Manager.
It allows you to customize what your character will wear on shift start in addition to their job's uniform.

Only one item can be selected per tab, with the exception of backpack items (three items are allowed in total).

Some items have tooltips displaying additional information about how they work.
Some items are compatible with greyscale coloring! You can choose what color they spawn as
by selecting the item, then by pressing the paint icon next to it and using the greyscaling UI.

Your loadout items will override the corresponding item in your job's outfit,
with the exception being BELT, EAR, and GLASSES items,
which will be placed in your backpack to prevent important items being deleted.

Additionally, UNDERSUITS, HELMETS, MASKS, and GLOVES loadout items
selected by plasmamen will spawn in their backpack instead of overriding their clothes
to avoid an untimely and sudden death by fire or suffocation at the start of the shift."}
