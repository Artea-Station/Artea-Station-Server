/obj/machinery/modular_computer/console
	name = "console"
	desc = "A stationary computer."

	icon = 'icons/obj/modular_console.dmi'
	icon_state = "computer"
	icon_state_powered = "computer"
	icon_state_unpowered = "computer"
	base_icon_state = "computer"
	hardware_flag = PROGRAM_CONSOLE
	density = TRUE
	base_idle_power_usage = 100
	base_active_power_usage = 500
	steel_sheet_cost = 10
	light_strength = 2
	max_integrity = 300
	integrity_failure = 0.5
	///Used in New() to set network tag according to our area.
	var/console_department = ""

/obj/machinery/modular_computer/console/Initialize(mapload)
	. = ..()
	if(cpu)
		cpu.screen_on = TRUE
	update_appearance()

/obj/machinery/modular_computer/console/update_icon_state()
	if(cpu.get_integrity() <= cpu.integrity_failure * cpu.max_integrity)
		icon_state = "[base_icon_state]_broken"
		return

	return ..()

/obj/machinery/modular_computer/console/update_overlays()
	. = ..()

	if(cpu.get_integrity() <= cpu.integrity_failure * cpu.max_integrity)
		. -= "broken"
		. += mutable_appearance(icon, "[base_icon_state]_broken_glass", layer + 0.01)
		return // If we don't do this broken computers glow in the dark.

	if(!cpu.last_power_usage) // Your screen can't be on if you're not using any damn power
		. += mutable_appearance(icon, "[base_icon_state]_glass", layer + 0.01)
		return

	. += emissive_appearance(icon, cpu.active_program?.program_icon_state || screen_icon_state_menu)
