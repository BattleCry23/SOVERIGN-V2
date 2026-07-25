#define DEBUG

#define CHECK_TICK if(world.tick_usage > 80) sleep(world.tick_lag)

/*
Map 1 - EARTH

Map 2 - OTHER REALMS

Map 3 - EARTH UNDERGROUND

Map 4 - YUKOPIA

Map 5 - PSIONICA

Map 6 - OTHER REALMS UNDERGROUND

Map 7 - YUKOPIA UNDERGROUND

Map 8 - PSIONICA UNDERGROUND

Map 10 - VEGETA

Map 11 - VEGETA UNDERGROUND
*/


var/list/artifact_tables = list(
    "heaven" = list(
        /obj/items/misc/meteorite = 10,
        /obj/items/misc/rad_rock_3 = 10,
        /obj/items/misc/rad_rock_2 = 10,
        /obj/items/misc/sword_in_stone = 10
    ),
    "hell" = list(
        /obj/items/misc/meteorite = 10,
        /obj/items/misc/rad_rock_3 = 10,
        /obj/items/misc/rad_rock_2 = 10,
        /obj/items/misc/sword_in_stone = 10
    ),
    "checkpoint" = list(
        /obj/items/misc/meteorite = 10,
        /obj/items/misc/rad_rock_3 = 10,
        /obj/items/misc/rad_rock_2 = 10,
        /obj/items/misc/sword_in_stone = 10
    ),
    "earth" = list(
        /obj/items/misc/crashed_satellite = 10,
        /obj/items/misc/crashed_storage = 10,
        /obj/items/misc/crashed_space_pod = 10,
        /obj/items/misc/rad_rock_3 = 10
    ),
    "vegeta" = list(
        /obj/items/misc/crashed_satellite = 10,
        /obj/items/misc/crashed_storage = 10,
        /obj/items/misc/crashed_space_pod = 10,
        /obj/items/misc/rad_rock_3 = 10
    ),
    "namek" = list(
        /obj/items/misc/crashed_satellite = 10,
        /obj/items/misc/crashed_storage = 10,
        /obj/items/misc/crashed_space_pod = 10,
        /obj/items/misc/rad_rock_3 = 10
    ),
    "icer" = list(
        /obj/items/misc/crashed_satellite = 10,
        /obj/items/misc/crashed_storage = 10,
        /obj/items/misc/crashed_space_pod = 10,
        /obj/items/misc/rad_rock_3 = 10
    )


    // repeat for others
)
world/proc/TrySpawnArtifact(region, turf/location)
    set background = 1
    if(!artifact_tables[region]) return

    var/list/table = artifact_tables[region]

    var/total_weight = 0
    for(var/path in table)
        total_weight += table[path]

    var/roll = rand(1, total_weight)
    var/current = 0

    for(var/obj/items/misc/path in table)
        current += table[path]
        if(roll <= current)
            new path(location)
            return
world/proc/Respawn_Artifacts()
	set background = 1
	heaven_artifacts = 0
	hell_artifacts = 0
	checkpoint_artifacts = 0
	earth_artifacts = 0
	namek_artifacts = 0
	icer_artifacts = 0
	vegeta_artifacts = 0
	if(global.earth_spawn_tiles.len && global.vegeta_spawn_tiles.len && global.namek_spawn_tiles.len && global.icer_spawn_tiles.len)
		while(earth_artifacts < 7)
			//world << "earth tiles length: [earth_spawn_tiles ? earth_spawn_tiles.len : "NULL"]"
			var/turf/g = pick(global.earth_spawn_tiles)
		//	world << "Picked earth tile: [g]"
			TrySpawnArtifact("earth", g)
			earth_artifacts++
			sleep(0.1)
		while(vegeta_artifacts < 7)
			//world << "vegeta tiles length: [vegeta_spawn_tiles ? vegeta_spawn_tiles.len : "NULL"]"
			var/turf/g = pick(global.vegeta_spawn_tiles)
			TrySpawnArtifact("vegeta", g)
			vegeta_artifacts++
			sleep(0.1)

		if(icer_artifacts < 7)
			//world << "icer tiles length: [icer_spawn_tiles ? icer_spawn_tiles.len : "NULL"]"
			var/turf/g = pick(global.icer_spawn_tiles)
			TrySpawnArtifact("icer", g)
			icer_artifacts++
			sleep(0.1)
		if(namek_artifacts < 7)
			//  world << "namek tiles length: [namek_spawn_tiles ? namek_spawn_tiles.len : "NULL"]"
			var/turf/g = pick(global.namek_spawn_tiles)
			TrySpawnArtifact("namek", g)
			namek_artifacts++
			sleep(0.1)

		//world<<"Artifacts were refreshed."
		if(hell_artifacts < 7)
			var/turf/g = pick(global.hell_spawn_tiles)
			TrySpawnArtifact("hell", g)
			hell_artifacts++
			sleep(0.1)

		if(checkpoint_artifacts < 7)
			var/turf/g = pick(checkpoint_spawn_tiles)
			TrySpawnArtifact("checkpoint", g)
			checkpoint_artifacts++
			sleep(0.1)

		while(heaven_artifacts < 7)
			//  world << "Heaven tiles length: [heaven_spawn_tiles ? heaven_spawn_tiles.len : "NULL"]"
			var/turf/g = pick(global.heaven_spawn_tiles)
			TrySpawnArtifact("heaven", g)
			heaven_artifacts++
			sleep(0.1)


var/global
	cftglobal
	chosen_ones = 0
	night = 0
	wind_dir = NORTH
	wind_speed = 1
	diary = null
	map_loaded = 0
	server_loading = 0
	server_started = 0;
	server_new = 0; //If the server is not new, delete all the map /obj/items and load the save files with the old items inside.
	debug_mode = 0
	demo = 0 //Set to 1 if this is the demo version of the game.
	global_id = 10; //Increase this by one everytime a new obj is spawned. Start at 10 because starting at 0 messed with some checks.
	startup_result = null

	vines = 0
	stat_rank_cd = 10
	maps_created = 0
	list/weathers = list()
	list/celestial_wings = list()
	weather_snow = null
	weather_desert = null
	weather_grass = null
	eat_time = 16 //Set here to change a bit easier
	obj/inv_slot
	obj/shop_slot
	obj/sandstorm
	obj/snowstorm
	obj/rainstorm
	obj/furrow
	obj/eyes_focus
	obj/eyes_divine
	obj/eyes_wide
	obj/eyes_focus_celestial
	obj/bubble
	obj/map_master
	obj/psi_realm_background

	obj/login_background
	obj/login2_background
	obj/korintower_background
	obj/hbtc_background
	obj/hell_background
	obj/drealm_background
	obj/afterlife_background
	obj/space_realm_background
	obj/industrial_smoke
	obj/bodypart_underlay
	obj/tech_xp_bar
	obj/stat_xp_bar

	list/networks_psionica = list()
	area/network_psionica
	//obj/hud/map/map_large/map_earth
	//obj/hud/map/map_large/map_psi_realm
	//Appearance vars
	turf/master_lava = null

	const/MAX_MESSAGE_LEN = 6144//6kb per text wall

	vegeta_artifacts = 0
	earth_artifacts = 0
	namek_artifacts = 0
	checkpoint_artifacts = 0
	icer_artifacts = 0
	heaven_artifacts = 0
	hell_artifacts = 0
	darkrealm_artifacts = 0
	/*
	//Sound lists
	list/dodges = list('swosh-01.mp3','swosh-03.mp3','swosh-05.mp3','swosh-07.mp3','swosh-08.mp3','swosh-10.mp3','swosh-11.mp3','swosh-12.mp3','swosh-13.mp3','swosh-14.mp3','swosh-15.mp3')
	list/hits = list('hit01.mp3','hit02.mp3','hit03.mp3','hit04.mp3','hit05.mp3','hit06.mp3','hit07.mp3','hit08.mp3','hit10.mp3','hit11.mp3','hit12.mp3','hit13.mp3')
	list/thunder = list('thunder1.mp3','thunder2.mp3','thunder3.mp3','thunder4.mp3','thunder5.mp3','thunder6.mp3')
	list/speed = list('superspeed2.mp3','superspeed5.mp3','superspeed6.mp3','superspeed7.mp3')
	*/
	//Other lists

	list/maps = list()
	list/map_overlays = list()
	list/map_biomes = list()
	list/map_locales = list()
	list/turfs[1][8]
	list/items = list()
	list/custom_planets = list()
	list/eyes_portrait_female_demon = list()
	list/eyes_portrait_male_demon = list()
	list/eyes_portrait_kai = list()
	list/eyes_portrait_yuk = list()
	list/eyes_portrait_spiritdoll = list()
	list/eyes_portrait_changeling = list()
	list/eyes_portrait_oni = list()
	list/eyes_portrait_makyo = list()
	list/saiyan_tails = list()
	list/body_horns = list()
	list/horns_yuk = list()
	list/horns_oni = list()
	list/horns_portrait_yuk = list()
	list/horns_portrait_oni = list()
	list/horns_portait_demon = list()
	list/hairs_male = list()
	list/kid_hairs_male = list()
	list/hairs_female = list()
	list/kid_hairs_female = list()
	list/hairs_portrait_male = list()
	list/nose_portrait_male = list()
	list/nose_portrait_female = list()
	list/mouth_portrait_male = list()
	list/mouth_portrait_female = list()
	list/eyes_portrait_male = list()
	list/hairs_portrait_female = list()
	list/eyes_portrait_female = list()
	list/skins_human_male = list()
	list/skins_human_female = list()
	list/eyes_portrait_cerebroid = list()
	list/eyes_portrait_android_male = list()
	list/eyes_portrait_android_female = list()
	list/imp_ears = list()
	list/imp_skin = list()
	list/help = list()
	list/yukopian_grasses = list()
	list/yukopian_vines = list()
	list/names_taken = list("Goku","Piccolo","Vegeta","Gohan", "Goku Jr.","Vegeta Jr.","Raditz","Dabura","Guldo","Recoome","Burter","Jeice","Ginyu","Freiza","Cooler","Kold","Yamcha","Yadjirobe","Chiaotzu","Tien","Trunks","Bulma","Briefs","Dr.Gero","Doctor Gero","Gero","Cell","Garlic Jr.","Turles","Bardock","Broly","Majin","Majin Buu","Majin Boo","Buu","Uub","Pan","Chi-Chi","Krillin","Pruar","Nytmeer (Elite)","Massive Oozaru (Elite)", "Massive Oozaru", "Fauna (Elite)", "Auto War Intelligence (Elite)","Auto War Intelligence","Meebe (Elite)","Great Makyoni (Elite)","Great Makyoni")
	yukopian_pp = 0
	list/tech = list()
	list/dusts = list()
	list/dmg_nums = list()
	list/charge_nums = list()
	list/rsc_nums = list()
	list/parts = list()
	list/grow_order = list()
	//list/dusts_explosive = list()
	list/blasts = list()
	list/charges = list()
	list/beams = list()
	list/furrows = list()
	list/smokes = list()
	list/clouds = list()
	list/cosmic_holes = list()
	list/psi_lightning = list()
	list/space_lightning = list()
	list/plumes = list()
	list/orbs = list()
	list/lvl_overlays = list()
	list/learnable_traits = list()
	list/learnable_skills = list()
	list/learnable_stances = list()
	//list/npc = list()
	list/players = list()
	list/player_shells = list() //List of empty objs that get used to create player look-alike copies as they login for the first time.
	list/contacts = list() //A universal list of contacts created and chosen from the player_shells list, then given vars based on the player they are based around.
	list/contacts_online = list() //A universal list of only online players.
	list/factions = list()
	list/sandstorm_imgs = list()
	list/snowstorm_imgs = list()
	list/rainstorm_imgs = list()
	list/cybertech = list()
	list/drugs = list()
	list/origins = list()
	list/ages = list()
	//list/version_notes = list()
	list/races_tuffles = list()
	list/races_makyos = list()
	list/races_spiritdolls = list()
	list/races_changelings = list()
	list/races_halfgods = list()
	list/races_saiyans = list()
	list/races_humans = list()
	list/races_demons = list()
	list/races_celestials = list()
	list/races_yukopians = list()
	list/races_cerebroids = list()
	list/races_aliens = list()
	list/races_androids = list()
	list/races_imps = list()
	//list/power_grid[500][500][4] //Set to 1 when a live power line is found on this turf grid
	//list/currents_grid[500][500][4]
	//list/excess_grid[500][500][4] //Overall excess power available on this grid network
	//list/stored_grid[500][500][4]
	//list/bats_list[500][500][4]
	list/game_menus = list("options","skills_bar","body","inven","skills","stats","emote","chat","build_open","percents","settings","skill_panes","confirm","buttons","char_creation")

	tmp/list/sands = list()
	tmp/list/snows = list()
	tmp/list/grasses = list()

	//Building lists
	list/floors = list()
	list/walls = list()
	list/roofs = list()
	obj/demolish = null

	//Areas
	area/earth = null

	//Crater Rings
	rings = list()

	//World info
	last_save = null
	next_save = null
	world_history = null
	world_story = null
	year = 1
	start_year = 1
	psi_year = 0
	counter = 0
	pre_startup = 0

	hbtc_open = 1
	hbtc_time = 27

	Earth_active = 1
	Namek_active = 1
	Vegeta_active = 1
	Icer_active = 1

	white_outline = "<SPAN STYLE='-dm-text-outline: 1px #ffffff'>"
	css_outline = "<SPAN STYLE='-dm-text-outline: 1px #000000'>" // Has 45 characters
	css_outline_left_bottom = "<span style='color:#00b8ff;font-weight:bold;font-size:1px;text-align:left;' valign='bottom'>" // Has 45 characters
	css_outline_nowrap = "<SPAN STYLE='white-space:pre;'>"
	css_underline = "<SPAN STYLE='text-decoration: underline'>"
	css_blink = "<SPAN STYLE='text-decoration: blink'>"
	css_background = "<SPAN STYLE='background-color: #0066ff'>" //Has 41 characters

	//Core stats colors
	css_psionic_power = "<font color = #9900ff>"
	css_rating = "<font color = #9900ff>"
	css_energy = "<font color = #3abbf2>"
	css_strength = "<font color = #ff9900>"
	css_endurance = "<font color = #996633>"
	css_agility = "<font color = #2fbaa3>"
	css_resistance = "<font color = #9999ff>"
	css_regen = "<font color = #29cf3d>"
	css_recov = "<font color = #ccffff>"
	css_lift = "<font color = #	FFFFFF>"
	css_int = "<font color = ##cce6ff>"
	css_magic = "<font color = #ccccff>"
	css_off = "<font color = #ab1a1a>"
	css_def = "<font color = #99A930>"
	css_force = "<font color =#ff3399>"
	css_divine = "<font color =#FFCC00>"
	css_dark = "<font color =#512C69>"
	css_combat = "<font color = #A0A0A0>"
	css_tech = "<font color = #727168>"
	css_arcane = "<font color = #2470F2>"

	//Race colors
	css_human = "<font color =#ff3399>"
	css_demon = "<font color =#ff3399>"
	css_celestial = "<font color =#ff3399>"
	css_android = "<font color =#ff3399>"
	css_cerebroid = "<font color =#ff3399>"
	css_imp = "<font color =#ff3399>"
	css_yukopian = "<font color =#ff3399>"

	//Rarity colors
	color_common = "<font color =#ffffff>Common</font>"
	color_uncommon = "<font color =#1eff00>Uncommon</font>"
	color_rare = "<font color =#0070dd>Rare</font>"
	color_epic = "<font color =#a335ee>Epic</font>"
	color_legendary = "<font color =#ff8000>Legendary</font>"

	rarity_color = list(color_common,color_uncommon,color_rare,color_epic,color_legendary)

	game_version =  2.304
var/obj/Spawn_Manager/spawn_manager

/*proc/create_shopkeepers()
	for(var/mob/NPC/People/Shopkeeper/n in world)
	//	n.icon *= rgb(rand(1,255),rand(1,255),rand(1,255))
		n.accessing = n
		var/obj/hud/menus/shopkeeper_inventory_background/inv = new
		n.hud_invshop = inv
		inv.loc = n
		inv.menu_create()
		var/obj/items/Scissors/sc = new /obj/items/Scissors(n.loc)
		sc.stack_display.maptext = "[css_outline]<font size = 1><text aling=right valing=bottom>[sc.value]"
		//n.store_in_store(sc)
		n.pickup(sc)
            */
proc/RequestClientTime(mob/player)
    player << browse("<script>var now = new Date();window.location='byond://?src=\ref[player]&client_time='+now.getHours();</script>", "window=time_request")

mob/Topic(href, href_list)
    ..()
    if (href_list["client_time"]) // If the client sends their time
        var/user_hour = text2num(href_list["client_time"])
        alert(usr,"[user_hour]:00 o Clock")
        if (user_hour >= 6 && user_hour < 18) // Daytime: 6 AM - 6 PM
            src.apply_loginnight_glow(0)
            src.apply_loginday_glow(1) // Modify as needed
        else
            src.apply_loginday_glow(0)
            src.apply_loginnight_glow(1) // Modify as needed
        return

mob/proc/SetLoginBackground(icon_file)
    src << browse("<img src='[icon_file]' width=800 height=600>", "window=login_screen")


mob/proc/SetLoginScreen()
    var/current_hour = text2num(time2text(world.timeofday, "hh")) // Get server hour
    var/user_timezone_offset = src.client.timezone// Get user's assumed timezone offset
    var/user_hour = ((current_hour + user_timezone_offset) + 24) % 24
    if(src.client.timezone == world.timezone)
        user_hour = current_hour
    if (user_hour >= 7 && user_hour < 18) // 6 AM to 6 PM
        src.apply_loginnight_glow(0)
        src.apply_loginday_glow(1) // Replace with actual function
    else
        src.apply_loginday_glow(0)
        src.apply_loginnight_glow(1) // Replace with actual function
var/global
	list/vegeta_spawn_tiles
	list/earth_spawn_tiles
	list/namek_spawn_tiles
	list/icer_spawn_tiles
	list/heaven_spawn_tiles
	list/hell_spawn_tiles
	list/checkpoint_spawn_tiles

world
	fps = 40 // originally 60
	icon_size = 32	// 32x32 icon size by default
	//view = "32x18"//"24x9"//"32x18"//"30x17"
	name = "Sovereign V2"
	hub = "AquavisionGames.Sovereign"
	hub_password = "UHFwnqgTuucSI5hu"//"4cZEYRIzjcDVfmey"//"4cZEYRIzjcDVfmey" // Current: 4cZEYRIzjcDVfmey
	map_format = TOPDOWN_MAP
	//movement_mode = TILE_MOVEMENT_MODE
	status = "Server Type: V2"
	//cache_lifespan = 9999999999999999999999999999
	loop_checks = 1//1 // was 0 for awhile, about 6 versions, but originally 1

