/obj/effect/decal/cleanable/blood/squirt
	name = "blood squirt"
	desc = "Raining blood, from a lacerated sky, bleeding its horror!"
	icon_state = "squirt"
	random_icon_states = null
	dryname = "dried blood squirt"
	drydesc = "Creating my structure - Now I shall reign in blood!"

/obj/effect/decal/cleanable/blood/squirt/Initialize(mapload, direction)
	if(!isnull(direction))
		//has to be done before we call replace_decal()
		setDir(direction)
	return ..()

/obj/effect/decal/cleanable/blood/squirt/replace_decal(obj/effect/decal/cleanable/merger)
	. = ..()
	if(!.)
		return
	//squirts of the same dir are redundant, but not if they're different
	if(merger.dir != src.dir)
		return FALSE
