/obj/effect/spawner/random/supplies_box
	icon = 'icons/obj/structures/supplies_box.dmi'
	icon_state = "random"
	name = "spawn random supplies box"
	loot = list(
		/obj/structure/supplies_box/food = 1,
		/obj/structure/supplies_box/materials = 1,
		/obj/structure/supplies_box/engineering = 1,
		/obj/structure/supplies_box/medical = 1,
		/obj/structure/supplies_box/security = 1,
		/obj/structure/supplies_box/military = 1,
		/obj/structure/supplies_box/tech = 1,
	)

/obj/effect/spawner/random/supplies_box/common
	name = "spawn random common supplies box"
	icon_state = "random_common"
	loot = list(
		/obj/structure/supplies_box/food = 1,
		/obj/structure/supplies_box/materials = 1,
		/obj/structure/supplies_box/engineering = 1,
		/obj/structure/supplies_box/medical = 1,
		/obj/structure/supplies_box/tech = 1,
	)

/obj/effect/spawner/random/random_supplies_box/rare
	name = "spawn random rare supplies box"
	icon_state = "random_rare"
	loot = list(
		/obj/structure/supplies_box/security = 1,
		/obj/structure/supplies_box/military = 1,
		/obj/structure/supplies_box/tech = 1,
	)
