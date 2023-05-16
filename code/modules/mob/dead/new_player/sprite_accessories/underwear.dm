///////////////////////////
// Underwear Definitions //
///////////////////////////

/datum/sprite_accessory/underwear
	icon = 'icons/mob/clothing/underwear.dmi'
	use_static = FALSE
	em_block = TRUE

	///Whether the underwear uses a special sprite for digitigrade style (i.e. briefs, not panties). Adds a "_d" suffix to the icon state
	/// Except this does nothing for now on Artea, due to digi being somewhat low on my list of things to support for now. - Rimi
	var/has_digitigrade = FALSE

//MALE UNDERWEAR
/datum/sprite_accessory/underwear/nude
	name = "Nude"
	icon_state = null
	gender = NEUTER

/datum/sprite_accessory/underwear/male_briefs
	name = "Briefs"
	icon_state = "male_briefs"
	gender = MALE

/datum/sprite_accessory/underwear/male_boxers
	name = "Boxers"
	icon_state = "male_boxers"
	gender = MALE
	has_digitigrade = TRUE

/datum/sprite_accessory/underwear/male_stripe
	name = "Striped Boxers"
	icon_state = "male_stripe"
	gender = MALE
	has_digitigrade = TRUE

/datum/sprite_accessory/underwear/male_midway
	name = "Midway Boxers"
	icon_state = "male_midway"
	gender = MALE
	has_digitigrade = TRUE

/datum/sprite_accessory/underwear/male_longjohns
	name = "Long Johns"
	icon_state = "male_longjohns"
	gender = MALE
	has_digitigrade = TRUE

/datum/sprite_accessory/underwear/male_kinky
	name = "Jockstrap"
	icon_state = "male_kinky"
	gender = MALE

/datum/sprite_accessory/underwear/male_mankini
	name = "Mankini"
	icon_state = "male_mankini"
	gender = MALE

/datum/sprite_accessory/underwear/male_hearts
	name = "Hearts Boxers"
	icon_state = "male_hearts"
	gender = MALE
	use_static = TRUE
	has_digitigrade = TRUE

/datum/sprite_accessory/underwear/male_commie
	name = "Commie Boxers"
	icon_state = "male_commie"
	gender = MALE
	use_static = TRUE
	has_digitigrade = TRUE

/datum/sprite_accessory/underwear/male_usastripe
	name = "Freedom Boxers"
	icon_state = "male_assblastusa"
	gender = MALE
	use_static = TRUE
	has_digitigrade = TRUE

/datum/sprite_accessory/underwear/male_uk
	name = "UK Boxers"
	icon_state = "male_uk"
	gender = MALE
	use_static = TRUE
	has_digitigrade = TRUE


//FEMALE UNDERWEAR
/datum/sprite_accessory/underwear/female_bikini
	name = "Bikini"
	icon_state = "female_bikini"
	gender = FEMALE

/datum/sprite_accessory/underwear/female_lace
	name = "Lace Bikini"
	icon_state = "female_lace"
	gender = FEMALE

/datum/sprite_accessory/underwear/female_bralette
	name = "Bralette w/ Boyshorts"
	icon_state = "female_bralette"
	gender = FEMALE

/datum/sprite_accessory/underwear/female_sport
	name = "Sports Bra w/ Boyshorts"
	icon_state = "female_sport"
	gender = FEMALE
	has_digitigrade = TRUE

/datum/sprite_accessory/underwear/female_thong
	name = "Thong"
	icon_state = "female_thong"
	gender = FEMALE

/datum/sprite_accessory/underwear/female_strapless
	name = "Strapless Bikini"
	icon_state = "female_strapless"
	gender = FEMALE

/datum/sprite_accessory/underwear/female_babydoll
	name = "Babydoll"
	icon_state = "female_babydoll"
	gender = FEMALE

/datum/sprite_accessory/underwear/swimsuit_onepiece
	name = "One-Piece Swimsuit"
	icon_state = "swim_onepiece"
	gender = FEMALE

/datum/sprite_accessory/underwear/swimsuit_strapless_onepiece
	name = "Strapless One-Piece Swimsuit"
	icon_state = "swim_strapless_onepiece"
	gender = FEMALE

/datum/sprite_accessory/underwear/swimsuit_twopiece
	name = "Two-Piece Swimsuit"
	icon_state = "swim_twopiece"
	gender = FEMALE

/datum/sprite_accessory/underwear/swimsuit_strapless_twopiece
	name = "Strapless Two-Piece Swimsuit"
	icon_state = "swim_strapless_twopiece"
	gender = FEMALE

/datum/sprite_accessory/underwear/swimsuit_stripe
	name = "Strapless Striped Swimsuit"
	icon_state = "swim_stripe"
	gender = FEMALE

/datum/sprite_accessory/underwear/swimsuit_halter
	name = "Halter Swimsuit"
	icon_state = "swim_halter"
	gender = FEMALE

/datum/sprite_accessory/underwear/female_white_neko
	name = "Neko Bikini (White)"
	icon_state = "female_neko_white"
	gender = FEMALE
	use_static = TRUE

