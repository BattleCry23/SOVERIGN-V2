var/const
	HAIR_LAYER = 5
	CLOTHING_LAYER = 5.5
	ARMOUR_LAYER = 6
	EQUIPMENT_LAYER = 6.5
	EXTRA_LAYER = 9.5
	AURA_LAYER = 15

obj/overlay
	//parent_type = /obj //figure out how to undo this, buffs are already moved, but overlays need to have their parent_type changed.
	//layer = 5
	layer = MOB_LAYER
	//IsntAItem=1
	//canGrab = 0
	mouse_opacity = 0
	vis_flags = VIS_INHERIT_DIR | VIS_INHERIT_LAYER | VIS_INHERIT_ID | VIS_INHERIT_ICON
	var
		ID=1 //important, when you remove shit, you compare IDs.
		mob/container //mind as well use the same variables from buff.dm - makes it more consistant and future coders can use "container" for all datum-based frameworks.
		SUBID=1
		pastSelf
		temporary=FALSE //will this aura remain on duplications, be left on resets, and etc?
		o_px=0
		o_py=0

	proc/starteffect()
		if(!container)
			return
		if(ismob(container))
			container.vis_contents |= src
		else if(isobj(container))
			container.overlays += src

	proc/effectloop()
		if(!container)
			return
		pixel_x = container.pixel_x + o_px
		pixel_y = container.pixel_y + o_py

	proc/endeffect()
		if(container)
			remove_overlay(container, src)
		qdel(src)

	proc/fasteffectend()
		if(container)
			remove_overlays_fast(container, src)
		qdel(src)

//this essentials handles how hair overlays work, the previous version handled hair overlays as a single overlay that changed its icon and color, but this version handles each hair as a separate overlay, which allows for more customization and less issues with things like the ssj hair not updating properly when changing colors or something like that. It also allows for things like the ssj2 hair to be added without needing to change the ssj1 hair's icon or color, which is something that was an issue with the previous version. It also allows for things like the ssj3 hair to be added without needing to change the ssj1 or ssj2 hair's icon or color, which is something that was an issue with the previous version. It also allows for things like the ssj4 hair to be added without needing to change the ssj1, ssj2, or ssj3 hair's icon or color, which is something that was an issue with the previous version. It also allows for things like the lssj hair to be added without needing to change the ssj1, ssj2, ssj3, or ssj4 hair's icon or color, which is something that was an issue with the previous version. It also allows for things like the rlssj hair to be added without needing to change the ssj1, ssj2, ssj3, ssj4, or lssj hair's icon or color, which is something that was an issue with the previous version. It also allows for things like the ussj hair to be added without needing to change the ssj1, ssj2, ssj3, ssj4, lssj, or rlssj hair's icon or color, which is something that was an issue with the previous version. It also allows for things like the mastered ssj1 hair to be added without needing to change the ssj1, ssj2, ssj3, ssj4, lssj, rlssj, or ussj hair's icon or color, which is something that was an issue with the previous version.
obj/overlay/hairs
	//plane = HAIR_LAYER
	layer = HAIR_LAYER
	appearance_flags = PIXEL_SCALE
	vis_flags = VIS_INHERIT_DIR | VIS_INHERIT_LAYER | VIS_INHERIT_ID | VIS_INHERIT_ICON
	name = "hair"
	transform = null
	ID = 3
	var
		tmp/gdkid = 0
		prevgdki = 0//this is for hair changes pretaining to future use of godki, but it can also be used for other things like the ssj2 hair or something like that if I decide to add it in the future.

		rssjed = 0
		lssjed = 0
		wrathed = 0//this is for wrathful state, the plan is to use the ssj hairs but turn it black sort of like Giji.
