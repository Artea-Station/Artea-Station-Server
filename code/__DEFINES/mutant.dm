// Defines for mutant organ keys.

#define MUTANT_EARS "ears"
#define MUTANT_TAIL "tail"
#define MUTANT_LIZARD_TAIL "tail_lizard"
#define MUTANT_SPINES "spines"
#define MUTANT_HORNS "horns"
#define MUTANT_FRILLS "frills"
#define MUTANT_SNOUT "snout"
#define MUTANT_MOTH_ANTENNAE "moth_antennae"
#define MUTANT_POD_HAIR "pod_hair"

#define MUTANT_CHOICED_NEW(name, global_list) /datum/preference/choiced/mutant/##name/New() { \
	. = ..(); \
	sprite_accessory = ##global_list; \
}
