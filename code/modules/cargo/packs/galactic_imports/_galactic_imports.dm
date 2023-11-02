// NOTE: If you want to make an existing pack a galactic import, set `galactic_import` to true!

/datum/supply_pack/galactic_imports
	group = TRADER_GROUP_GALACTIC_IMPORTS
	/// Category to hide this under in galactic imports. Yes, cartridges are the whole reason this exists.
	var/category

/datum/supply_pack/galactic_imports/get_cost()
	. = ..()
	. *= 1.8 // These are expensive to import.

// We don't handle `galactic_import` here.
/datum/supply_pack/galactic_imports/generate_supply_packs()
	return

/datum/supply_pack/galactic_imports/generated/New(id, datum/supply_pack/pack_to_rip)
	id = pack_to_rip.id
	name = pack_to_rip.name
	category = islist(pack_to_rip.group) ? pack_to_rip.group[1] : pack_to_rip.group
	contains = pack_to_rip.contains
	cost = pack_to_rip.cost
