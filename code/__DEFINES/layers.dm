//Defines for atom layers and planes
//KEEP THESE IN A NICE ACSCENDING ORDER, PLEASE

//NEVER HAVE ANYTHING BELOW THIS PLANE ADJUST IF YOU NEED MORE SPACE
#define LOWEST_EVER_PLANE -200

#define CLICKCATCHER_PLANE -99

#define PLANE_SPACE -95
#define PLANE_SPACE_PARALLAX -90

#define HEAT_PLANE -12
#define HEAT_RENDER_TARGET "*HEAT_RENDER_TARGET"
#define HEAT_COMPOSITE_RENDER_TARGET "*HEAT_RENDER_TARGET_C"

#define GRAVITY_PULSE_PLANE -12
#define GRAVITY_PULSE_RENDER_TARGET "*GRAVPULSE_RENDER_TARGET"

#define TRANSPARENT_FLOOR_PLANE -11 //Transparent plane that shows openspace underneath the floor
#define OPENSPACE_PLANE -10 //Openspace plane below all turfs
#define OPENSPACE_BACKDROP_PLANE -9 //Black square just over openspace plane to guaranteed cover all in openspace turf


#define FLOOR_PLANE -8

#define GAME_PLANE -7

// PLANE_SPACE layer(s)
#define SPACE_LAYER 1.8
#define ROOF_LAYER 1.9 // Used by lifts and shuttles to show a roof, but under turf so it's easy to hide when it isn't needed ;)

//#define TURF_LAYER 2 //For easy recordkeeping; this is a byond define. Most floors (FLOOR_PLANE) and walls (GAME_PLANE) use this.

// GAME_PLANE layers
#define CULT_OVERLAY_LAYER 2.01
#define MID_TURF_LAYER 2.02
#define HIGH_TURF_LAYER 2.03
#define TURF_PLATING_DECAL_LAYER 2.031
#define TURF_DECAL_LAYER 2.039 //Makes turf decals appear in DM how they will look inworld.
#define ABOVE_OPEN_TURF_LAYER 2.04
#define CLOSED_TURF_LAYER 2.05
#define BULLET_HOLE_LAYER 2.06
#define ABOVE_NORMAL_TURF_LAYER 2.08
#define LATTICE_LAYER 2.2
#define DISPOSAL_PIPE_LAYER 2.3
#define GAS_PIPE_HIDDEN_LAYER 2.35 //layer = initial(layer) + piping_layer / 1000 in atmospherics/update_icon() to determine order of pipe overlap
#define WIRE_LAYER 2.4
#define WIRE_BRIDGE_LAYER 2.44
#define WIRE_TERMINAL_LAYER 2.45
#define GAS_SCRUBBER_LAYER 2.46
#define GAS_PIPE_VISIBLE_LAYER 2.47 //layer = initial(layer) + piping_layer / 1000 in atmospherics/update_icon() to determine order of pipe overlap
#define GAS_FILTER_LAYER 2.48
#define GAS_PUMP_LAYER 2.49
#define PLUMBING_PIPE_VISIBILE_LAYER 2.495//layer = initial(layer) + ducting_layer / 3333 in atmospherics/handle_layer() to determine order of duct overlap
#define LOW_OBJ_LAYER 2.5
///catwalk overlay of /turf/open/floor/plating/catwalk_floor
#define CATWALK_LAYER 2.51
#define LOW_SIGIL_LAYER 2.52
#define SIGIL_LAYER 2.53
#define HIGH_PIPE_LAYER 2.54
// Anything aboe this layer is not "on" a turf for the purposes of washing
// I hate this life of ours
#define FLOOR_CLEAN_LAYER 2.55
#define BELOW_OPEN_DOOR_LAYER 2.6
#define BLASTDOOR_LAYER 2.65
#define SHUTTER_LAYER 2.67
#define OPEN_DOOR_LAYER 2.7
#define DOOR_ACCESS_HELPER_LAYER 2.71 //keep this above OPEN_DOOR_LAYER, special layer used for /obj/effect/mapping_helpers/bulkhead/access
#define DOOR_HELPER_LAYER 2.72 //keep this above DOOR_ACCESS_HELPER_LAYER and OPEN_DOOR_LAYER since the others tend to have tiny sprites that tend to be covered up.
#define PROJECTILE_HIT_THRESHHOLD_LAYER 2.75 //projectiles won't hit objects at or below this layer if possible
#define TABLE_LAYER 2.8
#define GATEWAY_UNDERLAY_LAYER 2.85
#define LOW_WALL_LAYER 2.86
#define BELOW_OBJ_LAYER 2.9
#define LOW_ITEM_LAYER 2.95