//	maxz=2

	Del()
		for(var/mob/races/m in players)
			//winset(m, null, "command=.quit")
			m.Logout()
			sleep(world.tick_lag)
		Save_All()
		sleep(1)
		..()
	New()
		//version_notes = file("updates/updates.txt")

		if(psi_realm_background == null) psi_realm_background = new /obj/hud/background
		if(login_background == null ) login_background = new /obj/hud/loginbackground
		if(login2_background == null ) login2_background = new /obj/hud/login2background
		if(hbtc_background == null) hbtc_background = new /obj/hud/hbtcbackground
		if(korintower_background == null) korintower_background = new /obj/hud/korintowerbackground
		if(afterlife_background == null) afterlife_background = new/obj/hud/afterlifebackground
		if(hell_background == null) hell_background = new/obj/hud/hellbackground
		if(drealm_background == null) drealm_background = new/obj/hud/darkrealmbackground
		world.log <<"Backgrounds Created."
		if(bodypart_underlay == null)
			bodypart_underlay = new /obj
			bodypart_underlay.icon = 'part_buttons.dmi'
			bodypart_underlay.plane = 22
			bodypart_underlay.layer = 33
			world.log <<"Bodyparts Created."
		if(tech_xp_bar == null)
			var/obj/bar = new
			bar.icon = 'tech_tree_bar.dmi'
			bar.icon_state = "100"
			bar.plane = 34
			bar.layer = 40
			bar.blend_mode = BLEND_INSET_OVERLAY
			tech_xp_bar = bar
			world.log <<"Tech Tree bars Created."
		if(stat_xp_bar == null)
			var/obj/hud/menus/core_stats_background/stat_exp_bar/bar = new
			/*
			bar.icon = 'core_stats_xp_slice.dmi'
			bar.icon_state = "slice"
			bar.plane = 22
			bar.layer = 35
			bar.blend_mode = BLEND_INSET_OVERLAY
			*/
			stat_xp_bar = bar
			world.log <<"Stat xp bar created."
		set_dark_realm_gravity()
		sleep(1)
		set_hells_gravity()
		//sleep(1)
		//create_growth_list()
		//world.log <<"Growth list Created."
		sleep(1)
		create_bodies()
		world.log <<"Bodies Created."
		sleep(1)
		create_buildings()
		world.log <<"Builings Created."
		sleep(1)
		create_help()
		world.log <<"Help Created."
		sleep(1)
		create_dust()
		world.log <<"Dust Created."
		sleep(1)
		create_blast()
		world.log <<"Blasts Created."
		//create_origin_paths()
		sleep(1)
		create_tech()
		world.log <<"Tech Created."
		//create_charges()
		sleep(1)
		create_orbs()
		world.log <<"Orbs Created."
		sleep(1)
		create_beams()
		world.log <<"Beams Created."
		sleep(1)
		create_skills()
		world.log <<"Skills Created."
		sleep(1)
		create_stances()
		world.log <<"Stances Created."
		sleep(1)
		create_lightning()
		world.log <<"Lightning Created."
		sleep(1)

		create_traits()
		world.log <<"Traits Created."
		sleep(1)
		//create_plumes()
		//world.log <<"Plumes Created."
		sleep(1)
		create_player_shells()
		world.log <<"Player Shells Created."
		sleep(1)
		create_cybertech()
		world.log <<"Cybertech Created."
		sleep(1)
		create_drugs()
		world.log <<"Drugs Created."
		sleep(1)
		create_lvl_overlays()
		world.log <<"Lvl Overlays Created."
		sleep(1)
		//create_clouds()
		create_furrows()
		world.log <<"Furrows Created."
		sleep(1)
		//create_dmg_nums()
		//create_charge_nums()
		//world.log <<"Charge Nums Created."
		//sleep(1)
	//	create_rsc_nums()
	//	world.log <<"Rsc Nums Created."
		sleep(1)
		create_races()
		world.log <<"Races Created."
		sleep(1)
		//shadows()
		//world.log <<"Shadows Created."
		//spawn_chests()
		sleep(1)
		Load_objs()
		world.log <<"Loaded Objs."
		sleep(1)
		//save_players()
	//	create_wings()
		//world.log <<"Wings Created."
		//create_hiddeninputbox()
		//create_shopkeepers()
	//	Handle_Lightning_Bolts()
		//InitializePlanetPositions
		//save_items()
		if(inv_slot == null) inv_slot = new /obj/effects/inv_slot
		if(eyes_focus == null) eyes_focus = new /obj/effects/eyes_focus
		if(eyes_wide == null) eyes_wide = new /obj/effects/eyes_wide
		if(eyes_focus_celestial == null) eyes_focus_celestial = new /obj/effects/eyes_focus_celestial
		if(eyes_divine == null) eyes_divine = new /obj/effects/eyes_divine
		if(furrow == null) furrow = new /obj/effects/furrow
		if(bubble == null) bubble = new /obj/effects/bubble
		vegeta_spawn_tiles = list()
		earth_spawn_tiles = list()
		namek_spawn_tiles = list()
		icer_spawn_tiles = list()
		heaven_spawn_tiles = list()
		hell_spawn_tiles = list()
		checkpoint_spawn_tiles = list()
		world.log <<"Eyes/Furrows/Bubbles/Spawn Lists Created."
		sleep(0.1)
		//if(debug_mode == 0)
		//	sleep(0.1)
			/*
			var/num_snow = 0
			for(var/turf/snows/sn in block(locate(1,1,1),locate(500,500,1)))
				for(var/turf/grass/g in range(4,sn))
					num_snow += 1
					new /turf/dirts/dirt5 (g)
					if(prob(1)) new /obj/items/plants/tuff (g)
					if(num_snow >= 10)
						num_snow = 0
						sleep(0.1)
			sleep(0.1)
			var/num_desert = 0
			for(var/turf/sands/s in block(locate(1,1,1),locate(500,500,1)))
				for(var/turf/grass/g in range(4,s))
					num_desert += 1
					new /turf/dirts/dirt5 (g)
					if(prob(1)) new /obj/items/plants/tuff (g)
					if(num_desert >= 10)
						num_desert = 0
						sleep(0.1)
			*/
		sleep(0.1)
		//create_sandstorm()
		industrial_smoke = new/obj/effects/industrial_smoke
		world.log <<"Industrial Smoke Created."
		//sleep(0.1)
		//create_snowstorm()
		//sleep(0.1)
		//create_rainstorm()

		//Load all the saves here
		sleep(0.1)
		Initialize()
		world.log <<"World Initialized."
		sleep(0.1)

		//if(!spawn_manager)
		//	spawn_manager = new()
		BuildItemTypeCache()
		sleep(0.1)
		start_galaxy()
		//spawn(5) WorldBossDailyScheduler()
		spawn(5) WeeklyRoleplayScheduler()
		sleep(0.1)
		//SetupAuctionHouses()
		//sleep(1)
		LoadAllAuctionListings()
		spawn(5) AuctionHouseLoop()
		world.log <<"Galaxy Created."
		sleep(0.1)
		years()
		world.log <<"Years Started."
		server_loading = 0
		..()




		//world << "World has finished loading"


	proc
		create_hiddeninputbox()
			for(var/mob/M in world)
				if(M)
					winset(M, null, "input_box=\"\"")



		create_races()
			var/n = 100
			//Create races
			while(n)
				n -= 1
				var/mob/races/Human/human = new
				//human.setup_race("Human")
				human.set_lists()
				human.set_debuffs()
				human.create_body()
				human.create_menus()
				human.set_info_box()
				human.set_decline()
				human.set_genetic_limits()
				human.path_type = "mob/races/Human"
				races_humans += human
				//sleep(0.1)

			sleep(0.1)
			n = 100



			while(n)
				n -= 1
				var/mob/races/Changeling/changeling = new
				//human.setup_race("Human")
				changeling.set_lists()
				changeling.set_debuffs()
				changeling.create_body()
				changeling.create_menus()
				changeling.set_info_box()
				changeling.set_decline()
				changeling.set_genetic_limits()
				changeling.path_type = "mob/races/Changeling"
				races_changelings += changeling
			//	sleep(0.1)

			sleep(0.1)
			n = 100
			while(n)
				n -= 1
				var/mob/races/Spiritdoll/spiritdoll = new
				//human.setup_race("Human")
				spiritdoll.set_lists()
				spiritdoll.set_debuffs()
				spiritdoll.create_body()
				spiritdoll.create_menus()
				spiritdoll.set_info_box()
				spiritdoll.set_decline()
				spiritdoll.set_genetic_limits()
				spiritdoll.path_type = "mob/races/Spiritdoll"
				races_spiritdolls += spiritdoll
			//	sleep(0.1)

			sleep(0.1)
			n = 100
			while(n)
				n -= 1
				var/mob/races/Saiyan/saiyan = new
				//human.setup_race("Human")
				saiyan.set_lists()
				saiyan.set_debuffs()
				saiyan.create_body()
				saiyan.create_menus()
				saiyan.set_info_box()
				saiyan.set_decline()
				saiyan.set_genetic_limits()
				saiyan.path_type = "mob/races/Saiyan"
				races_saiyans += saiyan
			//sleep(0.1)

			sleep(0.1)
			n = 100

			while(n)
				n -= 1
				var/mob/races/Tuffle/tuffle = new
				//human.setup_race("Human")
				tuffle.set_lists()
				tuffle.set_debuffs()
				tuffle.create_body()
				tuffle.create_menus()
				tuffle.set_info_box()
				tuffle.set_decline()
				tuffle.set_genetic_limits()
				tuffle.path_type = "mob/races/Tuffle"
				races_tuffles += tuffle
			//	sleep(0.1)

			sleep(0.1)
			n = 100

			while(n)
				n -= 1
				var/mob/races/Android/android = new
				//android.setup_race("Android")
				android.set_lists()
				android.set_debuffs()
				android.create_body()
				android.create_menus()
				android.set_info_box()
				android.set_decline()
				android.set_genetic_limits()
				android.path_type = "mob/races/Android"
				races_androids += android
			//	sleep(0.1)

			sleep(0.1)
			n = 100
			while(n)
				n -= 1
				var/mob/races/Makyo/makyo = new
				//human.setup_race("Human")
				makyo.set_lists()
				makyo.set_debuffs()
				makyo.create_body()
				makyo.create_menus()
				makyo.set_info_box()
				makyo.set_decline()
				makyo.set_genetic_limits()
				makyo.path_type = "mob/races/Makyo"
				races_makyos += makyo
			//	sleep(0.1)

			sleep(0.1)
			n = 100

			while(n)
				n -= 1
				var/mob/races/Demon/demon = new
				//demon.setup_race("Demon")
				demon.set_lists()
				demon.set_debuffs()
				demon.create_body()
				demon.create_menus()
				demon.set_info_box()
				demon.set_decline()
				demon.set_genetic_limits()
				demon.path_type = "mob/races/Demon"
				races_demons += demon
			//	sleep(0.1)

			sleep(0.1)
			n = 100

			while(n)
				n -= 1
				var/mob/races/Celestial/celestial = new
				//celestial.setup_race("Celestial")
				celestial.set_lists()
				celestial.set_debuffs()
				celestial.create_body()
				celestial.create_menus()
				celestial.set_info_box()
				celestial.set_decline()
				celestial.set_genetic_limits()
				celestial.path_type = "mob/races/Celestial"
				races_celestials += celestial
			//	sleep(0.1)

			sleep(0.1)
			n = 100

			while(n)
				n -= 1
				var/mob/races/Imp/imp = new
				//imp.setup_race("Imp")
				imp.set_lists()
				imp.set_debuffs()
				imp.create_body()
				imp.create_menus()
				imp.set_info_box()
				imp.set_decline()
				imp.set_genetic_limits()
				imp.path_type = "mob/races/Imp"
				races_imps += imp
			//	sleep(0.1)

			sleep(0.1)
			n = 100

			while(n)
				n -= 1
				var/mob/races/Yukopian/yukopian = new
				//yukopian.setup_race("Yukopian")
				yukopian.set_lists()
				yukopian.set_debuffs()
				yukopian.create_body()
				yukopian.create_menus()
				yukopian.set_info_box()
				yukopian.set_decline()
				yukopian.set_genetic_limits()
				yukopian.path_type = "mob/races/Yukopian"
				//yukopian.give_horns()
				races_yukopians += yukopian
			//	sleep(0.1)

			sleep(0.1)
			n = 100

			while(n)
				n -= 1
				var/mob/races/Alien/alien = new
				//cerebroid.setup_race("Cerebroid")
				alien.set_lists()
				alien.set_debuffs()
				alien.create_body()
				alien.create_menus()
				alien.set_info_box()
				alien.set_decline()
				alien.set_genetic_limits()
				alien.path_type = "mob/races/Alien"
				races_aliens += alien
			//	sleep(0.1)

			sleep(0.1)
		create_origin_paths()
			origins = typesof(/obj/origins/)
			origins -= /obj/origins/
		/*create_world_tree()
			if(world_tree == null)
				if(fexists("saves/world/world_tree.sav") == 1)
					Load_World_Tree()
				else
					var/obj/items/tech/world_tree/wt = new
					wt.loc = locate(250,250,4)
					world_tree = wt
					*/
		create_drugs()
			var/list/drug_creation = typesof(/obj/items/drugs/)
			drug_creation -= /obj/items/drugs
			for(var/x in drug_creation)
				var/obj/items/drugs/I = new x()
				//I.name = I.info_name
				drugs += I
				sleep(0.1)
		/*
		---------Populate world.tech list with all the tech items and sub_tech----------

		- Idea here is to create a single, universal list of techs for the game world
		- Then players have their tech lists/vars assigned to this list when they log in
		- That way, it's better than creating 80+ tech/sub_techs for each player
		*/
		create_tech()
			var/list/tech_creation = typesof(/obj/items/tech/)
		/*	tech_creation -= /obj/items/tech
			tech_creation -= /obj/items/tech/Ship
			tech_creation -= /obj/items/tech/Conveyor_Belt
			tech_creation -= /obj/items/tech/Resource_Cache
			tech_creation -= /obj/items/tech/Container_Tech
			tech_creation -= /obj/items/tech/Robot_Factory
			tech_creation -= /obj/items/tech/Silo
			tech_creation -= /obj/items/tech/world_tree
			tech_creation -= /obj/items/tech/sub_tech*/

			var/n = 0
			for(var/x in tech_creation)
				n += 1
				var/obj/items/tech/I = new x()
				tech += I
				I.list_pos = n //Track the pos of the obj inside the list, so we can later make a comparison
		//------------------------------------------------------------------------------

		create_cybertech()
			var/list/cyber_creation = typesof(/obj/body_related/bodyparts/cybernetics/)
			cyber_creation -= /obj/body_related/bodyparts/cybernetics
			cyber_creation -= /obj/body_related/bodyparts/cybernetics/cybernetic_arm_implants
			cyber_creation -= /obj/body_related/bodyparts/cybernetics/cybernetic_circulatory_implants
			cyber_creation -= /obj/body_related/bodyparts/cybernetics/cybernetic_cortex_implants
			cyber_creation -= /obj/body_related/bodyparts/cybernetics/cybernetic_leg_implants
			cyber_creation -= /obj/body_related/bodyparts/cybernetics/cybernetic_muscular_implants
			cyber_creation -= /obj/body_related/bodyparts/cybernetics/cybernetic_nervous_system_implants
			cyber_creation -= /obj/body_related/bodyparts/cybernetics/cybernetic_ocular_implants
			cyber_creation -= /obj/body_related/bodyparts/cybernetics/cybernetic_skeletal_implants
			cyber_creation -= /obj/body_related/bodyparts/cybernetics/cybernetic_skin_implants
			cyber_creation -= /obj/body_related/bodyparts/cybernetics/cybernetic_spinal_mount
			for(var/x in cyber_creation)
				var/cyber = "[x]"
				var/synth = findtext(cyber,"/obj/body_related/bodyparts/cybernetics/synthetics")
				if(synth) cyber_creation -= x
			for(var/x in cyber_creation)
				var/obj/body_related/bodyparts/cybernetics/I = new x()
				//if(istype(I,/obj/body_related/bodyparts/cybernetics/synthetics/)) I.loc = null
				//else
				I.name = I.info_name
				cybertech += I
				sleep(0.1)
		create_wings()
			var/obj/wings_south = new
			var/obj/wings_north = new
			var/obj/wings_east = new
			var/obj/wings_west = new
			wings_south.appearance_flags = KEEP_TOGETHER
			wings_south.vis_flags = VIS_INHERIT_ID | VIS_INHERIT_DIR
			wings_north.appearance_flags = KEEP_TOGETHER
			wings_north.vis_flags = VIS_INHERIT_ID | VIS_INHERIT_DIR
			wings_east.appearance_flags = KEEP_TOGETHER
			wings_east.vis_flags = VIS_INHERIT_ID | VIS_INHERIT_DIR
			wings_west.appearance_flags = KEEP_TOGETHER
			wings_west.vis_flags = VIS_INHERIT_ID | VIS_INHERIT_DIR

			celestial_wings = list(wings_south,wings_north,wings_east,wings_west)

			var/right_wing0_beads = 0
			var/xx = 4
			var/yy = 4
			var/yy_t = 6
			var/list/right_beads0 = list()
			while(right_wing0_beads < 112)
				right_wing0_beads += 1
				var/obj/effects/wing_pixel/bead = new
				yy_t += 1
				if(yy_t >= 18)
					yy_t = 18
					yy += 1
					xx += 1
				else
					yy += 1
				bead.pixel_x = xx
				bead.pixel_y = yy
				bead.o_y = bead.pixel_y
				bead.t_y = yy_t
				bead.timing = 12
				right_beads0 += bead

			var/right_wing1_beads = 0
			xx = 4
			yy = 4
			yy_t = 4
			var/list/right_beads1 = list()
			while(right_wing1_beads < 96)
				right_wing1_beads += 1
				var/obj/effects/wing_pixel/bead = new
				xx += 1
				yy_t += 1
				if(yy_t > 12)
					yy_t = 12
					yy += 1
				else yy += 1
				if(yy > 52) yy = 52
				bead.pixel_x = xx
				bead.pixel_y = yy
				bead.o_y = bead.pixel_y
				bead.t_y = yy_t
				bead.timing = 11
				right_beads1 += bead
				//sleep(0.1)

			var/right_wing2_beads = 0
			xx = 4
			yy = 4
			yy_t = 2
			var/list/right_beads2 = list()
			while(right_wing2_beads < 80)
				right_wing2_beads += 1
				var/obj/effects/wing_pixel/bead = new
				xx += 1
				yy += 0.5
				yy_t += 0.1
				bead.pixel_x = xx
				bead.pixel_y = yy
				bead.o_y = bead.pixel_y
				bead.t_y = yy_t
				bead.timing = 10
				right_beads2 += bead
				//sleep(0.1)

			var/right_wing3_beads = 0
			xx = 4
			yy = 4
			yy_t = 4
			var/list/right_beads3 = list()
			while(right_wing3_beads < 54)
				right_wing3_beads += 1
				var/obj/effects/wing_pixel/bead = new
				xx += 1
				yy -= 0.2
				yy_t -= 0.5
				bead.pixel_x = xx
				bead.pixel_y = yy
				bead.o_y = bead.pixel_y
				bead.t_y = yy_t
				bead.timing = 10
				right_beads3 += bead
				//sleep(0.1)

			for(var/obj/effects/wing_pixel/b in right_beads0)
				var/obj/effects/wing_pixel/bead1 = new
				bead1.icon_state = "bead south"
				bead1.pixel_x = b.pixel_x
				bead1.pixel_y = b.pixel_y
				bead1.o_y = b.pixel_y
				bead1.t_y = b.t_y
				bead1.timing = b.timing
				animate(bead1,pixel_y = b.t_y, time = b.timing, easing = SINE_EASING,loop = -1)
				animate(pixel_y = b.o_y, easing = SINE_EASING,time = b.timing)
				wings_south.vis_contents += bead1

				var/obj/effects/wing_pixel/bead2 = new
				bead2.icon_state = "bead south"
				bead2.pixel_x = (104-b.pixel_x)-104
				bead2.pixel_y = b.pixel_y
				bead2.o_y = b.pixel_y
				bead2.t_y = b.t_y
				bead2.timing = b.timing
				animate(bead2,pixel_y = b.t_y, time = b.timing, easing = SINE_EASING,loop = -1)
				animate(pixel_y = b.o_y, easing = SINE_EASING,time = b.timing)
				wings_south.vis_contents += bead2

				var/obj/effects/wing_pixel/beadN1 = new
				beadN1.icon_state = "bead north"
				beadN1.pixel_x = b.pixel_x
				beadN1.pixel_y = b.pixel_y
				beadN1.o_y = b.pixel_y
				beadN1.t_y = b.t_y
				beadN1.timing = b.timing
				animate(beadN1,pixel_y = b.t_y, time = b.timing, easing = SINE_EASING,loop = -1)
				animate(pixel_y = b.o_y, easing = SINE_EASING,time = b.timing)
				wings_north.vis_contents += beadN1

				var/obj/effects/wing_pixel/beadN2 = new
				beadN2.icon_state = "bead north"
				beadN2.pixel_x = (104-b.pixel_x)-104
				beadN2.pixel_y = b.pixel_y
				beadN2.o_y = b.pixel_y
				beadN2.t_y = b.t_y
				beadN2.timing = b.timing
				animate(beadN2,pixel_y = b.t_y, time = b.timing, easing = SINE_EASING,loop = -1)
				animate(pixel_y = b.o_y, easing = SINE_EASING,time = b.timing)
				wings_north.vis_contents += beadN2

				var/obj/effects/wing_pixel/bead3 = new
				bead3.icon_state = "bead west"
				bead3.pixel_x = b.pixel_x
				bead3.pixel_y = b.pixel_y
				bead3.o_y = b.pixel_y
				bead3.t_y = b.t_y
				bead3.timing = b.timing
				animate(bead3,pixel_y = b.t_y, time = b.timing, easing = SINE_EASING,loop = -1)
				animate(pixel_y = b.o_y, easing = SINE_EASING,time = b.timing)
				wings_west.vis_contents += bead3

				var/obj/effects/wing_pixel/bead4 = new
				bead4.icon_state = "bead east"
				bead4.pixel_x = (104-b.pixel_x)-104
				bead4.pixel_y = b.pixel_y
				bead4.o_y = b.pixel_y
				bead4.t_y = b.t_y
				bead4.timing = b.timing
				animate(bead4,pixel_y = b.t_y, time = b.timing, easing = SINE_EASING,loop = -1)
				animate(pixel_y = b.o_y, easing = SINE_EASING,time = b.timing)
				wings_east.vis_contents += bead4
				sleep(0.4)

			for(var/obj/effects/wing_pixel/b in right_beads1)
				var/obj/effects/wing_pixel/bead1 = new
				bead1.icon_state = "bead south"
				bead1.pixel_x = b.pixel_x
				bead1.pixel_y = b.pixel_y
				bead1.o_y = b.pixel_y
				bead1.t_y = b.t_y
				bead1.timing = b.timing
				animate(bead1,pixel_y = b.t_y, time = b.timing, easing = SINE_EASING,loop = -1)
				animate(pixel_y = b.o_y, easing = SINE_EASING,time = b.timing)
				wings_south.vis_contents += bead1

				var/obj/effects/wing_pixel/bead2 = new
				bead2.icon_state = "bead south"
				bead2.pixel_x = (104-b.pixel_x)-104
				bead2.pixel_y = b.pixel_y
				bead2.o_y = b.pixel_y
				bead2.t_y = b.t_y
				bead2.timing = b.timing
				animate(bead2,pixel_y = b.t_y, time = b.timing, easing = SINE_EASING,loop = -1)
				animate(pixel_y = b.o_y, easing = SINE_EASING,time = b.timing)
				wings_south.vis_contents += bead2

				var/obj/effects/wing_pixel/beadN1 = new
				beadN1.icon_state = "bead north"
				beadN1.pixel_x = b.pixel_x
				beadN1.pixel_y = b.pixel_y
				beadN1.o_y = b.pixel_y
				beadN1.t_y = b.t_y
				beadN1.timing = b.timing
				animate(beadN1,pixel_y = b.t_y, time = b.timing, easing = SINE_EASING,loop = -1)
				animate(pixel_y = b.o_y, easing = SINE_EASING,time = b.timing)
				wings_north.vis_contents += beadN1

				var/obj/effects/wing_pixel/beadN2 = new
				beadN2.icon_state = "bead north"
				beadN2.pixel_x = (104-b.pixel_x)-104
				beadN2.pixel_y = b.pixel_y
				beadN2.o_y = b.pixel_y
				beadN2.t_y = b.t_y
				beadN2.timing = b.timing
				animate(beadN2,pixel_y = b.t_y, time = b.timing, easing = SINE_EASING,loop = -1)
				animate(pixel_y = b.o_y, easing = SINE_EASING,time = b.timing)
				wings_north.vis_contents += beadN2

				var/obj/effects/wing_pixel/bead3 = new
				bead3.icon_state = "bead west"
				bead3.pixel_x = b.pixel_x
				bead3.pixel_y = b.pixel_y
				bead3.o_y = b.pixel_y
				bead3.t_y = b.t_y
				bead3.timing = b.timing
				animate(bead3,pixel_y = b.t_y, time = b.timing, easing = SINE_EASING,loop = -1)
				animate(pixel_y = b.o_y, easing = SINE_EASING,time = b.timing)
				wings_west.vis_contents += bead3

				var/obj/effects/wing_pixel/bead4 = new
				bead4.icon_state = "bead east"
				bead4.pixel_x = (104-b.pixel_x)-104
				bead4.pixel_y = b.pixel_y
				bead4.o_y = b.pixel_y
				bead4.t_y = b.t_y
				bead4.timing = b.timing
				animate(bead4,pixel_y = b.t_y, time = b.timing, easing = SINE_EASING,loop = -1)
				animate(pixel_y = b.o_y, easing = SINE_EASING,time = b.timing)
				wings_east.vis_contents += bead4
				sleep(0.4)

			for(var/obj/effects/wing_pixel/b in right_beads2)
				var/obj/effects/wing_pixel/bead1 = new
				bead1.icon_state = "bead south"
				bead1.pixel_x = b.pixel_x
				bead1.pixel_y = b.pixel_y
				bead1.o_y = b.pixel_y
				bead1.t_y = b.t_y
				bead1.timing = b.timing
				animate(bead1,pixel_y = b.t_y, time = b.timing, easing = SINE_EASING,loop = -1)
				animate(pixel_y = b.o_y, easing = SINE_EASING,time = b.timing)
				wings_south.vis_contents += bead1

				var/obj/effects/wing_pixel/bead2 = new
				bead2.icon_state = "bead south"
				bead2.pixel_x = (104-b.pixel_x)-104
				bead2.pixel_y = b.pixel_y
				bead2.o_y = b.pixel_y
				bead2.t_y = b.t_y
				bead2.timing = b.timing
				animate(bead2,pixel_y = b.t_y, time = b.timing, easing = SINE_EASING,loop = -1)
				animate(pixel_y = b.o_y, easing = SINE_EASING,time = b.timing)
				wings_south.vis_contents += bead2

				var/obj/effects/wing_pixel/beadN1 = new
				beadN1.icon_state = "bead north"
				beadN1.pixel_x = b.pixel_x
				beadN1.pixel_y = b.pixel_y
				beadN1.o_y = b.pixel_y
				beadN1.t_y = b.t_y
				beadN1.timing = b.timing
				animate(beadN1,pixel_y = b.t_y, time = b.timing, easing = SINE_EASING,loop = -1)
				animate(pixel_y = b.o_y, easing = SINE_EASING,time = b.timing)
				wings_north.vis_contents += beadN1

				var/obj/effects/wing_pixel/beadN2 = new
				beadN2.icon_state = "bead north"
				beadN2.pixel_x = (104-b.pixel_x)-104
				beadN2.pixel_y = b.pixel_y
				beadN2.o_y = b.pixel_y
				beadN2.t_y = b.t_y
				beadN2.timing = b.timing
				animate(beadN2,pixel_y = b.t_y, time = b.timing, easing = SINE_EASING,loop = -1)
				animate(pixel_y = b.o_y, easing = SINE_EASING,time = b.timing)
				wings_north.vis_contents += beadN2

				var/obj/effects/wing_pixel/bead3 = new
				bead3.icon_state = "bead west"
				bead3.pixel_x = b.pixel_x
				bead3.pixel_y = b.pixel_y
				bead3.o_y = b.pixel_y
				bead3.t_y = b.t_y
				bead3.timing = b.timing
				animate(bead3,pixel_y = b.t_y, time = b.timing, easing = SINE_EASING,loop = -1)
				animate(pixel_y = b.o_y, easing = SINE_EASING,time = b.timing)
				wings_west.vis_contents += bead3

				var/obj/effects/wing_pixel/bead4 = new
				bead4.icon_state = "bead east"
				bead4.pixel_x = (104-b.pixel_x)-104
				bead4.pixel_y = b.pixel_y
				bead4.o_y = b.pixel_y
				bead4.t_y = b.t_y
				bead4.timing = b.timing
				animate(bead4,pixel_y = b.t_y, time = b.timing, easing = SINE_EASING,loop = -1)
				animate(pixel_y = b.o_y, easing = SINE_EASING,time = b.timing)
				wings_east.vis_contents += bead4
				sleep(0.4)

			for(var/obj/effects/wing_pixel/b in right_beads3)
				var/obj/effects/wing_pixel/bead1 = new
				bead1.icon_state = "bead south"
				bead1.pixel_x = b.pixel_x
				bead1.pixel_y = b.pixel_y
				bead1.o_y = b.pixel_y
				bead1.t_y = b.t_y
				bead1.timing = b.timing
				animate(bead1,pixel_y = b.t_y, time = b.timing, easing = SINE_EASING,loop = -1)
				animate(pixel_y = b.o_y, easing = SINE_EASING,time = b.timing)
				wings_south.vis_contents += bead1

				var/obj/effects/wing_pixel/bead2 = new
				bead2.icon_state = "bead south"
				bead2.pixel_x = (104-b.pixel_x)-104
				bead2.pixel_y = b.pixel_y
				bead2.o_y = b.pixel_y
				bead2.t_y = b.t_y
				bead2.timing = b.timing
				animate(bead2,pixel_y = b.t_y, time = b.timing, easing = SINE_EASING,loop = -1)
				animate(pixel_y = b.o_y, easing = SINE_EASING,time = b.timing)
				wings_south.vis_contents += bead2

				var/obj/effects/wing_pixel/beadN1 = new
				beadN1.icon_state = "bead north"
				beadN1.pixel_x = b.pixel_x
				beadN1.pixel_y = b.pixel_y
				beadN1.o_y = b.pixel_y
				beadN1.t_y = b.t_y
				beadN1.timing = b.timing
				animate(beadN1,pixel_y = b.t_y, time = b.timing, easing = SINE_EASING,loop = -1)
				animate(pixel_y = b.o_y, easing = SINE_EASING,time = b.timing)
				wings_north.vis_contents += beadN1

				var/obj/effects/wing_pixel/beadN2 = new
				beadN2.icon_state = "bead north"
				beadN2.pixel_x = (104-b.pixel_x)-104
				beadN2.pixel_y = b.pixel_y
				beadN2.o_y = b.pixel_y
				beadN2.t_y = b.t_y
				beadN2.timing = b.timing
				animate(beadN2,pixel_y = b.t_y, time = b.timing, easing = SINE_EASING,loop = -1)
				animate(pixel_y = b.o_y, easing = SINE_EASING,time = b.timing)
				wings_north.vis_contents += beadN2

				var/obj/effects/wing_pixel/bead3 = new
				bead3.icon_state = "bead west"
				bead3.pixel_x = b.pixel_x
				bead3.pixel_y = b.pixel_y
				bead3.o_y = b.pixel_y
				bead3.t_y = b.t_y
				bead3.timing = b.timing
				animate(bead3,pixel_y = b.t_y, time = b.timing, easing = SINE_EASING,loop = -1)
				animate(pixel_y = b.o_y, easing = SINE_EASING,time = b.timing)
				wings_west.vis_contents += bead3

				var/obj/effects/wing_pixel/bead4 = new
				bead4.icon_state = "bead east"
				bead4.pixel_x = (104-b.pixel_x)-104
				bead4.pixel_y = b.pixel_y
				bead4.o_y = b.pixel_y
				bead4.t_y = b.t_y
				bead4.timing = b.timing
				animate(bead4,pixel_y = b.t_y, time = b.timing, easing = SINE_EASING,loop = -1)
				animate(pixel_y = b.o_y, easing = SINE_EASING,time = b.timing)
				wings_east.vis_contents += bead4
				sleep(0.5)

			var/matrix/m_south = matrix()
			m_south.Translate(0,-4)
			wings_south.transform = m_south
			wings_south.layer = 3

			var/matrix/m_north = matrix()
			m_north.Translate(0,-4)
			wings_north.transform = m_north
			wings_north.layer = 6

			var/matrix/m_east = matrix()
			m_east.Translate(0,-4)
			wings_east.transform = m_east
			wings_east.layer = 6

			var/matrix/m_west = matrix()
			m_west.Translate(0,-4)
			wings_west.transform = m_west
			wings_west.layer = 6

			right_beads0 = null
			right_beads1 = null
			right_beads2 = null
			right_beads3 = null
		create_growth_list()
			global.grow_order = list(new/obj/body_related/bodyparts/right_leg,new/obj/body_related/bodyparts/left_leg,new/obj/body_related/bodyparts/right_arm,new/obj/body_related/bodyparts/left_arm)
		spawn_chests()
			spawn(60)
				while(1)
					var/m = list(1,2)
					for(var/n in m)
						var/type = pick("resources","psi")
						if(type == "resources")
							var/obj/items/misc/resource_cache/c = new
							var/found_space = 0
							while(found_space == 0)
								c.loc = locate(rand(1,500),rand(1,500),n)
								var/turf/t = c.loc
								if(t.density == 0 && t.liquid == null) found_space = 1
								sleep(0.1)
						if(type == "psi")
							var/obj/items/misc/divine_cache/c = new
							var/found_space = 0
							while(found_space == 0)
								c.loc = locate(rand(1,500),rand(1,500),n)
								var/turf/t = c.loc
								if(t.density == 0 && t.liquid == null) found_space = 1
								sleep(0.1)
					sleep(36000)
		add_items()
			for(var/obj/items/I in world)
				if(!items.Find(I))
					if(!istype(I,/obj/items/environmental/))
						items += I


		respawn_items()
			var/total = 0
			var/nums = 0
			for(var/mob/NPC/c in block(locate(1,1,1),locate(480,480,1)))
				total += 1
			sleep(0.1)
			if(total <= 200)
				//Do Earth herbs and veg
				for(var/turf/grass/g in block(locate(1,1,1),locate(480,480,1)))
					nums += 1
					if(g.icon == 'terrain.dmi')
						var/c
						var/o = length(g.overlays)
						var/clear = 0
						var/placed = 0
						for(var/turf/g2 in range(1,g))
							c = length(g2.contents)
							if(c == 0) clear += 1
						if(clear == 9) if(o == 0)
							if(prob(0.1)) if(!placed)
								new /mob/NPC/Animals/Sheep(g)
								placed = 1
							if(prob(0.1)) if(!placed)
								new /mob/NPC/Animals/Cow(g)
								placed = 1
							if(prob(0.01)) if(!placed)
								new /mob/NPC/Animals/Mammoth(g)
								placed = 1
							if(prob(0.005)) if(!placed)
								new /mob/NPC/Animals/Dragon(g)
								placed = 1

							if(prob(0.002)) if(!placed)
								new /mob/NPC/Animals/Pterodactyl(g)
								placed = 1

							if(prob(0.1)) if(!placed)
								new /mob/NPC/Animals/Chicken(g)
								placed = 1
					if(nums >= 500)
						nums = 0
						sleep(0.1)
			total = 0
			for(var/mob/NPC/b in block(locate(1,1,2),locate(480,480,2)))
				total += 1
			sleep(0.1)
			if(total <= 100)
				//Do Psi Realms
				nums = 0
				for(var/turf/lava_cooled/g in block(locate(1,1,2),locate(480,480,2)))
					nums += 1
					if(g.icon == 'terrain.dmi')
						var/c
						var/o = length(g.overlays)
						var/clear = 0
						var/placed = 0
						for(var/turf/g2 in range(1,g))
							c = length(g2.contents)
							if(c == 0) clear += 1
						if(clear == 9) if(o == 0)
							if(prob(0.01)) if(!placed)
								new /mob/NPC/Animals/Dinosaur(g)
								placed = 1

							if(prob(0.01)) if(!placed)
								new /mob/NPC/Animals/Mammoth(g)
								placed = 1

							if(prob(0.005)) if(!placed)
								new /mob/NPC/Animals/T_Rex(g)
								placed = 1

							if(prob(0.01)) if(!placed)
								new /mob/NPC/Animals/Sheep(g)
								placed = 1
					if(nums >= 500)
						nums = 0
						sleep(0.1)
			total = 0
			for(var/mob/NPC/b in block(locate(1,1,10),locate(480,480,10)))
				total += 1
			sleep(0.1)
			if(total <= 100)
				//Do Vegeta Realms
				nums = 0
				for(var/turf/cracked_ground/g in block(locate(1,1,10),locate(480,480,10)))
					nums += 1
					if(g.icon == 'tileset2.dmi')
						var/c
						var/o = length(g.overlays)
						var/clear = 0
						var/placed = 0
						for(var/turf/g2 in range(1,g))
							c = length(g2.contents)
							if(c == 0) clear += 1
						if(clear == 9) if(o == 0)
							if(prob(0.01)) if(!placed)
								new /mob/NPC/Animals/Dinosaur(g)
								placed = 1

							if(prob(0.01)) if(!placed)
								new /mob/NPC/Animals/Mammoth(g)
								placed = 1

							if(prob(0.005)) if(!placed)
								new /mob/NPC/Animals/T_Rex(g)
								placed = 1



					if(nums >= 500)
						nums = 0
						sleep(0.1)

			total=0

			for(var/mob/NPC/b in block(locate(1,1,9),locate(480,480,9)))
				total += 1
			sleep(0.1)
			if(total <= 100)
				//Do Icer Realms
				nums = 0
				for(var/turf/Terrain/Ice/g in block(locate(1,1,9),locate(480,480,9)))
					nums += 1
					if(g.icon == 'tileset2.dmi')
						var/c
						var/o = length(g.overlays)
						var/clear = 0
						var/placed = 0
						for(var/turf/g2 in range(1,g))
							c = length(g2.contents)
							if(c == 0) clear += 1
						if(clear == 9) if(o == 0)
							if(prob(0.01)) if(!placed)
								new /mob/NPC/Animals/Dinosaur(g)
								placed = 1

							if(prob(0.01)) if(!placed)
								new /mob/NPC/Animals/Mammoth(g)
								placed = 1

							if(prob(0.01)) if(!placed)
								new /mob/NPC/Animals/Sheep(g)
								placed = 1

							if(prob(0.01)) if(!placed)
								new /mob/NPC/Animals/Dragon(g)
								placed = 1

							if(prob(0.005)) if(!placed)
								new /mob/NPC/Attack_Bot(g)
								placed = 1

					if(nums >= 500)
						nums = 0
						sleep(0.1)
			total=0
			for(var/mob/NPC/b in block(locate(1,1,4),locate(480,480,4)))
				total += 1
			sleep(0.1)
			if(total <= 100)
				//Do Namek Realms
				nums = 0
				for(var/turf/namekgrass/g in block(locate(1,1,4),locate(480,480,4)))
					nums += 1
					if(g.icon == 'NewNamekTileset.dmi')
						var/c
						var/o = length(g.overlays)
						var/clear = 0
						var/placed = 0
						for(var/turf/g2 in range(1,g))
							c = length(g2.contents)
							if(c == 0) clear += 1
						if(clear == 9) if(o == 0)
							if(prob(0.01)) if(!placed)
								new /mob/NPC/Animals/Dinosaur(g)
								placed = 1

							if(prob(0.01)) if(!placed)
								new /mob/NPC/Animals/Mammoth(g)
								placed = 1

							if(prob(0.02)) if(!placed)
								new /mob/NPC/Animals/Sheep(g)
								placed = 1

							if(prob(0.005)) if(!placed)
								new /mob/NPC/Animals/Pterodactyl(g)
								placed = 1

					if(nums >= 500)
						nums = 0
						sleep(0.1)
			total=0
			for(var/mob/NPC/b in block(locate(1,1,6),locate(480,480,6)))
				total += 1
			sleep(0.1)
			if(total <= 100)
				//Do Hell Realms
				nums = 0
				for(var/turf/lava_cooled/g in block(locate(1,1,6),locate(480,480,6)))
					nums += 1
					if(g.icon == 'terrain.dmi')
						var/c
						var/o = length(g.overlays)
						var/clear = 0
						var/placed = 0
						for(var/turf/g2 in range(1,g))
							c = length(g2.contents)
							if(c == 0) clear += 1
						if(clear == 9) if(o == 0)
							if(prob(0.01)) if(!placed)
								new /mob/NPC/Animals/Dinosaur(g)
								placed = 1

							if(prob(0.01)) if(!placed)
								new /mob/NPC/Animals/Mammoth(g)
								placed = 1

							if(prob(0.005)) if(!placed)
								new /mob/NPC/Animals/T_Rex(g)
								placed = 1

							if(prob(0.01)) if(!placed)
								new /mob/NPC/Animals/Sheep(g)
								placed = 1
					if(nums >= 500)
						nums = 0
						sleep(0.1)
			total = 0
			for(var/mob/NPC/b in block(locate(1,1,12),locate(480,480,12)))
				total += 1
			sleep(0.1)
			if(total <= 100)
				//Do DR Realms
				nums = 0
				for(var/turf/lava_cooled/g in block(locate(1,1,12),locate(480,480,12)))
					nums += 1
					if(g.icon == 'terrain.dmi')
						var/c
						var/o = length(g.overlays)
						var/clear = 0
						var/placed = 0
						for(var/turf/g2 in range(1,g))
							c = length(g2.contents)
							if(c == 0) clear += 1
						if(clear == 9) if(o == 0)
							if(prob(0.01)) if(!placed)
								new /mob/NPC/Animals/Dinosaur(g)
								placed = 1

							if(prob(0.01)) if(!placed)
								new /mob/NPC/Animals/Mammoth(g)
								placed = 1

							if(prob(0.005)) if(!placed)
								new /mob/NPC/Animals/T_Rex(g)
								placed = 1

							if(prob(0.01)) if(!placed)
								new /mob/NPC/Animals/Sheep(g)
								placed = 1
					if(nums >= 500)
						nums = 0
						sleep(0.1)
		create_npcs()
			var/earthnums = 0
			//EARTH-WATER NPC
			for(var/turf/water/g in block(locate(5,5,1),locate(400,480,1)))
				earthnums += 1
				if(g.icon == 'terrain.dmi')
					var/c
					var/o = length(g.overlays)
					var/clear = 0
					var/placed = 0
					for(var/turf/g2 in range(1,g))
						c = length(g2.contents)
						if(c == 0) clear += 1
					if(clear == 9) if(o == 0)
						if(prob(0.5)) if(!placed)
							new /mob/NPC/Animals/Small_Fish(g)
							placed = 1
						/*
						if(prob(0.5)) if(!placed)
							new /obj/items/plants/tree_birch(g)
							placed = 1
						*/

						if(prob(0.1))
							new /mob/NPC/Animals/Large_Fish(g)
							placed = 1



				if(earthnums >= 500)
					earthnums = 0
					sleep(0.1)
			//EARTH-LAND NPC
			for(var/turf/grass/g in block(locate(1,1,1),locate(500,500,1)))
				earthnums += 1
				if(g.icon == 'terrain.dmi')
					var/c
					var/o = length(g.overlays)
					var/clear = 0
					var/placed = 0
					for(var/turf/g2 in range(1,g))
						c = length(g2.contents)
						if(c == 0) clear += 1
					if(clear == 9) if(o == 0)
						if(prob(0.4)) if(!placed)
							new /mob/NPC/Animals/Sheep(g.loc)
							placed = 1
						/*
						if(prob(0.5)) if(!placed)
							new /obj/items/plants/tree_birch(g)
							placed = 1
						*/
						if(prob(0.3)) if(!placed)
							new /mob/NPC/Animals/Dragon(g.loc)
							placed = 1

						if(prob(0.5)) if(!placed)
							new /mob/NPC/Animals/Cow(g.loc)
							placed = 1

						if(prob(0.2))
							new /mob/NPC/Animals/Dinosaur(g.loc)
							placed = 1

						if(prob(0.8))
							new /mob/NPC/Animals/T_Rex(g.loc)
							placed = 1

						if(prob(0.2))
							new /mob/NPC/Animals/Pig(g.loc)
							placed = 1

						if(prob(0.5))
							new /mob/NPC/Animals/Chicken(g.loc)
							placed = 1

						if(prob(0.8))
							new /mob/NPC/Animals/Mammoth(g.loc)
							placed = 1


				if(earthnums >= 500)
					earthnums = 0
					sleep(0.1)

		create_earth_seeds()
			var/nums = 0
			for(var/turf/grass/g in block(locate(1,1,1),locate(480,480,1)))
				nums += 1
				if(g.icon == 'terrain.dmi')
					var/c
					var/o = length(g.overlays)
					var/clear = 0
					var/placed = 0
					for(var/turf/g2 in range(1,g))
						c = length(g2.contents)
						if(c == 0) clear += 1
					if(clear == 9) if(o == 0)
						if(prob(0.05)) if(!placed)
							new /obj/items/consumables/seeds(g)
							placed = 1

				if(nums >= 300)
					nums = 0
					sleep(0.1)

		create_vegeta_seeds()
			var/nums = 0
			for(var/turf/cracked_ground/g in block(locate(1,1,10),locate(480,480,10)))
				nums += 1
				if(g.icon == 'tileset2.dmi')
					var/c
					var/o = length(g.overlays)
					var/clear = 0
					var/placed = 0
					for(var/turf/g2 in range(1,g))
						c = length(g2.contents)
						if(c == 0) clear += 1
					if(clear == 9) if(o == 0)
						if(prob(0.05)) if(!placed)
							new /obj/items/consumables/seeds(g)
							placed = 1

				if(nums >= 300)
					nums = 0
					sleep(0.1)


		create_icer_seeds()
			var/nums = 0
			for(var/turf/Terrain/Ice/g in block(locate(1,1,9),locate(480,480,9)))
				nums += 1
				if(g.icon == 'tileset2.dmi')
					var/c
					var/o = length(g.overlays)
					var/clear = 0
					var/placed = 0
					for(var/turf/g2 in range(1,g))
						c = length(g2.contents)
						if(c == 0) clear += 1
					if(clear == 9) if(o == 0)
						if(prob(0.05)) if(!placed)
							new /obj/items/consumables/seeds(g)
							placed = 1

				if(nums >= 300)
					nums = 0
					sleep(0.1)


		create_namek_seeds()
			var/nums = 0
			for(var/turf/namekgrass/g in block(locate(1,1,4),locate(480,480,4)))
				nums += 1
				if(g.icon == 'NewNamekTileset.dmi')
					var/c
					var/o = length(g.overlays)
					var/clear = 0
					var/placed = 0
					for(var/turf/g2 in range(1,g))
						c = length(g2.contents)
						if(c == 0) clear += 1
					if(clear == 9) if(o == 0)
						if(prob(0.05)) if(!placed)
							new /obj/items/consumables/seeds(g)
							placed = 1

				if(nums >= 300)
					nums = 0
					sleep(0.1)




		/*	var/nums5=0
			for(var/turf/Terrain/namekgrass/gg in block(locate(30,30,4),locate(380,380,4)))
				nums5 += 1
				if(gg.icon == 'NewNamekTileset.dmi')
					var/c
					var/o = length(gg.overlays)
					var/clear = 0
					var/placed = 0
					for(var/turf/gg2 in range(1,gg))
						c = length(gg2.contents)
						if(c == 0) clear += 1
					if(clear == 9) if(o == 0)
						if(prob(0.1)) if(!placed)
							new /obj/items/consumables/seeds(gg)
							placed = 1

				if(nums5 >= 200)
					nums5 = 0
					sleep(0.1)
					*/
		create_otherworld_seeds()
			var/nums = 0
			for(var/turf/grass_crystal/g in block(locate(1,1,2),locate(480,480,2)))
				nums += 1
				if(g.icon == 'terrain.dmi')
					var/c
					var/o = length(g.overlays)
					var/clear = 0
					var/placed = 0
					for(var/turf/g2 in range(1,g))
						c = length(g2.contents)
						if(c == 0) clear += 1
					if(clear == 9) if(o == 0)
						if(prob(0.05)) if(!placed)
							new /obj/items/consumables/seeds(g)
							placed = 1

				if(nums >= 100)
					nums = 0
					sleep(0.1)



		create_hell_seeds()
			var/nums = 0
			for(var/turf/lava_cooled/g in block(locate(1,1,6),locate(480,480,6)))
				nums += 1
				if(g.icon == 'terrain.dmi')
					var/c
					var/o = length(g.overlays)
					var/clear = 0
					var/placed = 0
					for(var/turf/g2 in range(1,g))
						c = length(g2.contents)
						if(c == 0) clear += 1
					if(clear == 9) if(o == 0)
						if(prob(0.05)) if(!placed)
							new /obj/items/consumables/seeds(g)
							placed = 1

				if(nums >= 150)
					nums = 0
					sleep(0.1)


		create_heaven_seeds()
			var/nums = 0
			for(var/turf/grass_crystal/g in block(locate(1,1,11),locate(480,480,11)))
				nums += 1
				if(g.icon == 'terrain.dmi')
					var/c
					var/o = length(g.overlays)
					var/clear = 0
					var/placed = 0
					for(var/turf/g2 in range(1,g))
						c = length(g2.contents)
						if(c == 0) clear += 1
					if(clear == 9) if(o == 0)
						if(prob(0.05)) if(!placed)
							new /obj/items/consumables/seeds(g)
							placed = 1

				if(nums >= 150)
					nums = 0
					sleep(0.1)

		create_darkrealm_seeds()
			var/nums = 0
			for(var/turf/lava_cooled/g in block(locate(1,1,12),locate(480,480,12)))
				nums += 1
				if(g.icon == 'terrain.dmi')
					var/c
					var/o = length(g.overlays)
					var/clear = 0
					var/placed = 0
					for(var/turf/g2 in range(1,g))
						c = length(g2.contents)
						if(c == 0) clear += 1
					if(clear == 9) if(o == 0)
						if(prob(0.05)) if(!placed)
							new /obj/items/consumables/seeds(g)
							placed = 1

				if(nums >= 150)
					nums = 0
					sleep(0.1)


		create_darkrealm_seeds2()
			var/nums = 0
			for(var/turf/grass/g in block(locate(1,1,12),locate(480,480,12)))
				nums += 1
				if(g.icon == 'terrain.dmi')
					var/c
					var/o = length(g.overlays)
					var/clear = 0
					var/placed = 0
					for(var/turf/g2 in range(1,g))
						c = length(g2.contents)
						if(c == 0) clear += 1
					if(clear == 9) if(o == 0)
						if(prob(0.05)) if(!placed)
							new /obj/items/consumables/seeds(g)
							placed = 1

				if(nums >= 100)
					nums = 0
					sleep(0.1)



		create_seeds()
			set background = 1

			create_earth_seeds()
			sleep(0.1)
			create_vegeta_seeds()
			sleep(0.1)
			create_icer_seeds()
			sleep(0.1)
			create_namek_seeds()
			sleep(0.1)
			create_otherworld_seeds()
			sleep(0.1)
			create_hell_seeds()
			sleep(0.1)
			create_heaven_seeds()
			sleep(0.1)
			create_darkrealm_seeds()
			sleep(0.1)
			create_darkrealm_seeds2()




		create_namek_plants()
			var/nums = 0
			for(var/turf/namekgrass/g in block(locate(1,1,4),locate(480,480,4)))
				nums += 1
				if(g.icon == 'NewNamekTileset.dmi')
					var/c
					var/o = length(g.overlays)
					var/clear = 0
					var/placed = 0
					for(var/turf/g2 in range(1,g))
						c = length(g2.contents)
						if(c == 0) clear += 1
					if(clear == 9) if(o == 0)
						if(prob(0.4)) if(!placed)
							new /obj/items/misc/rock(g)
							placed = 1
						if(namek_artifacts<7)
							if(prob(0.001))
								if(!placed)
									new/obj/items/misc/crashed_satellite(g)
									placed = 1
									namek_artifacts ++
									namek_spawn_tiles += g

							if(prob(0.001)) if(!placed)
								new/obj/items/misc/meteorite(g)
								placed = 1
								namek_artifacts ++
								namek_spawn_tiles += g

							if(prob(0.01)) if(!placed)
								new/obj/items/misc/crashed_storage(g)
								placed = 1
								namek_artifacts ++
								namek_spawn_tiles += g
							if(prob(0.01)) if(!placed)
								new/obj/items/misc/crashed_space_pod(g)
								placed = 1
								namek_artifacts ++
								namek_spawn_tiles += g
							if(prob(0.01)) if(!placed)
								new/obj/items/misc/rad_rock_3(g)
								placed = 1
								namek_artifacts ++
								namek_spawn_tiles += g

							if(prob(0.01)) if(!placed)
								new/obj/items/misc/rad_rock_2(g)
								namek_artifacts ++
								placed = 1
								namek_spawn_tiles += g
							if(prob(0.01)) if(!placed)
								new/obj/items/misc/sword_in_stone(g)
								namek_artifacts ++
								placed = 1
								namek_spawn_tiles += g

						/*
						if(prob(0.5)) if(!placed)
							new /obj/items/plants/tree_birch(g)
							placed = 1
						*/
						if(prob(0.5)) if(!placed)
							new /obj/items/plants/namek_tree(g)
							placed = 1


						if(prob(0.5)) if(!placed)
							new /obj/items/plants/twig(g)
							placed = 1

				if(nums >= 500)
					nums = 0

					sleep(0.1)



		/*	var/nums2 = 0
			for(var/turf/grass/gg in block(locate(1,1,4),locate(450,450,4)))
				nums2 += 1
				if(gg.icon == 'terrain.dmi' && gg.icon_state == "grass crystal")
					var/c
					var/o = length(gg.overlays)
					var/clear = 0
					var/placed = 0
					for(var/turf/gg2 in range(1,gg))
						c = length(gg2.contents)
						if(c == 0) clear += 1
					if(clear == 9) if(o == 0)
						if(prob(0.1)) if(!placed)
							new /obj/buildables/Namektree(gg)
							placed = 1



						if(prob(0.01)) if(!placed)
							new /obj/items/plants/twig(gg)
							placed = 1

				if(nums2 >= 150)
					nums2 = 0
					sleep(0.2)
					*/
		create_afterlife_plants()
			var/nums=0
			var/nums2=0
			for(var/turf/grass/g in block(locate(1,1,11),locate(480,480,11)))
				nums2 += 1
				if(g.icon == 'terrain.dmi')
					var/c
					var/o = length(g.overlays)
					var/clear = 0
					var/placed = 0
					for(var/turf/g2 in range(1,g))
						c = length(g2.contents)
						if(c == 0) clear += 1
					if(clear == 9) if(o == 0)
						if(prob(0.4)) if(!placed)
							new /obj/items/misc/rock(g)
							placed = 1


						if(checkpoint_artifacts<7)
							if(prob(0.01)) if(!placed)
								new/obj/items/misc/meteorite(g)
								placed = 1
								checkpoint_artifacts++
								checkpoint_spawn_tiles += g
							if(prob(0.01)) if(!placed)
								new/obj/items/misc/crashed_storage(g)
								placed = 1
								checkpoint_artifacts++
								checkpoint_spawn_tiles += g
							if(prob(0.01)) if(!placed)
								new/obj/items/misc/crashed_space_pod(g)
								placed = 1
								checkpoint_artifacts++
								checkpoint_spawn_tiles += g
							if(prob(0.01)) if(!placed)
								new/obj/items/misc/crashed_satellite(g)
								placed = 1
								checkpoint_artifacts++
								checkpoint_spawn_tiles += g
							if(prob(0.01)) if(!placed)
								new/obj/items/misc/rad_rock_2(g)
								placed = 1
								checkpoint_artifacts++
								checkpoint_spawn_tiles += g
							if(prob(0.01)) if(!placed)
								new/obj/items/misc/rad_rock_1(g)
								placed = 1
								checkpoint_artifacts++
								checkpoint_spawn_tiles += g
							if(prob(0.01)) if(!placed)
								new/obj/items/misc/rad_rock_3(g)
								placed = 1
								checkpoint_artifacts++
								checkpoint_spawn_tiles += g
							if(prob(0.01)) if(!placed)
								new/obj/items/misc/sword_in_stone(g)
								placed = 1
								checkpoint_artifacts++
								checkpoint_spawn_tiles += g
						/*
						if(prob(0.5)) if(!placed)
							new /obj/items/plants/tree_birch(g)
							placed = 1

						if(prob(0.5)) if(!placed)
							new /obj/items/plants/tree_chestnut(g)
							placed = 1
						if(prob(0.5)) if(!placed)
							new /obj/items/plants/tree_maple(g)
							placed = 1
						*/
						if(prob(0.1)) if(!placed)
							new /obj/items/misc/icerock1(g)
							placed = 1
						if(prob(2)) if(!placed)
							new /obj/items/plants/oak_white(g)
							placed = 1
						if(prob(0.2)) if(!placed)
							new /obj/items/plants/tree_oak_dead(g)
							placed = 1


						if(prob(0.5)) if(!placed)
							new /obj/items/plants/twig(g)
							placed = 1

				if(nums2 >= 500)
					nums2 = 0
					sleep(0.1)


			for(var/turf/snows/snow5/g in block(locate(1,1,2),locate(480,480,2)))
				nums += 1
				if(g.icon == 'terrain.dmi')
					var/c
					var/o = length(g.overlays)
					var/clear = 0
					var/placed = 0
					for(var/turf/g2 in range(1,g))
						c = length(g2.contents)
						if(c == 0) clear += 1
					if(clear == 9) if(o == 0)
						if(prob(0.4)) if(!placed)
							new /obj/items/misc/rock(g)
							placed = 1


						if(checkpoint_artifacts<7)
							if(prob(0.01)) if(!placed)
								new/obj/items/misc/meteorite(g)
								placed = 1
								checkpoint_artifacts++
								checkpoint_spawn_tiles += g
							if(prob(0.01)) if(!placed)
								new/obj/items/misc/crashed_storage(g)
								placed = 1
								checkpoint_artifacts++
								checkpoint_spawn_tiles += g
							if(prob(0.01)) if(!placed)
								new/obj/items/misc/crashed_space_pod(g)
								placed = 1
								checkpoint_artifacts++
								checkpoint_spawn_tiles += g
							if(prob(0.01)) if(!placed)
								new/obj/items/misc/crashed_satellite(g)
								placed = 1
								checkpoint_artifacts++
								checkpoint_spawn_tiles += g
							if(prob(0.01)) if(!placed)
								new/obj/items/misc/rad_rock_2(g)
								placed = 1
								checkpoint_artifacts++
								checkpoint_spawn_tiles += g
							if(prob(0.01)) if(!placed)
								new/obj/items/misc/rad_rock_1(g)
								placed = 1
								checkpoint_artifacts++
								checkpoint_spawn_tiles += g
							if(prob(0.01)) if(!placed)
								new/obj/items/misc/rad_rock_3(g)
								placed = 1
								checkpoint_artifacts++
								checkpoint_spawn_tiles += g
							if(prob(0.01)) if(!placed)
								new/obj/items/misc/sword_in_stone(g)
								placed = 1
								checkpoint_artifacts++
								checkpoint_spawn_tiles += g
						/*
						if(prob(0.5)) if(!placed)
							new /obj/items/plants/tree_birch(g)
							placed = 1

						if(prob(0.5)) if(!placed)
							new /obj/items/plants/tree_chestnut(g)
							placed = 1
						if(prob(0.5)) if(!placed)
							new /obj/items/plants/tree_maple(g)
							placed = 1
						*/
						if(prob(0.1)) if(!placed)
							new /obj/items/misc/icerock1(g)
							placed = 1
						if(prob(2)) if(!placed)
							new /obj/items/plants/oak_white(g)
							placed = 1
						if(prob(0.2)) if(!placed)
							new /obj/items/plants/tree_oak_dead(g)
							placed = 1


						if(prob(0.5)) if(!placed)
							new /obj/items/plants/twig(g)
							placed = 1

				if(nums >= 500)
					nums = 0

					sleep(0.1)

		create_icer_plants()
			var/nums=0
			for(var/turf/snows/snow5/g in block(locate(1,1,9),locate(400,400,9)))
				nums += 1
				if(g.icon == 'terrain.dmi')
					var/c
					var/o = length(g.overlays)
					var/clear = 0
					var/placed = 0
					for(var/turf/g2 in range(1,g))
						c = length(g2.contents)
						if(c == 0) clear += 1
					if(clear == 9) if(o == 0)
						if(prob(0.4)) if(!placed)
							new /obj/items/misc/rock(g)
							placed = 1
						if(icer_artifacts<7)
							if(prob(0.001)) if(!placed)
								new/obj/items/misc/crashed_satellite(g)
								placed = 1
								icer_artifacts++
								icer_spawn_tiles += g

							if(prob(0.01)) if(!placed)
								new/obj/items/misc/meteorite(g)
								placed = 1
								icer_artifacts++
								icer_spawn_tiles += g

							if(prob(0.0012)) if(!placed)
								new/obj/items/misc/crashed_space_pod(g)
								placed = 1
								icer_artifacts++
								icer_spawn_tiles += g
							if(prob(0.01)) if(!placed)
								new/obj/items/misc/crashed_storage(g)
								placed = 1
								icer_artifacts++
								icer_spawn_tiles += g

							if(prob(0.01)) if(!placed)
								new/obj/items/misc/rad_rock_3(g)
								placed = 1
								icer_artifacts++
								icer_spawn_tiles += g

							if(prob(0.01)) if(!placed)
								new/obj/items/misc/rad_rock_2(g)
								placed = 1
								icer_artifacts++
								icer_spawn_tiles += g
							if(prob(0.01)) if(!placed)
								new/obj/items/misc/sword_in_stone(g)
								placed = 1
								icer_artifacts++
								icer_spawn_tiles += g
							if(prob(0.01)) if(!placed)
								new/obj/items/misc/rad_rock_1(g)
								placed = 1
								icer_artifacts++
								icer_spawn_tiles += g
						/*

						if(prob(0.5)) if(!placed)
							new /obj/items/plants/tree_birch(g)
							placed = 1

						if(prob(0.5)) if(!placed)
							new /obj/items/plants/tree_chestnut(g)
							placed = 1
						if(prob(0.5)) if(!placed)
							new /obj/items/plants/tree_maple(g)
							placed = 1
						*/
						if(prob(0.1)) if(!placed)
							new /obj/items/misc/icerock1(g)
							placed = 1
						if(prob(2)) if(!placed)
							new /obj/items/plants/oak_white(g)
							placed = 1
						if(prob(0.2)) if(!placed)
							new /obj/items/plants/tree_oak_dead(g)
							placed = 1


						if(prob(0.5)) if(!placed)
							new /obj/items/plants/twig(g)
							placed = 1

				if(nums >= 500)
					nums = 0
					sleep(0.1)



		create_vegeta_plants()
			var/nums = 0
			for(var/turf/Terrain/tilesets1/grass5/g in block(locate(1,1,10),locate(480,480,10)))
				nums += 1
				if(g.icon == 'tileset1.dmi')
					var/c
					var/o = length(g.overlays)
					var/clear = 0
					var/placed = 0
					for(var/turf/g2 in range(1,g))
						c = length(g2.contents)
						if(c == 0) clear += 1
					if(clear == 9) if(o == 0)
						if(prob(0.4)) if(!placed)
							new /obj/items/misc/rock(g)
							placed = 1

						/*
						if(prob(0.5)) if(!placed)
							new /obj/items/plants/tree_birch(g)
							placed = 1
						*/
						if(prob(0.5)) if(!placed)
							new /obj/GDBGSet/trees/treered(g)
							placed = 1

						if(prob(0.5)) if(!placed)
							new /obj/items/plants/oak_black(g)
							placed = 1
							placed = 1


						if(prob(0.5)) if(!placed)
							new /obj/items/plants/twig(g)
							placed = 1

				if(nums >= 500)
					nums = 0
					sleep(0.1)
		create_heaven_artifacts()
			var/nums = 0
			for(var/turf/grass/g in block(locate(1,1,10),locate(480,480,11)))
				nums += 1
				if(g.icon)
					var/c
					var/o = length(g.overlays)
					var/clear = 0
					var/placed = 0

					for(var/turf/g2 in range(1,g))
						c = length(g2.contents)
						if(c == 0) clear += 1
					if(clear == 9) if(o == 0)
						if(prob(0.4)) if(!placed)
							new /obj/items/misc/rock(g)
							placed = 1
						if(heaven_artifacts<7)
							if(prob(0.001)) if(!placed)
								new/obj/items/misc/crashed_satellite(g)
								placed = 1
								heaven_artifacts ++
								heaven_spawn_tiles += g
							if(prob(0.01)) if(!placed)
								new/obj/items/misc/meteorite(g)
								placed = 1
								heaven_artifacts ++
								heaven_spawn_tiles += g
							if(prob(0.0012)) if(!placed)
								new/obj/items/misc/crashed_space_pod(g)
								placed = 1
								heaven_artifacts ++
								heaven_spawn_tiles += g
							if(prob(0.01)) if(!placed)
								new/obj/items/misc/crashed_storage(g)
								placed = 1
								heaven_artifacts ++
								heaven_spawn_tiles += g

							if(prob(0.01)) if(!placed)
								new/obj/items/misc/rad_rock_3(g)
								placed = 1
								heaven_artifacts ++
								heaven_spawn_tiles += g

							if(prob(0.01)) if(!placed)
								new/obj/items/misc/rad_rock_2(g)
								placed = 1
								heaven_artifacts ++
								heaven_spawn_tiles += g
							if(prob(0.01)) if(!placed)
								new/obj/items/misc/sword_in_stone(g)
								placed = 1
								heaven_artifacts ++
								heaven_spawn_tiles += g
							if(prob(0.01)) if(!placed)
								new/obj/items/misc/rad_rock_1(g)
								placed = 1
								heaven_artifacts ++
								heaven_spawn_tiles += g




				if(nums >= 500)
					nums = 0

					sleep(0.1)
		create_hell_artifacts2()
			var/nums = 0
			for(var/turf/Terrain/pink_snow/g in block(locate(1,1,10),locate(480,480,6)))
				nums += 1
				if(g.icon)
					var/c
					var/o = length(g.overlays)
					var/clear = 0
					var/placed = 0

					for(var/turf/g2 in range(1,g))
						c = length(g2.contents)
						if(c == 0) clear += 1
					if(clear == 9) if(o == 0)
						if(prob(0.4)) if(!placed)
							new /obj/items/misc/rock(g)
							placed = 1
						if(hell_artifacts<7)
							if(prob(0.001)) if(!placed)
								new/obj/items/misc/crashed_satellite(g)
								placed = 1
								hell_artifacts ++
								hell_spawn_tiles += g
							if(prob(0.01)) if(!placed)
								new/obj/items/misc/meteorite(g)
								placed = 1
								hell_artifacts ++
								hell_spawn_tiles += g
							if(prob(0.0012)) if(!placed)
								new/obj/items/misc/crashed_space_pod(g)
								placed = 1
								hell_artifacts ++
								hell_spawn_tiles += g
							if(prob(0.01)) if(!placed)
								new/obj/items/misc/crashed_storage(g)
								placed = 1
								hell_artifacts ++
								hell_spawn_tiles += g

							if(prob(0.01)) if(!placed)
								new/obj/items/misc/rad_rock_3(g)
								placed = 1
								hell_artifacts ++
								hell_spawn_tiles += g

							if(prob(0.01)) if(!placed)
								new/obj/items/misc/rad_rock_2(g)
								placed = 1
								hell_artifacts ++
								hell_spawn_tiles += g
							if(prob(0.01)) if(!placed)
								new/obj/items/misc/sword_in_stone(g)
								placed = 1
								hell_artifacts ++
								hell_spawn_tiles += g
							if(prob(0.01)) if(!placed)
								new/obj/items/misc/rad_rock_1(g)
								placed = 1
								hell_artifacts ++
								hell_spawn_tiles += g




				if(nums >= 500)
					nums = 0

					sleep(0.1)

		create_hell_artifacts()
			var/nums = 0
			for(var/turf/lava_cooled/g in block(locate(1,1,10),locate(480,480,6)))
				nums += 1
				if(g.icon)
					var/c
					var/o = length(g.overlays)
					var/clear = 0
					var/placed = 0

					for(var/turf/g2 in range(1,g))
						c = length(g2.contents)
						if(c == 0) clear += 1
					if(clear == 9) if(o == 0)
						if(prob(0.4)) if(!placed)
							new /obj/items/misc/rock(g)
							placed = 1
						if(hell_artifacts<7)
							if(prob(0.001)) if(!placed)
								new/obj/items/misc/crashed_satellite(g)
								placed = 1
								hell_artifacts ++
								hell_spawn_tiles += g
							if(prob(0.01)) if(!placed)
								new/obj/items/misc/meteorite(g)
								placed = 1
								hell_artifacts ++
								hell_spawn_tiles += g
							if(prob(0.0012)) if(!placed)
								new/obj/items/misc/crashed_space_pod(g)
								placed = 1
								hell_artifacts ++
								hell_spawn_tiles += g
							if(prob(0.01)) if(!placed)
								new/obj/items/misc/crashed_storage(g)
								placed = 1
								hell_artifacts ++
								hell_spawn_tiles += g

							if(prob(0.01)) if(!placed)
								new/obj/items/misc/rad_rock_3(g)
								placed = 1
								hell_artifacts ++
								hell_spawn_tiles += g

							if(prob(0.01)) if(!placed)
								new/obj/items/misc/rad_rock_2(g)
								placed = 1
								hell_artifacts ++
								hell_spawn_tiles += g
							if(prob(0.01)) if(!placed)
								new/obj/items/misc/sword_in_stone(g)
								placed = 1
								hell_artifacts ++
								hell_spawn_tiles += g
							if(prob(0.01)) if(!placed)
								new/obj/items/misc/rad_rock_1(g)
								placed = 1
								hell_artifacts ++
								hell_spawn_tiles += g




				if(nums >= 500)
					nums = 0

					sleep(0.1)
		create_vegeta_terrains()
			var/nums = 0
			for(var/turf/cracked_ground/g in block(locate(1,1,10),locate(480,480,10)))
				nums += 1
				if(g.icon == 'tileset2.dmi')
					var/c
					var/o = length(g.overlays)
					var/clear = 0
					var/placed = 0

					for(var/turf/g2 in range(1,g))
						c = length(g2.contents)
						if(c == 0) clear += 1
					if(clear == 9) if(o == 0)
						if(prob(0.4)) if(!placed)
							new /obj/items/misc/rock(g)
							placed = 1
						if(vegeta_artifacts<7)
							if(prob(0.001)) if(!placed)
								new/obj/items/misc/crashed_satellite(g)
								placed = 1
								vegeta_artifacts ++
								vegeta_spawn_tiles += g
							if(prob(0.01)) if(!placed)
								new/obj/items/misc/meteorite(g)
								placed = 1
								vegeta_artifacts ++
								vegeta_spawn_tiles += g
							if(prob(0.0012)) if(!placed)
								new/obj/items/misc/crashed_space_pod(g)
								placed = 1
								vegeta_artifacts ++
							if(prob(0.01)) if(!placed)
								new/obj/items/misc/crashed_storage(g)
								placed = 1
								vegeta_artifacts ++
								vegeta_spawn_tiles += g

							if(prob(0.01)) if(!placed)
								new/obj/items/misc/rad_rock_3(g)
								placed = 1
								vegeta_artifacts ++
								vegeta_spawn_tiles += g

							if(prob(0.01)) if(!placed)
								new/obj/items/misc/rad_rock_2(g)
								placed = 1
								vegeta_artifacts ++
								vegeta_spawn_tiles += g
							if(prob(0.01)) if(!placed)
								new/obj/items/misc/sword_in_stone(g)
								placed = 1
								vegeta_artifacts ++
								vegeta_spawn_tiles += g
							if(prob(0.01)) if(!placed)
								new/obj/items/misc/rad_rock_1(g)
								placed = 1
								vegeta_artifacts ++
								vegeta_spawn_tiles += g


						if(prob(0.1)) if(!placed)
							new /obj/GDBGSet/trees/treered(g)
							placed = 1
						if(prob(0.05)) if(!placed)
							new /obj/items/plants/tree_oak_dead(g)
							placed = 1
						/*if(prob(0.5)) if(!placed)
							new /obj/items/plants/tree_maple(g)
							placed = 1
						*/



						if(prob(0.5)) if(!placed)
							new /obj/items/plants/twig(g)
							placed = 1

				if(nums >= 500)
					nums = 0

					sleep(0.1)



		create_plants()
			var/nums = 0
			for(var/turf/grass/g in block(locate(1,1,1),locate(480,480,1)))
				nums += 1
				if(g.icon == 'terrain.dmi')
					var/c
					var/o = length(g.overlays)
					var/clear = 0
					var/placed = 0

					for(var/turf/g2 in range(1,g))
						c = length(g2.contents)
						if(c == 0) clear += 1
					if(clear == 9) if(o == 0)
						if(prob(0.4)) if(!placed)
							new /obj/items/misc/rock(g)
							placed = 1
						if(earth_artifacts<7)
							if(prob(0.001)) if(!placed)
								new/obj/items/misc/crashed_satellite(g)
								placed = 1
								earth_artifacts ++
								earth_spawn_tiles += g
							if(prob(0.01)) if(!placed)
								new/obj/items/misc/meteorite(g)
								placed = 1
								earth_artifacts ++
								earth_spawn_tiles += g
							if(prob(0.01)) if(!placed)
								new/obj/items/misc/crashed_storage(g)
								placed = 1
								earth_artifacts ++
								earth_spawn_tiles += g
							if(prob(0.01)) if(!placed)
								new/obj/items/misc/crashed_space_pod(g)
								placed = 1
								earth_artifacts ++
								earth_spawn_tiles += g
							if(prob(0.01)) if(!placed)
								new/obj/items/misc/rad_rock_3(g)
								placed = 1
								earth_artifacts ++
								earth_spawn_tiles += g
							if(prob(0.01)) if(!placed)
								new/obj/items/misc/rad_rock_2(g)
								placed = 1
								earth_artifacts ++
								earth_spawn_tiles += g
							if(prob(0.01)) if(!placed)
								new/obj/items/misc/sword_in_stone(g)
								placed = 1
								earth_artifacts ++
								earth_spawn_tiles += g
							if(prob(0.01)) if(!placed)
								new/obj/items/misc/rad_rock_3(g)
								placed = 1
								earth_artifacts ++
								earth_spawn_tiles += g
						/*
						if(prob(0.5)) if(!placed)
							new /obj/items/plants/tree_birch(g)
							placed = 1
						*/
						if(prob(0.5)) if(!placed)
							new /obj/items/plants/tree_oak(g)
							placed = 1
						/*
						if(prob(0.5)) if(!placed)
							new /obj/items/plants/tree_chestnut(g)
							placed = 1
						if(prob(0.5)) if(!placed)
							new /obj/items/plants/tree_maple(g)
							placed = 1
						*/
						if(prob(2)) if(!placed)
							var/bushes = list(/obj/items/plants/bush_large1,/obj/items/plants/bush_large2,/obj/items/plants/bush_large3)
							var/obj/b = pick(bushes)
							new b(g)
							placed = 1
						if(prob(2)) if(!placed)
							var/bushes = list(/obj/items/plants/bush_small1,/obj/items/plants/bush_small2,/obj/items/plants/bush_small3)
							var/obj/b = pick(bushes)
							new b(g)
							placed = 1
						if(prob(1)) if(!placed)
							new /obj/items/plants/rockgrass(g)
							placed = 1
						if(prob(0.5)) if(!placed)
							new /obj/items/plants/twig(g)
							placed = 1
						/*
						if(prob(0.1)) if(!placed)
							new /obj/items/plants/beanstalk(g)
							placed = 1
						if(prob(0.2)) if(!placed)
							new /obj/items/consumables/shroom_red(g)
							placed = 1
						if(prob(0.2)) if(!placed)
							new /obj/items/consumables/ginseng(g)
							placed = 1
						if(prob(0.2)) if(!placed)
							new /obj/items/consumables/turnip(g)
							placed = 1
						if(prob(0.1)) if(!placed)
							new /obj/items/consumables/shroom_psi(g)
							placed = 1
						if(prob(0.1)) if(!placed)
							new /obj/items/consumables/shroom_truffle(g)
							placed = 1
						*/
						if(prob(5)) if(!placed)
							new /obj/items/plants/flower(g)
							placed = 1
						if(prob(5)) if(!placed)
							new /obj/items/plants/plant(g)
							placed = 1
				if(nums >= 500)
					nums = 0

					sleep(0.1)


		edges_dirt()
			set background = 1
			var/n = 0
			for(var/turf/grass/g in block(locate(1,1,1),locate(480,480,2)))
				n += 1
				var/o = length(g.overlays)
				if(o <= 0)
					var/water_sides = 0
					var/turf/found_west = get_step(g,WEST)
					var/turf/found_east = get_step(g,EAST)
					var/turf/found_north = get_step(g,NORTH)
					var/turf/found_south = get_step(g,SOUTH)
					var/turf/found_southwest = get_step(g,SOUTHWEST)
					var/turf/found_northwest = get_step(g,NORTHWEST)
					var/turf/found_northeast = get_step(g,NORTHEAST)
					var/turf/found_southeast = get_step(g,SOUTHEAST)
					if(istype(found_west,/turf/dirts/dirt5)) water_sides += 1
					else found_west = null
					if(istype(found_east,/turf/dirts/dirt5)) water_sides += 1
					else found_east = null
					if(istype(found_north,/turf/dirts/dirt5)) water_sides += 1
					else found_north = null
					if(istype(found_south,/turf/dirts/dirt5)) water_sides += 1
					else found_south = null
					if(istype(found_southwest,/turf/dirts/dirt5)) water_sides += 1
					else found_southwest = null
					if(istype(found_southeast,/turf/dirts/dirt5)) water_sides += 1
					else found_southeast = null
					if(istype(found_northwest,/turf/dirts/dirt5)) water_sides += 1
					else found_northwest = null
					if(istype(found_northeast,/turf/dirts/dirt5)) water_sides += 1
					else found_northeast = null
					if(found_south) g.overlays += /turf/dirts/dirt8
					if(found_north) g.overlays += /turf/dirts/dirt2
					if(found_west) g.overlays += /turf/dirts/dirt6
					if(found_east) g.overlays += /turf/dirts/dirt4
					if(water_sides == 1) if(found_southwest) g.overlays += /turf/dirts/dirt9
					if(water_sides == 1) if(found_southeast) g.overlays += /turf/dirts/dirt7
					if(water_sides == 1) if(found_northwest) g.overlays += /turf/dirts/dirt3
					if(water_sides == 1) if(found_northeast) g.overlays += /turf/dirts/dirt1
				if(n >= 100)
					n=0
					sleep(0.1)
		edges_solid_rock(var/xx_start,var/yy_start,var/xx_end,var/yy_end,var/zz)
			var/n = 0
			for(var/turf/g in block(locate(xx_start,yy_start,zz),locate(xx_end,yy_end,zz)))
				if(g.type == /turf/stone_roof/)
					if(g.glow)
						g.glow.destroy()
						g.glow = null
					n += 1
					var/rock_floors = 0
					var/turf/found_west = get_step(g,WEST)
					var/turf/found_east = get_step(g,EAST)
					var/turf/found_north = get_step(g,NORTH)
					var/turf/found_south = get_step(g,SOUTH)
					var/turf/found_southwest = get_step(g,SOUTHWEST)
					var/turf/found_northwest = get_step(g,NORTHWEST)
					var/turf/found_northeast = get_step(g,NORTHEAST)
					var/turf/found_southeast = get_step(g,SOUTHEAST)

					//If we don't find any stone_roof instances nearby, add to rock_floors. Otherwise, set the found_ vars to null
					if(istype(found_west,/turf/stone_roof) == 0) rock_floors += 1
					else found_west = null
					if(istype(found_east,/turf/stone_roof) == 0) rock_floors += 1
					else found_east = null
					if(istype(found_north,/turf/stone_roof) == 0) rock_floors += 1
					else found_north = null
					if(istype(found_south,/turf/stone_roof) == 0) rock_floors += 1
					else found_south = null
					if(istype(found_southwest,/turf/stone_roof) == 0) rock_floors += 1
					else found_southwest = null
					if(istype(found_southeast,/turf/stone_roof) == 0) rock_floors += 1
					else found_southeast = null
					if(istype(found_northwest,/turf/stone_roof) == 0) rock_floors += 1
					else found_northwest = null
					if(istype(found_northeast,/turf/stone_roof) == 0) rock_floors += 1
					else found_northeast = null

					if(found_south && found_east == null && found_west == null)
						var/turf/t = locate(g.x,g.y-1,g.z)
						if(t.glow)
							t.glow.destroy()
							t.glow = null
						for(var/obj/map/cliffs/c in g)
							c.destroy()
						for(var/obj/map/cliffs/c in t)
							c.destroy()
						var/obj/map/cliffs/c5/c_5 = new
						c_5.loc = g
						var/obj/map/cliffs/c2/c_2 = new
						c_2.loc = t
					if(found_north  && found_east == null && found_west == null)
						for(var/obj/map/cliffs/c in g)
							c.destroy()
						var/obj/map/cliffs/c10/c_10 = new
						c_10.loc = g
					if(found_east && found_north == null && found_south == null && found_west == null)
						for(var/obj/map/cliffs/c in g)
							c.destroy()
						var/obj/map/cliffs/c8/c_8 = new
						c_8.loc = g
					if(found_west && found_north == null && found_south == null && found_east == null)
						for(var/obj/map/cliffs/c in g)
							c.destroy()
						var/obj/map/cliffs/c7/c_7 = new
						c_7.loc = g
					if(found_east && found_northeast && found_north && found_south == null && found_west == null && found_southwest == null)
						for(var/obj/map/cliffs/c in g)
							c.destroy()
						var/obj/map/cliffs/c11/c_11 = new
						c_11.loc = g
					if(found_west && found_northwest && found_north && found_south == null && found_east == null && found_southeast == null)
						for(var/obj/map/cliffs/c in g)
							c.destroy()
						var/obj/map/cliffs/c9/c_9 = new
						c_9.loc = g
					if(found_south && found_southwest && found_west && found_east == null && found_north == null && found_northeast == null)
						var/turf/t = locate(g.x,g.y-1,g.z)
						if(t.glow)
							t.glow.destroy()
							t.glow = null
						for(var/obj/map/cliffs/c in t)
							c.destroy()
						for(var/obj/map/cliffs/c in g)
							c.destroy()
						var/obj/map/cliffs/c4/c_4 = new
						c_4.loc = g
						var/obj/map/cliffs/c1/c_1 = new
						c_1.loc = t
					if(found_south && found_southeast && found_east && found_west == null && found_north == null && found_northwest == null)
						var/turf/t = locate(g.x,g.y-1,g.z)
						if(t.glow)
							t.glow.destroy()
							t.glow = null
						for(var/obj/map/cliffs/c in t)
							c.destroy()
						for(var/obj/map/cliffs/c in g)
							c.destroy()
						var/obj/map/cliffs/c6/c_6 = new
						c_6.loc = g
						var/obj/map/cliffs/c3/c_3 = new
						c_3.loc = t
					if(found_southwest && found_north == null && found_east == null && found_west == null && found_south == null)
						for(var/obj/map/cliffs/c in g)
							c.destroy()
						var/obj/map/cliffs/c16/c_16 = new
						c_16.loc = g
					if(found_southeast && found_north == null && found_east == null && found_west == null && found_south == null)
						for(var/obj/map/cliffs/c in g)
							c.destroy()
						var/obj/map/cliffs/c13/c_13 = new
						c_13.loc = g
					if(found_northeast && found_north == null && found_east == null && found_west == null && found_south == null)
						for(var/obj/map/cliffs/c in g)
							c.destroy()
						var/obj/map/cliffs/c14/c_14 = new
						c_14.loc = g
					if(found_northwest && found_north == null && found_east == null && found_west == null && found_south == null)
						for(var/obj/map/cliffs/c in g)
							c.destroy()
						var/obj/map/cliffs/c15/c_15 = new
						c_15.loc = g
					if(n >= 500) sleep(0.1)
				//	if(n == 0 ) break
		edges_afterlife()
			set background = 1
			var/n = 0
			for(var/turf/g in block(locate(1,1,2),locate(480,480,2)))
				if(g.type != /turf/void/)
					n += 1
					var/void_sides = 0
					var/turf/found_west = get_step(g,WEST)
					var/turf/found_east = get_step(g,EAST)
					var/turf/found_north = get_step(g,NORTH)
					var/turf/found_south = get_step(g,SOUTH)
					var/turf/found_southwest = get_step(g,SOUTHWEST)
					var/turf/found_northwest = get_step(g,NORTHWEST)
					var/turf/found_northeast = get_step(g,NORTHEAST)
					var/turf/found_southeast = get_step(g,SOUTHEAST)

					if(istype(found_west,/turf/void)) void_sides += 1
					else found_west = null
					if(istype(found_east,/turf/void)) void_sides += 1
					else found_east = null
					if(istype(found_north,/turf/void)) void_sides += 1
					else found_north = null
					if(istype(found_south,/turf/void)) void_sides += 1
					else found_south = null
					if(istype(found_southwest,/turf/void)) void_sides += 1
					else found_southwest = null
					if(istype(found_southeast,/turf/void)) void_sides += 1
					else found_southeast = null
					if(istype(found_northwest,/turf/void)) void_sides += 1
					else found_northwest = null
					if(istype(found_northeast,/turf/void)) void_sides += 1
					else found_northeast = null

					if(found_north && found_east == null && found_west == null)
						var/obj/map/cliffs/c10/c_10 = new
						c_10.loc = g
						c_10.density_factor = 0;
						c_10.name = "Void Cliff Top"
					if(found_north && found_northeast == null)
						var/obj/map/cliffs/c15/c_15 = new
						c_15.loc = locate(g.x+1,g.y,g.z)
						c_15.density_factor = 0;
						c_15.name = "Void Cliff Top"
					if(found_north && found_northwest == null)
						var/obj/map/cliffs/c14/c_14 = new
						c_14.loc = locate(g.x-1,g.y,g.z)
						c_14.density_factor = 0;
						c_14.name = "Void Cliff Top"
					if(found_west && found_south == null && found_north == null)
						var/obj/map/cliffs/c7/c_7 = new
						c_7.loc = g
						c_7.density_factor = 0;
						c_7.name = "Void Cliff Top"
					if(found_east && found_south == null && found_north == null)
						var/obj/map/cliffs/c8/c_8 = new
						c_8.loc = g
						c_8.density_factor = 0;
						c_8.name = "Void Cliff Top"
					if(found_east && found_south == null && found_north == null && found_northeast == null)
						var/obj/map/cliffs/c13/c_13 = new
						c_13.loc = locate(g.x,g.y+1,g.z)
						c_13.density_factor = 0;
						c_13.name = "Void Cliff Top"
					if(found_west && found_south == null && found_north == null && found_northwest == null)
						var/obj/map/cliffs/c16/c_16 = new
						c_16.loc = locate(g.x,g.y+1,g.z)
						c_16.density_factor = 0;
						c_16.name = "Void Cliff Top"
					if(found_south && found_east == null && found_west == null)
						var/obj/map/cliffs/c5/c_5 = new
						c_5.loc = g
						c_5.density_factor = 0;
						c_5.name = "Void Cliff"
						var/obj/map/cliffs/c2/c_2 = new
						c_2.loc = locate(g.x,g.y-1,g.z)
						c_2.density_factor = 0;
						c_2.name = "Void Cliff"
					if(found_south && found_east == null && found_west)
						var/obj/map/cliffs/c4/c_4 = new
						c_4.loc = g
						c_4.density_factor = 0;
						c_4.name = "Void Cliff"
						var/obj/map/cliffs/c1/c_1 = new
						c_1.loc = locate(g.x,g.y-1,g.z)
						c_1.density_factor = 0;
						c_1.name = "Void Cliff"
						var/obj/map/cliffs/c16/c_16 = new
						c_16.loc = locate(g.x,g.y+1,g.z)
						c_16.density_factor = 0;
						c_16.name = "Void Cliff"
					if(found_south && found_east && found_west == null)
						var/obj/map/cliffs/c6/c_6 = new
						c_6.loc = g
						c_6.density_factor = 0;
						c_6.name = "Void Cliff"
						var/obj/map/cliffs/c3/c_3 = new
						c_3.loc = locate(g.x,g.y-1,g.z)
						c_3.density_factor = 0;
						c_3.name = "Void Cliff"
						var/obj/map/cliffs/c13/c_13 = new
						c_13.loc = locate(g.x,g.y+1,g.z)
						c_13.density_factor = 0;
						c_13.name = "Void Cliff"
					if(found_south == null && found_east == null && found_west && found_north)
						var/obj/map/cliffs/c9/c_9 = new
						c_9.loc = g
						c_9.density_factor = 0;
						c_9.name = "Void Cliff Top"
					if(found_south == null && found_east && found_west == null && found_north)
						var/obj/map/cliffs/c11/c_11 = new
						c_11.loc = g
						c_11.density_factor = 0;
						c_11.name = "Void Cliff Top"
					if(found_south == null && found_east == null && found_west && found_north && found_northeast == null)
						var/obj/map/cliffs/c15/c_15 = new
						c_15.loc = locate(g.x+1,g.y,g.z)
						c_15.density_factor = 0;
						c_15.name = "Void Cliff Top"
					if(n >= 500)
						sleep(0.1)
						n = 0;
					if(n == 0 ) break
		create_lakes()
			/*
			for(var/turf/grass/g in world)
				for(var/turf/water/water_lake/l in range(2,g))
					new /turf/dirts/dirt5 (g)
			*/
			var/n = 0
			for(var/turf/g in block(locate(1,1,1),locate(480,480,2)))
				if(istype(g,/turf/grass) || istype(g,/turf/grass_crystal))
					n += 1
					var/water_sides = 0
					var/turf/found_west = get_step(g,WEST)
					var/turf/found_east = get_step(g,EAST)
					var/turf/found_north = get_step(g,NORTH)
					var/turf/found_south = get_step(g,SOUTH)
					var/turf/found_southwest = get_step(g,SOUTHWEST)
					var/turf/found_northwest = get_step(g,NORTHWEST)
					var/turf/found_northeast = get_step(g,NORTHEAST)
					var/turf/found_southeast = get_step(g,SOUTHEAST)
					if(istype(found_west,/turf/water/water_lake) || istype(found_west,/turf/water/water_river) || istype(found_west,/turf/water/water5)) water_sides += 1
					else found_west = null
					if(istype(found_east,/turf/water/water_lake) || istype(found_east,/turf/water/water_river) || istype(found_east,/turf/water/water5)) water_sides += 1
					else found_east = null
					if(istype(found_north,/turf/water/water_lake) || istype(found_north,/turf/water/water_river) || istype(found_north,/turf/water/water5)) water_sides += 1
					else found_north = null
					if(istype(found_south,/turf/water/water_lake) || istype(found_south,/turf/water/water_river) || istype(found_south,/turf/water/water5)) water_sides += 1
					else found_south = null
					if(istype(found_southwest,/turf/water/water_lake) || istype(found_southwest,/turf/water/water_river) || istype(found_southwest,/turf/water/water5)) water_sides += 1
					else found_southwest = null
					if(istype(found_southeast,/turf/water/water_lake) || istype(found_southeast,/turf/water/water_river) || istype(found_southeast,/turf/water/water5)) water_sides += 1
					else found_southeast = null
					if(istype(found_northwest,/turf/water/water_lake) || istype(found_northwest,/turf/water/water_river) || istype(found_northwest,/turf/water/water5)) water_sides += 1
					else found_northwest = null
					if(istype(found_northeast,/turf/water/water_lake) || istype(found_northeast,/turf/water/water_river) || istype(found_northeast,/turf/water/water5)) water_sides += 1
					else found_northeast = null
					if(found_west && found_south)
						g.overlays += /turf/water/water13
						found_west = null
						found_east = null
						found_south = null
						found_north = null
						found_southwest = null
						found_northwest = null
						found_northeast = null
						found_southeast = null
					if(found_west && found_north)
						g.overlays += /turf/water/water11
						found_west = null
						found_east = null
						found_south = null
						found_north = null
						found_southwest = null
						found_northwest = null
						found_northeast = null
						found_southeast = null
					if(found_east && found_north)
						g.overlays += /turf/water/water10
						found_west = null
						found_east = null
						found_south = null
						found_north = null
						found_southwest = null
						found_northwest = null
						found_northeast = null
						found_southeast = null
					if(found_east && found_south)
						g.overlays += /turf/water/water12
						found_west = null
						found_east = null
						found_south = null
						found_north = null
						found_southwest = null
						found_northwest = null
						found_northeast = null
						found_southeast = null
					if(found_south) g.overlays += /turf/water/water8
					if(found_north) g.overlays += /turf/water/water2
					if(found_west) g.overlays += /turf/water/water6
					if(found_east) g.overlays += /turf/water/water4
					if(water_sides == 1) if(found_southwest) g.overlays += /turf/water/water9
					if(water_sides == 1) if(found_southeast) g.overlays += /turf/water/water7
					if(water_sides == 1) if(found_northwest) g.overlays += /turf/water/water3
					if(water_sides == 1) if(found_northeast) g.overlays += /turf/water/water1
					if(n >= 500)
						sleep(0.1)
						n = 0;
					if(n == 0 ) break
		create_grass_dirt_transition(var/s_x = 1,var/s_y = 1,var/e_x = 480,var/e_y = 480,var/s_z = 1,var/e_z = 5,var/special = 0)
			set background = 1
			var/n = 0
			for(var/turf/grass/g in block(locate(s_x,s_y,s_z),locate(e_x,e_y,e_z)))
				var/i = 'dirt.dmi'
				/*
				if(g.z == 5)
					i = 'dirt_psionica.dmi'
					g.icon = 'dirt_psionica.dmi'
					g.icon_state = "grass full"
					//g.filters += filter(type="bloom", threshold=rgb(0,0,0), size = 6,offset=1,alpha = 175)
				*/
				if(g.icon == 'grass_yukopian.dmi' || g.icon == 'dirt_yukopian.dmi') i = 'dirt_yukopian.dmi'
				n += 1
				if(i)
					var/turf/south = get_step(g,SOUTH)
					var/turf/north = get_step(g,NORTH)
					var/turf/east = get_step(g,EAST)
					var/turf/west = get_step(g,WEST)

					var/turf/southwest = get_step(g,SOUTHWEST)
					var/turf/northwest = get_step(g,NORTHWEST)
					var/turf/southeast = get_step(g,SOUTHEAST)
					var/turf/northeast = get_step(g,NORTHEAST)

					if(!istype(north,/turf/dirts)) north = null
					if(!istype(south,/turf/dirts)) south = null
					if(!istype(east,/turf/dirts)) east = null
					if(!istype(west,/turf/dirts)) west = null

					if(!istype(northwest,/turf/dirts)) northwest = null
					if(!istype(northeast,/turf/dirts)) northeast = null
					if(!istype(southwest,/turf/dirts)) southwest = null
					if(!istype(southeast,/turf/dirts)) southeast = null

					//This took way too long, and is complicated. Don't be a dummy and change it badly.
					if(west)// && southwest && northwest)
						g.icon = i
						g.icon_state = "d9"
					if(east)// && southeast && northeast)
						g.icon = i
						g.icon_state = "d4"
					if(north)
						g.icon = i
						g.icon_state = "d6"
					if(south)
						g.icon = i
						g.icon_state = "d1"
					if(northeast && southwest)
						g.icon = i
						g.icon_state = "d21"
					if(northwest && southeast)
						g.icon = i
						g.icon_state = "d22"
					if(!north && !south && !west && northwest && southwest)
						g.icon = i
						g.icon_state = "d23"
					if(!north && !south && !east && northeast && southeast)
						g.icon = i
						g.icon_state = "d24"
					if(!east && !west && northeast && northwest && !north)
						g.icon = i
						g.icon_state = "d25"
					if(!east && !west && southeast && southwest && !south)
						g.icon = i
						g.icon_state = "d31"
					if(west && southwest && northwest && northeast)
						g.icon = i
						g.icon_state = "d26"
					if(east && !west && !south && !north && northwest && !southwest)
						g.icon = i
						g.icon_state = "d30"
					if(!east && !west && southeast && northwest && !north && !south && northeast)
						g.icon = i
						g.icon_state = "d32"
					if(!east && !west && !south && southeast && north && !southwest)
						g.icon = i
						g.icon_state = "d29"
					if(!east && !west && northwest && southwest && south && southeast)
						g.icon = i
						g.icon_state = "d27"
					if(!west && !east && northeast && southeast && south && !north)
						g.icon = i
						g.icon_state = "d28"
					if(!east && !west && !south && southeast && northeast && north && northwest)
						g.icon = i
						g.icon_state = "d29"
					if(east && !west && !south && southeast && northeast && !north && northwest)
						g.icon = i
						g.icon_state = "d30"
					if(!east && !west && northwest && !southwest && south && southeast && !northeast && !north && !southwest)
						g.icon = i
						g.icon_state = "d27"
					if(!east && !west && !south && southeast && !northeast && north && northwest && !southwest)
						g.icon = i
						g.icon_state = "d29"
					if(northeast && !southwest && !west && !east && !north && !south && !southeast && !northwest)
						g.icon = i
						g.icon_state = "d12"
					if(southeast && !southwest && !west && !east && !north && !south && !northeast && !northwest)
						g.icon = i
						g.icon_state = "d3"
					if(northwest && !southwest && !west && !east && !north && !south && !northeast && !southeast)
						g.icon = i
						g.icon_state = "d8"
					if(southwest && !northwest && !west && !east && !north && !south && !northeast && !southeast)
						g.icon = i
						g.icon_state = "d11"
					if(north && northwest && west)
						g.icon = i
						g.icon_state = "d7"
					if(south && southwest && west)
						g.icon = i
						g.icon_state = "d10"
					if(!west && !north && east && south)
						g.icon = i
						g.icon_state = "d36"
					if(north && northeast && east)
						g.icon = i
						g.icon_state = "d5"
					if(east && west && !south && !north)
						g.icon = i
						g.icon_state = "d35"
					if(!east && !west && south && north)
						g.icon = i
						g.icon_state = "d34"
					if(north && west && east && south)
						g.icon = i
						g.icon_state = "d13"
					if(north && west && east && !south)
						g.icon = i
						g.icon_state = "d15"
					if(!north && west && east && south)
						g.icon = i
						g.icon_state = "d14"
					if(north && west && !east && south)
						g.icon = i
						g.icon_state = "d16"
					if(north && !west && east && south)
						g.icon = i
						g.icon_state = "d18"
					if(east && !west && southwest && !south && north && northeast)
						g.icon = i
						g.icon_state = "d38"
					if(!east && west && !southeast && !south && !north && northeast)
						g.icon = i
						g.icon_state = "d42"
					if(!east && west && southeast && !south && !north && !northeast)
						g.icon = i
						g.icon_state = "d43"
					if(!east && west && southwest && south && !north && northeast && !northwest)
						g.icon = i
						g.icon_state = "d39"
					if(!east && !west && !southeast && southwest && !south && north && northeast)
						g.icon = i
						g.icon_state = "d40"
					if(east && !west && southwest && !south && !north && northeast && !northwest)
						g.icon = i
						g.icon_state = "d41"
					if(!east && west && southeast && southwest && !south && north && !northeast && northwest)
						g.icon = i
						g.icon_state = "d33"
					if(!east && west && southeast && !southwest && !south && north && northeast && northwest)
						g.icon = i
						g.icon_state = "d33"
					if(!east && west && southeast && !southwest && !south && north && !northeast && northwest)
						g.icon = i
						g.icon_state = "d33"
					if(east && !west && southeast && !southwest && south && !north && !northeast && northwest)
						g.icon = i
						g.icon_state = "d36"
					if(east && !west && southeast && !southwest && south && !north && northeast && northwest)
						g.icon = i
						g.icon_state = "d36"
					if(east && !west && southeast && southwest && south && !north && !northeast && northwest)
						g.icon = i
						g.icon_state = "d36"
					if(east && !west && southeast && southwest && !south && !north && northeast && !northwest)
						g.icon = i
						g.icon_state = "d37"
					if(!east && west && !southeast && southwest && !south && !north && northeast && northwest)
						g.icon = i
						g.icon_state = "d43"
					if(south && southeast && east && !northwest && !north && !west)
						g.icon = i
						g.icon_state = "d2"
					if(special && !north && !west && !east && !south && !southwest && !southeast && !northeast && !northwest)
						if(g.icon == 'dirt_yukopian.dmi' || g.icon == 'grass_yukopian.dmi') g.icon = 'grass_yukopian.dmi'
						else g.icon = initial(g.icon)
						g.icon_state = initial(g.icon_state)
				if(n >= 500)
					sleep(0.1)
					n = 0;
				//if(n == 0 ) break
		create_water_edges()
			set background = 1
			var/n = 0
			//Do the normal grass first
			for(var/turf/grass/g in block(locate(1,1,1),locate(400,400,1)))
				var/found_cliff_already = 0
				for(var/obj/map/cliffs/c in g)
					found_cliff_already = 1
					break
				if(found_cliff_already == 0)
					n += 1
					var/turf/south = get_step(g,SOUTH)
					var/turf/north = get_step(g,NORTH)
					var/turf/east = get_step(g,EAST)
					var/turf/west = get_step(g,WEST)

					var/turf/southwest = get_step(g,SOUTHWEST)
					var/turf/northwest = get_step(g,NORTHWEST)
					var/turf/southeast = get_step(g,SOUTHEAST)
					var/turf/northeast = get_step(g,NORTHEAST)

					if(istype(south,/turf/water) && !istype(east,/turf/water) && !istype(west,/turf/water))
						g.icon = 'edges_water.dmi'
						g.icon_state = "2"
						g.underlays += /turf/water/water5
					if(istype(north,/turf/water) && !istype(east,/turf/water) && !istype(west,/turf/water))
						g.icon = 'edges_water.dmi'
						g.icon_state = "12"
						g.underlays += /turf/water/water5
					if(istype(east,/turf/water))
						g.icon = 'edges_water.dmi'
						g.icon_state = "7"
						g.underlays += /turf/water/water5
					if(istype(west,/turf/water))
						g.icon = 'edges_water.dmi'
						g.icon_state = "6"
						g.underlays += /turf/water/water5
					if(istype(east,/turf/water) && istype(south,/turf/water))
						g.icon = 'edges_water.dmi'
						g.icon_state = "3"
						g.underlays += /turf/water/water5
					if(istype(west,/turf/water) && istype(south,/turf/water))
						g.icon = 'edges_water.dmi'
						g.icon_state = "1"
						g.underlays += /turf/water/water5
					if(istype(east,/turf/water) && istype(north,/turf/water))
						g.icon = 'edges_water.dmi'
						g.icon_state = "11"
						g.underlays += /turf/water/water5
					if(istype(west,/turf/water) && istype(north,/turf/water))
						g.icon = 'edges_water.dmi'
						g.icon_state = "8"
						g.underlays += /turf/water/water5
					if(istype(southeast,/turf/water) && !istype(east,/turf/water) && !istype(south,/turf/water) && !istype(west,/turf/water) && !istype(north,/turf/water))
						g.icon = 'edges_water.dmi'
						g.icon_state = "5"
						g.underlays += /turf/water/water5
					if(istype(southwest,/turf/water) && !istype(east,/turf/water) && !istype(south,/turf/water) && !istype(west,/turf/water) && !istype(north,/turf/water))
						g.icon = 'edges_water.dmi'
						g.icon_state = "4"
						g.underlays += /turf/water/water5
					if(istype(northwest,/turf/water) && !istype(east,/turf/water) && !istype(south,/turf/water) && !istype(west,/turf/water) && !istype(north,/turf/water))
						g.icon = 'edges_water.dmi'
						g.icon_state = "9"
						g.underlays += /turf/water/water5
					if(istype(northeast,/turf/water) && !istype(east,/turf/water) && !istype(south,/turf/water) && !istype(west,/turf/water) && !istype(north,/turf/water))
						g.icon = 'edges_water.dmi'
						g.icon_state = "10"
						g.underlays += /turf/water/water5
				if(n >= 500)
					sleep(0.1)
					n = 0;

		create_beaches(var/s_x = 1,var/s_y = 1,var/e_x = 500,var/e_y = 500)
			set background = 1
			var/n = 0
			for(var/turf/sands/sand5/s in block(locate(s_x,s_y,1),locate(e_x,e_y,1)))
				//Make the desert area on the map hot.
				if(s.x >= 300 && s.y <= 200 && s.z == 1)
					s.tmp_dmg = 1
				n += 1
				var/turf/south = get_step(s,SOUTH)
				var/turf/north = get_step(s,NORTH)
				var/turf/east = get_step(s,EAST)
				var/turf/west = get_step(s,WEST)

				var/turf/southwest = get_step(s,SOUTHWEST)
				var/turf/northwest = get_step(s,NORTHWEST)
				var/turf/southeast = get_step(s,SOUTHEAST)
				var/turf/northeast = get_step(s,NORTHEAST)

				//This took way too long, and is complicated. Don't be a dummy and change it badly.
				if(istype(north,/turf/grass) && istype(northeast,/turf/grass) && istype(northwest,/turf/grass))// && !istype(east,/turf/grass) && !istype(west,/turf/grass))
					if(north.icon == 'terrain.dmi') north.icon = 'edges_grass.dmi'
					else if(north.icon == 'grass_yukopian.dmi') north.icon = 'edges_grass_yukopian.dmi'
					north.icon_state = "grass desert 1"
				if(istype(south,/turf/grass) && istype(southeast,/turf/grass) && istype(southwest,/turf/grass))// && !istype(east,/turf/grass) && !istype(west,/turf/grass))
					if(south.icon == 'terrain.dmi') south.icon = 'edges_grass.dmi'
					else if(south.icon == 'grass_yukopian.dmi') south.icon = 'edges_grass_yukopian.dmi'
					south.icon_state = "grass desert 6"
				if(istype(west,/turf/grass) && istype(southwest,/turf/grass) && istype(northwest,/turf/grass))
					if(west.icon == 'terrain.dmi') west.icon = 'edges_grass.dmi'
					else if(west.icon == 'grass_yukopian.dmi') west.icon = 'edges_grass_yukopian.dmi'
					west.icon_state = "grass desert 4"
				if(istype(east,/turf/grass) && istype(southeast,/turf/grass) && istype(northeast,/turf/grass))
					if(east.icon == 'terrain.dmi') east.icon = 'edges_grass.dmi'
					else if(east.icon == 'grass_yukopian.dmi') east.icon = 'edges_grass_yukopian.dmi'
					east.icon_state = "grass desert 9"
				if(!istype(northeast,/turf/grass) && istype(north,/turf/grass) && istype(northwest,/turf/grass))
					if(north.icon == 'terrain.dmi') north.icon = 'edges_grass.dmi'
					else if(north.icon == 'grass_yukopian.dmi') north.icon = 'edges_grass_yukopian.dmi'
					north.icon_state = "grass desert 2"
				if(!istype(northwest,/turf/grass) && istype(north,/turf/grass) && istype(northeast,/turf/grass))
					if(north.icon == 'terrain.dmi') north.icon = 'edges_grass.dmi'
					else if(north.icon == 'grass_yukopian.dmi') north.icon = 'edges_grass_yukopian.dmi'
					north.icon_state = "grass desert 10"
				if(istype(southwest,/turf/grass) && istype(south,/turf/grass) && !istype(southeast,/turf/grass))
					if(south.icon == 'terrain.dmi') south.icon = 'edges_grass.dmi'
					else if(south.icon == 'grass_yukopian.dmi') south.icon = 'edges_grass_yukopian.dmi'
					south.icon_state = "grass desert 5"
				if(istype(southeast,/turf/grass) && istype(south,/turf/grass) && !istype(southwest,/turf/grass))
					if(south.icon == 'terrain.dmi') south.icon = 'edges_grass.dmi'
					else if(south.icon == 'grass_yukopian.dmi') south.icon = 'edges_grass_yukopian.dmi'
					south.icon_state = "grass desert 7"
				if(istype(west,/turf/grass) && istype(northwest,/turf/grass))
					if(northwest.icon == 'terrain.dmi') northwest.icon = 'edges_grass.dmi'
					else if(northwest.icon == 'grass_yukopian.dmi') northwest.icon = 'edges_grass_yukopian.dmi'
					northwest.icon_state = "grass desert 3"
				if(istype(east,/turf/grass) && istype(northeast,/turf/grass))
					if(northeast.icon == 'terrain.dmi') northeast.icon = 'edges_grass.dmi'
					else if(northeast.icon == 'grass_yukopian.dmi') northeast.icon = 'edges_grass_yukopian.dmi'
					northeast.icon_state = "grass desert 11"
				if(istype(southwest,/turf/grass) && !istype(north,/turf/grass) && istype(west,/turf/grass) && istype(south,/turf/grass) && !istype(east,/turf/grass))
					if(southwest.icon == 'terrain.dmi') southwest.icon = 'edges_grass.dmi'
					else if(southwest.icon == 'grass_yukopian.dmi') southwest.icon = 'edges_grass_yukopian.dmi'
					southwest.icon_state = "grass desert 12"
				if(istype(southeast,/turf/grass) && !istype(north,/turf/grass) && istype(east,/turf/grass) && istype(south,/turf/grass) && !istype(west,/turf/grass))
					if(southeast.icon == 'terrain.dmi') southeast.icon = 'edges_grass.dmi'
					else if(southeast.icon == 'grass_yukopian.dmi') southeast.icon = 'edges_grass_yukopian.dmi'
					southeast.icon_state = "grass desert 8"

				if(istype(south,/turf/water) && !istype(east,/turf/water) && !istype(west,/turf/water))
					s.icon = 'beach_edges.dmi'
					s.icon_state = "2"
					s.underlays += /turf/water/water5
				if(istype(north,/turf/water) && !istype(east,/turf/water) && !istype(west,/turf/water))
					s.icon = 'beach_edges.dmi'
					s.icon_state = "12"
					s.underlays += /turf/water/water5
				if(istype(east,/turf/water))
					s.icon = 'beach_edges.dmi'
					s.icon_state = "7"
					s.underlays += /turf/water/water5
				if(istype(west,/turf/water))
					s.icon = 'beach_edges.dmi'
					s.icon_state = "6"
					s.underlays += /turf/water/water5
				if(istype(east,/turf/water) && istype(south,/turf/water))
					s.icon = 'beach_edges.dmi'
					s.icon_state = "3"
					s.underlays += /turf/water/water5
				if(istype(west,/turf/water) && istype(south,/turf/water))
					s.icon = 'beach_edges.dmi'
					s.icon_state = "1"
					s.underlays += /turf/water/water5
				if(istype(east,/turf/water) && istype(north,/turf/water))
					s.icon = 'beach_edges.dmi'
					s.icon_state = "11"
					s.underlays += /turf/water/water5
				if(istype(west,/turf/water) && istype(north,/turf/water))
					s.icon = 'beach_edges.dmi'
					s.icon_state = "8"
					s.underlays += /turf/water/water5
				if(istype(southeast,/turf/water) && !istype(east,/turf/water) && !istype(south,/turf/water) && !istype(west,/turf/water) && !istype(north,/turf/water))
					s.icon = 'beach_edges.dmi'
					s.icon_state = "5"
					s.underlays += /turf/water/water5
				if(istype(southwest,/turf/water) && !istype(east,/turf/water) && !istype(south,/turf/water) && !istype(west,/turf/water) && !istype(north,/turf/water))
					s.icon = 'beach_edges.dmi'
					s.icon_state = "4"
					s.underlays += /turf/water/water5
				if(istype(northwest,/turf/water) && !istype(east,/turf/water) && !istype(south,/turf/water) && !istype(west,/turf/water) && !istype(north,/turf/water))
					s.icon = 'beach_edges.dmi'
					s.icon_state = "9"
					s.underlays += /turf/water/water5
				if(istype(northeast,/turf/water) && !istype(east,/turf/water) && !istype(south,/turf/water) && !istype(west,/turf/water) && !istype(north,/turf/water))
					s.icon = 'beach_edges.dmi'
					s.icon_state = "10"
					s.underlays += /turf/water/water5
				if(n >= 100) sleep(0.1)

			//	if(n == 0 ) break
		create_dirt_sand_transition(var/s_x = 1,var/s_y = 1,var/e_x = 500,var/e_y = 500)
			set background = 1
			var/n = 0
			for(var/turf/dirts/d in block(locate(s_x,s_y,1),locate(e_x,e_y,1)))
				n += 1
				var/blocked = 0
				for(var/obj/map/cliffs/c in range(1,d))
					blocked = 1
					break
				if(blocked == 0)
					var/turf/south = get_step(d,SOUTH)
					var/turf/north = get_step(d,NORTH)
					var/turf/east = get_step(d,EAST)
					var/turf/west = get_step(d,WEST)

					var/turf/southwest = get_step(d,SOUTHWEST)
					var/turf/northwest = get_step(d,NORTHWEST)
					var/turf/southeast = get_step(d,SOUTHEAST)
					var/turf/northeast = get_step(d,NORTHEAST)

					if(istype(south,/turf/sands/) && !istype(east,/turf/water) && !istype(west,/turf/water))
						d.icon = 'edges_sand.dmi'
						d.icon_state = "2"
					if(istype(north,/turf/sands/) && !istype(east,/turf/water) && !istype(west,/turf/water))
						d.icon = 'edges_sand.dmi'
						d.icon_state = "12"
					if(istype(east,/turf/sands/))
						d.icon = 'edges_sand.dmi'
						d.icon_state = "7"
					if(istype(west,/turf/sands/))
						d.icon = 'edges_sand.dmi'
						d.icon_state = "6"
					if(istype(east,/turf/sands/) && istype(south,/turf/sands/))
						d.icon = 'edges_sand.dmi'
						d.icon_state = "3"
					if(istype(west,/turf/sands/) && istype(south,/turf/sands/))
						d.icon = 'edges_sand.dmi'
						d.icon_state = "1"
					if(istype(east,/turf/sands/) && istype(north,/turf/sands/))
						d.icon = 'edges_sand.dmi'
						d.icon_state = "11"
					if(istype(west,/turf/sands/) && istype(north,/turf/sands/))
						d.icon = 'edges_sand.dmi'
						d.icon_state = "8"
					if(istype(southeast,/turf/sands/) && !istype(east,/turf/sands/) && !istype(south,/turf/sands/) && !istype(west,/turf/sands/) && !istype(north,/turf/sands/))
						d.icon = 'edges_sand.dmi'
						d.icon_state = "5"
					if(istype(southwest,/turf/sands/) && !istype(east,/turf/sands/) && !istype(south,/turf/sands/) && !istype(west,/turf/sands/) && !istype(north,/turf/sands/))
						d.icon = 'edges_sand.dmi'
						d.icon_state = "4"
					if(istype(northwest,/turf/sands/) && !istype(east,/turf/sands/) && !istype(south,/turf/sands/) && !istype(west,/turf/sands/) && !istype(north,/turf/sands/))
						d.icon = 'edges_sand.dmi'
						d.icon_state = "9"
					if(istype(northeast,/turf/sands/) && !istype(east,/turf/sands/) && !istype(south,/turf/sands/) && !istype(west,/turf/sands/) && !istype(north,/turf/sands/))
						d.icon = 'edges_sand.dmi'
						d.icon_state = "10"
				if(n >= 100) sleep(0.1)
		create_ash_cooled_lava_transition(var/s_x = 1,var/s_y = 1,var/e_x = 500,var/e_y = 500)
			set background = 1
			var/n = 0
			for(var/turf/lava_cooled/d in block(locate(s_x,s_y,1),locate(e_x,e_y,12)))
				var/turf/south = get_step(d,SOUTH)
				var/turf/north = get_step(d,NORTH)
				var/turf/east = get_step(d,EAST)
				var/turf/west = get_step(d,WEST)

				var/turf/southwest = get_step(d,SOUTHWEST)
				var/turf/northwest = get_step(d,NORTHWEST)
				var/turf/southeast = get_step(d,SOUTHEAST)
				var/turf/northeast = get_step(d,NORTHEAST)

				if(istype(south,/turf/lava_cooling/) && !istype(east,/turf/lava_cooling) && !istype(west,/turf/lava_cooling))
					d.icon = 'edges_lava_cooled.dmi'
					d.icon_state = "2"
				if(istype(north,/turf/lava_cooling/) && !istype(east,/turf/lava_cooling) && !istype(west,/turf/lava_cooling))
					d.icon = 'edges_lava_cooled.dmi'
					d.icon_state = "12"
				if(istype(east,/turf/lava_cooling/))
					d.icon = 'edges_lava_cooled.dmi'
					d.icon_state = "7"
				if(istype(west,/turf/lava_cooling/))
					d.icon = 'edges_lava_cooled.dmi'
					d.icon_state = "6"
				if(istype(east,/turf/lava_cooling/) && istype(south,/turf/lava_cooling/))
					d.icon = 'edges_lava_cooled.dmi'
					d.icon_state = "3"
				if(istype(west,/turf/lava_cooling/) && istype(south,/turf/lava_cooling/))
					d.icon = 'edges_lava_cooled.dmi'
					d.icon_state = "1"
				if(istype(east,/turf/lava_cooling/) && istype(north,/turf/lava_cooling/))
					d.icon = 'edges_lava_cooled.dmi'
					d.icon_state = "11"
				if(istype(west,/turf/lava_cooling/) && istype(north,/turf/lava_cooling/))
					d.icon = 'edges_lava_cooled.dmi'
					d.icon_state = "8"
				if(istype(southeast,/turf/lava_cooling/) && !istype(east,/turf/lava_cooling/) && !istype(south,/turf/lava_cooling/) && !istype(west,/turf/lava_cooling/) && !istype(north,/turf/lava_cooling/))
					d.icon = 'edges_lava_cooled.dmi'
					d.icon_state = "5"
				if(istype(southwest,/turf/lava_cooling/) && !istype(east,/turf/lava_cooling/) && !istype(south,/turf/lava_cooling/) && !istype(west,/turf/lava_cooling/) && !istype(north,/turf/lava_cooling/))
					d.icon = 'edges_lava_cooled.dmi'
					d.icon_state = "4"
				if(istype(northwest,/turf/lava_cooling/) && !istype(east,/turf/lava_cooling/) && !istype(south,/turf/lava_cooling/) && !istype(west,/turf/lava_cooling/) && !istype(north,/turf/lava_cooling/))
					d.icon = 'edges_lava_cooled.dmi'
					d.icon_state = "9"
				if(istype(northeast,/turf/lava_cooling/) && !istype(east,/turf/lava_cooling/) && !istype(south,/turf/lava_cooling/) && !istype(west,/turf/lava_cooling/) && !istype(north,/turf/lava_cooling/))
					d.icon = 'edges_lava_cooled.dmi'
					d.icon_state = "10"
				if(n >= 500)
					sleep(0.1)
					n = 0;
				if(n == 0 ) break
		create_lava_transition(var/s_x = 1,var/s_y = 1,var/e_x = 480,var/e_y = 480)
			set background = 1
			var/n = 0
			for(var/turf/lava_cooling/d in block(locate(s_x,s_y,1),locate(e_x,e_y,12)))
				var/turf/south = get_step(d,SOUTH)
				var/turf/north = get_step(d,NORTH)
				var/turf/east = get_step(d,EAST)
				var/turf/west = get_step(d,WEST)

				var/turf/southwest = get_step(d,SOUTHWEST)
				var/turf/northwest = get_step(d,NORTHWEST)
				var/turf/southeast = get_step(d,SOUTHEAST)
				var/turf/northeast = get_step(d,NORTHEAST)

				if(istype(south,/turf/lava_static/) && !istype(east,/turf/lava_static) && !istype(west,/turf/lava_static))
					d.icon = 'edges_lava.dmi'
					d.icon_state = "2"
				if(istype(north,/turf/lava_static/) && !istype(east,/turf/lava_static) && !istype(west,/turf/lava_static))
					d.icon = 'edges_lava.dmi'
					d.icon_state = "12"
				if(istype(east,/turf/lava_static/))
					d.icon = 'edges_lava.dmi'
					d.icon_state = "7"
				if(istype(west,/turf/lava_static/))
					d.icon = 'edges_lava.dmi'
					d.icon_state = "6"
				if(istype(east,/turf/lava_static/) && istype(south,/turf/lava_static/))
					d.icon = 'edges_lava.dmi'
					d.icon_state = "3"
				if(istype(west,/turf/lava_static/) && istype(south,/turf/lava_static/))
					d.icon = 'edges_lava.dmi'
					d.icon_state = "1"
				if(istype(east,/turf/lava_static/) && istype(north,/turf/lava_static/))
					d.icon = 'edges_lava.dmi'
					d.icon_state = "11"
				if(istype(west,/turf/lava_static/) && istype(north,/turf/lava_static/))
					d.icon = 'edges_lava.dmi'
					d.icon_state = "8"
				if(istype(southeast,/turf/lava_static/) && !istype(east,/turf/lava_static/) && !istype(south,/turf/lava_static/) && !istype(west,/turf/lava_static/) && !istype(north,/turf/lava_static/))
					d.icon = 'edges_lava.dmi'
					d.icon_state = "5"
				if(istype(southwest,/turf/lava_static/) && !istype(east,/turf/lava_static/) && !istype(south,/turf/lava_static/) && !istype(west,/turf/lava_static/) && !istype(north,/turf/lava_static/))
					d.icon = 'edges_lava.dmi'
					d.icon_state = "4"
				if(istype(northwest,/turf/lava_static/) && !istype(east,/turf/lava_static/) && !istype(south,/turf/lava_static/) && !istype(west,/turf/lava_static/) && !istype(north,/turf/lava_static/))
					d.icon = 'edges_lava.dmi'
					d.icon_state = "9"
				if(istype(northeast,/turf/lava_static/) && !istype(east,/turf/lava_static/) && !istype(south,/turf/lava_static/) && !istype(west,/turf/lava_static/) && !istype(north,/turf/lava_static/))
					d.icon = 'edges_lava.dmi'
					d.icon_state = "10"
				if(n >= 100) sleep(0.1)

		create_snow_transition(var/s_x = 1,var/s_y = 1,var/e_x = 480,var/e_y = 480)
			set background = 1
			var/n = 0
			for(var/turf/snows/d in block(locate(s_x,s_y,1),locate(e_x,e_y,9)))
				var/turf/south = get_step(d,SOUTH)
				var/turf/north = get_step(d,NORTH)
				var/turf/east = get_step(d,EAST)
				var/turf/west = get_step(d,WEST)

				var/turf/southwest = get_step(d,SOUTHWEST)
				var/turf/northwest = get_step(d,NORTHWEST)
				var/turf/southeast = get_step(d,SOUTHEAST)
				var/turf/northeast = get_step(d,NORTHEAST)

				if(istype(south,/turf/dirts/) && !istype(east,/turf/dirts) && !istype(west,/turf/dirts))
					d.icon = 'edges_snow.dmi'
					d.icon_state = "2"
				if(istype(north,/turf/dirts/) && !istype(east,/turf/dirts) && !istype(west,/turf/dirts))
					d.icon = 'edges_snow.dmi'
					d.icon_state = "12"
				if(istype(east,/turf/dirts/))
					d.icon = 'edges_snow.dmi'
					d.icon_state = "7"
				if(istype(west,/turf/dirts/))
					d.icon = 'edges_snow.dmi'
					d.icon_state = "6"
				if(istype(east,/turf/dirts/) && istype(south,/turf/dirts/))
					d.icon = 'edges_snow.dmi'
					d.icon_state = "3"
				if(istype(west,/turf/dirts/) && istype(south,/turf/dirts/))
					d.icon = 'edges_snow.dmi'
					d.icon_state = "1"
				if(istype(east,/turf/dirts/) && istype(north,/turf/dirts/))
					d.icon = 'edges_snow.dmi'
					d.icon_state = "11"
				if(istype(west,/turf/dirts/) && istype(north,/turf/dirts/))
					d.icon = 'edges_snow.dmi'
					d.icon_state = "8"
				if(istype(southeast,/turf/dirts/) && !istype(east,/turf/dirts/) && !istype(south,/turf/dirts/) && !istype(west,/turf/dirts/) && !istype(north,/turf/dirts/))
					d.icon = 'edges_snow.dmi'
					d.icon_state = "5"
				if(istype(southwest,/turf/dirts/) && !istype(east,/turf/dirts/) && !istype(south,/turf/dirts/) && !istype(west,/turf/dirts/) && !istype(north,/turf/dirts/))
					d.icon = 'edges_snow.dmi'
					d.icon_state = "4"
				if(istype(northwest,/turf/dirts/) && !istype(east,/turf/dirts/) && !istype(south,/turf/dirts/) && !istype(west,/turf/dirts/) && !istype(north,/turf/dirts/))
					d.icon = 'edges_snow.dmi'
					d.icon_state = "9"
				if(istype(northeast,/turf/dirts/) && !istype(east,/turf/dirts/) && !istype(south,/turf/dirts/) && !istype(west,/turf/dirts/) && !istype(north,/turf/dirts/))
					d.icon = 'edges_snow.dmi'
					d.icon_state = "10"
				if(n >= 100) sleep(0.1)
			//	if(n == 0 ) break
		create_map_new()
			//Any blank spaces on the map are more often than not the filter for creating a 2+ tile thick border that is all white. So any white on the map is blank basically, inherently.
			set background = 1

			//Check if the maps were already created/saved
			var/found_maps = 0
			if(fexists("saves/world/world_maps.sav"))
				var/savefile/S = new("saves/world/world_maps.sav")
				if(S["MAPS"])
					S["MAPS"] >> maps
					S["MAP_BUTTONS"] >> map_locales
					S["MAP_MASTER"] >> map_master
					found_maps = 1
					maps_created = 1
					world.log<<"Found Maps."

			//If not, create fresh, new ones
			if(found_maps == 0)
				world.log<<"No maps found, creating maps and overlays......."
				//CREATE MAP OVERLAYS
				var/obj/hud/map/map_overlay/earth_build_overlay = new
				var/obj/hud/map/map_overlay/earth_u_build_overlay = new
		//		var/obj/hud/map/map_overlay/psi_build_overlay = new
				var/obj/hud/map/map_overlay/yuk_build_overlay = new
				var/obj/hud/map/map_overlay/yuk_u_build_overlay = new
				var/obj/hud/map/map_overlay/vegeta_build_overlay = new
				var/obj/hud/map/map_overlay/vegeta_u_build_overlay = new
				var/obj/hud/map/map_overlay/icer_build_overlay = new
				var/obj/hud/map/map_overlay/icer_u_build_overlay = new
			//	var/obj/hud/map/map_overlay/hell_build_overlay = new
			//	var/obj/hud/map/map_overlay/heaven_build_overlay = new
			//	var/obj/hud/map/map_overlay/darkrealm_build_overlay = new

				//Setup master map, for the player blips
				var/obj/master_map = new
				master_map.icon = 'map_large_blank.dmi'
				master_map.icon_state = "none"
				master_map.screen_loc = "CENTER-7,CENTER-7:-9"
				master_map.plane = 8
				master_map.layer = 10
				master_map.mouse_opacity = 0

				map_master = master_map

				//Create all the actual maps that go into client.screen and display the world map


				var/obj/hud/map/map_large/map_icer_underground = new
				map_icer_underground.name = "Icer Underground"
				map_icer_underground.z_level = 8
				icer_u_build_overlay.loc = map_icer_underground

				var/obj/hud/map/map_large/map_icer = new
				map_icer.name = "Icer"
				map_icer.z_level = 9
				icer_build_overlay.loc = map_icer


				var/obj/hud/map/map_large/map_vegeta = new
				map_vegeta.name = "Vegeta"
				map_vegeta.z_level = 10
				vegeta_build_overlay.loc = map_vegeta

				var/obj/hud/map/map_large/map_vegeta_underground = new
				map_vegeta_underground.name = "Vegeta Underground"
				map_vegeta_underground.z_level = 8
				vegeta_u_build_overlay.loc = map_vegeta_underground


				var/obj/hud/map/map_large/map_earth = new
				map_earth.name = "Earth"
				map_earth.z_level = 1
				earth_build_overlay.loc = map_earth



				var/obj/hud/map/map_large/map_earth_underground = new
				map_earth_underground.name = "Earth Underground"
				map_earth_underground.z_level = 3
				earth_u_build_overlay.loc = map_earth_underground

				var/obj/hud/map/map_large/map_yukopia = new
				map_yukopia.name = "Namek"
				map_yukopia.z_level = 4
				yuk_build_overlay.loc = map_yukopia

				var/obj/hud/map/map_large/map_yukopia_underground = new
				map_yukopia_underground.name = "Namek Underground"
				map_yukopia_underground.z_level = 7
				yuk_u_build_overlay.loc = map_yukopia_underground

				var/icon/icon_earth = icon(map_earth.icon)

				var/icon/icon_earth_underground = icon(map_earth_underground.icon)
				var/icon/icon_yukopia = icon(map_yukopia.icon)
				var/icon/icon_yukopia_underground = icon(map_yukopia_underground.icon)
				var/icon/icon_vegeta = icon(map_vegeta.icon)
				var/icon/icon_vegeta_underground = icon(map_vegeta_underground.icon)
				var/icon/icon_icer = icon(map_icer.icon)
				var/icon/icon_icer_underground = icon(map_icer_underground.icon)



				var/icon/icon_earth_overlay = icon(earth_build_overlay.icon)
				var/icon/icon_earth_underground_overlay = icon(earth_u_build_overlay.icon)
				var/icon/icon_yukopia_overlay = icon(yuk_build_overlay.icon)
				var/icon/icon_yukopia_underground_overlay = icon(yuk_u_build_overlay.icon)
				var/icon/icon_vegeta_overlay = icon(vegeta_build_overlay.icon)
				var/icon/icon_vegeta_underground_overlay = icon(vegeta_u_build_overlay.icon)
				var/icon/icon_icer_overlay = icon(icer_build_overlay.icon)
				var/icon/icon_icer_underground_overlay = icon(icer_u_build_overlay.icon)

				//Paint the world map
				for(var/turf/t in block(locate(1,1,1),locate(480,480,10)))
					if(istype(t,/turf/buildables/roofs/))
						if(t.z == 1) icon_earth_overlay.DrawBox(rgb(63,63,63),t.x,t.y,t.x,t.y)
						else if(t.z == 3) icon_earth_underground_overlay.DrawBox(rgb(63,63,63),t.x,t.y,t.x,t.y)
						else if(t.z == 4) icon_yukopia_overlay.DrawBox(rgb(63,63,63),t.x,t.y,t.x,t.y)
						else if(t.z == 7) icon_yukopia_underground_overlay.DrawBox(rgb(63,63,63),t.x,t.y,t.x,t.y)
						else if(t.z == 9) icon_icer_overlay.DrawBox(rgb(63,63,63),t.x,t.y,t.x,t.y)
						else if(t.z == 10) icon_vegeta_overlay.DrawBox(rgb(63,63,63),t.x,t.y,t.x,t.y)
					if(istype(t,/turf/buildables/walls/))
						if(t.z == 1) icon_earth_overlay.DrawBox(rgb(127,127,127),t.x,t.y,t.x,t.y)
						else if(t.z == 3) icon_earth_underground_overlay.DrawBox(rgb(127,127,127),t.x,t.y,t.x,t.y)
						else if(t.z == 4) icon_yukopia_overlay.DrawBox(rgb(127,127,127),t.x,t.y,t.x,t.y)
						else if(t.z == 7) icon_yukopia_underground_overlay.DrawBox(rgb(127,127,127),t.x,t.y,t.x,t.y)
						else if(t.z == 9) icon_icer_overlay.DrawBox(rgb(127,127,127),t.x,t.y,t.x,t.y)
						else if(t.z == 10) icon_vegeta_overlay.DrawBox(rgb(127,127,127),t.x,t.y,t.x,t.y)

					if(istype(t,/turf/buildables/floors/))
						if(t.z == 1) icon_earth_overlay.DrawBox(rgb(191,191,191),t.x,t.y,t.x,t.y)
						else if(t.z == 3) icon_earth_underground_overlay.DrawBox(rgb(191,191,191),t.x,t.y,t.x,t.y)
						else if(t.z == 4) icon_yukopia_overlay.DrawBox(rgb(191,191,191),t.x,t.y,t.x,t.y)
						else if(t.z == 7) icon_yukopia_underground_overlay.DrawBox(rgb(191,191,191),t.x,t.y,t.x,t.y)
						else if(t.z == 9) icon_icer_overlay.DrawBox(rgb(191,191,191),t.x,t.y,t.x,t.y)
						else if(t.z == 10) icon_vegeta_overlay.DrawBox(rgb(191,191,191),t.x,t.y,t.x,t.y)

					if(istype(t,/turf/grass) || t.og_type == /turf/grass)
						if(t.z == 1)
							icon_earth.DrawBox(rgb(10,139,53),t.x,t.y,t.x,t.y)

						else if(t.z == 3)
							icon_earth_underground.DrawBox(rgb(10,139,53),t.x,t.y,t.x,t.y)
						else if(t.z == 4)
							if(t.icon == 'grass_yukopian.dmi') icon_yukopia.DrawBox(rgb(0,153,255),t.x,t.y,t.x,t.y)
							else icon_yukopia.DrawBox(rgb(10,139,53),t.x,t.y,t.x,t.y)

						else if(t.z == 7)
							icon_yukopia_underground.DrawBox(rgb(10,139,53),t.x,t.y,t.x,t.y)


					else if(istype(t,/turf/grass_crystal) || t.og_type == /turf/grass)
						if(t.z == 1)
							icon_earth.DrawBox(rgb(153,255,255),t.x,t.y,t.x,t.y)

						else if(t.z == 3)
							icon_earth_underground.DrawBox(rgb(153,255,255),t.x,t.y,t.x,t.y)
						else if(t.z == 4)
							icon_yukopia.DrawBox(rgb(153,255,255),t.x,t.y,t.x,t.y)

						else if(t.z == 7)
							icon_yukopia_underground.DrawBox(rgb(10,139,53),t.x,t.y,t.x,t.y)



					else if(istype(t,/turf/water/) || t.og_type == /turf/grass)
						if(t.z == 1)
							icon_earth.DrawBox(rgb(91,110,225),t.x,t.y,t.x,t.y)
							for(var/turf/t2 in range(1,t))
								if(istype(t2,/turf/water/) == 0) icon_earth.DrawBox(rgb(0,0,0),t.x,t.y,t.x,t.y)

						else if(t.z == 3)
							icon_earth_underground.DrawBox(rgb(91,110,225),t.x,t.y,t.x,t.y)
							for(var/turf/t2 in range(1,t))
								if(istype(t2,/turf/water/) == 0) icon_earth_underground.DrawBox(rgb(0,0,0),t.x,t.y,t.x,t.y)
						else if(t.z == 4)
							icon_yukopia.DrawBox(rgb(91,110,225),t.x,t.y,t.x,t.y)
							for(var/turf/t2 in range(1,t))
								if(istype(t2,/turf/water/) == 0) icon_yukopia.DrawBox(rgb(0,0,0),t.x,t.y,t.x,t.y)

						else if(t.z == 9)
							icon_icer.DrawBox(rgb(91,110,225),t.x,t.y,t.x,t.y)
						else if(t.z == 7)
							icon_yukopia_underground.DrawBox(rgb(10,139,53),t.x,t.y,t.x,t.y)
						else if(t.z == 10)
							icon_vegeta.DrawBox(rgb(91,110,225),t.x,t.y,t.x,t.y)

					else if(istype(t,/turf/dirts/) || t.og_type == /turf/dirts/ || t.og_type == /turf/dirts/dirt7)
						if(t.z == 1)
							icon_earth.DrawBox(rgb(153,102,51),t.x,t.y,t.x,t.y)

						else if(t.z == 3)
							icon_earth_underground.DrawBox(rgb(153,102,51),t.x,t.y,t.x,t.y)
						else if(t.z == 4)
							icon_yukopia.DrawBox(rgb(153,102,51),t.x,t.y,t.x,t.y)

						else if(t.z == 7)
							icon_yukopia_underground.DrawBox(rgb(10,139,53),t.x,t.y,t.x,t.y)
						else if(t.z == 9)
							icon_icer.DrawBox(rgb(153,102,51),t.x,t.y,t.x,t.y)
						else if(t.z == 10)
							icon_vegeta.DrawBox(rgb(153,102,51),t.x,t.y,t.x,t.y)


					else if(istype(t,/turf/sands/) || t.og_type == /turf/sands/)
						if(t.z == 1)
							icon_earth.DrawBox(rgb(239,199,79),t.x,t.y,t.x,t.y)

						else if(t.z == 3)
							icon_earth_underground.DrawBox(rgb(239,199,79),t.x,t.y,t.x,t.y)
						else if(t.z == 4)
							icon_yukopia.DrawBox(rgb(239,199,79),t.x,t.y,t.x,t.y)

						else if(t.z == 7)
							icon_yukopia_underground.DrawBox(rgb(239,199,79),t.x,t.y,t.x,t.y)
						else if(t.z == 10)
							icon_vegeta.DrawBox(rgb(239,199,79),t.x,t.y,t.x,t.y)



					else if(istype(t,/turf/stone_roof/) || t.og_type == /turf/stone_roof/)
						if(t.z == 1)
							icon_earth.DrawBox(rgb(126,78,29),t.x,t.y,t.x,t.y)

						else if(t.z == 3)
							icon_earth_underground.DrawBox(rgb(126,78,29),t.x,t.y,t.x,t.y)
						else if(t.z == 4)
							icon_yukopia.DrawBox(rgb(126,78,29),t.x,t.y,t.x,t.y)

						else if(t.z == 7)
							icon_yukopia_underground.DrawBox(rgb(126,78,29),t.x,t.y,t.x,t.y)
						else if(t.z == 9)
							icon_icer.DrawBox(rgb(126,78,29),t.x,t.y,t.x,t.y)
						else if(t.z == 10)
							icon_vegeta.DrawBox(rgb(126,78,29),t.x,t.y,t.x,t.y)



					else if(istype(t,/turf/stone_floor/) || t.og_type == /turf/stone_floor/)
						if(t.z == 1)
							icon_earth.DrawBox(rgb(160,97,35),t.x,t.y,t.x,t.y)

						else if(t.z == 3)
							icon_earth_underground.DrawBox(rgb(160,97,35),t.x,t.y,t.x,t.y)
						else if(t.z == 4)
							icon_yukopia.DrawBox(rgb(160,97,35),t.x,t.y,t.x,t.y)

						else if(t.z == 7)
							icon_yukopia_underground.DrawBox(rgb(160,97,35),t.x,t.y,t.x,t.y)
					else if(istype(t,/turf/snows/) || t.og_type == /turf/snows/)
						if(t.z == 1)
							icon_earth.DrawBox(rgb(234,234,234),t.x,t.y,t.x,t.y)

						else if(t.z == 3)
							icon_earth_underground.DrawBox(rgb(234,234,234),t.x,t.y,t.x,t.y)
						else if(t.z == 4)
							icon_yukopia.DrawBox(rgb(234,234,234),t.x,t.y,t.x,t.y)

						else if(t.z == 7)
							icon_yukopia_underground.DrawBox(rgb(234,234,234),t.x,t.y,t.x,t.y)
						else if(t.z == 9)
							icon_icer.DrawBox(rgb(234,234,234),t.x,t.y,t.x,t.y)
					else if(istype(t,/turf/lava_cooled) || t.og_type == /turf/lava_cooled)
						if(t.z == 1)
							icon_earth.DrawBox(rgb(33,33,33),t.x,t.y,t.x,t.y)

						else if(t.z == 3)
							icon_earth_underground.DrawBox(rgb(33,33,33),t.x,t.y,t.x,t.y)
						else if(t.z == 4)
							icon_yukopia.DrawBox(rgb(33,33,33),t.x,t.y,t.x,t.y)

						else if(t.z == 7)
							icon_yukopia_underground.DrawBox(rgb(33,33,33),t.x,t.y,t.x,t.y)


					else if(istype(t,/turf/lava_cooling) || t.og_type == /turf/lava_cooling)
						if(t.z == 1)
							icon_earth.DrawBox(rgb(64,12,12),t.x,t.y,t.x,t.y)

						else if(t.z == 3)
							icon_earth_underground.DrawBox(rgb(64,12,12),t.x,t.y,t.x,t.y)
						else if(t.z == 4)
							icon_yukopia.DrawBox(rgb(64,12,12),t.x,t.y,t.x,t.y)

						else if(t.z == 7)
							icon_yukopia_underground.DrawBox(rgb(64,12,12),t.x,t.y,t.x,t.y)

					else if(istype(t,/turf/lava_static) || t.og_type == /turf/lava_static)
						if(t.z == 1)
							icon_earth.DrawBox(rgb(255,102,0),t.x,t.y,t.x,t.y)

						else if(t.z == 3)
							icon_earth_underground.DrawBox(rgb(255,102,0),t.x,t.y,t.x,t.y)
						else if(t.z == 4)
							icon_yukopia.DrawBox(rgb(255,102,0),t.x,t.y,t.x,t.y)

						else if(t.z == 7)
							icon_yukopia_underground.DrawBox(rgb(255,102,0),t.x,t.y,t.x,t.y)

					else if(istype(t,/turf/ice) || t.og_type == /turf/ice)
						if(t.z == 1)
							icon_earth.DrawBox(rgb(153,204,255),t.x,t.y,t.x,t.y)

						else if(t.z == 3)
							icon_earth_underground.DrawBox(rgb(153,204,255),t.x,t.y,t.x,t.y)
						else if(t.z == 4)
							icon_yukopia.DrawBox(rgb(153,204,255),t.x,t.y,t.x,t.y)

						else if(t.z == 7)
							icon_yukopia_underground.DrawBox(rgb(153,204,255),t.x,t.y,t.x,t.y)
					else if(istype(t,/turf/Terrain/Ice) )
						if(t.z == 9)
							icon_icer.DrawBox(rgb(153,204,255),t.x,t.y,t.x,t.y)
					else if(istype(t,/turf/cracked_ground) )
						if(t.z == 10)
							icon_vegeta.DrawBox(rgb(239,199,79),t.x,t.y,t.x,t.y)
					else if(istype(t,/turf/Terrain/tilesets1/grass5))
						if(t.z == 10)
							icon_vegeta.DrawBox(rgb(239,199,79),t.x,t.y,t.x,t.y)

					for(var/obj/map/cliffs/c in t)
						if(t.z == 1)
							icon_earth.DrawBox(rgb(102,51,0),t.x,t.y,t.x,t.y)

						else if(t.z == 3)
							icon_earth_underground.DrawBox(rgb(102,51,0),t.x,t.y,t.x,t.y)
						else if(t.z == 4)
							icon_yukopia.DrawBox(rgb(102,51,0),t.x,t.y,t.x,t.y)

						else if(t.z == 7)
							icon_yukopia_underground.DrawBox(rgb(102,51,0),t.x,t.y,t.x,t.y)
						break
					if(istype(t,/turf/void) || istype(t,/turf/unpassable_solid_opaque))
						if(t.z == 1)
							icon_earth.DrawBox(rgb(32,0,32),t.x,t.y,t.x,t.y)

						else if(t.z == 3)
							icon_earth_underground.DrawBox(rgb(32,0,32),t.x,t.y,t.x,t.y)
						else if(t.z == 4)
							icon_yukopia.DrawBox(rgb(32,0,32),t.x,t.y,t.x,t.y)

						else if(t.z == 7)
							icon_yukopia_underground.DrawBox(rgb(32,0,32),t.x,t.y,t.x,t.y)

				//Re-assign the icons to the world maps and their overlays
				map_earth.icon = icon_earth


				map_earth_underground.icon = icon_earth_underground
				map_yukopia.icon = icon_yukopia
				map_yukopia_underground.icon = icon_yukopia_underground
				map_vegeta.icon = icon_vegeta
				map_vegeta_underground.icon = icon_vegeta_underground
				map_icer.icon = icon_icer
				map_icer_underground.icon = icon_icer_underground


				earth_build_overlay.icon = icon_earth_overlay
				earth_u_build_overlay.icon = icon_earth_underground_overlay
				yuk_build_overlay.icon = icon_yukopia_overlay
				yuk_u_build_overlay.icon = icon_yukopia_underground_overlay
				vegeta_build_overlay.icon = icon_vegeta_overlay
				vegeta_u_build_overlay.icon = icon_vegeta_underground_overlay
				icer_build_overlay.icon = icon_icer_overlay
				icer_u_build_overlay.icon = icon_icer_underground_overlay


				map_locales = list(new /:map_box_large,new /:earth_location,new /:earth_underground_location, new /:yuk_location,new /:yuk_location_underground,new /:vegeta_location,new /:icer_location)

				maps = list(map_earth, map_earth_underground, null, map_yukopia, map_yukopia_underground, null, map_earth, map_earth_underground, map_icer, map_vegeta)

				maps_created = 1
				world.log<<"Maps and overlays created!"

				var/savefile/S = new("saves/world/world_maps.sav")
				S["MAPS"] << maps
				S["MAP_BUTTONS"] << map_locales
				S["MAP_MASTER"] << map_master

			for(var/mob/races/m in players)

				m.create_player_blip()
				if(m.z && m.open_map)
					var/obj/hud/map/map_large/x = maps[m.z]
					if(m.client && x.build_overlay) m.client.screen += x.build_overlay
				sleep(world.tick_lag)
			world.log<<"World Authorized!"
		create_player_shells()
			var/n = 1000
			while(n)
				n -= 1
				var/obj/hud/contact/shell = new
				player_shells += shell
		create_traits()
			var/list/trait_creation = typesof(/obj/traits/)
			trait_creation -= /obj/traits
			var/shift_xx = 20
			var/shift_yy = 636
			for(var/x in trait_creation)
				var/obj/I = new x()
				I.hud_x = shift_xx
				I.hud_y = shift_yy
				var/matrix/m = matrix()
				m.Translate(I.hud_x,I.hud_y)
				I.transform = m
				var/image/sel = image('skills.dmi',I,"skill unlocked",36)
				I.img_select = sel
				learnable_traits += I
				if(shift_xx >= 644)
					shift_xx = 20
					shift_yy -= 48
				else shift_xx += 48
		create_stances()
			var/list/stance_creation = typesof(/obj/stances/)
			stance_creation -= /obj/stances/
			var/shift_xx = 20
			var/shift_yy = 636
			for(var/x in stance_creation)
				var/obj/I = new x()
				I.hud_x = shift_xx
				I.hud_y = shift_yy
				var/matrix/m = matrix()
				m.Translate(I.hud_x,I.hud_y)
				I.transform = m
				var/image/sel = image('skills.dmi',I,"skill unlocked",36)
				I.img_select = sel
				learnable_stances += I
				if(shift_xx >= 644)
					shift_xx = 20
					shift_yy -= 48
				else shift_xx += 48
		create_skills()
			var/list/skill_creation = typesof(/obj/skills/)
			skill_creation -= /obj/skills/
			skill_creation -= /obj/skills/skill_overlay
			for(var/x in skill_creation)
				var/obj/skills/I = new x()
				var/image/sel = image('skills.dmi',I,"[I.name]",36)
				I.img_select = sel
				var/matrix/m = matrix()
				m.Translate(I.hud_x,I.hud_y)
				I.transform = m
				I.disable_sleep = 1
				learnable_skills += I

		/*create_skills()
			var/list/skill_creation = typesof(/obj/skills/)
			skill_creation -= /obj/skills/
			skill_creation -= /obj/skills/skill_overlay

			for(var/path in skill_creation)
				var/obj/I = path
				var/image/sel = image('skills.dmi',I,"[I.name]",36)
				I.img_select = sel
				var/matrix/m = matrix()
				m.Translate(I.hud_x,I.hud_y)
				I.transform = m
				//path.disable_sleep = 1
				global.learnable_skills += I*/
		create_rsc_nums()
			var/dmgs = 1000
			while(dmgs)
				dmgs -= 1
				var/obj/effects/over_displays/dmg_num/n = new
				n.maptext_width = 160
				n.maptext_x = -16
				n.layer = 201
				rsc_nums += n
				//sleep(0.1)
		create_dmg_nums()
			var/dmgs = 3333
			while(dmgs)
				dmgs -= 1
				var/obj/effects/over_displays/dmg_num/n = new
				dmg_nums += n
				//sleep(0.1)
		create_charge_nums()
			var/dmgs = 1000
			while(dmgs)
				dmgs -= 1
				var/obj/effects/over_displays/dmg_num/n = new
				charge_nums += n
				//sleep(0.1)
		create_plumes()
			var/plume = 1000
			while(plume)
				plume -= 1
				var/obj/effects/plume_ground/p = new
				plumes += p
				//sleep(0.1)
		create_lvl_overlays()
			var/lvls = 10000
			var/n = 0
			while(lvls)
				lvls -= 1
				var/obj/effects/over_displays/lvl_up_overlay/s = new
				lvl_overlays += s
				n += 1
				if(n == 100)
					n = 0
					sleep(0.1)
				//sleep(0.1)
		create_lightning()
			var/o = 750
			var/s = 750
			while(o)
				o -= 1
				var/obj/effects/lightning_bolt_psi/pl = new
				psi_lightning += pl
				pl.loc = locate(rand(1,500),rand(1,500),12)
				//sleep(0.1)

			while(s)
				s -= 1
				var/obj/effects/lightning_bolt_space/plspace = new
				space_lightning += plspace
				plspace.loc = locate(rand(1,500),rand(1,500),16)
			//	sleep(0.1)
		create_orbs()
			var/o = 10000
			while(o)
				o -= 1
				var/obj/effects/orb/or = new
				orbs += or
			//	sleep(0.1)
		create_furrows()
			var/f = 10000
			while(f)
				f -= 1
				var/obj/effects/furrow/d = new
				furrows += d
			//	sleep(0.1)
		create_parts()
			var/p = 333
			while(p)
				p -= 1
				var/obj/effects/particle/d = new
				parts += d
			//	sleep(0.1)
		create_dust()
			var/dust = 20000
			while(dust)
				dust -= 1
				var/obj/effects/dust/d = new
				dusts += d
			//	sleep(0.1)
			/*
			var/dust_expl = 3333
			while(dust_expl)
				dust_expl -= 1
				var/obj/effects/dust_explosive/d = new
				dusts_explosive += d
			*/
		create_blast()
			var/blast = 1000
			while(blast)
				blast -= 1
				var/obj/ranged/blast/b = new
				blasts += b
			//	sleep(0.1)
		create_beams()
			var/bm = 7000
			while(bm)
				bm -= 1
				var/obj/ranged/beam/b = new
				beams += b
				//sleep(0.1)
		create_help()
			//help = list(new /:offence,new /:Agility,new /:Endurance,new /:Energy,new /:Help_Flight,new /:force,new /:Help_Super_Speed,new /:Help_Meditation,new /:defence,new /:Regeneration,new /:resistance,new /:Help_Self_Train,new /:Strength,new /:Traits,new /:Recovery)
			var/list/help_creation = typesof(/obj/help_topics/)
			help_creation -= /obj/help_topics/
			help_creation -= /obj/help_topics/Alert_Misc
			for(var/x in help_creation)
				var/obj/I = new x()
				help += I
		create_buildings()
			var/obj/ov = new
			ov.icon = 'terrain_overlay.dmi'
			ov.pixel_x = -1
			ov.pixel_y = -1
			ov.layer = 33
			ov.plane = 23

			var/xx = 13
			var/yy = 233

			demolish = new /:demolish()

			floors = list(new /:Lava_Cooling,new /:Lava_Cooled,new /:Dirt,new /:Sand,new /:Snow,new /:Grass,new /:Wooden_Floor,new /:Brick_Floor,new /:Stone_Floor,new /:Log_Floor,new /:Metal_floor_01,new /:Metal_floor_02,new /:Metal_floor_03,new /:Metal_floor_04)

			for(var/obj/o in floors)
				var/matrix/m = matrix()
				m.Translate(xx,yy)
				o.transform = m
				o.overlays += ov
				xx += 48
				if(xx >= 288)
					xx = 13
					yy -= 48

			walls = list(new /:Brick_Wall,new /:Wooden_Wall,new /:Stone_Wall,new /:Log_Wall,new /:Metal_wall_01,new /:Metal_wall_02,new /:Metal_wall_03)

			xx = 13
			yy = 233

			for(var/obj/o in walls)
				var/matrix/m = matrix()
				m.Translate(xx,yy)
				o.transform = m
				o.overlays += ov
				xx += 48
				if(xx >= 288)
					xx = 13
					yy -= 48

			roofs = list(new /:Metal_Roof,new /:Wooden_Roof,new /:Brick_Roof,new /:Log_Roof,new /:Stone_Roof,new /:Metal_roof_01,new /:Metal_roof_02)

			xx = 13
			yy = 233

			for(var/obj/o in roofs)
				var/matrix/m = matrix()
				m.Translate(xx,yy)
				o.transform = m
				o.overlays += ov
				xx += 48
				if(xx >= 288)
					xx = 13
					yy -= 48
		save_players()
			spawn(10)
				while(src)
					for(var/mob/m in players)
						if(m.client) if(m.can_save && m.started)
							m.Mob_Save(0)

							//m.Mob_Save(0)//m.client.Save()
						//CHECK_TICK
					//sleep(60)
					sleep(3000)
		save_items()
			spawn(10)
				while(src)
					Save_objs()
					sleep(1000)
		create_bodies()
			eyes_portrait_cerebroid = list(new /:portrait_cerebroid_eyes1)
			eyes_portrait_yuk = list(new /:portrait_yuk_eyes1)
			horns_portrait_oni= list(new /:horns1_oni, new /:horns1_oni)
			horns_portait_demon = list(new /:horns1_demonic,new /:horns2_demonic)
			saiyan_tails = list(new /:brown_tail,new /:black_tail)
			body_horns = list(new /:horns1_demon,new /:horns2_demon,new/:horns2_demon_kid)
			horns_oni= list(new /:oni_horns1, new/:oni_horns1_kid)
			kid_hairs_male = list(new /:Hair1_kid,new /:Hair2_kid,new /:Hair3_kid,new /:Hair4_kid,new /:Hair5_kid,new /:Hair6_kid,new /:Hair7_kid,new /:Hair8_kid,new /:Hair9_kid,new /:Hair10_kid, new /:Hair11_kid, new /:Hair22_kid, new /:Hair24_kid, new /:Hair25_kid, new /:Hair26_kid, new /:None)
			kid_hairs_female = list(new /:Hair1_female_kid,new /:Hair2_female_kid,new /:Hair3_female_kid, new /:Hair9_female_kid,new /:Hair10_female_kid, new /:Hair11_female_kid, new /:None)
			hairs_male = list(new /:Hair1,new /:Hair2,new /:Hair3,new /:Hair4,new /:Hair5,new /:Hair6,new /:Hair7,new /:Hair8,new /:Hair9,new /:Hair10, new /:Hair11, new /:Hair22, new /:Hair24, new /:Hair25, new /:Hair26,new /:Hair27, new /:None)
			hairs_portrait_male = list(new /:portrait_Hair1_male,new /:portrait_Hair2_male,new /:portrait_Hair3_male,new /:portrait_Hair4_male,new /:portrait_Hair5_male,new /:portrait_Hair6_male,new /:portrait_Hair7_male,new /:portrait_Hair8_male,new /:portrait_Hair9_male,new /:portrait_Hair10_male, new /:portrait_Hair11_male, new /:portrait_Hair22_male, new /:portrait_Hair24_male, new /:portrait_Hair25_male, new /:portrait_Hair26_male, new /:portrait_Hair27_male, new /:None)
			hairs_female = list(new /:Hair1_female,new /:Hair2_female,new /:Hair3_female,new /:Hair9_female,new /:Hair10_female, new /:Hair11_female, new /:None)
			hairs_portrait_female = list(new /:portrait_Hair1_female,new /:portrait_Hair2_female,new /:portrait_Hair3_female,new /:portrait_Hair9_female,new /:None)
			eyes_portrait_female_demon = list(new /:portrait_female_demon_eyes1)
			eyes_portrait_makyo = list (new /:portrait_makyo_eyes1, new /:portrait_makyo_eyes2)
			eyes_portrait_spiritdoll = list (new /:portrait_spiritdoll_eyes1, new /:portrait_spiritdoll_eyes2)
			eyes_portrait_changeling = list(new /:portrait_changeling_eyes1)
			eyes_portrait_oni = list(new/:portrait_oni_eyes1, new /:portrait_oni_eyes2)
			eyes_portrait_female = list(new /:portrait_eyes1_female,new /:portrait_eyes2_female,new /:portrait_eyes3_female)
			eyes_portrait_male = list(new /:portrait_eyes1_male,new /:portrait_eyes2_male, new/:portrait_male_demon_eyes1, new/:portrait_male_demon_eyes3, new/:portrait_male_demon_eyes3)
			eyes_portrait_female_demon = list(new/:portrait_female_demon_eyes1, new/:portrait_female_demon_eyes2, new/:portrait_female_demon_eyes3)
			eyes_portrait_male_demon =list(new/:portrait_male_demon_eyes1, new/:portrait_male_demon_eyes3, new/:portrait_male_demon_eyes3)
			eyes_portrait_kai = list(new/:portrait_male_kai_eyes1, new /:portrait_male_kai_eyes2 , new/:portrait_male_kai_eyes3, new/:portrait_female_kai_eyes1, new/:portrait_female_kai_eyes2, new/:portrait_female_kai_eyes3)
			eyes_portrait_android_female = list(new /:android_female_eyes1,new /:android_female_eyes2,new /:android_female_eyes3)
			eyes_portrait_android_male = list(new /:android_male_eyes1,new /:android_male_eyes2)
			nose_portrait_male = list(new /:portrait_nose1_male,new /:portrait_nose2_male, new /:portrait_nose3_male)
			nose_portrait_female = list(new /:portrait_nose1_female,new /:portrait_nose2_female, new /:portrait_nose3_male)
			mouth_portrait_male = list(new /:portrait_mouth1_male,new /:portrait_mouth2_male,new /:portrait_mouth3_male,new /:portrait_mouth4_male)
			mouth_portrait_female = list(new /:portrait_mouth1_female,new /:portrait_mouth2_female,new /:portrait_mouth3_female,new /:portrait_mouth4_female,new /:portrait_mouth5_female)
			skins_human_male = list('NewMalesWhite.dmi','NewMalesWhite.dmi','NewMalesWhite.dmi')
			skins_human_female = list('FemaleBaseWhite.dmi','FemaleBaseWhite.dmi','FemaleBaseWhite.dmi')
			imp_ears = list("ears_curled","ears_down","ears_pointed")
			imp_skin = list("imp_blue_","imp_brown_","imp_grey_")
		shadows()
			for(var/obj/items/O in world)
				if(O.loc && O.icon && O.hashadow)
					if(O.shadow == null)
						var/obj/shad = new
						var/icon/I = new(O.icon,O.icon_state,O.dir)
						I.icon -= rgb(255,255,255)
						shad.icon = I
						shad.icon_state = O.icon_state
						shad.alpha = 100
						shad.loc = O.loc
						shad.pixel_x = O.pixel_x
						shad.pixel_y = O.pixel_y
						//shad.pixel_y = shad.pixel_y-(I.Height()/15)
						shad.pixel_y = shad.pixel_y-2
						shad.layer = 2.1
						shad.bolted = 2
						O.shadow = shad
						//del(I)
		yukopian_grass_populate()
			set background = 1
			for(var/turf/grass/y in block(locate(1,1,4),locate(400,400,4)))
				if(y.icon != 'grass_yukopian.dmi') y.icon = 'grass_yukopian.dmi'
				var/remove = 1
				for(var/turf/x in range(1,y))
					if(x.type != /turf/grass && x.liquid == null)
						remove = 0
				if(remove) yukopian_grasses -= y
				else yukopian_grasses += y
				sleep(0.1)

		yukopian_grass()
			var/list/turf_list = list()
			var/empty = 1
			//world << "DEBUG - Activating grass growing"
			spawn(6)
				//world << "DEBUG - Activated grass growing"
				while(1)
					for(var/turf/grass/g in yukopian_grasses)
						if(prob(1))
							if(g.density == 0 && g.density_factor <= 0)
								var/list/plants = list(/obj/items/plants/tree_yuk_1,/obj/items/plants/bush_small_yuk_1,/obj/items/plants/bush_small_yuk_2,/obj/items/plants/bush_small_yuk_3,/obj/items/plants/plant_small_yuk_1)
								var/p = pick(plants)
								var/obj/pln = new p(g)
								items += pln
								pln.transform = matrix()*0.1
								pln.layer = MOB_LAYER + pln.laymod - (g.y + pln.step_y / 32) / world.maxy
								animate(pln,transform = matrix()*1,time = 60)
						turf_list = list()
						empty = 1
						for(var/turf/x in range(1,g))
							if(x.type != /turf/grass && x.liquid == null)
								turf_list += x
								empty = 0
						if(empty == 0)
							var/turf/t = pick(turf_list)
							var/turf/grass/new_g = new(locate(t.x,t.y,t.z))
							new_g.icon = 'grass_yukopian.dmi'
							turfs[1][new_g.z] += new_g
							yukopian_grasses += new_g
							create_grass_dirt_transition(new_g.x-1,new_g.y-1,new_g.x+1,new_g.y+1,4,4,1)
						else
							yukopian_grasses -= g
							//g.icon = initial(g.icon)
							//g.icon_state = initial(g.icon_state)
						//sleep(0.1)
					global.yukopian_pp = length(yukopian_grasses)/4
					sleep(6000)
		yukopian_vines_populate()
			for(var/turf/t in block(locate(1,1,4),locate(500,500,4)))
				for(var/obj/items/tech/Power_Line/p in t)
					if(p.organic && p.grow_dir)
						yukopian_vines += p
						break
			if(vines >= 200) yukopian_vines = list()
		yukopian_vines()
			spawn(60)
				while(1)
					if(vines > 200) return
					for(var/obj/items/tech/Power_Line/p in yukopian_vines)
						if(p.loc)
							if(p.grow_dir == "west")
								p.grow_dir = null
								yukopian_vines -= p
								var/turf/t1 = locate(p.x-1,p.y,p.z)
								var/emp_1 = 1
								if(t1)
									for(var/obj/items/tech/Power_Line/pow in t1)
										emp_1 = 0
										break
									if(emp_1)
										var/obj/items/tech/Power_Line/p_1 = new
										p_1.loc = t1
										p_1.organic = 1
										p_1.icon = 'power_lines_vines.dmi'
										p_1.grow_dir = "west"
										if(prob(10)) p_1.grow_dir = pick("all","north","south")
										yukopian_vines += p_1
										items += p_1
										vines += 1
							else if(p.grow_dir == "east")
								p.grow_dir = null
								yukopian_vines -= p
								var/turf/t1 = locate(p.x+1,p.y,p.z)
								var/emp_1 = 1
								if(t1)
									for(var/obj/items/tech/Power_Line/pow in t1)
										emp_1 = 0
										break
									if(emp_1)
										var/obj/items/tech/Power_Line/p_1 = new
										p_1.loc = t1
										p_1.organic = 1
										p_1.icon = 'power_lines_vines.dmi'
										p_1.grow_dir = "east"
										if(prob(10)) p_1.grow_dir = pick("all","north","south")
										yukopian_vines += p_1
										items += p_1
										vines += 1
							else if(p.grow_dir == "north")
								p.grow_dir = null
								yukopian_vines -= p
								var/turf/t1 = locate(p.x,p.y+1,p.z)
								var/emp_1 = 1
								if(t1)
									for(var/obj/items/tech/Power_Line/pow in t1)
										emp_1 = 0
										break
									if(emp_1)
										var/obj/items/tech/Power_Line/p_1 = new
										p_1.loc = t1
										p_1.organic = 1
										p_1.icon = 'power_lines_vines.dmi'
										p_1.grow_dir = "north"
										if(prob(10)) p_1.grow_dir = pick("all","east","west")
										yukopian_vines += p_1
										items += p_1
										vines += 1
							else if(p.grow_dir == "south")
								p.grow_dir = null
								yukopian_vines -= p
								var/turf/t1 = locate(p.x,p.y-1,p.z)
								var/emp_1 = 1
								if(t1)
									for(var/obj/items/tech/Power_Line/pow in t1)
										emp_1 = 0
										break
									if(emp_1)
										var/obj/items/tech/Power_Line/p_1 = new
										p_1.loc = t1
										p_1.organic = 1
										p_1.icon = 'power_lines_vines.dmi'
										p_1.grow_dir = "south"
										if(prob(10)) p_1.grow_dir = pick("all","east","west")
										yukopian_vines += p_1
										items += p_1
										vines += 1
							else if(p.grow_dir == "all")
								p.grow_dir = null
								yukopian_vines -= p
								var/turf/t1 = locate(p.x,p.y+1,p.z)
								var/turf/t2 = locate(p.x,p.y-1,p.z)
								var/turf/t3 = locate(p.x+1,p.y,p.z)
								var/turf/t4 = locate(p.x-1,p.y,p.z)
								var/emp_1 = 1
								var/emp_2 = 1
								var/emp_3 = 1
								var/emp_4 = 1
								if(t1)
									for(var/obj/items/tech/Power_Line/pow in t1)
										emp_1 = 0
										break
									if(emp_1)
										var/obj/items/tech/Power_Line/p_1 = new
										p_1.loc = t1
										p_1.organic = 1
										p_1.icon = 'power_lines_vines.dmi'
										p_1.grow_dir = "north"
										yukopian_vines += p_1
										items += p_1
										vines += 1
								if(t2)
									for(var/obj/items/tech/Power_Line/pow in t2)
										emp_2 = 0
										break
									if(emp_2)
										var/obj/items/tech/Power_Line/p_2 = new
										p_2.loc = t2
										p_2.organic = 1
										p_2.icon = 'power_lines_vines.dmi'
										p_2.grow_dir = "south"
										yukopian_vines += p_2
										items += p_2
										vines += 1
								if(t3)
									for(var/obj/items/tech/Power_Line/pow in t3)
										emp_3 = 0
										break
									if(emp_3)
										var/obj/items/tech/Power_Line/p_3 = new
										p_3.loc = t3
										p_3.organic = 1
										p_3.icon = 'power_lines_vines.dmi'
										p_3.grow_dir = "east"
										yukopian_vines += p_3
										items += p_3
										vines += 1
								if(t4)
									for(var/obj/items/tech/Power_Line/pow in t4)
										emp_4 = 0
										break
									if(emp_4)
										var/obj/items/tech/Power_Line/p_4 = new
										p_4.loc = t4
										p_4.organic = 1
										p_4.icon = 'power_lines_vines.dmi'
										p_4.grow_dir = "west"
										yukopian_vines += p_4
										items += p_4
										vines += 1
					sleep(6000)
