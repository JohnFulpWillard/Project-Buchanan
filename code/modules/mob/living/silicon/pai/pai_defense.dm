#define PAI_EMP_SILENCE_DURATION 3 MINUTES

/mob/living/silicon/pai/blob_act(obj/structure/blob/B)
	return FALSE

/mob/living/silicon/pai/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return
	take_holo_damage(severity/2)
	DefaultCombatKnockdown(severity*4)
	silent = max(silent, (PAI_EMP_SILENCE_DURATION) / SSmobs.wait / severity)
	if(holoform)
		fold_in(force = TRUE)
	emitter_next_use = world.time + emitter_emp_cd
	//Need more effects that aren't instadeath or permanent law corruption.

/mob/living/silicon/pai/ex_act(severity, target)
	take_holo_damage(severity * 50)
	switch(severity)
		if(1)	//RIP
			qdel(card)
			qdel(src)
		if(2)
			fold_in(force = 1)
			DefaultCombatKnockdown(400)
		if(3)
			fold_in(force = 1)
			DefaultCombatKnockdown(200)

/mob/living/silicon/pai/on_attack_hand(mob/living/carbon/human/user)
	switch(user.a_intent)
		if(INTENT_HELP)
			visible_message(span_notice("[user] gently pats [src] on the head, eliciting an off-putting buzzing from its holographic field."),
				span_notice("[user] gently pats you on the head, eliciting an off-putting buzzing from your holographic field."))
		if(INTENT_DISARM)
			visible_message(span_notice("[user] boops [src] on the head!"),
				span_notice("[user] boops you on the head!"))
		if(INTENT_HARM)
			user.do_attack_animation(src)
			if (user.name == master)
				visible_message(span_notice("Responding to its master's touch, [src] disengages its holochassis emitter, rapidly losing coherence."))
				fold_in()
				if(user.put_in_hands(card))
					user.visible_message(span_notice("[user] promptly scoops up [user.p_their()] pAI's card."),
						span_notice("You promptly scoops up your pAI's card."))
			else
				if(HAS_TRAIT(user, TRAIT_PACIFISM))
					to_chat(user, span_notice("You don't want to hurt [src]!"))
					return
				visible_message(span_danger("[user] stomps on [src]!."),
					span_userdanger("[user] stomps on you!."))
				take_holo_damage(2)
		else
			grabbedby(user)

/mob/living/silicon/pai/bullet_act(obj/item/projectile/P, def_zone)
	if(P.stun)
		fold_in(force = TRUE)
		visible_message(span_warning("The electrically-charged projectile disrupts [src]'s holomatrix, forcing [src] to fold in!"))
	. = ..()
	return BULLET_ACT_FORCE_PIERCE

/mob/living/silicon/pai/stripPanelUnequip(obj/item/what, mob/who, where) //prevents stripping
	to_chat(src, span_warning("Your holochassis stutters and warps intensely as you attempt to interact with the object, forcing you to cease lest the field fail."))

/mob/living/silicon/pai/stripPanelEquip(obj/item/what, mob/who, where) //prevents stripping
	to_chat(src, span_warning("Your holochassis stutters and warps intensely as you attempt to interact with the object, forcing you to cease lest the field fail."))

/mob/living/silicon/pai/IgniteMob(mob/living/silicon/pai/P)
	return FALSE //No we're not flammable

/mob/living/silicon/pai/proc/take_holo_damage(amount)
	emitterhealth = clamp((emitterhealth - amount), -50, emittermaxhealth)
	if(emitterhealth < 0)
		fold_in(force = TRUE)
	if(amount > 0)
		to_chat(src, span_userdanger("The impact degrades your holochassis!"))
	return amount

/mob/living/silicon/pai/adjustBruteLoss(amount, updating_health = TRUE, forced = FALSE)
	return take_holo_damage(amount)

/mob/living/silicon/pai/adjustFireLoss(amount, updating_health = TRUE, forced = FALSE)
	return take_holo_damage(amount)

/mob/living/silicon/pai/adjustToxLoss(amount, updating_health = TRUE, forced = FALSE)
	return FALSE

/mob/living/silicon/pai/adjustOxyLoss(amount, updating_health = TRUE, forced = FALSE)
	return FALSE

/mob/living/silicon/pai/adjustCloneLoss(amount, updating_health = TRUE, forced = FALSE)
	return FALSE

/mob/living/silicon/pai/adjustStaminaLoss(amount, updating_health, forced = FALSE)
	if(forced)
		take_holo_damage(amount)
	else
		take_holo_damage(amount * 0.25)

/mob/living/silicon/pai/adjustOrganLoss(slot, amount, maximum = 500) //I kept this in, unlike tg
	DefaultCombatKnockdown(amount * 0.2)

/mob/living/silicon/pai/getBruteLoss()
	return emittermaxhealth - emitterhealth

/mob/living/silicon/pai/getFireLoss()
	return emittermaxhealth - emitterhealth

/mob/living/silicon/pai/getToxLoss()
	return FALSE

/mob/living/silicon/pai/getOxyLoss()
	return FALSE

/mob/living/silicon/pai/getCloneLoss()
	return FALSE

/mob/living/silicon/pai/getStaminaLoss()
	return FALSE

/mob/living/silicon/pai/setCloneLoss()
	return FALSE

/mob/living/silicon/pai/setStaminaLoss()
	return FALSE

/mob/living/silicon/pai/setToxLoss()
	return FALSE

/mob/living/silicon/pai/setOxyLoss()
	return FALSE
