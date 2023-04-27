/turf/closed/wall/mineral
	name = "mineral wall"
	desc = "This shouldn't exist"
	rcd_memory = null
	material_flags = MATERIAL_EFFECTS

/turf/closed/wall/mineral/gold
	name = "gold wall"
	desc = "A wall with gold plating. Swag!"
	explosion_block = 0 //gold is a soft metal you dingus.
	plating_material = /datum/material/gold
	color = "#dbdd4c" //To display in mapping softwares

/turf/closed/wall/mineral/silver
	name = "silver wall"
	desc = "A wall with silver plating. Shiny!"
	plating_material = /datum/material/silver
	color = "#e3f1f8" //To display in mapping softwares

/turf/closed/wall/mineral/diamond
	name = "diamond wall"
	desc = "A wall with diamond plating. You monster."
	slicing_duration = 200   //diamond wall takes twice as much time to slice
	explosion_block = 3
	plating_material = /datum/material/diamond
	color = "#71c8f7" //To display in mapping softwares

/turf/closed/wall/mineral/bananium
	name = "bananium wall"
	desc = "A wall with bananium plating. Honk!"
	plating_material = /datum/material/bananium
	color = "#ffff00" //To display in mapping softwares

/turf/closed/wall/mineral/sandstone
	name = "sandstone wall"
	desc = "A wall with sandstone plating. Rough."
	icon = 'icons/turf/walls/stone_wall.dmi'
	explosion_block = 0
	plating_material = /datum/material/sandstone
	color = "#B77D31" //To display in mapping softwares

/turf/closed/wall/mineral/uranium
	article = "a"
	name = "uranium wall"
	desc = "A wall with uranium plating. This is probably a bad idea."
	icon = 'icons/turf/walls/stone_wall.dmi'
	plating_material = /datum/material/uranium
	color = "#007a00" //To display in mapping softwares

	/// Mutex to prevent infinite recursion when propagating radiation pulses
	var/active = null

	/// The last time a radiation pulse was performed
	var/last_event = 0

/turf/closed/wall/mineral/uranium/Initialize(mapload)
	. = ..()
	RegisterSignal(src, COMSIG_ATOM_PROPAGATE_RAD_PULSE, PROC_REF(radiate))

/turf/closed/wall/mineral/uranium/proc/radiate()
	SIGNAL_HANDLER
	if(active)
		return
	if(world.time <= last_event + 1.5 SECONDS)
		return
	active = TRUE
	radiation_pulse(
		src,
		max_range = 3,
		threshold = RAD_LIGHT_INSULATION,
		chance = URANIUM_IRRADIATION_CHANCE,
		minimum_exposure_time = URANIUM_RADIATION_MINIMUM_EXPOSURE_TIME,
	)
	propagate_radiation_pulse()
	last_event = world.time
	active = FALSE

/turf/closed/wall/mineral/uranium/attack_hand(mob/user, list/modifiers)
	radiate()
	return ..()

/turf/closed/wall/mineral/uranium/attackby(obj/item/W, mob/user, params)
	radiate()
	return ..()

/turf/closed/wall/mineral/uranium/Bumped(atom/movable/AM)
	radiate()
	return ..()

/turf/closed/wall/mineral/plasma
	name = "plasma wall"
	desc = "A wall with plasma plating. This is definitely a bad idea."
	thermal_conductivity = 0.04
	plating_material = /datum/material/plasma
	color = "#c162ec" //To display in mapping softwares

/turf/closed/wall/mineral/wood
	name = "wooden wall"
	desc = "A wall with wooden plating. Stiff."
	icon = 'icons/turf/walls/wood_wall.dmi'
	hardness = 70
	turf_flags = IS_SOLID
	explosion_block = 0
	plating_material = /datum/material/wood
	color = "#bb8e53" //To display in mapping softwares

/turf/closed/wall/mineral/wood/attackby(obj/item/W, mob/user)
	if(W.get_sharpness() && W.force)
		var/duration = ((4.8 SECONDS)/W.force) * 2 //In seconds, for now.
		if(istype(W, /obj/item/hatchet) || istype(W, /obj/item/fireaxe))
			duration /= 4 //Much better with hatchets and axes.
		if(do_after(user, duration * (1 SECONDS), target=src)) //Into deciseconds.
			dismantle_wall(FALSE,FALSE)
			return
	return ..()

