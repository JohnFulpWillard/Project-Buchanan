//**************
//*****Keys*******************
//**************		**  **
/obj/item/keycard
	name = "security keycard"
	desc = "This feels like it belongs to a door."
	icon = 'icons/obj/puzzle_small.dmi'
	icon_state = "keycard"
	force = 0
	throwforce = 0
	w_class = WEIGHT_CLASS_TINY
	throw_speed = 1
	throw_range = 7
	resistance_flags = INDESTRUCTIBLE | FIRE_PROOF | ACID_PROOF | LAVA_PROOF
	var/puzzle_id = null

//Two test keys for use alongside the two test doors.
/obj/item/keycard/cheese
	name = "cheese keycard"
	desc = "Look, I still don't understand the reference. What the heck is a keyzza?"
	color = "#f0da12"
	puzzle_id = "cheese"

/obj/item/keycard/swordfish
	name = "titanic keycard"
	desc = "Smells like it was at the bottom of a harbor."
	color = "#3bbbdb"
	puzzle_id = "swordfish"

/obj/item/keycard/deathclaw
	name = "titanic keycard"
	desc = "Smells like it was stuck in the jaw of that plated Deathclaw. Nasty!"
	color = "#9edb3b"
	puzzle_id = "deathclaw"

/obj/item/keycard/vault
	name = "titanic keycard"
	desc = "It seems a bit burned from the explosion, but otherwise fine!"
	color = "#e93737"
	puzzle_id = "vault"

/obj/item/keycard/nml1
	name = "titanic keycard"
	desc = "There is a fat wad of glowing radioactive goo sticking to this card."
	color = "#1cff42"
	puzzle_id = "nmlmutant"

/obj/item/keycard/nml2
	name = "titanic keycard"
	desc = "Smells like it was stuck in the jaw of that plated Deathclaw. Nasty!"
	color = "#07a569"
	puzzle_id = "nmldeathclaw"

//***************
//*****Doors*****
//***************

/obj/machinery/door/keycard
	name = "locked door"
	desc = "This door only opens when a keycard is swiped. It looks virtually indestructable."
	icon = 'icons/obj/doors/puzzledoor/default.dmi'
	icon_state = "door_closed"
	explosion_block = 3
	heat_proof = TRUE
	max_integrity = 600
	armor = list("melee" = 100, "bullet" = 100, "laser" = 100, "energy" = 100, "bomb" = 100, "bio" = 100, "rad" = 100, "fire" = 100, "acid" = 100)
	resistance_flags = INDESTRUCTIBLE | FIRE_PROOF | ACID_PROOF | LAVA_PROOF
	damage_deflection = 70
	/// Make sure that the key has the same puzzle_id as the keycard door!
	var/puzzle_id = null
	/// Message that occurs when the door is opened
	var/open_message = "The door beeps, and slides opens."

//Standard Expressions to make keycard doors basically un-cheeseable
/obj/machinery/door/keycard/Bumped(atom/movable/AM)
	return !density && ..()

/obj/machinery/door/keycard/emp_act(severity)
	return

/obj/machinery/door/keycard/ex_act(severity, target)
	return

/obj/machinery/door/keycard/try_to_activate_door(mob/user)
	add_fingerprint(user)
	if(operating)
		return

/obj/machinery/door/keycard/attackby(obj/item/I, mob/user, params)
	. = ..()
	if(istype(I,/obj/item/keycard))
		var/obj/item/keycard/key = I
		if((!puzzle_id || puzzle_id == key.puzzle_id)  && density)
			if(open_message)
				to_chat(user, span_notice("[open_message]"))
			open()
			return
		else if(puzzle_id != key.puzzle_id)
			to_chat(user, span_notice("[src] buzzes. This must not be the right key."))
			return
		else
			to_chat(user, span_notice("This door doesn't appear to close."))
			return

//Test doors. Gives admins a few doors to use quickly should they so choose.
/obj/machinery/door/keycard/cheese
	name = "blue airlock"
	desc = "Smells like... pizza?"
	puzzle_id = "cheese"

/obj/machinery/door/keycard/swordfish
	name = "blue airlock"
	desc = "If nautical nonsense be something you wish."
	puzzle_id = "swordfish"

//*************************
//***Box Pushing Puzzles***
//*************************
//We're working off a subtype of pressureplates, which should work just a BIT better now.
/obj/structure/holobox
	name = "holobox"
	desc = "A hard-light box, containing a secure decryption key."
	icon = 'icons/obj/puzzle_small.dmi'
	icon_state = "laserbox"
	density = TRUE
	resistance_flags = INDESTRUCTIBLE | FIRE_PROOF | ACID_PROOF | LAVA_PROOF

//Uses the pressure_plate settings for a pretty basic custom pattern that waits for a specific item to trigger. Easy enough to retool for mapping purposes or subtypes.
/obj/item/pressure_plate/hologrid
	name = "hologrid"
	desc = "A high power, electronic input port for a holobox, which can unlock the hologrid's storage compartment. Safe to stand on."
	icon = 'icons/obj/puzzle_small.dmi'
	icon_state = "lasergrid"
	anchored = TRUE
	trigger_mob = FALSE
	trigger_item = TRUE
	specific_item = /obj/structure/holobox
	removable_signaller = FALSE //Being a pressure plate subtype, this can also use signals.
	roundstart_signaller_freq = FREQ_HOLOGRID_SOLUTION //Frequency is kept on it's own default channel however.
	active = TRUE
	trigger_delay = 10
	resistance_flags = INDESTRUCTIBLE | FIRE_PROOF | ACID_PROOF | LAVA_PROOF
	var/reward = /obj/item/reagent_containers/food/snacks/cookie
	var/claimed = FALSE

/obj/item/pressure_plate/hologrid/examine(mob/user)
	. = ..()
	if(claimed)
		. += span_notice("This one appears to be spent already.")

/obj/item/pressure_plate/hologrid/trigger()
	if(!claimed)
		new reward(loc)
	flick("lasergrid_a",src)
	icon_state = "lasergrid_full"
	claimed = TRUE

/obj/item/pressure_plate/hologrid/on_entered(datum/source, atom/movable/enterer, atom/old_loc, list/atom/old_locs)
	. = ..()
	if(!.)
		return
	if(trigger_item && istype(enterer, specific_item) && !claimed)
		enterer.anchored = TRUE
		flick("laserbox_burn", enterer)
		trigger()
		QDEL_IN(enterer, 15)

// snowflake code until undertile elements
/obj/item/pressure_plate/hologrid/hide()
	. = ..()
	anchored = TRUE
