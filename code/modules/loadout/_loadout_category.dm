/**
 * # Loadout categories
 *
 * Loadout categories are singletons used to group loadout items together in the loadout screen.
 */
/datum/loadout_category
	/// The name of the category, shown in the tabs
	var/category_name
	/// The title of the category, shown at the top of the list
	var/ui_title
	/// What type of loadout items should be generated for this category?
	var/type_to_generate
	/// List of all loadout items in this category
	VAR_FINAL/list/datum/loadout_item/associated_items

/datum/loadout_category/New()
	. = ..()
	associated_items = get_items()

/datum/loadout_category/Destroy(force, ...)
	if(!force)
		stack_trace("Who's destroying loadout categories?! This shouldn't really ever be done! (Use FORCE if necessary)")
		return

	associated_items.Cut()
	GLOB.loadout_categories -= src
	return ..()

/// Return a list of all /datum/loadout_items in this category.
/datum/loadout_category/proc/get_items()
	RETURN_TYPE(/list)
	. = list()
	for(var/datum/loadout_item/found_type as anything in typesof(type_to_generate))
		if(found_type == initial(found_type.abstract_type))
			continue

		if(!ispath(initial(found_type.item_path), /obj/item))
			stack_trace("loadout get_items(): Attempted to instantiate a loadout item ([found_type]) with an invalid or null typepath! (got path: [initial(found_type.item_path)])")
			continue

		var/datum/loadout_item/spawned_type = new found_type(src)
		. += spawned_type

/// Returns a list of all /datum/loadout_items in this category, formatted for UI use.
/datum/loadout_category/proc/items_to_ui_data()
	RETURN_TYPE(/list)
	if(!length(associated_items))
		return list()

	var/list/formatted_list = list()

	for(var/datum/loadout_item/item as anything in associated_items)
		formatted_list += list(item.to_ui_data())

	sortTim(formatted_list, /proc/cmp_assoc_list_name) // Alphebetizig
	return formatted_list

/**
 * Handles what happens when two items of this category are selected at once
 *
 * Return TRUE if it's okay to continue with adding the incoming item,
 * or return FALSE to stop the new item from being added
 */
/datum/loadout_category/proc/handle_duplicate_entires(
	datum/preference_middleware/loadout/manager,
	datum/loadout_item/conflicting_item,
	datum/loadout_item/added_item,
	list/datum/loadout_item/all_loadout_items,
)
	manager.deselect_item(conflicting_item)
	return TRUE