//#define OBJ_LAYER 3 //For easy recordkeeping; this is a byond define
#define CLOSED_DOOR_LAYER 3.1
#define CLOSED_FIREDOOR_LAYER 3.11
#define ABOVE_OBJ_LAYER 3.2
#define SHUTTER_LAYER_CLOSED 3.21
#define CLOSED_BLASTDOOR_LAYER 3.22
#define LOW_WALL_STRIPE_LAYER 3.25
#define ABOVE_WINDOW_LAYER 3.3
#define SIGN_LAYER 3.4
#define CORGI_ASS_PIN_LAYER 3.41
#define NOT_HIGH_OBJ_LAYER 3.5
#define HIGH_OBJ_LAYER 3.6
#define BELOW_MOB_LAYER 3.7
#define LOW_MOB_LAYER 3.75
#define LYING_MOB_LAYER 3.8
#define VEHICLE_LAYER 3.9
#define MOB_BELOW_PIGGYBACK_LAYER 3.94

//#define MOB_LAYER 4 //For easy recordkeeping; this is a byond define
#define MOB_SHIELD_LAYER 4.01
#define MOB_ABOVE_PIGGYBACK_LAYER 4.06
#define MOB_UPPER_LAYER 4.07
#define HITSCAN_PROJECTILE_LAYER 4.09
#define ABOVE_MOB_LAYER 4.1
#define WALL_OBJ_LAYER 4.25
#define EDGED_TURF_LAYER 4.3
#define ON_EDGED_TURF_LAYER 4.35
#define SPACEVINE_LAYER 4.4
#define LARGE_MOB_LAYER 4.5
#define SPACEVINE_MOB_LAYER 4.6

// Intermediate layer used by both GAME_PLANE_FOV_HIDDEN and ABOVE_GAME_PLANE
#define ABOVE_ALL_MOB_LAYER 4.7

//#define FLY_LAYER 5 //For easy recordkeeping; this is a byond define
#define GAS_LAYER 5
#define GASFIRE_LAYER 5.05
#define RIPPLE_LAYER 5.1

#define OPENSPACE_LAYER 600 //Openspace layer over all

#define BLACKNESS_PLANE 0 //To keep from conflicts with SEE_BLACKNESS internals

#define AREA_PLANE 60
#define MASSIVE_OBJ_PLANE 70
#define GHOST_PLANE 80
#define POINT_PLANE 90

//---------- LIGHTING -------------
///Normal 1 per turf dynamic lighting underlays
#define LIGHTING_PLANE 100
#define LIGHTING_EXPOSURE_PLANE 101 // Light sources "cones"
#define LIGHTING_LAMPS_SELFGLOW 102 // Light sources glow (lamps, doors overlay, etc.)
#define LIGHTING_LAMPS_PLANE 103 // Light sources themselves (lamps, screens, etc.)
#define LIGHTING_LAMPS_GLARE 104 // Light glare (optional setting)
#define LIGHTING_LAMPS_RENDER_TARGET "*LIGHTING_LAMPS_RENDER_TARGET"

