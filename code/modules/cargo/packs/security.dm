//////////////////////////////////////////////////////////////////////////////
//////////////////////////// Security ////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

/datum/supply_pack/security
	group = "Security"
	access = ACCESS_SECURITY
	container_type = /obj/structure/closet/crate/secure/gear

/datum/supply_pack/security/ammo
	name = "Ammo Crate"
	desc = "Contains three boxes of beanbag shotgun shells, three boxes of rubbershot shotgun shells and one of each special .38 speedloarders. Requires Security access to open."
	cost = CARGO_CRATE_VALUE * 8
	access_view = ACCESS_ARMORY
	contains = list(/obj/item/storage/box/beanbag,
					/obj/item/storage/box/beanbag,
					/obj/item/storage/box/beanbag,
					/obj/item/storage/box/rubbershot,
					/obj/item/storage/box/rubbershot,
					/obj/item/storage/box/rubbershot,
					/obj/item/ammo_box/c38/trac,
					/obj/item/ammo_box/c38/hotshot,
					/obj/item/ammo_box/c38/iceblox)
	container_name = "ammo crate"

/datum/supply_pack/security/armor
	name = "Armor Crate"
	desc = "Three vests of well-rounded, decently-protective armor. Requires Security access to open."
	cost = CARGO_CRATE_VALUE * 2
	access_view = ACCESS_SECURITY
	contains = list(/obj/item/clothing/suit/armor/vest,
					/obj/item/clothing/suit/armor/vest,
					/obj/item/clothing/suit/armor/vest)
	container_name = "armor crate"

/datum/supply_pack/security/disabler
	name = "Disabler Crate"
	desc = "Three stamina-draining disabler weapons. Requires Security access to open."
	cost = CARGO_CRATE_VALUE * 3
	access_view = ACCESS_SECURITY
	contains = list(/obj/item/gun/energy/disabler,
					/obj/item/gun/energy/disabler,
					/obj/item/gun/energy/disabler)
	container_name = "disabler crate"

/datum/supply_pack/security/forensics
	name = "Forensics Crate"
	desc = "Stay hot on the criminal's heels with Nanotrasen's Detective Essentials(tm). Contains a forensics scanner, six evidence bags, camera, tape recorder, white crayon, and of course, a fedora. Requires Security access to open."
	cost = CARGO_CRATE_VALUE * 2.5
	access_view = ACCESS_MORGUE
	contains = list(/obj/item/detective_scanner,
					/obj/item/storage/box/evidence,
					/obj/item/camera,
					/obj/item/taperecorder,
					/obj/item/toy/crayon/white,
					/obj/item/clothing/head/fedora/det_hat)
	container_name = "forensics crate"

/datum/supply_pack/security/helmets
	name = "Helmets Crate"
	desc = "Contains three standard-issue brain buckets. Requires Security access to open."
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/clothing/head/helmet/sec,
					/obj/item/clothing/head/helmet/sec,
					/obj/item/clothing/head/helmet/sec)
	container_name = "helmet crate"

/datum/supply_pack/security/laser
	name = "Lasers Crate"
	desc = "Contains three lethal, high-energy laser guns. Requires Security access to open."
	cost = CARGO_CRATE_VALUE * 4
	access_view = ACCESS_ARMORY
	contains = list(/obj/item/gun/energy/laser,
					/obj/item/gun/energy/laser,
					/obj/item/gun/energy/laser)
	container_name = "laser crate"

/datum/supply_pack/security/securitybarriers
	name = "Security Barrier Grenades"
	desc = "Stem the tide with four Security Barrier grenades. Requires Security access to open."
	access_view = ACCESS_BRIG
	contains = list(/obj/item/grenade/barrier,
					/obj/item/grenade/barrier,
					/obj/item/grenade/barrier,
					/obj/item/grenade/barrier)
	cost = CARGO_CRATE_VALUE * 2
	container_name = "security barriers crate"

