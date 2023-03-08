#define TEST_ATMOS_MESSAGE(test_atmos, message) "[test_atmos.type] [message]"

// Tests all `/datum/atmosphere` for general sanity.
// This is mainly a test for `/datum/atmosphere/proc/generate_gas_string()`.
/datum/unit_test/atmosphere_sanity

/datum/unit_test/atmosphere_sanity/Run()
	for (var/datum/atmosphere/test_atmos_type as anything in subtypesof(/datum/atmosphere))
		test_atmosphere(test_atmos_type)

/datum/unit_test/atmosphere_sanity/proc/test_atmosphere(datum/atmosphere/test_atmos_type)
	var/datum/atmosphere/test_atmos = new test_atmos_type
	test_gases("`base_gases`", test_atmos, test_atmos.base_gases)
	test_gases("`normal_gases`", test_atmos, test_atmos.normal_gases)
	test_gases("`restricted_gases`", test_atmos, test_atmos.restricted_gases)
	TEST_ASSERT(istype(SSair.parse_gas_string(test_atmos.gas_string), /datum/gas_mixture), TEST_ATMOS_MESSAGE(test_atmos, "generated a `gas_string` which can not be parsed by `parse_gas_string`."))

/datum/unit_test/atmosphere_sanity/proc/test_gases(context, datum/atmosphere/test_atmos, list/test_gases)
	for(var/datum/gas_type in test_gases)
		TEST_ASSERT(istype(gas_type, /datum/gas), TEST_ATMOS_MESSAGE(test_atmos, "should only have `/datum/gas` in [context]."))
		TEST_ASSERT(GLOB.gaslist_cache[gas_type], TEST_ATMOS_MESSAGE(test_atmos, "has `[gas_type]` in [context] but it does not exist in `GLOB.gaslist_cache`."))

	return

#undef TEST_ATMOS_MESSAGE
