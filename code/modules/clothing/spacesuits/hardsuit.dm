//Baseline hardsuits
/obj/item/clothing/head/helmet/space/hardsuit
	name = "hardsuit helmet"
	desc = "A special helmet designed for work in a hazardous, low-pressure environment. Has radiation shielding."
	icon = 'icons/obj/clothing/head/hardsuit.dmi'
	worn_icon = 'icons/mob/clothing/head/hardsuit_head.dmi'
	icon_state = "hardsuit0-engineering"
	max_integrity = 300
	armor = list(MELEE = 10,  BULLET = 5, LASER = 10, ENERGY = 15, BOMB = 10, BIO = 100, FIRE = 50, ACID = 75, WOUND = 5)
	light_color = "#ffd595"
	light_system = MOVABLE_LIGHT_DIRECTIONAL
	light_range = 3
	light_power = 0.75
	light_on = FALSE
	var/basestate = "hardsuit"
	var/on = FALSE
	var/obj/item/clothing/suit/space/hardsuit/suit
	var/hardsuit_type = "engineering" //Determines used sprites: hardsuit[on]-[type]
	actions_types = list(/datum/action/item_action/toggle_helmet_light)
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH
	flags_inv = HIDEMASK | HIDEEARS | HIDEEYES | HIDEFACE | HIDEHAIR | HIDEFACIALHAIR
	visor_flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH
	clothing_flags = INEDIBLE_CLOTHING | STOPSPRESSUREDAMAGE | THICKMATERIAL | SNUG_FIT
	var/current_tick_amount = 0
	var/radiation_count = 0
	var/grace = TIME_WITHOUT_RADIATION_BEFORE_RESET
	/// If the headlamp is broken, used by lighteater
	var/light_broken = FALSE

/obj/item/clothing/head/helmet/space/hardsuit/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/item/clothing/head/helmet/space/hardsuit/Destroy()
	if(!QDELETED(suit))
		qdel(suit)
	suit = null
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/clothing/head/helmet/space/hardsuit/attack_self(mob/user)
	if(light_broken)
		to_chat(user, "<span class='notice'>The headlamp has been burnt out... Looks like there's no replacing it.</span>")
		on = FALSE
	else
		on = !on
	icon_state = "[basestate][on]-[hardsuit_type]"
	user?.update_worn_head()	//so our mob-overlays update

	set_light_on(on)

	for(var/X in actions)
		var/datum/action/A = X
		A.UpdateButton()

/obj/item/clothing/head/helmet/space/hardsuit/dropped(mob/user)
	..()
	if(suit)
		suit.RemoveHelmet()

/obj/item/clothing/head/helmet/space/hardsuit/item_action_slot_check(slot)
	if(slot == ITEM_SLOT_HEAD)
		return 1

/obj/item/clothing/head/helmet/space/hardsuit/equipped(mob/user, slot)
	..()
	if(slot != ITEM_SLOT_HEAD)
		if(suit)
			suit.RemoveHelmet()
		else
			qdel(src)

/obj/item/clothing/suit/space/hardsuit
	name = "hardsuit"
	desc = "A special suit that protects against hazardous, low pressure environments. Has radiation shielding."
	icon = 'icons/obj/clothing/suits/hardsuit.dmi'
	worn_icon = 'icons/mob/clothing/suits/hardsuit.dmi'
	icon_state = "hardsuit-engineering"
	max_integrity = 300
	armor = list(MELEE = 10,  BULLET = 5, LASER = 10, ENERGY = 15, BOMB = 10, BIO = 100, FIRE = 50, ACID = 75, WOUND = 5)
	allowed = list(/obj/item/flashlight, /obj/item/tank/internals, /obj/item/t_scanner, /obj/item/construction/rcd, /obj/item/pipe_dispenser)
	siemens_coefficient = 0
	var/obj/item/clothing/head/helmet/space/hardsuit/helmet
	actions_types = list(/datum/action/item_action/toggle_helmet)
	var/helmettype = /obj/item/clothing/head/helmet/space/hardsuit
	var/obj/item/tank/jetpack/suit/jetpack = null
	var/hardsuit_type
	var/datum/mod_theme/theme = null

