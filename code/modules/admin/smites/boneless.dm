/// Gives the target critically bad wounds
/datum/smite/boneless
	name = ":B:oneless"

/datum/smite/boneless/effect(client/user, mob/living/target)
	. = ..()

	if (!iscarbon(target))
		to_chat(user, span_warning("This must be used on a carbon mob."), confidential = TRUE)
		return

	var/mob/living/carbon/carbon_target = target
	for(var/obj/item/bodypart/limb as anything in carbon_target.bodyparts)
		var/type_wound = pick_weighted(list(
			/datum/wound/blunt/bone/critical = 2,
			/datum/wound/blunt/bone/severe = 2,
			/datum/wound/blunt/bone/moderate = 1,
		))
		limb.force_wound_upwards(type_wound, smited = TRUE)
