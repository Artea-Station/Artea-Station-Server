/// The subsystem used to tick [/obj/machinery/airlock_controller] instances.
PROCESSING_SUBSYSTEM_DEF(airlocks)
	name = "Airlocks"
	priority = FIRE_PRIORITY_AIRLOCKS
	flags = SS_NO_INIT | SS_BACKGROUND
	wait = 0.5 SECONDS
