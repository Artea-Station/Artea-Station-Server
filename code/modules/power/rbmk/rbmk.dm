//For my sanity :))
// You made a giga-file containing a bunch of unrelated content that I had to separate. It was, in fact, not for anyone's sanity. - Rimi

//Reference: Heaters go up to 500K.
//Hot plasmaburn: ~14400 k.

/// !!!ARTEA NOTE, READ THIS SHIT!!!
/*
	Okay, so this shitshow of a conversion makes the RBMK work a little in between the SM and the RBMK, to make it easy to learn, but hard to master (at least once the PA is added).

	PLASMA, AND OTHER RADIOACTIVE GASSES (just tritium for now) ARE NOW THE ONLY FUELS!

	This means stuff like oxygen just won't do anything, and at best, slow down the reactor/clog pipes, and at worst, cause a pipe fire, which'll likely cause a cascading issue with reaction speed.

	The hotter the fuel, the faster it burns, and the more power the reactor makes.

	The temperature itself has no direct effect on the reactor's heat output aside from the above, for balancing's sake.

	The coolant loop is the same old deal as always, and decides the reactor pressure.
*/

//Remember kids, if the reactor itself is not physically powered by an APC, it cannot shove coolant or fuel in!

#define COOLANT_INPUT_GATE airs[1]
#define MODERATOR_INPUT_GATE airs[2]
#define COOLANT_OUTPUT_GATE airs[3]

#define OFFSET_TEMPERATURE (temperature - 70)

GLOBAL_LIST_EMPTY(rbmk_reactors)

/obj/machinery/atmospherics/components/trinary/nuclear_reactor
	name = "Advanced Gas-Cooled Nuclear Reactor"
	desc = "A tried and tested design which can output stable power at an acceptably low risk. The moderator can be changed to provide different effects."
	icon = 'icons/obj/machines/rbmk/rbmk.dmi'
	icon_state = "reactor_map"
	pixel_x = -32
	pixel_y = -32
	density = FALSE //It burns you if you're stupid enough to walk over it.
	anchored = TRUE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF
	light_color = LIGHT_COLOR_CYAN
	dir = WEST //Less headache inducing :))
	var/id = null //Change me mappers
	//Variables essential to operation
	var/temperature = 0 //Lose control of this -> Meltdown
	var/vessel_integrity = 400 //How long can the reactor withstand overpressure / meltdown? This gives you a fair chance to react to even a massive pipe fire
	var/pressure = 0 //Lose control of this -> Blowout
	var/rate_of_reaction = 0 //Rate of reaction.
	var/desired_k = 0
	var/control_rod_effectiveness = 0.65 //Starts off with a lot of control over rate_of_reaction. If you flood this thing with plasma, you lose your ability to control rate_of_reaction as easily.
	var/power = 0 //0-100%. A function of the maximum heat you can achieve within operating temperature
	var/has_fuel
	var/started = FALSE
	//Secondary variables.
	var/warning = FALSE //Have we begun warning the crew of their impending death?
	var/next_warning = 0 //To avoid spam.
	var/last_power_produced = 0 //For logging purposes
	var/next_flicker = 0 //Light flicker timer
	var/slagged = FALSE //Is this reactor even usable any more?
	//Console statistics.
	var/last_coolant_temperature = 0
	var/last_output_temperature = 0
	var/last_heat_delta = 0 //For administrative cheating only. Knowing the delta lets you know EXACTLY what to set rate_of_reaction at.
	var/no_coolant_ticks = 0	//How many times in succession did we not have enough coolant? Decays twice as fast as it accumulates.
	var/last_user = null
	var/datum/looping_sound/rbmk_reactor/soundloop
	var/datum/powernet/powernet = null

//Use this in your maps if you want everything to be preset.
/obj/machinery/atmospherics/components/trinary/nuclear_reactor/preset
	id = "rbmk_default"

