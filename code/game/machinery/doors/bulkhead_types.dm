/*
	Station Bulkheads Regular
*/

/obj/machinery/door/bulkhead/command
	assemblytype = /obj/structure/door_assembly/door_assembly_com
	normal_integrity = 450
	bulkhead_paint = "#334E6D"
	stripe_paint = "#43769D"

/obj/machinery/door/bulkhead/command/chief_engineer
	assemblytype = /obj/structure/door_assembly/door_assembly_com/ce
	normal_integrity = 450
	bulkhead_paint = "#F6F6F6"
	stripe_paint = "#BB8425"

/obj/machinery/door/bulkhead/command/head_of_security
	assemblytype = /obj/structure/door_assembly/door_assembly_com/hos
	normal_integrity = 450
	bulkhead_paint = "#F6F6F6"
	stripe_paint = "#912e25"

/obj/machinery/door/bulkhead/security
	assemblytype = /obj/structure/door_assembly/door_assembly_sec
	normal_integrity = 450
	bulkhead_paint = "#912e25"
	stripe_paint = "#1E2425"

/obj/machinery/door/bulkhead/engineering
	assemblytype = /obj/structure/door_assembly/door_assembly_eng
	bulkhead_paint = "#BB8425"
	stripe_paint = "#1E2425"

/obj/machinery/door/bulkhead/medical
	assemblytype = /obj/structure/door_assembly/door_assembly_med
	bulkhead_paint = "#BBBBBB"
	stripe_paint = "#5995BA"

/obj/machinery/door/bulkhead/medical/shuttle
	assemblytype = /obj/structure/door_assembly/door_assembly_medical_shuttle
	stripe_paint = "#575577"

/obj/machinery/door/bulkhead/hydroponics	//Hydroponics front doors!
	assemblytype = /obj/structure/door_assembly/door_assembly_hydro
	bulkhead_paint = "#559958"
	stripe_paint = "#0650A4"

/obj/machinery/door/bulkhead/maintenance
	name = "maintenance access"
	assemblytype = /obj/structure/door_assembly/door_assembly_mai
	normal_integrity = 250
	stripe_paint = "#B69F3C"
	doorOpen = 'sound/machines/door/airlock_open_maint.ogg'
	doorClose = 'sound/machines/door/airlock_close_maint.ogg'

/obj/machinery/door/bulkhead/maintenance/external
	name = "external bulkhead access"
	assemblytype = /obj/structure/door_assembly/door_assembly_extmai
	stripe_paint = "#9F2828"
	doorOpen = 'sound/machines/door/airlock_open_space.ogg'
	doorClose = 'sound/machines/door/airlock_close_space.ogg'

/obj/machinery/door/bulkhead/mining
	name = "mining bulkhead"
	assemblytype = /obj/structure/door_assembly/door_assembly_min
	bulkhead_paint = "#967032"
	stripe_paint = "#5F350B"

/obj/machinery/door/bulkhead/atmos
	name = "atmospherics bulkhead"
	assemblytype = /obj/structure/door_assembly/door_assembly_atmo
	bulkhead_paint = "#A28226"
	stripe_paint = "#469085"

/obj/machinery/door/bulkhead/research
	assemblytype = /obj/structure/door_assembly/door_assembly_research
	bulkhead_paint = "#BBBBBB"
	stripe_paint = "#563758"

/obj/machinery/door/bulkhead/freezer
	name = "freezer bulkhead"
	assemblytype = /obj/structure/door_assembly/door_assembly_fre
	bulkhead_paint = "#BBBBBB"

/obj/machinery/door/bulkhead/science
	assemblytype = /obj/structure/door_assembly/door_assembly_science
	bulkhead_paint = "#BBBBBB"
	stripe_paint = "#6633CC"

/obj/machinery/door/bulkhead/virology
	assemblytype = /obj/structure/door_assembly/door_assembly_viro
	bulkhead_paint = "#BBBBBB"
	stripe_paint = "#2a7a25"

/obj/machinery/door/bulkhead/pathfinders
	assemblytype = /obj/structure/door_assembly/door_assembly_pathfinders
	bulkhead_paint = "#847A96"
	stripe_paint = "#575577"

//////////////////////////////////
/*
	Station Bulkheads Glass
*/

/obj/machinery/door/bulkhead/glass
	opacity = FALSE
	glass = TRUE

