/proc/init_sm_gas()
	var/list/gas_list = list()
	for (var/sm_gas_path in subtypesof(/datum/sm_gas))
		var/datum/sm_gas/sm_gas = new sm_gas_path
		gas_list[sm_gas.gas_path] = sm_gas
	return gas_list

/// Assoc of sm_gas_behavior[/datum/gas (path)] = datum/sm_gas (instance)
GLOBAL_LIST_INIT(sm_gas_behavior, init_sm_gas())

/// Contains effects of gases when absorbed by the sm.
/datum/sm_gas
	/// Path of the [/datum/gas] involved with this interaction.
	var/gas_path

	/// Influences zap power without interfering with the crystal's own energy.
	var/transmit_modifier = 0
	/// How much more waste heat and gas the SM generates.
	var/heat_penalty = 0
	/// How extra hot the SM can run before taking damage
	var/heat_resistance = 0
	/// Lets the sm generate extra power from heat. Yeah...
	var/powermix = 0
	/// How much powerloss do we get rid of.
	var/powerloss_inhibition = 0

/datum/sm_gas/proc/extra_effects(obj/machinery/power/supermatter_crystal/sm, datum/gas_mixture/env)
	return

/datum/sm_gas/oxygen
	gas_path = GAS_OXYGEN
	heat_penalty = 1
	transmit_modifier = 1.5
	powermix = 1

/datum/sm_gas/nitrogen
	gas_path = GAS_NITROGEN
	heat_penalty = -1.5
	powermix = -1

/datum/sm_gas/carbon_dioxide
	gas_path = GAS_CO2
	heat_penalty = 2
	powermix = 1
	powerloss_inhibition = 1

/// Can be on Oxygen or CO2, but better lump it here since CO2 is rarer.
/datum/sm_gas/carbon_dioxide/extra_effects(obj/machinery/power/supermatter_crystal/sm, datum/gas_mixture/env)
	if(!(sm.gas_percentage[GAS_CO2] && sm.gas_percentage[GAS_OXYGEN]))
		return
	var/co2_pp = env.returnPressure() * sm.gas_percentage[GAS_CO2]
	/// Our consumption ratio, not the actual ratio in SM we already have that.
	/// This var is a fucking lie, we only consume half of it.
	var/co2_ratio = (co2_pp - CO2_CONSUMPTION_PP) / (co2_pp + CO2_PRESSURE_SCALING)
	co2_ratio = clamp(co2_ratio, 0, 1)
	var/consumed_co2 = sm.absorbed_gasmix.gas[GAS_CO2] * co2_ratio
	consumed_co2 = min(
		consumed_co2,
		sm.absorbed_gasmix.gas[GAS_CO2] * INVERSE(0.5),
		sm.absorbed_gasmix.gas[GAS_OXYGEN] * INVERSE(0.5)
	)
	if(!consumed_co2)
		return
	sm.absorbed_gasmix.gas[GAS_CO2] -= consumed_co2 * 0.5
	sm.absorbed_gasmix.gas[GAS_OXYGEN] -= consumed_co2 * 0.5
	// ASSERT_GAS(/datum/gas/pluoxium, sm.absorbed_gasmix)
	// sm.absorbed_gasmix.gas[/datum/gas/pluoxium][MOLES] += consumed_co2 * 0.25

/datum/sm_gas/plasma
	gas_path = GAS_PLASMA
	heat_penalty = 15
	transmit_modifier = 4
	powermix = 1

/datum/sm_gas/water_vapor
	gas_path = GAS_STEAM
	heat_penalty = 12
	transmit_modifier = -2.5
	powermix = 1

/datum/sm_gas/nitrous_oxide
	gas_path = GAS_N2O
	heat_resistance = 6

/datum/sm_gas/nitro_dioxide
	gas_path = GAS_NO2

/datum/sm_gas/tritium
	gas_path = GAS_TRITIUM
	heat_penalty = 10
	transmit_modifier = 30
	powermix = 1

// /datum/sm_gas/bz
// 	gas_path = /datum/gas/bz
// 	heat_penalty = 5
// 	transmit_modifier = -2
// 	powermix = 1

// /// Start to emit radballs at a maximum of 30% chance per tick
// /datum/sm_gas/bz/extra_effects(obj/machinery/power/supermatter_crystal/sm, datum/gas_mixture/env)
// 	if(sm.gas_percentage[/datum/gas/bz] >= 0.4 && prob(30 * sm.gas_percentage[/datum/gas/bz]))
// 		sm.fire_nuclear_particle()

// /datum/sm_gas/pluoxium
// 	gas_path = /datum/gas/pluoxium
// 	heat_penalty = -0.5
// 	transmit_modifier = -5
// 	powermix = 1

// Mmmm, fart powered SM
/datum/sm_gas/methane
	gas_path = GAS_METHANE
	powermix = 0.5
	heat_penalty = 5

// /datum/sm_gas/freon
// 	gas_path = /datum/gas/freon
// 	heat_penalty = -10
// 	transmit_modifier = -30
// 	powermix = 1

/datum/sm_gas/hydrogen
	gas_path = GAS_HYDROGEN
	heat_penalty = 10
	transmit_modifier = 25
	heat_resistance = 2
	powermix = 1

// /datum/sm_gas/healium
// 	gas_path = /datum/gas/healium
// 	heat_penalty = 4
// 	transmit_modifier = 2.4
// 	powermix = 1

/datum/sm_gas/nitric_oxide
	gas_path = GAS_NO
	heat_penalty = -3
	transmit_modifier = 15
	heat_resistance = 5
	powermix = 1

// /datum/sm_gas/zauker
// 	gas_path = /datum/gas/zauker
// 	heat_penalty = 8
// 	transmit_modifier = 20
// 	powermix = 1

// /datum/sm_gas/zauker/extra_effects(obj/machinery/power/supermatter_crystal/sm, datum/gas_mixture/env)
// 	if(!prob(sm.gas_percentage[/datum/gas/zauker]))
// 		return
// 	playsound(sm.loc, 'sound/weapons/emitter2.ogg', 100, TRUE, extrarange = 10)
// 	sm.supermatter_zap(
// 		sm,
// 		range = 6,
// 		zap_str = clamp(sm.power * 2, 4000, 20000),
// 		zap_flags = ZAP_MOB_STUN,
// 		zap_cutoff = sm.zap_cutoff,
// 		power_level = sm.power,
// 		zap_icon = sm.zap_icon
// 	)

// /datum/sm_gas/halon
// 	gas_path = /datum/gas/halon

// /datum/sm_gas/helium
// 	gas_path = /datum/gas/helium

// /datum/sm_gas/antinoblium
// 	gas_path = /datum/gas/antinoblium
// 	transmit_modifier = -5
// 	heat_penalty = 15
// 	powermix = 1
