/*/mob/proc/show_admin_panel()
	var/html = {"
	<html>
	<head>
	<style>
		body {
			background: #0b0e14;
			color: #d6d6d6;
			font-family: Verdana;
		}
		h1 {
			text-align: center;
			color: #ff4444;
		}
		.section {
			border: 1px solid #333;
			border-radius: 6px;
			padding: 10px;
			margin-bottom: 12px;
			background: #141820;
		}
		.section-title {
			text-align: center;
			color: #ffaa00;
			font-weight: bold;
			margin-bottom: 8px;
		}
		.admin-btn {
			display: block;
			padding: 6px;
			margin: 4px 0;
			background: #222;
			border: 1px solid #555;
			color: white;
			text-decoration: none;
			text-align: center;
		}
		.admin-btn:hover {
			background: #444;
		}
	</style>
	</head>
	<body>

	<h1>ADMINISTRATIVE CONSOLE</h1>

	<div class='section'>
		<div class='section-title'>World Control</div>
		<a class='admin-btn' href='?src=\ref[src];admin_cmd=Announce'>Announce</a>
		<a class='admin-btn' href='?src=\ref[src];admin_cmd=Shutdown'>Shutdown</a>
	</div>

	<div class='section'>
		<div class='section-title'>Player Control</div>
		<a class='admin-btn' href='?src=\ref[src];admin_cmd=Heal'>Heal</a>
		<a class='admin-btn' href='?src=\ref[src];admin_cmd=Revive'>Revive</a>
		<a class='admin-btn' href='?src=\ref[src];admin_cmd=Kill'>Kill</a>
	</div>

	<div class='section'>
		<div class='section-title'>Items</div>
		<a class='admin-btn' href='?src=\ref[src];admin_cmd=Create_Item'>Create Item</a>
		<a class='admin-btn' href='?src=\ref[src];admin_cmd=Delete'>Delete Object</a>
	</div>

	</body>
	</html>
	"}

	src << browse(html, "window=admin_panel;size=520x600")
	*/
/mob/proc/DeleteExistingSkills()
    set background = 1
    //set waitfor = 0
    src.disable_skills()

    src.skill_wrestle = null
    src.skill_meditation = null
    src.skill_active_meditation = null
    src.skill_gather = null
    src.skill_hunt = null
    src.skill_attack = null
    src.skill_block = null
    src.skill_super_speed = null
    src.skill_remote_viewing = null
    src.skill_touch_of_death = null
    src.skill_psi_clone = null
    src.skill_mage_pot = null
    src.skill_divine_weapon = null
    src.skill_flight = null
    src.skill_shieldeyes = null
    src.skill_profusion = null
    src.skill_power_control = null
    src.skill_levitation = null
    src.skill_obfuscation = null
    src.skill_explosion = null

    src.skill_beam = null
    src.skill_stance = null
    src.skill_blast = null
    src.skill_run = null
    src.skill_charge = null
    src.skill_breathing = null
    src.skill_sense = null
    src.skill_ki_fist = null
    src.skill_ki_blade = null

    src.skill_control_oozaru = null
    src.skill_control_rampage = null

    src.skill_createdbs = null
    src.skill_sleep = null
    src.skill_study = null
    src.skill_hone = null
    src.skill_focus = null
    src.skill_invis = null
    src.skill_teleport = null
    src.skill_cyberize = null
    src.skill_lightning = null
    src.skill_lightning_storm = null

    src.skill_dig = null
    src.skill_divine_infusion = null
    src.skill_cleanse = null
    src.skill_dark_infusion = null
    src.skill_dark_petrifaction = null

    src.skill_telepathy = null
    src.skill_tk = null

    src.skill_restoration = null
    src.skill_reformation = null
    src.skill_revive = null

    src.skill_quicksilver = null
    src.skill_kaioken = null
    src.skill_kaioenjin = null

    src.skill_reprieve = null
    src.skill_majinize = null
    src.skill_mysticize = null
    // delete real skills
    for(var/obj/skills/S in src)

        qdel(S)
        sleep(world.tick_lag) // spreads load

    sleep(2) // let BYOND clean refs



    // rebuild HUD
    if(src.hud_skills)
        qdel(src.hud_skills)

        sleep(world.tick_lag) // spreads load
        var/obj/hud/menus/skills_background/skl = new
        src.hud_skills = skl
        skl.loc = src
        skl.menu_create()

    src << "Skills Deleted.(Please give it a few seconds for the hud to rebuild.)"

/mob/proc/RefreshExistingSkills()
    set background = 1
    //set waitfor = 0
    var/list/rebuild = list()
    src.disable_skills()
    // Save skill data
    for(var/obj/skills/S in src)

        if(S.type == /obj/skills/AA_Skill_Copy)
            continue

        var/list/d = list()
        d["type"] = S.type
        d["skill_lvl"] = S.skill_lvl
        d["skill_exp"] = S.skill_exp

        rebuild += list(d)

        // remove HUD clone safely
        if(S.clone)
            del(S.clone)
        sleep(world.tick_lag) // spreads load

    // delete real skills
    for(var/obj/skills/S in src)
        if(S.type != /obj/skills/AA_Skill_Copy)
            qdel(S)
            sleep(world.tick_lag) // spreads load

    sleep(2) // let BYOND clean refs

    // rebuild ONLY what player had
    for(var/list/d in rebuild)

        var/path = d["type"]

        var/obj/skills/N = new path(src)
        N.loc = src

        N.skill_lvl = d["skill_lvl"]
        N.skill_exp = d["skill_exp"]
        sleep(world.tick_lag) // spreads load

    // rebuild HUD
    if(src.hud_skills)
        qdel(src.hud_skills)

        sleep(world.tick_lag) // spreads load
        var/obj/hud/menus/skills_background/skl = new
        src.hud_skills = skl
        skl.loc = src
        skl.menu_create()

    src << "Skills refreshed.(Please give it a few seconds for the hud rebuild)"

/*mob/proc/RefreshExistingSkills()
    set background = 1
    set waitfor = 0   // critical

    var/list/rebuild = list()

    // save skills
    for(var/obj/skills/S in src)

        if(S.type == /obj/skills/AA_Skill_Copy)
            continue

        rebuild += list(list(
            "type" = S.type,
            "lvl" = S.skill_lvl,
            "exp" = S.skill_exp
        ))

        if(S.clone)
            del(S.clone)

        sleep(world.tick_lag) // spreads load

    // delete skills slowly
    for(var/obj/skills/S in src)

        if(S.type == /obj/skills/AA_Skill_Copy)
            continue

        del(S)

        sleep(world.tick_lag)

    sleep(2)

    // rebuild slowly
    for(var/list/d in rebuild)

        var/obj/skills/N = new d["type"](src)

        N.skill_lvl = d["lvl"]
        N.skill_exp = d["exp"]

        sleep(world.tick_lag)

    // rebuild HUD last
    if(src.hud_skills)

        del(src.hud_skills)

        sleep(1)

        var/obj/hud/menus/skills_background/skl = new

        src.hud_skills = skl

        skl.loc = src

        skl.menu_create()

    src << "Skills refreshed."*/
/proc/RoleplaySpyLog(message, is_emote = FALSE)
    for(var/client/C)
        if(!C) continue
        if(C.mob.key in StaffTeam)
            if(is_emote)
                C << output(message, "roleplay_spy.output_emotes")
                C << output(message, "roleplay_spy.output_general")
            else
                C << output(message, "roleplay_spy.output_general")

