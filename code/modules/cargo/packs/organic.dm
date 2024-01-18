//////////////////////////////////////////////////////////////////////////////
//////////////////////////// Organic /////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

/datum/supply_pack/organic
	group = "Food & Hydroponics"
	container_type = /obj/structure/closet/crate/freezer

/datum/supply_pack/organic/hydroponics
	access = ACCESS_HYDROPONICS

/datum/supply_pack/organic/hydroponics/beekeeping_suits
	name = "Beekeeper Suit Crate"
	desc = "Bee business booming? Better be benevolent and boost botany by bestowing bi-Beekeeper-suits! Contains two beekeeper suits and matching headwear."
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/clothing/head/beekeeper_head,
					/obj/item/clothing/suit/utility/beekeeper_suit,
					/obj/item/clothing/head/beekeeper_head,
					/obj/item/clothing/suit/utility/beekeeper_suit)
	container_name = "beekeeper suits"
	container_type = /obj/structure/closet/crate/hydroponics

/datum/supply_pack/organic/hydroponics/beekeeping_fullkit
	name = "Beekeeping Starter Crate"
	desc = "BEES BEES BEES. Contains three honey frames, a beekeeper suit and helmet, flyswatter, bee house, and, of course, a pure-bred Artea-Standardized Queen Bee!"
	cost = CARGO_CRATE_VALUE * 3
	contains = list(/obj/structure/beebox/unwrenched,
					/obj/item/honey_frame,
					/obj/item/honey_frame,
					/obj/item/honey_frame,
					/obj/item/queen_bee/bought,
					/obj/item/clothing/head/beekeeper_head,
					/obj/item/clothing/suit/utility/beekeeper_suit,
					/obj/item/melee/flyswatter)
	container_name = "beekeeping starter crate"
	container_type = /obj/structure/closet/crate/hydroponics

/datum/supply_pack/organic/randomized/chef
	name = "Excellent Meat Crate"
	desc = "The best cuts in the whole galaxy."
	cost = CARGO_CRATE_VALUE * 4
	contains = list(/obj/item/food/meat/slab/human/mutant/slime,
					/obj/item/food/meat/slab/killertomato,
					/obj/item/food/meat/slab/bear,
					/obj/item/food/meat/slab/xeno,
					/obj/item/food/meat/slab/spider,
					/obj/item/food/meat/rawbacon,
					/obj/item/food/meat/slab/penguin,
					/obj/item/food/spiderleg,
					/obj/item/food/fishmeat/carp,
					/obj/item/food/meat/slab/human)
	container_name = "food crate"

/datum/supply_pack/organic/randomized/chef/fill(obj/C)
	for(var/i in 1 to 15)
		var/item = pick(contains)
		new item(C)

/datum/supply_pack/organic/exoticseeds
	name = "Exotic Seeds Crate"
	desc = "Any entrepreneuring botanist's dream. Contains fourteen different seeds, including one replica-pod seed and two mystery seeds!"
	cost = CARGO_CRATE_VALUE * 3
	access = ACCESS_HYDROPONICS
	contains = list(/obj/item/seeds/nettle,
					/obj/item/seeds/replicapod,
					/obj/item/seeds/plump,
					/obj/item/seeds/liberty,
					/obj/item/seeds/amanita,
					/obj/item/seeds/reishi,
					/obj/item/seeds/bamboo,
					/obj/item/seeds/eggplant/eggy,
					/obj/item/seeds/rainbow_bunch,
					/obj/item/seeds/shrub,
					/obj/item/seeds/random,
					/obj/item/seeds/random)
	container_name = "exotic seeds crate"
	container_type = /obj/structure/closet/crate/hydroponics

/datum/supply_pack/organic/food
	name = "Food Crate"
	desc = "Get things cooking with this crate full of useful ingredients! Contains a dozen eggs, three bananas, and some flour, rice, milk, soymilk, salt, pepper, enzyme, sugar, and monkeymeat."
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/reagent_containers/condiment/flour,
					/obj/item/reagent_containers/condiment/rice,
					/obj/item/reagent_containers/condiment/milk,
					/obj/item/reagent_containers/condiment/soymilk,
					/obj/item/reagent_containers/condiment/saltshaker,
					/obj/item/reagent_containers/condiment/peppermill,
					/obj/item/storage/fancy/egg_box,
					/obj/item/reagent_containers/condiment/enzyme,
					/obj/item/reagent_containers/condiment/sugar,
					/obj/item/food/meat/slab/monkey,
					/obj/item/food/grown/banana,
					/obj/item/food/grown/banana,
					/obj/item/food/grown/banana)
	container_name = "food crate"

