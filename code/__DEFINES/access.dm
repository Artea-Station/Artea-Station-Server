
/*  Access is broken down by department, department special functions/rooms, and departmental roles
*	The first access for the department will always be its general access function
*	Please try to make the strings for any new accesses as close to the name of the define as possible
*	If you are going to add an access to the list, make sure to also add it to its respective region further below
*	If you're varediting on the map, it uses the string. If you're editing the object directly, use the define name
*/

#define ACCESS_COMMAND_LOWSEC "command_lowsec"
#define ACCESS_COMMAND_HIGHSEC "command_highsec"
#define ACCESS_COMMAND_VEHICLES "command_vehicles"

#define ACCESS_ENGINEERING_LOWSEC "engineering_lowsec"
#define ACCESS_ENGINEERING_HIGHSEC "engineering_highsec"
#define ACCESS_ENGINEERING_VEHICLES "engineering_vehicles"
#define ACCESS_ENGINEERING_HEAD "engineering_head"

#define ACCESS_MEDICAL_LOWSEC "medical_lowsec"
#define ACCESS_MEDICAL_HIGHSEC "medical_highsec"
#define ACCESS_MEDICAL_VEHICLES "medical_vehicles"
#define ACCESS_MEDICAL_HEAD "medical_head"

#define ACCESS_PATHFINDERS_LOWSEC "pathfinders_lowsec"
#define ACCESS_PATHFINDERS_HIGHSEC "pathfinders_highsec"
#define ACCESS_PATHFINDERS_VEHICLES "pathfinders_vehicles"
#define ACCESS_PATHFINDERS_HEAD "pathfinders_head"

#define ACCESS_SECURITY_LOWSEC "security_lowsec"
#define ACCESS_SECURITY_HIGHSEC "security_highsec"
#define ACCESS_SECURITY_VEHICLES "security_vehicles"
#define ACCESS_SECURITY_HEAD "security_head"

#define ACCESS_SERVICE_LOWSEC "service_lowsec"
#define ACCESS_SERVICE_HIGHSEC "service_highsec"
#define ACCESS_SERVICE_VEHICLES "service_vehicles"

#define ACCESS_CARGO_LOWSEC "cargo_lowsec"
#define ACCESS_CARGO_HIGHSEC "cargo_highsec"
#define ACCESS_CARGO_VEHICLES "cargo_vehicles"
#define ACCESS_CARGO_HEAD "cargo_head"

#define ACCESS_SYNDICATE_LOWSEC "syndicate_lowsec"
#define ACCESS_SYNDICATE_HIGHSEC "syndicate_highsec"
#define ACCESS_SYNDICATE_VEHICLES "syndicate_vehicles"

#define ACCESS_CENTCOM_LOWSEC "centcom_lowsec"
#define ACCESS_CENTCOM_HIGHSEC "centcom_highsec"
#define ACCESS_CENTCOM_VEHICLES "centcom_vehicles"

#define ACCESS_SPECIAL_CAPTAIN "special_captain"
#define ACCESS_SPECIAL_WEAPONS "special_weapons"
#define ACCESS_SPECIAL_THUNDERDOME "special_thunderdome"
#define ACCESS_SPECIAL_BLOODCULT "special_bloodcult"

#define ACCESS_ANY_VAULT "command_highsec", "cargo_highsec"
#define ACCESS_ANY_ROBOTICS "engineering_highsec", "medical_highsec"

#define ACCESS_ARTEA_COMMON "artea_common"

/// - - - AWAY MISSIONS - - -
/*For generic away-mission/ruin access. Why would normal crew have access to a long-abandoned derelict
	or a 2000 year-old temple? */
