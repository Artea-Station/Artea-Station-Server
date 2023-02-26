/mob/living/silicon/robot/Moved(atom/OldLoc, Dir, Forced = FALSE)
	. = ..()
	if(robot_resting)
		robot_resting = FALSE
		on_standing_up()
		update_icons()

/mob/living/silicon/robot/toggle_resting()
	robot_lay_down()

/mob/living/silicon/robot/on_lying_down(new_lying_angle)
	if(layer == initial(layer)) //to avoid things like hiding larvas.
		layer = LYING_MOB_LAYER //so mob lying always appear behind standing mobs
	density = FALSE // We lose density and stop bumping passable dense things.

/mob/living/silicon/robot/on_standing_up()
	if(layer == LYING_MOB_LAYER)
		layer = initial(layer)
	density = initial(density) // We were prone before, so we become dense and things can bump into us again.

/mob/living/silicon/robot/proc/rest_style()
	set name = "Switch Rest Style"
	set category = "Robot Commands"
	set desc = "Select your resting pose."
	if(!dogborg)
		to_chat(src, "<span class='warning'>You can't do that!</span>")
		return
	var/choice = alert(src, "Select resting pose", "", "Resting", "Sitting", "Belly up")
	switch(choice)
		if("Resting")
			robot_rest_style = ROBOT_REST_NORMAL
		if("Sitting")
			robot_rest_style = ROBOT_REST_SITTING
		if("Belly up")
			robot_rest_style = ROBOT_REST_BELLY_UP
	robot_resting = robot_rest_style
	on_lying_down()
	update_icons()

/mob/living/silicon/robot
	var/nextrobotreset = 1

/mob/living/silicon/robot/proc/user_reset_model()
	set name = "Reset Shell Model"
	set category = "Robot Commands"
	set desc = "Reset your Shell Model to Factory"
	if(src.nextrobotreset > world.time)
		to_chat(src, SPAN_DANGER("An error displays from the reset module: System not fully cooled down, Please wait [DisplayTimeText(src.nextrobotreset - world.time)]."))
		return
	src.nextrobotreset = world.time + ROBOT_RESET_DELAY
	ResetModel()


/mob/living/silicon/robot/proc/robot_lay_down()
	set name = "Lay down"
	set category = "Robot Commands"
	if(!dogborg)
		to_chat(src, "<span class='warning'>You can't do that!</span>")
		return
	if(stat != CONSCIOUS) //Make sure we don't enable movement when not concious
		return
	if(robot_resting)
		to_chat(src, "<span class='notice'>You are now getting up.</span>")
		robot_resting = FALSE
		mobility_flags = MOBILITY_FLAGS_DEFAULT
		on_standing_up()
	else
		to_chat(src, "<span class='notice'>You are now laying down.</span>")
		robot_resting = robot_rest_style
		on_lying_down()
	update_icons()

/mob/living/silicon/robot/update_resting()
	. = ..()
	if(dogborg)
		robot_resting = FALSE
		update_icons()

/mob/living/silicon/robot/update_module_innate()
	..()
	if(hands)
		hands.icon = (model.model_select_alternate_icon ? model.model_select_alternate_icon : initial(hands.icon))

/mob/living/silicon/robot/start_pulling(atom/movable/AM, state, force, supress_message)
	. = ..()
	if(dogborg)
		src.transform.Translate(-16, 0)

/mob/living/silicon/robot/stop_pulling()
	. = ..()
	if(dogborg)
		src.transform.Translate(-16, 0)
