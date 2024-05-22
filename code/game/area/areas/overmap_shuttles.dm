// DM file specifically for shuttles built for overmap use. We want to phase out all non-overmap-built shuttles for something more appropriate, using standard shuttle sizes.

/area/shuttle/overmap
	requires_power = TRUE
	allow_door_remotes = TRUE

// Shuttles that are logistical in nature. Public shuttles typically fall into this category, despite being barely functional at all.
/area/shuttle/overmap/alv_s
	name = "Generic Logistic Shuttle - Do not use directly."

/area/shuttle/overmap/alv_s/boxt
	name = "\improper ALV-S Boxt"

/area/shuttle/overmap/alv_s/jalopy
	name = "\improper ALV-S Jalopy"

// Shuttles that are for emergency use. This is typically medical or emergency evac shuttles.
/area/shuttle/overmap/aev_s
	name = "Generic Emergency Shuttle - Do not use directly."

/area/shuttle/overmap/aev_s/wellwagon
	name = "AEV-S Wellwagon"

// Shuttles that are for pathfinder use. These are typically much higher quality than the shuttles above in this file.
/area/shuttle/overmap/aev_p
	name = "Generic Pathfinder Shuttle - Do not use directly."

/area/shuttle/overmap/aev_p/astrum
	name = "APV-S Astrum"

/area/shuttle/overmap/aev_p/hermes
	name = "APV-S Hermes"

/area/shuttle/overmap/aev_p/ghetto
	name = "APV-S Ghetto"
