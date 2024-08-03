
// Legacy preference toggles.
// !!! DO NOT ADD ANY NEW ONES HERE !!!
// Use `/datum/preference/toggle` instead.
#define SOUND_ADMINHELP (1<<0)
#define SOUND_MIDI (1<<1)
#define SOUND_AMBIENCE (1<<2)
#define SOUND_LOBBY (1<<3)
#define MEMBER_PUBLIC (1<<4)
#define SOUND_INSTRUMENTS (1<<7)
#define SOUND_SHIP_AMBIENCE (1<<8)
#define SOUND_PRAYERS (1<<9)
#define ANNOUNCE_LOGIN (1<<10)
#define SOUND_ANNOUNCEMENTS (1<<11)
#define DISABLE_DEATHRATTLE (1<<12)
#define DISABLE_ARRIVALRATTLE (1<<13)
#define COMBOHUD_LIGHTING (1<<14)
#define DEADMIN_ALWAYS (1<<15)
#define DEADMIN_ANTAGONIST (1<<16)
#define DEADMIN_POSITION_HEAD (1<<17)
#define DEADMIN_POSITION_SECURITY (1<<18)
#define DEADMIN_POSITION_SILICON (1<<19)
#define SOUND_ENDOFROUND (1<<20)
#define ADMIN_IGNORE_CULT_GHOST (1<<21)
#define SOUND_COMBATMODE (1<<22)
#define SPLIT_ADMIN_TABS (1<<23)

#define TOGGLES_DEFAULT (SOUND_ADMINHELP|SOUND_MIDI|SOUND_AMBIENCE|SOUND_LOBBY|SOUND_ENDOFROUND|MEMBER_PUBLIC|SOUND_INSTRUMENTS|SOUND_SHIP_AMBIENCE|SOUND_PRAYERS|SOUND_ANNOUNCEMENTS|SOUND_COMBATMODE)

// Legacy chat toggles.
// !!! DO NOT ADD ANY NEW ONES HERE !!!
// Use `/datum/preference/toggle` instead.
#define CHAT_OOC (1<<0)
#define CHAT_DEAD (1<<1)
#define CHAT_GHOSTEARS (1<<2)
#define CHAT_GHOSTSIGHT (1<<3)
#define CHAT_PRAYER (1<<4)
#define CHAT_PULLR (1<<6)
#define CHAT_GHOSTWHISPER (1<<7)
#define CHAT_GHOSTPDA (1<<8)
#define CHAT_GHOSTRADIO (1<<9)
#define CHAT_BANKCARD  (1<<10)
#define CHAT_GHOSTLAWS (1<<11)
#define CHAT_LOGIN_LOGOUT (1<<12)

#define TOGGLES_DEFAULT_CHAT (CHAT_OOC|CHAT_DEAD|CHAT_GHOSTEARS|CHAT_GHOSTSIGHT|CHAT_PRAYER|CHAT_PULLR|CHAT_GHOSTWHISPER|CHAT_GHOSTPDA|CHAT_GHOSTRADIO|CHAT_BANKCARD|CHAT_GHOSTLAWS|CHAT_LOGIN_LOGOUT)

#define PARALLAX_INSANE "Insane"
#define PARALLAX_HIGH "High"
#define PARALLAX_MED "Medium"
#define PARALLAX_LOW "Low"
#define PARALLAX_DISABLE "Disabled"

#define SCALING_METHOD_NORMAL "normal"
#define SCALING_METHOD_DISTORT "distort"
#define SCALING_METHOD_BLUR "blur"

#define PARALLAX_DELAY_DEFAULT world.tick_lag
#define PARALLAX_DELAY_MED 1
#define PARALLAX_DELAY_LOW 2

#define SEC_DEPT_NONE "None"
#define SEC_DEPT_ENGINEERING "Engineering"
#define SEC_DEPT_MEDICAL "Medical"
#define SEC_DEPT_SCIENCE "Science"
#define SEC_DEPT_SUPPLY "Supply"

// Playtime tracking system, see jobs_exp.dm
#define EXP_TYPE_LIVING "Living"
#define EXP_TYPE_CREW "Crew"
#define EXP_TYPE_COMMAND "Command"
#define EXP_TYPE_ENGINEERING "Engineering"
#define EXP_TYPE_PATHFINDERS "Pathfinders"
#define EXP_TYPE_MEDICAL "Medical"
#define EXP_TYPE_SCIENCE "Science"
#define EXP_TYPE_SUPPLY "Supply"
#define EXP_TYPE_SECURITY "Security"
#define EXP_TYPE_CIVILLIAN "Civillian"
#define EXP_TYPE_MISC "Miscellanous"
#define EXP_TYPE_SILICON "Silicon"
#define EXP_TYPE_SERVICE "Service"
#define EXP_TYPE_ANTAG "Antag"
#define EXP_TYPE_SPECIAL "Special"
#define EXP_TYPE_GHOST "Ghost"
#define EXP_TYPE_ADMIN "Admin"

//Flags in the players table in the db
#define DB_FLAG_EXEMPT 1

#define DEFAULT_CYBORG_NAME "Default Cyborg Name"


//Job preferences levels
#define JP_LOW 1
#define JP_MEDIUM 2
#define JP_HIGH 3

//randomised elements
#define RANDOM_ANTAG_ONLY 1
#define RANDOM_DISABLED 2
#define RANDOM_ENABLED 3

//recommened client FPS
#define RECOMMENDED_FPS 100

// randomise_appearance_prefs() and randomize_human_appearance() proc flags
#define RANDOMIZE_SPECIES (1<<0)
#define RANDOMIZE_NAME (1<<1)

