// --- Loadout item datums for gloves ---

/// Glove Slot Items (Deletes overrided items)
/datum/loadout_category/gloves
	category_name = "Gloves"
	ui_title = "Glove Slot Items"
	type_to_generate = /datum/loadout_item/gloves

/datum/loadout_item/gloves
	abstract_type = /datum/loadout_item/gloves

/datum/loadout_item/gloves/insert_path_into_outfit(datum/outfit/outfit, mob/living/carbon/human/equipper, visuals_only = FALSE)
	if(isplasmaman(equipper))
		if(!visuals_only)
			to_chat(equipper, "Your loadout gloves were not equipped directly due to your envirosuit gloves.")
			LAZYADD(outfit.backpack_contents, item_path)
	else
		outfit.gloves = item_path

/datum/loadout_item/gloves/fingerless
	item_path = /obj/item/clothing/gloves/fingerless

/datum/loadout_item/gloves/black
	item_path = /obj/item/clothing/gloves/color/black

/datum/loadout_item/gloves/blue
	item_path = /obj/item/clothing/gloves/color/blue

/datum/loadout_item/gloves/brown
	item_path = /obj/item/clothing/gloves/color/brown

/datum/loadout_item/gloves/green
	item_path = /obj/item/clothing/gloves/color/green

/datum/loadout_item/gloves/grey
	item_path = /obj/item/clothing/gloves/color/grey

/datum/loadout_item/gloves/light_brown
	item_path = /obj/item/clothing/gloves/color/light_brown

/datum/loadout_item/gloves/orange
	item_path = /obj/item/clothing/gloves/color/orange

/datum/loadout_item/gloves/purple
	item_path = /obj/item/clothing/gloves/color/purple

/datum/loadout_item/gloves/rainbow
	item_path = /obj/item/clothing/gloves/color/rainbow

/datum/loadout_item/gloves/red
	item_path = /obj/item/clothing/gloves/color/red

/datum/loadout_item/gloves/white
	item_path = /obj/item/clothing/gloves/color/white
