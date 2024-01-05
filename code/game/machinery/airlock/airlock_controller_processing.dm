// This is in it's own file cause of how goddamn monolithic this crap is.

/obj/machinery/airlock_controller/process()
	var/sensor_pressure = memory["chamber_pressure"]
	switch(state)
		if(AIRLOCK_STATE_OPEN)
			if(target_state == AIRLOCK_STATE_INOPEN)
				if(sensor_pressure >= ONE_ATMOSPHERE*0.95)
					if(memory["interior_status"] == "open" && memory["exterior_status"] == "open")
						state = AIRLOCK_STATE_OPEN
					else
						if(memory["interior_status"] == "closed")
							post_signal(new /datum/signal(list(
								"tag" = interior_door_tag,
								"command" = "secure_open",
							)))
						if(memory["exterior_status"] == "closed")
							post_signal(new /datum/signal(list(
								"tag" = exterior_door_tag,
								"command" = "secure_open",
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

		if(AIRLOCK_STATE_INOPEN)
			if(target_state != state)
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
			if(target_state == AIRLOCK_STATE_INOPEN || target_state == AIRLOCK_STATE_OPEN)
				if(sensor_pressure >= ONE_ATMOSPHERE*0.95 && target_state == AIRLOCK_STATE_INOPEN)
					if(memory["interior_status"] == "open")
						state = AIRLOCK_STATE_INOPEN
					else
						post_signal(new /datum/signal(list(
							"tag" = interior_door_tag,
							"command" = "secure_open"
						)))
				else if(sensor_pressure >= ONE_ATMOSPHERE*0.95 && target_state == AIRLOCK_STATE_OPEN)
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
			if(target_state == AIRLOCK_STATE_OUTOPEN)
				if(memory["interior_status"] == "closed")
					state = AIRLOCK_STATE_DEPRESSURIZE
				else
					post_signal(new /datum/signal(list(
						"tag" = interior_door_tag,
						"command" = "secure_close"
					)))
					post_signal(new /datum/signal(list(
						"tag" = exterior_door_tag,
						"command" = "secure_close"
					)))
			else if(target_state == AIRLOCK_STATE_INOPEN)
				if(memory["exterior_status"] == "closed")
					state = AIRLOCK_STATE_PRESSURIZE
				else
					post_signal(new /datum/signal(list(
						"tag" = interior_door_tag,
						"command" = "secure_close"
					)))
					post_signal(new /datum/signal(list(
						"tag" = exterior_door_tag,
						"command" = "secure_close"
					)))
			else if(target_state == AIRLOCK_STATE_OPEN)
				var/did_something = FALSE
				if(memory["interior_status"] != "open")
					post_signal(new /datum/signal(list(
						"tag" = interior_door_tag,
						"command" = "secure_open"
					)))
					did_something = TRUE
				if(memory["exterior_status"] != "open")
					post_signal(new /datum/signal(list(
						"tag" = exterior_door_tag,
						"command" = "secure_open"
					)))
					did_something = TRUE

				if(!did_something)
					state = AIRLOCK_STATE_PRESSURIZE

			else
				if(memory["pump_status"] != "off")
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

		if(AIRLOCK_STATE_OUTOPEN) //state 2
			if(target_state != AIRLOCK_STATE_OUTOPEN)
				if(memory["exterior_status"] == "closed")
					if(sanitize_external)
						state = AIRLOCK_STATE_DEPRESSURIZE
					else
						state = AIRLOCK_STATE_CLOSED
				else
					post_signal(new /datum/signal(list(
						"tag" = exterior_door_tag,
						"command" = "secure_close"
					)))
			else
				if(memory["pump_status"] != "off")
					post_signal(new /datum/signal(list(
						"tag" = airpump_tag,
						"power" = FALSE,
						"sigtype" = "command"
					)))

	memory["processing"] = state != target_state

	return TRUE