/datum/supply_pack/organic/randomized/chef/fruits
	name = "Fruit Crate"
	desc = "Rich of vitamins, may contain oranges."
	cost = CARGO_CRATE_VALUE * 3
	contains = list(/obj/item/food/grown/citrus/lime,
					/obj/item/food/grown/citrus/orange,
					/obj/item/food/grown/watermelon,
					/obj/item/food/grown/apple,
					/obj/item/food/grown/berries,
					/obj/item/food/grown/citrus/lemon)
	container_name = "food crate"

/datum/supply_pack/organic/cream_piee
	name = "High-yield Clown-grade Cream Pie Crate"
	desc = "Designed by Aussec's Advanced Warfare Research Division, these high-yield, Clown-grade cream pies are powered by a synergy of performance and efficiency. Guaranteed to provide maximum results."
	cost = CARGO_CRATE_VALUE * 12
	contains = list(/obj/item/storage/backpack/duffelbag/clown/cream_pie)
	container_name = "party equipment crate"
	contraband = TRUE
	access = ACCESS_THEATRE
	access = ACCESS_THEATRE
	container_type = /obj/structure/closet/crate/secure

/datum/supply_pack/organic/hydroponics
	name = "Hydroponics Crate"
	desc = "Supplies for growing a great garden! Contains two bottles of ammonia, two Plant-B-Gone spray bottles, a hatchet, cultivator, plant analyzer, as well as a pair of leather gloves and a botanist's apron."
	cost = CARGO_CRATE_VALUE * 3
	contains = list(/obj/item/reagent_containers/spray/plantbgone,
					/obj/item/reagent_containers/spray/plantbgone,
					/obj/item/reagent_containers/cup/bottle/ammonia,
					/obj/item/reagent_containers/cup/bottle/ammonia,
					/obj/item/hatchet,
					/obj/item/cultivator,
					/obj/item/plant_analyzer,
					/obj/item/clothing/gloves/botanic_leather,
					/obj/item/clothing/suit/apron)
	container_name = "hydroponics crate"
	container_type = /obj/structure/closet/crate/hydroponics

/datum/supply_pack/organic/hydroponics/hydrotank
	name = "Hydroponics Backpack Crate"
	desc = "Bring on the flood with this high-capacity backpack crate. Contains 500 units of life-giving H2O."
	cost = CARGO_CRATE_VALUE * 2
	access = ACCESS_HYDROPONICS
	contains = list(/obj/item/watertank)
	container_name = "hydroponics backpack crate"
	container_type = /obj/structure/closet/crate/secure

/datum/supply_pack/organic/pizza
	name = "Pizza Crate"
	desc = "Why visit the kitchen when you can have five random pizzas in a fraction of the time? \
			Best prices this side of the galaxy! All deliveries are guaranteed to be 99% anomaly-free."
	cost = CARGO_CRATE_VALUE * 10 // Best prices this side of the galaxy.
	contains = list(/obj/item/pizzabox/margherita,
					/obj/item/pizzabox/mushroom,
					/obj/item/pizzabox/meat,
					/obj/item/pizzabox/vegetable,
					/obj/item/pizzabox/pineapple)
	container_name = "pizza crate"
	///Whether we've provided an infinite pizza box already this shift or not.
	var/static/anomalous_box_provided = FALSE
	///The percentage chance (per pizza) of this supply pack to spawn an anomalous pizza box.
	var/anna_molly_box_chance = 1
	///Total tickets in our figurative lottery (per pizza) to decide if we create a bomb box, and if so what type. 1 to 3 create a bomb. The rest do nothing.
	var/boombox_tickets = 100
	///Whether we've provided a bomb pizza box already this shift or not.
	var/boombox_provided = FALSE

