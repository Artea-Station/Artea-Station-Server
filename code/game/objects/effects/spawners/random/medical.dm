/obj/effect/spawner/random/medical
	name = "medical loot spawner"
	desc = "Doc, gimmie something good."

/obj/effect/spawner/random/medical/minor_healing
	name = "minor healing spawner"
	icon_state = "gauze"
	loot = list(
		/obj/item/stack/medical/suture,
		/obj/item/stack/medical/mesh,
		/obj/item/stack/medical/gauze,
	)

/obj/effect/spawner/random/medical/injector
	name = "injector spawner"
	icon_state = "syringe"
	loot = list(
		/obj/item/implanter,
		/obj/item/reagent_containers/dropper,
		/obj/item/reagent_containers/syringe,
	)

/obj/effect/spawner/random/medical/organs
	name = "ayylien organ spawner"
	icon_state = "eyes"
	spawn_loot_count = 3
	loot = list(
		/obj/item/organ/internal/heart/gland/egg = 7,
		/obj/item/organ/internal/heart/gland/plasma = 7,
		/obj/item/organ/internal/heart/gland/chem = 5,
		/obj/item/organ/internal/heart/gland/mindshock = 5,
		/obj/item/organ/internal/heart/gland/transform = 5,
		/obj/item/organ/internal/heart/gland/spiderman = 5,
		/obj/item/organ/internal/heart/gland/slime = 4,
		/obj/item/organ/internal/heart/gland/trauma = 4,
		/obj/item/organ/internal/heart/gland/electric = 3,
		/obj/item/organ/internal/regenerative_core = 2,
		/obj/item/organ/internal/heart/gland/ventcrawling = 1,
		/obj/item/organ/internal/body_egg/alien_embryo = 1,
	)

/obj/effect/spawner/random/medical/memeorgans
	name = "meme organ spawner"
	icon_state = "eyes"
	spawn_loot_count = 5
	loot = list(
		/obj/item/organ/internal/ears/penguin,
		/obj/item/organ/internal/ears/cat,
		/obj/item/organ/internal/eyes/moth,
		/obj/item/organ/internal/eyes/snail,
		/obj/item/organ/internal/tongue/bone,
		/obj/item/organ/internal/tongue/fly,
		/obj/item/organ/internal/tongue/snail,
		/obj/item/organ/internal/tongue/lizard,
		/obj/item/organ/internal/tongue/alien,
		/obj/item/organ/internal/tongue/ethereal,
		/obj/item/organ/internal/tongue/robot,
		/obj/item/organ/internal/tongue/zombie,
		/obj/item/organ/internal/appendix,
		/obj/item/organ/internal/liver/fly,
		/obj/item/organ/internal/lungs/plasmaman,
		/obj/item/organ/external/tail/cat,
		/obj/item/organ/external/tail/lizard,
	)

/obj/effect/spawner/random/medical/two_percent_xeno_egg_spawner
	name = "2% chance xeno egg spawner"
	icon_state = "xeno_egg"
	loot = list(
		/obj/effect/decal/remains/xeno = 49,
		/obj/effect/spawner/xeno_egg_delivery = 1,
	)

/obj/effect/spawner/random/medical/surgery_tool
	name = "Surgery tool spawner"
	icon_state = "scapel"
	loot = list(
		/obj/item/scalpel,
		/obj/item/hemostat,
		/obj/item/retractor,
		/obj/item/circular_saw,
		/obj/item/surgicaldrill,
		/obj/item/cautery,
		/obj/item/bonesetter,
	)

/obj/effect/spawner/random/medical/surgery_tool_advanced
	name = "Advanced surgery tool spawner"
	icon_state = "scapel"
	loot = list( // Mail loot spawner. Drop pool of advanced medical tools typically from research. Not endgame content.
		/obj/item/scalpel/advanced,
		/obj/item/retractor/advanced,
		/obj/item/cautery/advanced,
	)

/obj/effect/spawner/random/medical/surgery_tool_alien
	name = "Rare surgery tool spawner"
	icon_state = "scapel"
	loot = list( // Mail loot spawner. Some sort of random and rare surgical tool. Alien tech found here.
		/obj/item/scalpel/alien,
		/obj/item/hemostat/alien,
		/obj/item/retractor/alien,
		/obj/item/circular_saw/alien,
		/obj/item/surgicaldrill/alien,
		/obj/item/cautery/alien,
	)

/obj/effect/spawner/random/medical/medkit_rare
	name = "rare medkit spawner"
	icon_state = "medkit"
	loot = list(
		/obj/item/storage/medkit/emergency,
		/obj/item/storage/medkit/surgery,
		/obj/item/storage/medkit/advanced,
	)

