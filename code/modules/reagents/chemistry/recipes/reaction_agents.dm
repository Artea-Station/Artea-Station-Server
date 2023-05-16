/datum/chemical_reaction/acidic_inversifier
	results = list(/datum/reagent/acidic_inversifier = 10)
	required_reagents = list(/datum/reagent/sodium = 2, /datum/reagent/hydrogen = 2, /datum/reagent/consumable/ethanol = 2, /datum/reagent/water = 2)
	mix_message = "The solution froths in the beaker."
	required_temp = 250
	optimal_temp = 500
	overheat_temp = NO_OVERHEAT
	thermic_constant = 0
	rate_up_lim = 20
	reaction_tags = REACTION_TAG_EASY | REACTION_TAG_CHEMICAL