/datum/supply_pack/security/securityclothes
	name = "Security Clothing Crate"
	desc = "Contains appropriate outfits for the station's private security force. Contains outfits for the Warden, Head of Security, and two Security Officers. Each outfit comes with a rank-appropriate jumpsuit, suit, and beret. Requires Security access to open."
	cost = CARGO_CRATE_VALUE * 3
	access_view = ACCESS_SECURITY
	contains = list(/obj/item/clothing/under/rank/security/officer/formal,
					/obj/item/clothing/under/rank/security/officer/formal,
					/obj/item/clothing/suit/jacket/officer/blue,
					/obj/item/clothing/suit/jacket/officer/blue,
					/obj/item/clothing/head/beret/sec/navyofficer,
					/obj/item/clothing/head/beret/sec/navyofficer,
					/obj/item/clothing/under/rank/security/warden/formal,
					/obj/item/clothing/suit/jacket/warden/blue,
					/obj/item/clothing/head/beret/sec/navywarden,
					/obj/item/clothing/under/rank/security/head_of_security/formal,
					/obj/item/clothing/suit/jacket/hos/blue,
					/obj/item/clothing/head/hos/beret/navyhos)
	container_name = "security clothing crate"

/datum/supply_pack/security/stingpack
	name = "Stingbang Grenade Pack"
	desc = "Contains five \"stingbang\" grenades, perfect for stopping riots and playing morally unthinkable pranks. Requires Security access to open."
	cost = CARGO_CRATE_VALUE * 5
	access_view = ACCESS_ARMORY
	contains = list(/obj/item/storage/box/stingbangs)
	container_name = "stingbang grenade pack crate"

/datum/supply_pack/security/supplies
	name = "Security Supplies Crate"
	desc = "Contains seven flashbangs, seven teargas grenades, six flashes, and seven handcuffs. Requires Security access to open."
	cost = CARGO_CRATE_VALUE * 3.5
	access_view = ACCESS_ARMORY
	contains = list(/obj/item/storage/box/flashbangs,
					/obj/item/storage/box/teargas,
					/obj/item/storage/box/flashes,
					/obj/item/storage/box/handcuffs)
	container_name = "security supply crate"

/datum/supply_pack/security/firingpins
	name = "Standard Firing Pins Crate"
	desc = "Upgrade your arsenal with 10 standard firing pins. Requires Security access to open."
	cost = CARGO_CRATE_VALUE * 4
	access_view = ACCESS_ARMORY
	contains = list(/obj/item/storage/box/firingpins,
					/obj/item/storage/box/firingpins)
	container_name = "firing pins crate"

/datum/supply_pack/security/firingpins/paywall
	name = "Paywall Firing Pins Crate"
	desc = "Specialized firing pins with a built-in configurable paywall. Requires Security access to open."
	cost = CARGO_CRATE_VALUE * 2
	access_view = ACCESS_ARMORY
	contains = list(/obj/item/storage/box/firingpins/paywall,
					/obj/item/storage/box/firingpins/paywall)
	container_name = "paywall firing pins crate"

/datum/supply_pack/security/justiceinbound
	name = "Standard Justice Enforcer Crate"
	desc = "This is it. The Bee's Knees. The Creme of the Crop. The Pick of the Litter. The best of the best of the best. The Crown Jewel of Nanotrasen. The Alpha and the Omega of security headwear. Guaranteed to strike fear into the hearts of each and every criminal aboard the station. Also comes with a security gasmask. Requires Security access to open."
	cost = CARGO_CRATE_VALUE * 6 //justice comes at a price. An expensive, noisy price.
	contraband = TRUE
	contains = list(/obj/item/clothing/head/helmet/justice,
					/obj/item/clothing/mask/gas/sechailer)
	container_name = "security clothing crate"

/datum/supply_pack/security/baton
	name = "Stun Batons Crate"
	desc = "Arm the Civil Protection Forces with three stun batons. Batteries included. Requires Security access to open."
	cost = CARGO_CRATE_VALUE * 2
	access_view = ACCESS_SECURITY
	contains = list(/obj/item/melee/baton/security/loaded,
					/obj/item/melee/baton/security/loaded,
					/obj/item/melee/baton/security/loaded)
	container_name = "stun baton crate"

/datum/supply_pack/security/wall_flash
	name = "Wall-Mounted Flash Crate"
	desc = "Contains four wall-mounted flashes. Requires Security access to open."
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/storage/box/wall_flash,
					/obj/item/storage/box/wall_flash,
					/obj/item/storage/box/wall_flash,
					/obj/item/storage/box/wall_flash)
	container_name = "wall-mounted flash crate"

/datum/supply_pack/security/constable
	name = "Traditional Equipment Crate"
	desc = "Spare equipment found in a warehouse."
	cost = CARGO_CRATE_VALUE * 2.2
	contraband = TRUE
	contains = list(/obj/item/clothing/under/rank/security/constable,
					/obj/item/clothing/head/constable,
					/obj/item/clothing/gloves/color/white,
					/obj/item/clothing/mask/whistle,
					/obj/item/conversion_kit)
