// ------------------------------------------------------------
// WORLD BOSS SYSTEM
// ------------------------------------------------------------

var/list/WORLD_BOSS_CONTROLLERS = list()

/proc/IsWeekend()
	// Uses host machine date/time (world.realtime).
	// "DDD" returns day abbrev like "Mon" "Tue" ... "Sat" "Sun"
	var/d = time2text(world.realtime, "DDD")
	return (d == "Sat" || d == "Sun")

/proc/SecondsUntilNextMidnight()
	// Compute seconds until next local midnight using host time.
	// Format: "YYYY-MM-DD hh:mm:ss"
	var/t = time2text(world.realtime, "YYYY-MM-DD hh:mm:ss")

	// Positions: YYYY(1-4) - (5) MM(6-7) - (8) DD(9-10) space(11) hh(12-13) :(14) mm(15-16) :(17) ss(18-19)
	var/hh = text2num(copytext(t, 12, 14))
	var/mm = text2num(copytext(t, 15, 17))
	var/ss = text2num(copytext(t, 18, 20))

	var/seconds_today = (hh * 3600) + (mm * 60) + ss
	var/left = 86400 - seconds_today
	if(left <= 0) left = 1
	return left


world/proc/IsMondayEST()
    return (time2text(world.realtime, "DDD", -300) == "Mon")

world/proc/SecondsUntilNextMondayMidnightEST()
    // EST offset = -300 minutes
    var/day = time2text(world.realtime, "DDD", -300)
    var/t = time2text(world.realtime, "YYYY-MM-DD hh:mm:ss", -300)

    var/hh = text2num(copytext(t, 12, 14))
    var/mm = text2num(copytext(t, 15, 17))
    var/ss = text2num(copytext(t, 18, 20))

    var/seconds_today = (hh * 3600) + (mm * 60) + ss
    var/seconds_left_today = 86400 - seconds_today

    if(day == "Mon")
        // If it's Monday, we want NEXT Monday
        return seconds_left_today + (6 * 86400)

    var/list/days = list("Sun","Mon","Tue","Wed","Thu","Fri","Sat")
    var/current_index = days.Find(day)
    var/monday_index = days.Find("Mon")

    var/days_until = monday_index - current_index
    if(days_until <= 0)
        days_until += 7

    return seconds_left_today + ((days_until - 1) * 86400)

world/proc/ApplyWeeklyRoleplayReset()
    world << "<b>Weekly Roleplay Reset Activated!</b>"

    for(var/mob/M in world)
        if(!M.client) continue

        M.roleplay_rank -= 5

        if(M.roleplay_rank < 1)
            M.roleplay_rank = 1
        M.set_roleplayrank(M.roleplay_rank)

        M << "<font color=green><b>Your roleplay rank has been reduced for the weekly reset!</font></b>"

world/proc/WeeklyRoleplayScheduler()
    set background = 1

    while(TRUE)
        var/sec = SecondsUntilNextMondayMidnightEST()
        sleep(sec * 10)  // convert seconds to ticks

        ApplyWeeklyRoleplayReset()

/datum/worldboss_controller
	var
		name = "World Boss"
		z_level = 1
		boss_type = /mob/NPC/WorldBoss
		respawn_delay_ticks = 600 // 10 minutes at 10 ticks/sec
		tmp/mob/NPC/WorldBoss/current = null
		tmp/active_today = 0
		list/spawn_points = list() // turfs

	New(_name, _z, _boss_type)
		..()
		if(_name) name = _name
		if(_z) z_level = _z
		if(_boss_type) boss_type = _boss_type

	proc/AddSpawnPoint(x, y)
		var/turf/T = locate(x, y, z_level)
		if(T) spawn_points += T

	proc/GetSpawnLoc()
		if(spawn_points && spawn_points.len)
			return pick(spawn_points)
		// Fallback if you forget to add points:
		return locate(1,1,z_level)

	proc/EnsureBoss()
		if(!active_today) return
		if(current && current.loc) return
		SpawnBoss()

	proc/SpawnBoss()
		if(!active_today) return
		var/turf/T = GetSpawnLoc()
		if(!T) return

		var/mob/NPC/WorldBoss/B = new boss_type(T)
		current = B
		B.worldboss_controller = src
		B.boss_planet_name = name

		world << "<b><font color=#ff9933>WORLD BOSS:</font> <font color=white>[name] boss has appeared!</font></b>"

	proc/OnBossDeath()
		if(!active_today) return
		// schedule respawn
		spawn(respawn_delay_ticks)
			if(src && active_today)
				SpawnBoss()

	proc/StartDay()
		active_today = 1
		EnsureBoss()

	proc/StopDay()
		active_today = 0
		if(current)
			del(current)
			current = null

// ------------------------------------------------------------
// BOOTSTRAP + DAILY SCHEDULER
// ------------------------------------------------------------

world/proc/SetupWorldBossControllers()
	if(WORLD_BOSS_CONTROLLERS && WORLD_BOSS_CONTROLLERS.len) return

	// Z-levels taken from your Planet Teleport:
	// Earth=1, Namek=4, Icer=9, Vegeta=10

	var/datum/worldboss_controller/E = new("Earth", 1, /mob/NPC/WorldBoss/EarthBoss)
	var/datum/worldboss_controller/N = new("Namek", 4, /mob/NPC/WorldBoss/NamekBoss)
	var/datum/worldboss_controller/I = new("Icer", 9, /mob/NPC/WorldBoss/IcerBoss)
	var/datum/worldboss_controller/V = new("Vegeta", 10, /mob/NPC/WorldBoss/VegetaBoss)
	var/datum/worldboss_controller/HV = new("Heaven", 11, /mob/NPC/WorldBoss/HeavenBoss)
	var/datum/worldboss_controller/HF = new("Hell", 6, /mob/NPC/WorldBoss/HellBoss)

	// Add a few spawn points per planet (CHANGE THESE COORDS)
	// You can add as many as you want; it picks randomly.
	E.AddSpawnPoint(432,66) // Earth World Boss Spawn

	N.AddSpawnPoint(117,424) // Namek World Boss Spawn

	I.AddSpawnPoint(425,450) // Icer World Boss Spawn

	V.AddSpawnPoint(45,425) // Vegeta World Boss Spawn

	HV.AddSpawnPoint(37,26) // Heaven World Boss Spawn

	HF.AddSpawnPoint(389,220) // Hell World Boss Spawn

	WORLD_BOSS_CONTROLLERS += E
	WORLD_BOSS_CONTROLLERS += N
	WORLD_BOSS_CONTROLLERS += I
	WORLD_BOSS_CONTROLLERS += V
	WORLD_BOSS_CONTROLLERS += HF
	WORLD_BOSS_CONTROLLERS += HV

	world.log << "WorldBoss: controllers setup complete ([WORLD_BOSS_CONTROLLERS.len])."