/obj/item/clothing/suit/space/hardsuit/Initialize(mapload)
	. = ..()

/obj/item/clothing/suit/space/hardsuit/attack_self(mob/user)
	user.changeNext_move(CLICK_CD_MELEE)
	..()

/obj/item/clothing/suit/space/hardsuit/ui_action_click(mob/user, datum/actiontype)
	switch(actiontype.type)
		if(/datum/action/item_action/toggle_helmet)
			ToggleHelmet()
			return
	return ..()

/obj/item/clothing/suit/space/hardsuit/item_action_slot_check(slot)
	if(slot == ITEM_SLOT_OCLOTHING) //we only give the mob the ability to toggle the helmet if he's wearing the hardsuit.
		return 1

//Engineering
/obj/item/clothing/head/helmet/space/hardsuit/engine
	name = "engineering hardsuit helmet"
	desc = "A special helmet designed for work in a hazardous, low-pressure environment. Has radiation shielding."
	icon_state = "hardsuit0-engineering"
	armor = list(MELEE = 30,  BULLET = 5, LASER = 10, ENERGY = 12, BOMB = 10, BIO = 100, FIRE = 100, ACID = 75, WOUND = 10)
	hardsuit_type = "engineering"
	resistance_flags = FIRE_PROOF

/obj/item/clothing/head/helmet/space/hardsuit/engine/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/radiation_protected_clothing)

/obj/item/clothing/suit/space/hardsuit/engine
	name = "engineering hardsuit"
	desc = "A special suit that protects against hazardous, low pressure environments. Has radiation shielding."
	icon_state = "hardsuit-engineering"
	armor = list(MELEE = 30,  BULLET = 5, LASER = 10, ENERGY = 15, BOMB = 10, BIO = 100, FIRE = 100, ACID = 75, WOUND = 10)
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/engine
	resistance_flags = FIRE_PROOF

/obj/item/clothing/suit/space/hardsuit/engine/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/radiation_protected_clothing)

//Atmospherics
/obj/item/clothing/head/helmet/space/hardsuit/engine/atmos
	name = "atmospherics hardsuit helmet"
	desc = "A special helmet designed for work in a hazardous, low-pressure environment. Has thermal shielding."
	icon_state = "hardsuit0-atmospherics"
	hardsuit_type = "atmospherics"
	armor = list(MELEE = 30,  BULLET = 5, LASER = 10, ENERGY = 15, BOMB = 10, BIO = 100, FIRE = 100, ACID = 75, WOUND = 10)
	heat_protection = HEAD												//Uncomment to enable firesuit protection
	max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT

/obj/item/clothing/suit/space/hardsuit/engine/atmos
	name = "atmospherics hardsuit"
	desc = "A special suit that protects against hazardous, low pressure environments. Has thermal shielding."
	icon_state = "hardsuit-atmospherics"
	armor = list(MELEE = 30,  BULLET = 5, LASER = 10, ENERGY = 15, BOMB = 10, BIO = 100, FIRE = 100, ACID = 75, WOUND = 10)
	heat_protection = CHEST | GROIN | LEGS | FEET | ARMS | HANDS					//Uncomment to enable firesuit protection
	max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/engine/atmos


//Chief Engineer's hardsuit
/obj/item/clothing/head/helmet/space/hardsuit/engine/elite
	name = "advanced hardsuit helmet"
	desc = "An advanced helmet designed for work in a hazardous, low pressure environment. Shines with a high polish."
	icon_state = "hardsuit0-white"
	hardsuit_type = "white"
	armor = list(MELEE = 40,  BULLET = 5, LASER = 10, ENERGY = 15, BOMB = 50, BIO = 100, FIRE = 100, ACID = 90, WOUND = 10)
	heat_protection = HEAD
	max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT

/obj/item/clothing/suit/space/hardsuit/engine/elite
	icon_state = "hardsuit-white"
	name = "advanced hardsuit"
	desc = "An advanced suit that protects against hazardous, low pressure environments. Shines with a high polish."
	armor = list(MELEE = 40,  BULLET = 5, LASER = 10, ENERGY = 20, BOMB = 50, BIO = 100, FIRE = 100, ACID = 90, WOUND = 10)
	heat_protection = CHEST | GROIN | LEGS | FEET | ARMS | HANDS
	max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT
	slowdown = 0.25
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/engine/elite

