/datum/looping_sound/showering
	start_sound = 'sound/machines/shower/shower_start.ogg'
	start_length = 2
	mid_sounds = list('sound/machines/shower/shower_mid1.ogg' = 1, 'sound/machines/shower/shower_mid2.ogg' = 1, 'sound/machines/shower/shower_mid3.ogg' = 1)
	mid_length = 10
	end_sound = 'sound/machines/shower/shower_end.ogg'
	volume = 20

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/datum/looping_sound/supermatter
	mid_sounds = list('sound/machines/sm/loops/calm.ogg' = 1)
	mid_length = 60
	volume = 40
	extra_range = 25
	falloff_exponent = 10
	falloff_distance = 5
	vary = TRUE

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/datum/looping_sound/destabilized_crystal
	mid_sounds = list('sound/machines/sm/loops/delamming.ogg' = 1)
	mid_length = 60
	volume = 55
	extra_range = 15
	vary = TRUE

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/datum/looping_sound/hypertorus
	mid_sounds = list('sound/machines/hypertorus/loops/hypertorus_nominal.ogg' = 1)
	mid_length = 60
	volume = 55
	extra_range = 15
	vary = TRUE

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/datum/looping_sound/generator
	start_sound = 'sound/machines/generator/generator_start.ogg'
	start_length = 4
	mid_sounds = list('sound/machines/generator/generator_mid1.ogg' = 1, 'sound/machines/generator/generator_mid2.ogg' = 1, 'sound/machines/generator/generator_mid3.ogg' = 1)
	mid_length = 4
	end_sound = 'sound/machines/generator/generator_end.ogg'
	volume = 40

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


/datum/looping_sound/deep_fryer
	start_sound = 'sound/machines/fryer/deep_fryer_immerse.ogg' //my immersions
	start_length = 10
	mid_sounds = list('sound/machines/fryer/deep_fryer_1.ogg' = 1, 'sound/machines/fryer/deep_fryer_2.ogg' = 1)
	mid_length = 2
	end_sound = 'sound/machines/fryer/deep_fryer_emerge.ogg'
	volume = 15

/datum/looping_sound/clock
	mid_sounds = list('sound/ambience/ticking_clock.ogg' = 1)
	mid_length = 40
	volume = 50
	ignore_walls = FALSE

