// Describes the three modes of scanning available for health analyzers
#define SCANMODE_HEALTH 0
#define SCANMODE_WOUND 1
#define SCANMODE_COUNT 2 // Update this to be the number of scan modes if you add more
#define SCANNER_CONDENSED 0
#define SCANNER_VERBOSE 1

/obj/item/healthanalyzer
	name = "health analyzer"
	icon = 'icons/obj/device.dmi'
	icon_state = "health"
	inhand_icon_state = "healthanalyzer"
	worn_icon_state = "healthanalyzer"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	desc = "A hand-held body scanner capable of distinguishing vital signs of the subject. Has a side button to scan for chemicals, and can be toggled to scan wounds."
	flags_1 = CONDUCT_1
	item_flags = NOBLUDGEON
	slot_flags = ITEM_SLOT_BELT
	throwforce = 3
	w_class = WEIGHT_CLASS_TINY
	throw_speed = 3
	throw_range = 7
	custom_materials = list(/datum/material/iron=200)
	pickup_sound = 'sound/items/handling/device_pickup.ogg'
	drop_sound = 'sound/items/handling/device_drop.ogg'
	var/mode = SCANNER_VERBOSE
	var/scanmode = SCANMODE_HEALTH
	var/advanced = FALSE
	custom_price = PAYCHECK_COMMAND
	var/last_scan_text

/obj/item/healthanalyzer/Initialize(mapload)
	. = ..()

	register_item_context()

/obj/item/healthanalyzer/examine(mob/user)
	. = ..()
	. += span_notice("Alt-click [src] to toggle the limb damage readout.")

/obj/item/healthanalyzer/suicide_act(mob/living/carbon/user)
	user.visible_message(span_suicide("[user] begins to analyze [user.p_them()]self with [src]! The display shows that [user.p_theyre()] dead!"))
	return BRUTELOSS

/obj/item/healthanalyzer/attack_self(mob/user)
	scanmode = (scanmode + 1) % SCANMODE_COUNT
	switch(scanmode)
		if(SCANMODE_HEALTH)
			to_chat(user, span_notice("You switch the health analyzer to check physical health."))
		if(SCANMODE_WOUND)
			to_chat(user, span_notice("You switch the health analyzer to report extra info on wounds."))

/obj/item/healthanalyzer/attack(mob/living/M, mob/living/carbon/human/user)
	flick("[icon_state]-scan", src) //makes it so that it plays the scan animation upon scanning, including clumsy scanning

	// Clumsiness/brain damage check
	if ((HAS_TRAIT(user, TRAIT_CLUMSY) || HAS_TRAIT(user, TRAIT_DUMB)) && prob(50))
		var/turf/scan_turf = get_turf(user)
		user.visible_message(
			span_warning("[user] analyzes [scan_turf]'s vitals!"),
			span_notice("You stupidly try to analyze [scan_turf]'s vitals!"),
		)

		var/floor_text = "<span class='info'>Analyzing results for <b>[scan_turf]</b> ([station_time_timestamp()]):</span><br>"
		floor_text += "<span class='info ml-1'>Overall status: <i>Unknown</i></span><br>"
		floor_text += "<span class='alert ml-1'>Subject lacks a brain.</span><br>"
		floor_text += "<span class='info ml-1'>Body temperature: [scan_turf?.return_temperature() || "???"]</span><br>"

		if(user.can_read(src) && !user.is_blind())
			to_chat(user, examine_block(floor_text))
		last_scan_text = floor_text
		return

	if(ispodperson(M)&& !advanced)
		to_chat(user, "<span class='info'>[M]'s biological structure is too complex for the health analyzer.")
		return

	user.visible_message(span_notice("[user] analyzes [M]'s vitals."))
	balloon_alert(user, "analyzing vitals")

	var/readability_check = user.can_read(src) && !user.is_blind()
	switch (scanmode)
		if (SCANMODE_HEALTH)
			last_scan_text = healthscan(user, M, mode, advanced, tochat = readability_check)
		if (SCANMODE_WOUND)
			if(readability_check)
				woundscan(user, M, src)

	add_fingerprint(user)