/obj/machinery/atmospherics/components/trinary/nuclear_reactor/Initialize()
	. = ..()
	RegisterSignal(src, COMSIG_MOVABLE_CROSS_OVER, PROC_REF(crossed_over))
	connect_to_network()
	icon_state = "reactor_off"
	GLOB.rbmk_reactors += src

/obj/machinery/atmospherics/components/trinary/nuclear_reactor/examine(mob/user)
	. = ..()
	if(Adjacent(src, user))
		if(do_after(user, 1 SECONDS, target=src, interaction_key = "rbmk_inspect"))
			var/percent = vessel_integrity / initial(vessel_integrity) * 100
			var/msg = "<span class='warning'>The reactor looks operational.</span>"
			switch(percent)
				if(0 to 10)
					msg = "<span class='boldwarning'>[src]'s seals are dangerously warped and you can see cracks all over the reactor vessel! </span>"
				if(10 to 40)
					msg = "<span class='boldwarning'>[src]'s seals are heavily warped and cracked! </span>"
				if(40 to 60)
					msg = "<span class='warning'>[src]'s seals are holding, but barely. You can see some micro-fractures forming in the reactor vessel.</span>"
				if(60 to 80)
					msg = "<span class='warning'>[src]'s seals are in-tact, but slightly worn. There are no visible cracks in the reactor vessel.</span>"
				if(80 to 90)
					msg = "<span class='notice'>[src]'s seals are in good shape, and there are no visible cracks in the reactor vessel.</span>"
				if(95 to 100)
					msg = "<span class='notice'>[src]'s seals look factory new, and the reactor's in excellent shape.</span>"
			. += msg

/obj/machinery/atmospherics/components/trinary/nuclear_reactor/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/sealant))
		if(power >= 20)
			to_chat(user, "<span class='notice'>You cannot repair [src] while it is running at above 20% power.</span>")
			return FALSE
		if(vessel_integrity >= 350)
			to_chat(user, "<span class='notice'>[src]'s seals are already in-tact, repairing them further would require a new set of seals.</span>")
			return FALSE
		if(vessel_integrity <= 0.5 * initial(vessel_integrity)) //Heavily damaged.
			to_chat(user, "<span class='notice'>[src]'s reactor vessel is cracked and worn, you need to repair the cracks with a welder before you can repair the seals.</span>")
			return FALSE
		if(do_after(user, 5 SECONDS, target=src, interaction_key = "rbmk_repair"))
			if(vessel_integrity >= 350)	//They might've stacked doafters
				to_chat(user, "<span class='notice'>[src]'s seals are already in-tact, repairing them further would require a new set of seals.</span>")
				return FALSE
			playsound(src, 'sound/effects/spray2.ogg', 50, 1, -6)
			user.visible_message("<span class='warning'>[user] applies sealant to some of [src]'s worn out seals.</span>", "<span class='notice'>You apply sealant to some of [src]'s worn out seals.</span>")
			vessel_integrity += 30
			vessel_integrity = clamp(vessel_integrity, 0, initial(vessel_integrity))
		return TRUE
	return ..()

/obj/machinery/atmospherics/components/trinary/nuclear_reactor/welder_act(mob/living/user, obj/item/I)
	if(power >= 20)
		to_chat(user, "<span class='notice'>You can't repair [src] while it is running at above 20% power.</span>")
		return FALSE
	if(vessel_integrity > 0.5 * initial(vessel_integrity))
		to_chat(user, "<span class='notice'>[src] is free from cracks. Further repairs must be carried out with flexi-seal sealant.</span>")
		return FALSE
	if(I.use_tool(src, user, 0, volume=40))
		if(vessel_integrity > 0.5 * initial(vessel_integrity))
			to_chat(user, "<span class='notice'>[src] is free from cracks. Further repairs must be carried out with flexi-seal sealant.</span>")
			return FALSE
		vessel_integrity += 20
		to_chat(user, "<span class='notice'>You weld together some of [src]'s cracks. This'll do for now.</span>")
	return TRUE

