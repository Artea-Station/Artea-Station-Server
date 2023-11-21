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
#define TRADER_GROUP_SECURITY "Security"
#define TRADER_GROUP_SERVICE "Service"
#define TRADER_GROUP_VENDING_RESTOCKS "Vending Restocks"
#define TRADER_GROUP_TECH_DISKS "Tech Disks"

// The kind of box a supply box is. Decides icons and the material dropped when deconstructed.
#define SUPPLY_BOX_WOOD 1
#define SUPPLY_BOX_METAL 2
#define SUPPLY_BOX_MILITARY 3

#define TRADE_USER_SUFFIX_AI "ai"
#define TRADE_USER_SUFFIX_CYBORG "silicon"
#define TRADE_USER_SUFFIX_GOLEM "golem"
#define TRADE_USER_SUFFIX_SYNTH "synth"
