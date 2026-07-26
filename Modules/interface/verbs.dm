mob/verb/Pick_Up_Nearby()
    set category = "Other"
    set name = ".pickup"
    if(!started) return

    if(koed || stunned) return

    // ---- 2 SECOND COOLDOWN ----
    if(world.time < last_pickup_time + 15)   // 15 ticks = 1.5 seconds
        return

    last_pickup_time = world.time

    var/obj/items/closest = null
    var/best_dist = 999

    for(var/obj/items/I in view(2, src))
        if(!I) continue
        if(I.loc == src) continue
        if(I.pickup_lock) continue
        if(I.bolted) continue
        if(I.grabbed_by) continue
        if(!I.can_pocket && !I.is_zenni && !I.is_dokuro) continue

        var/d = get_dist(src, I)
        if(d < best_dist)
            best_dist = d
            closest = I

    if(!closest)
        //src << "There is nothing nearby to pick up."
        return

    // ---- LOCK ITEM ----
    closest.pickup_lock = 1


    pickup(closest, 1)
    view(src)<<output("[src] picks up x[closest.stacks] [closest]","actionoutput")
    spawn(5)
        if(closest)
            closest.pickup_lock = 0
/*mob/verb/Pick_Up_Nearby()
    set hidden = 1
    set name = ".pickup"
    if(!started) return
    if(koed || stunned) return

    var/max_range = 2
    var/picked_any = 0

    // Search nearest first (range 1, then 2)
    for(var/r = 1, r <= max_range, r++)
        for(var/obj/items/I in range(r, src))
            if(!I) continue
            if(I.bolted) continue
            if(I.grabbed_by) continue
            if(!I.can_pocket && !I.is_zenni && !I.is_dokuro) continue

            pickup(I, 0)   // reuse your existing logic
            picked_any = 1

            // OPTIONAL: stop after first found
            return

    if(!picked_any)
        src << "There is nothing nearby to pick up."*/