/datum/sprite_accessory/underwear/female_black_neko
	name = "Neko Bikini (Black)"
	icon_state = "female_neko_black"
	gender = FEMALE
	use_static = TRUE

/datum/sprite_accessory/underwear/female_commie
	name = "Commie Bikini"
	icon_state = "female_commie"
	gender = FEMALE
	use_static = TRUE

/datum/sprite_accessory/underwear/female_usastripe
	name = "Freedom Bikini"
	icon_state = "female_assblastusa"
	gender = FEMALE
	use_static = TRUE

/datum/sprite_accessory/underwear/female_uk
	name = "UK Bikini"
	icon_state = "female_uk"
	gender = FEMALE
	use_static = TRUE

/datum/sprite_accessory/underwear/female_kinky
	name = "Lingerie"
	icon_state = "female_kinky"
	gender = FEMALE
	use_static = TRUE

// Skyrat underwear

/datum/sprite_accessory/underwear/male_bee
	name = "Boxers - Bee"
	icon_state = "bee_shorts"
	has_digitigrade = TRUE
	gender = MALE
	use_static = TRUE

/datum/sprite_accessory/underwear/female_beekini
	name = "Panties - Bee-kini"
	icon_state = "panties_bee-kini"
	gender = FEMALE
	use_static = TRUE

/datum/sprite_accessory/underwear/panties
	name = "Panties"
	icon_state = "panties"
	gender = FEMALE

/datum/sprite_accessory/underwear/fishnet_lower
	name = "Panties - Fishnet"
	icon_state = "fishnet_lower"
	gender = FEMALE
	use_static = TRUE

/datum/sprite_accessory/underwear/fishnet_lower/alt
	name = "Panties - Fishnet (Greyscale)"
	icon_state = "fishnet_lower_alt"
	use_static = null

/datum/sprite_accessory/underwear/female_beekini
	name = "Panties - Bee-kini"
	icon_state = "panties_bee-kini"
	gender = FEMALE
	use_static = TRUE

/datum/sprite_accessory/underwear/female_commie
	name = "Panties - Commie"
	icon_state = "panties_commie"
	gender = FEMALE
	use_static = TRUE

/datum/sprite_accessory/underwear/female_usastripe
	name = "Panties - Freedom"
	icon_state = "panties_assblastusa"
	gender = FEMALE
	use_static = TRUE

/datum/sprite_accessory/underwear/female_kinky
	name = "Panties - Kinky Black"
	icon_state = "panties_kinky"
	gender = FEMALE
	use_static = TRUE

/datum/sprite_accessory/underwear/panties_uk
	name = "Panties - UK"
	icon_state = "panties_uk"
	gender = FEMALE
	use_static = TRUE

/datum/sprite_accessory/underwear/panties_neko
	name = "Panties - Neko"
	icon_state = "panties_neko"
	gender = FEMALE

/datum/sprite_accessory/underwear/panties_slim
	name = "Panties - Slim"
	icon_state = "panties_slim"
	gender = FEMALE

/datum/sprite_accessory/underwear/striped_panties
	name = "Panties - Striped"
	icon_state = "striped_panties"
	gender = FEMALE

/datum/sprite_accessory/underwear/panties_swimsuit
	name = "Panties - Swimsuit"
	icon_state = "panties_swimming"
	gender = FEMALE

/datum/sprite_accessory/underwear/panties_thin
	name = "Panties - Thin"
	icon_state = "panties_thin"
	gender = FEMALE

/datum/sprite_accessory/underwear/swimsuit_red
	name = "Swimsuit, One Piece - Red"
	icon_state = "swimming_red"
	gender = FEMALE
	use_static = TRUE

/datum/sprite_accessory/underwear/swimsuit
	name = "Swimsuit, One Piece - Black"
	icon_state = "swimming_black"
	gender = FEMALE
	use_static = TRUE

/datum/sprite_accessory/underwear/swimsuit_blue
	name = "Swimsuit, One Piece - Striped Blue"
	icon_state = "swimming_blue"
	gender = FEMALE
	use_static = TRUE

/datum/sprite_accessory/underwear/thong
	name = "Thong"
	icon_state = "thong"
	gender = FEMALE

/datum/sprite_accessory/underwear/thong_babydoll
	name = "Thong - Alt"
	icon_state = "thong_babydoll"
	gender = FEMALE

/datum/sprite_accessory/underwear/chastbelt
	name = "Chastity Belt"
	icon_state = "chastbelt"
	use_static = TRUE

/datum/sprite_accessory/underwear/chastcage
	name = "Chastity Cage"
	icon_state = "chastcage"
	use_static = null

/datum/sprite_accessory/underwear/latex
	name = "Panties - Latex"
	icon_state = "panties_latex"
	use_static = TRUE

/datum/sprite_accessory/underwear/lizared
	name = "LIZARED Underwear"
	icon_state = "lizared"
	use_static = TRUE

/datum/sprite_accessory/underwear/boyshorts
	name = "Boyshorts"
	icon_state = "boyshorts"
	has_digitigrade = TRUE
	gender = FEMALE