/*
:Tech vars:.
	- Setting has_subtech = 1 will force the tech, when displayed inside the "Build Tech", to show a plus(+)
	- tech_ref is assigned to the expand_button's that are created, so when the player clicks them, it knows which tech is selected

*/
obj/items/var/tmp/pickup_lock = 0
// Centralized clothing crafting registry
var/global/list/WOOL_CRAFTING = list(
	"Kid Shirt" = /obj/items/clothing/kid_shirt,
	"Kid Shoes" = /obj/items/clothing/kid_shoes,
	"Kid Pants" = /obj/items/clothing/kid_pants,
	"Kid Jacket" = /obj/items/clothing/kid_jacket,
	"Kid Boots" = /obj/items/clothing/boots,
	"Kid Saiyan Boots" = /obj/items/clothing/kid_saiyan_boots,
	"Kid Black Sleeve Jacket" = /obj/items/clothing/kid_black_sleeve_jacket,
	"Kid Bandana" = /obj/items/clothing/kid_bandana,
	"Kid Karate Headband" = /obj/items/clothing/kid_karate_headband,
	"Kid Cape" = /obj/items/clothing/kid_cape,
	"Kid Turban" = /obj/items/clothing/kid_turban,
    "Shirt" = /obj/items/clothing/shirt,
    "Sleeveless Shirt" = /obj/items/clothing/sleeveless_shirt,
    "Singlet" = /obj/items/clothing/singlet,
    "Hoodie" = /obj/items/clothing/hoodie,
    "Pants" = /obj/items/clothing/pants,
    "Shoes" = /obj/items/clothing/shoes,
    "Boots" = /obj/items/clothing/boots,
    "Saiyan Boots" = /obj/items/clothing/saiyan_boots,
    "Gloves" = /obj/items/clothing/gloves,
    "Wristbands" = /obj/items/clothing/wristbands,
    "Belt" = /obj/items/clothing/belt,
    "Sash" = /obj/items/clothing/sash,
    "Kai Sash" = /obj/items/clothing/kai_sash,
    "Turban" = /obj/items/clothing/turban,
    "Cape" = /obj/items/clothing/cape,
    "Cape Shoulderless" = /obj/items/clothing/cape_shoulderless,
    "Bandana" = /obj/items/clothing/bandana,
    "Karate Headband" = /obj/items/clothing/karate_headband,
    "Side Headband" = /obj/items/clothing/side_headband,
    "Namekian Scarf" = /obj/items/clothing/namekian_scarf,
    "Glasses" = /obj/items/clothing/glasses,
    "Shades" = /obj/items/clothing/shades,
    "Royal Cape" = /obj/items/clothing/royal_cape,
    "Deluxe Cape" = /obj/items/clothing/deluxe_cape,
    "Hero Helmet" = /obj/items/clothing/hero_helmet,
    "Fedora Hat" = /obj/items/clothing/fedora_hat,
    "Wizard Hat" = /obj/items/clothing/wizard_hat,
    "Wide Skirt Dress" = /obj/items/clothing/wide_skirt_dress,
    "Cheerleader Top" = /obj/items/clothing/cheerleader_top,
    "Cheerleader Skirt" = /obj/items/clothing/cheerleader_skirt,
    "Ballroom Dress" = /obj/items/clothing/ballroom_dress,
    "Nun Headdress" = /obj/items/clothing/nun_headdress,
    "Nun Legging" = /obj/items/clothing/nun_leggings,
    "Nun Outfit" = /obj/items/clothing/nun_outfit,
    "Embroiled Cape" = /obj/items/clothing/embroiled_cape,
    "Two Tone Dress" =/obj/items/clothing/two_tone_dress,
    "Mutant Helmet" = /obj/items/clothing/Mutant_Helmet,
    "Mutant Helmet(Full)" = /obj/items/clothing/Mutant_Helmet_Full

)
obj/items/tech/Space_Pod
	proc/get_pod_speed(lvl)
		var/base_speed = 5.0
		var/deduction = 0.0

		if (lvl >= 50000)
			deduction = base_speed - 0.8  // Ensures it caps at 0.8
		else if (lvl >= 40000)
			deduction = 2.0+(lvl*0.01)
		else if (lvl >= 10000)
			deduction = 1.0+(lvl*0.01)
		else if (lvl >= 1000)
			deduction = 0.4+(lvl*0.001)
		else if (lvl >= 100)
			deduction = 0.3+(lvl*0.001)
		else if (lvl >= 10)
			deduction = 0.1+(lvl*0.001)

		var/final_speed = max(base_speed - deduction, 0.8) // Ensure speed never goes below 0.8
		return final_speed
obj/items/tech/ships
	var
		landing = 0
		ship_id = 0
		established = 0
		started=0
		locked =0
		Speed=2.5
		tmp/gravity_on=0
		tmp/setgrav = 0
		var/entry_location
		tmp/mob/pilot = null
		tmp/obj/tele = null
		obj/items/tech/Ship_Controls/panel
		obj/Door
		instance_id // Unique ID per ship
		interior_z // Z-level where the ship interior exists
		launched = 0
		tmp/manualtravel = 0
		tmp/autotravel = 0
	proc/get_ship_speed(lvl)
		var/base_speed = 5.0
		var/deduction = 0.0

		if (lvl >= 50000)
			deduction = base_speed - 0.8  // Ensures it caps at 0.8
		else if (lvl >= 40000)
			deduction = 2.0+(lvl*0.01)
		else if (lvl >= 10000)
			deduction = 1.0+(lvl*0.01)
		else if (lvl >= 1000)
			deduction = 0.4+(lvl*0.001)
		else if (lvl >= 100)
			deduction = 0.3+(lvl*0.001)
		else if (lvl >= 10)
			deduction = 0.1+(lvl*0.001)

		var/final_speed = max(base_speed - deduction, 0.8) // Ensure speed never goes below 0.8
		return final_speed