/obj/machinery/door/bulkhead/glass/incinerator
	autoclose = FALSE
	frequency = FREQ_AIRLOCK_CONTROL
	heat_proof = TRUE
	req_access = list(ACCESS_SYNDICATE)

/obj/machinery/door/bulkhead/glass/incinerator/syndicatelava_interior
	name = "Turbine Interior Bulkhead"
	id_tag = INCINERATOR_SYNDICATELAVA_AIRLOCK_INTERIOR

/obj/machinery/door/bulkhead/glass/incinerator/syndicatelava_exterior
	name = "Turbine Exterior Bulkhead"
	id_tag = INCINERATOR_SYNDICATELAVA_AIRLOCK_EXTERIOR

/obj/machinery/door/bulkhead/command/glass
	opacity = FALSE
	glass = TRUE
	normal_integrity = 400

/obj/machinery/door/bulkhead/command/chief_engineer/glass
	opacity = FALSE
	glass = TRUE
	normal_integrity = 400

/obj/machinery/door/bulkhead/command/head_of_security/glass
	opacity = FALSE
	glass = TRUE
	normal_integrity = 400

/obj/machinery/door/bulkhead/engineering/glass
	opacity = FALSE
	glass = TRUE

/obj/machinery/door/bulkhead/engineering/glass/critical
	critical_machine = TRUE //stops greytide virus from opening & bolting doors in critical positions, such as the SM chamber.

/obj/machinery/door/bulkhead/security/glass
	opacity = FALSE
	glass = TRUE
	normal_integrity = 400

/obj/machinery/door/bulkhead/medical/glass
	opacity = FALSE
	glass = TRUE

/obj/machinery/door/bulkhead/medical/shuttle/glass
	opacity = FALSE
	glass = TRUE

/obj/machinery/door/bulkhead/hydroponics/glass //Uses same icon as medical/glass, maybe update it with its own unique icon one day?
	opacity = FALSE
	glass = TRUE

/obj/machinery/door/bulkhead/research/glass
	opacity = FALSE
	glass = TRUE

/obj/machinery/door/bulkhead/research/glass/incinerator
	autoclose = FALSE
	frequency = FREQ_AIRLOCK_CONTROL
	heat_proof = TRUE

/obj/machinery/door/bulkhead/research/glass/incinerator/ordmix_interior
	name = "Mixing Room Interior Bulkhead"
	id_tag = INCINERATOR_ORDMIX_AIRLOCK_INTERIOR

/obj/machinery/door/bulkhead/research/glass/incinerator/ordmix_exterior
	name = "Mixing Room Exterior Bulkhead"
	id_tag = INCINERATOR_ORDMIX_AIRLOCK_EXTERIOR

/obj/machinery/door/bulkhead/mining/glass
	opacity = FALSE
	glass = TRUE

/obj/machinery/door/bulkhead/atmos/glass
	opacity = FALSE
	glass = TRUE

/obj/machinery/door/bulkhead/atmos/glass/critical
	critical_machine = TRUE //stops greytide virus from opening & bolting doors in critical positions, such as the SM chamber.

/obj/machinery/door/bulkhead/science/glass
	opacity = FALSE
	glass = TRUE

/obj/machinery/door/bulkhead/virology/glass
	opacity = FALSE
	glass = TRUE

/obj/machinery/door/bulkhead/maintenance/glass
	opacity = FALSE
	glass = TRUE

/obj/machinery/door/bulkhead/maintenance/external/glass
	opacity = FALSE
	glass = TRUE
	normal_integrity = 200

/obj/machinery/door/bulkhead/pathfinders/glass
	opacity = FALSE
	glass = TRUE

//////////////////////////////////
/*
	Station Bulkheads Mineral
*/

/obj/machinery/door/bulkhead/gold
	name = "gold bulkhead"
	assemblytype = /obj/structure/door_assembly/door_assembly_gold
	bulkhead_paint = "#9F891F"

/obj/machinery/door/bulkhead/gold/glass
	opacity = FALSE
	glass = TRUE

/obj/machinery/door/bulkhead/silver
	name = "silver bulkhead"
	assemblytype = /obj/structure/door_assembly/door_assembly_silver
	bulkhead_paint = "#C9C9C9"

/obj/machinery/door/bulkhead/silver/glass
	opacity = FALSE
	glass = TRUE