/turf/closed/wall/mineral/wood/nonmetal
	desc = "A solidly wooden wall. It's a bit weaker than a wall made with metal."
	hardness = 50

/turf/closed/wall/mineral/iron
	name = "rough iron wall"
	desc = "A wall with rough iron plating."
	icon = 'icons/turf/walls/stone_wall.dmi'

/turf/closed/wall/mineral/snow
	name = "packed snow wall"
	desc = "A wall made of densely packed snow blocks."
	icon = 'icons/turf/walls/stone_wall.dmi'
	hardness = 80
	explosion_block = 0
	slicing_duration = 30
	bullet_sizzle = TRUE
	bullet_bounce_sound = null
	plating_material = /datum/material/snow

/turf/closed/wall/mineral/abductor
	name = "alien wall"
	desc = "A wall with alien alloy plating."
	slicing_duration = 200   //alien wall takes twice as much time to slice
	explosion_block = 3
	plating_material = /datum/material/alloy/alien
	color = "#6041aa" //To display in mapping softwares

/////////////////////Titanium walls/////////////////////

/turf/closed/wall/mineral/titanium //has to use this path due to how building walls works
	name = "wall"
	desc = "A light-weight titanium wall used in shuttles."
	explosion_block = 3
	flags_1 = CAN_BE_DIRTY_1
	flags_ricochet = RICOCHET_SHINY | RICOCHET_HARD
	smoothing_groups = list(SMOOTH_GROUP_WALLS)
	canSmoothWith = list(SMOOTH_GROUP_WALLS, SMOOTH_GROUP_WINDOW_FULLTILE, SMOOTH_GROUP_LOW_WALL, SMOOTH_GROUP_AIRLOCK, SMOOTH_GROUP_SHUTTERS_BLASTDOORS, SMOOTH_GROUP_SHUTTLE_PARTS)
	plating_material = /datum/material/titanium
	color = "#b3c0c7" //To display in mapping softwares

/turf/closed/wall/mineral/titanium/rust_heretic_act()
	return // titanium does not rust

/turf/closed/wall/mineral/titanium/nodiagonal

/turf/closed/wall/mineral/titanium/nosmooth

/turf/closed/wall/mineral/titanium/overspace

/turf/closed/wall/mineral/titanium/interior

/turf/closed/wall/mineral/titanium/survival
	name = "pod wall"
	desc = "An easily-compressable wall used for temporary shelter."
	canSmoothWith = list(SMOOTH_GROUP_SURVIVAL_TITANIUM_WALLS, SMOOTH_GROUP_WINDOW_FULLTILE, SMOOTH_GROUP_AIRLOCK, SMOOTH_GROUP_SHUTTLE_PARTS)
	color = "#242424" //To display in mapping softwares
	wall_paint = "#242424"
	stripe_paint = "#824621"

/turf/closed/wall/mineral/titanium/survival/nodiagonal

/turf/closed/wall/mineral/titanium/survival/pod
	smoothing_groups = list(SMOOTH_GROUP_SURVIVAL_TITANIUM_WALLS, SMOOTH_GROUP_WALLS)
	canSmoothWith = list(SMOOTH_GROUP_SURVIVAL_TITANIUM_WALLS)

/////////////////////Plastitanium walls/////////////////////

/turf/closed/wall/mineral/plastitanium
	name = "wall"
	desc = "A durable wall made of an alloy of plasma and titanium."
	icon = 'icons/turf/walls/metal_wall.dmi'
	explosion_block = 4
	smoothing_groups = list(SMOOTH_GROUP_WALLS)
	plating_material = /datum/material/alloy/plastitanium
	color = "#3a313a" //To display in mapping softwares

/turf/closed/wall/mineral/plastitanium/rust_heretic_act()
	return // plastitanium does not rust

/turf/closed/wall/mineral/plastitanium/nodiagonal

/turf/closed/wall/mineral/plastitanium/nosmooth

/turf/closed/wall/mineral/plastitanium/overspace


/turf/closed/wall/mineral/plastitanium/explosive/ex_act(severity)
	var/obj/item/bombcore/large/bombcore = new(get_turf(src))
	bombcore.detonate()
	return ..()

/turf/closed/wall/mineral/plastitanium/interior
