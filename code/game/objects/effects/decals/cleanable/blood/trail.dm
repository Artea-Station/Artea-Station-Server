/obj/effect/decal/cleanable/blood/trail
	name = "blood trail"
	desc = "Your instincts say you shouldn't be following these."
	icon = 'icons/effects/blood.dmi'
	icon_state = null
	random_icon_states = null
	beauty = -50
	bloodiness = BLOOD_AMOUNT_PER_DECAL * 0.2
	dryname = "dried blood trail"
	drydesc = "It's probably safer now, but your instincts still say you shouldn't be following these."
	/// Existing directions for building our overlays
	var/list/existing_dirs = list()
	/// Last direction we added to existing dirs
	var/last_dir = NONE

/obj/effect/decal/cleanable/blood/trail/proc/add_trail(state = "ltrail", direction)
	var/new_dir = direction
	if((new_dir != last_dir) && (last_dir in GLOB.cardinals) && (direction in GLOB.cardinals))
		switch(last_dir)
			if(NORTH)
				if(direction & EAST)
					new_dir = NORTHWEST
				else
					new_dir = NORTHEAST
			if(SOUTH)
				if(direction & EAST)
					new_dir = SOUTHWEST
				else
					new_dir = SOUTHEAST
			if(EAST)
				if(direction & NORTH)
					new_dir = SOUTHEAST
				else
					new_dir = NORTHEAST
			if(WEST)
				if(direction & NORTH)
					new_dir = SOUTHWEST
				else
					new_dir = NORTHWEST
		existing_dirs -= "[last_dir]"
	if(existing_dirs["[new_dir]"])
		return
	existing_dirs["[new_dir]"] = image(icon, state, dir = new_dir)
	last_dir = new_dir
	update_appearance(UPDATE_ICON)

/obj/effect/decal/cleanable/blood/trail/update_overlays()
	. = ..()
	for(var/direction in existing_dirs)
		. += existing_dirs[direction]