/obj/item/healthanalyzer/attack_secondary(mob/living/victim, mob/living/user, params)
	chemscan(user, victim)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/item/healthanalyzer/add_item_context(
	obj/item/source,
	list/context,
	atom/target,
)
	if (!isliving(target))
		return NONE

	switch (scanmode)
		if (SCANMODE_HEALTH)
			context[SCREENTIP_CONTEXT_LMB] = "Scan health"
		if (SCANMODE_WOUND)
			context[SCREENTIP_CONTEXT_LMB] = "Scan wounds"

	context[SCREENTIP_CONTEXT_RMB] = "Scan chemicals"

	return CONTEXTUAL_SCREENTIP_SET

// Used by the PDA medical scanner too
/proc/healthscan(mob/user, mob/living/target, mode = SCANNER_VERBOSE, advanced = FALSE, tochat = TRUE)
	if(user.incapacitated())
		return

	if(user.is_blind())
		to_chat(user, span_warning("You realize that your scanner has no accessibility support for the blind!"))
		return

	// the final list of strings to render
	var/list/render_list = list()

	// Damage specifics
	var/oxy_loss = target.getOxyLoss()
	var/tox_loss = target.getToxLoss()
	var/fire_loss = target.getFireLoss()
	var/brute_loss = target.getBruteLoss()
	var/mob_status = (target.stat == DEAD ? span_alert("<b>Deceased</b>") : "<b>[round(target.health / target.maxHealth, 0.01) * 100]% healthy</b>")

	if(HAS_TRAIT(target, TRAIT_FAKEDEATH) && !advanced)
		mob_status = span_alert("<b>Deceased</b>")
		oxy_loss = max(rand(1, 40), oxy_loss, (300 - (tox_loss + fire_loss + brute_loss))) // Random oxygen loss

	render_list += "[span_info("Analyzing results for <b>[target]</b> ([station_time_timestamp()]):")]<br><span class='info ml-1'>Overall status: [mob_status]</span><br>"

	if(!advanced && target.has_reagent(/datum/reagent/inverse/technetium))
		advanced = TRUE

	SEND_SIGNAL(target, COMSIG_LIVING_HEALTHSCAN, render_list, advanced, user, mode, tochat)

	// Husk detection
	if(HAS_TRAIT(target, TRAIT_HUSK))
		if(advanced)
			if(HAS_TRAIT_FROM(target, TRAIT_HUSK, BURN))
				render_list += "<span class='alert ml-1'>Subject has been husked by [conditional_tooltip("severe burns", "Tend burns and apply a de-husking agent, such as [/datum/reagent/medicine/c2/synthflesh::name].", tochat)].</span><br>"
			else if (HAS_TRAIT_FROM(target, TRAIT_HUSK, CHANGELING_DRAIN))
				render_list += "<span class='alert ml-1'>Subject has been husked by [conditional_tooltip("desiccation", "Irreparable. Under normal circumstances, revival can only proceed via brain transplant.", tochat)].</span><br>"
			else
				render_list += "<span class='alert ml-1'>Subject has been husked by mysterious causes.</span>\n"

		else
			render_list += "<span class='alert ml-1'>Subject has been husked.</span>\n"

	if(target.getStaminaLoss())
		if(advanced)
			render_list += "<span class='alert ml-1'>Fatigue level: [target.getStaminaLoss()]%.</span>\n"
		else
			render_list += "<span class='alert ml-1'>Subject appears to be suffering from fatigue.</span>\n"
	if (target.getCloneLoss())
		if(advanced)
			render_list += "<span class='alert ml-1'>Cellular damage level: [target.getCloneLoss()].</span>\n"
		else
			render_list += "<span class='alert ml-1'>Subject appears to have [target.getCloneLoss() > 30 ? "severe" : "minor"] cellular damage.</span>\n"
	if (!target.getorganslot(ORGAN_SLOT_BRAIN)) // kept exclusively for soul purposes
		render_list += "<span class='alert ml-1'>Subject lacks a brain.</span>\n"

	if(iscarbon(target))
		var/mob/living/carbon/carbontarget = target
		if(LAZYLEN(carbontarget.quirks))
			render_list += "<span class='info ml-1'>Subject Major Disabilities: [carbontarget.get_quirk_string(FALSE, CAT_QUIRK_MAJOR_DISABILITY, from_scan = TRUE)].</span><br>"
			if(advanced)
				render_list += "<span class='info ml-1'>Subject Minor Disabilities: [carbontarget.get_quirk_string(FALSE, CAT_QUIRK_MINOR_DISABILITY)].</span>\n"

	// Body part damage report
	if(iscarbon(target))
		var/mob/living/carbon/carbontarget = target
		var/any_damage = brute_loss > 0 || fire_loss > 0 || oxy_loss > 0 || tox_loss > 0 || fire_loss > 0
		var/any_missing = length(carbontarget.bodyparts) < (carbontarget.dna?.species?.max_bodypart_count || 6)
		var/any_wounded = length(carbontarget.all_wounds)
		var/any_embeds = carbontarget.has_embedded_objects()
		if(any_damage || (mode == SCANNER_VERBOSE && (any_missing || any_wounded || any_embeds)))
			render_list += "<hr>"
			var/dmgreport = "<span class='info ml-1'>Body status:</span>\
							<font face='Verdana'>\
							<table class='ml-2'>\
							<tr>\
							<td style='width:7em;'><font color='#ff0000'><b>Damage:</b></font></td>\
							<td style='width:5em;'><font color='#ff3333'><b>Brute</b></font></td>\
							<td style='width:4em;'><font color='#ff9933'><b>Burn</b></font></td>\
							<td style='width:4em;'><font color='#00cc66'><b>Toxin</b></font></td>\
							<td style='width:8em;'><font color='#00cccc'><b>Suffocation</b></font></td>\
							</tr>\
							<tr>\
							<td><font color='#ff3333'><b>Overall:</b></font></td>\
							<td><font color='#ff3333'><b>[ceil(brute_loss)]</b></font></td>\
							<td><font color='#ff9933'><b>[ceil(fire_loss)]</b></font></td>\
							<td><font color='#00cc66'><b>[ceil(tox_loss)]</b></font></td>\
							<td><font color='#33ccff'><b>[ceil(oxy_loss)]</b></font></td>\
							</tr>"

			if(mode == SCANNER_VERBOSE)
				// Follow same body zone list every time so it's consistent across all humans
				for(var/zone in GLOB.all_body_zones)
					var/obj/item/bodypart/limb = carbontarget.get_bodypart(zone)
					if(isnull(limb))
						dmgreport += "<tr>"
						dmgreport += "<td><font color='#cc3333'>[capitalize(parse_zone(zone))]:</font></td>"
						dmgreport += "<td><font color='#cc3333'>-</font></td>"
						dmgreport += "<td><font color='#ff9933'>-</font></td>"
						dmgreport += "</tr>"
						dmgreport += "<tr><td colspan=6><span class='alert ml-2'>&rdsh; Physical trauma: [conditional_tooltip("Dismembered", "Reattach or replace surgically.", tochat)]</span></td></tr>"
						continue
					var/has_any_embeds = length(limb.embedded_objects) >= 1
					var/has_any_wounds = length(limb.wounds) >= 1
					var/is_damaged = limb.burn_dam > 0 || limb.brute_dam > 0
					if(!is_damaged && (zone != BODY_ZONE_CHEST || (tox_loss <= 0 && oxy_loss <= 0)) && !has_any_embeds && !has_any_wounds)
						continue
					dmgreport += "<tr>"
					dmgreport += "<td><font color='#cc3333'>[capitalize((limb.bodytype & BODYTYPE_ROBOTIC) ? limb.name : limb.plaintext_zone)]:</font></td>"
					dmgreport += "<td><font color='#cc3333'>[limb.brute_dam > 0 ? ceil(limb.brute_dam) : "0"]</font></td>"
					dmgreport += "<td><font color='#ff9933'>[limb.burn_dam > 0 ? ceil(limb.burn_dam) : "0"]</font></td>"
					if(zone == BODY_ZONE_CHEST) // tox/oxy is stored in the chest
						dmgreport += "<td><font color='#00cc66'>[tox_loss > 0 ? ceil(tox_loss) : "0"]</font></td>"
						dmgreport += "<td><font color='#33ccff'>[oxy_loss > 0 ? ceil(oxy_loss) : "0"]</font></td>"
					dmgreport += "</tr>"
					if(has_any_embeds)
						var/list/embedded_names = list()
						for(var/obj/item/embed as anything in limb.embedded_objects)
							embedded_names[capitalize(embed.name)] += 1
						for(var/embedded_name in embedded_names)
							var/displayed = embedded_name
							var/embedded_amt = embedded_names[embedded_name]
							if(embedded_amt > 1)
								displayed = "[embedded_amt]x [embedded_name]"
							dmgreport += "<tr><td colspan=6><span class='alert ml-2'>&rdsh; Foreign object(s): [conditional_tooltip(displayed, "Use a hemostat to remove.", tochat)]</span></td></tr>"
					if(has_any_wounds)
						for(var/datum/wound/wound as anything in limb.wounds)
							dmgreport += "<tr><td colspan=6><span class='alert ml-2'>&rdsh; Physical trauma: [conditional_tooltip("[wound.name] ([wound.severity_text()])", wound.treat_text_short, tochat)]</span></td></tr>"

			dmgreport += "</table></font>"
			render_list += dmgreport // tables do not need extra linebreak

	if(ishuman(target))
		var/mob/living/carbon/human/humantarget = target

		// Organ damage, missing organs
		var/render = FALSE
		var/toReport = "<span class='info ml-1'>Organ status:</span>\
			<font face='Verdana'>\
			<table class='ml-2'>\
			<tr>\
			<td style='width:8em;'><font color='#ff0000'><b>Organ:</b></font></td>\
			[advanced ? "<td style='width:4em;'><font color='#ff0000'><b>Dmg</b></font></td>" : ""]\
			<td style='width:30em;'><font color='#ff0000'><b>Status</b></font></td>\
			</tr>"

		var/list/missing_organs = list()
		if(!humantarget.internal_organs_slot[ORGAN_SLOT_BRAIN])
			missing_organs[ORGAN_SLOT_BRAIN] = "Brain"
		if(!humantarget.needs_heart() && !humantarget.internal_organs_slot[ORGAN_SLOT_HEART])
			missing_organs[ORGAN_SLOT_HEART] = "Heart"
		if(!HAS_TRAIT_FROM(humantarget, TRAIT_NOBREATH, SPECIES_TRAIT) && !isnull(humantarget.dna.species.mutantlungs) && !humantarget.internal_organs_slot[ORGAN_SLOT_LUNGS])
			missing_organs[ORGAN_SLOT_LUNGS] = "Lungs"
		if(!isnull(humantarget.dna.species.mutantliver) && !humantarget.internal_organs_slot[ORGAN_SLOT_LIVER])
			missing_organs[ORGAN_SLOT_LIVER] = "Liver"
		if(!HAS_TRAIT_FROM(humantarget, TRAIT_NOHUNGER, SPECIES_TRAIT) && !isnull(humantarget.dna.species.mutantstomach) && !humantarget.internal_organs_slot[ORGAN_SLOT_STOMACH])
			missing_organs[ORGAN_SLOT_STOMACH] ="Stomach"
		if(!isnull(humantarget.dna.species.mutanttongue) && !humantarget.internal_organs_slot[ORGAN_SLOT_TONGUE])
			missing_organs[ORGAN_SLOT_TONGUE] = "Tongue"
		if(!isnull(humantarget.dna.species.mutantears) && !humantarget.internal_organs_slot[ORGAN_SLOT_EARS])
			missing_organs[ORGAN_SLOT_EARS] = "Ears"
		if(!isnull(humantarget.dna.species.mutantears) && !humantarget.internal_organs_slot[ORGAN_SLOT_EYES])
			missing_organs[ORGAN_SLOT_EYES] = "Eyes"

		// Follow same order as in the organ_process_order so it's consistent across all humans
		for(var/sorted_slot in GLOB.organ_process_order)
			var/obj/item/organ/organ = humantarget.internal_organs_slot[sorted_slot]
			if(isnull(organ))
				if(missing_organs[sorted_slot])
					render = TRUE
					toReport += "<tr><td><font color='#cc3333'>[missing_organs[sorted_slot]]:</font></td>\
						[advanced ? "<td><font color='#ff3333'>-</font></td>" : ""]\
						<td><font color='#cc3333'>Missing</font></td></tr>"
				continue
			if(mode != SCANNER_VERBOSE && !organ.show_on_condensed_scans())
				continue
			var/status = organ.get_status_text(advanced, tochat)
			var/appendix = organ.get_status_appendix(advanced, tochat)
			if(status || appendix)
				status ||= "<font color='#ffcc33'>OK</font>" // otherwise flawless organs have no status reported by default
				render = TRUE
				toReport += "<tr>\
					<td><font color='#cc3333'>[capitalize(organ.name)]:</font></td>\
					[advanced ? "<td><font color='#ff3333'>[organ.damage > 0 ? ceil(organ.damage) : "0"]</font></td>" : ""]\
					<td>[status]</td>\
					</tr>"
				if(appendix)
					toReport += "<tr><td colspan=4><span class='alert ml-2'>&rdsh; [appendix]</span></td></tr>"

		if(render)
			render_list += "<hr>"
			render_list += toReport + "</table></font>" // tables do not need extra linebreak

		// Cybernetics
		var/list/cyberimps
		for(var/obj/item/organ/internal/cyberimp/cyberimp in humantarget.internal_organs)
			if((cyberimp.status & ORGAN_ROBOTIC) && !(cyberimp.organ_flags & ORGAN_HIDDEN))
				LAZYADD(cyberimps, "\a [cyberimp]")
		if(LAZYLEN(cyberimps))
			if(!render)
				render_list += "<hr>"
			render_list += "<span class='notice ml-1'>Detected cybernetic modifications:</span><br>"
			render_list += "<span class='notice ml-2'>[english_list(cyberimps, and_text = ", and ")]</span><br>"

		render_list += "<hr>"

		//Genetic stability
		if(advanced && humantarget.has_dna() && humantarget.dna.stability != initial(humantarget.dna.stability))
			render_list += "<span class='info ml-1'>Genetic Stability: [humantarget.dna.stability]%.</span><br>"

		// Species and body temperature
		var/datum/species/targetspecies = humantarget.dna.species
		var/mutant = targetspecies.mutantlungs != initial(targetspecies.mutantlungs) \
			|| targetspecies.mutantbrain != initial(targetspecies.mutantbrain) \
			|| targetspecies.mutantheart != initial(targetspecies.mutantheart) \
			|| targetspecies.mutanteyes != initial(targetspecies.mutanteyes) \
			|| targetspecies.mutantears != initial(targetspecies.mutantears) \
			|| targetspecies.mutanthands != initial(targetspecies.mutanthands) \
			|| targetspecies.mutanttongue != initial(targetspecies.mutanttongue) \
			|| targetspecies.mutantliver != initial(targetspecies.mutantliver) \
			|| targetspecies.mutantstomach != initial(targetspecies.mutantstomach) \
			|| targetspecies.mutantappendix != initial(targetspecies.mutantappendix) \
			|| istype(humantarget.getorganslot(ORGAN_SLOT_EXTERNAL_WINGS), /obj/item/organ/external/wings/functional)

		render_list += "<span class='info ml-1'>Species: [targetspecies.name][mutant ? "-derived mutant" : ""]</span>\n"
		render_list += "<span class='info ml-1'>Core temperature: [round(humantarget.coretemperature-T0C,0.1)] &deg;C ([round(humantarget.coretemperature*1.8-459.67,0.1)] &deg;F)</span>\n"
	render_list += "<span class='info ml-1'>Body temperature: [round(target.bodytemperature-T0C,0.1)] &deg;C ([round(target.bodytemperature*1.8-459.67,0.1)] &deg;F)</span>\n"

	// Blood Level
	var/mob/living/carbon/carbontarget = target
	var/blood_id = carbontarget.get_blood_id()
	if(blood_id)
		var/blood_percent = round((carbontarget.blood_volume / BLOOD_VOLUME_NORMAL) * 100)
		var/blood_type = carbontarget.dna.blood_type
		if(blood_id != /datum/reagent/blood) // special blood substance
			var/datum/reagent/real_reagent = GLOB.chemical_reagents_list[blood_id]
			blood_type = real_reagent?.name || blood_id
		if(carbontarget.blood_volume <= BLOOD_VOLUME_SAFE && carbontarget.blood_volume > BLOOD_VOLUME_OKAY)
			render_list += "<span class='alert ml-1'>Blood level: LOW [blood_percent]%, [carbontarget.blood_volume] cl,</span> [span_info("type: [blood_type]")]<br>"
		else if(carbontarget.blood_volume <= BLOOD_VOLUME_OKAY)
			render_list += "<span class='alert ml-1'>Blood level: <b>CRITICAL [blood_percent]%</b>, [carbontarget.blood_volume] cl,</span> [span_info("type: [blood_type]")]<br>"
		else
			render_list += "<span class='info ml-1'>Blood level: [blood_percent]%, [carbontarget.blood_volume] cl, type: [blood_type]</span><br>"

	var/blood_alcohol_content = target.get_blood_alcohol_content()
	if(blood_alcohol_content > 0)
		if(blood_alcohol_content >= 0.24)
			render_list += "<span class='alert ml-1'>Blood alcohol content: <b>CRITICAL [blood_alcohol_content]%</b></span><br>"
		else
			render_list += "<span class='info ml-1'>Blood alcohol content: [blood_alcohol_content]%</span><br>"

	//Diseases
	var/disease_hr = FALSE
	for(var/datum/disease/disease as anything in target.diseases)
		if(disease.visibility_flags & HIDDEN_SCANNER)
			continue
		if(!disease_hr)
			render_list += "<hr>"
			disease_hr = TRUE
		render_list += "<span class='alert ml-1'>\
			<b>Warning: [disease.form] detected</b><br>\
			<div class='ml-2'>\
			Name: [disease.name].<br>\
			Type: [disease.spread_text].<br>\
			Stage: [disease.stage]/[disease.max_stages].<br>\
			Possible Cure: [disease.cure_text]</div>\
			</span>"

	// Time of death
	if(target.tod && (target.stat == DEAD || (HAS_TRAIT(target, TRAIT_FAKEDEATH) && !advanced)))
		render_list += "<hr>"
		render_list += "<span class='info ml-1'>Time of Death: [target.tod]</span><br>"
		render_list += "<span class='alert ml-1'><b>Subject died [DisplayTimeText(round(world.time - target.timeofdeath))] ago.</b></span><br>"

	. = jointext(render_list, "")
	if(tochat)
		to_chat(user, examine_block(.), trailing_newline = FALSE, type = MESSAGE_TYPE_INFO)
	return .

