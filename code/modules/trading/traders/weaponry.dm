/datum/trader/gunshop
	name = "Gun Shop Employee"
	pack_groups = list(TRADER_GROUP_ARMORY)
	possible_origins = list("Rooty Tootie's Point-n-Shooties", "Bang-Bang Shop", "Wild Wild West Shop", "Keleshnikov", "Hunting Depot", "Big Game Hunters")
	speech = list("hail"    = "Hello, hello! I hope you have your permit. Oh, who are we kidding, you're welcome anyway!",
				"hail_deny"         = "Store policy dictates that you can fuck off.",

				"trade_complete"    = "Thanks for buying your guns from ORIGIN!",
				"trade_no_goods"    = "Cash for guns, thats the deal.",
				"trade_not_enough"  = "Guns are expensive! Give us more if you REALLY want it.",
				"how_much"          = "Well, I'd love to give this little beauty to you for VALUE.",

				"compliment_deny"   = "If we were in the same room right now, I'd probably punch you.",
				"compliment_accept" = "Ha! Good one!",
				"insult_good"       = "I expected better from you. I suppose in that, I was wrong.",
				"insult_bad"        = "If I had my gun I'd shoot you!")
	possible_bounties = list(
		/datum/trader_bounty/gun_celebration_day = 150,
		/datum/trader_bounty/reagent/ammo_requisition = 200,
		/datum/trader_bounty/reagent/explosive_ammo = 100
		)

/datum/trader/egunshop
	name = "Energy Gun Shop Employee"
	pack_groups = list(TRADER_GROUP_ARMORY)
	possible_origins = list("The Emperor's Lasgun Shop", "Future Guns", "Solar Army", "Kiefer's Dependable Electric Arms", "Olympus Kingsport")
	speech = list("hail"    = "Welcome to the future of warfare! ORIGIN, your one-stop shop for energy weaponry!",
				"hail_deny"         = "I'm sorry, your communication channel has been blacklisted.",

				"trade_complete"    = "Thank you, your purchase has been logged and you have automatically liked our Spacebook page.",
				"trade_no_goods"    = "We deal in cash.",
				"trade_not_enough"  = "State of the art weaponry costs more than that.",
				"how_much"          = "All our quality weapons are priceless, but I'd give that to you for VALUE.",

				"compliment_deny"   = "If I was dumber I probably would have believed you.",
				"compliment_accept" = "Yes, I am very smart.",
				"insult_good"       = "Energy weapons are TWICE the gun kinetic guns are!",
				"insult_bad"        = "That's... very mean. I won't think twice about blacklisting your channel, so stop.")
	possible_bounties = list(
		/datum/trader_bounty/anomalous_energy_sources = 100,
		/datum/trader_bounty/unlimited_power = 100
		)
