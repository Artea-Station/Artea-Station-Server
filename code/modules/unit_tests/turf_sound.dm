/**
 * Goes through every subtype of /turf/open and makes sure a valid step type exists for each category.
 */
/datum/unit_test/turf_sound

/datum/unit_test/turf_sound/Run()
	for(var/turf/open/turf_to_check as anything in subtypesof(/turf/open))
		var/footstep = initial(turf_to_check.footstep)
		var/barefootstep = initial(turf_to_check.barefootstep)
		var/clawfootstep = initial(turf_to_check.clawfootstep)
		var/heavyfootstep = initial(turf_to_check.heavyfootstep)
		if(footstep && !GLOB.footstep[footstep])
			TEST_FAIL("Footstep for [turf_to_check] is not a valid entry, check \"code/__DEFINES/footsteps.dm\" for valid values.")
		if(barefootstep && !GLOB.barefootstep[barefootstep])
			TEST_FAIL("Barefootstep for [turf_to_check] is not a valid entry, check \"code/__DEFINES/footsteps.dm\" for valid values.")
		if(clawfootstep && !GLOB.clawfootstep[clawfootstep])
			TEST_FAIL("Clawfootstep for [turf_to_check] is not a valid entry, check \"code/__DEFINES/footsteps.dm\" for valid values.")
		if(heavyfootstep && !GLOB.heavyfootstep[heavyfootstep])
			TEST_FAIL("Heavyfootstep for [turf_to_check] is not a valid entry, check \"code/__DEFINES/footsteps.dm\" for valid values.")
