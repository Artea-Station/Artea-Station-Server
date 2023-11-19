//////////////////////////////////////////////////////////////////////////////
////////////////////////////// Livestock /////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

/datum/supply_pack/critter
	group = "Livestock"
	container_type = /obj/structure/closet/crate/critter

/datum/supply_pack/critter/parrot
	name = "Bird Crate"
	desc = "Contains five expert telecommunication birds."
	cost = CARGO_CRATE_VALUE * 8
	access_view = ACCESS_CE
	contains = list(/mob/living/simple_animal/parrot)
	container_name = "parrot crate"

/datum/supply_pack/critter/parrot/generate()
	. = ..()
	for(var/i in 1 to 4)
		new /mob/living/simple_animal/parrot(.)

/datum/supply_pack/critter/butterfly
	name = "Butterflies Crate"
	desc = "Not a very dangerous insect, but they do give off a better image than, say, flies or cockroaches."//is that a motherfucking worm reference
	contraband = TRUE
	cost = CARGO_CRATE_VALUE * 5
	access_view = ACCESS_THEATRE
	contains = list(/mob/living/simple_animal/butterfly)
	container_name = "entomology samples crate"

/datum/supply_pack/critter/butterfly/generate()
	. = ..()
	for(var/i in 1 to 49)
		new /mob/living/simple_animal/butterfly(.)

/datum/supply_pack/critter/cat
	name = "Cat Crate"
	desc = "The cat goes meow! Comes with a collar and a nice cat toy! Cheeseburger not included."//i can't believe im making this reference
	cost = CARGO_CRATE_VALUE * 10 //Cats are worth as much as corgis.
	access_view = ACCESS_MEDICAL
	contains = list(/mob/living/simple_animal/pet/cat,
					/obj/item/clothing/neck/petcollar,
					/obj/item/toy/cattoy)
	container_name = "cat crate"

/datum/supply_pack/critter/cat/generate()
	. = ..()
	if(prob(50))
		var/mob/living/simple_animal/pet/cat/C = locate() in .
		qdel(C)
		new /mob/living/simple_animal/pet/cat/_proc(.)

/datum/supply_pack/critter/chick
	name = "Chicken Crate"
	desc = "The chicken goes bwaak!"
	cost = CARGO_CRATE_VALUE * 4
	access_view = ACCESS_KITCHEN
	contains = list( /mob/living/simple_animal/chick)
	container_name = "chicken crate"

/datum/supply_pack/critter/corgi
	name = "Corgi Crate"
	desc = "Considered the optimal dog breed by thousands of research scientists, this Corgi is but one dog from the millions of Ian's noble bloodline. Comes with a cute collar!"
	cost = CARGO_CRATE_VALUE * 10
	access_view = ACCESS_HOP
	contains = list(/mob/living/simple_animal/pet/dog/corgi,
					/obj/item/clothing/neck/petcollar)
	container_name = "corgi crate"

/datum/supply_pack/critter/corgi/generate()
	. = ..()
	if(prob(50))
		var/mob/living/simple_animal/pet/dog/corgi/D = locate() in .
		if(D.gender == FEMALE)
			qdel(D)
			new /mob/living/simple_animal/pet/dog/corgi/lisa(.)

/datum/supply_pack/critter/cow
	name = "Cow Crate"
	desc = "The cow goes moo!"
	cost = CARGO_CRATE_VALUE * 6
	access_view = ACCESS_HYDROPONICS
	contains = list(/mob/living/basic/cow)
	container_name = "cow crate"

/datum/supply_pack/critter/sheep
	name = "Sheep Crate"
	desc = "The sheep goes BAAAA!"
	cost = CARGO_CRATE_VALUE * 6
	access_view = ACCESS_HYDROPONICS
	contains = list(/mob/living/basic/sheep)
	container_name = "sheep crate"

/datum/supply_pack/critter/pig
	name = "Pig Crate"
	desc = "The pig goes oink!"
	cost = CARGO_CRATE_VALUE * 6
	access_view = ACCESS_KITCHEN
	contains = list(/mob/living/basic/pig)
	container_name = "pig crate"

