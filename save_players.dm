
mob
	proc
		save_load(var/n)
			if(src.started == 0)
				src.sav_active = n
				//If the save slot isn't empty, load the mob
				/*if(src.sav[n] != null)


					world.log << "DEBUG - Player's mob type before load: [src.type]"
					src.Mob_Load()
					world.log << "DEBUG - Player's mob type after load: [src.type]"*/
					//If the save loads correctly, players started should equal 1

				//  ORIGINAL USE!!!!
				/*if(src.sav[n])
					src.Mob_Load()*/


				//var/savefile/F = new("saves/players/[src.byond_key]/sav[n].sav")
				var/key = "[src.key]"
				var/path = "saves/players/[key]/sav[n].sav"

				if(fexists(path))
					src.Mob_Load()

				//if(fexists("saves/players/[src.byond_key]/sav[n].sav"))
					//src.Mob_Load()






					/*src.client.screen -= src.hud_load

					// OPEN the savefile
					var/savefile/F = new("saves/players/[src.key]/sav[n].sav")

					F["Player"] >> src
					F["X"] >> src.save_x
					F["Y"] >> src.save_y
					F["Z"] >> src.save_z
					Read(F)
					src.title(1)
					src.choosing_character = 0
					world.log << "Found Save to Load for [src.client.key](Client.key)"
					world.log << "(Client)Preparing Mob([ckey]).."
					for(var/obj/hud/titles/t in src.client.screen)
						if(t)
							src.client.screen -= t
							t.loc = null
					src.mob_prep()
					for(var/mob/races/r in world)
						if(r.client == null && r.name == "Celestial")
							if(!r in races_celestials)
								del(r)
								*/

				else //Start a new character save
					//src.loc = null
					//world << "WARNING: Save slot [n] metadata exists but file missing for [src.key]"
					src.choosing_character = 1
					src.loc = locate(260,260,19)
					src.client.eye = locate(250,250,19)
					src.client.screen -= src.hud_load
					//src.Human()
					src.birth_year = year-20
					//src.new_char()
					if(src.hud_char) src.client.screen += src.hud_char
					//winset(src,"chat","pos=0,[src.scrheight/1.6]")
					src.title(1)
					//world << "[src.key] logs in"
					world<<output("<font color=yellow>[src.key] logs in.</font>","rpspy.output2")

					var/obj/hud/menus/char_creation_background/b = src.hud_char
					//src.switch_race("Human")
					if(b)
						//Copy the players in-game avatar icon, but save the layer/plane/transform.
						b.menu_avatar()
						//Update the players portrait, if they have one, to reflect the new race choice.
						b.update_portrait_transform()
					if(!src.screen_text)
						var/obj/effects/screen_text/st = new
						src.screen_text = st
					if(src.screen_text)
						src.screen_text.screen_loc = "LEFT+6,CENTER"
						src.client.screen += src.screen_text
						src.screen_text.maptext = "<font size = 15><font color=yellow><center>SELECT A RACE!"
						src.screen_text.alpha=255
						//animate(src.screen_text,alpha = 255,time = 10)
						//animate(alpha = 0,time = 120)
						spawn(300)
							animate(src.screen_text, alpha = 0,time = 60)
							//src.screen_text.alpha=0
							src.screen_text.screen_loc = initial(src.screen_text.screen_loc)
		save_delete(var/n)
			if(src.started == 0)
				//src.sav_active = n
				src.left_click_ref = n
				src.hud_confirm.confirm_text(1,"Are you sure you want to delete Save [n]?",src)
				src.confirm = "confirm save delete"
				//src.left_click_ref = n
		Mob_Save(var/stop_all = 1)
			set background = 1

			//set waitfor = 0
			//if(src.client) if(src.can_save)
		//	world << "DEBUG - Saving player client."
			if(!src.can_save || !src.started)
				return
			if(src.can_save && src.started)
			//	world << "DEBUG - Player can save and has started game"

				//If the player is about to logout/quit, then run this part of the save code.
				if(stop_all)
					src.letgo()
					//sleep(0.1)
					//src.clear_minigame_lift()
					//sleep(0.1)
					src.drop_tk()
					//sleep(0.1)
					//src.overlays -= /obj/effects/swim
					//src.filters -= filter(type="motion_blur", x=1, y=0)
					//src.filters = null
					//sleep(0.1)
					src.bolted = 0
					src.layer = 4
					if(src.wings) src.vis_contents -= src.wings
					//src.alpha = 255
					src.weather = null
					//Reset the location of visual indicators so they don't stay on the map when the player logs.
					if(src.mouse_over_tooltip) src.mouse_over_tooltip.loc = null
					if(src.mouse_over_visual) src.mouse_over_visual.loc = null
					if(src.build_marker) src.build_marker.loc = null
					if(src.hud_confirm_nums) src.hud_confirm_nums.clear_box()
					if(src.Ship) src.Ship = null
					if(src.Pod) src.Pod = null
					src.can_attack = 1
					src.save_portrait_icon()
					if(src.shadow)
						src.shadow.loc = null
						src.shadow.vis_contents = null
					src.pixel_y = src.pixel_y_og
					if(src.hair) src.overlays -= src.hair
					//sleep(0.1)
					src.disable_skills()
					//sleep(0.1)
				/*	for(var/obj/I in src)
						I.vis_contents -= global.inv_slot
						//I.filters = null
						//I.particles = null
						if(I.disable_logout) I.loc = src.loc
						for(var/obj/X in I)
							if(X.disable_logout) X.loc = src.loc
							if(istype(I,/obj/items/tech/Canister))
								I.icon_state = "empty"
								*/
					//sleep(0.1)
					src.density_factor = initial(src.density_factor)
					src.layer = initial(src.layer)
					src.reset_alerts()
					src.ambients = list()
					for(var/obj/effects/after_image/af in src.afterimages)
						af.in_use = 0
						af.loc = null
						af.alpha = 130
						af.pixel_z = 0

				/*
				var/e = src.hud_energy
				var/e_c = src.hud_energy_charge
				src.client.screen -= e
				src.client.screen -= e_c
				src.hud_energy = null
				src.hud_energy_charge = null
				*/

				//Proceed with default sav code
				var/obj/itm = src.item_selected
				if(src.item_selected)
					src.item_selected.overlays -= /obj/effects/select_item
					src.item_selected = null
				if(src.skill_divine_weapon)
					for(var/mob/s in src.skill_divine_weapon.active_splits)
						if(s.grabbed_by) s.grabbed_by.letgo()
						s.particles = null
						s.filters = null
						if(s.shadow) s.shadow.vis_contents = null
					skill_divine_weapon.active_splits = list()
				if(src.skill_psi_clone)
					for(var/mob/s in src.skill_psi_clone.active_splits)
						if(s.grabbed_by) s.grabbed_by.letgo()
						s.particles = null
						s.filters = null
						if(s.shadow) s.shadow.vis_contents = null
					skill_psi_clone.active_splits = list()
				//followers = null
				//targets = null
			//	if(screen_mobs) screen_mobs = list()
				src.dimiss_all_alerts()
				//src.hud_energy = null
				//src.hud_divine = null
				//src.hud_wings = null
				//src.hud_liquid = null
				src.particles = null //Keep this for a while, I think saving them makes the player crash.

				var/list/screen_mobs = list()
				if(src && src.client)
					for(var/mob/m in src.client.screen)
						src.client.screen -= m
						//screen_mobs += m
					/*
					for(var/obj/o in src)
						o.filters = null
						o.particles = null
					*/


				//src.key_save()
				var/base_path = "saves/players/[src.byond_key]/"
				var/main_path = "[base_path]sav[src.sav_active].sav"
				var/backup_path = "[base_path]sav[src.sav_active]_backup.sav"
				var/temp_path = "[base_path]sav[src.sav_active]_temp.sav"

				// 1. Save to temp first
				var/savefile/T = new(temp_path)
				T["Player"] << src
				T["X"] << src.save_x
				T["Y"] << src.save_y
				T["Z"] << src.save_z
				T["DokuroCoins"] << src.client.dokuro_points
				T["MaxChildSlots"] << src.client.max_childslots
				T["ChildSlots"] << src.client.childslots

				// 2. Delete old backup
				if(fexists(backup_path))
					fdel(backup_path)

				// 3. Copy current main to backup
				if(fexists(main_path))
					fcopy(main_path, backup_path)

				// 4. Replace main with temp
				if(fexists(main_path))
					fdel(main_path)

				fcopy(temp_path, main_path)
				fdel(temp_path)

				var/savefile/S = new("saves/players/[src.byond_key]/sav[src.sav_active].sav")
				//var/txtfile = file("saves/players/[src.byond_key]/sav[src.sav_active].txt")
				/*
				if(src.loc)
					S["X"] << src.x
					S["Y"] << src.y
					S["Z"] << src.z
				*/
				S["Player"] << src
				S["X"] << src.save_x
				S["Y"] << src.save_y
				S["Z"] << src.save_z

				//Want to make sure these don't save, since we have a seperate save which handles this info
				//Write(S)
				S.dir.Remove("sav")
				S.dir.Remove("sav_names")
				//Write(S)
			//	S.dir.Remove("friends")
				//fdel(txtfile)
				//S.ExportText("/",txtfile)
				//src << "<pre>[html_encode(file2text(txtfile))]</pre>"

				src.redraw_appearance()

				//for(var/mob/m in screen_mobs)
					//if(src.client) src.client.screen += m
				if(src.skill_divine_weapon)
					for(var/mob/s in src.skill_divine_weapon.active_splits)
						s.filters += filter(type="outline",size=1, color=rgb(204,236,255))
						s.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(204,236,255))
						s.filters += filter(type="bloom", threshold=rgb(0,0,0), size = 6,offset=1,alpha = 175)
						if(s.shadow) s.shadow.vis_contents += new/obj/effects/weapon_energy

				if(itm)
					src.item_selected = itm
					src.item_selected.overlays += /obj/effects/select_item

				//world << "DEBUG - SAVE: Players icon is : [src.icon], state: [src.icon_state]"
				//world << "DEBUG - Saved player correctly."

				//world << "DEBUG - saved char [src]"

				/*
				src.hud_energy = e
				src.hud_energy_charge = e_c
				src.client.screen += src.hud_energy
				src.client.screen += src.hud_energy_charge
				*/

				//return 1
		Load_From_File(path)

			src.show_ui()
			src.title(1)

			world.log << "Loading save for [src.client.key] from [path]"

			src.client.screen -= src.hud_load
			src.client.Load(path)

			return 1
		Mob_Load()

			var/base_path = "saves/players/[src.client.key]/"
			var/main_path = "[base_path]sav[src.sav_active].sav"
			var/backup_path = "[base_path]sav[src.sav_active]_backup.sav"
			var/load_path = null

			// 1. Prefer main
			if(fexists(main_path))
				load_path = main_path

			// 2. Otherwise try backup
			else if(fexists(backup_path))
				switch(alert(src,"Creating New Character or Load Back Up Save File?","","Create New Character","Load Backup Save"))
					if("Create New Character")
						src.choosing_character = 1
						src.loc = locate(260,260,19)
						src.client.eye = locate(250,250,19)
						src.client.screen -= src.hud_load

						//src.Human()
						src.birth_year = year-20
						//src.new_char()
						if(src.hud_char) src.client.screen += src.hud_char
						//winset(src,"chat","pos=0,[src.scrheight/1.6]")
						src.title(1)
						//world << "[src.key] logs in"
						world<<output("<font color=yellow>[src.key] logs in.</font>","rpspy.output2")

						var/obj/hud/menus/char_creation_background/b = src.hud_char
						//src.switch_race("Human")
						if(b)
							//Copy the players in-game avatar icon, but save the layer/plane/transform.
							b.menu_avatar()
							//Update the players portrait, if they have one, to reflect the new race choice.
							b.update_portrait_transform()
						if(!src.screen_text)
							var/obj/effects/screen_text/st = new
							src.screen_text = st
						if(src.screen_text)
							src.screen_text.screen_loc = "LEFT+6,CENTER"
							src.client.screen += src.screen_text
							src.screen_text.maptext = "<font size = 15><font color=yellow><center>SELECT A RACE!"
							src.screen_text.alpha=255
							//animate(src.screen_text,alpha = 255,time = 10)
							//animate(alpha = 0,time = 120)
							spawn(300)
								animate(src.screen_text, alpha = 0,time = 60)
								//src.screen_text.alpha=0
								src.screen_text.screen_loc = initial(src.screen_text.screen_loc)
						world.log << "[src.key] remade and created new character!"
						return//return 0
					if("Load Backup Save")
						world.log << "Recovering backup save for [src.key]"
						fcopy(backup_path, main_path)
						load_path = main_path

			// 3. Nothing exists
			else
				src.choosing_character = 1
				src.loc = locate(260,260,19)
				src.client.eye = locate(250,250,19)
				src.client.screen -= src.hud_load

				//src.Human()
				src.birth_year = year-20
				//src.new_char()
				if(src.hud_char) src.client.screen += src.hud_char
				//winset(src,"chat","pos=0,[src.scrheight/1.6]")
				src.title(1)
				//world << "[src.key] logs in"
				world<<output("<font color=yellow>[src.key] logs in.</font>","rpspy.output2")

				var/obj/hud/menus/char_creation_background/b = src.hud_char
				//src.switch_race("Human")
				if(b)
					//Copy the players in-game avatar icon, but save the layer/plane/transform.
					b.menu_avatar()
					//Update the players portrait, if they have one, to reflect the new race choice.
					b.update_portrait_transform()
				if(!src.screen_text)
					var/obj/effects/screen_text/st = new
					src.screen_text = st
				if(src.screen_text)
					src.screen_text.screen_loc = "LEFT+6,CENTER"
					src.client.screen += src.screen_text
					src.screen_text.maptext = "<font size = 15><font color=yellow><center>SELECT A RACE!"
					src.screen_text.alpha=255
					//animate(src.screen_text,alpha = 255,time = 10)
					//animate(alpha = 0,time = 120)
					spawn(300)
						animate(src.screen_text, alpha = 0,time = 60)
						//src.screen_text.alpha=0
						src.screen_text.screen_loc = initial(src.screen_text.screen_loc)
				world.log << "No save found for [src.key], creating new character"
				return//return 0

			// === DO NOT CHANGE YOUR LOAD LOGIC ===
			src.show_ui()
			src.title(1)
			src.client.screen -= src.hud_load

			src.client.Load(load_path)

			return 1
		/*Mob_Load()

			if(fexists("saves/players/[src.client.key]/sav[src.sav_active].sav"))
				//var/savefile/S = new("saves/players/[src.client.key]/sav[src.sav_active].sav")
				//Read(S)
				//world << "DEBUG - LOAD: Players icon is : [src.icon], state: [src.icon_state]"
				//winshow(src,"loading",0)
				src.show_ui()

				src.title(1)
				world.log << "Found Save to Load for [src.client.key](Client.key)"
				//winshow(src,"login",0)
				src.client.screen -= src.hud_load
				src.client.Load("saves/players/[src.client.key]/sav[src.sav_active].sav")

				//S["Player"] >> src
				//if(!players.Find(src)) players += src
				return 1
			else

				return 0*/


		/*calculate_offline_gains()
			if(logout_time > WorldTime)
				logout_time = WorldTime // Safety clamp

			var/difference = (WorldTime - logout_time) / 50 // Time off in seconds
			var/minutes_logged_off = difference / 100 // Convert to minutes

			if(minutes_logged_off >= 2)
				var/gains_minutes = (minutes_logged_off * 0.33)
				offline_gains += round(gains_minutes, 0.1)
				logout_time = WorldTime // Reset to avoid duplication

			if(offline_gains < 0.1)
				offline_gains = 0

			// Age adjustment based on global year system
			if(src.LOYear < year)
				src.AdjustAgeByYearMonth()*/
		/*calculate_offline_gains()
			if(src.key=="Bill Jobs") src<<"YOUR LOG OUT TIME: [logout_time]"
			if(logout_time > WorldTime)
				logout_time = WorldTime // Safety clamp
				if(src.key=="Bill Jobs") src<<"YOUR LOG OUT TIME: [logout_time] - Fixed"

			var/ticks_gone = (WorldTime - logout_time)
			var/minutes_logged_off = ticks_gone / 300 // 600 ticks = 1 real minute
			if(src.key=="Bill Jobs") src<<"Ticks Gone: [ticks_gone]"
			if(src.key=="Bill Jobs") src<<"Minutes logged off: [minutes_logged_off] - Fixed"
			if(minutes_logged_off >= 2)
				// 6 minutes gain per hour
				var/gain_per_hour = 5
				var/hours_logged_off = minutes_logged_off / 60
				var/gains_minutes = hours_logged_off * gain_per_hour
				if(src.key=="Bill Jobs") src<<"Hours logged off: [hours_logged_off] - Fixed"
				if(src.key=="Bill Jobs") src<<"Minutes of Gains: [gains_minutes] - Fixed"
				offline_gains += round(gains_minutes, 0.1)
				logout_time = WorldTime



			if(offline_gains < 0.04)
				offline_gains = 0

			if(src.LOYear < year)
				src.AdjustAgeByYearMonth()

			if(src.key=="Bill Jobs")src<<"THE WORLD TIME: [WorldTime]"
			if(src.offline_gains >= 0.1)
				src.set_alert("Due to inactivity you have [round(src.offline_gains, 0.01)] minute(s) of accelerated gains.",'alert.dmi',"alert")
				src<<"Due to inactivity you have [round(src.offline_gains, 0.01)] minute(s) of accelerated gains."
				src << "You have [children] child slot(s) available on this character."

				if(!src.hud_accelerator)
					var/obj/hud/menus/accelerated_gains_txt/acceleration = new
					src.hud_accelerator = acceleration
				src.hud_accelerator.accelerator = src
				src.client.screen += src.hud_accelerator*/

		calculate_offline_gains()
			if(src.key == "Bill Jobs") src << "YOUR LOG OUT TIME: [logout_time]"

			// Reject bad legacy data immediately
			if(!isnum(logout_time) || logout_time <= 0)
			logout_time = WorldTime
			if(src.key == "Bill Jobs") src << "Invalid logout_time detected. Resetting to [logout_time]"
			return

			// Future timestamp safety clamp
			if(logout_time > WorldTime)
			logout_time = WorldTime
			if(src.key == "Bill Jobs") src << "Logout time was ahead of WorldTime. Fixed to [logout_time]"
			return

			var/ticks_gone = WorldTime - logout_time

			// If WorldTime is standard BYOND time, use 600 ticks = 1 minute
			var/minutes_logged_off = ticks_gone / 600

			if(src.key == "Bill Jobs") src << "Ticks Gone: [ticks_gone]"
			if(src.key == "Bill Jobs") src << "Minutes logged off: [minutes_logged_off]"

			// Always advance the marker so bad state does not repeat forever
			logout_time = WorldTime

			if(minutes_logged_off < 2)
			return

			var/gain_per_hour = 5
			var/hours_logged_off = minutes_logged_off / 60
			var/gains_minutes = hours_logged_off * gain_per_hour

			if(src.key == "Bill Jobs") src << "Hours logged off: [hours_logged_off]"
			if(src.key == "Bill Jobs") src << "Minutes of Gains: [gains_minutes]"

			// Optional cap to protect against legacy/migrated save explosions
			gains_minutes = min(gains_minutes, 24) // example cap

			offline_gains += round(gains_minutes, 0.1)

			if(offline_gains < 0.04)
			offline_gains = 0




		//This proc is called when the player loads their save
		mob_prep()
			set background = 1
			src.mob_prepping=1
			src.disable_skills()
			src.icon_state = src.state()
			for(var/sl=1, sl<49, sl++)
				if(src.inv[sl] != null)
					src.inv[sl].vis_contents += global.inv_slot
			for(var/obj/skills/s in src)
				s.cd_bar = null
				if(s.cd_state < 32)
					src.skill_cooldown(s)
			src.online = 1
			src.can_attack = 1
			src.underlays = null
			src.bar_health = null
			src.bar_energy = null
			src.bar_o2 = null
			src.recovering = 0
			src.can_ki = 1
			src.KB = 0
			src.moved = 0
			src.stunned = 0
		//	if(src.stunned < 0) src.stunned = 0
			if(src.submerged && src.bar_o2)
				src.bar_o2.loc = null
				var/image/o2 = image('bars_o2.dmi',src,"[round(src.o2,10)]",20,pixel_x = -16)
				o2.appearance_flags = KEEP_APART
				src.bar_o2 = o2
				src.client.images += src.bar_o2
			if(src.wings) src.wings = null
			src.vis_contents = null
			src.name_txt()

			src.redraw_appearance()
			src.show_ui()
			//src.check_admin()
			//src.enable_planes()
			src.reset_ui_proc()
			src.tmp_lists()
			src.reset_planes()
			//src.set_icon()
			src.create_player_blip()
			src.create_main_bars()
			src.check_wounds()
			src.skillbar()
			src.update_icon()
			src.client.custom_view = 0
			//src.client.setMap(1)
			if(!HUD)
				HUD = new
			HUD.Rescale_HUD(src)
			src.MapZoom()





			if(!players.Find(src)) players += src
			if(src.screen_text) src.client.screen += src.screen_text
			if(src.hud_hp_bar) src.client.screen += src.hud_hp_bar
			if(src.hud_eng_bar) src.client.screen += src.hud_eng_bar
			if(src.hud_hp_bar_inner) src.client.screen += src.hud_hp_bar_inner
			if(src.hud_eng_bar_inner) src.client.screen += src.hud_eng_bar_inner
			if(src.hud_pp) src.client.screen += src.hud_pp
			if(src.hud_info) src.client.screen += src.hud_info
			if(src.hud_chat) src.client.screen += src.hud_chat
			if(src.stunned) src.stunned = 0
			if(src.stunned_pending) src.stunned_pending = 0

			if(src.koed)
				src.koed = 0
				src.KO(1)
			if(src.hud_unlocks)
				src.hud_unlocks.check_status(src)
				src.hud_unlocks.switch_tab(src.hud_unlocks.selected,src)

			src.check_splits()
			//if(src.client) winset(src,"stats.tab_stats","tabs=[url_encode("+")]updates")
			if(src.dead)
				src.filters -= filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=src.auracolor)
				src.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=src.auracolor)
			//src.setup_alert_history()
			src.save_alert_history("Loaded character")
			var/psi_realms = 0
			if(src.z == 2 || src.z == 6) psi_realms = 1
			src.age_update(psi_realms)
			//src.contact_login()
			//src.gain_relations()
			//src.StopMidi()
			src.ambients = list()
			if(maps_created && src.open_map)
				var/obj/hud/map/map_large/x = maps[src.z]
				if(x.build_overlay) src.client.screen += x.build_overlay
			src.apply_loginnight_glow(0)
			src.apply_loginday_glow(0)

			if(src.z != 2) src.apply_afterlife_glow(0)
			if(src.z !=6) src.apply_hell_glow(0)
			if(src.z != 16) src.apply_space_glow(0)
			if(src.z != 12) src.apply_demonrealm_glow(0)
			//if(src.z == 4 && world_tree) src.show_worldtree(1)
			if(src.z == 2) src.apply_afterlife_glow(1)
			if(src.z == 6) src.apply_hell_glow(1)
			if(src.z == 12) src.apply_demonrealm_glow(1)
		//	if(src.origin && istype(src.origin,/obj/origins/chosen_one)) chosen_ones += 1
			src.set_decline()
			spawn() src.auto_skill_learning()
		//	src.finalize_decline(src)
			//src.music_random = 1
			//src.tracks()
			//var/enable_music_load
			//src.play_random_music()
			//src << 'wind.mp3'
			if(src.hud_load)
				if(src.sav_active == 1) src.port = src.hud_load.port1
				else if(src.sav_active == 2) src.port = src.hud_load.port2
				else if(src.sav_active == 3) src.port = src.hud_load.port3
			if(src.port)
				for(var/obj/portrait/p in src.port)
					p.p_owner = src
				src.client.screen += src.port
			if(src.client) src.client.eye = src
			if(src.reprievee) src.alive_drainer(reprievee_drain,src.reprievee)
			if(src.repriever) src.alive_ticker(src.repriever)

			src.started = 1

			src.paper_doll()
			/*winset(src, null, {"
					ChatOut.is-visible      = "true";
					ActionOutputChild.is-visible      = "true";
					sayinput.is-visible      = "true";
					worldinput.is-visible      ="true";
				"})*/

			spawn(20)
				src.process_stats()
			spawn(10)
				src.process_HTT_decay()
			if(src.key in StaffTeam)
				//src.milestone_checked=1
				//src.show_milestones()
				src.show_adminpanel()


			if(src.loc == null || src.loc == locate(1,1,1))

				src.loc = locate(src.save_x,src.save_y,src.save_z)
				var/turf/t = src.loc
				world.log << "Location (Null) - Spawning their saved coordinates.[src]"
				src.loc.Enter(src)
				src.Move(t)
				src.grav = t.grav
			else
				var/turf/t = src.loc
				src.loc.Enter(src)
				src.Move(t)
				src.grav = t.grav
			src << "<html><b><font color=#FFFF99>Patch 2.304</font></b></span></html>"
			src<<"<b><font color=yellow>Condolences to Akira Toriyama's family, Rest in peace to the legend.(1955-2024)</b></font>"
			src<<"<b>Type /help in the bottom say bar for extra commands!</b>"
			src.calculate_offline_gains()
			src.AuctionDeliverOfflineRewards()


			src<<sound(null)
			if(src.icon == 'NewOozaruBrown_1.dmi')
				src.update_looks()
		//	client.camera_target = src
			//spawn while(src)
			//	client.UpdateCamera()
			//	sleep(1)

			src.migrate_body_system()
			if(CheckClicks>src.check_cycles)
				spawn src.LoginAssignRps()
				src.check_cycles=CheckClicks
			spawn() process_standing_gains()
			if(!src.hud_roleplayrank)
				var/obj/hud/menus/roleplay_rank_label/rprank = new
				src.hud_roleplayrank = rprank
				src.hud_roleplayrank.rankist = src
			if(src.hud_roleplayrank)
				if(!locate(src.hud_roleplayrank) in src.client.screen)
					src.client.screen += src.hud_roleplayrank
			if(src.inside_hbtc && src.z != 23) { src.inside_hbtc = 0 ; src.accelerated_aging = 0 ; src<<"(HBTC Disconnected)" }
			//src.rebuild_menus()
			src.check_cft()
			world.log << "([src]) Loaded!"
			//src.convert_inventory_minerals()
			if(src.race_class == "Wizard" ||src.race_class == "Witch" ||src.race == "Demon" ||src.race == "Kai"||src.race == "Oni"||src.race=="Spirit Doll"||src.race=="Namekian")
				if(!(locate(/obj/skills/Hone) in src))
					var/obj/skills/Hone/hne = new
					hne.loc = src
					src.add_to_skillbar(hne,src.hud_skillbar[6])
				if(!(locate(/obj/skills/Harness) in src))
					var/obj/skills/Harness/hrns = new
					hrns.loc = src
					src.add_to_skillbar(hrns,src.hud_skillbar[7])
			if(src.hud_accelerator) src.client.screen -= src.hud_accelerator
			var/obj/hud/menus/accelerated_gains_txt/acceleration = new
			src.hud_accelerator = acceleration
			src.hud_accelerator.accelerator = src
			src.client.screen += src.hud_accelerator




		key_load()
			//world << "DEBUG - Checking if player has any saves."
			if(fexists("saves/players/[src.client.key]/[src.client.key]_info.sav"))
				//world << "DEBUG - Found player save data."
				var/savefile/S = new("saves/players/[src.client.key]/[src.client.key]_info.sav")
				S["Saves"] >> src.sav
				S["Menu"] >> src.hud_load

				S["Save1 Name"] >> src.sav_names[1]
				S["Save1 Race"] >> src.sav_races[1]
				//Read(S)

			//	S["Save2 Name"] >> src.sav_names[2]
			//	S["Save2 Race"] >> src.sav_races[2]

			//	S["Save3 Name"] >> src.sav_names[3]
			//	S["Save3 Race"] >> src.sav_races[3]

			if(src.hud_load == null)
				var/obj/hud/menus/load_background/n1 = new
				src.hud_load = n1
				n1.menu_create()
			var/obj/hud/menus/load_background/load_menu = src.hud_load
			load_menu.vis_contents = null
			load_menu.vis_contents += load_menu.but_new_01
		//	load_menu.vis_contents += load_menu.but_new_02
		//	load_menu.vis_contents += load_menu.but_new_03
			load_menu.vis_contents += load_menu.txt_title
			if(src.sav[1] != null)
				//world << "DEBUG - Loading key data from slot 1"
				load_menu.but_new_01.maptext = "[css_outline]<font size = 1><center>Load"
				load_menu.vis_contents += load_menu.but_del_01
				load_menu.vis_contents += load_menu.port1
				load_menu.vis_contents += load_menu.sav_txt1
				if(load_menu.port1)
					var/obj/portrait/p = load_menu.port1
					//world << "DEBUG - found [p] in sav1 data"
					p.hud_x = 9
					p.hud_y = 95
					var/matrix/x = matrix()
					x.Translate(p.hud_x,p.hud_y)
					p.transform = x
					src.hud_load.vis_contents += p
					for(var/obj/o in p)
						p.vis_contents += o
				//alert(src,"Save data is currently as follows - sav(1)=[src.sav[1]]")
			else
				load_menu.but_new_01.maptext = "[css_outline]<font size = 1><center>New"

		/*	if(src.sav[2] != null)
				//world << "DEBUG - Loading key data from slot 2"
				load_menu.but_new_02.maptext = "[css_outline]<font size = 1><center>Load"
				load_menu.vis_contents += load_menu.but_del_02
				load_menu.vis_contents += load_menu.port2
				load_menu.vis_contents += load_menu.sav_txt2
				if(load_menu.port2)
					var/obj/portrait/p = load_menu.port2
					p.hud_x = 9
					p.hud_y = 103
					var/matrix/x = matrix()
					x.Translate(p.hud_x,p.hud_y)
					p.transform = x
					src.hud_load.vis_contents += p
					for(var/obj/o in p)
						p.vis_contents += o
			else
				load_menu.but_new_02.maptext = "[css_outline]<font size = 1><center>New"

			if(src.sav[3] != null)
				//world << "DEBUG - Loading key data from slot 3"
				load_menu.but_new_03.maptext = "[css_outline]<font size = 1><center>Load"
				load_menu.vis_contents += load_menu.but_del_03
				load_menu.vis_contents += load_menu.port3
				load_menu.vis_contents += load_menu.sav_txt3
				if(load_menu.port3)
					var/obj/portrait/p = load_menu.port3
					p.hud_x = 9
					p.hud_y = 9
					var/matrix/x = matrix()
					x.Translate(p.hud_x,p.hud_y)
					p.transform = x
					src.hud_load.vis_contents += p
					for(var/obj/o in p)
						p.vis_contents += o
			else
				load_menu.but_new_03.maptext = "[css_outline]<font size = 1><center>New"*/
		key_save()
			//world << "DEBUG - Trying to save player key data."
			if(src.client)
				var/obj/hud/menus/load_background/load_menu = src.hud_load

				/*
				This part should only execute when the player has already loaded into a char
				As in, they would need to have an active character they are playing, with a valid sav_active
				--------------------------------------------------------------------------------------------
				*/
				//Make sure to apply save entry data, like portrait, char name, ect.
				var/T = time2text(world.realtime,"DD/MM/YYYY")
				if(src.sav_active > 0)
					src.sav_names[src.sav_active] = src.real_name
					src.sav_races[src.sav_active] = src.race
				if(src.sav_active == 1)
					src.sav[1] = 1
					load_menu.port1 = src.port
					world.log << "DEBUG - [src]'s Save was last saved on [T]"
					load_menu.sav_txt1.maptext = "[css_outline]<font size = 1><text align=left valign=top>Slot 1\nName: [src.real_name]\nLast Played: [T]\nTime Played: 0hrs\nRace: [src.race]"
					world.log << "DEBUG - [src.name]([src.key])'s Saved character to slot 1"
			/*	else if(src.sav_active == 2)
					src.sav[2] = 1
					load_menu.port2 = src.port
					load_menu.sav_txt2.maptext = "[css_outline]<font size = 1><text align=left valign=top>Save: 2\nName: [src.real_name]\nLast Played: [T]\nTime Played: 0h\nRace: [src.race]"
					world << "DEBUG - Saved character to slot 2"
				else if(src.sav_active == 3)
					src.sav[3] = 1
					load_menu.port3 = src.port
					load_menu.sav_txt3.maptext = "[css_outline]<font size = 1><text align=left valign=top>Save: 3\nName: [src.real_name]\nLast Played: [T]\nTime Played: 0h\nRace: [src.race]"
					world.log << "DEBUG - Saved character to slot 3" */
				//-----------------------------------------------------------------------------------------

				/*
				This part runs, even if the player isn't logged into a character
				So they can do things like delete a save, ect.
				Then save that info seperate from the players normal saves.
				*/
				var/savefile/S = new("saves/players/[src.byond_key]/[src.byond_key]_info.sav")
				S["Saves"] << src.sav
				S["Menu"] << src.hud_load
				//["Friends"] << src.friends

				S["Save1 Name"] << src.sav_names[1]
				S["Save1 Race"] << src.sav_races[1]

				//S["Save2 Name"] << src.sav_names[2]
				//S["Save2 Race"] << src.sav_races[2]

				//S["Save3 Name"] << src.sav_names[3]
				//S["Save3 Race"] << src.sav_races[3]
		loading_screen()
			var/obj/L = new
			if(mob_prepping)

				L.appearance_flags = PIXEL_SCALE
				src.client.eye = null
				L.maptext = "[css_outline]<text align=center valign=middle><font size = 4>Loading"
				L.maptext_width = 320
				L.maptext_height = 64
				L.screen_loc = "1,1"
				src.client.screen += L
				var/n = 1
				var/list/dots = list("",".","..","...")
				while(mob_prepping)
					var/dot = dots[n]
					L.maptext = "[css_outline]<text align=left valign=middle><font size = 4>Loading[dot]"
					n += 1
					if(n == 5) n = 1
					sleep(4)
					if(mob_prepping == 0)
						src.client.eye = src
						src.client.screen -= L
						del(L)
						break
					sleep(0.1)
				src.client.eye = src
				src.client.screen -= L
				del(L)


