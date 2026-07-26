atom
	MouseUp(location,control,params)
		..()
		if(!usr) return
		// Always clear stuck charging input no matter where mouse is released
		usr.mouse_down = null
		usr.drag_icon_x = 0


		if(control != "map.map")
			if(usr.active_attack)
				usr.stop_charging()  // your existing cancel log
		if(control == "map.map")
			if(usr) usr.mouse_saved_loc = src
			if(ismovable(src))
				var/atom/movable/a = src
				if(a.bound_width > 32 || a.bound_height > 32 || a.i_width > 32)
					if(usr) usr.place_percise(params)
					if(usr) usr.mouse_saved_loc = locate(usr.new_x,usr.new_y,src.z)
			//if(usr) usr.mouse_down = null
			//if(usr) usr.drag_icon_x = 0
			if(usr && !usr.left_click_function) usr.client.mouse_pointer_icon = 'mouse.dmi'
			//Makes sure that when the player clicks outside their text input boxes, it no longer counts as them typing inside.
			if(usr.typing && src != usr.typing)
				usr.typing.maptext = "[css_outline]<font size = 1><left>[usr.typing.string_full]"
				usr.typing = null

		//if(usr.tk) usr.drop_tk()
	MouseDown(location,control,params) //Don't think this is continious, basically one half of a click.
		..()
		if(!usr) return
		if(control != "map.map")
			if(usr.active_attack)
				usr.stop_charging()  // your existing cancel log
		params = params2list(params)
		if(isturf(src)) usr.mouse_down = src
		else if(isturf(src.loc)) usr.mouse_down = src.loc
		if(src.can_pocket || src.can_activate) usr.mouse_down = null
		if(params["left"])
			if(usr.current_attack && usr.can_ki)
				if(usr.active_attack == null)
					if(control == "map.map" && location)
						//Make sure attacks don't go off when clicking objects that can be activated
						if(isobj(location))
							var/obj/o = location
							if(o.can_activate)
								return
						if(isobj(src))
							var/obj/o = src
							if(o.can_activate)
								return
						//Otherwise, continue using attacks as usual.
						usr.place_percise(params)
						var/obj/a = usr.current_attack
						if(a.act) call(a,a.act)(usr)
	MouseDrag(over_object,src_location,over_location,src_control,over_control,params)
		..()
		if(!usr) return
		if(!isobj(src)) return
		if(src_control != "map.map") return
		usr.client.update(params)
		usr.mouse_saved_loc = over_location
		if(ismovable(over_location))
			var/atom/movable/a = over_location
			if(a.bound_width > 32 || a.bound_height > 32 || a.i_width > 32)
				if(usr) usr.place_percise(params)
				if(usr) usr.mouse_saved_loc = locate(usr.new_x,usr.new_y,src.z)
		if(usr && usr.client.client_mouse_x)usr.client.prev_mouse_x = usr.client.client_mouse_x
		if(usr &&  usr.client.client_mouse_y)usr.client.prev_mouse_y = usr.client.client_mouse_y
		if(usr)usr.client.MousePosition(params)
		//usr.client.check_mouse_loc(params)
		if(usr.mouse_txt) usr.client.screen -= usr.mouse_txt
		if(isturf(over_location)) usr.mouse_down = over_location
		if(over_control != "map.map") usr.mouse_down = null
		var/atom/spawn_loc = null
		if(isturf(over_location))
			spawn_loc = over_location
		if(isobj(over_location))
			var/obj/o = over_location
			if(isturf(o.loc))
				spawn_loc = o.loc
				usr.mouse_down = o.loc
		if(ismob(over_location))
			var/mob/m = over_location
			if(isturf(m.loc))
				spawn_loc = m.loc
		if(usr.koed)
			spawn_loc = null
		var/obj/proceed = null
		if(spawn_loc)
			for(var/obj/skills/Telekinesis/t in usr)
				if(t.active)
					proceed = t
					break
			if(isobj(proceed))
				if(usr.energy>2)
					if(src in range(20,usr))
						var/obj/O = src
						//var/remove_later
						if(!isturf(O)) if(!O.bolted) if(over_location) if(!O.grabbed_by) //if(!usr.tk_minigame.Find(src))
							//if(O in view(1,over_location))
							if(O.tk == 0)
								O.mouse_opacity  = 0
								animate(O, pixel_z = 16, time = 1)
								O.density_factor = 0
								O.layer += 100
								O.filters += filter(type="drop_shadow", x=0, y=0, size=5, offset=0, color=rgb(102,0,204))
								var/obj/effects/dust_medium/d = new
								d.SetCenter(O)
							//usr.energy -= 0.01+((usr.energy_max*0.25)/proceed.skill_lvl/usr.mod_energy)
							usr.energy -= 1.1-(proceed.skill_lvl/100)
							//usr.gain_stat("force",1,1,"Telekinesis")
							proceed.skill_exp += (10/proceed.skill_lvl)*usr.mod_skill
							if(proceed.skill_exp >= 100 && proceed.skill_lvl < 100)
								proceed.skill_exp = 1
								proceed.skill_lvl += 1
							O.tk = 1
							usr.tk = O
							/*
							var/bumps = 0
							for(var/atom/x in over_location)
								if(x != src) if(x != usr)
									if(x.density_factor) x.vibrate()
									bumps = 1
									usr.drop_tk()
							if(bumps == 0)
							*/
							//O.Move(over_location)
							step_towards(O,over_location,0)
							if(isturf(over_location)) usr.mouse_down = over_location
							if(over_control != "map.map")
								usr.mouse_down = null
								usr.drop_tk()
						if(O.bolted == 1)
							O.shake()
							for(var/obj/skills/Telekinesis/T in usr)
								var/chance = T.skill_lvl/10
								if(usr.trait_ip) chance = 100
								if(prob(chance))
									O.bolted = 0
									break
				else usr.drop_tk()
	MouseMove(location,control,params)
		//Mouse name box code
		//usr.mouse_down = null
		//winset(usr,"main.info_text","text=\"[src]\"")
		//world << "DEBUG  - [location]"
		//var/remove_check_mouse_loc_later
		//usr.check_mouse_loc(params)
		if(usr.client)
			if(usr) usr.client.update(params)
			//var/list/p = params2list(params)
			if(control == "map.map")
				if(usr) usr.mouse_saved_loc = src
				if(usr && usr.client && usr.loc)
					if(ismovable(src))
						var/atom/movable/a = src
						if(a.bound_width > 32 || a.bound_height > 32 || a.i_width > 32)
							if(usr) usr.place_percise(params)
							if(usr) usr.mouse_saved_loc = locate(usr.new_x,usr.new_y,src.z)
					//var/remove_ang
					if(usr) usr.mouse_ang = usr.GetAngle(src)
					if(usr && usr.mouse_txt_confirm == src)
						if(istype(src,/obj/items/))
							usr.client.MousePosition(params)
							usr.create_map_box(params,src)
					else
						if(usr && usr.mouse_txt) usr.client.screen -= usr.mouse_txt
					//End mouse name box code
					if(usr.build_marker == null && usr.started == 1)
						usr.build_marker = new /obj/
						usr.build_marker.bolted = 2
						usr.build_marker.density_factor = 0;
						usr.build_marker.mouse_opacity = 0
						usr.build_marker.layer = 100;
					//Move build_mouse icon to the correct place, and check if the location is too far or not.
					if(usr.build_mouse)
						usr.check_mouse_loc(params)
						if(get_dist(usr,location) < 4)
							if(usr.mouse_far)
								usr.build_mouse.icon = usr.build_mouse_og
								usr.build_mouse.icon += rgb(0,150,0)
								usr.mouse_far = null
						if(get_dist(usr,location) > 4)
							if(usr.mouse_far == null)
								usr.build_mouse.icon = usr.build_mouse_og
								usr.build_mouse.icon += rgb(150,0,0)
							usr.mouse_far = "Too far away."

						if(isturf(usr.mouse_saved_loc)) usr.build_marker.loc = usr.mouse_saved_loc
						//usr.build_marker.loc = locate((usr.x-17)+usr.mouse_x,(usr.y-10)+usr.mouse_y,usr.z)

						for(var/obj/items/tech/t in usr.build_marker.loc)
							if(t.type == usr.build_tech.type)
								usr.build_mouse.icon = usr.build_mouse_og
								usr.build_mouse.icon += rgb(150,0,0)
								usr.mouse_far = "Already same type of tech present."
								break;
						if(isturf(usr.build_marker.loc) || !istype(usr.build_marker.loc,/obj/ShipStuff/))
							var/turf/t = usr.build_marker.loc
							if(t.liquid)
								if(usr.build_tech && usr.build_tech.tech_water == 0)
									if(usr.mouse_far == null)
										usr.build_mouse.icon = usr.build_mouse_og
										usr.build_mouse.icon += rgb(150,0,0)
									usr.mouse_far = "Need solid area."
					//If no build_mouse icon was assigned, but we have a tech or building selected, create the icon.
					else if(usr.build_tech)
						var/image/i = image(usr.build_tech.icon,usr.build_marker,usr.build_tech.icon_state,100)
						//var/icon/ic = new(usr.build_tech.icon)
						//var/w = ic.Width();
						i.mouse_opacity = 0
						i.alpha = 200
						i.pixel_y = usr.build_tech.pixel_y
						i.pixel_x = usr.build_tech.pixel_x
						//if(w > 64) i.pixel_x -= 32
						usr.build_mouse_og = i.icon
						i.icon += rgb(0,150,0)
						usr.client.images += i
						usr.build_mouse = i
			//if(usr.hud_build) usr.client.screen += usr.hud_build
	Click(location,control,params)
		..()
		params = params2list(params)
		//Activate energy attack.
		if(control == "map.map")
			if(params["right"])

				if(usr.skill_remote_viewing && usr.skill_remote_viewing.active) //Cancel using remote viewing for when the map opens for player to choose a location.
					call(usr.skill_remote_viewing.act)(usr,usr.skill_remote_viewing)
					usr.map_proc(1)
				if(usr.active_attack)

					if(istype(usr.active_attack, /obj/skills/Beam))
						usr.CancelBeam()
					else usr.active_attack = null //Cancel the energy attack current being fired or charged.
					return
				if(usr.left_click_function) //Dismiss any left click functions
					if(usr.left_click_function == "restoration") usr.skill_restoration.icon_state = "Revivification off"
					else if(usr.left_click_function == "reformation") usr.skill_reformation.icon_state = "Revivification off"
					else if(usr.left_click_function == "revive") usr.skill_revive.icon_state = "Revivification off"
				//	else if(findtext(usr.left_click_function,"clone"))
						//winshow(usr,"contacts",1)
						//usr.open_contacts = 1
						//usr.open_menus.Add(".open_contacts")
					usr.left_click_function = null
					usr.left_click_ref = null
					//world << "DEBUG - left_click_ref rendered null"
					usr.client.mouse_pointer_icon = 'mouse.dmi'
					return
				if(usr.target_follower)
					if(ismob(usr.target_follower))
						var/mob/m = usr.target_follower
						usr.client.images -= m.target_img
						usr.target_follower = null
						return
				if(usr.target) //Remove current target
					usr.add_remove_target(usr.target,1)
					usr.tab_num = 0
					/*
					if(usr.target.bar_energy)
						usr.client.images -= usr.target.bar_energy
					if(usr.target.bar_health)
						usr.client.images -= usr.target.bar_health
					if(usr.target.target_img) usr.client.images -= usr.target.target_img
					usr.target = null
					usr.reset_estimates()
					*/
					return
				if(istype(usr.build_tech,/obj/items/tech/)) usr.cancel_tech()
				else if(istype(usr.build_tech,/obj/buildings/)) usr.cancel_build()
				else if(istype(usr.build_tech,/obj/body_related/bodyparts/cybernetics/)) usr.cancel_tech()
				else if(istype(usr.build_tech,/obj/items/drugs)) usr.cancel_tech()

				if(usr.talk_to)
					winshow(usr, "dialogue", 0)
					usr.talk_to = null
					usr.topic = null
			else if(usr.rightclick_menu_open)
				var/mob/m = usr.rightclick_menu_open
				for(var/obj/hud/buttons/popup_option/o in m.options)
					o.ref = null
					o.loc = null
					o.pixel_x = 0;
					o.pixel_y = 0;
					usr.rightclick_menu_open = null;
					usr.client.images -= o.img_select
					usr.client.images -= o.img_over
			if(usr.left_click_function == "capsule")
				if(usr.left_click_ref)
					if(get_dist(usr, src) > 2)
						usr << "You are too far away to store that."
						usr.left_click_function = null
						usr.left_click_ref = null
						usr.client.mouse_pointer_icon = 'mouse.dmi'
						return
					var/obj/items/tech/Capsule/capsule = usr.left_click_ref
					if(isobj(src))
						if(!istype(src,/obj/items/consumables/))
							capsule.contents += src
							capsule.storeditem = src
							capsule.suffix = "Capsule - [src.name]"
							capsule.occupied = 1
							view(10,usr)<<output("[usr] stored [src] inside a capsule.","actionoutput")
							usr.left_click_ref=null
				usr.left_click_function = null
				usr.client.mouse_pointer_icon = 'mouse.dmi'
				return
				//m.left_click_function = "revive defibrillator"
						//		m.left_click_ref = i
							//	m.set_alert("Select target to zap",i.icon,i.icon_state)
			//Player activates TK on target
			if(usr.left_click_function == "tk")
				if(ismovable(src))
					var/atom/movable/mov = src
					if(usr.skill_tk && src.bolted < 2)
						if(src.tk == 0)
							src.mouse_opacity  = 0
							animate(src, pixel_z = 16, time = 1)
							src.density_factor = 0
							src.layer += 100
							src.filters += filter(type="drop_shadow", x=0, y=0, size=5, offset=0, color=rgb(102,0,204))
							var/obj/effects/dust_medium/d = new
							d.SetCenter(src)
							if(mov.generator == 1 && mov.can_generate == 1 || mov.icon_state == "battery")
								for(var/turf/trf in mov.locs)
									for(var/obj/items/tech/Power_Line/p in trf)
										spawn(2)
											if(p) p.reconnect_power()
							spawn(1)
								if(usr && src)
									animate(src,pixel_y = 4, time = 10,loop = -1)
									animate(pixel_y = 0, time = 10)
						//usr.energy -= 0.01+((usr.energy_max*0.25)/proceed.skill_lvl/usr.mod_energy)
						usr.energy -= 11-(usr.skill_tk.skill_lvl/100)
						//usr.gain_stat("force",1,1,"Telekinesis")
						usr.skill_tk.skill_exp += (10/usr.skill_tk.skill_lvl)*usr.mod_skill
						if(usr.skill_tk.skill_exp >= 100 && usr.skill_tk.skill_lvl < 100)
							usr.skill_tk.skill_exp = 1
							usr.skill_tk.skill_lvl += 1
						src.tk = 1
						usr.tk = src
					usr.left_click_function = null
					usr.client.mouse_pointer_icon = 'mouse.dmi'
					return
			//Follower grab
			else if(usr.left_click_function == "clone grab")
				if(usr.left_click_ref)
					var/mob/NPC/m = usr.left_click_ref
					usr << output("Selected [src] as target for [usr.left_click_ref] to grab.","chat.world")
					usr << output("Selected [src] as target for [usr.left_click_ref] to grab.","chat.local")
					m.idle_ticks = 0
					m.function = "grab"
					m.target_go = src
					m.icon_state = m.state()
					usr.left_click_function = null
					usr.left_click_ref = null
					usr.client.mouse_pointer_icon = 'mouse.dmi'
					//winshow(usr,"contacts",1)
					//usr.open_contacts = 1
				//	usr.open_menus.Add(".open_contacts")
					if(m.activated == 0)
						m.activated = 1
						m.follower_ai()
					return
			//Follower go
			else if(usr.left_click_function == "clone go")
				if(usr.left_click_ref)
					var/mob/NPC/m = usr.left_click_ref
					usr << output("Selected [src] as target for [usr.left_click_ref] to travel to.","chat.world")
					usr << output("Selected [src] as target for [usr.left_click_ref] to travel to.","chat.local")
					m.idle_ticks = 0
					m.function = "go"
					m.target_go = src
					m.icon_state = m.state()
					usr.left_click_function = null
					usr.left_click_ref = null
					usr.client.mouse_pointer_icon = 'mouse.dmi'
					//winshow(usr,"contacts",1)
					//usr.open_contacts = 1
					//usr.open_menus.Add(".open_contacts")
					if(m.activated == 0)
						m.activated = 1
						m.follower_ai()
					return
			if(isturf(src))
				var/turf/trf = src
				usr.mouse_down = trf
				//Upgrade walls
				if(usr.left_click_function == "upgrade wall")
					if(trf in range(2,usr))
						usr.left_click_function = null
						var/wall_found = 0
						var/h = 100
						var/obj/L = null
						var/Y = 1 + year
						Y = Y / 20
						//for(var/obj/items/tech/sub_tech/Engineering/Structural_Engineering/SE in usr.technology_researched)
						for(var/obj/items/tech/sub_tech/Engineering/Structural_Engineering/SE in global.tech)
							if(usr.tech_unlocked[SE.list_pos] == SE.type)
								if(usr.tech_lvls[SE.list_pos] > 0)
									h = ((SE.tech_lvl**4)*250*Y)+100
									L = SE
						if(L)
							var/b = trf.builder
							usr.left_click_function = null
							for(var/turf/t in turfs[1][trf.z])
								if(t.builder == b)
									if(t.level < L.tech_lvl)
										animate(t, color = list("#000", "#000", "#000", "#fff"),time = 4)
										animate(color = initial(t.color),time = 4)
										wall_found = 1
										t.hp = h
										t.hp_max = h
										t.level = L.tech_lvl
										t.vis_contents = null
										for(var/obj/items/tech/doors/Security_Door_MKI/d in range(1,t))
											animate(d, color = list("#000", "#000", "#000", "#fff"),time = 4)
											animate(color = initial(t.color),time = 4)
											d.hp = h
											d.hp_max = h
											d.level = L.tech_lvl
										sleep(0.1)
							if(wall_found)
								usr << output("Upgraded all building tiles to level [L.tech_lvl], with [Commas(h)] health, on map level [src.z].", "chat.system")
								usr.set_alert("Upgraded tiles",L.icon,L.icon_state)
								//usr.create_chat_entry("alerts","Upgraded tiles.")
							else
								usr << output("No walls found on this map built by the same person.", "chat.system")
								usr.set_alert("Failed to upgrade",L.icon,L.icon_state)
								//usr.create_chat_entry("alerts","Failed to upgrade.")
						else
							usr << output("Need at least one level in Structural Engineering.", "chat.system")
							usr.set_alert("Need Structural Engineering",'alert.dmi',"alert")
						//	usr.create_chat_entry("alerts","Need Structural Engineering.")
					else
						usr << output("[src] is out of range for upgrading.", "chat.system")
						usr.set_alert("Out of range",'alert.dmi',"alert")
						//usr.create_chat_entry("alerts","Out of range.")
			else if(isturf(src.loc)) usr.mouse_down = src.loc
			else usr.mouse_down = null
			if(control != "map.map") usr.mouse_down = null
			if(src.can_pocket || src.can_activate) usr.mouse_down = null
			spawn(0.1)
				if(usr) usr.mouse_down = null
			//Build tech by clicking
			if(usr.build_mouse && usr.build_tech)
				if(usr.mouse_far || get_dist(usr,usr.build_marker) > 4)
					usr << "<font color = red>Unable to place. [usr.mouse_far]"
					usr.set_alert("Unable to place. [usr.mouse_far]",'alert.dmi',"alert")
					return
				if(usr.build_tech)
					if(istype(usr.build_tech,/obj/items/tech/)) usr.build_tech(usr.build_tech,usr.build_marker)
					else if(istype(usr.build_tech,/obj/buildings/)) usr.build(usr.build_tech,usr.build_marker)
					else if(istype(usr.build_tech,/obj/body_related/bodyparts/cybernetics/)) usr.build_tech(usr.build_tech,usr.build_marker)
					else if(istype(usr.build_tech,/obj/items/drugs/)) usr.build_tech(usr.build_tech,usr.build_marker)
				if(usr) usr.mouse_down = null
				return
	DblClick(location,control,params)
		..()
		//usr << output("<font color = teal>Test click","chat.system")
		//src.filters[src.filters.len].transform = turn(src.filters[src.filters.len].transform, 45)
		//animate(src.filters[src.filters.len], transform = turn(src.filters[src.filters.len].transform, 45),  time = 10)
		if(control == "map.map")
		//	if(params["left"])
			if(usr.grab)
				//usr.clear_minigame_lift()
				usr.dir = get_dir(usr,src)
				var/d = usr.GetAngle(src)
				var/atom/a = usr.grab
				usr.grab = null
				switch(rand(1,2))
					if(1)flick(pick("RPunch","LPunch"),usr)
					if(2)flick(pick("RKick","LKick"),usr)
				usr.icon_state = usr.state(1)
				if(prob(45)) view(10, a) << sound('swoophit.ogg', volume = 10)
				spawn(1)
					if(usr) usr.icon_state = usr.state()
					view(10,usr)<<sound('throw.ogg',volume=20)

				a.throwing(src,usr,d,src)
				if(ismob(usr.grab))
					var/mob/m = usr.grab
					m.icon_state = m.state()
			if(usr.tk)
				var/atom/movable/a = usr.tk
				var/d = a.GetAngle(src)
				var/steps = 1 + ((get_dist(src,a)*32)/16)
				a.density_factor = initial(a.density_factor)
				switch(rand(1,2))
					if(1)flick(pick("RPunch","LPunch"),usr)
					if(2)flick(pick("RKick","LKick"),usr)
				while(steps)
					steps -= 1
					if(a && usr && a == usr.tk)
						a.MoveAng(d,16,0,0,null)
					else return
					//sleep(0.2)
			else if(usr.target_follower)
				usr.follower_go_dblclick(src)
				return
			if(usr.skill_explosion && usr.skill_explosion.active)
				if(isturf(src))
					var/obj/skills/Explosion/ex = usr.skill_explosion
					if(usr.skill_explosion.cd_state < 32)
						usr << output("<font color = teal>Skill is on cooldown, please wait.","chat.system")
						//var/is = usr.skill_explosion.icon_state
						usr.skill_explosion.icon_state = "cd"
						spawn(3)
							if(usr.skill_explosion) usr.skill_explosion.icon_state = "Explosion"
						return
					src.explosion(5)
					usr.skill_cooldown(usr.skill_explosion)
					ex.skill_exp += ((100-ex.skill_lvl)*usr.mod_skill)+1
					if(ex.skill_exp >= 100 && ex.skill_lvl < 100)
						ex.skill_exp = 1
						ex.skill_lvl += 1
						ex.skill_up(usr)
			else if(usr.skill_lightning && usr.skill_lightning.active)
				var/obj/skills/Psi_Lightning/pl = usr.skill_lightning
				if(usr.skill_lightning.cd_state < 32)
					usr << output("<font color = teal>Skill is on cooldown, please wait.","chat.system")
					//var/is = usr.skill_lightning.icon_state
					usr.skill_lightning.icon_state = "cd"
					spawn(3)
						if(usr && usr.skill_lightning) usr.skill_lightning.icon_state = "Psi Lightning"
					return
				usr.skill_cooldown(usr.skill_lightning)
				usr.filters -= filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(0,160,230))
				usr.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(0,160,230))
				pl.skill_exp += ((50-(pl.skill_lvl/2))*usr.mod_skill)+0.5
				if(pl.skill_exp >= 100 && pl.skill_lvl < 100)
					pl.skill_exp = 1
					pl.skill_lvl += 1
					pl.skill_up(usr)
				var/obj/effects/lightning_bolt/b = new
				if(isturf(src)) b.loc = src
				else b.loc = src.loc
				spawn(6)
					if(usr) usr.filters -= filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(0,160,230))
			else if(usr.skill_super_speed && usr.skill_super_speed.active)
				var/can_move = 1
				if(usr.koed || usr.stunned || usr.grabbed_by)
					can_move = 0
					usr << output("<font color = teal>Unable to use super speed.","chat.system")
				//if("ko" in usr.states)
					//can_move = 0
				if(usr.KB)
					can_move = 0
				if(src.density_factor == 2)
					can_move = 0
				if(src.density_factor >= 1 && usr.density_factor)
					can_move = 0
				if(src.density)
					can_move = 0
				if(ismob(src.loc))
					can_move = 0
				if(usr.minigame)
					can_move = 0
				if(usr.skill_super_speed.cd_state < 32)
					//m << output("<font color = teal>Skill is on cooldown, please wait.","chat.system")
					//var/is = s.icon_state
					usr.skill_super_speed.icon_state = "cd"
					spawn(3)
						if(usr && usr.skill_super_speed) usr.skill_super_speed.icon_state = "Super Speed off"
					return
				if(can_move)
					if(usr.skill_super_speed && src in range(33,usr))
						var/Drain = (0.5/usr.mod_recovery) + (0.5/usr.skill_super_speed.skill_lvl)
						if(usr.energy>=Drain)
							usr.speed_image(src)
							//usr.icon_state = "dodge"
							//var/Drain = (usr.energy_max/10)/proceed.skill_lvl/usr.mod_recovery/usr.mod_energy
							/*
							if(isturf(src))
								usr.loc = src
							else
								usr.loc = src.loc
							*/
							usr.set_shadow()
							usr.energy -= Drain
						//	usr.gain_stat("energy",1,10,"Super Speed",1)
							//usr.gain_stat("power",1,1,"Super Speed",1)
							//usr.gain_stat("agility",1,10,"Super Speed",1)
							usr.skill_super_speed.skill_exp += (10/usr.skill_super_speed.skill_lvl)*usr.mod_skill
							if(usr.skill_super_speed.skill_exp >= 100 && usr.skill_super_speed.skill_lvl < 100)
								usr.skill_super_speed.skill_exp = 1
								usr.skill_super_speed.skill_lvl += 1
							usr.skill_cooldown(usr.skill_super_speed)
