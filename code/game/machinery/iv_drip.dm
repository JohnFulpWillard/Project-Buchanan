#define IV_TAKING 0
#define IV_INJECTING 1

/obj/machinery/iv_drip
	name = "\improper IV drip"
	desc = "An IV drip with an advanced infusion pump that can both drain blood into and inject liquids from attached containers. Blood packs are processed at an accelerated rate. Alt-Click to change the transfer rate."
	icon = 'icons/obj/iv_drip.dmi'
	icon_state = "iv_drip"
	anchored = FALSE
	mouse_drag_pointer = MOUSE_ACTIVE_POINTER
	drag_delay = 0.05 SECONDS
	var/mob/living/carbon/attached
	var/mode = IV_INJECTING
	var/dripfeed = FALSE
	var/obj/item/reagent_containers/beaker
	var/static/list/drip_containers = typecacheof(list(/obj/item/reagent_containers/blood,
									/obj/item/reagent_containers/food,
									/obj/item/reagent_containers/glass,
									/obj/item/reagent_containers/chem_pack))

/obj/machinery/iv_drip/Initialize(mapload)
	. = ..()
	update_icon()

/obj/machinery/iv_drip/Destroy()
	attached = null
	QDEL_NULL(beaker)
	return ..()

/obj/machinery/iv_drip/update_icon_state()
	if(attached)
		if(mode)
			icon_state = "injecting"
		else
			icon_state = "donating"
	else
		if(mode)
			icon_state = "injectidle"
		else
			icon_state = "donateidle"

/obj/machinery/iv_drip/update_overlays()
	. = ..()

	if(beaker)
		if(attached)
			. += "beakeractive"
		else
			. += "beakeridle"
		if(beaker.reagents.total_volume)
			var/mutable_appearance/filling_overlay = mutable_appearance('icons/obj/iv_drip.dmi', "reagent")

			var/percent = round((beaker.reagents.total_volume / beaker.volume) * 100)
			switch(percent)
				if(0 to 9)
					filling_overlay.icon_state = "reagent0"
				if(10 to 24)
					filling_overlay.icon_state = "reagent10"
				if(25 to 49)
					filling_overlay.icon_state = "reagent25"
				if(50 to 74)
					filling_overlay.icon_state = "reagent50"
				if(75 to 79)
					filling_overlay.icon_state = "reagent75"
				if(80 to 90)
					filling_overlay.icon_state = "reagent80"
				if(91 to INFINITY)
					filling_overlay.icon_state = "reagent100"

			filling_overlay.color = mix_color_from_reagents(beaker.reagents.reagent_list)
			. += filling_overlay

/obj/machinery/iv_drip/MouseDrop(mob/living/target)
	. = ..()
	if(!ishuman(usr) || !usr.canUseTopic(src, BE_CLOSE) || !isliving(target))
		return

	if(attached)
		visible_message(span_warning("[attached] is detached from [src]."))
		attached = null
		update_icon()
		return

	if(!target.has_dna())
		to_chat(usr, span_danger("The drip beeps: Warning, incompatible creature!"))
		return

	if(Adjacent(target) && usr.Adjacent(target))
		if(beaker)
			usr.visible_message(span_warning("[usr] attaches [src] to [target]."), span_notice("You attach [src] to [target]."))
			log_combat(usr, target, "attached", src, "containing: [beaker.name] - ([beaker.reagents.log_list()])")
			add_fingerprint(usr)
			attached = target
			START_PROCESSING(SSmachines, src)
			update_icon()
		else
			to_chat(usr, span_warning("There's nothing attached to the IV drip!"))


/obj/machinery/iv_drip/attackby(obj/item/W, mob/user, params)
	if(is_type_in_typecache(W, drip_containers))
		if(beaker)
			to_chat(user, span_warning("There is already a reagent container loaded!"))
			return
		if(!user.transferItemToLoc(W, src))
			return
		beaker = W
		to_chat(user, span_notice("You attach [W] to [src]."))
		user.log_message("attached a [W] to [src] at [AREACOORD(src)] containing ([beaker.reagents.log_list()])", LOG_ATTACK)
		add_fingerprint(user)
		update_icon()
		return
	else
		return ..()

/obj/machinery/iv_drip/deconstruct(disassembled = TRUE)
	if(!(flags_1 & NODECONSTRUCT_1))
		new /obj/item/stack/sheet/metal(loc)
	qdel(src)

