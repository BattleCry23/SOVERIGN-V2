
/datum/offspring_profile
    var
        name
        real_name
        password
        race
        recessive_race
        gen
        Father
        Mother
        PG



        // core mods
        mod_strength
        mod_energy
        mod_agility
        mod_endurance
        mod_defence
        mod_force
        mod_recovery
        mod_regeneration
        mod_resistance
        mod_psionic_power
        mod_psionic_power_base
        resistance
        offence
        defence
        psionic_power
        energy_max
        gains_trained_energy
        strength
        endurance
        force
        generation_lvl

        // visuals
        hair_c
        eye_c
        skin_pos
        hair_pos
        mouth_pos
        eye_pos
        nose_pos
        body_pos
        bodysize

        // meta
        planet_spawn
        conceived_by
        mutation_types
        spawn_point

        alien_dna
        makyo_dna
        tuffle_dna
        demon_dna
        kai_dna
        spirit_doll_dna
        oni_dna
        changeling_dna
        saiyan_dna
        namekian_dna
        human_dna
        is_hybrid


//Main vars


mob
	player

	races
		glide_size = 18
	Move()
		..()
		src.layer = MOB_LAYER + src.laymod - (src.y + src.step_y / 32) / world.maxy
		if(src.shadow)
			src.shadow.loc = src.loc
			src.shadow.step_x = src.step_x
			src.shadow.step_y = src.step_y
		src.wings()
	New()
		//src.appearance_flags = KEEP_TOGETHER
		..()
		src.weight = 1
		if(src.id == 0)
			src.id = rand(10000000,99999999)//global_id;
			global_id += 1;
	/*	spawn(10)
			if(src)
				src.round_mods()
				/*var/icon/i = new(src.icon)
				src.i_width = i.Width()
				src.i_height = i.Height()
				if(src.loc) src.layer = MOB_LAYER + (world.maxy - src.y)/world.maxy*/
				var/icon/I = new(icon(src.icon, src.icon_state))
				src.bound_width = I.Width()
				src.bound_height = I.Height()
				src.i_width = I.Width()
				src.i_height = I.Height()
				/*if(!istype(src,/mob/NPC/))
					src.bound_x = -(I.Width() - 32) / 2
					src.bound_y = 0*/

				*/

	step_size = 8 // og. 6 //originally 5

	//pixel_x = -17
	//pixel_y = -5
	//bounds = "8,1 to 25,7"
	//bound_height = 32
	//bound_width = 32
	density_factor = 1
	appearance_flags = LONG_GLIDE | KEEP_TOGETHER
	see_invisible = 1
	hashadow = 1
	//pixel_x = -8
	/*
	step_size = 6
	pixel_x = -16
	//pixel_y = -8
	bounds = "23,8 to 43,18"
	*/
	var/tmp/total_damage = 0
	var/tmp/list/damage_by_ckey = list()   // "ckey" = damage
	var/tmp/list/name_by_ckey = list()     // "ckey" = last name
	var/tmp/last_click_time = 0
	var/tmp/debuffs_set=0
	var/datum/offspring_profile/profile = null
	var/tmp/rp_mode = null
	var/tmp/list/phase_members = null
	var/tmp/phased = null
	var/tmp/phase_ready = null
	var/tmp/guard = 25
	var/tmp/explosion_ready = TRUE
	var/tmp/explosion_timer = 0
	var/tmp/last_gain_time = 0
	var/gain_cd = 25  // cooldown in ticks (2.5 seconds)
	var/boss = 0
	var/list/auction_mail = list()   // persistent payouts
	var/list/portrait_contents = list() // portrait saves just in case.
	var/tmp/mob/ahc_target   // who you're replying to
	var/tmp/confirming = 0
	var/tmp/last_pickup_time = 0
	var/list/installed_cybernetics = list()
	var/tmp/next_gravity_damage = 0
	var/tmp/last_gravity_tick = 0
	var
		LSSJ = 0
		scouter_on = 0
		obj/items/tech/Scouters/current_scouter = null
		stone_count = 0
		silver_count = 0
		copper_count = 0
		coal_count = 0
		gold_count = 0
		mystille_count = 0
		titanium_count = 0


		lift_kg
		lift_lbs
		lift_raw
		tmp/unconsciousalert=0
		tmp/fatiguealert=0

		move880_rewarded = 0
		has_vote_mute = 0
		last_vote_mute_time = 0
		home_planet = "Earth"

		//Leaderboards
		total_rpps_gained = 0
		scouter_crushes = 0
		mute_count = 0
		ban_count = 0

		//RPs stuff
		monthly_rps
		check_cycles

		//RP Ranks
		roleplay_rank = 1
		rp_rankxp = 0
		rp_rankmaxxp = 100
		roleplay_points = 0
		transing = 0
		roleplay_rank_letter = "<font color =#D86060>F</font>"

		save_x
		save_y
		save_z
		first_cft = 0
		judgement_bid = 0

		hbtc_entries = 0
		inside_hbtc = 0
		tmp/hbtc_exit_prompting = 0

		potential_unlocked = 0
		immortal = 0

		rank = 0

		tmp/dokuro_shop_open = 0

		generational_pg = 0

		child_slots = 2

		beard = 0
		obj/beard_style = null
		has_beard = 0
		beard_icon
		beard_overlay
		portrait_beard_icon
	//	portrait_beard_overlay

		maimed = 0
		bleeding = 0

		service_lvl = 0
		spam_protect=0
		standing_gains_timer = 0

		saved_interface = "interface.dmf"  // default
		interface_style = "Modern"

		has_sf1 = 0
		has_sf2 = 0
		has_sf3 = 0
		has_sf4 = 0
		has_sf5 = 0

		recessive_race = "N/A"

		superform = 0
		superform2 = 0
		superform3 = 0
		superform4 = 0
		superform5 = 0

		bandaged = 0
		resting = 0

		tmp/admin_spying = 0
		willpower = 200
		mod_zenkai = 0
		last_zenkai_boost
		// traits
		giant = 0
		bald =0
		midget = 0

		cycle_free_time = 0
		cft_activated = 0
		icon/i_race
		icon/i_age_race1
		icon/i_age_race2
		tmp/list/holding_macros = list() // key = TRUE if holding
		pw
		owns_planets = 0
		offline_gains = 0
		logout_time = 0
		LOYear
		can_move = 1
		tmp/moved = 0
		movement_speed = 10
		mob_prepping=0
		saved_icon = ""
		death_location
		respawn_type // for npcs
		respawnloc // for npcs

		//test stuff
		testtime
		testing = 0

		npc = 0
		tmp/rerolling // for Mutations
		//misc
		obj/items/tech/drainers/Energy_Drainer/e_drainer_equipped
		obj/items/tech/drainers/DNA_Drainer/d_drainer_equipped
		//new from sovereing
		in_space_pod = 0
		in_space_ship = 0
		in_space = 0
		tmp/looking_out_ship = 0
		obj/items/tech/Space_Pod/Pod
		obj/items/tech/ships/Ship
		tmp/killprompt=0
		onEarth = 0
		onNamek = 0
		onVegeta = 0
		onIcer = 0
		onOtherRealm = 0
		onDarkRealm = 0
		obj/items/Planets/Unknown_Planet/on_customplanet
		inSpace = 0
		oozaru_mastery = 0
		rampid = 0
		oozaru_form = 0
		c_type_mutation = 0
		hidden_potential = 0
		lssj_form = 0
		lssj_mastery = 0
		looking_at_moon=0
		looking_at_flares = 1 // Solar flare
		tmp/in_oozaru_rampage = 0
		tmp/oozaru_rampage_loop
		tmp/in_lssj_rampage = 0
		tmp/lssj_rampage_loop


		makyo_boost = 0

		lifespan_gain = 0

		mob/reprievee
		mob/repriever
		reprievee_drain
		repriever_timer = 0

		BPpcnt=100
		Body = 1
		auracolor
		armored_hp = 0

		sword_pl = 0
		axe_pl = 0
		hammer_pl = 0
		weapon_stance = 0

		discovery = 1
		luck = 1
		hunting_enabled = 0
		npc_spawn_cd = 0

		intel_points = 0
		intel_gauge = 0
		max_intelgauge = 100

		ifocus = 0
		magicfocus = 0

		int_add = 1
		has_FPLM=0
		PG =  1//0.1 // base personal growth
		final_powerlevel_mod = 1000000
		in_fplm = 0

		rating_mult = 1

		race_class = null

		generation_lvl = 1
		aura_alignment = 0
		aura_txt = "Neutral"

		current_weight_gain = 0
		//Mods and stats
		max_trainres = 100
		max_medres = 100
		max_blastres = 100
		max_sparres = 100
		max_studyres = 100
		max_researchres = 100


		study_ressed = 0
		research_ressed = 0
		spar_ressed=0
		blast_ressed=0
		train_ressed=0
		med_ressed=0

		studyres=0
		researchres=0
		trainres=0
		medres=0
		blastres=0
		sparres=0

		divine_energy = 100
		divine_energy_mod = 1
		dark_matter = 1000
		dark_matter_mod = 1
		move_lvl = 1
		movelvl_exp = 0

		psiforging_speed = 1

		gravity_mastered = 1
		microwaves_mastered = 1

		vampire = 0

		grav_highest = 0
		micro_highest = 0

		//DNAs
		saiyan_dna = 0
		human_dna = 0
		namekian_dna = 0
		changeling_dna = 0
		spirit_doll_dna = 0
		makyo_dna = 0
		tuffle_dna = 0
		alien_dna = 0
		demon_dna = 0
		kai_dna = 0
		oni_dna = 0
		half_god_dna = 0
		is_hybrid = 0//if you have more than one DNA, this is set to 1. This is used for some special cases.
		has_beast_gene = 0

		f_type_mutation = 0
		co_type_mutation = 0

		//Save info
		SAVEFILE_VERSION = 0;
		byond_key = null

		sav_active = 0

		path_type

		list/sav[3]//Set to 1 for any list position would mean that save is taken
		list/sav_names[3]//List of all the names of the character saves, starting at 1
		list/sav_races[3]//List of all the races of the character saves, starting at 1
		list/sav_time_played[3]//List of all the times played of the character saves, starting at 1
		list/sav_last[3]//List of all the last saved times of the character saves, starting at 1
		list/friends
		sav_menu

		tmp/estimate_strength = 1
		tmp/estimate_endurance = 1
		tmp/estimate_force = 1
		tmp/estimate_agility = 1
		tmp/estimate_resistance = 1
		tmp/estimate_offence = 1
		tmp/estimate_defence = 1
		tmp/estimate_regeneration = 1
		tmp/estimate_recovery = 1

		tmp/estimate_strength_txt = "Unknown"
		tmp/estimate_endurance_txt = "Unknown"
		tmp/estimate_force_txt = "Unknown"
		tmp/estimate_agility_txt = "Unknown"
		tmp/estimate_resistance_txt = "Unknown"
		tmp/estimate_offence_txt = "Unknown"
		tmp/estimate_defence_txt = "Unknown"
		tmp/estimate_regeneration_txt = "Unknown"
		tmp/estimate_recovery_txt = "Unknown"

		drug_tolerances = 100
		mod_psionic_power = 1
		mod_rating = 1
		mod_energy = 1
		mod_strength = 1
		mod_endurance = 1
		mod_force = 1
		mod_resistance = 1
		mod_agility = 1
		mod_offence = 1
		mod_defence = 1
		mod_regeneration = 1
		mod_recovery = 1
		mod_gravity = 1
		mod_microwaves = 1
		//mod_intelligence = 0.000125

		mod_psionic_power_base = 1
		mod_rating_base = 1
		mod_energy_base = 1
		mod_strength_base = 1
		mod_endurance_base = 1
		mod_agility_base = 1
		mod_force_base = 1
		mod_resistance_base = 1
		mod_offence_base = 1
		mod_defence_base = 1
		mod_regeneration_base = 1
		mod_recovery_base = 1

		mod_psionic_power_og = 1
		mod_rating_og = 1
		mod_energy_og = 1
		mod_strength_og = 1
		mod_endurance_og = 1
		mod_force_og = 1
		mod_resistance_og = 1
		mod_agility_og = 1
		mod_offence_og = 1
		mod_defence_og = 1
		mod_regeneration_og = 1
		mod_recovery_og = 1
		mod_gravity_og = 1
		mod_microwaves_og = 1

		mod_energy_points = 0
		mod_strength_points = 0
		mod_endurance_points = 0
		mod_agility_points = 0
		mod_force_points = 0
		mod_resistance_points = 0
		mod_offence_points = 0
		mod_defence_points = 0
		mod_regeneration_points = 0
		mod_recovery_points = 0

		mod_tech_potential = 1
		mod_arcane_potential = 1
		mod_sense = 1

		mod_immune_rads = 0 //Ranges from 0 to 1, in increments of 0.1
		mod_immune_cold = 0
		mod_immune_heat = 0
		mod_immune_gravity = 0 //For strange creations like the Manites.
		mod_immune_microwaves = 0
		mod_immune_toxins = 0

		immune_rads_base = 0
		immune_cold_base = 0
		immune_heat_base = 0
		immune_gravity_base = 0
		immune_microwaves_base = 0
		immune_toxins_base = 0

		Edeflection_skill = 0
		ED = 0 // edefelction skill
		deflection_skill = 0
		DS = 0 // defelction skill
		laceration_skill = 0
		LC = 0 // laceration skill

		efficient_skill = 0
		EffS = 0
		androids_skill = 0
		AD= 0 // android skill
		cyborgs_skill = 0
		self_cyborg_skill = 0

		bare_handed_skill = 0
		weapon_stance_skill = 0

		RC = 0 // recovery skill
		RG = 0 // regeneration skill
		BB = 0 // bone breaker skill
		CYB = 0 // Cyborgification skill
		has_cyborgself = 0
		mod_fly = 1
		mod_teleport = 1
		mod_skill = 1 //The multi for skill exp gains.

		mod_str_usage = 1 //Ranges from 0.1 to 1, where 0.1 is 10%
		mod_force_usage = 1
		mod_off_

		lift = 0

		orbiting = 0
		floats = 0
		divine_weapon = 0
		tmp/turf/fight_area

		tmp/obj/active_menu = null

		stat_rank = 1
		psi_rank = 1

		super_fly = 0
		better = null //Set to ground or air.


		mod_points = 5
		mod_points_spent = 0
		med_focus = "none"
		med_pixel = 1

		//Injury - These are the amount of stats missing due to injury
		injury_power = 0
		injury_energy = 0
		injury_strength = 0
		injury_endurance = 0
		injury_force = 0
		injury_resistance = 0
		injury_off = 0
		injury_def = 0

		injury_power_mod = 0
		injury_energy_mod = 0
		injury_strength_mod = 0
		injury_endurance_mod = 0
		injury_agility_mod = 0
		injury_force_mod = 0
		injury_resistance_mod = 0
		injury_off_mod = 0
		injury_def_mod = 0
		injury_regen_mod = 0
		injury_recov_mod = 0

		injury_o2 = 0

		immune_rads_injury = 0
		immune_cold_injury = 0
		immune_heat_injury = 0
		immune_gravity_injury = 0
		immune_microwaves_injury = 0
		immune_toxins_injury = 0

		//Gains psiforging - Keeps track of what stats were permanently gained total, per stat.
		gains_psiforged_power = 0
		gains_psiforged_rating = 0
		gains_psiforged_energy = 0
		gains_psiforged_strength = 0
		gains_psiforged_endurance = 0
		gains_psiforged_force = 0
		gains_psiforged_resistance = 0
		gains_psiforged_off = 0
		gains_psiforged_def = 0

		gains_psiforged_rating_mod = 0
		gains_psiforged_power_mod = 0
		gains_psiforged_energy_mod = 0
		gains_psiforged_strength_mod = 0
		gains_psiforged_endurance_mod = 0
		gains_psiforged_agility_mod = 0
		gains_psiforged_force_mod = 0
		gains_psiforged_resistance_mod = 0
		gains_psiforged_off_mod = 0
		gains_psiforged_def_mod = 0
		gains_psiforged_regen_mod = 0
		gains_psiforged_recov_mod = 0

		gains_psiforged_o2 = 0

		immune_rads_psiforged = 0
		immune_cold_psiforged = 0
		immune_heat_psiforged = 0
		immune_gravity_psiforged = 0
		immune_microwaves_psiforged = 0
		immune_toxins_psiforged = 0

		//Gains training - Keeps track of what stats were permanently gained total, per stat.
		gains_trained_power = 1
		gains_trained_rating = 1
		gains_trained_energy = 1
		gains_trained_strength = 1
		gains_trained_endurance = 1
		gains_trained_force = 1
		gains_trained_resistance = 1
		gains_trained_off = 1
		gains_trained_def = 1

		gains_trained_power_mod = 1
		gains_trained_rating_mod = 1
		gains_trained_energy_mod = 1
		gains_trained_strength_mod = 1
		gains_trained_endurance_mod = 1
		gains_trained_agility_mod = 1
		gains_trained_force_mod = 1
		gains_trained_resistance_mod = 1
		gains_trained_off_mod = 1
		gains_trained_def_mod = 1
		gains_trained_regen_mod = 1
		gains_trained_recov_mod = 1

		gains_trained_o2 = 100

		immune_rads_trained = 0
		immune_cold_trained = 0
		immune_heat_trained = 0
		immune_gravity_trained = 0
		immune_microwaves_trained = 0
		immune_toxins_trained = 0

		//Gains through items and food
		gains_items_rating = 0
		gains_items_power = 0
		gains_items_energy = 0
		gains_items_strength = 0
		gains_items_endurance = 0
		gains_items_force = 0
		gains_items_resistance = 0
		gains_items_off = 0
		gains_items_def = 0


		gains_items_power_mod = 0
		gains_items_energy_mod = 0
		gains_items_strength_mod = 0
		gains_items_endurance_mod = 0
		gains_items_agility_mod = 0
		gains_items_force_mod = 0
		gains_items_resistance_mod = 0
		gains_items_off_mod = 0
		gains_items_def_mod = 0
		gains_items_regen_mod = 0
		gains_items_recov_mod = 0

		gains_items_o2 = 0

		immune_rads_items = 0
		immune_cold_items = 0
		immune_heat_items = 0
		immune_gravity_items = 0
		immune_microwaves_items = 0
		immune_toxins_items = 0

		//General buffs/debuffs
		gains_temp_power = 0
		gains_temp_energy = 0
		gains_temp_strength = 0
		gains_temp_endurance = 0
		gains_temp_force = 0
		gains_temp_resistance = 0
		gains_temp_off = 0
		gains_temp_def = 0

		gains_temp_power_mod = 0
		gains_temp_energy_mod = 0
		gains_temp_strength_mod = 0
		gains_temp_endurance_mod = 0
		gains_temp_agility_mod = 0
		gains_temp_force_mod = 0
		gains_temp_resistance_mod = 0
		gains_temp_off_mod = 0
		gains_temp_def_mod = 0
		gains_temp_regen_mod= 0
		gains_temp_recov_mod = 0

		gains_temp_o2 = 0

		immune_rads_temp = 0
		immune_cold_temp = 0
		immune_heat_temp = 0
		immune_gravity_temp = 0
		immune_microwaves_temp = 0
		immune_toxins_temp = 0

		//Skill and trait points
		trait_exp = 1

		//Roleplay system vars and communication
		RP_open_time = 0
		RP_close_time = 0
		RP_copy
		list/RP_last //List of the last rp's someone did. If the most recent one is the same as any of the previous, then no rpp's awarded.
		list/RP_last_100
		list/RP_word_count
		RP_hourly_checker = null //More rp
		RP_Earned = 0
		RP_Points = 2500
		rp_total = 0
		RP_Rested = 0
		RPs = 0
		RP_Length = 0
		common_word_count = 0
		paste_detected = 0

		//Admin vars
		admin = 0
		muted = 0


		text_color_ic = "red"
		text_color_ooc = "red"
		listen_ooc = 1
		text_size = 3
		ViewX=30
		ViewY=17
		real_name = null

		//Sound & music
		list/music
		music_current = 0
		music_volume = 100
		music_random = 1

		//xp toward a skill point in this stat
		//Start at 10 because skills start at lvl 1
		xp_energy = 10;
		xp_rating = 10;
		xp_strength = 10;
		xp_endurance = 10;
		xp_force = 10;
		xp_resistance = 10;
		xp_agility = 10;
		xp_recovery = 10;
		xp_regen = 10;
		xp_offence = 10;
		xp_defence = 10;
		xp_power = 10;
		//How many skill points are available in this stat
		skill_points_energy = 100
		skill_points_strength = 100
		skill_points_rating = 100
		skill_points_endurance = 100
		skill_points_force = 100
		skill_points_resistance = 100
		skill_points_agility = 100
		skill_points_recovery = 100
		skill_points_regen = 100
		skill_points_offence = 100
		skill_points_defence = 100
		skill_points_power = 100
		skill_points_combat = 100 //Used to unlock Traits and Stances
		skill_points_psiforging = 100

		passive_points = 0
		stance_points=0

		tmp/attack_rate = 10
		attack_range = 32
		attack_setting = "lethal"
		blast = 1 //1 for left, 2 for right - animations
		idle_state = null
		can_save = 0
		dismissed = 0

		//Anger
		mod_anger = 0.1
		/*
		//Anger
		mod_anger_cd = 0
		mod_anger_cd_max = 120
		angry = 0;
		text_anger = null;
		*/

		//Tech
		tech_bar = null
		tmp/obj/tech_focus = null
		tmp/obj/tech_display = null
		obj/items/tech/Vat/vat = null;
		obj/map_sense = null
		gene_points = 10; //How many points player has to spend in genetic engineering. Increased via research.
		gene_limit = 1; //Max mod number the player can reach for their creations mods.
		tech_pos_se = 0 //The position in the players tech_lvls list where Structural Engineering can be found.

		//Limits for genetics
		gene_limit_psi = 1;
		gene_limit_energy = 1;
		gene_limit_strength = 1;
		gene_limit_endurance = 1;
		gene_limit_resistance = 1;
		gene_limit_force = 1;
		gene_limit_agility = 1;
		gene_limit_offence = 1;
		gene_limit_defence = 1;
		gene_limit_regen = 1;
		gene_limit_recov = 1;

		//Extra organs and parts
		extra_heart = 0;
		extra_kidneys = 0;
		extra_lungs = 0;
		extra_adrenal = 0; //Gives another set of adrenal glands, helps with recovery perhaps?
		extra_growth = 0; //Gives faster exp gain for body parts
		extra_regen = 0; //Gives passive xp toward parts and gives death regen
		extra_lobe = 0; //Extra brain power, a third lobe.
		extra_spleen = 0;
		extra_liver = 0;
		extra_skin = 0; //Thicker skin

		being_grown = 0;
		clone_awake = 0;
		list/clones = null;

		critical_throat = 0
		critical_hearing = 0

		//info
		race = null
		gen = "Male" //Gender
		tmp/obj/faction = null
		temperature = 0
		bodysize = SMALL
		class = ""

		//Age and time
		age = 0.1
		age_soul = 0.1
		age_text = "Kid"
		grey_hair = 0
		hair_icon = null
		lifespan = 80
		oldage = 50
		prime = 1
		mortal = 1
		in_oldage = 0
		birth_year = -20
		log_year = 0 //Time when player logged out last
		log_psi_year = 0 //Time when player logged out last
		vigour = 100 //This is how well your body functions. It lowers when you get older and become frail and weak.
		last_taught = 0 //Last year/time this player taught somone anything.


		//settings
		txt_size = 12
		tmp/icon_stored = null //Set when a player clicks a change icon button. The icon to apply to anything they click.
		tmp/icon_offered = null //Set when one player offers to change the icon of another.
		show_flash_local = 1
		show_flash_local_say = 1
		show_flash_world = 1
		show_alerts = 1
		mouse_x
		mouse_y
		mouse_pix_x
		mouse_pix_y
		mouse_screen_x
		mouse_screen_y
		mouse_screen_loc
		mouse_x_true = 0
		mouse_y_true = 0
		drag_icon_x = 0

		//Keyboard input stuff
		tmp/obj/typing = null
		tmp/shift_held = 0
		tmp/ctrl_held = 0
		tmp/backspace_held = 0
		tmp/backspace_started = 0
		tmp/space_held = 0
		tmp/space_started = 0
		tmp/left_started = 0
		tmp/left_held = 0
		tmp/right_started = 0
		tmp/right_held = 0
		tmp/clipboard = null

		tmp/obj/typing_test = null
		tmp/obj/tiny_test = null
		tmp/list/txt_list = list()

		//percents
		percent_energy = 100
		//percent_power = 100
		percent_ko = 0

		//minerals
		their_stone = 0
		their_copper = 0
		their_coal = 0
		their_silver = 0
		their_titanium = 0
		their_gold = 0
		their_mystille = 0

		/*
		percent_balance = 100
		percent_seeing = 100
		percent_hearing = 100
		percent_consciousness = 100
		percent_blood = 100
		percent_pain = 0
		percent_manipulation = 100
		percent_movement = 100
		*/

		/*
		//Does it matter/effect the mob?
		matters_balance = 1
		matters_seeing = 1
		matters_hearing = 1
		matters_consciousness = 1
		matters_blood = 1
		matters_pain = 1
		matters_manipulation = 1
		matters_movement = 1
		matters_fatigue = 1
		matters_energy = 1
		*/
		inStance
		//skills
		obj/skills/skill_wrestle
		obj/skills/skill_meditation
		obj/skills/skill_active_meditation
		obj/skills/skill_selftrain
		obj/skills/skill_gather
		obj/skills/skill_hunt
		obj/skills/skill_attack
		obj/skills/skill_block
		obj/skills/skill_super_speed
		obj/skills/skill_remote_viewing
		obj/skills/Precision/skill_touch_of_death
		obj/skills/Split_Form/skill_psi_clone
		obj/skills/Summon_Mage_Pot/skill_mage_pot
		obj/skills/Divine_Weapon/skill_divine_weapon
		obj/skills/skill_flight
		obj/skills/skill_shieldeyes
		obj/skills/skill_profusion
		obj/skills/skill_power_control
		obj/skills/skill_levitation
		obj/skills/skill_obfuscation
		obj/skills/skill_explosion
		obj/skills/Beam/skill_beam
		obj/skills/Stance/skill_stance
		obj/skills/skill_blast
		obj/skills/skill_run
		obj/skills/skill_charge
		obj/skills/skill_breathing
		obj/skills/skill_sense
		obj/skills/Ki_Fist/skill_ki_fist
		obj/skills/Ki_Blade/skill_ki_blade
		obj/skills/skill_control_oozaru = null
		obj/skills/skill_control_rampage = null
		obj/skills/skill_createdbs
		obj/skills/skill_sleep
		obj/skills/skill_study
		obj/skills/skill_hone
		obj/skills/skill_focus
		obj/skills/skill_invis
		obj/skills/skill_teleport
		obj/skills/skill_cyberize
		obj/skills/skill_lightning
		obj/skills/skill_lightning_storm
		obj/skills/Dig/skill_dig
		obj/skills/Divine_Infusion/skill_divine_infusion
		obj/skills/Cleanse/skill_cleanse
		obj/skills/Dark_Infusion/skill_dark_infusion
		obj/skills/Dark_Petrifaction/skill_dark_petrifaction
		obj/skills/skill_telepathy
		obj/skills/skill_tk
		obj/skills/Restoration/skill_restoration
		obj/skills/Reincarnation/skill_reformation
		obj/skills/Ressurect/skill_revive
		obj/skills/Kaiosoku/skill_quicksilver
		obj/skills/Kaioken/skill_kaioken
		obj/skills/Kaioenjin/skill_kaioenjin
		obj/skills/Spirit_Reprieve/skill_reprieve
		obj/skills/Majinize/skill_majinize
		obj/skills/Mysticize/skill_mysticize

		obj/origins/origin // Since player can only have one, just set this to the activated inside their character
		tmp/obj/origins/origin_selected
		tmp/obj/ages/age_selected
		hatch_icon
		occupation = "None"

		face_angle = 0;
		lifeforce = 100
		dead = 0
		swimming = 0
		breath = 100
		shock_chance = 0
		fruit = 0
		o2 = 100
		o2_max = 100
		o2_max_base = 100
		need_o2 = "Yes"
		beaming = 0
		has_majin = 0
		has_mystic = 0
		can_sense_aura = 0

		max_anger = 125
		anger = 100
		anger_phase
		HTT = 0
		tmp/killproc = 0

		//passive perk skills
		selfborg_skill= 0
		android_skill=0
		efficiency_skill=0
		implants_skill=0
		parts_skill=0
		cyborg_skill=0
		cyborging = 0

		//Survival
		need_food = "Yes"
		need_water = "Yes"
		need_sleep = "Yes"
		hunger = 99 //Starts at 100% and slowly falls to -100%. 50 to 100% is well fed. 0 to 50% is nothing, no buffs/debuffs. 0 to -100% is hungry with a debuff.
		thirst = 99 //Starts at 100% and slowly falls to -100%. 50 to 100% is well hydrated. 0 to 50% is nothing, no buffs/debuffs. 0 to -100% is thirsty with a debuff.
		restedness = 99 //Starts at 100% and slowly falls to -100%. 50 to 100% is well rested. 0 to 50% is nothing, no buffs/debuffs. 0 to -100% is tired with a debuff.
		metabolic_rate = 0.1 //How quickly you get hungry, higher makes it quicker so you get hungry more often.
		dehydration_rate = 0.1 //How quickly you get thirsty, higher makes it quicker so you get thirsty more often.
		tiredness_rate = 0.1 //How quickly you get tired, higher makes it quicker so you get tired more often.
		tmp/obj/eating = null //Set for when a player is munching on food, so they can be intrrupted.

		has_body = 1;
		has_hair = 0;
		has_eyes = 0 //Just visually. For example, some races might not have eyes. Currently applies to endoskeletal androids.
		has_stomach = 1 //Set to 0 if impossible to eat food, i.e Androids.
		keep_body = 0;
		signature = 0;
		shop_opened=0
		can_attack = 1
		can_block = 1
		recovering = 0
		can_ki = 1
		move_cd = 0
		tmp/tab_num = 0
		tmp/obj/grid

		tmp/mob/save_mob = null
		/*
		 - Used to save the player mob
		 - Should always be the player's original/main mob
		 - Even the player's original/main mob should have this equal to themselves
		 - For followers, should be set to the players original/main mob
		 - Useful for when the player=follower, allows the players original/main mob to save, instead of the follower they're controlling
		*/

		attack_state = "melee" //switch to change to blast.

		tmp/obj/wings = null
		wings_hidden = 0
		halo_hidden = 0

		obj/divine_elec = null
		obj/hair = null
		obj/horns = null
		obj/body_horns = null
		obj/tail = null
		obj/halo = null
		obj/eyes_white = null
		obj/eyes = null
		obj/eyes_white_copy = null
		obj/eyes_copy = null
		obj/water = null //water overlay for the player
		obj/hp_bar_clone = null //Overlay for clones and other things grown inside vats
		obj/mouse_over_tooltip = null
		obj/mouse_over_visual = null
		eye_c = null
		skin_c = null
		hair_c = null
		tail_c = null
		saved_hair_c = null //for extra backup
		saved_skin_c = null //for extra backup
		saved_eye_c = null //for extra backup
		saved_tail_c = null //for extra backup
		tmp/paperdoll_shown = 0
		hair_pos = 15
		ear_pos = 1
		skin_pos = 1
		horn_pos = 1
		expand_icon = null
		eye_pos = 1
		nose_pos = 1
		mouth_pos = 1
		body_pos = 1
		bodysize_pos = 1
		icon/save_icon = null

		milestone_checked =0
		milestonecurrent_lvls = 0
		max_milestonecurrent_lvls = 6
		lastmilestonelvl = 13
		lastrpmeter = 100
		tmp/RecentScan=0
		scoutercrushes = 0
		tmp/AllowedScan=1
		//Portrait stuff
		tmp/obj/portrait/port = null //Made this tmp, so when the player loads a save, it then applies the portrait from the save instead
		tmp/obj/portrait/babyport = null
		//Bodypart selection and training
		obj/body_related/bodyparts/part_selected = null
		obj/body_related/bodyparts/part_focus = null
		obj/hud/menus/shopkeeper_inventory_background/current_shop = null
		total_organs = 0
		organ_grow = 1

		//states
		list/debuffs
		koed = 0
		tmp/stunned = 0
		tmp/stunned_pending = 0 //Set this everytime a stun is appiled that should be removed when logging back in in the case of d/c.
		lifting = 0
		meditating = 0
		selftraining = 0

		fullname = "Name"

		//Group vars
		tmp/obj/grp //A group obj that has the settings for a group inside, and its members

		//Lists
		list/learnable_origins
		list/pickable_ages
		list/options
		list/habitats
		list/dialogues
		list/afterimages
		list/tech_lvls
		list/tech_xp
		list/tech_unlocked
		list/bodyparts
		list/body
		list/milestones
		list/ascensions
		list/meridians
		list/chakras
		list/soul
		list/quests
		list/hud_map
		list/player_contacts
		list/mutations = list()
		list/known_people = null
		list/missing_organs
		list/sense_boxes
		list/seen_build
		list/hud_skillbar
		list/hud_main
		list/hud_sub
		list/milestone_hud
		list/admin_panel
		list/ambients
		list/inv[49]
		list/shop[49]


		//Offspring Stuff
		passwordOfChild = ""
		offspring = 0
		Father
		Mother
		savedloc

		/*
			Soul numbers
			1 = envy
			2 = gluttony
			3 = greed
			4 = lust
			5 = pride
			6 = sloth
			7 = wrath
			8 = charity
			9 = chastity
			10 = diligence
			11 = humility
			12 = kindness
			13 = patience
			14 = temperance
			15 - Nirvana
		*/

		//Reset these every month.
		tmp/list/remembers_strength = null
		tmp/list/remembers_endurance = null
		tmp/list/remembers_agility = null
		tmp/list/remembers_resistance = null
		tmp/list/remembers_force = null
		tmp/list/remembers_offence = null
		tmp/list/remembers_defence = null
		tmp/list/remembers_recovery = null
		tmp/list/remembers_regeneration = null
		//Other temp lists
		tmp/list/open_menus
		tmp/list/chat_see
		tmp/list/hate_list
		tmp/list/mobs_map
		tmp/list/mobs_map_mini
		tmp/list/blips_map_mini
		tmp/list/blips_map
		tmp/list/remote_viewer
		tmp/list/blips
		tmp/list/hurt_limbs
		tmp/list/tab_targets

		tmp/obj/tech_using = null //Machine player is currenty using.
		tmp/obj/skills/learning = null
		tmp/obj/digging_dust

		//Menu locs
		main_x = 0
		main_y = 0
		tmp/obj/hud/map_blip

		list/one
		list/two
		list/three
		list/four
		list/five
		list/six
		list/seven
		list/eight
		list/nine
		list/zero
		list/minus
		list/equal

		one_rep = 0
		two_rep = 0
		three_rep = 0
		four_rep = 0
		five_rep = 0
		six_rep = 0
		seven_rep = 0
		eight_rep = 0
		nine_rep = 0
		zero_rep = 0
		minus_rep = 0
		equal_rep = 0

		list/tutorials
		list/traits
		//settings stuff
		battle_text = 1
		anger_text = 1

		//mating stuff
		children = 2 //max children found in client vars
		in_BioRegenTank = 0
		in_DeluxeTank = 0
		asexual = 0

		//lethality stuff
		spar_mode = 1
		srs_mode = 0
		lethal_mode = 0

		//Main screen loc vars

		list/pos_prev[2]
		list/pos_new[2]

		pos_prev_txt = null
		dis_x_prev = 0
		dis_y_prev = 0
		check_menus = 1

		obj/info_box1
		obj/info_box2
		obj/info_box3
