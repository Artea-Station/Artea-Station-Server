// --- Loadout item datums for shoes items ---

/// Shoe Slot Items (Deletes overrided items)
/datum/loadout_category/shoes
	category_name = "Shoes"
	ui_title = "Foot Slot Items"
	type_to_generate = /datum/loadout_item/shoes

/datum/loadout_item/shoes
	abstract_type = /datum/loadout_item/shoes
	/// Snowflake, whether these shoes work on digi legs.
	VAR_FINAL/supports_digitigrade = FALSE

/datum/loadout_item/shoes/New()
	. = ..()
	var/ignores_digi = !!(initial(item_path.item_flags) & IGNORE_DIGITIGRADE)
	var/supports_digi = !!(initial(item_path.supports_variations_flags) & (CLOTHING_DIGITIGRADE_VARIATION|CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON))
	supports_digitigrade = ignores_digi || supports_digi
	if(supports_digitigrade)
		add_tooltip("SUPPORTS DIGITIGRADE - This item can be worn on mobs who have digitigrade legs.")

// This is snowflake but digitigrade is in general
// Need to handle shoes that don't fit digitigrade being selected
// Ideally would be generalized with species can equip or something but OH WELL
/datum/loadout_item/shoes/on_equip_item(datum/preferences/preference_source, mob/living/carbon/human/equipper, visuals_only, list/preference_list)
	// Supports digi = needs no special handling so we can continue as normal
	if(supports_digitigrade)
		return ..()

	// Does not support digi and our equipper is? We shouldn't mess with it, skip
	if(equipper.dna?.species?.bodytype & BODYTYPE_DIGITIGRADE)
		return

	// Does not support digi and our equipper is not digi? Continue as normal
	return ..()

/datum/loadout_item/shoes/insert_path_into_outfit(datum/outfit/outfit, mob/living/carbon/human/equipper, visuals_only = FALSE)
	outfit.shoes = item_path

/datum/loadout_item/shoes/winter_boots
	item_path = /obj/item/clothing/shoes/winterboots

/datum/loadout_item/shoes/work_boots
	item_path = /obj/item/clothing/shoes/workboots

/datum/loadout_item/shoes/mining_boots
	item_path = /obj/item/clothing/shoes/workboots/mining

/datum/loadout_item/shoes/laceup
	item_path = /obj/item/clothing/shoes/laceup

/datum/loadout_item/shoes/russian_boots
	item_path = /obj/item/clothing/shoes/russian

/datum/loadout_item/shoes/black_cowboy_boots
	item_path = /obj/item/clothing/shoes/cowboy/black

/datum/loadout_item/shoes/brown_cowboy_boots
	item_path = /obj/item/clothing/shoes/cowboy

/datum/loadout_item/shoes/white_cowboy_boots
	item_path = /obj/item/clothing/shoes/cowboy/white

/datum/loadout_item/shoes/sandals
	item_path = /obj/item/clothing/shoes/sandal