/datum/looping_sound/grill
	mid_sounds = list('sound/machines/grill/grillsizzle.ogg' = 1)
	mid_length = 18
	volume = 50

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/datum/looping_sound/oven
	start_sound = 'sound/machines/oven/oven_loop_start.ogg' //my immersions
	start_length = 12
	mid_sounds = list('sound/machines/oven/oven_loop_mid.ogg' = 1)
	mid_length = 13
	end_sound = 'sound/machines/oven/oven_loop_end.ogg'
	volume = 100
	falloff_exponent = 4

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/datum/looping_sound/deep_fryer
	mid_length = 2
	mid_sounds = list('sound/machines/fryer/deep_fryer_1.ogg' = 1, 'sound/machines/fryer/deep_fryer_2.ogg' = 1)
	volume = 30

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/datum/looping_sound/microwave
	start_sound = 'sound/machines/microwave/microwave-start.ogg'
	start_length = 10
	mid_sounds = list('sound/machines/microwave/microwave-mid1.ogg' = 10, 'sound/machines/microwave/microwave-mid2.ogg' = 1)
	mid_length = 10
	end_sound = 'sound/machines/microwave/microwave-end.ogg'
	volume = 90

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/datum/looping_sound/jackpot
	mid_length = 11
	mid_sounds = list('sound/machines/roulettejackpot.ogg' = 1)
	volume = 85
	vary = TRUE

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/datum/looping_sound/server
	mid_sounds = list(
		'sound/machines/tcomms/tcomms_mid1.ogg' = 1,
		'sound/machines/tcomms/tcomms_mid2.ogg' = 1,
		'sound/machines/tcomms/tcomms_mid3.ogg' = 1,
		'sound/machines/tcomms/tcomms_mid4.ogg' = 1,
		'sound/machines/tcomms/tcomms_mid5.ogg' = 1,
		'sound/machines/tcomms/tcomms_mid6.ogg' = 1,
		'sound/machines/tcomms/tcomms_mid7.ogg' = 1,
	)
	mid_length = 1.8 SECONDS
	extra_range = -11
	falloff_distance = 1
	falloff_exponent = 5
	volume = 50
	ignore_walls = FALSE

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/datum/looping_sound/computer
	start_sound = 'sound/machines/computer/computer_start.ogg'
	start_length = 7.2 SECONDS
	start_volume = 10
	mid_sounds = list('sound/machines/computer/computer_mid1.ogg', 'sound/machines/computer/computer_mid2.ogg')
	mid_length = 1.8 SECONDS
	end_sound = 'sound/machines/computer/computer_end.ogg'
	end_volume = 10
	volume = 2
	falloff_exponent = 5 //Ultra quiet very fast
	extra_range = -12
	falloff_distance = 1 //Instant falloff after initial tile

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/datum/looping_sound/gravgen
	mid_sounds = list('sound/machines/gravgen/gravgen_mid1.ogg' = 1, 'sound/machines/gravgen/gravgen_mid2.ogg' = 1, 'sound/machines/gravgen/gravgen_mid3.ogg' = 1, 'sound/machines/gravgen/gravgen_mid4.ogg' = 1)
	mid_length = 1.8 SECONDS
	extra_range = 10
	volume = 40
	falloff_distance = 5
	falloff_exponent = 20

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/datum/looping_sound/firealarm
	mid_sounds = list('sound/machines/FireAlarm1.ogg' = 1,'sound/machines/FireAlarm2.ogg' = 1,'sound/machines/FireAlarm3.ogg' = 1,'sound/machines/FireAlarm4.ogg' = 1)
	mid_length = 2.4 SECONDS
	volume = 75
	ignore_walls = FALSE
	extra_range = 5


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/datum/looping_sound/atmosalarm
	mid_sounds = list('sound/machines/atmosalarm.ogg' = 1)
	mid_length = 1 SECONDS
	ignore_walls = FALSE

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/datum/looping_sound/gravgen/kinesis
	volume = 20
	falloff_distance = 2
	falloff_exponent = 5

/datum/looping_sound/drill
	start_sound = 'sound/machines/drill/drill_start.ogg'
	start_length = 1 SECONDS
	mid_sounds = list('sound/machines/drill/drill_loop.ogg'=1)
	mid_length = 1 SECONDS
	end_sound = 'sound/machines/drill/drill_end.ogg'
	volume = 40

/datum/looping_sound/engine
	start_sound = 'sound/machines/engine/enginestart.ogg'
	start_length = 1.4 SECONDS
	mid_sounds = list('sound/machines/engine/engineloop.ogg'=1)
	mid_length = 1.4 SECONDS
	end_sound = 'sound/machines/engine/engineend.ogg'
	volume = 10
	falloff_distance = 5

/datum/looping_sound/air_pump
	start_sound = 'sound/machines/airpumpstart.ogg'
	start_length = 1 SECONDS
	mid_sounds = list(
		'sound/machines/airpumpidle1.ogg' = 1,
		'sound/machines/airpumpidle2.ogg' = 1,
		'sound/machines/airpumpidle3.ogg' = 1,
		'sound/machines/airpumpidle4.ogg' = 1,
		'sound/machines/airpumpidle5.ogg' = 1,
	)
	mid_length = 0.99 SECONDS // I hate it, but it gets rid of most micro-stutters.
	end_sound = 'sound/machines/airpumpshutdown.ogg'
	volume = 5
	falloff_distance = 0
	ignore_walls = FALSE

/datum/looping_sound/industrial_lift
	start_sound = 'sound/lifts/lift_loop/lift_start.ogg'
	start_length = 0.5 SECONDS
	mid_sounds = list('sound/lifts/lift_loop/lift_loop.ogg'=1)
	mid_length = 2 SECONDS
	end_sound = 'sound/lifts/lift_loop/lift_end.ogg'
	volume = 40
	falloff_distance = 4