/proc/dir2text_sense(direction)
	switch(direction)
		if(1.0)
			return "North"
		if(2.0)
			return "South"
		if(4.0)
			return "East"
		if(8.0)
			return "West"
		if(5.0)
			return "NorthEast"
		if(6.0)
			return "SouthEast"
		if(9.0)
			return "NorthWest"
		if(10.0)
			return "SouthWest"
		else
	return
/*
/proc/Commas(A)
	//var/Number=num2text(round(A,1),20)
	var/Number=num2text(A,20)
	for(var/i=length(Number)-2,i>1,i-=3) Number="[copytext(Number,1,i)]'[copytext(Number,i)]"
	return Number
*/
/proc/File_Size(file)
	var/size=length(file)
	if(!size|!isnum(size)) return
	var/ending="Byte"
	if(size>=1024)
		size/=1024
		ending="KB"
		if(size>=1024)
			size/=1024
			ending="MB"
			if(size>=1024)
				size/=1024
				ending="GB"
	return ending
/proc/Commas(A)
	var/Number=num2text(round(A,1),20)
	var/start_num = length(Number)-2
	if(A < 0) start_num = length(Number)-3
	for(var/i=start_num,i>1,i-=3) Number="[copytext(Number,1,i)],[copytext(Number,i)]"
	return Number

/proc/signs(x)
	sleep(1)
	return x!=0?x/abs(x):0 //((x<0)?-1:((x>0)?1:0))


