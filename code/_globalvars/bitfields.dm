GLOBAL_LIST_INIT(bitfields, generate_bitfields())

/// Specifies a bitfield for smarter debugging
/datum/bitfield
	/// The variable name that contains the bitfield
	var/variable

	/// An associative list of the readable flag and its true value
	var/list/flags

/// Turns /datum/bitfield subtypes into a list for use in debugging
/proc/generate_bitfields()
	var/list/bitfields = list()
	for (var/_bitfield in subtypesof(/datum/bitfield))
		var/datum/bitfield/bitfield = new _bitfield
		bitfields[bitfield.variable] = bitfield.flags
	return bitfields

DEFINE_BITFIELD(admin_flags, list(
	"ADMIN" = R_ADMIN,
	"BAN" = R_BAN,
	"DBRANKS" = R_DBRANKS,
	"DEBUG" = R_DEBUG,
	"FUN" = R_FUN,
	"PERMISSIONS" = R_PERMISSIONS,
	"POLL" = R_POLL,
	"POSSESS" = R_POSSESS,
	"SERVER" = R_SERVER,
	"SPAWN" = R_SPAWN,
	"STEALTH" = R_STEALTH,
	"VAREDIT" = R_VAREDIT,
))

DEFINE_BITFIELD(appearance_flags, list(
	"KEEP_APART" = KEEP_APART,
	"KEEP_TOGETHER" = KEEP_TOGETHER,
	"LONG_GLIDE" = LONG_GLIDE,
	"NO_CLIENT_COLOR" = NO_CLIENT_COLOR,
	"PIXEL_SCALE" = PIXEL_SCALE,
	"PLANE_MASTER" = PLANE_MASTER,
	"RESET_ALPHA" = RESET_ALPHA,
	"RESET_COLOR" = RESET_COLOR,
	"RESET_TRANSFORM" = RESET_TRANSFORM,
	"TILE_BOUND" = TILE_BOUND,
))

DEFINE_BITFIELD(clothing_flags, list(
	"LAVAPROTECT" = LAVAPROTECT,
	"STOPSPRESSUREDAMAGE" = STOPSPRESSUREDAMAGE,
	"BLOCK_GAS_SMOKE_EFFECT" = BLOCK_GAS_SMOKE_EFFECT,
	"ALLOWINTERNALS" = ALLOWINTERNALS,
	"NOSLIP" = NOSLIP,
	"NOSLIP_ICE" = NOSLIP_ICE,
	"THICKMATERIAL" = THICKMATERIAL,
	"VOICEBOX_TOGGLABLE" = VOICEBOX_TOGGLABLE,
	"VOICEBOX_DISABLED" = VOICEBOX_DISABLED,
	"IGNORE_HAT_TOSS" = IGNORE_HAT_TOSS,
	"SCAN_REAGENTS" = SCAN_REAGENTS,
))

DEFINE_BITFIELD(datum_flags, list(
	"DF_ISPROCESSING" = DF_ISPROCESSING,
	"DF_VAR_EDITED" = DF_VAR_EDITED,
	"DF_USE_TAG" = DF_USE_TAG,
))

DEFINE_BITFIELD(disease_flags, list(
	"CAN_CARRY"	= CAN_CARRY,
	"CAN_RESIST" = CAN_RESIST,
	"CURABLE" = CURABLE,
))

DEFINE_BITFIELD(flags_1, list(
	"NOJAUNT_1" = NOJAUNT_1,
	"UNUSED_RESERVATION_TURF_1" = UNUSED_RESERVATION_TURF_1,
	"CAN_BE_DIRTY_1" = CAN_BE_DIRTY_1,
	"HEAR_1" = HEAR_1,
	"DEFAULT_RICOCHET_1" = DEFAULT_RICOCHET_1,
	"CONDUCT_1" = CONDUCT_1,
	"NO_LAVA_GEN_1" = NO_LAVA_GEN_1,
	"NODECONSTRUCT_1" = NODECONSTRUCT_1,
	"ON_BORDER_1" = ON_BORDER_1,
	"NO_RUINS_1" = NO_RUINS_1,
	"PREVENT_CLICK_UNDER_1" = PREVENT_CLICK_UNDER_1,
	"HOLOGRAM_1" = HOLOGRAM_1,
	"SHOCKED_1" = SHOCKED_1,
	"INITIALIZED_1" = INITIALIZED_1,
	"ADMIN_SPAWNED_1" = ADMIN_SPAWNED_1,
	"PREVENT_CONTENTS_EXPLOSION_1" = PREVENT_CONTENTS_EXPLOSION_1,
	"BLOCK_FACE_ATOM_1" = BLOCK_FACE_ATOM_1,
	"CAN_HAVE_NATURE" = CAN_HAVE_NATURE,
	"ADJACENCIES_OVERLAY" = ADJACENCIES_OVERLAY,
	"CRITICAL_ATOM_1" = CRITICAL_ATOM_1,

))

DEFINE_BITFIELD(flags_ricochet, list(
	"RICOCHET_HARD" = RICOCHET_HARD,
	"RICOCHET_SHINY" = RICOCHET_SHINY,
))