/obj/machinery/atmospherics/components/trinary/nuclear_reactor/proc/crossed_over(atom/movable/AM)
	if(isliving(AM) && temperature > 0)
		var/mob/living/L = AM
		L.adjust_bodytemperature(clamp(temperature, BODYTEMP_COOLING_MAX, BODYTEMP_HEATING_MAX)) //If you're on fire, you heat up!

/obj/machinery/atmospherics/components/trinary/nuclear_reactor/process()
	update_parents() //Update the pipenet to register new gas mixes
	//Let's get our gasses sorted out.
	var/datum/gas_mixture/coolant_input = COOLANT_INPUT_GATE
	var/datum/gas_mixture/fuel_input = MODERATOR_INPUT_GATE
	var/datum/gas_mixture/coolant_output = COOLANT_OUTPUT_GATE
	has_fuel = fuel_input.total_moles >= RBMK_BASE_FUEL_CONSUMPTION

	if(has_fuel && coolant_input.total_moles < RBMK_MINIMUM_COOLANT_CONSUMPTION)
		no_coolant_ticks++
		if(no_coolant_ticks > RBMK_NO_COOLANT_TOLERANCE)
			temperature += temperature / 100 //This isn't really harmful early game, but when your reactor is up to full power, this can get out of hand quite quickly.
			vessel_integrity -= temperature / 200 //Think fast chucklenuts!
			take_damage(10) //Just for the sound effect, to let you know you've fucked up.
			color = COLOR_RED
			investigate_log("Reactor taking damage from the lack of coolant", INVESTIGATE_ENGINE)

	else
		//Firstly, process coolant.
		last_coolant_temperature = coolant_input.temperature
		//Important thing to remember, once you slot in the fuel rods, this thing will not stop making heat, at least, not unless you can live to be thousands of years old which is when the spent fuel finally depletes fully.
		var/heat_delta = (coolant_input.temperature - temperature) / 200 //Take in the gas as a cooled input, cool the reactor a bit.
		last_heat_delta = heat_delta
		if(coolant_input.temperature < temperature)
			heat_delta = -heat_delta / 5 // This cools down slower than it heats up. Careful!
		temperature += heat_delta

		coolant_output.merge(coolant_input) //And now, shove the input into the output.
		for (var/gas in coolant_input.gas) //Clear out anything left in the input gate.
			coolant_input.gas -= gas
		AIR_UPDATE_VALUES(coolant_input)

		color = null
		no_coolant_ticks = max(0, no_coolant_ticks-2)	//Needs half as much time to recover the ticks than to acquire them

	//Now, heat up the output and set our pressure.
	coolant_output.temperature += temperature / 10 //Heat the coolant output gas that we just had pass through us.
	last_output_temperature = coolant_output.temperature
	pressure = coolant_output.returnPressure()
	// -T0C to stop free power and heat.
	power = round((OFFSET_TEMPERATURE / (RBMK_TEMPERATURE_CRITICAL - 70)) * 100, 1.01)
	var/radioactivity_spice_multiplier = 1 //Some gasses make the reactor a bit spicy.

	// The total moles being used.
	var/actual_fuel_moles = 0
	var/base_power_production = 0

	//Next up, handle fuel!
	if(has_fuel)
		// The actual fuels to mols being used.
		var/actual_fuels = list()
		// The base power production decided by the fuels.
		var/potential_fuel_moles = 0

		// Find the fuels
		for(var/gas in fuel_input.gas)
			if(xgm_gas_data.radioactivity[gas])
				actual_fuels[gas] = fuel_input.gas[gas]
				potential_fuel_moles += fuel_input.gas[gas]

		// Process the fuels
		for(var/gas in actual_fuels)
			var/percentage = actual_fuels[gas] / potential_fuel_moles
			var/moles_to_process = max(RBMK_BASE_FUEL_CONSUMPTION, RBMK_BASE_FUEL_CONSUMPTION * (fuel_input.temperature / T20C)) * percentage
			actual_fuels[gas] = moles_to_process
			actual_fuel_moles += moles_to_process
			radioactivity_spice_multiplier += (moles_to_process / RBMK_BASE_FUEL_CONSUMPTION) * xgm_gas_data.radioactivity[gas] // Nudge the angery
			base_power_production += xgm_gas_data.radioactivity[gas] * moles_to_process // The more spicy, the better-er

		// Process power
		if(actual_fuel_moles >= (RBMK_BASE_FUEL_CONSUMPTION - 0.01)) //You need fuel to do anything. (-0.01 to deal with floating point issues)
			start_up() // Make the funny noise.


			// Shove out xenon into the air when it's fuelled. You need to filter this off, or you're gonna have a bad time.
			coolant_output.adjustGas(GAS_XENON, actual_fuel_moles / 50)

			if(power > 20)
				last_power_produced = base_power_production
				// Power is based on temp, so hotter reactor means it produces more power.
				last_power_produced *= power / 100
				// Finally, we turn it into actual usable numbers.
				last_power_produced *= RBMK_POWER_SANIFIER

				add_avail(last_power_produced)
			else
				last_power_produced = 0
		else
			last_power_produced = 0

		// Take the fuel used from the input gases.
		for (var/gas in actual_fuels)
			fuel_input.gas[gas] -= actual_fuels[gas]

		AIR_UPDATE_VALUES(fuel_input)
		rate_of_reaction += actual_fuel_moles / 1000

	else //Reactor must be fuelled and ready to go before we can heat it up boys.
		rate_of_reaction = 0
		last_power_produced = 0

	//Firstly, find the difference between the two numbers.
	var/difference = abs(rate_of_reaction - desired_k)

	if(rate_of_reaction != desired_k)
		if(desired_k > rate_of_reaction)
			rate_of_reaction += difference
		else if(desired_k < rate_of_reaction)
			rate_of_reaction -= difference

	rate_of_reaction = clamp(rate_of_reaction, 0, 3)

	if(has_fuel)
		if(base_power_production && OFFSET_TEMPERATURE < (base_power_production * 5.75)) // The reactor caps out at just over the threshold for power for plasma.
			temperature += rate_of_reaction * 6
		else
			temperature -= 3 // Make sure the reactor doesn't somehow creep beyond it's intended number for too long.
	else
		temperature -= 15 //Nothing to heat us up, so.

	temperature = max(temperature, 70)

	handle_alerts() //Let's check if they're about to die, and let them know.
	update_icon()
	radiation_pulse(
		src,
		clamp(log(radioactivity_spice_multiplier) * (temperature / 100), 2, 20), // clamped and logged to ensure radiation doesn't go entirely batshit
		RAD_MEDIUM_INSULATION,
		temperature * radioactivity_spice_multiplier,
		clamp((100 SECONDS) - log(radioactivity_spice_multiplier) * (temperature / 100), 0, 100 SECONDS), // Fuck you and your uninsulated clothing. The minus is intentional, otherwise the more radioactive, the longer you have.
	)

	if(power >= 93 && world.time >= next_flicker) //You're overloading the reactor. Give a more subtle warning that power is getting out of control.
		next_flicker = world.time + 30 SECONDS
		for(var/obj/machinery/light/found_light in GLOB.machines)
			if(prob(25) && is_station_level(found_light.z))
				found_light.flicker()

		investigate_log("Reactor overloading at [power]% power", INVESTIGATE_ENGINE)

	for(var/atom/movable/found_atom in get_turf(src))
		if(isliving(found_atom))
			var/mob/living/L = found_atom
			if(temperature > RBMK_TEMPERATURE_OPERATING)
				L.adjust_fire_stacks(2)