/obj/machinery/door/bulkhead/diamond
	name = "diamond bulkhead"
	assemblytype = /obj/structure/door_assembly/door_assembly_diamond
	normal_integrity = 1000
	explosion_block = 2
	bulkhead_paint = "#4AB4B4"

/obj/machinery/door/bulkhead/diamond/glass
	normal_integrity = 950
	opacity = FALSE
	glass = TRUE

/obj/machinery/door/bulkhead/uranium
	name = "uranium bulkhead"
	assemblytype = /obj/structure/door_assembly/door_assembly_uranium
	bulkhead_paint = "#174207"
	var/last_event = 0
	//Is this bulkhead actually radioactive?
	var/actually_radioactive = TRUE

/obj/machinery/door/bulkhead/uranium/process()
	if(actually_radioactive && world.time > last_event+20)
		if(prob(50))
			radiate()
		last_event = world.time
	..()

/obj/machinery/door/bulkhead/uranium/proc/radiate()
	radiation_pulse(
		src,
		max_range = 2,
		threshold = RAD_LIGHT_INSULATION,
		chance = IRRADIATION_CHANCE_URANIUM,
		minimum_exposure_time = URANIUM_RADIATION_MINIMUM_EXPOSURE_TIME,
	)

/obj/machinery/door/bulkhead/uranium/glass
	opacity = FALSE
	glass = TRUE

/obj/machinery/door/bulkhead/uranium/safe
	actually_radioactive = FALSE

/obj/machinery/door/bulkhead/uranium/glass/safe
	actually_radioactive = FALSE

/obj/machinery/door/bulkhead/plasma
	name = "plasma bulkhead"
	desc = "No way this can end badly."
	assemblytype = /obj/structure/door_assembly/door_assembly_plasma
	bulkhead_paint = "#65217B"
	material_flags = MATERIAL_EFFECTS
	material_modifier = 0.25

/obj/machinery/door/bulkhead/plasma/Initialize(mapload)
	custom_materials = custom_materials ? custom_materials : list(/datum/material/plasma = 20000)
	. = ..()

/obj/machinery/door/bulkhead/plasma/block_superconductivity() //we don't stop the heat~
	return 0

/obj/machinery/door/bulkhead/plasma/glass
	opacity = FALSE
	glass = TRUE

/obj/machinery/door/bulkhead/bananium
	name = "bananium bulkhead"
	desc = "Honkhonkhonk"
	assemblytype = /obj/structure/door_assembly/door_assembly_bananium
	bulkhead_paint = "#FFFF00"
	doorOpen = 'sound/items/bikehorn.ogg'

/obj/machinery/door/bulkhead/bananium/glass
	opacity = FALSE
	glass = TRUE

/obj/machinery/door/bulkhead/sandstone
	name = "sandstone bulkhead"
	assemblytype = /obj/structure/door_assembly/door_assembly_sandstone
	bulkhead_paint = "#C09A72"

/obj/machinery/door/bulkhead/sandstone/glass
	opacity = FALSE
	glass = TRUE

/obj/machinery/door/bulkhead/wood
	name = "wooden bulkhead"
	assemblytype = /obj/structure/door_assembly/door_assembly_wood
	bulkhead_paint = "#805F44"

/obj/machinery/door/bulkhead/wood/glass
	opacity = FALSE
	glass = TRUE

/obj/machinery/door/bulkhead/titanium
	name = "shuttle bulkhead"
	assemblytype = /obj/structure/door_assembly/door_assembly_titanium
	bulkhead_paint = "#b3c0c7"
	normal_integrity = 400

/obj/machinery/door/bulkhead/titanium/glass
	normal_integrity = 350
	opacity = FALSE
	glass = TRUE

/obj/machinery/door/bulkhead/bronze
	name = "bronze bulkhead"
	assemblytype = /obj/structure/door_assembly/door_assembly_bronze
	bulkhead_paint = "#9c5f05"

/obj/machinery/door/bulkhead/bronze/seethru
	assemblytype = /obj/structure/door_assembly/door_assembly_bronze/seethru
	opacity = FALSE
	glass = TRUE
//////////////////////////////////
/*
	Station2 Bulkheads
*/

/obj/machinery/door/bulkhead/public
	icon = 'icons/obj/doors/airlocks/station2/airlock.dmi'
	glass_fill_overlays = 'icons/obj/doors/airlocks/station2/glass_overlays.dmi'
	assemblytype = /obj/structure/door_assembly/door_assembly_public

