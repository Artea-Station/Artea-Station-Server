#define TEST_ATMOS_MESSAGE(test_atmos, message) "[test_atmos] [message]"

// Tests all `/datum/atmosphere` for general sanity.
// This is mainly a test for `/datum/atmosphere/proc/generate_gas_string()`.
/datum/unit_test/atmosphere_sanity

/datum/unit_test/atmosphere_sanity/Run()
	for (var/datum/atmosphere/test_atmos_type as anything in subtypesof(/datum/atmosphere))
		var/datum/atmosphere/test_atmos = new test_atmos_type
		test_gases_list("`base_gases`", test_atmos, test_atmos.base_gases)
		test_gases_list("`normal_gases`", test_atmos, test_atmos.normal_gases)
		test_gases_list("`restricted_gases`", test_atmos, test_atmos.restricted_gases)
		test_atmosphere(test_atmos)

/datum/unit_test/atmosphere_sanity/proc/test_atmosphere(datum/atmosphere/test_atmos)
	TEST_ASSERT(istype(SSair.parse_gas_string(test_atmos.gas_string), /datum/gas_mixture), TEST_ATMOS_MESSAGE(test_atmos, "generated a `gas_string` which can not be parsed by `parse_gas_string`."))

/datum/unit_test/atmosphere_sanity/proc/test_gases_list(context, datum/atmosphere/test_atmos, list/test_gases)
	for(var/datum/gas/gas_type as anything in test_gases)
		TEST_ASSERT(ispath(gas_type, /datum/gas), TEST_ATMOS_MESSAGE(test_atmos, "should only have `/datum/gas` typepaths in [context]."))
		TEST_ASSERT(GLOB.gaslist_cache[gas_type], TEST_ATMOS_MESSAGE(test_atmos, "has `[gas_type]` in [context] but it does not exist in `GLOB.gaslist_cache`."))
	return

#undef TEST_ATMOS_MESSAGE