/obj/machinery/atmospherics/components/trinary/nuclear_reactor/proc/relay(var/sound, var/message) //Sends a sound and/or text message to the crew of a ship
	for(var/mob/found_mob in GLOB.player_list)
		var/turf/found_turf // Hacky shortcut incoming
		// If not on the station, or can't hear, or there's no turf to check the mob's air with, or if there's not enough pressure for sound (sim/unsim turf)
		if(!is_station_level(found_mob.z) || !found_mob.can_hear() || !(found_turf = get_turf(found_mob)) || !(found_turf.simulated ? found_turf.zone?.air.returnPressure() : found_turf.air?.returnPressure()) > SOUND_MINIMUM_PRESSURE)
			found_mob.stop_sound_channel(CHANNEL_REACTOR_ALERT) // Shut.
			return

		if(sound)
			SEND_SOUND(found_mob, sound(sound, repeat = TRUE, wait = 0, volume = 70, channel = CHANNEL_REACTOR_ALERT))

		if(message)
			to_chat(found_mob, message)

/obj/machinery/atmospherics/components/trinary/nuclear_reactor/proc/stop_relay() //Stops all playing sounds for crewmen for the reactor channel.
	for(var/mob/found_mob in GLOB.player_list)
		found_mob.stop_sound_channel(CHANNEL_REACTOR_ALERT) // No z check cause there's no garuantee everyone is on a station Z.