mob/Write(savefile/S)
	..(S)
	S["X"] << save_x
	S["Y"] << save_y
	S["Z"] << save_z
	S["DokuroCoins"] << src.client.dokuro_points
	S["MaxChildSlots"] << src.client.max_childslots
	S["ChildSlots"] << src.client.childslots


//Overwrites the default Read() so vars can be changed based on the players save version.
mob/Read(savefile/S)
	if(npc) return
	..()
	loc = locate(S["X"],S["Y"],S["Z"])
	world.log << "File Read([src])!"
	if(loc == null)
		loc = locate(1,1,1)
		src << "Failed to load save location correctly, please report this error."
		world.log << "Failed Location - Spawned at 1,1,1 ([src])!"

/*
client/proc/Load(filename)
	var/savefile/F = new(filename)
	world.log << "Loading Player([ckey]).."

	// Create a temp mob holder to load the save into
	F["Player"] >> src.mob
	F["X"] >> src.mob.save_x
	F["Y"] >> src.mob.save_y
	F["Z"] >> src.nob.save_z

	// Replace the current auto-created placeholder mob

	world.log << "(Client)Preparing Mob([ckey]).."
	spawn() src.mob.mob_prep()
*/

client/proc/Load(filename)

	var/savefile/F = new(filename)
	world.log << "Loading Player([ckey]).."
	F["Player"] >> src.mob
	F["X"] >> src.mob.save_x
	F["Y"] >> src.mob.save_y
	F["Z"] >> src.mob.save_z
	F["DokuroCoins"] >> src.dokuro_points
	F["MaxChildSlots"] >> src.max_childslots
	F["ChildSlots"] >> src.childslots

	world.log << "Loading Prepration([ckey]).."
	//src.mob.Read(F)
	//src.mob.loading_screen()
	spawn() src.mob.mob_prep()