/obj/machinery/door/bulkhead/public/glass
	opacity = FALSE
	glass = TRUE

/obj/machinery/door/bulkhead/public/glass/incinerator
	autoclose = FALSE
	frequency = FREQ_AIRLOCK_CONTROL
	heat_proof = TRUE

/obj/machinery/door/bulkhead/public/glass/incinerator/atmos_interior
	name = "Turbine Interior Bulkhead"
	id_tag = INCINERATOR_ATMOS_AIRLOCK_INTERIOR

/obj/machinery/door/bulkhead/public/glass/incinerator/atmos_exterior
	name = "Turbine Exterior Bulkhead"
	id_tag = INCINERATOR_ATMOS_AIRLOCK_EXTERIOR

//////////////////////////////////
/*
	External Bulkheads
*/

/obj/machinery/door/bulkhead/external
	name = "external bulkhead"
	icon = 'icons/obj/doors/airlocks/external/airlock.dmi'
	color_overlays = 'icons/obj/doors/airlocks/external/airlock_color.dmi'
	glass_fill_overlays = 'icons/obj/doors/airlocks/external/glass_overlays.dmi'
	overlays_file = 'icons/obj/doors/airlocks/external/overlays.dmi'
	bulkhead_paint = "#9F2828"
	assemblytype = /obj/structure/door_assembly/door_assembly_ext
	doorOpen = 'sound/machines/door/airlock_open_space.ogg'
	doorClose = 'sound/machines/door/airlock_close_space.ogg'

	/// Whether or not the bulkhead can be opened without access from a certain direction while powered, or with bare hands from any direction while unpowered OR pressurized.
	var/space_dir = null

/obj/machinery/door/bulkhead/external/Initialize(mapload, ...)
	// default setting is for mapping only, let overrides work
	if(!mapload || req_access_txt || req_one_access_txt)
		req_access = null

	..()

	return INITIALIZE_HINT_LATELOAD

/obj/machinery/door/bulkhead/external/LateInitialize()
	. = ..()
	if(space_dir)
		unres_sides |= space_dir

/obj/machinery/door/bulkhead/external/examine(mob/user)
	. = ..()
	if(space_dir)
		. += span_notice("It has labels indicating that it has an emergency mechanism to open from the [dir2text(space_dir)] side with <b>just your hands</b> even if there's no power.")

/obj/machinery/door/bulkhead/external/cyclelinkbulkhead()
	. = ..()
	var/obj/machinery/door/bulkhead/external/cycle_linked_external_bulkhead = cyclelinkedbulkhead
	if(istype(cycle_linked_external_bulkhead))
		cycle_linked_external_bulkhead.space_dir |= space_dir
		space_dir |= cycle_linked_external_bulkhead.space_dir

/obj/machinery/door/bulkhead/external/try_safety_unlock(mob/user)
	if(space_dir && density)
		if(!hasPower())
			to_chat(user, span_notice("You begin unlocking the bulkhead safety mechanism..."))
			if(do_after(user, 15 SECONDS, target = src))
				try_to_crowbar(null, user, TRUE)
				return TRUE
		else
			// always open from the space side
			// get_dir(src, user) & space_dir, checked in unresricted_sides
			var/should_safety_open = shuttledocked || cyclelinkedbulkhead?.shuttledocked || is_safe_turf(get_step(src, space_dir), TRUE, FALSE)
			return try_to_activate_door(user, should_safety_open)

	return ..()

/// Access free external bulkhead
/obj/machinery/door/bulkhead/external/ruin

/obj/machinery/door/bulkhead/external/glass
	opacity = FALSE
	glass = TRUE

/// Access free external glass bulkhead
/obj/machinery/door/bulkhead/external/glass/ruin

//////////////////////////////////
/*
	CentCom Bulkheads
*/

/obj/machinery/door/bulkhead/centcom //Use grunge as a station side version, as these have special effects related to them via phobias and such.
	icon = 'icons/obj/doors/airlocks/centcom/airlock.dmi'
	assemblytype = /obj/structure/door_assembly/door_assembly_centcom
	normal_integrity = 1000
	security_level = 6
	explosion_block = 2

/obj/machinery/door/bulkhead/grunge
	icon = 'icons/obj/doors/airlocks/centcom/airlock.dmi'
	assemblytype = /obj/structure/door_assembly/door_assembly_grunge