mob
	verb
	//Settings
		Change_IC_Text_Colour()
			set hidden = 1

			text_color_ic=input("Choose a color for IC.") as color
	//Communication
		switch_whisper()
			set name = ".switch_whisper"
			set hidden = 1
			if(usr.typing) return
			if(usr.started == 0) return
			if(usr.chat != "whisper")
				usr.chat = "whisper"
				winset(usr,"chat.button_toggle_say","is-checked=false")
				winset(usr,"map.map","focus=true")
		switch_say()
			set name = ".switch_say"
			set hidden = 1
			if(usr.typing) return
			if(usr.started == 0) return
			if(usr.chat != "say")
				usr.chat = "say"
				winset(usr,"chat.button_toggle_whisper","is-checked=false")
				winset(usr,"map.map","focus=true")
		switch_local()
			set name = ".switch_local"
			set hidden = 1
			if(usr.typing) return
			if(usr.started == 0) return
			if(usr.chat != "local")
				usr.chat = "local"

				winset(usr,"chat.button_local","is-checked=true")
				winshow(usr,"chat.local",1)
				winshow(usr,"chat.output_local",1)
				winshow(usr,"chat.button_toggle_say",1)
				winshow(usr,"chat.button_toggle_whisper",1)

				winset(usr,"chat.button_world","is-checked=false")
				winset(usr,"chat.button_system","is-checked=false")
				winshow(usr,"chat.output_world",0)
				winshow(usr,"chat.world",0)
				winshow(usr,"chat.system",0)
				winshow(usr,"chat.output_alerts",0)

				winset(usr,"map.map","focus=true")

		switch_system()
			set name = ".switch_system"
			set hidden = 1
			if(usr.typing) return
			//if(usr.started == 0) return
			usr.chat = "system"

			winset(usr,"chat.button_local","is-checked=false")
			winset(usr,"chat.button_world","is-checked=false")
			winset(usr,"chat.button_alerts","is-checked=false")
			winshow(usr,"chat.local",0)
			winshow(usr,"chat.world",0)
			winshow(usr,"chat.output_alerts",0)
			winshow(usr,"chat.output_local",0)
			winshow(usr,"chat.output_world",0)
			winshow(usr,"chat.button_toggle_say",0)
			winshow(usr,"chat.button_toggle_whisper",0)

			winset(usr,"chat.button_system","is-checked=true")
			winshow(usr,"chat.system",1)
			winset(usr,"map.map","focus=true")
		switch_world()
			set name = ".switch_world"
			set hidden = 1
			if(usr.typing) return
			if(usr.started == 0) return
			usr.chat = "world"

			winset(usr,"chat.button_local","is-checked=false")
			winset(usr,"chat.button_system","is-checked=false")
			winset(usr,"chat.button_alerts","is-checked=false")
			winshow(usr,"chat.local",0)
			winshow(usr,"chat.system",0)
			winshow(usr,"chat.output_alerts",0)
			winshow(usr,"chat.output_local",0)
			winshow(usr,"chat.button_toggle_say",0)
			winshow(usr,"chat.button_toggle_whisper",0)

			winset(usr,"chat.button_world","is-checked=true")
			winshow(usr,"chat.output_world",1)
			winshow(usr,"chat.world",1)
			winset(usr,"map.map","focus=true")

		switch_alerts()
			set name = ".switch_alerts"
			set hidden = 1
			if(usr.typing) return
			if(usr.started == 0) return
			usr.chat = "alerts"

			winset(usr,"chat.button_local","is-checked=false")
			winset(usr,"chat.button_system","is-checked=false")
			winset(usr,"chat.button_world","is-checked=false")
			winshow(usr,"chat.local",0)
			winshow(usr,"chat.system",0)
			winshow(usr,"chat.world",0)
			winshow(usr,"chat.output_local",0)
			winshow(usr,"chat.output_world",0)
			winshow(usr,"chat.button_toggle_say",0)
			winshow(usr,"chat.button_toggle_whisper",0)

			winset(usr,"chat.button_alerts","is-checked=true")
			winshow(usr,"chat.output_alerts",1)
			winset(usr,"map.map","focus=true")
		/*
		say(var/t as text)
			set name = ".say"
			set hidden = 1
			if(usr.started == 0) return
			winset(usr,"map.map","focus=true")
			if(length(t) > 500)
				usr << output("Text too long, please make it shorter to help avoid lag or spam.", "chat.system")
				return
			if(usr.ic_chat == "say")
				for(var/mob/M in range(12,usr))
					M << output("[usr] says - [t]", "chat.local")
			else
				for(var/mob/M in range(2,usr))
					M << output("[usr] whispers - [t]", "chat.local")
			if(usr.txt_say)
				animate(usr.txt_say)
				del(usr.txt_say)
			var/obj/effects/txt/s = new
			s.pixel_y = 16
			s.pixel_x = -12
			s.filters += filter(type="outline", size=1, color=rgb(0,0,0))
			s.filters += filter(type="drop_shadow", size=1, offset = 8, color=rgb(255,255,255))
			s.maptext = "[usr.name]: [t]"
			var/image/I = new(s,usr)
			for(var/mob/m in range(8,usr))
				if(m.client)
					m << I
			usr.txt_say = I
			I.pixel_z = -100
			I.alpha = 0
			animate(I, pixel_z = 0, alpha = 225, time = 10, easing = ELASTIC_EASING)
			spawn(length(s.maptext)+10)
				if(I) animate(I,alpha = 0,25)
		*/

		world(var/t as text)
			set name = ".world"
			set hidden = 1
			if(usr.typing) return
			if(usr.started == 0) return
			winset(usr,"map.map","focus=true")
			if(length(t) > 500)
				usr << output("Text too long, please make it shorter to help avoid lag or spam.", "chat.system")
				return
			//t = FilterString(t)
			for(var/mob/M in players)
				M << output("<font color = [usr.auracolor]>[usr.key] - [t]", "chat.world")
				spawn(1)
					if(M && M.client && M != usr && M.show_flash_world)
						winset(M,"main","flash=10")
						var/times = 6
						while(times)
							times -= 1
							if(M && M.client) winset(M,"chat.button_world","background-color=#FFFF00")
							sleep(2)
							if(M && M.client) winset(M,"chat.button_world","background-color=#000000")
							sleep(2)
			winset(usr,"map.map","focus=true")

	//Misc
		tab_target()
			set name = ".tab_target"
			set hidden = 1
			if(usr.typing) return
			var/list/players = list()
			for(var/mob/m in view(18,usr))
				if(m != usr) players += m
			if(length(players) > 0)
				if(usr.tab_num >= length(players))
					usr.tab_num = 1
				else usr.tab_num += 1
				var/mob/m = players[usr.tab_num]
				if(usr.target) usr.add_remove_target(usr.target,1)
				usr.add_remove_target(m,0)
		toggle_info()
			set name = ".toggle_info"
			set hidden = 1
			if(usr.typing) return
			if(usr.toggled_info == 0)
				usr.toggled_info = 1
				if(usr.mouse_inside) usr.show_info(usr.mouse_inside)
				return
			else
				usr.toggled_info = 0
				if(usr.mouse_over_tooltip && usr.client) usr.client.images -= usr.mouse_over_tooltip
				if(usr.mouse_over_visual && usr.client) usr.client.images -= usr.mouse_over_visual
				return
		reset_player_icon()
			set name = ".reset_player_icon"
			set hidden = 1
			if(usr.typing) return
			usr.left_click_function = "reset player icon"

			winshow(usr,"settings",0)
			usr.open_settings = 0
			usr.open_menus.Remove(".open_settings")

			winshow(usr,"options",0)
			usr.open_options = 0
			usr.open_menus.Remove(".open_options")
		reset_object_icon()
			set name = ".reset_object_icon"
			set hidden = 1
			if(usr.typing) return
			usr.left_click_function = "reset object icon"

			winshow(usr,"settings",0)
			usr.open_settings = 0
			usr.open_menus.Remove(".open_settings")

			winshow(usr,"options",0)
			usr.open_options = 0
			usr.open_menus.Remove(".open_options")
		change_player_icon()
			set name = ".change_player_icon"
			set hidden = 1
			if(usr.typing) return
			var/icon/I=input("Choose an icon from your system.","Your Icon")as null|icon

			var/icon/Z = new /icon(I)

			if(Z)
				if(isicon(Z))
					usr.left_click_function = "change player icon"
					usr.icon_stored = Z

					winshow(usr,"settings",0)
					usr.open_settings = 0
					usr.open_menus.Remove(".open_settings")

					winshow(usr,"options",0)
					usr.open_options = 0
					usr.open_menus.Remove(".open_options")

				else
					usr.set_alert("Problem loading icon",'alert.dmi',"alert")
					//usr.create_chat_entry("alerts","Problem loading icon.")

			else
				usr.set_alert("Problem loading icon.",'alert.dmi',"alert")
				//usr.create_chat_entry("alerts","Problem loading icon.")
		change_object_icon()
			set name = ".change_object_icon"
			set hidden = 1
			if(usr.typing) return
			var/icon/I=input("Choose an icon from your system.","Your Icon")as null|icon

			var/icon/Z = new /icon(I)

			if(Z)
				if(isicon(Z))
					usr.left_click_function = "change object icon"
					usr.icon_stored = Z

					winshow(usr,"settings",0)
					usr.open_settings = 0
					usr.open_menus.Remove(".open_settings")

					winshow(usr,"options",0)
					usr.open_options = 0
					usr.open_menus.Remove(".open_options")

				else
					usr.set_alert("Problem loading icon.",'alert.dmi',"alert")
				//	usr.create_chat_entry("alerts","Problem loading icon.")

			else
				usr.set_alert("Problem loading icon.",'alert.dmi',"alert")
			//	usr.create_chat_entry("alerts","Problem loading icon.")
		switch_afk()
			set name = ".switch_afk"
			set hidden = 1
			if(usr.typing) return
			if(usr.afk == 0)
				usr.overlays -= /obj/effects/afk
				usr.overlays += /obj/effects/afk
				usr.afk = 2
				winset(usr,"chat.afk","is-checked=true")
				view(10,src)<<"[usr] went afk."
				spawn(100)
					if(usr && usr.afk == 2)
						usr.afk = 1
			else
				usr.overlays -= /obj/effects/afk
				usr.afk = 0
				winset(usr,"chat.afk","is-checked=false")
				view(10,src)<<"[usr] came back from afk."
		switch_skills_tab(var/t as text)
			set name = ".switch_skills_tab"
			set hidden = 1
			if(usr.typing) return
		use_item()
			set name = ".use"
			set hidden = 1
			if(usr.typing) return
			if(usr.item_selected)
				var/obj/i = usr.item_selected
				if(i.act)
					call(i.act)(usr,i)
		drop_item()
			set name = ".drop"
			set hidden = 1
			if(usr.typing) return
			if(usr.item_selected)
				var/obj/i = usr.item_selected
				if(i.act_drop)
					call(i.act_drop)(usr,i)

		display_skill_info(var/t as text,var/p as text)
			set name = ".display_skill_info"
			set hidden = 1
			if(usr.typing) return
			var/obj/skills/s = null
			var/is_trait = 0
			var/is_stance = 0
			for(var/obj/skills/b in learnable_skills)
				if(b.name == t) s = b
			for(var/obj/stances/st in learnable_stances)
				if(st.name == t)
					s = st
					is_stance = 1
			for(var/obj/traits/tr in learnable_traits)
				if(tr.name == t)
					s = tr
					is_trait = 1
			winset(usr,"[p].label_name","text=\"[s.name]\"")
			var/cat
			var/buff = 0;
			if(is_trait == 0)
				if(!s.category) s.category = list()
				for(var/x in s.category)
					cat = "[cat], [x]"
					if(x == "Buff" || x == "Utility") buff = 1;
				if(is_stance == 0)
					winset(usr,"[p].label_category","text=\"Category[cat]\"")
					winset(usr,"[p].label_energy_cost","text=\"Energy Cost: [s.info_energy_cost]\"")
				else winset(usr,"[p].label_energy_cost","text=\"Recovery Cost: [s.info_energy_cost]\"")
				if(buff == 0) winset(usr,"[p].label_dmg","text=\"Damage: [s.info_dmg]\"")
				else winset(usr,"[p].label_dmg","text=\"Duration: [s.info_duration]\"")
				if(buff == 0) winset(usr,"[p].label_spd","text=\"Speed: [s.info_spd]\"")
				else winset(usr,"[p].label_spd","text=\"Effects: [s.info_buffs]\"")
				winset(usr,"[p].label_mastery","text=\"Mastery: [s.info_mastery]\"")
				winset(usr,"[p].label_point_cost","text=\"Point Cost: [s.info_point_cost]\"")
				winset(usr,"[p].label_info","text=\"[s.help_text]\"")
			else
				winset(usr,"[p].label_point_cost","text=\"Point Cost: [s.info_point_cost]\"")
				winset(usr,"[p].label_info","text=\"[s.info]\"")
			var/icon/I = icon(s.icon,s.icon_state,SOUTH,1,0)
			I.Scale(64,64)
			var/Z = fcopy_rsc(I)
			winset(usr,"[p].label_img","image=\ref[Z]")
			winset(usr,"[p].button_unlock","is-disabled = false")
			winset(usr,"[p].button_teach","is-visible = false")
			for(var/obj/skills/sk in usr)
				if(sk.name == t)
					winset(usr,"[p].button_unlock","is-disabled = true")
					winset(usr,"[p].button_teach","is-visible = true")
			for(var/obj/stances/st in usr)
				if(st.name == t)
					winset(usr,"[p].button_unlock","is-disabled = true")
					winset(usr,"[p].button_teach","is-visible = true")
			for(var/obj/traits/trait in usr)
				if(trait.name == t) winset(usr,"[p].button_unlock","is-disabled = true")

		/*
		fps_player()
			set name = ".fps_player"
			set hidden = 1
			winset(usr,"numbers.label_numbers","text=\"Input your new frames per second setting.\"")
			winshow(usr,"numbers",1)
			winset(usr,"numbers","pos=960,400")
			usr.numbers_text = "fps player"
			winset(usr,"numbers.input_number","focus=true")
		*/
		settings(var/t as text)
			set name = ".settings"
			set hidden = 1
			if(usr.typing) return
			if(t == "particles")
				if(usr.see_invisible)
					usr.see_invisible = 0
					//if(usr.afterlife_effect) usr.client.screen -= usr.afterlife_effect
					return
				else
					usr.see_invisible = 1
					return
			if(t == "resize")
				var/resize = winget(usr,"settings_main.button_resize","is-checked")
				if(resize == "true")
					winset(usr,"inven","can-resize=true")
					winset(usr,"help","can-resize=true")
					winset(usr,"skills","can-resize=true")
					winset(usr,"skill_panes","can-resize=true")
					winset(usr,"tech_panes","can-resize=true")
					winset(usr,"settings","can-resize=true")
					winset(usr,"build_open","can-resize=true")
					winset(usr,"stats","can-resize=true")
					winset(usr,"sense","can-resize=true")
					winset(usr,"chat","can-resize=true")
				else
					winset(usr,"inven","can-resize=false")
					winset(usr,"help","can-resize=false")
					winset(usr,"skills","can-resize=false")
					winset(usr,"skill_panes","can-resize=false")
					winset(usr,"tech_panes","can-resize=false")
					winset(usr,"settings","can-resize=false")
					winset(usr,"build_open","can-resize=false")
					winset(usr,"stats","can-resize=false")
					winset(usr,"sense","can-resize=false")
					winset(usr,"chat","can-resize=false")
			if(t == "windowed")
				var/win = winget(usr,"settings_main.button_window","is-checked")
				if(win == "true")
					winset(usr,"main","titlebar=true")
					winset(usr,"main","statusbar=true")
					winset(usr,"main","can-resize=true")
					return
				else
					winset(usr, "main", "is-maximized=false;can-resize=false;titlebar=false;menu=false") //Reset to not maximized and turn off titlebar.
					winset(usr, "main", "is-maximized=true") //Now set to maximized. We have to do this separately, so that the taskbar is appropriately covered.
					usr.show_ui()
					return
		color_ic(var/c as color)
			set name = ".color_ic"
			set hidden = 1
			if(usr.typing) return
			usr.text_color_ic = c
			winset(usr,"settings_main.ic_color","background-color=[c]")
		color_ooc(var/c as color)
			set name = ".color_ooc"
			set hidden = 1
			if(usr.typing) return
			usr.text_color_ooc = c
			winset(usr,"settings_main.ooc_color","background-color=[c]")
		colors_eyes(var/c as color)
			set name = ".eye_colors"
			set hidden = 1
			if(usr.typing) return
			usr.eye_c = c
			winset(usr,"char_creation.eye_color","background-color=[c]")
			usr.update_looks("+ eyes")
		colors(var/c as color)
			set name = ".colors"
			set hidden = 1
			if(usr.typing) return
			var/mob/target = usr
			var/obj/items/tech/Vat/clone_tank = null
			if(usr.tech_using)
				if(istype(usr.tech_using,/obj/items/tech/Vat))
					clone_tank = usr.tech_using
					target = null

			if(target)
				target.hair_c = c
				winset(target,"char_creation.hair_color","background-color=[c]")
			if(clone_tank)
				clone_tank.vat_hair_c = c
				winset(usr,"genetics.hair_color","background-color=[c]")

			if(target)
				//Reset, update and regenerate hair with new colours
				target.update_looks()
		switch_build(var/t as text)
			set name = ".switch_build"
			set hidden = 1
			if(usr.typing) return
			usr.build = t
			usr.build_menu()
			winset(usr,"map.map","focus=true")
		reset_ui()
			set name = ".reset_ui"
			set hidden = 1
			if(usr.typing) return
			usr.reset_ui_proc()
		cancel_numbers()
			set name = ".cancel_numbers"
			set hidden = 1
			if(usr.typing) return
			usr.numbers = null
			usr.numbers_text = null
			usr.numbers_accessing = null

			usr.open_spread = 0

			winshow(usr,"numbers",0)
		ui_trans()
			set name = ".ui_trans"
			set hidden = 1
			if(usr.typing) return
			var/trans = winget(usr,"settings_main.bar_trans","value")
			trans = text2num(trans)
			trans = 255-trans
			winset(usr,"help","alpha=[trans]")
			winset(usr,"percents","alpha=[trans]")
			winset(usr,"skills","alpha=[trans]")
			winset(usr,"skill_panes","alpha=[trans]")
			winset(usr,"tech_panes","alpha=[trans]")
			winset(usr,"settings","alpha=[trans]")
			winset(usr,"build_open","alpha=[trans]")
			winset(usr,"stats","alpha=[trans]")
			winset(usr,"options","alpha=[trans]")
			winset(usr,"numbers","alpha=[trans]")
		/*
		ui_scale()
			set name = ".ui_scale"
			set hidden = 1
			var/size = winget(usr,"settings.bar_ui_scale","value")
			size = text2num(size)
			size = size/100
			if(size < 0.33)
				size = 0.33
			var/inven_x = copytext(og_player_inven,1,findtext(og_player_inven,"X",1,0))
			var/inven_y = copytext(og_player_inven,length(inven_x)+2,0)
			inven_x = text2num(inven_x)
			inven_y = text2num(inven_y)
			winset(usr,"inven","size=[inven_x*size]x[inven_y*size]")

			var/help_x = copytext(og_player_help,1,findtext(og_player_help,"X",1,0))
			var/help_y = copytext(og_player_help,length(help_x)+2,0)
			help_x = text2num(help_x)
			help_y = text2num(help_y)
			winset(usr,"help","size=[help_x*size]x[help_y*size]")

			var/percents_x = copytext(og_player_percents,1,findtext(og_player_percents,"X",1,0))
			var/percents_y = copytext(og_player_percents,length(percents_x)+2,0)
			percents_x = text2num(percents_x)
			percents_y = text2num(percents_y)
			winset(usr,"percents","size=[percents_x*size]x[percents_y*size]")

			var/skills_x = copytext(og_player_skills,1,findtext(og_player_skills,"X",1,0))
			var/skills_y = copytext(og_player_skills,length(skills_x)+2,0)
			skills_x = text2num(skills_x)
			skills_y = text2num(skills_y)
			winset(usr,"skills","size=[skills_x*size]x[skills_y*size]")

			var/tech_x = copytext(og_player_tech,1,findtext(og_player_tech,"X",1,0))
			var/tech_y = copytext(og_player_tech,length(tech_x)+2,0)
			tech_x = text2num(tech_x)
			tech_y = text2num(tech_y)
			winset(usr,"tech_panes","size=[tech_x*size]x[tech_y*size]")

			var/settings_x = copytext(og_player_settings,1,findtext(og_player_settings,"X",1,0))
			var/settings_y = copytext(og_player_settings,length(settings_x)+2,0)
			settings_x = text2num(settings_x)
			settings_y = text2num(settings_y)
			winset(usr,"settings","size=[settings_x*size]x[settings_y*size]")

			var/build_x = copytext(og_player_build,1,findtext(og_player_build,"X",1,0))
			var/build_y = copytext(og_player_build,length(build_x)+2,0)
			build_x = text2num(build_x)
			build_y = text2num(build_y)
			winset(usr,"build_open","size=[build_x*size]x[build_y*size]")

			var/stats_x = copytext(og_player_stats,1,findtext(og_player_stats,"X",1,0))
			var/stats_y = copytext(og_player_stats,length(stats_x)+2,0)
			stats_x = text2num(stats_x)
			stats_y = text2num(stats_y)
			winset(usr,"stats","size=[stats_x*size]x[stats_y*size]")

			var/sense_x = copytext(og_player_sense,1,findtext(og_player_sense,"X",1,0))
			var/sense_y = copytext(og_player_sense,length(sense_x)+2,0)
			sense_x = text2num(sense_x)
			sense_y = text2num(sense_y)
			winset(usr,"sense","size=[sense_x*size]x[sense_y*size]")
		*/
		txt_size()
			set name = ".txt_size"
			set hidden = 1
			if(usr.typing) return
			var/size = winget(usr,"settings_main.bar_txt_size","value")
			size = text2num(size)
			if(size > 0) size = size/5
			if(size < 1) size = 1
			//var/list/sense = list("label_name","label_strength","label_endurance","label_resistance","label_force","label_agility","label_offence","label_defence","label_regen","label_recovery")
			var/list/stats = list("txt_energy","txt_strength","txt_endurance","txt_agility","txt_resistance","txt_force","txt_offence","txt_defence","txt_int","txt_combat","txt_race","txt_age","txt_gen","txt_regen","txt_recov","txt_skill","txt_grav","txt_traits" \
			,"strength","endurance","energy","resistance","force","agility","offence","defence","intel","combat","race","age","gender","regen","recov","skill_multi","gravity","trait_points","name")

			for(var/t in stats)
				winset(usr,"stats_core.[t]","font-size=[size]")
			//for(var/t in sense)
				//winset(usr,"sense.[t]","font-size=[size]")

			winset(usr,"inven.label_inven","font-size=[size]")
			winset(usr,"help.label_help","font-size=[size]")
			winset(usr,"main.energy","font-size=[size+3]")
			winset(usr,"main.power","font-size=[size+3]")
			winset(usr,"main.health","font-size=[size+3]")
			winset(usr,"skills.label_skills","font-size=[size]")
			winset(usr,"skill_info.skill_desc","font-size=[size-3]")
			winset(usr,"tech.label_title","font-size=[size]")
			winset(usr,"tech.label_tech","font-size=[size-3]")
			winset(usr,"settings_main.label_title","font-size=[size]")
			winset(usr,"settings_main.label_txt_size","font-size=[size]")
			winset(usr,"settings_main.label_trans","font-size=[size]")
			winset(usr,"settings_main.label_resize","font-size=[size]")
			winset(usr,"settings_main.label_window","font-size=[size]")
			winset(usr,"settings_main.label_ui_scale","font-size=[size]")
			winset(usr,"build_open.label_title","font-size=[size]")

		//This one is different to the normal inputkey() verb, in that it only goes off when a key is released, after being pressed.
		inputkey_up(key as text)
			set name = ".inputkey_up"
			set hidden = 1
			set instant = 1
			if(usr.typing)
				switch(key)
					if("Return")  // Handle Enter key
						usr.space_held = 0
						usr.space_started = 0
						usr.backspace_held = 0
						usr.backspace_started = 0
						usr.left_started = 0
						usr.left_held = 0
						usr.right_started = 0
						usr.right_held = 0
						//usr.typing = null
						return
					if("Shift") usr.shift_held = 0 //This makes sure when shift is released, it knows we're no longer holding shift.
					if("Ctrl") usr.ctrl_held = 0
					if("Back") usr.backspace_held = 0
					if("Space") usr.space_held = 0
					if("West") usr.left_held = 0
					if("East") usr.right_held = 0

		//Captures as the player types, and if shift is detected, it will switch to "shift mode" and then use inputkey_up() instead, until shift is let go. i.e, +up
		inputkey(key as text)
			set name = ".inputkey"
			set hidden = 1
			set instant = 1
			if(usr.typing)
				var/obj/hud/o = usr.typing
				var/new_string = o.string_full
				/*if(key == "Return")
					if(usr.hud_chat)
						var/selected_tab = null
						if(usr.hud_chat.tab_selected == usr.hud_chat.tab_local) selected_tab = "local"
						else if(usr.hud_chat.tab_selected == usr.hud_chat.tab_global) selected_tab = "world"

					//	usr.create_chat_entry(selected_tab,null)

						if(istype(o,/obj/hud/menus/chat_background/chat_input))
							var/obj/hud/menus/chat_background/chat_input/b = o
							b.clear_box()
							b.selected = 0
					usr.typing = null
					usr.chat_cd = 1
					spawn(1)
						if(usr) usr.chat_cd = 0
					return
					*/
				if(key == "Shift")
					usr.shift_held = 1 //Since this is a "hold", shift is pressed until released.
					return
				else if(key == "Ctrl")
					usr.ctrl_held = 1 //Since this is a "hold", ctrl is pressed until released.
					//usr.grab_clipboard()
					return
				else if(key == "Back")
					if(usr.backspace_started == 0)
						usr.backspace_held = 1
						usr.backspace_started += 1
						while(usr && usr.backspace_held)
							if(usr.backspace_started > 1 || usr.backspace_started == 0)
								//world << "DEBUG - stopped more than one instance on inputkey."
								return
							if(o.caret_pos-1 > 0)
								new_string = splicetext(o.string_full,o.caret_pos-1,o.caret_pos,"")
								o.caret_pos -= 1
							o.string_full = new_string
							usr.typing.maptext = "[css_outline]<font size = 1><left>[splicetext(new_string,o.caret_pos,o.caret_pos,"|")]"
							//world << "DEBUG - Pressed backspace"
							sleep(1.3)
						usr.backspace_started = 0
					return
				else if(key == "Space")
					if(usr.typing.input_type == "num") return
					if(usr.space_started == 0)
						usr.space_held = 1
						usr.space_started += 1
						while(usr && usr.space_held)
							if(usr.space_started > 1 || usr.space_started == 0)
								//world << "DEBUG - stopped more than one instance on inputkey."
								return
							if(o.caret_pos-1 > 0)
								new_string = splicetext(o.string_full,o.caret_pos,o.caret_pos," ")
							else new_string += " "
							o.caret_pos += 1
							o.string_full = new_string
							usr.typing.maptext = "[css_outline]<font size = 1>[splicetext_char(new_string,o.caret_pos,o.caret_pos,"|")]"
						//	world << "DEBUG - Pressed space"
							sleep(2)
						usr.space_started = 0
					return
				else if(key == "West")
					/*
					Input bar is 318 pixel in width
					Only want to display a 318 pixel slice of the input box at a time

					:.Caret pos moved by Left/Right:.
						- Example, if the caret pos is near 300 pixels, but the length of the text is 600 pixels, we would want only the length relative to the caret pos to show
					.:How to keep track of how long the text is?:.
						- Perhaps split the text every 318 pixels?
						- Could use splittext() proc, but would need special character like ~ to show where splits should be?
						- Could manually split the text by calculating the full length, dividing it by 318 then using copytext() until we reach the end?
					*/
					if(usr.left_started == 0)
						usr.left_started += 1
						usr.left_held = 1
						while(usr && usr.left_held)
							if(usr.left_started > 1 || usr.left_started == 0)
								//world << "DEBUG - stopped more than one instance on inputkey."
								return
							if(length(o.string_full) > 0 && o.caret_pos > 1)
								o.caret_pos -= 1
								usr.typing.maptext = "[css_outline]<font size = 1><left>[splicetext(o.string_full,o.caret_pos,o.caret_pos,"|")]"
							sleep(2)
						usr.left_started = 0
					return
				else if(key == "East")
					if(usr.right_started == 0)
						usr.right_started += 1
						usr.right_held = 1
						while(usr && usr.right_held)
							if(usr.right_started > 1 || usr.right_started == 0)
								//world << "DEBUG - stopped more than one instance on inputkey."
								return

							if(o.caret_pos < length(o.string_full)+1)
								o.caret_pos += 1
								usr.typing.maptext = "[css_outline]<font size = 1><left>[splicetext(o.string_full,o.caret_pos,o.caret_pos,"|")]"
							sleep(2)
						usr.right_started = 0
					return
				else if(length(key) <= 1)
					if(usr.typing.input_type == "num")
						switch(key)
							if("1") key = "1"
							if("2") key = "2"
							if("3") key = "3"
							if("4") key = "4"
							if("5") key = "5"
							if("6") key = "6"
							if("7") key = "7"
							if("8") key = "8"
							if("9") key = "9"
							if("0") key = "0"
							else return
					else if(usr.shift_held)
						switch(key)
							if("1") key = "!"
							if("2") key = "\""
							if("3") key = "£"
							if("4") key = "$"
							if("5") key = "%"
							if("6") key = "^"
							if("7") key = "&"
							if("8") key = "*"
							if("9") key = "("
							if("0") key = ")"
							if("-") key = "_"
							if("=") key = "+"
							if("`") key = "¬"
							if("\[") key = "{"
							if("]") key = "}"
							if(";") key = ":"
							if("'") key = "@"
							if("#") key = "~"
							if(",") key = "<"
							if(".") key = ">"
							if("/") key = "?"
					else if(usr.ctrl_held)
						switch(key)
							if("V")
								//usr.grab_clipboard()
								key = usr.clipboard
							else return
					else key = lowertext(key)

					//If the player starts typing and their caret position is higher than the start of the chat box
					if(o.caret_pos-1 > 0)
						new_string = splicetext(o.string_full,o.caret_pos,o.caret_pos,key)
					//If the player starts typing at the start of the chat box
					else new_string += key
					//o.string_before += key
				o.caret_pos += length_char(key)//(1+length_char(key))

				o.string_full = new_string
				var/MT = "[css_outline]<font size = 1>[splicetext_char(new_string,o.caret_pos,o.caret_pos,"|")]"
				//300 pixels seems to be where the text will then split into the next line.
				//66 characters seems to be where the text will the split
				//if(usr.typing.string_display == null) usr.typing.string_display = list()
				usr.typing.maptext = MT
		launch()
			set name = ".launch"
			set hidden = 1
			if(usr.typing) return
			for(var/obj/items/tech/ships/CC_Ship/ship in world)
				if(ship.loc)
					if(ship.landing == 0)
						ship.landing = 1
						if(ship.active)
							usr.piloting = null
							ship.active = 0
							ship.overlays = null
							var/obj/effects/shadow_ship/s = new
							s.loc = ship.loc
							s.pixel_x = ship.pixel_x
							s.pixel_y = ship.pixel_y
							animate(ship, pixel_z = 0, time = 10)
							animate(transform = turn(matrix(), 0), time = 2)
							animate(alpha = 255, time = 10)
							sleep(12)
							ship.landing = 0
							del(s)
							ship.icon_state = "open"
							ship.layer = initial(ship.layer)
							ship.tele.loc = locate(ship.x,ship.y-5,ship.z)
							for(var/obj/items/plants/p in range(5,ship))
								p.overlays = null
								p.underlays = null
						else
							ship.tele.loc = ship
							ship.icon_state = "closed"
							ship.layer = 303
							var/obj/effects/shadow_ship/s = new
							s.loc = ship.loc
							s.pixel_x = ship.pixel_x
							s.pixel_y = ship.pixel_y
							animate(ship, pixel_z = 128, time = 10)
							sleep(10)
							ship.landing = 0
							ship.active = 1
							del(s)
							var/obj/effects/shadow_ship/s2 = new
							ship.overlays += s2
							usr.piloting = ship
		refuel()
			set name = ".refuel"
			set hidden = 1
			if(usr.typing) return
			for(var/obj/items/tech/ships/CC_Ship/s in world)
				if(s.loc)
					s.fuel = 100
					for(var/mob/m in players)
						if(m.piloting == s) winset(m,"ship.bar_fuel","value=[m.piloting.fuel]")
		pilot()
			set name = ".pilot"
			set hidden = 1
			if(usr.typing) return
			for(var/obj/items/tech/ships/CC_Ship/s in world)
				if(s.loc)
					var/can_pilot = 1
					for(var/mob/m in range(10,usr))
						if(m != usr) if(m.piloting == s)
							can_pilot = 0
					if(usr.client.eye != s)
						if(can_pilot)
							usr.client.perspective = EYE_PERSPECTIVE | EDGE_PERSPECTIVE
							usr.client.eye = s
							usr.client.view += 5
							if(s.active) if(s.landing == 0) usr.piloting = s
					else
						usr.client.perspective = MOB_PERSPECTIVE | EDGE_PERSPECTIVE//initial(usr.client.perspective)
						usr.client.eye = usr
						usr.client.view -= 5
						usr.piloting = null
		chat_shortcut()
			set name = ".enter"
			set hidden = 1
			if(usr.typing) return
			if(usr.chat_cd) return
			if(usr.started == 0)
				//winshow(usr,"loading",1)
				return
			if(usr.hud_chat)
				var/obj/hud/menus/chat_background/chat_input/ci = usr.hud_chat.input
				ci.chat_input_select(null,usr)
			/*
			else if(usr.chat == "world")
				winset(usr,"chat.output_world","focus=true")
			else if(usr.chat == "local")
				winset(usr,"chat.output_local","focus=true")
			else if(usr.chat == "whisper")
				winset(usr,"chat.output_local","focus=true")
			*/
		esc()
			set name = ".esc"
			set hidden = 1
			if(usr.typing) return
			if(!usr.open_menus) usr.open_menus = list()
			if(!length(usr.open_menus))
				//winshow(usr,"options",1)
				//winset(usr,"options.label_version","text=\"Version - [game_version]\"")
				usr.client.screen += usr.hud_opt
				usr.open_options = 1
				usr.open_menus.Add("open_options")
				return
			var/n = 0
			var/n_max = usr.open_menus.len
			for(var/menu in usr.open_menus)
				n += 1
				if(n == n_max)
					if(findtext(menu,"open_map"))
						usr.map_proc(1)
						if(usr.skill_teleport && usr.skill_teleport.active) call(usr.skill_teleport.act)(usr,usr.skill_teleport)
						if(usr.skill_remote_viewing && usr.skill_remote_viewing.active && usr.client.eye == usr) call(usr.skill_remote_viewing.act)(usr,usr.skill_remote_viewing)
					if(findtext(menu,"close_dialogue"))
						winshow(usr,"dialogue",0)
						usr.open_dialogue = 0
						usr.open_menus.Remove(".close_dialogue")
					if(findtext(menu,"open_options"))
						winshow(usr,"options",0)
						usr.open_menus.Remove("open_options")
					if(findtext(menu,"open_settings"))
						winshow(usr,"settings",0)
						usr.open_settings = 0
						usr.open_menus.Remove(".open_settings")
					if(findtext(menu,"open_traits"))
						winshow(usr,"skill_panes",0)
						usr.open_traits = 0
						usr.open_menus.Remove(".open_traits")
					if(findtext(menu,"open_body"))
						//winshow(usr,"body",0)
						if(usr.hud_body) usr.client.screen -= usr.hud_body
						if(usr.skill_divine_infusion && usr.skill_divine_infusion.active == 1) call(usr.skill_divine_infusion.act)(usr,usr.skill_divine_infusion)
						usr.open_body = 0
						usr.open_menus.Remove(".open_body")
						usr.upgrading = null
					if(findtext(menu,"open_build"))
						//winshow(usr,"build_open",0)
						if(usr.hud_build) usr.client.screen -= usr.hud_build
						usr.open_build = 0
						usr.open_menus.Remove(".open_build")
					if(findtext(menu,"open_help"))
						winshow(usr,"help",0)
						usr.open_help = 0
						usr.open_menus.Remove(".open_help")
					if(findtext(menu,"open_emote"))
						winshow(usr,"emote",0)
						usr.open_emote = 0
						usr.overlays -= 'Typing.dmi'
						usr.open_menus.Remove(".open_emote")
					if(findtext(menu,"open_options"))
						usr.client.screen -= usr.hud_opt
						usr.open_options = 0
						winshow(usr,"help",0)
						usr.open_help = 0
						usr.open_menus.Remove("open_options")
					if(findtext(menu,"open_tech"))
						//winshow(usr,"tech_panes",0)
						if(usr.hud_tech) usr.client.screen -= usr.hud_tech
						usr.open_tech = 0
						usr.open_menus.Remove(".open_tech")
						if(usr.build_mouse)
							usr.client.images -= usr.build_mouse
							del(usr.build_mouse)
						usr.build_tech = null
					if(findtext(menu,"open_skills"))
						winshow(usr,"skills",0)
						usr.open_skills = 0
						usr.open_menus.Remove(".open_skills")
					if(findtext(menu,"open_stats"))
						winshow(usr,"stats",0)
						usr.open_stats = 0
						usr.open_menus.Remove(".open_stats")
					if(findtext(menu,"open_inven"))
						winshow(usr,"inven",0)
						usr.open_inven = 0
						usr.open_menus.Remove(".open_inven")
					if(findtext(menu,"open_sense"))
						winshow(usr,"sense",0)
						usr.open_sense = 0
						usr.open_menus.Remove(".open_sense")
					break
		close_dialogue()
			set name = ".close_dialogue"
			set hidden = 1
			if(usr.typing) return
			winshow(usr,"dialogue",0)
			usr.open_dialogue = 0
			usr.open_menus.Remove(".close_dialogue")
			winset(usr,"dialogue.portrait","image=")
			usr.talk_to = null
		close_tutorial()
			set name = ".close_tutorial"
			set hidden = 1
			if(usr.typing) return
			winshow(usr,"tutorial",0)
		close_creation()
			set name = ".close_creation"
			set hidden = 1
			if(usr.typing) return
			var/mob/m = new
			m.loc = locate(250,250,2)
			for(var/obj/o in usr.client.screen)
				usr.client.screen -= o
			winshow(usr,"char_creation",0)
			m.key = usr.key
			return
		open_traits()
			set name = ".open_traits"
			set hidden = 1
			if(usr.typing) return
			if(usr.started == 0) return
			if(usr.open_traits)
				usr.client.screen -= usr.hud_unlocks
				usr.open_traits = 0
				usr.open_menus.Remove(".open_traits")
			else
				usr.client.screen += usr.hud_unlocks
				usr.open_traits = 1
				usr.open_menus.Add(".open_traits")
			winset(usr,"map.map","focus=true")
		open_updates()
			set name = ".open_updates"
			set hidden = 1
			if(usr.typing) return
			if(usr.started == 0) return
			if(usr.open_updates)
				winshow(usr,"login",0)
				usr.open_updates = 0
				usr.open_menus.Remove(".open_updates")
			else
				winshow(usr,"login",1)
				usr.open_updates = 1
				usr.open_menus.Add(".open_updates")
			winset(usr,"map.map","focus=true")
		open_map()
			set name = ".open_map"
			set hidden = 1
			if(usr.typing) return
			if(usr.started == 0) return
			if(usr.open_map)
				usr.map_proc(1)
				if(usr.skill_teleport && usr.skill_teleport.active) call(usr.skill_teleport.act)(usr,usr.skill_teleport)
				if(usr.skill_remote_viewing && usr.skill_remote_viewing.active && usr.client.eye == usr) call(usr.skill_remote_viewing.act)(usr,usr.skill_remote_viewing)
			else
				usr.map_proc(0)
		/*
		open_map()
			set name = ".open_map"
			set hidden = 1
			if(usr.started == 0) return
			if(usr.open_map)
				winshow(usr,"map",0)
				usr.open_map = 0
				usr.open_menus.Remove(".open_map")
				for(var/obj/o in usr.blips_map)
					usr.client.screen -= o
					del(o)
				usr.blips_map = new()
				usr.mobs_map = new()
			else
				winshow(usr,"map",1)
				usr.open_map = 1
				usr.open_menus.Add(".open_map")

				if(usr.map_big == null)
					var/obj/hud/map_large/copy = new
					copy.screen_loc = "2,1"
					copy.icon = map.icon
					copy.screen_loc = "map_box:1,1"
					usr.client.screen += copy
					usr.map_big = copy
					var/obj/cords = new
					cords.filters += filter(type="outline", size=1, color=rgb(0,0,0))
					cords.maptext_width = 128
					cords.maptext_height = 64
					cords.screen_loc = "map_box:1:16,1:730"
					cords.loc = copy
					usr.client.screen += cords
				if(usr.blip == null)
					var/obj/b = new
					b.icon = 'map_blip_large.dmi'
					b.screen_loc = "map_box:1,1"
					usr.client.screen += b
					usr.blip = b
				for(var/obj/o in usr.blips_map)
					usr.client.screen -= o
					del(o)
				usr.blips_map = new()
				usr.mobs_map = new()
				for(var/mob/m in world)
					if(m != usr)
						var/obj/hud/map_blip/detect = new
						detect.icon = 'map_blip_sense.dmi'
						detect.screen_loc = "map_box:1:[m.x],1:[m.y]"
						if(m.race == "Human") detect.icon_state = "human"
						if(m.race == "Goog") detect.icon_state = "goog"
						detect.name = m.name
						detect.track = m
						usr.client.screen += detect
						usr.mobs_map += m
						usr.blips_map += detect
				while(usr.open_map)
					usr.blip.screen_loc = "map_box:1:[usr.x],1:[usr.y]"
					if(length(usr.blips_map))
						var/pos = 1
						var/pos_max = length(usr.mobs_map)
						while(pos != pos_max)
							var/mob/m = usr.mobs_map[pos]
							var/obj/b = usr.blips_map[pos]
							if(b) b.screen_loc = "map_box:1:[m.x],1:[m.y]"
							pos += 1
					sleep(1)
					//CHECK_TICK
			winset(usr,"map.map","focus=true")
		*/
		open_body()
			set name = ".open_body"
			set hidden = 1
			if(usr.typing) return
			if(usr.started == 0) return

			if(usr.open_body)
				//winshow(usr,"body",0)
				if(usr.hud_body) usr.client.screen -= usr.hud_body
				usr.open_body = 0
				usr.open_menus.Remove(".open_body")
				usr.upgrading = null
				if(usr.skill_divine_infusion && usr.skill_divine_infusion.active == 1) call(usr.skill_divine_infusion.act)(usr,usr.skill_divine_infusion)
			else
				if(usr.hud_body) usr.client.screen += usr.hud_body
				usr.open_body = 1
				usr.open_menus.Add(".open_body")
			winset(usr,"map.map","focus=true")
		open_contacts()
			set name = ".open_contacts"
			set hidden = 1
			if(usr.typing) return
			if(usr.started == 0) return
			if(usr.open_contacts)
				//winshow(usr,"contacts",0)
				usr.client.screen -= usr.hud_contacts
				usr.open_contacts = 0
				usr.open_menus.Remove(".open_contacts")
			else
				//winshow(usr,"contacts",1)
				usr.client.screen += usr.hud_contacts
				usr.open_contacts = 1
				usr.open_menus.Add(".open_contacts")
				usr.hud_contacts.players("Online")
			winset(usr,"map.map","focus=true")
		open_build()
			set name = ".open_build"
			set hidden = 1
			if(usr.typing) return
			//var/enable_build
			//return
			if(usr.started == 0) return
			if(usr.open_build)
				//winshow(usr,"build_open",0)
				if(usr.hud_build) usr.client.screen -= usr.hud_build
				usr.open_build = 0
				usr.open_menus.Remove(".open_build")
			else
				//winshow(usr,"build_open",1)
				usr.open_build = 1
				if(usr.hud_build) usr.client.screen += usr.hud_build
				usr.open_menus.Add(".open_build")
			winset(usr,"map.map","focus=true")
		/*
		open_emote()
			set name = ".open_emote"
			set hidden = 1
			if(usr.started == 0) return
			if(usr.open_emote)
				winshow(usr,"emote",0)
				usr.open_emote = 0
				usr.open_menus.Remove(".open_emote")
			else
				winshow(usr,"emote",1)
				usr.open_emote = 1
				usr.open_menus.Add(".open_emote")
			winset(usr,"map.map","focus=true")
		*/

		open_tech()
			set name = ".open_tech"
			set hidden = 1
			if(usr.typing) return
			if(usr.started == 0) return
			if(usr.open_tech)
				//winshow(usr,"tech_panes",0)
				if(usr.hud_tech) usr.client.screen -= usr.hud_tech
				usr.open_tech = 0
				usr.open_menus.Remove(".open_tech")
				if(usr.build_mouse)
					usr.client.images -= usr.build_mouse
					qdel(usr.build_mouse)
				usr.build_tech = null
			else
				//winshow(usr,"tech_panes",1)
				if(usr.hud_tech) usr.client.screen += usr.hud_tech
				usr.open_tech = 1
				usr.open_menus.Add(".open_tech")
			winset(usr,"map.map","focus=true")

		open_skills()
			set name = ".open_skills"
			set hidden = 1
			if(usr.typing) return
			if(usr.started == 0) return
			if(usr.open_skills)
				//winshow(usr,"skills",0)
				usr.client.screen -= usr.hud_skills
				usr.open_skills = 0
				usr.open_menus.Remove(".open_skills")
			else
				//winshow(usr,"skills",1)
				usr.hud_skills.skills()

				usr.client.screen += usr.hud_skills
				usr.open_skills = 1
				usr.open_menus.Add(".open_skills")
			winset(usr,"map.map","focus=true")

		open_stats()
			set name = ".open_stats"
			set hidden = 1
			if(usr.typing) return
			if(usr.started == 0) return
			if(usr.open_stats)
				//winshow(usr,"stats",0)
				usr.open_stats = 0
				usr.client.screen -= usr.hud_stats

				usr.open_menus.Remove(".open_stats")
			else
				//winshow(usr,"stats",1)
				usr.open_stats = 1
				usr.client.screen += usr.hud_stats

				usr.hud_stats.bars(usr)
				usr.hud_stats.portrait_look(usr)
				usr.open_menus.Add(".open_stats")
			winset(usr,"map.map","focus=true")

		open_inven()
			set name = ".open_inven"
			set hidden = 1
			if(usr.typing) return
			if(usr.started == 0) return
			if(usr.open_inven)
				//winshow(usr,"inven",0)
				usr.open_inven = 0
				usr.client.screen -= usr.hud_inv

				usr.open_menus.Remove(".open_inven")
			else
				usr.accessing = usr
				//winshow(usr,"inven",1)
				usr.open_inven = 1
				usr.client.screen += usr.hud_inv

				usr.open_menus.Add(".open_inven")
				usr.refresh_inv()
			winset(usr,"map.map","focus=true")

		open_sense()
			set name = ".open_sense"
			set hidden = 1
			if(usr.typing) return
			if(usr.started == 0) return
			if(usr.open_sense)
				usr.open_sense = 0
				winshow(usr,"sense",0)

				usr.open_menus.Remove(".open_sense")
			else
				usr.open_sense = 1
				winshow(usr,"sense",1)

				usr.open_menus.Add(".open_sense")
			winset(usr,"map.map","focus=true")
		attack()
			set name = ".attack"
			set hidden = 1
			if(usr.typing) return
			//for(var/mob/M in get_step(usr,usr.dir))
			if(usr.started == 0) return
			usr.Attack()
		game_load()
			set name = ".game_load"
			set hidden = 1
			if(usr.typing) return
			if(fexists("saves/[usr.key]/[usr.key].sav"))
				if(usr.client)
					//world << "[usr.key] logs in"
					//winshow(usr,"new_game",0)
					//usr.client.Load()
					usr.Mob_Load()

		//Skills
		grab()
			set name = ".grab"
			set hidden = 1
			set instant = 1
			if(usr.typing) return
			if(usr.started == 0) return
			winset(usr,"map.map","focus=true")
			if(usr.koed) return
			if(usr.minigame)
				if(usr.minigame == "breathing")
					if(usr.skill_breathing)
						var/obj/skills/Crane_Breathing/s = usr.skill_breathing
						flick("push",s.e_but)
						if(s.fullness >= 45)
							s.bar.filters -= filter(type="drop_shadow", x=0, y=0,size=5, offset=2, color=rgb(0,200,0))
							s.bar.filters -= filter(type="outline",size=1, color=rgb(255,255,255))
							s.bar.filters += filter(type="outline",size=1, color=rgb(255,255,255))
							s.bar.filters += filter(type="drop_shadow", x=0, y=0,size=5, offset=2, color=rgb(0,200,0))
							//Search for any lungs and add their level as a bonus multipler to recovery of energy. Also add the level of the Crane Breathing skill into the calculations.
							var/lev = 1+(s.skill_lvl/100)
							var/lev_lungs = 1
							//lvl up lungs

							usr.energy += 0.1*energy_max*mod_recovery*lev*lev_lungs
							//world << "Debug - Recovered [0.1*energy_max*mod_recovery*lev*lev_lungs] energy from Crane Breathing"
							if(usr.energy > usr.energy_max) usr.energy = usr.energy_max
							usr.gain_stat("energy",1,10,"Crane Breathing")
							//Gain divine energy
							usr.gain_stat("divine",1,10,"Crane Breathing")
							usr.divine_energy += 0.01*usr.divine_energy_mod

							//Give the skill some exp
							//s.skill_exp += (33/s.skill_lvl)*usr.mod_skill
							s.skill_exp += ((10-(s.skill_lvl/10))*usr.mod_skill)+1
							if(s.skill_exp >= 100 && s.skill_lvl < 100)
								s.skill_exp = 1
								s.skill_lvl += 1
								s.skill_up(usr)
							spawn(10)
								if(usr && s)
									usr.energy_sources -= "Crane Breathing"
									usr.divine_sources -= "Crane Breathing"
									s.bar.filters -= filter(type="outline",size=1, color=rgb(255,255,255))
									s.bar.filters -= filter(type="drop_shadow", x=0, y=0,size=5, offset=2, color=rgb(0,200,0))
						else
							s.bar.filters -= filter(type="drop_shadow", x=0, y=0,size=5, offset=2, color=rgb(200,0,0))
							s.bar.filters -= filter(type="outline",size=1, color=rgb(255,255,255))
							s.bar.filters += filter(type="outline",size=1, color=rgb(255,255,255))
							s.bar.filters += filter(type="drop_shadow", x=0, y=0,size=5, offset=2, color=rgb(200,0,0))
							spawn(2)
								if(usr && s)
									s.bar.filters -= filter(type="outline",size=1, color=rgb(255,255,255))
									s.bar.filters -= filter(type="drop_shadow", x=0, y=0,size=5, offset=2, color=rgb(200,0,0))
									if(s.active) call(s.act)(usr,s)
						return
			if(usr.skill_meditation && usr.skill_meditation.active) call(usr.skill_meditation.act)(usr,usr.skill_meditation)
			usr.grab_something()
			/*
			if(usr.grab == null)
				for(var/obj/items/resources/A in range(2,usr))
					if(!ismob(A))
						animate(A, pixel_x = initial(A.pixel_x), time = 1)
						animate(A, pixel_y = initial(A.pixel_y), time = 1)
				var/list/itm = list()
				for(var/atom/movable/A in range(2,usr))
					var/D = get_dir(usr,A)
					//usr << output("[A] is [D] from [usr]", "chat.system")
					if(A.bolted == 0 || usr.trait_hm)
						if(bounds_dist(usr,A) <= 16)
							if(usr.mouse_over == A)
								itm += A
								usr.dir = get_dir(usr,A)
							if(usr.dir == EAST)
								if(D == EAST || D == NORTHEAST || D == SOUTHEAST || D == 0) itm += A
							if(usr.dir == WEST)
								if(D == WEST || D == NORTHWEST || D == SOUTHWEST || D == 0) itm += A
							if(usr.dir == NORTH)
								if(D == NORTH || D == NORTHWEST || D == NORTHEAST || D == 0) itm += A
							if(usr.dir == SOUTH)
								if(D == SOUTH || D == SOUTHWEST || D == SOUTHEAST || D == 0) itm += A
							if(usr.dir == SOUTHEAST)
								if(D == SOUTH || D == EAST || D == SOUTHEAST || D == 0) itm += A
							if(usr.dir == SOUTHWEST)
								if(D == SOUTH || D == WEST || D == SOUTHWEST || D == 0) itm += A
							if(usr.dir == NORTHEAST)
								if(D == EAST || D == NORTH || D == NORTHEAST || D == 0) itm += A
							if(usr.dir == NORTHWEST)
								if(D == WEST || D == NORTH || D == NORTHWEST || D == 0) itm += A
				for(var/atom/movable/A in itm)
					var/proceed = 1
					if(isturf(A.loc))
						//If it's a small item we're grabbing, put it in inventory.
						if(A.can_pocket)
							A.loc = usr
							if(A.shadow) A.shadow.loc = null
							if(istype(A,/obj/items/))
								var/obj/items/o = A
								if(o.inven_state) o.icon_state = o.inven_state
							A.overlays -= /obj/effects/select_item
							break
						//Otherwise, grab and lift the item.
						if(A.pixel_z > 0) proceed = 0
						if(A.bolted && usr.trait_hm == null)
							proceed = 0
						if(A.bolted >= 2) proceed = 0
						if(A == usr) proceed = 0
						if(A.icon == null) proceed = 0
						if(A.tk) proceed = 0
						if(ismob(A))
							var/mob/m = A
							if(m.grab && m.afk == 0)
								if(m.grab == usr)
									proceed = 0
								else
									m.letgo()
					if(proceed)
						if(usr.client && usr.tutorials.Find(text_grabbing))
							winshow(usr,"tutorial",1)
							winset(usr,"tutorial.tutorial_title","text=\"Grab tutorial\"")
							winset(usr,"tutorial.tutorial_info","text=\"[text_grabbing]\"")
							usr.tutorials -= text_grabbing
						var/turf/t = A.loc
						if(t.liquid) A.submerge(0,1,t)
						animate(A, pixel_z = 16, time = 1)
						A.density_factor = 0
						usr.grab = A
						if(usr.icon_state == "fly") usr.icon_state = "fly beam"
						else usr.icon_state = "beam"
						A.grabbed_by = usr
						//If the player grabs a generator, cut the power if applicable.
						if(A.generator == 1 && A.can_generate == 1)
							for(var/turf/trf in A.locs)
								for(var/obj/items/tech/Power_Line/p in trf)
									spawn(2)
										if(p) p.reconnect_power()
						break
				while(usr&&usr.grab)
					if(usr.client && usr.client.inactivity >= 3000)
						break
					if(usr.minigame == null)
						var/L = get_step(usr.loc,usr.dir)
						var/A = usr.GetAngleStep(L)
						usr.grab.loc = usr.loc
						usr.grab.step_x = usr.step_x
						usr.grab.step_y = usr.step_y
						usr.grab.MoveAng(A,30,0,0,null) //Making this more than 30 pixels makes the Move() proc not work.
						usr.grab.set_shadow()
						if(ismob(usr.grab))
							usr.grab.icon_state = "fly"
							usr.grab.dir = get_dir(usr.grab,usr)
							usr.grab.KB = 0
						usr.gain_stat("strength",1,1,"Lifting")
						usr.energy -= 0.1
						if(usr.grab) usr.grab.layer = usr.layer+0.1
					sleep(0.1)
				if(usr.grab == null || usr.client.inactivity > 3000)
					usr.letgo()
			else
				usr.letgo()
			*/
		who_panel()
			set name = ".who_panel"
			set hidden = 1
			var/amount=0
			var/Who={"<html>
	<head><title>Who</title><body>
	<body bgcolor="black"><font family='Default'><font size=2><font color="white">
	"}

			for(var/mob/M) if(M.client) amount+=1
			for(var/mob/M) if(M.client) Who+={"<html>
		<head><title>Who</title><body>
		<body bgcolor="black"><font family='Default'><font size=2><font color=white>
		<br><font color=[M.auracolor]>[M.key]
		"}
			Who += "<br><font color=white>[amount] players.</font></body><html>"
			usr<<browse(Who,"window=Who;size=250x350")
			Who={"<html>
		<head><title>Who</title><body>
		<body bgcolor="black"><font family='Default'><font size=2><font color="white">
		</body><html>"}
		macro_chat()
			set name = ".macro_chat"
			set hidden = 1
			if(usr.typing) return
			if(usr.chat == "world")
				winset(usr,"chat.output_world","focus=true")
			else
				winset(usr,"chat.output_local","focus=true")
		macro_skills(var/t as text)
			set name = ".macro_skills"
			set hidden = 1
			if(usr.spam_protect) return
			if(usr.typing) return
			if(usr.started == 0) return

			if(t == "1")
				//usr.spam_protect=1
				for(var/obj/o in usr.one)
					if(o.repeat) winset(usr,"macro.1","name=1+REP")
					else winset(usr,"macro.1","name=1")
					usr.mouse_dir = "left"
					o.Click()
					usr.mouse_dir = null
				//spawn(10) usr.spam_protect = 0
			if(t == "2")
				usr.spam_protect=1
				for(var/obj/o in usr.two)
					if(o.repeat) winset(usr,"macro.2","name=2+REP")
					else winset(usr,"macro.2","name=2")
					usr.mouse_dir = "left"
					o.Click()
					usr.mouse_dir = null
				spawn(10) usr.spam_protect = 0
			if(t == "3")
				usr.spam_protect=1
				for(var/obj/o in usr.three)
					if(o.repeat) winset(usr,"macro.3","name=3+REP")
					else winset(usr,"macro.3","name=3")
					usr.mouse_dir = "left"
					o.Click()
					usr.mouse_dir = null
				spawn(10) usr.spam_protect = 0
			if(t == "4")
				usr.spam_protect=1
				for(var/obj/o in usr.four)
					if(o.repeat) winset(usr,"macro.4","name=4+REP")
					else winset(usr,"macro.4","name=4")
					usr.mouse_dir = "left"
					o.Click()
					usr.mouse_dir = null
				spawn(10) usr.spam_protect = 0
			if(t == "5")
				usr.spam_protect=1
				for(var/obj/o in usr.five)
					if(o.repeat) winset(usr,"macro.5","name=5+REP")
					else winset(usr,"macro.5","name=5")
					usr.mouse_dir = "left"
					o.Click()
					usr.mouse_dir = null
				spawn(10) usr.spam_protect = 0
			if(t == "6")
				usr.spam_protect=1
				for(var/obj/o in usr.six)
					if(o.repeat) winset(usr,"macro.6","name=6+REP")
					else winset(usr,"macro.6","name=6")
					usr.mouse_dir = "left"
					o.Click()
					usr.mouse_dir = null
				spawn(10) usr.spam_protect = 0
			if(t == "7")
				usr.spam_protect=1
				for(var/obj/o in usr.seven)
					if(o.repeat) winset(usr,"macro.7","name=7+REP")
					else winset(usr,"macro.7","name=7")
					usr.mouse_dir = "left"
					o.Click()
					usr.mouse_dir = null
				spawn(10) usr.spam_protect = 0
			if(t == "8")
				usr.spam_protect=1
				for(var/obj/o in usr.eight)
					if(o.repeat) winset(usr,"macro.8","name=8+REP")
					else winset(usr,"macro.8","name=8")
					usr.mouse_dir = "left"
					o.Click()
					usr.mouse_dir = null
				spawn(10) usr.spam_protect = 0
			if(t == "9")
				usr.spam_protect=1
				for(var/obj/o in usr.nine)
					if(o.repeat) winset(usr,"macro.9","name=9+REP")
					else winset(usr,"macro.9","name=9")
					usr.mouse_dir = "left"
					o.Click()
					usr.mouse_dir = null
				spawn(10) usr.spam_protect = 0
			if(t == "0")
				usr.spam_protect=1
				for(var/obj/o in usr.zero)
					if(o.repeat) winset(usr,"macro.0","name=0+REP")
					else winset(usr,"macro.0","name=0")
					usr.mouse_dir = "left"
					o.Click()
					usr.mouse_dir = null
				spawn(10) usr.spam_protect = 0
			if(t == "=")

				for(var/obj/o in usr.equal)
					if(o.repeat) winset(usr,"macro.=","name= =+REP")
					else winset(usr,"macro.=","name= =")
					usr.mouse_dir = "left"
					o.Click()
					usr.mouse_dir = null
			if(t == "-")
				for(var/obj/o in usr.minus)
					if(o.repeat) winset(usr,"macro.-","name= -+REP")
					else winset(usr,"macro.-","name= -")
					usr.mouse_dir = "left"
					o.Click()
					usr.mouse_dir = null
			return