// /obj/item/healthanalyzer/click_ctrl_shift(mob/user)
// 	. = ..()
// 	if(!LAZYLEN(last_scan_text))
// 		balloon_alert(user, "no scans!")
// 		return
// 	if(scanner_busy)
// 		balloon_alert(user, "analyzer busy!")
// 		return
// 	scanner_busy = TRUE
// 	balloon_alert(user, "printing report...")
// 	addtimer(CALLBACK(src, PROC_REF(print_report)), 2 SECONDS)

// /obj/item/healthanalyzer/proc/print_report(mob/user)
// 	var/obj/item/paper/report_paper = new(get_turf(src))

// 	report_paper.color = "#99ccff"
// 	report_paper.name = "health scan report - [station_time_timestamp()]"
// 	var/report_text = "<center><B>Health scan report. Time of retrieval: [station_time_timestamp()]</B></center><HR>"
// 	report_text += last_scan_text

// 	report_paper.add_raw_text(report_text)
// 	report_paper.update_appearance()

// 	if(ismob(loc))
// 		var/mob/printer = loc
// 		printer.put_in_hands(report_paper)
// 		balloon_alert(printer, "logs cleared")

// 	report_text = list()
// 	scanner_busy = FALSE

/proc/chemscan(mob/living/user, mob/living/target)
	if(user.incapacitated())
		return

	if(user.is_blind())
		to_chat(user, span_warning("You realize that your scanner has no accessibility support for the blind!"))
		return

	if(istype(target) && target.reagents)
		var/render_list = list()

		// Blood reagents
		if(target.reagents.reagent_list.len)
			render_list += "<span class='notice ml-1'>Subject contains the following reagents in their blood:</span>\n"
			for(var/r in target.reagents.reagent_list)
				var/datum/reagent/reagent = r
				if(reagent.chemical_flags & REAGENT_INVISIBLE) //Don't show hidden chems on scanners
					continue
				render_list += "<span class='notice ml-2'>[round(reagent.volume, 0.001)] units of [reagent.name][reagent.overdosed ? "</span> - [span_boldannounce("OVERDOSING")]" : ".</span>"]\n"
		else
			render_list += "<span class='notice ml-1'>Subject contains no reagents in their blood.</span>\n"

		// Stomach reagents
		var/obj/item/organ/internal/stomach/belly = target.getorganslot(ORGAN_SLOT_STOMACH)
		if(belly)
			if(belly.reagents.reagent_list.len)
				render_list += "<span class='notice ml-1'>Subject contains the following reagents in their stomach:</span>\n"
				for(var/bile in belly.reagents.reagent_list)
					var/datum/reagent/bit = bile
					if(bit.chemical_flags & REAGENT_INVISIBLE) //Don't show hidden chems on scanners
						continue
					if(!belly.food_reagents[bit.type])
						render_list += "<span class='notice ml-2'>[round(bit.volume, 0.001)] units of [bit.name][bit.overdosed ? "</span> - [span_boldannounce("OVERDOSING")]" : ".</span>"]\n"
					else
						var/bit_vol = bit.volume - belly.food_reagents[bit.type]
						if(bit_vol > 0)
							render_list += "<span class='notice ml-2'>[round(bit_vol, 0.001)] units of [bit.name][bit.overdosed ? "</span> - [span_boldannounce("OVERDOSING")]" : ".</span>"]\n"
			else
				render_list += "<span class='notice ml-1'>Subject contains no reagents in their stomach.</span>\n"

		// Addictions
		if(LAZYLEN(target.mind?.active_addictions))
			render_list += "<span class='boldannounce ml-1'>Subject is addicted to the following types of drug:</span>\n"
			for(var/datum/addiction/addiction_type as anything in target.mind.active_addictions)
				render_list += "<span class='alert ml-2'>[initial(addiction_type.name)]</span>\n"

		// Special eigenstasium addiction
		if(target.has_status_effect(/datum/status_effect/eigenstasium))
			render_list += "<span class='notice ml-1'>Subject is temporally unstable. Stabilising agent is recommended to reduce disturbances.</span>\n"

		// Allergies
		for(var/datum/quirk/quirky as anything in target.quirks)
			if(istype(quirky, /datum/quirk/item_quirk/allergic))
				var/datum/quirk/item_quirk/allergic/allergies_quirk = quirky
				var/allergies = allergies_quirk.allergy_string
				render_list += "<span class='alert ml-1'>Subject is extremely allergic to the following chemicals:</span>\n"
				render_list += "<span class='alert ml-2'>[allergies]</span>\n"

		// we handled the last <br> so we don't need handholding
		to_chat(user, examine_block(jointext(render_list, "")), trailing_newline = FALSE, type = MESSAGE_TYPE_INFO)

