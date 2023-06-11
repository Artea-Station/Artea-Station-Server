/**
 * Original Food export file got eaten somewhere along the line and I have no idea when or where it got completely deleted.
 * Foods given a venue value are exportable to cargo as a backup to selling from venues, however at the expense of elasticity.
 */
/datum/export/food
	cost = 10
	unit_name = "serving"
	message = "of food"
	export_types = list(/obj/item/food)
	include_subtypes = TRUE
	exclude_types = list(/obj/item/food/grown)
	/// Have we already set the cost of this export? Necessary to avoid the cost being constantly reset.
	var/cost_obtained_from_venue_value = FALSE

/datum/export/food/get_cost(obj/object, allowed_categories, apply_elastic)
	var/obj/item/food/sold_food = object
	if(sold_food.food_flags & FOOD_SILVER_SPAWNED)
		return FOOD_PRICE_WORTHLESS

	if(!cost_obtained_from_venue_value)
		cost = sold_food.venue_value
		cost_obtained_from_venue_value = TRUE

	return ..()

/datum/export/chem_cartridge
	cost = 50
	unit_name = "chem cartridges"
	export_types = list(/obj/item/reagent_containers/chem_disp_cartridge)

/datum/export/chem_cartridge/get_cost(obj/object, apply_elastic)
	return ..(object, FALSE) // This is for returning canisters, so let's tell it to not apply elasticity.
