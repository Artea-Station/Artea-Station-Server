//For my sanity :))
// You made a giga-file containing a bunch of unrelated content that I had to separate. It was, in fact, not for anyone's sanity. - Rimi

//Reference: Heaters go up to 500K.
//Hot plasmaburn: ~14400 k.

/// !!!ARTEA NOTE, READ THIS SHIT!!!
/*
	Okay, so this shitshow of a conversion makes the RBMK work a little in between the SM and the RBMK, to make it easy to learn, but hard to master (at least once the PA is added).

	PLASMA, AND OTHER RADIOACTIVE GASSES (just tritium for now) ARE NOW THE ONLY FUELS!

	This means stuff like oxygen just won't do anything, and at best, slow down the reactor, and at worst, cause a pipe fire, which'll likely cause a cascading issue with reaction speed.

	The hotter the fuel, the faster it burns, and the more power the reactor makes.

	The temperature itself has no direct effect on the reactor's heat output aside from the above, for balancing's sake.

	The coolant loop is the same old deal as always, and decides the reactor pressure.
*/

//Remember kids, if the reactor itself is not physically powered by an APC, it cannot shove coolant in!

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
	//Secondary variables.
	var/gas_absorption_effectiveness = 0.5
	var/gas_absorption_constant = 0.5 //We refer to this one as it's set on init, randomized.
	var/minimum_fuel_level = 2
	var/warning = FALSE //Have we begun warning the crew of their impending death?
	var/next_warning = 0 //To avoid spam.
	var/last_power_produced = 0 //For logging purposes
	var/next_flicker = 0 //Light flicker timer
	var/base_power_modifier = RBMK_POWER_FLAVOURISER
	var/slagged = FALSE //Is this reactor even usable any more?
	//Console statistics.
	var/last_coolant_temperature = 0
	var/last_output_temperature = 0
	var/last_heat_delta = 0 //For administrative cheating only. Knowing the delta lets you know EXACTLY what to set rate_of_reaction at.
	var/no_coolant_ticks = 0	//How many times in succession did we not have enough coolant? Decays twice as fast as it accumulates.
	var/last_user = null
	var/current_desired_k = null
	var/datum/looping_sound/rbmk_reactor/soundloop
	var/datum/powernet/powernet = null
	var/has_fuel
	var/started = FALSE

//Use this in your maps if you want everything to be preset.
/obj/machinery/atmospherics/components/trinary/nuclear_reactor/preset
	id = "rbmk_default"

/obj/machinery/atmospherics/components/trinary/nuclear_reactor/Initialize()
	. = ..()
	RegisterSignal(src, COMSIG_MOVABLE_CROSS_OVER, PROC_REF(crossed_over))
	connect_to_network()
	icon_state = "reactor_off"
	gas_absorption_effectiveness = rand(5, 6)/10 //All reactors are slightly different. This will result in you having to figure out what the balance is for rate_of_reaction.
	gas_absorption_constant = gas_absorption_effectiveness //And set this up for the rest of the round.
	GLOB.rbmk_reactors += src

