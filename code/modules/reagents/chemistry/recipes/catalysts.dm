
///////////////////////////MEDICINES////////////////////////////

/datum/chemical_reaction/medical_speed_catalyst
	results = list(/datum/reagent/catalyst_agent/speed/medicine = 2)
	required_reagents = list(/datum/reagent/medicine/c2/libital = 3, /datum/reagent/medicine/c2/probital = 4, /datum/reagent/toxin/plasma = 2)
	mix_message = "The reaction evaporates slightly as the mixture solidifies"
	mix_sound = 'sound/chemistry/catalyst.ogg'
	reaction_tags = REACTION_TAG_MODERATE | REACTION_TAG_UNIQUE | REACTION_TAG_CHEMICAL
	required_temp = 320
	optimal_temp = 600
	overheat_temp = 800
	thermic_constant = 1000
	rate_up_lim = 1

/datum/chemical_reaction/medical_speed_catalyst/overheated(datum/reagents/holder, datum/equilibrium/equilibrium, step_volume_added)
	explode_invert_smoke(holder, equilibrium) //Will be better when the inputs have proper invert chems

/datum/chemical_reaction/medical_speed_catalyst/overly_impure(datum/reagents/holder, datum/equilibrium/equilibrium, step_volume_added)
	explode_invert_smoke(holder, equilibrium)
