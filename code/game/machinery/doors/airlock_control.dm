// This code allows for airlocks to be controlled externally by setting an id_tag and comm frequency (disables ID access)

/obj/machinery/door
	var/datum/radio_frequency/radio_connection

/obj/machinery/door/airlock
	opens_with_door_remote = TRUE

	/// The current state of the airlock, used to construct the airlock overlays
	var/airlock_state
	var/frequency

/obj/machinery/door/airlock/receive_signal(datum/signal/signal)
	if(!signal)
		return

	if(id_tag != signal.data["tag"] || !signal.data["command"])
		return

	switch(signal.data["command"])
		if("open")
			open()

		if("close")
			close()

		if("unlock")
			unlock()

		if("lock")
			lock()

		if("secure_open")
			secure_open()
			return // This does it's own send status.

		if("secure_close")
			secure_close()
			return // This does it's own send status.

	send_status()

/obj/machinery/door/proc/secure_open()
	set waitfor = FALSE

	if(!density || opening)
		return

	unlock()

	sleep(2)
	open()
	send_status()

	lock()

/obj/machinery/door/proc/secure_close()
	set waitfor = FALSE

	if(density || closing)
		return

	unlock()

	sleep(2)
	close()
	send_status()

	lock()

/obj/machinery/door/proc/send_status()
	if(radio_connection)
		var/datum/signal/signal = new(list(
			"tag" = id_tag,
			"timestamp" = world.time,
			"door_status" = closing ? "closed" : opening ? "open" : density ? "closed" : "open",
			"lock_status" = locked ? "locked" : "unlocked"
		))
		radio_connection.post_signal(src, signal, range = AIRLOCK_CONTROL_RANGE, filter = RADIO_AIRLOCK)

/obj/machinery/door/airlock/proc/set_frequency(new_frequency)
	SSradio.remove_object(src, frequency)
	if(new_frequency)
		frequency = new_frequency
		radio_connection = SSradio.add_object(src, frequency, RADIO_AIRLOCK)

/obj/machinery/door/airlock/on_magic_unlock(datum/source, datum/action/cooldown/spell/aoe/knock/spell, mob/living/caster)
	// Airlocks should unlock themselves when knock is casted, THEN open up.
	locked = FALSE
	return ..()

/obj/machinery/door/airlock/Destroy()
	if(frequency)
		SSradio.remove_object(src,frequency)
	return ..()
