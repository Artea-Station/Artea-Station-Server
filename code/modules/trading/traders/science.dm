/datum/trader/scrapper
	name = "Scrappers"
	pack_groups = list(TRADER_GROUP_SCIENCE, TRADER_GROUP_MISC)
	possible_origins = list("Scrappers-R-Us", "Scrap-Mart", "Scrap-U")
	speech = list(
		"hail" = "Welcome to ORIGIN! Let me walk you through our fine scrap selection! Pah, we got this junk from somewhere out in space.",
		"hail_silicon" = "Welcome to ORIGIN! Ah, you'll be here soon enough, I'm sure!",
		"hail_deny" = "ORIGIN no longer wants to speak to you.",

		"trade_complete" = "ORIGIN! You'll be here one day!",
		"trade_no_goods" = "You're offering us what?!",
		"trade_not_enough" = "Cash, my friend. You don't got no money!",
		"how_much" = "This pile of crap will cost you VALUE!",

		"compliment_deny" = "Well, I almost believed that.",
		"compliment_accept" = "Thank you! My scrapheap is my life.",
		"insult_good" = "Uncalled for.... uncalled for.",
		"insult_bad" = "I've found scrap more insulting than you!",
	)
	possible_bounties = list(
		/datum/trader_bounty/heavy_lifting = 100,
		/datum/trader_bounty/stack/seeing_diamonds = 100,
		/datum/trader_bounty/reagent/ammo_requisition = 100,
		/datum/trader_bounty/reagent/medicine_easy = 100,
	)
	possible_supplies_bounties = list(
		/datum/trader_bounty/engineering_supplies = 100,
		/datum/trader_bounty/medical_supplies = 100,
	)
	guaranteed_packs = list(
		/datum/supply_pack/tech_disk/major,
		/datum/supply_pack/tech_disk/middle,
		/datum/supply_pack/tech_disk/minor,
	)