world/proc/WorldBossDailyScheduler()
	set background = 1

	SetupWorldBossControllers()

	while(TRUE)
		// At server start, apply today immediately:
		if(IsWeekend())
			for(var/datum/worldboss_controller/C in WORLD_BOSS_CONTROLLERS)
				C.StartDay()
		else
			for(var/datum/worldboss_controller/C in WORLD_BOSS_CONTROLLERS)
				C.StopDay()

		// Wait until next midnight, then loop again
		var/sec = SecondsUntilNextMidnight()
		sleep(sec * 10) // convert seconds to ticks
/datum/loot_roll/proc/Resolve()
	if(!active) return
	active = 0

	InjectFakeRolls()

	var/winner_ckey = null
	var/winning_roll = 0

	// 1) NEED always wins over GREED
	if(need.len)
		for(var/ck in need)
			if(need[ck] > winning_roll)
				winning_roll = need[ck]
				winner_ckey = ck

	else if(greed.len)
		for(var/ck in greed)
			if(greed[ck] > winning_roll)
				winning_roll = greed[ck]
				winner_ckey = ck

	// 2) Give item or leave it
	if(winner_ckey)
		GiveItemTo(winner_ckey)
		//world << "<b>[roll_type] roll won:</b> [item.name]"
	//else
		// << "<i>All players passed on [item.name].</i>"

/datum/loot_roll/proc/HandleChoice(mob/M, list/h)
	if(!active || !M || !M.client) return

	var/ck = M.ckey
	var/act = h["action"]

	if(!(ck in eligible_ckeys)) return
	if(ck in need || ck in greed || ck in pass) return

	var/roll = 0

	switch(act)
		if("need")
			roll = rand(1,100)
			need[ck] = roll
			BroadcastRoll("[M.name] rolled <b><font color = yellow>NEED</b></font> ([roll])",M)

		if("greed")
			roll = rand(1,100)
			greed[ck] = roll
			BroadcastRoll("[M.name] rolled <b><font color = green>GREED</b></font> ([roll])",M)

		if("pass")
			pass += ck
			BroadcastRoll("[M.name] <font color = red>passed.</font>",M)

	M << browse(null, "window=lootroll")

/datum/loot_roll/proc/BroadcastRoll(msg,mob/N)
	if(N != null)
		for(var/mob/races/M in view(15,N))
			if(M.client)
				M << "<span class='loot'>[msg]</span>"
	else
		for(var/mob/races/M in players)
			if(M.client)
				M << "<span class='loot'>[msg]</span>"


/datum/loot_roll
	var/obj/item
	var/list/eligible_ckeys = list()

	var/list/need = list()    // ckey = roll
	var/list/greed = list()   // ckey = roll
	var/list/pass = list()

	var/time_limit = 300      // 30 seconds (10 ticks/sec)
	var/tmp/active = 1

	New(obj/O, list/eligible_mobs)
		item = O

		for(var/mob/races/M in eligible_mobs)
			if(M && M.client)
				eligible_ckeys += M.ckey
				ShowLootUI(M)

		spawn(time_limit)
			Resolve()

