mob
	verb
		tech_misc_button()
			set name = ".tech_misc_button"
			set hidden = 1
			if(usr.tech_display)
				var/obj/items/tech/t = usr.tech_display
				if(t.type == /obj/items/tech/sub_tech/Engineering/Robotics && t.tech_lvl > 0)
					//winshow(usr,"tech_panes",0)
					if(usr.hud_tech) usr.client.screen -= usr.hud_tech
					usr.open_tech = 0
					usr.open_menus.Remove(".open_tech")
					usr.left_click_function = "choose android"
					usr.set_alert("Select Android to upgrade",t.icon,t.icon_state)
					return
				else if(t.type == /obj/items/tech/sub_tech/Engineering/Automated_Drill_Towers && t.tech_lvl > 0)
					//winshow(usr,"tech_panes",0)
					if(usr.hud_tech) usr.client.screen -= usr.hud_tech
					usr.open_tech = 0
					usr.open_menus.Remove(".open_tech")
					usr.left_click_function = "upgrade drill"
					usr.set_alert("Select drill to upgrade",t.icon,t.icon_state)
					return
				else if(t.type == /obj/items/tech/sub_tech/Engineering/Structural_Engineering && t.tech_lvl > 0)
					//winshow(usr,"tech_panes",0)
					if(usr.hud_tech) usr.client.screen -= usr.hud_tech
					usr.open_tech = 0
					usr.open_menus.Remove(".open_tech")
					usr.left_click_function = "upgrade wall"
					usr.set_alert("Select wall to upgrade",t.icon,t.icon_state)
					return
				else if(t.type == /obj/items/tech/sub_tech/Physics/Scouters && t.tech_lvl > 0)
					//winshow(usr,"tech_panes",0)
					if(usr.hud_tech) usr.client.screen -= usr.hud_tech
					usr.open_tech = 0
					usr.open_menus.Remove(".open_tech")
					usr.left_click_function = "upgrade scanner"
					usr.set_alert("Select Scanner to upgrade",t.icon,t.icon_state)
					return
		tech_build()
			set name = ".tech_build"
			set hidden = 1
			//winshow(usr,"tech_panes",0)
			if(usr.hud_tech) usr.client.screen -= usr.hud_tech
			usr.build_tech = usr.build_tech_selected
		/*
		display_tech_info(var/t as text,var/p as text)
			set name = ".display_tech_info"
			set hidden = 1
			var/cat
			var/obj/items/tech/s = null
			for(var/obj/items/tech/x in usr.technology)
				if(x.tag == t || x.name == t) s = x
			for(var/obj/items/tech/z in usr.technology_researched)
				if(z.tag == t || z.name == t) s = z
			if(s)
				if(!s.category) s.category = list()
				for(var/x in s.category)
					cat = "[cat], [x]"
				winset(usr,"tech_research_engineering.button_misc","is-visible=false")
				if(t == "Robotics" && s.tech_lvl > 0)
					winset(usr,"tech_research_engineering.button_misc","is-visible=true")
				else if(t == "Structural Engineering" && s.tech_lvl > 0)
					winset(usr,"tech_research_engineering.button_misc","is-visible=true")
					var/walls = 0
					for(var/turf/w in turfs[1][usr.z])
						//world << "DEBUG - check tiles, found [w] - hp = [w.hp]/[w.hp_max]"
						if(w.builder == usr.real_name && w.hp < w.hp_max)
							walls += 1
					s.tech_give_txt = "\n\nTiles Damaged: [walls]"
				else if(t == "Scanners" && s.tech_lvl > 0)
					winset(usr,"tech_research_physics.button_misc","is-visible=true")
				else if(t == "Automated Drill Towers" && s.tech_lvl > 0)
					winset(usr,"tech_research_engineering.button_misc","is-visible=true")
				var/time = round((100/s.tech_exp_gain)/60,0.1)
				winset(usr,"[p].bar_[s.info_name]","value=[s.tech_exp]")
				winset(usr,"[p].xp_bar","value=[s.tech_exp]")
				winset(usr,"[p].label_name","text=\"[s.name]\"")
				winset(usr,"[p].label_role","text=\"Roles[cat]\"")
				winset(usr,"[p].label_research_time","text=\"Research Time: [round(time/usr.mod_intelligence,0.1)] minutes\"")
				winset(usr,"[p].label_resource_cost","text=\"Tech Given: [s.tech_give_txt]\"")
				winset(usr,"[p].label_tech_tree","text=\"Tech Tree: [s.tech_tree]\"")
				winset(usr,"[p].label_tech_lvl","text=\"Level: [s.tech_lvl]\"")
				var rep = "No"
				if(s.tech_repeatable) rep = "Yes"
				winset(usr,"[p].label_repeatable","text=\"Repeatable: [rep]\"")
				winset(usr,"[p].label_info","text=\"[s.desc]\"")
				if(usr.tech_focus == s) winset(usr,"[p].button_research","text=\"Pause\"")
				else winset(usr,"[p].button_research","text=\"Research\"")
				usr.tech_display = s
				var/icon/I = icon(s.icon,s.icon_state,SOUTH,1,0)
				I.Scale(64,64)
				var/Z = fcopy_rsc(I)
				winset(usr,"[p].label_img","image=\ref[Z]")
				winset(usr,"[p].button_research","is-disabled = false")
				for(var/obj/items/tech/sk in usr.technology_researched)
					if(sk.tag == t && sk.tech_repeatable == 0) winset(usr,"[p].button_research","is-disabled = true")
		*/
		research_tech(var/t as text)
			set name = ".research_tech"
			set hidden = 1
			var/has_p = 0;
			var/needed_p = 0;
			if(usr.tech_focus) winset(usr,"[t].button_[usr.tech_focus.info_name]","background-color = #FF0000")
			if(usr.tech_focus == usr.tech_display)
				winset(usr,"[t].button_research","text=\"Research\"")
				usr.tech_focus = null
				return
			else if(usr.tech_display)
				var/obj/items/tech/tch = usr.tech_display
				needed_p = length(tch.tech_prerequisites)
				if(needed_p > 0)
					for(var/p in tch.tech_prerequisites)
						for(var/obj/items/tech/z in global.tech)//usr.technology_researched)
							if(usr.tech_unlocked[z.list_pos] == z.type)
								if(z.type == p) has_p += 1
				if(needed_p == 0 || has_p >= needed_p)
					usr.tech_focus = usr.tech_display
					winset(usr,"[t].button_[usr.tech_focus.info_name]","background-color = #00466B")
					winset(usr,"[t].button_research","text=\"Pause\"")
				else
					usr.output_msg("Prerequisites not met.")