/datum/supply_pack/organic/pizza/fill(obj/C)
	. = ..()

	var/list/pizza_types = list(
		/obj/item/food/pizza/margherita = 10,
		/obj/item/food/pizza/meat = 10,
		/obj/item/food/pizza/mushroom = 10,
		/obj/item/food/pizza/vegetable = 10,
		/obj/item/food/pizza/donkpocket = 10,
		/obj/item/food/pizza/dank = 7,
		/obj/item/food/pizza/sassysage = 10,
		/obj/item/food/pizza/pineapple = 10,
		/obj/item/food/pizza/arnold = 3
	) //weighted by chance to disrupt eaters' rounds

	for(var/obj/item/pizzabox/P in C)
		if(!anomalous_box_provided)
			if(prob(anna_molly_box_chance)) //1% chance for each box, so 4% total chance per order
				var/obj/item/pizzabox/infinite/fourfiveeight = new(C)
				fourfiveeight.boxtag = P.boxtag
				fourfiveeight.boxtag_set = TRUE
				fourfiveeight.update_appearance()
				qdel(P)
				anomalous_box_provided = TRUE
				log_game("An anomalous pizza box was provided in a pizza crate at during cargo delivery.")
				if(prob(50))
					addtimer(CALLBACK(src, PROC_REF(anomalous_pizza_report)), rand(300, 1800))
					message_admins("An anomalous pizza box was provided in a pizza crate at during cargo delivery.")
				else
					message_admins("An anomalous pizza box was silently created with no command report in a pizza crate delivery.")
				continue

		if(!boombox_provided)
			var/boombox_lottery = rand(1,boombox_tickets)
			var/boombox_type
			switch(boombox_lottery)
				if(1 to 2)
					boombox_type = /obj/item/pizzabox/bomb/armed //explodes after opening
				if(3)
					boombox_type = /obj/item/pizzabox/bomb //free bomb

			if(boombox_type)
				new boombox_type(C)
				qdel(P)
				boombox_provided = TRUE
				log_game("A pizza box bomb was created by a pizza crate delivery.")
				message_admins("A pizza box bomb has arrived in a pizza crate delivery.")
				continue

		//here we randomly replace our pizzas for a chance at the full range
		var/obj/item/food/pizza/replacement_type = pick_weight(pizza_types)
		pizza_types -= replacement_type
		if(replacement_type && !istype(P.pizza, replacement_type))
			QDEL_NULL(P.pizza)
			P.pizza = new replacement_type
			P.boxtag = P.pizza.boxtag
			P.boxtag_set = TRUE
			P.update_appearance()

/datum/supply_pack/organic/pizza/proc/anomalous_pizza_report()
	print_command_report("[station_name()], our anomalous materials divison has reported a missing object that is highly likely to have been sent to your station during a routine cargo \
	delivery. Please search all crates and manifests provided with the delivery and return the object if is located. The object resembles a standard <b>\[DATA EXPUNGED\]</b> and is to be \
	considered <b>\[REDACTED\]</b> and returned at your leisure. Note that objects the anomaly produces are specifically attuned exactly to the individual opening the anomaly; regardless \
	of species, the individual will find the object edible and it will taste great according to their personal definitions, which vary significantly based on person and species.")

/datum/supply_pack/organic/potted_plants
	name = "Potted Plants Crate"
	desc = "Spruce up the station with these lovely plants! Contains a random assortment of five potted plants from Artea's potted plant research division. Warranty void if thrown."
	cost = CARGO_CRATE_VALUE * 1.5
	contains = list(/obj/item/kirbyplants/random,
					/obj/item/kirbyplants/random,
					/obj/item/kirbyplants/random,
					/obj/item/kirbyplants/random,
					/obj/item/kirbyplants/random)
	container_name = "potted plants crate"
	container_type = /obj/structure/closet/crate/wooden

/datum/supply_pack/organic/seeds
	name = "Seeds Crate"
	desc = "Big things have small beginnings. Contains fifteen different seeds."
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/seeds/chili,
					/obj/item/seeds/cotton,
					/obj/item/seeds/berry,
					/obj/item/seeds/corn,
					/obj/item/seeds/eggplant,
					/obj/item/seeds/tomato,
					/obj/item/seeds/soya,
					/obj/item/seeds/wheat,
					/obj/item/seeds/wheat/rice,
					/obj/item/seeds/carrot,
					/obj/item/seeds/sunflower,
					/obj/item/seeds/rose,
					/obj/item/seeds/chanter,
					/obj/item/seeds/potato,
					/obj/item/seeds/sugarcane,
					/obj/item/seeds/cucumber)
	container_name = "seeds crate"
	container_type = /obj/structure/closet/crate/hydroponics

