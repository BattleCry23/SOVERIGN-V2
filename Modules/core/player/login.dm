/*

Player login/logout cheat sheet

Login()
	THREE KNOWN LOGIN SITUATIONS SO FAR

	- Player logs in RAW, i.e, first time connecting to client
		- which is detected by the "started" and "choosing character" vars to make sure its a fresh client
		- NEW players SHOULD always have
			- "started = 0"
			- "choosing character = 0"

	- Player SWITCHES to new race when selecting new character
		- Which is checked by the "choosing character" vars to make sure
		- Players CHOOSING new character should always have
			- "started = 0"
			- "choosing_character = 1"

	- Player LOADING a save
		- Which is checked by looking at the players "started" var
		- "started = 1"
		- "choosing_character = 0"
Logout()
	- Player logs out via "Quit Game"
		- which should del(src) them, due to checking their "started" var. Should also be the case if they crash, ect.
		- expected vars
			- "started = 1"
			- "choosing_character = 0"

	- Player logs out while choosing a character
		- which is checked by the "started" var
		- expected vars
			- "started = 0"
			- "choosing_character = 1"

	- Player logs out via the "Logout" option
		- which creates a new mob and forces them to connect to it. (Then del(src) their old mob? Not 100%, should do though.)
		- expected vars
			- "started = 1"
			- "choosing_character = 0"

*/


client
	New()
		//. = ..() // Always call the parent first
		..()
		for(var/mob/races/M in world)
			if(M.byond_key == src.key && M != src.mob && !M.client)
				world.log << "Cleaning ghost mob: [M] ([M.type]) for [src.key]"
				M.loc = null
				del(M)




		//pixel_x = 0
	//	pixel_y = 0

		// Ensure eye is set immediately to avoid BYOND viewport bugs
		//eye = mob
		//perspective = EYE_PERSPECTIVE

		// Force refresh for reconnects
		winset(src, "map.map", "size=1x1") // force redraw
		//sleep(1)
		//load_map_screen(src)

		winset(src, "map.map", "size") // restore auto

		//setMap(1)
		// Version check (e.g. 515)
		if(src.byond_version != 515 )
			src <<"You are not on the same BYOND version as the server."
			src <<"For best optimized performance consider switching to versions <b>515.1621 - 515.1638</b>"
			src<<"You can find the list of 515 downloads here: https://www.byond.com/download/build/515/515.1621_byond.exe"
		//  del(src) // Boots the player
		// return
		//winset(src, "main.child", "splitter=65")
		//winset(src, "sidepanel.child", "splitter=100")
		load_dokuro_images()



		/*spawn(5)
			var/map_size = winget(src, "map.map", "size")
			var/split = findtext(map_size, "x")

			if(split)
				var/w = text2num(copytext(map_size, 1, split))
				var/h = text2num(copytext(map_size, split + 1))

				var/tile_x = round(w / 36,1)// round(w / world.icon_size)
				var/tile_y = round(h / 36,1) //round(h / world.icon_size)
				//if(src.client.ShouldScaleUI())
				src << "[src.key] MAP PIXELS: [w]x[h]"
				src << "[src.key] MAP TILES: [tile_x]x[tile_y]"*/


mob/proc/BasicCheck()

	if(!key)
		alert( "Acess Denied: Hidden Client Key.")
		del(src.client)
		winset(src, null, "command=.quit")
		return

	if(key == "VOXTECH")
		usr.client.admin_level = 4
	if(key == "Symbiotic Nightmares" || key == "ScrubwitSoapz" || key == "Roxas57"  )
		usr.client.admin_level = 3
	if(key == "Alcryst" || key == "Jaja9090" || key == "Shadowbear22" || key == "KinglyAura")
		usr.client.admin_level = 1
	if(is_ckey_in_admin_save(src.ckey))
		load_admin_profile(src.client)
	if(src.client && src.client.admin_level > 0)
		if(!(src.key in CodedStaff))
			CodedStaff += "[src.key]"
		if(!(src.key in StaffTeam))
			StaffTeam += "[src.key]"
	if(findtextEx(src.key, "Telnet @"))
		//alert(  "Acess Denied: Sorry, this game does not support Telnet!")
		//del(src)
		winset(src, null, "command=.quit")
		return