//Mining hardsuit
/obj/item/clothing/head/helmet/space/hardsuit/mining
	name = "mining hardsuit helmet"
	desc = "A special helmet designed for work in a hazardous, low pressure environment. Has reinforced plating for wildlife encounters and dual floodlights."
	icon_state = "hardsuit0-mining"
	hardsuit_type = "mining"
	max_heat_protection_temperature = FIRE_SUIT_MAX_TEMP_PROTECT
	resistance_flags = FIRE_PROOF
	heat_protection = HEAD
	armor = list(MELEE = 30,  BULLET = 5, LASER = 10, ENERGY = 20, BOMB = 50, BIO = 100, FIRE = 50, ACID = 75, WOUND = 15)
	light_range = 7
	allowed = list(/obj/item/flashlight, /obj/item/tank/internals, /obj/item/resonator, /obj/item/mining_scanner, /obj/item/t_scanner/adv_mining_scanner)

/obj/item/clothing/head/helmet/space/hardsuit/mining/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/armor_plate)

/obj/item/clothing/suit/space/hardsuit/mining
	icon_state = "hardsuit-mining"
	name = "mining hardsuit"
	desc = "A special suit that protects against hazardous, low pressure environments. Has reinforced plating for wildlife encounters."
	max_heat_protection_temperature = FIRE_SUIT_MAX_TEMP_PROTECT
	resistance_flags = FIRE_PROOF
	armor = list(MELEE = 30,  BULLET = 5, LASER = 10, ENERGY = 20, BOMB = 50, BIO = 100, FIRE = 50, ACID = 75, WOUND = 15)
	allowed = list(/obj/item/flashlight, /obj/item/tank/internals, /obj/item/storage/bag/ore, /obj/item/pickaxe)
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/mining
	heat_protection = CHEST | GROIN | LEGS | FEET | ARMS | HANDS

/obj/item/clothing/suit/space/hardsuit/mining/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/armor_plate)

//Syndicate hardsuit
/obj/item/clothing/head/helmet/space/hardsuit/syndi
	name = "blood-red hardsuit helmet"
	desc = "A dual-mode advanced helmet designed for work in special operations. It is in EVA mode. Property of Gorlex Marauders."
	alt_desc = "A dual-mode advanced helmet designed for work in special operations. It is in combat mode. Property of Gorlex Marauders."
	icon_state = "hardsuit1-syndi"
	hardsuit_type = "syndi"
	armor = list(MELEE = 40,  BULLET = 50, LASER = 30, ENERGY = 40, BOMB = 35, BIO = 100, FIRE = 50, ACID = 90, WOUND = 25)
	on = TRUE
	var/obj/item/clothing/suit/space/hardsuit/syndi/linkedsuit = null
	visor_flags_inv = HIDEMASK | HIDEEYES | HIDEFACE | HIDEFACIALHAIR | HIDEEARS | HIDESNOUT
	visor_flags = STOPSPRESSUREDAMAGE

/obj/item/clothing/head/helmet/space/hardsuit/syndi/Initialize(mapload)
	. = ..()

/obj/item/clothing/head/helmet/space/hardsuit/syndi/ui_action_click(mob/user, datum/action)
	switch(action.type)
		if(/datum/action/item_action/toggle_helmet_mode)
			attack_self(user)
			return
	..()

/obj/item/clothing/head/helmet/space/hardsuit/syndi/attack_self(mob/user) //Toggle Helmet
	if(!isturf(user.loc))
		to_chat(user, "<span class='warning'>You cannot toggle your helmet while in this [user.loc]!</span>" )
		return
	on = !on
	if(on || force)
		to_chat(user, "<span class='notice'>You switch your hardsuit to EVA mode, sacrificing speed for space protection.</span>")
		activate_space_mode()
	else
		to_chat(user, "<span class='notice'>You switch your hardsuit to combat mode and can now run at full speed.</span>")
		activate_combat_mode()
	update_icon()
	playsound(src.loc, 'sound/mecha/mechmove03.ogg', 50, 1)
	toggle_hardsuit_mode(user)
	user.update_worn_head()
	if(iscarbon(user))
		var/mob/living/carbon/C = user
		C.head_update(src, forced = 1)
	for(var/X in actions)
		var/datum/action/A = X
		A.UpdateButton()

