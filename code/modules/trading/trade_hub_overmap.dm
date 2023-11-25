/datum/overmap_object/trade_hub
	name = "Trading Hub"
	visual_type = /obj/effect/abstract/overmap/trade_hub
	clears_hazards_on_spawn = TRUE
	var/datum/trade_hub/hub


/datum/overmap_object/trade_hub/New(datum/overmap_sun_system/passed_system, x_coord, y_coord, hub_type, pixel_x = 0, pixel_y = 0)
	. = ..()
	hub = new hub_type(src)
	partial_x = pixel_x
	partial_y = pixel_y
	UpdateVisualOffsets()

/datum/overmap_object/trade_hub/Destroy()
	QDEL_NULL(hub)
	return ..()

/obj/effect/abstract/overmap/trade_hub
	icon_state = "trade"
	color = COLOR_GREEN
	layer = OVERMAP_LAYER_STATION