//Method to handle sound effects, reactor warnings, all that jazz.
/obj/machinery/atmospherics/components/trinary/nuclear_reactor/proc/handle_alerts()
	var/alert = FALSE //If we have an alert condition, we'd best let people know.
	if(rate_of_reaction <= 0 && temperature <= T20C) // Too cold and no fuel, get lost.
		shut_down()
	//First alert condition: Overheat
	if(temperature >= RBMK_TEMPERATURE_CRITICAL)
		alert = TRUE
		investigate_log("Reactor reaching critical temperature at [temperature] k with desired criticality at [desired_k]", INVESTIGATE_ENGINE)
		message_admins("Reactor reaching critical temperature at [ADMIN_VERBOSEJMP(src)]")
		if(temperature >= RBMK_TEMPERATURE_MELTDOWN)
			var/temp_damage = min(temperature/100, initial(vessel_integrity)/40)	//40 seconds to meltdown from full integrity, worst-case. Bit less than blowout since it's harder to spike heat that much.
			vessel_integrity -= temp_damage
			if(vessel_integrity <= temp_damage)
				investigate_log("Reactor melted down at [temperature] k with desired criticality at [desired_k]", INVESTIGATE_ENGINE)
				meltdown() //Oops! All meltdown
				return
	else
		alert = FALSE

	if(temperature < 70)
		color = COLOR_CYAN
	else
		color = null

	//Second alert condition: Overpressurized (the more lethal one)
	if(pressure >= RBMK_PRESSURE_CRITICAL)
		alert = TRUE
		investigate_log("Reactor reaching critical pressure at [pressure] kpa with desired criticality at [desired_k]", INVESTIGATE_ENGINE)
		message_admins("Reactor reaching critical pressure at [ADMIN_VERBOSEJMP(src)]")
		shake_animation(0.5)
		playsound(loc, 'sound/machines/clockcult/steam_whoosh.ogg', 100, TRUE)
		var/turf/my_turf = get_turf(src)
		my_turf.atmos_spawn_air(GAS_STEAM, pressure / 100, temperature)
		var/pressure_damage = min(pressure / 100, initial(vessel_integrity) / 45)	//You get 45 seconds (if you had full integrity), worst-case. But hey, at least it can't be instantly nuked with a pipe-fire.. though it's still very difficult to save.
		vessel_integrity -= pressure_damage
		if(vessel_integrity <= pressure_damage) //It wouldn't
			investigate_log("Reactor blowout at [pressure] kpa with desired criticality at [desired_k]", INVESTIGATE_ENGINE)
			blowout()
			return

	if(warning)
		if(!alert) //Congrats! You stopped the meltdown / blowout.
			stop_relay()
			warning = FALSE
			light_color = LIGHT_COLOR_CYAN
			set_light(10)

	else
		if(!alert)
			return
		if(world.time < next_warning)
			return
		next_warning = world.time + 30 SECONDS //To avoid engis pissing people off when reaaaally trying to stop the meltdown or whatever.
		warning = TRUE //Start warning the crew of the imminent danger.
		relay('sound/machines/rbmk/alarm.ogg')
		light_color = COLOR_RED
		set_light(10)

