/// The subsystem used to tick [/obj/machinery/airlock_controller] instances.
PROCESSING_SUBSYSTEM_DEF(airlocks)
	name = "Airlocks"
	init_order = INIT_ORDER_AIRLOCKS
	priority = FIRE_PRIORITY_AIRLOCKS
	flags = SS_BACKGROUND
	wait = 0.5 SECONDS

	var/list/helpers_to_initialize = list()

/datum/controller/subsystem/processing/airlocks/Initialize()
	for(var/obj/effect/mapping_helpers/bulkhead_controller_helper/helper as anything in helpers_to_initialize)
		helper.airlock_initialize()
		qdel(helper)

	helpers_to_initialize.Cut()

	return SS_INIT_SUCCESS