///Lighting objects that are "free floating"
#define O_LIGHTING_VISUAL_PLANE 110
#define O_LIGHTING_VISUAL_RENDER_TARGET "O_LIGHT_VISUAL_PLANE"

#define DAY_NIGHT_LIGHTING_LAYER 100

///Things that should render ignoring lighting
#define ABOVE_LIGHTING_PLANE 120

// LIGHTING_PLANE layers
// The layer of turf underlays starts at 0.01 and goes up by 0.01
// Based off the z level. No I do not remember why, should check that

/// Typically overlays, that "hide" portions of the turf underlay layer
/// I'm allotting 100 z levels before this breaks. That'll never happen
/// --Lemon
#define LIGHTING_MASK_LAYER 10
#define LIGHTING_PRIMARY_LAYER 15	//The layer for the main lights of the station
#define LIGHTING_PRIMARY_DIMMER_LAYER 15.1	//The layer that dims the main lights of the station
#define LIGHTING_SECONDARY_LAYER 16	//The colourful, usually small lights that go on top


///visibility + hiding of things outside of light source range
#define BYOND_LIGHTING_PLANE 130


//---------- EMISSIVES -------------
//Layering order of these is not particularly meaningful.
//Important part is the seperation of the planes for control via plane_master

/// This plane masks out lighting to create an "emissive" effect, ie for glowing lights in otherwise dark areas.
#define EMISSIVE_PLANE 150
/// The render target used by the emissive layer.
#define EMISSIVE_RENDER_TARGET "*EMISSIVE_PLANE"
/// The layer you should use if you _really_ don't want an emissive overlay to be blocked.
#define EMISSIVE_LAYER_UNBLOCKABLE 9999

///---------------- MISC -----------------------

///Pipecrawling images
#define PIPECRAWL_IMAGES_PLANE 180

///AI Camera Static
#define CAMERA_STATIC_PLANE 200

///Debug Atmos Overlays
#define ATMOS_GROUP_PLANE 450

///--------------- FULLSCREEN IMAGES ------------

#define FULLSCREEN_PLANE 500
#define FLASH_LAYER 1
#define FULLSCREEN_LAYER 2
#define UI_DAMAGE_LAYER 3
#define BLIND_LAYER 4
#define CRIT_LAYER 5
#define CURSE_LAYER 6
#define FOV_EFFECTS_LAYER 10000 //Blindness effects are not layer 4, they lie to you

///--------------- FULLSCREEN RUNECHAT BUBBLES ------------

///Popup Chat Messages
#define RUNECHAT_PLANE 501
/// Plane for balloon text (text that fades up)
#define BALLOON_CHAT_PLANE 502
/// Bubble for typing indicators
#define TYPING_LAYER 500

//-------------------- HUD ---------------------
//HUD layer defines
#define HUD_PLANE 1000
#define ABOVE_HUD_PLANE 1100

#define RADIAL_BACKGROUND_LAYER 0
///1000 is an unimportant number, it's just to normalize copied layers
#define RADIAL_CONTENT_LAYER 1000

#define ADMIN_POPUP_LAYER 1

///Layer for screentips
#define SCREENTIP_LAYER 4

///Plane of the "splash" icon used that shows on the lobby screen. only render plate planes should be above this
#define SPLASHSCREEN_PLANE 9900

//-------------------- Rendering ---------------------
#define RENDER_PLANE_GAME 9990
#define RENDER_PLANE_NON_GAME 9995
#define RENDER_PLANE_MASTER 9999
//----------------------------------------------------

// Lobby screen layers
#define LOBBY_FADE_LAYER 3
#define LOBBY_BACKGROUND_LAYER 3.01
#define LOBBY_BUTTON_LAYER 4

///cinematics are "below" the splash screen
#define CINEMATIC_LAYER -1

///Plane master controller keys
#define PLANE_MASTERS_GAME "plane_masters_game"
#define PLANE_MASTERS_COLORBLIND "plane_masters_colorblind"