//////////////////////////////////
/*
	Vault Bulkheads
*/

/obj/machinery/door/bulkhead/vault
	name = "vault door"
	icon = 'icons/obj/doors/airlocks/vault/airlock.dmi'
	overlays_file = 'icons/obj/doors/airlocks/vault/overlays.dmi'
	assemblytype = /obj/structure/door_assembly/door_assembly_vault
	explosion_block = 2
	normal_integrity = 400 // reverse engieneerd: 400 * 1.5 (sec lvl 6) = 600 = original
	security_level = 6
	has_fill_overlays = FALSE

//////////////////////////////////
/*
	Hatch Bulkheads
*/

/obj/machinery/door/bulkhead/hatch
	name = "airtight hatch"
	icon = 'icons/obj/doors/airlocks/hatch/airlock.dmi'
	stripe_overlays = 'icons/obj/doors/airlocks/hatch/airlock_stripe.dmi'
	assemblytype = /obj/structure/door_assembly/door_assembly_hatch
	doorOpen = 'sound/machines/door/airlock_open_maint.ogg'
	doorClose = 'sound/machines/door/airlock_close_maint.ogg'

/obj/machinery/door/bulkhead/maintenance_hatch
	name = "maintenance hatch"
	icon = 'icons/obj/doors/airlocks/hatch/airlock.dmi'
	stripe_overlays = 'icons/obj/doors/airlocks/hatch/airlock_stripe.dmi'
	overlays_file = 'icons/obj/doors/airlocks/hatch/overlays.dmi'
	assemblytype = /obj/structure/door_assembly/door_assembly_mhatch
	stripe_paint = "#B69F3C"
	doorOpen = 'sound/machines/door/airlock_open_maint.ogg'
	doorClose = 'sound/machines/door/airlock_close_maint.ogg'

//////////////////////////////////
/*
	High Security Bulkheads
*/

/obj/machinery/door/bulkhead/highsecurity
	name = "high tech security bulkhead"
	icon = 'icons/obj/doors/airlocks/highsec/airlock.dmi'
	color_overlays = null
	stripe_overlays = null
	has_fill_overlays = FALSE
	assemblytype = /obj/structure/door_assembly/door_assembly_highsecurity
	explosion_block = 2
	normal_integrity = 500
	security_level = 1
	damage_deflection = 30

//////////////////////////////////
/*
	Shuttle Bulkheads
*/

/obj/machinery/door/bulkhead/shuttle
	name = "shuttle bulkhead"
	assemblytype = /obj/structure/door_assembly/door_assembly_shuttle
	bulkhead_paint = "#b3c0c7"

/obj/machinery/door/bulkhead/shuttle/glass
	opacity = FALSE
	glass = TRUE

/obj/machinery/door/bulkhead/abductor
	name = "alien bulkhead"
	desc = "With humanity's current technological level, it could take years to hack this advanced bulkhead... or maybe we should give a screwdriver a try?"
	assemblytype = /obj/structure/door_assembly/door_assembly_abductor
	damage_deflection = 30
	explosion_block = 3
	hackProof = TRUE
	aiControlDisabled = AI_WIRE_DISABLED
	normal_integrity = 700
	security_level = 1
	bulkhead_paint = "#333333"
	stripe_paint = "#6633CC"

//////////////////////////////////
/*
	Cult Bulkheads
*/

/obj/machinery/door/bulkhead/cult
	name = "cult bulkhead"
	assemblytype = /obj/structure/door_assembly/door_assembly_cult
	hackProof = TRUE
	aiControlDisabled = AI_WIRE_DISABLED
	req_access = list(ACCESS_BLOODCULT)
	damage_deflection = 10
	bulkhead_paint = "#333333"
	stripe_paint = "#610000"
	var/openingoverlaytype = /obj/effect/temp_visual/cult/door
	var/friendly = FALSE
	var/stealthy = FALSE

/obj/machinery/door/bulkhead/cult/Initialize(mapload)
	. = ..()
	new openingoverlaytype(loc)

/obj/machinery/door/bulkhead/cult/canAIControl(mob/user)
	return (IS_CULTIST(user) && !isAllPowerCut())

/obj/machinery/door/bulkhead/cult/on_break()
	if(!panel_open)
		panel_open = TRUE

/obj/machinery/door/bulkhead/cult/isElectrified()
	return FALSE