/obj/machinery/iv_drip/process()
	if(!attached)
		return PROCESS_KILL

	if(!(get_dist(src, attached) <= 1 && isturf(attached.loc)))
		to_chat(attached, span_userdanger("The IV drip needle is ripped out of you!"))
		attached.apply_damage(3, BRUTE, pick(BODY_ZONE_R_ARM, BODY_ZONE_L_ARM))
		attached = null
		update_icon()
		return PROCESS_KILL

	if(beaker)
		// Give blood
		if(mode)
			if(beaker.reagents.total_volume)
				var/transfer_amount = 5
				if (dripfeed)
					transfer_amount = 1
				if(istype(beaker, /obj/item/reagent_containers/blood))
					// speed up transfer on blood packs
					transfer_amount *= 2
				var/fraction = min(transfer_amount/beaker.reagents.total_volume, 1) //the fraction that is transfered of the total volume
				beaker.reagents.reaction(attached, INJECT, fraction, FALSE) //make reagents reacts, but don't spam messages
				beaker.reagents.trans_to(attached, transfer_amount)
				update_icon()

		// Take blood
		else
			var/amount = beaker.reagents.maximum_volume - beaker.reagents.total_volume
			amount = min(amount, 4)
			// If the beaker is full, ping
			if(!amount)
				if(prob(5))
					visible_message("[src] pings.")
					playsound(loc, 'sound/machines/beep.ogg', 50, 1)
				return

			// If the human is losing too much blood, beep.
			if(attached.blood_volume < ((BLOOD_VOLUME_SAFE*attached.blood_ratio) && prob(5) && ishuman(attached))) //really couldn't care less about monkeys
				visible_message("[src] beeps loudly.")
				playsound(loc, 'sound/machines/twobeep.ogg', 50, 1)
			attached.transfer_blood_to(beaker, amount)
			update_icon()

/obj/machinery/iv_drip/on_attack_hand(mob/user, act_intent = user.a_intent, unarmed_attack_flags)
	if(attached)
		visible_message("[attached] is detached from [src]")
		attached = null
		update_icon()
		return
	else if(beaker)
		eject_beaker(user)
	else
		toggle_mode()

/obj/machinery/iv_drip/AltClick(mob/living/user)
	if(!user.canUseTopic(src, be_close=TRUE))
		return
	if(dripfeed)
		dripfeed = FALSE
		to_chat(usr, span_notice("You loosen the valve to speed up the [src]."))
	else
		dripfeed = TRUE
		to_chat(usr, span_notice("You tighten the valve to slowly drip-feed the contents of [src]."))

/obj/machinery/iv_drip/attack_robot(mob/user)
	if(Adjacent(user))
		attack_hand(user)

/obj/machinery/iv_drip/verb/eject_beaker(mob/user)
	set category = "Object"
	set name = "Remove IV Container"
	set src in view(1)

	if(!isliving(usr))
		to_chat(usr, span_warning("You can't do that!"))
		return

	if(usr.incapacitated())
		return
	if(beaker)
		if(usr && Adjacent(usr) && usr.can_hold_items())
			if(!usr.put_in_hands(beaker))
				beaker.forceMove(drop_location())
		if(iscyborg(user))
			beaker.forceMove(drop_location())
		beaker = null
		update_icon()

/obj/machinery/iv_drip/verb/toggle_mode()
	set category = "Object"
	set name = "Toggle Mode"
	set src in view(1)

	if(!isliving(usr))
		to_chat(usr, span_warning("You can't do that!"))
		return

	if(usr.incapacitated())
		return
	mode = !mode
	to_chat(usr, "The IV drip is now [mode ? "injecting" : "taking blood"].")
	update_icon()

/obj/machinery/iv_drip/examine(mob/user)
	. = ..()
	if(get_dist(user, src) > 2)
		return

	. += "[src] is [mode ? "injecting" : "taking blood"].\n"

	if(beaker)
		if(beaker.reagents && beaker.reagents.reagent_list.len)
			. += "\t[span_notice("Attached is \a [beaker] with [beaker.reagents.total_volume] units of liquid.")]\n"
		else
			. += "\t[span_notice("Attached is an empty [beaker.name].")]\n"
	else
		. += "\t[span_notice("No chemicals are attached.")]\n"

	. += "\t[span_notice("[attached ? attached : "No one"] is attached.")]"

/obj/machinery/iv_drip/telescopic
	name = "telescopic IV drip"
	desc = "An IV drip with an advanced infusion pump that can both drain blood into and inject liquids from attached containers. Blood packs are processed at an accelerated rate. This one is telescopic, and can be picked up and put down.Alt-Click with a beaker attached to change the transfer rate."
	icon_state = "iv_drip"

/obj/machinery/iv_drip/telescopic/update_icon_state()
	..()
	icon_state += "_tele"

/obj/machinery/iv_drip/telescopic/AltClick(mob/user)
	if (attached || beaker || !user.canUseTopic(src, BE_CLOSE))
		return ..()
	new /obj/item/tele_iv(get_turf(src))
	qdel(src)
	return TRUE

#undef IV_TAKING
#undef IV_INJECTING