/obj/item/healthanalyzer/AltClick(mob/user)
	..()

	if(!user.canUseTopic(src, BE_CLOSE))
		return

	mode = !mode
	to_chat(user, mode == SCANNER_VERBOSE ? "The scanner now shows specific limb damage." : "The scanner no longer shows limb damage.")

/obj/item/healthanalyzer/advanced
	name = "advanced health analyzer"
	icon_state = "health_adv"
	desc = "A hand-held body scanner able to distinguish vital signs of the subject with high accuracy."
	advanced = TRUE

/// Displays wounds with extended information on their status vs medscanners
/proc/woundscan(mob/user, mob/living/carbon/patient, obj/item/healthanalyzer/wound/scanner)
	if(!istype(patient) || user.incapacitated())
		return

	if(user.is_blind())
		to_chat(user, span_warning("You realize that your scanner has no accessibility support for the blind!"))
		return

	var/render_list = ""
	for(var/i in patient.get_wounded_bodyparts())
		var/obj/item/bodypart/wounded_part = i
		render_list += "<span class='alert ml-1'><b>Warning: Physical trauma[LAZYLEN(wounded_part.wounds) > 1? "s" : ""] detected in [wounded_part.name]</b>"
		for(var/k in wounded_part.wounds)
			var/datum/wound/W = k
			render_list += "<div class='ml-2'>[W.get_scanner_description()]</div>\n"
		render_list += "</span>"

	if(render_list == "")
		if(istype(scanner))
			// Only emit the cheerful scanner message if this scan came from a scanner
			playsound(scanner, 'sound/machines/ping.ogg', 50, FALSE)
			to_chat(user, span_notice("\The [scanner] makes a happy ping and briefly displays a smiley face with several exclamation points! It's really excited to report that [patient] has no wounds!"))
		else
			to_chat(user, "<span class='notice ml-1'>No wounds detected in subject.</span>")
	else
		to_chat(user, examine_block(jointext(render_list, "")), type = MESSAGE_TYPE_INFO)

