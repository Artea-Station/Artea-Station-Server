// This is in it's own file cause of how goddamn monolithic this crap is.

/obj/machinery/airlock_controller/process()
	var/sensor_pressure = memory["chamber_pressure"]
	// Used in a few places to check if it already did something this tick, and returning if it did before doing anything more.
	var/did_something = FALSE
	switch(state)
		if(AIRLOCK_STATE_OPEN)
			// Turn off the pump, we're done here.
			if(memory["pump_status"] != "off")
				post_signal(new /datum/signal(list(
					"tag" = airpump_tag,
					"power" = FALSE,
					"sigtype" = "command"
				)))

			else if (target_state != AIRLOCK_STATE_OPEN)
				state = AIRLOCK_STATE_CLOSED

		if(AIRLOCK_STATE_INOPEN)
			if(target_state != AIRLOCK_STATE_INOPEN)
				if(memory["interior_status"] == "closed")
					state = AIRLOCK_STATE_CLOSED
				else
					post_signal(new /datum/signal(list(
						"tag" = interior_door_tag,
						"command" = "secure_close"
					)))
			else
				if(memory["pump_status"] != "off")
					post_signal(new /datum/signal(list(
						"tag" = airpump_tag,
						"power" = FALSE,
						"sigtype" = "command"
					)))

		if(AIRLOCK_STATE_PRESSURIZE)
			if(target_state == AIRLOCK_STATE_INOPEN || target_state == AIRLOCK_STATE_OPEN || target_state == AIRLOCK_STATE_OUTOPEN)
				var/is_safe = sensor_pressure >= ONE_ATMOSPHERE*0.95
				if(is_safe && target_state == AIRLOCK_STATE_INOPEN)
					if(memory["interior_status"] == "open")
						state = AIRLOCK_STATE_INOPEN
					else
						post_signal(new /datum/signal(list(
							"tag" = interior_door_tag,
							"command" = "secure_open"
						)))
				else if(is_safe && target_state == AIRLOCK_STATE_OPEN)
					if(memory["interior_status"] == "open" && memory["exterior_status"] == "open")
						state = AIRLOCK_STATE_OPEN
					else
						post_signal(new /datum/signal(list(
							"tag" = interior_door_tag,
							"command" = "secure_open"
						)))
						post_signal(new /datum/signal(list(
							"tag" = exterior_door_tag,
							"command" = "secure_open"
						)))
				else if(is_safe && target_state == AIRLOCK_STATE_OUTOPEN)
					if(memory["exterior_status"] == "open")
						state = AIRLOCK_STATE_OUTOPEN
					else
						post_signal(new /datum/signal(list(
							"tag" = exterior_door_tag,
							"command" = "secure_open"
						)))

				else
					var/datum/signal/signal = new(list(
						"tag" = airpump_tag,
						"sigtype" = "command"
					))
					if(memory["pump_status"] == "siphon")
						signal.data["stabilize"] = TRUE
					else if(memory["pump_status"] != "release")
						signal.data["power"] = TRUE
					post_signal(signal)
			else
				state = AIRLOCK_STATE_CLOSED

		if(AIRLOCK_STATE_CLOSED)
			if(memory["interior_status"] != "closed")
				post_signal(new /datum/signal(list(
					"tag" = interior_door_tag,
					"command" = "secure_close"
				)))
			if(memory["exterior_status"] != "closed")
				post_signal(new /datum/signal(list(
					"tag" = exterior_door_tag,
					"command" = "secure_close"
				)))
			if(did_something) // Only do one "action" per process
				return

			if(target_state == AIRLOCK_STATE_OUTOPEN)
				if(sanitize_external && !docked)
					state = AIRLOCK_STATE_DEPRESSURIZE
				else
					state = AIRLOCK_STATE_PRESSURIZE

			else if(target_state == AIRLOCK_STATE_INOPEN || target_state == AIRLOCK_STATE_OPEN)
				state = AIRLOCK_STATE_PRESSURIZE

			else
				// Always have the pump on if the alarm's going, otherwise, turn it off, as normal use doesn't require hiding in here.
				if(is_firelock && sound_loop.is_active())
					var/datum/signal/signal = new(list(
						"tag" = airpump_tag,
						"sigtype" = "command"
					))
					if(memory["pump_status"] == "siphon")
						signal.data["stabilize"] = TRUE
					else if(memory["pump_status"] != "release")
						signal.data["power"] = TRUE
					post_signal(signal)

				else if(memory["pump_status"] != "off")
					post_signal(new /datum/signal(list(
						"tag" = airpump_tag,
						"power" = FALSE,
						"sigtype" = "command"
					)))

		if(AIRLOCK_STATE_DEPRESSURIZE)
			var/target_pressure = ONE_ATMOSPHERE*0.05
			if(sanitize_external)
				target_pressure = ONE_ATMOSPHERE*0.01

			if(sensor_pressure <= target_pressure)
				if(target_state == AIRLOCK_STATE_OUTOPEN)
					if(memory["exterior_status"] == "open")
						state = AIRLOCK_STATE_OUTOPEN
					else
						post_signal(new /datum/signal(list(
							"tag" = exterior_door_tag,
							"command" = "secure_open"
						)))
				else
					state = AIRLOCK_STATE_CLOSED
			else if((target_state != AIRLOCK_STATE_OUTOPEN) && !sanitize_external)
				state = AIRLOCK_STATE_CLOSED
			else
				var/datum/signal/signal = new(list(
					"tag" = airpump_tag,
					"sigtype" = "command"
				))
				if(memory["pump_status"] == "release")
					signal.data["purge"] = TRUE
				else if(memory["pump_status"] != "siphon")
					signal.data["power"] = TRUE
				post_signal(signal)

		if(AIRLOCK_STATE_OUTOPEN)
			if(target_state != AIRLOCK_STATE_OUTOPEN)
				if(memory["exterior_status"] == "closed")
					state = AIRLOCK_STATE_CLOSED
				else
					post_signal(new /datum/signal(list(
						"tag" = exterior_door_tag,
						"command" = "secure_close"
					)))
			else
				if(memory["interior_lock_status"] == "locked")
					post_signal(new /datum/signal(list(
						"tag" = interior_door_tag,
						"command" = "unlock"
					)))
				// Stop the pump if it's on. It shouldn't be.
				if(memory["pump_status"] != "off" && sensor_pressure >= ONE_ATMOSPHERE*0.95)
					post_signal(new /datum/signal(list(
						"tag" = airpump_tag,
						"power" = FALSE,
						"sigtype" = "command"
					)))

	memory["processing"] = state != target_state

	return TRUE
