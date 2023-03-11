
/obj/effect/spawner/random/weapon
	name = "weapon loot spawner"
	desc = "Pstttthhh! Pass it under the table."
	icon_state = "pistol"

/obj/effect/spawner/random/weapon/energy_weapon
	name = "energy weapon spawner"
	loot = list(
		/obj/item/gun/energy/e_gun = 1,
		/obj/item/gun/energy/e_gun/mini = 1,
		/obj/item/gun/energy/laser/hellgun = 1,
		/obj/item/gun/energy/e_gun/nuclear = 1,
		/obj/item/gun/energy/taser = 1
	)

/obj/effect/spawner/random/weapon/ballistic_weapon
	name = "ballistic weapon spawner"
	loot = list(
		/obj/item/gun/ballistic/automatic/pistol = 1,
		/obj/item/gun/ballistic/automatic/pistol/m1911 = 1,
		/obj/item/gun/ballistic/shotgun = 1
	)

/obj/effect/spawner/random/weapon/handgun
	name = "handgun spawner"
	loot = list(
		/obj/item/gun/ballistic/automatic/pistol = 1,
		/obj/item/gun/ballistic/automatic/pistol/m1911 = 1,
		/obj/item/gun/energy/e_gun/mini = 1
	)

/obj/effect/spawner/random/weapon/melee_weapon
	name = "melee weapon spawner"
	loot = list(
		/obj/item/melee/baton/security/loaded = 1,
		/obj/item/switchblade = 1,
		/obj/item/knife/combat/survival = 1
	)

/obj/effect/spawner/random/weapon/tactical_gear
	name = "tactical gear spawner"
	loot = list(
		/obj/item/clothing/glasses/night = 1,
		/obj/item/clothing/gloves/tackler/combat/insulated = 1,
		/obj/item/clothing/suit/armor/riot = 1,
		/obj/item/clothing/head/helmet/riot = 1
	)

/obj/effect/spawner/random/weapon/grenade
	name = "grenade spawner"
	loot = list(
		/obj/item/grenade/c4/x4 = 1,
		/obj/item/grenade/c4 = 1,
		/obj/item/grenade/frag = 1,
		/obj/item/grenade/flashbang = 1,
		/obj/item/grenade/empgrenade = 1
	)

/obj/effect/spawner/random/weapon/ammo
	name = "ammo spawner"
	loot = list(
		/obj/item/ammo_box/magazine/m9mm = 1,
		/obj/item/ammo_box/magazine/m45 = 1,
		/obj/item/ammo_box/magazine/m12g = 1,
		/obj/item/ammo_box/magazine/m12g/slug = 1
	)