//
		tmp/mob/ref = null //usually for astral projection and stuff, more of a temp owner var.
		tmp/displaying_options = 0
		tmp/open_settings = 0
		tmp/open_stats = 0
		tmp/open_inven = 0
		tmp/open_sense = 0
		tmp/open_skills = 0
		tmp/open_stat_focus = 0
		tmp/open_tech = 0
		tmp/open_spread = 0
		tmp/open_options = 0
		tmp/open_emote = 0
		tmp/open_help = 0
		tmp/open_build = 0
		tmp/open_body = 0
		tmp/open_updates = 0
		tmp/open_traits = 0
		tmp/open_ship = 0
		tmp/open_dialogue = 0
		tmp/open_map = 0
		tmp/open_contacts = 0
		tmp/toggled_info = 0
		tmp/mob/accessing = null //The mob who's inventory you are accessing, usually set to your own.
		tmp/confirm = null //Tells the confirm screen what the player is confirming and passes it through the verb.
		tmp/confirm_text = null
		tmp/numbers_text = null
		tmp/numbers = null
		tmp/numbers_value = 0
		tmp/numbers_accessing = null
		tmp/mouse_dir = null
		tmp/turf/mouse_inside = null
		tmp/atom/mouse_down = null
		tmp/obj/mouse_skill = null
		tmp/atom/movable/grab = null //The obj you grabbed.
		tmp/obj/body_related/grab_part //The part of a mob you grabbed
		tmp/wrestle_stage = null
		tmp/impact_cd = 0
		tmp/knocked_back = 0
		tmp/obj/piloting = null
		tmp/obj/name_txt = null
		tmp/held = 0
		tmp/obj/txt = null
		tmp/obj/build_tech = null
		tmp/obj/build_tech_selected = null
		tmp/obj/build_marker = null
		tmp/image/build_mouse = null
		tmp/image/build_mouse_og = null
		tmp/mouse_far = null
		tmp/image/txt_say = null
		tmp/atom/movable/mouse_over = null
		tmp/obj/eng_attack = null
		tmp/obj/mouse_txt = null
		tmp/obj/mouse_txt_over //Checks with mouse_txt_confirm before creating a name box at players mouse.
		tmp/obj/mouse_txt_confirm //Checks with mouse_txt_over before creating a name box at players mouse.
		tmp/mouse_ang = 0
		tmp/turf/mouse_saved_loc
		tmp/new_x
		tmp/new_y
		tmp/rightclick_menu_open = null
		tmp/left_click_function = null
		tmp/mob/left_click_ref = null
		tmp/right_click_function = null
		tmp/mob/right_click_ref = null
		tmp/mob/target = null
		tmp/mob/target_follower = null
		tmp/mob/target_follow = null
		tmp/atom/target_go = null
		tmp/obj/active_attack = null
		tmp/last_attacked = null
		tmp/mouse_degree = 0
		tmp/locked_mouse_degree = 0
		tmp/obj/ranged/ball = null
		tmp/obj/projection = null
		tmp/obj/contact_selected = null
		tmp/obj/player_selected = null
		tmp/mob/upgrading = null
		tmp/wt_trunk_hidden = 0
		tmp/wt_top_hidden = 0
		tmp/obj/item_selected = null
		tmp/obj/skill_selected = null
		tmp/obj/cyber_selected = null
		tmp/obj/gravity_overlay = null

		tmp/obj/effects/phase_icon = null
		tmp/obj/effects/roleplaymode_icon = null


		//Training sources
		tmp/list/restedness_sources = null
		tmp/list/power_sources = null
		tmp/list/energy_sources = null
		tmp/list/divine_sources = null
		tmp/list/dark_matter_sources = null
		tmp/list/strength_sources = null
		tmp/list/endurance_sources = null
		tmp/list/resistance_sources = null
		tmp/list/agility_sources = null
		tmp/list/force_sources = null
		tmp/list/offence_sources = null
		tmp/list/defence_sources = null
		tmp/list/regen_sources = null
		tmp/list/recov_sources = null


		//Particles and screen objs
		tmp/obj/afterlife_effect = null
		tmp/obj/hell_effect = null
		tmp/obj/drealm_effect = null
		tmp/obj/space_effect = null
		tmp/obj/grav_effect = null
		tmp/obj/login_effect = null
		tmp/obj/login2_effect = null
		obj/vision = null
		obj/screen_text = null
		obj/screen_text2 = null
		obj/hud/planes/plane_liquid/hud_liquid
		obj/hud_void
		obj/hud_energy
		obj/hud_divine
		obj/hud_wings
		tmp/obj/hud_hud

		//Skills Stuff
		tmp/kaioken_pl = 1
		tmp/kaiosoku_boost = 0
		tmp/kaioenjin = 0
		tmp/kaioryu = 0
		obj/hud_hp
		obj/hud_eng
		obj/hud/menus/core_stats_background/hud_stats
		obj/hud/menus/inventory_background/hud_inv
		obj/hud/menus/shopkeeper_inventory_background/hud_invshop
		obj/hud/menus/tech_background/hud_tech
		obj/hud/menus/char_creation_background/hud_char
		obj/hud/menus/confirm_menu_background/hud_confirm
		obj/hud/menus/confirm_menu_numbers_background/hud_confirm_nums
		obj/hud/menus/options_background/hud_opt
		obj/hud/menus/skills_background/hud_skills
		obj/hud/menus/bodyparts_background/hud_body
		obj/hud/menus/limb_paperdoll/hud_paperdoll
		obj/hud/menus/chat_background/hud_chat
		obj/hud/menus/load_background/hud_load
		obj/hud/menus/unlocks_background/hud_unlocks
		obj/hud/menus/contacts_background/hud_contacts
		obj/hud/menus/build_background/hud_build
		obj/hud/menus/help_background/hud_help
		obj/hud/menus/updates_background/hud_updates
		obj/hud_roleplayrank
		obj/hud_coords
		tmp/obj/hud/menus/accelerated_gains_txt/hud_accelerator
		obj/hud_info
		obj/hud_namebar
		obj/hud_hp_bar
		obj/hud_hp_bar_inner
		obj/hud_eng_bar
		obj/hud_eng_bar_inner
		obj/hud_pp
		obj/hud_passivetree
		obj/hud_immersionshop
		obj/hud_dokushop
		obj/hud_cft
		obj/hud_rptree
		obj/hud_eat

		obj/but_inven
		obj/but_skills
		obj/but_stats
		obj/but_tech
		obj/but_opt


		obj/stance
		obj/warp_pointer
		obj/body_related/infusing
		obj/body_related/cleansing

		//tmp/obj/map_big
		//tmp/obj/blip
		build = "floors"
		pp_extra = 0 //How much psionic power was gained from a lvl up, to display on a players screen
		pp_extra_timer = 0 //Set this to a number and have it tick down, then remove the pp_extra after a while

		//misc
		precog = 0 //Precognition
		afk = 0
		planet = null
		chat = "local"
		tmp/chat_cd = 0
		regenerates = 0
		ko_time = 0
		ko_time_max = 0
		show_particles = 1

		pixel_x_og = 0
		pixel_y_og = 0

		tmp/change_hp = 0 // Keeps track of whether hp changed since last tick, so the hp bar isn't updated constantly
		tmp/change_eng = 0 // Keeps track of whether eng changed since last tick, so the eng bar isn't updated constantly

		//Save stuff
		online = 0;
		started = 0
		tmp/choosing_character = 0

		turf/start_loc = null

		//Power control vars
		power_percent = 100;
		powering_up = 0

		agressive = 1 //NPC attacks player?
		talks = 0 //Does this npc talk?
		can_harm = 1

		expand = 1
		ki_blade = 1
		ki_fist = 1


		stat_pixel = 0

		//HUD
		body_version = 0
		//DEBUG
		obj/debug_mouse = null

		//Target related
		image/target_img = null
		image/bar_energy = null
		image/bar_health = null
		image/bar_ko = null
		image/bar_o2 = null

		obj/slice_hp = null
		obj/slice_eng = null
		obj/slice_o2 = null

		//og = original

		//psi attacks
		tmp/obj/charging = null //Make sure this obj is deleted if player is koed
		tmp/charged = 0
		tmp/charge_lvl = 0 //This is set to the charge lvl of the attack so far. The power of the attack is 0.1, or 10%, per charge-interval.
		tmp/charge_size = 0
		tmp/obj/skills/current_attack = null


		//minigames
		tmp/list/tk_minigame
		tmp/list/tk_spaces
		tmp/minigame = null
		tmp/lift_window //Window of oppurtunity for lifting an item to get a bonus to str when weight lifting.
		tmp/lift_pos = "relaxed" //Current position of the lifted obj, be it relaxed, lifting or lifted.
		tmp/lift_pos_aim
		tmp/obj/txt_lift
		minigame_tk_pos = 0
		tk_multiplier = 1
		lift_multiplier = 1
		dragging = 0

		/*
		obj/lift_bar = null
		obj/lift_pointer = null
		obj/lift_range = null
		obj/lift_multi = null
		*/

		//dialogue stuff
		tmp/mob/talk_to = null
		tmp/topic = null
		list/topics_done

		last_x = 0;
		last_y = 0;
		last_z = 0;

		// sparring gloves vars
		obj/items/tech/Sparring_Gloves/sparring_gloves = null