/obj/effect/spawner/random/medical/medkit
	name = "medkit spawner"
	icon_state = "medkit"
	loot = list(
		/obj/item/storage/medkit/regular = 10,
		/obj/item/storage/medkit/o2 = 10,
		/obj/item/storage/medkit/fire = 10,
		/obj/item/storage/medkit/brute = 10,
		/obj/item/storage/medkit/toxin = 10,
		/obj/effect/spawner/random/medical/medkit_rare = 1,
	)

/obj/effect/spawner/random/medical/patient_stretcher
	name = "patient stretcher spawner"
	icon_state = "rollerbed"
	loot = list(
		/obj/structure/bed/roller,
		/obj/vehicle/ridden/wheelchair,
	)

/obj/effect/spawner/random/medical/supplies
	name = "medical supplies spawner"
	icon_state = "box_small"
	loot = list(
		/obj/item/storage/box/hug,
		/obj/item/storage/box/pillbottles,
		/obj/item/storage/box/bodybags,
		/obj/item/storage/box/rxglasses,
		/obj/item/storage/box/beakers,
		/obj/item/storage/box/gloves,
		/obj/item/storage/box/masks,
		/obj/item/storage/box/syringes,
	)

/obj/effect/spawner/random/medical/equipment
	name = "medical equipment spawner"
	loot = list(
		/obj/effect/spawner/random/medical/medicine/five = 1,
		/obj/effect/spawner/random/medical/medkit = 1,
		/obj/item/bodybag = 1,
		/obj/machinery/iv_drip = 1,
		/obj/structure/closet/crate/freezer/blood = 1,
		/obj/structure/closet/crate/freezer/surplus_limbs = 1,
		/obj/item/storage/backpack/duffelbag/med/surgery = 1,
		/obj/item/storage/organbox = 1
	)

/obj/effect/spawner/random/medical/medicine
	name = "medicine spawner"
	loot = list(
		/obj/item/stack/medical/bruise_pack = 5,
		/obj/item/stack/medical/ointment= 5,
		/obj/item/reagent_containers/hypospray/medipen = 5,
		/obj/item/stack/medical/gauze/twelve = 5,
		/obj/item/stack/medical/bone_gel/four = 5,
		/obj/item/stack/medical/suture = 5,
		/obj/item/stack/medical/mesh = 5,
		/obj/effect/spawner/random/engineering/toolbox = 1,
		/obj/item/storage/pill_bottle/mining = 1,
		/obj/item/storage/pill_bottle/mannitol = 1,
		/obj/item/storage/pill_bottle/iron = 5,
		/obj/item/storage/pill_bottle/probital = 1,
		/obj/item/storage/pill_bottle/potassiodide = 1,
		/obj/item/storage/pill_bottle/mutadone = 1,
		/obj/item/storage/pill_bottle/epinephrine = 5,
		/obj/item/storage/pill_bottle/multiver = 5
	)

/obj/effect/spawner/random/medical/medicine/five
	name = "5x medicine spawner"
	spawn_loot_count = 5

/obj/effect/spawner/random/medical/chem_cartridge
	name = "random chem cartridge"
	loot = list(
		/obj/item/reagent_containers/chem_cartridge/large = 1,
		/obj/item/reagent_containers/chem_cartridge/medium = 5,
		/obj/item/reagent_containers/chem_cartridge/small = 10,
	)
	var/static/list/cached_whitelist
	var/is_always_full = FALSE

/obj/effect/spawner/random/medical/chem_cartridge/Initialize(mapload)
	if(!cached_whitelist)
		cached_whitelist = list()
		for(var/datum/reagent/reagent as anything in CARTRIDGE_LIST_CHEM_DISPENSER)
			cached_whitelist += reagent
	. = ..()

/obj/effect/spawner/random/medical/chem_cartridge/make_item(spawn_loc, type_path_to_make)
	var/obj/item/reagent_containers/chem_cartridge/cartridge = new type_path_to_make(spawn_loc)
	cartridge.reagents.add_reagent(pick(cached_whitelist), is_always_full ? cartridge.volume : rand(0, cartridge.volume))
	return cartridge

/obj/effect/spawner/random/medical/chem_cartridge/three
	name = "3x random chem cartridge"
	spawn_loot_count = 3

/obj/effect/spawner/random/medical/chem_cartridge/full
	name = "random full chem cartridge"
	is_always_full = TRUE

/obj/effect/spawner/random/medical/chem_cartridge/full/three
	name = "3x random full chem cartridge"
	spawn_loot_count = 3
