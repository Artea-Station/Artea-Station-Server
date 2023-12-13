#define SYNTH_STOMACH_LIGHT_EMP_CHARGE_LOSS 50
#define SYNTH_STOMACH_HEAVY_EMP_CHARGE_LOSS 150

/obj/item/organ/internal/stomach/synth
	name = "synth power cell"
	icon = 'icons/mob/species/synth/surgery.dmi'
	icon_state = "stomach-ipc"
	w_class = WEIGHT_CLASS_NORMAL
	zone = "chest"
	slot = "stomach"
	desc = "A specialised cell, for synthetic use only. Has a low-power mode. Without this, synthetics are unable to stay powered."
	status = ORGAN_ROBOTIC
	organ_flags = ORGAN_SYNTHETIC

/obj/item/organ/internal/stomach/synth/emp_act(severity)
	. = ..()

	if(!owner || . & EMP_PROTECT_SELF)
		return

	switch(severity)
		if(EMP_HEAVY)
			owner.nutrition = max(0, owner.nutrition - SYNTH_STOMACH_HEAVY_EMP_CHARGE_LOSS)
			to_chat(owner, span_warning("Alert: Severe battery discharge!"))

		if(EMP_LIGHT)
			owner.nutrition = max(0, owner.nutrition - SYNTH_STOMACH_LIGHT_EMP_CHARGE_LOSS)
			to_chat(owner, span_warning("Alert: Minor battery discharge!"))

/obj/item/organ/internal/stomach/synth/Insert(mob/living/carbon/receiver, special, drop_if_replaced)
	. = ..()
	add_synth_signals(receiver)

/obj/item/organ/internal/stomach/synth/Remove(mob/living/carbon/stomach_owner, special)
	. = ..()
	remove_synth_signals(stomach_owner)

/obj/item/organ/internal/stomach/synth/proc/add_synth_signals(mob/living/carbon/stomach_owner)
	SIGNAL_HANDLER
	RegisterSignal(stomach_owner, COMSIG_PROCESS_BORGCHARGER_OCCUPANT, PROC_REF(on_borg_charge))

/obj/item/organ/internal/stomach/synth/proc/remove_synth_signals(mob/living/carbon/stomach_owner)
	SIGNAL_HANDLER
	UnregisterSignal(stomach_owner, COMSIG_PROCESS_BORGCHARGER_OCCUPANT)

/obj/item/organ/internal/stomach/synth/proc/on_borg_charge(datum/source, amount)
	SIGNAL_HANDLER

	// This is so it isn't completely instant
	// This is called ~once every second, so it'd take ~40s to fully charge from stock t1 parts (amount = 200) from empty.
	amount /= 15
	if(owner.nutrition < NUTRITION_LEVEL_WELL_FED)
		owner.nutrition += amount
		if(owner.nutrition > NUTRITION_LEVEL_FULL)
			owner.nutrition = NUTRITION_LEVEL_ALMOST_FULL

#undef SYNTH_STOMACH_LIGHT_EMP_CHARGE_LOSS
#undef SYNTH_STOMACH_HEAVY_EMP_CHARGE_LOSS
