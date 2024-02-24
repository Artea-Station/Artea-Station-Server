/datum/wires/bulkhead/shell
	holder_type = /obj/machinery/door/bulkhead/shell
	proper_name = "Circuit Bulkhead"

/datum/wires/bulkhead/shell/on_cut(wire, mend)
	// Don't allow them to re-enable autoclose.
	if(wire == WIRE_TIMING)
		return
	return ..()

/obj/machinery/door/bulkhead/shell
	name = "circuit bulkhead"
	autoclose = FALSE

/obj/machinery/door/bulkhead/shell/Initialize(mapload)
	. = ..()
	AddComponent( \
		/datum/component/shell, \
		unremovable_circuit_components = list(new /obj/item/circuit_component/bulkhead, new /obj/item/circuit_component/bulkhead_access_event), \
		capacity = SHELL_CAPACITY_LARGE, \
		shell_flags = SHELL_FLAG_ALLOW_FAILURE_ACTION|SHELL_FLAG_REQUIRE_ANCHOR \
	)

/obj/machinery/door/bulkhead/shell/check_access(obj/item/I)
	return FALSE

/obj/machinery/door/bulkhead/shell/canAIControl(mob/user)
	return FALSE

/obj/machinery/door/bulkhead/shell/canAIHack(mob/user)
	return FALSE

/obj/machinery/door/bulkhead/shell/allowed(mob/user)
	if(SEND_SIGNAL(src, COMSIG_AIRLOCK_SHELL_ALLOWED, user) & COMPONENT_OBJ_ALLOW)
		return TRUE
	return isAdminGhostAI(user)

/obj/machinery/door/bulkhead/shell/set_wires()
	return new /datum/wires/bulkhead/shell(src)

/obj/item/circuit_component/bulkhead
	display_name = "Bulkhead"
	desc = "The general interface with an bulkhead. Includes general statuses of the bulkhead"

	/// The shell, if it is an bulkhead.
	var/obj/machinery/door/bulkhead/attached_bulkhead

	/// Bolts the bulkhead (if possible)
	var/datum/port/input/bolt
	/// Unbolts the bulkhead (if possible)
	var/datum/port/input/unbolt
	/// Opens the bulkhead (if possible)
	var/datum/port/input/open
	/// Closes the bulkhead (if possible)
	var/datum/port/input/close

	/// Contains whether the bulkhead is open or not
	var/datum/port/output/is_open
	/// Contains whether the bulkhead is bolted or not
	var/datum/port/output/is_bolted

	/// Called when the bulkhead is opened.
	var/datum/port/output/opened
	/// Called when the bulkhead is closed
	var/datum/port/output/closed

	/// Called when the bulkhead is bolted
	var/datum/port/output/bolted
	/// Called when the bulkhead is unbolted
	var/datum/port/output/unbolted

/obj/item/circuit_component/bulkhead/populate_ports()
	// Input Signals
	bolt = add_input_port("Bolt", PORT_TYPE_SIGNAL)
	unbolt = add_input_port("Unbolt", PORT_TYPE_SIGNAL)
	open = add_input_port("Open", PORT_TYPE_SIGNAL)
	close = add_input_port("Close", PORT_TYPE_SIGNAL)
	// States
	is_open = add_output_port("Is Open", PORT_TYPE_NUMBER)
	is_bolted = add_output_port("Is Bolted", PORT_TYPE_NUMBER)
	// Output Signals
	opened = add_output_port("Opened", PORT_TYPE_SIGNAL)
	closed = add_output_port("Closed", PORT_TYPE_SIGNAL)
	bolted = add_output_port("Bolted", PORT_TYPE_SIGNAL)
	unbolted = add_output_port("Unbolted", PORT_TYPE_SIGNAL)

/obj/item/circuit_component/bulkhead/register_shell(atom/movable/shell)
	. = ..()
	if(istype(shell, /obj/machinery/door/bulkhead))
		attached_bulkhead = shell
		RegisterSignal(shell, COMSIG_BULKHEAD_SET_BOLT, PROC_REF(on_bulkhead_set_bolted))
		RegisterSignal(shell, COMSIG_BULKHEAD_OPEN, PROC_REF(on_bulkhead_open))
		RegisterSignal(shell, COMSIG_BULKHEAD_CLOSE, PROC_REF(on_bulkhead_closed))

/obj/item/circuit_component/bulkhead/unregister_shell(atom/movable/shell)
	attached_bulkhead = null
	UnregisterSignal(shell, list(
		COMSIG_BULKHEAD_SET_BOLT,
		COMSIG_BULKHEAD_OPEN,
		COMSIG_BULKHEAD_CLOSE,
	))
	return ..()

