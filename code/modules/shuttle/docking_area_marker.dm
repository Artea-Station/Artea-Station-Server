// Okay, I'm going to hate myself for doing this, but I am FED UP WITH THESE FUCKING MAGIC NUMBERS AAAAAAAAAAAAAAAAAAAAAAAAAA

/// Used by mappers on a docking port. You place three, one at the docking port's right, one at the opposite corner, and then one on the axis joint between the two.
/// See Bearcat if this explanation didn't make sense.
/obj/docking_area_marker
	invisibility = INVISIBILITY_ABSTRACT
	icon = 'icons/obj/device.dmi'
	icon_state = "pinonalertdirect"
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	anchored = TRUE

/// Used by the debug mode to show how the scanner got to the size it ended up on. Good for if you place down a bunch of intersecting ports, for whatever reason.
/obj/docking_area_marker/debug
	icon_state = "pinondirect"

/obj/docking_area_marker/Initialize(mapload)
	. = ..()
	#ifdef TESTING
	invisibility = NONE
	#endif