/obj/machinery/door/bulkhead/cult/hasPower()
	return TRUE

/obj/machinery/door/bulkhead/cult/allowed(mob/living/L)
	if(!density)
		return TRUE
	if(friendly || IS_CULTIST(L) || isshade(L) || isconstruct(L))
		if(!stealthy)
			new openingoverlaytype(loc)
		return TRUE
	else
		if(!stealthy)
			new /obj/effect/temp_visual/cult/sac(loc)
			var/atom/throwtarget
			throwtarget = get_edge_target_turf(src, get_dir(src, get_step_away(L, src)))
			SEND_SOUND(L, sound(pick('sound/hallucinations/turn_around1.ogg','sound/hallucinations/turn_around2.ogg'),0,1,50))
			flash_color(L, flash_color="#960000", flash_time=20)
			L.Paralyze(40)
			L.throw_at(throwtarget, 5, 1)
		return FALSE

/obj/machinery/door/bulkhead/cult/proc/conceal()
	icon = 'icons/obj/doors/airlocks/station/airlock.dmi'
	overlays_file = 'icons/obj/doors/airlocks/station/overlays.dmi'
	name = "Bulkhead"
	desc = "It opens and closes."
	stealthy = TRUE
	update_appearance()

/obj/machinery/door/bulkhead/cult/proc/reveal()
	icon = initial(icon)
	overlays_file = initial(overlays_file)
	name = initial(name)
	desc = initial(desc)
	stealthy = initial(stealthy)
	update_appearance()

/obj/machinery/door/bulkhead/cult/narsie_act()
	return

/obj/machinery/door/bulkhead/cult/emp_act(severity)
	return

/obj/machinery/door/bulkhead/cult/friendly
	friendly = TRUE

/obj/machinery/door/bulkhead/cult/glass
	glass = TRUE
	opacity = FALSE

/obj/machinery/door/bulkhead/cult/glass/friendly
	friendly = TRUE

/obj/machinery/door/bulkhead/cult/unruned
	assemblytype = /obj/structure/door_assembly/door_assembly_cult/unruned
	openingoverlaytype = /obj/effect/temp_visual/cult/door/unruned

/obj/machinery/door/bulkhead/cult/unruned/friendly
	friendly = TRUE

/obj/machinery/door/bulkhead/cult/unruned/glass
	glass = TRUE
	opacity = FALSE

/obj/machinery/door/bulkhead/cult/unruned/glass/friendly
	friendly = TRUE

/obj/machinery/door/bulkhead/cult/weak
	name = "brittle cult bulkhead"
	desc = "An bulkhead hastily corrupted by blood magic, it is unusually brittle in this state."
	normal_integrity = 150
	damage_deflection = 5
	armor = list(MELEE = 0, BULLET = 0, LASER = 0,ENERGY = 0, BOMB = 0, BIO = 0, FIRE = 0, ACID = 0)


//////////////////////////////////
/*
	Material Bulkheads
*/
/obj/machinery/door/bulkhead/material
	name = "Bulkhead"
	material_flags = MATERIAL_EFFECTS | MATERIAL_ADD_PREFIX | MATERIAL_GREYSCALE | MATERIAL_AFFECT_STATISTICS
	greyscale_config = /datum/greyscale_config/material_bulkhead
	assemblytype = /obj/structure/door_assembly/door_assembly_material

/obj/machinery/door/bulkhead/material/close(forced, force_crush)
	. = ..()
	if(!.)
		return
	for(var/datum/material/mat in custom_materials)
		if(mat.alpha < 255)
			set_opacity(FALSE)
			break

/obj/machinery/door/bulkhead/material/prepare_deconstruction_assembly(obj/structure/door_assembly/assembly)
	assembly.set_custom_materials(custom_materials)
	..()

/obj/machinery/door/bulkhead/material/glass
	opacity = FALSE
	glass = TRUE

//////////////////////////////////
/*
	Misc Bulkheads
*/

/obj/machinery/door/bulkhead/glass_large
	name = "large glass bulkhead"
	icon = 'icons/obj/doors/airlocks/glass_large/glass_large.dmi'
	overlays_file = 'icons/obj/doors/airlocks/glass_large/overlays.dmi'
	opacity = FALSE
	assemblytype = null
	glass = TRUE
	bound_width = 64 // 2x1

/obj/machinery/door/bulkhead/glass_large/narsie_act()
	return