#define ACCESS_AWAY_GENERAL "away_general"
#define ACCESS_AWAY_COMMAND "away_command"
#define ACCESS_AWAY_SEC "away_sec"
#define ACCESS_AWAY_ENGINEERING "away_engineering"
#define ACCESS_AWAY_MEDICAL "away_medical"
#define ACCESS_AWAY_SUPPLY "away_supply"
#define ACCESS_AWAY_SCIENCE "away_science"
#define ACCESS_AWAY_MAINTENANCE "away_maintenance"
#define ACCESS_AWAY_GENERIC1 "away_generic1"
#define ACCESS_AWAY_GENERIC2 "away_generic2"
#define ACCESS_AWAY_GENERIC3 "away_generic3"
#define ACCESS_AWAY_GENERIC4 "away_generic4"

/// - - - END ACCESS IDS - - -

/// A list of access levels that, when added to an ID card, will warn admins.
#define ACCESS_ALERT_ADMINS list(ACCESS_COMMAND_LOWSEC, ACCESS_COMMAND_HIGHSEC)

/// Logging define for ID card access changes
#define LOG_ID_ACCESS_CHANGE(user, id_card, change_description) \
	log_game("[key_name(user)] [change_description] to an ID card [(id_card.registered_name) ? "belonging to [id_card.registered_name]." : "with no registered name."]"); \
	user.investigate_log("([key_name(user)]) [change_description] to an ID card [(id_card.registered_name) ? "belonging to [id_card.registered_name]." : "with no registered name."]", INVESTIGATE_ACCESSCHANGES); \
	user.log_message("[change_description] to an ID card [(id_card.registered_name) ? "belonging to [id_card.registered_name]." : "with no registered name."]", LOG_GAME); \

/// Used in ID card access adding procs. Will try to add all accesses and utilises free wildcards, skipping over any accesses it can't add.
#define TRY_ADD_ALL 0
/// Used in ID card access adding procs. Will try to add all accesses and does not utilise wildcards, skipping anything requiring a wildcard.
#define TRY_ADD_ALL_NO_WILDCARD 1
/// Used in ID card access adding procs. Will forcefully add all accesses.
#define FORCE_ADD_ALL 2
/// Used in ID card access adding procs. Will stack trace on fail.
#define ERROR_ON_FAIL 3

/// All accesses to their names. Keep up to date.
#define ALL_ACCESS_NAMES list( \
	ACCESS_ARTEA_COMMON = "Artea Common", \
	ACCESS_COMMAND_LOWSEC = "Low Security Command", \
	ACCESS_COMMAND_HIGHSEC = "High Security Command", \
	ACCESS_COMMAND_VEHICLES = "Command Vehicles", \
	ACCESS_ENGINEERING_LOWSEC = "Low Security Engineering", \
	ACCESS_ENGINEERING_HIGHSEC = "High Security Engineering", \
	ACCESS_ENGINEERING_VEHICLES = "Engineering Vehicles", \
	ACCESS_ENGINEERING_HEAD = "Chief Engineer", \
	ACCESS_MEDICAL_LOWSEC = "Low Security Medical", \
	ACCESS_MEDICAL_HIGHSEC = "High Security Medical", \
	ACCESS_MEDICAL_VEHICLES = "Medical Vehicles", \
	ACCESS_MEDICAL_HEAD = "Chief Medical Officer", \
	ACCESS_PATHFINDERS_LOWSEC = "Low Security Pathfinders", \
	ACCESS_PATHFINDERS_HIGHSEC = "High Security Pathfinders", \
	ACCESS_PATHFINDERS_VEHICLES = "Pathfinders Vehicles", \
	ACCESS_PATHFINDERS_HEAD = "Lead Pathfinder", \
	ACCESS_SECURITY_LOWSEC = "Low Security Security", \
	ACCESS_SECURITY_HIGHSEC = "High Security Security", \
	ACCESS_SECURITY_VEHICLES = "Security Vehicles", \
	ACCESS_SECURITY_HEAD = "Head of Security", \
	ACCESS_SERVICE_LOWSEC = "Low Security Service", \
	ACCESS_SERVICE_HIGHSEC = "High Security Service", \
	ACCESS_SERVICE_VEHICLES = "Service Vehicles", \
	ACCESS_CARGO_LOWSEC = "Low Security Cargo", \
	ACCESS_CARGO_HIGHSEC = "High Security Cargo", \
	ACCESS_CARGO_VEHICLES = "Cargo Vehicles", \
	ACCESS_CARGO_HEAD = "Quartermaster", \
	ACCESS_SYNDICATE_LOWSEC = "Low Security Syndicate", \
	ACCESS_SYNDICATE_HIGHSEC = "High Security Syndicate", \
	ACCESS_SYNDICATE_VEHICLES = "Syndicate Vehicles", \
	ACCESS_CENTCOM_LOWSEC = "Low Security Central Command", \
	ACCESS_CENTCOM_HIGHSEC = "High Security Central Command", \
	ACCESS_CENTCOM_VEHICLES = "Central Command Vehicles", \
	ACCESS_SPECIAL_CAPTAIN = "Captain", \
	ACCESS_SPECIAL_WEAPONS = "Weapons Permit", \
	ACCESS_SPECIAL_THUNDERDOME = "Thunderdome", \
	ACCESS_SPECIAL_BLOODCULT = "Blood Cult", \
)