/obj/item/healthanalyzer/wound
	name = "first aid analyzer"
	icon_state = "adv_spectrometer"
	desc = "A prototype MeLo-Tech medical scanner used to diagnose injuries and recommend treatment for serious wounds, but offers no further insight into the patient's health. You hope the final version is less annoying to read!"
	var/next_encouragement
	var/greedy

/obj/item/healthanalyzer/wound/attack_self(mob/user)
	if(next_encouragement < world.time)
		playsound(src, 'sound/machines/ping.ogg', 50, FALSE)
		var/list/encouragements = list("briefly displays a happy face, gazing emptily at you", "briefly displays a spinning cartoon heart", "displays an encouraging message about eating healthy and exercising", \
				"reminds you that everyone is doing their best", "displays a message wishing you well", "displays a sincere thank-you for your interest in first-aid", "formally absolves you of all your sins")
		to_chat(user, span_notice("\The [src] makes a happy ping and [pick(encouragements)]!"))
		next_encouragement = world.time + 10 SECONDS
		greedy = FALSE
	else if(!greedy)
		to_chat(user, span_warning("\The [src] displays an eerily high-definition frowny face, chastizing you for asking it for too much encouragement."))
		greedy = TRUE
	else
		playsound(src, 'sound/machines/buzz-sigh.ogg', 50, FALSE)
		if(isliving(user))
			var/mob/living/L = user
			to_chat(L, span_warning("\The [src] makes a disappointed buzz and pricks your finger for being greedy. Ow!"))
			L.adjustBruteLoss(4)
			L.dropItemToGround(src)

/obj/item/healthanalyzer/wound/attack(mob/living/carbon/patient, mob/living/carbon/human/user)
	add_fingerprint(user)
	user.visible_message(span_notice("[user] scans [patient] for serious injuries."), span_notice("You scan [patient] for serious injuries."))

	if(!istype(patient))
		playsound(src, 'sound/machines/buzz-sigh.ogg', 30, TRUE)
		to_chat(user, span_notice("\The [src] makes a sad buzz and briefly displays a frowny face, indicating it can't scan [patient]."))
		return

	woundscan(user, patient, src)

#undef SCANMODE_HEALTH
#undef SCANMODE_WOUND
#undef SCANMODE_COUNT
#undef SCANNER_CONDENSED
#undef SCANNER_VERBOSE