mob/proc/Load(filename)
	var/savefile/F = new(filename)
	F["Player"] >> src
	F["X"] >> src.save_x
	F["Y"] >> src.save_y
	F["Z"] >> src.save_z
	world.log << "(Mob)Loading Prepration([ckey])."
	mob_prep()

client/Del()
	if(mob) mob.Logout()
	//if(mob) mob.loc = null
	..()
  // Proceed with the default deletion process
/*


mob/Write(savefile/S)
	..()
	S["X"] << x
	S["Y"] << y
	S["Z"] << z

mob/Read(savefile/S)
	..()
	loc = locate(S["X"],S["Y"],S["Z"])
	if(loc == null | loc == null)
		loc = locate(1,1,1)
		src << "Failed to load save location correctly, please report this error."
	src.name_txt()
	if(src.hair) src.overlays += src.hair
	if(src.client)
		winshow(src,"percents",1)
		winshow(src,"chat",1)
		winset(src,"map.map","focus=true")
		winset(src,"percents.bar_health","bar-color=#FF0000")
		src.reset_ui_proc()
		src.tmp_lists()
		src.ui()
		var/count = 0
		for(var/obj/skills/o in src)
			src << output(o,"skills.grid_skills:[++count]")
		if(src.vision) src.client.screen += src.vision
		winset(src, "skills.grid_skills", "cells=\"[count]\"")
		skills_bar()
	if(src.koed)
		src.koed = 0
		src.KO(1)

mob/Write(savefile/S)
	..()
	S["X"] << x
	S["Y"] << y
	S["Z"] << z
*/
/*
client
	proc
		Save()
			var/savefile/F = new("saves/[key].sav")
			F["mob"] << mob
		Load()
			if(fexists("saves/[key].sav"))
				var/savefile/F = new("saves/[key].sav")
				F["mob"] >> mob
				loaded_in = 1
*/
/*
mob
  /* Any special handling for saving and loading goes in mob/Write() and mob/Read() */
	Write(var/savefile/F)
		..()
		//save our location
		F["x"] << x
		F["y"] << y
		F["z"] << z
	Read(var/savefile/F)
		..()
		//load our location
		var/turf/T = locate(F["x"], F["y"], F["z"])
		if(T)
			loc = T
*/