/obj/item/circuit_component/bulkhead/proc/on_bulkhead_set_bolted(datum/source, should_bolt)
	SIGNAL_HANDLER
	is_bolted.set_output(should_bolt)
	if(should_bolt)
		bolted.set_output(COMPONENT_SIGNAL)
	else
		unbolted.set_output(COMPONENT_SIGNAL)

/obj/item/circuit_component/bulkhead/proc/on_bulkhead_open(datum/source, force)
	SIGNAL_HANDLER
	is_open.set_output(TRUE)
	opened.set_output(COMPONENT_SIGNAL)

/obj/item/circuit_component/bulkhead/proc/on_bulkhead_closed(datum/source, forced)
	SIGNAL_HANDLER
	is_open.set_output(FALSE)
	closed.set_output(COMPONENT_SIGNAL)

/obj/item/circuit_component/bulkhead/input_received(datum/port/input/port)

	if(!attached_bulkhead)
		return

	if(COMPONENT_TRIGGERED_BY(bolt, port))
		attached_bulkhead.bolt()
	if(COMPONENT_TRIGGERED_BY(unbolt, port))
		attached_bulkhead.unbolt()
	if(COMPONENT_TRIGGERED_BY(open, port) && attached_bulkhead.density)
		INVOKE_ASYNC(attached_bulkhead, TYPE_PROC_REF(/obj/machinery/door/bulkhead, open))
	if(COMPONENT_TRIGGERED_BY(close, port) && !attached_bulkhead.density)
		INVOKE_ASYNC(attached_bulkhead, TYPE_PROC_REF(/obj/machinery/door/bulkhead, close))


/obj/item/circuit_component/bulkhead_access_event
	display_name = "Bulkhead Access Event"
	desc = "An event that can be handled through circuit components to determine if the door should open or not for an entity that might be trying to access it."
	circuit_flags = CIRCUIT_FLAG_INSTANT

	/// The shell, if it is an bulkhead.
	var/obj/machinery/door/bulkhead/attached_bulkhead

	/// Tells the event to open the bulkhead.
	var/datum/port/input/open_bulkhead

	/// The person trying to open the bulkhead.
	var/datum/port/output/accessing_entity

	/// The signal sent when this event is triggered
	var/datum/port/output/event_triggered


/obj/item/circuit_component/bulkhead_access_event/register_shell(atom/movable/shell)
	. = ..()
	if(istype(shell, /obj/machinery/door/bulkhead))
		attached_bulkhead = shell
		RegisterSignal(shell, list(
			COMSIG_OBJ_ALLOWED,
			COMSIG_AIRLOCK_SHELL_ALLOWED,
		), PROC_REF(handle_allowed))

/obj/item/circuit_component/bulkhead_access_event/unregister_shell(atom/movable/shell)
	attached_bulkhead = null
	UnregisterSignal(shell, list(
		COMSIG_OBJ_ALLOWED,
		COMSIG_AIRLOCK_SHELL_ALLOWED
	))
	return ..()


/obj/item/circuit_component/bulkhead_access_event/populate_ports()
	open_bulkhead = add_input_port("Should Open Bulkhead", PORT_TYPE_RESPONSE_SIGNAL, trigger = PROC_REF(should_open_bulkhead))
	accessing_entity = add_output_port("Accessing Entity", PORT_TYPE_ATOM)
	event_triggered = add_output_port("Event Triggered", PORT_TYPE_INSTANT_SIGNAL)


/obj/item/circuit_component/bulkhead_access_event/proc/should_open_bulkhead(datum/port/input/port, list/return_values)
	CIRCUIT_TRIGGER
	if(!return_values)
		return
	return_values["should_open"] = TRUE

/obj/item/circuit_component/bulkhead_access_event/proc/handle_allowed(datum/source, mob/accesser)
	SIGNAL_HANDLER
	if(!attached_bulkhead)
		return

	SScircuit_component.queue_instant_run()
	accessing_entity.set_output(accesser)
	event_triggered.set_output(COMPONENT_SIGNAL)
	var/list/result = SScircuit_component.execute_instant_run()

	if(!result)
		attached_bulkhead.visible_message(span_warning("[attached_bulkhead]'s circuitry overheats!"))
		return

	if(result["should_open"])
		return COMPONENT_OBJ_ALLOW
	else
		return COMPONENT_OBJ_DISALLOW