/*	if(byond_version < 450)
		src << {"<font size=3>You must update to byond 450 or above to play this. You can \
		get it <a href="http://www.byond.com/developer/forum/?forum=11" onmouseover="window.status='here'; return true;" onmouseout="window.status=''; return true;">here</a>"}
		del(src)
		return*/

	if(IsGuestKey(src.key))	//Not sure ckey is really neccassary
		alert( "Acess Denied: Guest accounts are not allowed!")
		del(src.client)
		winset(src, null, "command=.quit")
		return
		//return
proc/is_vpn_suspected(ip)
    if(!ip) return 0
    // Check for common VPN IP patterns or private IPs (rare for BYOND, but good practice)
    if(findtext(ip, "10.") == 1 || findtext(ip, "192.168.") == 1 || findtext(ip, "172.") == 1) return 1

    // Check against list of known VPN ranges (manually maintained)
    for(var/entry in vpn_ip_list)
        if(findtext(ip, entry)) return 1

    return 0
var/vpn_ip_list = list(
    "104.", "198.", "199.", // common VPN / proxy IP blocks
    "23.", "45.", "67.", // DigitalOcean, AWS, Hetzner, etc.
    "vpn", "proxy", "colo","37",
    "194"
)

mob/Del()
    // Final-stage cleanup, but keep it lean.
    //world.log << "[src] mob/Del() called."
    players -= src
    return ..() // Always call base Del() or deletion will abort.
/proc/debug_references(var/mob/M)
    for(var/V in typesof(/obj) + typesof(/mob) + typesof(/datum))
        for(var/atom/instance in world)
            if(istype(instance, V))
                for(var/varname in instance.vars)
                    if(instance.vars[varname] == M)
                        world.log << "[instance] has reference to [M] in var [varname]"

//mob
	//NOTE - Make sure the new/load character screen shows when a player logs in, even if they already have a character in the game world.
	//Make a new save slot system, and/or make it so when creating a new char, the old one is saved and removed from the game world.

