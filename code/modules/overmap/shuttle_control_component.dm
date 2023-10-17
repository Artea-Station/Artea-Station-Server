/datum/overmap_shuttle_controller
	var/mob/living/mob_controller

	var/list/mob/living/mob_viewers = list()

	var/datum/overmap_object/shuttle/overmap_obj

	var/datum/action/innate/quit_control/quit_control_button
	var/datum/action/innate/stop_shuttle/stop_shuttle_button
	var/datum/action/innate/open_shuttle_control/shuttle_control_button
	var/busy = FALSE

	var/datum/shuttle_freeform_docker/freeform_docker
	var/turf/control_turf

/datum/overmap_shuttle_controller/proc/NewVisualOffset(x,y)
	if(mob_controller && mob_controller.client)
		mob_controller.client.pixel_x = x
		mob_controller.client.pixel_y = y

/datum/overmap_shuttle_controller/New(datum/overmap_object/shuttle/passed_ov_obj)
	overmap_obj = passed_ov_obj
	quit_control_button = new
	quit_control_button.target = src
	stop_shuttle_button = new
	stop_shuttle_button.target = src
	shuttle_control_button = new
	shuttle_control_button.target = src

/datum/overmap_shuttle_controller/Destroy()
	if(mob_controller)
		RemoveCurrentControl()
	QDEL_NULL(quit_control_button)
	QDEL_NULL(stop_shuttle_button)
	QDEL_NULL(shuttle_control_button)
	overmap_obj = null
	return ..()

/datum/overmap_shuttle_controller/proc/SetController(mob/living/our_guy)
	if(mob_controller)
		RemoveCurrentControl()

	mob_controller = our_guy
	RegisterSignal(mob_controller, COMSIG_CLICKON, PROC_REF(ControllerClick))
	mob_controller.client.perspective = EYE_PERSPECTIVE
	mob_controller.client.eye = overmap_obj.my_visual
	mob_controller.client.show_popup_menus = FALSE
	var/list/new_offsets = overmap_obj.GetVisualOffsets()
	NewVisualOffset(new_offsets[1],new_offsets[2])
	mob_controller.remote_control = overmap_obj.my_visual
	mob_controller.update_parallax_contents()
	quit_control_button.Grant(mob_controller)
	stop_shuttle_button.Grant(mob_controller)
	shuttle_control_button.Grant(mob_controller)

/datum/overmap_shuttle_controller/proc/AddViewer(mob/living/our_guy)
	mob_viewers += our_guy
	RegisterSignal(our_guy, COMSIG_CLICKON, PROC_REF(ViewerClick))
	our_guy.client.perspective = EYE_PERSPECTIVE
	our_guy.client.eye = overmap_obj.my_visual
	our_guy.client.show_popup_menus = FALSE
	var/list/new_offsets = overmap_obj.GetVisualOffsets()
	if(our_guy && our_guy.client)
		our_guy.client.pixel_x = new_offsets[1]
		our_guy.client.pixel_y = new_offsets[2]
	our_guy.remote_control = overmap_obj.my_visual
	our_guy.update_parallax_contents()
	var/datum/action/innate/quit_viewing/quit_viewing_button = new
	quit_viewing_button.target = src
	quit_viewing_button.Grant(our_guy)

/datum/overmap_shuttle_controller/proc/RemoveCurrentControl()
	if(mob_controller)
		if(freeform_docker)
			AbortFreeform()
		UnregisterSignal(mob_controller, COMSIG_CLICKON)
		mob_controller.client.perspective = MOB_PERSPECTIVE
		mob_controller.client.eye = mob_controller
		mob_controller.client.show_popup_menus = TRUE
		mob_controller.client.pixel_x = 0
		mob_controller.client.pixel_y = 0
		quit_control_button.Remove(mob_controller)
		stop_shuttle_button.Remove(mob_controller)
		shuttle_control_button.Remove(mob_controller)
		playsound(mob_controller, 'sound/machines/terminal_off.ogg', 25, FALSE)
		mob_controller.remote_control = null
		mob_controller.update_parallax_contents()
		mob_controller = null