/obj/items
	var/abstract = FALSE
	var/admin_spawnable = TRUE

obj/items/tech/weapons
	abstract = TRUE

obj
	step_size = 6

	Move()
		if(src.loc)
			src.layer = MOB_LAYER + src.laymod - (src.y + src.step_y / 32) / world.maxy
			if(src.shadow)
				src.shadow.loc = src.loc
				src.shadow.step_x = src.step_x
				src.shadow.step_y = src.step_y
		..()
	items
		New()
			if(isturf(src.loc)) if(src.icon)
				src.layer = MOB_LAYER + src.laymod - (src.y + src.step_y / 32) / world.maxy
			spawn(1)
				if(src)
					var/icon/i = new(src.icon)
					src.i_width = i.Width()
					src.i_height = i.Height()
					if(src.hashadow) src.create_shadow()
			..()
		Del()
			if(src.shadow) qdel(src.shadow)
			..()
	var
		// for cyborgs
		part_type
		percent
		bonus_pl
		bonus_end
		bonus_str
		bonus_for
		bonus_res
		bonus_off
		bonus_def

		standby = 0
		capsule_storable = 0
		plant_type = "generic"
		top_color = null
		bottom_color = null
		build_icon = null
		icon/top_icon = null
		icon/bottom_icon = null
		uses_left
		max_uses
		artifact = 0
		signature_number = 0
		//For dbs
		Home
		wishing=0
		passphrase=""
		wishes = 0
		// For Ships
		obj/items/tech/ships/ship_ref = null
		ship_view
		fuelamount= 0 // for Fuel tech
		needs_to_be_active = 0
		weapon = 0

		// For Planets
		obj/items/Planets/Unknown_Planet/planet_ref

		//For capsules
		obj/items/tech/storeditem = null
		occupied
		cantStore = 0

		var/list/customs = list() // store custom techniques beams/kiblasts/kiblades/stances
		var/tmp/last_activate_time = 0
		base_type = "Default"
		base_pts = 0.1
		food = 0
		can_cook=0
		cooked=0
		Bed=0
		mystille_cost=0
		titanium_cost=0
		gold_cost=0
		coal_cost=0
		silver_cost=0
		copper_cost=0
		stone_cost=0
		needed_qp = 99999999999999
		cooked_type

		can_teach = 1
		 // needed intel points for techs

		map_z // for map selections, depending on what z plane you're on, the map will show.
		adapted = 0
		floor_state
		inven_state
		open = 0
		rarity = 1
		stacks = 1 //-1 makes sure this item doesn't stack, ever. -2 or 0 means this item was used and should be deleted. In the case of -2, it's because the code takes 1 away from -1.
		stack_exempt = 0
		tmp/image/stack_display
		max_level = 200
		act
		act_drop
		act_load
		act_create
		tree=0
		rock = 0
		skill_y = -464
		translated_y = 0
		translated_x = 0
		translate_max = 420
		icon_y_saved = 270 //The y that the scrollbar is sitting at
		icon_x_saved = 83 //The x that the scrollbar is sitting at
		y_start = 0
		x_start = 0
		arsenal = 0
		exit
		entrance
		passive_skill=0
		stance_skill = 0
		is_zenni = 0
		is_dokuro = 0
		/*
		ki_spread = 2
		ki_dmg = 0
		ki_offence = 0
		ki_power = 0
		ki_damage = 0
		ki_exp = 0
		*/

		//Energy skills vars
		super_sense = 0
		deflectable = 1
		bullet = 0
		active = 0 //Is this obj/skill skipped when checking the players state?
		tmp/using = 0 //Is this skill currently being used in a proc?
		tmp/image/over
		disabled_ko = 1 //Is this skill disabled when you become koed?
		disabled_switch = 0 //Is this attack turned off when another like it is activated?
		repeat = 0 //For skills and macros. If set to 1, the skill in question forces the macro being used to be a repeat macro.
		trait = 0; //Is this a trait or a skill?
		stance = 0;
		//Relations
		relations = 0 //Can be minus for bad and plus for good.
		relation_points = 0 //The longer a player is around another player, the more relation points they get to spend on relations.
		relation_points_comitted = 0 //Number of relation points actually put inside the relations already.
		//Skill info vars
		info_energy_cost = 0 //General idea of energy cost for skill
		info_dmg = 0 //General idea of dmg potential from skill
		info_spd = 0 //General idea of how fast skill moves and/or charges
		info_mastery = 0 //General idea of how long it takes to master and teach
		info_point_cost //How many points this skill costs to unlock
		info_duration //How long the buff lasts for
		info_buffs //Which stats are buffed by this skill
		info_stats //Contains more of the info found inside info_buffs, used for displaying skill bonuses inside the skills menu.
		info_point_cost_type //Which stat points are used to unlock this skill
		info_name //How this skills name would appear as a button. Must include _ instead of spaces.
		list/info_prerequisite //Skill needed before this one can be unlocked. Must be exactly as the name appears for the skills.
		info //The text description of a trait or skill
		info_path //The interface name
		info_calculations //Lets the player know how the damage or buff works mechanically.
		info_relation = "None"//The relation of the players contact, for example, good, bad, rival, lover, ect.
		info_relation_points = 0 //The numerical value of the relation points
		info_cd = 0 //The text format of the cd related to skills.
		info_last_seen = 0 //How many months ago a player last saw a contact
		info_last_loc = null
		info_race
		info_client //The Contact type, player, npc
		info_auth //Type of authentication, Byond, Steam, ect.

		image/img_select = null
		image/img_over = null

		//Tech
		tech_tree //Which of the 3 tech tree's does this tech belong to, physics, genetics or egineering.
		tech_subtech
		tech_parent_path //The associated tech that determines the max lvl of this tech
		tech_time //Time it takes for research to finish
		tech_repeatable = 0 //Can this be repeated, like construction or armor/weapon upgrades?
		tech_upgradable = 0
		tech_exp_gain = 0
		tech_give_txt = "None" //List in txt format of what this tech will give when researched
		tech_needed_txt = "None"
		tech_display = 1;
		tech_lvl = 0
		tech_water = 0 //Can this tech be placed over water/liquid?

		help_text
		tutorial_text
		seen = 0 //Set to 1 if this help topic was seen already
		input_type = "text" //Can be num or text

		//Usually attached to the input box itself and not the player
		pre_cooldown = 0
		tmp/string_full = "" //This is the uncut, full sized length of the text without edits or CSS/maptext edits.
		tmp/list/string_display[10] //These are the actual strings we will show. Because only a certain number of pixels can be shown, and text can be much longer, show the correct part
		tmp/string_selected = ""
		tmp/string_min = 1
		tmp/string_max = 1
		tmp/caret_pos = 1
		tmp/caret_line = 1 //The line the caret is currently on, which is text height divided by 13. (i.e, 52/13=4)
		tmp/display_pos = 1 //This is the pos within the string_display list

		obj/overlay_special = null

		capacity = 0 // How much a battery holds in raw power
		capacity_max = 1000
		on = 0
		on_always = 0
		spawning = 1; //Set to 0 once an item finishes loading/spawning
		tmp/list/remote_views //For the large map, keeps a list of whats seen.
		silo = 0
		build = null //The /type of atom to create once this is clicked in the build menu
		skill_exp = 1 //From 1-100, having 100 in a skill means its fully mastered.
		skill_lvl = 1
		setting = 0 //Can be the setting of a tech item, for example, gravity lvl.
		needs_node = 0 //Does this tech item only function over a node?
		tmp/pos = null //position related to tk minigame
		tutorial_shown = 0
		disable_logout = 0 //If set to 1, prevents this item saving to a players inventory on logout.
		hud_x = 0
		hud_y = 0
		saved_x = 0
		saved_y = 0
		saved_step_x = 0
		saved_step_y = 0
		item_info = null
		scale_x = 64;
		scale_y = 64;
		invul_melee = 0 //Can't be damaged by melee
		armor = 0
		//Item icon states
		state_ground = null
		state_wear = null

		//hairs - How many frames per hair and the current frame
		frames = 2
		frame_current = 1

		//skill learning
		//list/cant_learn = list()
		learnable = 1
		difficulty = 10
		added_map = 0 //Set to 1 if this item was added to the mini map display already
		energy_skill = 0

		//HUD vars
		slot = -1
		tmp/obj/slot_taken = null //For inventory slots. A reference to the item thats inside this inventory slot.
		tmp/obj/skill_taken = null //For the skill slots.A reference to the skill thats inside this skill slot.
		image/txt_i //The image text shown when mousing over things.
		display = 1//Whether the bodypart or item should display in a grid or not
		shift_y = 0
		shift_x = 0
		box_x_scale = 128
		box_y_scale = 64
		box_x_shift = 64
		box_y_shift = 32
		tmp/select_started = 0
		tmp/select_end = 0
		tmp/excluded_before = ""
		tmp/excluded_after = ""
		mob/rankist = null
		mob/coordinator = null
		is_health_set = 0

		mob/accelerator = null
		mob/cycler = null

		//Pixel offsets, ect.
		p_x = 0 //How many pixels this item should be offset when assigning its icon to an obj, like a players builder mouse.
		p_y = 0

		//for fridges
		maxlimit = 12 // Max limit of items, affected by quality
		list/stored_items = list()
		food_count = 0
		fridge = 0

		//for foods
		expiry = 0 // expiration timer
		expiration = 900 // 900-15 minutes to expire.
		expiration_cycle = 0 // 0-1 cycles, last cycle is full, first cycle is half deduction
		insideofaship = 0