DEFINE_BITFIELD(interaction_flags_atom, list(
	"INTERACT_ATOM_REQUIRES_ANCHORED" = INTERACT_ATOM_REQUIRES_ANCHORED,
	"INTERACT_ATOM_ATTACK_HAND" = INTERACT_ATOM_ATTACK_HAND,
	"INTERACT_ATOM_UI_INTERACT" = INTERACT_ATOM_UI_INTERACT,
	"INTERACT_ATOM_REQUIRES_DEXTERITY" = INTERACT_ATOM_REQUIRES_DEXTERITY,
	"INTERACT_ATOM_IGNORE_INCAPACITATED" = INTERACT_ATOM_IGNORE_INCAPACITATED,
	"INTERACT_ATOM_IGNORE_RESTRAINED" = INTERACT_ATOM_IGNORE_RESTRAINED,
	"INTERACT_ATOM_CHECK_GRAB" = INTERACT_ATOM_CHECK_GRAB,
	"INTERACT_ATOM_NO_FINGERPRINT_ATTACK_HAND" = INTERACT_ATOM_NO_FINGERPRINT_ATTACK_HAND,
	"INTERACT_ATOM_NO_FINGERPRINT_INTERACT" = INTERACT_ATOM_NO_FINGERPRINT_INTERACT,
))

DEFINE_BITFIELD(interaction_flags_machine, list(
	"INTERACT_MACHINE_OPEN" = INTERACT_MACHINE_OPEN,
	"INTERACT_MACHINE_OFFLINE" = INTERACT_MACHINE_OFFLINE,
	"INTERACT_MACHINE_WIRES_IF_OPEN" = INTERACT_MACHINE_WIRES_IF_OPEN,
	"INTERACT_MACHINE_ALLOW_SILICON" = INTERACT_MACHINE_ALLOW_SILICON,
	"INTERACT_MACHINE_OPEN_SILICON" = INTERACT_MACHINE_OPEN_SILICON,
	"INTERACT_MACHINE_REQUIRES_SILICON" = INTERACT_MACHINE_REQUIRES_SILICON,
	"INTERACT_MACHINE_SET_MACHINE" = INTERACT_MACHINE_SET_MACHINE,
))

DEFINE_BITFIELD(interaction_flags_item, list(
	"INTERACT_ITEM_ATTACK_HAND_PICKUP" = INTERACT_ITEM_ATTACK_HAND_PICKUP,
))

DEFINE_BITFIELD(item_flags, list(
	"BEING_REMOVED" = BEING_REMOVED,
	"IN_INVENTORY" = IN_INVENTORY,
	"FORCE_STRING_OVERRIDE" = FORCE_STRING_OVERRIDE,
	"NEEDS_PERMIT" = NEEDS_PERMIT,
	"SLOWS_WHILE_IN_HAND" = SLOWS_WHILE_IN_HAND,
	"NO_MAT_REDEMPTION" = NO_MAT_REDEMPTION,
	"DROPDEL" = DROPDEL,
	"NOBLUDGEON" = NOBLUDGEON,
	"ABSTRACT" = ABSTRACT,
	"IMMUTABLE_SLOW" = IMMUTABLE_SLOW,
	"SURGICAL_TOOL" = SURGICAL_TOOL,
	"NO_UNIFORM_REQUIRED" = NO_UNIFORM_REQUIRED,
	"NO_COMBAT_MODE_FORCE_MODIFIER" = NO_COMBAT_MODE_FORCE_MODIFIER,
	"ITEM_CAN_PARRY" = ITEM_CAN_PARRY,
	"ITEM_CAN_BLOCK" = ITEM_CAN_BLOCK,
))

//rename to machine_stat when possible
DEFINE_BITFIELD(stat, list(
	"BROKEN" = BROKEN,
	"EMPED" = EMPED,
	"MAINT"	= MAINT,
	"NOPOWER" = NOPOWER,
))

DEFINE_BITFIELD(mob_biotypes, list(
	"MOB_ORGANIC" = MOB_ORGANIC,
	"MOB_MINERAL" = MOB_MINERAL,
	"MOB_ROBOTIC" = MOB_ROBOTIC,
	"MOB_UNDEAD" = MOB_UNDEAD,
	"MOB_HUMANOID" = MOB_HUMANOID,
	"MOB_BUG" = MOB_BUG,
	"MOB_BEAST" = MOB_BEAST,
	"MOB_EPIC" = MOB_EPIC,
	"MOB_REPTILE" = MOB_REPTILE,
	"MOB_SPIRIT" = MOB_SPIRIT,
	"MOB_INORGANIC" = MOB_INORGANIC,
))

DEFINE_BITFIELD(mobility_flags, list(
	"MOVE" = MOBILITY_MOVE,
	"PICKUP" = MOBILITY_PICKUP,
	"PULL" = MOBILITY_PULL,
	"STAND" = MOBILITY_STAND,
	"STORAGE" = MOBILITY_STORAGE,
	"UI" = MOBILITY_UI,
	"USE" = MOBILITY_USE,
	"HOLD" = MOBILITY_HOLD,
	"RESIST" = MOBILITY_RESIST,
))