/datum/supply_pack/organic/randomized/chef/vegetables
	name = "Vegetables Crate"
	desc = "Grown in vats."
	cost = CARGO_CRATE_VALUE * 1.8
	contains = list(/obj/item/food/grown/chili,
					/obj/item/food/grown/corn,
					/obj/item/food/grown/tomato,
					/obj/item/food/grown/potato,
					/obj/item/food/grown/carrot,
					/obj/item/food/grown/mushroom/chanterelle,
					/obj/item/food/grown/onion,
					/obj/item/food/grown/pumpkin,
					/obj/item/food/grown/cucumber)
	container_name = "food crate"

/datum/supply_pack/organic/grill
	name = "Grilling Starter Kit"
	desc = "Hey dad I'm Hungry. Hi Hungry I'm THE NEW GRILLING STARTER KIT ONLY 5000 BUX GET NOW! Contains a grill and fuel."
	cost = CARGO_CRATE_VALUE * 8
	container_type = /obj/structure/closet/crate
	contains = list(/obj/item/stack/sheet/mineral/coal/five,
					/obj/machinery/grill/unwrenched,
					/obj/item/reagent_containers/cup/soda_cans/monkey_energy
					)
	container_name = "grilling starter kit crate"

/datum/supply_pack/organic/grillfuel
	name = "Grilling Fuel Kit"
	desc = "Contains propane and propane accessories. (Note: doesn't contain any actual propane.)"
	cost = CARGO_CRATE_VALUE * 4
	container_type = /obj/structure/closet/crate
	contains = list(/obj/item/stack/sheet/mineral/coal/ten,
					/obj/item/reagent_containers/cup/soda_cans/monkey_energy
					)
	container_name = "grilling fuel kit crate"

/datum/supply_pack/organic/tiziran_supply
	name = "Tiziran Supply Box"
	desc = "A packaged box of supplies from the heart of the Lizard Empire. Contains a selection of Tiziran ingredients and basic foods."
	cost = CARGO_CRATE_VALUE * 3
	contains = list(/obj/item/storage/box/tiziran_goods,
					/obj/item/storage/box/tiziran_cans,
					/obj/item/storage/box/tiziran_meats)
	container_name = "\improper Tiziran Supply box"
	container_type = /obj/structure/closet/crate/cardboard/tiziran

/datum/supply_pack/organic/mothic_supply
	name = "Mothic Supply Box"
	desc = "A packaged box of surplus supplies from the Mothic Fleet. Contains a selection of Mothic ingredients and basic foods."
	cost = CARGO_CRATE_VALUE * 3
	contains = list(/obj/item/storage/box/mothic_goods,
					/obj/item/storage/box/mothic_cans_sauces,
					/obj/item/storage/box/mothic_rations)
	container_name = "\improper Mothic Supply box"
	container_type = /obj/structure/closet/crate/cardboard/mothic

/datum/supply_pack/organic/syrup
	name = "Coffee Syrups Box"
	desc = "A packaged box of various syrups, perfect for making your delicious coffee even more diabetic."
	cost = CARGO_CRATE_VALUE * 4
	contains = list(
		/obj/item/reagent_containers/cup/bottle/syrup_bottle/caramel,
		/obj/item/reagent_containers/cup/bottle/syrup_bottle/liqueur,
		/obj/item/reagent_containers/cup/bottle/syrup_bottle/korta_nectar,
	)
	container_name = "coffee syrups box"
	container_type = /obj/structure/closet/crate/cardboard

/datum/supply_pack/organic/syrup_contraband
	contraband = TRUE
	name = "Contraband Syrups Box"
	desc = "A packaged box containing illegal coffee syrups. Possession of these carries a penalty established in the galactic penal code."
	cost = CARGO_CRATE_VALUE * 6
	contains = list(
		/obj/item/reagent_containers/cup/bottle/syrup_bottle/laughsyrup,
		/obj/item/reagent_containers/cup/bottle/syrup_bottle/laughsyrup,
	)
	container_name = "illegal syrups box"
	container_type = /obj/structure/closet/crate/cardboard