/obj/item/clothing/head/helmet/space/hardsuit/syndi/proc/toggle_hardsuit_mode(mob/user) //Helmet Toggles Suit Mode
	if(linkedsuit)
		linkedsuit.icon_state = "hardsuit[on]-[hardsuit_type]"
		linkedsuit.update_icon()
		if(on)
			linkedsuit.activate_space_mode()
		else
			linkedsuit.activate_combat_mode()

/obj/item/clothing/head/helmet/space/hardsuit/syndi/proc/activate_space_mode()
	name = initial(name)
	desc = initial(desc)
	set_light_on(TRUE)
	clothing_flags |= visor_flags
	flags_cover |= HEADCOVERSEYES | HEADCOVERSMOUTH
	flags_inv |= visor_flags_inv
	cold_protection |= HEAD
	on = TRUE

/obj/item/clothing/head/helmet/space/hardsuit/syndi/proc/activate_combat_mode()
	name = "[initial(name)] (combat)"
	desc = alt_desc
	set_light_on(FALSE)
	clothing_flags &= ~visor_flags
	flags_cover &= ~(HEADCOVERSEYES | HEADCOVERSMOUTH)
	flags_inv &= ~visor_flags_inv
	cold_protection &= ~HEAD
	on = FALSE

/obj/item/clothing/suit/space/hardsuit/syndi
	name = "blood-red hardsuit"
	desc = "A dual-mode advanced hardsuit designed for work in special operations. It is in EVA mode. Property of Gorlex Marauders."
	alt_desc = "A dual-mode advanced hardsuit designed for work in special operations. It is in combat mode. Property of Gorlex Marauders."
	icon_state = "hardsuit1-syndi"
	hardsuit_type = "syndi"
	w_class = WEIGHT_CLASS_NORMAL
	armor = list(MELEE = 40,  BULLET = 50, LASER = 30, ENERGY = 40, BOMB = 35, BIO = 100, FIRE = 50, ACID = 90, WOUND = 25)
	allowed = list(/obj/item/gun, /obj/item/ammo_box,/obj/item/ammo_casing, /obj/item/melee/baton, /obj/item/restraints/handcuffs, /obj/item/tank/internals)
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/syndi
	actions_types = list(
		/datum/action/item_action/toggle_helmet,
	)

/obj/item/clothing/suit/space/hardsuit/syndi/RemoveHelmet()
	. = ..()
	//Update helmet to non combat mode
	var/obj/item/clothing/head/helmet/space/hardsuit/syndi/syndieHelmet = helmet
	if(!syndieHelmet)
		return
	syndieHelmet.activate_combat_mode()
	syndieHelmet.update_icon()
	for(var/X in syndieHelmet.actions)
		var/datum/action/A = X
		A.UpdateButton()
	//Update the icon_state first
	icon_state = "hardsuit[syndieHelmet.on]-[syndieHelmet.hardsuit_type]"
	update_icon()
	//Actually apply the non-combat mode to suit and update the suit overlay
	activate_combat_mode()

/obj/item/clothing/suit/space/hardsuit/syndi/proc/activate_space_mode()
	name = initial(name)
	desc = initial(desc)
	slowdown = 1
	clothing_flags |= STOPSPRESSUREDAMAGE
	cold_protection |= CHEST | GROIN | LEGS | FEET | ARMS | HANDS
	if(ishuman(loc))
		var/mob/living/carbon/H = loc
		H.update_equipment_speed_mods()

/obj/item/clothing/suit/space/hardsuit/syndi/proc/activate_combat_mode()
	name = "[initial(name)] (combat)"
	desc = alt_desc
	slowdown = 0
	clothing_flags &= ~STOPSPRESSUREDAMAGE
	cold_protection &= ~(CHEST | GROIN | LEGS | FEET | ARMS | HANDS)
	if(ishuman(loc))
		var/mob/living/carbon/H = loc
		H.update_equipment_speed_mods()