//Failure condition 1: Meltdown. Achieved by having heat go over tolerances. This is less devastating because it's easier to achieve.
//Results: Engineering becomes unusable and your engine irreparable
/obj/machinery/atmospherics/components/trinary/nuclear_reactor/proc/meltdown()
	set waitfor = FALSE
	SSairmachines.atmos_machinery -= src //Annd we're now just a useless brick.
	slagged = TRUE
	color = null
	update_icon()
	STOP_PROCESSING(SSmachines, src)
	icon_state = "reactor_slagged"
	AddComponent(/datum/component/radioactive, 15000 , src, 0)
	var/obj/effect/landmark/nuclear_waste_spawner/NSW = new /obj/effect/landmark/nuclear_waste_spawner/strong(get_turf(src))
	relay('sound/machines/rbmk/meltdown.ogg', "<span class='userdanger'>You hear a horrible metallic hissing.</span>")
	stop_relay()
	NSW.fire() //This will take out engineering for a decent amount of time as they have to clean up the sludge.
	for(var/obj/machinery/power/apc/apc in GLOB.apcs_list)
		if(is_station_level(apc.z) && prob(70))
			apc.overload_lighting()
	var/datum/gas_mixture/coolant_input = COOLANT_INPUT_GATE
	var/datum/gas_mixture/fuel_input = MODERATOR_INPUT_GATE
	var/datum/gas_mixture/coolant_output = COOLANT_OUTPUT_GATE
	var/turf/my_turf = get_turf(src)
	coolant_input.temperature = temperature * 2 // I'm not sure if I like these magic x2s. We'll see. - Rimi
	fuel_input.temperature = temperature * 2
	coolant_output.temperature = temperature * 2
	AIR_UPDATE_VALUES(coolant_input)
	AIR_UPDATE_VALUES(fuel_input)
	AIR_UPDATE_VALUES(coolant_output)
	my_turf.assume_air(coolant_input)
	my_turf.assume_air(fuel_input)
	my_turf.assume_air(coolant_output)
	explosion(get_turf(src), 0, 5, 10, 20, TRUE, TRUE)
	empulse(get_turf(src), 25, 15)
	QDEL_NULL(soundloop)

//Failure condition 2: Blowout. Achieved by reactor going over-pressured. This is a round-ender because it requires more fuckery to achieve.
/obj/machinery/atmospherics/components/trinary/nuclear_reactor/proc/blowout()
	var/turf/my_turf = get_turf(src)
	var/datum/gas_mixture/oh_shit_mix = new /datum/gas_mixture(_temperature = temperature)
	var/datum/gas_mixture/fuel = MODERATOR_INPUT_GATE

	var/oh_shit_amount = 0
	for(var/gas in fuel.gas)
		oh_shit_amount += xgm_gas_data.molar_mass[gas] * fuel.gas[gas] // The more spicy, the worse-er

	oh_shit_mix.adjustGas(GAS_RADON, oh_shit_amount * 19, TRUE) // Does this break the laws of mass? Yes. Do I care? Not really, you guys should be fucking off on the emergency shuttle in 10 minutes.
	my_turf.assume_air(oh_shit_mix)

	explosion(get_turf(src), zas_settings.maxex_devastation_range, zas_settings.maxex_heavy_range, zas_settings.maxex_light_range, zas_settings.maxex_fire_range, zas_settings.maxex_flash_range, TRUE, smoke = TRUE)
	meltdown() //Double kill.
	power = 0

	// SSweather.run_weather("nuclear fallout")
	for(var/X in GLOB.landmarks_list)
		if(istype(X, /obj/effect/landmark/nuclear_waste_spawner))
			var/obj/effect/landmark/nuclear_waste_spawner/WS = X
			WS.fire() //Begin the SLUDGING

