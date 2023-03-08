/// Special chip for CE, cause fuck I hate skillchip code.
#define SKILLCHIP_CATEGORY_SPECIAL "special"

/obj/item/skillchip/rdsplx
	name = "R.D.S.P.L.X. skillchip"
	desc = "Knowledge of how to solve the ancient conumdrum; what happens when an unstoppable force meets an immovable object."
	auto_traits = list(TRAIT_ROD_SUPLEX)
	skill_name = "True Strength"
	skill_description = "The knowledge and strength to resolve the most ancient conumdrum; what happens when an unstoppable force meets an immovable object."
	skill_icon = "dumbbell"
	activate_message = "<span class='notice'>You realise if you apply the correct force, at the correct angle, it is possible to make the immovable permanently movable.</span>"
	deactivate_message = "<span class='notice'>You forget how to permanently anchor a paradoxical object.</span>"

	skillchip_flags = SKILLCHIP_RESTRICTED_CATEGORIES
	incompatibility_list = list(SKILLCHIP_CATEGORY_SPECIAL)
	chip_category = SKILLCHIP_CATEGORY_SPECIAL
	slot_use = 2

#undef SKILLCHIP_CATEGORY_SPECIAL
