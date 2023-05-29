/*
Town access doors
Oasis government: 130  ACCESS_COMMAND
Sheriff/Deputy, Gatehouse etc: 62 ACCESS_GATEWAY
General access: 25 ACCESS_BAR
Clinic: 133 ACCESS_CLINIC
Church: 22 ACCESS_CHAPEL_OFFICE
Shopkeeper: 34 ACCESS_CARGO_BOT
Barkeep : 28 ACCESS_KITCHEN - you jebronis made default bar for no reason bruh
Prospector : 48 ACCESS_MINING
Detective : 4 ACCESS_FORENSICS_LOCKERS
here's a tip, go search DEFINES/access.dm
*/

/*
Mayor
*/

/datum/job/usps
	exp_type = EXP_TYPE_FALLOUT
	faction = FACTION_USPS
	department_flag = USPS
	selection_color = "#83a4c0"
	access = list(ACCESS_CARGO_BOT, ACCESS_USPS)
	minimal_access = list(ACCESS_CARGO_BOT, ACCESS_USPS)

/datum/job/usps/f13postmastergeneral
	title = "Postmaster General"
	flag = F13POSTMASTERGENERAL
	department_flag = FACTION_USPS
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Constitution"
	description = "You are the leader of the local post office, and possibly the highest ranking member of the postal service left. How you handle this burden is up to you. Sort mail, handle packages, fulfill orders from the requests console and most importantly... deliver hope."
	selection_color = "#83a4c0"
	display_order = JOB_DISPLAY_ORDER_POSTMASTERGENERAL


	outfit = /datum/outfit/job/usps/f13postmastergeneral
	access = list(ACCESS_USPS)
	minimal_access = list(ACCESS_USPS)
	matchmaking_allowed = list(
		/datum/matchmaking_pref/friend = list(
			/datum/job/wendover,
		),
		/datum/matchmaking_pref/rival = list(
			/datum/job/wendover,
		),
	)

/datum/outfit/job/usps/f13postmastergeneral/pre_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	..()
	if(visualsOnly)
		return
	ADD_TRAIT(H, TRAIT_HARD_YARDS, src)
	ADD_TRAIT(H, TRAIT_GENERIC, src)
	if(H.mind)
		var/obj/effect/proc_holder/spell/terrifying_presence/S = new /obj/effect/proc_holder/spell/terrifying_presence
		H.mind.AddSpell(S)

/datum/outfit/job/usps/f13postmastergeneral
	name = "Postmaster General"
	jobtype = /datum/job/usps/f13postmastergeneral

	ears = /obj/item/radio/headset/headset_usps
	id = /obj/item/card/id/usps
	satchel = /obj/item/storage/backpack/satchel/mail
	l_pocket = /obj/item/storage/bag/money/small/settler
	gloves = /obj/item/clothing/gloves/fingerless
	shoes = /obj/item/clothing/shoes/f13/fancy
	uniform = /obj/item/clothing/under/suit/turtle/grey
	suit = /obj/item/clothing/suit/armor/f13/USPSbomber
	suit_store = /obj/item/gun/ballistic/automatic/m1garand/oldglory
	backpack_contents = list(
		/obj/item/stamp/chameleon = 1,
		/obj/item/binoculars = 1,
		/obj/item/pda/quartermaster = 1,
		/obj/item/gun/ballistic/revolver/detective = 1,
		/obj/item/ammo_box/magazine/garand308 = 2,
		)


/*--------------------------------------------------------------*/

/datum/job/usps/f13mailcarrier
	title = "Mail Carrier"
	flag = F13MAILCARRIER
	department_flag = FACTION_USPS
	total_positions = 3
	spawn_positions = 3
	supervisors = "the Postmaster General"
	description = "You have taken upon yourself the honorable service of orchestrating the receipt and delivery of mail within the town of Wendover and its surrounding areas. In doing so you risk exposure to the elements, hostile mutants, ruthless opportunists and even a few dogs. Stand and deliver."
	selection_color = "#83a4c0"
	display_order = JOB_DISPLAY_ORDER_MAILCARRIER


	outfit = /datum/outfit/job/usps/f13mailcarrier
	access = list(ACCESS_USPS)
	minimal_access = list(ACCESS_USPS)
	matchmaking_allowed = list(
		/datum/matchmaking_pref/friend = list(
			/datum/job/wendover,
		),
		/datum/matchmaking_pref/rival = list(
			/datum/job/wendover,
		),
	)

/datum/outfit/job/usps/f13mailcarrier/pre_equip(mob/living/carbon/human/H)
	..()
	uniform = pick(
		/obj/item/clothing/under/f13/police/formal, \
		/obj/item/clothing/under/misc/mailman, \
		/obj/item/clothing/under/patriotsuit, \
		/obj/item/clothing/under/rank/civilian/lawyer/bluesuit, \
		/obj/item/clothing/under/f13/roving, \
		/obj/item/clothing/under/f13/merchant)

/datum/outfit/job/usps/f13mailcarrier/pre_equip(mob/living/carbon/human/H)
	..()
	suit = pick(
		/obj/item/clothing/suit/toggle/labcoat/depjacket/med, \
		/obj/item/clothing/suit/toggle/labcoat/depjacket/sec, \
		/obj/item/clothing/suit/armored/light/leather_jacket, \
		/obj/item/clothing/suit/jacket/miljacket, \
		/obj/item/clothing/suit/jacket)

/datum/outfit/job/usps/f13mailcarrier/pre_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	..()
	if(visualsOnly)
		return
	ADD_TRAIT(H, TRAIT_HARD_YARDS, src)
	ADD_TRAIT(H, TRAIT_GENERIC, src)

/datum/outfit/job/usps/f13mailcarrier
	name = "Mail Carrier"
	jobtype = /datum/job/usps/f13mailcarrier

	ears = /obj/item/radio/headset/headset_usps
	id = /obj/item/card/id/usps
	satchel = /obj/item/storage/backpack/satchel/mail
	l_pocket = /obj/item/storage/bag/money/small/settler
	shoes = /obj/item/clothing/shoes/jackboots
	suit_store = /obj/item/gun/ballistic/shotgun/hunting
	belt = /obj/item/storage/belt/fannypack/black
	backpack_contents = list(
		/obj/item/melee/onehanded/knife/bayonet = 1,
		/obj/item/binoculars = 1,
		/obj/item/gun/ballistic/revolver/detective = 1,
		/obj/item/ammo_box/shotgun/buck = 1,
		)


/*--------------------------------------------------------------*/