mob
	proc
		tech_xp_update(var/all = 0)
			/*
			- This proc should clear the players tech menu
			- Then refill it with various instances of the global.tech_xp_bar
			- Each overlay of the global.tech_xp_bar is a snapshot at that moment
			*/
			var/obj/hud/menus/tech_background/b = src.hud_tech
			b.tech_holder_special.overlays = null
			if(b.selected == 2 || all)
				for(var/obj/items/tech/sub_tech/Engineering/t in global.tech)
					tech_xp_bar.transform = t.transform
					var/result = round((src.tech_xp[t.list_pos]/100)*100,10)
					tech_xp_bar.icon_state = "[result]"
					b.tech_holder_special.overlays += tech_xp_bar
			if(b.selected == 3 || all)
				for(var/obj/items/tech/sub_tech/Physics/t in global.tech)
					tech_xp_bar.transform = t.transform
					var/result = round((src.tech_xp[t.list_pos]/100)*100,10)
					tech_xp_bar.icon_state = "[result]"
					b.tech_holder_special.overlays += tech_xp_bar
			if(b.selected == 4 || all)
				for(var/obj/items/tech/sub_tech/Genetics/t in global.tech)
					tech_xp_bar.transform = t.transform
					var/result = round((src.tech_xp[t.list_pos]/100)*100,10)
					tech_xp_bar.icon_state = "[result]"
					b.tech_holder_special.overlays += tech_xp_bar