//Medical hardsuit
/obj/item/clothing/head/helmet/space/hardsuit/medical
	name = "medical hardsuit helmet"
	desc = "A special helmet designed for work in a hazardous, low pressure environment. Built with lightweight materials for extra comfort, but does not protect the eyes from intense light."
	icon_state = "hardsuit0-medical"
	hardsuit_type = "medical"
	flash_protect = 0
	armor = list(MELEE = 30,  BULLET = 5, LASER = 10, ENERGY = 15, BOMB = 10, BIO = 100, FIRE = 60, ACID = 75, WOUND = 5)
	clothing_flags = STOPSPRESSUREDAMAGE | THICKMATERIAL | SNUG_FIT

/obj/item/clothing/suit/space/hardsuit/medical
	icon_state = "hardsuit-medical"
	name = "medical hardsuit"
	desc = "A special suit that protects against hazardous, low pressure environments. Built with lightweight materials for easier movement."
	allowed = list(/obj/item/flashlight, /obj/item/tank/internals, /obj/item/healthanalyzer, /obj/item/stack/medical)
	armor = list(MELEE = 30,  BULLET = 5, LASER = 10, ENERGY = 15, BOMB = 10, BIO = 100, FIRE = 60, ACID = 75, WOUND = 5)
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/medical
	slowdown = 0.5

//CMO hardsuit
/obj/item/clothing/head/helmet/space/hardsuit/medical/cmo
	name = "chief medical officer's hardsuit helmet"
	desc = "A special helmet designed for work in a hazardous, low pressure environment. Built with lightweight materials for extra comfort and protects the eyes from intense light."
	flash_protect = 2
	armor = list(MELEE = 30,  BULLET = 5, LASER = 10, ENERGY = 15, BOMB = 10, BIO = 100, FIRE = 60, ACID = 75, WOUND = 5)

/obj/item/clothing/suit/space/hardsuit/medical/cmo
	name = "chief medical officer's hardsuit"
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/medical/cmo
	armor = list(MELEE = 30,  BULLET = 5, LASER = 10, ENERGY = 15, BOMB = 10, BIO = 100, FIRE = 60, ACID = 75, WOUND = 5)

//Security hardsuit
/obj/item/clothing/head/helmet/space/hardsuit/security
	name = "security hardsuit helmet"
	desc = "A special helmet designed for work in a hazardous, low pressure environment. Has an additional layer of armor."
	icon_state = "hardsuit0-sec"
	hardsuit_type = "sec"
	armor = list(MELEE = 35,  BULLET = 15, LASER = 30, ENERGY = 40, BOMB = 10, BIO = 100, FIRE = 75, ACID = 75, WOUND = 15)

/obj/item/clothing/suit/space/hardsuit/security
	icon_state = "hardsuit-sec"
	name = "security hardsuit"
	desc = "A special suit that protects against hazardous, low pressure environments. Has an additional layer of armor."
	armor = list(MELEE = 35,  BULLET = 15, LASER = 30, ENERGY = 40, BOMB = 10, BIO = 100, FIRE = 75, ACID = 75, WOUND = 15)
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/security

/obj/item/clothing/suit/space/hardsuit/security/Initialize(mapload)
	. = ..()

//Head of Security hardsuit
/obj/item/clothing/head/helmet/space/hardsuit/security/hos
	name = "head of security's hardsuit helmet"
	desc = "A special bulky helmet designed for work in a hazardous, low pressure environment. Has an additional layer of armor."
	icon_state = "hardsuit0-hos"
	hardsuit_type = "hos"
	armor = list(MELEE = 45,  BULLET = 25, LASER = 30, ENERGY = 40, BOMB = 25, BIO = 100, FIRE = 95, ACID = 95, WOUND = 15)

/obj/item/clothing/suit/space/hardsuit/security/head_of_security
	icon_state = "hardsuit-hos"
	name = "head of security's hardsuit"
	desc = "A special bulky suit that protects against hazardous, low pressure environments. Has an additional layer of armor."
	armor = list(MELEE = 45,  BULLET = 25, LASER = 30, ENERGY = 40, BOMB = 25, BIO = 100, FIRE = 95, ACID = 95, WOUND = 15)
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/security/hos
