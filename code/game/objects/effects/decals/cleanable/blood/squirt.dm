/obj/effect/decal/cleanable/blood/squirt
	name = "blood squirt"
	desc = "Raining blood, from a lacerated sky, bleeding its horror!"
	icon_state = "squirt"
	random_icon_states = null
	dryname = "dried blood squirt"
	drydesc = "Creating my structure - Now I shall reign in blood!"

/obj/effect/decal/cleanable/blood/squirt/Initialize(mapload, direction)
	. = ..()
	if(!isnull(direction))
		setDir(direction)
