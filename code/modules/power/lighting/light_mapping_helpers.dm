/obj/machinery/light/broken
	status = LIGHT_BROKEN
	icon_state = "tube-broken"

/obj/machinery/light/built
	icon_state = "tube-empty"
	start_with_cell = FALSE

/obj/machinery/light/built/Initialize(mapload)
	. = ..()
	status = LIGHT_EMPTY
	update(0)

/obj/machinery/light/no_nightlight
	nightshift_enabled = FALSE

/obj/machinery/light/warm
	bulb_colour = "#fae5c1"

/obj/machinery/light/warm/no_nightlight
	nightshift_allowed = FALSE

/obj/machinery/light/cold
	bulb_colour = "#deefff"
	nightshift_light_color = "#deefff"

/obj/machinery/light/cold/no_nightlight
	nightshift_allowed = FALSE

/obj/machinery/light/red
	bulb_colour = "#FF3232"
	nightshift_allowed = FALSE
	no_low_power = TRUE
	glow_icon_state = "tube_red"

/obj/machinery/light/red/dim
	brightness = 4
	bulb_power = 0.7

/obj/machinery/light/blacklight
	bulb_colour = "#A700FF"
	nightshift_allowed = FALSE
	brightness = 8

/obj/machinery/light/dim
	nightshift_allowed = FALSE
	bulb_colour = "#ffd9b3"
	bulb_power = 0.4

// the smaller bulb light fixture

/obj/machinery/light/small
	icon_state = "bulb"
	base_state = "bulb"
	fitting = "bulb"
	brightness = 4
	nightshift_brightness = 4
	bulb_colour = "#ffd9b3"
	bulb_power = 0.45
	desc = "A small lighting fixture."
	light_type = /obj/item/light/bulb
	glow_icon_state = "bulb"
	exposure_icon_state = "circle"

/obj/machinery/light/small/broken
	status = LIGHT_BROKEN
	icon_state = "bulb-broken"

/obj/machinery/light/small/built
	icon_state = "bulb-empty"
	start_with_cell = FALSE

/obj/machinery/light/small/built/Initialize(mapload)
	. = ..()
	status = LIGHT_EMPTY
	update(0)

/obj/machinery/light/small/red
	bulb_colour = "#FF3232"
	no_low_power = TRUE
	nightshift_allowed = FALSE
	glow_icon_state = "bulb_red"

/obj/machinery/light/small/red/dim
	brightness = 2
	bulb_power = 0.8

/obj/machinery/light/small/blacklight
	bulb_colour = "#A700FF"
	nightshift_allowed = FALSE
	brightness = 4

/obj/machinery/light/small/maintenance
	bulb_colour = "#e0a142"
	nightshift_allowed = FALSE
	bulb_power = 0.45
	brightness = 2
	glow_icon_state = "bulb_maint"

// -------- Directional presets
// The directions are backwards on the lights we have now
MAPPING_DIRECTIONAL_HELPERS_ROBUST(/obj/machinery/light, 23, 0, 12, -12)

// ---- Broken tube
MAPPING_DIRECTIONAL_HELPERS_ROBUST(/obj/machinery/light/broken, 23, 0, 12, -12)

// ---- Tube construct
MAPPING_DIRECTIONAL_HELPERS_ROBUST(/obj/structure/light_construct, 23, 0, 12, -12)

// ---- Tube frames
MAPPING_DIRECTIONAL_HELPERS_ROBUST(/obj/machinery/light/built, 23, 0, 12, -12)

// ---- No nightlight tubes
MAPPING_DIRECTIONAL_HELPERS_ROBUST(/obj/machinery/light/no_nightlight, 23, 0, 12, -12)

// ---- Warm light tubes
MAPPING_DIRECTIONAL_HELPERS_ROBUST(/obj/machinery/light/warm, 23, 0, 12, -12)

// ---- No nightlight warm light tubes
MAPPING_DIRECTIONAL_HELPERS_ROBUST(/obj/machinery/light/warm/no_nightlight, 23, 0, 12, -12)

// ---- Cold light tubes
MAPPING_DIRECTIONAL_HELPERS_ROBUST(/obj/machinery/light/cold, 23, 0, 12, -12)

// ---- No nightlight cold light tubes
MAPPING_DIRECTIONAL_HELPERS_ROBUST(/obj/machinery/light/cold/no_nightlight, 23, 0, 12, -12)

// ---- Red tubes
MAPPING_DIRECTIONAL_HELPERS_ROBUST(/obj/machinery/light/red, 23, 0, 12, -12)

// ---- Red dim tubes
MAPPING_DIRECTIONAL_HELPERS_ROBUST(/obj/machinery/light/red/dim, 23, 0, 12, -12)

// ---- Blacklight tubes
MAPPING_DIRECTIONAL_HELPERS_ROBUST(/obj/machinery/light/blacklight, 23, 0, 12, -12)

// ---- Dim tubes
MAPPING_DIRECTIONAL_HELPERS_ROBUST(/obj/machinery/light/dim, 23, 0, 12, -12)


// -------- Bulb lights
MAPPING_DIRECTIONAL_HELPERS_ROBUST(/obj/machinery/light/small, 23, 0, 12, -12)

// ---- Bulb construct
MAPPING_DIRECTIONAL_HELPERS_ROBUST(/obj/structure/light_construct/small, 23, 0, 12, -12)

// ---- Bulb frames
MAPPING_DIRECTIONAL_HELPERS_ROBUST(/obj/machinery/light/small/built, 23, 0, 12, -12)

// ---- Broken bulbs
MAPPING_DIRECTIONAL_HELPERS_ROBUST(/obj/machinery/light/small/broken, 23, 0, 12, -12)

// ---- Red bulbs
MAPPING_DIRECTIONAL_HELPERS_ROBUST(/obj/machinery/light/small/red, 23, 0, 12, -12)

// ---- Red dim bulbs
MAPPING_DIRECTIONAL_HELPERS_ROBUST(/obj/machinery/light/small/red/dim, 23, 0, 12, -12)

// ---- Blacklight bulbs
MAPPING_DIRECTIONAL_HELPERS_ROBUST(/obj/machinery/light/small/blacklight, 23, 0, 12, -12)

// ---- Maintenance bulbs
MAPPING_DIRECTIONAL_HELPERS_ROBUST(/obj/machinery/light/small/maintenance, 23, 0, 12, -12)
