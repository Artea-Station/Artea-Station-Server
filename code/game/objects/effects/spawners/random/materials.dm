

/// Space loot spawner. Random selecton of a few rarer materials.
/obj/effect/spawner/random/material
	name = "material spawner"
	loot = list(
		/obj/item/stack/sheet/plastic/fifty = 5,
		/obj/item/stack/sheet/runed_metal/ten = 20,
		/obj/item/stack/sheet/runed_metal/fifty = 5,
		/obj/item/stack/sheet/mineral/diamond{amount = 15} = 15,
		/obj/item/stack/sheet/mineral/uranium{amount = 15} = 15,
		/obj/item/stack/sheet/mineral/plasma{amount = 15} = 15,
		/obj/item/stack/sheet/mineral/gold{amount = 15} = 15,
	)

//Really low amounts/chances of materials
/obj/effect/spawner/random/material_scarce
	name = "scarce material spawner"
	loot = list(
		/obj/item/stack/sheet/iron{amount = 5} = 60,
		/obj/item/stack/sheet/glass{amount = 5} = 20,
		/obj/item/stack/sheet/mineral/silver{amount = 3} = 15,
		/obj/item/stack/sheet/mineral/diamond{amount = 2} = 5,
		/obj/item/stack/sheet/mineral/uranium{amount = 2} = 5,
		/obj/item/stack/sheet/mineral/plasma{amount = 2} = 5,
		/obj/item/stack/sheet/mineral/titanium{amount = 2} = 5,
		/obj/item/stack/sheet/mineral/gold{amount = 2} = 5,
		/obj/item/stack/ore/bluespace_crystal{amount = 1} = 1
	)

/// One random selection of some ore, heavily weighted for common drops
/obj/effect/spawner/random/ore
	name = "ore spawner"
	loot = list(
		/obj/item/stack/ore/iron{amount = 15} = 50,
		/obj/item/stack/ore/glass{amount = 15} = 15,
		/obj/item/stack/ore/silver{amount = 10} = 15,
		/obj/item/stack/ore/diamond{amount = 5} = 5,
		/obj/item/stack/ore/uranium{amount = 5} = 5,
		/obj/item/stack/ore/plasma{amount = 5} = 5,
		/obj/item/stack/ore/titanium{amount = 5} = 5,
		/obj/item/stack/ore/gold{amount = 5} = 5,
		/obj/item/stack/ore/bluespace_crystal{amount = 1} = 2
	)

/obj/effect/spawner/random/ore_scarce
	name = "scarce ore spawner"
	loot = list(
		/obj/item/stack/ore/iron{amount = 5} = 50,
		/obj/item/stack/ore/glass{amount = 5} = 15,
		/obj/item/stack/ore/silver{amount = 3} = 15,
		/obj/item/stack/ore/diamond{amount = 2} = 5,
		/obj/item/stack/ore/uranium{amount = 2} = 5,
		/obj/item/stack/ore/plasma{amount = 2} = 5,
		/obj/item/stack/ore/titanium{amount = 2} = 5,
		/obj/item/stack/ore/gold{amount = 2} = 5,
		/obj/item/stack/ore/bluespace_crystal{amount = 1} = 2
	)

/obj/effect/spawner/random/ore_rich
	name = "rich ore spawner"
	loot = list(
		/obj/item/stack/ore/iron{amount = 34} = 50,
		/obj/item/stack/ore/glass{amount = 25} = 15,
		/obj/item/stack/ore/silver{amount = 20} = 15,
		/obj/item/stack/ore/diamond{amount = 10} = 5,
		/obj/item/stack/ore/uranium{amount = 15} = 5,
		/obj/item/stack/ore/plasma{amount = 15} = 5,
		/obj/item/stack/ore/titanium{amount = 15} = 5,
		/obj/item/stack/ore/gold{amount = 15} = 5,
		/obj/item/stack/ore/bluespace_crystal{amount = 6} = 2
	)
