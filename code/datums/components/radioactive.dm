#define DELAY_BETWEEN_RADIATION_PULSES (3 SECONDS)

/// This atom will regularly pulse radiation.
/datum/component/radioactive
	dupe_mode = COMPONENT_DUPE_UNIQUE

	var/threshold
	var/chance
	var/minimum_exposure_time

	var/last_pulse = 0

/datum/component/radioactive/Initialize(
	threshold = RAD_LIGHT_INSULATION,
	chance = IRRADIATION_CHANCE_URANIUM,
	minimum_exposure_time = URANIUM_RADIATION_MINIMUM_EXPOSURE_TIME,
)
	if(!isatom(parent))
		return COMPONENT_INCOMPATIBLE

	src.threshold = threshold
	src.chance = chance
	src.minimum_exposure_time = minimum_exposure_time
	START_PROCESSING(SSradiation, src)

/datum/component/radioactive/process(delta_time)
	if (world.time - last_pulse < DELAY_BETWEEN_RADIATION_PULSES)
		return

	radiation_pulse(
		parent,
		max_range = 3,
		threshold = threshold,
		chance = chance,
		minimum_exposure_time = minimum_exposure_time,
	)

	last_pulse = world.time

#undef DELAY_BETWEEN_RADIATION_PULSES