mob
	var
		active_skillbar = "1"

	var
		skillbar_slots = list(
			"1" = list(
				"one"=list(), "two"=list(), "three"=list(), "four"=list(),
				"five"=list(), "six"=list(), "seven"=list(),
				"eight"=list(), "nine"=list(), "zero"=list()
			),
			"2" = list(
				"one"=list(), "two"=list(), "three"=list(), "four"=list(),
				"five"=list(), "six"=list(), "seven"=list(),
				"eight"=list(), "nine"=list(), "zero"=list()
			)
		)

mob/proc/sync_active_skillbar()
	var/bar = skillbar_slots[active_skillbar]

	one   = bar["one"]
	two   = bar["two"]
	three = bar["three"]
	four  = bar["four"]
	five  = bar["five"]
	six   = bar["six"]
	seven = bar["seven"]
	eight = bar["eight"]
	nine  = bar["nine"]
	zero  = bar["zero"]

mob/var
	obj/hud/buttons/main/toggle_skillbar_button/loadout_button = null
mob/verb/toggle_skillbar()
	set name = ".toggle_skillbar"
	set hidden = 1
	src.clear_skillbar_screen()
	src.active_skillbar = (src.active_skillbar == "1") ? "2" : "1"
	src.sync_active_skillbar()
	src.skillbar()
	if(src.active_skillbar == "1")
		if(src.loadout_button) src.loadout_button.icon_state = "1"
		else for(var/obj/hud/buttons/main/toggle_skillbar_button/ts in usr.client.screen)
			ts.icon_state = "1"
			src.loadout_button = ts
	if(src.active_skillbar == "2")
		if(src.loadout_button) src.loadout_button.icon_state = "2"
		else for(var/obj/hud/buttons/main/toggle_skillbar_button/ts in usr.client.screen)
			ts.icon_state = "2"
			src.loadout_button = ts
mob/proc/clear_skillbar_screen()
	for (var/obj/o in one)   client.screen -= o
	for (var/obj/o in two)   client.screen -= o
	for (var/obj/o in three) client.screen -= o
	for (var/obj/o in four)  client.screen -= o
	for (var/obj/o in five)  client.screen -= o
	for (var/obj/o in six)   client.screen -= o
	for (var/obj/o in seven) client.screen -= o
	for (var/obj/o in eight) client.screen -= o
	for (var/obj/o in nine)  client.screen -= o
	for (var/obj/o in zero)  client.screen -= o


mob/var
	tmp/lastcavelocation
	incave=0
	firstcaveentry=1
	caveentered=0
	inownedLand=0
	sovereignty=1
	dungeondrop
	mob/offspring_transport = null
	creature_started = 0