/datum/loot_roll/proc/ShowLootUI(mob/M)
	if(!M || !M.client) return

	var/icon_html = ""
	if(item)
		var/icon/I = icon(item.icon, item.icon_state)
		I.Scale(48,48)
		var/r = fcopy_rsc(I)
		icon_html = "<img src='\ref[r]' width='48' height='48'>"

	var/html = {"
	<html>
	<head>
	<style>
	body{
		background:linear-gradient(#0c0f16,#121722);
		color:#ffffff;
		font-family:Verdana;
		text-align:center;
		margin:0;
		padding:15px;
	}

	.container{
		background:#1a1f2b;
		border:2px solid #2c3447;
		border-radius:12px;
		padding:15px;
		box-shadow:0 0 20px rgba(0,0,0,0.8);
	}

	.item-name{
		font-size:16px;
		font-weight:bold;
		color:#ffd166;
		margin-top:5px;
		margin-bottom:10px;
		text-shadow:0 0 6px rgba(255,209,102,0.7);
	}

	.timer{
		font-size:12px;
		color:#aaa;
		margin-bottom:15px;
	}

	.button{
		display:inline-block;
		width:80%;
		padding:10px;
		margin:6px 0;
		border-radius:8px;
		text-decoration:none;
		font-weight:bold;
		font-size:14px;
		transition:all 0.15s ease-in-out;
		border:1px solid transparent;
	}

	.need{
		background:#2a1f1f;
		border-color:#aa4444;
		color:#ff6666;
		box-shadow:0 0 10px rgba(255,80,80,0.4);
	}
	.need:hover{
		background:#3b2323;
		box-shadow:0 0 18px rgba(255,80,80,0.9);
		transform:scale(1.05);
	}

	.greed{
		background:#1f2a1f;
		border-color:#44aa44;
		color:#66ff66;
		box-shadow:0 0 10px rgba(80,255,80,0.4);
	}
	.greed:hover{
		background:#243b24;
		box-shadow:0 0 18px rgba(80,255,80,0.9);
		transform:scale(1.05);
	}

	.pass{
		background:#2a2a2a;
		border-color:#777;
		color:#ccc;
		box-shadow:0 0 8px rgba(200,200,200,0.2);
	}
	.pass:hover{
		background:#333;
		box-shadow:0 0 14px rgba(255,255,255,0.4);
		transform:scale(1.05);
	}

	.footer{
		font-size:11px;
		color:#888;
		margin-top:10px;
	}
	</style>
	</head>

	<body>
	<div class='container'>
		<h3>Loot Roll</h3>
		[icon_html]
		<div class='item-name'>[item.name]</div>
		<div class='timer'>You have 30 seconds to choose</div>

		<a class='button need' href='?loot_roll=\ref[src];action=need'>NEED</a>
		<a class='button greed' href='?loot_roll=\ref[src];action=greed'>GREED</a>
		<a class='button pass' href='?loot_roll=\ref[src];action=pass'>PASS</a>

		<div class='footer'>Highest roll wins. Need rolls beat Greed rolls.</div>
	</div>
	</body>
	</html>
	"}

	M << browse(html, "window=lootroll;size=320x360;can_close=0")

/*/datum/loot_roll/proc/ShowLootUI(mob/M)
	if(!M || !M.client) return

	var/html = {"
	<html>
	<body style='background:#111;color:white;font-family:Verdana'>
	<h3>Please select an option!</h3>
	<p><b><h3>Loot:[item.name]</h3></b></p>
	<p>You have 30 seconds to choose:</p>

	<a href='?loot_roll=\ref[src];action=need'>Need</a><br>
	<a href='?loot_roll=\ref[src];action=greed'>Greed</a><br>
	<a href='?loot_roll=\ref[src];action=pass'>Pass</a>
	</body>
	</html>
	"}

	M << browse(html, "window=lootroll;size=300x240")
	world.log << "WB DEBUG total_damage=[total_damage] contributors=[damage_by_ckey.len]"
	for(var/ck in damage_by_ckey)
		world.log << "WB DEBUG [ck] dmg=[damage_by_ckey[ck]] pct=[(damage_by_ckey[ck]*100)/total_damage]%"*/



/datum/loot_roll/Topic(href, list/h)
	if(!active) return

	var/ck = h["ck"]
	var/act = h["act"]

	if(!(ck in eligible_ckeys)) return
	if(ck in need || ck in greed || ck in pass) return

	switch(act)
		if("need")
			need[ck] = rand(1,100)
		if("greed")
			greed[ck] = rand(1,100)
		if("pass")
			pass += ck
/datum/loot_roll/proc/GiveItemTo(var/ckey)
	for(var/mob/races/M in players)
		if(M.ckey == ckey && M.client)

			item.loc = M.loc
			M.pickup(item)
			M << "<b>You won:</b> [item.name]!"
			oview(15,M) << "<b>[M.name]</b> won [item.name]."
			sleep(world.tick_lag)
			return

	// Player offline → item drops normally
	item.loc = item.loc

/datum/loot_roll/proc/HighestRoll(list/L)
	var/high = 0
	var/winner = null

	for(var/ck in L)
		if(L[ck] > high)
			high = L[ck]
			winner = ck

	return winner


mob/NPC/WorldBoss
	npc = 1
	agressive = 1
	hashadow = 1
	grav = 5000
	appearance_flags = KEEP_TOGETHER

	var/tmp/datum/worldboss_controller/worldboss_controller = null
	var/tmp/boss_planet_name = null


	var/tmp/obj/items/rare_item = null
	// Optional: stop bosses from wandering too far (if your AI uses leash vars)
	leash_range = 65
	chase_range = 80
	attack_range = 9
	attack_cooldown = 10

	boss = 1
	var/tmp/turret_ai_running = 0
	var/tmp/next_fire_time = 0
	proc
		boss_cancel_attack()
		// Safety: stop any “stuck” attack state
			src.active_attack = null
			src.current_attack = null
			src.mouse_down = null

		boss_find_target()
			for(var/mob/races/M in oview(25, src))
				if(M && M.client && !M.npc && !M.koed)
					return M
					return null

		boss_idle_ai()
			if(src.turret_ai_running) return
			src.turret_ai_running = 1

			spawn(-1)
				while(src)
					if(src.koed || src.stunned)
						src.target = null
						src.boss_cancel_attack()
						sleep(10)
						continue

						// Acquire/validate target
					if(!src.target || src.target.koed || get_dist(src, src.target) > 25)
						src.target = src.boss_find_target()

					if(src.target)
						var/d = get_dist(src, src.target)




						// Always face target (no movement)
						src.dir = get_dir(src, src.target)

						/*if(dist > src.attack_range)
							src.updateFollow(src.target, 0, src.follow_delay)
							sleep(src.follow_delay)
							continue*/

						/*if(d >= 1 && d <= src.attack_range)
							if(prob(50))
								src.step_towards(src, src.target)*/

						if(d > src.leash_range)
							src._npc_return_home()
							continue

						// Only fire if within 1–10 tiles
						if(d >= 1 && d >= src.attack_range)
							// If your blast system sets active_attack while firing, respect it
							//world << "[src] attack range: [src.attack_range] / dist: [d]"
							if(!src.active_attack && world.time >= src.next_fire_time)
								if(src.skill_blast && src.energy >= 1)

									src.next_fire_time = world.time + src.attack_cooldown
									src.mouse_down = src.target.loc
									src.current_attack = src.skill_blast
									call(src.skill_blast, src.skill_blast.act)(src)
									if(hascall(src, "Blast"))
										call(src, "Blast")()

						else
							if(d <= src.attack_range)
								src.updateFollow(src.target, 0, src.follow_delay)
								sleep(src.follow_delay)
								continue
							// Out of range: stop/cancel any ongoing firing state
							if(src.active_attack || src.current_attack)
								src.boss_cancel_attack()

							if(hascall(src, "Attack"))
								call(src, "Attack")()
							else
								src._npc_melee_strike(src.target)


					else
						// Idle: optionally rotate sometimes
						if(prob(10))
							src.dir = pick(NORTH, SOUTH, EAST, WEST)
					src.get_mouse_pos()
					sleep(25)

	New()
		..()
		// Make sure it “feels” like a boss:
		src.name_txt()
		src.create_afterimages()
		var/turf/t = src.loc
		src.loc.Enter(src)
		src.Move(t)
		src.grav = t.grav

		// If you have a preferred AI proc for NPCs, you can start it here.
		// spawn(5) src.npc_ai()

	Del()
		// If the boss is deleted while active (killed or removed), notify controller.
		if(worldboss_controller && worldboss_controller.active_today)
			// Important: Only schedule respawn if it was actually a death scenario.
			// If StopDay() is deleting it, active_today will be 0 before del().
			worldboss_controller.current = null
		..()

	// Hook death: your game uses Death("reason") in places.
	// If your actual death handler is named differently, tell me the exact proc name and I’ll hook that instead.
	Death(var/reason)
		if(worldboss_controller.active_today)
			view(15,src) << "<b><font color=#ff3333>WORLD BOSS:</font> <font color=white>[boss_planet_name] boss was defeated!</font></b>"
			var/list/eligible = GetEligiblePlayers()

			if(eligible.len)
				new /datum/loot_roll(rare_item, eligible)
				world.log << "Eligible players found for loot! - [src]"


			else
				world.log << "No eligible players for loot. - [src]"

			worldboss_controller.current = null
			worldboss_controller.OnBossDeath()
			world.log << "WB DEBUG total_damage=[total_damage] contributors=[damage_by_ckey.len]"
			for(var/ck in damage_by_ckey)
				world.log << "WB DEBUG [ck] dmg=[damage_by_ckey[ck]] pct=[(damage_by_ckey[ck]*100)/total_damage]%"
		..(reason)

	/*proc/GetEligiblePlayers()
		var/list/eligible = list()

		if(total_damage <= 0) return eligible

		for(var/ck in damage_by_ckey)
			var/dmg = damage_by_ckey[ck]
			if(dmg / total_damage < 0.05) continue

			// Find active mob for this ckey
			for(var/mob/M in players)
				if(M.ckey == ck && M.client)
					eligible += M
					break

		return eligible*/
	proc/GetEligiblePlayers()
		var/list/eligible = list()
		if(total_damage <= 0) return eligible

		for(var/ck in damage_by_ckey)
			var/dmg = damage_by_ckey[ck]
			var/pct = (dmg * 100) / total_damage
			if(pct < 5) continue

			for(var/mob/M in players)
				if(M && M.client && M.ckey == ck)
					eligible += M
					break

		return eligible



	// -------------------------
	// Planet-specific bosses
	// -------------------------

	EarthBoss
		name = "Great Makyoni (Elite)"
		real_name = "Great Makyoni (Elite)"
		fullname = "Great Makyoni (Elite)"
		icon = 'Earth Boss.dmi'
		hp = 500

		New()
			..()
			// You can set stats however your system expects.
			// Using your style:
			set_stats(33,3333,33,100,33,100,50,50)
			psionic_power = 1000 * year
			energy = 999999999
			energy_max = 999999999
			strength = 500 * year
			endurance = 3500 * year
			force = 500 * year
			resistance = 1500 * year
			offence = 2500 * year
			defence = 1000 * year
			mod_agility = 2
			src.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(255,255,128))
			switch(rand(1,99))
				if(55 to 75)
					var/obj/items/consumables/ectoplasm_pure/epe = new /obj/items/consumables/ectoplasm_pure(src)
					epe.loc = src
					rare_item = epe
				if(2)
					var/obj/items/dokuro_coin/dc = new/obj/items/dokuro_coin(src)
					dc.stacks = pick(5,15,20,40,60)
					dc.loc = src
					rare_item = dc
				if(3)
					var/obj/items/misc/platinum_chest/gc2 = new /obj/items/misc/platinum_chest(src)
					gc2.loc = src
					rare_item = gc2
				if(4 to 15)
					var/obj/items/artifacts/blueprint/bp= new /obj/items/artifacts/blueprint(src)
					bp.loc = src
					rare_item = bp
				if(1)
					var/obj/items/dokuro_coin/dc2 = new/obj/items/dokuro_coin(src)
					dc2.stacks = pick(3,5,10,25,40)
					dc2.loc = src
					rare_item = dc2
				if(16 to 30)
					var/obj/items/artifacts/blueprint/bp= new /obj/items/artifacts/blueprint(src)
					bp.loc = src
					rare_item = bp
				if(31 to 54)
					var/obj/items/artifacts/blueprint/en = new /obj/items/artifacts/blueprint(src)
					en.loc = src
					rare_item = en
				if(76 to 90)
					var/obj/items/misc/platinum_chest/gc2 = new /obj/items/misc/platinum_chest(src)
					gc2.loc = src
					rare_item = gc2
				if(91 to 99)
					var/obj/items/consumables/ectoplasm_pure/epe = new /obj/items/consumables/ectoplasm_pure(src)
					epe.loc = src
					rare_item = epe
			var/colorz
			switch(rand(1,14))
				if(1)
					colorz=rgb(rand(1,250),rand(1,200),rand(1,250))
				if(2)
					colorz=rgb(rand(20,80),rand(1,200),rand(1,255))
				if(3)
					colorz=rgb(0,rand(80,200),rand(20,255))
				if(4)
					colorz=rgb(rand(1,255),rand(1,20),rand(56,175))
				if(5)
					colorz=rgb(rand(1,60),rand(1,80),rand(1,120))
				if(6)
					colorz=rgb(rand(80,155),0,rand(1,80))
				if(7)
					colorz=rgb(rand(5,253),rand(5,253),rand(5,80))
				if(8)
					colorz=rgb(rand(5,80),rand(5,253),rand(5,253))
				if(9)
					colorz=rgb(rand(5,80),rand(5,80),rand(5,80))
				if(10)
					colorz=rgb(rand(35,153),rand(65,153),rand(95,153))
				if(11)
					colorz=rgb(rand(1,250),rand(1,200),rand(1,250))
				if(12)
					colorz=rgb(rand(0,255),rand(200,255),rand(0,255))
				if(13)
					colorz=rgb(rand(200,255),rand(0,255),rand(0,255))
				if(14)
					colorz=rgb(rand(0,255),rand(0,255),rand(200,255))
			auracolor = colorz

			// Ensure blast exists
			var/obj/skills/Blast/f = new
			f.loc = src
			f.skill_lvl = 25
			src.skill_blast = f

			// IMPORTANT: do NOT run the old movement/chase loop for turrets.
			// Start turret brain immediately:
			src.boss_idle_ai()



	NamekBoss
		name = "Fauna (Elite)"
		icon = 'Namek Boss.dmi'
		real_name = "Fauna (Elite)"
		fullname = "Fauna (Elite)"
		hp = 500
		New()
			..()
			var/pix_y = 0
			set_stats(33,3333,33,100,33,100,50,50)
			psionic_power = 1300 * year
			energy = 999999999
			energy_max = 999999999
			strength = 500 * year
			endurance = 600 * year
			force = 700 * year
			resistance = 3000 * year
			offence = 2000 * year
			defence = 1000 * year
			mod_agility = 3
			animate(src,pixel_y = 5, time = 20,loop = -1,flags = ANIMATION_PARALLEL + ANIMATION_END_NOW)
			animate(pixel_y = pix_y, time = 10)
			src.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(255,255,128))
			switch(rand(1,99))
				if(55 to 75)
					var/obj/items/consumables/ectoplasm_pure/epe = new /obj/items/consumables/ectoplasm_pure(src)
					epe.loc = src
					rare_item = epe
				if(2)
					var/obj/items/dokuro_coin/dc = new/obj/items/dokuro_coin(src)
					dc.stacks = pick(5,15,20,40,60)
					dc.loc = src
					rare_item = dc
				if(3)
					var/obj/items/misc/platinum_chest/gc2 = new /obj/items/misc/platinum_chest(src)
					gc2.loc = src
					rare_item = gc2
				if(4 to 15)
					var/obj/items/artifacts/blueprint/bp= new /obj/items/artifacts/blueprint(src)
					bp.loc = src
					rare_item = bp
				if(1)
					var/obj/items/dokuro_coin/dc2 = new/obj/items/dokuro_coin(src)
					dc2.stacks = pick(3,5,10,25,40)
					dc2.loc = src
					rare_item = dc2
				if(16 to 30)
					var/obj/items/consumables/might_fruit/st = new /obj/items/consumables/might_fruit(src)
					st.loc = src
					rare_item = st
				if(31 to 54)
					var/obj/items/artifacts/blueprint/en = new /obj/items/artifacts/blueprint(src)
					en.loc = src
					rare_item = en
				if(76 to 90)
					var/obj/items/misc/platinum_chest/gc = new /obj/items/misc/platinum_chest(src)
					gc.loc = src
					rare_item = gc
				if(91 to 99)
					var/obj/items/consumables/ectoplasm_pure/epe = new /obj/items/consumables/ectoplasm_pure(src)
					epe.loc = src
					rare_item = epe
			var/colorz
			switch(rand(1,14))
				if(1)
					colorz=rgb(rand(1,250),rand(1,200),rand(1,250))
				if(2)
					colorz=rgb(rand(20,80),rand(1,200),rand(1,255))
				if(3)
					colorz=rgb(0,rand(80,200),rand(20,255))
				if(4)
					colorz=rgb(rand(1,255),rand(1,20),rand(56,175))
				if(5)
					colorz=rgb(rand(1,60),rand(1,80),rand(1,120))
				if(6)
					colorz=rgb(rand(80,155),0,rand(1,80))
				if(7)
					colorz=rgb(rand(5,253),rand(5,253),rand(5,80))
				if(8)
					colorz=rgb(rand(5,80),rand(5,253),rand(5,253))
				if(9)
					colorz=rgb(rand(5,80),rand(5,80),rand(5,80))
				if(10)
					colorz=rgb(rand(35,153),rand(65,153),rand(95,153))
				if(11)
					colorz=rgb(rand(1,250),rand(1,200),rand(1,250))
				if(12)
					colorz=rgb(rand(0,255),rand(200,255),rand(0,255))
				if(13)
					colorz=rgb(rand(200,255),rand(0,255),rand(0,255))
				if(14)
					colorz=rgb(rand(0,255),rand(0,255),rand(200,255))
			auracolor = colorz

			// Ensure blast exists
			var/obj/skills/Blast/f = new
			f.loc = src
			f.skill_lvl = 25
			src.skill_blast = f

			// IMPORTANT: do NOT run the old movement/chase loop for turrets.
			// Start turret brain immediately:
			src.boss_idle_ai()

	IcerBoss
		name = "Auto War Intelligence (Elite)"
		icon = 'Icer Boss.dmi'
		real_name = "Auto War Intelligence (Elite)"
		fullname = "Auto War Intelligence (Elite)"
		hp = 500

		New()
			..()
			var/pix_y = 0
			set_stats(33,3333,33,100,33,100,50,50)
			psionic_power = 1900 * year
			energy = 999999999
			energy_max = 999999999
			strength = 500 * year
			endurance = 1800 * year
			force = 2500 * year
			resistance = 1500 * year
			offence = 1500 * year
			defence = 1000 * year
			mod_agility = 3
			animate(src,pixel_y = 5, time = 20,loop = -1,flags = ANIMATION_PARALLEL + ANIMATION_END_NOW)
			animate(pixel_y = pix_y, time = 10)
			src.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(255,255,128))
			switch(rand(1,99))
				if(55 to 75)
					var/obj/items/misc/platinum_chest/gc = new /obj/items/misc/platinum_chest(src)
					gc.loc = src
					rare_item = gc
				if(2)
					var/obj/items/dokuro_coin/dc = new/obj/items/dokuro_coin(src)
					dc.stacks = pick(5,15,20,40,60)
					dc.loc = src
					rare_item = dc
				if(3)
					var/obj/items/misc/platinum_chest/gc2 = new /obj/items/misc/platinum_chest(src)
					gc2.loc = src
					rare_item = gc2
				if(4 to 15)
					var/obj/items/artifacts/blueprint/bp= new /obj/items/artifacts/blueprint(src)
					bp.loc = src
					rare_item = bp
				if(1)
					var/obj/items/dokuro_coin/dc2 = new/obj/items/dokuro_coin(src)
					dc2.stacks = pick(3,5,10,25,40)
					dc2.loc = src
					rare_item = dc2
				if(16 to 30)
					var/obj/items/consumables/ectoplasm_pure/epe = new /obj/items/consumables/ectoplasm_pure(src)
					epe.loc = src
					rare_item = epe
				if(31 to 54)
					var/obj/items/artifacts/blueprint/en = new /obj/items/artifacts/blueprint(src)
					en.loc = src
					rare_item = en
				if(76 to 90)
					var/obj/items/misc/platinum_chest/gc = new /obj/items/misc/platinum_chest(src)
					gc.loc = src
					rare_item = gc
				if(91 to 99)
					var/obj/items/consumables/ectoplasm_pure/epe = new /obj/items/consumables/ectoplasm_pure(src)
					epe.loc = src
					rare_item = epe
			var/colorz
			switch(rand(1,14))
				if(1)
					colorz=rgb(rand(1,250),rand(1,200),rand(1,250))
				if(2)
					colorz=rgb(rand(20,80),rand(1,200),rand(1,255))
				if(3)
					colorz=rgb(0,rand(80,200),rand(20,255))
				if(4)
					colorz=rgb(rand(1,255),rand(1,20),rand(56,175))
				if(5)
					colorz=rgb(rand(1,60),rand(1,80),rand(1,120))
				if(6)
					colorz=rgb(rand(80,155),0,rand(1,80))
				if(7)
					colorz=rgb(rand(5,253),rand(5,253),rand(5,80))
				if(8)
					colorz=rgb(rand(5,80),rand(5,253),rand(5,253))
				if(9)
					colorz=rgb(rand(5,80),rand(5,80),rand(5,80))
				if(10)
					colorz=rgb(rand(35,153),rand(65,153),rand(95,153))
				if(11)
					colorz=rgb(rand(1,250),rand(1,200),rand(1,250))
				if(12)
					colorz=rgb(rand(0,255),rand(200,255),rand(0,255))
				if(13)
					colorz=rgb(rand(200,255),rand(0,255),rand(0,255))
				if(14)
					colorz=rgb(rand(0,255),rand(0,255),rand(200,255))
			auracolor = colorz

			// Ensure blast exists
			var/obj/skills/Blast/f = new
			f.loc = src
			f.skill_lvl = 25
			src.skill_blast = f

			// IMPORTANT: do NOT run the old movement/chase loop for turrets.
			// Start turret brain immediately:
			src.boss_idle_ai()

	VegetaBoss
		name = "Massive Oozaru (Elite)"
		icon = 'Oozaru_Boss.dmi' // replace
		real_name = "Massive Oozaru (Elite)"
		fullname = "Massive Oozaru (Elite)"
		hp = 500


		New()
			..()
			set_stats(33,3333,33,100,33,100,50,50)
			psionic_power = 1500 * year
			energy = 999999999
			energy_max = 999999999
			strength = 500 * year
			endurance = 2000 * year
			force = 600 * year
			resistance = 1200 * year
			offence = 3000 * year
			defence = 1000 * year
			mod_agility = 2.2
			src.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(255,255,128))
			switch(rand(1,99))
				if(55 to 75)
					var/obj/items/misc/platinum_chest/gc = new /obj/items/misc/platinum_chest(src)
					gc.loc = src
					rare_item = gc
				if(2)
					var/obj/items/dokuro_coin/dc = new/obj/items/dokuro_coin(src)
					dc.stacks = pick(5,15,20,40,60)
					dc.loc = src
					rare_item = dc
				if(3)
					var/obj/items/misc/platinum_chest/gc2 = new /obj/items/misc/platinum_chest(src)
					gc2.loc = src
					rare_item = gc2
				if(4 to 15)
					var/obj/items/artifacts/blueprint/bp= new /obj/items/artifacts/blueprint(src)
					bp.loc = src
					rare_item = bp
				if(1)
					var/obj/items/dokuro_coin/dc2 = new/obj/items/dokuro_coin(src)
					dc2.stacks = pick(3,5,10,25,40)
					dc2.loc = src
					rare_item = dc2
				if(16 to 30)
					var/obj/items/consumables/might_fruit/st = new /obj/items/consumables/might_fruit(src)
					st.loc = src
					rare_item = st
				if(31 to 54)
					var/obj/items/artifacts/blueprint/en = new /obj/items/artifacts/blueprint(src)
					en.loc = src
					rare_item = en
				if(76 to 90)
					var/obj/items/consumables/might_fruit/ep = new /obj/items/consumables/might_fruit(src)
					ep.loc = src
					rare_item = src
				if(91 to 99)
					var/obj/items/consumables/ectoplasm_pure/epe = new /obj/items/consumables/ectoplasm_pure(src)
					epe.loc = src
					rare_item = epe
			var/colorz
			switch(rand(1,14))
				if(1)
					colorz=rgb(rand(1,250),rand(1,200),rand(1,250))
				if(2)
					colorz=rgb(rand(20,80),rand(1,200),rand(1,255))
				if(3)
					colorz=rgb(0,rand(80,200),rand(20,255))
				if(4)
					colorz=rgb(rand(1,255),rand(1,20),rand(56,175))
				if(5)
					colorz=rgb(rand(1,60),rand(1,80),rand(1,120))
				if(6)
					colorz=rgb(rand(80,155),0,rand(1,80))
				if(7)
					colorz=rgb(rand(5,253),rand(5,253),rand(5,80))
				if(8)
					colorz=rgb(rand(5,80),rand(5,253),rand(5,253))
				if(9)
					colorz=rgb(rand(5,80),rand(5,80),rand(5,80))
				if(10)
					colorz=rgb(rand(35,153),rand(65,153),rand(95,153))
				if(11)
					colorz=rgb(rand(1,250),rand(1,200),rand(1,250))
				if(12)
					colorz=rgb(rand(0,255),rand(200,255),rand(0,255))
				if(13)
					colorz=rgb(rand(200,255),rand(0,255),rand(0,255))
				if(14)
					colorz=rgb(rand(0,255),rand(0,255),rand(200,255))
			auracolor = colorz

			// Ensure blast exists
			var/obj/skills/Blast/f = new
			f.loc = src
			f.skill_lvl = 25
			src.skill_blast = f

			// IMPORTANT: do NOT run the old movement/chase loop for turrets.
			// Start turret brain immediately:
			src.boss_idle_ai()
	HeavenBoss
		name = "Meebe (Elite)"
		icon = 'Heaven Boss.dmi' // replace
		real_name = "Meebe (Elite)"
		fullname = "Meebe (Elite)"
		hp = 500

		New()
			..()
			set_stats(33,3333,33,100,33,100,50,50)
			psionic_power = 1500 * year
			energy = 999999999
			energy_max = 999999999
			strength = 1000 * year
			endurance = 1000 * year
			force = 5000 * year
			resistance = 4000 * year
			offence = 2500 * year
			defence = 1000 * year
			mod_agility = 2.8
			src.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(255,255,128))
			switch(rand(1,99))
				if(55 to 75)
					var/obj/items/misc/platinum_chest/gc = new /obj/items/misc/platinum_chest(src)
					gc.loc = src
					rare_item = gc
				if(2)
					var/obj/items/dokuro_coin/dc = new/obj/items/dokuro_coin(src)
					dc.stacks = pick(5,15,20,40,60)
					dc.loc = src
					rare_item = dc
				if(3)
					var/obj/items/misc/platinum_chest/gc2 = new /obj/items/misc/platinum_chest(src)
					gc2.loc = src
					rare_item = gc2
				if(4 to 15)
					var/obj/items/artifacts/blueprint/bp= new /obj/items/artifacts/blueprint(src)
					bp.loc = src
					rare_item = bp
				if(1)
					var/obj/items/dokuro_coin/dc2 = new/obj/items/dokuro_coin(src)
					dc2.stacks = pick(3,5,10,25,40)
					dc2.loc = src
					rare_item = dc2
				if(16 to 30)
					var/obj/items/consumables/ectoplasm_pure/epe = new /obj/items/consumables/ectoplasm_pure(src)
					epe.loc = src
					rare_item = epe
				if(31 to 54)
					var/obj/items/artifacts/blueprint/en = new /obj/items/artifacts/blueprint(src)
					en.loc = src
					rare_item = en
				if(76 to 90)
					var/obj/items/consumables/might_fruit/ep = new /obj/items/consumables/might_fruit(src)
					ep.loc = src
					rare_item = src
				if(91 to 99)
					var/obj/items/consumables/ectoplasm_pure/epe = new /obj/items/consumables/ectoplasm_pure(src)
					epe.loc = src
					rare_item = epe
			var/colorz
			switch(rand(1,14))
				if(1)
					colorz=rgb(rand(1,250),rand(1,200),rand(1,250))
				if(2)
					colorz=rgb(rand(20,80),rand(1,200),rand(1,255))
				if(3)
					colorz=rgb(0,rand(80,200),rand(20,255))
				if(4)
					colorz=rgb(rand(1,255),rand(1,20),rand(56,175))
				if(5)
					colorz=rgb(rand(1,60),rand(1,80),rand(1,120))
				if(6)
					colorz=rgb(rand(80,155),0,rand(1,80))
				if(7)
					colorz=rgb(rand(5,253),rand(5,253),rand(5,80))
				if(8)
					colorz=rgb(rand(5,80),rand(5,253),rand(5,253))
				if(9)
					colorz=rgb(rand(5,80),rand(5,80),rand(5,80))
				if(10)
					colorz=rgb(rand(35,153),rand(65,153),rand(95,153))
				if(11)
					colorz=rgb(rand(1,250),rand(1,200),rand(1,250))
				if(12)
					colorz=rgb(rand(0,255),rand(200,255),rand(0,255))
				if(13)
					colorz=rgb(rand(200,255),rand(0,255),rand(0,255))
				if(14)
					colorz=rgb(rand(0,255),rand(0,255),rand(200,255))
			auracolor = colorz

			// Ensure blast exists
			var/obj/skills/Blast/f = new
			f.loc = src
			f.skill_lvl = 25
			src.skill_blast = f

			// IMPORTANT: do NOT run the old movement/chase loop for turrets.
			// Start turret brain immediately:
			src.boss_idle_ai()

	HellBoss
		name = "Nytmeer (Elite)"
		icon = 'Hell Boss.dmi' // replace
		real_name = "Nytmeer (Elite)"
		fullname = "Nytmeer (Elite)"
		hp = 500

		New()
			..()
			set_stats(33,3333,33,100,33,100,50,50)
			psionic_power = 1500 * year
			energy = 999999999
			energy_max = 999999999
			strength = 8000 * year
			endurance = 1000 * year
			force = 3000 * year
			resistance = 2000 * year
			offence = 4000 * year
			defence = 1000 * year
			mod_agility = 3
			src.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(255,255,128))
			switch(rand(1,99))
				if(55 to 75)
					var/obj/items/misc/platinum_chest/gc = new /obj/items/misc/platinum_chest(src)
					gc.loc = src
					rare_item = gc
				if(2)
					var/obj/items/dokuro_coin/dc = new/obj/items/dokuro_coin(src)
					dc.stacks = pick(5,15,20,40,60)
					dc.loc = src
					rare_item = dc
				if(3)
					var/obj/items/misc/platinum_chest/gc2 = new /obj/items/misc/platinum_chest(src)
					gc2.loc = src
					rare_item = gc2
				if(4 to 15)
					var/obj/items/artifacts/blueprint/bp= new /obj/items/artifacts/blueprint(src)
					bp.loc = src
					rare_item = bp
				if(1)
					var/obj/items/dokuro_coin/dc2 = new/obj/items/dokuro_coin(src)
					dc2.stacks = pick(3,5,10,25,40)
					dc2.loc = src
					rare_item = dc2
				if(16 to 30)
					var/obj/items/consumables/ectoplasm_pure/epe = new /obj/items/consumables/ectoplasm_pure(src)
					epe.loc = src
					rare_item = epe
				if(31 to 54)
					var/obj/items/artifacts/blueprint/en = new /obj/items/artifacts/blueprint(src)
					en.loc = src
					rare_item = en
				if(76 to 90)
					var/obj/items/consumables/might_fruit/ep = new /obj/items/consumables/might_fruit(src)
					ep.loc = src
					rare_item = src
				if(91 to 99)
					var/obj/items/consumables/ectoplasm_pure/epe = new /obj/items/consumables/ectoplasm_pure(src)
					epe.loc = src
					rare_item = epe
			var/colorz
			switch(rand(1,14))
				if(1)
					colorz=rgb(rand(1,250),rand(1,200),rand(1,250))
				if(2)
					colorz=rgb(rand(20,80),rand(1,200),rand(1,255))
				if(3)
					colorz=rgb(0,rand(80,200),rand(20,255))
				if(4)
					colorz=rgb(rand(1,255),rand(1,20),rand(56,175))
				if(5)
					colorz=rgb(rand(1,60),rand(1,80),rand(1,120))
				if(6)
					colorz=rgb(rand(80,155),0,rand(1,80))
				if(7)
					colorz=rgb(rand(5,253),rand(5,253),rand(5,80))
				if(8)
					colorz=rgb(rand(5,80),rand(5,253),rand(5,253))
				if(9)
					colorz=rgb(rand(5,80),rand(5,80),rand(5,80))
				if(10)
					colorz=rgb(rand(35,153),rand(65,153),rand(95,153))
				if(11)
					colorz=rgb(rand(1,250),rand(1,200),rand(1,250))
				if(12)
					colorz=rgb(rand(0,255),rand(200,255),rand(0,255))
				if(13)
					colorz=rgb(rand(200,255),rand(0,255),rand(0,255))
				if(14)
					colorz=rgb(rand(0,255),rand(0,255),rand(200,255))
			auracolor = colorz

			// Ensure blast exists
			var/obj/skills/Blast/f = new
			f.loc = src
			f.skill_lvl = 25
			src.skill_blast = f

			// IMPORTANT: do NOT run the old movement/chase loop for turrets.
			// Start turret brain immediately:
			src.boss_idle_ai()

