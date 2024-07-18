/datum/atmosphere
	/// A list of gases to always have, associative to weight
	var/list/base_gases = list()
	/// A list of picked extra gases to roll, associative to weight
	var/list/normal_gases = list()
	/// How many extra gases will we roll from the normal pool
	var/normal_gas_picks = 1
	/// A list of allowed gases like normal_gases but each can only be selected a maximum of one time. Associative to weight
	var/list/restricted_gases = list()
	/// Chance to pick a restricted gas
	var/restricted_chance = 0

	var/minimum_pressure
	var/maximum_pressure

	var/minimum_temp
	var/maximum_temp
