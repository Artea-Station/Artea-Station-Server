///called when an item is used as an ingredient: (atom/customized)
#define COMSIG_ITEM_USED_AS_INGREDIENT "item_used_as_ingredient"
///called when an edible ingredient is added: (datum/component/edible/ingredient)
#define COMSIG_EDIBLE_INGREDIENT_ADDED "edible_ingredient_added"

//Food

///from Edible component: (mob/living/eater, mob/feeder, bitecount, bitesize)
#define COMSIG_FOOD_EATEN "food_eaten"
///from base of datum/component/edible/on_entered: (mob/crosser, bitecount)
#define COMSIG_FOOD_CROSSED "food_crossed"

///from base of Component/edible/On_Consume: (mob/living/eater, mob/living/feeder)
#define COMSIG_FOOD_CONSUMED "food_consumed"
/// called when a pill is injested (mob/living/eater, mob/living/feeder)
#define COMSIG_PILL_CONSUMED "pill_consumed"

///from base of Component/edible/on_silver_slime_reaction: (obj/item/source)
#define COMSIG_FOOD_SILVER_SPAWNED "food_silver_spawned"

#define COMSIG_ITEM_FRIED "item_fried"
#define COMSIG_FRYING_HANDLED (1<<0)

#define COMSIG_ITEM_GRILL_PLACED "item_placed_on_griddle"
///Called when a griddle is turned on
#define COMSIG_ITEM_GRILL_TURNED_ON "item_grill_turned_on"
///Called when a griddle is turned off
#define COMSIG_ITEM_GRILL_TURNED_OFF "item_grill_turned_off"

//Drink

///from base of obj/item/reagent_containers/cup/attack(): (mob/M, mob/user)
#define COMSIG_GLASS_DRANK "glass_drank"
