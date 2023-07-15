// To make this system not a massive meta-pick for gamers, while still allowing plenty of room for unique combinations.
#define MINIMUM_REQUIRED_TOXICS 1
#define MINIMUM_REQUIRED_DISLIKES 3
#define MAXIMUM_LIKES 3

// Hahahaha, it LIVES!
/datum/preference_middleware/food
	action_delegations = list(
		"reset_food" = PROC_REF(reset_food),
		"toggle_food" = PROC_REF(toggle_food),
		"change_food" = PROC_REF(change_food),
	)

/datum/preference_middleware/food/apply_to_human(mob/living/carbon/human/target, datum/preferences/preferences)
	if(!length(preferences.food_preferences) || isdummy(target))
		return

	var/fail_reason = is_food_invalid(preferences)
	if(fail_reason)
		to_chat(preferences.parent, span_announce("Your food preferences can't be set! Reason: \"[fail_reason]\" Please check your preferences!")) // Sorry, but I don't want folk sleeping on this.
		return

	var/datum/species/species = target.dna.species
	species.liked_food = NONE
	species.disliked_food = NONE
	species.toxic_food = NONE

	for(var/food_entry in GLOB.food_ic_flag_to_point_values)
		var/list/food_points_entry = GLOB.food_ic_flag_to_point_values[food_entry]
		var/food_preference = preferences.food_preferences[food_entry] || food_points_entry[FOOD_PREFERENCE_DEFAULT]

		switch(food_preference)
			if(FOOD_PREFERENCE_LIKED)
				species.liked_food |= GLOB.food_ic_flag_to_bitflag[food_entry]
			if(FOOD_PREFERENCE_DISLIKED)
				species.disliked_food |= GLOB.food_ic_flag_to_bitflag[food_entry]
			if(FOOD_PREFERENCE_TOXIC)
				species.toxic_food |= GLOB.food_ic_flag_to_bitflag[food_entry]

/datum/preference_middleware/food/proc/reset_food(list/params, mob/user)
	qdel(preferences.food_preferences)
	preferences.food_preferences = list()
	return TRUE

/datum/preference_middleware/food/proc/toggle_food(list/params, mob/user)
	if(!preferences.food_preferences)
		preferences.food_preferences = list()
	preferences.food_preferences["enabled"] = !preferences.food_preferences["enabled"]
	return TRUE

/datum/preference_middleware/food/proc/change_food(list/params, mob/user)
	var/food_name = params["food_name"]
	var/food_preference = params["food_preference"]

	if(!food_name || !preferences || !food_preference || !(food_preference in list(FOOD_PREFERENCE_LIKED, FOOD_PREFERENCE_NEUTRAL, FOOD_PREFERENCE_DISLIKED, FOOD_PREFERENCE_TOXIC)))
		return TRUE

	// Do some simple validation for max liked foods. Full validation is done on spawn and in the actual menu.
	var/liked_food_length = 0

	for(var/food_entry in preferences.food_preferences)
		var/list/food_points_entry = GLOB.food_ic_flag_to_point_values[food_entry]
		if(length(food_points_entry) >= FOOD_PREFERENCE_OBSCURE && food_points_entry[FOOD_PREFERENCE_OBSCURE])
			continue

		if(preferences.food_preferences[food_entry] == FOOD_PREFERENCE_LIKED)
			liked_food_length++
			if(liked_food_length > MAXIMUM_LIKES)
				preferences.food_preferences.Remove(food_entry)

	if(liked_food_length > MAXIMUM_LIKES || (food_preference == FOOD_PREFERENCE_LIKED && liked_food_length == MAXIMUM_LIKES)) // Equals as well, if we're setting a liked food!
		return TRUE // Fuck you, look your mistakes in the eye.

	preferences.food_preferences[food_name] = food_preference
	return TRUE

/datum/preference_middleware/food/get_ui_static_data(mob/user)
	return list(
		"food_types" = GLOB.food_ic_flag_to_point_values,
	)

/datum/preference_middleware/food/get_ui_data(mob/user)
	return list(
		"food_selection" = preferences.food_preferences,
		"food_points" = calculate_points(preferences),
		"food_enabled" = preferences.food_preferences["enabled"],
		"food_invalid" = is_food_invalid(preferences),
	)

/// Checks the provided preferences datum to make sure the food pref values are valid. Does not check if the food preferences value is null.
/datum/preference_middleware/food/proc/is_food_invalid(datum/preferences/preferences)
	var/liked_food_length = 0
	var/disliked_food_length = 0
	var/toxic_food_length = 0

	for(var/food_entry in GLOB.food_ic_flag_to_point_values)
		var/list/food_points_entry = GLOB.food_ic_flag_to_point_values[food_entry]
		var/food_preference = preferences.food_preferences[food_entry] || food_points_entry[FOOD_PREFERENCE_DEFAULT]

		if(length(food_points_entry) >= FOOD_PREFERENCE_OBSCURE && food_points_entry[FOOD_PREFERENCE_OBSCURE])
			continue

		switch(food_preference)
			if(FOOD_PREFERENCE_LIKED)
				liked_food_length++
			if(FOOD_PREFERENCE_DISLIKED)
				disliked_food_length++
			if(FOOD_PREFERENCE_TOXIC)
				toxic_food_length++

	if(liked_food_length > MAXIMUM_LIKES)
		return "Too many like choices."
	if(disliked_food_length < MINIMUM_REQUIRED_DISLIKES)
		return "Too few dislike choices."
	if(toxic_food_length < MINIMUM_REQUIRED_TOXICS)
		return "Too few toxic choices."
	if(calculate_points(preferences) < 0)
		return "Not enough points."

/// Calculates the deviance points for food.
/datum/preference_middleware/food/proc/calculate_points(datum/preferences/preferences)
	var/points = 0

	for(var/food_entry in preferences.food_preferences)
		var/food_preference = preferences.food_preferences[food_entry]
		var/list/food_points_entry = GLOB.food_ic_flag_to_point_values[food_entry]
		if(!food_points_entry || food_points_entry.Find(FOOD_PREFERENCE_OBSCURE))
			continue

		points += food_points_entry[food_preference]

	return points

#undef MINIMUM_REQUIRED_TOXICS
#undef MINIMUM_REQUIRED_DISLIKES
#undef MAXIMUM_LIKES