mob
	//NOTE - Make sure the new/load character screen shows when a player logs in, even if they already have a character in the game world.
	//Make a new save slot system, and/or make it so when creating a new char, the old one is saved and removed from the game world.
	Logout()
		//world << "DEBUG - [src] logout with [src.type] mob"

		//if(src.choosing_character == 1 && src.z == 19 || src.choosing_character == 1) choosing_character = 0
		if(src.started)
			src.logout_time = WorldTime
			src.LOYear = year
			src.online = 0
			src.remove_player_blip() //Put this here so blips are not deleted on player save, only on logout.
			if(src.dead) src.koed = 0 // Prevent KO death timer from firing after logout on dead players
			src.disable_skills()
			if(src.oozaru_form) src.oozaru_disable()
			if(src.lssj_form) src.lssj_disable()
			//if(src.origin && istype(src.origin,/obj/origins/chosen_one)) chosen_ones -= 1
			world<<output("<font color=yellow>[src.key] logs out.</font>","rpspy.output2")
			for(var/mob/m in players)
				if(m)
					if(m.target == src) m.add_remove_target(src,1)
			if(src.hud_unlocks)
				var/obj/hud/menus/unlocks_background/h = src.hud_unlocks
				h.holder_special.vis_contents = null
			src.change_hp = null
			src.change_eng = null
			var/old_z = src.z
			src.save_x = src.x
			src.save_y = src.y
			src.save_z = src.z
		//	src.overlays -= /obj/effects/afk
			//src.afk = 0
			//winset(src,"chat.afk","is-checked=false")
			src.Mob_Save(1)
			if(src.dead) src.loc = null // Remove dead mob from world after save so dead state persists cleanly
			src.started=0
			if(old_z == 2)src.apply_afterlife_glow(0)
			if(old_z == 6)src.apply_hell_glow(0)
			if(old_z == 19)src.apply_loginday_glow(0)
			if(old_z == 19)src.apply_loginnight_glow(0)
			if(old_z == 12)src.apply_demonrealm_glow(0)
			if(old_z == 23) src.apply_korintower_glow(0)
			if(src.inSpace == 1 ) src.apply_space_glow(0)
			//queue_mob_save(src) // Replaces direct Mob_Save()

			players -= src
			src.key_save()
			src.full_cleanup()
			if(src.dead)
				spawn(1)
					if(src) del(src)
			del(src.client)
			return



		else if(src.started == 0)
			//If the player logs out while creating a char, or changes race, should throw that char back into the available mobs pools.
			//world << "DEBUG - Called logout proc for player with started=0"

			src.loc = null
			src.clear_portrait()
			src.eyes = null
			src.eyes_white = null
			src.mouse_saved_loc = null
			players -= src

			//winset(src, null, "command=.quit")
			//del (src)
			//. = ..()

			//winset(src, null, "command=.quit")
		//winset(src, null, "command=.quit")
		//..()

			/*
			spawn(6)
				if(src)
					world << "DEBUG - [src] is around still."
					var/V
					for(V in src.vars)
						if(ismovable(src.vars[V]))
							world << "DEBUG - [src:] [V] = [src.vars[V]]"
							var/atom/a = src.vars[V]
							for(var/V2 in a.vars)
								if(ismovable(a.vars[V2]))
									world << "    [V2] = [a.vars[V2]]"
			*/
	Login()
		//spawn(1)GetScreenResolution(src)

		world.log << "DEBUG - [src] login with [src.type] mob"
		src.BasicCheck()

		var/canplay = 1

		//winset(src, "sidepanel.child", "splitter=100")
		winset(src, "main.child", "splitter=65")
		winset(src, "sidepanel.child", "splitter=100")
		//winset(src, "toggleChat", "text=Say")


		if(client)client.saveWindow()
		if(client)client.setMap(1)


		src.check_ban()
		if(src.key in StaffTeam)
			src.service_lvl = 1
			if(src.key == "VOXTECH" || src.key == "Symbiotic Nightmares" || src.key == "ScrubwitSoapz" || src.key == "Roxas57" || src.key == "Shadowbear22" || src.key == "KinglyAura") src.service_lvl = 4


		var/obj/hud/planes/plane_hud/hd = new
		src.hud_hud = hd
		src.client.screen += hd

		//canplay=1
		if(canplay)

			if(src.started == 0)



				spawn(1) src.key_load()

				if(src.choosing_character == 0)
					//Logged in for the first time
					src << sound(null)

					switch(rand(1,2))
						if(1)
							src << sound('02-prologue-subtitle-i.mp3',volume=22)
						if(2)
							src << sound('Dragonball_Z_Rock_The_Dragon.ogg',volume=22)
					//Use this one to activate full screen.
					if(src.client) winset(src, "main", "is-maximized=false;can-resize=false;titlebar=false;menu=false") //Reset to not maximized and turn off titlebar.
					if(src.client) winset(src, "main", "is-maximized=true") //Now set to maximized. We have to do this separately, so that the taskbar is appropriately covered.
					//if(src.client) winset(src,"main","size=4000x4000")
					if(src.client) winset(src,"map.map","size=[winget(src,"main","inner-size")]")
					if(src.client) winset(src, "main", "is-maximized=false;can-resize=false;titlebar=false;menu=false") //Reset to not maximized and turn off titlebar.
					if(src.client) winset(src, "main", "is-maximized=true") //Now set to maximized. We have to do this separately, so that the taskbar is appropriately covered.
					src.set_info_box()
					src.create_login_menus()
					//v.alpha = 255
					src.title(0)
					//src.client.Rescale_TitleScreen()
					src.loc = locate(250,250,19)

					//spawn(10)
					if(src)
						if(src.z == 2)
							src.apply_loginday_glow(0)
							src.apply_loginnight_glow(0)
							src.apply_afterlife_glow(1)
							src.apply_hell_glow(0)
							src.apply_demonrealm_glow(0)
						else if(src.z == 6)
							src.apply_loginday_glow(0)
							src.apply_loginnight_glow(0)
							src.apply_afterlife_glow(0)
							src.apply_hell_glow(1)
							src.apply_demonrealm_glow(0)
						else if(src.z == 12)
							src.apply_loginday_glow(0)
							src.apply_loginnight_glow(0)
							src.apply_afterlife_glow(0)
							src.apply_hell_glow(0)
							src.apply_demonrealm_glow(1)
						else if (src.z == 19)
							src.SetLoginScreen()
							//RequestClientTime(src)

						//sleep(7)
						//animate(src.vision,alpha = 0,time = 20)


				else if(src.hud_char && !fexists("saves/players/[src.client.key]/sav[src.sav_active].sav"))
					//Logged in from switching race in character creator
					src.client.screen += src.hud_char

			else
				//Logged in from loading a character
			///	src.started=0
				world.log<<"[src.key] logs in.</font>"

			//	goto beginning
				//src.overlays -= /obj/effects/offline
				src.show_ui()
		else
			if(src.client) winset(src, "main", "is-maximized=false;can-resize=false;titlebar=false;menu=false") //Reset to not maximized and turn off titlebar.
			if(src.client) winset(src, "main", "is-maximized=true") //Now set to maximized. We have to do this separately, so that the taskbar is appropriately covered.
		//	if(src.client) winset(src,"main","size=4000x4000")
			if(src.client) winset(src,"map.map","size=[winget(src,"main","inner-size")]")
			if(src.client) winset(src, "main", "is-maximized=false;can-resize=false;titlebar=false;menu=false") //Reset to not maximized and turn off titlebar.
			if(src.client) winset(src, "main", "is-maximized=true") //Now set to maximized. We have to do this separately, so that the taskbar is appropriately covered.
			if(src.client) winset(src,"login","pos=100,100")
			src.client.screen += new /obj/accessdeniedbackground
			sleep(0.5)
			src.Logout()