/obj/machinery/atmospherics/components/trinary/nuclear_reactor/examine(mob/user)
	. = ..()
	if(Adjacent(src, user))
		if(do_after(user, 1 SECONDS, target=src))
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
		if(do_after(user, 5 SECONDS, target=src))
			if(vessel_integrity >= 350)	//They might've stacked doafters
				to_chat(user, "<span class='notice'>[src]'s seals are already in-tact, repairing them further would require a new set of seals.</span>")
				return FALSE
			playsound(src, 'sound/effects/spray2.ogg', 50, 1, -6)
			user.visible_message("<span class='warning'>[user] applies sealant to some of [src]'s worn out seals.</span>", "<span class='notice'>You apply sealant to some of [src]'s worn out seals.</span>")
			vessel_integrity += 10
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
	has_fuel = !!fuel_input.total_moles

	//Firstly, heat up the reactor based off of rate_of_reaction.
	var/input_moles = coolant_input.total_moles //Firstly. Do we have enough moles of coolant?
	if(input_moles >= minimum_fuel_level)
		start_up()
		last_coolant_temperature = coolant_input.temperature
		//Important thing to remember, once you slot in the fuel rods, this thing will not stop making heat, at least, not unless you can live to be thousands of years old which is when the spent fuel finally depletes fully.
		var/heat_delta = (coolant_input.temperature / 100) * gas_absorption_effectiveness //Take in the gas as a cooled input, cool the reactor a bit. The optimum, 100% balanced reaction sits at rate_of_reaction=1, coolant input temp of 200K / -73 celsius.
		last_heat_delta = heat_delta
		temperature += heat_delta
		coolant_output.merge(coolant_input) //And now, shove the input into the output.
		for (var/gas in coolant_input.gas) //Clear out anything left in the input gate.
			coolant_input.gas -= gas
		AIR_UPDATE_VALUES(coolant_input)

		color = null
		no_coolant_ticks = max(0, no_coolant_ticks-2)	//Needs half as much time to recover the ticks than to acquire them
	else
		if(has_fuel)
			no_coolant_ticks++
			if(no_coolant_ticks > RBMK_NO_COOLANT_TOLERANCE)
				temperature += temperature / 500 //This isn't really harmful early game, but when your reactor is up to full power, this can get out of hand quite quickly.
				vessel_integrity -= temperature / 200 //Think fast chucklenuts!
				take_damage(10) //Just for the sound effect, to let you know you've fucked up.
				color = COLOR_RED
				investigate_log("Reactor taking damage from the lack of coolant", INVESTIGATE_ENGINE)
	//Now, heat up the output and set our pressure.
	coolant_output.temperature = temperature //Heat the coolant output gas that we just had pass through us.
	last_output_temperature = coolant_output.temperature
	pressure = coolant_output.returnPressure()
	power = (temperature / RBMK_TEMPERATURE_CRITICAL) * 100
	var/radioactivity_spice_multiplier = 1 //Some gasses make the reactor a bit spicy.
	gas_absorption_effectiveness = gas_absorption_constant
	//Next up, handle fuel!
	if(fuel_input.total_moles >= minimum_fuel_level)
		var/total_fuel_moles = 0
		// Oh god this is horribly off
		// for(var/gas in fuel_input.gas)
		// 	if(xgm_gas_data.radioactivity[gas])
		// 		total_fuel_moles += fuel_input.gas[gas]
		// 		radioactivity_spice_multiplier += (fuel_input.gas[gas] / 2500) * xgm_gas_data.radioactivity[gas] // Nudge the angery

		var/power_modifier = max((fuel_input.gas[GAS_OXYGEN] / fuel_input.total_moles * 10), 1) //You can never have negative IPM.
		if(total_fuel_moles >= minimum_fuel_level) //You at least need SOME fuel.
			var/power_produced = max((total_fuel_moles / fuel_input.total_moles * 10), 1)
			last_power_produced = max(0,((power_produced*power_modifier)*fuel_input.total_moles))
			last_power_produced *= (power/100) //Aaaand here comes the cap. Hotter reactor => more power.
			last_power_produced *= base_power_modifier //Finally, we turn it into actual usable numbers.
			var/turf/T = get_turf(src)
			if(power >= 20)
				coolant_output.adjustGas(GAS_XENON, total_fuel_moles/50) //Shove out xenon into the air when it's fuelled. You need to filter this off, or you're gonna have a bad time.
			var/obj/structure/cable/C = T.get_cable_node()
			if(!C?.powernet)
				return
			else
				C.powernet.newavail += last_power_produced //hacky wtf
				add_avail(last_power_produced)

		// N2/CO2 helps you control the reaction at the cost of making it absolutely blast you with rads.
		var/total_control_moles = fuel_input.gas[GAS_NITROGEN] + (fuel_input.gas[GAS_CO2]*2)
		if(total_control_moles >= minimum_fuel_level)
			var/control_bonus = total_control_moles / 250 //1 mol of n2 -> 0.002 bonus control rod effectiveness, if you want a super controlled reaction, you'll have to sacrifice some power.
			control_rod_effectiveness = initial(control_rod_effectiveness) + control_bonus
			radioactivity_spice_multiplier += fuel_input.gas[GAS_NITROGEN] / 25 //An example setup of 50 moles of n2 (for dealing with spent fuel) leaves us with a radioactivity spice multiplier of 3.
			radioactivity_spice_multiplier += fuel_input.gas[GAS_CO2] / 12.5

		// Makes the reactor use more gas and spit out more gas. Good for making Xenon.
		var/total_permeability_moles = fuel_input.gas[GAS_BORON] + (fuel_input.gas[GAS_STEAM]*2)
		if(total_permeability_moles >= minimum_fuel_level)
			var/permeability_bonus = total_permeability_moles / 500
			gas_absorption_effectiveness = gas_absorption_constant + permeability_bonus

		//From this point onwards, we clear out the remaining gasses.
		for (var/gas in fuel_input.gas) //Woosh. And the soul is gone.
			fuel_input.gas -= gas
		AIR_UPDATE_VALUES(fuel_input)
		rate_of_reaction += total_fuel_moles / 1000
	var/fuel_power = 0 //So that you can't magically generate rate_of_reaction with your control rods.
	if(!has_fuel)  //Reactor must be fuelled and ready to go before we can heat it up boys.
		rate_of_reaction = 0
	//Firstly, find the difference between the two numbers.
	var/difference = abs(rate_of_reaction - desired_k)
	//Then, hit as much of that goal with our cooling per tick as we possibly can.
	difference = clamp(difference, 0, control_rod_effectiveness) //And we can't instantly zap the rate_of_reaction to what we want, so let's zap as much of it as we can manage....
	if(difference > fuel_power && desired_k > rate_of_reaction)
		message_admins("Not enough fuel to get [difference]. We have fuel [fuel_power]")
		investigate_log("Reactor has not enough fuel to get [difference]. We have fuel [fuel_power]", INVESTIGATE_ENGINE)
		difference = fuel_power //Again, to stop you being able to run off of 1 fuel rod.
	if(rate_of_reaction != desired_k)
		if(desired_k > rate_of_reaction)
			rate_of_reaction += difference
		else if(desired_k < rate_of_reaction)
			rate_of_reaction -= difference
	if(rate_of_reaction == desired_k && last_user && current_desired_k != desired_k)
		current_desired_k = desired_k
		message_admins("Reactor desired criticality set to [desired_k] by [ADMIN_LOOKUPFLW(last_user)] in [ADMIN_VERBOSEJMP(src)]")
		investigate_log("reactor desired criticality set to [desired_k] by [key_name(last_user)] at [AREACOORD(src)]", INVESTIGATE_ENGINE)

	rate_of_reaction = clamp(rate_of_reaction, 0, RBMK_MAX_CRITICALITY)
	if(has_fuel)
		temperature += rate_of_reaction
	else
		temperature -= 10 //Nothing to heat us up, so.
	handle_alerts() //Let's check if they're about to die, and let them know.
	update_icon()
	radiation_pulse(src, temperature*radioactivity_spice_multiplier)
	if(power >= 93 && world.time >= next_flicker) //You're overloading the reactor. Give a more subtle warning that power is getting out of control.
		next_flicker = world.time + 2 MINUTES
		for(var/obj/machinery/light/L in GLOB.machines)
			if(prob(25) && L.z == z) //If youre running the reactor cold though, no need to flicker the lights.
				L.flicker()
		investigate_log("Reactor overloading at [power]% power", INVESTIGATE_ENGINE)
	for(var/atom/movable/I in get_turf(src))
		if(isliving(I))
			var/mob/living/L = I
			if(temperature > 0)
				L.adjust_bodytemperature(clamp(temperature, BODYTEMP_COOLING_MAX, BODYTEMP_HEATING_MAX)) //If you're on fire, you heat up!
		if(istype(I, /obj/item/food))
			playsound(src, pick('sound/machines/fryer/deep_fryer_1.ogg', 'sound/machines/fryer/deep_fryer_2.ogg'), 100, TRUE)
			var/obj/item/food/grilled_item = I
			if(prob(80))
				return //To give the illusion that it's actually cooking omegalul.
			switch(power)
				if(20 to 39)
					grilled_item.name = "grilled [initial(grilled_item.name)]"
					grilled_item.desc = "[initial(I.desc)] It's been grilled over a nuclear reactor."
					if(!(grilled_item.foodtypes & FRIED))
						grilled_item.foodtypes |= FRIED
				if(40 to 70)
					grilled_item.name = "heavily grilled [initial(grilled_item.name)]"
					grilled_item.desc = "[initial(I.desc)] It's been heavily grilled through the magic of nuclear fission."
					if(!(grilled_item.foodtypes & FRIED))
						grilled_item.foodtypes |= FRIED
				if(70 to 95)
					grilled_item.name = "Three-Mile Nuclear-Grilled [initial(grilled_item.name)]"
					grilled_item.desc = "A [initial(grilled_item.name)]. It's been put on top of a nuclear reactor running at extreme power by some badass engineer."
					if(!(grilled_item.foodtypes & FRIED))
						grilled_item.foodtypes |= FRIED
				if(95 to INFINITY)
					grilled_item.name = "Ultimate Meltdown Grilled [initial(grilled_item.name)]"
					grilled_item.desc = "A [initial(grilled_item.name)]. A grill this perfect is a rare technique only known by a few engineers who know how to perform a 'controlled' meltdown whilst also having the time to throw food on a reactor. I'll bet it tastes amazing."
					if(!(grilled_item.foodtypes & FRIED))
						grilled_item.foodtypes |= FRIED

