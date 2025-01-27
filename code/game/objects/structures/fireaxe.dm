/obj/structure/fireaxecabinet
	name = "fire axe cabinet"
	desc = "There is a small label that reads \"For Emergency use only\" along with details for safe use of the axe. As if."
	icon = 'icons/obj/wallmounts.dmi'
	icon_state = "fireaxe"
	plane = ABOVE_WALL_PLANE
	anchored = TRUE
	density = FALSE
	armor = list("melee" = 50, "bullet" = 20, "laser" = 0, "energy" = 100, "bomb" = 10, "bio" = 100, "rad" = 100, "fire" = 90, "acid" = 50)
	max_integrity = 150
	integrity_failure = 0.33
	var/locked = TRUE
	var/open = FALSE
	var/obj/item/twohanded/fireaxe/fireaxe

/obj/structure/fireaxecabinet/Initialize()
	. = ..()
	fireaxe = new
	update_icon()

/obj/structure/fireaxecabinet/Destroy()
	if(fireaxe)
		QDEL_NULL(fireaxe)
	return ..()

/obj/structure/fireaxecabinet/attackby(obj/item/I, mob/user, params)
	if(iscyborg(user) || istype(I, /obj/item/multitool))
		toggle_lock(user)
	else if(istype(I, /obj/item/weldingtool) && user.a_intent == INTENT_HELP && !broken)
		if(obj_integrity < max_integrity)
			if(!I.tool_start_check(user, amount=2))
				return

			to_chat(user, span_notice("You begin repairing [src]."))
			if(I.use_tool(src, user, 40, volume=50, amount=2))
				obj_integrity = max_integrity
				update_icon()
				to_chat(user, span_notice("You repair [src]."))
		else
			to_chat(user, span_warning("[src] is already in good condition!"))
		return
	else if(istype(I, /obj/item/stack/sheet/glass) && broken)
		var/obj/item/stack/sheet/glass/G = I
		if(G.get_amount() < 2)
			to_chat(user, span_warning("You need two glass sheets to fix [src]!"))
			return
		to_chat(user, span_notice("You start fixing [src]..."))
		if(do_after(user, 20, target = src) && G.use(2))
			broken = 0
			obj_integrity = max_integrity
			update_icon()
	else if(open || broken)
		if(istype(I, /obj/item/twohanded/fireaxe) && !fireaxe)
			var/obj/item/twohanded/fireaxe/F = I
			if(F.wielded)
				to_chat(user, span_warning("Unwield the [F.name] first."))
				return
			if(!user.transferItemToLoc(F, src))
				return
			fireaxe = F
			to_chat(user, span_caution("You place the [F.name] back in the [name]."))
			update_icon()
			return
		else if(!broken)
			toggle_open()
	else
		return ..()

/obj/structure/fireaxecabinet/play_attack_sound(damage_amount, damage_type = BRUTE, damage_flag = 0)
	switch(damage_type)
		if(BRUTE)
			if(broken)
				playsound(loc, 'sound/effects/hit_on_shattered_glass.ogg', 90, 1)
			else
				playsound(loc, 'sound/effects/glasshit.ogg', 90, 1)
		if(BURN)
			playsound(src.loc, 'sound/items/welder.ogg', 100, 1)

/obj/structure/fireaxecabinet/take_damage(damage_amount, damage_type = BRUTE, damage_flag = 0, sound_effect = 1, attack_dir)
	if(open)
		return
	. = ..()
	if(.)
		update_icon()

/obj/structure/fireaxecabinet/obj_break(damage_flag)
	if(!broken && !(flags_1 & NODECONSTRUCT_1))
		update_icon()
		broken = TRUE
		playsound(src, 'sound/effects/glassbr3.ogg', 100, 1)
		new /obj/item/shard(loc)
		new /obj/item/shard(loc)

/obj/structure/fireaxecabinet/deconstruct(disassembled = TRUE)
	if(!(flags_1 & NODECONSTRUCT_1))
		if(fireaxe && loc)
			fireaxe.forceMove(loc)
			fireaxe = null
		new /obj/item/stack/sheet/metal(loc, 2)
	qdel(src)

/obj/structure/fireaxecabinet/blob_act(obj/structure/blob/B)
	if(fireaxe)
		fireaxe.forceMove(loc)
		fireaxe = null
	qdel(src)

/obj/structure/fireaxecabinet/on_attack_hand(mob/user, act_intent = user.a_intent, unarmed_attack_flags)
	if(open || broken)
		if(fireaxe)
			user.put_in_hands(fireaxe)
			fireaxe = null
			to_chat(user, span_caution("You take the fire axe from the [name]."))
			src.add_fingerprint(user)
			update_icon()
			return
	if(locked)
		to_chat(user, span_warning("The [name] won't budge!"))
		return
	else
		open = !open
		update_icon()
		return

/obj/structure/fireaxecabinet/attack_paw(mob/living/user)
	return attack_hand(user)

/obj/structure/fireaxecabinet/attack_ai(mob/user)
	toggle_lock(user)
	return

/obj/structure/fireaxecabinet/attack_tk(mob/user)
	if(locked)
		to_chat(user, span_warning("The [name] won't budge!"))
		return
	else
		open = !open
		update_icon()
		return

/obj/structure/fireaxecabinet/update_overlays()
	. = ..()
	if(fireaxe)
		. += "axe"
	if(!open)
		var/hp_percent = obj_integrity/max_integrity * 100
		if(broken)
			. += "glass4"
		else
			switch(hp_percent)
				if(-INFINITY to 40)
					. += "glass3"
				if(40 to 60)
					. += "glass2"
				if(60 to 80)
					. += "glass1"
				if(80 to INFINITY)
					. += "glass"
		if(locked)
			. += "locked"
		else
			. += "unlocked"
	else
		. += "glass_raised"

/obj/structure/fireaxecabinet/proc/toggle_lock(mob/user)
	to_chat(user, "<span class = 'caution'> Resetting circuitry...</span>")
	playsound(src, 'sound/machines/locktoggle.ogg', 50, 1)
	if(do_after(user, 20, target = src))
		to_chat(user, span_caution("You [locked ? "disable" : "re-enable"] the locking modules."))
		locked = !locked
		update_icon()

/obj/structure/fireaxecabinet/verb/toggle_open()
	set name = "Open/Close"
	set category = "Object"
	set src in oview(1)

	if(locked)
		to_chat(usr, span_warning("The [name] won't budge!"))
		return
	else
		open = !open
		update_icon()
		return
