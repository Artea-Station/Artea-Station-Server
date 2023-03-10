// For interact particle

/// The offset to use for the interact particle.
/obj/item/bodypart/proc/get_interact_particle_offset(direction)
	return null

/obj/item/bodypart/arm/right/get_interact_particle_offset(direction)
	switch(direction)
		if(NORTH)
			return list(6,-3)
		if(SOUTH)
			return list(-6,-3)
		if(EAST)
			return list(0,-3)
		if(WEST)
			return list(0,-3)

/obj/item/bodypart/arm/left/get_interact_particle_offset(direction)
	switch(direction)
		if(NORTH)
			return list(-6,-3)
		if(SOUTH)
			return list(6,-3)
		if(EAST)
			return list(0,-3)
		if(WEST)
			return list(0,-3)