/mob/proc/show_admin_panel()
	var/level = src.client.admin_level
	var/html = ""

	html += {"
	<html>
	<head>
	<style>
		body { background:#0b0e14; color:#d6d6d6; font-family:Verdana; }
		h1 { text-align:center; color:#ff4444; }
		.section {
			border:1px solid #333;
			border-radius:6px;
			padding:10px;
			margin-bottom:12px;
			background:#141820;
		}
		.section-title {
			text-align:center;
			color:#ffaa00;
			font-weight:bold;
			margin-bottom:8px;
		}
		.admin-btn {
			display:block;
			padding:6px;
			margin:4px 0;
			background:#222;
			border:1px solid #555;
			color:white;
			text-decoration:none;
			text-align:center;
		}
		.admin-btn:hover { background:#444; }
	</style>
	</head>
	<body>
	<h1>ADMINISTRATIVE CONSOLE</h1>
	"}

	// =========================
	// WORLD CONTROL
	// =========================
	html += "<div class='section'><div class='section-title'>World Control</div>"
	if(level >= 1)
		html += AdminButton("Announce","Announce")
		html += AdminButton("Spy_Roleplay","Spy Roleplay")
		html += AdminButton("Toggle_Global_OOC","Toggle Global OOC")
		html += AdminButton("Check_CPU","Check CPU")
		html += AdminButton("Purge_Lag","Purge Lag")

	if(level >= 2)
		html += AdminButton("Shutdown","Shutdown")
		html += AdminButton("Reboot","Reboot")
	html += "</div>"

	// =========================
	// PLAYER CONTROL
	// =========================
	html += "<div class='section'><div class='section-title'>Player Control</div>"
	if(level >= 1)
		html += AdminButton ("Rename_Player","Rename Player")
		html += AdminButton ("Admin_Telepathy","Admin Telepathy")
		html += AdminButton("Heal","Heal")
		html += AdminButton("Heal_Everything","Heal Everything")
		html += AdminButton("Revive","Revive")
		html += AdminButton("Kill","Kill")
		html += AdminButton("Knockout","Knockout")
		html += AdminButton("Observe","Observe")
		html += AdminButton("Goto","Goto")
		html += AdminButton("Bring","Bring")
		html += AdminButton("Ban","Ban")
		html += AdminButton("Boot","Boot")
		html += AdminButton("Damage_Limb","Damage Limb")
		html += AdminButton("Remove_Limb","Remove Limb")
		html += AdminButton("Restore_Limb","Restore Limb")
		html += AdminButton("Mute","Mute")
		html += AdminButton("Ban","Ban")
		html += AdminButton("Send_To_Spawn","Send To Spawn")
		html += AdminButton("Reset_Player_Technology","Reset Player Technology")
		html += AdminButton("Reset_Player_Inventory", "Reset Player Inventory")
		html += AdminButton("Refresh_Player_Skills","Reset Player Skills")
		html += AdminButton("Delete_Player_Skills","Delete Player Skills")
		html += AdminButton("Manage_Mutations","Manage Mutations")


	if(level >= 2)
		html += AdminButton("Change_Icon","Change Icon")
		html += AdminButton("Assess","Assess")
		html += AdminButton("Edit_Age","Edit Age")
		html += AdminButton("Debug_Player_Technology","Debug Player Tech")
		html += AdminButton("Planet_Teleport","Planet Teleport")
	if(level >= 3)
		html += AdminButton("Manage_Technology","Manage Technology")
		html += AdminButton("Force_Transformation","Force Transformation")
	html += "</div>"
	// =========================
	// FIX/CLIENT
	// =========================
	html += "<div class='section'><div class='section-title'>Fixes</div>"
	if(level >= 1)

		html += AdminButton("Clear_Known_Names", "Clear Known Names")
		html += AdminButton("Fix_Icon","Fix Icon")
		html += AdminButton("Fix_Screen_Offset","Fix Screen Offset")
		html += AdminButton("Force_Resolution_Fix","Force Resolution Fix")
	if(level >=4)
		html += AdminButton("Clear_Tech_List","Clear Tech List")
	html += "</div>"


	// =========================
	// ITEMS
	// =========================
	html += "<div class='section'><div class='section-title'>Items</div>"
	if(level >= 1)
		html += AdminButton("Delete","Delete Object")
	if(level >= 3)
		html += AdminButton("Create_Item","Create Item")
	if(level >= 4)
		html += AdminButton("Create_Custom_Icon_Object","Create Custom Icon Object")
	html += "</div>"

	// =========================
	// ECONOMY / STATS
	// =========================
	html += "<div class='section'><div class='section-title'>Economy / Stats</div>"
	if(level >= 3)
		html += AdminButton("Edit","Edit")
		html += AdminButton("Global_CFT","Global CFT")
		html += AdminButton("Give_RPPs","Give RPPs")
		html += AdminButton("Give_Zenni","Give Zenni")
		html += AdminButton("Increase_Stats","Increase Stats")
		html += AdminButton("Increase_HTT","Increase HTT")
		html += AdminButton("Restore_Artifacts","Restore Artifacts")


	html += "</div>"

	// =========================
	// RANKS
	// =========================
	if(level >= 2)
		html += "<div class='section'><div class='section-title'>Ranks</div>"
		html += AdminButton("Set_Rank","Set Rank")
		html += AdminButton("Remove_Rank","Remove Rank")
		if(level >=3) html += AdminButton("Edit_Roleplay_Rank","Edit Roleplay Rank")
		html += "</div>"

	// =========================
	// OWNER ONLY
	// =========================
	if(level >= 4)
		html += "<div class='section'><div class='section-title'>Owner</div>"
		html += AdminButton("Give_Dokuro_Coins","Give Dokuro Coins")
		html += AdminButton("Give_Accelerated_Gains","Give Accelerated Gains")
		html += AdminButton("World_Boss_Control", "Spawn World Bosses")
		html += AdminButton("Test_Loot_Roll","Loot Roll(TEST/DEBUG)")
		html += AdminButton("Grant_Vote_Mute_Access","Grant Vote Mute Access")
		html += AdminButton("Give_LSSJ","Give LSSJ")
		html += "</div>"


	html += "</body></html>"

	src << browse(html, "window=admin_panel;size=520x720")


/mob/proc/AdminButton(cmd, label)
	return "<a class='admin-btn' href='?src=\\ref[src];admin_cmd=[cmd]'>[label]</a>"

/mob/proc/RunAdminCommand(cmd)
	if(!(src.key in StaffTeam))
		src << "Access denied."
		return

	var/list/race_mobs = list()
	for(var/mob/races/R in world)
		if(R.started || R.client || R.loc)
			race_mobs += R
	if(!race_mobs.len) return

	switch(cmd)
	// =========================================================
	// BOOT / REBOOT / BAN // WORLD CONTROL
	// =========================================================
		if("Purge_Lag")
			switch(alert(src,"Are you purging specific mobs for lag or everything?","","Specific","Everything"))
				if("Specific")
					var/specific = input("Type the name of the mob exactly you wish to erase") as text
					world<<"<b>World Refreshing..</b>"
					var/list/race_placeholders = list(
						"Human",
						"Saiyan",
						"Yukopian",
						"Spiritdoll",
						"Makyo",
						"Imp",
						"Celestial",
						"Demon",
						"Changeling",
						"Tuffle",
						"Android",
						"Alien"
					)
					var/count = 0

					for(var/mob/m in world)
						if(!m) continue
						if(m.npc) continue
						if(m.client) continue
						if(m.name in race_placeholders) continue   // skip race preview mob




						if(m.name == "[specific]")
							count++
							world.log<<"[m] Deleted for Purge(LAG)"
							del(m)

					world << "<b>World Refreshed! ([count] misc. deleted)</b>"

				if("Everything")
					world<<"<b>World Refreshing..</b>"
					var/list/race_placeholders = list(
						"Human",
						"Saiyan",
						"Yukopian",
						"Spiritdoll",
						"Makyo",
						"Imp",
						"Celestial",
						"Demon",
						"Changeling",
						"Tuffle",
						"Android",
						"Alien"
					)

					var/count = 0
					for(var/mob/m in world)
						if(!m) continue
						if(m.npc) continue
						if(m.client) continue
						if(m.name in race_placeholders) continue   // skip race preview mob

						count++
						world.log<<"[m] Deleted for Purge(LAG)"
						del(m)
						sleep(1)
					world << "<b>World Refreshed! ([count] misc. deleted)</b>"



		if("Check_CPU")
			src << "CPU: [world.cpu] | Tick Usage: [world.tick_usage]"
			return
		if("Boot")
			var/mob/races/choice = input("Select a player:") as null|anything in race_mobs
			if(!choice) return
			world << "[choice] was booted."
			choice.client.images = null
			spawn(10) winset(choice, null, "command=.quit")
			choice.client.Del()
			world.log << "(Admin Log): [src.client.admin_name] [src] booted [choice]"
			return
		if("Reboot")
			world << "<span class=\"announce\"><font color=green><b>(MANUAL) Rebooting in 30 seconds!</b></font></span>"
			sleep(300)
			//world << "<span class=\"announce\"><font color=green><b><u>Saving and Rebooting World</u></b></font></span>"
			//  P.Save_Player_Data() // Save player data asynchronously
			//file("AdminLog.log")<<"[usr]([usr.key]) rebooted at [time2text(world.realtime,"Day DD hh:mm")] \n"
			rebooting = 1
			world.quick_save_players()
			sleep(1)
			world.Save_All()
			sleep(1)

			spawn(20)
				world.Reboot()
			return
		if("Ban")
			var/mob/races/choice = input("Select a player:") as null|anything in race_mobs
			if(!choice) return
			switch(alert(src,"Are you sure you wish to ban [choice]?","","Yes","No"))
				if("Yes")
					choice.client.screen += new /obj/bannedbackground
					ban_list += "[choice.client.computer_id]"
					world << "[choice.key] has been <font color=red><b>BANNED</b></font>"
					sleep(10)
					choice.Logout()
					world << output("<font color=yellow>(Admin Log): [src] banned [choice]","rpspy.output2")
			return
	// =========================
	// CORE / SAFETY
	// =========================

		if("Delete")
			src.set_alert("Select something to delete",'alert.dmi',"alert")
			src << "<b>ADMIN:</b> Select something to delete"
			src.left_click_function = "delete stuff"
			return
		if("Create_Item")
			var/typepath = input(src,"Select an item to create:","Admin Item Creation") as null|anything in ALL_ITEM_TYPES
			if(!typepath) return
			var/obj/items/I = new typepath(src.loc)
			I.alpha = 0
			I.pixel_z = 32
			I.level = src.intxp
			I.tech_lvl = src.intxp
			animate(I, alpha = 255, pixel_z = initial(I.pixel_z), time = 2, easing = BOUNCE_EASING)
			world.log << "(Admin Log): [src.key] created [I]"
			return
	// =========================
	// COMMUNICATION
	// =========================

		if("Admin_Chat")
			if(!src.service_lvl)
				src << "Only administrators may use this command."
				return
			var/msg = input("Admin Chat:") as text
			if(!msg) return
			for(var/mob/M in players)
				if(M.service_lvl)
					M << "<font size=2><b><font color=#CB0739>(AdminChat)[src.key]([src.client.admin_name]):</font> <font color=white>[msg]</font>"
			return
		if("Announce")
			var/announce = input("What are you announcing?") as text
			if(!announce) return
			world << "<center>[src.client.admin_name] announces:<br>----------------<br>[announce]<br>----------------</center>"
			world.log << "(Admin Log): [src.client.admin_name] used Announce"
			return
	// =========================
	// PLAYER CONTROL
	// =========================

		if("Change_Icon")
			var/mob/races/choice = input("Select a player:") as null|anything in race_mobs
			var/newicon = input(src, "Select icon file") as icon|null
			if(newicon) choice.icon = newicon
			world.log << "(Admin Log):[choice] icon was changed by [usr.client.admin_name]"



		if("Rename_Player")
			var/mob/races/choice = input("Select a player:") as null|anything in race_mobs
			var/newname = input("What will be their new name?") as text
			switch(alert(usr,"Are you sure you wish rename [choice] to [newname]?","","Yes","No"))
				if("Yes")
					world.log << "(Admin Log):[choice] name was changed to [newname] by [usr.client.admin_name]"

					choice.fullname = newname
					choice.name = newname
					choice.real_name = newname
		if("Admin_Telepathy")
			var/mob/races/choice = input("Select a player:") as null|anything in race_mobs
			if(!choice) return
			var/msg = input ("Message to: [choice]:") as text
			if(msg)
				choice<<"<font color=##89A7E2><u>Admin Telepathy:</u> [msg]"
				for(var/mob/M in players)
					if(M.service_lvl)
						M<<"<font color=##89A7E2><u>([src.key]) Admin Telepathy to [choice]:</u> [msg]"
					return
		if("Send_To_Spawn")
			var/mob/races/choice = input("Select a player:") as null|anything in race_mobs
			if(!choice) return
			switch(alert(src,"Are you sure you want to send them to their spawn point?","","Yes","No"))
				if("Yes")
					switch(choice.home_planet)
						if("Icer")
							choice.loc = locate(450/rand(1,5),450/rand(1,5),9)
						if("Namek")
							choice.loc = locate(450/rand(1,5),450/rand(1,5),4)
						if("Vegeta")
							choice.loc = locate(450/rand(1,5),450/rand(1,5),10)
						if("Earth")
							choice.loc = locate(450/rand(1,5),450/rand(1,5),1)
						if("Hell")
							choice.loc = locate(450/rand(1,5),450/rand(1,5),6)
						if("Heaven")
							choice.loc = locate(450/rand(1,5),450/rand(1,5),11)
						if("Checkpoint")
							choice.loc = locate(130,449,2)
					src<<"[choice] was sent to their home planet([choice.home_planet])"
					if(choice.in_space_ship) choice.in_space_ship = 0
					if(choice.in_space_pod) choice.in_space_pod = 0
			return
		if("Grant_Vote_Mute_Access")
			var/mob/races/choice = input("Select a player:") as null|anything in race_mobs
			if(!choice) return
			if(choice.has_vote_mute>=1)
				src<<"[choice] already has vote mute access!"
				return
			choice.has_vote_mute = 1
			choice<<"<b>You were granted access to Vote Mute. (use /votem to  start a vote)</b>"
			src<<"You granted them access to Vote Mute!"
			world.log << "(Admin Log): [src.client.admin_name] gave [choice] vote mute"
			return
		if("Heal")
			var/mob/races/choice = input("Select a player:") as null|anything in race_mobs
			if(!choice) return
			if(choice.percent_health <=1 || choice.koed || choice.icon_state == "KO")
				choice.KO(0,1)
			sleep(1)
			choice.percent_health = 100
			choice.energy = choice.energy_max
			choice.stunned = 0
			choice.stunned_pending = 0
			world.log << "(Admin Log): [src.client.admin_name] healed [choice]"

		if("Heal_Everything")
			var/mob/choice = input("Select a player:") as null|mob in race_mobs
			if(!choice) return
			if(choice.koed || choice.icon_state == "KO" || choice.percent_health <=1)
				choice.KO(0,1)
			sleep(1)
			choice.percent_health = 100
			choice.energy = choice.energy_max
			choice.thirst = 99
			choice.hunger = 99
			choice.toxicity = 0
			choice.restedness = 99
			choice.stunned = 0
			choice.stunned_pending = 0
			if(choice.heal_all_limbs())
				choice << "Your [choice] has been fully healed by an admin."
			world.log << "(Admin Log): [src.client.admin_name] healed everything of [choice]"

		if("Revive")
			var/mob/choice = input("Select a player:") as null|mob in players
			if(!choice || !choice.dead) return
			choice.Revive()
			choice.percent_health = 100
			choice.energy = choice.energy_max
			choice.thirst = 99
			choice.hunger = 99
			choice.restedness = 99
			choice.toxicity = 0
			choice.disable_skills()
			choice.check_glow_planes()
			world.log << "(Admin Log): [src.client.admin_name] revived [choice]"

		if("Kill")
			var/mob/races/choice = input("Select a player:") as null|anything in race_mobs
			if(!choice) return
			if(!choice.dead)
				choice.KO()
				sleep(2)
				choice.Death("Admin Killed")
			else
				src.set_alert("[choice] is already dead.",'alert.dmi',"alert")
			world.log << "(Admin Log): [src.client.admin_name] killed [choice]"

		if("Knockout")
			var/mob/races/choice = input("Select a player:") as null|anything in race_mobs
			if(choice)
				choice.KO()
				world.log << "(Admin Log): [src.client.admin_name] KO'd [choice]"

		if("Observe")
			var/mob/races/choice = input("Select a player:") as null|anything in race_mobs
			if(!choice) return
			src.client.perspective = EYE_PERSPECTIVE | EDGE_PERSPECTIVE
			src.client.eye = choice
			world.log << "(Admin Log): [src.client.admin_name] observed [choice]"

		if("Ban")
			var/mob/races/choice = input("Select a player:") as null|anything in race_mobs
			if(!choice) return

			switch(alert(src,"Are you sure you wish to ban [choice]?","","Yes","No"))
				if("Yes")

					choice.ban_count += 1

					// Add to ban list
					if(choice.client)
						ban_list += "[choice.client.computer_id]"

					choice.client.screen += new /obj/bannedbackground

					world << "<font color=red><b>[choice.key] has been BANNED.</b></font>"
					world.log << "(Admin Log): [src.client.admin_name] banned [choice] (Total Bans: [choice.ban_count])"

					sleep(10)
					choice.Logout()

		if("Mute")
			var/mob/races/choice = input("Select a player to mute/unmute:") as null|anything in race_mobs
			if(!choice) return

			if(choice.muted)
				switch(alert(src,"[choice] is currently muted.\nDo you want to unmute them?","","Unmute","Cancel"))
					if("Unmute")
						choice.muted = 0
						world << "<font color=yellow>[choice] has been unmuted by an administrator.</font>"
						world.log << "(Admin Log): [src.client.admin_name] unmuted [choice]"
			else
				switch(alert(src,"Mute [choice]?","","Yes","Cancel"))
					if("Yes")
						choice.muted = 1
						choice.mute_count += 1
						world << "<font color=orange>[choice] has been muted by an administrator.</font>"
						world.log << "(Admin Log): [src.client.admin_name] muted [choice] (Total Mutes: [choice.mute_count])"


	// =========================
	// TELEPORT
	// =========================

		if("Goto")
			var/mob/races/choice = input("Select a player:") as null|anything in race_mobs
			if(!choice) return
			src.projection.loc = locate(choice.x, choice.y+1, choice.z)
			src.check_glow_planes()
			world.log << "(Admin Log): Goto used on [choice]"

		if("Bring")
			var/mob/races/choice = input("Select a player:") as null|anything in race_mobs
			if(!choice) return
			choice.loc = locate(src.projection.x, src.projection.y-1, src.projection.z)
			choice.check_glow_planes()
			world.log << "(Admin Log): Bring used on [choice]"

	// =========================
	// ECONOMY / RP
	// =========================
		if("Restore_Artifacts")
			switch(alert(src,"Are you sure you wish to restore artifacts?\nNote: Please do not use this just because one planet is lacking, if there are abundant on another planet they are expected to wait for the monthly respawns.","","Yes","No"))
				if("Yes")
					world<<"Admin is restoring artifacts in 10 seconds."
					spawn(10)
						world.Respawn_Artifacts()

		if("Give_RPPs")
			var/mob/choice = input("Select a player:") as null|mob in players
			var/amount = input("How much RPPs?") as num
			if(amount > 0)
				choice.roleplay_points += amount
				choice.total_rpps_gained += amount
				choice << "You were given [amount] RPPs."

				world.log << "(Admin Log): Gave RPPs"

		if("Give_Zenni")
			var/mob/choice = input("Select a player:") as null|mob in players
			var/amount = input("How much Zenni?") as num
			if(amount > 0)
				choice.resources += amount
				choice.refresh_inv()

	// =========================
	// WORLD
	// =========================
		if("Global_CFT")
			if(!cftglobal)
				switch(alert(src,"Do you wish to unlock global CFT? This will give everyone an infinite amount of Cycle Free Time until it is toggled off.","","Yes","No"))
					if("Yes")
						cftglobal = 1
						for(var/mob/races/p in players)
							if(p)
								p.cycle_free_time = 25
								if(p.hud_cft == null)
									var/obj/hud/menus/cft_gains_txt/cftb = new
									p.hud_cft = cftb
									p.hud_cft.cycler = src
									if(p.cycle_free_time) p.client.screen += p.hud_cft
								else
									p.client.screen -= p.hud_cft
									p.client.screen += p.hud_cft
								p<<output("<b><font color=yellow>You were granted Cycle Free Time! <i>Note: Resilience is disabled during this time, offering you an opportunity to train stats without tire.</font></b>","actionoutput")
						world<<"<b><font color=#68D9FF>Global Cycle Free Time Activated!</b></font>"
						return
			else
				cftglobal = 0
				for(var/mob/races/p in players)
					if(p)
						p.cycle_free_time = 0
						if(p.hud_cft == null)
							var/obj/hud/menus/cft_gains_txt/cftb = new
							p.hud_cft = cftb
							p.hud_cft.cycler = src
							if(p.cycle_free_time) p.client.screen -= p.hud_cft
						else
							p.client.screen -= p.hud_cft
				world<<"<b><font color=#68D9FF>Global Cycle Free Time Deactivated!</b></font>"
				return

		if("Spy_Roleplay")
			winshow(src, "rpspy", TRUE)
		if("Toggle_Global_OOC")
			global.ooc_on = !global.ooc_on
			world << "<b>Global OOC: [global.ooc_on ? "<font color=green>ON</font>" : "<font color=red>OFF</font>"]</b>"

		if("Shutdown")
			if(alert(src,"Really Shutdown the server?","","Yes","No") == "Yes")
				world << "Shutting Down Server in 10 seconds!"
				sleep(100)
				for(var/mob/m in players)
					m.Logout()
				world.Del()

		// =========================================================
		// EDITING / VIEWING
		// =========================================================
		if("Assess")
			var/mob/choice = input("Select a player:") as null|mob in race_mobs
			if(!choice) return

			var/S = choice.bodysize
			if(S == 1) S = "Small"
			if(S == 2) S = "Medium"
			if(S == 3) S = "Large"

			var/A = {"
			<html>
			<style type="text/css">
			<!--
			body {
			     color:#449999;
			     background-color:black;
			     font-size:12;
			 }
			table {
			     font-size:12;
			 }
			//-->
			</style>
			<body>
			[(choice)]<br>
			Current Anger: [choice.anger]%<br>
			<table cellspacing="6%" cellpadding="1%">
			<tr><td><font color=white><b>Compensation Minutes | Standing Minutes:</b></font></td><td>Comp. Gains: [choice.offline_gains] minutes | Standing Gains: [choice.standing_gains_timer] second</td></tr>
			<tr><td><font color=white><b>Current HTTG:</b></font></td><td>(H:[choice.hunger] T:[choice.thirst] T:[choice.restedness])</td></tr>
			<tr><td><font color=white><b>Resilliences:</b></font></td><td> (Training)[choice.trainres]--[choice.max_trainres]| (Meditation)[choice.medres]--[choice.max_medres]| (Sparring)[choice.sparres]/[choice.max_sparres]| (Blasting)[choice.blastres]/[choice.max_blastres]</td></tr>
			<tr><td><font color=white><b>Ratings:</b></font></td><td>[choice.rating]</td></tr>
			<tr><td><font color=white><b>Move Lv:</b></font></td><td>[choice.move_lvl] Exp:([choice.movelvl_exp]/1000)</td></tr>
			<hr>
			<tr><td><font color=white><b>Health:</b></font></td><td>[choice.hp]</td></tr>
			<hr>
			<tr><td>Race(s):</td><td>[choice.race] | [choice.recessive_race]</td></tr>
			<tr><td>Race Class:</td><td>[choice.race_class]</td></tr>
			<tr><td>Key:</td><td>[choice.key]</td></tr>
			<tr><td>Body Size:</td><td>[S]</td></tr>
			<tr><td>Age:</td><td>[choice.age] ([choice.age_soul] True Age)</td></tr>
			<tr><td>Generation:</td><td>[choice.generation_lvl]</td></tr>

			<tr><td>Body:</td><td>[choice.Body*100]% ([choice.oldage] Decline) - Prime Age: ([choice.prime]) </td></tr>
			<tr><td>Base:</td><td>[choice.psionic_power_base] ([choice.mod_psionic_power])</td></tr>
			<tr><td>Current PL:</td><td>[Commas(choice.psionic_power)]</td></tr>
			<tr><td>Lift:</td><td>[round((choice.strength+choice.endurance*4)*0.45359237)*0.01] kg ([round(choice.strength+choice.endurance*4)*0.01] lbs)</td></tr>
			<tr><td>Energy:</td><td>[choice.energy]/[round(choice.energy_max)] Mod.([choice.mod_energy])</td></tr>
			<tr><td>Strength:</td><td>[choice.strength] Mod.([choice.mod_strength]) </td></tr>
			<tr><td>Endurance:</td><td>[choice.endurance] Mod.([choice.mod_endurance])</td></tr>
			<tr><td>Speed:</td><td>x[choice.mod_agility]</td></tr>
			<tr><td>Force:</td><td>[choice.force] Mod.([choice.mod_force])</td></tr>
			<tr><td>Resistance:</td><td>[round(choice.resistance)] Mod.([choice.mod_resistance])</td></tr>
			<tr><td>Offense:</td><td>[choice.offence] Mod.([choice.mod_offence])</td></tr>
			<tr><td>Defense:</td><td>[choice.defence] Mod.([choice.mod_defence])</td></tr>
			<tr><td>Regeneration:</td><td>[choice.mod_regeneration]</td></tr>
			<tr><td>Recovery:</td><td>[choice.mod_recovery]</td></tr>
			<tr><td>Gravity:</td><td>x[round(choice.gravity_mastered)]</td></tr>
			<tr><td>Anger:</td><td>[choice.max_anger]%</td></tr>
			<tr><td>Intelligence:</td><td>([choice.intxp]%) Mod([choice.mod_tech_potential])</td></tr>
			<tr><td>Magic:</td><td>([choice.magicxp]%) Mod([choice.mod_arcane_potential])</td></tr>
			<tr><td>Energy Signature:</td><td>[choice.signature]</td></tr>
			<tr><td>PG/PG Mult: [choice.PG] - [round(choice.rating_mult)]x</td></tr>
			<tr><td>Cycle Free Time:[choice.cycle_free_time]</td></tr>
			<tr><td>Final Power Level Mod:[choice.final_powerlevel_mod]</td></tr>
			</table>
			"}

			A += "<br><font color=red><b><u>Mutations</b></u><br>"
			for(var/mutations/X in choice.mutations)
				A += "<font color=red>[X.info_name] - [X.info]<br>"

			src << "[A]"
			src << browse(A, "window=[(choice)];size=700x600")
			world.log << "(Admin Log): [src.client.admin_name] [src] used ASSESS on [choice]"

		if("Edit")
			//var/mob/races/choice = input("Select a player:") as null|anything in race_mobs
			var/mob/choice = input("Select a player:") as null|anything in race_mobs
			if(!choice) return
			var/D = null
			if(ismob(choice))
				D = choice.desc
				choice.desc = null
				src.client << link("?command=edit;target=\ref[choice];type=view;")
			if(D) if(ismob(choice))
				choice.desc = D
				world.log << "(Admin Log): [src.client.admin_name] used Edit on [choice]"

		if("Edit_Age")
			var/mob/choice = input("Select a player:") as null|obj|mob in players
			if(!choice) return
			var/age = input("Physical age?") as num
			var/soul = input("Soul Age?") as num
			choice.age = age
			choice.age_soul = soul
			choice << "Your age was changed by an admin."
			choice.update_body_age()
			choice.beard_checker()
			return

		if("Edit_Roleplay_Rank")
			var/mob/choice = input("Select a player:") as null|mob in players
			if(!choice) return
			var/amount = input("What rank are you making them?\n\n1: Rank F\n2: Rank E\n3: Rank D\n4: Rank C\n5: Rank B\n6: Rank A\n7: Rank S\n8: Rank SS\n9: Rank SSS") as num
			choice.give_roleplayrank(amount)
			choice << "Your RP Rank was adjusted by admins!"
			return

		// =========================================================
		// FIXES / CLIENT / ICONS
		// =========================================================
		if("Debug_Player_Technology")
			var/mob/races/M = input("Select a player:") as null|anything in race_mobs
			if(!M) return

			src << "---- TECH DEBUG FOR [M] ----"

			for(var/obj/items/tech/T in global.tech)
				var/state = "LOCKED"

				if(M.tech_unlocked[T.list_pos] == T.type)
					state = "UNLOCKED"

				src << "[T.name] | Needed INTXP: [T.needed_qp] | State: [state]"


		if("Manage_Technology")
			var/mob/races/M = input("Select a player:") as null|anything in race_mobs
			if(!M) return

			var/list/options = list()

			for(var/obj/items/tech/T in global.tech)
				if(!T) continue

				var/status = "LOCKED"
				if(M.tech_unlocked[T.list_pos] == T.type)
					status = "UNLOCKED"

				options["[T.name] ([status])"] = T

			var/choice = input(src, "Select a tech to manage for [M].", "Tech Manager") in options
			if(!choice) return

			var/obj/items/tech/T = options[choice]

			var/action = input(src, "What do you want to do with [T.name]?", "Tech Action") in list(
			"Add Tech",
			"Remove Tech",
			"Recheck Unlock Logic",
			"Cancel"
			)

			if(action == "Add Tech")
				M.tech_unlocked[T.list_pos] = T.type
				T.lvl_up_tech(M)
				M << "[src] ADMIN added tech [T.name] to [M]."

			if(action == "Remove Tech")
				M.tech_unlocked[T.list_pos] = null
				M << "[src] ADMIN removed tech [T.name] from [M]."

			if(action == "Recheck Unlock Logic")
				T.lvl_up_tech(M)
				M << "[src] ADMIN forced tech check for [T.name] on [M]."

			spawn()
				tech_unlocking(M)

		if("Reset_Player_Inventory")

			var/mob/races/M = input("Select a player:") as null|anything in race_mobs
			if(!M) return

			if(alert(src,"Reset and rebuild [M]'s inventory?","Inventory Reset","Yes","No") != "Yes")
				return

			var/list/valid_items = list()

			// Gather valid items
			for(var/obj/items/I in M)
				if(I && I.can_pocket)
					valid_items += I

			// Clear inventory slots
			for(var/i=1,i<=48,i++)
				M.inv[i] = null

			// Rebuild inventory
			var/slot = 1
			for(var/obj/I in valid_items)

				if(slot > 48)
					break

				if(!I) continue

				I.slot = slot
				I.loc = M
				M.inv[slot] = I

				if(!(global.inv_slot in I.vis_contents))
					I.vis_contents += global.inv_slot

				slot++

			// Remove any broken leftovers
			for(var/obj/items/I in M)
				if(!(I in valid_items))
					del(I)

			// Reset selection
			M.item_selected = null
			M.mouse_down = null
			M.mouse_over = null

			// Rebuild HUD
			M.refresh_inv()

			src << "[M]'s inventory has been rebuilt."
			M << "Your inventory has been rebuilt by an admin to fix corrupted slots."
		if("Delete_Player_Skills")
			var/mob/M = input("Select a player:") as null|anything in players
			if(!M) return

			if(alert(src, "Delete all existing skills for [M]?", "Skill Refresh", "Yes", "No") != "Yes")
				return

			M.DeleteExistingSkills()

			src << "[M]'s skills were deleted."
			//M << "Your skills were refreshed by an admin."

		if("Refresh_Player_Skills")
			var/mob/M = input("Select a player:") as null|anything in players
			if(!M) return

			if(alert(src, "Refresh all existing skills for [M]?", "Skill Refresh", "Yes", "No") != "Yes")
				return

			M.RefreshExistingSkills()

			src << "[M]'s skills were refreshed."
			//M << "Your skills were refreshed by an admin."
		
		if("Manage_Mutations")
			var/mob/M = input("Select a player:") as null|anything in players
			if(!M) return

			var/action = alert(src, "What action?", "Mutation Manager", "Give", "Take", "Cancel")
			if(action == "Cancel" || !action) return

			var/list/mutations = list()
			if(action == "Give")
				// Get every concrete mutation type defined in the game
				for(var/mut_type in typesof(/mutations/))
					if(mut_type == /mutations) continue
					var/mutations/mut = new mut_type()
					if(!mut || !mut.info_name) continue
					mutations["[mut.info_name] ([mut_type])"] = mut_type
				mutations = sort_list(mutations)
				if(!mutations.len)
					src << "[M] has no available mutations to give."
					return
				var/mutation_choice = input("Select mutation:", "Give Mutation") as null|anything in mutations
				if(!mutation_choice) return
				var/mut_type = mutations[mutation_choice]
				if(!mut_type) return
				var/mutations/mut = new mut_type()
				if(!mut) return
				mut.activate(M)
				M.mutations += mut
				src << "Gave [mutation_choice] to [M]."
				M << "Admin gave you mutation: [mutation_choice]"
			if(action == "Take")
				// Get current mutations sorted by name
				for(var/mutations/mut in M.mutations)
					if(!mut) continue
					mutations[mut.info_name] = mut
				if(!mutations.len)
					src << "[M] has no mutations."
					return
				mutations = sort_list(mutations)
				var/mutation_choice = input("Select mutation to remove:", "Remove Mutation") as null|anything in mutations
				if(!mutation_choice) return
				var/mutations/mut = mutations[mutation_choice]
				if(!mut) return
				M.mutations -= mut
				src << "Removed [mutation_choice] from [M]."
				M << "Admin removed your mutation: [mutation_choice]"

		if("Reset_Player_Technology")
			var/mob/races/M = input("Select a player:") as null|anything in race_mobs
			if(!M) return

			if(alert(src,"Reset ALL technology for [M]? They will relearn everything based on their INTXP.","Tech Reset","Yes","No") != "Yes")
				return

			// Save current intelligence XP
			var/saved_intxp = M.intxp

			// Reset player INTXP temporarily
			M.intxp = 0

			// Reset tech data
			M.tech_unlocked = list()
			M.tech_lvls = list()
			M.tech_xp = list()

			M.tech_unlocked.len = global.tech.len
			M.tech_lvls.len = global.tech.len
			M.tech_xp.len = global.tech.len

			/// Delete old tech HUD
			if(M.hud_tech)
				del(M.hud_tech)
				M.hud_tech = null

			// Recreate it clean
			M.hud_tech = new /obj/hud/menus/tech_background
			M.hud_tech.populate_tech_tree()
			M.hud_tech.menu_create()

			// Restore INTXP
			M.intxp = saved_intxp

			// Re-run tech unlocking logic
			spawn()
				tech_unlocking(M)

			src << "[M]'s technology has been fully reset and rebuilt."
			M << "Your technology has been reset by an admin. Your intelligence remains the same and technologies will be relearned automatically."
		if("Clear_Tech_List")
			var/mob/choice = input("Select a player:") as null|obj|mob in players
			if(!choice) return
			switch(alert(src,"Are you sure you wish to fix [choice] technology list? This will clear their inventory and you are expected to reset their QP from 0 to their current QP so they can relearn their tech.","","Yes","No"))
				if("Yes")
					choice.hud_tech.ClearTechEntriesFull()
					src << "[choice] technology list was cleared!"
					choice << "Your technology list was cleared by an admin!"
					return

		if("Clear_Known_Names")
			var/mob/choice = input("Select a player:") as null|obj|mob in players
			if(!choice) return
			switch(alert(src,"Are you sure you wish to fix [choice] name list?","","Yes","No"))
				if("Yes")
					choice.known_people = list()
					src << "[choice] name list was defaulted!"
					choice << "Your name list was defaulted by an admin!"
					return
		if("Fix_Icon")
			var/mob/choice = input("Select a player:") as null|obj|mob in players
			if(!choice) return
			switch(alert(src,"Are you sure you wish to fix [choice] icon?","","Yes","No"))
				if("Yes")
					choice.update_looks()
					choice.update_icon()
					src << "[choice] looks were updated!"
					choice << "Your looks were updated(fixed)!"
		if("Force_Resolution_Fix")
			var/mob/races/M = input(src, "Select player") as mob in players
			if(!M || !M.client) return

			var/w = input(src, "Enter Width (example 1360):") as num
			var/h = input(src, "Enter Height (example 760):") as num

			if(!w || !h)
				src << "Invalid resolution."
				return

			M.client.ApplyResolutionScale(w, h)

			src << "Forced resolution [w]x[h] applied to [M]."
		if("Fix_Screen_Offset")
			var/mob/races/choice = input("Select a player:") as null|anything in race_mobs
			if(!choice) return
			var/option = input("Select their offset") in list("Auto","Zero","Custom","Client Custom")

			if(option == "Auto")
				choice.client.custom_view = 32
			if(option == "Zero")
				choice.client.custom_view = 0
			if(option == "Custom")
				var/newoption = input("Type your offset(eg. -32, 32, -16, 16)") as num
				choice.client.custom_view = newoption
			if(option == "Client Custom")
				var/clientx = input("Type the 'x' of the client view") as num
				var/clienty = input("Type the 'y' of the client view") as num
				var/pixelxoff = input("Type the 'pixel_x' number") as num
				var/pixelyoff = input("Type the 'pixel_y' number") as num
				switch(alert(src,"Their client view will be '[clientx]x[clienty]' and their pixel offsets will be: px: [pixelxoff] py: [pixelyoff], do you confirm?","","Yes","Cancel"))
					if("Yes")
						choice.client.view = "[clientx]x[clienty]"
						choice.pixel_y = pixelyoff
						choice.pixel_x = pixelxoff
						choice << "Your view was changed to [clientx]x[clienty] by an admin."
						return

			choice.client.setMap(choice.client)
			choice << "Your view was changed to [option] by an admin."
		// =========================================================
		// ECONOMY / POINTS
		// =========================================================
		if("Give_Zenni")
			var/mob/choice = input("Select a player:") as null|obj|mob in players
			if(!choice) return
			var/amount = input("How much are zenni are you giving them [choice]?") as num
			if(amount <= 1) return
			choice.resources += amount
			choice.refresh_inv()
			world << output("<font color=yellow>(Admin Log): [src] gave [choice] [amount] Zenni","rpspy.output2")
		if("Give_Dokuro_Coins")
			var/mob/choice = input("Select a player:") as null|mob in players
			if(!choice) return
			var/amount = input("How much dokuro coins are you giving them [choice]?") as num
			if(amount < 1) return
			choice.client.dokuro_points += amount
			choice<<"You were gifted <b><font color=yellow>[amount]</font></b> Dokuro coins!"
			choice.set_alert("You were gifted [amount] Dokuro coins!",'alert.dmi',"alert")
			world.log << "(Admin Log): [src.client.admin_name]/[src] gave [choice] [amount] acceleated gains"
		if("Give_Accelerated_Gains")
			var/mob/choice = input("Select a player:") as null|mob in players
			if(!choice) return
			var/amount = input("How much accelerated gains are you giving them [choice]?") as num
			if(amount <= 1) return
			choice.offline_gains += amount
			if(!choice.hud_accelerator)
				var/obj/hud/menus/accelerated_gains_txt/acceleration = new
				choice.hud_accelerator = acceleration
			choice.hud_accelerator.accelerator = choice
			choice.client.screen += choice.hud_accelerator
			choice<<"You were gifted <b><font color=yellow>[amount]</b></font> minute(s) of accelerated gains!"
			choice.set_alert("You were gifted [amount] minute(s) of accelerated gains!",'alert.dmi',"alert")
			world.log << "(Admin Log): [src.client.admin_name]/[src] gave [choice] [amount] accelerated gains"

		// =========================================================
		// STATS / HTT
		// =========================================================
		if("Increase_Stats")
			var/mob/choice = input("Select a player:") as null|obj|mob in players
			if(!choice) return

			switch(input("Which Stat to Increase:") in list("Passive Points","Stance Points","Personal Growth","Rating","Intelligence","Magic","Energy","Power Level","Strength","Endurance","Speed","Force","Resistance","Offence","Defence","Recovery","Regeneration","Gravity"))

				if("Personal Growth")
					var/amount = input("How much are you increasing by?(Becareful, these are mod levels(0.1-5.0+ prefered)") as num
					choice.PG += amount
					world.log << "(Admin Log): [src.client.admin_name] increased [choice] PG by [amount]"

				if("Rating")
					var/amount = input("How much are you increasing by?") as num
					choice.rating += amount
					world.log << "(Admin Log): [src.client.admin_name] increased [choice] Ratings by [amount]"

				if("Power Level")
					var/amount = input("How much are you increasing by?") as num
					choice.psionic_power_base += amount
					world.log << "(Admin Log): [src.client.admin_name] [src] increased [choice] PL by [amount]"

				if("Strength")
					var/amount = input("How much are you increasing by?") as num
					choice.strength += amount
					world.log << "(Admin Log): [src.client.admin_name] [src] increased [choice] Strength by [amount]"

				if("Endurance")
					var/amount = input("How much are you increasing by?") as num
					choice.endurance += amount
					world.log << "(Admin Log): [src.client.admin_name] [src] increased [choice] Endurance by [amount]"

				if("Energy")
					var/amount = input("How much are you increasing by?") as num
					choice.gains_trained_energy += amount
					world.log << "(Admin Log): [src.client.admin_name] [src] increased [choice] Energy by [amount]"

				if("Recovery")
					var/amount = input("How much are you increasing by?(Becareful, these are mod levels(0.1-5.0+ prefered)") as num
					choice.mod_recovery += amount
					world.log << "(Admin Log): [src.client.admin_name] [src] increased [choice] Recovery by [amount]"

				if("Regeneration")
					var/amount = input("How much are you increasing by?(Becareful, these are mod levels(0.1-5.0+ prefered)") as num
					choice.mod_regeneration += amount
					world.log << "(Admin Log): [src.client.admin_name] [src] increased [choice] Regeneration by [amount]"

				if("Gravity")
					var/amount = input("How much are you increasing by?") as num
					choice.gravity_mastered += amount
					world.log << "(Admin Log): [src.client.admin_name] [src] increased [choice] Gravity by [amount]"

				if("Speed")
					var/amount = input("How much are you increasing by?(Becareful, these are mod levels(0.1-5.0+ prefered)") as num
					choice.mod_agility += amount
					world.log << "(Admin Log): [src.client.admin_name] [src] increased [choice] Speed by [amount]"

				if("Force")
					var/amount = input("How much are you increasing by?") as num
					choice.force += amount
					world.log << "(Admin Log): [src.client.admin_name] [src] increased [choice] Force by [amount]"

				if("Resistance")
					var/amount = input("How much are you increasing by?") as num
					choice.resistance += amount
					world.log << "(Admin Log): [src.client.admin_name] [src] increased [choice] Resistance by [amount]"

				if("Offence")
					var/amount = input("How much are you increasing by?") as num
					choice.offence += amount
					world.log << "(Admin Log): [src.client.admin_name] [src] increased [choice] Offence by [amount]"

				if("Defence")
					var/amount = input("How much are you increasing by?") as num
					choice.defence += amount
					world.log << "(Admin Log): [src.client.admin_name] [src] increased [choice] Defence by [amount]"

				if("Passive Points")
					var/amount = input("How much are you increasing by?") as num
					choice.passive_points += amount
					world.log << "(Admin Log): [src.client.admin_name] [src] increased [choice] PPs by [amount]"

				if("Stance Points")
					var/amount = input("How much are you increasing by?") as num
					choice.stance_points += amount
					world.log << "(Admin Log): [src.client.admin_name] [src] increased [choice] SPs by [amount]"

				if("Intelligence")
					var/amount = input("How much are you increasing by?") as num
					choice.intxp += amount
					world.log << "(Admin Log): [src.client.admin_name] [src] increased [choice] QP% by [amount]"

				if("Magic")
					var/amount = input("How much are you increasing by?") as num
					choice.magicxp += amount
					world.log << "(Admin Log): [src.client.admin_name] [src] increased [choice] Magic by [amount]"

		if("Increase_HTT")
			var/mob/choice = input("Select a player:") as null|obj|mob in players
			if(!choice) return
			var/selection = input("Select a variable:") in list("Cancel","Hunger","Thirst","Tiredness")
			switch(selection)
				if("Hunger")
					var/amount = input("How much are you increasing their hunger by?") as num
					if(amount <= 1) return
					choice.hunger += amount
					world << output("<font color=yellow>(Admin Log): [src] increased [choice] Hunger by [amount]!","rpspy.output2")
				if("Thirst")
					var/amount = input("How much are you increasing their thirst by?") as num
					if(amount <= 1) return
					choice.thirst += amount
					world << output("<font color=yellow>(Admin Log): [src] increased [choice] Thirst by [amount]!","rpspy.output2")
				if("Tiredness")
					var/amount = input("How much are you increasing their tiredness by?") as num
					if(amount <= 1) return
					choice.restedness += amount
					world << output("<font color=yellow>(Admin Log): [src] increased [choice] Tiredness by [amount]!","rpspy.output2")

		// =========================================================
		// TRANSFORMATION
		// =========================================================
		if("Force_Transformation")
			var/mob/races/choice = input("Select a player:") as null|anything in race_mobs
			if(!choice) return
			choice.Transformation(1,1)
			src << "You successfully transformed [choice]."
			world.log << "(Admin Log): [src.client.admin_name] transformed [choice]"
		if("Give_LSSJ")
			var/mob/races/choice = input("Select a player:") as null|anything in race_mobs
			if(!choice) return

			if("Saiyan")
				choice.race_class = "Legendary"
				choice.mod_psionic_power = decimal_rand(6, 10)
				choice.final_powerlevel_mod = 2800000
				choice.psionic_power_base += ((choice.age/choice.mod_psionic_power) + random_mod_multiplier() + (choice.final_powerlevel_mod * 0.0001)) * choice.mod_psionic_power


				//src.strength = 200
				//src.endurance = 200
				choice.mod_rating = 1
				choice.mod_energy = decimal_rand(1.8, 2.5)

				choice.mod_strength = decimal_rand(1.8, 2)
				choice.mod_endurance = decimal_rand(1.8, 2.3)
				choice.mod_zenkai = decimal_rand(2,2.5)



				choice.mod_agility += decimal_rand(1.3, 1.5)
				choice.mod_force = decimal_rand(1.9, 2.2)
				choice.mod_resistance = decimal_rand(1.2, 1.4)
				choice.mod_offence = decimal_rand(1.6, 2.2)
				choice.mod_defence = decimal_rand(1.4, 2)
				choice.mod_regeneration = decimal_rand(1.2, 1.3)
				choice.mod_recovery = decimal_rand(1.5, 1.9)
				choice.mod_sense = 2
				choice.mod_tech_potential = 1
				choice.LSSJ = 1
				choice.auracolor = rgb(202,242,127)
				choice << "You successfully transformed [choice] into a LSSJ spawn."
				world.log << "(Admin Log): [src.client.admin_name] transformed [choice] into LSSJ!"
			else
				src<< "[choice] is not a Saiyan!"
				return


		// =========================================================
		// RANKS
		// =========================================================
		if("Remove_Rank")
			var/mob/choice = input("Select a player:") as null|mob in players
			if(!choice) return
			if(choice.occupation)
				switch(alert(src,"[choice.real_name]'s current rank is [choice.occupation], are you wishing to remove this?","","Yes","Cancel"))
					if("Yes")
						if(choice.owns_planets >= 1)
							choice.occupation = "Planet Owner"
							choice.rank = 0
						else
							choice.occupation = "None"
							choice.rank = 0
						world.log << "(Admin Log): [src.client.admin_name] [src] removed [choice]'s rank"

		if("Set_Rank")
			var/mob/choice = input("Select a player:") as null|mob in players
			if(!choice) return

			switch(input(src,"What planet is this rank for?") in list("Earth","Namek","Vegeta","Icer","Space","Other Realm","Dark Realm","Hell"))

				if("Hell")
					switch(input("Which rank:") in list("Demon Lord","Vice Demon Lord","Academy Master"))
						if("Demon Lord")
							choice.occupation = "Demon Lord"
							choice.rank = 4
						if("Vice Demon Lord")
							choice.occupation = "Vice Demon Lord"
							choice.rank = 3
						if("Academy Master")
							choice.occupation = "Acad. Master"
							choice.rank = 2

				if("Dark Realm")
					switch(input("Which rank:") in list("Supreme Demon Lord","Vice Supreme Demon Lord","Academy Master"))
						if("Supreme Demon Lord")
							choice.occupation = "Spr.DemonLord"
							choice.rank = 4
						if("Vice Supreme Demon Lord")
							choice.occupation = "V.Spr.DemonLord"
							choice.rank = 3
						if("Academy Master")
							choice.occupation = "Acad. Master"
							choice.rank = 2

				if("Other Realm")
					switch(input("Which rank:") in list("Supreme Kaioshin","North Kai","South Kai","East Kai","West Kai","Checkpoint Guardian"))
						if("Supreme Kaioshin")
							choice.occupation = "Supreme Kai"
							choice.rank = 4
						if("North Kai")
							choice.occupation = "North Kai"
							choice.rank = 4
						if("South Kai")
							choice.occupation = "South Kai"
							choice.rank = 4
						if("East Kai")
							choice.occupation = "East Kai"
							choice.rank = 4
						if("West Kai")
							choice.occupation = "West Kai"
							choice.rank = 4
						if("Checkpoint Guardian")
							choice.occupation = "Chpnt. Guardian"
							choice.rank = 3

				if("Space")
					switch(input("Which rank:") in list("Space Pirate","Yardrat Master"))
						if("Space Pirate")
							choice.occupation = "Space Pirate"
							choice.rank = 3
						if("Yardrat Master")
							choice.occupation = "Yrdrt Master"
							choice.rank = 3

				if("Earth")
					switch(input("Which rank:") in list("Earth Guardian","Crane Hermit","Turtle Hermit","Red Ribbon Army Leader","Academy Master"))
						if("Earth Guardian")
							choice.occupation = "Guardian"
							choice.rank = 4
							global.hbtc_time = 270
							choice << output("The Hyperbolical Time Chamber has calmed down.","actionoutput")
						if("Crane Hermit")
							choice.occupation = "Hermit(C)"
							choice.rank = 4
						if("Turtle Hermit")
							choice.occupation = "Hermit(T)"
							choice.rank = 4
						if("Red Ribbon Army Leader")
							choice.occupation = "R.R.Leader"
							choice.rank = 3
						if("Academy Master")
							choice.occupation = "Acad. Master"
							choice.rank = 2

				if("Namek")
					switch(input("Which rank:") in list("Namek Elder","Academy Master"))
						if("Namek Elder")
							choice.occupation = "Elder"
							choice.rank = 4
						if("Academy Master")
							choice.occupation = "Acad. Master"
							choice.rank = 2

				if("Vegeta")
					switch(input("Which rank:") in list("King/Queen","General","Royalty","Academy Master"))
						if("King/Queen")
							if(choice.gen == "Female") choice.occupation = "Queen"
							if(choice.gen == "Male") choice.occupation = "King"
							choice.rank = 4
						if("General")
							choice.occupation = "Saiyan General"
							choice.rank = 3
						if("Royalty")
							choice.occupation = "Royalty"
							choice.rank = 2
						if("Academy Master")
							choice.occupation = "Acad. Master"
							choice.rank = 2

				if("Icer")
					switch(input("Which rank:") in list("Icer Lord","General","Academy Master"))
						if("Icer Lord")
							choice.occupation = "Icer Lord"
							choice.rank = 4
						if("General")
							choice.occupation = "Icer General"
							choice.rank = 3
						if("Academy Master")
							choice.occupation = "Acad. Master"
							choice.rank = 2

			choice.percent_health = 100
			choice.percent_energy = 100
			world << output("<font color=yellow>(Admin Log): [src] gave [choice] a rank([choice.occupation])","rpspy.output2")

		// =========================================================
		// OBJECTS / CREATION
		// =========================================================
		if("Create_Custom_Icon_Object")
			new /obj/items/custom_icon_object(src.loc)
			src << "Created a Custom Icon Object at your location. Right-click it while in your inventory to customize."


		// =========================================================
		// LIMBS
		// =========================================================
		if("Damage_Limb")
			var/mob/races/choice = input("Select a player:") as null|obj|mob in players
			if(!choice) return
			var/option = input("Select the limb") in list("Cancel","Right Arm","Right Leg","Left Arm","Left Leg","All")
			var/damage = input("How much are you damaging this by?\nTip: 0-100%") as num
			if(option == "Cancel") return
			if(damage<=0) return
			if(option == "All")
				for(var/obj/body_related/bodyparts/p in choice.body)
					if(p)
						choice.damage_limb(src,0, 1, damage,p)
						src<<"You damaged [choice]'s [option] by [damage]."
			else
				for(var/obj/body_related/bodyparts/p in choice.body)
					if(p)
						if(p.name == option || p.name == "[option]")
							choice.damage_limb(src,0, 1, damage,p)
							src<<"You damaged [choice]'s [option] by [damage]."



			// NOTE: your snippet shows only the menu for Restore Limb, not the actual restore logic.
			// If you have a restore proc (common names: restore_limb(), regrow_limb(), etc.),
			// call it here EXACTLY as your codebase does.
			// Placeholder message to avoid breaking compile if no proc is known:
		//	src << "Restore Limb: logic not present in the provided snippet. Hook your existing restore proc here."
		if("Restore_Limb")
			var/mob/choice = input("Select a player:") as null|obj|mob in players
			if(!choice) return
			var/option = input("Select the limb") in list("Cancel","Right Arm","Right Leg","Left Arm","Left Leg","All")
			if(option == "Cancel") return
			// NOTE: your snippet shows only the menu for Restore Limb, not the actual restore logic.
			// If you have a restore proc (common names: restore_limb(), regrow_limb(), etc.),
			// call it here EXACTLY as your codebase does.
			// Placeholder message to avoid breaking compile if no proc is known:
			src << "Restore Limb: logic not present in the provided snippet. Hook your existing restore proc here."

		if("Remove_Limb")
			var/mob/choice = input("Select a player:") as null|obj|mob in players
			if(!choice) return
			var/option = input("Select the limb") in list("Cancel","Right Arm","Right Leg","Left Arm","Left Leg","All")
			if(option == "Cancel") return

			if(option == "All")
				for(var/obj/body_related/bodyparts/right_arm/limb in choice.bodyparts)
					check_maim_limb(src, limb, choice, 1)

				for(var/obj/body_related/bodyparts/left_leg/limb in choice.bodyparts)
					check_maim_limb(src, limb, choice, 1)
				for(var/obj/body_related/bodyparts/left_arm/limb in choice.bodyparts)
					check_maim_limb(src, limb, choice, 1)
				for(var/obj/body_related/bodyparts/right_leg/limb in choice.bodyparts)
					check_maim_limb(src, limb, choice, 1)
				return

			if(option == "Right Arm")
				for(var/obj/body_related/bodyparts/right_arm/limb in choice.bodyparts)
					check_maim_limb(src, limb, choice, 1)
					return

			if(option == "Left Arm")
				for(var/obj/body_related/bodyparts/left_arm/limb in choice.bodyparts)
					check_maim_limb(src, limb, choice, 1)
					return

			if(option == "Right Leg")
				for(var/obj/body_related/bodyparts/right_leg/limb in choice.bodyparts)
					check_maim_limb(src, limb, choice, 1)
					return

			if(option == "Left Leg")
				for(var/obj/body_related/bodyparts/left_leg/limb in choice.bodyparts)
					check_maim_limb(src, limb, choice, 1)
					return

		// =========================================================
		// PLANET TELEPORT
		// =========================================================

		if("Planet_Teleport")
			var/planets = list("Earth"=1, "Namek"=4, "Vegeta"=10, "Icer"=9, "Other Realm"=2, "Heaven"=11, "Hell"=6, "Dark Realm"=12, "Space"=16)
			var/planet = input("Where are you teleporting too?") in planets
			if(planet)
				var/z_level = planets[planet]
				var/y_rand = (planet == "Heaven") ? rand(5,490) : rand(5,480)
				src.loc = locate(rand(5,480), y_rand, z_level)
				src.check_glow_planes()
				world.log << "(Admin Log): [src.client.admin_name] used Planet Teleport"

		// =========================================================
		// WORLD BOSS CONTROL & LOOT TESTING
		// =========================================================
		if("Test_Loot_Roll")
			BuildTechItemCache()

			if(!TECH_ITEM_TYPES.len)
				src << "No tech items cached."
				return

			// Pick random tech item
			var/path = pick(TECH_ITEM_TYPES)
			var/obj/items/tech/I = new path(src.loc)

			// Gather real nearby players
			var/list/eligible = list()
			for(var/mob/M in view(10, src))
				if(M.client)
					eligible += M

			// Create loot roll
			var/datum/loot_roll/L = new(I, eligible)

			// If too few players, inject fake ones
			if(eligible.len < 2)
				L.fake_ckeys = GenerateFakeRollers(rand(2,4))
				usr << "Loot Test: Injected fake players."

			usr << "<b>Loot Test Started:</b> [I.name]"

		if("World_Boss_Control")

			var/status = GetWorldBossStatusText()

			var/choice = alert(
				src,
				"[status]\n\nDo you want to FORCE SPAWN all World Bosses now?\n(This does NOT cancel the official weekend timer.)",
				"World Boss Control",
				"Force Spawn",
				"Cancel"
			)

			if(choice != "Force Spawn")
				return

			switch(alert(src,"Are you absolutely sure?","","Yes","No"))
				if("No") return

			// Force start for today
			for(var/datum/worldboss_controller/C in WORLD_BOSS_CONTROLLERS)
				C.StartDay()

			world << "<b><font color=#ff9933>WORLD BOSS EVENT:</font> <font color=white>World Bosses have been manually summoned by an administrator.</font></b>"
			world.log << "(Admin Log): [src.client.admin_name] force-spawned World Bosses"

/// Sorts a list by its keys
/proc/sort_list(list/L)
	if(!L || !L.len) return L
	var/list/sorted = list()
	var/list/keys = L.Copy()
	sort_text(keys) 
	for(var/key in keys)
		sorted[key] = L[key]
	return sorted

/// Sorts a list of text values alphabetically
/proc/sort_text(list/src)
	for(var/i = 1, i < length(src), i++)
		for(var/j = 1, j <= length(src) - i, j++)
			if(text2num(src[j]) > text2num(src[j+1]))
				var/temp = src[j]
				src[j] = src[j+1]
				src[j+1] = temp
	return src
