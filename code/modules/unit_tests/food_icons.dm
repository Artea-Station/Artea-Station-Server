///Checks that all food has an existing icon state in their icon file.
/datum/unit_test/food_icons

/datum/unit_test/food_icons/Run()
	for(var/obj/item/food/food as anything in subtypesof(/obj/item/food))
		if(!icon_exists(initial(food.icon), initial(food.icon_state)))
			TEST_FAIL("No icon found for [initial(food.name)] ([food])!")
