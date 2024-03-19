// Atmos types used for planetary airs
/datum/atmosphere/lavaland
	base_gases = list(
		GAS_OXYGEN = 5,
		GAS_NITROGEN = 10,
	)
	normal_gases = list(
		GAS_OXYGEN = 10,
		GAS_NITROGEN = 10,
		GAS_CO2 = 10,
	)
	restricted_gases = list(
		GAS_PLASMA =0.1,
		///datum/gas/bz=1.2,
		///datum/gas/miasma=1.2,
		///datum/gas/water_vapor=0.1,
	)
	restricted_chance = 30

	minimum_pressure = HAZARD_LOW_PRESSURE + 10
	maximum_pressure = LAVALAND_EQUIPMENT_EFFECT_PRESSURE - 1

	minimum_temp = BODYTEMP_COLD_DAMAGE_LIMIT + 1
	maximum_temp = 350

/datum/atmosphere/icemoon
	base_gases = list(
		GAS_OXYGEN = 5,
		GAS_NITROGEN = 10,
	)
	normal_gases = list(
		GAS_OXYGEN = 10,
		GAS_NITROGEN = 10,
		GAS_CO2 = 10,
	)
	restricted_gases = list(
		GAS_PLASMA=0.1,
		///datum/gas/water_vapor=0.1,
		///datum/gas/miasma=1.2,
	)
	restricted_chance = 20

	minimum_pressure = HAZARD_LOW_PRESSURE + 10
	maximum_pressure = LAVALAND_EQUIPMENT_EFFECT_PRESSURE - 1

	minimum_temp = 180
	maximum_temp = 180