/obj/machinery/atmospherics/components/trinary/nuclear_reactor/proc/relay(var/sound, var/message=null, loop = FALSE, channel = null) //Sends a sound + text message to the crew of a ship
	for(var/mob/M in GLOB.player_list)
		if(M.z == z)
			if(!isinspace(M))
				if(sound)
					if(channel) //Doing this forbids overlapping of sounds
						SEND_SOUND(M, sound(sound, repeat = loop, wait = 0, volume = 70, channel = channel))
					else
						SEND_SOUND(M, sound(sound, repeat = loop, wait = 0, volume = 70))
				if(message)
					to_chat(M, message)

/obj/machinery/atmospherics/components/trinary/nuclear_reactor/proc/stop_relay(channel) //Stops all playing sounds for crewmen on N channel.
	for(var/mob/M in GLOB.player_list)
		if(M.z == z)
			M.stop_sound_channel(channel)

//Method to handle sound effects, reactor warnings, all that jazz.
/obj/machinery/atmospherics/components/trinary/nuclear_reactor/proc/handle_alerts()
	var/alert = FALSE //If we have an alert condition, we'd best let people know.
	if(rate_of_reaction <= 0 && temperature <= 0)
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
	if(temperature < -200) //That's as cold as I'm letting you get it, engineering.
		color = COLOR_CYAN
		temperature = -200
	else
		color = null
	//Second alert condition: Overpressurized (the more lethal one)
	if(pressure >= RBMK_PRESSURE_CRITICAL)
		alert = TRUE
		investigate_log("Reactor reaching critical pressure at [pressure] kpa with desired criticality at [desired_k]", INVESTIGATE_ENGINE)
		message_admins("Reactor reaching critical pressure at [ADMIN_VERBOSEJMP(src)]")
		shake_animation(0.5)
		playsound(loc, 'sound/machines/clockcult/steam_whoosh.ogg', 100, TRUE)
		var/turf/T = get_turf(src)
		T.atmos_spawn_air("water_vapor=[pressure/100];TEMP=[temperature]")
		var/pressure_damage = min(pressure/100, initial(vessel_integrity)/45)	//You get 45 seconds (if you had full integrity), worst-case. But hey, at least it can't be instantly nuked with a pipe-fire.. though it's still very difficult to save.
		vessel_integrity -= pressure_damage
		if(vessel_integrity <= pressure_damage) //It wouldn't
			investigate_log("Reactor blowout at [pressure] kpa with desired criticality at [desired_k]", INVESTIGATE_ENGINE)
			blowout()
			return
	if(warning)
		if(!alert) //Congrats! You stopped the meltdown / blowout.
			stop_relay(CHANNEL_REACTOR_ALERT)
			warning = FALSE
			set_light(0)
			light_color = LIGHT_COLOR_CYAN
			set_light(10)
	else
		if(!alert)
			return
		if(world.time < next_warning)
			return
		next_warning = world.time + 30 SECONDS //To avoid engis pissing people off when reaaaally trying to stop the meltdown or whatever.
		warning = TRUE //Start warning the crew of the imminent danger.
		relay('sound/machines/rbmk/alarm.ogg', null, loop=TRUE, channel = CHANNEL_REACTOR_ALERT)
		set_light(0)
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
	stop_relay(CHANNEL_REACTOR_ALERT)
	NSW.fire() //This will take out engineering for a decent amount of time as they have to clean up the sludge.
	for(var/obj/machinery/power/apc/apc in GLOB.apcs_list)
		if(is_station_level(apc.z) && prob(70))
			apc.overload_lighting()
	var/datum/gas_mixture/coolant_input = COOLANT_INPUT_GATE
	var/datum/gas_mixture/fuel_input = MODERATOR_INPUT_GATE
	var/datum/gas_mixture/coolant_output = COOLANT_OUTPUT_GATE
	var/turf/T = get_turf(src)
	coolant_input.temperature = temperature * 2 // I'm not sure if I like these magic x2s. We'll see. - Rimi
	fuel_input.temperature = temperature * 2
	coolant_output.temperature = temperature * 2
	AIR_UPDATE_VALUES(coolant_input)
	AIR_UPDATE_VALUES(fuel_input)
	AIR_UPDATE_VALUES(coolant_output)
	T.assume_air(coolant_input)
	T.assume_air(fuel_input)
	T.assume_air(coolant_output)
	power = 0 //we set it to zero so the reactor can be serviced and repaired.
	explosion(get_turf(src), 0, 5, 10, 20, TRUE, TRUE)
	empulse(get_turf(src), 25, 15)
	QDEL_NULL(soundloop)