/obj/machinery/atmospherics/components/trinary/nuclear_reactor/update_icon()
	. = ..()
	icon_state = "reactor_off"
	switch(temperature)
		if(0 to 200)
			icon_state = "reactor_on"
		if(200 to RBMK_TEMPERATURE_OPERATING)
			icon_state = "reactor_hot"
		if(RBMK_TEMPERATURE_OPERATING to RBMK_TEMPERATURE_HOT)
			icon_state = "reactor_veryhot"
		if(RBMK_TEMPERATURE_HOT to RBMK_TEMPERATURE_CRITICAL) //Point of no return.
			icon_state = "reactor_overheat"
		if(RBMK_TEMPERATURE_CRITICAL to INFINITY)
			icon_state = "reactor_meltdown"
	if(!has_fuel)
		icon_state = "reactor_off"
	if(slagged)
		icon_state = "reactor_slagged"


//Startup, shutdown
/obj/machinery/atmospherics/components/trinary/nuclear_reactor/proc/start_up()
	if(started)
		return
	started = TRUE
	desired_k = 1
	set_light(10)
	var/startup_sound = pick('sound/machines/rbmk/startup.ogg', 'sound/machines/rbmk/startup2.ogg')
	playsound(loc, startup_sound, 100)
	if(!soundloop)
		soundloop = new(src)
	soundloop.start()
	if(!powernet)
		message_admins("No powernet for the Nuclear Reactor! Trying to add.")
		connect_to_network()
		if(!powernet)
			message_admins("Powernet add fail. This reactor will never produce power.")

//Shuts off the fuel rods, ambience, etc. Keep in mind that your temperature may still go up!
/obj/machinery/atmospherics/components/trinary/nuclear_reactor/proc/shut_down()
	if(!started)
		return
	started = FALSE
	set_light(0)
	rate_of_reaction = 0
	desired_k = 0
	temperature = 0
	update_icon()
	soundloop?.stop()

//Preset pumps for mappers. You can also set the id tags yourself.
/obj/machinery/atmospherics/components/binary/pump/rbmk_input
	id = "rbmk_input"
	frequency = FREQ_RBMK_CONTROL

/obj/machinery/atmospherics/components/binary/pump/rbmk_output
	id = "rbmk_output"
	frequency = FREQ_RBMK_CONTROL

/obj/machinery/atmospherics/components/binary/pump/rbmk_moderator
	id = "rbmk_moderator"
	frequency = FREQ_RBMK_CONTROL

//Procs shamelessly taken from machinery/power
/obj/machinery/atmospherics/components/trinary/nuclear_reactor/proc/connect_to_network()
	var/turf/my_turf = src.loc
	if(!my_turf || !istype(my_turf))
		return FALSE

	var/obj/structure/cable/found_cable = my_turf.get_cable_node() //check if we have a node cable on the machine turf, the first found is picked
	if(!found_cable || !found_cable.powernet)
		return FALSE

	found_cable.powernet.add_machine(src)
	return TRUE

/obj/machinery/atmospherics/components/trinary/nuclear_reactor/proc/disconnect_from_network()
	if(!powernet)
		return FALSE
	powernet.remove_machine(src)
	return TRUE

/obj/machinery/atmospherics/components/trinary/nuclear_reactor/proc/add_avail(amount)
	if(powernet)
		powernet.newavail += amount
		return TRUE
	else
		return FALSE

/obj/machinery/atmospherics/components/trinary/nuclear_reactor/Destroy()
	. = ..()
	GLOB.rbmk_reactors -= src

#undef OFFSET_TEMPERATURE
#undef COOLANT_INPUT_GATE
#undef MODERATOR_INPUT_GATE
#undef COOLANT_OUTPUT_GATE