DEFINE_BITFIELD(movement_type, list(
	"FLOATING" = FLOATING,
	"FLYING" = FLYING,
	"GROUND" = GROUND,
	"UNSTOPPABLE" = UNSTOPPABLE,
	"VENTCRAWLING" = VENTCRAWLING,
	"CRAWLING" = CRAWLING,
))

DEFINE_BITFIELD(obj_flags, list(
	"EMAGGED" = EMAGGED,
	"IN_USE" = IN_USE,
	"CAN_BE_HIT" = CAN_BE_HIT,
	"BEING_SHOCKED" = BEING_SHOCKED,
	"DANGEROUS_POSSESSION" = DANGEROUS_POSSESSION,
	"ON_BLUEPRINTS" = ON_BLUEPRINTS,
	"UNIQUE_RENAME" = UNIQUE_RENAME,
	"USES_TGUI" = USES_TGUI,
	"FROZEN" = FROZEN,
	"BLOCK_Z_OUT_DOWN" = BLOCK_Z_OUT_DOWN,
	"BLOCK_Z_OUT_UP" = BLOCK_Z_OUT_UP,
	"BLOCK_Z_IN_DOWN" = BLOCK_Z_IN_DOWN,
	"BLOCK_Z_IN_UP" = BLOCK_Z_IN_UP,
	"SHOVABLE_ONTO" = SHOVABLE_ONTO,
	"EXAMINE_SKIP" = EXAMINE_SKIP,
	"IN_STORAGE" = IN_STORAGE,
))

DEFINE_BITFIELD(pass_flags, list(
	"LETPASSTHROW" = LETPASSTHROW,
	"PASSBLOB" = PASSBLOB,
	"PASSCLOSEDTURF" = PASSCLOSEDTURF,
	"PASSGLASS" = PASSGLASS,
	"PASSGRILLE" = PASSGRILLE,
	"PASSMOB" = PASSMOB,
	"PASSTABLE" = PASSTABLE,
))

DEFINE_BITFIELD(resistance_flags, list(
	"LAVA_PROOF" = LAVA_PROOF,
	"FIRE_PROOF" = FIRE_PROOF,
	"FLAMMABLE" = FLAMMABLE,
	"ON_FIRE" = ON_FIRE,
	"UNACIDABLE" = UNACIDABLE,
	"ACID_PROOF" = ACID_PROOF,
	"INDESTRUCTIBLE" = INDESTRUCTIBLE,
	"FREEZE_PROOF" = FREEZE_PROOF,
	"GOLIATH_RESISTANCE" = GOLIATH_RESISTANCE,
	"GOLIATH_WEAKNESS" = GOLIATH_WEAKNESS,
))

//rename to sight_flags when possible
DEFINE_BITFIELD(sight, list(
	"BLIND" = BLIND,
	"SEE_BLACKNESS" = SEE_BLACKNESS,
	"SEE_INFRA" = SEE_INFRA,
	"SEE_MOBS" = SEE_MOBS,
	"SEE_OBJS" = SEE_OBJS,
	"SEE_PIXELS" = SEE_PIXELS,
	"SEE_SELF" = SEE_SELF,
	"SEE_THRU" = SEE_THRU,
	"SEE_TURFS" = SEE_TURFS,
))

DEFINE_BITFIELD(smooth, list(
	"SMOOTH_TRUE" = SMOOTH_TRUE,
	"SMOOTH_MORE" = SMOOTH_MORE,
	"SMOOTH_DIAGONAL" = SMOOTH_DIAGONAL,
	"SMOOTH_BORDER" = SMOOTH_BORDER,
	"SMOOTH_QUEUED" = SMOOTH_QUEUED,
	"SMOOTH_OLD" = SMOOTH_OLD,
))

DEFINE_BITFIELD(vis_flags, list(
	"VIS_HIDE" = VIS_HIDE,
	"VIS_INHERIT_DIR" = VIS_INHERIT_DIR,
	"VIS_INHERIT_ICON" = VIS_INHERIT_ICON,
	"VIS_INHERIT_ICON_STATE" = VIS_INHERIT_ICON_STATE,
	"VIS_INHERIT_ID" = VIS_INHERIT_ID,
	"VIS_INHERIT_LAYER" = VIS_INHERIT_LAYER,
	"VIS_INHERIT_PLANE" = VIS_INHERIT_PLANE,
	"VIS_UNDERLAY" = VIS_UNDERLAY,
))

DEFINE_BITFIELD(zap_flags, list(
	"ZAP_ALLOW_DUPLICATES" = ZAP_ALLOW_DUPLICATES,
	"ZAP_MACHINE_EXPLOSIVE" = ZAP_MACHINE_EXPLOSIVE,
	"ZAP_MOB_DAMAGE" = ZAP_MOB_DAMAGE,
	"ZAP_MOB_STUN" = ZAP_MOB_STUN,
	"ZAP_OBJ_DAMAGE" = ZAP_OBJ_DAMAGE,
))