//Failure condition 2: Blowout. Achieved by reactor going over-pressured. This is a round-ender because it requires more fuckery to achieve.
/obj/machinery/atmospherics/components/trinary/nuclear_reactor/proc/blowout()
	// explosion(get_turf(src), GLOB.MAX_EX_DEVESTATION_RANGE, GLOB.MAX_EX_HEAVY_RANGE, GLOB.MAX_EX_LIGHT_RANGE, GLOB.MAX_EX_FLASH_RANGE)
	meltdown() //Double kill.
	power = 0 //we set it to zero so the reactor can be serviced and repaired.
	// SSweather.run_weather("nuclear fallout")
	for(var/X in GLOB.landmarks_list)
		if(istype(X, /obj/effect/landmark/nuclear_waste_spawner))
			var/obj/effect/landmark/nuclear_waste_spawner/WS = X
			if(is_station_level(WS.z)) //Begin the SLUDGING
				WS.fire()

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
	soundloop = new(src, TRUE)
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
	QDEL_NULL(soundloop)

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
	var/turf/T = src.loc
	if(!T || !istype(T))
		return FALSE

	var/obj/structure/cable/C = T.get_cable_node() //check if we have a node cable on the machine turf, the first found is picked
	if(!C || !C.powernet)
		return FALSE

	C.powernet.add_machine(src)
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
