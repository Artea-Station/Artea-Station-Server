//Cash amounts the traders get
#define DEFAULT_TRADER_CREDIT_AMOUNT 7000
#define RICH_TRADER_CREDIT_AMOUNT 15000
#define POOR_TRADER_CREDIT_AMOUNT 3500
#define VERY_POOR_TRADER_CREDIT_AMOUNT 1500

//Every time SStrading ticks, if the traders have cash below a threshold they'll gain a small injection of cash
#define TRADER_LOW_CASH_THRESHOLD 50 //In percentage
#define TRADER_PAYCHECK_LOW 500
#define TRADER_PAYCHECK_HIGH 1500

/// Percentage threshold of remaining stock at which they should restock that item
#define TRADER_RESTOCK_THRESHOLD 0.5

// The possible trades a trader can hold.
#define TRADER_GROUP_ARMORY "Armory"
#define TRADER_GROUP_COSTUMES_AND_TOYS "Costumes & Toys"
#define TRADER_GROUP_EMERGENCY "Emergency"
#define TRADER_GROUP_ENGINE_CONSTRUCTION "Engine Construction"
#define TRADER_GROUP_ENGINEERING "Engineering"
#define TRADER_GROUP_GALACTIC_IMPORTS "Galactic Imports"
#define TRADER_GROUP_GOODIES "Goodies"
#define TRADER_GROUP_LIVESTOCK "Livestock"
#define TRADER_GROUP_MEDICAL "Medical"
#define TRADER_GROUP_MISC "Misc"
#define TRADER_GROUP_FOOD_AND_HYDROPONICS "Food & Hydroponics"
#define TRADER_GROUP_SCIENCE "Science"
#define TRADER_GORUP_SECURITY "Security"
#define TRADER_GORUP_SERVICE "Service"
#define TRADER_GORUP_VENDING_RESTOCKS "Vending Restocks"

// The kind of box a supply box is. Decides icons and the material dropped when deconstructed.
#define SUPPLY_BOX_WOOD 1
#define SUPPLY_BOX_METAL 2
#define SUPPLY_BOX_MILITARY 3

#define TRADE_USER_SUFFIX_AI "ai"
#define TRADE_USER_SUFFIX_CYBORG "silicon"
#define TRADE_USER_SUFFIX_GOLEM "golem"
#define TRADE_USER_SUFFIX_ROBOT_PERSON "robotperson"

/*
All of these can have a suffix of _<suffix>. These can be species IDs, or the above TRADE_USER_SUFFIX defines.

hail_generic //When the trader hails the person
hail_deny //When the trader denies the hail

trade_show_goods //What the trader says when showing goods
trade_no_sell_goods //What the trader says when disclaiming that he doesnt sell goods

what_want //When showing what items he buys
trade_no_goods //When disclaiming he doesnt buy items

compliment_deny //When denies a compliment
compliment_accept //When accepts a compliment

insult_bad //When he's pissed off at an inuslt
insult_good //When he doesnt mind the insult much

pad_empty //When you try and conduct selling but your pad is empty

how_much //When he appraises the value of item. ITEM = item name, VALUE = amount of cash worth
appraise_multiple //When he appraises the value of multiple items.  VALUE = amount of cash worth

trade_found_unwanted //When there's only items that they dont want on the pad
out_of_money //When the trader's out of money to pay us for stuff
doesnt_use_cash //When he disclaims that he doesnt use cash

trade_complete //Sentence after a successful trade
trade_not_enough //Sentence when the trader rejects a barter offer
out_of_stock //The trader is out of stock on an item the user wants to buy
user_no_money //When the user doesnt have enough money to perform a trade
only_deal_in_goods //When the user tries to sell items for money, but the trader doesnt deal in money

bounty_fail_claim //When the user tries to turn in a bounty, but doesn't meet the requirements
*/