/proc/FormatSecondsVerbose(var/seconds)
	if(seconds <= 0)
		return "right now"

	var/days = round(seconds / 86400)
	seconds -= days * 86400

	var/hours = round(seconds / 3600)
	seconds -= hours * 3600

	var/minutes = round(seconds / 60)
	seconds -= minutes * 60

	var/list/parts = list()

	if(days > 0) parts += "[days] day[days == 1 ? "" : "s"]"
	if(hours > 0) parts += "[hours] hour[hours == 1 ? "" : "s"]"
	if(minutes > 0) parts += "[minutes] minute[minutes == 1 ? "" : "s"]"
	if(seconds > 0) parts += "[seconds] second[seconds == 1 ? "" : "s"]"

	var/text = ""
	for(var/i = 1; i <= parts.len; i++)
		if(i == 1)
			text = parts[i]
		else
			text += ", [parts[i]]"

	return text

/proc/SecondsUntilNextWorldBossWindow()
	// Current date/time from host
	var/t = time2text(world.realtime, "DDD YYYY-MM-DD hh:mm:ss")

	var/day = copytext(t, 1, 4)
	var/hh = text2num(copytext(t, 17, 19))
	var/mm = text2num(copytext(t, 20, 22))
	var/ss = text2num(copytext(t, 23, 25))

	var/seconds_today = (hh * 3600) + (mm * 60) + ss

	var/list/days = list("Mon","Tue","Wed","Thu","Fri","Sat","Sun")
	var/current_index = days.Find(day)

	if(!current_index) return 0

	// If already Saturday or Sunday
	if(day == "Sat" || day == "Sun")
		return max(1, 86400 - seconds_today)

	// Days until Saturday
	var/days_until = 6 - current_index
	if(days_until < 0) days_until += 7

	return (days_until * 86400) + (86400 - seconds_today)


