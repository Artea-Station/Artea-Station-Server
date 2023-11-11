///Utilitarian "cold" datum to spawn the loot, for memory optimisation
/datum/supplies_box_loot
	/// A list of all guaranteed spawns from this sheet
	var/list/guaranteed_spawns
	/// A list of weighted spawns from this sheet, they will be picked and taken
	var/list/weighted_spawns
	/// Amount of weighted spawns to roll
	var/weighted_spawns_amount

/datum/supplies_box_loot/proc/spawn_loot(turf/location)
	for(var/spawn_type in guaranteed_spawns)
		new spawn_type(location)
	if(!weighted_spawns_amount)
		return
	for(var/i in 1 to weighted_spawns_amount)
		var/picked_type = pick_weight(weighted_spawns)
		new picked_type(location)
		weighted_spawns -= picked_type
		if(!weighted_spawns.len)
			break

/datum/supplies_box_loot/food
	guaranteed_spawns = list(
		/obj/item/reagent_containers/condiment/flour,
		/obj/item/reagent_containers/condiment/rice,
		/obj/item/reagent_containers/condiment/milk,
		/obj/item/reagent_containers/condiment/soymilk,
		/obj/item/reagent_containers/condiment/enzyme,
		/obj/item/reagent_containers/condiment/sugar,
		/obj/item/food/meat/slab/monkey,
		/obj/item/storage/fancy/egg_box,
		)
	weighted_spawns = list(
		/obj/item/storage/box/ingredients/fiesta = 100,
		/obj/item/storage/box/ingredients/italian = 100,
		/obj/item/storage/box/ingredients/vegetarian = 100,
		/obj/item/storage/box/ingredients/american = 100,
		/obj/item/storage/box/ingredients/fruity = 100,
		/obj/item/storage/box/ingredients/sweets = 100,
		/obj/item/storage/box/ingredients/delights = 100,
		/obj/item/storage/box/ingredients/grains = 100,
		/obj/item/storage/box/ingredients/carnivore = 100,
		/obj/item/storage/box/ingredients/exotic = 100,
		)
	weighted_spawns_amount = 2

/datum/supplies_box_loot/materials
	guaranteed_spawns = list(
		/obj/item/stack/sheet/iron{amount = 50},
		/obj/item/stack/sheet/glass{amount = 40},
		)
	weighted_spawns = list(
		/obj/item/stack/sheet/mineral/silver{amount = 10} = 15,
		/obj/item/stack/sheet/mineral/diamond{amount = 5} = 5,
		/obj/item/stack/sheet/mineral/uranium{amount = 5} = 5,
		/obj/item/stack/sheet/mineral/plasma{amount = 5} = 5,
		/obj/item/stack/sheet/mineral/titanium{amount = 5} = 10,
		/obj/item/stack/sheet/mineral/gold{amount = 5} = 10,
		/obj/item/stack/ore/bluespace_crystal{amount = 2} = 2,
	)
	weighted_spawns_amount = 1

/datum/supplies_box_loot/engineering
	guaranteed_spawns = list(
		/obj/item/storage/toolbox/mechanical,
		/obj/item/storage/toolbox/electrical
		)
	weighted_spawns = list(
		/obj/item/wrench = 10,
		/obj/item/screwdriver = 10,
		/obj/item/weldingtool = 10,
		/obj/item/crowbar = 10,
		/obj/item/wirecutters = 10,
		/obj/item/flashlight = 20,
		/obj/item/weldingtool/largetank = 10,
		/obj/item/analyzer = 10,
		/obj/item/t_scanner = 20,
		/obj/item/multitool = 40,
		/obj/item/assembly/flash/handheld = 20,
		/obj/item/clothing/gloves/color/yellow = 20,
		/obj/item/clothing/gloves/color/fyellow = 20,
		/obj/item/stock_parts/cell/upgraded = 20,
		)
	weighted_spawns_amount = 4

/datum/supplies_box_loot/medical
	guaranteed_spawns = list(/obj/item/storage/medkit/regular)
	weighted_spawns = list(
		/obj/item/stack/medical/bruise_pack = 5,
		/obj/item/stack/medical/ointment= 5,
		/obj/item/reagent_containers/hypospray/medipen = 5,
		/obj/item/stack/medical/gauze/twelve = 5,
		/obj/item/stack/medical/bone_gel/four = 5,
		/obj/item/stack/medical/suture = 5,
		/obj/item/stack/medical/mesh = 5,
		/obj/item/storage/pill_bottle/mining = 1,
		/obj/item/storage/pill_bottle/mannitol = 1,
		/obj/item/storage/pill_bottle/iron = 5,
		/obj/item/storage/pill_bottle/probital = 1,
		/obj/item/storage/pill_bottle/potassiodide = 1,
		/obj/item/storage/pill_bottle/mutadone = 1,
		/obj/item/storage/pill_bottle/epinephrine = 5,
		/obj/item/storage/pill_bottle/multiver = 5,
	)
	weighted_spawns_amount = 3

/datum/supplies_box_loot/security
	guaranteed_spawns = list(
		/obj/item/melee/baton/security/loaded,
		/obj/item/restraints/handcuffs/cable/zipties,
		)
	weighted_spawns = list(
		/obj/item/assembly/flash/handheld = 10,
		/obj/item/reagent_containers/spray/pepper = 10,
		/obj/item/grenade/flashbang = 10,
		/obj/item/storage/fancy/donut_box = 10,
		)
	weighted_spawns_amount = 2

/datum/supplies_box_loot/military
	guaranteed_spawns = list(
		/obj/item/gun/ballistic/automatic/pistol,
		/obj/item/switchblade,
		)
	weighted_spawns = list(
		/obj/item/ammo_box/magazine/m9mm = 10,
		/obj/effect/spawner/random/weapon/grenade = 10,
		/obj/item/gun/ballistic/shotgun/lethal = 2,
		/obj/item/storage/box/lethalshot = 10,
		)
	weighted_spawns_amount = 1

/datum/supplies_box_loot/tech
	guaranteed_spawns = list(
		/obj/item/disk/tech_disk/research/minor,
		)
	weighted_spawns = list(
		/obj/item/disk/tech_disk/research/minor = 50,
		/obj/item/disk/tech_disk/research/middle = 30,
		/obj/item/disk/tech_disk/research/major = 20,
		)
	weighted_spawns_amount = 2