// Values for /datum/preference/savefile_identifier
/// This preference is character specific.
#define PREFERENCE_CHARACTER "character"
/// This preference is account specific.
#define PREFERENCE_PLAYER "player"

// Values for /datum/preferences/current_tab
// Append _list to the end of values that arent main features for ease of readability.
/// Open the character preference window
#define PREFERENCE_TAB_CHARACTER_PREFERENCES 0

/// Open the game preferences window
#define PREFERENCE_TAB_GAME_PREFERENCES 1

/// Open the keybindings window
#define PREFERENCE_TAB_KEYBINDINGS 2

/// Any preferences that will show to the sides of the character in the setup menu.
#define PREFERENCE_CATEGORY_CLOTHING "clothing"

/// Any preferences that will show to the sides of the character in the setup menu.
#define PREFERENCE_CATEGORY_CLOTHING_LIST "clothing_list"

/// These will show in the appearance prefs tab.
#define PREFERENCE_CATEGORY_APPEARANCE "appearance"

/// These will show in the appearance prefs tab, in a list at the bottom. DO NOT USE FOR PREFS WITH ICONS.
#define PREFERENCE_CATEGORY_APPEARANCE_LIST "appearance_list"

/// These will show in the inspection prefs tab.
#define PREFERENCE_CATEGORY_INSPECTION_LIST "inspection_list"

/// These will show in the content prefs tab.
#define PREFERENCE_CATEGORY_CONTENT_LIST "content_list"

/// These will show in the OOC prefs tab.
#define PREFERENCE_CATEGORY_OOC_LIST "ooc_list"

/// These are preferences that are supplementary for main features,
/// such as hair color being affixed to hair.
#define PREFERENCE_CATEGORY_SUPPLEMENTAL_FEATURES "supplemental_features"

/// Preferences that have their own handling. Not to be confused with MISC_LIST.
#define PREFERENCE_CATEGORY_MISC "misc"

/// Preferences that will be put into the misc preferences tab.
#define PREFERENCE_CATEGORY_MISC_LIST "misc_list"

/// Will be put under the game preferences window.
#define PREFERENCE_CATEGORY_GAME_PREFERENCES "game_preferences"

// Playtime is tracked in minutes
/// The time needed to unlock hardcore random mode in preferences
#define PLAYTIME_HARDCORE_RANDOM 120 // 2 hours
/// The time needed to unlock the gamer cloak in preferences
#define PLAYTIME_VETERAN 300000 // 5,000 hours

/// Checks given content preference, returns FALSE if the value is "No" or "Prefer Not".
/// Not particularly performant, and arguably shitcode, so please don't use this inside large loops or hot procs.
#define CONTENT_PREFERENCE_CHECK(pref_value) (#pref_value != "No" && #pref_value != "Prefer Not")

// Synth brain preferences
#define ORGAN_PREF_POSI_BRAIN "Positronic Brain"
#define ORGAN_PREF_MMI_BRAIN "Man-Machine Interface"
#define ORGAN_PREF_CIRCUIT_BRAIN "Circuitboard"

/// Defines for what loadout slot a corresponding item belongs to.
#define LOADOUT_ITEM_BELT "belt"
#define LOADOUT_ITEM_EARS "ears"
#define LOADOUT_ITEM_GLASSES "glasses"
#define LOADOUT_ITEM_GLOVES "gloves"
#define LOADOUT_ITEM_HEAD "head"
#define LOADOUT_ITEM_MASK "mask"
#define LOADOUT_ITEM_NECK "neck"
#define LOADOUT_ITEM_SHOES "shoes"
#define LOADOUT_ITEM_SUIT "suit"
#define LOADOUT_ITEM_UNIFORM "under"
#define LOADOUT_ITEM_ACCESSORY "accessory"
#define LOADOUT_ITEM_INHAND "inhand_items"
#define LOADOUT_ITEM_MISC "pocket_items"

#define LOADOUT_DATA_GREYSCALE "greyscale"
#define LOADOUT_DATA_NAMED "name"
#define LOADOUT_DATA_RESKIN "reskin"
#define LOADOUT_DATA_LAYER "layer"

/// Used to make something not recolorable even if it's capable
#define LOADOUT_DONT_GREYSCALE -1

/// Defines for extra info blurbs, for loadout items.
#define TOOLTIP_NO_ARMOR "ARMORLESS - This item has no armor and is entirely cosmetic."
#define TOOLTIP_NO_DAMAGE "CEREMONIAL - This item has very low force and is cosmetic."
#define TOOLTIP_RANDOM_COLOR "RANDOM COLOR - This item has a random color and will change every round."
#define TOOLTIP_GREYSCALE "GREYSCALED - This item can be customized via the greyscale modification UI."
#define TOOLTIP_RENAMABLE "RENAMABLE - This item can be given a custom name."
#define TOOLTIP_RESKINNABLE "RESKINNABLE - This item can be reskinned."

/// Global list of ALL loadout datums instantiated.
GLOBAL_LIST_EMPTY(all_loadout_datums)

/// Global list of all loadout categories singletons
/// This is global (rather than just static on the loadout middleware datum)
/// just so we can ensure it is loaded regardless of whether someone opens the loadout UI
/// (because it also inits our loadout datums)
GLOBAL_LIST_INIT(loadout_categories, init_loadout_categories())

#define BLOOM_HIGH    0
#define BLOOM_MED     1 //default.
#define BLOOM_LOW     2
#define BLOOM_DISABLE 3 //this option must be the highest number