#define ACCESS_REGIONS_STATION list( \
	ACCESS_REGION_STATION_HEADS, \
	ACCESS_REGION_COMMAND, \
	ACCESS_REGION_ENGINEERING, \
	ACCESS_REGION_MEDICAL, \
	ACCESS_REGION_PATHFINDERS, \
	ACCESS_REGION_SECURITY, \
	ACCESS_REGION_SERVICE, \
	ACCESS_REGION_CARGO, \
)

#define ACCESS_REGION_STATION_HEADS list( \
	ACCESS_ENGINEERING_HEAD, \
	ACCESS_MEDICAL_HEAD, \
	ACCESS_PATHFINDERS_HEAD, \
	ACCESS_SECURITY_HEAD, \
	ACCESS_CARGO_HEAD, \
)

#define ACCESS_REGION_COMMAND list( \
	ACCESS_COMMAND_LOWSEC, \
	ACCESS_COMMAND_HIGHSEC, \
	ACCESS_COMMAND_VEHICLES, \
)

#define ACCESS_REGION_ENGINEERING list( \
	ACCESS_ENGINEERING_LOWSEC, \
	ACCESS_ENGINEERING_HIGHSEC, \
	ACCESS_ENGINEERING_VEHICLES, \
)

#define ACCESS_REGION_MEDICAL list( \
	ACCESS_MEDICAL_LOWSEC, \
	ACCESS_MEDICAL_HIGHSEC, \
	ACCESS_MEDICAL_VEHICLES, \
)

#define ACCESS_REGION_PATHFINDERS list( \
	ACCESS_PATHFINDERS_LOWSEC, \
	ACCESS_PATHFINDERS_HIGHSEC, \
	ACCESS_PATHFINDERS_VEHICLES, \
)

#define ACCESS_REGION_SECURITY list( \
	ACCESS_SECURITY_LOWSEC, \
	ACCESS_SECURITY_HIGHSEC, \
	ACCESS_SECURITY_VEHICLES, \
)

#define ACCESS_REGION_SERVICE list( \
	ACCESS_SERVICE_LOWSEC, \
	ACCESS_SERVICE_HIGHSEC, \
	ACCESS_SERVICE_VEHICLES, \
)

#define ACCESS_REGION_CARGO list( \
	ACCESS_CARGO_LOWSEC, \
	ACCESS_CARGO_HIGHSEC, \
	ACCESS_CARGO_VEHICLES, \
)

#define ALL_REGION_NAMES list( \
	ACCESS_REGION_STATION_HEADS = "Heads", \
	ACCESS_REGION_COMMAND = "Command", \
	ACCESS_REGION_ENGINEERING = "Engineering", \
	ACCESS_REGION_MEDICAL = "Medical", \
	ACCESS_REGION_PATHFINDERS = "Pathfinders", \
	ACCESS_REGION_SECURITY = "Security", \
	ACCESS_REGION_SERVICE = "Service", \
	ACCESS_REGION_CARGO = "Cargo", \
)