/datum/supply_pack/critter/crab
	name = "Crab Rocket"
	desc = "CRAAAAAAB ROCKET. CRAB ROCKET. CRAB ROCKET. CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB ROCKET. CRAFT. ROCKET. BUY. CRAFT ROCKET. CRAB ROOOCKET. CRAB ROOOOCKET. CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB ROOOOOOOOOOOOOOOOOOOOOOCK EEEEEEEEEEEEEEEEEEEEEEEEE EEEETTTTTTTTTTTTAAAAAAAAA AAAHHHHHHHHHHHHH. CRAB ROCKET. CRAAAB ROCKEEEEEEEEEGGGGHHHHTT CRAB CRAB CRAABROCKET CRAB ROCKEEEET."//fun fact: i actually spent like 10 minutes and transcribed the entire video.
	cost = CARGO_CRATE_VALUE * 8
	access_view = ACCESS_HOS
	contains = list(/mob/living/simple_animal/crab)
	container_name = "look sir free crabs"

/datum/supply_pack/critter/crab/generate()
	. = ..()
	for(var/i in 1 to 10)
		new /mob/living/simple_animal/crab(.)

/datum/supply_pack/critter/corgis/exotic
	name = "Exotic Corgi Crate"
	desc = "Corgis fit for a king, these corgis come in a unique color to signify their superiority. Comes with a cute collar!"
	cost = CARGO_CRATE_VALUE * 11
	contains = list(/mob/living/simple_animal/pet/dog/corgi/exoticcorgi,
					/obj/item/clothing/neck/petcollar)
	container_name = "exotic corgi crate"

/datum/supply_pack/critter/fox
	name = "Fox Crate"
	desc = "The fox goes...? Comes with a collar!"//what does the fox say
	cost = CARGO_CRATE_VALUE * 10
	access_view = ACCESS_CAPTAIN
	contains = list(/mob/living/simple_animal/pet/fox,
					/obj/item/clothing/neck/petcollar)
	container_name = "fox crate"

/datum/supply_pack/critter/goat
	name = "Goat Crate"
	desc = "The goat goes baa! Warranty void if used as a replacement for Pete."
	cost = CARGO_CRATE_VALUE * 5
	access_view = ACCESS_KITCHEN
	contains = list(/mob/living/simple_animal/hostile/retaliate/goat)
	container_name = "goat crate"

/datum/supply_pack/critter/mothroach
	name = "Mothroach Crate"
	desc = "Put the mothroach on your head and find out what true cuteness looks like."
	cost = CARGO_CRATE_VALUE * 4
	contains = list(/mob/living/basic/mothroach)
	container_name = "mothroach crate"

/datum/supply_pack/critter/monkey
	name = "Monkey Cube Crate"
	desc = "Stop monkeying around! Contains seven monkey cubes. Just add water!"
	cost = CARGO_CRATE_VALUE * 4
	contains = list (/obj/item/storage/box/monkeycubes)
	container_type = /obj/structure/closet/crate
	container_name = "monkey cube crate"

/datum/supply_pack/critter/pug
	name = "Pug Crate"
	desc = "Like a normal dog, but... squished. Comes with a nice collar!"
	cost = CARGO_CRATE_VALUE * 10
	contains = list(/mob/living/simple_animal/pet/dog/pug,
					/obj/item/clothing/neck/petcollar)
	container_name = "pug crate"

/datum/supply_pack/critter/bullterrier
	name = "Bull Terrier Crate"
	desc = "Like a normal dog, but with a head the shape of an egg. Comes with a nice collar!"
	cost = CARGO_CRATE_VALUE * 10
	contains = list(/mob/living/simple_animal/pet/dog/bullterrier,
					/obj/item/clothing/neck/petcollar)
	container_name = "bull terrier crate"

/datum/supply_pack/critter/snake
	name = "Snake Crate"
	desc = "Tired of these MOTHER FUCKING snakes on this MOTHER FUCKING space station? Then this isn't the crate for you. Contains three poisonous snakes."
	cost = CARGO_CRATE_VALUE * 6
	access_view = ACCESS_SECURITY
	contains = list(/mob/living/simple_animal/hostile/retaliate/snake,
					/mob/living/simple_animal/hostile/retaliate/snake,
					/mob/living/simple_animal/hostile/retaliate/snake)
	container_name = "snake crate"

/datum/supply_pack/critter/lizard
	name = "Lizard Crate"
	desc = "Hisss! Containssss a friendly lizard. Not to be confusssed with a lizardperssson."
	cost = CARGO_CRATE_VALUE * 4
	access_view = ACCESS_JANITOR
	contains = list(/mob/living/simple_animal/hostile/lizard)
	container_name = "lizard crate"