/datum/overmap_shuttle_controller/proc/RemoveViewer(mob/our_guy)
	UnregisterSignal(our_guy, COMSIG_CLICKON)
	our_guy.client.perspective = MOB_PERSPECTIVE
	our_guy.client.eye = mob_controller
	our_guy.client.show_popup_menus = TRUE
	our_guy.client.pixel_x = 0
	our_guy.client.pixel_y = 0
	var/datum/action/innate/quit_viewing/quit_viewing_button = locate(/datum/action/innate/quit_viewing) in our_guy.actions
	quit_viewing_button?.Remove(our_guy)
	qdel(quit_viewing_button)
	playsound(our_guy, 'sound/machines/terminal_off.ogg', 25, FALSE)
	our_guy.remote_control = null
	our_guy.update_parallax_contents()
	mob_viewers -= our_guy

/datum/overmap_shuttle_controller/proc/AbortFreeform()
	if(!freeform_docker)
		return
	freeform_docker.remove_eye_control()
	qdel(freeform_docker)
	mob_controller.client.perspective = EYE_PERSPECTIVE
	mob_controller.client.eye = overmap_obj.my_visual
	mob_controller.update_parallax_contents()
	mob_controller.remote_control = overmap_obj.my_visual

/datum/overmap_shuttle_controller/proc/ViewerClick(datum/source, atom/A, params)
	SIGNAL_HANDLER
	if(A.z != overmap_obj.current_system.z_level)
		return
	var/list/modifiers = params2list(params)
	if(modifiers["shift"] && modifiers["right"])
		return
	if(modifiers["shift"])
		A.examine(source)
		return COMSIG_CANCEL_CLICKON

	return COMSIG_CANCEL_CLICKON

/datum/overmap_shuttle_controller/proc/ControllerClick(datum/source, atom/A, params)
	SIGNAL_HANDLER
	if(A.z != overmap_obj.current_system.z_level)
		return
	var/list/modifiers = params2list(params)
	if(modifiers["shift"] && modifiers["right"])
		return
	if(modifiers["shift"])
		A.examine(source)
		return COMSIG_CANCEL_CLICKON
	if(modifiers["right"])
		overmap_obj.CommandMove(A.x,A.y)
		return COMSIG_CANCEL_CLICKON

	return COMSIG_CANCEL_CLICKON

/datum/action/innate/quit_control
	name = "Quit Control"
	icon_icon = 'icons/mob/actions/actions_silicon.dmi'
	button_icon_state = "camera_off"

/datum/action/innate/quit_control/Trigger(trigger_flags)
	var/datum/overmap_shuttle_controller/OSC = target
	OSC.RemoveCurrentControl()

/datum/action/innate/quit_viewing
	name = "Quit Viewing"
	icon_icon = 'icons/mob/actions/actions_silicon.dmi'
	button_icon_state = "camera_off"

/datum/action/innate/quit_viewing/Trigger(trigger_flags)
	var/datum/overmap_shuttle_controller/OSC = target
	OSC.RemoveViewer(owner)

/datum/action/innate/stop_shuttle
	name = "Stop Shuttle"
	icon_icon = 'icons/mob/actions/actions_mod.dmi'
	button_icon_state = "recall"

/datum/action/innate/stop_shuttle/Trigger(trigger_flags)
	var/datum/overmap_shuttle_controller/OSC = target
	OSC.overmap_obj.StopMove()

/datum/action/innate/open_shuttle_control
	name = "Shuttle Controls"
	icon_icon = 'icons/mob/actions/actions_mod.dmi'
	button_icon_state = "panel"

/datum/action/innate/open_shuttle_control/Trigger(trigger_flags)
	var/datum/overmap_shuttle_controller/OSC = target
	OSC.overmap_obj.ui_interact(OSC.mob_controller, null, OSC.control_turf)