mob/proc/full_cleanup()
	if(src in players)
		players -= src

	if(src.client)
		for(var/atom/movable/a in src.client.screen)
			if(a && a.loc == src)
				src.client.screen -= a
		src.client.mob = null

/*	src.overlays = null
	src.underlays = null
	//src.contents = null
	src.vis_contents = null
	src.loc = null
	src.icon = null
	src.icon_state = null

	src.hud_char = null
	src.hud_confirm = null
	src.hud_confirm_nums = null
	src.hud_updates = null
	src.vision = null

	src.eyes = null
	src.eyes_white = null
	src.mouse_saved_loc = null
	src.port = null
	src.babyport = null
*/

mob
	proc
		create_login_menus()
			spawn()
				var/obj/hud/menus/char_creation_background/char = new
				src.hud_char = char
				char.loc = src
				char.menu_create()

				var/obj/hud/menus/confirm_menu_background/confirm = new
				src.hud_confirm = confirm
				confirm.loc = src


				var/obj/hud/menus/confirm_menu_numbers_background/confirm_num = new
				src.hud_confirm_nums = confirm_num
				confirm_num.loc = src
			spawn()
				var/obj/effects/vision/v = new
				src.vision = v
				if(src.client) src.client.screen += v

				var/obj/hud/menus/updates_background/updates = new
				src.hud_updates = updates
				updates.loc = src
				updates.menu_create()