/proc/GetWorldBossStatusText()
	if(IsWeekend())
		return "World Bosses are ACTIVE today."

	var/seconds = SecondsUntilNextWorldBossWindow()
	var/pretty = FormatSecondsVerbose(seconds)

	return "World Bosses will activate in: [pretty]"

/proc/FindSafeBossRespawn(atom/boss, min_dist = 20, max_dist = 40)
	if(!boss || !boss.loc) return null

	var/z = boss.z

	for(var/i = 1; i <= 50; i++)
		var/x = boss.x + rand(min_dist, max_dist) * pick(-1,1)
		var/y = boss.y + rand(min_dist, max_dist) * pick(-1,1)

		var/turf/T = locate(x, y, z)
		if(T && !T.density)
			return T

	// Fallback: just shove them somewhere guaranteed
	return locate(
		clamp(boss.x + 30, 1, world.maxx),
		clamp(boss.y + 30, 1, world.maxy),
		z
	)


/// TESTING !


var/list/TECH_ITEM_TYPES = list()

/proc/BuildTechItemCache()
	if(TECH_ITEM_TYPES.len) return

	for(var/path in typesof(/obj/items/tech))
		if(path == /obj/items/tech) continue
		if(typesof(path).len > 1) continue // concrete only
		TECH_ITEM_TYPES += path

	world.log << "LootTest: Cached [TECH_ITEM_TYPES.len] tech items."


/proc/GenerateFakeRollers(var/count = 3)
	var/list/fakes = list()

	for(var/i = 1 to count)
		fakes += "fake_player_[rand(1000,9999)]"

	return fakes

/datum/loot_roll
	var/list/fake_ckeys = list()
	var/list/fake_names // ckey → display name

/datum/loot_roll/proc/InjectFakeRolls()
	for(var/ck in fake_ckeys)
		var/choice = pick("need","greed","pass")

		switch(choice)
			if("need")
				var/r = rand(1,100)
				need[ck] = r
				BroadcastRoll("[fake_names[ck]] rolled <b>NEED</b> ([r])",null)

			if("greed")
				var/r = rand(1,100)
				greed[ck] = r
				BroadcastRoll("[fake_names[ck]] rolled <b>GREED</b> ([r])",null)

			if("pass")
				pass += ck
				BroadcastRoll("[fake_names[ck]] passed.",null)
