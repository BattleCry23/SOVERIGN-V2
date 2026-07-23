mob
	var/image/over
	var/obj/village
	MouseEntered(location,control,params)
		var/mob/M = usr
		if(!M || !M.client) return

		M.mouse_over = src

		if(!M.left_click_function)
			M.client.mouse_pointer_icon = 'mouse.dmi'

		if(!src.over)
			var/image/sel = new
			sel.appearance = src.appearance
			sel.override = 1
			sel.loc = src
			src.over = sel

		src.over.loc = src
		src.over.dir = src.dir

		if(src == M)
			src.over.filters = list(filter(type="outline", size=1, color=rgb(0,255,0)))
		else
			src.over.filters = list(filter(type="outline", size=1, color=rgb(255,255,255)))

		if(!M.client.images.Find(src.over))
			M.client.images += src.over
	/*MouseEntered(location,control,params)

		usr.mouse_over = src
		if(!usr.left_click_function) usr.client.mouse_pointer_icon = 'mouse.dmi'
		if(src.over == null)
			var/image/sel = new
			sel.appearance = src.appearance
			//sel.vis_contents = src.vis_contents
			sel.override = 1
			sel.loc = src
			src.over = sel
			//usr << output("DEBUG - Created over image for [src]", "chat.system")
		src.over.loc = src
		usr.client.images += src.over
		while(usr && usr.mouse_over == src)
			src.over.appearance = src.appearance
			src.over.pixel_x = 0
			src.over.pixel_y = 0
			src.over.pixel_z = 0
			//if(src.grabbed_by) src.over.pixel_z = src.pixel_z-16
			src.over.dir = src.dir
			if(src == usr) src.over.filters = filter(type="outline", size=1, color=rgb(0,255,0))
			else src.over.filters = filter(type="outline", size=1, color=rgb(255,255,255))
			/*
			if(src.faction && usr.faction)
				if(src.faction in usr.faction.faction_agressive) src.over.filters = filter(type="outline", size=1, color=rgb(255,0,0))
				if(usr in src.hate_list) src.over.filters = filter(type="outline", size=1, color=rgb(255,0,0))
				if(src == usr) src.over.filters = filter(type="outline", size=1, color=rgb(0,255,0))
			*/
			//sleep(0.1)
			*/
	/*MouseExited(location,control,params)
		if(src.name_txt)
			usr.client.images -= src.name_txt
		usr.client.images -= src.over
		usr.mouse_over = null*/
	MouseExited(location,control,params)
		var/mob/M = usr
		if(!M || !M.client) return

		if(src.over)
			M.client.images -= src.over

		M.mouse_over = null
	Click(location,control,params)
		usr.place_percise(params)
		params = params2list(params)
		//Start right click menu code
		if(params["right"])
			//winset(usr,"psiclone","pos=[usr.client.mouse_x],[usr.client.mouse_y]")
			//var/s = winget(usr, "psiclone", "pos")
			//world << output("new pos = [s]","chat.system")
			if(usr.skill_remote_viewing && usr.skill_remote_viewing.active)
				call(usr.skill_remote_viewing.act)(usr,usr.skill_remote_viewing)
				return
			//Follower selection
			if(usr.left_click_function != "clone grab" && src.owner == usr.real_name)
				var/mob/NPC/m = src
				if(src == usr.target_follower)
					usr.target_follower = null
					usr << output("(Unselected [src].)","actionoutput")
					if(src.target_img) usr.client.images -= src.target_img
					return
				else
					if(usr.target_follower) usr.client.images -= usr.target_follower.target_img
					if(!src.target_img)
						var/image/trg = image('target.dmi',src,"",2)
						src.target_img = trg
					usr.target_follower = src
					if(src.name_txt == null) src.name_txt()
					//src.icon_state = src.state()
					usr << output("(Selected [src].)","actionoutput")
					//usr.client.perspective = EYE_PERSPECTIVE | EDGE_PERSPECTIVE
					//usr.client.eye = src
					if(src.target_img) usr.client.images += src.target_img
					if(src.activated == 0)
						m.activated = 1
						m.follower_ai()
					return
			else if(usr.left_click_function) //Dismiss any left click functions
				if(usr.left_click_function == "restoration") usr.skill_restoration.icon_state = "Revivification off"
				if(usr.left_click_function == "reformation") usr.skill_reformation.icon_state = "Revivification off"
				if(usr.left_click_function == "revive") usr.skill_revive.icon_state = "Revivification off"
				usr.left_click_function = null
				usr.left_click_ref = null
				//world << "DEBUG - left_click_ref rendered null"
				usr.client.mouse_pointer_icon = 'mouse.dmi'
				return
			/*
			if(usr.rightclick_menu_open == null)
				var/opt_n = length(src.options)
				for(var/obj/hud/buttons/popup_option/o in src.options)
					usr.rightclick_menu_open = src;
					var/pix_x = 25;
					var/pix_y = 0;
					if(opt_n == 1 || opt_n == 3 || opt_n == 5) pix_x = 25;
					if(opt_n == 2 || opt_n == 4 || opt_n == 6) pix_x = -41;
					if(opt_n == 3 || opt_n == 4) pix_y = 18;
					if(opt_n == 5 || opt_n == 6) pix_y = -18;
					o.ref = src
					if(!isturf(o.loc)) o.follow_ref()
					o.loc = src.loc
					o.step_x = src.step_x
					o.step_y = src.step_y
					animate(o,pixel_x = pix_x,pixel_y = pix_y,time = 4,easing = BOUNCE_EASING)
					usr.client.images += o.img_select
					opt_n -= 1;
			*/
			return
		//End right click menu code

		//Left click function code

		else
			//Deleting Mobs code
			if(usr.left_click_function == "delete stuff")
				var/mob/N = src
				usr.left_click_ref = N
				usr.hud_confirm.confirm_text(1,"You are about to delete [N] do you accept?",src)
				src.confirm = "accept delete mob"
				return
			//Follower attack
			else if(usr.left_click_function == "clone attack")
				if(usr.left_click_ref && src != usr.left_click_ref)
					var/mob/NPC/m = usr.left_click_ref
					if(m.divine_weapon)
						m.function = null
						m.target = null
						m.target_follow = null
						m.target_go = null
						m.divine_weapon_reset()
						sleep(1)
					if(usr && m && src)
						if(src.divine_weapon && m.divine_weapon)
							usr.left_click_function = null
							usr.left_click_ref = null
							usr.client.mouse_pointer_icon = 'mouse.dmi'
							m.target = src
							m.divine_weapon_attack()
							return
						else
							usr << output("Selected [src] as the target.","actionoutput")
							usr << output("Selected [src] as the target.","actionoutput")
							m.idle_ticks = 0
							m.function = "attack"
							m.target = src
							m.target_follow = src
							m.icon_state = m.state()
							usr.left_click_function = null
							//world << "DEBUG - left_click_ref rendered null"
							usr.left_click_ref = null
							usr.client.mouse_pointer_icon = 'mouse.dmi'
							//winshow(usr,"contacts",1)
							//usr.open_contacts = 1
							//usr.open_menus.Add(".open_contacts")
							if(m.activated == 0)
								m.activated = 1
								m.follower_ai()
						return
			//Follower follow
			else if(usr.left_click_function == "clone follow")
				if(usr.left_click_ref && src != usr.left_click_ref)
					var/mob/NPC/m = usr.left_click_ref
					usr << output("Selected [src] as the target to follow.","actionoutput")
					usr << output("Selected [src] as the target to follow.","actionoutput")
					m.idle_ticks = 0
					m.function = "follow"
					m.target = null
					m.target_follow = src
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
			//Player clicks someone to try and reset their icon
			else if(usr.left_click_function == "reset player icon")
				if(src == usr)
					usr.icon = usr.icon_original
				else if(winget(src,"confirm","is-visible") == "false")
					//winset(src,"confirm.label_confirm","text=\"[usr] would like to reset your icon, do you accept?\"")
					//winshow(src,"confirm",1)
					src.hud_confirm.confirm_text(1,"[usr] would like to reset your icon, do you accept?",src)
					src.confirm = "accept icon reset"
				else usr.set_alert("They are busy",'alert.dmi',"alert")
				usr.left_click_function = null
			//Player clicks someone to try and change their icon
			else if(usr.left_click_function == "change player icon")
				if(src.client)
					if(usr.icon_stored)
						if(src == usr)
							usr.icon = usr.icon_stored
						else if(winget(src,"confirm","is-visible") == "false")
							//winset(src,"confirm.label_confirm","text=\"[usr] would like to change your icon, do you accept?\"")
							//winshow(src,"confirm",1)
							src.hud_confirm.confirm_text(1,"[usr] would like to change your icon, do you accept?",src)
							src.confirm = "accept icon"
							src.icon_offered = usr.icon_stored
						else usr.set_alert("They are busy",'alert.dmi',"alert")
						usr.left_click_function = null
						usr.icon_stored = null
			else if(usr.left_click_function == "gene scan")
				if(src.client)
					if(src == usr)
						var/A
						var/healthstatus = "Fit"
						for(var/mutations/X in src.mutations)
							A+="<b>[src.name]'s mutations</b>\n"
							A+="<font color=green>Family DNA: [src.signature]\n"
							A+="Health Status: [healthstatus]\n"
							A+="<font color=green>[X.info_name] - [X.info]<br>"
						src<<output("[A]","actionoutput")
					else
						if(get_dist(usr,src) <=5 )
							if(usr.left_click_ref)
								var/obj/items/tech/Gene_Scanner/s = usr.left_click_ref
								if(s in usr)
									if(!src.koed)
										switch(alert(src,"[usr] would like to scan your genetics, do you accept?","","Accept","Decline"))
											if("Accept")
												var/A
												var/healthstatus = "Fit"
												for(var/mutations/X in src.mutations)
													A+="<b>[src.name]'s mutations</b>\n"
													A+="<font color=green>Family DNA: [src.signature]\n"
													A+="Health Status: [healthstatus]\n"
													A+="<font color=green>[X.info_name] - [X.info]<br>"
												usr<<output("[A]","actionoutput")
											if("Decline")
												return
												//usr<<"<font color=green>[jointext(src.mutations, ", ")]"

			//Player teaches someone
			else if(usr.left_click_function == "teach")
				if(src.client)
					if(get_dist(usr,src) <= 8)
						if(usr.left_click_ref)
							var/obj/skills/s = usr.left_click_ref
							if(s in usr)

								for(var/obj/skills/sk in src)
									if(sk.type == s.type)
										usr.set_alert("They already have this skill",s.icon,s.icon_state)
										usr<<output("[src.fullname] already has the [s] skill.","actionoutput")
										//usr << output("[src] already has the [s] skill.","chat.system")
										usr.left_click_function = null
										usr.left_click_ref = null
										return
								if(istype(s,/obj/skills/Study/) && usr.key != "VOXTECH")
									usr<<output("You cannot teach people to study.","actionoutput")
									return
								if(istype(s,/obj/skills/Hone/) && usr.key != "VOXTECH")
									usr<<output("You cannot teach people to hone.","actionoutput")
									return
								if(istype(s,/obj/skills/Research/) && usr.key != "VOXTECH")
									usr<<output("You cannot teach people to study.","actionoutput")
									return
								if(istype(s,/obj/skills/Harness/) && usr.key != "VOXTECH")
									usr<<output("You cannot teach people to study.","actionoutput")
									return
								if(istype(s,/obj/skills/Expand/) && usr.key != "VOXTECH" )
									if(src.race == "Changeling" || src.race == "Saiyan" || src.race == "Human")
										usr<<output("They cannot learn to physically expand.","actionoutput")
										return
							if(istype(s,/obj/skills/Create_Namekian_Dragonballs/) && usr.key != "VOXTECH")
								if(src.race != "Namekian")
									usr<<output("They cannot learn to physically create namekian dragonballs.","actionoutput")
									return
							//	if(winget(src,"confirm","is-visible") == "false")
									//winset(src,"confirm.label_confirm","text=\"[usr] would like to teach you [s], do you accept?\"")
									//winshow(src,"confirm",1)
								//switch(alert(src,"[usr] would like to teach you [s], do you accept?","","Accept","Decline"))
								//	if("Accept")

								if(src.move_lvl<usr.move_lvl&&usr.occupation=="None")
									src<<"You are too advanced to learn this technique."
									usr<<"They are too advanced to learn this technique."
									//usr.
									return

								if(usr.energy_max<s.teach_energy*2.5&&usr.occupation=="None")
									src<<"You are not advanced enough to learn this technique."
									usr<<"They are not advanced enough to learn this technique."
									return

								src.confirm = "accept teaching"
								src.learning = s
								usr.left_click_function = null
								usr.left_click_ref = null
								usr.set_alert("Teaching invite sent",s.icon,s.icon_state)
								src.hud_confirm.confirm_text(1,"[usr] would like to teach you [s], do you accept?",src)
								//usr.create_chat_entry("alerts","Teaching invite sent.")
								return

									//	else
								//	usr.set_alert("They are busy",'alert.dmi',"alert")
									//usr << output("[src] is busy, they already have a different confirmation window open.","chat.system")
								//	usr.left_click_function = null
								//	usr.left_click_ref = null
									//return
					else
						usr.set_alert("Too far away",'alert.dmi',"alert")
					//	usr.create_chat_entry("alerts","Too far away.")
						usr << output("[src] is too far away.","actionoutput")
						usr.left_click_function = null
						usr.left_click_ref = null
						return
			//Player adds a contact
			else if(usr.left_click_function == "add contact")
				usr.left_click_function = null
				if(src.client)// && src != usr)
					usr.new_contact(src)
					winshow(usr,"contacts",1)
					usr.open_contacts = 1
					usr.open_menus.Add(".open_contacts")
			//Player telepaths someone
			else if(usr.left_click_function == "telepath")
				winset(usr,"numbers.label_numbers","text=\"What would you like to telepath?\"")
				winshow(usr,"numbers",1)
				usr.numbers_text = "telepath"
				usr.left_click_function = null
				usr.left_click_ref = src
			/*
			//Player revives someone
			else if(usr.left_click_function == "revive")
				if(src.client)
					usr.left_click_function = null
					if(get_dist(usr,src) > 2)
						usr << output("<font color = teal>They are too far away to interact with.","chat.system")
						usr.set_alert("Too far away",'alert.dmi',"alert")
						usr.skill_revive.icon_state = "Revivification off"
						return
					if(src.has_body == 0)
						usr << output("<font color = teal>They need to have a body to attempt the revivification process.","chat.system")
						usr.set_alert("Need body",usr.skill_revive.icon,usr.skill_revive.icon_state)
						usr.skill_revive.icon_state = "Revivification off"
						return
					if(src.dead == 0)
						usr << output("<font color = teal>They are already alive.","chat.system")
						usr.set_alert("Already alive",usr.skill_revive.icon,usr.skill_revive.icon_state)
						usr.skill_revive.icon_state = "Revivification off"
						return
					if(src.dead && src.z == 2)
						for(var/obj/skills/Meditate/med in usr)
							if(med.active) call(med.act)(usr,med)
						usr.skill_revive.active = 1
						usr.skill_revive.skill_target = src
						usr.icon_state = "meditate"
						usr.stunned += 1
						usr.stunned_pending += 1
						usr.client.screen += usr.skill_revive.bar
						if(src != usr) src.client.screen += usr.skill_revive.bar
						view(8,usr) << output("<font color = purple> [usr] begins to revive [src]'s soul.", "chat.local")
					else
						usr << output("<font color = teal>They need to be dead and in the Psionic Realm for you to attempt the revivification process.","chat.system")
						usr.set_alert("Target must be dead and in Psi Realms",'alert.dmi',"alert")
						usr.skill_revive.icon_state = "Revivification off"
			//Player gives youth
			else if(usr.left_click_function == "restoration")
				if(src.client)
					usr.left_click_function = null
					if(get_dist(usr,src) > 2)
						usr << output("<font color = teal>They are too far away to interact with.","chat.system")
						usr.set_alert("Too far away",'alert.dmi',"alert")
						usr.skill_reformation.icon_state = "Revivification off"
						return
					for(var/obj/skills/Meditate/med in usr)
						if(med.active) call(med.act)(usr,med)
					usr.skill_restoration.active = 1
					usr.skill_restoration.skill_target = src
					usr.icon_state = "meditate"
					usr.stunned += 1
					animate(usr, color = list("#000", "#000", "#000", "#fff"),time = 20, loop = -1)
					animate(color = initial(usr.color),time = 20)
					usr.stunned_pending += 1
					usr.client.screen += usr.skill_restoration.bar
					if(src != usr) src.client.screen += usr.skill_restoration.bar
					view(8,usr) << output("<font color = purple> [usr] begins to restore [src]'s youth.", "chat.local")
			//Player gives body
			else if(usr.left_click_function == "reformation")
				if(src.client)
					usr.left_click_function = null
					if(get_dist(usr,src) > 2)
						usr << output("<font color = teal>They are too far away to interact with.","chat.system")
						usr.set_alert("Too far away",'alert.dmi',"alert")
						usr.skill_reformation.icon_state = "Revivification off"
						return
					if(src.has_body)
						usr << output("<font color = teal>You have no need to reform their body, since they already have one.","chat.system")
						usr.set_alert("Already have body",'alert.dmi',"alert")
						usr.skill_reformation.icon_state = "Revivification off"
						return
					if(src.dead && src.z == 2)
						for(var/obj/skills/Meditate/med in usr)
							if(med.active) call(med.act)(usr,med)
						usr.skill_reformation.active = 1
						usr.skill_reformation.skill_target = src
						usr.icon_state = "meditate"
						usr.stunned += 1
						usr.stunned_pending += 1
						usr.client.screen += usr.skill_reformation.bar
						if(src != usr) src.client.screen += usr.skill_reformation.bar
						view(8,usr) << output("<font color = purple> [usr] begins to reform a new body for [src].", "chat.local")
					else
						usr << output("<font color = teal>They need to be dead and in the Psionic Realm for you to attempt the reformation process.","chat.system")
						usr.set_alert("Target must be dead and in Psi Realms",'alert.dmi',"alert")
						usr.skill_reformation.icon_state = "Revivification off"
			*/
			//Player chooses an android to upgrade
			else if(usr.left_click_function == "choose android")
				usr.left_click_function = null
				if(src.race == "Android")
					if(get_dist(usr,src) <= 2)
						usr.upgrading = src
						usr.part_selected = null
						winset(usr,"body.button_train","text=\"Upgrade\"")
						usr.open_body = 1
						usr.open_menus.Add(".open_body")
						if(usr.hud_body) usr.client.screen += usr.hud_body
					else
						usr.set_alert("Android too far away",'alert.dmi',"alert")
						//usr.create_chat_entry("alerts","Android too far away.")
						usr << output("Android is too far away to upgrade.", "actionoutput")
			else if(usr.target)
				//usr.client.images -= usr.bar_power
				if(usr.target.bar_energy)
					usr.client.images -= usr.target.bar_energy
				if(usr.target.bar_health)
					usr.client.images -= usr.target.bar_health
				if(usr.target.target_img) usr.client.images -= usr.target.target_img

			if(usr.target && usr.target == src)
				usr.add_remove_target(src,1)
				return
			else
				usr.add_remove_target(src,0)
		//End left click function code
		if(src.koed || src == usr)
			if(get_dist(usr,src) <= 2)
				usr.accessing = src
				usr.refresh_inv()
		winset(usr,"map.map","focus=true")
		..()