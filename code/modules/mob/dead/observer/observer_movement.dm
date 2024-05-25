/mob/dead/observer/up()
	set name = "Move Upwards"
	set category = "IC"

	var/target = src.z + 1
	if(src.z >= SSmapping.z_list.len)
		target = 1
	src.z = target
	to_chat(src, span_notice("You move upwards."))

/mob/dead/observer/down()
	set name = "Move Down"
	set category = "IC"

	var/target = src.z - 1
	if(src.z <= 1)
		target = SSmapping.z_list.len
	src.z = target
	to_chat(src, span_notice("You move down."))

/mob/dead/observer/can_z_move(direction, turf/start, turf/destination, z_move_flags = NONE, mob/living/rider)
	z_move_flags |= ZMOVE_IGNORE_OBSTACLES  //observers do not respect these FLOORS you speak so much of.
	return ..()

