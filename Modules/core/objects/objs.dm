obj/items/tech
    capsule_storable = 1
    Click(location, control, params)
        ..()
        if(usr.left_click_function == "capsule" && !(src in usr))
            var/obj/items/tech/Capsule/capsule = usr.left_click_ref
            if(!capsule) goto cleanup

            if(get_dist(usr, src) > 2)
                usr << "You are too far away to store that."
                goto cleanup

            if(!src.capsule_storable)
                usr << "That can't be stored in a capsule."
                goto cleanup
            // IMPORTANT: use Move() and verify it worked
            /*if(src.capsule_storable && src.bolted >=2 && src.can_pocket == 0)
                continue*/
            /*if(!src.Move(capsule))
                usr << "The capsule can't store [src] right now."
                goto cleanup*/
            capsule.contents += src
            if(!isobj(src.loc)) src.Move(capsule)
            capsule.storeditem = src
            capsule.suffix = "Capsule - [src.name]"
            capsule.desc_extra = "Stored Item: [src]\n\n"
            capsule.occupied = 1
            if(items)
                if(src in items) items -= src

            view(usr) << sound('capsuleclick.ogg', volume=22)
            for(var/mob/races/P in view(10, usr))
                P << output("[P.get_strangername(usr)] stored [src] inside a capsule.", "actionoutput")

        cleanup:
            usr.left_click_ref = null
            usr.left_click_function = null
            usr.client.mouse_pointer_icon = 'mouse.dmi'
            return
/*/obj/items/tech
	Click(location, control, params)
		..()
		if(usr.left_click_function == "capsule" && !(src in usr))
			if(usr.left_click_ref)
				if(get_dist(usr, src) > 2)
					usr << "You are too far away to store that."
					usr.left_click_function = null
					usr.left_click_ref = null
					usr.client.mouse_pointer_icon = 'mouse.dmi'
					return
				var/obj/items/tech/Capsule/capsule = usr.left_click_ref
				if(isobj(src))
					if(!src.Move(capsule))
						usr << "You can't store [src] inside the capsule."
						usr.left_click_function = null
						usr.left_click_ref = null
						usr.client.mouse_pointer_icon = 'mouse.dmi'
						return
					capsule.storeditem = src
					capsule.suffix = "Capsule - [src.name]"
					capsule.desc_extra = "Stored Item: [capsule.storeditem]\n\n"
					capsule.occupied = 1
					view(usr) << sound('capsuleclick.ogg', volume=22)
					for(var/mob/races/P in view(10, usr))
						P << output("[P.get_strangername(usr)] stored [src] inside a capsule.", "actionoutput")
					usr.left_click_ref=null
			usr.left_click_function = null
			usr.client.mouse_pointer_icon = 'mouse.dmi'
			return
			*/
obj/effects/phase_icon
	icon = 'roleplayalertE.dmi'
	icon_state = "phased"
	plane=29
	layer = MOB_LAYER + 1
	can_pocket = 0
	hashadow=0
	appearance_flags = KEEP_TOGETHER

obj/effects/roleplaymode_icon
	icon = 'roleplayalertE.dmi'
	icon_state = "rpm"
	plane=29
	layer = MOB_LAYER + 1
	can_pocket = 0
	hashadow=0
	appearance_flags = KEEP_TOGETHER
/obj/items/custom_icon_object
    name = "Custom Icon Object"
    icon = 'artifacts_small.dmi'
    icon_state = ""
    layer = MOB_LAYER + 1
    color = "#FFFFFF"
    can_pocket = 1
    stacks = -1
    density_factor = 0
    hashadow = 0
    suffix = null // used to track equipped state
    appearance_flags = KEEP_TOGETHER
    act = /obj/items/custom_icon_object/proc/use
    act_drop = /obj/items/custom_icon_object/proc/drop
    New()
        ..()
        tag = name
        img_select = image('fx.dmi', src, "select item", 1000) // assuming this is your selection FX

    Click(location, control, params)
        ..()
        if(items && src in items) items -= src // Remove from global item list if applicable

        var/list/p = params2list(params)

        if(p["left"])
            if(isturf(src.loc))
                usr.pickup(src)
            else if(ismob(src.loc))
                if(usr.item_selected)
                    usr.item_selected.overlays -= /obj/effects/select_item
                usr.item_selected = src
                //usr << "Selected [src]."
        else if(p["right"])
            show_customization_menu()

    proc/show_customization_menu(var/obj/items/custom_icon_object/i)
        var/list/opts = list(
            "Rename",
            "Change Icon",
            "Change Icon State",
            "Set Layer",
            "Set Color",
            "Cancel"
        )
        var/choice = input(usr, "Customize [src.name]:", "Customization") in opts
        switch(choice)
            if("Rename")
                var/newname = input(usr, "Enter new name:", "Rename", src.name)
                if(newname) src.name = newname

            if("Change Icon")
                var/newicon = input(usr, "Select icon file") as icon|null
                if(newicon) src.icon = newicon
                var/newstate = input(usr, "Enter icon state:", "Icon State", src.icon_state)
                if(newstate) src.icon_state = newstate


            if("Change Icon State")
                var/newstate = input(usr, "Enter icon state:", "Icon State", src.icon_state)
                if(newstate) src.icon_state = newstate

            if("Set Layer")
                var/newlayer = input(usr, "Enter layer:", "Layer", src.layer) as num
                if(isnum(newlayer)) src.layer = newlayer

            if("Set Color")
                var/newcolor = input(usr, "Enter color (e.g. red, #FF0000):", "Color", src.color)
                if(newcolor) i.color = newcolor

            if("Cancel")
                return

    // Mimic the use() logic shown in your sample
    proc/use(var/mob/m, var/obj/items/custom_icon_object/i)
        if(i in m)
            if(i.suffix)
                // Unequipping logic
                i.suffix = null
                i.name = "[initial(i.name)]"
                m.overlays -= i.icon
                m.refresh_inv()
                return
            else
                // Equipping logic (can be expanded)
                i.suffix = "equipped"
                i.name = "[i.name] *Equipped*"
                m.overlays += i.icon
                m.refresh_inv()
                return

    proc/drop(var/mob/m, var/obj/items/custom_icon_object/i)
        if(i in m.accessing)
            if(i.suffix)
                i.suffix = null
                i.name = "[initial(i.name)]"
                m.overlays -= i
            i.overlays -= /obj/effects/select_item
            m.drop(i)

obj/DamagedTurf
	icon='tileset2.dmi'
	icon_state="dirt3"
	New()
		..()
		spawn(rand(200,215))if(src) src.destroy()
obj
	//biome //placed inside players lists and activated once they step foot on this planet.
	/*
	proc
		power(var/list/params,var/mob/m)
			if(bounds_dist(src, m)  <= 10)
				if(params["left"])
					if(src.icon_state == "on")
						src.icon_state = "off"
						src.on = 0
						return
	*/
	items/Money
		name="Money"
		icon='Misc2.dmi'
		icon_state="ZenniBag"
		can_pocket=1
		is_zenni=1
		Click(location,control,params)
			..()
			//Removes this item from the global Items list.
			if(items)
				if(src in items) items -= src
			params = params2list(params)
			if(params["left"])
				if(isturf(src.loc))
					usr.pickup(src)

				else if(ismob(src.loc))
					if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
					usr.item_selected = src
					src.overlays -= /obj/effects/select_item
					src.overlays += /obj/effects/select_item
	PoP_npc_spawner
		layer=1
		bolted = 2
		act = /obj/PoP_npc_spawner/proc/activate
		proc
			activate(obj/PoP_npc_spawner/n)
				if(prob(25))
					var/list/mob_types = list(
						new /mob/NPC/Defenders/turret,
							/mob/NPC/Defenders/beetle
						)
					if(!n.loc)
						for(var/mob/m in world)
							if(m.client)
								m.set_alert("Spawner has no valid location",'alert.dmi',"alert")
						return

					var/spawned_npc = pick(mob_types) // Randomly selects an NPC type
					var/mob/NPC/Defenders/active_npc = spawned_npc
					active_npc.loc = n.loc
					active_npc.npc_ai()
					//var/obj/items/consumables/turnip/t = new /obj/items/consumables/turnip(n.loc)
					//if(!active_npc.loc) active_npc.loc = src.loc // Assigns the NPC to the given turf
					for(var/mob/m in players)
						if(m.client)
							m.set_alert("NPC Set([active_npc.name])",'alert.dmi',"alert")
	pop_npc_spawner
		layer=1
		bolted = 2
		act = /obj/pop_npc_spawner/proc/activate
		proc
			activate(obj/pop_npc_spawner/n)
				if(prob(25))
					var/list/mob_types = list(
						new /mob/NPC/Defenders/turret,
						new /mob/NPC/Defenders/beetle
						)
					if(!n.loc)
						for(var/mob/m in world)
							if(m.client)
								m.set_alert("Spawner has no valid location",'alert.dmi',"alert")
						return

					var/spawned_npc = pick(mob_types) // Randomly selects an NPC type
					var/mob/NPC/Defenders/turret/active_npc = spawned_npc
					active_npc.loc = n.loc
					active_npc.turret_idle_ai()
					//var/obj/items/consumables/turnip/t = new /obj/items/consumables/turnip(n.loc)
					//if(!active_npc.loc) active_npc.loc = src.loc // Assigns the NPC to the given turf
					//for(var/mob/m in players)
					//	if(m.client)
					//		m.set_alert("NPC Set([active_npc.name])",'alert.dmi',"alert")
	npc_spawner
		layer=1
		bolted = 2
		act = /obj/npc_spawner/proc/activate
		proc
			activate(obj/npc_spawner/n)
				if(prob(25))
					var/list/mob_types = list(
						new /mob/NPC/Animals/T_Rex,
						new /mob/NPC/Animals/Dinosaur,
						new /mob/NPC/Animals/Dragon
						)
					if(!n.loc)
						for(var/mob/m in world)
							if(m.client)
								m.set_alert("Spawner has no valid location",'alert.dmi',"alert")
						return

					var/spawned_npc = pick(mob_types) // Randomly selects an NPC type
					var/mob/NPC/active_npc = spawned_npc
					active_npc.loc = n.loc
					active_npc.npc_ai()
					//var/obj/items/consumables/turnip/t = new /obj/items/consumables/turnip(n.loc)
					//if(!active_npc.loc) active_npc.loc = src.loc // Assigns the NPC to the given turf
				//	for(var/mob/m in players)
					//	if(m.client)
					//		m.set_alert("NPC Set([active_npc.name])",'alert.dmi',"alert")

		/*	while(src)
				if(prob(25))
					var/mob/NPC/spawned_npc = pick(mob_types) // Randomly selects an NPC type
					var/mob/NPC/active_npc = new spawned_npc(src.loc)
					if(!active_npc.loc) active_npc.loc = src.loc // Assigns the NPC to the given turf
					for(var/mob/m in world)
						if(m.client)
							m.set_alert("NPC Set([active_npc])",'alert.dmi',"alert")
					break
				src.active=0

				*/
	Beds
		Bed=1
		bolted = 2
		Bed
			icon = 'HospitalBed2.dmi'

	divider
		density=1
		density_factor = 1
		opacity=1
		hp=9999999999999999999999999999999999999
		layer=60
	skin_color_select
		icon='RPBoxes.dmi'
		icon_state="colors"
		layer = 33
		plane = 24
		hud_x = 15
		hud_y = 415
		Click()
			var/mob/target = usr
			if(usr.race!="Kai") return
			var/c  = input ("Choose a color for your skin.") as color
			if(target)
				target.skin_c = c
				//winset(target,"char_creation.eye_color","background-color=[c]")

				target.update_looks("skin color")
				target.saved_skin_c = target.skin_c
				if(usr.port && usr.hud_char)
					//Adjust players portrait first.
					usr.hud_char.update_portrait_transform()
					//Adjust players in-game avatar next.
					usr.hud_char.menu_avatar()
				//if(usr.hud_char)
				//	usr.hud_char.menu.clear_portrait_vis()
				//	usr.hud_char.menu.update_portrait_transform()
				//else
				//	usr.hud_char.menu.update_portrait_transform()
	eye_color_select
		icon='RPBoxes.dmi'
		icon_state="colors"
		layer = 33
		plane = 24
		hud_x = 15
		hud_y = 375
		Click()
			var/mob/target = usr
			if(target.race == "Saiyan" && !target.is_hybrid) 
				target.eye_c = rgb(0,0,0)
				target.update_looks("eye color")
				target << "Saiyans have black eyes by default."
				return
			var/c  = input ("Choose a color for your eyes.") as color
			if(target)
				target.eye_c = c
				winset(target,"char_creation.eye_color","background-color=[c]")

				target.update_looks("eye color")
				target.saved_eye_c = target.eye_c
				if(usr.port && usr.hud_char)
					//Adjust players portrait first.
					usr.hud_char.update_portrait_transform()
					//Adjust players in-game avatar next.
					usr.hud_char.menu_avatar()
				//if(usr.hud_char)
				//	usr.hud_char.menu.clear_portrait_vis()
				//	usr.hud_char.menu.update_portrait_transform()
				//else
				//	usr.hud_char.menu.update_portrait_transform()
	hair_color_select
		icon='RPBoxes.dmi'
		icon_state="colors"
		layer = 33
		plane = 24
		hud_x = 15
		hud_y = 435
		Click()
			var/mob/target = usr
			if(target.race == "Saiyan" && !target.is_hybrid) return
			var/c  = input ("Choose a color for your hair.") as color
			if(target)
				target.hair_c = c
				if(target.saiyan_dna && target.is_hybrid)
					target.tail_c = target.hair_c
					target.saved_tail_c = target.tail_c
				winset(target,"char_creation.hair_color","background-color=[c]")
				target.update_looks("hair color")
				target.saved_hair_c = target.hair_c
				if(usr.port && usr.hud_char)
					//Adjust players portrait first.
					usr.hud_char.update_portrait_transform()
					//Adjust players in-game avatar next.
					usr.hud_char.menu_avatar()

				//if(usr.hud_char)
				//	usr.hud_char.menu.clear_portrait_vis()
				//	usr.hud_char.menu.update_portrait_transform()
				//else
				///	usr.hud_char.menu.update_portrait_transform()
	interiors
		hp = 1.#INF
		block_halfdense
			density_factor = 1
			icon = 'red.dmi'
			layer = 100
			bolted = 2
			New()
				spawn(10)
					src.icon = null
		block_dense
			density_factor = 2
			icon = 'red.dmi'
			layer = 100
			bolted = 2
			New()
				spawn(10)
					src.icon = null
		ship_parts
			ship_core
				icon = 'ship_inside.dmi'
				icon_state = "core layer"
				pixel_x = -8
				layer = 4
				mouse_opacity = 0
			ship_chair
				icon = 'ship_inside.dmi'
				icon_state = "chair"
				pixel_x = -8
				layer = 4
				mouse_opacity = 0
			ship_console
				icon = 'ship_inside.dmi'
				icon_state = "console"
				pixel_x = -8
				Click()
					if(usr.open_ship == 0)
						if(usr in range(11,src))
							usr.open_ship = src
							winshow(usr,"ship",1)
							for(var/obj/items/tech/ships/CC_Ship/s in world)
								if(s.loc)
									usr.client.perspective = EYE_PERSPECTIVE | EDGE_PERSPECTIVE
									usr.client.eye = s
									usr.client.view += 5
					else
						usr.open_ship = 0
			ship_inside
				icon = 'ship_inside.dmi'
				icon_state = "inside"
				pixel_x = -8
				layer = 2
				mouse_opacity = 0


	warpers
		var/goes_x = null
		var/goes_y = null
		var/goes_z = null
		bolted = 2
		density = 0
		density_factor = 0
		opacity = 0
		tree_exit
			//icon = 'terrain.dmi'
			//icon_state = "blank"
			goes_x = 250
			goes_y = 254
			goes_z = 4
			//Enter(atom/movable/O, atom/oldloc)
			Cross(atom/movable/O)
				if(src.goes_x)
					O.loc = locate(src.goes_x,src.goes_y,src.goes_z)
					if(ismob(O))
						var/mob/M = O
						M << sound(null,channel = 9)
						if(M.ambients) M.ambients -= "yuk tree heart beat"
						if(M.client) M.apply_hell_glow(0)
						if(M.client) M.apply_afterlife_glow(0)
						if(M.client) M.apply_space_glow(0)
						if(M.client) M.apply_demonrealm_glow(0)
		tree_entrance
			//icon = 'grass_yukopian.dmi'
			goes_x = 250
			goes_y = 256
			goes_z = 7
			//Enter(atom/movable/O, atom/oldloc)
			Cross(atom/movable/O)
				if(src.goes_x)
					O.loc = locate(src.goes_x,src.goes_y,src.goes_z)
					if(ismob(O))
						var/mob/M = O
						if(M.client) M.apply_hell_glow(0)
						if(M.client) M.apply_afterlife_glow(0)
						if(M.client) M.apply_space_glow(0)
						if(M.client) M.apply_demonrealm_glow(0)
		inside_hbtc_exit
			goes_x = 238
			goes_y = 168
			goes_z = 23
			//Enter(atom/movable/O, atom/oldloc)
			Cross(atom/movable/O)
				if(global.hbtc_open && ismob(O))
					var/mob/M = O
					if(M.hbtc_exit_prompting) return // Prevent spam

					M.hbtc_exit_prompting = 1
					M.stunned += 1

					spawn()
						var/choice = alert(M, "Do you wish to exit the Hyperbolical Chamber?\nWARNING: You will not be able to enter again!", "", "Yes", "No")
						if(choice == "Yes")
							M.stunned -= 1
							M.accelerated_aging = 0
							M.inside_hbtc = 0
							if(src.goes_x)
								M.loc = locate(src.goes_x, src.goes_y, src.goes_z)

							//if(M.client)
							///	M.apply_hbtc_glow(0)
								//sleep(1)
							//	M.apply_korintower_glow(0)

						else if(choice == "No")
							M.stunned -= 1

						M.hbtc_exit_prompting = 0 // Clear flag
		inside_hbtc_entrance
			goes_x = 239
			goes_y = 444
			goes_z = 23
			//Enter(atom/movable/O, atom/oldloc)
			Cross(atom/movable/O)
				if(global.hbtc_open && ismob(O))
					var/mob/M = O
					if(M.hbtc_exit_prompting) return // Prevent spam

					M.hbtc_exit_prompting = 1
					M.stunned += 1
					spawn()
						if(M.hbtc_entries<1)
							var/choice
							if(global.hbtc_time == 27) choice = alert(M, "Do you wish to enter the Hyperbolical Chamber?\nWARNING: Time is sped up by x100 inside the chamber at the moment!","","Yes","No")
							if(global.hbtc_time == 270) choice = alert(M, "Do you wish to enter the Hyperbolical Chamber?\nWARNING: Time is sped up by x10 inside the chamber!","","Yes","No")
							if(choice == "Yes")
								M.stunned -= 1

								if(src.goes_x)
									M.loc = locate(src.goes_x, src.goes_y, src.goes_z)
									M.inside_hbtc = 1
									M.hbtc_entries += 1
								//if(M.client)
									//M.apply_korintower_glow(0)
									//sleep(1)
									//M.apply_hbtc_glow(1)
								M.accelerate_age()
							else if(choice == "No")
								M.stunned -= 1
						else
							M << output("You have exceeded your entry limit!","actionoutput")
							M.hbtc_exit_prompting = 0
							M.stunned -= 1
							return

						M.hbtc_exit_prompting = 0 // Clear flag


				/*if(global.hbtc_open)
					if(ismob(O))
						var/mob/M = O
						if(M.hbtc_entries<1)
							M.stunned +=1
							switch(alert(M,"Do you wish to enter the Hyperbolical Chamber?\nWARNING: Time is sped up by x10 inside the chamber!","","Yes","No"))
								if("Yes")
									M.stunned -=1
									if(src.goes_x)
										O.loc = locate(src.goes_x,src.goes_y,src.goes_z)
										if(M.client)
											M.apply_korintower_glow(0)
											sleep(1)
											M.apply_hbtc_glow(1)
											M.hbtc_entries += 1
											M.inside_hbtc = 1
											spawn() M.accelerate_age()
								if("No")
									M.stunned -=1
									return
						else
							M << output("You have exceeded your entry limit!","actionoutput")
							return

							*/
		hbtc_entrance
			goes_x = 238
			goes_y = 2
			goes_z = 23
			//Enter(atom/movable/O, atom/oldloc)
			Cross(atom/movable/O)
				if(src.goes_x)
					O.loc = locate(src.goes_x,src.goes_y,src.goes_z)
					//if(ismob(O))
					//	var/mob/M = O
					//	if(M.client)
						//	M.apply_korintower_glow(0)
						//	sleep(1)
							//M.apply_hbtc_glow(1)
		hbtc_exit
			goes_x = 236
			goes_y = 476
			goes_z = 14
			//Enter(atom/movable/O, atom/oldloc)
			Cross(atom/movable/O)
				if(src.goes_x)
					O.loc = locate(src.goes_x,src.goes_y,src.goes_z)
					//if(ismob(O))
					//	var/mob/M = O
					//	if(M.client)
						//	M.apply_hbtc_glow(0)
						//	sleep(1)
						//	M.apply_korintower_glow(1)
		korintower_entrance
			icon = 'cloudSmall.dmi'
			icon_state = ""
			goes_x = 236
			goes_y = 2
			goes_z = 14
			//Enter(atom/movable/O, atom/oldloc)
			Cross(atom/movable/O)
				if(src.goes_x)
					O.loc = locate(src.goes_x,src.goes_y,src.goes_z)
					//if(ismob(O))
					//	var/mob/M = O
					//	if(M.client) M.apply_korintower_glow(1)
		korintower_exit
			//icon = 'cave_exit.dmi'
			goes_x = 453
			goes_y = 256
			goes_z = 1
			//Enter(atom/movable/O, atom/oldloc)
			Cross(atom/movable/O)
				if(src.goes_x)
					O.loc = locate(src.goes_x,src.goes_y,src.goes_z)
					//if(ismob(O))
					//	var/mob/M = O
					//	if(M.client) M.apply_korintower_glow(0)
		cave_entrance_01
			icon = 'terrain.dmi'
			icon_state = "cave entrance"
			goes_x = 291
			goes_y = 43
			goes_z = 3
			//Enter(atom/movable/O, atom/oldloc)
			Cross(atom/movable/O)
				if(src.goes_x)
					O.loc = locate(src.goes_x,src.goes_y,src.goes_z)
					if(ismob(O))
						var/mob/M = O
						if(M.client) M.apply_hell_glow(0)
						if(M.client) M.apply_afterlife_glow(0)
						if(M.client) M.apply_space_glow(0)
						if(M.client) M.apply_demonrealm_glow(0)
		underworld_exit_01
			icon = 'cave_exit.dmi'
			goes_x = 291
			goes_y = 41
			goes_z = 1
			//Enter(atom/movable/O, atom/oldloc)
			Cross(atom/movable/O)
				if(src.goes_x)
					if(ismob(O))
						var/mob/M = O
						O.loc = locate(M.last_x,M.last_y,M.last_z)
						if(M.client) M.apply_afterlife_glow(1)
						if(M.client) M.apply_space_glow(1)
		cave_exit_01
			icon = 'cave_exit.dmi'
			goes_x = 291
			goes_y = 41
			goes_z = 1
			//Enter(atom/movable/O, atom/oldloc)
			Cross(atom/movable/O)
				if(src.goes_x)
					O.loc = locate(src.goes_x,src.goes_y,src.goes_z)
					if(ismob(O))
						var/mob/M = O
						if(M.client) M.apply_afterlife_glow(1)
						if(M.client) M.apply_space_glow(1)
		cave_entrance_09 //namek cave 2
			icon = 'terrain.dmi'
			icon_state = "cave entrance"
			goes_x = 373
			goes_y = 169
			goes_z = 21
			//Enter(atom/movable/O, atom/oldloc)
			Cross(atom/movable/O)
				if(src.goes_x)
					O.loc = locate(src.goes_x,src.goes_y,src.goes_z)
					if(ismob(O))
						var/mob/M = O
						if(M.client) M.apply_hell_glow(0)
						if(M.client) M.apply_afterlife_glow(0)
						if(M.client) M.apply_space_glow(0)
						if(M.client) M.apply_demonrealm_glow(0)
		cave_exit_09 // namek cave 2
			icon = 'cave_exit.dmi'
			goes_x = 479
			goes_y = 249
			goes_z = 4
			//Enter(atom/movable/O, atom/oldloc)
			Cross(atom/movable/O)
				if(src.goes_x)
					O.loc = locate(src.goes_x,src.goes_y,src.goes_z)
					if(ismob(O))
						var/mob/M = O
						if(M.client) M.apply_hell_glow(0)
						if(M.client) M.apply_afterlife_glow(0)
						if(M.client) M.apply_space_glow(0)
						if(M.client) M.apply_demonrealm_glow(0)
		cave_entrance_08 //namek cave 1
			icon = 'terrain.dmi'
			icon_state = "cave entrance"
			goes_x = 232
			goes_y = 268
			goes_z = 21
			//Enter(atom/movable/O, atom/oldloc)
			Cross(atom/movable/O)
				if(src.goes_x)
					O.loc = locate(src.goes_x,src.goes_y,src.goes_z)
					if(ismob(O))
						var/mob/M = O
						if(M.client) M.apply_hell_glow(0)
						if(M.client) M.apply_afterlife_glow(0)
						if(M.client) M.apply_space_glow(0)
						if(M.client) M.apply_demonrealm_glow(0)
		cave_exit_08 // namek  cave
			icon = 'cave_exit.dmi'
			goes_x = 31
			goes_y = 334
			goes_z = 4
			//Enter(atom/movable/O, atom/oldloc)
			Cross(atom/movable/O)
				if(src.goes_x)
					O.loc = locate(src.goes_x,src.goes_y,src.goes_z)
					if(ismob(O))
						var/mob/M = O
						if(M.client) M.apply_hell_glow(0)
						if(M.client) M.apply_afterlife_glow(0)
						if(M.client) M.apply_space_glow(0)
						if(M.client) M.apply_demonrealm_glow(0)
		cave_entrance_07 //vegeta cave 3
			icon = 'terrain.dmi'
			icon_state = "cave entrance"
			goes_x = 232
			goes_y = 268
			goes_z = 20
			//Enter(atom/movable/O, atom/oldloc)
			Cross(atom/movable/O)
				if(src.goes_x)
					O.loc = locate(src.goes_x,src.goes_y,src.goes_z)
					if(ismob(O))
						var/mob/M = O
						if(M.client) M.apply_hell_glow(0)
						if(M.client) M.apply_afterlife_glow(0)
						if(M.client) M.apply_space_glow(0)
						if(M.client) M.apply_demonrealm_glow(0)
		cave_exit_07 // vegeta cave 3
			icon = 'cave_exit.dmi'
			goes_x = 211
			goes_y = 141
			goes_z = 10
			//Enter(atom/movable/O, atom/oldloc)
			Cross(atom/movable/O)
				if(src.goes_x)
					O.loc = locate(src.goes_x,src.goes_y,src.goes_z)
					if(ismob(O))
						var/mob/M = O
						if(M.client) M.apply_hell_glow(0)
						if(M.client) M.apply_afterlife_glow(0)
						if(M.client) M.apply_space_glow(0)
						if(M.client) M.apply_demonrealm_glow(0)
		cave_entrance_06 //vegeta cave 2
			icon = 'terrain.dmi'
			icon_state = "cave entrance"
			goes_x = 458
			goes_y = 163
			goes_z = 20
			//Enter(atom/movable/O, atom/oldloc)
			Cross(atom/movable/O)
				if(src.goes_x)
					O.loc = locate(src.goes_x,src.goes_y,src.goes_z)
					if(ismob(O))
						var/mob/M = O
						if(M.client) M.apply_hell_glow(0)
						if(M.client) M.apply_afterlife_glow(0)
						if(M.client) M.apply_space_glow(0)
						if(M.client) M.apply_demonrealm_glow(0)
		cave_exit_06 // vegeta cave 2
			icon = 'cave_exit.dmi'
			goes_x = 440
			goes_y = 35
			goes_z = 10
			//Enter(atom/movable/O, atom/oldloc)
			Cross(atom/movable/O)
				if(src.goes_x)
					O.loc = locate(src.goes_x,src.goes_y,src.goes_z)
					if(ismob(O))
						var/mob/M = O
						if(M.client) M.apply_hell_glow(0)
						if(M.client) M.apply_afterlife_glow(0)
						if(M.client) M.apply_space_glow(0)
						if(M.client) M.apply_demonrealm_glow(0)
		cave_entrance_05 //vegeta cave 1
			icon = 'terrain.dmi'
			icon_state = "cave entrance"
			goes_x = 38
			goes_y = 202
			goes_z = 20
			//Enter(atom/movable/O, atom/oldloc)
			Cross(atom/movable/O)
				if(src.goes_x)
					O.loc = locate(src.goes_x,src.goes_y,src.goes_z)
					if(ismob(O))
						var/mob/M = O
						if(M.client) M.apply_hell_glow(0)
						if(M.client) M.apply_afterlife_glow(0)
						if(M.client) M.apply_space_glow(0)
						if(M.client) M.apply_demonrealm_glow(0)
		cave_exit_05 // vegeta cave 1
			icon = 'cave_exit.dmi'
			goes_x = 23
			goes_y = 463
			goes_z = 10
			//Enter(atom/movable/O, atom/oldloc)
			Cross(atom/movable/O)
				if(src.goes_x)
					O.loc = locate(src.goes_x,src.goes_y,src.goes_z)
					if(ismob(O))
						var/mob/M = O
						if(M.client) M.apply_hell_glow(0)
						if(M.client) M.apply_afterlife_glow(0)
						if(M.client) M.apply_space_glow(0)
						if(M.client) M.apply_demonrealm_glow(0)
		cave_entrance_02
			icon = 'terrain.dmi'
			icon_state = "door cliff 1"
			goes_x = 38
			goes_y = 203
			goes_z = 3
			//Enter(atom/movable/O, atom/oldloc)
			Cross(atom/movable/O)
				if(src.goes_x)
					O.loc = locate(src.goes_x,src.goes_y,src.goes_z)
					if(ismob(O))
						var/mob/M = O
						if(M.client) M.apply_hell_glow(0)
						if(M.client) M.apply_afterlife_glow(0)
						if(M.client) M.apply_space_glow(0)
						if(M.client) M.apply_demonrealm_glow(0)
		cave_exit_02
			icon = 'cave_exit.dmi'
			goes_x = 38
			goes_y = 201
			goes_z = 1
			//Enter(atom/movable/O, atom/oldloc)
			Cross(atom/movable/O)
				if(src.goes_x)
					O.loc = locate(src.goes_x,src.goes_y,src.goes_z)
					if(ismob(O))
						var/mob/M = O
						if(M.client) M.apply_afterlife_glow(0)
						if(M.client) M.apply_space_glow(0)
		cave_entrance_03
			icon = 'terrain.dmi'
			icon_state = "cave entrance"
			goes_x = 380
			goes_y = 39
			goes_z = 18
			//Enter(atom/movable/O, atom/oldloc)
			Cross(atom/movable/O)
				if(src.goes_x)
					O.loc = locate(src.goes_x,src.goes_y,src.goes_z)
					if(ismob(O))
						var/mob/M = O
						if(M.client) M.apply_hell_glow(0)
						if(M.client) M.apply_afterlife_glow(0)
						if(M.client) M.apply_space_glow(0)
						if(M.client) M.apply_demonrealm_glow(0)
		cave_exit_03
			icon = 'cave_exit.dmi'
			goes_x = 140
			goes_y = 407
			goes_z = 9
			//Enter(atom/movable/O, atom/oldloc)
			Cross(atom/movable/O)
				if(src.goes_x)
					O.loc = locate(src.goes_x,src.goes_y,src.goes_z)
					if(ismob(O))
						var/mob/M = O
						if(M.client) M.apply_afterlife_glow(0)
						if(M.client) M.apply_space_glow(0)
		cave_entrance_04
			icon = 'terrain.dmi'
			icon_state = "cave entrance"
			goes_x = 419
			goes_y = 358
			goes_z = 3
			//Enter(atom/movable/O, atom/oldloc)
			Cross(atom/movable/O)
				if(src.goes_x)
					O.loc = locate(src.goes_x,src.goes_y,src.goes_z)
					if(ismob(O))
						var/mob/M = O
						if(M.client) M.apply_hell_glow(0)
						if(M.client) M.apply_afterlife_glow(0)
						if(M.client) M.apply_space_glow(0)
						if(M.client) M.apply_demonrealm_glow(0)
		cave_exit_04
			icon = 'cave_exit.dmi'
			goes_x = 419
			goes_y = 356
			goes_z = 1
			//Enter(atom/movable/O, atom/oldloc)
			Cross(atom/movable/O)
				if(src.goes_x)
					O.loc = locate(src.goes_x,src.goes_y,src.goes_z)
					if(ismob(O))
						var/mob/M = O
						if(M.client) M.apply_afterlife_glow(0)
						if(M.client) M.apply_space_glow(0)
		volcano_entrance_01
			icon = 'terrain.dmi'
			icon_state = "cave entrance"
			goes_x = 458
			goes_y = 163
			goes_z = 3
			//Enter(atom/movable/O, atom/oldloc)
			Cross(atom/movable/O)
				if(src.goes_x)
					O.loc = locate(src.goes_x,src.goes_y,src.goes_z)
					if(ismob(O))
						var/mob/M = O
						if(M.client) M.apply_hell_glow(0)
						if(M.client) M.apply_afterlife_glow(0)
						if(M.client) M.apply_space_glow(0)
						if(M.client) M.apply_demonrealm_glow(0)
		volcano_exit_01
			icon = 'cave_exit.dmi'
			goes_x = 458
			goes_y = 161
			goes_z = 1
			//Enter(atom/movable/O, atom/oldloc)
			Cross(atom/movable/O)
				if(src.goes_x)
					O.loc = locate(src.goes_x,src.goes_y,src.goes_z)
					if(ismob(O))
						var/mob/M = O
						if(M.client) M.apply_afterlife_glow(0)
						if(M.client) M.apply_space_glow(0)
	effects
		bolted = 2
		density_factor = 0
		phasemodeicon
			icon = 'RPBoxes.dmi'
			icon_state = "pm"
			appearance_flags = KEEP_TOGETHER

		roleplaymodeicon
			icon = 'RPBoxes.dmi'
			icon_state = "rpm"
			appearance_flags = KEEP_TOGETHER
		stunned
			icon = 'stunned.dmi'
			pixel_y = 8
			appearance_flags = KEEP_APART

		blood_splatter
			icon = 'bloods.dmi'
			icon_state = "1"
			//blend_mode = BLEND_ADD
			appearance_flags = KEEP_APART
			//layer=1
			//plane=22

			New()
				..()
				pixel_x = rand(-8,8)
				pixel_y = rand(-8,8)
				icon_state = pick("1","2","3","4")
				animate(src, alpha = 0,time = rand(60,180))
		stack_num
			appearance_flags = PIXEL_SCALE
			vis_flags = VIS_INHERIT_ID | VIS_INHERIT_LAYER | VIS_INHERIT_PLANE
		inv_slot
			icon = 'inv_slot.dmi'
			alpha = 60
			appearance_flags = PIXEL_SCALE | KEEP_APART
			vis_flags = VIS_INHERIT_ID | VIS_INHERIT_LAYER | VIS_INHERIT_PLANE | VIS_UNDERLAY
		shop_slot
			icon = 'inv_slot.dmi'
			alpha = 60
			appearance_flags = PIXEL_SCALE | KEEP_APART
		eyes_white
			icon = 'eye_whites.dmi'
			vis_flags = VIS_INHERIT_ICON_STATE | VIS_INHERIT_DIR | VIS_INHERIT_LAYER
			hasreflect = 1
			hashadow = 0
			//layer = 10
		eyes_iris
			icon = 'eye_pupils.dmi'
			vis_flags = VIS_INHERIT_ICON_STATE | VIS_INHERIT_DIR | VIS_INHERIT_LAYER
			hasreflect = 1
			hashadow = 0
			//layer = 11
		eyes_lich
			icon = 'Lich_Eyes.dmi'
			appearance_flags = KEEP_APART
			hasreflect = 0
			hashadow = 0
			plane = 2
			/*
			New()
				src.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(102,0,204))
				src.filters += filter(type="bloom", threshold=rgb(0,0,0), size = 6,offset=1,alpha = 175)
			*/
		eyes_focus
			icon = 'eye_whites.dmi'
			appearance_flags = KEEP_APART
			vis_flags = VIS_INHERIT_DIR | VIS_INHERIT_LAYER | VIS_INHERIT_ICON_STATE
			hasreflect = 0
			hashadow = 0
			New()
				src.filters += filter(type="bloom", threshold=rgb(0,0,0), size = 6,offset=1,alpha = 100)
				src.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(51,203,247))
		eyes_focus_celestial
			icon = 'eye_pupils.dmi'
			appearance_flags = KEEP_APART
			vis_flags = VIS_INHERIT_DIR | VIS_INHERIT_LAYER | VIS_INHERIT_ICON_STATE
			hasreflect = 0
			hashadow = 0
			New()
				src.filters += filter(type="bloom", threshold=rgb(0,0,0), size = 6,offset=1,alpha = 55)
				src.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(255,255,255))
		eyes_divine
			icon = 'eye_whites.dmi'
			appearance_flags = KEEP_APART
			vis_flags = VIS_INHERIT_DIR | VIS_INHERIT_LAYER | VIS_INHERIT_ICON_STATE
			hasreflect = 0
			hashadow = 0
			New()
				src.filters += filter(type="bloom", threshold=rgb(0,0,0), size = 6,offset=1,alpha = 100)
				src.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(255,204,0))
		eyes_wide
			icon = 'eye_whites.dmi'
			appearance_flags = KEEP_APART
			vis_flags = VIS_INHERIT_DIR | VIS_INHERIT_LAYER | VIS_INHERIT_ICON_STATE
			hasreflect = 0
			hashadow = 0
			New()
				src.filters += filter(type="bloom", threshold=rgb(0,0,0), size = 6,offset=1,alpha = 100)
				src.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(51,203,247))

		offline
			icon = 'offline.dmi'
			layer = 20
			pixel_x = 4
			pixel_y = 4
			appearance_flags = KEEP_APART
		orb_dark
			icon = 'fx.dmi'
			icon_state = "orb"
			plane = 22
			New()
				src.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(102,0,204))
				src.filters += filter(type="bloom", threshold=rgb(0,0,0), size = 6,offset=1,alpha = 175)
		orb_divine
			icon = 'fx.dmi'
			icon_state = "orb"
			plane = 22
			New()
				src.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(255,255,170))
				src.filters += filter(type="bloom", threshold=rgb(0,0,0), size = 6,offset=1,alpha = 175)
		orb
			icon = 'fx.dmi'
			icon_state = "orb"
			plane = 22
			New()
				src.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(102,0,204))
				src.filters += filter(type="bloom", threshold=rgb(0,0,0), size = 6,offset=1,alpha = 175)
			//plane = 1;
		wing_pixel
			icon = 'fx.dmi'
			icon_state = "pixel"
			appearance_flags = KEEP_TOGETHER
			vis_flags = VIS_INHERIT_ID | VIS_INHERIT_DIR
			//New()
				//src.filters += filter(type="drop_shadow", x=0, y=0, size=1, offset=1, color=rgb(102,204,255))
			var/timing = 0
			var/o_y = 0
			var/t_y = 0
		bubble
			icon = 'bubble.dmi'
			layer = 100
		txt
			maptext_width = 128
			maptext_height = 256
			maptext_y = 52
			layer = 30
		over_displays
			var/in_use = 0
			var/can_click = 0
			var/fading = 0
			lvl_up_overlay
				maptext_width = 500
				//maptext_width = 192
				maptext_height = 64
				maptext_x = -502
				maptext_y = 8
				layer = 30
				plane=22
				screen_loc = "32,18"
				MouseEntered(location,control,params)
					if(src.can_click)
						src.filters = filter(type="outline", size=1, color=rgb(255,255,255))
				MouseExited(location,control,params)
					if(src.can_click)
						src.filters = null
				Click(location,control,params)
					params = params2list(params)
					if(params["left"])
						if(src.help_text)
							if(usr.open_help == 0)
								usr.open_help = 1
								usr.open_menus.Add(".open_help")
								usr.client.screen += usr.hud_help
							var/obj/hud/menus/help_background/s = usr.hud_help
							var/obj/hud/menus/help_background/txt_raw/txt = s.txt_raw
							txt.maptext = "[css_outline]<font size = 1><text align=center valign=top><u>[src.name]</u>\n<text align=left valign=top>[src.help_text]"
							return
					if(params["right"])
						src.dismiss_alert(usr)
						return
				//filters = filter(type="outline", size=1, color=rgb(0,0,0))
			dmg_num
				pixel_y = 16
				maptext_x = 9
				maptext_width = 96
				maptext_height = 64
				filters = filter(type="outline", size=1, color=rgb(0,0,0))
				layer = 30
				var/mob/stay_with = null
				proc
					activate()
						if(src.loc && src.stay_with)
							src.loc = stay_with.loc
							src.step_x = stay_with.step_x
							src.step_y = stay_with.step_y
						else return
						spawn()
							if(src) src.activate()
					remove()
						spawn(10)
							if(src)
								loc = null
								alpha = 255
								pixel_y = 16
		minigames
			tk_ring
				icon = 'tk_ring.dmi'
				pixel_x = -48
				pixel_y = -60
				bounds = "-47,-59 to 112,100"
				layer = 101
				alpha = 50
				mouse_opacity = 0
				//transform = 0.5
				var/tmp/mob/tether = null
				New()
					..()
					spawn(1)
						src.transform *= 1.33
						src.filters += filter(type="drop_shadow", x=0, y=0,\
						size=5, offset=2, color=rgb(150,150,225))
		black_hole
			icon = 'black_hole.dmi'
			bounds = "17,17 to 48,48"
			var/mob/follow
			/*
			New()
				spawn(1)
					if(src) if(src.follow)
						while(src && src.follow)
							if(get_dist(src,src.follow) < 2)
								src.SetCenter(src.follow)
								src.step_y += 20
							sleep(0.1)
			*/
		aura
			icon = 'fx_aura.dmi'
			density_factor = 0
			density = 0
			alpha = 150
			plane = 0;
			layer = 10;
			pixel_x = -16
			pixel_y = -8
			New()
				..()
		aura_burst
			icon = 'ShadowAuraBurst.dmi'
			density_factor = 0
			density = 0
			alpha = 150
			plane = 0
			layer = AURA_LAYER + 20
			//pixel_x = -16
			//pixel_y = -8
			New()
				..()
		aura_stablized
			icon = 'ShadowsAuraTrans.dmi'
			density_factor = 0
			density = 0
			alpha = 150
			plane = 0
			layer = AURA_LAYER + 20
			//pixel_x = -16
			//pixel_y = -8
			New()
				..()
		lightning_bolt_psi_temp
			icon = 'fx_psi_lightening.dmi'
			layer = 12
			alpha = 255
			pixel_x = -55
			pixel_y = 20
			bolted = 2
			//plane = -1
			New()
				spawn(1)
					if(src)
						src.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(102,0,204))
						src.filters += filter(type="bloom", threshold=rgb(0,0,0), size = 6,offset=1,alpha = 175)
						var/matrix/m = matrix()//*rand(0.1,1)
						var/s = rand(0.1,1)
						m.Scale(s, s)
						m.Turn(rand(0,360))
						src.transform = m
						src.alpha = 200
						src.icon_state = pick("3","4","5","6")
						sleep(8)
						if(src) animate(src,alpha = 0, time = 6)
						sleep(6)
						if(src) src.destroy()



		lightning_bolt_icer
			icon = 'fx_psi_lightening.dmi'
			layer = 12
			alpha = 255
			pixel_x = -55
			pixel_y = 20
			bolted = 2
			New()
				src.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(222,251,255))
				src.filters += filter(type="bloom", threshold=rgb(0,0,0), size=6, offset=1, alpha=175)

			//	Register_Lightning_Bolt(src) // Register this lightning bolt for global handling
				spawn(rand(10,100))
					while(src)
						src.icon_state = pick("3","4","5","6")
						sleep(8)
						if(src) animate(src, alpha=0, time=6)
						sleep(6)
						if(src) src.alpha = 200
						src.icon_state = ""
						sleep(rand(6,60))
						if(src)
							src.alpha = 200
		lightning_bolt_namek
			icon = 'fx_psi_lightening.dmi'
			layer = 12
			alpha = 255
			pixel_x = -55
			pixel_y = 20
			bolted = 2
			New()
				src.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(149,210,174))
				src.filters += filter(type="bloom", threshold=rgb(0,0,0), size=6, offset=1, alpha=175)

			//	Register_Lightning_Bolt(src) // Register this lightning bolt for global handling
				spawn(rand(10,100))
					while(src)
						src.icon_state = pick("3","4","5","6")
						sleep(8)
						if(src) animate(src, alpha=0, time=6)
						sleep(6)
						if(src) src.alpha = 200
						src.icon_state = ""
						sleep(rand(6,60))
						if(src)
							src.alpha = 200
		lightning_bolt_vegeta
			icon = 'fx_psi_lightening.dmi'
			layer = 12
			alpha = 255
			pixel_x = -55
			pixel_y = 20
			bolted = 2
			New()
				src.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(131,3,62))
				src.filters += filter(type="bloom", threshold=rgb(0,0,0), size=6, offset=1, alpha=175)

			//	Register_Lightning_Bolt(src) // Register this lightning bolt for global handling
				spawn(rand(10,100))
					while(src)
						src.icon_state = pick("3","4","5","6")
						sleep(8)
						if(src) animate(src, alpha=0, time=6)
						sleep(6)
						if(src) src.alpha = 200
						src.icon_state = ""
						sleep(rand(6,60))
						if(src)
							src.alpha = 200
		lightning_bolt_earth
			icon = 'fx_psi_lightening.dmi'
			layer = 12
			alpha = 255
			pixel_x = -55
			pixel_y = 20
			bolted = 2
			New()
				src.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(98,236,244))
				src.filters += filter(type="bloom", threshold=rgb(0,0,0), size=6, offset=1, alpha=175)

			//	Register_Lightning_Bolt(src) // Register this lightning bolt for global handling
				spawn(rand(10,100))
					while(src)
						src.icon_state = pick("3","4","5","6")
						sleep(8)
						if(src) animate(src, alpha=0, time=6)
						sleep(6)
						if(src) src.alpha = 200
						src.icon_state = ""
						sleep(rand(6,60))
						if(src)
							src.alpha = 200
		lightning_bolt_space
			icon = 'fx_psi_lightening.dmi'
			layer = 12
			alpha = 255
			pixel_x = -55
			pixel_y = 20
			bolted = 2
			New()
				src.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(56,78,209))
				src.filters += filter(type="bloom", threshold=rgb(0,0,0), size=6, offset=1, alpha=175)

			//	Register_Lightning_Bolt(src) // Register this lightning bolt for global handling
				spawn(rand(10,100))
					while(src)
						src.icon_state = pick("3","4","5","6")
						sleep(8)
						if(src) animate(src, alpha=0, time=6)
						sleep(6)
						if(src) src.alpha = 200
						src.icon_state = ""
						sleep(rand(6,60))
						if(src)
							src.alpha = 200

		/*lightning_bolt_space
			icon = 'fx_psi_lightening.dmi'
			layer = 12
			alpha = 255
			pixel_x = -55
			pixel_y = 20
			bolted = 2
			//plane = -1
			New()
				src.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(253,208,35))
				src.filters += filter(type="bloom", threshold=rgb(0,0,0), size = 6,offset=1,alpha = 175)
				var/matrix/m = matrix()
				var/s = rand(0.1,1)
				m.Scale(s, s)
				m.Turn(rand(0,360))
				src.transform = m
				src.alpha = 200
				spawn(rand(10,100))
					if(src)
						var/list/nearby_planets = list()
						for(var/obj/Planets/Mains/P in world)
							if(get_dist(src, P) <= 99)
								nearby_planets += P
						while(src)
							src.icon_state = pick("3","4","5","6")
							sleep(8)
							if(src) animate(src, alpha = 0, time = 6)
							sleep(6)
							if(src)
								src.loc = locate(rand(1,500),rand(1,500),16)
								var/obj/Planets/Mains/x
								if(x.type in nearby_planets)
									if(x.name == "Namek")
										src.filters = null
										src.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(149,210,174))
										src.filters += filter(type="bloom", threshold=rgb(0,0,0), size = 6, offset=1, alpha = 175)
									if(x.name == "Earth")
										src.filters = null
										src.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(98,236,244))
										src.filters += filter(type="bloom", threshold=rgb(0,0,0), size = 6, offset=1, alpha = 175)
									if(x.name == "Vegeta")
										src.filters = null
										src.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(131,3,62))
										src.filters += filter(type="bloom", threshold=rgb(0,0,0), size = 6, offset=1, alpha = 175)
									if(x.name == "Icer")
										src.filters = null
										src.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(222,251,255))
										src.filters += filter(type="bloom", threshold=rgb(0,0,0), size = 6, offset=1, alpha = 175)
								src.icon_state = ""
								sleep(rand(6,60))
								if(src)
									src.alpha = 200*/


		lightning_bolt_psi
			icon = 'fx_psi_lightening.dmi'
			layer = 12
			alpha = 255
			pixel_x = -55
			pixel_y = 20
			bolted = 2
			//plane = -1
			New()
				src.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(102,0,204))
				src.filters += filter(type="bloom", threshold=rgb(0,0,0), size = 6,offset=1,alpha = 175)
				var/matrix/m = matrix()//*rand(0.1,1)
				var/s = rand(0.1,1)
				m.Scale(s, s)
				m.Turn(rand(0,360))
				src.transform = m
				src.alpha = 200
				spawn(rand(10,100))
					if(src)
						while(src)
							src.icon_state = pick("3","4","5","6")
							sleep(8)
							if(src) animate(src,alpha = 0, time = 6)
							sleep(6)
							if(src)
								src.loc = locate(rand(1,500),rand(1,500),2)
								src.icon_state = ""
								sleep(rand(6,60))
								if(src)
									src.alpha = 200
									//src.transform = initial(src.transform)
		lightning_bolt
			icon = 'fx_lightening.dmi'
			icon_state = "bolt"
			layer = 335
			alpha = 200
			pixel_x = -55
			pixel_y = 20
			New()
				//src.icon_state = "10"
				src.icon_state = pick("6","7","8","9")
				src.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(0,160,230))
				src.filters += filter(type="bloom", threshold=rgb(0,0,0), size = 6,offset=1,alpha = 175)
				spawn(1)
					if(isturf(src.loc))
						var/turf/t = src.loc
						spawn(1.5)
							if(src)
								for(var/atom/movable/a in t)
									if(a != src)
										if(isobj(a))
											var/obj/o = a
											o.shake()
										else if(ismob(a))
											var/mob/m = a
											//m.gain_stat("resistance",1,10,"Lightning")
											m.gain_stat("force",1,2,"Lightning")
								if(t.liquid == null)
									var/obj/effects/dust_medium/d = new
									d.pixel_y-=5
									d.loc = t
									d.SetCenter(src)
									src.shockwave()
								animate(src,alpha = 0, time = 6)
								spawn(7)
									if(src) src.destroy()
		tech

			blade
				icon = 'turbine_blade.dmi'
				icon_state = "blade spin"
				pixel_x = -48
				pixel_y = 21
				layer = 100
			regen_overlay
				icon = 'New regen tank.dmi'
				icon_state = "overlay"
				layer = 5
			bubbles
				icon = 'New regen tank.dmi'
				icon_state = "bubbles"
				layer = 10
			solar_overlay
				icon = 'solar_power.dmi'
				icon_state = "overlay"
				layer = 4.9
				bolted = 2
			battery_overlay
				icon = 'battery.dmi'
				icon_state = "0"
				layer = 40
			flow
				icon = 'power_lines.dmi'
				icon_state = "flow"
				layer = 100
		missing_grass
			icon = 'terrain.dmi'
			icon_state = "missing grass"
			mouse_opacity = 0
			layer = 2
			pixel_y = -10
			New()
				spawn(1)
					animate(src,alpha = 0, time = 2000)
					spawn(1000)
						if(src) src.destroy()
		damage_roof
			icon = 'damage_roof.dmi'
			icon_state = "0"
			layer = 3.3
			New()
				src.icon = pick('damage_roof.dmi','damage_roof2.dmi')
		after_image
			mouse_opacity = 0
			pixel_x = -16
			pixel_y = -8
			step_size = 5
			appearance_flags = KEEP_TOGETHER
			filters = filter(type="motion_blur", x=1, y=0)
			var in_use = 0;
			proc
				enable(var/mob/m)
					src.icon = m.icon
					src.pixel_x = m.pixel_x
					src.pixel_y = m.pixel_y
			New()
				spawn()
					animate(src,alpha = 0, time = 10)
		explosions
			layer = 100
			explosion_medium
				icon = 'fx_explosion_medium.dmi'
				pixel_x = -16
				pixel_y = -16
				New()
					src.transform *= 0.1
					animate(src, transform = matrix()*2,alpha = 0, time = 3)
					spawn(3)
						src.destroy()
		scorch
			icon = 'fx_scorch.dmi'
			layer = 2
			pixel_x = -16
			pixel_y = -16
			//alpha = 200
			mouse_opacity = 0
			New()
				src.icon_state = pick("1","2")
				animate(src, alpha = 0, time = 333)
				spawn(333)
					if(src) src.destroy()//del(src)
		zoom
			appearance_flags = PLANE_MASTER
			screen_loc = "1,1"
		screen_text
			screen_loc = "CENTER-4,CENTER"//"20,14"
			mouse_opacity = 0
			maptext_x = -304
			//maptext_y = 336
			maptext_width = 700
			maptext_height = 111
			maptext = "<font size = 6><center>You have died"
			filters = filter(type="outline", size=1, color=rgb(0,0,0))
			alpha = 0;
			plane = 99
		vision
			icon = 'fx.dmi'
			icon_state = "vision"
			screen_loc = "1,1 to 32,18"
			layer = 500
			alpha = 0
			mouse_opacity = 0
		snow
			icon = 'fx.dmi'
			icon_state = "snow"
			alpha = 100
			layer = 334
		rain
			icon = 'fx.dmi'
			icon_state = "rain2"
			//alpha = 100
			layer = 100
			mouse_opacity = 0
			New()
				src.icon_state = "rain[rand(1,3)]"
		weather
			mouse_opacity = 0
			icon = 'fx.dmi'
			icon_state = "weather"
			layer = 333
		swim
			icon = 'fx_swim.dmi'
			layer = 1000
			blend_mode = BLEND_MULTIPLY
		shadow_ship
			icon = 'ship.dmi'
			alpha = 175
			icon_state = "closed"
			pixel_y = -128
			layer = 99
			New()
				src.icon -= rgb(255,255,255)
		shadow
			icon = 'fx.dmi'
			icon_state = "shadow med"
			mouse_opacity = 0
			bolted = 2
		shadow_small
			icon = 'fx.dmi'
			icon_state = "shadow"
			mouse_opacity = 0
			bolted = 2
			var/atom/movable/attached = null
			New()
				..()
				spawn(7)
					if(src)
						if(src.attached) src.attached.overlays -= src
						//del(src)
						src.destroy()
		shadow_large
			icon = 'fx_shadow_large.dmi'
			icon_state = "large"
			mouse_opacity = 0
			bolted = 2
			pixel_y = -16
			pixel_x = 16
		shadow_tree
			icon = 'fx_shadow_tree.dmi'
			mouse_opacity = 0
			bolted = 2
			pixel_y = -8
			pixel_x = -15
		shield
			icon = 'shield_small.dmi'
			icon_state = "shield large"
			mouse_opacity = 0
			pixel_x = -78
			pixel_y = -64
			layer = 100
			New()
				spawn(10)
					if(src)
						src.transform *= 0.25
						animate(src, transform = matrix()*1, alpha = 0, time = 20,loop = -1)
						animate(transform = matrix()*0.25, alpha = 255, time = 0)
			/*
			New()
				..()
				spawn(40)
					if(src) del(src)
			*/
		shockwave_inverse
			icon = 'shockwave_inverse.dmi'
			mouse_opacity = 0
			bounds = "81,82 to 112,113"
			layer = 100
		shockwave_medium
			icon = 'shockwave.dmi'
			mouse_opacity = 0
			bounds = "81,82 to 112,113"
			layer = 100

		shockwave_lvl
			icon = 'shockwave_lvl.dmi'
			mouse_opacity = 0
			bounds = "81,82 to 112,113"
			layer = 100
		ripple_water
			icon = 'fx_ripple.dmi'
			mouse_opacity = 0
			bounds = "81,82 to 112,113"
			layer = 2
			plane = -1
		progress_bar
			icon = 'bars_progress.dmi'
			icon_state = "0"
			layer = 110
		misc
			help_overlay
				icon = 'question_mark.dmi'
				icon_state = "over"
			trait_overlay
				icon = 'traits.dmi'
				icon_state = "locked in"
			trait_select
				icon = 'traits.dmi'
				icon_state = "select"
		craters
			shakes = 0
			crater2_small
				icon = 'CraterStage2 (1).dmi'
				bolted = 2
				layer = TURF_LAYER+0.2
				pixel_x = -16
				pixel_y = -16
				bounds = "9,9 to 40,40"
				appearance_flags = TILE_BOUND
				New()
					..()
					var/map_spawned = 0
					if(isturf(src.loc)) map_spawned = 1
					if(istype(src.loc,/turf/grass))
						src.icon = 'CraterStage2 (1).dmi'
					for(var/obj/items/plants/p in range(1,src))
						if(bounds_dist(p,src) < 0) p.destroy() //del(p)
					spawn(600)
						if(src && map_spawned == 0)
							animate(src,alpha = 0, time = 10)
							spawn(10)
								if(src) src.destroy()
				Del()
					animate(src, alpha = 0, time = 20) // Crater fade-in effect
					..()
			crater2_big
				icon = 'CraterStage3.dmi'
				bolted = 2
				layer = TURF_LAYER+0.2
				pixel_x = -16
				pixel_y = -32
				bounds = "9,9 to 40,40"
				appearance_flags = TILE_BOUND
				New()
					..()
					var/map_spawned = 0
					if(isturf(src.loc)) map_spawned = 1
					if(istype(src.loc,/turf/grass))
						src.icon = 'CraterStage3.dmi'
					for(var/obj/items/plants/p in range(1,src))
						if(bounds_dist(p,src) < 0) p.destroy() //del(p)
					spawn(600)
						if(src && map_spawned == 0)
							animate(src,alpha = 0, time = 10)
							spawn(10)
								if(src) src.destroy()
			crater_small
				icon = 'fx_crater_small_dirt.dmi'
				bolted = 2
				layer = TURF_LAYER+0.2
				//pixel_x = -4
				//pixel_y = -12
				bounds = "9,9 to 40,40"
				appearance_flags = TILE_BOUND
				New()
					..()
					var/map_spawned = 0
					if(isturf(src.loc)) map_spawned = 1
					if(istype(src.loc,/turf/grass))
						src.icon = 'fx_crater_small.dmi'
					else if(istype(src.loc,/turf/lava_cooled) || istype(src.loc,/turf/lava_cooling)) src.icon = 'fx_crater_small_ash.dmi'
					for(var/obj/items/plants/p in range(1,src))
						if(bounds_dist(p,src) < 0) p.destroy() //del(p)
					spawn(600)
						if(src && map_spawned == 0)
							animate(src,alpha = 0, time = 10)
							spawn(10)
								if(src) src.destroy()
			crater_medium
				icon = 'fx_crater_medium_dirt.dmi'
				bolted = 2
				pixel_x = -48
				pixel_y = -58
				bounds = "-47,-57 to 112,102"
				layer = TURF_LAYER+0.2
				appearance_flags = TILE_BOUND
				New()
					..()
					var/map_spawned = 0
					if(isturf(src.loc)) map_spawned = 1
					if(istype(src.loc,/turf/grass))
						src.icon = 'fx_crater_medium.dmi'
					for(var/obj/items/plants/p in range(5,src))
						if(bounds_dist(p,src) < 0) p.destroy()//del(p)
					for(var/obj/effects/craters/c in range(5,src))
						if(c != src) if(bounds_dist(c,src) < -64) c.destroy()//del(c)
					spawn(600)
						if(src && map_spawned == 0)
							animate(src,alpha = 0, time = 10)
							spawn(10)
								if(src) src.destroy()
		exalted_rays
			icon = 'fx_ray_large.dmi'
			pixel_x = -284
			pixel_y = -285
			bolted = 2
			alpha = 155
			appearance_flags = KEEP_APART
			New()
				src.filters += filter(type="rays",x=0,y=0,size=300,color=rgb(255,255,255),offset=0,density=15,threshold=0.5,factor=0,flags=FILTER_OVERLAY)
				animate(src.filters[1],offset = 100,time = 4000, loop = -1)
				animate(offset = 0,time = 0)
		profusion_underlay
			icon = 'profusion_underlay.dmi'
			layer = 3
		profusion_overlay
			icon = 'profusion_overlay.dmi'
			layer = 6
		ground
			icon = 'ground_damage.dmi'
			icon_state = "middle"
			pixel_y = -42
			icon_state = "end left"
		particle
			icon = 'fx_particles.dmi'
			plane=22
			New()
				src.icon_state = "[pick(1,2,3,4)]"
		furrow
			icon = 'fx_furrow_grass_large.dmi'
			mouse_opacity = 0
			layer = 2.1
			pixel_x = -16
			pixel_y = -16

			appearance_flags = TILE_BOUND
		shockwave_smaller
			icon = 'shockwave_smaller.dmi'
			layer = 105
			alpha = 100
			New()
				src.pixel_x = rand(-10,10)
				src.pixel_y = rand(-10,10)
				animate(src,alpha = 0, time = 6)
				spawn(3.6) src.loc=null
		shockwave_small
			icon = 'shockwave_small.dmi'
			layer = 105
			pixel_x = -16
			pixel_y = -16
			plane=22
			mouse_opacity = 0
			New()
				src.pixel_x = rand(-10,10)
				src.pixel_y = rand(-10,10)
				animate(src, transform = matrix()*2, alpha = 100, time = 6)
				spawn(3.6) src.loc=null
		plume_ground
			icon = 'fx_dust_plume.dmi'
			layer = 3.1
			plane=22
			mouse_opacity = 0
			bounds = "3,26 to 31,60"
			//pixel_y = -10
		hit
			icon = 'fx_hit.dmi'
			layer = 100
			alpha = 175
			pixel_x = -44
			mouse_opacity = 0
			pixel_y = -24
			plane=29
			New()
				spawn(4)
					if(src) src.destroy()
		speed_shockwave
			icon = 'fx_speed_shockwave.dmi'
			layer = 100
			alpha = 175
			pixel_x = -44
			mouse_opacity = 0
			pixel_y = -24
			bolted = 2
			immune_dmg = 1
		disturb_air
			icon = 'fx_disturb_air.dmi'
			layer = 100
			alpha = 175
			pixel_x = -44
			mouse_opacity = 0
			pixel_y = -24
		dust_explosive
			icon = 'fx_dust_explosive.dmi'
			icon_state = "1"
			alpha = 200
			layer = 200
			layer = 3
			mouse_opacity = 0
			bounds = "1,1 to 32,32"
			pixel_x = -20
			pixel_y = -10
			New()
				src.icon_state = "[pick(1,2,3,4,5,6,7,8)]"
				//src.pixel_x = rand(-10,10)
		dust
			icon = 'fx_dust_dirt.dmi'
			icon_state = "1"
			alpha = 200
			//layer = 200
			plane = 7
			mouse_opacity = 0
			bounds = "1,1 to 32,32"
			pixel_x = -20
			pixel_y = -16
			invisibility = 1
			var/trans_x
			var/trans_y
			var/deg
			var/og_layer
			proc
				strip_grass()
					spawn(0.1)
						while(src.loc)
							var/obj/d = new
							d.icon = 'fx_furrow_grass.dmi'
							d.loc = src.loc
							d.step_x = src.step_x
							d.step_y = src.step_y
							sleep(0.5)
			New()
				src.icon_state = "[pick(1,2,3,4,5,6,7,8)]"
				//src.pixel_x = rand(-10,10)
		dust_rock_medium
			icon = 'fx_dust_medium.dmi'
			layer = 2.1
			pixel_x = -47
			pixel_y = -53
			alpha = 200
			mouse_opacity = 0
			appearance_flags = TILE_BOUND
			New()
				//animate(src, alpha = 200, time = 5)
				spawn(5)
					if(src) src.loc=null
		dust_medium
			icon = 'fx_dust_medium_dirt.dmi'
			layer = 2.1
			//pixel_x = -48
			//pixel_y = -50
			bounds = "48,49 to 79,80"
			alpha = 200
			mouse_opacity = 0
			appearance_flags = TILE_BOUND
			New()
				spawn(0.1)
					var/turf/t = src.loc
					if(istype(t,/turf/snows/))
						src.icon = 'fx_dust_medium.dmi'
					else if(istype(t,/turf/lava_cooled/) || istype(t,/turf/lava_cooling/))
						src.icon = 'fx_ash_medium.dmi'
					if(istype(t,/turf/water/))
						src.destroy()
						return
				spawn(5)
					if(src) src.destroy() //del(src)
		explosion_fire_small
			icon = 'fx.dmi'
			icon_state = "explosion"
			layer = 100
			alpha = 200
			plane=22
			mouse_opacity = 0
			New()
				spawn(1)
					if(src) if(prob(75)) src.shockwave()
					spawn(4)
						if(src) src.destroy()
		fire
			icon = 'fx_medium.dmi'
			icon_state = "fire"
			layer = 100
			alpha = 200
			pixel_x = -32
			pixel_y = -32
			plane=29
			New()
				src.icon_state = "fire[pick(1,2,3,4)]"
				spawn(33)
					if(src) src.destroy()
		afk
			appearance_flags = KEEP_APART
			icon = 'afk.dmi'
			layer = 20
			plane=22
		bluntenergy_fistL
			icon = 'energyFistL.dmi'
			layer=20

		bluntenergy_fistR
			icon = 'energyFistR.dmi'
			layer=20

		sharpenergy_fistL
			icon = 'energySwordL.dmi'
			alpha=255
			layer=20
			plane=3

		sharpenergy_fistR
			icon = 'energySwordR.dmi'
			alpha=255
			layer=20
			plane=3
		aura_kaioken
			icon = 'KaiokenSov.dmi'
			plane=22
			layer = 20
			appearance_flags = KEEP_APART
			pixel_x=-16
			pixel_y=-4
		elec_mystic
			icon = 'Electric_Mystic.dmi'
			layer = 20
			appearance_flags = KEEP_APART
		elec_majin
			icon = 'Electric_Majin.dmi'
			layer = 20
			appearance_flags = KEEP_APART
		energy_shield
			icon = 'energy_shield.dmi'
			layer = 20
			appearance_flags = KEEP_APART
		elec_cerebroid
			icon = 'blue elec.dmi'
			pixel_x = 16
			pixel_y = 12
			layer = 20
			appearance_flags = KEEP_APART
		elec
			icon = 'blue elec.dmi'
			//pixel_x = 16
			//pixel_y = 12
			layer = 20
			appearance_flags = KEEP_APART
		elec_green
			icon = 'green elec.dmi'
			//pixel_x = 16
			//pixel_y = 12
			layer = 20
		select_item
			icon = 'fx.dmi'
			icon_state = "select item"
			plane = 22
			layer = 35
			appearance_flags = KEEP_APART
			//vis_flags = VIS_INHERIT_ID | VIS_INHERIT_LAYER | VIS_INHERIT_PLANE | VIS_UNDERLAY
		tk
			icon = 'fx.dmi'
			icon_state = "tk"
		superfly
			icon = 'superfly.dmi'
			layer = 200
			alpha = 200
			pixel_y = -32
			pixel_x = -68
			mouse_opacity = 0
	enviornment
		Containment_Jar
			icon = 'Jar_Seal.dmi'
			icon_state = ""
			desc = "A mystical jar said to imprison evil souls within it."
			can_pocket = 0
			can_activate = 1
			var/o_color = "#aa0000"
			var/list/captured_players = list() // stores ckeys or names of sealed players
			MouseEntered(location,control,params)
				usr.mouse_over = src
				if(usr.hud_info) usr.hud_info.maptext = "<span style='-dm-text-outline: 1px #000000;text-align:right'>[src]</span>"
				if(src.stack_display == null) src.create_stack_display()
				if(src.stacks > 1 && src.stack_exempt == 0) usr.client.images += src.stack_display
				if(usr.toggled_info)
					if(istype(src,/obj/items/tech/))
						usr.show_info_tech(src)

				var/proceed = 1
				if(src.bolted && usr.trait_hm == null) proceed = 0
				if(src.bolted > 1) proceed = 0
				if(proceed) if(src.loc) if(!usr.left_click_function) usr.client.mouse_pointer_icon = 'mouse_grab.dmi'
				if(src.can_pocket || src.can_activate)
					if(!usr.left_click_function) usr.client.mouse_pointer_icon = 'mouse_interact.dmi'
					if(src.over == null)
						var/image/sel = image(src.icon,src)
						//sel.appearance = src.appearance
						//sel.override = 1
						//sel.mouse_opacity = 0
						sel.loc = src
						//sel.mouse_opacity = 0
						src.over = sel
						src.over.filters = filter(type="outline", size=1, color=src.o_color)
					if(ismob(src.loc) == 0 && isobj(src.loc) == 0)
						usr.client.images += src.over
						while(usr && usr.mouse_over && usr.mouse_over == src && src.over)
							//src.over.appearance = src.appearance
							src.over.icon = src.icon
							src.over.icon_state = src.icon_state
							//src.over.pixel_x = src.pixel_x
							//src.over.pixel_y = src.pixel_y
							src.over.overlays = src.overlays
							src.over.underlays = src.underlays
							//src.over.override = 1
							if(src.grabbed_by || src.tk) src.over.pixel_z = src.pixel_z-16
							//src.over.transform = src.transform
							src.over.dir = src.dir
							sleep(0.1)
					else if(length(src.filters) <= 0) src.filters += filter(type="outline", size=1, color=src.o_color)
			MouseExited(location,control,params)
				if(!isturf(src.loc))
					if(length(src.filters) <= 1) src.filters -= filter(type="outline", size=1, color=src.o_color)
				else usr.client.images -= src.stack_display
				if(usr.mouse_txt) usr.client.screen -= usr.mouse_txt // For the name box that appears for items.
				usr.mouse_txt_confirm = null // For the name box that appears for items.
				usr.mouse_txt_over = null // For the name box that appears for items.
				usr.client.images -= src.over
				usr.mouse_over = null
				if(!usr.left_click_function) usr.client.mouse_pointer_icon = 'mouse.dmi'

				if(usr.hud_namebar)
					usr.hud_namebar.loc = null
					usr.hud_info.loc = null
					/*
					var/obj/h = usr.hud_namebar
					h.loc = src.loc
					h.step_x = src.step_x
					h.step_y = src.step_y

					h.txt_i.maptext = "[src.name]"
					usr.client.images += h.txt_i
					*/

			Click(location, control, params)
				..()
				if(ismob(loc)) return // Don't activate from inventory
				if(length(captured_players) <= 0)
					usr << "The jar resonates with silence. No soul stirs inside."
					return

				var/list/online_matches = list()
				for(var/mob/M in players)
					if(M.ckey in captured_players || M.name in captured_players)
						if(M.online) online_matches += M

				if(online_matches.len <= 0)
					usr << "Nobody is currently awake in this realm."
					return

				var/energy_required = usr.energy_max * 0.60
				if(usr.energy < energy_required)
					usr << "<font color=red>You lack the energy required to break the seal."
					return

				var/mob/choice = input(usr, "Which imprisoned person do you wish to release?", "Choose soul", null) as null|anything in online_matches
				if(choice)
					usr.energy -= energy_required
					captured_players -= choice.ckey
					choice.loc = get_step(usr, usr.dir)
					usr << "<font color=limegreen>You channel your energy and shatter the seal!"
					choice << "<font color=yellow>Your soul is released from the Evil Containment Jar by [usr.name]!"
				// Add visuals, sounds, or particles here
		Campfire
			icon='Campfire.dmi'
			icon_state="Lit"
			change_icon = 0
			can_pocket = 0
			can_activate = 1
			stacks = -1
			var/is_cooking=0
			var/o_color = "#ffffff"
			desc = "Cook or roast yourself!"

			proc


				drop(var/mob/m,var/obj/items/i)
					m.drop(i)
			New()
				..()
				spawn(2500)
					if(src) src.destroy()
						//del(src)
			MouseEntered(location,control,params)
				usr.mouse_over = src
				if(usr.hud_info) usr.hud_info.maptext = "<span style='-dm-text-outline: 1px #000000;text-align:right'>[src]</span>"
				if(src.stack_display == null) src.create_stack_display()
				if(src.stacks > 1 && src.stack_exempt == 0) usr.client.images += src.stack_display
				if(usr.toggled_info)
					if(istype(src,/obj/items/tech/))
						usr.show_info_tech(src)

				var/proceed = 1
				if(src.bolted && usr.trait_hm == null) proceed = 0
				if(src.bolted > 1) proceed = 0
				if(proceed) if(src.loc) if(!usr.left_click_function) usr.client.mouse_pointer_icon = 'mouse_grab.dmi'
				if(src.can_pocket || src.can_activate)
					if(!usr.left_click_function) usr.client.mouse_pointer_icon = 'mouse_interact.dmi'
					if(src.over == null)
						var/image/sel = image(src.icon,src)
						//sel.appearance = src.appearance
						//sel.override = 1
						//sel.mouse_opacity = 0
						sel.loc = src
						//sel.mouse_opacity = 0
						src.over = sel
						src.over.filters = filter(type="outline", size=1, color=src.o_color)
					if(ismob(src.loc) == 0 && isobj(src.loc) == 0)
						usr.client.images += src.over
						while(usr && usr.mouse_over && usr.mouse_over == src && src.over)
							//src.over.appearance = src.appearance
							src.over.icon = src.icon
							src.over.icon_state = src.icon_state
							//src.over.pixel_x = src.pixel_x
							//src.over.pixel_y = src.pixel_y
							src.over.overlays = src.overlays
							src.over.underlays = src.underlays
							//src.over.override = 1
							if(src.grabbed_by || src.tk) src.over.pixel_z = src.pixel_z-16
							//src.over.transform = src.transform
							src.over.dir = src.dir
							sleep(0.1)
					else if(length(src.filters) <= 0) src.filters += filter(type="outline", size=1, color=src.o_color)
			MouseExited(location,control,params)
				if(!isturf(src.loc))
					if(length(src.filters) <= 1) src.filters -= filter(type="outline", size=1, color=src.o_color)
				else usr.client.images -= src.stack_display
				if(usr.mouse_txt) usr.client.screen -= usr.mouse_txt // For the name box that appears for items.
				usr.mouse_txt_confirm = null // For the name box that appears for items.
				usr.mouse_txt_over = null // For the name box that appears for items.
				usr.client.images -= src.over
				usr.mouse_over = null
				if(!usr.left_click_function) usr.client.mouse_pointer_icon = 'mouse.dmi'

				if(usr.hud_namebar)
					usr.hud_namebar.loc = null
					usr.hud_info.loc = null
					/*
					var/obj/h = usr.hud_namebar
					h.loc = src.loc
					h.step_x = src.step_x
					h.step_y = src.step_y

					h.txt_i.maptext = "[src.name]"
					usr.client.images += h.txt_i
					*/

			Click(location,control,params)
				..()
				//Removes this item from the global Items list.

	items
		var/o_color = "#ffffff"
		var
			psi_gain = 0
			eng_gain = 0
			str_gain = 0
			end_gain = 0
			spd_gain = 0
			res_gain = 0
			force_gain = 0
			off_gain = 0
			def_gain = 0
			regen_gain = 0
			recov_gain = 0
			int_gain = 0
			lifespan_gain = 0
			rads_gain = 0
			cold_gain = 0
			heat_gain = 0
			toxin_gain = 0
			gravity_gain = 0
			divine_eng_gain = 0
			dark_matter_gain = 0
			divine_mod_gain = 0
			dark_matter_mod_gain = 0
			o2_gain = 0
			eng_mod_gain = 0
			psi_mod_gain = 0
			metab_gain = 0
			hydro_gain = 0
			tiredness_gain = 0
			lvl_rand_part = 0 // Whether this item lvls random parts or not
			lvl_rand_num = 0 //How many times this item lvls up a rand part
			list/lvl_parts = null //List of parts to lvl
			lvl_parts_num = 0 //How many levels to give the parts in lvl_parts list

			psi_gain_temp = 0
			eng_gain_temp = 0
			str_gain_temp = 0
			end_gain_temp = 0
			spd_gain_temp = 0
			res_gain_temp = 0
			force_gain_temp = 0
			off_gain_temp = 0
			def_gain_temp = 0
			regen_gain_temp = 0
			recov_gain_temp = 0
			int_gain_temp = 0
			rads_gain_temp = 0
			cold_gain_temp = 0
			heat_gain_temp = 0
			toxin_gain_temp = 0
			gravity_gain_temp = 0
			divine_mod_gain_temp = 0
			dark_matter_mod_gain_temp = 0
			eng_mod_gain_temp = 0
			psi_mod_gain_temp = 0
			metab_gain_temp = 0
			hydro_gain_temp = 0
			tiredness_gain_temp = 0

			psi_loss_temp = 0
			eng_loss_temp = 0
			str_loss_temp = 0
			end_loss_temp = 0
			spd_loss_temp = 0
			res_loss_temp = 0
			force_loss_temp = 0
			off_loss_temp = 0
			def_loss_temp = 0
			regen_loss_temp = 0
			recov_loss_temp = 0
			int_loss_temp = 0
			rads_loss_temp = 0
			cold_loss_temp = 0
			heat_loss_temp = 0
			toxin_loss_temp = 0
			gravity_loss_temp = 0
			divine_mod_loss_temp = 0
			dark_matter_mod_loss_temp = 0
			eng_mod_loss_temp = 0
			psi_mod_loss_temp = 0
			metab_loss_temp = 0
			hydro_loss_temp = 0
			tiredness_loss_temp = 0

			time_eaten = 0
			extra_info = null
			duration = 0
			comedown_duration = 0
			comedown = 1
			toxic = 0

			has_subtech = 0
			is_subtech = 0


		vis_flags = VIS_INHERIT_PLANE | VIS_INHERIT_LAYER
		//vis_flags = VIS_INHERIT_PLANE
		/*
		"#ffffff" = White - common
		"#1eff00" = Green - Uncommon
		"#0070dd" = Blue - Rare
		"#a335ee" = Purple - Epic
		"#ff8000" = Orange - legendary
		*/
		//hasreflect = 0
		proc



					//if(src.lvl_rand_part)
					//	while(src.lvl_rand_num)
					//		src.lvl_rand_num -= 1
					//		m.lvl_rand_bodypart()

				//	if(src.lvl_parts != null)
				//
			apply_item_stats(var/mob/m,var/ID,var/skip_sleep = 0,var/skip_eat = 0)
				var/multi = 1
				if(skip_eat == 0 && m.eating) return
				m.eating = src
				src.time_eaten = ID
				//world << "DEBUG - Time trying to consume = [world.time]"
				if(istype(src,/obj/items/consumables/) == 1 || istype(src,/obj/items/drugs/) == 1) m.eat()
				if(skip_sleep == 0) sleep(global.eat_time)
				if(src && m && m.eating == src && src.loc == m && src.stacks > 0 && src.time_eaten == ID || src && m && m.eating == src && src.loc == m && istype(src,/obj/items/consumables/food/special/) && src.time_eaten == ID)
					m.icon_state = m.state()
					if(m.hud_eat)
						m.vis_contents -= m.hud_eat
						m.stunned -= 1
						m.stunned_pending -= 1
					if(src.toxic)
						if(m.toxicity >= 85)
							multi = 2
							m.lifespan -= abs(src.lifespan_gain)
							m.set_decline()
						else if(src.lifespan_gain != 0)
							m.lifespan += src.lifespan_gain*multi
							//m.check_quest("tutorial_lifespan",1)
							m.set_decline()
					else if(src.lifespan_gain != 0)
						m.lifespan += src.lifespan_gain*multi
						//m.check_quest("tutorial_lifespan",1)
						m.set_decline()
					//if(src.lvl_rand_part)
					//	while(src.lvl_rand_num)
					//		src.lvl_rand_num -= 1
					//		m.lvl_rand_bodypart()
					view(15,m)<<output("[m] consumes a [src].","actionoutput")
					if(src.active) src.active = 0
				//	if(src.lvl_parts != null)
				//		m.lvl_typesof_bodypart(src.lvl_parts,src.lvl_parts_num*100,0,0,1)
					if(src.cooked==0)
						if(src.toxicity != 0) m.toxicity += src.toxicity*multi
						if(src.psi_mod_gain != 0)
							m.gains_items_power_mod += src.psi_mod_gain
						//	m.mod_psionic_power += src.psi_mod_gain
						if(src.psi_gain != 0)
							m.gains_items_power += src.psi_gain*multi
						if(src.eng_mod_gain != 0)
							m.gains_items_energy_mod += src.eng_mod_gain
						//	m.mod_energy += src.eng_mod_gain
						if(src.eng_gain != 0)
							m.gains_items_energy += src.eng_gain*multi
						if(src.divine_eng_gain != 0)
							m.divine_energy += (src.divine_eng_gain*m.divine_energy_mod)*multi

						if(src.dark_matter_gain != 0)
							m.dark_matter += (src.dark_matter_gain*m.dark_matter_mod)*multi

						if(src.str_gain != 0)
							m.gains_items_strength += src.str_gain*multi
							//m.strength += (src.str_gain*m.mod_strength)*multi
						if(src.spd_gain != 0)
							m.gains_items_agility_mod += src.spd_gain*multi
							//m.mod_agility += src.spd_gain*multi
						if(src.end_gain != 0)
							m.gains_items_endurance += src.end_gain*multi
							//m.endurance += (src.end_gain*m.mod_endurance)*multi
						if(src.res_gain != 0)
							m.gains_items_resistance += src.res_gain*multi
							//m.resistance += (src.res_gain*m.mod_resistance)*multi
						if(src.force_gain != 0)
							m.gains_items_force += src.force_gain*multi
							//m.force += (src.force_gain*m.mod_force)*multi
						if(src.off_gain != 0)
							m.gains_items_off += src.off_gain*multi
							//m.offence += (src.off_gain*m.mod_offence)*multi
						if(src.def_gain != 0)
							m.gains_items_def += src.def_gain*multi
							//m.defence += (src.def_gain*m.mod_defence)*multi
						if(src.regen_gain != 0)
							m.gains_items_regen_mod += src.regen_gain*multi
							//m.mod_regeneration += src.regen_gain*multi
						if(src.recov_gain != 0)
							m.gains_items_recov_mod += src.recov_gain*multi
							//m.mod_recovery += src.recov_gain*multi
						if(src.rads_gain != 0)
						//	m.mod_immune_rads += src.rads_gain*multi
							m.immune_rads_items += src.rads_gain*multi
						if(src.cold_gain != 0)
							//m.mod_immune_cold += src.cold_gain*multi
							m.immune_cold_items += src.cold_gain*multi
						if(src.heat_gain != 0)
						//	m.mod_immune_heat += src.heat_gain*multi
							m.immune_heat_items += src.heat_gain*multi
						if(src.gravity_gain != 0)
							m.mod_immune_gravity += src.gravity_gain*multi
							m.immune_gravity_items += src.gravity_gain*multi
						if(src.toxin_gain != 0)
							//m.mod_immune_toxins += src.toxin_gain
							m.immune_toxins_items += src.toxin_gain
						if(src.divine_mod_gain != 0) m.divine_energy_mod += src.divine_mod_gain*multi
						if(src.dark_matter_mod_gain != 0) m.dark_matter_mod += src.dark_matter_mod_gain*multi
						if(src.o2_gain != 0)
							m.o2_max += src.o2_gain*multi
							m.gains_items_o2 += src.o2_gain*multi
						if(src.metab_gain != 0)
							m.hunger += src.metab_gain*multi
						//	m.check_quest("tutorial_eat",1)
						if(src.hydro_gain != 0)
							m.thirst += src.hydro_gain*multi
						//	m.check_quest("tutorial_drink",1)
					//	if(src.tiredness_gain != 0)
						//	m.restedness += src.tiredness_gain*multi
					else if(src.cooked==1)
						if(src.psi_mod_gain != 0)
							m.gains_items_power_mod += src.psi_mod_gain
						//	m.mod_psionic_power += src.psi_mod_gain
						if(src.psi_gain != 0)
							m.gains_items_power += src.psi_gain*multi
						if(src.eng_mod_gain != 0)
							m.gains_items_energy_mod += src.eng_mod_gain
							//m.mod_energy += src.eng_mod_gain
						if(src.eng_gain != 0)
							m.gains_items_energy += src.eng_gain*multi
						if(src.divine_eng_gain != 0)
							m.divine_energy += (src.divine_eng_gain*m.divine_energy_mod)*multi

						if(src.dark_matter_gain != 0)
							m.dark_matter += (src.dark_matter_gain*m.dark_matter_mod)*multi

						if(src.str_gain != 0)
							m.gains_items_strength += src.str_gain*multi
							//m.strength += (src.str_gain*m.mod_strength)*multi
						if(src.spd_gain != 0)
							m.gains_items_agility_mod += src.spd_gain*multi
						//	m.mod_agility += src.spd_gain*multi
						if(src.end_gain != 0)
							m.gains_items_endurance += src.end_gain*multi
							//m.endurance += (src.end_gain*m.mod_endurance)*multi
						if(src.res_gain != 0)
							m.gains_items_resistance += src.res_gain*multi
							//m.resistance += (src.res_gain*m.mod_resistance)*multi
						if(src.force_gain != 0)
							m.gains_items_force += src.force_gain*multi
						//	m.force += (src.force_gain*m.mod_force)*multi
						if(src.off_gain != 0)
							m.gains_items_off += src.off_gain*multi
						//	m.offence += (src.off_gain*m.mod_offence)*multi
						if(src.def_gain != 0)
							m.gains_items_def += src.def_gain*multi
						//	m.defence += (src.def_gain*m.mod_defence)*multi
						if(src.regen_gain != 0)
							m.gains_items_regen_mod += src.regen_gain*multi
						//	m.mod_regeneration += src.regen_gain*multi
						if(src.recov_gain != 0)
							m.gains_items_recov_mod += src.recov_gain*multi
						//	m.mod_recovery += src.recov_gain*multi
						if(src.rads_gain != 0)
							//m.mod_immune_rads += src.rads_gain*multi
							m.immune_rads_items += src.rads_gain*multi
						if(src.cold_gain != 0)
							//m.mod_immune_cold += src.cold_gain*multi
							m.immune_cold_items += src.cold_gain*multi
						if(src.heat_gain != 0)
							//m.mod_immune_heat += src.heat_gain*multi
							m.immune_heat_items += src.heat_gain*multi
						if(src.gravity_gain != 0)
							m.mod_immune_gravity += src.gravity_gain*multi
							m.immune_gravity_items += src.gravity_gain*multi
						if(src.toxin_gain != 0)
							//m.mod_immune_toxins += src.toxin_gain
							m.immune_toxins_items += src.toxin_gain
						if(src.divine_mod_gain != 0) m.divine_energy_mod += src.divine_mod_gain*multi
						if(src.dark_matter_mod_gain != 0) m.dark_matter_mod += src.dark_matter_mod_gain*multi
						if(src.o2_gain != 0)
							m.o2_max += src.o2_gain*multi
							m.gains_items_o2 += src.o2_gain*multi
						if(src.metab_gain != 0)
							m.hunger += src.metab_gain*multi
						//	m.check_quest("tutorial_eat",1)
						if(src.hydro_gain != 0)
							m.thirst += src.hydro_gain*multi
							//m.check_quest("tutorial_drink",1)
					//	if(src.tiredness_gain != 0)
						//	m.restedness += src.tiredness_gain*multi







			create_item_desc()
				var/txt = "Permanent Effects: "
				var/txt_c = null
				var/txt_green = "<font color = green>+"
				var/txt_red = "<font color = red>"
				if(src.psi_mod_gain != 0)
					if(src.psi_mod_gain > 0) txt_c = txt_green
					else txt_c = txt_red
					txt = "[txt]\n[txt_c][src.psi_mod_gain] Power Mod</font>"
				if(src.psi_gain != 0)
					if(src.psi_gain > 0) txt_c = txt_green
					else txt_c = txt_red
					txt = "[txt]\n[txt_c][src.psi_gain] Power</font>"
				if(src.eng_mod_gain != 0)
					if(src.eng_mod_gain > 0) txt_c = txt_green
					else txt_c = txt_red
					txt = "[txt]\n[txt_c][src.eng_mod_gain] Energy Mod</font>"
				if(src.eng_gain != 0)
					if(src.eng_gain > 0) txt_c = txt_green
					else txt_c = txt_red
					txt = "[txt]\n[txt_c][src.eng_gain] Max Energy</font>"
				if(src.str_gain != 0)
					if(src.str_gain > 0) txt_c = txt_green
					else txt_c = txt_red
					txt = "[txt]\n[txt_c][src.str_gain] Strength</font>"
				if(src.spd_gain != 0)
					if(src.spd_gain > 0) txt_c = txt_green
					else txt_c = txt_red
					txt = "[txt]\n[txt_c][src.spd_gain] Agility Mod</font>"
				if(src.end_gain != 0)
					if(src.end_gain > 0) txt_c = txt_green
					else txt_c = txt_red
					txt = "[txt]\n[txt_c][src.end_gain] Endurance</font>"
				if(src.res_gain != 0)
					if(src.res_gain > 0) txt_c = txt_green
					else txt_c = txt_red
					txt = "[txt]\n[txt_c][src.res_gain] Resistance</font>"
				if(src.force_gain != 0)
					if(src.force_gain > 0) txt_c = txt_green
					else txt_c = txt_red
					txt = "[txt]\n[txt_c][src.force_gain] Force</font>"
				if(src.off_gain != 0)
					if(src.off_gain > 0) txt_c = txt_green
					else txt_c = txt_red
					txt = "[txt]\n[txt_c][src.off_gain] Offence</font>"
				if(src.def_gain != 0)
					if(src.def_gain > 0) txt_c = txt_green
					else txt_c = txt_red
					txt = "[txt]\n[txt_c][src.def_gain] Defence</font>"
				if(src.regen_gain != 0)
					if(src.regen_gain > 0) txt_c = txt_green
					else txt_c = txt_red
					txt = "[txt]\n[txt_c][src.regen_gain] Regeneration Mod</font>"
				if(src.recov_gain != 0)
					if(src.recov_gain > 0) txt_c = txt_green
					else txt_c = txt_red
					txt = "[txt]\n[txt_c][src.recov_gain] Recovery Mod</font>"
				if(src.rads_gain != 0)
					if(src.rads_gain > 0) txt_c = txt_green
					else txt_c = txt_red
					txt = "[txt]\n[txt_c][src.rads_gain] Radiation Tolerance</font>"
				if(src.cold_gain != 0)
					if(src.cold_gain > 0) txt_c = txt_green
					else txt_c = txt_red
					txt = "[txt]\n[txt_c][src.cold_gain] Cold Tolerance</font>"
				if(src.heat_gain != 0)
					if(src.heat_gain > 0) txt_c = txt_green
					else txt_c = txt_red
					txt = "[txt]\n[txt_c][src.heat_gain] Heat Tolerance</font>"
				if(src.gravity_gain != 0)
					if(src.gravity_gain > 0) txt_c = txt_green
					else txt_c = txt_red
					txt = "[txt]\n[txt_c][src.gravity_gain] Gravity Tolerance</font>"
				if(src.toxin_gain != 0)
					if(src.toxin_gain > 0) txt_c = txt_green
					else txt_c = txt_red
					txt = "[txt]\n[txt_c][src.toxin_gain] Toxin Tolerance</font>"
				if(src.divine_mod_gain != 0)
					if(src.divine_mod_gain > 0) txt_c = txt_green
					else txt_c = txt_red
					txt = "[txt]\n[txt_c][src.divine_mod_gain] Divine Energy Mod</font>"
				if(src.dark_matter_mod_gain != 0)
					if(src.dark_matter_mod_gain > 0) txt_c = txt_green
					else txt_c = txt_red
					txt = "[txt]\n[txt_c][src.dark_matter_mod_gain] Dark Matter Mod</font>"
				if(src.lifespan_gain != 0)
					if(src.lifespan_gain > 0) txt_c = txt_green
					else txt_c = txt_red
					txt = "[txt]\n[txt_c][src.lifespan_gain] Lifespan</font>"
				if(src.metab_gain != 0)
					if(src.metab_gain > 0) txt_c = "<font color = green>+"
					else txt_c = "<font color = red>"
					txt = "[txt]\n[txt_c][src.metab_gain]% Satiation</font>"
				if(src.hydro_gain != 0)
					if(src.hydro_gain > 0) txt_c = "<font color = green>+"
					else txt_c = "<font color = red>"
					txt = "[txt]\n[txt_c][src.hydro_gain]% Hydration</font>"
				if(src.tiredness_gain != 0)
					if(src.tiredness_gain > 0) txt_c = "<font color = green>+"
					else txt_c = "<font color = red>"
					txt = "[txt]\n[txt_c][src.tiredness_gain]% Restedness</font>"

				txt = "[txt]\n\nTemporarily Effects: "
				if(src.psi_mod_gain_temp != 0)
					if(src.psi_mod_gain_temp > 0) txt_c = txt_green
					else txt_c = txt_red
					txt = "[txt]\n[txt_c][src.psi_mod_gain_temp] Power Mod</font>"
				if(src.psi_gain_temp != 0)
					if(src.psi_gain_temp > 0) txt_c = txt_green
					else txt_c = txt_red
					txt = "[txt]\n[txt_c][src.psi_gain_temp] Power</font>"
				if(src.eng_mod_gain_temp != 0)
					if(src.eng_mod_gain_temp > 0) txt_c = txt_green
					else txt_c = txt_red
					txt = "[txt]\n[txt_c][src.eng_mod_gain_temp] Energy Mod</font>"
				if(src.eng_gain_temp != 0)
					if(src.eng_gain_temp > 0) txt_c = txt_green
					else txt_c = txt_red
					txt = "[txt]\n[txt_c][src.eng_gain_temp] Max Energy</font>"
				if(src.str_gain_temp != 0)
					if(src.str_gain_temp > 0) txt_c = txt_green
					else txt_c = txt_red
					txt = "[txt]\n[txt_c][src.str_gain_temp] Strength</font>"
				if(src.spd_gain_temp != 0)
					if(src.spd_gain_temp > 0) txt_c = txt_green
					else txt_c = txt_red
					txt = "[txt]\n[txt_c][src.spd_gain_temp] Agility Mod</font>"
				if(src.end_gain_temp != 0)
					if(src.end_gain_temp > 0) txt_c = txt_green
					else txt_c = txt_red
					txt = "[txt]\n[txt_c][src.end_gain_temp] Endurance</font>"
				if(src.res_gain_temp != 0)
					if(src.res_gain_temp > 0) txt_c = txt_green
					else txt_c = txt_red
					txt = "[txt]\n[txt_c][src.res_gain_temp] Resistance</font>"
				if(src.force_gain_temp != 0)
					if(src.force_gain_temp > 0) txt_c = txt_green
					else txt_c = txt_red
					txt = "[txt]\n[txt_c][src.force_gain_temp] Force</font>"
				if(src.off_gain_temp != 0)
					if(src.off_gain_temp > 0) txt_c = txt_green
					else txt_c = txt_red
					txt = "[txt]\n[txt_c][src.off_gain_temp] Offence</font>"
				if(src.def_gain_temp != 0)
					if(src.def_gain_temp > 0) txt_c = txt_green
					else txt_c = txt_red
					txt = "[txt]\n[txt_c][src.def_gain_temp] Defence</font>"
				if(src.regen_gain_temp != 0)
					if(src.regen_gain_temp > 0) txt_c = txt_green
					else txt_c = txt_red
					txt = "[txt]\n[txt_c][src.regen_gain_temp] Regeneration Mod</font>"
				if(src.recov_gain_temp != 0)
					if(src.recov_gain_temp > 0) txt_c = txt_green
					else txt_c = txt_red
					txt = "[txt]\n[txt_c][src.recov_gain_temp] Recovery Mod</font>"
				if(src.rads_gain_temp != 0)
					if(src.rads_gain_temp > 0) txt_c = txt_green
					else txt_c = txt_red
					txt = "[txt]\n[txt_c][src.rads_gain_temp] Radiation Tolerance</font>"
				if(src.cold_gain_temp != 0)
					if(src.cold_gain_temp > 0) txt_c = txt_green
					else txt_c = txt_red
					txt = "[txt]\n[txt_c][src.cold_gain_temp] Cold Tolerance</font>"
				if(src.heat_gain_temp != 0)
					if(src.heat_gain_temp > 0) txt_c = txt_green
					else txt_c = txt_red
					txt = "[txt]\n[txt_c][src.heat_gain_temp] Heat Tolerance</font>"
				if(src.gravity_gain_temp != 0)
					if(src.gravity_gain_temp > 0) txt_c = txt_green
					else txt_c = txt_red
					txt = "[txt]\n[txt_c][src.gravity_gain_temp] Gravity Tolerance</font>"
				if(src.toxin_gain_temp != 0)
					if(src.toxin_gain_temp > 0) txt_c = txt_green
					else txt_c = txt_red
					txt = "[txt]\n[txt_c][src.toxin_gain_temp] Toxin Tolerance</font>"
				/*if(src.divine_mod_gain_temp != 0)
					if(src.divine_mod_gain_temp > 0) txt_c = txt_green
					else txt_c = txt_red
					txt = "[txt]\n[txt_c][src.divine_mod_gain_temp] Divine Energy Mod</font>"
				if(src.dark_matter_mod_gain_temp != 0)
					if(src.dark_matter_mod_gain_temp > 0) txt_c = txt_green
					else txt_c = txt_red
					txt = "[txt]\n[txt_c][src.dark_matter_mod_gain_temp] Dark Matter Mod</font>"*/
				if(src.metab_gain_temp != 0)
					if(src.metab_gain_temp > 0) txt_c = "<font color = red>+"
					else txt_c = "<font color = green>-"
					txt = "[txt]\n[txt_c][src.metab_gain_temp] Metabolic Rate</font>"
				if(src.hydro_gain_temp != 0)
					if(src.hydro_gain_temp > 0) txt_c = "<font color = red>+"
					else txt_c = "<font color = green>-"
					txt = "[txt]\n[txt_c][src.hydro_gain_temp] Dehydration Rate</font>"
				if(src.tiredness_gain_temp != 0)
					if(src.tiredness_gain_temp > 0) txt_c = "<font color = red>+"
					else txt_c = "<font color = green>-"
					txt = "[txt]\n[txt_c][src.tiredness_gain_temp] Tiredness Rate</font>"
				txt = "[txt]\n\nComedown Effects: "
				if(src.psi_mod_loss_temp != 0)
					if(src.psi_mod_loss_temp > 0) txt_c = txt_green
					else txt_c = txt_red
					txt = "[txt]\n[txt_c][src.psi_mod_loss_temp] Power Mod</font>"
				if(src.psi_loss_temp != 0)
					if(src.psi_loss_temp > 0) txt_c = txt_green
					else txt_c = txt_red
					txt = "[txt]\n[txt_c][src.psi_loss_temp] Power</font>"
				if(src.eng_mod_loss_temp != 0)
					if(src.eng_mod_loss_temp > 0) txt_c = txt_green
					else txt_c = txt_red
					txt = "[txt]\n[txt_c][src.eng_mod_loss_temp] Energy Mod</font>"
				if(src.eng_loss_temp != 0)
					if(src.eng_loss_temp > 0) txt_c = txt_green
					else txt_c = txt_red
					txt = "[txt]\n[txt_c][src.eng_loss_temp] Max Energy</font>"
				if(src.str_loss_temp != 0)
					if(src.str_loss_temp > 0) txt_c = txt_green
					else txt_c = txt_red
					txt = "[txt]\n[txt_c][src.str_loss_temp] Strength</font>"
				if(src.spd_loss_temp != 0)
					if(src.spd_loss_temp > 0) txt_c = txt_green
					else txt_c = txt_red
					txt = "[txt]\n[txt_c][src.spd_loss_temp] Agility Mod</font>"
				if(src.end_loss_temp != 0)
					if(src.end_loss_temp > 0) txt_c = txt_green
					else txt_c = txt_red
					txt = "[txt]\n[txt_c][src.end_loss_temp] Endurance</font>"
				if(src.res_loss_temp != 0)
					if(src.res_loss_temp > 0) txt_c = txt_green
					else txt_c = txt_red
					txt = "[txt]\n[txt_c][src.res_loss_temp] Resistance</font>"
				if(src.force_loss_temp != 0)
					if(src.force_loss_temp > 0) txt_c = txt_green
					else txt_c = txt_red
					txt = "[txt]\n[txt_c][src.force_loss_temp] Force</font>"
				if(src.off_loss_temp != 0)
					if(src.off_loss_temp > 0) txt_c = txt_green
					else txt_c = txt_red
					txt = "[txt]\n[txt_c]+[src.off_loss_temp] Offence</font>"
				if(src.def_loss_temp != 0)
					if(src.def_loss_temp > 0) txt_c = txt_green
					else txt_c = txt_red
					txt = "[txt]\n[txt_c][src.def_loss_temp] Defence</font>"
				if(src.regen_loss_temp != 0)
					if(src.regen_loss_temp > 0) txt_c = txt_green
					else txt_c = txt_red
					txt = "[txt]\n[txt_c][src.regen_loss_temp] Regeneration Mod</font>"
				if(src.recov_loss_temp != 0)
					if(src.recov_loss_temp > 0) txt_c = txt_green
					else txt_c = txt_red
					txt = "[txt]\n[txt_c][src.recov_loss_temp] Recovery Mod</font>"
				if(src.rads_loss_temp != 0)
					if(src.rads_loss_temp > 0) txt_c = txt_green
					else txt_c = txt_red
					txt = "[txt]\n[txt_c][src.rads_loss_temp] Radiation Tolerance</font>"
				if(src.cold_loss_temp != 0)
					if(src.cold_loss_temp > 0) txt_c = txt_green
					else txt_c = txt_red
					txt = "[txt]\n[txt_c][src.cold_loss_temp] Cold Tolerance</font>"
				if(src.heat_loss_temp != 0)
					if(src.heat_loss_temp > 0) txt_c = txt_green
					else txt_c = txt_red
					txt = "[txt]\n[txt_c][src.heat_loss_temp] Heat Tolerance</font>"
				if(src.gravity_loss_temp != 0)
					if(src.gravity_loss_temp > 0) txt_c = txt_green
					else txt_c = txt_red
					txt = "[txt]\n[txt_c][src.gravity_loss_temp] Gravity Tolerance</font>"
				if(src.toxin_loss_temp != 0)
					if(src.toxin_loss_temp > 0) txt_c = txt_green
					else txt_c = txt_red
					txt = "[txt]\n[txt_c][src.toxin_loss_temp] Toxin Tolerance</font>"
			/*	if(src.divine_mod_loss_temp != 0)
					if(src.divine_mod_loss_temp > 0) txt_c = txt_green
					else txt_c = txt_red
					txt = "[txt]\n[txt_c][src.divine_mod_loss_temp] Divine Energy Mod</font>"
				if(src.dark_matter_mod_loss_temp != 0)
					if(src.dark_matter_mod_loss_temp > 0) txt_c = txt_green
					else txt_c = txt_red
					txt = "[txt]\n[txt_c][src.dark_matter_mod_loss_temp] Dark Matter Mod</font>"*/
				if(src.metab_loss_temp != 0)
					if(src.metab_loss_temp > 0) txt_c = "<font color = red>+"
					else txt_c = "<font color = green>-"
					txt = "[txt]\n[txt_c][src.metab_loss_temp] Metabolic Rate</font>"
				if(src.hydro_loss_temp != 0)
					if(src.hydro_loss_temp > 0) txt_c = "<font color = red>+"
					else txt_c = "<font color = green>-"
					txt = "[txt]\n[txt_c][src.hydro_loss_temp] Dehydration Rate</font>"
				if(src.tiredness_loss_temp != 0)
					if(src.tiredness_loss_temp > 0) txt_c = "<font color = red>+"
					else txt_c = "<font color = green>-"
					txt = "[txt]\n[txt_c][src.tiredness_loss_temp] Tiredness Rate</font>"
				return txt
			create_drug_buff(var/mob/m)
				var/obj/buffs_and_debuffs/timed/b = new
				b.psi_gain = src.psi_gain_temp*src.tech_lvl
				b.eng_gain = src.eng_gain_temp*src.tech_lvl
				b.str_gain = src.str_gain_temp*src.tech_lvl
				b.end_gain = src.end_gain_temp*src.tech_lvl
				b.spd_gain = src.spd_gain_temp*src.tech_lvl
				b.res_gain = src.res_gain_temp*src.tech_lvl
				b.force_gain = src.force_gain_temp*src.tech_lvl
				b.off_gain = src.off_gain_temp*src.tech_lvl
				b.def_gain = src.def_gain_temp*src.tech_lvl
				b.regen_gain = src.regen_gain_temp*src.tech_lvl
				b.recov_gain = src.recov_gain_temp*src.tech_lvl
				b.int_gain = src.int_gain_temp*src.tech_lvl
				b.rads_gain = src.rads_gain_temp*src.tech_lvl
				b.cold_gain = src.cold_gain_temp*src.tech_lvl
				b.heat_gain = src.heat_gain_temp*src.tech_lvl
				b.toxin_gain = src.toxin_gain_temp*src.tech_lvl
				b.gravity_gain = src.gravity_gain_temp*src.tech_lvl
				b.divine_mod_gain = src.divine_mod_gain_temp*src.tech_lvl
				b.dark_matter_mod_gain = src.dark_matter_mod_gain_temp*src.tech_lvl
				b.eng_mod_gain = src.eng_mod_gain_temp*src.tech_lvl
				b.psi_mod_gain = src.psi_mod_gain_temp*src.tech_lvl
				b.metab_gain = src.metab_gain_temp*src.tech_lvl
				b.hydro_gain = src.hydro_gain_temp*src.tech_lvl
				b.tiredness_gain = src.tiredness_gain_temp*src.tech_lvl

				b.psi_loss = src.psi_loss_temp*src.tech_lvl
				b.eng_loss = src.eng_loss_temp*src.tech_lvl
				b.str_loss = src.str_loss_temp*src.tech_lvl
				b.end_loss = src.end_loss_temp*src.tech_lvl
				b.spd_loss = src.spd_loss_temp*src.tech_lvl
				b.res_loss = src.res_loss_temp*src.tech_lvl
				b.force_loss = src.force_loss_temp*src.tech_lvl
				b.off_loss = src.off_loss_temp*src.tech_lvl
				b.def_loss = src.def_loss_temp*src.tech_lvl
				b.regen_loss = src.regen_loss_temp*src.tech_lvl
				b.recov_loss = src.recov_loss_temp*src.tech_lvl
				b.int_loss = src.int_loss_temp*src.tech_lvl
				b.rads_loss = src.rads_loss_temp*src.tech_lvl
				b.cold_loss = src.cold_loss_temp*src.tech_lvl
				b.heat_loss = src.heat_loss_temp*src.tech_lvl
				b.toxin_loss = src.toxin_loss_temp*src.tech_lvl
				b.gravity_loss = src.gravity_loss_temp*src.tech_lvl
				b.divine_mod_loss = src.divine_mod_loss_temp*src.tech_lvl
				b.dark_matter_mod_loss = src.dark_matter_mod_loss_temp*src.tech_lvl
				b.eng_mod_loss = src.eng_mod_loss_temp*src.tech_lvl
				b.psi_mod_loss = src.psi_mod_loss_temp*src.tech_lvl
				b.metab_loss = src.metab_loss_temp*src.tech_lvl
				b.hydro_loss = src.hydro_loss_temp*src.tech_lvl
				b.tiredness_loss = src.tiredness_loss_temp*src.tech_lvl

				b.buff_type = "drug buff"
				b.icon_state = "drug buff"
				b.type_path = src.type
				b.buff_name = "[src.name] metabolization"
				b.origin_name = src.name
				b.comedown = src.comedown
				b.comedown_timer = src.comedown_duration

				b.timer = (src.tech_lvl/src.duration)*m.drug_tolerances
				m<<"Timer for Drug: [b.timer] - [(src.tech_lvl/src.duration)](Mix) - [src.duration] Dur. - [src.tech_lvl] Lvl."
				b.apply_buff(m,b)
				b.loc = m

			apply_same_drug(var/mob/m)
				var/found_same = 0
				for(var/obj/buffs_and_debuffs/b in m)
					if(b.origin_name == src.name)
						//if(b.name != "[b.origin_name] comedown") b.timer = src.duration
						found_same = 1
						break
				return found_same
		MouseEntered(location,control,params)
			//..()
			//Mouse name box code
			/*
			usr.client.MousePosition(params)
			usr.mouse_txt_over = src // For the name box that appears for items.
			usr.mouse_saved_loc = params
			spawn(7)
				if(usr.mouse_txt_over == src)
					usr.client.MousePosition(usr.mouse_saved_loc)
					usr.create_map_box(params,src) // For the name box that appears for items.
					usr.mouse_txt_confirm = src
			*/
			//End mouse name box code
			/*
			if(src.loc != null)
				if(usr.build_mouse && usr.build_tech)
					usr.place_percise(params)
			*/
			if(!usr) return
			usr.mouse_over = src
			if(usr.hud_info) usr.hud_info.maptext = "<span style='-dm-text-outline: 1px #000000;text-align:right'>[src]</span>"
			if(src.stack_display == null) src.create_stack_display()
			if(src.stacks > 1 && src.stack_exempt == 0) usr.client.images += src.stack_display
			if(usr.toggled_info)
				if(istype(src,/obj/items/tech/))
					usr.show_info_tech(src)
			/*
			if(usr.open_inven && usr.accessing && src.loc == usr.accessing && usr.hud_inv)
				//usr.hud_inv.item_name.maptext = "[css_outline]<font size = 1><center>[src.name]"
				usr.hud_inv.item_desc.maptext = "[css_outline]<font size = 1><text align=center valign=top>[src.name]<text align=left valign=top>\n\nRarity: [global.rarity_color[src.rarity]]\n\n[src.desc_extra][src.desc]"
				winset(usr,null,"inven.label_name.text=\"[src.name]\"")
				winset(usr,null,"inven.label_desc.text=\"[src.desc]\"")
				winset(usr,null,"inven.label_info.text=\"[src.desc_extra]\"")
			*/
			/*
			spawn(8)
				if(usr && src && usr.mouse_over == src)
					if(src.item_info == null)
						if(usr.hud_namebar && src.loc)
							var/obj/h = usr.hud_namebar
							h.loc = src.loc
							h.step_x = src.step_x
							h.step_y = src.step_y

							h.txt_i.maptext = "<center>[src.name]"
							if(!usr.client.images.Find(h.txt_i)) usr.client.images += h.txt_i

							//h.transform = matrix()*0.1
							//animate(h,transform = matrix()*1,time = 1)
					else if(usr.hud_info && src.loc)
						var/obj/h = usr.hud_info
						h.loc = src.loc
						h.step_x = src.step_x
						h.step_y = src.step_y

						//h.txt_i.maptext = "<center><p><u>[src.name]</u></p>[src.item_info]"
						h.txt_i.maptext = "<text align=center valign=top><p><u>[src.name]</u></p>[src.item_info]"
						if(!usr.client.images.Find(h.txt_i))  usr.client.images += h.txt_i

						//h.transform = matrix()*0.1
						//animate(h,transform = matrix()*1,time = 1)
			*/
			var/proceed = 1
			if(src.bolted && usr.trait_hm == null) proceed = 0
			if(src.bolted > 1) proceed = 0
			if(proceed) if(src.loc) if(!usr.left_click_function) usr.client.mouse_pointer_icon = 'mouse_grab.dmi'
			if(src.can_pocket || src.can_activate)
				if(!usr.left_click_function) usr.client.mouse_pointer_icon = 'mouse_interact.dmi'
				if(src.over == null)
					var/image/sel = image(src.icon,src)
					//sel.appearance = src.appearance
					//sel.override = 1
					//sel.mouse_opacity = 0
					sel.loc = src
					//sel.mouse_opacity = 0
					src.over = sel
					src.over.filters = filter(type="outline", size=1, color=src.o_color)
				if(ismob(src.loc) == 0 && isobj(src.loc) == 0)
					usr.client.images += src.over
					while(usr && usr.mouse_over && usr.mouse_over == src && src.over)
						//src.over.appearance = src.appearance
						src.over.icon = src.icon
						src.over.icon_state = src.icon_state
						//src.over.pixel_x = src.pixel_x
						//src.over.pixel_y = src.pixel_y
						src.over.overlays = src.overlays
						src.over.underlays = src.underlays
						//src.over.override = 1
						if(src.grabbed_by || src.tk) src.over.pixel_z = src.pixel_z-16
						//src.over.transform = src.transform
						src.over.dir = src.dir
						sleep(0.1)
				else if(length(src.filters) <= 0) src.filters += filter(type="outline", size=1, color=src.o_color)
		MouseExited(location,control,params)
			if(!usr) return
			if(!isturf(src.loc))
				if(length(src.filters) <= 1) src.filters -= filter(type="outline", size=1, color=src.o_color)
			else usr.client.images -= src.stack_display
			if(usr.mouse_txt)
				usr.client.screen -= usr.mouse_txt // For the name box that appears for items.
				usr.mouse_txt_confirm = null // For the name box that appears for items.
				usr.mouse_txt_over = null // For the name box that appears for items.
			usr.client.images -= src.over
			usr.mouse_over = null
			if(!usr.left_click_function) usr.client.mouse_pointer_icon = 'mouse.dmi'

			if(usr.hud_namebar)
				usr.hud_namebar.loc = null
				usr.hud_info.loc = null
				/*
				var/obj/h = usr.hud_namebar
				h.loc = src.loc
				h.step_x = src.step_x
				h.step_y = src.step_y

				h.txt_i.maptext = "[src.name]"
				usr.client.images += h.txt_i
				*/
		MouseDrag(over_object,src_location,over_location,src_control,over_control,params)
			if(src.loc != null)
				var/icon/i = new(src.icon,src.icon_state)
				usr.client.mouse_pointer_icon = i
		MouseDrop(over_object, src_location, over_location, src_control, over_control, params)
			if(src.loc != null)
				usr.client.mouse_pointer_icon = null

			var/obj/items/item = src // Assume the dragged object is an item
			var/obj/enviornment/Campfire/campfire = over_object // Object being dropped onto
			var/obj/items/Mage_Pot/pot = over_object // The object being dropped onto
			var/obj/items/consumables/seeds/Seed = over_object

			//Check for witch pot stuff
			if(istype(pot, /obj/items/Mage_Pot))
				pot.Dropped(item, usr)
				return

			// Check if dropped on a campfire and item is cookable
			if(istype(Seed, /obj/items/consumables/seeds))
				if(Seed.loc != usr)
					if(istype(item, /obj/items/consumables/water/))
						if(!istype(item,/obj/items/consumables/water/water_bottle_sea))
							var/amount = input(usr, "How much water do you want to pour?", "Watering", 1) as num
							if(amount > item.stacks)
								usr.set_alert("You don't have enough water.",'alert.dmi',"alert")
								return

							//item.stacks -= amount
							item.use_obj(usr,amount)
							usr.refresh_inv()
							Seed.Water(amount)
							usr.set_alert("You watered the [Seed.name] by [amount]x!",'alert.dmi',"alert")

			if(istype(campfire, /obj/enviornment/Campfire))
				if(item.can_cook == 1 && item.cooked == 0)
					//call(campfire.act)(usr,src)
					if (campfire.is_cooking == 1)
						usr.set_alert("Someone is already cooking!",'alert.dmi',"alert")

						return
					if(src in usr)
						if(item.cooked==1)
							usr.set_alert("[src] is already cooked!",'alert.dmi',"alert")
							return
						if(item.can_cook==1) if(item.cooked==0)
							//var/T = world.time
							campfire.is_cooking=1
							usr.set_alert("You begin cooking [item]..",'alert.dmi',"alert")
							sleep(2)
							campfire.is_cooking=0
							if(src && usr && src.loc == usr && src.stacks > 0)
								if(istype(item,/obj/items/consumables/water/water_bottle_dirty))

									item.cook_obj(usr)
									//usr.set_alert("You boiled a [item]!",'alert.dmi',"alert")
									view(10,usr)<<output("[usr.fullname] boiled a [item]","actionoutput")
									usr.refresh_inv()
								else
									if(istype(item,/obj/items/consumables/))

										item.cook_obj(usr)
										//usr.set_alert("You cooked a [item]!",'alert.dmi',"alert")
										view(10,usr)<<output("[usr.fullname] cooked a [item]","actionoutput")
										usr.refresh_inv()

								/*if(istype(item,/obj/items/consumables/water/water_bottle_dirty))
									usr.set_alert("You boiled a [item]!",'alert.dmi',"alert")
									view(5,usr)<<output("[usr.fullname]] boiled a [item]","actionoutput")
								else
									usr.set_alert("You cooked a [item]!",'alert.dmi',"alert")

									view(5,usr)<<output("[usr.fullname]] cooked a [item]","actionoutput")
								//usr.icon_state=""
								*/

			 	return

			// Handle other cases (e.g., dismiss or skillbar interactions)
			var/dismiss = 0
			if(istype(over_object, /obj/hud/buttons/skillbar/))
				if(istype(item, /obj/skills/))
					usr.add_to_skillbar(item, over_object)
				else
					dismiss = 1
			else
				dismiss = 1

			if(dismiss)
			// Logic for dismissing the dragged object
				usr.client.screen -= src

		Click(location,control,params)
			//src.flash_red()
			//src.shake()
			winset(usr,"map.map","focus=true")
			params = params2list(params)
			if(params["right"])
				if(usr.left_click_function) //Dismiss any left click functions
					usr.left_click_function = null
					usr.left_click_ref = null
					//world << "DEBUG - left_click_ref rendered null"
					usr.client.mouse_pointer_icon = 'mouse.dmi'
					return
				if(usr.skill_remote_viewing && usr.skill_remote_viewing.active)
					call(usr.skill_remote_viewing.act)(usr,usr.skill_remote_viewing)
					usr.map_proc(1)
				if(usr.active_attack) usr.active_attack = null //Cancel the energy attack current being fired or charged.

				/*
				//Drop an item by right clicking it
				if(usr.accessing in range(1,usr))
					var/mob/m = usr.accessing
					if(ismob(src.loc))
						var/mob/x = src.loc
						x.overlays -= src
						x.underlays -= src
						src.loc = m.loc
						src.underlays = null
						src.step_x = m.step_x
						src.step_y = m.step_y
						src.layer = initial(src.layer)
						usr.client.screen -= src
						src.set_shadow()
						if(src.floor_state)
							src.icon_state = src.floor_state
						usr.refresh_inv()
						return
				*/
			else if(params["left"])
				if(istype(src,/obj/items/))
					if(istype(src,/obj/items/tech/) && src.loc == usr.accessing && usr.intxp>=src.tech_lvl && !istype(src,/obj/items/tech/weapons/)) usr.hud_inv.item_desc.maptext = "[css_outline]<font size = 1><text align=center valign=top>[src.name]<text align=left valign=top>\n\nRarity: [global.rarity_color[src.rarity]]\nQuality: [src.tech_lvl]%\n\n[src.desc_extra][src.desc]"
					else if(istype(src,/obj/items/tech/) && src.loc == usr.accessing && usr.intxp<src.tech_lvl) usr.hud_inv.item_desc.maptext = "[css_outline]<font size = 1><text align=center valign=top>[src.name]<text align=left valign=top>\n\nRarity: [global.rarity_color[src.rarity]]\nQuality: Unknown\n\n[src.desc_extra][src.desc]"

					else if(istype(src,/obj/items/) && src.loc == usr.accessing) usr.hud_inv.item_desc.maptext = "[css_outline]<font size = 1><text align=center valign=top>[src.name]<text align=left valign=top>\n\nRarity: [global.rarity_color[src.rarity]]\n\n[src.desc_extra][src.desc]"
				else if(src.loc == usr.accessing) usr.hud_inv.item_desc.maptext = "[css_outline]<font size = 1><text align=center valign=top>[src.name]<text align=left valign=top>\n\nRarity: [global.rarity_color[src.rarity]]\n\n[src.desc_extra][src.desc]"

				if(istype(src,/obj/items/tech/))
					if(src.loc == null)
						for(var/obj/t in global.tech)//usr.technology_researched)
							usr.client.images -= t.img_select
						if(usr.tech_unlocked.Find(src.type))//src))
							//usr.build_tech = src
							if(usr.build_tech_selected)
								var/obj/t = usr.build_tech_selected
								t.filters -= filter(type="outline", size=4, color=rgb(255,255,255))
							usr.build_tech_selected = src;
							src.filters += filter(type="outline", size=4, color=rgb(255,255,255))
							if(istype(src,/obj/items/tech/weights/)) src.value = src.weight*100
							//winset(usr,"tech.label_cost","text=\"Cost: [Commas(src.value)]\"")
							//winset(usr,"tech.label_name","text=\"[src.name]\"")
							//winset(usr,"tech.label_desc","text=\"[src.desc]\"")
							//winset(usr,"tech.label_info","text=\"[src.desc_extra]\"")
							//var/icon/I = icon(src.icon,src.icon_state,SOUTH,1,0)
							//I.Scale(src.scale_x,src.scale_y)
							//var/Z = fcopy_rsc(I)

							if(usr.hud_tech)
								var/obj/I = usr.hud_tech.txt
								var/can_move = "Yes"
								if(src.bolted > 1) can_move = "No"
								I.maptext = "[css_outline]<font size = 1><text align=center valign=top>[src.name]<text align=left valign=top>\n\nNeeded Minerals: <text align=right valign=top> Stone: [src.stone_cost]\nCopper: [src.copper_cost]\nCoal: [src.coal_cost]\nSilver: [src.silver_cost]\nGold: [src.gold_cost]\nTitanium: [src.titanium_cost]\nMystille: [src.mystille_cost]\n\n<text align=left valign=top>Tech Tree: [src.tech_tree]\n\nMoveable: [can_move]\n\n[src.desc]"
								//winset(usr,"tech.label_img","image=\ref[Z]")
							//winshow(usr,"tech_panes",0)
							//winset(usr,"tech.label_tech","text=\"[src.name] - [src.desc]\"")
							//usr.client.images += src.img_select
							if(usr.build_mouse)
								usr.build_mouse.loc = null
								usr.build_mouse = null
								//del(usr.build_mouse)
					else if(usr.build_mouse && usr.build_tech)
						if(usr.mouse_far)
							usr << "Unable to place. [usr.mouse_far]"
							return
						usr.build_tech(usr.build_tech,usr.build_marker)
						if(usr) usr.mouse_down = null
						return
				//Player activates TK on target
				if(usr.left_click_function == "tk")
					if(usr.skill_tk && src.bolted < 2)
						if(src.tk == 0)
							src.mouse_opacity  = 0
							animate(src, pixel_z = 16, time = 1)
							src.density_factor = 0
							src.layer += 100
							src.filters += filter(type="drop_shadow", x=0, y=0, size=5, offset=0, color=rgb(102,0,204))
							var/obj/effects/dust_medium/d = new
							d.SetCenter(src)
							if(src.generator == 1 && src.can_generate == 1 || src.icon_state == "battery")
								for(var/turf/trf in src.locs)
									for(var/obj/items/tech/Power_Line/p in trf)
										spawn(2)
											if(p)
												p.reconnect_power()

							spawn(1)
								if(usr && src)
									animate(src,pixel_y = 4, time = 10,loop = -1)
									animate(pixel_y = 0, time = 10)
						//usr.energy -= 0.01+((usr.energy_max*0.25)/proceed.skill_lvl/usr.mod_energy)
						usr.energy -= 1.1-(usr.skill_tk.skill_lvl/100)
					//	usr.gain_stat("force",1,1,"Telekinesis")
						usr.skill_tk.skill_exp += (10/usr.skill_tk.skill_lvl)*usr.mod_skill
						if(usr.skill_tk.skill_exp >= 100 && usr.skill_tk.skill_lvl < 100)
							usr.skill_tk.skill_exp = 1
							usr.skill_tk.skill_lvl += 1
						src.tk = 1
						usr.tk = src
					usr.left_click_function = null
					usr.client.mouse_pointer_icon = 'mouse.dmi'
					return
				//Follower go
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
						winshow(usr,"contacts",1)
						usr.open_contacts = 1
						usr.open_menus.Add(".open_contacts")
						if(m.activated == 0)
							m.activated = 1
							m.follower_ai()
						return
				//Follower give
				else if(usr.left_click_function == "clone give")
					if(usr.left_click_ref)
						if(get_dist(usr,usr.left_click_ref) <= 2)
							if(src.suffix == "worn" || src.suffix == "equipped")
								usr.set_alert("Can't transfer worn items",'alert.dmi',"alert")

								return
							if(src in usr)
								usr.client.mouse_pointer_icon = 'mouse.dmi'
								winshow(usr,"contacts",1)
								usr.open_contacts = 1
								usr.open_menus.Add(".open_contacts")
								src.loc = usr.left_click_ref
								usr.refresh_inv()
								usr.left_click_function = null
								usr.left_click_ref = null
								if(src == usr.item_selected)
									usr.item_selected = null
									src.overlays -= /obj/effects/select_item
							else if(src in usr.left_click_ref)
								usr.client.mouse_pointer_icon = 'mouse.dmi'
								winshow(usr,"contacts",1)
								usr.open_contacts = 1
								usr.open_menus.Add(".open_contacts")
								src.loc = usr
								usr.refresh_inv()
								usr.left_click_function = null
								usr.left_click_ref = null
						return
				//Follower go
				else if(usr.left_click_function == "clone go")
					if(usr.left_click_ref)
						usr << output("Selected [src] as target for [usr.left_click_ref] to travel to.","chat.world")
						usr << output("Selected [src] as target for [usr.left_click_ref] to travel to.","chat.local")
						usr.left_click_ref.function = "go"
						usr.left_click_ref.target_go = src
						usr.left_click_function = null
						usr.left_click_ref = null
						usr.client.mouse_pointer_icon = 'mouse.dmi'
						winshow(usr,"contacts",1)
						usr.open_contacts = 1
						usr.open_menus.Add(".open_contacts")
						return
				else if(usr.left_click_function == "change object icon")
					if(usr.icon_stored)
						if(src.change_icon)
							src.icon = usr.icon_stored
							usr.left_click_function = null
							usr.icon_stored = null
						else
							usr.set_alert("None applicable object",'alert.dmi',"alert")

							usr.left_click_function = null
							usr.icon_stored = null
							return
					return
				else if(usr.left_click_function == "reset object icon")
					src.icon = initial(src.icon)
					usr.left_click_function = null
					usr.icon_stored = null
					return
				if(isturf(src.loc))
					if(usr.build_mouse && usr.build_tech)
						if(usr.mouse_far)
							usr << "Unable to place. [usr.mouse_far]"
							return
						if(istype(usr.build_tech,/obj/items/tech/)) usr.build_tech(usr.build_tech,usr.build_marker)
						else if(istype(usr.build_tech,/obj/buildings/)) usr.build(usr.build_tech,usr.build_marker)
						//usr.build_tech(usr.build_tech,usr.build_marker)
						usr.mouse_down = null
					/*
					if(src in range(1,usr))
						if(!src.bolted)
							if(src.can_pocket)
								src.loc = usr
								if(src.shadow) src.shadow.loc = null
								if(src.inven_state)
									src.icon_state = src.inven_state
								src.overlays -= /obj/effects/select_item
								usr.mouse_down = null
								usr.mouse_over = null
								usr.refresh_inv()
								return
					*/



		Incubation_Egg
			icon ='Species_Egg.dmi'
			can_pocket = 0
			rarity = 4
			hp = 99999999999
			stacks = -1
			density=1
			density_factor = 1
			var/progress = 0;
			var/obj/bar = null
			var/obj/bar_inner = null
			var/tmp/obj/g_ball = null
			var/tmp/obj/g_rays = null
			var/tmp/list/pixs
			var/tmp/mob_filter_pos = 0
			var/incubating = 0
			var/mob/born_species
			var/mob/set_species
			var/icon/savedicon
			var/mob/user
			var/hatch_requirement = 25000
			var/invested_energy = 0
			var/obj/items/tech/drainers/Energy_Drainer/device
			//act = obj/items/tech/drainers/Incubation_Egg/proc/activate
			bounds = "-36,39 to 67,39"
			Click(location, control, params)
				if(src.user == usr)
					switch(input(user,"Hatch","Invest Energy") in list ("Hatch","Invest Energy"))
						if("Hatch")
							switch(alert(user,"Hatching the egg's process can take up to 30 seconds, however it requires an extremely vast amount of energy. WARNING: There is a chance that the hatching process can rip some lifespan away, are you sure you want to hatch?","","Yes","No"))
								if("Yes")
									if(src.invested_energy >= hatch_requirement)
										src.activate(src,src.set_species,user)
										return
									else

										usr.set_alert("The egg does not have enough energy to hatch.",src.icon,src.icon_state)
										return
						if("Invest Energy")
							var/amount = input("How much energy are you investing?") as num
							var/obj/items/tech/drainers/Energy_Drainer/ED
							for(ED in user)
								if(ED.suffix)
									device = ED
							if(amount <1 ) return
							if(amount <=-0) return
							if(amount>=user.energy_max && amount >= device.energy_supply)
								usr.set_alert("You do not have that much energy to invest!",src.icon,src.icon_state)
								return
							else if(amount<=user.energy_max)
								if(src)
									src.invested_energy += amount
									user.gains_trained_energy -= amount
									user.set_alert("You invested [amount] energy into the egg.",'alert.dmi',"alert")
									user<<output("You invested [amount] energy into the egg.","actionoutput")
									return





			proc
				setspecies(var/mob/species)
					if(species)
						src.set_species = species
					return
				activate(var/obj/items/Incubation_Egg/s,var/mob/species,var/mob/user)
					if(s.pixs && islist(s.pixs))
						for(var/obj/o in s.pixs)
							o.destroy()
					if(!species || species == null)
						s.vis_contents -= s.bar_inner
						s.vis_contents -= s.bar
					//	s.bar_inner.screen_loc = "23:-2,75:-3"
						s.bar_inner.pixel_x = "16:-2"
						s.bar_inner.pixel_y = "10:-3"
						s.progress = 0
						s.icon +=rgb(125,125,125)
						s.alpha = 155
						animate(s,alpha = 255, time = 10)
						//animate(m)
					//	if(s.mob_filter_pos) s.filters -= s.filters[s.mob_filter_pos]
						for(var/mob/m in view(25,src))
							m<<output("[born_species.real_name] was created!","actionoutput")

						born_species.loc = get_step(s, s)
						born_species.step_x = s.step_x
						born_species.step_y = s.step_y
						born_species.icon +=rgb(125,125,125)
						born_species.alpha = 55
					//	species.started = 1
					//	species.choosing_character = 0
						//species.create_login_menus()
						born_species.accessing = born_species
						//species.confirm_new_character()
						animate(born_species,alpha = 255, time = 7)
						born_species.icon = savedicon
						born_species.AddStatMod("Strength",born_species.mod_strength)
						born_species.AddStatMod("Endurance",born_species.mod_endurance)
						born_species.AddStatMod("Force",born_species.mod_force)
						born_species.AddStatMod("Resistance",born_species.mod_resistance)
						born_species.AddStatMod("Speed",born_species.mod_agility)
						born_species.AddStatMod("Offence",born_species.mod_offence)
						born_species.AddStatMod("Defence",born_species.mod_defence)
						//src<<"<center><b>Best Modifiers</b></center>"
						user.GetOthersTopThreeMods(born_species)
						user.gains_trained_energy -= hatch_requirement
						sleep(5)
						if(born_species) s.shockwave()
						sleep(3)
						s.active = 0
						//del(s)
					if(s.active == 0)

						s.active=1
						if(species)
							s.born_species = species
							s.savedicon = species.icon
						s.pixs = list()


						s.vis_contents += s.bar
						s.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(0,0,0))
						s.mob_filter_pos = s.filters.len
						animate(s.filters[s.filters.len], size = 3,offset = 1, time = 15, loop = -1)
						animate(size = -3,offset = -1, time = 15, loop = -1)

						var/p = 33
						while(p)
							p -= 1;
							var/obj/pix = new
							pix.icon = 'fx.dmi'
							pix.icon_state = "pixel"
							pix.loc = s.loc
							pix.step_x = s.step_x
							pix.step_y = s.step_y
							pix.pixel_x = rand(-5,200)
							pix.pixel_y = rand(-5,200)
							pix.bolted = 2
							pix.filters += filter(type="drop_shadow", x=0, y=0, size=1, offset=0, color=rgb(255,255,170))
							pix.filters += filter(type="bloom", threshold=rgb(0,0,0), size = 6,offset=0,alpha = 175)
							animate(pix,pixel_x = 10, pixel_y = 10, time = rand(10,20), alpha = 255,loop = -1)
							animate(time = 0, alpha = 0)
							if(s.pixs && islist(s.pixs)) s.pixs += pix
							else s.pixs = list()
						p = 33
						while(p)
							p -= 1;
							var/obj/pix = new
							pix.icon = 'fx.dmi'
							pix.icon_state = "pixel"
							pix.loc = s.loc
							pix.step_x = s.step_x
							pix.step_y = s.step_y
							pix.pixel_x = 0
							pix.pixel_y = 0
							pix.bolted = 2
							pix.filters += filter(type="drop_shadow", x=0, y=0, size=1, offset=1, color=rgb(102,0,204))
							pix.filters += filter(type="bloom", threshold=rgb(0,0,0), size = 6,offset=1,alpha = 175)
							animate(pix,pixel_x = rand(-10,200), pixel_y = rand(-10,200), time = rand(10,20), alpha = 0,loop = -1)
							animate(time = 0, alpha = 255)
							if(s.pixs && islist(s.pixs)) s.pixs += pix
							else s.pixs = list()

					else
						if(src.incubating==1)
							s.vis_contents -= s.bar_inner
							s.vis_contents -= s.bar
							s.bar_inner.screen_loc = "23:-2,75:-3"
							s.bar_inner.pixel_x = "16:-2"
							s.bar_inner.pixel_y = "10:-3"
							s.progress = 0

							//animate(m)
							if(s.mob_filter_pos) s.filters -= s.filters[s.mob_filter_pos]
							species.loc = get_step(s, s)
							species.icon +=rgb(125,125,125)
							species.alpha = 55
							species.started = 1
							species.choosing_character = 0
							species.create_login_menus()
							species.accessing = species
							species.confirm_new_character()
							animate(species,alpha = 255, time = 7)
							sleep(5)
							if(species && src) s.shockwave()
							sleep(3)
							s.active = 0
							src.destroy()
						else

							s.vis_contents -= s.bar_inner
							s.vis_contents -= s.bar
							s.bar_inner.screen_loc = "23:-2,75:-3"
							s.progress = 0

							//animate(m)
							if(s.mob_filter_pos) s.filters -= s.filters[s.mob_filter_pos]
						//m.filters = null
			New()
				..()
				bar = new /:revive_bar
				bar_inner = new /:revive_bar_inner
				for(var/mob/M in view(10,src))
					M<<output("A strange egg appears!","actionoutput")


				spawn(10)
					if(src)
						while(src)
							if(src.active)
								src.progress += 2
								//src.skill_exp += (10/src.skill_lvl)*m.mod_skill

								src.vis_contents -= src.bar_inner
								src.bar_inner.pixel_x = 45
								src.bar_inner.pixel_y = 0//   = "23:[round(src.progress/2)-2],75:-3"
								var/matrix/M = matrix()
								M.Scale(round(src.progress),1)
								src.bar_inner.transform = M
								src.vis_contents += src.bar_inner

								if(!src.loc||src.loc == null)
									call(src.act)(src)
								if(src.progress >= 100)
									if(src)
										if(src.pixs && islist(src.pixs))
											for(var/obj/o in src.pixs)
												animate(o)
												o.destroy()
												sleep(0.1)
											src.pixs = null

										//if(src && src.active) call(src.act)(src)
										if(src) src.activate(src,null)
							sleep(10)
			MouseEntered(location,control,params)
				usr.mouse_over = src
				if(usr.hud_info) usr.hud_info.maptext = "<span style='-dm-text-outline: 1px #000000;text-align:right'>[src]</span>"
				if(src.stack_display == null) src.create_stack_display()
				if(src.stacks > 1 && src.stack_exempt == 0) usr.client.images += src.stack_display
				if(usr.toggled_info)
					if(istype(src,/obj/items/tech/))
						usr.show_info_tech(src)

				var/proceed = 1
				if(src.bolted && usr.trait_hm == null) proceed = 0
				if(src.bolted > 1) proceed = 0
				if(proceed) if(src.loc) if(!usr.left_click_function) usr.client.mouse_pointer_icon = 'mouse_grab.dmi'
				if(src.can_pocket || src.can_activate)
					if(!usr.left_click_function) usr.client.mouse_pointer_icon = 'mouse_interact.dmi'
					if(src.over == null)
						var/image/sel = image(src.icon,src)
						//sel.appearance = src.appearance
						//sel.override = 1
						//sel.mouse_opacity = 0
						sel.loc = src
						//sel.mouse_opacity = 0
						src.over = sel
						src.over.filters = filter(type="outline", size=1, color=src.o_color)
					if(ismob(src.loc) == 0 && isobj(src.loc) == 0)
						usr.client.images += src.over
						while(usr && usr.mouse_over && usr.mouse_over == src && src.over)
							//src.over.appearance = src.appearance
							src.over.icon = src.icon
							src.over.icon_state = src.icon_state
							//src.over.pixel_x = src.pixel_x
							//src.over.pixel_y = src.pixel_y
							src.over.overlays = src.overlays
							src.over.underlays = src.underlays
							//src.over.override = 1
							if(src.grabbed_by || src.tk) src.over.pixel_z = src.pixel_z-16
							//src.over.transform = src.transform
							src.over.dir = src.dir
							sleep(0.1)
					else if(length(src.filters) <= 0) src.filters += filter(type="outline", size=1, color=src.o_color)
			MouseExited(location,control,params)
				if(!isturf(src.loc))
					if(length(src.filters) <= 1) src.filters -= filter(type="outline", size=1, color=src.o_color)
				else usr.client.images -= src.stack_display
				if(usr.mouse_txt) usr.client.screen -= usr.mouse_txt // For the name box that appears for items.
				usr.mouse_txt_confirm = null // For the name box that appears for items.
				usr.mouse_txt_over = null // For the name box that appears for items.
				usr.client.images -= src.over
				usr.mouse_over = null
				if(!usr.left_click_function) usr.client.mouse_pointer_icon = 'mouse.dmi'

				if(usr.hud_namebar)
					usr.hud_namebar.loc = null
					usr.hud_info.loc = null
		Chopping_Board
			info_name = "hair_dye"
			mouse_over_pointer = MOUSE_ACTIVE_POINTER
			icon = 'ScissorsHairDye.dmi'
			icon_state = "Dye"
			value = 50
			can_pocket = 1
			density_factor = 0
			weight = 1
			desc = "A liquid substance used to change to permanently change your hair color"
			act = /obj/items/Hair_Dye/proc/use
			//act_drop = /obj/items/Hair_Dye/proc/drop
			appearance_flags = KEEP_TOGETHER



			info_name = "chopping_board"
			name = "Chopping Board"
			icon = 'choppingboard.dmi'
			can_pocket=1
			value = 50
			density_factor = 0
			stacks = -1
			rarity = 1
			weight = 1
			hp = 9999999
			icon_state = "Lit"
			act = /obj/items/Chopping_Board/proc/use
			//act_drop = /obj/items/Chopping_Board/proc/drop
			appearance_flags = KEEP_TOGETHER
			//stacks = -1
			var/is_chopping = 0
			desc = "Chop or chop yourself!"
			proc
				use(var/mob/m,var/obj/items/Chopping_Board/i)
					if(i in m)
						// Gather all valid items for cooking
						var/list/cookable_items = list()
						for(var/obj/items/consumables/itm in m)
							if (itm && itm.cooked == 0 && itm.food==1)
								cookable_items += itm

						if (!cookable_items.len)
							m.set_alert("You don't have anything to make!",'alert.dmi',"alert")
							m<<"You don't have anything to make!(Chopping Board)"
							//m << "You don’t have any cookable items in your inventory."
							return
						// Check for recipe matches
						var/list/recipes = list("Cancel")
						if(i.has_ingredients(m, "Raw Soup"))
							recipes += "Raw Soup"

						if (i.has_ingredients(m, "Raw Meat Soup"))
							recipes += "Raw Meat Soup"

						if (i.has_ingredients(m, "Apple Pie"))
							recipes += "Apple Pie"



						if(recipes.len == 1)
							m.set_alert("You don't have the ingredients for any recipes!",'alert.dmi',"alert")
							m<<"You don't have the ingredients for any recipes!"
							//m << "You don’t have the ingredients for any recipes."
							return
						// Create the recipe selection menu
						var/recipe_choice = input(m, "Choose a recipe to cook:", "Recipe Selection") in recipes
						if (recipe_choice == "Raw Soup")
							// Remove ingredients from inventory
							i.remove_ingredients(m, list("Carrot", "Celery", "Potato", "Bottle of Water"),"Raw Soup")
							// Create the Soup object
							var/obj/items/consumables/soup/s = new /obj/items/consumables/soup(m.loc)
							s.stacks=1
							m << "You created a delicious Soup!"


						// Mark the chopping as complete
							i.is_chopping = 0

						if (recipe_choice == "Raw Meat Soup")
							// Remove ingredients from inventory
							i.remove_ingredients(m, list("Carrot", "Celery", "Potato", "Bottle of Water","Raw Leg Meat","Raw Steak"),"Raw Meat Soup")
							// Create the Soup object
							var/obj/items/consumables/meat_soup/s = new /obj/items/consumables/meat_soup(m.loc)
							s.stacks=1
							m << "You created a delicious Meat Soup!"
							i.is_chopping = 0


						// Mark the chopping as complete

						if (recipe_choice == "Apple Pie")
							// Remove ingredients from inventory
							i.remove_ingredients(m, list("Apple","Bread","Milk"),"Apple Pie")
							// Create the Soup object
							var/obj/items/consumables/meat_soup/s = new /obj/items/consumables/meat_soup(m.loc)
							s.stacks=1
							m << "You created a delicious Meat Soup!"
							i.is_chopping = 0


						// Mark the chopping as complete

				drop(var/mob/m,var/obj/items/i)
					m.drop(i)


				/*has_ingredients(var/mob/m, var/recipe)

					if(recipe == "Raw Meat Soup")

						var/list/ingredients_required = list(
						"Carrot" = 1,
						"Celery" = 1,
						"Potato" = 1,
						"Bottle of Water" = 4
						)

						for(var/ingredient in ingredients_required)

							var/required_amount = ingredients_required[ingredient]
							var/found_amount = 0

							for(var/obj/items/consumables/item in m)
								if(item && item.name == ingredient)
									found_amount += item.stacks

							if(found_amount < required_amount)
								return FALSE

						// Check meat separately
						var/meat_total = 0

						for(var/obj/items/consumables/item in m)
							if(item && (item.name == "Raw Leg Meat" || item.name == "Raw Steak"))
							meat_total += item.stacks

						if(meat_total < 1)
							return FALSE

						return TRUE
					else if (recipe == "Raw Soup")
						var/ingredients_required = list(
							"Carrot" = 1,
							"Celery" = 1,
							"Potato" = 1,
							"Bottle of Water" = 4
						)
						for (var/ingredient in ingredients_required)
							var/required_amount = ingredients_required[ingredient]
							var/found_amount = 0

							for (var/obj/items/item in m)
								if (item && item.name == ingredient)
									found_amount += item.stacks

							if (found_amount < required_amount)
								return FALSE // Missing this ingredient
						return TRUE

					else if (recipe == "Apple Pie")
						var/ingredients_required = list(
							"Apple" = 1,
							"Bread" = 1,
							"Milk" = 1
						)

						for (var/ingredient in ingredients_required)
							var/found = 0
							for (var/obj/items/item in m)
								if (item && item.name == ingredient)
									found = 1
									break

							if (!found)
								return FALSE // Missing ingredient

						return TRUE

					return FALSE // Default fail
					*/

				has_ingredients(var/mob/m, var/recipe)

					if(recipe == "Raw Meat Soup")

						if(m.count_ingredient("Carrot") < 1) return FALSE
						if(m.count_ingredient("Celery") < 1) return FALSE
						if(m.count_ingredient("Potato") < 1) return FALSE
						if(m.count_ingredient("Bottle of Water") < 4) return FALSE

						var/meat_total = m.count_ingredient("Raw Leg Meat") + m.count_ingredient("Raw Steak")

						if(meat_total < 1) return FALSE

						return TRUE


					else if(recipe == "Raw Soup")

						if(m.count_ingredient("Carrot") < 1) return FALSE
						if(m.count_ingredient("Celery") < 1) return FALSE
						if(m.count_ingredient("Potato") < 1) return FALSE
						if(m.count_ingredient("Bottle of Water") < 4) return FALSE

						return TRUE


					else if(recipe == "Apple Pie")

						if(m.count_ingredient("Apple") < 1) return FALSE
						if(m.count_ingredient("Bread") < 1) return FALSE
						if(m.count_ingredient("Milk") < 1) return FALSE

						return TRUE

					return FALSE


			proc/remove_ingredients(var/mob/m, var/list/required_ingredients,var/recipe)
				if(recipe == "Raw Meat Soup")
					var/carrotamount = 1
					var/celeryamount = 1
					var/potatoamount = 1
					var/wateramount = 4
					var/meatamount = 1
					for (var/ingredient in required_ingredients)
						for (var/obj/items/item in m)
							if (item && item.name == ingredient)
								if(item.name == "Bottle of Water")
									item.stacks -= wateramount
									item.stack_display.maptext = "[css_outline]<font size=1><text align=right valign=bottom>[item.stacks]"
								if(item.name == "Potato")
									item.stacks -= potatoamount
									item.stack_display.maptext = "[css_outline]<font size=1><text align=right valign=bottom>[item.stacks]"

								if(item.name == "Celery")
									item.stacks -= celeryamount
									item.stack_display.maptext = "[css_outline]<font size=1><text align=right valign=bottom>[item.stacks]"

								if(item.name == "Carrot")
									item.stacks -= carrotamount
									item.stack_display.maptext = "[css_outline]<font size=1><text align=right valign=bottom>[item.stacks]"

								if(item.name == "Raw Leg Meat" || item.name == "Raw Steak")
									item.stacks -= meatamount
									item.stack_display.maptext = "[css_outline]<font size=1><text align=right valign=bottom>[item.stacks]"


								if(item.stacks == 0)
									item.destroy()
									if(item) del item
							//	if(item) del item

				else if(recipe == "Raw Soup")
					var/carrotamount = 1
					var/celeryamount = 1
					var/potatoamount = 1
					var/wateramount = 4
					for (var/ingredient in required_ingredients)
						for (var/obj/items/item in m)
							if (item && item.name == ingredient)
								if(item.name == "Bottle of Water")
									item.stacks -= wateramount
									item.stack_display.maptext = "[css_outline]<font size=1><text align=right valign=bottom>[item.stacks]"
								if(item.name == "Potato")
									item.stacks -= potatoamount
									item.stack_display.maptext = "[css_outline]<font size=1><text align=right valign=bottom>[item.stacks]"

								if(item.name == "Celery")
									item.stacks -= celeryamount
									item.stack_display.maptext = "[css_outline]<font size=1><text align=right valign=bottom>[item.stacks]"

								if(item.name == "Carrot")
									item.stacks -= carrotamount
									item.stack_display.maptext = "[css_outline]<font size=1><text align=right valign=bottom>[item.stacks]"


								if(item.stacks == 0)
									item.destroy()
									if(item) del item

			New()
				..()
				spawn(2500)
					if(src && !ismob(src.loc))
						src.destroy()


			Click(location,control,params)
				..()
				//Removes this item from the global Items list.



				params = params2list(params)
				if(params["left"])
					if(isturf(src.loc))
						usr.pickup(src)
						if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up x[src.stacks] [src]","actionoutput")
					else if(ismob(src.loc))
						if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
						usr.item_selected = src
						src.overlays -= /obj/effects/select_item
						src.overlays += /obj/effects/select_item


				if(items)
					if(src in items) items -= src
				params = params2list(params)
				if(params["left"])
					if(isturf(src.loc))
						usr.pickup(src)
						if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up x[src.stacks] [src]","actionoutput")
					else if(ismob(src.loc))
						if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
						usr.item_selected = src
						src.overlays -= /obj/effects/select_item
						src.overlays += /obj/effects/select_item


			MouseEntered(location,control,params)
				usr.mouse_over = src
				if(usr.hud_info) usr.hud_info.maptext = "<span style='-dm-text-outline: 1px #000000;text-align:right'>[src]</span>"
				if(src.stack_display == null) src.create_stack_display()
				if(src.stacks > 1 && src.stack_exempt == 0) usr.client.images += src.stack_display
				if(usr.toggled_info)
					if(istype(src,/obj/items/tech/))
						usr.show_info_tech(src)

				var/proceed = 1
				if(src.bolted && usr.trait_hm == null) proceed = 0
				if(src.bolted > 1) proceed = 0
				if(proceed) if(src.loc) if(!usr.left_click_function) usr.client.mouse_pointer_icon = 'mouse_grab.dmi'
				if(src.can_pocket || src.can_activate)
					if(!usr.left_click_function) usr.client.mouse_pointer_icon = 'mouse_interact.dmi'
					if(src.over == null)
						var/image/sel = image(src.icon,src)
						//sel.appearance = src.appearance
						//sel.override = 1
						//sel.mouse_opacity = 0
						sel.loc = src
						//sel.mouse_opacity = 0
						src.over = sel
						src.over.filters = filter(type="outline", size=1, color=src.o_color)
					if(ismob(src.loc) == 0 && isobj(src.loc) == 0)
						usr.client.images += src.over
						while(usr && usr.mouse_over && usr.mouse_over == src && src.over)
							//src.over.appearance = src.appearance
							src.over.icon = src.icon
							src.over.icon_state = src.icon_state
							//src.over.pixel_x = src.pixel_x
							//src.over.pixel_y = src.pixel_y
							src.over.overlays = src.overlays
							src.over.underlays = src.underlays
							//src.over.override = 1
							if(src.grabbed_by || src.tk) src.over.pixel_z = src.pixel_z-16
							//src.over.transform = src.transform
							src.over.dir = src.dir
							sleep(0.1)
					else if(length(src.filters) <= 0) src.filters += filter(type="outline", size=1, color=src.o_color)
			MouseExited(location,control,params)
				if(!isturf(src.loc))
					if(length(src.filters) <= 1) src.filters -= filter(type="outline", size=1, color=src.o_color)
				else usr.client.images -= src.stack_display
				if(usr.mouse_txt) usr.client.screen -= usr.mouse_txt // For the name box that appears for items.
				usr.mouse_txt_confirm = null // For the name box that appears for items.
				usr.mouse_txt_over = null // For the name box that appears for items.
				usr.client.images -= src.over
				usr.mouse_over = null
				if(!usr.left_click_function) usr.client.mouse_pointer_icon = 'mouse.dmi'

				if(usr.hud_namebar)
					usr.hud_namebar.loc = null
					usr.hud_info.loc = null
					/*
					var/obj/h = usr.hud_namebar
					h.loc = src.loc
					h.step_x = src.step_x
					h.step_y = src.step_y

					h.txt_i.maptext = "[src.name]"
					usr.client.images += h.txt_i
					*/
		// Witch Pot Object
		Mage_Pot
			name = "Mage Pot"
			icon = 'witchpot.dmi'
			var/obj/base_item = null
			var/obj/ingredients = list()
			var/mob/user = null
			bounds = "-65:81 , 177:75"
			pixel_y = -64
			pixel_x = -64

			// Initialize witch pot when placed
			New()
				..()
				var/matrix/M = matrix()

				var/scale_factor = 0.45  // Use 0.45 for 90x90 if needed
				M.Scale(scale_factor,scale_factor)
				src.transform = M

				//world << "A Witch Pot appears, ready for species creation."
			MouseEntered(location,control,params)
				usr.mouse_over = src
				if(usr.hud_info) usr.hud_info.maptext = "<span style='-dm-text-outline: 1px #000000;text-align:right'>[src]</span>"
				if(src.stack_display == null) src.create_stack_display()
				if(src.stacks > 1 && src.stack_exempt == 0) usr.client.images += src.stack_display
				if(usr.toggled_info)
					if(istype(src,/obj/items/tech/))
						usr.show_info_tech(src)

				var/proceed = 1
				if(src.bolted && usr.trait_hm == null) proceed = 0
				if(src.bolted > 1) proceed = 0
				if(proceed) if(src.loc) if(!usr.left_click_function) usr.client.mouse_pointer_icon = 'mouse_grab.dmi'
				if(src.can_pocket || src.can_activate)
					if(!usr.left_click_function) usr.client.mouse_pointer_icon = 'mouse_interact.dmi'
					if(src.over == null)
						var/image/sel = image(src.icon,src)
						//sel.appearance = src.appearance
						//sel.override = 1
						//sel.mouse_opacity = 0
						sel.loc = src
						//sel.mouse_opacity = 0
						src.over = sel
						src.over.filters = filter(type="outline", size=1, color=src.o_color)
					if(ismob(src.loc) == 0 && isobj(src.loc) == 0)
						usr.client.images += src.over
						while(usr && usr.mouse_over && usr.mouse_over == src && src.over)
							//src.over.appearance = src.appearance
							src.over.icon = src.icon
							src.over.icon_state = src.icon_state
							//src.over.pixel_x = src.pixel_x
							//src.over.pixel_y = src.pixel_y
							src.over.overlays = src.overlays
							src.over.underlays = src.underlays
							//src.over.override = 1
							if(src.grabbed_by || src.tk) src.over.pixel_z = src.pixel_z-16
							//src.over.transform = src.transform
							src.over.dir = src.dir
							sleep(0.1)
					else if(length(src.filters) <= 0) src.filters += filter(type="outline", size=1, color=src.o_color)
			MouseExited(location,control,params)
				if(!isturf(src.loc))
					if(length(src.filters) <= 1) src.filters -= filter(type="outline", size=1, color=src.o_color)
				else usr.client.images -= src.stack_display
				if(usr.mouse_txt) usr.client.screen -= usr.mouse_txt // For the name box that appears for items.
				usr.mouse_txt_confirm = null // For the name box that appears for items.
				usr.mouse_txt_over = null // For the name box that appears for items.
				usr.client.images -= src.over
				usr.mouse_over = null
				if(!usr.left_click_function) usr.client.mouse_pointer_icon = 'mouse.dmi'

				if(usr.hud_namebar)
					usr.hud_namebar.loc = null
					usr.hud_info.loc = null


			// Right-click to create species
			Click(location, control, params)
				if(src.user == usr)
					switch(input(user,"Are you ready to create the species?") in list ("Yes","No"))
						if("Yes")
							if(!src.base_item)
								usr.set_alert("You need a base item to create a species.",'alert.dmi',"alert")
								return

							// Determine species based on the base item type
							var/species = src.calculate_species()
							if(!species)
								usr.set_alert("Something went wrong during species creation.",'alert.dmi',"alert")
								return

							// Create the species and spawn it nearby
							var/chosenname = input("Select a name for this creation.") as text
							src.spawn_species(species,chosenname,user)
							src.destroy() // Remove the pot after use


			// When an item is dropped on the pot
			proc
				Dropped(var/obj/items/item, var/mob/user)
					if(!item.can_pocket)
						user.set_alert("You cannot use this item.",item.icon,item.icon_state)
						return
					if(istype(item,/obj/items/tech))
						user.set_alert("You cannot use this item.",item.icon,item.icon_state)
						return

					if(!user.race_class || (user.race_class != "Wizard" && user.race_class != "Witch"))
						user.set_alert("Only Witches and Wizards can use the Witch Pot.",'alert.dmi',"alert")
						return

					if(!src.user)
						src.user = user // Link the user who created this pot to prevent others from interfering

					// Ask the player to select "Base" or "Ingredient"
					var/choice = input(user, "Apply [item.name] as?") in list("Base", "Ingredient")
					if(choice == "Base")
						if(src.base_item)
							user.set_alert("A base item is already set. Create a new pot to change it.",'alert.dmi',"alert")
							return
						src.base_item = item
						user.set_alert("[item.name] is set as the base for this Witch Pot.",item.icon, item.icon_state)
					else if(choice == "Ingredient")
						src.ingredients += item
						user.set_alert("[item.name] has been added as an ingredient.",item.icon, item.icon_state)



				// Calculate species based on base item and ingredients
				calculate_species()
					var/base = src.base_item.base_type
					var/list/species_list = list()

					if(base == "Strength")
						species_list += list("Venemous Beetle", "Majin","Feline")
					else if(base == "Force")
						species_list += list("Saibamen", "Janemba","Canine")
					else if(base == "Endurance")
						species_list += list("Giant Crab", "Saibamen","Canine")
					else if(base == "Power")
						species_list += list("Venemous Beetle", "Majin", "Moro", "Saibamen", "Giant Crab","Feline","Canine")
					else if(base == "Speed")
						species_list += list("Saibamen","Feline","Canine")
					else if(base == "Offence")
						species_list += list("Saibamen","Majin","Venemous Beetle","Canine","Feline")
					else if(base == "Defence")
						species_list += list("Saibamen","Janemba","Venemous Beetle","Canine","Feline")
					else if(base == "Resistance")
						species_list += list("Saibamen","Venemous Beetle","Feline")
					else if(base == "Regeneration")
						species_list += list("Saibamen","Venemous Beetle","Giant Crab","Janemba")
					else if(base == "Recovery")
						species_list += list("Saibamen","Venemous Beetle","Giant Crab","Moro")




					if(species_list.len == 0)
						return null

					// Randomly select a species from the list
					return pick(species_list)

				// Spawn the species with stats derived from pot contents
				spawn_species(var/species,var/chosenname,var/mob/m)
					var/mob/new_species = new

					if(species == "Venemous Beetle") new_species.hatch_icon = 'VBeetle.dmi'
					if(species == "Majin") new_species.hatch_icon = 'majin_kid.dmi'
					if(species == "Saibamen") new_species.hatch_icon = 'Saiba.dmi'
					if(species == "Giant Crab") new_species.hatch_icon = 'NCrab.dmi'
					if(species == "Moro") new_species.hatch_icon = 'MoroBase.dmi'
					if(species == "Janemba") new_species.hatch_icon = 'JanembaBase.dmi'
					if(species == "Feline") new_species.hatch_icon = 'Cat_Male_Kid.dmi'
					if(species == "Canine") new_species.hatch_icon = 'Dog_Kid_Male_NT.dmi'
					new_species.name = "[chosenname]"
					new_species.real_name = new_species.name
					new_species.icon = new_species.hatch_icon

					 // Spawn near the player
					var/obj/items/Incubation_Egg/egg = new /obj/items/Incubation_Egg
					egg.loc=get_step(src.user, src.user.dir)
					egg.user = m

					// Calculate stats from ingredients
					var/total_strength = 0
					var/total_endurance = 0
					var/total_force = 0
					var/total_resistance = 0
					var/total_offence = 0
					var/total_defence = 0
					var/total_agility = 0
					var/total_energy = 0
					var/total_regeneration = 0
					var/total_recovery = 0

					var/total_powerlevel = 0

					var/total_pts = 0


					for(var/obj/items/item in src.ingredients)
						if(prob(50)) {total_strength += item.base_pts ; total_pts += item.base_pts}
						if(prob(50)){total_endurance += item.base_pts ; total_pts += item.base_pts}
						if(prob(50)){total_force += item.base_pts ; total_pts += item.base_pts}
						if(prob(50)){total_resistance += item.base_pts ; total_pts += item.base_pts}
						if(prob(50)){total_offence += item.base_pts ; total_pts += item.base_pts}
						if(prob(50)){total_defence += item.base_pts ; total_pts += item.base_pts}
						if(prob(50)){total_agility += item.base_pts ; total_pts += item.base_pts}
						if(prob(50)){total_energy += item.base_pts ; total_pts += item.base_pts}
						if(prob(50)){total_regeneration += item.base_pts ; total_pts += item.base_pts}
						if(prob(50)){total_recovery += item.base_pts ; total_pts += item.base_pts}
						total_powerlevel += total_pts


					new_species.mod_strength = total_strength
					new_species.mod_endurance = total_endurance
					new_species.mod_force = total_force
					new_species.mod_offence = total_offence
					new_species.mod_resistance= total_resistance
					new_species.mod_defence = total_defence
					new_species.mod_agility = total_agility
					new_species.mod_energy = total_energy
					new_species.psionic_power_base = total_powerlevel
					new_species.mod_arcane_potential = rand(1,1.8)
					new_species.mod_tech_potential = rand (1,1.4)
					new_species.max_anger = rand (130,180)
					new_species.gravity_mastered = m.gravity_mastered
					new_species.age = 13
					new_species.generation_lvl = 2
					new_species.bodysize = rand(1,3)
					new_species.race = "Magical Creature"

					egg.setspecies(new_species)
					players += new_species
					//egg.activate(egg,new_species)

					//world << "A new species, [species], has been created with unique stats."

		wool
			name = "Wool"
			icon='Wool.dmi'
			mouse_over_pointer = MOUSE_ACTIVE_POINTER
			can_pocket = 1
			//density=0
			//stacks = 1
			//density_factor=0
			act = /obj/items/wool/proc/use
			//act_drop = /obj/items/wool/proc/drop
			base_type = "Resistance"





			proc
				use(var/mob/m,var/obj/items/wool/i)
					if(!(i in m)) return
					m.open_wool_ui(i)
					/*if(i in m)
						switch(input(m,"What type of clothing will you make?") in list("Cancel","Shirt","Sleeveless Shirt","Singlet","Jacket","Sleeveless Jacket","Sleveless Trench Coat","Kai Suit","Male Underclothes","Female Underclothes","Martial Arts Uniform","Martial Arts Uniform Single Shoulder","Black Sleeveless Jacket","Hoodie","Pants","Panty","Shoes","Boots","Saiyan Boots","Wrapped Boots","Gloves","Wristbands","Belt","Sash","Kai Sash","Cape","Cape Shoulderless","Bandana","Karate Headband","Side Headband","Namekian Scarf","Turban","Glasses","Shades"))
							if("Shades")
								var/obj/items/clothing/shades/sh = new/obj/items/clothing/shades(m.loc)
								var/newcolor = input("Choose a color:") as color
								sh.icon *= newcolor
								i.use_obj(m)
								m.refresh_inv()
								m.set_alert("You created a [sh]!",'alert.dmi',"alert")
								return
							if("Glasses")
								var/obj/items/clothing/glasses/sh = new/obj/items/clothing/glasses(m.loc)
								var/newcolor = input("Choose a color:") as color
								sh.icon *= newcolor
								i.use_obj(m)
								m.refresh_inv()
								m.set_alert("You created a [sh]!",'alert.dmi',"alert")
								return
							if("Turban")
								var/icon/finali = new // Final icon
								switch(input(m,"What Size:?") in list ("Kid","Adult/Teen"))
									if("Adult/Teen")

										var/newcolor = input("Choose a color:") as color

										// Define the color you want to replace (e.g., gray or black)
										var/oldcolor = rgb(148, 148, 145) // Replace this with the color in your icon
										var/oldcolor2 = rgb(185,185,185)
										var/list/states = list(
											"", "", "KB", "Flight", "Train", "Fall", "KO",
											"2HCharge", "2HBlast", "Meditate", "Power upF", "Power up",
											"Superform", "RPunch", "LPunch", "RKick", "LKick",
											"Block", "1HCharge", "1HBlastR", "1HBlastL"
										)

										for(var/state in states)
											var/icon/base = icon('Turban.dmi', state)

											// Replace all pixels matching oldcolor with newcolor
											base.MapColors(list(oldcolor = newcolor))
											base.MapColors(list(oldcolor2 = newcolor))

											finali.Insert(base, state)
										// Create the final item with the new icon
										var/obj/items/clothing/kid_turban/sh = new/obj/items/clothing/kid_turban(m.loc)
										sh.icon = finali

										i.use_obj(m)
										m.refresh_inv()
										m.set_alert("You created a [sh]!",'alert.dmi',"alert")
										return
									if("Kid")
										var/newcolor = input("Choose a color:") as color

										// Define the color you want to replace (e.g., gray or black)
										var/oldcolor = rgb(148, 148, 145) // Replace this with the color in your icon
										var/oldcolor2 = rgb(185,185,185)
										var/list/states = list(
											"", "", "KB", "Flight", "Train", "Fall", "KO",
											"2HCharge", "2HBlast", "Meditate", "Power upF", "Power up",
											"Superform", "RPunch", "LPunch", "RKick", "LKick",
											"Block", "1HCharge", "1HBlastR", "1HBlastL"
										)

										for(var/state in states)
											var/icon/base = icon('Turban.dmi', state)

											// Replace all pixels matching oldcolor with newcolor
											base.MapColors(list(oldcolor = newcolor))
											base.MapColors(list(oldcolor2 = newcolor))

											finali.Insert(base, state)

										// Create the final item with the new icon
										var/obj/items/clothing/turban/sh = new/obj/items/clothing/turban(m.loc)
										sh.icon = finali

										i.use_obj(m)
										m.refresh_inv()
										m.set_alert("You created a [sh]!",'alert.dmi',"alert")
										return
								/*var/obj/items/clothing/turban/sh = new/obj/items/clothing/turban(m.loc)
								var/icon/ic = icon(sh.icon)
								var/newcolor = input("Choose a color:") as color

								// Example: Color only a box from (x1,y1) to (x2,y2)
								var/icon/overlay = icon(ic)
								overlay.DrawBox(newcolor, 16,25,18,28) // Draws colored box over that region

								ic.Blend(overlay, ICON_OVERLAY)
								sh.icon = ic

								//var/newcolor = input("Choose a color:") as color
								//sh.icon *= newcolor
								i.use_obj()
								m.refresh_inv()
								m.set_alert("You created a [sh]!",'alert.dmi',"alert")
								return*/
							if("Namekian Scarf")
								var/obj/items/clothing/namekian_scarf/sh = new/obj/items/clothing/namekian_scarf(m.loc)
								var/newcolor = input("Choose a color:") as color
								sh.icon *= newcolor
								i.use_obj(m)
								m.refresh_inv()
								m.set_alert("You created a [sh]!",'alert.dmi',"alert")
								return
							if("Side Headband")
								var/sze = input("What Size:?") in list ("Kid","Adult/Teen")
								if(sze == "Adult/Teen")
									var/obj/items/clothing/side_headband/sh = new/obj/items/clothing/side_headband(m.loc)
									var/newcolor = input("Choose a color:") as color
									sh.icon *= newcolor
									i.use_obj(m)
									m.refresh_inv()
									m.set_alert("You created a [sh]!",'alert.dmi',"alert")
									return
								if(sze == "Kid")
									var/obj/items/clothing/kid_side_headband/sh = new/obj/items/clothing/kid_side_headband(m.loc)
									var/newcolor = input("Choose a color:") as color
									sh.icon *= newcolor
									i.use_obj(m)
									m.refresh_inv()
									m.set_alert("You created a [sh]!",'alert.dmi',"alert")
									return
							if("Karate Headband")
								var/obj/items/clothing/karate_headband/sh = new/obj/items/clothing/karate_headband(m.loc)
								var/newcolor = input("Choose a color:") as color
								sh.icon *= newcolor
								i.use_obj(m)
								m.refresh_inv()
								m.set_alert("You created a [sh]!",'alert.dmi',"alert")
								return
							if("Bandana")
								var/obj/items/clothing/bandana/sh = new/obj/items/clothing/bandana(m.loc)
								var/newcolor = input("Choose a color:") as color
								sh.icon *= newcolor
								i.use_obj(m)
								m.refresh_inv()
								m.set_alert("You created a [sh]!",'alert.dmi',"alert")
								return
							if("Cape Shoulderless")
								var/obj/items/clothing/cape_shoulderless/sh = new/obj/items/clothing/cape_shoulderless(m.loc)
								var/newcolor = input("Choose a color:") as color
								sh.icon *= newcolor
								i.use_obj(m)
								m.refresh_inv()
								m.set_alert("You created a [sh]!",'alert.dmi',"alert")
								return
							if("Cape")
								var/obj/items/clothing/cape/sh = new/obj/items/clothing/cape(m.loc)
								var/newcolor = input("Choose a color:") as color
								sh.icon *= newcolor
								i.use_obj(m)
								m.refresh_inv()
								m.set_alert("You created a [sh]!",'alert.dmi',"alert")
								return
							if("Kai Sash")
								var/obj/items/clothing/kai_sash/sh = new/obj/items/clothing/kai_sash(m.loc)
								var/newcolor = input("Choose a color:") as color
								sh.icon *= newcolor
								i.use_obj(m)
								m.refresh_inv()
								m.set_alert("You created a [sh]!",'alert.dmi',"alert")
								return
							if("Sash")
								var/obj/items/clothing/sash/sh = new/obj/items/clothing/sash(m.loc)
								var/newcolor = input("Choose a color:") as color
								sh.icon *= newcolor
								i.use_obj(m)
								m.refresh_inv()
								m.set_alert("You created a [sh]!",'alert.dmi',"alert")
								return
							if("Belt")
								var/obj/items/clothing/belt/sh = new/obj/items/clothing/belt(m.loc)
								var/newcolor = input("Choose a color:") as color
								sh.icon *= newcolor
								i.use_obj(m)
								m.refresh_inv()
								m.set_alert("You created a [sh]!",'alert.dmi',"alert")
								return
							if("Wristbands")
								var/obj/items/clothing/wristbands/sh = new/obj/items/clothing/wristbands(m.loc)
								var/newcolor = input("Choose a color:") as color
								sh.icon *= newcolor
								i.use_obj(m)
								m.refresh_inv()
								m.set_alert("You created a [sh]!",'alert.dmi',"alert")
								return
							if("Gloves")
								var/obj/items/clothing/gloves/sh = new/obj/items/clothing/gloves(m.loc)
								var/newcolor = input("Choose a color:") as color
								sh.icon *= newcolor
								i.use_obj(m)
								m.refresh_inv()
								m.set_alert("You created a [sh]!",'alert.dmi',"alert")
								return
							if("Saiyan Boots")
								var/obj/items/clothing/saiyan_boots/sh = new/obj/items/clothing/saiyan_boots(m.loc)
								var/newcolor = input("Choose a color:") as color
								sh.icon *= newcolor
								i.use_obj(m)
								m.refresh_inv()
								m.set_alert("You created a [sh]!",'alert.dmi',"alert")
								return
							if("Boots")
								var/obj/items/clothing/boots/sh = new/obj/items/clothing/boots(m.loc)
								var/newcolor = input("Choose a color:") as color
								sh.icon *= newcolor
								i.use_obj(m)
								m.refresh_inv()
								m.set_alert("You created a [sh]!",'alert.dmi',"alert")
								return
							if("Hoodie")
								var/obj/items/clothing/hoodie/sh = new/obj/items/clothing/hoodie(m.loc)
								var/newcolor = input("Choose a color:") as color
								sh.icon *= newcolor
								i.use_obj(m)
								m.refresh_inv()
								m.set_alert("You created a [sh]!",'alert.dmi',"alert")
								return
							if("Black Sleeve Jacket")
								var/obj/items/clothing/black_sleeve_jacket/sh = new/obj/items/clothing/black_sleeve_jacket(m.loc)
								var/newcolor = input("Choose a color:") as color
								sh.icon *= newcolor
								i.use_obj(m)
								m.refresh_inv()
								m.set_alert("You created a [sh]!",'alert.dmi',"alert")
								return
							if("Martial Arts Uniform Single Shoulder")
								var/obj/items/clothing/martial_arts_uniform_single_shoulder/sh = new/obj/items/clothing/martial_arts_uniform_single_shoulder(m.loc)
								var/newcolor = input("Choose a color:") as color
								sh.icon *= newcolor
								i.use_obj(m)
								m.refresh_inv()
								m.set_alert("You created a [sh]!",'alert.dmi',"alert")
								return
							if("Martial Arts Uniform")
								var/obj/items/clothing/martial_arts_uniform/sh = new/obj/items/clothing/martial_arts_uniform(m.loc)
								var/newcolor = input("Choose a color:") as color
								sh.icon *= newcolor
								i.use_obj(m)
								m.refresh_inv()
								m.set_alert("You created a [sh]!",'alert.dmi',"alert")
								return
							if("Female Underclothes")
								var/obj/items/clothing/female_underclothes/sh = new/obj/items/clothing/female_underclothes(m.loc)
								var/newcolor = input("Choose a color:") as color
								sh.icon *= newcolor
								i.use_obj(m)
								m.refresh_inv()
								m.set_alert("You created a [sh]!",'alert.dmi',"alert")
								return
							if("Male Underclothes")
								var/obj/items/clothing/male_underclothes/sh = new/obj/items/clothing/male_underclothes(m.loc)
								var/newcolor = input("Choose a color:") as color
								sh.icon *= newcolor
								i.use_obj(m)
								m.refresh_inv()
								m.set_alert("You created a [sh]!",'alert.dmi',"alert")
								return
							if("Kai Suit")
								var/obj/items/clothing/kai_suit/sh = new/obj/items/clothing/kai_suit(m.loc)
								var/newcolor = input("Choose a color:") as color
								sh.icon *= newcolor
								i.use_obj(m)
								m.refresh_inv()
								m.set_alert("You created a [sh]!",'alert.dmi',"alert")
								return
							if("Sleeveless Trench Jacket")
								var/obj/items/clothing/sleeveless_trench_coat/sh = new/obj/items/clothing/sleeveless_trench_coat(m.loc)
								var/newcolor = input("Choose a color:") as color
								sh.icon *= newcolor
								i.use_obj(m)
								m.refresh_inv()
								m.set_alert("You created a [sh]!",'alert.dmi',"alert")
								return
							if("Sleeveless Jacket")
								var/obj/items/clothing/sleeveless_jacket/sh = new/obj/items/clothing/sleeveless_jacket(m.loc)
								var/newcolor = input("Choose a color:") as color
								sh.icon *= newcolor
								i.use_obj(m)
								m.refresh_inv()
								m.set_alert("You created a [sh]!",'alert.dmi',"alert")
								return
							if("Singlet")
								var/obj/items/clothing/singlet/sh = new/obj/items/clothing/singlet(m.loc)
								var/newcolor = input("Choose a color:") as color
								sh.icon *= newcolor
								i.use_obj(m)
								m.refresh_inv()
								m.set_alert("You created a [sh]!",'alert.dmi',"alert")
								return
							if("Sleeveless Shirt")
								var/obj/items/clothing/sleeveless_shirt/sh = new/obj/items/clothing/sleeveless_shirt(m.loc)
								var/newcolor = input("Choose a color:") as color
								sh.icon *= newcolor
								i.use_obj(m)
								m.refresh_inv()
								m.set_alert("You created a [sh]!",'alert.dmi',"alert")
								return
							if("Shirt")
								var/obj/items/clothing/shirt/sh = new/obj/items/clothing/shirt(m.loc)
								var/newcolor = input("Choose a color:") as color
								sh.icon *= newcolor
								i.use_obj(m)
								m.refresh_inv()
								m.set_alert("You created a [sh]!",'alert.dmi',"alert")
								return
							if("Pants")
								var/obj/items/clothing/pants/pt = new /obj/items/clothing/pants(m.loc)
								var/newcolor = input("Choose a color:") as color
								pt.icon *= newcolor
								i.use_obj(m)
								m.refresh_inv()
								m.set_alert("You created a [pt]!",'alert.dmi',"alert")
								return
							if("Shoes")
								var/obj/items/clothing/shoes/so = new /obj/items/clothing/shoes(m.loc)
								var/newcolor = input("Choose a color:") as color
								so.icon *= newcolor
								i.use_obj(m)
								m.refresh_inv()
								m.set_alert("You created a [so]!",'alert.dmi',"alert")
								return*/


			proc
				glow()
					while(src)
						animate(src.filters[src.filters.len], offset = 4, time = 5)
						animate(src.filters[src.filters.len], offset = 2, time = 5)
						sleep(10)
				drop(var/mob/m,var/obj/items/wool/i)
					m.drop(i)

			Click(location,control,params)
				..()
				//Removes this item from the global Items list.
				if(items)
					if(src in items) items -= src
				params = params2list(params)
				if(params["left"])
					if(isturf(src.loc))
						usr.pickup(src)
						if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up x[src.stacks] [src]","actionoutput")
					else if(ismob(src.loc))
						if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
						usr.item_selected = src
						src.overlays -= /obj/effects/select_item
						src.overlays += /obj/effects/select_item
		Hair_Dye
			info_name = "hair_dye"
			mouse_over_pointer = MOUSE_ACTIVE_POINTER
			icon = 'ScissorsHairDye.dmi'
			icon_state = "Dye"
			value = 50
			can_pocket = 1
			density_factor = 0
			weight = 1
			desc = "A liquid substance used to change to permanently change your hair color"
			act = /obj/items/Hair_Dye/proc/use
			//act_drop = /obj/items/Hair_Dye/proc/drop
			appearance_flags = KEEP_TOGETHER
			proc
				use(var/mob/m,var/obj/items/Hair_Dye/i)
					if(i in m)
						var/c  = input ("Choose a color for your hair.") as color
						if(m)
							m.hair_c = c
							winset(m,"char_creation.hair_color","background-color=[c]")
							//m.update_looks("change hair")
							m.update_looks()
							if(m.port && m.hud_char)
								//Adjust players portrait first.
								m.hud_char.update_portrait_transform()
								//Adjust players in-game avatar next.
								if(m.has_beard)
									m.update_beard_color_from_hair()
							i.stacks -= 1
							if(i.stacks <= 0) remove_item_from_inventory(m,i)
							m.refresh_inv()




				drop(var/mob/m,var/obj/items/tech/i)
					if(i in m.accessing)
						if(i.suffix)
							i.suffix = null
							i.name = "Hair Dye"

						m.drop(i)
			New()
				tag = name
				var/image/sel = image('fx.dmi',src,"select item",1000)
				src.img_select = sel

			Click(location,control,params)
				..()
				//Removes this item from the global Items list.
				if(items)
					if(src in items) items -= src
				params = params2list(params)
				if(params["left"])
					if(isturf(src.loc))
						usr.pickup(src)
						if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up x[src.stacks] [src]","actionoutput")
					else if(ismob(src.loc))
						if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
						usr.item_selected = src
						src.overlays -= /obj/effects/select_item
						src.overlays += /obj/effects/select_item
						usr.refresh_inv()
		Bedroll
			info_name = "Bedroll"
			mouse_over_pointer = MOUSE_ACTIVE_POINTER
			icon = 'BedRoll_Colorable (1).dmi'
			icon_state = ""
			value = 2000
			can_pocket = 1
			density_factor = 0
			weight = 1
			desc = "A single layered mattress best used to sleep anywhere at anytime."
			act = /obj/items/Bedroll/proc/use
			//act_drop = /obj/items/Bedroll/proc/drop
			appearance_flags = KEEP_TOGETHER
			proc
				use(var/mob/m,var/obj/items/Bedroll/i)
					if(i in m)
						src.drop(m,i)


				drop(var/mob/m,var/obj/items/Bedroll/i)
					if(i in m.accessing)
						if(i.suffix)
							i.suffix = null
							i.name = "Bedroll"

						m.drop(i)
			New()
				tag = name
				var/image/sel = image('fx.dmi',src,"select item",1000)
				src.img_select = sel

			Click(location,control,params)
				..()
				//Removes this item from the global Items list.
				if(items)
					if(src in items) items -= src
				params = params2list(params)
				if(params["left"])
					if(isturf(src.loc))
						usr.pickup(src)
						if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up x[src.stacks] [src]","actionoutput")
					else if(ismob(src.loc))
						if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
						usr.item_selected = src
						src.overlays -= /obj/effects/select_item
						src.overlays += /obj/effects/select_item
						usr.refresh_inv()
		Scissors
			info_name = "Scissors"
			mouse_over_pointer = MOUSE_ACTIVE_POINTER
			icon = 'ScissorsHairDye.dmi'
			icon_state = "Scissors"
			value = 250
			can_pocket = 1
			density_factor = 0
			weight = 1
			desc = "A reliable tool used to change your hairstyle."
			tech_tree = "Engineering"
			act = /obj/items/Scissors/proc/use
			//act_drop = /obj/items/Scissors/proc/drop
			appearance_flags = KEEP_TOGETHER
			proc
				use(var/mob/m,var/obj/items/Scissors/i)
					if(i in m)
						if(m.race == "Namekian" || m.has_hair == 0 || m.race == "Changeling" )
							m<<"You cannot use these."
							return
						var/choice = input("Select a grooming option") in list ("Cut Hair","Shave")

						if(choice == "Shave")
							if(!m.has_beard || m.beard <= 0)
								m << "You don't have any facial hair to shave."
								return

							var/list/options = list()
							switch(usr.beard)
								if(1) options = list("Shave Clean")
								if(2) options = list("Moustache", "Shave Clean")
								if(3) options = list("Goatee", "Moustache", "Shave Clean")
								if(4) options = list("Short Beard", "Goatee", "Moustache", "Shave Clean")
								if(5) options = list("Full Beard", "Short Beard", "Goatee", "Moustache", "Shave Clean")


							var/selection = input("Choose how much to shave off:") in options

							switch(selection)
								if("Shave Clean")
									m.remove_beard()
									m << "You shave your beard completely clean."
								if("Moustache")
									m.remove_beard()
									sleep(1)
									m.set_beard_stage(1)
									m << "You trim your beard down to a moustache."
								if("Goatee")
									m.remove_beard()
									sleep(1)
									m.set_beard_stage(2)
									m << "You trim your beard down to a goatee."
								if("Short Beard")
									m.remove_beard()
									sleep(1)
									m.set_beard_stage(3)
									m << "You trim your beard down to a short beard."
								if("Full Beard")
									m.remove_beard()
									sleep(1)
									m.set_beard_stage(4)
									m << "You trim your beard down to a full beard."

							m.update_beard_icon()
							m.update_portrait_beard()
							return
						else
							var/obj/h = null
							var/list/adult_list = list("Bald","Goku","Vegeta","Yamcha","Uub","Long","Afro","Raditz","Muse","Short","Spikey","Nach","Stylish Long","Yamcha GT","Kale","Female 1","Female 2","Caulifa","Vomi","Android 18","Android 17")
							var/list/kid_list = list("Bald","Goku","Vegeta","Yamcha","Uub","Long","Afro","Raditz","Muse","Short","Spikey","Stylish Long","Yamcha GT","Kale","Female 1","Female 2","Caulifa","Android 18","Android 17")
							if(m.age>=13)
								switch(input("Pick a hairstyle.") in adult_list) //("Bald","Goku","Vegeta","Yamcha","Uub","Long","Afro","Raditz","Muse","Short","Spikey","Nach","Stylish Long","Yamcha GT","Kale","Female 1","Female 2","Caulifa","Android 18","Android 17"))
									if("Bald")
										remove_overlay(m, usr.hair)
										m.hair=null
										m.vis_contents -= usr.hair
										m.hair_pos=16
									if("Goku")
										if(m.age>=13) h = hairs_male[1]
										else if(m.age<13)
											h = kid_hairs_male[1]
										m.hair_pos=1
									if("Vegeta")
										if(m.age>=13) h = hairs_male[2]
										else if(m.age<13)
											h = kid_hairs_male[2]
										m.hair_pos=2
									if("Yamcha")
										if(m.age>=13) h = hairs_male[3]
										else if(m.age<13)
											h = kid_hairs_male[3]
										m.hair_pos=3
									if("Uub")
										if(m.age>=13) h = hairs_male[4]
										else if(m.age<13)
											h = kid_hairs_male[4]
										m.hair_pos=4

									if("Long")
										if(m.age>=13) h = hairs_male[5]
										else if(m.age<13)
											h = kid_hairs_male[5]
										m.hair_pos=5
									if("Afro")
										if(m.age>=13) h = hairs_male[6]
										else if(m.age<13)
											h = kid_hairs_male[6]
										m.hair_pos=6
									if("Kidd")
										if(m.age>=13) h = hairs_male[7]
										else if(m.age<13)
											h = kid_hairs_male[7]
										m.hair_pos=7
									if("Raditz")
										if(m.age>=13) h = hairs_male[8]
										else if(m.age<13)
											h = kid_hairs_male[8]
										m.hair_pos=8
									if("Muse")
										if(m.age>=13) h = hairs_male[9]
										else if(m.age<13)
											h = kid_hairs_male[9]
										m.hair_pos=9
									if("Goten")
										if(m.age>=13) h = hairs_male[10]
										else if(m.age<13)
											h = kid_hairs_male[10]
										m.hair_pos=10
									if("Short")
										if(m.age>=13) h = hairs_male[11]
										else if(m.age<13)
											h = kid_hairs_male[11]
										m.hair_pos=11
									if("Spikey")
										if(m.age>=13) h = hairs_male[13]
										else if(m.age<13)
											h = kid_hairs_male[13]
										m.hair_pos=13
									if("Nach")
										if(m.age>=13) h = hairs_male[14]
										else if(m.age<13)
											h = kid_hairs_male[14]
										m.hair_pos=14
									if("Stylish Long")
										if(m.age>=13) h = hairs_male[15]
										else if(m.age<13)
											h = kid_hairs_male[15]
										m.hair_pos=15
									if("Yamcha GT")
										if(m.age>=13) h = hairs_male[12]
										else if(m.age<13)
											h = kid_hairs_male[12]
										usr.hair_pos=12
									if("Kale")
										if(m.age>=13) h = hairs_female[1]
										else if(m.age<13)
											h = kid_hairs_female[1]
										m.hair_pos=1
									if("Female 1")
										if(m.age>=13) h = hairs_female[3]
										else if(m.age<13)
											h = kid_hairs_female[3]
										m.hair_pos=3
									if("Female 2")
										if(m.age>=13) h = hairs_female[2]
										else if(m.age<13)
											h = kid_hairs_female[2]
										m.hair_pos=2
									if("Caulifa")
										if(m.age>=13) h = hairs_female[9]
										else if(m.age<13)
											h = kid_hairs_female[4]
										usr.hair_pos=9
									if("Vomi")
										h = hairs_male[16]
										m.hair_pos=16

									if("Android 17")
										if(m.age>=13) h = hairs_female[10]
										else if(m.age<13)
											h = kid_hairs_female[5]
										//usr.hair_pos=17
									if("Android 18")
										if(m.age>=13) h = hairs_female[11]
										else if(m.age<13)
											h = kid_hairs_female[6]
										//usr.hair_pos=18
							else if(m.age<13 && m.age>3.9)
								switch(input("Pick a hairstyle.") in kid_list)//list ("Bald","Goku","Vegeta","Yamcha","Uub","Long","Afro","Raditz","Muse","Short","Spikey","Nach","Stylish Long","Yamcha GT","Kale","Female 1","Female 2","Caulifa","Android 18","Android 17"))
									if("Bald")
										remove_overlay(m, usr.hair)
										m.hair=null
										m.vis_contents -= m.hair
										m.hair_pos=16
									if("Goku")
										if(m.age>=13) h = hairs_male[1]
										else if(m.age<13)
											h = kid_hairs_male[1]
										m.hair_pos=1
									if("Vegeta")
										if(m.age>=13) h = hairs_male[2]
										else if(m.age<13)
											h = kid_hairs_male[2]
										m.hair_pos=2
									if("Yamcha")
										if(m.age>=13) h = hairs_male[3]
										else if(m.age<13)
											h = kid_hairs_male[3]
										m.hair_pos=3
									if("Uub")
										if(m.age>=13) h = hairs_male[4]
										else if(m.age<13)
											h = kid_hairs_male[4]
										m.hair_pos=4

									if("Long")
										if(m.age>=13) h = hairs_male[5]
										else if(m.age<13)
											h = kid_hairs_male[5]
										m.hair_pos=5
									if("Afro")
										if(m.age>=13) h = hairs_male[6]
										else if(m.age<13)
											h = kid_hairs_male[6]
										m.hair_pos=6
									if("Kidd")
										if(m.age>=13) h = hairs_male[7]
										else if(m.age<13)
											h = kid_hairs_male[7]
										m.hair_pos=7
									if("Raditz")
										if(m.age>=13) h = hairs_male[8]
										else if(m.age<13)
											h = kid_hairs_male[8]
										m.hair_pos=8
									if("Muse")
										if(usr.age>=13) h = hairs_male[9]
										else if(usr.age<13)
											h = kid_hairs_male[9]
										m.hair_pos=9
									if("Goten")
										if(m.age>=13) h = hairs_male[10]
										else if(m.age<13)
											h = kid_hairs_male[10]
										m.hair_pos=10
									if("Short")
										if(m.age>=13) h = hairs_male[11]
										else if(m.age<13)
											h = kid_hairs_male[11]
										m.hair_pos=11
									if("Spikey")
										if(m.age>=13) h = hairs_male[13]
										else if(m.age<13)
											h = kid_hairs_male[13]
										m.hair_pos=13

									if("Stylish Long")
										if(m.age>=13) h = hairs_male[15]
										else if(m.age<13)
											h = kid_hairs_male[15]
										m.hair_pos=15
									if("Yamcha GT")
										if(m.age>=13) h = hairs_male[12]
										else if(m.age<13)
											h = kid_hairs_male[12]
										m.hair_pos=12
									if("Kale")
										if(m.age>=13) h = hairs_female[1]
										else if(m.age<13)
											h = kid_hairs_female[1]
										m.hair_pos=1
									if("Female 1")
										if(m.age>=13) h = hairs_female[3]
										else if(m.age<13)
											h = kid_hairs_female[3]
										m.hair_pos=3
									if("Female 2")
										if(m.age>=13) h = hairs_female[2]
										else if(m.age<13)
											h = kid_hairs_female[2]
										m.hair_pos=2
									if("Caulifa")
										if(m.age>=13) h = hairs_female[9]
										else if(m.age<13)
											h = kid_hairs_female[4]
										m.hair_pos=9

									if("Android 17")
										if(m.age>=13) h = hairs_female[10]
										else if(m.age<13)
											h = kid_hairs_female[5]
										//usr.hair_pos=17
									if("Android 18")
										if(m.age>=13) h = hairs_female[11]
										else if(m.age<13)
											h = kid_hairs_female[6]
										//usr.hair_pos=18

							if(m && usr.has_hair >= 1)
								remove_overlay(m, m.hair)
							//	m.hair=null
								//usr.vis_contents -= usr.hair
								//var/icon/E = icon(h.icon,"",SOUTH,1,0)
								var/icon/E_hair = icon(h.icon)
								E_hair.Blend(m.hair_c)
								//E.Scale(128,128)
								var/obj/new_hair = new h.type
								//new_hair.icon = E_hair
								new_hair.icon = E_hair
								m.hair = new_hair
							//	m.update_icon("change hair")
								m.overlays += m.hair
								//m.vis_contents += E_hair
								m<<"You cut your hair!"
								m.update_looks(m)
								i.use_obj(m)
								if( i && i.stacks <= 0) remove_item_from_inventory(m,i)


							//	if(usr.port && usr.hud_char)
									//Adjust players portrait first.
								//	usr.hud_char.update_portrait_transform()


				drop(var/mob/m,var/obj/items/tech/i)
					if(i in m.accessing)
						if(i.suffix)
							i.suffix = null
							i.name = "Scissors"
						i.overlays -= /obj/effects/select_item
						m.drop(i)
			New()
				tag = name
				var/image/sel = image('fx.dmi',src,"select item",1000)
				src.img_select = sel

			Click(location,control,params)
				..()
				//Removes this item from the global Items list.
				if(items)
					if(src in items) items -= src
				params = params2list(params)
				if(params["left"])
					if(isturf(src.loc))
						usr.pickup(src)
						if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up x[src.stacks] [src]","actionoutput")
					else if(ismob(src.loc))
						if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
						usr.item_selected = src
						src.overlays -= /obj/effects/select_item
						src.overlays += /obj/effects/select_item
						usr.refresh_inv()
		Wood
			name = "Wood"
			icon='roomobj.dmi'
			icon_state="firewood"
			mouse_over_pointer = MOUSE_ACTIVE_POINTER
			can_pocket = 1
			density=0
			desc = "Timberrrrr!"
			density_factor=0
			act = /obj/items/Wood/proc/use
			//act_drop = /obj/items/Wood/proc/drop
			base_type = "Resistance"




			proc
				use(var/mob/m,var/obj/items/Wood/i)
					if(i in m)
						if(i.stacks<=1)
							m.set_alert("You need more wood to make something!",'alert.dmi',"alert")
							return
						if(i.stacks>=3 && i.stacks <10)
							var/obj/enviornment/Campfire/cf = new /obj/enviornment/Campfire
							cf.loc=m.loc
							i.stacks -=2
							i.use_obj(m)
							m.refresh_inv()
							m.set_alert("You created a Campfire!",'alert.dmi',"alert")
							return
						if(i.stacks>=10)
							switch(alert(m,"What will you create?","","Campfire","Chopping Board"))
								if("Campfire")
									var/obj/enviornment/Campfire/cf = new /obj/enviornment/Campfire
									cf.loc=m.loc
									i.stacks -=2
									i.use_obj(m)
									m.refresh_inv()
									m.set_alert("You created a Campfire!",'alert.dmi',"alert")

									return
								if("Chopping Board")
									var/obj/items/Chopping_Board/cb = new /obj/items/Chopping_Board
									cb.loc=m.loc
									i.stacks -=9
									i.use_obj(m)
									m.refresh_inv()
									m.set_alert("You created a Chopping Board!",'alert.dmi',"alert")
									return

			proc
				glow()
					while(src)
						animate(src.filters[src.filters.len], offset = 4, time = 5)
						animate(src.filters[src.filters.len], offset = 2, time = 5)
						sleep(10)
				drop(var/mob/m,var/obj/items/i)

					m.drop(i)
					i.overlays -= /obj/effects/select_item

			Click(location,control,params)
				..()
				//Removes this item from the global Items list.
				if(items)
					if(src in items) items -= src
				params = params2list(params)
				if(params["left"])
					if(isturf(src.loc))
						usr.pickup(src)
						if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up x[src.stacks] [src]","actionoutput")
					else if(ismob(src.loc))
						if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
						usr.item_selected = src
						src.overlays -= /obj/effects/select_item
						src.overlays += /obj/effects/select_item
						usr.refresh_inv()
		skins
			Torso
				name = "Torso"
				icon = 'Torso.dmi'
				icon_state = ""
				rarity = 1
				can_cook=1
				desc = "The torso of someone's."
				//act = /obj/items/consumables/food/raw_steak/proc/use
				act_drop = /obj/items/consumables/food/raw_steak/proc/drop
				//Toxic buildup from taking drug
			//	toxic = 1
				//toxin_gain = 0.0001
			//	toxicity = 15
				base_type = "Strength"
				duration = 9000
				food=1
				//cooked_type = /obj/items/consumables/food/cooked_steak
				//Duration in 1/10 seconds

				//Does the drug have a comedown or not, and how long does it last

				//Changed permanently when taken
			//	hydro_gain = 55
				//metab_gain = 10

				//Changed temporarily when taken

				//Changed temporarily when wears off
				proc
					use(var/mob/m,var/obj/items/i)
						if(i in m)
							if(m.has_stomach == 0)
								m.set_alert("Unable to digest food",'alert.dmi',"alert")
								return

							if(m.hunger > 99)
								m.set_alert("Already full",'alert.dmi',"alert")
								return
							if(m.eating)
								m.set_alert("Already eating",'alert.dmi',"alert")
								return
							var/T = world.time
							i.apply_item_stats(m,T)
							if(i && m && i.loc == m && i.stacks > 0 && i == m.eating && i.time_eaten == T)
								i.use_obj(m)
								m.refresh_inv()
								if(m) m.eating = null
					drop(var/mob/m,var/obj/items/i)
						m.drop(i)
				New()
					..()
				//	src.desc_extra = "[src.create_item_desc()]\n\n"
				Click(location,control,params)
					..()
					//Removes this item from the global Items list.
					if(items)
						if(src in items) items -= src
					params = params2list(params)
					if(params["left"])
						if(isturf(src.loc))
							usr.pickup(src)
							if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up x[src.stacks] [src]","actionoutput")
						else if(ismob(src.loc))
							if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
							usr.item_selected = src
							src.overlays -= /obj/effects/select_item
							src.overlays += /obj/effects/select_item
							usr.refresh_inv()
			Head
				name = "Head"
				icon = 'Head.dmi'
				icon_state = ""
				rarity = 1
				can_cook=1
				desc = "The head of someone's."
				//act = /obj/items/consumables/food/raw_steak/proc/use
				act_drop = /obj/items/consumables/food/raw_steak/proc/drop
				//Toxic buildup from taking drug
			//	toxic = 1
				//toxin_gain = 0.0001
			//	toxicity = 15
				base_type = "Strength"
				duration = 9000
				food=1
				//cooked_type = /obj/items/consumables/food/cooked_steak
				//Duration in 1/10 seconds

				//Does the drug have a comedown or not, and how long does it last

				//Changed permanently when taken
			//	hydro_gain = 55
				//metab_gain = 10

				//Changed temporarily when taken

				//Changed temporarily when wears off
				proc
					use(var/mob/m,var/obj/items/i)
						if(i in m)
							if(m.has_stomach == 0)
								m.set_alert("Unable to digest food",'alert.dmi',"alert")
								return

							if(m.hunger > 99)
								m.set_alert("Already full",'alert.dmi',"alert")
								return
							if(m.eating)
								m.set_alert("Already eating",'alert.dmi',"alert")
								return
							var/T = world.time
							i.apply_item_stats(m,T)
							if(i && m && i.loc == m && i.stacks > 0 && i == m.eating && i.time_eaten == T)
								i.use_obj(m)
								m.refresh_inv()
								if(m) m.eating = null
					drop(var/mob/m,var/obj/items/i)
						m.drop(i)
				New()
					..()
				//	src.desc_extra = "[src.create_item_desc()]\n\n"
				Click(location,control,params)
					..()
					//Removes this item from the global Items list.
					if(items)
						if(src in items) items -= src
					params = params2list(params)
					if(params["left"])
						if(isturf(src.loc))
							usr.pickup(src)
							if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up x[src.stacks] [src]","actionoutput")
						else if(ismob(src.loc))
							if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
							usr.item_selected = src
							src.overlays -= /obj/effects/select_item
							src.overlays += /obj/effects/select_item
							usr.refresh_inv()
			Right_Leg
				name = "Right Leg"
				icon = 'Right_Leg_Colorable.dmi'
				icon_state = ""
				rarity = 1
				can_pocket=1
				desc = "The right leg of someone's."
				//act = /obj/items/consumables/food/raw_steak/proc/use
				act = /obj/items/skins/Right_Leg/proc/drop
				act_drop = /obj/items/skins/Right_Leg/proc/drop
				//Toxic buildup from taking drug
			//	toxic = 1
				//toxin_gain = 0.0001
			//	toxicity = 15
				base_type = "Strength"
				duration = 9000
				food=1
				//cooked_type = /obj/items/consumables/food/cooked_steak
				//Duration in 1/10 seconds

				//Does the drug have a comedown or not, and how long does it last

				//Changed permanently when taken
			//	hydro_gain = 55
				//metab_gain = 10

				//Changed temporarily when taken

				//Changed temporarily when wears off
				proc
					use(var/mob/m,var/obj/items/i)
						if(i in m)
							if(m.has_stomach == 0)
								m.set_alert("Unable to digest food",'alert.dmi',"alert")
								return

							if(m.hunger > 99)
								m.set_alert("Already full",'alert.dmi',"alert")
								return
							if(m.eating)
								m.set_alert("Already eating",'alert.dmi',"alert")
								return
							var/T = world.time
							i.apply_item_stats(m,T)
							if(i && m && i.loc == m && i.stacks > 0 && i == m.eating && i.time_eaten == T)
								i.use_obj(m)
								m.refresh_inv()
								if(m) m.eating = null
					drop(var/mob/m,var/obj/items/i)
						m.drop(i)
				New()
					..()
				//	src.desc_extra = "[src.create_item_desc()]\n\n"
				Click(location,control,params)
					..()
					//Removes this item from the global Items list.
					if(items)
						if(src in items) items -= src
					params = params2list(params)
					if(params["left"])
						if(isturf(src.loc))
							usr.pickup(src)
							if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up x[src.stacks] [src]","actionoutput")
						else if(ismob(src.loc))
							if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
							usr.item_selected = src
							src.overlays -= /obj/effects/select_item
							src.overlays += /obj/effects/select_item
							usr.refresh_inv()
			Left_Leg
				name = "Left Leg"
				rarity = 1
				can_pocket=1
				desc = "The left leg of someone's."

				act = /obj/items/skins/Left_Leg/proc/drop
				act_drop = /obj/items/skins/Left_Leg/proc/drop
				base_type = "Strength"
				duration = 9000
				food=1
				proc

					drop(var/mob/m,var/obj/items/i)
						m.drop(i)
				New()
					..()
				//	src.desc_extra = "[src.create_item_desc()]\n\n"
				Click(location,control,params)
					..()
					//Removes this item from the global Items list.
					if(items)
						if(src in items) items -= src
					params = params2list(params)
					if(params["left"])
						if(isturf(src.loc))
							usr.pickup(src)
							if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up x[src.stacks] [src]","actionoutput")
						else if(ismob(src.loc))
							if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
							usr.item_selected = src
							src.overlays -= /obj/effects/select_item
							src.overlays += /obj/effects/select_item
							usr.refresh_inv()
			Right_Arm
				name = "Right Arm"

				rarity = 1
				can_pocket=1
				desc = "The right arm of someone's."

				act = /obj/items/skins/Right_Arm/proc/drop
				act_drop = /obj/items/skins/Right_Arm/proc/drop

				base_type = "Strength"
				duration = 9000
				food=1

				proc

					drop(var/mob/m,var/obj/items/i)
						m.drop(i)
				New()
					..()
				//	src.desc_extra = "[src.create_item_desc()]\n\n"
				Click(location,control,params)
					..()
					//Removes this item from the global Items list.
					if(items)
						if(src in items) items -= src
					params = params2list(params)
					if(params["left"])
						if(isturf(src.loc))
							usr.pickup(src)
							if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up x[src.stacks] [src]","actionoutput")
						else if(ismob(src.loc))
							if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
							usr.item_selected = src
							src.overlays -= /obj/effects/select_item
							src.overlays += /obj/effects/select_item
							usr.refresh_inv()
			Left_Arm
				name = "Left Arm"

				rarity = 1
				can_pocket=1
				desc = "The left arm of someone's."
				act = /obj/items/skins/Left_Arm/proc/drop
				act_drop = /obj/items/skins/Left_Arm/proc/drop
				//Toxic buildup from taking drug
			//	toxic = 1
				//toxin_gain = 0.0001
			//	toxicity = 15
				base_type = "Strength"
				duration = 9000
				food=1



				proc

					drop(var/mob/m,var/obj/items/i)
						m.drop(i)
				New()
					..()
				//	src.desc_extra = "[src.create_item_desc()]\n\n"
				Click(location,control,params)
					..()
					//Removes this item from the global Items list.
					if(items)
						if(src in items) items -= src
					params = params2list(params)
					if(params["left"])
						if(isturf(src.loc))
							usr.pickup(src)
							if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up x[src.stacks] [src]","actionoutput")
						else if(ismob(src.loc))
							if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
							usr.item_selected = src
							src.overlays -= /obj/effects/select_item
							src.overlays += /obj/effects/select_item
							usr.refresh_inv()
		minerals
			invul_melee = 0
			mouse_over_pointer = MOUSE_ACTIVE_POINTER
			hashadow=1
			//hp = 9999999
			legendary = 0
			rarity = 0
			density=0
			density_factor=0

			Stone
				name = "Stone"
				icon = 'Mineral Rocks.dmi'
				icon_state = "stone"
				can_pocket = 1
				//act_drop = /obj/items/minerals/Stone/proc/drop
				base_type = "Endurance"
				base_pts = 0.01
				rarity = 0
				tech_lvl = 1
				desc = "A very common material"
				proc
					glow()
						while(src)
							animate(src.filters[src.filters.len], offset = 4, time = 5)
							animate(src.filters[src.filters.len], offset = 2, time = 5)
							sleep(10)
					drop(var/mob/m,var/obj/items/i)

						m.drop(i)
						i.overlays -= /obj/effects/select_item
				Click(location,control,params)
					..()
					//Removes this item from the global Items list.
					if(items)
						if(src in items) items -= src
					params = params2list(params)
					if(params["left"])
						if(isturf(src.loc))
							usr.pickup(src)
							if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up x[src.stacks] [src]","actionoutput")
						else if(ismob(src.loc))
							if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
							usr.item_selected = src
							src.overlays -= /obj/effects/select_item
							src.overlays += /obj/effects/select_item
			Silver
				name = "Silver"
				icon = 'Mineral Rocks.dmi'
				icon_state = "silver"
				can_pocket = 1
				//act_drop = /obj/items/minerals/Silver/proc/drop
				base_type = "Recovery"
				base_pts = 0.01
				rarity=1
				tech_lvl = 2
				desc = " A slightly common material"
				proc
					glow()
						while(src)
							animate(src.filters[src.filters.len], offset = 4, time = 5)
							animate(src.filters[src.filters.len], offset = 2, time = 5)
							sleep(10)
					drop(var/mob/m,var/obj/items/i)

						m.drop(i)
						i.overlays -= /obj/effects/select_item

				Click(location,control,params)
					..()
					//Removes this item from the global Items list.
					if(items)
						if(src in items) items -= src
					params = params2list(params)
					if(params["left"])
						if(isturf(src.loc))
							usr.pickup(src)
							if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up x[src.stacks] [src]","actionoutput")
						else if(ismob(src.loc))
							if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
							usr.item_selected = src
							src.overlays -= /obj/effects/select_item
							src.overlays += /obj/effects/select_item
			Copper
				name = "Copper"
				icon = 'Mineral Rocks.dmi'
				icon_state = "copper"
				can_pocket = 1
			//	act_drop = /obj/items/minerals/Copper/proc/drop
				base_type = "Resistance"
				base_pts = 0.01
				rarity=0
				tech_lvl = 3
				desc = "A very common material"
				proc
					glow()
						while(src)
							animate(src.filters[src.filters.len], offset = 4, time = 5)
							animate(src.filters[src.filters.len], offset = 2, time = 5)
							sleep(10)
					drop(var/mob/m,var/obj/items/i)

						m.drop(i)
						i.overlays -= /obj/effects/select_item
				Click(location,control,params)
					..()
					//Removes this item from the global Items list.
					if(items)
						if(src in items) items -= src
					params = params2list(params)
					if(params["left"])
						if(isturf(src.loc))
							usr.pickup(src)
							if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up x[src.stacks] [src]","actionoutput")
						else if(ismob(src.loc))
							if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
							usr.item_selected = src
							src.overlays -= /obj/effects/select_item
							src.overlays += /obj/effects/select_item
			Coal

				name = "Coal"
				icon = 'Mineral Rocks.dmi'
				icon_state = "coal"
				can_pocket = 1
			//	act_drop = /obj/items/minerals/Coal/proc/drop
				base_type = "Force"
				base_pts = 0.01
				rarity = 1
				tech_lvl = 4
				desc = "A slightly common material"
				proc
					glow()
						while(src)
							animate(src.filters[src.filters.len], offset = 4, time = 5)
							animate(src.filters[src.filters.len], offset = 2, time = 5)
							sleep(10)
					drop(var/mob/m,var/obj/items/i)

						m.drop(i)
						i.overlays -= /obj/effects/select_item

				Click(location,control,params)
					..()
					//Removes this item from the global Items list.
					if(items)
						if(src in items) items -= src
					params = params2list(params)
					if(params["left"])
						if(isturf(src.loc))
							usr.pickup(src)
							if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up x[src.stacks] [src]","actionoutput")
						else if(ismob(src.loc))
							if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
							usr.item_selected = src
							src.overlays -= /obj/effects/select_item
							src.overlays += /obj/effects/select_item
			Gold
				name = "Gold"
				icon = 'Mineral Rocks.dmi'
				icon_state = "gold"
				can_pocket = 1
			//	act_drop = /obj/items/minerals/Gold/proc/drop
				base_type = "Regeneration"
				base_pts = 0.01
				rarity =2
				tech_lvl = 5
				desc = "A less common material"
				proc
					glow()
						while(src)
							animate(src.filters[src.filters.len], offset = 4, time = 5)
							animate(src.filters[src.filters.len], offset = 2, time = 5)
							sleep(10)
					drop(var/mob/m,var/obj/items/i)
						m.drop(i)
						i.overlays -= /obj/effects/select_item

				Click(location,control,params)
					..()
					//Removes this item from the global Items list.
					if(items)
						if(src in items) items -= src
					params = params2list(params)
					if(params["left"])
						if(isturf(src.loc))
							usr.pickup(src)
							if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up x[src.stacks] [src]","actionoutput")
						else if(ismob(src.loc))
							if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
							usr.item_selected = src
							src.overlays -= /obj/effects/select_item
							src.overlays += /obj/effects/select_item
			Mystille
				name = "Mystille"
				icon = 'Mineral Rocks.dmi'
				icon_state = "mystille"
				can_pocket = 1
			//	act_drop = /obj/items/minerals/Mystille/proc/drop
				base_type = "Defence"
				base_pts = 0.01
				rarity = 3
				tech_lvl = 6
				desc = "A rare material"

				proc
					glow()
						while(src)
							animate(src.filters[src.filters.len], offset = 4, time = 5)
							animate(src.filters[src.filters.len], offset = 2, time = 5)
							sleep(10)
					drop(var/mob/m,var/obj/items/i)

						m.drop(i)
						i.overlays -= /obj/effects/select_item

				Click(location,control,params)
					..()
					//Removes this item from the global Items list.
					if(items)
						if(src in items) items -= src
					params = params2list(params)
					if(params["left"])
						if(isturf(src.loc))
							usr.pickup(src)
							if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up x[src.stacks] [src]","actionoutput")
						else if(ismob(src.loc))
							if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
							usr.item_selected = src
							src.overlays -= /obj/effects/select_item
							src.overlays += /obj/effects/select_item
			Titanium
				name = "Titanium"
				icon = 'Mineral Rocks.dmi'
				icon_state = "titanium"
				can_pocket = 1
			//	act_drop = /obj/items/minerals/Titanium/proc/drop
				base_type = "Offence"
				base_pts = 0.01
				rarity = 2
				tech_lvl = 7
				desc = "A less common material"
				proc
					glow()
						while(src)
							animate(src.filters[src.filters.len], offset = 4, time = 5)
							animate(src.filters[src.filters.len], offset = 2, time = 5)
							sleep(10)

					drop(var/mob/m,var/obj/items/i)

						m.drop(i)
						i.overlays -= /obj/effects/select_item

				Click(location,control,params)
					..()
					//Removes this item from the global Items list.
					if(items)
						if(src in items) items -= src
					params = params2list(params)
					if(params["left"])
						if(isturf(src.loc))
							usr.pickup(src)
							if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up x[src.stacks] [src]","actionoutput")
						else if(ismob(src.loc))
							if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
							usr.item_selected = src
							src.overlays -= /obj/effects/select_item
							src.overlays += /obj/effects/select_item
		environmental
			invul_melee = 1
			tornado
			gravitational_anomaly //Make these randomly teleport about the map for players to find, last for a while before moving again.
			psionic_storm //Same as grav anomaly, gives force when you sit inside it.
			portal_left
				density_factor = 0
				density = 0;
				bolted = 2
				go_x = 478;
				go_y = null;
				go_z = null;
			portal_right
				density_factor = 0
				density = 0;
				bolted = 2
				go_x = 2;
				go_y = null;
				go_z = null;
			portal_up
				density_factor = 0
				density = 0;
				bolted = 2
				go_x = null;
				go_y = 2;
				go_z = null;
			portal_down
				density_factor = 0
				density = 0;
				bolted = 2
				go_x = null;
				go_y = 478;
				go_z = null;
			psi_realm_flux_point
				bolted = 2
				radius = 9;
				New()
					var/obj/O = new(src.loc)
					O.particles = new
					O.particles.position = generator("box", list(-100, -100, 5), list(100,100,5), UNIFORM_RAND)
					O.particles.transform = list(1, 0, 0, 0,   0, 1, 0, 0,   0, 0, -1, -1,   0, 0, 0, 0)
					O.particles.count = 1000
					O.particles.spawning = 10
					O.particles.lifespan = 100
					O.particles.gravity = list(0,0,-0.002)
					O.particles.width = 32 * 6 * 2
					O.particles.height = 32 * 6 * 2
					O.particles.fadein = 50
					O.particles.fade = 10
					O.invisibility = 1
					O.plane = 1

					var/obj/rays = new
					rays.icon = 'fx_ray_large.dmi'
					rays.pixel_x = -284
					rays.pixel_y = -284
					rays.loc = src.loc
					rays.bolted = 2
					rays.filters += filter(type="rays",x=0,y=0,size=300,color=rgb(102,0,204),offset=0,density=15,threshold=0.5,factor=0,flags=FILTER_OVERLAY)
					animate(rays.filters[1],offset = 100,time = 1000, loop = -1)
					animate(offset = 0,time = 0)

					//var/obj/effects/soul_energy/s = new
					//s.loc = src.loc
					//s.invisibility = 1
					spawn(15)
						if(src) src.energy_field()
			neutron_field
				icon = 'neutron_field.dmi'
				density_factor = 0
				density = 0;
				pixel_x = -144;
				pixel_y = -144;
				bounds = "-144,-144,176,176"
				bolted = 2
				//plane = 3;
				radius = 5;
				i_width = 320;
				i_height = 320;
				mouse_opacity = 0;
				hp = 9999999
				appearance_flags = KEEP_TOGETHER
				New()
					..()
					src.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(155,255,255))
					src.filters += filter(type="bloom", threshold=rgb(0,0,0), size = 6,offset=1,alpha = 175)
					animate(src, transform = matrix()*1.1, time = 10, loop = -1)
					animate(transform = matrix()*1, time = 10)
			neutron_sphere
				icon = 'neutron_something.dmi'
				density_factor = 0
				density = 0;
				pixel_x = -144;
				pixel_y = -144;
				bounds = "-144,-144,176,176"
				bolted = 2
				//plane = 3;
				radius = 7;
				i_width = 320;
				i_height = 320;
				mouse_opacity = 0;
				hp = 9999999
				appearance_flags = KEEP_TOGETHER
				New()
					..()
					src.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(155,255,255))
					src.filters += filter(type="bloom", threshold=rgb(0,0,0), size = 6,offset=1,alpha = 175)
					animate(src, transform = matrix()*1.1, time = 10, loop = -1)
					animate(transform = matrix()*1, time = 10)

					animate(transform = turn(matrix(), 120), time = 2, loop = -1,flags = ANIMATION_PARALLEL)
					animate(transform = turn(matrix(), 240), time = 2)
					animate(transform = null, time = 2)
					spawn(10)
						if(src)
							for(var/turf/t in range(src.radius,src))
								t.microwaves = -1
							var/obj/rays = new
							rays.icon = 'fx_ray_large.dmi'
							rays.pixel_x = -284
							rays.pixel_y = -284
							rays.loc = src.loc
							rays.bolted = 2
							rays.filters += filter(type="rays",x=0,y=0,size=300,color=rgb(200,255,255),offset=0,density=15,threshold=0.5,factor=0,flags=FILTER_OVERLAY)
							animate(rays.filters[1],offset = 100,time = 1000, loop = -1)
							animate(offset = 0,time = 0)

							while(src)
								for(var/obj/items/tech/Bio_Rejuvination_Tank/tnk in range(src.radius,src))
									tnk.flash_red()
									tnk.shake()
									tnk.hp -= 5
									if(tnk.hp <= 0) tnk.destroy()
								for(var/mob/x in view(src.radius,src))
									if(x.debuff_exalted)
										if(x.skill_active_meditation == null || x.skill_active_meditation && x.skill_active_meditation.active == 0)
											if(x.skill_meditation == null || x.skill_meditation && x.skill_meditation.active == 0)
												x.debuff_exalted.active = 1
												x.blinding_light = 1
												for(var/obj/body_related/bodyparts/head/hd in x.bodyparts)
													for(var/obj/body_related/bodyparts/head/left_eye/le in hd)
														x.damage_limb(x,0, 1, 0.2*x.mod_regeneration,le)
														break
													for(var/obj/body_related/bodyparts/head/right_eye/re in hd)
														x.damage_limb(x,0, 1, 0.2*x.mod_regeneration,re)
														break
								sleep(10)

					//animate(transform = turn(matrix(), 120), time = 4,loop = -1, flags = ANIMATION_PARALLEL)
					//animate(transform = turn(matrix(), 240), time = 4)
			portals
				New()
					..()
					src.waves()
					spawn(100)
						if(src)
							animate(src, transform = matrix()*1.075, time = 10, loop = -1,flags=ANIMATION_PARALLEL)
							animate(transform = matrix()*1, time = 10)

							var/obj/t = new
							t.bolted = 2
							t.loc = src.loc
							t.step_x = -16;
							t.step_y = -16;

							var/xx = src.go_x
							var/yy = src.go_y
							var/zz = src.go_z
							t.vis_contents += locate(xx,yy,zz)
							t.vis_contents += locate(xx+1,yy,zz)
							t.vis_contents += locate(xx,yy+1,zz)
							t.vis_contents += locate(xx+1,yy+1,zz)
							//t.layer = 300;

							var/obj/i = new
							i.icon = 'portal.dmi'
							i.icon_state = "solid"
							i.loc = src.loc
							i.bolted = 2;
							i.pixel_x = -48;
							i.pixel_y = -48;
							i.alpha = 100
							i.transform *= 0.1
							animate(i, transform = matrix()*1.75,alpha = 0, time = 10, loop = -1)




				portal_cp_to_hell
					icon = 'portal.dmi'
					icon_state = "ring"
					density_factor = 0
					density = 0;
					bolted = 2
					pixel_x = -48;
					pixel_y = -48;
					bounds = "-48,-48 to 80,80"
					plane = 29;
					radius = 5;
					go_x = 282;
					go_y = 86;
					go_z = 6;
				portal_wastes_to_heaven
					icon = 'portal.dmi'
					icon_state = "ring"
					density_factor = 0
					density = 0;
					bolted = 2
					pixel_x = -48;
					pixel_y = -48;
					bounds = "-48,-48 to 80,80"
					plane = 29;
					radius = 5;
					go_x = 380;
					go_y = 15;
					go_z = 2;
				portal_hell_to_cp
					icon = 'portal.dmi'
					icon_state = "ring"
					density_factor = 0
					density = 0;
					bolted = 2
					pixel_x = -48;
					pixel_y = -48;
					bounds = "-48,-48 to 80,80"
					plane = 29;
					radius = 5;
					go_x = 64;
					go_y = 362;
					go_z = 2;
				portal_cp_to_dark_realm
					name = "Portal to Demon Realm"
					icon = 'portal.dmi'
					icon_state = "ring"
					density_factor = 0
					density = 0;
					bolted = 2
					pixel_x = -48;
					pixel_y = -48;
					bounds = "-48,-48 to 80,80"
					plane = 29;
					radius = 5;
					go_x = 231;
					go_y = 71;
					go_z = 12;
					sealed = 0

				portal_dark_realm_to_hfil
					name = "Portal to HFIL"
					icon = 'portal.dmi'
					icon_state = "ring"
					density_factor = 0
					density = 0;
					bolted = 2
					pixel_x = -48;
					pixel_y = -48;
					bounds = "-48,-48 to 80,80"
					plane = 29;
					radius = 5;
					go_x = 389;
					go_y = 222;
					go_z = 6;
					sealed = 0

				portal_cp_to_heaven
					icon = 'portal.dmi'
					name = "Portal to Heaven"
					icon_state = "ring"
					density_factor = 0
					density = 0;
					bolted = 2
					pixel_x = -48;
					pixel_y = -48;
					bounds = "-48,-48 to 80,80"
					plane = 29;
					radius = 5;
					go_x = 253;
					go_y = 20;
					go_z = 11;
				portal_heaven_to_cp
					icon = 'portal.dmi'
					icon_state = "ring"
					name = "Portal to Checkpoint"
					density_factor = 0
					density = 0;
					bolted = 2
					pixel_x = -48;
					pixel_y = -48;
					bounds = "-48,-48 to 80,80"
					plane = 29;
					radius = 5;
					go_x = 26;
					go_y = 462;
					go_z = 2;
				portal_wastes_to_earth
					icon = 'portal.dmi'
					icon_state = "ring"
					name = "Portal"
					density_factor = 0
					density = 0;
					bolted = 2
					pixel_x = -48;
					pixel_y = -48;
					bounds = "-48,-48 to 80,80"
					plane = 29;
					radius = 5;
					go_x = 100;
					go_y = 100;
					go_z = 1;
			psionic_ring
				icon = 'psionic_portal.dmi'
				icon_state = "ring"
				density_factor = 0
				density = 0;
				bolted = 2
				pixel_x = -48;
				pixel_y = -48;
				bounds = "-48,-48 to 80,80"
				plane = 29;
				radius = 5;
				New()
					animate(src, transform = matrix()*1.1, time = 10, loop = -1)
					animate(transform = matrix()*1, time = 10)
					//animate(transform = turn(matrix(), 120), time = 4,loop = -1, flags = ANIMATION_PARALLEL)
					//animate(transform = turn(matrix(), 240), time = 4)
			psionic_crystal
				icon = 'psionic_portal.dmi'
				icon_state = "crystal"
				density_factor = 0
				density = 0;
				bolted = 2
				pixel_x = -48;
				pixel_y = -48;
				bounds = "-48,-48 to 80,80"
				plane = 2;
				radius = 5;
				New()
					animate(src, transform = matrix()*1.1, time = 10, loop = -1)
					animate(transform = matrix()*1, time = 10)
					//animate(transform = turn(matrix(), 120), time = 4,loop = -1, flags = ANIMATION_PARALLEL)
					//animate(transform = turn(matrix(), 240), time = 4)
			Containment_Tornado
				icon = 'containment_wave.dmi'
				icon_state = "" // Your pulsating tornado state
				layer = FLOAT_LAYER
				pixel_x = -48
				pixel_y = -48
				bounds = "-48,-48 to 80,80"
				appearance_flags = TILE_BOUND
				density = 0
				radius = 5
				var/lifetime = 150 // 15 seconds


				New()
					..()

					spawn()
						pulse_effect()
					spawn()
						abduct_loop()

					spawn(lifetime)
						if(src) src.destroy()

				proc/pulse_effect()
					while(src)
						animate(src, transform = matrix(1.5, 1, MATRIX_SCALE), time = 5)
						animate(transform = matrix(0.7, 1, MATRIX_SCALE), time = 5)
						sleep(1)

				proc/abduct_loop()
					while(src)
						for(var/mob/M in range(radius, src))
							//if(M.skill_containment_wave.active)
							M.icon_state = "2HBlast"
							if(M.target)

								if(M.target.aura_alignment <= 0 && !M.koed)
									abduct_player(M.target)
						sleep(3)

				proc/abduct_player(var/mob/M)
					var/matrix/twist = matrix()
					twist.Scale(0.7, 1)
					twist.Turn(rand(15, 45))

					if(prob(50)) M.set_alert("You feel your body spiraling out of control!")
					M.stunned += 1
				//	M.frozen += 1
					M.dir = get_dir(M, src)

					spawn()
						var/pull_duration = 20
						for(var/i = 0; i < pull_duration; i++)
							step_towards(M, src)
							M.transform = twist
							twist.Scale(1 + i * 0.01, 1) // smooth in-pull
							sleep(10)
							twist.Scale(1,1) //
							twist.Turn(1,1)
						if(M.transform!=twist) M.transform = twist
						M.transform = null
						M.stunned -= 1
					//	M.frozen -= 1
					//	M.loc = locate(rand(10, 450), rand(10, 450), 18)
					//	M << "<font color=red>You have been sealed inside the containment realm!"

			blackhole2
				icon = 'blackhole.dmi'
				density_factor = 0
				density = 0;
				bolted = 2
				pixel_x = -48;
				pixel_y = -48;
				plane = 29
				bounds = "-48,-48 to 80,80"
				//plane = 1;
				radius = 5;
				appearance_flags = TILE_BOUND
				hp = 9999999
				var/grown = 1
				Cross(mob/m)
					..()
					if(ismob(m))
						m.last_x = rand(10,460)
						m.last_y = rand(10,460)
						m.last_z = m.z
						sleep(0.1)
						m.loc=locate(20,198,18)






				proc
					spin()
						animate(src, transform = matrix()*1.1, time = 10, loop = -1, flags = ANIMATION_PARALLEL)
						animate(transform = matrix()*1, time = 10)
						animate(transform = turn(matrix(), 120), time = 4,loop = -1, flags = ANIMATION_PARALLEL)
						animate(transform = turn(matrix(), 240), time = 4)
						animate(transform = null, time = 4)
				New()
					spawn(10)
						src.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(102,0,204))
						src.filters += filter(type="bloom", threshold=rgb(0,0,0), size = 6,offset=1,alpha = 175)
						if(src)
							//for(var/turf/t in range(src.radius,src))
							//	t.grav = -1
							if(src.grown)
								animate(src, transform = matrix()*1.1, time = 10, loop = -1)
								animate(transform = matrix()*1, time = 10)
								animate(transform = turn(matrix(), 120), time = 4,loop = -1, flags = ANIMATION_PARALLEL)
								animate(transform = turn(matrix(), 240), time = 4)
								animate(transform = null, time = 4)
								var/p = 33
								while(p)
									if(prob(25))
										sleep(1)
									p -= 1;
									var/obj/pix = new
									pix.icon = 'fx.dmi'
									pix.icon_state = "pixel"
									pix.loc = src.loc
									pix.step_x = src.step_x
									pix.step_y = src.step_y
									pix.pixel_x = rand(-200,200)
									pix.pixel_y = rand(-200,200)
									pix.bolted = 2
									animate(pix,pixel_x = 0, pixel_y = 0, time = rand(5,10), alpha = 0,loop = -1)
									animate(pixel_x = rand(-200,200), pixel_y = rand(-200,200), time = 0, alpha = 255)
									sleep(0.1)
							while(src)
								for(var/obj/items/tech/tch in range(src.radius,src))
									tch.flash_red()
									tch.shake()
									tch.hp -= 5
									if(tch.hp <= 0) tch.destroy()
								sleep(10)
					spawn(300)
						if(src)
							src.destroy()

			blackhole
				icon = 'blackhole.dmi'
				density_factor = 0
				density = 0;
				bolted = 2
				pixel_x = -48;
				pixel_y = -48;
				plane = 29
				bounds = "-48,-48 to 80,80"
				//plane = 1;
				radius = 5;
				appearance_flags = TILE_BOUND
				hp = 9999999
				var/grown = 1
				proc
					spin()
						animate(src, transform = matrix()*1.1, time = 10, loop = -1, flags = ANIMATION_PARALLEL)
						animate(transform = matrix()*1, time = 10)
						animate(transform = turn(matrix(), 120), time = 4,loop = -1, flags = ANIMATION_PARALLEL)
						animate(transform = turn(matrix(), 240), time = 4)
						animate(transform = null, time = 4)
				New()
					spawn(10)
						src.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(102,0,204))
						src.filters += filter(type="bloom", threshold=rgb(0,0,0), size = 6,offset=1,alpha = 175)
						if(src)
							for(var/turf/t in range(src.radius,src))
								t.grav = -1
							if(src.grown)
								animate(src, transform = matrix()*1.1, time = 10, loop = -1)
								animate(transform = matrix()*1, time = 10)
								animate(transform = turn(matrix(), 120), time = 4,loop = -1, flags = ANIMATION_PARALLEL)
								animate(transform = turn(matrix(), 240), time = 4)
								animate(transform = null, time = 4)
								var/p = 33
								while(p)
									if(prob(25))
										sleep(1)
									p -= 1;
									var/obj/pix = new
									pix.icon = 'fx.dmi'
									pix.icon_state = "pixel"
									pix.loc = src.loc
									pix.step_x = src.step_x
									pix.step_y = src.step_y
									pix.pixel_x = rand(-200,200)
									pix.pixel_y = rand(-200,200)
									pix.bolted = 2
									animate(pix,pixel_x = 0, pixel_y = 0, time = rand(5,10), alpha = 0,loop = -1)
									animate(pixel_x = rand(-200,200), pixel_y = rand(-200,200), time = 0, alpha = 255)
									sleep(0.1)
							while(src)
								for(var/obj/items/tech/tch in range(src.radius,src))
									tch.flash_red()
									tch.shake()
									tch.hp -= 5
									if(tch.hp <= 0) tch.destroy()
								sleep(10)
					/*
					spawn(10)
						if(src)
							if(src.density_factor == 0) src.gravity_well()
							while(src)
								src.pulsate_field()
								sleep(10)
					*/
		drugs
			//Add Kidney dialysis and stomach pumps, as well as nasal ejectors to treat overdose.
			icon = 'Drugss.dmi'
			icon_state = "empty pill"
			stacks = 1
			can_pocket = 1
			toxic = 1
			value = 100000
			tech_tree = "Engineering"
			tech_parent_path = /obj/items/tech/sub_tech/Genetics/Drug_Synthesis
			Click(location,control,params)
				..()
				//Removes this item from the global Items list.
				if(items)
					if(src in items) items -= src
				params = params2list(params)
				if(params["left"])
					if(isturf(src.loc))
						usr.pickup(src)
						if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up x[src.stacks] [src]","actionoutput")
					else if(ismob(src.loc))
						if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
						usr.item_selected = src
						src.overlays -= /obj/effects/select_item
						src.overlays += /obj/effects/select_item
					else if(src.loc == null)
						var/v = 10000
						src.tech_lvl = 1
						for(var/obj/items/tech/Drug_Synthesization/DS in global.tech)//usr.technology_researched)
							if(usr.tech_unlocked[DS.list_pos] == DS.type)
							//if(usr.tech_unlocked.Find(DS.type))
								src.tech_lvl = usr.tech_lvls[DS.list_pos]//DS.tech_lvl
								v = 10000*DS.tech_lvl
								world.log << "DEBUG - Found [DS], setting drug cost to [1000*DS.tech_lvl] based on level: [DS.tech_lvl]"
								break
						src.value = v
						winset(usr,"tech.label_cost","text=\"Needed Minerals: <text align=right valign=top> Stone: [src.stone_cost]\nCopper: [src.copper_cost]\nCoal: [src.coal_cost]\nSilver: [src.silver_cost]\nGold: [src.gold_cost]\nTitanium: [src.titanium_cost]\nMystille: [src.mystille_cost]\n\n<text align=left valign=top>\"")

						winset(usr,"tech.label_name","text=\"[src.name]\"")
						winset(usr,"tech.label_desc","text=\"[src.desc]\"")
						winset(usr,"tech.label_info","text=\"[src.desc_extra]\"")
						usr.build_tech_selected = src


			//Drug Synthesis items

		//	Chemotherapeutic_Agent //Helps with rad sickness
			Penicillin //Helps with regen, helps reduce time of infections/disease
				name = "Penicillin"
				icon_state = "Penicillin"
				rarity = 1
				desc = "<b><u>Drug Facts:</u></b> \n<i>Active ingredient(in each dose):</i>\n        (Un-able to read)"
				act = /obj/items/drugs/Penicillin/proc/use
				act_drop = /obj/items/drugs/Penicillin/proc/drop
				needed_qp = 3900
				//Toxic buildup from taking drug
				toxin_gain = 0.0001
				toxicity = 5
				lifespan_gain = -10
				mystille_cost = 300

				//Duration in 1/10 seconds
				duration = 6000

				//Does the drug have a comedown or not, and how long does it last
				comedown = 1
				comedown_duration = 6000

				//Changed permanently when taken
				regen_gain = 1

				//Changed temporarily when taken
				regen_gain_temp = 0.001

				//Changed temporarily when wears off
				regen_loss_temp = -10


				New()
					..()
					src.icon_state = "Penicillin"
					duration = 6000

					spawn(0)
						if(src)
							src.extra_info = "<font color = red>- Liver Damage</font>\n\n<font color = red>+ [src.toxicity*2]% Toxicity Buildup</font>\n\n<font color = red>- [abs(lifespan_gain)] Lifespan</font>\n"
							src.desc_extra = "Potency: [src.tech_lvl]%\n\nDuration: [(src.duration/10)/60] minutes\n\nToxicity Buildup: <font color = red>+ [src.toxicity]%</font>"

				proc
					use(var/mob/m,var/obj/items/drugs/i)
						if(i in m)
							if(m.has_stomach == 0 || m.has_body == 0)
								m.set_alert("Unable to metabolize this",'alert.dmi',"alert")
								return
							if(m.eating)
								m.set_alert("Already eating",'alert.dmi',"alert")

								return
							var/T = world.time
							i.apply_item_stats(m,T)
							if(i && m && i.loc == m && i.stacks > 0 && i == m.eating && i.time_eaten == T)
								var/repeat = i.apply_same_drug(m)
								if(repeat == 0) i.create_drug_buff(m)
								if(m.toxicity >= 85)
									m.flash_red()
									for(var/obj/body_related/bodyparts/torso/t in m.bodyparts)
										for(var/obj/body_related/bodyparts/torso/heart/h in t)
											m.damage_limb(i,0, 1, 100,h)
											break
								i.use_obj(m)
								m.refresh_inv()
								if(m.toxicity >= 200)
									m.set_alert("You overdose on [i]!",'alert.dmi',"alert")
									m<<output("You overdose on [i]!","actionoutput")
									m.Death("[i] overdose")
								if(m) m.eating = null
					drop(var/mob/m,var/obj/items/i)
						m.drop(i)

			Ibuprofen //Helps with regen and limb healing
				name = "Ibuprofen"
				icon_state = "Ibuprofen"
				rarity = 1
				desc = "<b><u>Drug Facts:</u></b> \n<i>Active ingredient(in each dose):</i>\n        (Un-able to read)"
				act = /obj/items/drugs/Ibuprofen/proc/use
				act_drop = /obj/items/drugs/Ibuprofen/proc/drop
				needed_qp = 3900
				//Toxic buildup from taking drug
				toxin_gain = 0.0001
				toxicity = 10
				lifespan_gain = -10
				mystille_cost = 300

				//Duration in 1/10 seconds
				duration = 6000

				//Does the drug have a comedown or not, and how long does it last
				comedown = 1
				comedown_duration = 6000

				//Changed permanently when taken
				regen_gain = 1

				//Changed temporarily when taken
				regen_gain_temp = 0.005

				//Changed temporarily when wears off
				regen_loss_temp = -10


				New()
					..()
					src.icon_state = "Ibuprofen"
					spawn(0)
						if(src)
							src.extra_info = "<font color = red>- Heart Damage</font>\n\n<font color = red>+ [src.toxicity*2]% Toxicity Buildup</font>\n\n<font color = red>- [abs(lifespan_gain)] Lifespan</font>\n\n<font color = green>- Double benefits</font>"
							src.desc_extra = "Potency: [src.tech_lvl]%\n\nDuration: [(src.duration/10)/60] minutes\n\nToxicity Buildup: <font color = red>+ [src.toxicity]%</font>"

				proc
					use(var/mob/m,var/obj/items/drugs/i)
						if(i in m)
							if(m.has_stomach == 0 || m.has_body == 0)
								m.set_alert("Unable to metabolize this",'alert.dmi',"alert")

								return
							if(m.eating)
								m.set_alert("Already eating",'alert.dmi',"alert")

								return
							var/T = world.time
							i.apply_item_stats(m,T)
							if(i && m && i.loc == m && i.stacks > 0 && i == m.eating && i.time_eaten == T)
								var/repeat = i.apply_same_drug(m)
								if(repeat == 0) i.create_drug_buff(m)
								if(m.toxicity >= 85)
									m.flash_red()
									for(var/obj/body_related/bodyparts/torso/t in m.bodyparts)
										for(var/obj/body_related/bodyparts/torso/heart/h in t)
											m.damage_limb(i,0, 1, 100,h)
											break
								i.use_obj(m)
								m.refresh_inv()
								if(m.toxicity >= 200)
									m.set_alert("You overdose on [i]!",'alert.dmi',"alert")
									m<<output("You overdose on [i]!","actionoutput")
									m.Death("[i] overdose")
								if(m) m.eating = null
					drop(var/mob/m,var/obj/items/i)
						m.drop(i)
		//	Acetylsalicylic_Acid //Helps with regen and limb healing (Aspirin)
			Activated_Charcoal //Helps with drug overdose
				name = "Activated Charcoal"
				icon_state = "Activated Charcoal"
				rarity = 1
				desc = "<b><u>Drug Facts:</u></b> \n<i>Active ingredient(in each dose):</i>\n        (Un-able to read)"
				act = /obj/items/drugs/Activated_Charcoal/proc/use
				act_drop = /obj/items/drugs/Activated_Charcoal/proc/drop
				needed_qp = 3900
				//Toxic buildup from taking drug
				toxin_gain = 0.0001
				toxicity = 10
				lifespan_gain = -10
				mystille_cost = 1500

				//Duration in 1/10 seconds
				duration = 6000

				//Does the drug have a comedown or not, and how long does it last
				comedown = 1
				comedown_duration = 6000

				//Changed permanently when taken
				str_gain = 1

				//Changed temporarily when taken
				str_gain_temp = 10

				//Changed temporarily when wears off
				str_loss_temp = -10


				New()
					..()
					src.icon_state = "Activated Charcoal"
					spawn(0)
						if(src)
							src.extra_info = "<font color = red>- Heart Damage</font>\n\n<font color = red>+ [src.toxicity*2]% Toxicity Buildup</font>\n\n<font color = red>- [abs(lifespan_gain)] Lifespan</font>\n\n<font color = green>- Double benefits</font>"
							src.desc_extra = "Potency: [src.tech_lvl]%\n\nDuration: [(src.duration/10)/60] minutes\n\nToxicity Buildup: <font color = red>+ [src.toxicity]%</font>"

				proc
					use(var/mob/m,var/obj/items/drugs/i)
						if(i in m)
							if(m.has_stomach == 0 || m.has_body == 0)
								m.set_alert("Unable to metabolize this",'alert.dmi',"alert")

								return
							if(m.eating)
								m.set_alert("Already eating",'alert.dmi',"alert")

								return
							var/T = world.time
							i.apply_item_stats(m,T)
							if(i && m && i.loc == m && i.stacks > 0 && i == m.eating && i.time_eaten == T)
								var/repeat = i.apply_same_drug(m)
								if(repeat == 0) i.create_drug_buff(m)
								if(m.toxicity >= 85)
									m.flash_red()
									for(var/obj/body_related/bodyparts/torso/t in m.bodyparts)
										for(var/obj/body_related/bodyparts/torso/heart/h in t)
											m.damage_limb(i,0, 1, 100,h)
											break
								i.use_obj(m)
								m.refresh_inv()
								if(m.toxicity >= 200)
									m.set_alert("You overdose on [i]!",'alert.dmi',"alert")
									m<<output("You overdose on [i]!","actionoutput")
									m.Death("[i] overdose")
								if(m) m.eating = null
					drop(var/mob/m,var/obj/items/i)
						m.drop(i)
			Diazepam //Help with recovery, helps with toxicity/addiction build up
				name = "Diazepam"
				icon_state = "Diazepam"
				rarity = 1
				desc = "<b><u>Drug Facts:</u></b> \n<i>Active ingredient(in each dose):</i>\n        (Un-able to read)"
				act = /obj/items/drugs/Diazepam/proc/use
				act_drop = /obj/items/drugs/Diazepam/proc/drop
				needed_qp = 3900
				//Toxic buildup from taking drug
				toxin_gain = 0.0001
				toxicity = 5
				lifespan_gain = -10
				mystille_cost = 1500

				//Duration in 1/10 seconds
				duration = 6000

				//Does the drug have a comedown or not, and how long does it last
				comedown = 1
				comedown_duration = 6000

				//Changed permanently when taken
				recov_gain = 1

				//Changed temporarily when taken
				recov_gain_temp = 0.001

				//Changed temporarily when wears off
				recov_loss_temp = -10



				New()
					..()
					src.icon_state = "Diazepam"
					spawn(0)
						if(src)
							src.extra_info = "<font color = red>- Heart Damage</font>\n\n<font color = red>+ [src.toxicity*2]% Toxicity Buildup</font>\n\n<font color = red>- [abs(lifespan_gain)] Lifespan</font>\n\n<font color = green>- Double benefits</font>"
							src.desc_extra = "Potency: [src.tech_lvl]%\n\nDuration: [(src.duration/10)/60] minutes\n\nToxicity Buildup: <font color = red>+ [src.toxicity]%</font>"

				proc
					use(var/mob/m,var/obj/items/drugs/i)
						if(i in m)
							if(m.has_stomach == 0 || m.has_body == 0)
								m.set_alert("Unable to metabolize this",'alert.dmi',"alert")

								return
							if(m.eating)
								m.set_alert("Already eating",'alert.dmi',"alert")

								return
							var/T = world.time
							i.apply_item_stats(m,T)
							if(i && m && i.loc == m && i.stacks > 0 && i == m.eating && i.time_eaten == T)
								var/repeat = i.apply_same_drug(m)
								if(repeat == 0) i.create_drug_buff(m)
								if(m.toxicity >= 85)
									m.flash_red()
									for(var/obj/body_related/bodyparts/torso/t in m.bodyparts)
										for(var/obj/body_related/bodyparts/torso/heart/h in t)
											m.damage_limb(i,0, 1, 100,h)
											break
								i.use_obj(m)
								m.refresh_inv()
								if(m.toxicity >= 200)
									m.set_alert("You overdose on [i]!",'alert.dmi',"alert")
									m<<output("You overdose on [i]!","actionoutput")
									m.Death("[i] overdose")
								if(m) m.eating = null
					drop(var/mob/m,var/obj/items/i)
						m.drop(i)
		//	Ferrous_Salt //Iron supplements, helps with strength
			//Silver_Sulfadiazine //Helps with heat tolerance and microwave tolerance
			Vaccine
				name = "Vaccine"
				icon_state = "Vaccine"
				rarity = 1
				desc = "<b><u>Drug Facts:</u></b> \n<i>Active ingredient(in each dose):</i>\n        (Un-able to read)"
				act = /obj/items/drugs/Vaccine/proc/use
				act_drop = /obj/items/drugs/Vaccine/proc/drop
				needed_qp = 3900
				//Toxic buildup from taking drug
				toxin_gain = 0.0001
				toxicity = 10
				lifespan_gain = -10
				mystille_cost = 3500

				//Duration in 1/10 seconds
				duration = 6000

				//Does the drug have a comedown or not, and how long does it last
				comedown = 1
				comedown_duration = 6000

				//Changed permanently when taken
				str_gain = 1

				//Changed temporarily when taken
				str_gain_temp = 10

				//Changed temporarily when wears off
				str_loss_temp = -10


				New()
					..()
					src.icon_state = "Vaccine"
					spawn(0)
						if(src)
							src.extra_info = "<font color = red>- Heart Damage</font>\n\n<font color = red>+ [src.toxicity*2]% Toxicity Buildup</font>\n\n<font color = red>- [abs(lifespan_gain)] Lifespan</font>\n\n<font color = green>- Double benefits</font>"
							src.desc_extra = "Potency: [src.tech_lvl]%\n\nDuration: [(src.duration/10)/60] minutes\n\nToxicity Buildup: <font color = red>+ [src.toxicity]%</font>"

				proc
					use(var/mob/m,var/obj/items/drugs/i)
						if(i in m)
							if(m.has_stomach == 0 || m.has_body == 0)
								m.set_alert("Unable to metabolize this",'alert.dmi',"alert")

								return
							if(m.eating)
								m.set_alert("Already eating",'alert.dmi',"alert")

								return
							var/T = world.time
							i.apply_item_stats(m,T)
							if(i && m && i.loc == m && i.stacks > 0 && i == m.eating && i.time_eaten == T)
								var/repeat = i.apply_same_drug(m)
								if(repeat == 0) i.create_drug_buff(m)
								if(m.toxicity >= 85)
									m.flash_red()
									for(var/obj/body_related/bodyparts/torso/t in m.bodyparts)
										for(var/obj/body_related/bodyparts/torso/heart/h in t)
											m.damage_limb(i,0, 1, 100,h)
											break
								i.use_obj(m)
								m.refresh_inv()
								if(m.toxicity >= 200)
									m.set_alert("You overdose on [i]!",'alert.dmi',"alert")
									m<<output("You overdose on [i]!","actionoutput")
									m.Death("[i] overdose")
								if(m) m.eating = null
					drop(var/mob/m,var/obj/items/i)
						m.drop(i)
		//	Ascorbic_Acid //Vitim C supplement, levels up organs when used
			//Calcium_Supplement //Levels up bones when used
		//	Colecalciferol //Vitim D supplement, levels up skin
		//	Retinol //Levels eyes, skin
			//Riboflavin //Increases energy

			Iloprost //Help with cold tolerance
				name = "Iloprost"
				icon_state = "Iloprost"
				rarity = 1
				desc = "<b><u>Drug Facts:</u></b> \n<i>Active ingredient(in each dose):</i>\n        (Un-able to read)"
				act = /obj/items/drugs/Iloprost/proc/use
				act_drop = /obj/items/drugs/Iloprost/proc/drop
				needed_qp = 3900
				//Toxic buildup from taking drug
				toxin_gain = 0.0001
				toxicity = 10
				lifespan_gain = -10
				mystille_cost = 500

				//Duration in 1/10 seconds
				duration = 6000

				//Does the drug have a comedown or not, and how long does it last
				comedown = 1
				comedown_duration = 6000

				//Changed permanently when taken
				cold_gain = 1

				//Changed temporarily when taken
				cold_gain_temp = 0.001

				//Changed temporarily when wears off
				cold_loss_temp = -10


				New()
					..()
					src.icon_state = "Iloprost"
					spawn(0)
						if(src)
							src.extra_info = "<font color = red>- Heart Damage</font>\n\n<font color = red>+ [src.toxicity*2]% Toxicity Buildup</font>\n\n<font color = red>- [abs(lifespan_gain)] Lifespan</font>\n\n<font color = green>- Double benefits</font>"
							src.desc_extra = "Potency: [src.tech_lvl]%\n\nDuration: [(src.duration/10)/60] minutes\n\nToxicity Buildup: <font color = red>+ [src.toxicity]%</font>"

				proc
					use(var/mob/m,var/obj/items/drugs/i)
						if(i in m)
							if(m.has_stomach == 0 || m.has_body == 0)
								m.set_alert("Unable to metabolize this",'alert.dmi',"alert")

								return
							if(m.eating)
								m.set_alert("Already eating",'alert.dmi',"alert")

								return
							var/T = world.time
							i.apply_item_stats(m,T)
							if(i && m && i.loc == m && i.stacks > 0 && i == m.eating && i.time_eaten == T)
								var/repeat = i.apply_same_drug(m)
								if(repeat == 0) i.create_drug_buff(m)
								if(m.toxicity >= 85)
									m.flash_red()
									for(var/obj/body_related/bodyparts/torso/t in m.bodyparts)
										for(var/obj/body_related/bodyparts/torso/heart/h in t)
											m.damage_limb(i,0, 1, 100,h)
											break
								i.use_obj(m)
								m.refresh_inv()
								if(m.toxicity >= 200)
									m.set_alert("You overdose on [i]!",'alert.dmi',"alert")
									m<<output("You overdose on [i]!","actionoutput")
									m.Death("[i] overdose")
								if(m) m.eating = null
					drop(var/mob/m,var/obj/items/i)
						m.drop(i)
			Ayahuasca //Increases divine energy, makes you trip out.
				name = "Ayahuasca"
				icon_state = "Ayahuasca"
				rarity = 1
				desc = "<b><u>Drug Facts:</u></b> \n<i>Active ingredient(in each dose):</i>\n        (Un-able to read)"
				act = /obj/items/drugs/Ayahuasca/proc/use
				act_drop = /obj/items/drugs/Ayahuasca/proc/drop
				needed_qp = 3900
				//Toxic buildup from taking drug
				toxin_gain = 0.0001
				toxicity = 10
				lifespan_gain = -10
				mystille_cost = 1800

				//Duration in 1/10 seconds
				duration = 6000

				//Does the drug have a comedown or not, and how long does it last
				comedown = 1
				comedown_duration = 6000

				//Changed permanently when taken
				divine_mod_gain = 1

				//Changed temporarily when taken
				divine_mod_gain_temp = 0.001

				//Changed temporarily when wears off
				divine_mod_loss_temp = -10


				New()
					..()
					src.icon_state = "Ayahuasca"
					spawn(0)
						if(src)
							src.extra_info = "<font color = red>- Heart Damage</font>\n\n<font color = red>+ [src.toxicity*2]% Toxicity Buildup</font>\n\n<font color = red>- [abs(lifespan_gain)] Lifespan</font>\n\n<font color = green>- Double benefits</font>"
							src.desc_extra = "Potency: [src.tech_lvl]%\n\nDuration: [(src.duration/10)/60] minutes\n\nToxicity Buildup: <font color = red>+ [src.toxicity]%</font>"

				proc
					use(var/mob/m,var/obj/items/drugs/i)
						if(i in m)
							if(m.has_stomach == 0 || m.has_body == 0)
								m.set_alert("Unable to metabolize this",'alert.dmi',"alert")

								return
							if(m.eating)
								m.set_alert("Already eating",'alert.dmi',"alert")

								return
							var/T = world.time
							i.apply_item_stats(m,T)
							if(i && m && i.loc == m && i.stacks > 0 && i == m.eating && i.time_eaten == T)
								var/repeat = i.apply_same_drug(m)
								if(repeat == 0) i.create_drug_buff(m)
								if(m.toxicity >= 85)
									m.flash_red()
									for(var/obj/body_related/bodyparts/torso/t in m.bodyparts)
										for(var/obj/body_related/bodyparts/torso/heart/h in t)
											m.damage_limb(i,0, 1, 100,h)
											break
								i.use_obj(m)
								m.refresh_inv()
								if(m.toxicity >= 200)
									m.set_alert("You overdose on [i]!",'alert.dmi',"alert")
									m<<output("You overdose on [i]!","actionoutput")
									m.Death("[i] overdose")
								if(m) m.eating = null
					drop(var/mob/m,var/obj/items/i)
						m.drop(i)
		//	Energy_Drink
			//Psi_X //Super drug
			//Alcohol

		//	Citrulline_Malate //Supplement, helps with heart and muscles.
		//	Tranexamic_Acid //Used to help stop bleeding.


			//Un-safe drugs
			Steroids //Strength. Too much hurts heart, lowers lifespan.
				name = "Steroids"
				icon_state = "Steroids"
				rarity = 1
				desc = "<b><u>Drug Facts:</u></b> \n<i>Active ingredient(in each dose):</i>\n        (Un-able to read)"
				act = /obj/items/drugs/Steroids/proc/use
				act_drop = /obj/items/drugs/Steroids/proc/drop
				needed_qp = 3900
				//Toxic buildup from taking drug
				toxin_gain = 0.0001
				toxicity = 10
				lifespan_gain = -10
				mystille_cost = 500

				//Duration in 1/10 seconds
				duration = 6000

				//Does the drug have a comedown or not, and how long does it last
				comedown = 1
				comedown_duration = 6000

				//Changed permanently when taken
				str_gain = 1

				//Changed temporarily when taken
				str_gain_temp = 0.001

				//Changed temporarily when wears off
				str_loss_temp = -10


				New()
					..()
					src.icon_state = "Steroids"
					spawn(0)
						if(src)
							src.extra_info = "<font color = red>- Heart Damage</font>\n\n<font color = red>+ [src.toxicity*2]% Toxicity Buildup</font>\n\n<font color = red>- [abs(lifespan_gain)] Lifespan</font>"
							src.desc_extra = "Toxicity Buildup: <font color = red>+ [src.toxicity]%</font>\n\nTaken at 85%+ Toxicity:\n\n[src.extra_info]"

				proc
					use(var/mob/m,var/obj/items/drugs/i)
						if(i in m)
							if(m.has_stomach == 0 || m.has_body == 0)
								m.set_alert("Unable to metabolize this",'alert.dmi',"alert")

								return
							if(m.eating)
								m.set_alert("Already eating",'alert.dmi',"alert")

								return
							var/T = world.time
							i.apply_item_stats(m,T)
							if(i && m && i.loc == m && i.stacks > 0 && i == m.eating && i.time_eaten == T)
								var/repeat = i.apply_same_drug(m)
								if(repeat == 0) i.create_drug_buff(m)
								if(m.toxicity >= 85)
									m.flash_red()
									for(var/obj/body_related/bodyparts/torso/t in m.bodyparts)
										for(var/obj/body_related/bodyparts/torso/heart/h in t)
											m.damage_limb(i,0, 1, 100,h)
											break
								i.use_obj(m)
								m.refresh_inv()
								if(m.toxicity >= 200)
									m.set_alert("You overdose on [i]!",'alert.dmi',"alert")
									m<<output("You overdose on [i]!","actionoutput")
									m.Death("[i] overdose")
								if(m) m.eating = null
					drop(var/mob/m,var/obj/items/i)
						m.drop(i)
			Creatine //Strength, increase muscle levels.
				name = "Creatine"
				icon_state = "Creatine"
				rarity = 1
				desc = "<b><u>Drug Facts:</u></b> \n<i>Active ingredient(in each dose):</i>\n        (Un-able to read)"
				act = /obj/items/drugs/Creatine/proc/use
				act_drop = /obj/items/drugs/Creatine/proc/drop
				//Toxic buildup from taking drug
				toxin_gain = 0.0001
				toxicity = 10
				lifespan_gain = -10
				needed_qp = 3500
				mystille_cost = 1500

				//Duration in 1/10 seconds
				duration = 6000

				//Does the drug have a comedown or not, and how long does it last
				comedown = 1
				comedown_duration = 6000

				//Changed permanently when taken
				str_gain = 1

				//Changed temporarily when taken
				str_gain_temp = 0.001

				//Changed temporarily when wears off
				str_loss_temp = -10
				New()
					..()
					src.icon_state = "Creatine"
					src.extra_info = "<font color = red>- Heart Damage</font>\n\n<font color = red>+ [src.toxicity*2]% Toxicity Buildup</font>\n\n<font color = red>- [abs(lifespan_gain)] Lifespan</font>"
					src.desc_extra = "Toxicity Buildup: <font color = red>+ [src.toxicity]%</font>\n\nTaken at 85%+ Toxicity:\n\n[src.extra_info]"
				proc
					use(var/mob/m,var/obj/items/drugs/i)
						if(i in m)
							if(m.has_stomach == 0 || m.has_body == 0)
								m.set_alert("Unable to metabolize this",'alert.dmi',"alert")

								return
							if(m.eating)
								m.set_alert("Already eating",'alert.dmi',"alert")

								return
							var/T = world.time
							i.apply_item_stats(m,T)
							if(i && m && i.loc == m && i.stacks > 0 && i == m.eating && i.time_eaten == T)
								var/repeat = i.apply_same_drug(m)
								if(repeat == 0) i.create_drug_buff(m)
								if(m.toxicity >= 85)
									m.flash_red()
									for(var/obj/body_related/bodyparts/torso/t in m.bodyparts)
										for(var/obj/body_related/bodyparts/torso/heart/h in t)
											m.damage_limb(i,0, 1, 100,h)
											break
								i.use_obj(m)
								m.refresh_inv()
								if(m.toxicity >= 200)
									m.set_alert("You overdose on [i]!",'alert.dmi',"alert")
									m<<output("You overdose on [i]!","actionoutput")
									m.Death("[i] overdose")
								if(m) m.eating = null
					drop(var/mob/m,var/obj/items/i)
						m.drop(i)
			Beta_Blocker //Strength, too much hurts heart and lowers lifespan
				name = "Beta Blockers"
				icon_state = "Beta Blockers"
				rarity = 1
				desc = "<b><u>Drug Facts:</u></b> \n<i>Active ingredient(in each dose):</i>\n        (Un-able to read)"
				act = /obj/items/drugs/Beta_Blocker/proc/use
				act_drop = /obj/items/drugs/Beta_Blocker/proc/drop
				//Toxic buildup from taking drug
				toxin_gain = 0.0001
				toxicity = 10
				lifespan_gain = -10
				needed_qp = 4800
				mystille_cost = 2300

				//Duration in 1/10 seconds
				duration = 6000

				//Does the drug have a comedown or not, and how long does it last
				comedown = 1
				comedown_duration = 6000

				//Changed permanently when taken
				str_gain = 1

				//Changed temporarily when taken
				str_gain_temp = 0.003

				//Changed temporarily when wears off
				str_loss_temp = -10
				New()
					..()
					src.icon_state = "Beta Blockers"
					src.extra_info = "<font color = red>- Heart Damage</font>\n\n<font color = red>+ [src.toxicity*2]% Toxicity Buildup</font>\n\n<font color = red>- [abs(lifespan_gain)] Lifespan</font>"
					src.desc_extra = "Toxicity Buildup: <font color = red>+ [src.toxicity]%</font>\n\nTaken at 85%+ Toxicity:\n\n[src.extra_info]"
				proc
					use(var/mob/m,var/obj/items/drugs/i)
						if(i in m)
							if(m.has_stomach == 0 || m.has_body == 0)
								m.set_alert("Unable to metabolize this",'alert.dmi',"alert")

								return
							if(m.eating)
								m.set_alert("Already eating",'alert.dmi',"alert")

								return
							var/T = world.time
							i.apply_item_stats(m,T)
							if(i && m && i.loc == m && i.stacks > 0 && i == m.eating && i.time_eaten == T)
								var/repeat = i.apply_same_drug(m)
								if(repeat == 0) i.create_drug_buff(m)
								if(m.toxicity >= 85)
									m.flash_red()
									for(var/obj/body_related/bodyparts/torso/t in m.bodyparts)
										for(var/obj/body_related/bodyparts/torso/heart/h in t)
											m.damage_limb(i,0, 1, 100,h)
											break
								i.use_obj(m)
								m.refresh_inv()
								if(m.toxicity >= 200)
									m.set_alert("You overdose on [i]!",'alert.dmi',"alert")
									m<<output("You overdose on [i]!","actionoutput")
									m.Death("[i] overdose")
								if(m) m.eating = null
					drop(var/mob/m,var/obj/items/i)
						m.drop(i)
			Methamphetamine //Agility/Energy. Higher int gains for a while. Less hunger. Too much hurts heart, lowers lifespan.
				name = "Methamphetamine"
				icon_state = "Methamphetamine"
				rarity = 1
				desc = "<b><u>Drug Facts:</u></b> \n<i>Active ingredient(in each dose):</i>\n        (Un-able to read)"
				act = /obj/items/drugs/Methamphetamine/proc/use
				act_drop = /obj/items/drugs/Methamphetamine/proc/drop
				//Toxic buildup from taking drug
				toxin_gain = 0.0001
				toxicity = 10
				lifespan_gain = -10
				needed_qp = 4000
				mystille_cost = 4000

				//Duration in 1/10 seconds
				duration = 6000

				//Does the drug have a comedown or not, and how long does it last
				comedown = 1
				comedown_duration = 6000

				//Changed permanently when taken
				eng_gain = 1
				spd_gain = 1

				//Changed temporarily when taken
				eng_gain_temp = 0.001
				spd_gain_temp = 0.002

				//Changed temporarily when wears off
				eng_loss_temp = -10
				spd_loss_temp = -15
				New()
					..()
					src.icon_state = "Methamphetamine"
					src.extra_info = "<font color = red>- Heart Damage</font>\n\n<font color = red>+ [src.toxicity*2]% Toxicity Buildup</font>\n\n<font color = red>- [abs(lifespan_gain)] Lifespan</font>"
					src.desc_extra = "Toxicity Buildup: <font color = red>+ [src.toxicity]%</font>\n\nTaken at 85%+ Toxicity:\n\n[src.extra_info]"
				proc
					use(var/mob/m,var/obj/items/drugs/i)
						if(i in m)
							if(m.has_stomach == 0 || m.has_body == 0)
								m.set_alert("Unable to metabolize this",'alert.dmi',"alert")

								return
							if(m.eating)
								m.set_alert("Already eating",'alert.dmi',"alert")

								return
							var/T = world.time
							i.apply_item_stats(m,T)
							if(i && m && i.loc == m && i.stacks > 0 && i == m.eating && i.time_eaten == T)
								var/repeat = i.apply_same_drug(m)
								if(repeat == 0) i.create_drug_buff(m)
								if(m.toxicity >= 85)
									m.flash_red()
									for(var/obj/body_related/bodyparts/torso/t in m.bodyparts)
										for(var/obj/body_related/bodyparts/torso/heart/h in t)
											m.damage_limb(i,0, 1, 100,h)
											break
								i.use_obj(m)
								m.refresh_inv()
								if(m.toxicity >= 200)
									m.set_alert("You overdose on [i]!",'alert.dmi',"alert")
									m<<output("You overdose on [i]!","actionoutput")
									m.Death("[i] overdose")
								if(m) m.eating = null
					drop(var/mob/m,var/obj/items/i)
						m.drop(i)

			Cocaine //Endurance/Energy. Hurts heart, lowers lifespan.
				name = "Cocaine"
				icon_state = "Cocaine"
				rarity = 4
				desc = "<b><u>Drug Facts:</u></b> \n<i>Active ingredient(in each dose):</i>\n        (Un-able to read)"
				act = /obj/items/drugs/Cocaine/proc/use
				act_drop = /obj/items/drugs/Cocaine/proc/drop
				//Toxic buildup from taking drug
				toxin_gain = 0.0001
				toxicity = 10
				lifespan_gain = -10
				needed_qp = 9999
				mystille_cost = 6500

				//Duration in 1/10 seconds
				duration = 6000

				//Does the drug have a comedown or not, and how long does it last
				comedown = 1
				comedown_duration = 6000

				//Changed permanently when taken
				end_gain = 1
				eng_gain = 1

				//Changed temporarily when taken
				end_gain_temp = 0.001
				eng_gain_temp = 0.003

				//Changed temporarily when wears off
				eng_loss_temp = -20
				end_loss_temp = -10
				New()
					..()
					src.icon_state="Cocaine"
					src.extra_info = "<font color = red>- Heart Damage</font>\n\n<font color = red>+ [src.toxicity*2]% Toxicity Buildup</font>\n\n<font color = red>- [abs(lifespan_gain)] Lifespan</font>"
					src.desc_extra = "Toxicity Buildup: <font color = red>+ [src.toxicity]%</font>\n\nTaken at 85%+ Toxicity:\n\n[src.extra_info]"
				proc
					use(var/mob/m,var/obj/items/drugs/i)
						if(i in m)
							if(m.has_stomach == 0 || m.has_body == 0)
								m.set_alert("Unable to metabolize this",'alert.dmi',"alert")

								return
							if(m.eating)
								m.set_alert("Already eating",'alert.dmi',"alert")

								return
							var/T = world.time
							i.apply_item_stats(m,T)
							if(i && m && i.loc == m && i.stacks > 0 && i == m.eating && i.time_eaten == T)
								var/repeat = i.apply_same_drug(m)
								if(repeat == 0) i.create_drug_buff(m)
								if(m.toxicity >= 85)
									m.flash_red()
									for(var/obj/body_related/bodyparts/torso/t in m.bodyparts)
										for(var/obj/body_related/bodyparts/torso/heart/h in t)
											m.damage_limb(i,0, 1, 100,h)
											break
								i.use_obj(m)
								m.refresh_inv()
								if(m.toxicity >= 200)
									m.set_alert("You overdose on [i]!",'alert.dmi',"alert")
									m<<output("You overdose on [i]!","actionoutput")
									m.Death("[i] overdose")
								if(m) m.eating = null
					drop(var/mob/m,var/obj/items/i)
						m.drop(i)
			Cannabis //Lower int gains for a while. More hunger. Too much ko's you.
				name = "Cannabis"
				rarity = 2
				desc = "<b><u>Drug Facts:</u></b> \n<i>Active ingredient(in each dose):</i>\n        (Un-able to read)"
				act = /obj/items/drugs/Cannabis/proc/use
				act_drop = /obj/items/drugs/Cannabis/proc/drop
				//Toxic buildup from taking drug
				toxin_gain = 0.0001
				toxicity = 10
				lifespan_gain = -10
				needed_qp = 4600
				mystille_cost = 2500

				//Duration in 1/10 seconds
				duration = 6000

				//Does the drug have a comedown or not, and how long does it last
				comedown = 1
				comedown_duration = 6000

				//Changed permanently when taken


				//Changed temporarily when taken
				metab_gain_temp = 0.001
				hydro_gain_temp = 0.001

				//Changed temporarily when wears off

				New()
					..()
					src.icon_state="Cannabis"
					spawn(0)
						if(src)
							src.extra_info = "<font color = red>- Heart Damage</font>\n\n<font color = red>+ [src.toxicity*2]% Toxicity Buildup</font>\n\n<font color = red>- [abs(lifespan_gain)] Lifespan</font>"
							src.desc_extra = "Toxicity Buildup: <font color = red>+ [src.toxicity]%</font>\n\nTaken at 85%+ Toxicity:\n\n[src.extra_info]"
				proc
					use(var/mob/m,var/obj/items/drugs/i)
						if(i in m)
							if(m.has_stomach == 0 || m.has_body == 0)
								m.set_alert("Unable to metabolize this",'alert.dmi',"alert")

								return
							if(m.eating)
								m.set_alert("Already eating",'alert.dmi',"alert")

								return
							var/T = world.time
							i.apply_item_stats(m,T)
							if(i && m && i.loc == m && i.stacks > 0 && i == m.eating && i.time_eaten == T)
								var/repeat = i.apply_same_drug(m)
								if(repeat == 0) i.create_drug_buff(m)
								if(m.toxicity >= 85)
									m.flash_red()
									for(var/obj/body_related/bodyparts/torso/t in m.bodyparts)
										for(var/obj/body_related/bodyparts/torso/heart/h in t)
											m.damage_limb(i,0, 1, 100,h)
											break
								i.use_obj(m)
								m.refresh_inv()
								if(m.toxicity >= 200)
									m.set_alert("You overdose on [i]!",'alert.dmi',"alert")
									m<<output("You overdose on [i]!","actionoutput")
									m.Death("[i] overdose")
								if(m) m.eating = null
					drop(var/mob/m,var/obj/items/i)
						m.drop(i)

			Lysergic_Acid_Diethylamide ///Increases Energy, Divine Energy
				name = "Lysergic Acid Diethylamide"
				rarity = 3
				desc = "<b><u>Drug Facts:</u></b> \n<i>Active ingredient(in each dose):</i>\n        (Un-able to read)"
				act = /obj/items/drugs/Lysergic_Acid_Diethylamide/proc/use
				act_drop = /obj/items/drugs/Lysergic_Acid_Diethylamide/proc/drop
				//Toxic buildup from taking drug
				toxin_gain = 0.0001
				toxicity = 10
				lifespan_gain = -10
				needed_qp = 4300
				mystille_cost = 2500


				//Duration in 1/10 seconds
				duration = 6000

				//Does the drug have a comedown or not, and how long does it last
				comedown = 1
				comedown_duration = 6000

				//Changed permanently when taken
				eng_gain = 1
				divine_mod_gain = 1

				//Changed temporarily when taken
				eng_gain_temp = 0.001
				divine_mod_gain_temp = 0.001

				//Changed temporarily when wears off
				eng_loss_temp = -10
				divine_mod_loss_temp = -10
				New()
					..()
					src.icon_state="Lysergic Acid Diethylamide"
					src.extra_info = "<font color = red>- Heart Damage</font>\n\n<font color = red>+ [src.toxicity*2]% Toxicity Buildup</font>\n\n<font color = red>- [abs(lifespan_gain)] Lifespan</font>"
					src.desc_extra = "Toxicity Buildup: <font color = red>+ [src.toxicity]%</font>\n\nTaken at 85%+ Toxicity:\n\n[src.extra_info]"
				proc
					use(var/mob/m,var/obj/items/drugs/i)
						if(i in m)
							if(m.has_stomach == 0 || m.has_body == 0)
								m.set_alert("Unable to metabolize this",'alert.dmi',"alert")

								return
							if(m.eating)
								m.set_alert("Already eating",'alert.dmi',"alert")

								return
							var/T = world.time
							i.apply_item_stats(m,T)
							if(i && m && i.loc == m && i.stacks > 0 && i == m.eating && i.time_eaten == T)
								var/repeat = i.apply_same_drug(m)
								if(repeat == 0) i.create_drug_buff(m)
								if(m.toxicity >= 85)
									m.flash_red()
									for(var/obj/body_related/bodyparts/torso/t in m.bodyparts)
										for(var/obj/body_related/bodyparts/torso/heart/h in t)
											m.damage_limb(i,0, 1, 100,h)
											break
								i.use_obj(m)
								m.refresh_inv()
								if(m.toxicity >= 200)
									m.set_alert("You overdose on [i]!",'alert.dmi',"alert")
									m<<output("You overdose on [i]!","actionoutput")
									m.Death("[i] overdose")
								if(m) m.eating = null
					drop(var/mob/m,var/obj/items/i)
						m.drop(i)
			/*Agaric //Magic shrooms. Increase int levels. Increase divine energy.
				name = "Agaric"
				rarity = 3
				desc = ""
				act = /obj/items/drugs/Agaric/proc/use
				act_drop = /obj/items/drugs/Agaric/proc/drop
				//Toxic buildup from taking drug
				toxin_gain = 0.0001
				toxicity = 10
				lifespan_gain = -10
				needed_qp = 4444

				//Duration in 1/10 seconds
				duration = 6000

				//Does the drug have a comedown or not, and how long does it last
				comedown = 1
				comedown_duration = 6000

				//Changed permanently when taken
				str_gain = 1

				//Changed temporarily when taken
				str_gain_temp = 10

				//Changed temporarily when wears off
				str_loss_temp = -10
				New()
					..()
					src.extra_info = "<font color = red>- Heart Damage</font>\n\n<font color = red>+ [src.toxicity*2]% Toxicity buildup</font>\n\n<font color = red>- [abs(lifespan_gain)] Lifespan</font>\n\n<font color = green>- Double benefits</font>"
					src.desc_extra = "When Taken:\n\n<font color = red>+ [src.toxicity]% Toxicity buildup</font>\n\n<font color = green>+ [src.divine_eng_gain] level in Divine Energy</font>\n\n<font color = green>+ [src.toxin_gain] Toxin Tolerance</font>\n\nTaken at 85%+ Toxicity:\n\n[src.extra_info]"
				proc
					use(var/mob/m,var/obj/items/drugs/i)
						if(i in m)
							if(m.has_stomach == 0 || m.has_body == 0)
								m.set_alert("Unable to metabolize this",'alert.dmi',"alert")
								m.create_chat_entry("alerts","Unable to metabolize this.")
								return
							if(m.eating)
								m.set_alert("Already eating",'alert.dmi',"alert")
								m.create_chat_entry("alerts","Already eating.")
								return
							var/T = world.time
							i.apply_item_stats(m,T)
							if(i && m && i.loc == m && i.stacks > 0 && i == m.eating && i.time_eaten == T)
								i.use_obj(m)
								m.refresh_inv()
								if(m.toxicity >= 200)
									m.set_alert("You overdose on [i]!",'alert.dmi',"alert")
									m.create_chat_entry("alerts","You overdose on [i]!")
									m.Death("[i] overdose")
								if(m) m.eating = null
					drop(var/mob/m,var/obj/items/i)
						m.drop(i)
					*/
			Diacetylmorphine //Heroin.
				name = "Heroin"
				icon_state="Heroin"
				rarity = 1
				desc = "<b><u>Drug Facts:</u></b> \n<i>Active ingredient(in each dose):</i>\n        (Un-able to read)"
				act = /obj/items/drugs/Diacetylmorphine/proc/use
				act_drop = /obj/items/drugs/Diacetylmorphine/proc/drop
				//Toxic buildup from taking drug
				toxin_gain = 0.0001
				toxicity = 10
				lifespan_gain = -10
				needed_qp = 3600
				mystille_cost = 1200

				//Duration in 1/10 seconds
				duration = 6000

				//Does the drug have a comedown or not, and how long does it last
				comedown = 1
				comedown_duration = 6000

				//Changed permanently when taken
				cold_gain = 1
				force_gain = 1

				//Changed temporarily when taken
				cold_gain_temp = 0.001
				force_gain_temp = 0.001

				//Changed temporarily when wears off
				force_loss_temp = -10
				New()
					..()
					src.extra_info = "<font color = red>- Heart Damage</font>\n\n<font color = red>+ [src.toxicity*2]% Toxicity Buildup</font>\n\n<font color = red>- [abs(lifespan_gain)] Lifespan</font>"
					src.desc_extra = "Toxicity Buildup: <font color = red>+ [src.toxicity]%</font>\n\nTaken at 85%+ Toxicity:\n\n[src.extra_info]"
				proc
					use(var/mob/m,var/obj/items/drugs/i)
						if(i in m)
							if(m.has_stomach == 0 || m.has_body == 0)
								m.set_alert("Unable to metabolize this",'alert.dmi',"alert")

								return
							if(m.eating)
								m.set_alert("Already eating",'alert.dmi',"alert")

								return
							var/T = world.time
							i.apply_item_stats(m,T)
							if(i && m && i.loc == m && i.stacks > 0 && i == m.eating && i.time_eaten == T)
								var/repeat = i.apply_same_drug(m)
								if(repeat == 0) i.create_drug_buff(m)
								if(m.toxicity >= 85)
									m.flash_red()
									for(var/obj/body_related/bodyparts/torso/t in m.bodyparts)
										for(var/obj/body_related/bodyparts/torso/heart/h in t)
											m.damage_limb(i,0, 1, 100,h)
											break
								i.use_obj(m)
								m.refresh_inv()
								if(m.toxicity >= 200)
									m.set_alert("You overdose on [i]!",'alert.dmi',"alert")

									m.Death("[i] overdose")
								if(m) m.eating = null
					drop(var/mob/m,var/obj/items/i)
						m.drop(i)
			Ketamine //Endurance
				name = "Ketamine"
				rarity = 3
				desc = "<b><u>Drug Facts:</u></b> \n<i>Active ingredient(in each dose):</i>\n        (Un-able to read)"
				act = /obj/items/drugs/Ketamine/proc/use
				act_drop = /obj/items/drugs/Ketamine/proc/drop
				//Toxic buildup from taking drug
				toxin_gain = 0.0001
				toxicity = 10
				lifespan_gain = -10
				needed_qp = 5800
				mystille_cost = 3800

				//Duration in 1/10 seconds
				duration = 6000

				//Does the drug have a comedown or not, and how long does it last
				comedown = 1
				comedown_duration = 6000

				//Changed permanently when taken
				end_gain = 1

				//Changed temporarily when taken
				end_gain_temp = 0.001

				//Changed temporarily when wears off
				end_loss_temp = -10
				New()
					..()
					src.icon_state="Ketamine"
					src.extra_info = "<font color = red>- Heart Damage</font>\n\n<font color = red>+ [src.toxicity*2]% Toxicity Buildup</font>\n\n<font color = red>- [abs(lifespan_gain)] Lifespan</font>"
					src.desc_extra = "Toxicity Buildup: <font color = red>+ [src.toxicity]%</font>\n\nTaken at 85%+ Toxicity:\n\n[src.extra_info]"
				proc
					use(var/mob/m,var/obj/items/drugs/i)
						if(i in m)
							if(m.has_stomach == 0 || m.has_body == 0)
								m.set_alert("Unable to metabolize this",'alert.dmi',"alert")

								return
							if(m.eating)
								m.set_alert("Already eating",'alert.dmi',"alert")

								return
							var/T = world.time
							i.apply_item_stats(m,T)
							if(i && m && i.loc == m && i.stacks > 0 && i == m.eating && i.time_eaten == T)
								var/repeat = i.apply_same_drug(m)
								if(repeat == 0) i.create_drug_buff(m)
								if(m.toxicity >= 85)
									m.flash_red()
									for(var/obj/body_related/bodyparts/torso/t in m.bodyparts)
										for(var/obj/body_related/bodyparts/torso/heart/h in t)
											m.damage_limb(i,0, 1, 100,h)
											break
								i.use_obj(m)
								m.refresh_inv()
								if(m.toxicity >= 200)
									m.set_alert("You overdose on [i]!",'alert.dmi',"alert")
									m<<output("You overdose on [i]!","actionoutput")
									m.Death("[i] overdose")
								if(m) m.eating = null
					drop(var/mob/m,var/obj/items/i)
						m.drop(i)
			MDMA //Increase agility?
				icon_state="Ecstacy"
				name = "Ecstasy"
				rarity = 3
				desc = "<b><u>Drug Facts:</u></b> \n<i>Active ingredient(in each dose):</i>\n        (Un-able to read)"
				act = /obj/items/drugs/MDMA/proc/use
				act_drop = /obj/items/drugs/MDMA/proc/drop
				//Toxic buildup from taking drug
				toxin_gain = 0.0001
				toxicity = 10
				lifespan_gain = -10
				needed_qp = 6200
				//Duration in 1/10 seconds
				duration = 6000
				mystille_cost = 5500

				//Does the drug have a comedown or not, and how long does it last
				comedown = 1
				comedown_duration = 6000

				//Changed permanently when taken
				spd_gain = 1

				//Changed temporarily when taken
				spd_gain_temp = 0.001

				//Changed temporarily when wears off
				spd_loss_temp = -10
				New()
					..()
					src.icon_state="Ecstacy"
					src.extra_info = "<font color = red>- Heart Damage</font>\n\n<font color = red>+ [src.toxicity*2]% Toxicity Buildup</font>\n\n<font color = red>- [abs(lifespan_gain)] Lifespan</font>"
					src.desc_extra = "Toxicity Buildup: <font color = red>+ [src.toxicity]%</font>\n\nTaken at 85%+ Toxicity:\n\n[src.extra_info]"
				proc
					use(var/mob/m,var/obj/items/drugs/i)
						if(i in m)
							if(m.has_stomach == 0 || m.has_body == 0)
								m.set_alert("Unable to metabolize this",'alert.dmi',"alert")

								return
							if(m.eating)
								m.set_alert("Already eating",'alert.dmi',"alert")

								return
							var/T = world.time
							i.apply_item_stats(m,T)
							if(i && m && i.loc == m && i.stacks > 0 && i == m.eating && i.time_eaten == T)
								var/repeat = i.apply_same_drug(m)
								if(repeat == 0) i.create_drug_buff(m)
								if(m.toxicity >= 85)
									m.flash_red()
									for(var/obj/body_related/bodyparts/torso/t in m.bodyparts)
										for(var/obj/body_related/bodyparts/torso/heart/h in t)
											m.damage_limb(i,0, 1, 100,h)
											break
								i.use_obj(m)
								m.refresh_inv()
								if(m.toxicity >= 200)
									m.set_alert("You overdose on [i]!",'alert.dmi',"alert")
									m<<output("You overdose on [i]!","actionoutput")
									m.Death("[i] overdose")
								if(m) m.eating = null
					drop(var/mob/m,var/obj/items/i)
						m.drop(i)
			Morphine //Endurance. Hurts kidney?
				icon_state = "Morphine"
				name = "Morphine"
				rarity = 4
				desc = "<b><u>Drug Facts:</u></b> \n<i>Active ingredient(in each dose):</i>\n        (Un-able to read)"
				act = /obj/items/drugs/Morphine/proc/use
				act_drop = /obj/items/drugs/Morphine/proc/drop
				//Toxic buildup from taking drug
				toxin_gain = 0.0001
				toxicity = 10
				lifespan_gain = -10
				needed_qp = 9999
				mystille_cost = 6500

				//Duration in 1/10 seconds
				duration = 6000

				//Does the drug have a comedown or not, and how long does it last
				comedown = 1
				comedown_duration = 6000

				//Changed permanently when taken
				end_gain = 1

				//Changed temporarily when taken
				end_gain_temp = 0.001

				//Changed temporarily when wears off
				end_loss_temp = -10
				New()
					..()
					src.icon_state="Morphine"
					src.extra_info = "<font color = red>- Heart Damage</font>\n\n<font color = red>+ [src.toxicity*2]% Toxicity Buildup</font>\n\n<font color = red>- [abs(lifespan_gain)] Lifespan</font>"
					src.desc_extra = "Toxicity Buildup: <font color = red>+ [src.toxicity]%</font>\n\nTaken at 85%+ Toxicity:\n\n[src.extra_info]"
				proc
					use(var/mob/m,var/obj/items/drugs/i)
						if(i in m)
							if(m.has_stomach == 0 || m.has_body == 0)
								m.set_alert("Unable to metabolize this",'alert.dmi',"alert")

								return
							if(m.eating)
								m.set_alert("Already eating",'alert.dmi',"alert")

								return
							var/T = world.time
							i.apply_item_stats(m,T)
							if(i && m && i.loc == m && i.stacks > 0 && i == m.eating && i.time_eaten == T)
								var/repeat = i.apply_same_drug(m)
								if(repeat == 0) i.create_drug_buff(m)
								if(m.toxicity >= 85)
									m.flash_red()
									for(var/obj/body_related/bodyparts/torso/t in m.bodyparts)
										for(var/obj/body_related/bodyparts/torso/heart/h in t)
											m.damage_limb(i,0, 1, 100,h)
											break
								i.use_obj(m)
								m.refresh_inv()
								if(m.toxicity >= 200)
									m.set_alert("You overdose on [i]!",'alert.dmi',"alert")
									m<<output("You overdose on [i]!","actionoutput")
									m.Death("[i] overdose")
								if(m) m.eating = null
					drop(var/mob/m,var/obj/items/i)
						m.drop(i)
			Caffeine //Increases off. Too much hurts heart.
				name = "Caffeine"
				icon_state="Caffeine"
				rarity = 1
				desc = "<b><u>Drug Facts:</u></b> \n<i>Active ingredient(in each dose):</i>\n        (Un-able to read)"
				act = /obj/items/drugs/Caffeine/proc/use
				act_drop = /obj/items/drugs/Caffeine/proc/drop
				//Toxic buildup from taking drug
				toxin_gain = 0.0001
				toxicity = 10
				lifespan_gain = -10
				needed_qp = 3500
				//Duration in 1/10 seconds
				duration = 6000
				mystille_cost = 2700

				//Does the drug have a comedown or not, and how long does it last
				comedown = 1
				comedown_duration = 6000

				//Changed permanently when taken

				off_gain = 1

				//Changed temporarily when taken
				off_gain_temp = 0.001

				//Changed temporarily when wears off
				off_loss_temp = -10
				New()
					..()
					src.icon_state="Caffeine"
					src.extra_info = "<font color = red>- Heart Damage</font>\n\n<font color = red>+ [src.toxicity*2]% Toxicity Buildup</font>\n\n<font color = red>- [abs(lifespan_gain)] Lifespan</font>"
					src.desc_extra = "Toxicity Buildup: <font color = red>+ [src.toxicity]%</font>\n\nTaken at 85%+ Toxicity:\n\n[src.extra_info]"
				proc
					use(var/mob/m,var/obj/items/drugs/i)
						if(i in m)
							if(m.has_stomach == 0 || m.has_body == 0)
								m.set_alert("Unable to metabolize this",'alert.dmi',"alert")

								return
							if(m.eating)
								m.set_alert("Already eating",'alert.dmi',"alert")

								return
							var/T = world.time
							i.apply_item_stats(m,T)
							if(i && m && i.loc == m && i.stacks > 0 && i == m.eating && i.time_eaten == T)
								var/repeat = i.apply_same_drug(m)
								if(repeat == 0) i.create_drug_buff(m)
								if(m.toxicity >= 85)
									m.flash_red()
									for(var/obj/body_related/bodyparts/torso/t in m.bodyparts)
										for(var/obj/body_related/bodyparts/torso/heart/h in t)
											m.damage_limb(i,0, 1, 100,h)
											break
								i.use_obj(m)
								m.refresh_inv()
								if(m.toxicity >= 200)
									m.set_alert("You overdose on [i]!",'alert.dmi',"alert")
									m<<output("You overdose on [i]!","actionoutput")
									m.Death("[i] overdose")
								if(m) m.eating = null
					drop(var/mob/m,var/obj/items/i)
						m.drop(i)
			Nicotine //Increases force
				name = "Nicotine"
				icon_state="Nicotine"
				rarity = 1
				desc = "<b><u>Drug Facts:</u></b> \n<i>Active ingredient(in each dose):</i>\n        (Un-able to read)"
				act = /obj/items/drugs/Nicotine/proc/use
				act_drop = /obj/items/drugs/Nicotine/proc/drop
				//Toxic buildup from taking drug
				toxin_gain = 0.0001
				toxicity = 10
				lifespan_gain = -10
				needed_qp = 3555
				//Duration in 1/10 seconds
				duration = 6000
				mystille_cost = 500

				//Does the drug have a comedown or not, and how long does it last
				comedown = 1
				comedown_duration = 6000

				//Changed permanently when taken
				res_gain = 1


				//Changed temporarily when taken
				res_gain_temp = 0.001

				//Changed temporarily when wears off
				res_loss_temp = -10
				New()
					..()
					src.icon_state="Nicotine"
					src.extra_info = "<font color = red>- Heart Damage</font>\n\n<font color = red>+ [src.toxicity*2]% Toxicity buildup</font>\n\n<font color = red>- [abs(lifespan_gain)] Lifespan</font>\n\n<font color = green>- Double benefits</font>"
					src.desc_extra = "Toxicity Buildup: <font color = red>+ [src.toxicity]%</font>\n\nTaken at 85%+ Toxicity:\n\n[src.extra_info]"
				proc
					use(var/mob/m,var/obj/items/drugs/i)
						if(i in m)
							if(m.has_stomach == 0 || m.has_body == 0)
								m.set_alert("Unable to metabolize this",'alert.dmi',"alert")

								return
							if(m.eating)
								m.set_alert("Already eating",'alert.dmi',"alert")

								return
							var/T = world.time
							i.apply_item_stats(m,T)
							if(i && m && i.loc == m && i.stacks > 0 && i == m.eating && i.time_eaten == T)
								var/repeat = i.apply_same_drug(m)
								if(repeat == 0) i.create_drug_buff(m)
								if(m.toxicity >= 85)
									m.flash_red()
									for(var/obj/body_related/bodyparts/torso/t in m.bodyparts)
										for(var/obj/body_related/bodyparts/torso/heart/h in t)
											m.damage_limb(i,0, 1, 100,h)
											break
								i.use_obj(m)
								m.refresh_inv()
								if(m.toxicity >= 200)
									m.set_alert("You overdose on [i]!",'alert.dmi',"alert")
									m<<output("You overdose on [i]!","actionoutput")
									m.Death("[i] overdose")
								if(m) m.eating = null
					drop(var/mob/m,var/obj/items/i)
						m.drop(i)
			/*Chondroitin_Sulphate //Increases regen
				name = "Chondroitin Sulphate"
				rarity = 2
				desc = ""
				act = /obj/items/drugs/Chondroitin_Sulphate/proc/use
				act_drop = /obj/items/drugs/Chondroitin_Sulphate/proc/drop
				//Toxic buildup from taking drug
				toxin_gain = 0.0001
				toxicity = 10
				lifespan_gain = -10
				needed_qp = 12222

				//Duration in 1/10 seconds
				duration = 6000

				//Does the drug have a comedown or not, and how long does it last
				comedown = 1
				comedown_duration = 6000

				//Changed permanently when taken
				str_gain = 1

				//Changed temporarily when taken
				str_gain_temp = 10

				//Changed temporarily when wears off
				str_loss_temp = -10
				New()
					..()
					src.extra_info = "<font color = red>- Heart Damage</font>\n\n<font color = red>+ [src.toxicity*2]% Toxicity buildup</font>\n\n<font color = red>- [abs(lifespan_gain)] Lifespan</font>\n\n<font color = green>- Double benefits</font>"
					src.desc_extra = "When Taken:\n\n<font color = red>+ [src.toxicity]% Toxicity buildup</font>\n\n<font color = green>+ [src.str_gain] level in Strength</font>\n\n<font color = green>+ [src.toxin_gain] Toxin Tolerance</font>\n\nTaken at 85%+ Toxicity:\n\n[src.extra_info]"
				proc
					use(var/mob/m,var/obj/items/drugs/i)
						if(i in m)
							if(m.has_stomach == 0 || m.has_body == 0)
								m.set_alert("Unable to metabolize this",'alert.dmi',"alert")
								m.create_chat_entry("alerts","Unable to metabolize this.")
								return
							if(m.eating)
								m.set_alert("Already eating",'alert.dmi',"alert")
								m.create_chat_entry("alerts","Already eating.")
								return
							var/T = world.time
							i.apply_item_stats(m,T)
							if(i && m && i.loc == m && i.stacks > 0 && i == m.eating && i.time_eaten == T)
								i.use_obj(m)
								m.refresh_inv()
								if(m.toxicity >= 200)
									m.set_alert("You overdose on [i]!",'alert.dmi',"alert")
									m.create_chat_entry("alerts","You overdose on [i]!")
									m.Death("[i] overdose")
								if(m) m.eating = null
					drop(var/mob/m,var/obj/items/i)
						m.drop(i)
					*/
			/*Hyaluronic_Acid //Increases regen
				name = "Hyaluronic Acid"
				rarity = 1
				desc = ""
				act = /obj/items/drugs/Hyaluronic_Acid/proc/use
				act_drop = /obj/items/drugs/Hyaluronic_Acid/proc/drop
				//Toxic buildup from taking drug
				toxin_gain = 0.0001
				toxicity = 10
				lifespan_gain = -10
				needed_qp = 16666

				//Duration in 1/10 seconds
				duration = 6000

				//Does the drug have a comedown or not, and how long does it last
				comedown = 1
				comedown_duration = 6000

				//Changed permanently when taken
				str_gain = 1

				//Changed temporarily when taken
				str_gain_temp = 10

				//Changed temporarily when wears off
				str_loss_temp = -10
				New()
					..()
					src.extra_info = "<font color = red>- Heart Damage</font>\n\n<font color = red>+ [src.toxicity*2]% Toxicity buildup</font>\n\n<font color = red>- [abs(lifespan_gain)] Lifespan</font>\n\n<font color = green>- Double benefits</font>"
					src.desc_extra = "When Taken:\n\n<font color = red>+ [src.toxicity]% Toxicity buildup</font>\n\n<font color = green>+ [src.str_gain] level in Strength</font>\n\n<font color = green>+ [src.toxin_gain] Toxin Tolerance</font>\n\nTaken at 85%+ Toxicity:\n\n[src.extra_info]"
				proc
					use(var/mob/m,var/obj/items/drugs/i)
						if(i in m)
							if(m.has_stomach == 0 || m.has_body == 0)
								m.set_alert("Unable to metabolize this",'alert.dmi',"alert")
								m.create_chat_entry("alerts","Unable to metabolize this.")
								return
							if(m.eating)
								m.set_alert("Already eating",'alert.dmi',"alert")
								m.create_chat_entry("alerts","Already eating.")
								return
							var/T = world.time
							i.apply_item_stats(m,T)
							if(i && m && i.loc == m && i.stacks > 0 && i == m.eating && i.time_eaten == T)
								i.use_obj(m)
								m.refresh_inv()
								if(m.toxicity >= 200)
									m.set_alert("You overdose on [i]!",'alert.dmi',"alert")
									m.create_chat_entry("alerts","You overdose on [i]!")
									m.Death("[i] overdose")
								if(m) m.eating = null
					drop(var/mob/m,var/obj/items/i)
						m.drop(i)
					*/
			Insulin //Increase energy, recovery. Too much hurts pancreas and ko's you.
				name = "Insulin"
				rarity = 1
				desc = "<b><u>Drug Facts:</u></b> \n<i>Active ingredient(in each dose):</i>\n        (Un-able to read)"
				act = /obj/items/drugs/Insulin/proc/use
				act_drop = /obj/items/drugs/Insulin/proc/drop
				//Toxic buildup from taking drug
				toxin_gain = 0.0001
				toxicity = 10
				lifespan_gain = -10
				needed_qp = 21000
				mystille_cost = 4500

				//Duration in 1/10 seconds
				duration = 6000

				//Does the drug have a comedown or not, and how long does it last
				comedown = 1
				comedown_duration = 6000

				//Changed permanently when taken
				recov_gain = 1

				//Changed temporarily when taken
				recov_gain_temp = 0.001

				//Changed temporarily when wears off
				recov_loss_temp = -10
				New()
					..()
					src.extra_info = "<font color = red>- Heart Damage</font>\n\n<font color = red>+ [src.toxicity*2]% Toxicity Buildup</font>\n\n<font color = red>- [abs(lifespan_gain)] Lifespan</font>"
					src.desc_extra = "Toxicity Buildup: <font color = red>+ [src.toxicity]%</font>\n\nTaken at 85%+ Toxicity:\n\n[src.extra_info]"
				proc
					use(var/mob/m,var/obj/items/drugs/i)
						if(i in m)
							if(m.has_stomach == 0 || m.has_body == 0)
								m.set_alert("Unable to metabolize this",'alert.dmi',"alert")

								return
							if(m.eating)
								m.set_alert("Already eating",'alert.dmi',"alert")

								return
							var/T = world.time
							i.apply_item_stats(m,T)
							if(i && m && i.loc == m && i.stacks > 0 && i == m.eating && i.time_eaten == T)
								var/repeat = i.apply_same_drug(m)
								if(repeat == 0) i.create_drug_buff(m)
								if(m.toxicity >= 85)
									m.flash_red()
									for(var/obj/body_related/bodyparts/torso/t in m.bodyparts)
										for(var/obj/body_related/bodyparts/torso/heart/h in t)
											m.damage_limb(i,0, 1, 100,h)
											break
								i.use_obj(m)
								m.refresh_inv()
								if(m.toxicity >= 200)
									m.set_alert("You overdose on [i]!",'alert.dmi',"alert")
									m<<output("You overdose on [i]!","actionoutput")
									m.Death("[i] overdose")
								if(m) m.eating = null
					drop(var/mob/m,var/obj/items/i)
						m.drop(i)


			Epinephrine //(Adrenalin) , Increase heart, strength, energy. Too much hurts heart, lowers lifespan.
				icon_state = "Epinephrine"
				name = "Epinephrine"
				rarity = 3
				desc = "<b><u>Drug Facts:</u></b> \n<i>Active ingredient(in each dose):</i>\n        (Un-able to read)"
				act = /obj/items/drugs/Epinephrine/proc/use
				act_drop = /obj/items/drugs/Epinephrine/proc/drop
				//Toxic buildup from taking drug
				toxin_gain = 0.0001
				toxicity = 10
				lifespan_gain = -10
				needed_qp = 26000
				mystille_cost = 8500

				//Duration in 1/10 seconds
				duration = 6000

				//Does the drug have a comedown or not, and how long does it last
				comedown = 1
				comedown_duration = 6000

				//Changed permanently when taken
				str_gain = 1
				off_gain = 1

				//Changed temporarily when taken
				str_gain_temp = 0.001
				off_gain_temp = 0.002

				//Changed temporarily when wears off
				str_loss_temp = -10
				off_gain_temp = -15
				New()
					..()
					src.icon_state="Epinephrine"
					src.extra_info = "<font color = red>- Heart Damage</font>\n\n<font color = red>+ [src.toxicity*2]% Toxicity Buildup</font>\n\n<font color = red>- [abs(lifespan_gain)] Lifespan</font>"
					src.desc_extra = "Toxicity Buildup: <font color = red>+ [src.toxicity]%</font>\n\nTaken at 85%+ Toxicity:\n\n[src.extra_info]"
				proc
					use(var/mob/m,var/obj/items/drugs/i)
						if(i in m)
							if(m.has_stomach == 0 || m.has_body == 0)
								m.set_alert("Unable to metabolize this",'alert.dmi',"alert")

								return
							if(m.eating)
								m.set_alert("Already eating",'alert.dmi',"alert")

								return
							var/T = world.time
							i.apply_item_stats(m,T)
							if(i && m && i.loc == m && i.stacks > 0 && i == m.eating && i.time_eaten == T)
								var/repeat = i.apply_same_drug(m)
								if(repeat == 0) i.create_drug_buff(m)
								if(m.toxicity >= 85)
									m.flash_red()
									for(var/obj/body_related/bodyparts/torso/t in m.bodyparts)
										for(var/obj/body_related/bodyparts/torso/heart/h in t)
											m.damage_limb(i,0, 1, 100,h)
											break
								i.use_obj(m)
								m.refresh_inv()
								if(m.toxicity >= 200)
									m.set_alert("You overdose on [i]!",'alert.dmi',"alert")
									m<<output("You overdose on [i]!","actionoutput")
									m.Death("[i] overdose")
								if(m) m.eating = null
					drop(var/mob/m,var/obj/items/i)
						m.drop(i)

			/*Methylmercury //Very dangerous, can be taken by androids too. Increases dark matter, reduces lifespan. Hurts organs if organic.
				name = "Methylmercury"
				rarity = 3
				desc = ""
				act = /obj/items/drugs/Methylmercury/proc/use
				act_drop = /obj/items/drugs/Methylmercury/proc/drop
				//Toxic buildup from taking drug
				toxin_gain = 0.0001
				toxicity = 10
				lifespan_gain = -10
				needed_qp = 31000
				//Duration in 1/10 seconds
				duration = 6000

				//Does the drug have a comedown or not, and how long does it last
				comedown = 1
				comedown_duration = 6000

				//Changed permanently when taken
				str_gain = 1

				//Changed temporarily when taken
				str_gain_temp = 10

				//Changed temporarily when wears off
				str_loss_temp = -10
				New()
					..()
					src.extra_info = "<font color = red>- Heart Damage</font>\n\n<font color = red>+ [src.toxicity*2]% Toxicity buildup</font>\n\n<font color = red>- [abs(lifespan_gain)] Lifespan</font>\n\n<font color = green>- Double benefits</font>"
					src.desc_extra = "When Taken:\n\n<font color = red>+ [src.toxicity]% Toxicity buildup</font>\n\n<font color = green>+ [src.str_gain] level in Strength</font>\n\n<font color = green>+ [src.toxin_gain] Toxin Tolerance</font>\n\nTaken at 85%+ Toxicity:\n\n[src.extra_info]"
				proc
					use(var/mob/m,var/obj/items/drugs/i)
						if(i in m)
							if(m.has_stomach == 0 || m.has_body == 0)
								m.set_alert("Unable to metabolize this",'alert.dmi',"alert")
								m.create_chat_entry("alerts","Unable to metabolize this.")
								return
							if(m.eating)
								m.set_alert("Already eating",'alert.dmi',"alert")
								m.create_chat_entry("alerts","Already eating.")
								return
							var/T = world.time
							i.apply_item_stats(m,T)
							if(i && m && i.loc == m && i.stacks > 0 && i == m.eating && i.time_eaten == T)
								i.use_obj(m)
								m.refresh_inv()
								if(m.toxicity >= 200)
									m.set_alert("You overdose on [i]!",'alert.dmi',"alert")
									m.create_chat_entry("alerts","You overdose on [i]!")
									m.Death("[i] overdose")
								if(m) m.eating = null
					drop(var/mob/m,var/obj/items/i)
						m.drop(i)
					*/


			/*Polonium_210 //Kills the user if their radiation tolerance is too low. Increases resistance and radiation tolerance.
				name = "Polonium-210"
				rarity = 3
				desc = ""
				act = /obj/items/drugs/Polonium_210/proc/use
				act_drop = /obj/items/drugs/Polonium_210/proc/drop
				//Toxic buildup from taking drug
				toxin_gain = 0.0001
				toxicity = 10
				lifespan_gain = -10

				//Duration in 1/10 seconds
				duration = 6000

				//Does the drug have a comedown or not, and how long does it last
				comedown = 1
				comedown_duration = 6000

				//Changed permanently when taken
				str_gain = 1

				//Changed temporarily when taken
				str_gain_temp = 10

				//Changed temporarily when wears off
				str_loss_temp = -10
				New()
					..()
					src.extra_info = "<font color = red>- Heart Damage</font>\n\n<font color = red>+ [src.toxicity*2]% Toxicity buildup</font>\n\n<font color = red>- [abs(lifespan_gain)] Lifespan</font>\n\n<font color = green>- Double benefits</font>"
					src.desc_extra = "When Taken:\n\n<font color = red>+ [src.toxicity]% Toxicity buildup</font>\n\n<font color = green>+ [src.str_gain] level in Strength</font>\n\n<font color = green>+ [src.toxin_gain] Toxin Tolerance</font>\n\nTaken at 85%+ Toxicity:\n\n[src.extra_info]"
				proc
					use(var/mob/m,var/obj/items/drugs/i)
						if(i in m)
							if(m.has_stomach == 0 || m.has_body == 0)
								m.set_alert("Unable to metabolize this",'alert.dmi',"alert")
								m.create_chat_entry("alerts","Unable to metabolize this.")
								return
							if(m.eating)
								m.set_alert("Already eating",'alert.dmi',"alert")
								m.create_chat_entry("alerts","Already eating.")
								return
							var/T = world.time
							i.apply_item_stats(m,T)
							if(i && m && i.loc == m && i.stacks > 0 && i == m.eating && i.time_eaten == T)
								i.use_obj(m)
								m.refresh_inv()
								if(m.toxicity >= 200)
									m.set_alert("You overdose on [i]!",'alert.dmi',"alert")
									m.create_chat_entry("alerts","You overdose on [i]!")
									m.Death("[i] overdose")
								if(m) m.eating = null
					drop(var/mob/m,var/obj/items/i)
						m.drop(i)
			//Fictional drugs
			Psiamphetamine //Special drug used to increase brain wave activity, gives Psionic power.
				name = "Psiamphetamine"
				rarity = 1
				desc = ""
				act = /obj/items/drugs/Psiamphetamine/proc/use
				act_drop = /obj/items/drugs/Psiamphetamine/proc/drop
				//Toxic buildup from taking drug
				toxin_gain = 0.0001
				toxicity = 10
				lifespan_gain = -10

				//Duration in 1/10 seconds
				duration = 6000

				//Does the drug have a comedown or not, and how long does it last
				comedown = 1
				comedown_duration = 6000

				//Changed permanently when taken
				str_gain = 1

				//Changed temporarily when taken
				str_gain_temp = 10

				//Changed temporarily when wears off
				str_loss_temp = -10
				New()
					..()
					src.extra_info = "<font color = red>- Heart Damage</font>\n\n<font color = red>+ [src.toxicity*2]% Toxicity buildup</font>\n\n<font color = red>- [abs(lifespan_gain)] Lifespan</font>\n\n<font color = green>- Double benefits</font>"
					src.desc_extra = "When Taken:\n\n<font color = red>+ [src.toxicity]% Toxicity buildup</font>\n\n<font color = green>+ [src.psi_gain] level in Power</font>\n\n<font color = green>+ [src.toxin_gain] Toxin Tolerance</font>\n\nTaken at 85%+ Toxicity:\n\n[src.extra_info]"
				proc
					use(var/mob/m,var/obj/items/drugs/i)
						if(i in m)
							if(m.has_stomach == 0 || m.has_body == 0)
								m.set_alert("Unable to metabolize this",'alert.dmi',"alert")
								m.create_chat_entry("alerts","Unable to metabolize this.")
								return
							if(m.eating)
								m.set_alert("Already eating",'alert.dmi',"alert")
								m.create_chat_entry("alerts","Already eating.")
								return
							var/T = world.time
							i.apply_item_stats(m,T)
							if(i && m && i.loc == m && i.stacks > 0 && i == m.eating && i.time_eaten == T)
								i.use_obj(m)
								m.refresh_inv()
								if(m.toxicity >= 200)
									m.set_alert("You overdose on [i]!",'alert.dmi',"alert")
									m.create_chat_entry("alerts","You overdose on [i]!")
									m.Death("[i] overdose")
								if(m) m.eating = null
					drop(var/mob/m,var/obj/items/i)
						m.drop(i)
			Psidexasulphate //Special drug used to increase brain wave activity, gives Psionic Power.
				name = "Psidexasulphate"
				rarity = 1
				desc = ""
				act = /obj/items/drugs/Psidexasulphate/proc/use
				act_drop = /obj/items/drugs/Psidexasulphate/proc/drop
				//Toxic buildup from taking drug
				toxin_gain = 0.0001
				toxicity = 10
				lifespan_gain = -10

				//Duration in 1/10 seconds
				duration = 6000

				//Does the drug have a comedown or not, and how long does it last
				comedown = 1
				comedown_duration = 6000

				//Changed permanently when taken
				str_gain = 1

				//Changed temporarily when taken
				str_gain_temp = 10

				//Changed temporarily when wears off
				str_loss_temp = -10
				New()
					..()
					src.extra_info = "<font color = red>- Heart Damage</font>\n\n<font color = red>+ [src.toxicity*2]% Toxicity buildup</font>\n\n<font color = red>- [abs(lifespan_gain)] Lifespan</font>\n\n<font color = green>- Double benefits</font>"
					src.desc_extra = "When Taken:\n\n<font color = red>+ [src.toxicity]% Toxicity buildup</font>\n\n<font color = green>+ [src.psi_gain] level in Power</font>\n\n<font color = green>+ [src.toxin_gain] Toxin Tolerance</font>\n\nTaken at 85%+ Toxicity:\n\n[src.extra_info]"
				proc
					use(var/mob/m,var/obj/items/drugs/i)
						if(i in m)
							if(m.has_stomach == 0 || m.has_body == 0)
								m.set_alert("Unable to metabolize this",'alert.dmi',"alert")
								m.create_chat_entry("alerts","Unable to metabolize this.")
								return
							if(m.eating)
								m.set_alert("Already eating",'alert.dmi',"alert")
								m.create_chat_entry("alerts","Already eating.")
								return
							var/T = world.time
							i.apply_item_stats(m,T)
							if(i && m && i.loc == m && i.stacks > 0 && i == m.eating && i.time_eaten == T)
								i.use_obj(m)
								m.refresh_inv()
								if(m.toxicity >= 200)
									m.set_alert("You overdose on [i]!",'alert.dmi',"alert")
									m.create_chat_entry("alerts","You overdose on [i]!")
									m.Death("[i] overdose")
								if(m) m.eating = null
					drop(var/mob/m,var/obj/items/i)
						m.drop(i)
			Super_Soldier_Serum //Increases all mods by 10%-20%, increases lifespan by 10%-20%
				icon_state = "syringe"
				name = "Super Soldier Serum"
				rarity = 1
				desc = ""
				act = /obj/items/drugs/Super_Soldier_Serum/proc/use
				act_drop = /obj/items/drugs/Super_Soldier_Serum/proc/drop
				//Toxic buildup from taking drug
				toxin_gain = 0.0001
				toxicity = 10
				lifespan_gain = -10
				needed_qp = 50000
				//Duration in 1/10 seconds
				duration = 6000

				//Does the drug have a comedown or not, and how long does it last
				comedown = 1
				comedown_duration = 6000

				//Changed permanently when taken
				str_gain = 1

				//Changed temporarily when taken
				str_gain_temp = 10

				//Changed temporarily when wears off
				str_loss_temp = -10
				New()
					..()
					src.extra_info = "<font color = red>- Heart Damage</font>\n\n<font color = red>+ [src.toxicity*2]% Toxicity buildup</font>\n\n<font color = red>- [abs(lifespan_gain)] Lifespan</font>\n\n<font color = green>- Double benefits</font>"
					src.desc_extra = "When Taken:\n\n<font color = red>+ [src.toxicity]% Toxicity buildup</font>\n\n<font color = green>+ [src.str_gain] level in Strength</font>\n\n<font color = green>+ [src.toxin_gain] Toxin Tolerance</font>\n\nTaken at 85%+ Toxicity:\n\n[src.extra_info]"
				proc
					use(var/mob/m,var/obj/items/drugs/i)
						if(i in m)
							if(m.has_stomach == 0 || m.has_body == 0)
								m.set_alert("Unable to metabolize this",'alert.dmi',"alert")
								m.create_chat_entry("alerts","Unable to metabolize this.")
								return
							if(m.eating)
								m.set_alert("Already eating",'alert.dmi',"alert")
								m.create_chat_entry("alerts","Already eating.")
								return
							var/T = world.time
							i.apply_item_stats(m,T)
							if(i && m && i.loc == m && i.stacks > 0 && i == m.eating && i.time_eaten == T)
								i.use_obj(m)
								m.refresh_inv()
								if(m.toxicity >= 200)
									m.set_alert("You overdose on [i]!",'alert.dmi',"alert")
									m.create_chat_entry("alerts","You overdose on [i]!")
									m.Death("[i] overdose")
								if(m) m.eating = null
					drop(var/mob/m,var/obj/items/i)
						m.drop(i)
						*/
		consumables
			can_pocket = 1;
			immune_dmg = 1
			icon = 'consumables.dmi'
			bounds = "8,6 to 25,24"

			var/infused = 0
			solar_infusion
			dragon_faeces
			dragon_bone
			thousand_year_old_dragon_bone
			thousand_year_old_dragon_faeces
			thousand_year_old_ginseng
			divine_feather
			void_droplet
			scarlet_crystal

			ambrosia //Increases max divine energy and life span
				name = "Ambrosia"
				icon = 'artifacts_small.dmi'
				icon_state = "ambrosia"
				rarity = 3
				hashadow = 1
				act = /obj/items/consumables/ambrosia/proc/use
				act_drop = /obj/items/consumables/ambrosia/proc/drop
				base_type = "Regeneration"
				//Toxic buildup from taking drug

				//Duration in 1/10 seconds

				//Does the drug have a comedown or not, and how long does it last

				//Changed permanently when taken
				//lifespan_gain = 1
				//divine_eng_gain = 1
				lvl_rand_part = 1
				lvl_rand_num = 1
				metab_gain = 19

				//Changed temporarily when taken

				//Changed temporarily when wears off

				New()
					..()
					src.desc_extra = "[src.create_item_desc()]\n\n"
				proc
					use(var/mob/m,var/obj/items/i)
						if(i in m)
							if(m.has_stomach == 0 )
								m.set_alert("Unable to eat food",'alert.dmi',"alert")

								return
							if(m.hunger > 99)
								m.set_alert("Already full",'alert.dmi',"alert")

								return
							if(m.eating)
								m.set_alert("Already eating",'alert.dmi',"alert")

								return
							var/T = world.time
							i.apply_item_stats(m,T)
							if(i && m && i.loc == m && i.stacks > 0 && i == m.eating && i.time_eaten == T)

								i.use_obj(m)
								m.refresh_inv()
								if(m) m.eating = null
					drop(var/mob/m,var/obj/items/i)
						m.drop(i)
				//plane = 4
					fall()
						spawn(1)
							if(src)
								src.pixel_y = 1000
								if(src.shadow) src.shadow.pixel_y = 0
								while(src.pixel_y > 0)
									src.pixel_y -= 8
									if(src.pixel_y < 0) src.pixel_y = 0
									sleep(0.1)
				Click(location,control,params)
					..()
					//Removes this item from the global Items list.
					if(items)
						if(src in items) items -= src
					params = params2list(params)
					if(params["left"])
						if(isturf(src.loc))
							usr.pickup(src)
							if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up x[src.stacks] [src]","actionoutput")
						else if(ismob(src.loc))
							if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
							usr.item_selected = src
							src.overlays -= /obj/effects/select_item
							src.overlays += /obj/effects/select_item


			food
				special
					water_thermoflask
						name = "Water Thermoflask"
						icon = 'Manyfoods.dmi'
						icon_state = "thermoflask"
						rarity = 5
						desc = "A high-capacity hydration unit that can be drank from multiple times."
						stacks = -1
						act = /obj/items/consumables/food/special/water_thermoflask/proc/use
						//act_drop = /obj/items/consumables/food/special/water_thermoflask/proc/drop
						duration = 3000
						base_type = "Recovery"
						hydro_gain = 130
						metab_gain = 0


						New()
							..()
							max_uses = rand(5,8)
							uses_left = max_uses
							src.desc_extra = "<font color=cyan>Uses Remaining: [uses_left]/[max_uses]</font>\n\n"
						Click(location,control,params)
							..()
							//Removes this item from the global Items list.
							if(items)
								if(src in items) items -= src
							params = params2list(params)
							if(params["left"])
								if(isturf(src.loc))
									usr.pickup(src)
									if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up x[src.stacks] [src]","actionoutput")
								else if(ismob(src.loc))
									if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
									usr.item_selected = src
									src.overlays -= /obj/effects/select_item
						proc
							use(var/mob/m,var/obj/items/i)
								if(!(i in m)) return

								if(m.thirst > 99)
									m.set_alert("Already hydrated",'alert.dmi',"alert")
									return

								if(m.eating)
									m.set_alert("Already drinking",'alert.dmi',"alert")
									return

								var/T = world.time
								i.apply_item_stats(m,T)

								if(i && m && i.loc == m && i == m.eating && i.time_eaten == T)
									i.uses_left--
									m.refresh_inv()
									m.eating = null

									i.desc_extra = "<font color=cyan>Uses Remaining: [i.uses_left]/[i.max_uses]</font>\n\n"

									if(i.uses_left <= 0)
										i.use_obj(m)

							drop(var/mob/m,var/obj/items/i)
								m.drop(i)

					cooked_deep_soup
						name = "Cooked Deep Soup"
						icon = 'Manyfoods.dmi'
						icon_state = "deepsoup"
						rarity = 5
						food = 1
						desc = "A perfected deep soup dish that restores heavily."
						act = /obj/items/consumables/food/special/cooked_deep_soup/proc/use
						//act_drop = /obj/items/consumables/food/special/cooked_deep_soup/proc/drop
						stacks = -1
						base_type = "Endurance"
						duration = 3000

						hydro_gain = 60
						metab_gain = 200



						New()
							..()
							max_uses = rand(6,8)
							uses_left = max_uses
							src.desc_extra = "<font color=green>Uses Remaining: [uses_left]/[max_uses]</font>\n\n"
						Click(location,control,params)
							..()
							//Removes this item from the global Items list.
							if(items)
								if(src in items) items -= src
							params = params2list(params)
							if(params["left"])
								if(isturf(src.loc))
									usr.pickup(src)
									if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up x[src.stacks] [src]","actionoutput")
								else if(ismob(src.loc))
									if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
									usr.item_selected = src
									src.overlays -= /obj/effects/select_item
						proc
							use(var/mob/m,var/obj/items/i)
								if(i in m)

									if(m.has_stomach == 0)
										m.set_alert("Unable to digest food",'alert.dmi',"alert")
										return

									if(m.hunger > 99)
										m.set_alert("Already full",'alert.dmi',"alert")
										return

									if(m.eating)
										m.set_alert("Already eating",'alert.dmi',"alert")
										return

									var/T = world.time
									i.apply_item_stats(m,T)

									if(i && m && i.loc == m && i == m.eating && i.time_eaten == T)
										i.uses_left--
										m.refresh_inv()
										m.eating = null

										i.desc_extra = "<font color=green>Uses Remaining: [i.uses_left]/[i.max_uses]</font>\n\n"

										if(i.uses_left <= 0)
											i.use_obj(m)

							drop(var/mob/m,var/obj/items/i)
								m.drop(i)

					deep_soup_bowl
						name = "Deep Soup Bowl"
						icon = 'Manyfoods.dmi'
						icon_state = "deepsoup"
						rarity = 4
						can_cook = 1
						stacks = -1
						food = 1
						desc = "A large bowl of soup that can be eaten multiple times."

						act = /obj/items/consumables/food/special/deep_soup_bowl/proc/use
						//act_drop = /obj/items/consumables/food/special/deep_soup_bowl/proc/drop
						cooked_type = /obj/items/consumables/food/special/cooked_deep_soup

						base_type = "Endurance"

						hydro_gain = 25
						metab_gain = 40

						New()
							..()
							max_uses = rand(5,8)
							uses_left = max_uses
							src.desc_extra = "<font color=green>Uses Remaining: [uses_left]/[max_uses]</font>\n\n"
						Click(location,control,params)
							..()
							//Removes this item from the global Items list.
							if(items)
								if(src in items) items -= src
							params = params2list(params)
							if(params["left"])
								if(isturf(src.loc))
									usr.pickup(src)
									if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up x[src.stacks] [src]","actionoutput")
								else if(ismob(src.loc))
									if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
									usr.item_selected = src
									src.overlays -= /obj/effects/select_item
						proc
							use(var/mob/m,var/obj/items/i)
								if(!(i in m)) return

								if(m.has_stomach == 0)
									m.set_alert("Unable to digest food",'alert.dmi',"alert")
									return

								if(m.hunger > 99)
									m.set_alert("Already full",'alert.dmi',"alert")
									return

								if(m.eating)
									m.set_alert("Already eating",'alert.dmi',"alert")
									return

								var/T = world.time
								i.apply_item_stats(m,T)

								if(i && m && i.loc == m && i == m.eating && i.time_eaten == T)
									i.uses_left--
									m.refresh_inv()
									m.eating = null

									i.desc_extra = "<font color=green>Uses Remaining: [i.uses_left]/[i.max_uses]</font>\n\n"

									if(i.uses_left <= 0)
										i.use_obj(m)

							drop(var/mob/m,var/obj/items/i)
								m.drop(i)

				baked_bread
					name = "Baked Bread"
					icon = 'Manyfoods.dmi'
					icon_state = "cBread"
					rarity = 1
				//	can_cook=1
					food = 1
					desc = "Cooked bread, the best quality of pasty."
					act = /obj/items/consumables/food/baked_bread/proc/use
					//act_drop = /obj/items/consumables/food/baked_bread/proc/drop
					base_type = "Strength"
					duration = 3000

					//Duration in 1/10 seconds

					//Does the drug have a comedown or not, and how long does it last

					//Changed permanently when taken
					metab_gain = 45

					//Changed temporarily when taken

					//Changed temporarily when wears off
					proc
						use(var/mob/m,var/obj/items/i)
							if(i in m)
								if(m.has_stomach == 0)
									m.set_alert("Unable to digest food",'alert.dmi',"alert")
									return

								if(m.hunger > 100)
									m.set_alert("Already full",'alert.dmi',"alert")
									return
								if(m.eating)
									m.set_alert("Already drinking",'alert.dmi',"alert")
									return
								var/T = world.time
								i.apply_item_stats(m,T)
								if(i && m && i.loc == m && i.stacks > 0 && i == m.eating && i.time_eaten == T)
									i.use_obj(m)
									m.refresh_inv()
									if(m) m.eating = null
						drop(var/mob/m,var/obj/items/i)
							m.drop(i)
					New()
						..()
					//	src.desc_extra = "[src.create_item_desc()]\n\n"
					Click(location,control,params)
						..()
						//Removes this item from the global Items list.
						if(items)
							if(src in items) items -= src
						params = params2list(params)
						if(params["left"])
							if(isturf(src.loc))
								usr.pickup(src)
								if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up x[src.stacks] [src]","actionoutput")
							else if(ismob(src.loc))
								if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
								usr.item_selected = src
								src.overlays -= /obj/effects/select_item
				cooked_meat_soup
					name = "Cooked Meat Soup"
					icon = 'foods.dmi'
					icon_state = "dragon soup"
					rarity = 1
					food = 1
				//	can_cook=1
					desc = "Cooked meat soup, the best quality dish."
					act = /obj/items/consumables/food/cooked_meat_soup/proc/use
					//act_drop = /obj/items/consumables/food/cooked_meat_soup/proc/drop
					//Toxic buildup from taking drug
					base_type = "Endurance"
					duration = 3000

					//Duration in 1/10 seconds

					//Does the drug have a comedown or not, and how long does it last

					//Changed permanently when taken
					hydro_gain = 40
					metab_gain = 200

					//Changed temporarily when taken

					//Changed temporarily when wears off
					proc
						use(var/mob/m,var/obj/items/i)
							if(i in m)
								if(m.has_stomach == 0)
									m.set_alert("Unable to digest food",'alert.dmi',"alert")
									return
								if(m.hunger > 99)
									m.set_alert("Already full",'alert.dmi',"alert")
									return

								if(m.eating)
									m.set_alert("Already drinking",'alert.dmi',"alert")
									return
								var/T = world.time
								i.apply_item_stats(m,T)
								if(i && m && i.loc == m && i.stacks > 0 && i == m.eating && i.time_eaten == T)
									i.use_obj(m)
									m.refresh_inv()
									if(m) m.eating = null
						drop(var/mob/m,var/obj/items/i)
							m.drop(i)
					New()
						..()
					//	src.desc_extra = "[src.create_item_desc()]\n\n"
					Click(location,control,params)
						..()
						//Removes this item from the global Items list.
						if(items)
							if(src in items) items -= src
						params = params2list(params)
						if(params["left"])
							if(isturf(src.loc))
								usr.pickup(src)
								if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up x[src.stacks] [src]","actionoutput")
							else if(ismob(src.loc))
								if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
								usr.item_selected = src
								src.overlays -= /obj/effects/select_item
								src.overlays += /obj/effects/select_item
				cooked_soup
					name = "Cooked Soup"
					icon = 'Manyfoods.dmi'
					icon_state = "cRawSoup"
					rarity = 1
				//	can_cook=1
					desc = "Cooked soup, the best quality dish."
					act = /obj/items/consumables/food/cooked_soup/proc/use
					//act_drop = /obj/items/consumables/food/cooked_soup/proc/drop
					//Toxic buildup from taking drug
					base_type = "Endurance"
					duration = 3000
					food = 1

					//Duration in 1/10 seconds

					//Does the drug have a comedown or not, and how long does it last

					//Changed permanently when taken
					hydro_gain = 40
					metab_gain = 159

					//Changed temporarily when taken

					//Changed temporarily when wears off
					proc
						use(var/mob/m,var/obj/items/i)
							if(i in m)
								if(m.has_stomach == 0)
									m.set_alert("Unable to digest food",'alert.dmi',"alert")
									return
								if(m.hunger > 99)
									m.set_alert("Already full",'alert.dmi',"alert")
									return
								if(m.eating)
									m.set_alert("Already drinking",'alert.dmi',"alert")
									return
								var/T = world.time
								i.apply_item_stats(m,T)
								if(i && m && i.loc == m && i.stacks > 0 && i == m.eating && i.time_eaten == T)
									i.use_obj(m)
									m.refresh_inv()
									if(m) m.eating = null
						drop(var/mob/m,var/obj/items/i)
							m.drop(i)
					New()
						..()
					//	src.desc_extra = "[src.create_item_desc()]\n\n"
					Click(location,control,params)
						..()
						//Removes this item from the global Items list.
						if(items)
							if(src in items) items -= src
						params = params2list(params)
						if(params["left"])
							if(isturf(src.loc))
								usr.pickup(src)
								if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up x[src.stacks] [src]","actionoutput")
							else if(ismob(src.loc))
								if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
								usr.item_selected = src
								src.overlays -= /obj/effects/select_item
								src.overlays += /obj/effects/select_item

				baked_potato
					name = "Baked Potato"
					icon = 'consumables.dmi'
					icon_state = "potato ground"
					rarity = 1
				//	can_cook=1
					desc = "Cooked potato, the best quality of vegetables."
					act = /obj/items/consumables/food/baked_potato/proc/use
					//act_drop = /obj/items/consumables/food/baked_potato/proc/drop
					base_type = "Strength"
					duration = 3000

					//Duration in 1/10 seconds

					//Does the drug have a comedown or not, and how long does it last

					//Changed permanently when taken
					metab_gain = 5

					//Changed temporarily when taken

					//Changed temporarily when wears off
					proc
						use(var/mob/m,var/obj/items/i)
							if(i in m)
								if(m.has_stomach == 0)
									m.set_alert("Unable to digest food",'alert.dmi',"alert")
									return

								if(m.hunger > 99)
									m.set_alert("Already full",'alert.dmi',"alert")
									return
								if(m.eating)
									m.set_alert("Already drinking",'alert.dmi',"alert")
									return
								var/T = world.time
								i.apply_item_stats(m,T)
								if(i && m && i.loc == m && i.stacks > 0 && i == m.eating && i.time_eaten == T)
									i.use_obj(m)
									m.refresh_inv()
									if(m) m.eating = null
						drop(var/mob/m,var/obj/items/i)
							m.drop(i)
					New()
						..()
					//	src.desc_extra = "[src.create_item_desc()]\n\n"
					Click(location,control,params)
						..()
						//Removes this item from the global Items list.
						if(items)
							if(src in items) items -= src
						params = params2list(params)
						if(params["left"])
							if(isturf(src.loc))
								usr.pickup(src)
								if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up x[src.stacks] [src]","actionoutput")
							else if(ismob(src.loc))
								if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
								usr.item_selected = src
								src.overlays -= /obj/effects/select_item
				cooked_celery
					name = "Cooked Celery"
					icon = 'consumables.dmi'
					icon_state = "celery ground"
					rarity = 1
				//	can_cook=1
					desc = "Cooked celery, the best quality of vegetables."
					act = /obj/items/consumables/food/cooked_celery/proc/use
				//	act_drop = /obj/items/consumables/food/cooked_celery/proc/drop
					base_type = "Strength"
					duration = 3000

					//Duration in 1/10 seconds

					//Does the drug have a comedown or not, and how long does it last

					//Changed permanently when taken
					metab_gain = 8

					//Changed temporarily when taken

					//Changed temporarily when wears off
					proc
						use(var/mob/m,var/obj/items/i)
							if(i in m)
								if(m.has_stomach == 0)
									m.set_alert("Unable to digest food",'alert.dmi',"alert")
									return

								if(m.hunger > 99)
									m.set_alert("Already full",'alert.dmi',"alert")
									return
								if(m.eating)
									m.set_alert("Already drinking",'alert.dmi',"alert")
									return
								var/T = world.time
								i.apply_item_stats(m,T)
								if(i && m && i.loc == m && i.stacks > 0 && i == m.eating && i.time_eaten == T)
									i.use_obj(m)
									m.refresh_inv()
									if(m) m.eating = null
						drop(var/mob/m,var/obj/items/i)
							m.drop(i)
					New()
						..()
					//	src.desc_extra = "[src.create_item_desc()]\n\n"
					Click(location,control,params)
						..()
						//Removes this item from the global Items list.
						if(items)
							if(src in items) items -= src
						params = params2list(params)
						if(params["left"])
							if(isturf(src.loc))
								usr.pickup(src)
								if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up x[src.stacks] [src]","actionoutput")
							else if(ismob(src.loc))
								if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
								usr.item_selected = src
								src.overlays -= /obj/effects/select_item
				cooked_carrot
					name = "Cooked Carrot"
					icon = 'consumables.dmi'
					icon_state = "carrot ground"
					rarity = 1
				//	can_cook=1
					desc = "Cooked carrot, the best quality of vegetables."
					act = /obj/items/consumables/food/cooked_carrot/proc/use
					//act_drop = /obj/items/consumables/food/cooked_carrot/proc/drop
					base_type = "Strength"
					duration = 3000

					//Duration in 1/10 seconds

					//Does the drug have a comedown or not, and how long does it last

					//Changed permanently when taken
					metab_gain = 8

					//Changed temporarily when taken

					//Changed temporarily when wears off
					proc
						use(var/mob/m,var/obj/items/i)
							if(i in m)
								if(m.has_stomach == 0)
									m.set_alert("Unable to digest food",'alert.dmi',"alert")
									return

								if(m.hunger > 99)
									m.set_alert("Already full",'alert.dmi',"alert")
									return
								if(m.eating)
									m.set_alert("Already drinking",'alert.dmi',"alert")
									return
								var/T = world.time
								i.apply_item_stats(m,T)
								if(i && m && i.loc == m && i.stacks > 0 && i == m.eating && i.time_eaten == T)
									i.use_obj(m)
									m.refresh_inv()
									if(m) m.eating = null
						drop(var/mob/m,var/obj/items/i)
							m.drop(i)
					New()
						..()
					//	src.desc_extra = "[src.create_item_desc()]\n\n"
					Click(location,control,params)
						..()
						//Removes this item from the global Items list.
						if(items)
							if(src in items) items -= src
						params = params2list(params)
						if(params["left"])
							if(isturf(src.loc))
								usr.pickup(src)
								if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up x[src.stacks] [src]","actionoutput")
							else if(ismob(src.loc))
								if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
								usr.item_selected = src
								src.overlays -= /obj/effects/select_item



				cooked_steak
					name = "Cooked Steak"
					icon = 'Manyfoods.dmi'
					icon_state = "steak"
					rarity = 1
				//	can_cook=1
					desc = "Cooked meat, the best quality of food."
					act = /obj/items/consumables/food/cooked_steak/proc/use
					//act_drop = /obj/items/consumables/food/cooked_steak/proc/drop
					//Toxic buildup from taking drug
					toxic = 1
					toxin_gain = 0.0001
					toxicity = 15
					base_type = "Strength"
					duration = 3000

					//Duration in 1/10 seconds

					//Does the drug have a comedown or not, and how long does it last

					//Changed permanently when taken
					//hydro_gain = 105
					metab_gain = 70

					//Changed temporarily when taken

					//Changed temporarily when wears off
					proc
						use(var/mob/m,var/obj/items/i)
							if(i in m)
								if(m.has_stomach == 0)
									m.set_alert("Unable to digest food",'alert.dmi',"alert")
									return
								if(m.hunger > 99)
									m.set_alert("Already full",'alert.dmi',"alert")
									return
								if(m.eating)
									m.set_alert("Already drinking",'alert.dmi',"alert")
									return
								var/T = world.time
								i.apply_item_stats(m,T)
								if(i && m && i.loc == m && i.stacks > 0 && i == m.eating && i.time_eaten == T)
									i.use_obj(m)
									m.refresh_inv()
									if(m) m.eating = null
						drop(var/mob/m,var/obj/items/i)
							m.drop(i)
					New()
						..()
					//	src.desc_extra = "[src.create_item_desc()]\n\n"
					Click(location,control,params)
						..()
						//Removes this item from the global Items list.
						if(items)
							if(src in items) items -= src
						params = params2list(params)
						if(params["left"])
							if(isturf(src.loc))
								usr.pickup(src)
								if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up x[src.stacks] [src]","actionoutput")
							else if(ismob(src.loc))
								if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
								usr.item_selected = src
								src.overlays -= /obj/effects/select_item
								src.overlays += /obj/effects/select_item
				cooked_legmeat
					name = "Cooked Leg Meat"
					icon = 'Manyfoods.dmi'
					icon_state = "leg"
					rarity = 1
					//can_cook=1
					desc = "Cooked meat, the best quality of food."
					act = /obj/items/consumables/food/cooked_legmeat/proc/use
					//act_drop = /obj/items/consumables/food/cooked_legmeat/proc/drop
					//Toxic buildup from taking drug
					base_type = "Endurance"
					duration = 3000
					//Duration in 1/10 seconds

					//Does the drug have a comedown or not, and how long does it last

					//Changed permanently when taken
					//hydro_gain = 105
					metab_gain = 70

					//Changed temporarily when taken

					//Changed temporarily when wears off
					proc
						use(var/mob/m,var/obj/items/i)
							if(i in m)
								if(m.has_stomach == 0 )
									m.set_alert("Unable to eat.",'alert.dmi',"alert")

									return
								if(m.hunger > 99)
									m.set_alert("Already full",'alert.dmi',"alert")

									return
								if(m.eating)
									m.set_alert("Already eating",'alert.dmi',"alert")

									return
								var/T = world.time
								i.apply_item_stats(m,T)
								if(i && m && i.loc == m && i.stacks > 0 && i == m.eating && i.time_eaten == T)
									i.use_obj(m)
									m.refresh_inv()
									if(m) m.eating = null
						drop(var/mob/m,var/obj/items/i)
							m.drop(i)
					New()
						..()
						src.desc_extra = "[src.create_item_desc()]\n\n"
					Click(location,control,params)
						..()
						//Removes this item from the global Items list.
						if(items)
							if(src in items) items -= src
						params = params2list(params)
						if(params["left"])
							if(isturf(src.loc))
								usr.pickup(src)
								if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up x[src.stacks] [src]","actionoutput")
							else if(ismob(src.loc))
								if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
								usr.item_selected = src
								src.overlays -= /obj/effects/select_item
								src.overlays += /obj/effects/select_item
				raw_steak
					name = "Raw Steak"
					icon = 'Manyfoods.dmi'
					icon_state = "steak"
					rarity = 1
					can_cook=1
					desc = "Raw meat, the worst quality of food."
					act = /obj/items/consumables/food/raw_steak/proc/use
					//act_drop = /obj/items/consumables/food/raw_steak/proc/drop
					//Toxic buildup from taking drug
					toxic = 1
					toxin_gain = 0.0001
					toxicity = 15
					base_type = "Strength"
					duration = 3000
					food=1
					cooked_type = /obj/items/consumables/food/cooked_steak
					//Duration in 1/10 seconds

					//Does the drug have a comedown or not, and how long does it last

					//Changed permanently when taken
				//	hydro_gain = 55
					metab_gain = 10

					//Changed temporarily when taken

					//Changed temporarily when wears off
					proc
						use(var/mob/m,var/obj/items/i)
							if(i in m)
								if(m.has_stomach == 0)
									m.set_alert("Unable to digest food",'alert.dmi',"alert")
									return

								if(m.hunger > 99)
									m.set_alert("Already full",'alert.dmi',"alert")
									return
								if(m.eating)
									m.set_alert("Already eating",'alert.dmi',"alert")
									return
								var/T = world.time
								i.apply_item_stats(m,T)
								if(i && m && i.loc == m && i.stacks > 0 && i == m.eating && i.time_eaten == T)
									i.use_obj(m)
									m.refresh_inv()
									if(m) m.eating = null
						drop(var/mob/m,var/obj/items/i)
							m.drop(i)
					New()
						..()
					//	src.desc_extra = "[src.create_item_desc()]\n\n"
					Click(location,control,params)
						..()
						//Removes this item from the global Items list.
						if(items)
							if(src in items) items -= src
						params = params2list(params)
						if(params["left"])
							if(isturf(src.loc))
								usr.pickup(src)
								if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up x[src.stacks] [src]","actionoutput")
							else if(ismob(src.loc))
								if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
								usr.item_selected = src
								src.overlays -= /obj/effects/select_item
								src.overlays += /obj/effects/select_item
				raw_legmeat
					name = "Raw Leg Meat"
					icon = 'Manyfoods.dmi'
					icon_state = "leg"
					rarity = 1
					can_cook=1
					food=1
					desc = "Raw meat, the worst quality of food."
					act = /obj/items/consumables/food/raw_legmeat/proc/use
					//act_drop = /obj/items/consumables/food/raw_legmeat/proc/drop
					//Toxic buildup from taking drug
					toxic = 1
					toxin_gain = 0.0001
					toxicity = 15
					base_type = "Endurance"
					duration = 3000
					cooked_type = /obj/items/consumables/food/cooked_legmeat
					//Duration in 1/10 seconds

					//Does the drug have a comedown or not, and how long does it last

					//Changed permanently when taken
					//hydro_gain = 55
					metab_gain = 10

					//Changed temporarily when taken

					//Changed temporarily when wears off
					proc
						use(var/mob/m,var/obj/items/i)
							if(i in m)
								if(m.has_stomach == 0 )
									m.set_alert("Unable to drink liquids",'alert.dmi',"alert")

									return

								if(m.hunger > 99)
									m.set_alert("Already full",'alert.dmi',"alert")

									return
								if(m.eating)
									m.set_alert("Already eating",'alert.dmi',"alert")

									return
								var/T = world.time
								i.apply_item_stats(m,T)
								if(i && m && i.loc == m && i.stacks > 0 && i == m.eating && i.time_eaten == T)
									i.use_obj(m)
									m.refresh_inv()
									if(m) m.eating = null
						drop(var/mob/m,var/obj/items/i)
							m.drop(i)
					New()
						..()
					//	src.desc_extra = "[src.create_item_desc()]\n\n"
					Click(location,control,params)
						..()
						//Removes this item from the global Items list.
						if(items)
							if(src in items) items -= src
						params = params2list(params)
						if(params["left"])
							if(isturf(src.loc))
								usr.pickup(src)
								if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up x[src.stacks] [src]","actionoutput")
							else if(ismob(src.loc))
								if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
								usr.item_selected = src
								src.overlays -= /obj/effects/select_item
								src.overlays += /obj/effects/select_item
			water
				coffee
					name = "Coffee"
					icon_state = "coffee"
					rarity = 1
					desc = "Darkly colored, bitter, and slightly acidic, coffee has a stimulating effect on people, primarily due to its caffeine content."
					act = /obj/items/consumables/water/coffee/proc/use
					//act_drop = /obj/items/consumables/water/coffee/proc/drop
					base_type = "Speed"
					//Toxic buildup from taking drug

					//Duration in 1/10 seconds

					//Does the drug have a comedown or not, and how long does it last

					//Changed permanently when taken
					hydro_gain = 60

					//Changed temporarily when taken

					//Changed temporarily when wears off
					proc
						use(var/mob/m,var/obj/items/i)
							if(i in m)
								if(m.has_stomach == 0 && m.race!="Namekian")
									m.set_alert("Unable to drink liquids",'alert.dmi',"alert")

									return
								if(m.thirst > 99)
									m.set_alert("Already full",'alert.dmi',"alert")

									return
								if(m.eating)
									m.set_alert("Already drinking",'alert.dmi',"alert")

									return
								var/T = world.time
								i.apply_item_stats(m,T)
								if(i && m && i.loc == m && i.stacks > 0 && i == m.eating && i.time_eaten == T)
									i.use_obj(m)
									m.refresh_inv()
									if(m) m.eating = null
						drop(var/mob/m,var/obj/items/i)
							m.drop(i)
					New()
						..()
					//	src.desc_extra = "[src.create_item_desc()]\n\n"
					Click(location,control,params)
						..()
						//Removes this item from the global Items list.
						if(items)
							if(src in items) items -= src
						params = params2list(params)
						if(params["left"])
							if(isturf(src.loc))
								usr.pickup(src)
								if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up x[src.stacks] [src]","actionoutput")
							else if(ismob(src.loc))
								if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
								usr.item_selected = src
								src.overlays -= /obj/effects/select_item
								src.overlays += /obj/effects/select_item
				energy_drink
					name = "Energy Drink"
					icon_state = "energy drink"
					rarity = 1
					desc = "Mental and physical stimulation in a can!"
					act = /obj/items/consumables/water/energy_drink/proc/use
				//	act_drop = /obj/items/consumables/water/energy_drink/proc/drop
					base_type = "Force"
					//Toxic buildup from taking drug

					//Duration in 1/10 seconds

					//Does the drug have a comedown or not, and how long does it last

					//Changed permanently when taken
					hydro_gain = 60

					//Changed temporarily when taken

					//Changed temporarily when wears off
					proc
						use(var/mob/m,var/obj/items/i)
							if(i in m)
								if(m.has_stomach == 0 && m.race!="Namekian")
									m.set_alert("Unable to drink liquids",'alert.dmi',"alert")

									return
								if(m.thirst > 99)
									m.set_alert("Already full",'alert.dmi',"alert")

									return
								if(m.eating)
									m.set_alert("Already drinking",'alert.dmi',"alert")

									return
								var/T = world.time
								i.apply_item_stats(m,T)
								if(i && m && i.loc == m && i.stacks > 0 && i == m.eating && i.time_eaten == T)
									i.use_obj(m)
									m.refresh_inv()
									if(m) m.eating = null
						drop(var/mob/m,var/obj/items/i)
							m.drop(i)
					New()
						..()
					//	src.desc_extra = "[src.create_item_desc()]\n\n"
					Click(location,control,params)
						..()
						//Removes this item from the global Items list.
						if(items)
							if(src in items) items -= src
						params = params2list(params)
						if(params["left"])
							if(isturf(src.loc))
								usr.pickup(src)
								if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up x[src.stacks] [src]","actionoutput")
							else if(ismob(src.loc))
								if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
								usr.item_selected = src
								src.overlays -= /obj/effects/select_item
								src.overlays += /obj/effects/select_item
				cola
					name = "Cola"
					icon_state = "cola"
					rarity = 1
					desc = "A caramel and spice combination drink that derives it's name from the original source of caffeine: the Kola nut."
					act = /obj/items/consumables/water/cola/proc/use
					//act_drop = /obj/items/consumables/water/cola/proc/drop
					//Toxic buildup from taking drug

					//Duration in 1/10 seconds

					//Does the drug have a comedown or not, and how long does it last

					//Changed permanently when taken
					hydro_gain = 40

					//Changed temporarily when taken

					//Changed temporarily when wears off
					proc
						use(var/mob/m,var/obj/items/i)
							if(i in m)
								if(m.has_stomach == 0 && m.race!="Namekian")
									m.set_alert("Unable to drink liquids",'alert.dmi',"alert")

									return
								if(m.thirst > 99)
									m.set_alert("Already full",'alert.dmi',"alert")

									return
								if(m.eating)
									m.set_alert("Already drinking",'alert.dmi',"alert")

									return
								var/T = world.time
								i.apply_item_stats(m,T)
								if(i && m && i.loc == m && i.stacks > 0 && i == m.eating && i.time_eaten == T)
									i.use_obj(m)
									m.refresh_inv()
									if(m) m.eating = null
						drop(var/mob/m,var/obj/items/i)
							m.drop(i)
					New()
						..()
					//	src.desc_extra = "[src.create_item_desc()]\n\n"
					Click(location,control,params)
						..()
						//Removes this item from the global Items list.
						if(items)
							if(src in items) items -= src
						params = params2list(params)
						if(params["left"])
							if(isturf(src.loc))
								usr.pickup(src)
								if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up x[src.stacks] [src]","actionoutput")
							else if(ismob(src.loc))
								if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
								usr.item_selected = src
								src.overlays -= /obj/effects/select_item
								src.overlays += /obj/effects/select_item
				water_bottle_dirty
					name = "Bottle of Sea Water"
					icon_state = "water bottle dirty"
					rarity = 1
					can_cook=1
					desc = "Water is an inorganic compound with the chemical formula H2O. It is a transparent, tasteless, odorless, and nearly colorless chemical substance."
					act = /obj/items/consumables/water/water_bottle_dirty/proc/use
					//act_drop = /obj/items/consumables/water/water_bottle_dirty/proc/drop
					cooked_type = /obj/items/consumables/water/water_bottle
					//Toxic buildup from taking drug
					toxic = 1
					toxin_gain = 5.000125
					toxicity = 75
					base_type = "Recovery"

					duration = 3000
					//Duration in 1/10 seconds

					//Does the drug have a comedown or not, and how long does it last

					//Changed permanently when taken
					hydro_gain = 60

					//Changed temporarily when taken

					//Changed temporarily when wears off
					proc
						use(var/mob/m,var/obj/items/i)
							if(i in m)
								if(m.has_stomach == 0 && m.race!="Namekian")
									m.set_alert("Unable to drink liquids",'alert.dmi',"alert")

									return
								if(m.thirst > 99)
									m.set_alert("Already quenched",'alert.dmi',"alert")

									return
								if(m.eating)
									m.set_alert("Already drinking",'alert.dmi',"alert")

									return
								var/T = world.time
								i.apply_item_stats(m,T)
								if(i && m && i.loc == m && i.stacks > 0 && i == m.eating && i.time_eaten == T)
									i.use_obj(m)
									m.refresh_inv()
									if(m) m.eating = null
						//drop(var/mob/m,var/obj/items/i)
						//	m.drop(i)
					New()
						..()
					//	src.desc_extra = "[src.create_item_desc()]\n\n"
					Click(location,control,params)
						..()
						//Removes this item from the global Items list.
						if(items)
							if(src in items) items -= src
						params = params2list(params)
						if(params["left"])
							if(isturf(src.loc))
								usr.pickup(src)
								if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up x[src.stacks] [src]","actionoutput")
							else if(ismob(src.loc))
								if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
								usr.item_selected = src
								src.overlays -= /obj/effects/select_item
								src.overlays += /obj/effects/select_item
				water_bottle_sea
					name = "Bottle of Sea Water"
					icon_state = "water bottle"
					rarity = 1
					can_cook=1
					dirty = 1
					desc = "Water is an inorganic compound with the chemical formula H2O. It is a transparent, tasteless, odorless, and nearly colorless chemical substance. This one tastes salty."
					act = /obj/items/consumables/water/water_bottle_sea/proc/use
					//act_drop = /obj/items/consumables/water/water_bottle_sea/proc/drop
					cooked_type = /obj/items/consumables/water/water_bottle
					base_type = "Recovery"
					//Toxic buildup from taking drug
					toxic = 1
					toxin_gain = 2.000125
					toxicity = 35
					//Duration in 1/10 seconds
					duration = 6000

					//Does the drug have a comedown or not, and how long does it last

					//Changed permanently when taken
					hydro_gain = 60

					//Changed temporarily when taken
					hydro_gain_temp = 1

					//Changed temporarily when wears off
					proc
						use(var/mob/m,var/obj/items/i)
							if(i in m)
								if(m.has_stomach == 0 && m.race!="Namekian")
									m.set_alert("Unable to drink liquids",'alert.dmi',"alert")

									return
								if(m.thirst > 99)
									m.set_alert("Already quenched",'alert.dmi',"alert")

									return
								if(m.eating)
									m.set_alert("Already drinking",'alert.dmi',"alert")

									return
								var/T = world.time
								i.apply_item_stats(m,T)
								if(i && m && i.loc == m && i.stacks > 0 && i == m.eating && i.time_eaten == T)
									for(var/obj/body_related/bodyparts/torso/t in m.bodyparts)
										for(var/obj/body_related/bodyparts/torso/left_kidney/lk in t)
											m.damage_limb(i,0, 1, 25,lk)
											break
										for(var/obj/body_related/bodyparts/torso/right_kidney/rk in t)
											m.damage_limb(i,0, 1, 25,rk)
											break
									var/obj/items/consumables/water/water_bottle_empty/b = new
									b.loc = m
									m.pickup(b,1)
									var/repeat = i.apply_same_drug(m)
									if(repeat == 0) i.create_drug_buff(m)
									i.use_obj(m)
									m.refresh_inv()
									if(m) m.eating = null
						//drop(var/mob/m,var/obj/items/i)
						//	m.drop(i)
					New()
						..()
					//	src.desc_extra = "[src.create_item_desc()]\n\n"
					Click(location,control,params)
						..()
						//Removes this item from the global Items list.
						if(items)
							if(src in items) items -= src
						params = params2list(params)
						if(params["left"])
							if(isturf(src.loc))
								usr.pickup(src)
								if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up x[src.stacks] [src]","actionoutput")
							else if(ismob(src.loc))
								if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
								usr.item_selected = src
								src.overlays -= /obj/effects/select_item
								src.overlays += /obj/effects/select_item
				water_bottle_empty
					name = "Empty Bottle"
					icon_state = "water bottle empty"
					rarity = 1
					desc = "Empty plastic bottle"
					act = /obj/items/consumables/water/water_bottle_empty/proc/use
					//act_drop = /obj/items/consumables/water/water_bottle_empty/proc/drop
					//Toxic buildup from taking drug

					//Duration in 1/10 seconds

					//Does the drug have a comedown or not, and how long does it last

					//Changed permanently when taken

					//Changed temporarily when taken

					//Changed temporarily when wears off
					proc
						use(var/mob/m,var/obj/items/i)
							if(i in m)
								var/found_water = 0
								for(var/turf/t in m.locs)
									if(t.type == /turf/water/water5)
										var/obj/items/consumables/water/water_bottle/b = new
										b.loc = m
										m.pickup(b,1)
										found_water = 1
										break
									if(t.type == /turf/water/water_ocean)
										var/obj/items/consumables/water/water_bottle_sea/b = new
										b.loc = m
										m.pickup(b,1)
										found_water = 1
										break
									if(istype(t,/turf/snows/))
										var/obj/items/consumables/water/water_bottle/b = new
										b.loc = m
										m.pickup(b,1)
										found_water = 1
										break
								if(found_water)
									i.use_obj(m)
									m.refresh_inv()
						//drop(var/mob/m,var/obj/items/i)
						//	m.drop(i)
					New()
						..()
					//	src.desc_extra = "[src.create_item_desc()]\n\n"
					Click(location,control,params)
						..()
						//Removes this item from the global Items list.
						if(items)
							if(src in items) items -= src
						params = params2list(params)
						if(params["left"])
							if(isturf(src.loc))
								usr.pickup(src)
								if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up x[src.stacks] [src]","actionoutput")
							else if(ismob(src.loc))
								if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
								usr.item_selected = src
								src.overlays -= /obj/effects/select_item
								src.overlays += /obj/effects/select_item
				water_bottle
					name = "Bottle of Water"
					icon_state = "water bottle"
					rarity = 1
					food=1
					desc = "Water is an inorganic compound with the chemical formula H2O. It is a transparent, tasteless, odorless, and nearly colorless chemical substance."
					act = /obj/items/consumables/water/water_bottle/proc/use
					//act_drop = /obj/items/consumables/water/water_bottle/proc/drop
					base_type = "Recovery"
					//Toxic buildup from taking drug

					//Duration in 1/10 seconds

					//Does the drug have a comedown or not, and how long does it last

					//Changed permanently when taken
					hydro_gain = 60

					//Changed temporarily when taken

					//Changed temporarily when wears off
					proc
						use(var/mob/m,var/obj/items/i)
							if(i in m)
								if(m.has_stomach == 0 && m.race!="Namekian")
									m.set_alert("Unable to drink liquids",'alert.dmi',"alert")

									return
								if(m.thirst > 99)
									m.set_alert("Already quenched",'alert.dmi',"alert")

									return
								if(m.eating)
									m.set_alert("Already drinking",'alert.dmi',"alert")

									return
								var/T = world.time
								i.apply_item_stats(m,T)
								if(i && m && i.loc == m && i.stacks > 0 && i == m.eating && i.time_eaten == T)
									var/obj/items/consumables/water/water_bottle_empty/b = new
									b.loc = m
									m.pickup(b,1)
									i.use_obj(m)
									m.refresh_inv()
									if(m) m.eating = null
						//drop(var/mob/m,var/obj/items/i)
						//	m.drop(i)
					New()
						..()
					//	src.desc_extra = "[src.create_item_desc()]\n\n"
					Click(location,control,params)
						..()
						//Removes this item from the global Items list.
						if(items)
							if(src in items) items -= src
						params = params2list(params)
						if(params["left"])
							if(isturf(src.loc))
								usr.pickup(src)
								if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up x[src.stacks] [src]","actionoutput")
							else if(ismob(src.loc))
								if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
								usr.item_selected = src
								src.overlays -= /obj/effects/select_item
								src.overlays += /obj/effects/select_item
			seeds
				icon = 'PlantsSov.dmi'
				icon_state = "Seed"
				// Agriculture System - Planting & Growth
				var/growth_stage = 0
				var/max_stage = 3 // Seed -> Sprout -> Growing -> Fully Grown
				var/water_needed = 5
				var/current_water = 0
				desc = "A tiny organic speckle capable of sprouting life, mostly for food."
				bolted = 0
				can_pocket = 1 // Uses existing var from vars_obj.dm
				var/icon_state_list = list("Seed", "sprout", "growing", "harvest","rotten")

				var/next_phase=0
				//stacks = -1


				New(var/duplicate = 0,var/obj/dupe)
					..()
					src.icon = 'PlantsSov.dmi'
					src.icon_state = icon_state_list[1] // Start as seed

					if(duplicate && dupe)
						if(dupe)
							src.name = dupe.name
							src.plant_type = dupe.plant_type
							src.tech_lvl = dupe.tech_lvl
						return

				//	src.desc_extra = "[src.create_item_desc()]\n\n"
					switch(rand(1,7))
						if(1)
							src.name="Potato Seed"
							src.plant_type = "Potato"
							src.tech_lvl = 1
						if(2)
							src.name="Carrot Seed"
							src.plant_type = "Carrot"
							src.tech_lvl = 2
						if(3)
							src.name="Celery Seed"
							src.plant_type = "Celery"
							src.tech_lvl = 3
						if(4)
							src.name="Watermelon Seed"
							src.plant_type = "Watermelon"
							src.tech_lvl = 4
						if(5)
							src.name="Tomato Seed"
							src.plant_type = "Tomato"
							src.tech_lvl = 5
						if(6)
							src.name="Banana Seed"
							src.plant_type = "Banana"
							src.tech_lvl = 6
						if(7)
							src.name="Wheat Seed"
							src.plant_type = "Wheat"
							src.tech_lvl = 7
					icon_state_list = list("Seed","[src.name]1","[src.name]2","[src.name]3")


				Click(location,control,params)
					..()
					//Removes this item from the global Items list.
					if(items)
						if(src in items) items -= src
					params = params2list(params)
					if(params["left"])
						if(src.bolted)
							if(src in range(1,usr))
								usr.set_alert("You cannot pick this up right now!",'alert.dmi',"alert")
								return
						else if(isturf(src.loc))
							usr.pickup(src)
							if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up x[src.stacks] [src]","actionoutput")
						else if(ismob(src.loc))
							if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
							usr.item_selected = src
							src.overlays -= /obj/effects/select_item
							src.overlays += /obj/effects/select_item



				MouseDrop(atom/target, src_location, target_location)
					if(target.loc != usr)
						if(istype(target, /obj/items/consumables/water/water_bottle))
							if(target.dirty) return
							var/obj/items/consumables/water/water_bottle/B = target
							var/amount = input(usr, "How much water do you want to pour?", "Watering", 1) as num
							if(amount > B.stacks)
								usr << "You don't have enough water."
								return
							B.stacks = (B.stacks - amount)
							usr.remove(B,amount)
							usr.refresh_inv()
							src.Water(amount)


				proc/Water(amount)
					if(growth_stage >= max_stage)
						usr << "This plant is already fully grown."
						return

					src.current_water += amount
					if(src.current_water >= src.water_needed)
						src.underlays+='cropunderlay.dmi'
						StartGrowth(amount)
					else
						usr.set_alert("The plant has absorbed some water, but still needs more.",'alert.dmi',"alert")


				proc/StartGrowth(var/amount)

					if(next_phase == 1)
						src.underlays-='cropunderlay.dmi'
						next_phase=0
						return
					if(growth_stage < max_stage && can_pocket == 1)

						src.growth_stage++
						src.icon_state = icon_state_list[growth_stage+1]
						src.current_water = (src.current_water/1.5) // Reset water for next phase
						can_pocket = 0 // No longer pickable
						bolted = 1
						spawn(300) // Wait 1 minute and a half subtracted by the amount before next phase
							if(current_water<=5)
								src.name="Rotten [src]"
								src.icon_state= icon_state_list[5]
								view(10,src)<<"[src] has withered away."
								spawn(15)
									src.destroy()
							else
								next_phase=1
								StartGrowth(amount)
					else
						src.underlays-='cropunderlay.dmi'
						usr.set_alert("The [plant_type] is now ready to harvest.",'alert.dmi',"alert")
						if(plant_type == "Carrot")
							var/obj/items/consumables/carrot/f = new/obj/items/consumables/carrot(src.loc)
							f.stacks = round((rand((current_water*0.125),(current_water*0.25))),1)
						if(plant_type == "Potato")
							var/obj/items/consumables/potato/f = new/obj/items/consumables/potato(src.loc)
							f.stacks = round((rand((current_water*0.125),(current_water*0.25))),1)
						if(plant_type == "Celery")
							var/obj/items/consumables/celery/f = new/obj/items/consumables/celery(src.loc)
							f.stacks = round((rand((current_water*0.125),(current_water*0.25))),1)
						if(plant_type == "Banana")
							var/obj/items/consumables/banana/f = new/obj/items/consumables/banana(src.loc)
							f.stacks = round((rand((current_water*0.125),(current_water*0.25))),1)
						if(plant_type == "Tomato")
							var/obj/items/consumables/tomato/f = new/obj/items/consumables/tomato(src.loc)
							f.stacks = round((rand((current_water*0.125),(current_water*0.25))),1)
						if(plant_type == "Wheat")
							var/obj/items/consumables/flour/f = new/obj/items/consumables/flour(src.loc)
							f.stacks = round((rand((current_water*0.125),(current_water*0.25))),1)
						if(plant_type == "Watermelon")
							var/obj/items/consumables/watermelon/f = new/obj/items/consumables/watermelon(src.loc)
							f.stacks = round((rand((current_water*0.125),(current_water*0.25))),1)
						sleep(1)
						src.destroy()


			ginseng //boosts Max Energy and recovers Energy (Little herbs in the ground you can click to remove)
				name = "Ginseng"
				icon_state = "ginseng ground1"
				bolted = 1;
				//o_color = "#1eff00"
				rarity = 2
				food=1
				desc = "A great source of Energy, Ginseng typically only grows on planet Earth. Consuming this herb guarantees a level up in your Energy stat. Androids are not able to consume this food."
				act = /obj/items/consumables/ginseng/proc/use
				act_drop = /obj/items/consumables/ginseng/proc/drop
				base_type = "Endurance"
				//Toxic buildup from taking drug

				//Duration in 1/10 seconds

				//Does the drug have a comedown or not, and how long does it last

				//Changed permanently when taken
			//	eng_gain = 1
				metab_gain = 5

				//Changed temporarily when taken

				//Changed temporarily when wears off
				proc
					use(var/mob/m,var/obj/items/i)
						if(i in m)
							if(m.has_stomach == 0)
								m.set_alert("Unable to eat food",'alert.dmi',"alert")

								return
							if(m.hunger > 99)
								m.set_alert("Already full",'alert.dmi',"alert")

								return
							if(m.eating)
								m.set_alert("Already eating",'alert.dmi',"alert")

								return
							var/T = world.time
							i.apply_item_stats(m,T)
							if(i && m && i.loc == m && i.stacks > 0 && i == m.eating && i.time_eaten == T)
								i.use_obj(m)
								m.refresh_inv()
								if(m) m.eating = null
					drop(var/mob/m,var/obj/items/i)
						m.drop(i)
				New()
					..()
					src.icon_state = "ginseng ground[rand(1,2)]"
				//	src.desc_extra = "[src.create_item_desc()]\n\n"
				Click(location,control,params)
					..()
					//Removes this item from the global Items list.
					if(items)
						if(src in items) items -= src
					params = params2list(params)
					if(params["left"])
						if(src.bolted)
							if(src in range(1,usr))
								src.icon_state = "ginseng"
								src.bolted = 0;
								animate(src,pixel_y = 32,time = 2,easing = BOUNCE_EASING)
								animate(pixel_y = 0, time = 2)
								animate(src,transform = turn(src.transform, 90), time = 2, flags = ANIMATION_PARALLEL)
								var/obj/h = new
								h.loc = src.loc
								h.step_x = src.step_x;
								h.step_y = src.step_y;
								h.icon = src.icon
								h.icon_state = "ginseng hole"
								return
						else if(isturf(src.loc))
							usr.pickup(src)
							if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up x[src.stacks] [src]","actionoutput")
						else if(ismob(src.loc))
							if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
							usr.item_selected = src
							src.overlays -= /obj/effects/select_item
							src.overlays += /obj/effects/select_item
			ectoplasm_negative // gives Strength, lowers lifespan
				name = "Negative Ectoplasm"
				icon_state = "ectoplasm negative"
				act = /obj/items/consumables/ectoplasm_negative/proc/use
				act_drop = /obj/items/consumables/ectoplasm_negative/proc/drop
				base_type = "Force"
				proc
					use(var/mob/m,var/obj/items/i)
					drop(var/mob/m,var/obj/items/i)
						m.drop(i)
				New()
					..()
					spawn(rand(1,10))
						if(src)
							animate(src,pixel_y = 2,time = 10,loop = -1)
							animate(pixel_y = 0, time = 10)
			ectoplasm_positive//, gives Force, lowers lifespan
				name = "Positive Ectoplasm"
				icon_state = "ectoplasm positive"
				act = /obj/items/consumables/ectoplasm_positive/proc/use
				act_drop = /obj/items/consumables/ectoplasm_positive/proc/drop
				base_type = "Force"
				proc
					use(var/mob/m,var/obj/items/i)
					drop(var/mob/m,var/obj/items/i)
						m.drop(i)
				New()
					..()
					spawn(rand(1,10))
						if(src)
							animate(src,pixel_y = 2,time = 10,loop = -1)
							animate(pixel_y = 0, time = 10)
			ectoplasm_pure //gives Endurance and resistance, lowers lifespan
				name = "Pure Ectoplasm"
				icon_state = "ectoplasm pure"
				act = /obj/items/consumables/ectoplasm_pure/proc/use
				act_drop = /obj/items/consumables/ectoplasm_pure/proc/drop
				base_type = "Force"
				proc
					use(var/mob/m,var/obj/items/i)
					drop(var/mob/m,var/obj/items/i)
						m.drop(i)
				New()
					..()
					spawn(rand(1,10))
						if(src)
							animate(src,pixel_y = 2,time = 10,loop = -1)
							animate(pixel_y = 0, time = 10)
			meat_soup //increases Endurance when eaten
				name = "Raw Meat Soup"
				icon = 'foods.dmi'
				icon_state = "dragon soup"
				desc = "Raw bowl of meat soup, the worst quality of dishes."
				//o_color = "#1eff00"
				rarity = 2
				can_cook = 1
				food = 1
				act = /obj/items/consumables/meat_soup/proc/use
				//act_drop = /obj/items/consumables/meat_soup/proc/drop
				cooked_type = /obj/items/consumables/food/cooked_meat_soup
				base_type = "Strength"
				//Toxic buildup from taking drug

				//Duration in 1/10 seconds

				//Does the drug have a comedown or not, and how long does it last

				//Changed permanently when taken
				//end_gain = 1
				metab_gain = 20
				hydro_gain = 10

				//Changed temporarily when taken

				//Changed temporarily when wears off

				New()
					..()
				//	src.desc_extra = "[src.create_item_desc()]\n\n"
				proc
					use(var/mob/m,var/obj/items/i)
						if(i in m)
							if(m.has_stomach == 0)
								m.set_alert("Unable to eat food",'alert.dmi',"alert")

								return
							if(m.hunger > 99)
								m.set_alert("Already full",'alert.dmi',"alert")

								return
							if(m.eating)
								m.set_alert("Already eating",'alert.dmi',"alert")

								return
							var/T = world.time
							i.apply_item_stats(m,T)
							if(i && m && i.loc == m && i.stacks > 0 && i == m.eating && i.time_eaten == T)
								i.use_obj(m)
								m.refresh_inv()
								if(m) m.eating = null
					drop(var/mob/m,var/obj/items/i)
						m.drop(i)
				Click(location,control,params)
					..()
					//Removes this item from the global Items list.
					if(items)
						if(src in items) items -= src
					params = params2list(params)
					if(params["left"])
						if(isturf(src.loc))
							usr.pickup(src)
							if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up x[src.stacks] [src]","actionoutput")
						else if(ismob(src.loc))
							if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
							usr.item_selected = src
							src.overlays -= /obj/effects/select_item
							src.overlays += /obj/effects/select_item
			soup //increases Endurance when eaten
				name = "Raw Soup"
				icon = 'Manyfoods.dmi'
				icon_state = "cRawSoup"
				//o_color = "#1eff00"
				rarity = 2
				can_cook = 1
				desc = "Raw bowl of soup, the worst quality of dishes."

				act = /obj/items/consumables/soup/proc/use
				//act_drop = /obj/items/consumables/soup/proc/drop
				cooked_type = /obj/items/consumables/food/cooked_soup
				base_type = "Strength"
				//Toxic buildup from taking drug

				//Duration in 1/10 seconds

				//Does the drug have a comedown or not, and how long does it last

				//Changed permanently when taken
				//end_gain = 1
				metab_gain = 10
				hydro_gain = 10
				food = 1

				//Changed temporarily when taken

				//Changed temporarily when wears off

				New()
					..()
				//	src.desc_extra = "[src.create_item_desc()]\n\n"
				proc
					use(var/mob/m,var/obj/items/i)
						if(i in m)
							if(m.has_stomach == 0)
								m.set_alert("Unable to eat food",'alert.dmi',"alert")

								return
							if(m.hunger > 99)
								m.set_alert("Already full",'alert.dmi',"alert")

								return
							if(m.eating)
								m.set_alert("Already eating",'alert.dmi',"alert")

								return
							var/T = world.time
							i.apply_item_stats(m,T)
							if(i && m && i.loc == m && i.stacks > 0 && i == m.eating && i.time_eaten == T)
								i.use_obj(m)
								m.refresh_inv()
								if(m) m.eating = null
					drop(var/mob/m,var/obj/items/i)
						m.drop(i)
				Click(location,control,params)
					..()
					//Removes this item from the global Items list.
					if(items)
						if(src in items) items -= src
					params = params2list(params)
					if(params["left"])
						if(isturf(src.loc))
							usr.pickup(src)
							if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up x[src.stacks] [src]","actionoutput")
						else if(ismob(src.loc))
							if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
							usr.item_selected = src
							src.overlays -= /obj/effects/select_item
							src.overlays += /obj/effects/select_item

			potato //increases Endurance when eaten
				name = "Potato"
				icon = 'consumables.dmi'
				icon_state = "potato ground"
				bolted = 1;
				//o_color = "#1eff00"
				rarity = 2
				can_cook = 1
				food = 1
				desc = "A vegetable grown from the ground."
				act = /obj/items/consumables/potato/proc/use
				//act_drop = /obj/items/consumables/potato/proc/drop
				cooked_type = /obj/items/consumables/food/baked_potato
				base_type = "Strength"
				//Toxic buildup from taking drug

				//Duration in 1/10 seconds

				//Does the drug have a comedown or not, and how long does it last

				//Changed permanently when taken
				//end_gain = 1
				metab_gain = 5

				//Changed temporarily when taken

				//Changed temporarily when wears off

				New()
					..()
				//	src.desc_extra = "[src.create_item_desc()]\n\n"
				proc
					use(var/mob/m,var/obj/items/i)
						if(i in m)
							if(m.has_stomach == 0)
								m.set_alert("Unable to eat food",'alert.dmi',"alert")

								return
							if(m.hunger > 99)
								m.set_alert("Already full",'alert.dmi',"alert")

								return
							if(m.eating)
								m.set_alert("Already eating",'alert.dmi',"alert")

								return
							var/T = world.time
							i.apply_item_stats(m,T)
							if(i && m && i.loc == m && i.stacks > 0 && i == m.eating && i.time_eaten == T)
								i.use_obj(m)
								m.refresh_inv()
								if(m) m.eating = null
					drop(var/mob/m,var/obj/items/i)
						m.drop(i)
				Click(location,control,params)
					..()
					//Removes this item from the global Items list.
					if(items)
						if(src in items) items -= src
					params = params2list(params)
					if(params["left"])
						if(src.bolted)
							if(src in range(1,usr))
								src.icon_state = "potato"
								src.bolted = 0;
								animate(src,pixel_y = 32,time = 2,easing = BOUNCE_EASING)
								animate(pixel_y = 0, time = 2)
								animate(transform = turn(matrix(), 90), time = 2, flags = ANIMATION_PARALLEL)
								var/obj/h = new
								h.loc = src.loc
								h.step_x = src.step_x;
								h.step_y = src.step_y;
								h.icon = src.icon
								h.icon_state = "ginseng hole"
								return
						else if(isturf(src.loc))
							usr.pickup(src)
							if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up x[src.stacks] [src]","actionoutput")
						else if(ismob(src.loc))
							if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
							usr.item_selected = src
							src.overlays -= /obj/effects/select_item
							src.overlays += /obj/effects/select_item
			celery //increases Endurance when eaten
				name = "Celery"
				icon = 'consumables.dmi'
				icon_state = "celery ground"
				bolted = 1;
				//o_color = "#1eff00"
				rarity = 2
				can_cook = 1
				food = 1
				desc = "A vegetable grown from the ground."
				act = /obj/items/consumables/celery/proc/use
				//act_drop = /obj/items/consumables/celery/proc/drop
				cooked_type = /obj/items/consumables/food/cooked_celery
				base_type = "Endurance"
				//Toxic buildup from taking drug

				//Duration in 1/10 seconds

				//Does the drug have a comedown or not, and how long does it last

				//Changed permanently when taken
				//end_gain = 1
				metab_gain = 10


				//Changed temporarily when taken

				//Changed temporarily when wears off

				New()
					..()
				//	src.desc_extra = "[src.create_item_desc()]\n\n"
				proc
					use(var/mob/m,var/obj/items/i)
						if(i in m)
							if(m.has_stomach == 0 )
								m.set_alert("Unable to eat food",'alert.dmi',"alert")

								return
							if(m.hunger > 99)
								m.set_alert("Already full",'alert.dmi',"alert")

								return
							if(m.eating)
								m.set_alert("Already eating",'alert.dmi',"alert")

								return
							var/T = world.time
							i.apply_item_stats(m,T)
							if(i && m && i.loc == m && i.stacks > 0 && i == m.eating && i.time_eaten == T)
								i.use_obj(m)
								m.refresh_inv()
								if(m) m.eating = null
					drop(var/mob/m,var/obj/items/i)
						m.drop(i)
				Click(location,control,params)
					..()
					//Removes this item from the global Items list.
					if(items)
						if(src in items) items -= src
					params = params2list(params)
					if(params["left"])
						if(src.bolted)
							if(src in range(1,usr))
								src.icon_state = "celery"
								src.bolted = 0;
								animate(src,pixel_y = 32,time = 2,easing = BOUNCE_EASING)
								animate(pixel_y = 0, time = 2)
								animate(transform = turn(matrix(), 90), time = 2, flags = ANIMATION_PARALLEL)
								var/obj/h = new
								h.loc = src.loc
								h.step_x = src.step_x;
								h.step_y = src.step_y;
								h.icon = src.icon
								h.icon_state = "turnip hole"
								return
						else if(isturf(src.loc))
							usr.pickup(src)
							if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up x[src.stacks] [src]","actionoutput")
						else if(ismob(src.loc))
							if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
							usr.item_selected = src
							src.overlays -= /obj/effects/select_item
							src.overlays += /obj/effects/select_item
			bread //increases Endurance when eaten
				name = "Bread"
				icon = 'Manyfoods.dmi'
				icon_state = "Bread"
				bolted = 1;
				//o_color = "#1eff00"
				rarity = 2
				can_cook = 1
				food = 1
				desc = "A plain pastry."
				act = /obj/items/consumables/bread/proc/use
				//act_drop = /obj/items/consumables/bread/proc/drop
				cooked_type = /obj/items/consumables/food/baked_bread
				base_type = "Endurance"
				//Toxic buildup from taking drug

				//Duration in 1/10 seconds

				//Does the drug have a comedown or not, and how long does it last

				//Changed permanently when taken
			//	end_gain = 1
				metab_gain = 30

				//Changed temporarily when taken

				//Changed temporarily when wears off

				New()
					..()
				//	src.desc_extra = "[src.create_item_desc()]\n\n"
				proc
					use(var/mob/m,var/obj/items/i)
						if(i in m)
							if(m.has_stomach == 0 )
								m.set_alert("Unable to eat food",'alert.dmi',"alert")

								return
							if(m.hunger > 99)
								m.set_alert("Already full",'alert.dmi',"alert")

								return
							if(m.eating)
								m.set_alert("Already eating",'alert.dmi',"alert")

								return
							var/T = world.time
							i.apply_item_stats(m,T)
							if(i && m && i.loc == m && i.stacks > 0 && i == m.eating && i.time_eaten == T)
								i.use_obj(m)
								m.refresh_inv()
								if(m) m.eating = null
					drop(var/mob/m,var/obj/items/i)
						m.drop(i)
				Click(location,control,params)
					..()
					//Removes this item from the global Items list.
					if(items)
						if(src in items) items -= src
					params = params2list(params)
					if(params["left"])
						if(src.bolted)
							if(src in range(1,usr))
								src.icon_state = "Bread"
								src.bolted = 0;
								animate(src,pixel_y = 32,time = 2,easing = BOUNCE_EASING)
								animate(pixel_y = 0, time = 2)
								animate(transform = turn(matrix(), 90), time = 2, flags = ANIMATION_PARALLEL)
								var/obj/h = new
								h.loc = src.loc
								h.step_x = src.step_x;
								h.step_y = src.step_y;
								h.icon = src.icon
								h.icon_state = "turnip hole"
								return
						else if(isturf(src.loc))
							usr.pickup(src)
							if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up x[src.stacks] [src]","actionoutput")
						else if(ismob(src.loc))
							if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
							usr.item_selected = src
							src.overlays -= /obj/effects/select_item
							src.overlays += /obj/effects/select_item
			watermelon //increases Endurance when eaten
				name = "Watermelon"
				icon = 'Manyfoods.dmi'
				icon_state = "WaterMellon"
				bolted = 1;
				//o_color = "#1eff00"
				rarity = 2
				can_cook = 0
				food = 1
				desc = "A fruit grown from the ground."
				act = /obj/items/consumables/watermelon/proc/use
			//	act_drop = /obj/items/consumables/watermelon/proc/drop
				base_type = "Energy"
				//Toxic buildup from taking drug

				//Duration in 1/10 seconds

				//Does the drug have a comedown or not, and how long does it last

				//Changed permanently when taken
			//	eng_gain = 1
				metab_gain = 10
				hydro_gain = 25

				//Changed temporarily when taken

				//Changed temporarily when wears off

				New()
					..()
					//src.desc_extra = "[src.create_item_desc()]\n\n"
				proc
					use(var/mob/m,var/obj/items/i)
						if(i in m)
							if(m.has_stomach == 0 )
								m.set_alert("Unable to eat food",'alert.dmi',"alert")

								return
							if(m.hunger > 99)
								m.set_alert("Already full",'alert.dmi',"alert")

								return
							if(m.thirst> 99)
								m.set_alert("Already full",'alert.dmi',"alert")

								return
							if(m.eating)
								m.set_alert("Already eating",'alert.dmi',"alert")

								return
							var/T = world.time
							i.apply_item_stats(m,T)
							if(i && m && i.loc == m && i.stacks > 0 && i == m.eating && i.time_eaten == T)
								i.use_obj(m)
								m.refresh_inv()
								if(m) m.eating = null
					drop(var/mob/m,var/obj/items/i)
						m.drop(i)
				Click(location,control,params)
					..()
					//Removes this item from the global Items list.
					if(items)
						if(src in items) items -= src
					params = params2list(params)
					if(params["left"])
						if(src.bolted)
							if(src in range(1,usr))
								src.icon_state = "WaterMellon"
								src.bolted = 0;
								animate(src,pixel_y = 32,time = 2,easing = BOUNCE_EASING)
								animate(pixel_y = 0, time = 2)
								animate(transform = turn(matrix(), 90), time = 2, flags = ANIMATION_PARALLEL)
								var/obj/h = new
								h.loc = src.loc
								h.step_x = src.step_x;
								h.step_y = src.step_y;
								h.icon = src.icon
								h.icon_state = "turnip hole"
								return
						else if(isturf(src.loc))
							usr.pickup(src)
							if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up x[src.stacks] [src]","actionoutput")
						else if(ismob(src.loc))
							if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
							usr.item_selected = src
							src.overlays -= /obj/effects/select_item
							src.overlays += /obj/effects/select_item
			tomato //increases Endurance when eaten
				name = "Tomato"
				icon = 'Manyfoods.dmi'
				icon_state = "tomato"
				bolted = 1;
				//o_color = "#1eff00"
				rarity = 2
				can_cook = 0
				food = 1
				desc = "A vegetable grown from the ground."
				act = /obj/items/consumables/tomato/proc/use
				//act_drop = /obj/items/consumables/tomato/proc/drop
				base_type = "Strength"
				//Toxic buildup from taking drug

				//Duration in 1/10 seconds

				//Does the drug have a comedown or not, and how long does it last

				//Changed permanently when taken
			//	str_gain = 1
				metab_gain = 5

				//Changed temporarily when taken

				//Changed temporarily when wears off

				New()
					..()
				//	src.desc_extra = "[src.create_item_desc()]\n\n"
				proc
					use(var/mob/m,var/obj/items/i)
						if(i in m)
							if(m.has_stomach == 0 )
								m.set_alert("Unable to eat food",'alert.dmi',"alert")

								return
							if(m.hunger > 99)
								m.set_alert("Already full",'alert.dmi',"alert")

								return
							if(m.eating)
								m.set_alert("Already eating",'alert.dmi',"alert")

								return
							var/T = world.time
							i.apply_item_stats(m,T)
							if(i && m && i.loc == m && i.stacks > 0 && i == m.eating && i.time_eaten == T)
								i.use_obj(m)
								m.refresh_inv()
								if(m) m.eating = null
					drop(var/mob/m,var/obj/items/i)
						m.drop(i)
				Click(location,control,params)
					..()
					//Removes this item from the global Items list.
					if(items)
						if(src in items) items -= src
					params = params2list(params)
					if(params["left"])
						if(src.bolted)
							if(src in range(1,usr))
								src.icon_state = "tomato"
								src.bolted = 0;
								animate(src,pixel_y = 32,time = 2,easing = BOUNCE_EASING)
								animate(pixel_y = 0, time = 2)
								animate(transform = turn(matrix(), 90), time = 2, flags = ANIMATION_PARALLEL)
								var/obj/h = new
								h.loc = src.loc
								h.step_x = src.step_x;
								h.step_y = src.step_y;
								h.icon = src.icon
								h.icon_state = "turnip hole"
								return
						else if(isturf(src.loc))
							usr.pickup(src)
							if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up x[src.stacks] [src]","actionoutput")
						else if(ismob(src.loc))
							if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
							usr.item_selected = src
							src.overlays -= /obj/effects/select_item
							src.overlays += /obj/effects/select_item
			flour //increases Endurance when eaten
				name = "Flour"
				icon = 'Manyfoods.dmi'
				icon_state = ""
				bolted = 1;
				//o_color = "#1eff00"
				rarity = 2
				can_cook = 0
				food = 0
				desc = "A grain grown from the ground."
				act = /obj/items/consumables/flour/proc/use
				//act_drop = /obj/items/consumables/flour/proc/drop
				base_type = "Strength"
				//Toxic buildup from taking drug

				//Duration in 1/10 seconds

				//Does the drug have a comedown or not, and how long does it last

				//Changed permanently when taken
			//	str_gain = 1
				//metab_gain = 0

				//Changed temporarily when taken

				//Changed temporarily when wears off

				New()
					..()
				//	src.desc_extra = "[src.create_item_desc()]\n\n"
				proc
					use(var/mob/m,var/obj/items/i)
						/*
						if(i in m)
							if(m.has_stomach == 0 )
								m.set_alert("Unable to eat food",'alert.dmi',"alert")

								return
							if(m.hunger > 99)
								m.set_alert("Already full",'alert.dmi',"alert")

								return
							if(m.eating)
								m.set_alert("Already eating",'alert.dmi',"alert")

								return
							var/T = world.time
							i.apply_item_stats(m,T)
							if(i && m && i.loc == m && i.stacks > 0 && i == m.eating && i.time_eaten == T)
								i.use_obj(m)*/
						m.refresh_inv()
								//if(m) m.eating = null
					drop(var/mob/m,var/obj/items/i)
						m.drop(i)
				Click(location,control,params)
					..()
					//Removes this item from the global Items list.
					if(items)
						if(src in items) items -= src
					params = params2list(params)
					if(params["left"])
						if(src.bolted)
							if(src in range(1,usr))
								src.icon_state = "flour"
								src.bolted = 0;
								animate(src,pixel_y = 32,time = 2,easing = BOUNCE_EASING)
								animate(pixel_y = 0, time = 2)
								animate(transform = turn(matrix(), 90), time = 2, flags = ANIMATION_PARALLEL)
								var/obj/h = new
								h.loc = src.loc
								h.step_x = src.step_x;
								h.step_y = src.step_y;
								h.icon = src.icon
								h.icon_state = "wheat hole"
								return
						else if(isturf(src.loc))
							usr.pickup(src)
							if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up x[src.stacks] [src]","actionoutput")
						else if(ismob(src.loc))
							if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
							usr.item_selected = src
							src.overlays -= /obj/effects/select_item
							src.overlays += /obj/effects/select_item
			banana //increases Endurance when eaten
				name = "Banana"
				icon = 'Manyfoods.dmi'
				icon_state = "Banana"
				bolted = 1;
				//o_color = "#1eff00"
				rarity = 2
				can_cook = 0
				food = 1
				desc = "A fruit grown from the ground."
				act = /obj/items/consumables/banana/proc/use
			//	act_drop = /obj/items/consumables/banana/proc/drop
				base_type = "Endurance"
				//Toxic buildup from taking drug

				//Duration in 1/10 seconds

				//Does the drug have a comedown or not, and how long does it last

				//Changed permanently when taken
				//end_gain = 1
				metab_gain = 5

				//Changed temporarily when taken

				//Changed temporarily when wears off

				New()
					..()
				//	src.desc_extra = "[src.create_item_desc()]\n\n"
				proc
					use(var/mob/m,var/obj/items/i)
						if(i in m)
							if(m.has_stomach == 0)
								m.set_alert("Unable to eat food",'alert.dmi',"alert")

								return
							if(m.hunger > 99)
								m.set_alert("Already full",'alert.dmi',"alert")

								return
							if(m.eating)
								m.set_alert("Already eating",'alert.dmi',"alert")

								return
							var/T = world.time
							i.apply_item_stats(m,T)
							if(i && m && i.loc == m && i.stacks > 0 && i == m.eating && i.time_eaten == T)
								i.use_obj(m)
								m.refresh_inv()
								if(m) m.eating = null
					drop(var/mob/m,var/obj/items/i)
						m.drop(i)
				Click(location,control,params)
					..()
					//Removes this item from the global Items list.
					if(items)
						if(src in items) items -= src
					params = params2list(params)
					if(params["left"])
						if(src.bolted)
							if(src in range(1,usr))
								src.icon_state = "Banana"
								src.bolted = 0;
								animate(src,pixel_y = 32,time = 2,easing = BOUNCE_EASING)
								animate(pixel_y = 0, time = 2)
								animate(transform = turn(matrix(), 90), time = 2, flags = ANIMATION_PARALLEL)
								var/obj/h = new
								h.loc = src.loc
								h.step_x = src.step_x;
								h.step_y = src.step_y;
								h.icon = src.icon
								h.icon_state = "turnip hole"
								return
						else if(isturf(src.loc))
							usr.pickup(src)
							if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up x[src.stacks] [src]","actionoutput")
						else if(ismob(src.loc))
							if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
							usr.item_selected = src
							src.overlays -= /obj/effects/select_item
							src.overlays += /obj/effects/select_item
			carrot //increases Endurance when eaten
				name = "Carrot"
				icon = 'consumables.dmi'
				icon_state = "carrot ground"
				bolted = 1;
				//o_color = "#1eff00"
				rarity = 2
				can_cook = 1
				food = 1
				desc = "A vegetable grown from the ground."
				act = /obj/items/consumables/carrot/proc/use
			//	act_drop = /obj/items/consumables/carrot/proc/drop
				cooked_type = /obj/items/consumables/food/cooked_carrot
				base_type = "Recovery"
				//Toxic buildup from taking drug

				//Duration in 1/10 seconds

				//Does the drug have a comedown or not, and how long does it last

				//Changed permanently when taken
			//	recov_gain = 1
				metab_gain = 10

				//Changed temporarily when taken

				//Changed temporarily when wears off

				New()
					..()
				//	src.desc_extra = "[src.create_item_desc()]\n\n"
				proc
					use(var/mob/m,var/obj/items/i)
						if(i in m)
							if(m.has_stomach == 0)
								m.set_alert("Unable to eat food",'alert.dmi',"alert")

								return
							if(m.hunger > 99)
								m.set_alert("Already full",'alert.dmi',"alert")

								return
							if(m.eating)
								m.set_alert("Already eating",'alert.dmi',"alert")

								return
							var/T = world.time
							i.apply_item_stats(m,T)
							if(i && m && i.loc == m && i.stacks > 0 && i == m.eating && i.time_eaten == T)
								i.use_obj(m)
								m.refresh_inv()
								if(m) m.eating = null
					drop(var/mob/m,var/obj/items/i)
						m.drop(i)
				Click(location,control,params)
					..()
					//Removes this item from the global Items list.
					if(items)
						if(src in items) items -= src
					params = params2list(params)
					if(params["left"])
						if(src.bolted)
							if(src in range(1,usr))
								src.icon_state = "carrot"
								src.bolted = 0;
								animate(src,pixel_y = 32,time = 2,easing = BOUNCE_EASING)
								animate(pixel_y = 0, time = 2)
								animate(transform = turn(matrix(), 90), time = 2, flags = ANIMATION_PARALLEL)
								var/obj/h = new
								h.loc = src.loc
								h.step_x = src.step_x;
								h.step_y = src.step_y;
								h.icon = src.icon
								h.icon_state = "turnip hole"
								return
						else if(isturf(src.loc))
							usr.pickup(src)
							if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up x[src.stacks] [src]","actionoutput")
						else if(ismob(src.loc))
							if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
							usr.item_selected = src
							src.overlays -= /obj/effects/select_item
							src.overlays += /obj/effects/select_item
			turnip //increases Endurance when eaten
				name = "Turnip"
				icon_state = "turnip ground"
				bolted = 1;
				//o_color = "#1eff00"
				rarity = 2
				//can_cook = 1
				food = 1
				desc = "A vegetable grown from the ground."
				act = /obj/items/consumables/turnip/proc/use
			//	act_drop = /obj/items/consumables/turnip/proc/drop
				base_type = "Strength"
				//Toxic buildup from taking drug

				//Duration in 1/10 seconds

				//Does the drug have a comedown or not, and how long does it last

				//Changed permanently when taken
			//	end_gain = 1
				metab_gain = 10

				//Changed temporarily when taken

				//Changed temporarily when wears off

				New()
					..()
				//	src.desc_extra = "[src.create_item_desc()]\n\n"
				proc
					use(var/mob/m,var/obj/items/i)
						if(i in m)
							if(m.has_stomach == 0)
								m.set_alert("Unable to eat food",'alert.dmi',"alert")

								return
							if(m.hunger > 99)
								m.set_alert("Already full",'alert.dmi',"alert")

								return
							if(m.eating)
								m.set_alert("Already eating",'alert.dmi',"alert")

								return
							var/T = world.time
							i.apply_item_stats(m,T)
							if(i && m && i.loc == m && i.stacks > 0 && i == m.eating && i.time_eaten == T)
								i.use_obj(m)
								m.refresh_inv()
								if(m) m.eating = null
					drop(var/mob/m,var/obj/items/i)
						m.drop(i)
				Click(location,control,params)
					..()
					//Removes this item from the global Items list.
					if(items)
						if(src in items) items -= src
					params = params2list(params)
					if(params["left"])
						if(src.bolted)
							if(src in range(1,usr))
								src.icon_state = "turnip"
								src.bolted = 0;
								animate(src,pixel_y = 32,time = 2,easing = BOUNCE_EASING)
								animate(pixel_y = 0, time = 2)
								animate(transform = turn(matrix(), 90), time = 2, flags = ANIMATION_PARALLEL)
								var/obj/h = new
								h.loc = src.loc
								h.step_x = src.step_x;
								h.step_y = src.step_y;
								h.icon = src.icon
								h.icon_state = "turnip hole"
								return
						else if(isturf(src.loc))
							usr.pickup(src)
							if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up x[src.stacks] [src]","actionoutput")
						else if(ismob(src.loc))
							if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
							usr.item_selected = src
							src.overlays -= /obj/effects/select_item
							src.overlays += /obj/effects/select_item
			spinach //increases Strength.
				name = "Spinach"
				icon_state = ""
				act = /obj/items/consumables/spinach/proc/use
			//	act_drop = /obj/items/consumables/spinach/proc/drop
				base_type = "Endurance"
				proc
					use(var/mob/m,var/obj/items/i)
					drop(var/mob/m,var/obj/items/i)
						m.drop(i)
			sage //Gives Force
				name = "Sage"
				icon_state = ""
				act = /obj/items/consumables/sage/proc/use
				act_drop = /obj/items/consumables/sage/proc/drop
				base_type = "Regeneration"
				proc
					use(var/mob/m,var/obj/items/i)
					drop(var/mob/m,var/obj/items/i)
						m.drop(i)
			kelp //Gives Resistance
				name = "Kelp"
				icon_state = ""
				act = /obj/items/consumables/kelp/proc/use
				act_drop = /obj/items/consumables/kelp/proc/drop
				base_type = "Recovery"
				proc
					use(var/mob/m,var/obj/items/i)
					drop(var/mob/m,var/obj/items/i)
						m.drop(i)
			divine_fruit_overripe
				name = "Overripe Divine Fruit"
				icon_state = "divine fruit grown"
				//o_color = "#a335ee"
				rarity = 4
				//desc_extra = "When Eaten:\n\n<font color = green>+ 10 Divine Energy</font>\n\n<font color = green>+ 10 Lifespan</font>\n\n<font color = green>+ 1 levels in all organs</font>\n\n"
				act = /obj/items/consumables/divine_fruit_overripe/proc/use
				//act_drop = /obj/items/consumables/divine_fruit_overripe/proc/drop
				base_type = "Offence"
				//Toxic buildup from taking drug

				//Duration in 1/10 seconds

				//Does the drug have a comedown or not, and how long does it last

				//Changed permanently when taken
				divine_eng_gain = 10
				metab_gain = 100
				hydro_gain = 100
				tiredness_gain = 100
				lifespan_gain = 10
				lvl_parts = list("Organ")
				lvl_parts_num = 1

				//Changed temporarily when taken

				//Changed temporarily when wears off

				New()
					..()
				//	src.desc_extra = "[src.create_item_desc()]\n\n"
				proc
					use(var/mob/m,var/obj/items/i)
						if(i in m)
							if(m.has_stomach == 0)
								m.set_alert("Unable to eat food",'alert.dmi',"alert")

								return
							if(m.hunger > 99)
								m.set_alert("Already full",'alert.dmi',"alert")

								return
							if(m.eating)
								m.set_alert("Already eating",'alert.dmi',"alert")

								return
							var/T = world.time
							i.apply_item_stats(m,T)
							if(i && m && i.loc == m && i.stacks > 0 && i == m.eating && i.time_eaten == T)
								for(var/obj/body_related/bodyparts/torso/trs in m.bodyparts)
									for(var/obj/body_related/bodyparts/torso/stomach/stm in trs)
										m.damage_limb(m,0, 1, 100,stm)
										break
									for(var/obj/body_related/bodyparts/torso/large_intestines/int in trs)
										m.damage_limb(m,0, 1, 100,int)
									for(var/obj/body_related/bodyparts/torso/small_intestines/int in trs)
										m.damage_limb(m,0, 1, 100,int)
										break
								i.use_obj(m)
								m.refresh_inv()
								if(m) m.eating = null
					drop(var/mob/m,var/obj/items/i)
						m.drop(i)
				Click(location,control,params)
					..()
					//Removes this item from the global Items list.
					if(items)
						if(src in items) items -= src
					params = params2list(params)
					if(params["left"])
						if(isturf(src.loc))
							usr.pickup(src)
							if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up x[src.stacks] [src]","actionoutput")
						else if(ismob(src.loc))
							if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
							usr.item_selected = src
							src.overlays -= /obj/effects/select_item
							src.overlays += /obj/effects/select_item
			divine_fruit //increases Force and Max Divine Energy
				name = "Divine Fruit"
				icon_state = "divine fruit grown"
				//o_color = "#ff8000"
				rarity = 5
				//desc_extra = "When Eaten:\n\n<font color = green>+ 50 Divine Energy</font>\n\n<font color = green>+ 100 Lifespan</font>\n\n<font color = green>+ 10 levels in all bodyparts</font>\n\n"
				act = /obj/items/consumables/divine_fruit/proc/use
			//	act_drop = /obj/items/consumables/divine_fruit/proc/drop
				base_type = "Regeneration"
				//Toxic buildup from taking drug

				//Duration in 1/10 seconds

				//Does the drug have a comedown or not, and how long does it last

				//Changed permanently when taken
				divine_eng_gain = 50
				metab_gain = 200
				hydro_gain = 200
				tiredness_gain = 200
				lifespan_gain = 100
				lvl_parts = list("Muscle","Bone","Organ")
				lvl_parts_num = 10

				//Changed temporarily when taken

				//Changed temporarily when wears off

				New()
					..()
				//	src.desc_extra = "[src.create_item_desc()]\n\n"
				proc
					use(var/mob/m,var/obj/items/i)
						if(i in m)
							if(m.has_stomach == 0 || m.has_body == 0)
								m.set_alert("Unable to eat food",'alert.dmi',"alert")

								return
							if(m.hunger > 99)
								m.set_alert("Already full",'alert.dmi',"alert")

								return
							if(m.eating)
								m.set_alert("Already eating",'alert.dmi',"alert")

								return
							var/T = world.time
							i.apply_item_stats(m,T)
							if(i && m && i.loc == m && i.stacks > 0 && i == m.eating && i.time_eaten == T)
								i.use_obj(m)
								m.refresh_inv()
								if(m) m.eating = null
					drop(var/mob/m,var/obj/items/i)
						m.drop(i)
				Click(location,control,params)
					..()
					//Removes this item from the global Items list.
					if(items)
						if(src in items) items -= src
					params = params2list(params)
					if(params["left"])
						if(isturf(src.loc))
							usr.pickup(src)
							if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up x[src.stacks] [src]","actionoutput")
						else if(ismob(src.loc))
							if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
							usr.item_selected = src
							src.overlays -= /obj/effects/select_item
							src.overlays += /obj/effects/select_item
			might_fruit
				icon = 'Manyfoods.dmi'
				icon_state = "mightfruit"
				name = "Might Fruit"
				rarity = 5
				hp = 9999999
				stacks = 1
				toxin_gain = 0.0001
				toxicity = 50

				act = /obj/items/consumables/might_fruit/proc/use
			//	act_drop = /obj/items/consumables/might_fruit/proc/drop

				desc = "A forbidden fruit overflowing with violent vitality. Its power comes at a cost."
				Click(location,control,params)
					..()
					//Removes this item from the global Items list.
					if(items)
						if(src in items) items -= src
					params = params2list(params)
					if(params["left"])
						if(isturf(src.loc))
							usr.pickup(src)
							if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up x[src.stacks] [src]","actionoutput")
						else if(ismob(src.loc))
							if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
							usr.item_selected = src
							src.overlays -= /obj/effects/select_item
							src.overlays += /obj/effects/select_item
				proc
					use(var/mob/m,var/obj/items/consumables/i)
						if(!(i in m)) return

						if(m.eating)
							m.set_alert("Already consuming something",'alert.dmi',"alert")
							return

						var/T = world.time
						i.apply_item_stats(m,T)

						if(i && m && i.loc == m && (i.stacks > 0 || i.stacks == -1) && i == m.eating && i.time_eaten == T)

							// 🔥 POWER LEVEL BOOST (110%)
							m.psionic_power_base += (m.psionic_power_base * 1.50)

							// 💪 50% BOOST TO ALL CORE STATS
							m.strength += (m.strength * 0.85)
							m.endurance += (m.endurance * 0.85)
							m.force += (m.force * 0.5)
							m.resistance += (m.resistance * 0.5)
							m.offence += (m.offence * 0.25)
							m.defence += (m.defence * 0.25)
							m.mod_agility += (m.mod_agility * 0.15)
							m.mod_energy += (m.mod_energy * 0.5)

							// ☣️ Toxicity spike
							var/tox_gain = rand(50,65)
							m.toxicity += tox_gain

							//view(m) <<output("[m] consumes a might fruit.","actionoutput")

							i.use_obj(m)
							m.refresh_inv()
							m.eating = null

					drop(var/mob/m,var/obj/items/i)
						m.drop(i)

			spirit_stone
				icon = 'artifacts_small.dmi'
				name = "Spirit Stone"
				rarity = 2
				hp = 9999999
				icon_state = "spirit stone1"
				act = /obj/items/consumables/spirit_stone/proc/use
			//	act_drop = /obj/items/consumables/spirit_stone/proc/drop
				act_load = /obj/items/consumables/spirit_stone/proc/load
				var/fused_key = null
				var/fused_name = null
				var/fused_id = null
				base_type = "Force"
				//Toxic buildup from taking drug

				//Duration in 1/10 seconds

				//Does the drug have a comedown or not, and how long does it last

				//Changed permanently when taken
				tiredness_gain = 1
				eng_gain = 1

				//Changed temporarily when taken

				//Changed temporarily when wears off
				proc
					load(var/obj/items/consumables/spirit_stone/i)
						i.vis_contents = null
						i.filters = null
						if(i.infused == 2 || i.infused == 3)
							i.filters += filter(type="outline",size=1, color=rgb(204,236,255))
							i.filters += filter(type="drop_shadow", x=0, y=0, size=1, offset=1, color=rgb(102,0,204))

							animate(i.filters[2], size = 2,offset = 2, time = 15, loop = -1)
							animate(size = 0,offset = 0, time = 15, loop = -1)

							i.vis_contents += new/obj/effects/dark_matter_energy
					use(var/mob/m,var/obj/items/consumables/i)
						if(i in m)
							if(i.infused == 3) return
							if(m.eating)
								m.set_alert("Already absorbing",'alert.dmi',"alert")

								return
							var/T = world.time
							i.apply_item_stats(m,T)
							if(i && m && i.loc == m && i.stacks > 0 && i == m.eating && i.time_eaten == T)
								i.use_obj(m)
								m.refresh_inv()
								if(m) m.eating = null
					drop(var/mob/m,var/obj/items/i)
						m.drop(i)
				New()
					..()
					spawn(10)
						if(src)
							if(ismob(src.loc) || isobj(src.loc)) return
							src.icon_state = "spirit stone[rand(1,5)]"
							src.filters = null
							var/proceed = 0
							if(src.infused == 1) proceed = 1
							else if(src.infused == 2) proceed = 2
							else if(src.infused == 3) proceed = 3
							else if(prob(5)) proceed = 1
							else if(prob(0.5)) proceed = 2
							if(proceed >= 2)
								src.filters += filter(type="outline",size=1, color=rgb(204,236,255))
								src.filters += filter(type="drop_shadow", x=0, y=0, size=1, offset=1, color=rgb(102,0,204))

								animate(src.filters[2], size = 2,offset = 2, time = 15, loop = -1)
								animate(size = 0,offset = 0, time = 15, loop = -1)

								//src.stacks = -1
								src.tech_lvl = 3
								src.vis_contents += new/obj/effects/dark_matter_energy
								src.name = "Black Spirit Stone"
								src.icon_state = "black spirit stone"
								src.infused = 2
								src.rarity = 5
								src.tiredness_gain = 100
								src.eng_gain = 10
								src.lifespan_gain = 100
								src.dark_matter_gain = 50
								src.lvl_parts = list("Muscle","Bone","Organ")
								src.lvl_parts_num = 10
								src.desc_extra = "When absorbed:\n\n<font color = green>+ 100 Lifespan</font>\n\n<font color = green>+ 50 Dark Matter</font>\n\n+ <font color = green>10 Levels in all bodyparts</font>\n\nUsed in: Lichdom ritual\n\n"
								src.desc = "Description: An exceedingly rare spirit stone which has managed to absorb a large quantity of Dark Matter. Their already unique crystal lattices seem to vibrate on a primordial level, creating a higher dimensional hyper tesseract capable of housing anything from normal matter to more exotic substances, such as anima. These particular stones are often used in extremely powerful scientific experiments or as a ritual material for certain ascensions, such as Lichdom."
							else if(proceed == 1)
								//src.stacks = -1
								src.tech_lvl = 2
								src.icon_state = "spirit stone[rand(1,5)]"
								src.filters += filter(type="outline",size=1, color=rgb(204,236,255))
								src.filters += filter(type="drop_shadow", x=0, y=0, size=1, offset=1, color=rgb(0,160,230))

								animate(src.filters[2], size = 2,offset = 2, time = 15, loop = -1)
								animate(size = 0,offset = 0, time = 15, loop = -1)

								src.infused = 1
								src.tiredness_gain = 10
								src.eng_gain = 10
								src.desc_extra = "<font color = green>+ 10 Max Energy</font>\n\n<font color = green>+ 10% Energy</font>\n\n"
								src.name = "Infused Spirit Stone"
								src.rarity = 3
						//	src.desc_extra = "[src.create_item_desc()]\n\n"
				Click(location,control,params)
					..()
					//Removes this item from the global Items list.
					if(items)
						if(src in items) items -= src
					params = params2list(params)
					if(params["left"])
						if(isturf(src.loc))
							usr.pickup(src)
							if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up x[src.stacks] [src]","actionoutput")
						else if(ismob(src.loc))
							if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
							usr.item_selected = src
							src.overlays -= /obj/effects/select_item
							src.overlays += /obj/effects/select_item
			lotus_flower //increases Force and Max Divine Energy
				name = "Lotus Flower"
				rarity = 3
				icon_state = "lotus flower"
				act = /obj/items/consumables/lotus_flower/proc/use
			//	act_drop = /obj/items/consumables/lotus_flower/proc/drop
				base_type = "Force"
				desc = "A vegetable grown from the depths of lakes."
				//Toxic buildup from taking drug

				//Duration in 1/10 seconds

				//Does the drug have a comedown or not, and how long does it last

				//Changed permanently when taken
			//	force_gain = 1
			//	divine_eng_gain = 1
				metab_gain = 9
				hydro_gain = 9

				//Changed temporarily when taken

				//Changed temporarily when wears off
				proc
					use(var/mob/m,var/obj/items/consumables/i)
						if(i in m)
							if(m.has_stomach == 0)
								m.set_alert("Unable to eat food",'alert.dmi',"alert")

								return
							if(m.hunger > 99)
								m.set_alert("Already full",'alert.dmi',"alert")

								return
							if(m.thirst> 99)
								m.set_alert("Already full",'alert.dmi',"alert")

								return
							if(m.eating)
								m.set_alert("Already eating",'alert.dmi',"alert")

								return
							var/T = world.time
							i.apply_item_stats(m,T)
							if(i && m && i.loc == m && i.stacks > 0 && i == m.eating && i.time_eaten == T)
								i.use_obj(m)
								m.refresh_inv()
								if(m) m.eating = null
					drop(var/mob/m,var/obj/items/i)
						m.drop(i)
				New()
					..()
					spawn(10)
						if(src)
							if(ismob(src.loc) || isobj(src.loc)) return
							var/proceed = 0
							if(src.infused) proceed = 1
							else if(prob(10)) proceed = 1
							if(proceed)
								src.infused = 1
								//src.stacks = -1
								src.tech_lvl = 2
								src.force_gain = 10
								src.divine_eng_gain = 10
								src.filters += filter(type="outline",size=1, color=rgb(255,255,170))
								src.vis_contents += new/obj/effects/divine_energy
								src.name = "Divine Lotus Flower"
								src.rarity = 4
								//src.desc_extra = "When Eaten:\n\n<font color = green>+ 10 levels in Force</font>\n\n<font color = green>+ 10 Divine Energy</font>\n\n"
						//	src.desc_extra = "[src.create_item_desc()]\n\n"
				Click(location,control,params)
					..()
					//Removes this item from the global Items list.
					if(items)
						if(src in items) items -= src
					params = params2list(params)
					if(params["left"])
						if(isturf(src.loc))
							usr.pickup(src)
							if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up x[src.stacks] [src]","actionoutput")
						else if(ismob(src.loc))
							if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
							usr.item_selected = src
							src.overlays -= /obj/effects/select_item
							src.overlays += /obj/effects/select_item
			milk //Gives endurance and bone exp
				name = "Milk"
				icon = 'Manyfoods.dmi'
				icon_state = "Milk"
				act = /obj/items/consumables/milk/proc/use
			//	act_drop = /obj/items/consumables/milk/proc/drop
				base_type = "Resistance"
				desc = "Tasty and edible feeding from cows and/or other mammals."
				food = 1
				//Toxic buildup from taking drug

				//Duration in 1/10 seconds

				//Does the drug have a comedown or not, and how long does it last

				//Changed permanently when taken
			//	force_gain = 1
			//	divine_eng_gain = 1
				metab_gain = 10
				hydro_gain = 25

				//Changed temporarily when taken

				//Changed temporarily when wears off
				proc
					use(var/mob/m,var/obj/items/consumables/i)
						if(i in m)
							if(m.has_stomach == 0)
								m.set_alert("Unable to drink milk",'alert.dmi',"alert")

								return
							if(m.thirst> 99)
								m.set_alert("Already quenched",'alert.dmi',"alert")

								return
							if(m.eating)
								m.set_alert("Already eating",'alert.dmi',"alert")

								return
							var/T = world.time
							i.apply_item_stats(m,T)
							if(i && m && i.loc == m && i.stacks > 0 && i == m.eating && i.time_eaten == T)
								i.use_obj(m)
								m.refresh_inv()
								if(m) m.eating = null
					drop(var/mob/m,var/obj/items/i)
						m.drop(i)
				New()
					..()
					spawn(10)
						if(src)
							if(ismob(src.loc) || isobj(src.loc)) return
							var/proceed = 0
							if(src.infused) proceed = 1
							else if(prob(10)) proceed = 1
							if(proceed)
								src.infused = 1
								//src.stacks = -1
								src.tech_lvl = 2
								src.name = "Milk"
								src.rarity = 1
								src.desc_extra = "Great for the bones!"
							//src.desc_extra = "[src.create_item_desc()]\n\n"
				Click(location,control,params)
					..()
					//Removes this item from the global Items list.
					if(items)
						if(src in items) items -= src
					params = params2list(params)
					if(params["left"])
						if(isturf(src.loc))
							usr.pickup(src)
							if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up x[src.stacks] [src]","actionoutput")
						else if(ismob(src.loc))
							if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
							usr.item_selected = src
							src.overlays -= /obj/effects/select_item
							src.overlays += /obj/effects/select_item


			ancient_bone
				name = "Ancient Bone"
				rarity = 1
				icon_state = "ancient bone"
				desc = "Old bones from a time long forgotten, sat dormant and slowly turning to stone. Grinding them into powder and consuming them would grant a boost in ones Endurance, but at the cost of Lifespan. Sometimes these are so old as to be saturated in dark energy, overflowing with power."
				desc_extra = "When Eaten:\n\n<font color = green>+ 1 level in Endurance</font>\n\n-<font color = red> 1 Lifespan</font>\n\n"
				act = /obj/items/consumables/ancient_bone/proc/use
				act_drop = /obj/items/consumables/ancient_bone/proc/drop
				base_type = "Endurance"
				//Toxic buildup from taking drug

				//Duration in 1/10 seconds

				//Does the drug have a comedown or not, and how long does it last

				//Changed permanently when taken
				end_gain = 1
				lifespan_gain = -1
				hydro_gain = -1

				//Changed temporarily when taken

				//Changed temporarily when wears off
				New()
					..()
				//	src.desc_extra = "[src.create_item_desc()]\n\n"
				proc
					use(var/mob/m,var/obj/items/consumables/i)
						if(i in m)
							if(m.eating)
								m.set_alert("Already absorbing",'alert.dmi',"alert")

								return
							var/T = world.time
							i.apply_item_stats(m,T)
							if(i && m && i.loc == m && i.stacks > 0 && i == m.eating && i.time_eaten == T)
								i.use_obj(m)
								m.refresh_inv()
								if(m) m.eating = null
					drop(var/mob/m,var/obj/items/i)
						m.drop(i)
				Click(location,control,params)
					..()
					//Removes this item from the global Items list.
					if(items)
						if(src in items) items -= src
					params = params2list(params)
					if(params["left"])
						if(isturf(src.loc))
							src.pixel_x = 0
							src.pixel_y = 0
							usr.pickup(src,2)
							if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up x[src.stacks] [src]","actionoutput")
						else if(ismob(src.loc))
							if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
							usr.item_selected = src
							src.overlays -= /obj/effects/select_item
							src.overlays += /obj/effects/select_item
			shroom_psi //Gives Max Psionic Power
				name = "Mushroom"
				rarity = 3
				icon_state = "psi shroom"
				desc = "Mushrooms have been known to absorb the properties of their surroundings, even going as far as soaking up ambient radioactive material. In the case of the Shroom, an oversaturation of Power seems to have caused it to grow.\n\nWhether its morphology is derived from an already known species of fungus, which happened to absorb Energy, or an entirely new organism, is unknown. What is known is when consumed, this fungus seems to grant Power and enhances the body."
				desc_extra = "When Eaten:\n\n<font color = green>+ 1 level in Power</font>\n\n<font color = green>+ 1 level in random bodypart</font>\n\n"
				act = /obj/items/consumables/shroom_psi/proc/use
			//	act_drop = /obj/items/consumables/shroom_psi/proc/drop
				base_type = "Regeneration"
				desc = "A strange fungus grown from the ground."
				//Toxic buildup from taking drug

				//Duration in 1/10 seconds

				//Does the drug have a comedown or not, and how long does it last

				//Changed permanently when taken
				//psi_gain = 1
				metab_gain = 15


				//Changed temporarily when taken

				//Changed temporarily when wears off
				proc
					use(var/mob/m,var/obj/items/consumables/i)
						if(i in m)
							if(m.has_stomach == 0 )
								m.set_alert("Unable to eat food",'alert.dmi',"alert")

								return
							if(m.hunger > 99)
								m.set_alert("Already full",'alert.dmi',"alert")

								return
							if(m.eating)
								m.set_alert("Already eating",'alert.dmi',"alert")

								return
							var/T = world.time
							i.apply_item_stats(m,T)
							if(i && m && i.loc == m && i.stacks > 0 && i == m.eating && i.time_eaten == T)
								i.use_obj(m)
								m.refresh_inv()
								if(m) m.eating = null
					drop(var/mob/m,var/obj/items/i)
						m.drop(i)
				New()
					..()
					spawn(10)
						if(src)
							if(ismob(src.loc) || isobj(src.loc)) return

							var/obj/shad = new
							shad.icon = src.icon
							shad.icon_state = "shad"
							shad.loc = src.loc
							shad.bolted = 2
							src.shadow = shad

							var/proceed = 0
							if(src.infused) proceed = 1
							else if(prob(5)) proceed = 1
							if(proceed)
								//src.stacks = -1
								src.tech_lvl = 2
								src.infused = 1
								src.psi_gain = 10
								src.lvl_rand_num = 10
								src.filters += filter(type="outline",size=1, color=rgb(204,236,255))
								src.filters += filter(type="outline",size=1, color=rgb(102,0,204))
								src.vis_contents += new/obj/effects/dark_matter_energy
								src.rarity = 4
								src.name = "Infused Mushroom"
								src.desc_extra = "When Eaten:\n\n<font color = green>+ 10 levels in Power</font>\n\n<font color = green>+ 1 level in 10 random bodyparts</font>\n\n"
							//src.desc_extra = "[src.create_item_desc()]\n\n"

				Click(location,control,params)
					..()
					//Removes this item from the global Items list.
					if(items)
						if(src in items) items -= src
					params = params2list(params)
					if(params["left"])
						if(isturf(src.loc))
							usr.pickup(src)
							if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up x[src.stacks] [src]","actionoutput")
						else if(ismob(src.loc))
							if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
							usr.item_selected = src
							src.overlays -= /obj/effects/select_item
							src.overlays += /obj/effects/select_item
			/*fossilized_part //Consumed by Demon/Celestial to gain a bodypart
				icon = 'consumables.dmi'
				icon_state = "fossilized organ"
				name = "fossilized part"
				rarity = 2
				hashadow = 0
				stacks = -1
				desc = "A fossilized part from some long dead eldritch creature or being, left to ossify over aeons. It seems to consist of pure concentrated ectoplasm and thrums with power."
				act = /obj/items/consumables/fossilized_part/proc/use
				act_drop = /obj/items/consumables/fossilized_part/proc/drop
				base_type = "Resistance"
				var/part_type_path
				var/part_infusion
				//Toxic buildup from taking drug

				//Duration in 1/10 seconds

				//Does the drug have a comedown or not, and how long does it last

				//Changed permanently when taken

				//Changed temporarily when taken

				//Changed temporarily when wears off
				proc
					slide(var/obj/items/misc/bonepile/b)
						spawn(1)
							if(src && b)
								var/steps = 10
								var/d = pick(b.ang)
								b.ang -= d
								while(steps)
									steps -= 1
									src.MoveAng(d,4,0,0,null)
									sleep(0.3)
					use(var/mob/m,var/obj/items/consumables/fossilized_part/i)
						if(i in m)
							if(m.race != "Demon" && m.race != "Kai")
								m.set_alert("Must be Demon or Kai",'alert.dmi',"alert")

								return
							if(m.has_body == 0)
								m.set_alert("Need body first",'alert.dmi',"alert")

								return
							if(m.eating)
								m.set_alert("Already eating",'alert.dmi',"alert")

								return
							if(m.organ_grow >= m.total_organs+1)
								m << "All bodyparts grown."
								m.set_alert("All bodyparts gained already",'alert.dmi',"alert")

								return
							var/dupe = 0
							var/obj/body_related/bodyparts/part
							var/obj/body_related/bodyparts/part_dest
							if(i.part_type_path)

								//Head
								if(ispath(i.part_type_path,/obj/body_related/bodyparts/head/))
									var/obj/body_related/bodyparts/head/h = m.bodyparts[1]
									for(var/obj/body_related/bodyparts/b in h)
										if(i.part_type_path == b.type)
											dupe = 1
											break
									if(dupe == 0)
										part_dest = h
										part = new i.part_type_path
									else
										m.set_alert("Already have this part",'alert.dmi',"alert")

										return

								//Torso
								if(ispath(i.part_type_path,/obj/body_related/bodyparts/torso/))
									var/obj/body_related/bodyparts/torso/h = m.bodyparts[2]
									for(var/obj/body_related/bodyparts/b in h)
										if(i.part_type_path == b.type)
											dupe = 1
											break
									if(dupe == 0)
										part_dest = h
										part = new i.part_type_path
									else
										m.set_alert("Already have this part",'alert.dmi',"alert")

										return

								//Left Arm
								if(ispath(i.part_type_path,/obj/body_related/bodyparts/left_arm/))
									var/obj/body_related/bodyparts/left_arm/t = m.bodyparts[3]
									for(var/obj/body_related/bodyparts/b in t)
										if(i.part_type_path == b.type)
											dupe = 1
											break
									if(dupe == 0)
										part_dest = t
										part = new i.part_type_path
									else
										m.set_alert("Already have this part",'alert.dmi',"alert")

										return

								//Right Arm
								if(ispath(i.part_type_path,/obj/body_related/bodyparts/right_arm/))
									var/obj/body_related/bodyparts/right_arm/t = m.bodyparts[4]
									for(var/obj/body_related/bodyparts/b in t)
										if(i.part_type_path == b.type)
											dupe = 1
											break
									if(dupe == 0)
										part_dest = t
										part = new i.part_type_path
									else
										m.set_alert("Already have this part",'alert.dmi',"alert")

										return

								//Right Leg
								if(ispath(i.part_type_path,/obj/body_related/bodyparts/right_leg/))
									var/obj/body_related/bodyparts/right_leg/t = m.bodyparts[5]
									for(var/obj/body_related/bodyparts/b in t)
										if(i.part_type_path == b.type)
											dupe = 1
											break
									if(dupe == 0)
										part_dest = t
										part = new i.part_type_path
									else
										m.set_alert("Already have this part",'alert.dmi',"alert")

										return

								//Left Leg
								if(ispath(i.part_type_path,/obj/body_related/bodyparts/left_leg/))
									var/obj/body_related/bodyparts/left_leg/t = m.bodyparts[6]
									for(var/obj/body_related/bodyparts/b in t)
										if(i.part_type_path == b.type)
											dupe = 1
											break
									if(dupe == 0)
										part_dest = t
										part = new i.part_type_path
									else
										m.set_alert("Already have this part",'alert.dmi',"alert")

										return

							var/T = world.time
							m.eating = i
							i.time_eaten = T
							m.eat()
							sleep(global.eat_time)
							if(i && m && m.eating == i && i.loc == m && i.time_eaten == T)
								m.icon_state = m.state()
								if(m.hud_eat)
									m.vis_contents -= m.hud_eat
									m.stunned -= 1
									m.stunned_pending -= 1

								if(part && dupe == 0 && part_dest)
									part.loc = part_dest
									part.name = part.info_name
									part.i_state = part.icon_state
									part.part_exp = 500
									part.part_reward(m,1)
									if(part.type == /obj/body_related/bodyparts/torso/stomach) m.has_stomach = 1
									m.screen_text.maptext = "<font size = 6><center>[part] absorbed"
									animate(m.screen_text,alpha = 255,time = 60)
									animate(alpha = 0,time = 60)
									if(i.part_infusion == "dark")
										part.i_state = "[initial(part.icon_state)] dark"
										part.icon_state = part.i_state
										part.infused_dark = 1
										part.part_exp = 1000
										part.part_reward(m,1)
										if(i.rarity >= 4)
											part.part_exp = 1500
											part.part_reward(m,1)
										if(i.rarity == 5)
											part.part_exp = 3000
											part.part_reward(m,1)

								if(i && m && i.loc == m && i == m.eating && i.time_eaten == T)
									i.use_obj(m)
									m.refresh_inv()
									if(m) m.eating = null
					drop(var/mob/m,var/obj/items/i)
						m.drop(i)
				New()
					..()
					spawn(10)
						if(src)
							if(ismob(src.loc)) return// || isobj(src.loc)) return

							var/obj/shad = new
							shad.icon = 'fx.dmi'
							shad.icon_state = "shadow"
							shad.loc = src.loc
							shad.bolted = 2
							//shad.appearance_flags = RESET_TRANSFORM | KEEP_APART
							//src.vis_contents += shad
							src.shadow = shad

							var/obj/body_related/p = pick(global.grow_order)
							src.part_type_path = p.type
							if(p.bodypart_type == "Organ") src.icon_state = "fossilized organ"
							else if(p.bodypart_type == "Muscle") src.icon_state = "fossilized muscle"
							else if(p.bodypart_type == "Bone") src.icon_state = "fossilized bone"
							src.name = "Fossilized [p.info_name]"
							spawn(rand(0,60))
								if(src)
									animate(src, pixel_y = 6, time = 10, loop = -1,easing= ANIMATION_RELATIVE, flags = BACK_EASING)
									animate(pixel_y = 4, time = 10)
							if(prob(10))
								src.rarity = 3
								if(prob(10))
									src.rarity = 4
							if(src.rarity >= 3)
								src.part_infusion = "dark"
								src.filters = null
								src.filters += filter(type="outline",size=1, color=rgb(204,236,255))
								src.filters += filter(type="outline",size=1, color=rgb(102,0,204))
								src.name = "Ancient Fossilized [p.info_name]"
							if(src.rarity >= 4)
								src.name = "Primordial Fossilized [p.info_name]"
								src.filters += filter(type="drop_shadow", x=0, y=0, size=0, offset=1, color=rgb(0,0,0))
								animate(src.filters[src.filters.len], size = 3,offset = 1, time = 20, loop = -1)
								animate(size = 0,offset = 1, time = 20)
								src.vis_contents += new/obj/effects/dark_matter_energy

								var/obj/rays = new
								rays.icon = 'fx_ray_small.dmi'
								rays.pixel_x = -16
								rays.pixel_y = -17
								rays.bolted = 2
								rays.step_y = 12
								rays.layer = src.layer-1
								rays.filters += filter(type="rays",x=0,y=0,size=64,color=rgb(0,0,0),offset=0,density=10,threshold=0.5,factor=0,flags=FILTER_OVERLAY)
								animate(rays.filters[1],offset = 100,time = 3333, loop = -1)
								animate(offset = 0,time = 0)
								src.vis_contents += rays

							src.desc_extra = "When Absorbed:\n\n<font color = green>Gain [p.info_name]</font>\n\n"

				Click(location,control,params)
					..()
					//Removes this item from the global Items list.
					if(items)
						if(src in items) items -= src
					params = params2list(params)
					if(params["left"])
						if(isturf(src.loc))
							usr.pickup(src)
						else if(ismob(src.loc))
							if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
							usr.item_selected = src
							src.overlays -= /obj/effects/select_item
							src.overlays += /obj/effects/select_item
			crystallized_part //Consumed by Demon/Celestial to gain a bodypart
				icon = 'consumables.dmi'
				icon_state = "crystallized organ"
				name = "crystallized part"
				rarity = 2
				hashadow = 0
				stacks = -1
				desc = "A crystallized part from a long-since deceased being or entity. It seems to consist of pure concentrated ectoplasm and thrums with power."
				act = /obj/items/consumables/crystallized_part/proc/use
				act_drop = /obj/items/consumables/crystallized_part/proc/drop
				var/part_type_path
				var/part_infusion
				base_type = "Resistance"
				//Toxic buildup from taking drug

				//Duration in 1/10 seconds

				//Does the drug have a comedown or not, and how long does it last

				//Changed permanently when taken

				//Changed temporarily when taken

				//Changed temporarily when wears off
				proc
					use(var/mob/m,var/obj/items/consumables/crystallized_part/i)
						if(i in m)
							if(m.race != "Demon" && m.race != "Kai")
								m.set_alert("Must be Demon or Kai",'alert.dmi',"alert")

								return
							if(m.has_body == 0)
								m.set_alert("Need body first",'alert.dmi',"alert")

								return
							if(m.eating)
								m.set_alert("Already eating",'alert.dmi',"alert")

								return
							if(m.organ_grow >= m.total_organs+1)
								m << "All bodyparts grown."
								m.set_alert("All bodyparts gained already",'alert.dmi',"alert")

								return
							var/dupe = 0
							var/obj/body_related/bodyparts/part
							var/obj/body_related/bodyparts/part_dest
							if(i.part_type_path)

								//Head
								if(ispath(i.part_type_path,/obj/body_related/bodyparts/head/))
									var/obj/body_related/bodyparts/head/h = m.bodyparts[1]
									for(var/obj/body_related/bodyparts/b in h)
										if(i.part_type_path == b.type)
											dupe = 1
											break
									if(dupe == 0)
										part_dest = h
										part = new i.part_type_path
									else
										m.set_alert("Already have this part",'alert.dmi',"alert")

										return

								//Torso
								if(ispath(i.part_type_path,/obj/body_related/bodyparts/torso/))
									var/obj/body_related/bodyparts/torso/h = m.bodyparts[2]
									for(var/obj/body_related/bodyparts/b in h)
										if(i.part_type_path == b.type)
											dupe = 1
											break
									if(dupe == 0)
										part_dest = h
										part = new i.part_type_path
									else
										m.set_alert("Already have this part",'alert.dmi',"alert")

										return

								//Left Arm
								if(ispath(i.part_type_path,/obj/body_related/bodyparts/left_arm/))
									var/obj/body_related/bodyparts/left_arm/t = m.bodyparts[3]
									for(var/obj/body_related/bodyparts/b in t)
										if(i.part_type_path == b.type)
											dupe = 1
											break
									if(dupe == 0)
										part_dest = t
										part = new i.part_type_path
									else
										m.set_alert("Already have this part",'alert.dmi',"alert")

										return

								//Right Arm
								if(ispath(i.part_type_path,/obj/body_related/bodyparts/right_arm/))
									var/obj/body_related/bodyparts/right_arm/t = m.bodyparts[4]
									for(var/obj/body_related/bodyparts/b in t)
										if(i.part_type_path == b.type)
											dupe = 1
											break
									if(dupe == 0)
										part_dest = t
										part = new i.part_type_path
									else
										m.set_alert("Already have this part",'alert.dmi',"alert")

										return

								//Right Leg
								if(ispath(i.part_type_path,/obj/body_related/bodyparts/right_leg/))
									var/obj/body_related/bodyparts/right_leg/t = m.bodyparts[5]
									for(var/obj/body_related/bodyparts/b in t)
										if(i.part_type_path == b.type)
											dupe = 1
											break
									if(dupe == 0)
										part_dest = t
										part = new i.part_type_path
									else
										m.set_alert("Already have this part",'alert.dmi',"alert")

										return

								//Left Leg
								if(ispath(i.part_type_path,/obj/body_related/bodyparts/left_leg/))
									var/obj/body_related/bodyparts/left_leg/t = m.bodyparts[6]
									for(var/obj/body_related/bodyparts/b in t)
										if(i.part_type_path == b.type)
											dupe = 1
											break
									if(dupe == 0)
										part_dest = t
										part = new i.part_type_path
									else
										m.set_alert("Already have this part",'alert.dmi',"alert")

										return

							var/T = world.time
							m.eating = i
							i.time_eaten = T
							m.eat()
							sleep(global.eat_time)
							if(i && m && m.eating == i && i.loc == m && i.time_eaten == T)
								m.icon_state = m.state()
								if(m.hud_eat)
									m.vis_contents -= m.hud_eat
									m.stunned -= 1
									m.stunned_pending -= 1

								if(part && dupe == 0 && part_dest)
									part.loc = part_dest
									part.name = part.info_name
									part.i_state = part.icon_state
									part.part_exp = 500
									part.part_reward(m,1)
									if(part.type == /obj/body_related/bodyparts/torso/stomach) m.has_stomach = 1
									m.screen_text.maptext = "<font size = 6><center>[part] absorbed"
									animate(m.screen_text,alpha = 255,time = 60)
									animate(alpha = 0,time = 60)
									if(i.part_infusion == "divine")
										part.i_state = "[initial(part.icon_state)] divine"
										part.icon_state = part.i_state
										part.infused_dark = 1
										part.part_exp = 1000
										part.part_reward(m,1)

								if(i && m && i.loc == m && i == m.eating && i.time_eaten == T)
									i.use_obj(m)
									m.refresh_inv()
									if(m) m.eating = null
					drop(var/mob/m,var/obj/items/i)
						m.drop(i)
				New()
					..()
					spawn(10)
						if(src)
							if(ismob(src.loc)) return// || isobj(src.loc)) return

							var/obj/shad = new
							shad.icon = 'fx.dmi'
							shad.icon_state = "shadow"
							shad.loc = src.loc
							shad.bolted = 2
							src.shadow = shad

							var/obj/body_related/p = pick(global.grow_order)
							src.part_type_path = p.type
							if(p.bodypart_type == "Organ") src.icon_state = "crystallized organ"
							else if(p.bodypart_type == "Muscle") src.icon_state = "crystallized muscle"
							else if(p.bodypart_type == "Bone") src.icon_state = "crystallized bone"
							src.name = "Crystallized [p.info_name]"
							spawn(rand(0,60))
								if(src)
									animate(src, pixel_y = 6, time = 10, loop = -1,flags = BACK_EASING)
									animate(pixel_y = 4, time = 10)
							if(prob(10))
								src.rarity = 3
								if(prob(10))
									src.rarity = 4
							if(src.rarity >= 3)
								src.part_infusion = "divine"
								src.filters = null
								src.filters += filter(type="outline",size=1, color=rgb(255,255,255))
								src.filters += filter(type="drop_shadow", x=0, y=0, size=1, offset=1, color=rgb(102,204,255))
								src.name = "Ancient Crystallized [p.info_name]"
							if(src.rarity >= 4)
								src.name = "Primordial Crystallized [p.info_name]"
								src.vis_contents += new/obj/effects/divine_energy

								var/obj/rays = new
								rays.icon = 'fx_ray_small.dmi'
								rays.pixel_x = -16
								rays.pixel_y = -17
								rays.bolted = 2
								rays.step_y = 12
								rays.layer = src.layer-1
								rays.filters += filter(type="rays",x=0,y=0,size=64,color=rgb(255,255,255),offset=0,density=10,threshold=0.5,factor=0,flags=FILTER_OVERLAY)
								animate(rays.filters[1],offset = 100,time = 3333, loop = -1)
								animate(offset = 0,time = 0)
								src.vis_contents += rays


							src.desc_extra = "When Absorbed:\n\n<font color = green>Gain [p.info_name]</font>\n\n"

				Click(location,control,params)
					..()
					//Removes this item from the global Items list.
					if(items)
						if(src in items) items -= src
					params = params2list(params)
					if(params["left"])
						if(isturf(src.loc))
							usr.pickup(src)
						else if(ismob(src.loc))
							if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
							usr.item_selected = src
							src.overlays -= /obj/effects/select_item
							src.overlays += /obj/effects/select_item

				*/
			shroom_red //Gives resistance
				name = "Amanita muscaria"
				icon_state = "redcap"
				//o_color = "#1eff00"
				rarity = 2
				desc = "Amanita muscaria, commonly known as the fly agaric or fly amanita, is a poisonous mushroom, granting a level in resistance when consumed. Be wary, as eating it will also remove 1% of your health."
				desc_extra = "When Eaten:\n\n<font color = green>+ 1 level in Resistance</font>\n\n-<font color = red> 1% health</font>\n\n"
				act = /obj/items/consumables/shroom_red/proc/use
				act_drop = /obj/items/consumables/shroom_red/proc/drop
				//Toxic buildup from taking drug
				toxic = 1
				toxin_gain = 0.0001
				toxicity = 50
				base_type = "Force"
				desc = "A strange fungus grown from the ground."

				//Duration in 1/10 seconds
				duration = 6000

				//Does the drug have a comedown or not, and how long does it last

				//Changed permanently when taken
				res_gain = 1
				metab_gain = 5
				lifespan_gain = -1

				//Changed temporarily when taken
				recov_gain_temp = -1
				regen_gain_temp = -1


				//Changed temporarily when wears off

				New()
					..()
					//src.desc_extra = "[src.create_item_desc()]\n\n"
				proc
					use(var/mob/m,var/obj/items/i)
						if(i in m)
							if(m.has_stomach == 0)
								m.set_alert("Unable to eat food",'alert.dmi',"alert")

								return
							if(m.hunger > 99)
								m.set_alert("Already full",'alert.dmi',"alert")

								return
							if(m.eating)
								m.set_alert("Already eating",'alert.dmi',"alert")

								return
							if(i.toxic)
								var/repeat = i.apply_same_drug(m)
								if(repeat == 0) i.create_drug_buff(m)
							var/T = world.time
							i.apply_item_stats(m,T)
							if(i && m && i.loc == m && i.stacks > 0 && i == m.eating && i.time_eaten == T)
								i.use_obj(m)
								m.refresh_inv()
								if(m) m.eating = null
					drop(var/mob/m,var/obj/items/i)
						m.drop(i)
				Click(location,control,params)
					..()
					//Removes this item from the global Items list.
					if(items)
						if(src in items) items -= src
					params = params2list(params)
					if(params["left"])
						if(isturf(src.loc))
							usr.pickup(src)
							if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up x[src.stacks] [src]","actionoutput")
						else if(ismob(src.loc))
							if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
							usr.item_selected = src
							src.overlays -= /obj/effects/select_item
							src.overlays += /obj/effects/select_item
			bean_arabica //Gives Max Energy and boosts Recovery
				name = "Arabica Bean"
				icon_state = "bean"
				//o_color = "#1eff00"
				rarity = 2
				food = 1
				desc = "A vegetable grown from the ground."
				act = /obj/items/consumables/bean_arabica/proc/use
				act_drop = /obj/items/consumables/bean_arabica/proc/drop
				//Toxic buildup from taking drug

				//Duration in 1/10 seconds

				//Does the drug have a comedown or not, and how long does it last

				//Changed permanently when taken
				metab_gain = 5
				lvl_parts = list("Heart")
				lvl_parts_num = 0.1
				base_type = "Speed"

				//Changed temporarily when taken

				//Changed temporarily when wears off

				New()
					..()
					//src.desc_extra = "[src.create_item_desc()]\n\n"
				proc
					use(var/mob/m,var/obj/items/i)
						if(i in m)
							if(m.has_stomach == 0)
								m.set_alert("Unable to eat food",'alert.dmi',"alert")

								return
							if(m.hunger > 99)
								m.set_alert("Already full",'alert.dmi',"alert")

								return
							if(m.eating)
								m.set_alert("Already eating",'alert.dmi',"alert")

								return
							var/T = world.time
							i.apply_item_stats(m,T)
							if(i && m && i.loc == m && i.stacks > 0 && i == m.eating && i.time_eaten == T)
								i.use_obj(m)
								m.refresh_inv()
								if(m) m.eating = null
					drop(var/mob/m,var/obj/items/i)
						m.drop(i)
				Click(location,control,params)
					..()
					//Removes this item from the global Items list.
					if(items)
						if(src in items) items -= src
					params = params2list(params)
					if(params["left"])
						if(isturf(src.loc))
							usr.pickup(src)
							if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up x[src.stacks] [src]","actionoutput")
						else if(ismob(src.loc))
							if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
							usr.item_selected = src
							src.overlays -= /obj/effects/select_item
							src.overlays += /obj/effects/select_item
			shroom_truffle //Gives Strength, Endurance and Max Energy
				name = "Truffle"
				icon_state = "truffle"
				//o_color = "#0070dd"
				rarity = 3
				desc = "These very rare types of fungus are potent and useful for someone seeking a strong and endurant body. Eating one not only heals you slightly, but also gives a level in Strength, Endurance and Energy."
				desc_extra = "When Eaten:\n\n<font color = green>+ 1 level in Energy</font>\n\n<font color = green>+ 1 level in Strength</font>\n\n<font color = green>+ 1 level in Endurance</font>\n\n<font color = green>+ 1% health</font>\n\n"
				act = /obj/items/consumables/shroom_truffle/proc/use
				act_drop = /obj/items/consumables/shroom_truffle/proc/drop
				base_type = "Endurance"
				//Toxic buildup from taking drug

				//Duration in 1/10 seconds

				//Does the drug have a comedown or not, and how long does it last

				//Changed permanently when taken
				metab_gain = 10
				eng_gain = 1
				str_gain = 1
				end_gain = 1

				//Changed temporarily when taken

				//Changed temporarily when wears off

				New()
					..()
					//src.desc_extra = "[src.create_item_desc()]\n\n"
				proc
					use(var/mob/m,var/obj/items/i)
						if(i in m)
							if(m.has_stomach == 0)
								m.set_alert("Unable to eat food",'alert.dmi',"alert")

								return
							if(m.hunger > 99)
								m.set_alert("Already full",'alert.dmi',"alert")

								return
							if(m.eating)
								m.set_alert("Already eating",'alert.dmi',"alert")

								return
							var/T = world.time
							i.apply_item_stats(m,T)
							if(i && m && i.loc == m && i.stacks > 0 && i == m.eating && i.time_eaten == T)
								i.use_obj(m)
								m.refresh_inv()
								if(m) m.eating = null
					drop(var/mob/m,var/obj/items/i)
						m.drop(i)
				Click(location,control,params)
					..()
					//Removes this item from the global Items list.
					if(items)
						if(src in items) items -= src
					params = params2list(params)
					if(params["left"])
						if(isturf(src.loc))
							usr.pickup(src)
							if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up x[src.stacks] [src]","actionoutput")
						else if(ismob(src.loc))
							if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
							usr.item_selected = src
							src.overlays -= /obj/effects/select_item
							src.overlays += /obj/effects/select_item
			manuka_honey //boosts Regen for a while, increase lifespan. (Little bee nests in trees you can womp)
				name = "Manuka Honey"
				icon_state = "honey 1"
				act = /obj/items/consumables/manuka_honey/proc/use
				act_drop = /obj/items/consumables/manuka_honey/proc/drop
				base_type = "Regeneration"
				proc
					use(var/mob/m,var/obj/items/i)
					drop(var/mob/m,var/obj/items/i)
						m.drop(i)
				New()
					..()
					src.icon_state = "honey [rand(1,2)]"
				Click(location,control,params)
					..()
					//Removes this item from the global Items list.
					if(items)
						if(src in items) items -= src
					params = params2list(params)
					if(params["left"])
						if(isturf(src.loc))
							usr.pickup(src)
							if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up x[src.stacks] [src]","actionoutput")
						else if(ismob(src.loc))
							if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
							usr.item_selected = src
							src.overlays -= /obj/effects/select_item
							src.overlays += /obj/effects/select_item
			honeydew //boosts Recovery for a while. (Created each day, can harvest it by walking through longrass)
				name = "Honeydew"
				icon_state = "honeydew"
				act = /obj/items/consumables/honeydew/proc/use
				act_drop = /obj/items/consumables/honeydew/proc/drop
				base_type = "Recovery"
				proc
					use(var/mob/m,var/obj/items/i)
					drop(var/mob/m,var/obj/items/i)
						m.drop(i)
				Click(location,control,params)
					..()
					//Removes this item from the global Items list.
					if(items)
						if(src in items) items -= src
					params = params2list(params)
					if(params["left"])
						if(isturf(src.loc))
							usr.pickup(src)
							if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up x[src.stacks] [src]","actionoutput")
						else if(ismob(src.loc))
							if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
							usr.item_selected = src
							src.overlays -= /obj/effects/select_item
							src.overlays += /obj/effects/select_item
			zarberry //increases all stats slightly, boosts regen for a while.
				name = "Zarberry"
				icon = 'artifacts_small.dmi'
				icon_state = "zarberry"
				desc = "A berry tree grown from the ground."
				//o_color = "#a335ee"
				rarity = 4
				act = /obj/items/consumables/zarberry/proc/use
				act_drop = /obj/items/consumables/zarberry/proc/drop
				base_type = "Recovery"
				desc_extra = ""
				//Toxic buildup from taking drug

				//Duration in 1/10 seconds

				//Does the drug have a comedown or not, and how long does it last

				//Changed permanently when taken
				metab_gain = 25
				hydro_gain = 25
				//lvl_parts = list("Organ")
				//lvl_parts_num = 1

				//Changed temporarily when taken

				//Changed temporarily when wears off

				New()
					..()
					//src.desc_extra = "[src.create_item_desc()]\n\n"
				proc
					use(var/mob/m,var/obj/items/i)
						if(i in m)
							if(m.has_stomach == 0 )
								m.set_alert("Unable to eat food",'alert.dmi',"alert")

								return
							if(m.hunger > 99)
								m.set_alert("Already full",'alert.dmi',"alert")

								return
							if(m.eating)
								m.set_alert("Already eating",'alert.dmi',"alert")

								return
							var/T = world.time
							i.apply_item_stats(m,T)
							if(i && m && i.loc == m && i.stacks > 0 && i == m.eating && i.time_eaten == T)
								i.use_obj(m)
								m.refresh_inv()
								if(m) m.eating = null
					drop(var/mob/m,var/obj/items/i)
						m.drop(i)
				Click(location,control,params)
					..()
					//Removes this item from the global Items list.
					if(items)
						if(src in items) items -= src
					params = params2list(params)
					if(params["left"])
						if(isturf(src.loc))
							usr.pickup(src)
							if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up x[src.stacks] [src]","actionoutput")
						else if(ismob(src.loc))
							if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
							usr.item_selected = src
							src.overlays -= /obj/effects/select_item
							src.overlays += /obj/effects/select_item

		artifacts
			invul_melee = 1
			mouse_over_pointer = MOUSE_ACTIVE_POINTER
			hashadow = 1
			hp = 9999999
			legendary = 1
			rarity = 5
				/*
				New()
					..()
					spawn(rand(10,20))
						if(src)
							src.waves()
							src.filters += filter(type="drop_shadow", x=0, y=0,size=5, offset=2, color=rgb(255,255,170))
							src.filters += filter(type="bloom", threshold=rgb(0,0,0), size = 6,offset=1,alpha = 175)

							animate(src,pixel_y = 6,time = 15, loop = -1, flags = ANIMATION_PARALLEL)
							animate(pixel_y = 0,time = 15)
							animate(src, transform = matrix()*1.5, time = 10, loop = -1,flags=ANIMATION_PARALLEL)
							animate(transform = matrix()*1, time = 10)
				*/
			/*
			Shards for each enviromental effect that makes you immune when holding them.

			Fire Shard
				- Grants immunity to heat while held
				- Looks like a shard of crystal, red/orange with a white outline and pulsating orange/red light. Has a ember particle effect attached to it.
				- Found inside the heart of Earth's volcano? Or maybe found underground, inside the heart of the Demonic portion of the psi realm.
			Ice Shard
				- Grants immunity to cold while held
				- Looks like a shard of Ice/Black Ice, glows slightly with a faint outline, like the shard in the psi realm. Has a snow particle effect attached to it.
				- Found underground either on Earth, or perhaps in the Celestial portion of the psi realm.
			Gravity Shard
				- Grants immunity to gravity while held
				- Looks like a diamond shaped crystal, like a mini black hole.
				- Found inside Dark Matter Realm, so players can't use it to enter the realm, since you need high/inf grav mastered to enter that realm.
			Radiation Shard
				- Grants immunity to radiation while held
				- Looks like a dodecahedron, glows like the radiation crystals.
				- Maybe found locked inside a lab/power plant on Earth
			Microwave Shard
				- Grants immunity to microwaves while held
				- Looks like a shard of crystal, and has ligthning crackling around it.
				- Found on Yukopia
			Toxin Shard
				- Grants immunity to toxins while held
				- Looks like a green spikey crystal shard with an aura of toxic around it.
				- Found inside a sentient super rare plant that attacks players when they are near.
			*/
			immunity_shards
				heat_shard
				cold_shard
				gravity_shard
				radiation_shard
				microwave_shard
				toxin_shard
			continuum_gems
				//These are dropped by bosses
				power_gem
					//increases power mod
					//gives passive xp toward power
					//age quicker, since it takes more energy from the body to function.
				agility_gem
					//increases agility mod
					//gives passive xp toward agility
					//age quicker, since you move quicker through time and space.
				regeneration_gem
					//increases regen mod
					//makes you hungry quicker, since it takes more energy from the body to function.
				awareness_gem
					//Lets you see everyone, everywhere, at all times
					//Adds everyone to your contacts list
					//Gives contact exp, even if not near contacts
				defence_gem
					//increases def mod
					//gives passive xp toward def
				intelligence_gem
					//increases int mod
					//gives passive xp toward skill levels
					//Makes you sleepy quicker, since it takes more energy from the body to function.
				strength_gem
					//increases str mod
					//gives passive xp toward str
				energy_gem
					//increases eng mod
					//gives passive xp toward eng
					//Stops the Dantian from being leveled as quickly, or at all.
				force_gem
					//increases force mod
					//gives passive xp toward force
				offence_gem
					//increases off mod
					//gives passive xp toward off
				resistance_gem
					//increases res mod
					//gives passive xp toward res
				endurance_gem
					//increases end mod
					//gives passive xp toward end
				vitality_gem
					//increases lifespan
				equilibrium_gem
					//increases your divine energy and dark matter mods
				recovery_gem
					//increases recovery mod
					//makes you thirsty quicker, since it takes more energy from the body to function.
				paradise_forever
					//All the gems combined spell Paradise Forever
					//Lets you do something completely insane, like make a wish, for example
					//Also gives you the effects of all the gems
					//Unlocks a special ascension of its namesake that basically makes you a god and/or "Psiforged" instantly.
					//Or unlocks a special realm instead
					//When combined, could play a cool animation of all the gems lining up, and as each one does, the letters of their names appear above them, spelling out Paradise Forever.
					//Or could have the letters appear on the screen slowly as the gems line up

			phylactery
				icon = 'artifacts_small.dmi'
				icon_state = "dark matter ball"
				name = "Phylactery"
				can_pocket = 1
				density_factor = 0
				density = 0;
				//plane = 2;
				radius = 5;
				layer = 10
				New()
					spawn(10)
						if(src)
							src.step_y = 12
							src.filters += filter(type="outline",size=1, color=rgb(204,236,255))
							src.filters += filter(type="drop_shadow", x=0, y=0, size=1, offset=1, color=rgb(102,0,204))

							animate(src,pixel_y = 4, time = 15, loop = -1)
							animate(pixel_y = 0, time = 15)
							animate(src.filters[2], size = 2,offset = 2, time = 15, loop = -1,flags = ANIMATION_PARALLEL)
							animate(size = 0,offset = 0, time = 15, loop = -1)

							var/obj/rays = new
							rays.icon = 'fx_ray_small.dmi'
							rays.pixel_x = -16
							rays.pixel_y = -16
							rays.loc = src.loc
							rays.bolted = 2
							rays.step_y = 12
							rays.layer = 9
							rays.filters += filter(type="rays",x=0,y=0,size=56,color=rgb(25,25,25),offset=0,density=10,threshold=0.5,factor=0,flags=FILTER_OVERLAY)
							animate(rays.filters[1],offset = 100,time = 1500, loop = -1)
							animate(offset = 0,time = 0)
							animate(rays.filters[1],y = 4,time = 15, loop = -1, flags = ANIMATION_PARALLEL)
							animate(y = 0, time = 15)


							src.vis_contents += new/obj/effects/dark_matter_energy
			blueprint
				icon = 'artifacts_small.dmi'
				icon_state = "blueprints"
				can_pocket = 1;
			skillbook
				icon = 'artifacts_small.dmi'
				icon_state = "skillbook"
				can_pocket = 1;
				var/contains = null
				New()
					spawn(30)
						if(src)
							var/obj/skills/s = pick(learnable_skills)
							contains = s.type
							src.name = "Skillbook: [s.name]"
				Click(location, control, params)
					..()
					params = params2list(params)
					if(params["right"])
						if(src in usr)
							var/has = 0
							for(var/obj/skills/s in usr)
								if(s.type == src.contains)
									has = 1
									break
							var/obj/I = new src.contains()
							if(has == 0)
								I.loc = usr
								usr.set_alert("Learned new skill: [I.name]",I.icon,I.icon_state)
								src.loc = null
							else
								usr.set_alert("[I.name] already known",src.icon,src.icon_state)

								I.loc = null
							usr.refresh_inv()
			psi_orb
				name = "Psi Orb"
				icon = 'artifacts_small.dmi'
				icon_state = "psi orb"
				can_pocket = 1
				disable_logout = 1
				hp = 9999999
				act = /obj/items/artifacts/psi_orb/proc/use
				act_drop = /obj/items/artifacts/psi_orb/proc/drop
				var
					tmp/obj/twin = null
				proc
					drop(var/mob/m,var/obj/items/i)
						m.drop(i)
					use(var/mob/m,var/obj/items/artifacts/psi_orb/i)
						if(i in range(1,usr))
							if(i.active)
								i.icon_state = "psi orb"
								i.twin.icon_state = "psi orb"
								i.active = 0
								i.twin.active = 0
								i.overlays = null
								i.twin.overlays = null
								i.can_pocket = 1
								i.twin.can_pocket = 1
							else
								if(ismob(i.loc))
									var/mob/x = i.loc
									i.loc = x.loc
								if(ismob(i.twin.loc))
									var/mob/x = i.twin.loc
									i.twin.loc = x.loc
								i.shake()
								i.twin.shake()
								i.shockwave()
								i.twin.shockwave()
								i.icon_state = "psi orb on"
								i.twin.icon_state = "psi orb on"
								i.active = 1
								i.twin.active = 1
								i.can_pocket = 0
								i.twin.can_pocket = 0

								var/obj/p = new
								p.icon = 'fx_portal.dmi'
								p.pixel_x = -50
								p.pixel_y = -52
								p.layer = 50
								p.alpha = 240
								i.overlays += p

								var/obj/p2 = new
								p2.icon = 'fx_portal.dmi'
								p2.pixel_x = -50
								p2.pixel_y = -52
								p2.layer = 50
								p2.alpha = 240
								twin.overlays += p2
				New()
					spawn(10)
						if(src.twin == null)
							var/obj/items/artifacts/psi_orb/o = new
							o.loc = locate(rand(1,500),rand(1,500),1)
							src.twin = o
							o.twin = src
						src.filters += filter(type="drop_shadow", x=0, y=0,\
						size=5, offset=2, color=rgb(100,0,200))
						spawn(10)
							while(src)
								if(ismob(src.loc))
									var/mob/m = src.loc
									for(var/obj/skills/Telekinesis/T in m)
										T.skill_exp += (5/T.skill_lvl)*m.mod_skill
										if(T.skill_exp >= 100 && T.skill_lvl < 100)
											T.skill_exp = 1
											T.skill_lvl += 1
									for(var/obj/skills/Sense/S in m)
										S.skill_exp += (5/S.skill_lvl)*m.mod_skill
										if(S.skill_exp >= 100 && S.skill_lvl < 100)
											S.skill_exp = 1
											S.skill_lvl += 1
								if(src.active)
									for(var/mob/m in range(0,src))
										m.loc = locate(src.twin.x,src.twin.y-1,src.twin.z)
								sleep(1)
				Click(location,control,params)
					..()
					//Removes this item from the global Items list.
					if(items)
						if(src in items) items -= src
					params = params2list(params)
					if(params["left"])
						if(isturf(src.loc))
							usr.pickup(src)
							if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up x[src.stacks] [src]","actionoutput")
						else if(ismob(src.loc))
							if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
							usr.item_selected = src
							src.overlays -= /obj/effects/select_item
							src.overlays += /obj/effects/select_item

			everfrost
				name = "Everfrost"
				icon = 'artifacts_large.dmi'
				icon_state = "frost shard"
				bolted = 3
				hp = 9999999
				pixel_x = -16
				pixel_y = -16
				New()
					spawn(10)
						if(src)
							//src.filters += filter(type="drop_shadow", x=0, y=0, size=1, offset=1, color=rgb(102,204,255))


							//src.filters += filter(type="outline",size=1, color=rgb(204,236,255))
							src.filters += filter(type="drop_shadow", x=0, y=0, size=1, offset=1, color=rgb(102,204,255))

							animate(src.filters[1], size = 2,offset = 2, time = 15, loop = -1)
							animate(size = 0,offset = 0, time = 15, loop = -1)

							animate(src,pixel_y = 4,time = 20,loop = -1,flags = ANIMATION_PARALLEL)
							animate(pixel_y = -4, time = 20)
				/*
				proc
					glow()
						animate(src.filters[src.filters.len], offset = 4, time = 5, loop = -1)
						animate(src.filters[src.filters.len], offset = 2, time = 5)

				New()
					spawn(50)
						src.filters += filter(type="drop_shadow", x=0, y=0,\
						size=5, offset=2, color=rgb(255,255,170))
						spawn(50)
							if(src) src.glow()

				Click(location,control,params)
					..()
					params = params2list(params)
					if(params["right"])
						src.compress("right",usr,4,0)
				*/
			tesseract_matrix
				name = "Tesseract Matrix"
				icon = 'artifacts_small.dmi'
				icon_state = "empty"
				disable_logout = 1
				can_activate = 1
				hp = 9999999
				proc
					glow()
						animate(src.filters[src.filters.len], offset = 4, time = 5, loop = -1)
						animate(src.filters[src.filters.len], offset = 2, time = 5)

				New()
					spawn(50)
						src.filters += filter(type="drop_shadow", x=0, y=0,\
						size=5, offset=2, color=rgb(255,255,170))
						spawn(50)
							if(src) src.glow()

				Click(location,control,params)
					..()
					params = params2list(params)

			psionic_shard
				name = "Psionic Shard"
				icon = 'artifacts_small.dmi'
				icon_state = "shard main"
				can_pocket = 1
				proc
					glow()
						while(src)
							animate(src.filters[src.filters.len], offset = 4, time = 5)
							animate(src.filters[src.filters.len], offset = 2, time = 5)
							sleep(10)
				New()
					spawn(50)
						src.filters += filter(type="drop_shadow", x=0, y=0,\
						size=5, offset=2, color=rgb(47,172,255))
						spawn(50)
							src.glow()
				Click(location,control,params)
					..()
					params = params2list(params)
					if(params["right"])
						if(src in range(1,usr))
							if(src.can_pocket == 0) return
							//src.loc = locate(usr.x,usr.y-1,usr.z)
							var/shards = 25
							var/list/shard_bits = list()
							src.can_pocket = 0
							src.shake()
							src.shockwave()
							while(shards)
								shards -= 1
								var/obj/s = new
								s.icon = src.icon
								s.icon_state = pick("shard1","shard2","shard3","shard4")
								s.loc = src.loc
								s.layer = 333
								shard_bits += s
								sleep(0.1)
							src.loc = null
							for(var/obj/x in shard_bits)
								var/X = rand(-224,224)
								var/X_continue
								if(X > 0) X_continue=X+33
								else	X_continue=X-33
								animate(x,pixel_y = rand(-224,224),pixel_x = X,transform = turn(matrix(), 240), time = 3,easing = QUAD_EASING)
								animate(pixel_y = x.pixel_y/1.5,pixel_x = X_continue, time = 6,easing = QUAD_EASING,flags = ANIMATION_PARALLEL)
								animate(alpha = 0,time = 100)
							usr.skill_points_combat += 1
							sleep(6)
							for(var/obj/x in shard_bits)
								x.layer = initial(x.layer)
							src.destroy()
		plants
			hp = 100
			dust = 0
			hashadow = 1

			var/bush=0
			appearance_flags = TILE_BOUND
			/*
			Cross(atom/movable/O)
				..()
				if(src.shudders) if(O.density_factor)
					animate(src,transform = turn(matrix(), 5), time = 1)
					animate(transform = turn(matrix(), -5), time = 1)
					animate(transform = turn(matrix(), 0), time = 1)
				if(src.density_factor == 0)
					return 1
				if(O.density_factor == 0)
					return 1
			*/
			beanstalk
				name = "Beanstalk"
				icon = 'beanstalk.dmi'
				icon_state = "beanstalk 4"
				bolted = 1
				disable_logout = 1
				hashadow = 0
				hp = 100
				bounds = "14,1 to 19,8"
				density_factor = 1
				can_activate = 1
				base_type = "Endurance"
				var
					berries = 4
				New()
					..()
					spawn(10)
						if(src)
							var/obj/shad = new
							shad.icon = src.icon
							shad.icon_state = "shad"
							shad.pixel_y = -3
							shad.loc = src.loc
							shad.bolted = 2
							src.shadow = shad
							/*
							while(src)
								if(src.berries < 4)
									src.berries += 4
									src.icon_state = "beanstalk [src.berries]"
								sleep(3333)
							*/
				Click(location,control,params)
					..()
					usr.mouse_down = null
					params = params2list(params)
					if(params["left"])
						if(src in range(1,usr))
							if(src.berries > 0)
								src.berries -= 1
								src.icon_state = "beanstalk [src.berries]"
								var/obj/items/consumables/bean_arabica/bean = new
								bean.loc = usr
								usr.pickup(bean)
								if(ismob(bean.loc)) view(15,usr)<<output("[usr] picks up x[src.stacks] [src]","actionoutput")
								usr.refresh_inv()
								spawn(3333)
									if(src && src.berries < 4)
										src.berries += 1
										src.icon_state = "beanstalk [src.berries]"
			zarberry_plant
				name = "Zarberry Plant"
				icon = 'zarberry_plant.dmi'
				icon_state = "zarberry plant 5"
				bolted = 1
				disable_logout = 1
				hashadow = 0
				hp = 100
				bounds = "10,1 to 22,8"
				density_factor = 1
				can_activate = 1
				base_type = "Recovery"
				var
					berries = 5
				New()
					..()
					spawn(10)
						var/obj/shad = new
						shad.icon = src.icon
						shad.icon_state = "shadow"
						shad.alpha = 100
						shad.pixel_y = -3
						shad.loc = src.loc
						shad.bolted = 2
						src.shadow = shad
						/*
						while(src)
							if(src.berries < 5)
								src.berries += 1
								src.icon_state = "zarberry plant [src.berries]"
							sleep(3333)
						*/
				Click(location,control,params)
					..()
					usr.mouse_down = null
					params = params2list(params)
					if(params["left"])
						if(src in range(1,usr))
							if(src.berries > 0)
								src.berries -= 1
								src.icon_state = "zarberry plant [src.berries]"
								var/obj/items/consumables/zarberry/z = new
								z.loc = usr
								usr.pickup(z)
								if(ismob(z.loc)) view(15,usr)<<output("[usr] picks up x[src.stacks] [src]","actionoutput")
								usr.refresh_inv()
								spawn(3333)
									if(src && src.berries < 5)
										src.berries += 1
										src.icon_state = "zarberry plant [src.berries]"
			tuff
				icon = 'plants.dmi'
				bolted = 1
				icon_state = "tuff1"
				hashadow = 0
				hp = 2
				New()
					src.icon_state = "tuff[rand(1,6)]"
					src.pixel_x = rand(-4,4)
					src.pixel_y = rand(-4,4)
			rockgrass
				icon = 'plants.dmi'
				bolted = 1
				icon_state = "rock1"
				hashadow = 0
				hp = 50000
				New()
					src.icon_state = "rock[rand(1,4)]"
			twig
				icon = 'plants.dmi'
				bolted = 1
				icon_state = "twig1"
				hashadow = 0
				hp = 2
				New()
					src.icon_state = "twig[rand(1,2)]"
			lily
				icon = 'plants.dmi'
				bolted = 1
				icon_state = "pad1"
				hashadow = 0
				hp = 2
				New()
					var/n = rand(1,4)
					src.icon_state = "pad[n]"
					src.step_x = rand(-16,16)
					src.step_y = rand(-16,16)
					if(n <= 2) if(prob(25))
						var/obj/items/consumables/lotus_flower/l = new
						l.loc = src.loc
						l.step_x = src.step_x
						l.step_y = src.step_y
			reeds
				icon = 'plants.dmi'
				bolted = 1
				icon_state = "reeds1"
				hashadow = 0
				hp = 2
				New()
					src.icon_state = "reeds[rand(1,3)]"
					src.pixel_x = rand(-16,16)
					src.pixel_y = rand(-16,16)
			flower
				icon = 'plants.dmi'
				bolted = 1
				icon_state = "flower2"
				hashadow = 1
				hp = 2
				filters = filter(type="outline", size=1, color=rgb(84,107,60))
				New()
					src.icon_state = "flower[rand(1,5)]"
			crystal_plant1
				icon = 'plants.dmi'
				bolted = 1
				icon_state = "crystal plant1"
				hashadow = 1
			crystal_tuff
				icon = 'plants.dmi'
				bolted = 1
				icon_state = "crystal tuff"
				hashadow = 0
			plant
				icon = 'plants.dmi'
				bolted = 1
				icon_state = "plant2"
				hashadow = 1
				filters = filter(type="outline", size=1, color=rgb(84,107,60))
				New()
					src.icon_state = "plant[rand(1,5)]"
			divine_tree1
				icon = 'tree_divine.dmi'
				bolted = 1
				icon_state = "tree1"
				shudders = 1
				New()
					..()
					src.filters += filter(type="outline",size=1, color=rgb(204,236,255))
					src.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(204,236,255))
					src.filters += filter(type="bloom", threshold=rgb(0,0,0), size = 6,offset=1,alpha = 175)
			crystal_bush_large1
				icon = 'bush_large.dmi'
				bolted = 1
				icon_state = "crystal bush1"
				shudders = 1
				pixel_x = -32
				bounds = "-7,1 to 40,24"
				New()
					..()
					//src.filters += filter(type="bloom", threshold=rgb(0,0,0), size = 6,offset=1,alpha = 175)
					var/t = rand(10,20)
					var/obj/i = new
					i.appearance = src.appearance
					src.vis_contents += i
					i.alpha = 155
					i.bolted = 2
					i.pixel_x = 0
					animate(i, transform = matrix()*1.5,alpha = 0, time = t, loop = -1)
					animate(transform = matrix()*1,alpha = 155,time = 0)
			crystal_bush_large2
				icon = 'bush_large.dmi'
				bolted = 1
				icon_state = "crystal bush2"
				shudders = 1
				pixel_x = -32
				bounds = "-7,1 to 40,24"
				New()
					..()
					//src.filters += filter(type="bloom", threshold=rgb(0,0,0), size = 6,offset=1,alpha = 175)
					var/t = rand(10,20)
					var/obj/i = new
					i.appearance = src.appearance
					src.vis_contents += i
					i.alpha = 155
					i.bolted = 2
					i.pixel_x = 0
					animate(i, transform = matrix()*1.5,alpha = 0, time = t, loop = -1)
					animate(transform = matrix()*1,alpha = 155,time = 0)
			crystal_bush_small1
				icon = 'bush_small.dmi'
				bolted = 1
				icon_state = "crystal bush"
				shudders = 1
				New()
					..()
					//src.filters += filter(type="bloom", threshold=rgb(0,0,0), size = 6,offset=1,alpha = 175)
					var/t = rand(10,20)
					var/obj/i = new
					i.appearance = src.appearance
					src.vis_contents += i
					i.alpha = 155
					i.bolted = 2
					animate(i, transform = matrix()*1.5,alpha = 0, time = t, loop = -1)
					animate(transform = matrix()*1,alpha = 155,time = 0)
			crystal_bush_small2
				icon = 'bush_small.dmi'
				bolted = 1
				icon_state = "crystal bush2"
				shudders = 1
				New()
					..()
					//src.filters += filter(type="bloom", threshold=rgb(0,0,0), size = 6,offset=1,alpha = 175)
					var/t = rand(10,20)
					var/obj/i = new
					i.appearance = src.appearance
					src.vis_contents += i
					i.alpha = 155
					i.bolted = 2
					animate(i, transform = matrix()*1.5,alpha = 0, time = t, loop = -1)
					animate(transform = matrix()*1,alpha = 155,time = 0)
			tree_yuk_1
				icon = 'tree_yuk.dmi'
				bolted = 1
				//icon_state = "1"
				//shudders = 1
				//hashadow = 1
				bounds = "9,8 to 39,21"
				density_factor = 1
			plant_small_yuk_1
				icon = 'bush_small_yuk.dmi'
				bolted = 1
				icon_state = "4"
				shudders = 1
				hashadow = 0
			bush_small_yuk_1
				icon = 'bush_small_yuk.dmi'
				bolted = 1
				icon_state = "1"
				shudders = 1
				hashadow = 0
			bush_small_yuk_2
				icon = 'bush_small_yuk.dmi'
				bolted = 1
				icon_state = "2"
				shudders = 1
				hashadow = 0
			bush_small_yuk_3
				icon = 'bush_small_yuk.dmi'
				bolted = 1
				icon_state = "3"
				shudders = 1
				hashadow = 0
			bush_small1
				icon = 'bush_small.dmi'
				bolted = 1
				icon_state = "bare"
				shudders = 1
				New()
					src.icon_state = pick("bare","berries")
			bush_small2
				icon = 'bush_small.dmi'
				bolted = 1
				icon_state = "bush2"
				shudders = 1
			bush_small3
				icon = 'bush_small.dmi'
				bolted = 1
				icon_state = "bush3"
				shudders = 1
			bush_large1
				icon = 'bush_large.dmi'
				bolted = 1
				icon_state = "bare"
				shudders = 1
				pixel_x = -32
				bounds = "-7,1 to 40,24"
				New()
					..()
					src.icon_state = pick("bare","berries")
			bush_large2
				icon = 'bush_large.dmi'
				bolted = 1
				icon_state = "bush2"
				shudders = 1
				pixel_x = -32
				bounds = "-7,1 to 40,24"
			bush_large3
				icon = 'bush_large.dmi'
				bolted = 1
				icon_state = "bush3"
				shudders = 1
				pixel_x = -32
				bounds = "-7,1 to 40,24"
			tree_oak
				icon = 'tree_oak.dmi'
				icon_state = "tree leaves"
				density_factor = 1
				pixel_x = -32
				bolted = 1
				bounds = "-14,10 to 47,35"
				hashadow = 0
				weight = 2
				tree=1
				hp=1
				/*
				New()
					..()
					spawn(10)
						if(src)
							var/obj/L = new
							L.icon = src.icon
							L.icon_state = "top leaves"
							L.hashadow = 0
							L.pixel_y = 2
							L.layer = src.layer + 0.1
							L.appearance_flags = PIXEL_SCALE
							src.vis_contents += L
							var/matrix/m1 = matrix()
							m1.Turn(2)
							m1.Translate(2,2)

							var/matrix/m2 = matrix()
							m2.Turn(2)
							m2.Translate(-2,-2)

							animate(L,transform = m1, time = 20, loop = -1)
							animate(transform = m2, time = 20)
				*/
			namek_tree
				icon='NewNamekianTrees.dmi'
				icon_state="Tree1"
				density_factor = 1
				pixel_x = -32
				bolted = 1
				bounds = "-14,10 to 47,35"
				hashadow = 0
				weight = 2
				tree=1
				hp=10


			namek_tree2
				icon='NewNamekianTrees.dmi'
				icon_state="Tree2"
				density_factor = 1
				pixel_x = -32
				bolted = 1
				bounds = "-14,10 to 47,35"
				hashadow = 0
				weight = 2
				tree=1
				hp=10
			namek_tree2
				icon='NewNamekianTrees.dmi'
				icon_state="Tree3"
				density_factor = 1
				pixel_x = -32
				bolted = 1
				bounds = "-14,10 to 47,35"
				hashadow = 0
				weight = 2
				tree=1
				hp=10
			oak_black
				icon='TreeWorld1.dmi'
				icon_state="T8"
				density_factor = 1
				pixel_x = -32
				bolted = 1
				bounds = "-14,10 to 47,35"
				hashadow = 0
				weight = 2
				tree=1
				hp=1
			oak_white
				icon='TreeWorld1.dmi'
				icon_state="T5"
				density_factor = 1
				pixel_x = -32
				bolted = 1
				bounds = "-14,10 to 47,35"
				hashadow = 0
				weight = 2
				tree=1
				hp=1
			tree_yellow
				icon='TreeWorld1.dmi'
				icon_state="T3"
				density_factor = 1
				pixel_x = -32
				bolted = 1
				bounds = "-14,10 to 47,35"
				hashadow = 0
				weight = 2
				tree=1
				hp=10
			tree_green
				icon='TreeWorld1.dmi'
				icon_state="T1"
				density_factor = 1
				pixel_x = -32
				bolted = 1
				bounds = "-14,10 to 47,35"
				hashadow = 0
				weight = 2
				tree=1
				hp=10
			tree_red
				icon='TreeWorld1.dmi'
				icon_state="T11"
				density_factor = 1
				pixel_x = -32
				bolted = 1
				bounds = "-14,10 to 47,35"
				hashadow = 0
				weight = 2
				tree=1
				hp=10



			tree_oak_dead
				icon = 'tree_oak.dmi'
				icon_state = "tree bare"
				density_factor = 1
				pixel_x = -32
				bolted = 1
				bounds = "-14,10 to 47,35"
				hashadow = 0
				weight = 2
				tree=1
				hp=1
			tree_chestnut
				icon = 'trees_smaller.dmi'
				icon_state = "chestnut"
				density_factor = 1
				pixel_x = -32
				bolted = 1
				bounds = "-14,10 to 47,35"
				hashadow = 0
				weight = 2
				tree=1
				hp=10
			tree_maple
				icon = 'trees_smaller.dmi'
				icon_state = "maple"
				density_factor = 1
				pixel_x = -32
				bolted = 1
				bounds = "-14,10 to 47,35"
				hashadow = 0
				weight = 2
				tree=1
				hp=100
			tree_birch
				icon = 'trees_smaller.dmi'
				icon_state = "birch"
				density_factor = 1
				pixel_x = -32
				bolted = 1
				bounds = "-14,10 to 47,35"
				hashadow = 0
				weight = 2
				tree=1
				hp=1

			tree_white
				icon = 'tree_white.dmi'
				density_factor = 1
				pixel_x = -32
				bolted = 1
				bounds = "-14,10 to 47,35"
				hashadow = 0
				weight = 2
				tree=1
				hp=10

			tree_white2
				icon='TreeWorld1.dmi'
				icon_state="T13"
				density_factor = 1
				pixel_x = -32
				bolted = 1
				bounds = "-14,10 to 47,35"
				hashadow = 0
				weight = 2
				tree=1
				hp=10

			tree_crystal
				icon = 'tree_oak.dmi'
				icon_state = "tree crystal"
				density_factor = 1
				pixel_x = -32
				bolted = 1
				bounds = "-14,10 to 47,35"
				hashadow = 0
				weight = 2
				tree=1
				hp=10
				New()
					..()
					src.filters += filter(type="drop_shadow", x=0, y=0, size=1, offset=1, color=rgb(155,255,255))
					src.filters += filter(type="bloom", threshold=rgb(0,0,0), size = 6,offset=1,alpha = 175)
				/*
				New()
					..()
					var/obj/s = new
					s.icon = 'tree_oak.dmi'
					s.icon_state = "shadow"
					var/icon/I = new(src.icon)
					I.icon -= rgb(255,255,255)
					//I.Flip(NORTH)
					s.icon = I
					s.alpha = 100
					s.pixel_y = -36
					src.underlays += s
				*/
			tall_grass
				icon = 'tall_grass.dmi'
				icon_state = "1"
				//pixel_x = -16;
				bolted = 1;
				hashadow = 0
				shudders = 1;
				New()
					..()
					icon_state = "[rand(1,4)]"
		misc
			item_container
				icon = 'misc.dmi'
				icon_state = "players items"
				hp = 9999999
				can_pocket = 1
				can_activate = 0
				hashadow = 0
				Click()
					..()
					if(src in range(2,usr))
						for(var/obj/items/I in src)
							I.loc = src.loc
							usr.pickup(I,2)
						src.destroy()
			body
				icon = 'NewMalesWhite.dmi'
				icon_state = "KO"
				hashadow = 0
				var/spoiled = 0
				var/buried = 0
				var/turf/buried_turf = null
				New()
					..()
					spawn(72000)
						if(src)
							src.spoiled = 1
							for(var/mob/m in view(10,src))
								m<<output("[src]'s body has decayed.","actionoutput")
							src.owner<<output("Your living body has decayed.","actionoutput")
							src.owner=null
							src.destroy()
				Click(location,control,params)
					..()
					usr.mouse_down = null
					params = params2list(params)
					if(params["right"])

						if(get_dist(usr,src) > 1)
							usr << "You are too far away."
							return

						if(src.buried)
							usr << "The body is already buried."
							return

						src.buried = 1
						src.buried_turf = src.loc

						src.invisibility = 101
						src.density = 0

						view(10,usr) << output("[usr] buries [src].","actionoutput")
						return
					if(params["left"])
						//Player uses defib to revive
						if(usr.left_click_function == "revive defibrillator")
							if(get_dist(usr,src) <= 2)
								if(usr.left_click_ref)
									var/obj/d = usr.left_click_ref
									if(d in usr.accessing)
										if(src.spoiled)
											usr.set_alert("Body lifeless",d.icon,d.icon_state)
											usr << output("Defibrillation failed, body has been dead too long.","actionoutput")
											return
										usr.left_click_function = null
										usr.left_click_ref = null
										var/found_body_owner = 0
										for(var/mob/m in world)
											if(m.client && m.real_name == src.owner)
												m.loc = src.loc
												m.step_x = src.step_x
												m.step_y = src.step_y
												m.Body()
												m.Revive()
												m.energy = 1
												m.KO()
												d.use_obj(usr)
												found_body_owner = 1
												spawn()
													if(src) src.destroy()
												return
										if(found_body_owner == 0)
											usr.set_alert("Defibrillation failed",d.icon,d.icon_state)
											usr << output("Defibrillation failed, wasn't able to locate the soul of the corpse and rejoin it with their body.","actionoutput")
			yuk_tree_heart
				icon = 'tree_heart.dmi'
				icon_state = "heart"
				bolted = 2
				shudders = 1
				pixel_x = -32
				//step_x = 2
				bounds = "-7,1 to 40,24"
				immune_dmg = 1
				hp = 9999999
				can_activate = 1
				/*
				Yukopians can click the heart that opens a menu that displays its stats.
				Button for linking up with heart as a yukopian
				Displays heart hp, energy, divine energy, general status/condition. How many plants/grass tiles maybe? And also how much power heart has.
				Send/Take energy button
				Send/Take divine energy button
				Send/Take hp button
				Taking too much of any stat makes the heart slowly wither until it dies and becomes black
				Once it becomes black, it pumps out dark matter instead
				Giving energy/divine/hp helps the tree grow more plants, become stronger and thus give Yukopians linked to it more power as a whole

				Stage 1 - Link to Yukopian "hive mind"
				Stage 2 - Linking ritual to tree

				*/
				New()
					spawn(10)
						if(src)
							src.layer = 10

							var/obj/o = new
							o.plane = 4
							o.icon = src.icon
							o.icon_state = "overlay"
							o.appearance_flags = 0
							o.filters += filter(type="drop_shadow", x=0, y=0, size=1, offset=1, color=rgb(155,255,255))
							src.vis_contents += o

							var/obj/rays = new
							rays.icon = 'fx_ray_large.dmi'
							rays.pixel_x = -286
							rays.pixel_y = -256
							rays.loc = src.loc
							rays.step_x = src.step_x
							rays.step_y = src.step_y
							rays.bolted = 2
							rays.layer = src.layer-0.2
							rays.filters += filter(type="rays",x=0,y=0,size=300,color=rgb(255,255,255),offset=0,density=15,threshold=0.5,factor=0,flags=FILTER_OVERLAY)
							animate(rays.filters[1],offset = 100,time = 1000, loop = -1)
							animate(offset = 0,time = 0)

							var/obj/i = new
							i.icon = src.icon
							i.icon_state = "heart"
							i.loc = src.loc
							i.step_x = src.step_x
							i.step_y = src.step_y
							i.pixel_x = src.pixel_x
							i.pixel_y = src.pixel_y
							i.layer = src.layer+1;
							i.alpha = 155
							animate(i, transform = matrix()*1.4,alpha = 0, time = 20, loop = -1)
							animate(transform = matrix()*1,alpha = 155,time = 0)

							var/p = 33
							while(p)
								if(prob(25))
									sleep(1)
								p -= 1;
								var/obj/pix = new
								pix.icon = 'fx.dmi'
								pix.icon_state = "pixel"
								pix.loc = locate(src.x,src.y,src.z)
								pix.step_x = src.step_x-4
								pix.step_y = src.step_y+20
								pix.pixel_x = rand(-200,200)
								pix.pixel_y = rand(-200,200)
								pix.bolted = 2
								animate(pix,pixel_x = 0, pixel_y = 0, time = rand(5,10), alpha = 0,loop = -1)
								animate(pixel_x = rand(-200,200), pixel_y = rand(-200,200), time = 0, alpha = 255)
								sleep(0.1)
								//s.pixs += pix

							var/obj/effects/shockwave_medium/b = new
							b.loc = src.loc
							b.step_x = src.step_x
							b.step_y = src.step_y
							b.pixel_x = -82
							b.pixel_y = -44
							b.transform *= 0.1
							animate(b, transform = matrix()*1, alpha = 0, time = 3, loop = -1)
							animate(layer = b.layer, time = 7)
							animate(transform = matrix()*0.1,alpha = 255,time = 0)
							while(src)
								/*
								var/obj/effects/shockwave_medium/b = new
								b.loc = src.loc
								b.step_x = src.step_x
								b.step_y = src.step_y
								b.pixel_x = -82
								b.pixel_y = -44
								b.transform *= 0.1
								animate(b, transform = matrix()*1, alpha = 0, time = 3)
								spawn(10)
									if(b) b.destroy()
									*/
								for(var/mob/m in view(4,src))
									m.gain_stat("divine",1,0.2,"World Tree Heart",1)
									//m.divine_energy_max += 0.003*m.divine_energy_mod
									m.divine_energy += 0.007*m.divine_energy_mod
									if(m.ambients == null) m.ambients = list()
									/*
									if(m.ambients.Find("yuk tree heart beat") == 0)
										m << sound('heart2.mp3',1,0,9,100)
										m.ambients += "yuk tree heart beat"
									*/
								sleep(10)
			beehive
				name = "Beehive"
				icon = 'consumables.dmi'
				icon_state = "beehive"
				density_factor = 1
				//bounds = "10,9 to 22,25"
				hashadow = 1
				weight = 1
				bolted = 1;
				can_activate = 1;
				pixel_y = -8;
				base_type = "Speed"
				Click(location,control,params)
					..()
					usr.mouse_down = null
					params = params2list(params)
					if(params["left"])
						if(src in range(1,usr))
							//Make the hive expand slightly twice, like it's about to burst, then make it explode into honey combs.
							//Make an NPC bee-swarm spawn and attack the player.
							animate(src,transform = matrix()*1.05,time = 2)
							animate(transform = matrix()*1,time = 2)
							animate(transform = matrix()*1.1,time = 2)
							animate(transform = matrix()*1,time = 2)
							animate(transform = matrix()*1.2,time = 2)
							sleep(10)
							src.alpha = 0;
							src.shadow.alpha = 0;
							if(src)
								var/h = 2
								var/pos = list(src.x-1,src.x+1)
								while(h)
									var/obj/items/consumables/manuka_honey/hon = new
									var/n = pos[h]
									hon.loc = locate(n,src.y,src.z)
									var/p_x = 0;
									if(n > src.x) p_x = -16;
									if(n < src.x) p_x = 16;
									hon.pixel_x = p_x;
									animate(hon,pixel_y = 16,pixel_x = p_x/2,time = 2)
									animate(pixel_y = -8,pixel_x = 0,time = 2)
									h -= 1
							sleep(10)
							if(src) src.destroy()
			crashed_space_pod
				name = "Crashed Space Pod"
				icon = 'Artifacts.dmi'
				icon_state = "Crashed Pod"
				density_factor = 1
			//	bounds = "-10,1 to 46,19"
				hashadow = 1
			//	pixel_x = -16;
				weight = 1
				radius = 4
				bolted = 2
				hp=5000
				New()
					..()
					spawn(10)
						if(src)
							src.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(0,150,0))
							animate(src.filters[src.filters.len], offset = 4, time = 10,loop = -1)
							animate(offset = 1, time = 10)
							src.rad_field()
				Del()
					src.explode_rock()
					sleep(3)
					..()
			meteorite
				name = "Meteorite"
				icon = 'Artifacts.dmi'
				icon_state = "Meteorite"
				density_factor = 1
			//	bounds = "-3,1 to 40,19"
				hashadow = 1
			//	pixel_x = -16;
				weight = 1
				radius = 4
				bolted = 2
				hp=5000
				New()
					..()
					spawn(10)
						if(src)
							src.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(0,150,0))
							animate(src.filters[src.filters.len], offset = 4, time = 10,loop = -1)
							animate(offset = 1, time = 10)
							src.rad_field()
				Del()
					src.explode_rock()
					sleep(3)
					..()
			crashed_satellite
				name = "Crashed Satellite"
				icon = 'Artifacts.dmi'
				icon_state = "Crashed Satellite"
				density_factor = 1
				//bounds = "3,1 to 29,15"
			//	pixel_x = -16
				hashadow = 1
				weight = 1
				radius = 4
				bolted = 2
				hp=5000
				New()
					..()
					spawn(10)
						if(src)
							src.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(0,150,0))
							animate(src.filters[src.filters.len], offset = 4, time = 10,loop = -1)
							animate(offset = 1, time = 10)
							src.rad_field()
				Del()
					src.explode_rock()
					sleep(3)
					..()
			crashed_storage
				name = "Crashed Storage"
				icon = 'Artifacts 32x32.dmi'
				icon_state = "Crashed Storage"
				density_factor = 1
			//	bounds = "3,1 to 29,15"
			//	pixel_x = -16
				hashadow = 1
				weight = 1
				radius = 4
				bolted = 2
				hp=5000
				New()
					..()
					spawn(10)
						if(src)
							src.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(0,150,0))
							animate(src.filters[src.filters.len], offset = 4, time = 10,loop = -1)
							animate(offset = 1, time = 10)
							src.rad_field()
				Del()
					src.explode_rock()
					sleep(3)
					..()
			sword_in_stone
				name = "Sword in Stone"
				icon = 'Artifacts 32x32.dmi'
				icon_state = "Sword in stone"
				density_factor = 1
			//	bounds = "3,1 to 29,15"
			//	pixel_x = -16
				hashadow = 1
				weight = 1
				radius = 4
				bolted = 2
				hp=5000
				New()
					..()
					spawn(10)
						if(src)
							src.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(0,150,0))
							animate(src.filters[src.filters.len], offset = 4, time = 10,loop = -1)
							animate(offset = 1, time = 10)
							src.rad_field()
				Del()
					src.explode_rock()
					sleep(3)
					..()
			rad_rock_1
				name = "Rock"
				icon = 'rocks.dmi'
				icon_state = "rad rock 1"
				density_factor = 1
			//	bounds = "-10,1 to 46,19"
				hashadow = 1
				//pixel_x = -16;
				weight = 1
				radius = 4
				bolted = 2
				hp=5000
				New()
					..()
					spawn(10)
						if(src)
							src.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(0,150,0))
							animate(src.filters[src.filters.len], offset = 4, time = 10,loop = -1)
							animate(offset = 1, time = 10)
							src.rad_field()
				Del()
					src.explode_rock()
					sleep(3)
					..()
			rad_rock_2
				name = "Rock"
				icon = 'rocks.dmi'
				icon_state = "rad rock 2"
				density_factor = 1
			//	bounds = "-3,1 to 40,19"
				hashadow = 1
			//	pixel_x = -16;
				weight = 1
				radius = 4
				bolted = 2
				hp=5000
				New()
					..()
					spawn(10)
						if(src)
							src.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(0,150,0))
							animate(src.filters[src.filters.len], offset = 4, time = 10,loop = -1)
							animate(offset = 1, time = 10)
							src.rad_field()
				Del()
					src.explode_rock()
					sleep(3)
					..()
			rad_rock_3
				name = "Rock"
				icon = 'rocks.dmi'
				icon_state = "rad rock 3"
				density_factor = 1
			//	bounds = "3,1 to 29,15"
				//pixel_x = -16
				hashadow = 1
				weight = 1
				radius = 4
				bolted = 2
				hp=5000
				New()
					..()
					spawn(10)
						if(src)
							src.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(0,150,0))
							animate(src.filters[src.filters.len], offset = 4, time = 10,loop = -1)
							animate(offset = 1, time = 10)
							src.rad_field()
				Del()
					src.explode_rock()
					sleep(3)
					..()
			rock_larger
				name = "Rock"
				icon = 'rocks.dmi'
				icon_state = "larger rock 1"
				density_factor = 1
				//bounds = "-3,6 to 34,23"
				hashadow = 1
				//pixel_x = -16
				weight = 1
				hp=99999
				rock=1
				Del()
					src.explode_rock()
					sleep(3)
					..()
			rock_lava
				name = "Rock"
				icon = 'terrain.dmi'
				icon_state = "lava rock 1"
				density_factor = 1
			//	bounds = "1,1 to 32,16"
				hashadow = 1
				weight = 1
				rock=1
				hp=10000
				Del()
					src.explode_rock()
					sleep(3)
					..()
				New()
					..()
					src.icon_state = "lava rock [rand(1,3)]"
			rock_desert
				name = "Rock"
				icon = 'terrain.dmi'
				icon_state = "rock1"
				density_factor = 1
			//	bounds = "1,1 to 32,16"
				hashadow = 1
				weight = 1
				rock=1
				hp=10000
				New()
					..()
					src.icon_state = "rock[rand(1,3)]"
				Click(location,control,params)
					..()
					params = params2list(params)
					if(params["left"])
						if(src in range(1,usr))
							if(src.can_activate)
								flick(pick("punch","kick"),usr)
								src.flash_red()
								src.shake()
								spawn(3)
									if(src && usr)
										if(src.loc)
											var/turf/x = src.loc
											if(x.liquid == null)
												var/obj/effects/craters/crater_small/cs = new
												cs.loc = src.loc
												cs.step_x = src.step_x
												cs.step_y = src.step_y

										src.explosion_small()

										//usr.resources += round(src.resources)
										usr.update_rsc()
									//	usr.rsc_nums("<font color = green>+[src.resources] resources")

										src.resources = 0
										src.destroy()
			/*world_tree_overlay
				icon = 'world_tree.dmi'
				icon_state = "overlay"
				bolted = 2
				hashadow = 0
				plane = 4
				immune_dmg = 1
				layer = 30
				New()
					..()
					src.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(155,255,255))
			world_tree_inside
				icon = 'tree_inside.dmi'
				bolted = 2
				hashadow = 0
				pixel_x = -119
				pixel_y = -32
				layer = 2.1
				immune_dmg = 1
				New()
					spawn(10)
						if(src) src.layer = 2.1
						*/
			divine_cache
				name = "Divine Cache"
				icon = 'containers.dmi'
				icon_state = "psi cache2"
				density_factor = 1
				bounds = "1,1 to 32,16"
				hashadow = 1
				weight = 1
				bolted = 2
				can_activate = 1
				var/obj/orb = null
				var/obj/ray = null
				Click(location,control,params)
					..()
					params = params2list(params)
					if(params["left"])
						if(src in range(1,usr))
							if(src.can_activate)
								flick(pick("punch","kick"),usr)
								src.flash_red()
								src.shake()
								spawn(3)
									if(src && usr && src.resources > 0)
										if(src.loc)
											var/turf/x = src.loc
											if(x.liquid == null)
												var/obj/effects/craters/crater_small/cs = new
												cs.loc = src.loc
												cs.step_x = src.step_x
												cs.step_y = src.step_y

										src.explosion_small()

										if(src.icon_state == "psi cache1")
											usr.dark_matter += src.resources;
											//usr.rsc_nums("<font color = green>+[Commas(src.resources)] dark matter energy")
										//if(src.icon_state == "psi cache2")
											//usr.psionic_power_base += src.resources;
											//usr.rsc_nums("<font color = green>+[Commas(src.resources)] psionic power")
										if(src.icon_state == "psi cache3")
											usr.divine_energy += src.resources*usr.divine_energy_mod;
										//	usr.rsc_nums("<font color = green>+[Commas(src.resources)] divine energy")


										src.resources = 0
										if(src.orb) src.orb.destroy()
										if(src.ray) src.ray.destroy()
										src.destroy()
				New()
					src.icon_state = "psi cache[rand(1,3)]"
					spawn(10)
						if(src && src.loc)
							if(src.icon_state == "psi cache1")
								var/obj/ball = new
								ball.loc = src.loc
								ball.layer = 10
								ball.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(102,0,204))
								ball.filters += filter(type="bloom", threshold=rgb(0,0,0), size = 6,offset=1,alpha = 175)
								ball.step_y = 12
								ball.icon = src.icon
								ball.icon_state = "dark matter ball"
								ball.bolted = 2
								animate(ball,pixel_y = 4, time = 12, loop = -1)
								animate(pixel_y = 0, time = 12)
								src.orb = ball

								var/obj/rays = new
								rays.icon = 'fx_ray_small.dmi'
								rays.pixel_x = -16
								rays.pixel_y = -16
								rays.loc = src.loc
								rays.bolted = 2
								rays.step_y = 12
								rays.layer = 9
								rays.filters += filter(type="rays",x=0,y=0,size=56,color=rgb(25,25,25),offset=0,density=10,threshold=0.5,factor=0,flags=FILTER_OVERLAY)
								animate(rays.filters[1],offset = 100,time = 1500, loop = -1)
								animate(offset = 0,time = 0)
								animate(rays.filters[1],y = 4,time = 12, loop = -1, flags = ANIMATION_PARALLEL)
								animate(y = 0, time = 12)
								src.ray = rays
							if(src.icon_state == "psi cache2")
								var/obj/ball = new
								ball.loc = src.loc
								ball.layer = 10
								ball.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(102,0,204))
								ball.filters += filter(type="bloom", threshold=rgb(0,0,0), size = 6,offset=1,alpha = 175)
								ball.step_y = 12
								ball.icon = src.icon
								ball.icon_state = "psi ball"
								ball.bolted = 2
								animate(ball,pixel_y = 4, time = 12, loop = -1)
								animate(pixel_y = 0, time = 12)
								src.orb = ball

								var/obj/rays = new
								rays.icon = 'fx_ray_small.dmi'
								rays.pixel_x = -16
								rays.pixel_y = -16
								rays.loc = src.loc
								rays.bolted = 2
								rays.step_y = 12
								rays.layer = 9
								rays.filters += filter(type="rays",x=0,y=0,size=64,color=rgb(255,255,255),offset=0,density=10,threshold=0.5,factor=0,flags=FILTER_OVERLAY)
								animate(rays.filters[1],offset = 100,time = 1500, loop = -1)
								animate(offset = 0,time = 0)
								animate(rays.filters[1],y = 4,time = 12, loop = -1, flags = ANIMATION_PARALLEL)
								animate(y = 0, time = 12)
								src.ray = rays
							if(src.icon_state == "psi cache3")
								var/obj/ball = new
								ball.loc = src.loc
								ball.layer = 10
								ball.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(255,255,170))
								ball.filters += filter(type="bloom", threshold=rgb(0,0,0), size = 6,offset=1,alpha = 175)
								ball.step_y = 12
								ball.icon = src.icon
								ball.icon_state = "divine energy ball"
								ball.bolted = 2
								animate(ball,pixel_y = 4, time = 12, loop = -1)
								animate(pixel_y = 0, time = 12)
								src.orb = ball

								var/obj/rays = new
								rays.icon = 'fx_ray_small.dmi'
								rays.pixel_x = -16
								rays.pixel_y = -16
								rays.loc = src.loc
								rays.bolted = 2
								rays.step_y = 12
								rays.layer = 9
								rays.filters += filter(type="rays",x=0,y=0,size=64,color=rgb(255,255,170),offset=0,density=10,threshold=0.5,factor=0,flags=FILTER_OVERLAY)
								animate(rays.filters[1],offset = 100,time = 1500, loop = -1)
								animate(offset = 0,time = 0)
								animate(rays.filters[1],y = 4,time = 12, loop = -1, flags = ANIMATION_PARALLEL)
								animate(y = 0, time = 12)
								src.ray = rays

							if(prob(25)) src.resources = 10
							else if(prob(25)) src.resources = 25
							else if(prob(25)) src.resources = 100
							else if(prob(25)) src.resources = 250
							else if(prob(10)) src.resources = 500
							if(src.resources == 10) o_color="#ffffff"
							else if(src.resources == 25) o_color="#1eff00"
							else if(src.resources == 100) o_color="#0070dd"
							else if(src.resources == 250) o_color="#a335ee"
							else if(src.resources == 500) o_color="#ff8000"
					..()
			platinum_chest
				name = "Treasure Chest"
				icon = 'Treasure Chests.dmi'
				icon_state = "platinum"
				density_factor = 1
				bounds = "1,1 to 32,16"
				hashadow = 1
				weight = 1
				can_pocket = 1
				stacks = -1
				hp = 99999999999
				var/preset = 0
				desc = "An abandoned treasure chest possibly burried some years ago."
				act = /obj/items/misc/platinum_chest/proc/use
				act_drop = /obj/items/misc/platinum_chest/proc/drop
				Click(location,control,params)
					..()
					//Removes this item from the global Items list.
					if(items)
						if(src in items) items -= src
					params = params2list(params)
					if(params["left"])
						if(isturf(src.loc))
							usr.pickup(src)
							if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up a [src]","actionoutput")
						else if(ismob(src.loc))
							if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
							usr.item_selected = src
							src.overlays -= /obj/effects/select_item
							src.overlays += /obj/effects/select_item
				proc
					use(var/mob/m,var/obj/items/misc/platinum_chest/i)
						if(i in m)
							//m.resources += round(i.resources)
						//	m.update_rsc()
							m.open_chest(i.resources,"Platinum")
							i.use_obj(m)
							m.refresh_inv()
					drop(var/mob/m,var/obj/items/i)
						m.drop(i)
						i.overlays -= /obj/effects/select_item
				New()
					..()
					spawn(0.1)
						if(prob(25)) src.resources = 50000
						else if(prob(25)) src.resources = 52500
						else if(prob(25)) src.resources = 55000
						else src.resources = 50000
						rarity = 4

						src.desc_extra = "When Used:\n\n<font color = green>+ a bundle of minerals</font>\n\n"

			mystery_box
				name = "Mystery Box"
				icon = 'Treasure Chests.dmi'
				icon_state = "gold"
				density_factor = 1
				bounds = "1,1 to 32,16"
				hashadow = 1
				weight = 1
				can_pocket = 1
				stacks = -1
				rarity=4
				hp = 9999999999999
				var/preset = 0
				desc = "A questionable box of mysteries."
				act = /obj/items/misc/mystery_box/proc/use
				act_drop = /obj/items/misc/mystery_box/proc/drop
				Click(location,control,params)
					..()
					//Removes this item from the global Items list.
					if(items)
						if(src in items) items -= src
					params = params2list(params)
					if(params["left"])
						if(isturf(src.loc))
							usr.pickup(src)
						else if(ismob(src.loc))
							if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
							usr.item_selected = src
							src.overlays -= /obj/effects/select_item
							src.overlays += /obj/effects/select_item
				proc
					use(var/mob/m,var/obj/items/misc/mystery_box/i)
						if(!(i in m)) return

						var/year = global.year

						// ========================================
						// RNG TABLE
						// ========================================

						var/roll = rand(1,1000)

						// 1% Ultra Rare
						if(roll <= 10)
							SpawnTechItem(m, year, 1)

						// 9% Special (Spirit Stone / Special Food)
						else if(roll <= 100)
							SpawnSpecialItem(m)

						// 25% Tech Item
						else if(roll <= 350)
							SpawnTechItem(m, year, 0)

						// 30% Consumable Food
					//	else if(roll <= 650)
						//	SpawnFoodItem(m)

						// 15% Mineral
						else if(roll <= 750)
							SpawnMineral(m)

						// 20% Zenni
						else
							SpawnZenni(m, year)

						i.use_obj(m)
						m.refresh_inv()

					drop(var/mob/m,var/obj/items/i)
						m.drop(i)
						i.overlays -= /obj/effects/select_item
				New()
					spawn(0.1)
						if(isturf(src.loc))
							if(prob(25)) src.resources = 20000
							else if(prob(25)) src.resources = 22500
							else if(prob(25)) src.resources = 25000
							else src.resources = 20000
							rarity = 4

							src.desc_extra = "When Used:\n\n<font color = green>+ receive a mystery asset!</font>\n\n"
						..()
			gold_chest
				name = "Treasure Chest"
				icon = 'Treasure Chests.dmi'
				icon_state = "gold"
				density_factor = 1
				bounds = "1,1 to 32,16"
				hashadow = 1
				weight = 1
				can_pocket = 1
				stacks = -1
				hp = 99999999999
				var/preset = 0
				desc = "An abandoned treasure chest possibly burried some years ago."
				act = /obj/items/misc/gold_chest/proc/use
				act_drop = /obj/items/misc/gold_chest/proc/drop
				Click(location,control,params)
					..()
					//Removes this item from the global Items list.
					if(items)
						if(src in items) items -= src
					params = params2list(params)
					if(params["left"])
						if(isturf(src.loc))
							usr.pickup(src)
							if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up a [src]","actionoutput")
						else if(ismob(src.loc))
							if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
							usr.item_selected = src
							src.overlays -= /obj/effects/select_item
							src.overlays += /obj/effects/select_item
				proc
					use(var/mob/m,var/obj/items/misc/gold_chest/i)
						if(i in m)
							//m.resources += round(i.resources)
						//	m.update_rsc()
							m.open_chest(i.resources,"Gold")
							i.use_obj(m)
							m.refresh_inv()
					drop(var/mob/m,var/obj/items/i)
						m.drop(i)
						i.overlays -= /obj/effects/select_item
				New()
					spawn(0.1)
						if(isturf(src.loc))
							if(prob(25)) src.resources = 20000
							else if(prob(25)) src.resources = 22500
							else if(prob(25)) src.resources = 25000
							else src.resources = 20000
							rarity = 4

							src.desc_extra = "When Used:\n\n<font color = green>+ a bundle of minerals</font>\n\n"
						..()
			silver_chest
				name = "Treasure Chest"
				icon = 'Treasure Chests.dmi'
				icon_state = "silver"
				density_factor = 1
				bounds = "1,1 to 32,16"
				hashadow = 1
				weight = 1
				can_pocket = 1
				stacks = -1
				hp = 99999999999
				var/preset = 0
				desc = "An abandoned treasure chest possibly burried some years ago."
				act = /obj/items/misc/silver_chest/proc/use
				act_drop = /obj/items/misc/silver_chest/proc/drop
				Click(location,control,params)
					..()
					//Removes this item from the global Items list.
					if(items)
						if(src in items) items -= src
					params = params2list(params)
					if(params["left"])
						if(isturf(src.loc))
							usr.pickup(src)
							if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up a [src]","actionoutput")
						else if(ismob(src.loc))
							if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
							usr.item_selected = src
							src.overlays -= /obj/effects/select_item
							src.overlays += /obj/effects/select_item
				proc
					use(var/mob/m,var/obj/items/misc/silver_chest/i)
						if(i in m)

							//m.resources += round(i.resources)
						//	m.update_rsc()
							m.open_chest(i.resources,"Silver")
							i.use_obj(m)
							m.refresh_inv()
					drop(var/mob/m,var/obj/items/i)
						m.drop(i)
						i.overlays -= /obj/effects/select_item
				New()
					spawn(0.1)
						if(isturf(src.loc))
							if(prob(25)) src.resources = 9000
							else if(prob(25)) src.resources = 10500
							else if(prob(25)) src.resources = 11000
							else src.resources = 8800
							rarity = 2

							src.desc_extra = "When Used:\n\n<font color = green>+ a bundle of minerals</font>\n\n"
						..()
			bronze_chest
				name = "Treasure Chest"
				icon = 'Treasure Chests.dmi'
				icon_state = "bronze"
				density_factor = 1
				bounds = "1,1 to 32,16"
				hashadow = 1
				weight = 1
				can_pocket = 1
				stacks = -1
				hp = 99999999999
				var/preset = 0
				desc = "An abandoned treasure chest possibly burried some years ago."
				act = /obj/items/misc/bronze_chest/proc/use
				act_drop = /obj/items/misc/bronze_chest/proc/drop
				Click(location,control,params)
					..()
					//Removes this item from the global Items list.
					if(items)
						if(src in items) items -= src
					params = params2list(params)
					if(params["left"])
						if(isturf(src.loc))
							usr.pickup(src)
							if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up a [src]","actionoutput")
						else if(ismob(src.loc))
							if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
							usr.item_selected = src
							src.overlays -= /obj/effects/select_item
							src.overlays += /obj/effects/select_item
				proc
					use(var/mob/m,var/obj/items/misc/bronze_chest/i)
						if(i in m)

							//m.resources += round(i.resources)
						//	m.update_rsc()
							m.open_chest(i.resources,"Bronze")
							i.use_obj(m)
							m.refresh_inv()
					drop(var/mob/m,var/obj/items/i)
						m.drop(i)
						i.overlays -= /obj/effects/select_item
				New()
					spawn(0.1)
						if(isturf(src.loc))
							if(prob(25)) src.resources = 2500
							else if(prob(25)) src.resources = 3000
							else if(prob(25)) src.resources = 3500
							else src.resources = 2000
							rarity = 1

							src.desc_extra = "When Used:\n\n<font color = green>+ a bundle of minerals</font>\n\n"
						..()
			resource_cache
				name = "Resource Cache"
				icon = 'containers.dmi'
				icon_state = "resource cache2"
				density_factor = 1
				bounds = "1,1 to 32,16"
				hashadow = 1
				weight = 1
				can_pocket = 1
				stacks = -1
				hp = 9999999
				var/preset = 0
				desc = "Long lost ancient cache of resources left over from a bygone era."
				act = /obj/items/misc/resource_cache/proc/use
				act_drop = /obj/items/misc/resource_cache/proc/drop
				Click(location,control,params)
					..()
					//Removes this item from the global Items list.
					if(items)
						if(src in items) items -= src
					params = params2list(params)
					if(params["left"])
						if(isturf(src.loc))
							usr.pickup(src)
							if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up a [src]","actionoutput")
						else if(ismob(src.loc))
							if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
							usr.item_selected = src
							src.overlays -= /obj/effects/select_item
							src.overlays += /obj/effects/select_item
				proc
					use(var/mob/m,var/obj/items/misc/resource_cache/i)
						if(i in m)
							m.resources += round(i.resources)
							m.update_rsc()
							i.use_obj(m)
							m.refresh_inv()
					drop(var/mob/m,var/obj/items/i)
						i.overlays -= /obj/effects/select_item
						m.drop(i)
				New()
					spawn(0.1)
						if(isturf(src.loc))
							if(src.preset == 0) src.icon_state = "resource cache[rand(1,4)]"
							if(prob(25)) src.resources = 1000
							else if(prob(25)) src.resources = 10000
							else if(prob(25)) src.resources = 1000000
							else if(prob(10)) src.resources = 25000000
							else if(prob(5)) src.resources = 50000000
							if(src.resources == 1000)
								//o_color="#ffffff"
								src.rarity = 1
							else if(src.resources == 10000)
								//o_color="#1eff00"
								src.rarity = 2
							else if(src.resources == 1000000)
								//o_color="#0070dd"
								src.rarity = 3
							else if(src.resources == 25000000)
								//o_color="#a335ee"
								src.rarity = 4
							else if(src.resources == 50000000)
								//o_color="#ff8000"
								src.rarity = 5
							src.desc_extra = "When Used:\n\n<font color = green>+ [Commas(src.resources)] Zenni</font>\n\n"
						..()
			water_pot
				name = "Endlessly Refilling Water Pot"
				icon = 'consumables.dmi'
				icon_state = "pot water"
				density_factor = 1
				bounds = "9,7 to 25,16"
				//hashadow = 1
				weight = 1
				can_activate = 1
				var/infused = 0
				var/full = 1
				var/refill_timer = 6000
				/*Click(location,control,params)
					..()
					params = params2list(params)
					if(params["left"])
						if(src in range(1,usr))
							if(src.can_activate)
								if(src.full)
									if(usr.thirst > 100)
										usr.set_alert("Already quenched",'alert.dmi',"alert")
										return
									else
										usr.thirst += rand(69,79)
										src.icon_state = "pot"
										src.full = 0

									if(src.bolted > 0) src.refill_timer = 3000
									spawn(src.refill_timer)
										if(src)
											src.full = 1
											src.icon_state = "pot water"*/
			/*bonepile
				name = "Bonepile"
				icon = 'consumables.dmi'
				icon_state = "bonepile1"
				density_factor = 1
				bounds = "1,1 to 32,16"
				hashadow = 1
				weight = 1
				can_activate = 1
				var/infused = 0
				var/list/ang
				base_type = "Resistance"
				New()
					..()
					src.icon_state = "bonepile[rand(1,6)]"
					if(prob(10))
						src.infused = 1
						src.filters += filter(type="outline",size=1, color=rgb(204,236,255))
						src.filters += filter(type="drop_shadow", x=0, y=0, size=1, offset=1, color=rgb(102,0,204))

						animate(src.filters[2], size = 2,offset = 2, time = 15, loop = -1)
						animate(size = 0,offset = 0, time = 15, loop = -1)

						src.vis_contents += new/obj/effects/dark_matter_energy

					src.ang = list(0,90,180,270,45,135,225,315)
					var/parts = 0
					if(prob(20))
						parts += 1
						if(prob(20))
							parts += 1
					while(parts)
						parts -= 1
						var/obj/items/consumables/fossilized_part/p = new
						p.loc = src
				Click(location,control,params)
					..()
					params = params2list(params)
					if(params["left"])
						if(src in range(1,usr))
							if(src.can_activate)
								if(src.shadow)
									src.shadow.loc = null
									src.shadow = null
								flick(pick("punch","kick"),usr)
								src.flash_red()
								src.shake()
								spawn(3)
									if(src && usr)
										if(src.loc)
											var/bones = rand(2,4)
											while(bones)
												bones -= 1
												var/obj/items/consumables/ancient_bone/b = new
												b.loc = src.loc
												animate(b,transform = turn(matrix(), 120), time = 2)
												animate(transform = turn(matrix(), 240), time = 2)
												animate(b,pixel_x = rand(-48,48),pixel_y = rand(32,64),transform = turn(matrix(), 360), time = 2,flags = ANIMATION_PARALLEL)
												animate(pixel_y = rand(-8,8), time = 2)

												if(src.infused)
													b.rarity = 3
													b.desc_extra = "When Eaten:\n\n<font color = green>+ 1 level in Endurance</font>\n\n<font color = green>+ 1 Lifespan</font>\n\n<font color = green>+ 1 Dark Matter</font>\n\n"
													b.name = "Thousand Year Bone"
													b.infused = 1
													b.tech_lvl = 2
													b.lifespan_gain = 1
													b.dark_matter_gain = 1
													b.filters += filter(type="outline",size=1, color=rgb(204,236,255))
													b.filters += filter(type="drop_shadow", x=0, y=0, size=1, offset=1, color=rgb(102,0,204))
													animate(b.filters[2], size = 1,offset = 1, time = 15, loop = -1,flags = ANIMATION_PARALLEL)
													animate(size = 0,offset = 0, time = 15, loop = -1)

											for(var/obj/items/consumables/fossilized_part/p in src)
												p.loc = src.loc
												p.slide(src)
												if(p.shadow)
													world.log << "DEBUG - [p] has a shadow -_-"

											src.destroy()
											animate(src)
											src.filters = null
											src.particles = null

											*/
			icerock1
				name = "Ice Rock"
				icon='Iceberg1.dmi'
				icon_state=""
				density_factor = 1
				//bounds = "1,1 to 32,16"
				hashadow = 1
				weight = 1
				rock=1
				hp = 550000
				Click(location,control,params)
					..()
					params = params2list(params)
					if(params["left"])
						if(src in range(1,usr))
							if(src.can_activate)
								flick(pick("LPunch","RPunch"),usr)
								src.flash_red()
								src.shake()
								spawn(3)
									if(src && usr)
										if(src.loc)
											var/turf/x = src.loc
											if(x.liquid == null)
												var/obj/effects/craters/crater_small/cs = new
												cs.loc = src.loc
												cs.step_x = src.step_x
												cs.step_y = src.step_y

										src.explosion_small()
										src.destroy()
			icerock2
				name = "Ice Rock"
				icon='Iceberg2.dmi'
				icon_state=""
				hp = 550000
				rock=1
				Click(location,control,params)
					..()
					params = params2list(params)
					if(params["left"])
						if(src in range(1,usr))
							if(src.can_activate)
								flick(pick("punch","kick"),usr)
								src.flash_red()
								src.shake()
								spawn(3)
									if(src && usr)
										if(src.loc)
											var/turf/x = src.loc
											if(x.liquid == null)
												var/obj/effects/craters/crater_small/cs = new
												cs.loc = src.loc
												cs.step_x = src.step_x
												cs.step_y = src.step_y

										src.explosion_small()
										src.destroy()
			rock
				name = "Rock"
				icon = 'terrain.dmi'
				icon_state = "solid rock1"
				density_factor = 1
				//bounds = "1,1 to 32,16"
				hashadow = 1
				weight = 1
				rock=1
				hp = 550000
				Click(location,control,params)
					..()
					params = params2list(params)
					if(params["left"])
						if(src in range(1,usr))
							if(src.can_activate)
								flick(pick("punch","kick"),usr)
								src.flash_red()
								src.shake()
								spawn(3)
									if(src && usr)
										if(src.loc)
											var/turf/x = src.loc
											if(x.liquid == null)
												var/obj/effects/craters/crater_small/cs = new
												cs.loc = src.loc
												cs.step_x = src.step_x
												cs.step_y = src.step_y

										src.explosion_small()


										src.destroy()
				New()
					..()
					src.icon_state = "solid rock[rand(1,3)]"
					/*
					if(prob(33))
						src.icon_state = "resource rock[rand(1,3)]"
						src.mouse_over_pointer = MOUSE_ACTIVE_POINTER
						src.can_activate = 1
					*/
					/*
					if(prob(10))
						var/obj/x = new
						x.icon = src.icon
						x.layer = src.layer+1
						x.icon_state = pick("resource1","resource2")
						src.overlays += x
					*/
					//src.layer = src.lay - src.y
				/*
				Click()
					if(src in range(1,usr))
						src.loc = usr.loc
						src.layer = src.layer+100
						usr.icon_state = "hold"
						animate(src, pixel_z = 19,pixel_x = 15, time = 2)
						sleep(10)
						usr.icon_state = "hold"
						var/n = 5
						while(n)
							sleep(5)
							animate(src, pixel_z = 25, time = 1)
							usr.icon_state = "lift"
							sleep(5)
							animate(src, pixel_z = 19, time = 1)
							sleep(1)
							usr.icon_state = "hold"
							n-=1
						animate(src, pixel_z = 0, time = 2,easing = BOUNCE_EASING)
						src.layer = src.layer-100
						usr.icon_state = "hold"
						sleep(5)
						usr.icon_state = usr.state()
				*/
		/*
		resources
			icon = 'misc.dmi'
			icon_state = "uncommon resources2"
			name = "0 Resources"
			density_factor = 0
			bounds = "7,11 to 27,18"
			can_pocket = 1
			stacks = -1
			stack_exempt = 1
			mouse_over_pointer = MOUSE_ACTIVE_POINTER
			//act = /obj/items/resources/proc/use
			act_drop = /obj/items/resources/proc/drop
			proc
				drop(var/mob/m,var/obj/items/i)
					if(i in m.accessing)
						if(m.numbers_accessing == null)
							//winset(m,"numbers.label_numbers","text=\"How many resources? Press enter to confirm.\"")
							//winset(m,"numbers","pos=960,400")
							//winshow(m,"numbers",1)
							m.numbers_accessing = m
							//winset(m,"numbers.input_number","focus=true")
							m.hud_confirm_nums.confirm_text(1,"How many resources? Press enter to confirm.",m)
			Click()
				..()
				if(ismob(src.loc))
					if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
					usr.item_selected = src
					src.overlays -= /obj/effects/select_item
					src.overlays += /obj/effects/select_item
				else if(isturf(src.loc))
					usr.mouse_down = null
					if(src in range(2,usr))
						for(var/obj/items/resources/r in usr)
							r.value += round(src.value)
							r.name = "[Commas(r.value)] Resources"
						src.destroy()
			*/
			/*
			Click()
				if(isturf(src.loc))
					usr.mouse_down = null
					if(src in range(2,usr))
						//for(var/obj/items/resources/x in range(2,src))
						for(var/obj/items/resources/r in usr)
							r.value += round(src.value)
							r.name = "[Commas(r.value)] Resources"
							//if(x != src) del(x)
						src.destroy()
				else if(src in usr.accessing)
					usr.hud_inv.item_desc.maptext = "[css_outline]<font size = 1><text align=center valign=top>[src.name]<text align=left valign=top>\n\nRarity: [global.rarity_color[src.rarity]]\n\n[src.desc_extra][src.desc]"


						//del(src)
				else if(usr.accessing in range(1,usr))
					if(src in usr.accessing) if(usr.numbers_accessing == null)
						var/mob/m = usr.accessing
						winset(usr,"numbers.label_numbers","text=\"How many resources? Press enter to confirm.\"")
						winset(usr,"numbers","pos=960,400")
						winshow(usr,"numbers",1)
						usr.numbers_accessing = m
						winset(usr,"numbers.input_number","focus=true")
				*/
		clothing
			change_icon = 0
			floor_state = "floor"
			density_factor = 0
			hashadow = 0
			can_pocket = 1;
			stacks = -1
			immune_dmg = 1
			desc = "Wear me!"
			act = /obj/items/clothing/proc/use
			act_drop = /obj/items/clothing/proc/drop
			appearance_flags = KEEP_TOGETHER
			proc
				use(var/mob/m,var/obj/items/tech/i)
					if(i in m.accessing)
						var/mob/x = m.accessing
						if(!i.suffix)
							m.vis_contents -= i.icon
							i.suffix = "worn"
							i.name += "(Equipped)"
							i.icon_state = ""
							//i.layer = 13
							x.redraw_appearance()
							m.vis_contents += i.icon
							return
						else
							i.suffix = null
							i.name = initial(i.name)
							i.layer = initial(i.layer)
							x.redraw_appearance()
							m.vis_contents -= i.icon
							return
				drop(var/mob/m,var/obj/items/clothing/i)
					if(i in m.accessing)
						var/mob/x = m.accessing
						if(i.suffix)
							m.overlays -= i.icon
							i.suffix = null
							i.name = initial(i.name)
							//i.layer = initial(i.layer)
							x.redraw_appearance()
						m.drop(i)
			Click(location,control,params)
				..()
				//Removes this item from the global Items list.
				if(items)
					if(src in items) items -= src
				params = params2list(params)
				var/dir = null
				if(params["left"] || usr.mouse_dir == "left")
					dir = "left"
				if(params["right"] || usr.mouse_dir == "right")
					dir = "right"
				if(dir == "right")
					if(isturf(src.loc))
						usr.pickup(src)
						if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up a [src]","actionoutput")
					else if(ismob(src.loc))
						if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
						usr.item_selected = src
					//	src.overlays -= /obj/effects/select_item
						//src.overlays += /obj/effects/select_item
				//if(params["left"])
				if(dir=="left")
					//Upgrade scanner
					if(isturf(src.loc))
						usr.pickup(src)
						if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up [src]","actionoutput")
					else if(ismob(src.loc))
						if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
						usr.item_selected = src
					//	src.overlays -= /obj/effects/select_item
						//src.overlays += /obj/effects/select_item

			/*Click(location,control,params)
				params = params2list(params)
				if(params["left"])
					if(params["left"])
						if(isturf(src.loc))
							usr.pickup(src)
						return
				if(params["right"])
					if(src in usr && usr.accessing )
						if(src.suffix == "worn")
							usr.overlays -= src
							src.icon_state = "ground"
							src.layer = 3
							src.suffix = null
						else
							src.icon_state = ""
							src.layer = usr.layer + 0.1
							src.suffix = "worn"
							usr.overlays += src
				..() */
			embroiled_cape
				icon = 'Embroiled Crane Cape.dmi'
				name = "Embroiled Cape"
				value = 1000
				layer = CLOTHING_LAYER + 1
				density_factor = 0
				appearance_flags = KEEP_TOGETHER
				New()
					..()
					name = "[src.name]"
					spawn(1)
						if(src) if(isturf(src.loc))
							src.name = "Embroiled Cape"
			cheerleader_skirt
				icon = 'Cheerleader Skirt Overlay.dmi'
				name = "Cheerleader Skirt"
				value = 1000
				layer = CLOTHING_LAYER
				density_factor = 0
				appearance_flags = KEEP_TOGETHER
				New()
					..()
					name = "[src.name]"
					spawn(1)
						if(src) if(isturf(src.loc))
							src.name = "Cheerleader Skirt"
			cheerleader_top
				icon = 'Cheerleader Top Overlay.dmi'
				name = "Cheerleader Top"
				value = 1000
				layer = CLOTHING_LAYER
				density_factor = 0
				appearance_flags = KEEP_TOGETHER
				New()
					..()
					name = "[src.name]"
					spawn(1)
						if(src) if(isturf(src.loc))
							src.name = "Cheerleader Top"
			nun_headdress
				icon = 'Nun Headdress.dmi'
				name = "Nun Headdress"
				value = 1000
				layer = CLOTHING_LAYER + 1
				density_factor = 0
				appearance_flags = KEEP_TOGETHER
				New()
					..()
					name = "[src.name]"
					spawn(1)
						if(src) if(isturf(src.loc))
							src.name = "Nun Headdress"
			nun_outfit
				icon = 'Nun Outfit.dmi'
				name = "Nun Outfit"
				value = 1000
				layer = CLOTHING_LAYER
				density_factor = 0
				appearance_flags = KEEP_TOGETHER
				New()
					..()
					name = "[src.name]"
					spawn(1)
						if(src) if(isturf(src.loc))
							src.name = "Nun Outfit"
			nun_leggings
				icon = 'Nun Legging.dmi'
				name = "Nun Leggings"
				value = 1000
				layer = CLOTHING_LAYER
				density_factor = 0
				appearance_flags = KEEP_TOGETHER
				New()
					..()
					name = "[src.name]"
					spawn(1)
						if(src) if(isturf(src.loc))
							src.name = "Nun Leggings"
			two_tone_dress
				icon = 'Two-tone Dress.dmi'

				name = "Two Tone Dress"
				value = 1000
				layer = CLOTHING_LAYER
				density_factor = 0
				appearance_flags = KEEP_TOGETHER

				// Separate icon files
				top_icon = 'Two-tone Dress.dmi'
				bottom_icon = 'Two-tone Dress Overlay.dmi'

				top_color = "#FFFFFF"
				bottom_color = "#FFFFFF"

				New()
					..()
					//build_icon()
					name = "[src.name]"
					spawn()
						if(src) if(isturf(src.loc))
							src.name = "Two Tone Dress"
			ballroom_dress
				icon = 'Ballroom Dress Base.dmi'

				name = "Ballroom Dress"
				value = 1000
				layer = CLOTHING_LAYER
				density_factor = 0
				appearance_flags = KEEP_TOGETHER

				// Separate icon files
				top_icon = 'Ballroom Dress Base.dmi'
				bottom_icon = 'Ballroom Dress Overlay.dmi'

				top_color = "#FFFFFF"
				bottom_color = "#FFFFFF"

				New()
					..()
					//build_icon()
					name = "[src.name]"
					spawn()
						if(src) if(isturf(src.loc))
							src.name = "Ballroom Dress"
			wide_skirt_dress
				icon = 'Wide Skirt Dress Overlay 1.dmi'

				name = "Wide Skirt Dress"
				value = 1000
				layer = CLOTHING_LAYER
				density_factor = 0
				appearance_flags = KEEP_TOGETHER

				// Separate icon files
				top_icon = 'Wide Skirt Dress Overlay 1.dmi'
				bottom_icon = 'Wide Skirt Dress Overlay2.dmi'

				top_color = "#FFFFFF"
				bottom_color = "#FFFFFF"

				New()
					..()
					//build_icon()
					name = "[src.name]"
					spawn()
						if(src) if(isturf(src.loc))
							src.name = "Wide Skirt Dress"
			Mutant_Helmet_Full
				icon = 'Ling Helmet.dmi'
				name = "Mutant Helmet(Full)"
				value = 1000
				layer = EQUIPMENT_LAYER
				density_factor = 0
				appearance_flags = KEEP_TOGETHER
				New()
					..()
					name = "[src.name]"
					spawn()
						if(src) if(isturf(src.loc))
							src.name = "Mutant Helmet(Full)"
			Mutant_Helmet
				icon = 'Ling Helmet Overlay.dmi'
				name = "Mutant Helmet"
				value = 1000
				layer = EQUIPMENT_LAYER
				density_factor = 0
				appearance_flags = KEEP_TOGETHER
				New()
					..()
					name = "[src.name]"
					spawn()
						if(src) if(isturf(src.loc))
							src.name = "Mutant Helmet"
			hair_ribbon_back
				icon = 'Hair Ribbon Back Side Only.dmi'
				name = "Hair Ribbon(Back)"
				value = 1000
				layer = CLOTHING_LAYER + 1
				density_factor = 0
				appearance_flags = KEEP_TOGETHER
				New()
					..()
					name = "[src.name]"
					spawn()
						if(src) if(isturf(src.loc))
							src.name = "Hair Ribbon(Back)"
			hair_ribbon
				icon = 'Hair Ribbon Base.dmi'
				name = "Hair Ribbon"
				value = 1000
				layer = CLOTHING_LAYER + 1
				density_factor = 0
				appearance_flags = KEEP_TOGETHER
				New()
					..()
					name = "[src.name]"
					spawn()
						if(src) if(isturf(src.loc))
							src.name = "Hair Ribbon"
			wizard_hat
				icon = 'DMG Helmet.dmi'
				name = "Wizard Hat"
				value = 1000
				layer = CLOTHING_LAYER + 2
				density_factor = 0
				appearance_flags = KEEP_TOGETHER
				New()
					..()
					name = "[src.name]"
					spawn()
						if(src) if(isturf(src.loc))
							src.name = "Wizard Hat"

			fedora_hat
				icon = 'Fedora Base.dmi'
				name = "Fedora Hat"
				value = 1000
				layer = CLOTHING_LAYER + 2
				density_factor = 0
				appearance_flags = KEEP_TOGETHER
				New()
					..()
					name = "[src.name]"
					spawn()
						if(src) if(isturf(src.loc))
							src.name = "Fedora Hat"
			hero_helmet
				icon = 'Shaka Helmet.dmi'
				name = "Hero Helmet"
				value = 1000
				layer = CLOTHING_LAYER + 2
				density_factor = 0
				appearance_flags = KEEP_TOGETHER
				New()
					..()
					name = "[src.name]"
					spawn()
						if(src) if(isturf(src.loc))
							src.name = "Hero Helmet"
			deluxe_cape
				icon = 'Emperor Cape Overlay.dmi'
				name = "Deluxe Cape"
				value = 1000
				layer = CLOTHING_LAYER + 1
				density_factor = 0
				appearance_flags = KEEP_TOGETHER
				New()
					..()
					name = "[src.name]"
					spawn(1)
						if(src) if(isturf(src.loc))
							src.name = "Deluxe Cape"
			royal_cape
				icon = 'Emperor Cape.dmi'
				name = "Royal Cape"
				value = 1000
				layer = CLOTHING_LAYER + 1
				density_factor = 0
				appearance_flags = KEEP_TOGETHER
				New()
					..()
					name = "[src.name]"
					spawn()
						if(src) if(isturf(src.loc))
							src.name = "Royal Cape"
			shades
				icon = 'Shades.dmi'
				name = "Shades"
				value = 1000
				layer = CLOTHING_LAYER + 4
				density_factor = 0
				appearance_flags = KEEP_TOGETHER
				New()
					..()
					name = "[src.name]"
					spawn()
						if(src) if(isturf(src.loc))
							src.name = "Shades"
			glasses
				icon = 'Glasses.dmi'
				name = "Glasses"
				value = 1000
				layer = CLOTHING_LAYER + 4
				density_factor = 0
				appearance_flags = KEEP_TOGETHER
				New()
					..()
					name = "[src.name]"
					spawn()
						if(src) if(isturf(src.loc))
							src.name = "Glasses"
			turban
				icon = 'NamekianTurban.dmi'
				name = "Turban"
				value = 1000
				layer = CLOTHING_LAYER + 2
				density_factor = 0
				appearance_flags = KEEP_TOGETHER
				New()
					..()
					name = "[src.name]"
					spawn()
						if(src) if(isturf(src.loc))
							src.name = "Turban"

			kid_turban
				icon = 'NamekianTurbanKid.dmi'
				name = "Turban(Kid)"
				value = 1000
				layer = CLOTHING_LAYER + 2
				density_factor = 0
				appearance_flags = KEEP_TOGETHER
				New()
					..()
					name = "[src.name]"
					spawn()
						if(src) if(isturf(src.loc))
							src.name = "Turban(Kid)"
			namekian_scarf
				icon = 'Namekian_Scarf.dmi'
				name = "Namekian Scarf"
				value = 1000
				layer = CLOTHING_LAYER + 1
				density_factor = 0
				appearance_flags = KEEP_TOGETHER
				New()
					..()
					name = "[src.name]"
					spawn()
						if(src) if(isturf(src.loc))
							src.name = "Namekian Scarf"
			side_headband
				icon = 'Kogu_Headband.dmi'
				name = "Side Headband"
				value = 1000
				layer = CLOTHING_LAYER + 2
				density_factor = 0
				appearance_flags = KEEP_TOGETHER
				New()
					..()
					name = "[src.name]"
					spawn()
						if(src) if(isturf(src.loc))
							src.name = "Side Headband"
			kid_side_headband
				icon = 'Kogu_Headband_kid.dmi'
				name = "Side Headband(Kid)"
				value = 1000
				layer = CLOTHING_LAYER + 2
				density_factor = 0
				appearance_flags = KEEP_TOGETHER
				New()
					..()
					name = "[src.name]"
					spawn()
						if(src) if(isturf(src.loc))
							src.name = "Side Headband(Kid)"
			karate_headband
				icon = 'KarateHeadband.dmi'
				name = "Karate Headband"
				value = 1000
				layer = CLOTHING_LAYER + 2
				density_factor = 0
				appearance_flags = KEEP_TOGETHER
				New()
					..()
					name = "[src.name]"
					spawn()
						if(src) if(isturf(src.loc))
							src.name = "Karate Headband"
			kid_karate_headband
				icon = 'KarateHeadband_kid.dmi'
				name = "Karate Headband(Kid)"
				value = 1000
				layer = CLOTHING_LAYER + 2
				density_factor = 0
				appearance_flags = KEEP_TOGETHER
				New()
					..()
					name = "[src.name]"
					spawn()
						if(src) if(isturf(src.loc))
							src.name = "Karate Headband(Kid)"
			bandana
				icon = 'Bojack_Bandana.dmi'
				name = "Bandana"
				value = 1000
				layer = CLOTHING_LAYER + 2
				density_factor = 0
				appearance_flags = KEEP_TOGETHER
				New()
					..()
					name = "[src.name]"
					spawn()
						if(src) if(isturf(src.loc))
							src.name = "Bandana"
			kid_bandana
				icon = 'Bojack_Bandana_Kid.dmi'
				name = "Bandana(Kid)"
				value = 1000
				layer = CLOTHING_LAYER + 2
				density_factor = 0
				appearance_flags = KEEP_TOGETHER
				New()
					..()
					name = "[src.name]"
					spawn()
						if(src) if(isturf(src.loc))
							src.name = "Bandana(Kid)"
			cape_shoulderless
				icon = 'Cape_Shoulderless.dmi'
				name = "Shouderless Cape"
				value = 1000
				layer = CLOTHING_LAYER + 1
				density_factor = 0
				appearance_flags = KEEP_TOGETHER
				New()
					..()
					name = "[src.name]"
					spawn()
						if(src) if(isturf(src.loc))
							src.name = "Shoulderless Cape"
			cape
				icon = 'Cape.dmi'
				name = "Cape"
				value = 1000
				layer = CLOTHING_LAYER + 1
				density_factor = 0
				appearance_flags = KEEP_TOGETHER
				New()
					..()
					name = "[src.name]"
					spawn()
						if(src) if(isturf(src.loc))
							src.name = "Cape"
			kid_cape
				icon = 'Kid_Cape (1).dmi'
				name = "Cape(Kid)"
				value = 1000
				layer = CLOTHING_LAYER + 1
				density_factor = 0
				appearance_flags = KEEP_TOGETHER
				New()
					..()
					name = "[src.name]"
					spawn()
						if(src) if(isturf(src.loc))
							src.name = "Cape(Kid)"
			kai_sash
				icon = 'Kai_Sash.dmi'
				name = "Kai Sash"
				value = 1000
				layer = CLOTHING_LAYER + 1
				density_factor = 0
				appearance_flags = KEEP_TOGETHER
				New()
					..()
					name = "[src.name]"
					spawn()
						if(src) if(isturf(src.loc))
							src.name = "Kai Sash"
			sash
				icon = 'Sash.dmi'
				name = "Sash"
				value = 1000
				layer = CLOTHING_LAYER + 1
				density_factor = 0
				appearance_flags = KEEP_TOGETHER
				New()
					..()
					name = "[src.name]"
					spawn()
						if(src) if(isturf(src.loc))
							src.name = "Sash"
			belt
				icon = 'Belt.dmi'
				name = "Belt"
				value = 1000
				layer = CLOTHING_LAYER + 1
				density_factor = 0
				appearance_flags = KEEP_TOGETHER
				New()
					..()
					name = "[src.name]"
					spawn()
						if(src) if(isturf(src.loc))
							src.name = "Belt"
			wristbands
				icon = 'Wristbands.dmi'
				name = "Wristbands"
				value = 1000
				layer = CLOTHING_LAYER
				density_factor = 0
				appearance_flags = KEEP_TOGETHER
				New()
					..()
					name = "[src.name]"
					spawn()
						if(src) if(isturf(src.loc))
							src.name = "Wristbands"
			gloves
				icon = 'Gloves.dmi'
				name = "Gloves"
				value = 1000
				layer = CLOTHING_LAYER + 1
				density_factor = 0
				appearance_flags = KEEP_TOGETHER
				New()
					..()
					name = "[src.name]"
					spawn()
						if(src) if(isturf(src.loc))
							src.name = "Gloves"

			saiyan_boots
				icon = 'Boots_Saiyan.dmi'
				name = "Saiyan Boots"
				value = 1000
				layer = CLOTHING_LAYER + 1
				density_factor = 0
				appearance_flags = KEEP_TOGETHER
				New()
					..()
					name = "[src.name]"
					spawn()
						if(src) if(isturf(src.loc))
							src.name = "Saiyan Boots"
			kid_saiyan_boots
				icon = 'boots_saiyan_kid.dmi'
				name = "Saiyan Boots(Kid)"
				value = 1000
				layer = CLOTHING_LAYER + 1
				density_factor = 0
				appearance_flags = KEEP_TOGETHER
				New()
					..()
					name = "[src.name]"
					spawn()
						if(src) if(isturf(src.loc))
							src.name = "Saiyan Boots(Kid)"
			boots
				icon = 'BootsSov.dmi'
				name = "Boots"
				value = 1000
				layer = CLOTHING_LAYER + 1
				density_factor = 0
				appearance_flags = KEEP_TOGETHER
				New()
					..()
					name = "[src.name]"
					spawn()
						if(src) if(isturf(src.loc))
							src.name = "Boots"
			kid_boots
				icon = 'BootsSovkid.dmi'
				name = "Boots(Kid)"
				value = 1000
				layer = CLOTHING_LAYER + 1
				density_factor = 0
				appearance_flags = KEEP_TOGETHER
				New()
					..()
					name = "[src.name]"
					spawn()
						if(src) if(isturf(src.loc))
							src.name = "Boots(Kid)"
			hoodie
				icon = 'Hoodie.dmi'
				name = "Hoodie"
				value = 1000
				layer = CLOTHING_LAYER
				density_factor = 0
				appearance_flags = KEEP_TOGETHER
				New()
					..()
					name = "[src.name]"
					spawn()
						if(src) if(isturf(src.loc))
							src.name = "Hoodie"
			black_sleeve_jacket
				icon = 'Jacket_Black_Sleeves.dmi'
				name = "Black Jacket Sleeves"
				value = 1000
				layer = CLOTHING_LAYER + 1
				density_factor = 0
				appearance_flags = KEEP_TOGETHER
				New()
					..()
					name = "[src.name]"
					spawn()
						if(src) if(isturf(src.loc))
							src.name = "Black Jacket Sleeves"
			kid_black_sleeve_jacket
				icon = 'Jacket_Kid_Black_Sleeves.dmi'
				name = "Black Jacket Sleeves(Kid)"
				value = 1000
				layer = CLOTHING_LAYER + 1
				density_factor = 0
				appearance_flags = KEEP_TOGETHER
				New()
					..()
					name = "[src.name]"
					spawn()
						if(src) if(isturf(src.loc))
							src.name = "Black Jacket Sleeves(Kid)"
			martial_arts_uniform_single_shoulder
				icon = 'Martial_Art_Uniform_SingleShoulder.dmi'
				name = "Single Shoulder Martial Art Uniform"
				value = 1000
				layer = CLOTHING_LAYER
				density_factor = 0
				appearance_flags = KEEP_TOGETHER
				New()
					..()
					name = "[src.name]"
					spawn()
						if(src) if(isturf(src.loc))
							src.name = "Single Shoulder Martial Art Uniform"
			martial_arts_uniform
				icon = 'Martial_Art_Uniform.dmi'
				name = "Martial Art Uniform"
				value = 1000
				layer = CLOTHING_LAYER
				density_factor = 0
				appearance_flags = KEEP_TOGETHER
				New()
					..()
					name = "[src.name]"
					spawn()
						if(src) if(isturf(src.loc))
							src.name = "Martial Art Uniform"
			female_underclothes
				icon = 'UnderclothesFemaleSleevless.dmi'
				name = "Female Underclothes"
				value = 1000
				layer = CLOTHING_LAYER
				density_factor = 0
				appearance_flags = KEEP_TOGETHER
				New()
					..()
					name = "[src.name]"
					spawn()
						if(src) if(isturf(src.loc))
							src.name = "Female Underclothes"
			male_underclothes
				icon = 'Underclothes_Male.dmi'
				name = "Male Underclothes"
				value = 1000
				layer = CLOTHING_LAYER
				density_factor = 0
				appearance_flags = KEEP_TOGETHER
				New()
					..()
					name = "[src.name]"
					spawn()
						if(src) if(isturf(src.loc))
							src.name = "Male Underclothes"
			kai_suit
				icon = 'Kai_Suit.dmi'
				name = "Kai Suit"
				value = 1000
				layer = CLOTHING_LAYER + 1
				density_factor = 0
				appearance_flags = KEEP_TOGETHER
				New()
					..()
					name = "[src.name]"
					spawn()
						if(src) if(isturf(src.loc))
							src.name = "Kai Suit"
			sleeveless_trench_coat
				icon = 'Sleeveless_Trench_Coat.dmi'
				name = "Sleevelees Trench Coat"
				value = 1000
				layer = CLOTHING_LAYER + 1
				density_factor = 0
				appearance_flags = KEEP_TOGETHER
				New()
					..()
					name = "[src.name]"
					spawn()
						if(src) if(isturf(src.loc))
							src.name = "Sleevelees Trench Coat"
			sleeveless_jacket
				icon = 'Jacket_Sleeveless.dmi'
				name = "Sleeveless Jacket"
				value = 1000
				layer = CLOTHING_LAYER + 1
				density_factor = 0
				appearance_flags = KEEP_TOGETHER
				New()
					..()
					name = "[src.name]"
					spawn()
						if(src) if(isturf(src.loc))
							src.name = "Sleeveless Jacket"
			kid_sleeveless_jacket
				icon = 'Jacket_Kid_Sleeveless.dmi'
				name = "Sleeveless Jacket(Kid)"
				value = 1000
				layer = CLOTHING_LAYER + 1
				density_factor = 0
				appearance_flags = KEEP_TOGETHER
				New()
					..()
					name = "[src.name]"
					spawn()
						if(src) if(isturf(src.loc))
							src.name = "Sleeveless Jacket(Kid)"
			jacket
				icon = 'Jacket.dmi'
				name = "Jacket"
				value = 1000
				layer = CLOTHING_LAYER + 1
				density_factor = 0
				appearance_flags = KEEP_TOGETHER
				New()
					..()
					name = "[src.name]"
					spawn()
						if(src) if(isturf(src.loc))
							src.name = "Jacket"
			kid_jacket
				icon = 'Jacket_Kid.dmi'
				name = "Jacket(Kid)"
				value = 1000
				layer = CLOTHING_LAYER + 1
				density_factor = 0
				appearance_flags = KEEP_TOGETHER
				New()
					..()
					name = "[src.name]"
					spawn()
						if(src) if(isturf(src.loc))
							src.name = "Jacket(Kid)"
			singlet
				icon = 'Singlet.dmi'
				name = "Singlet"
				value = 1000
				layer = CLOTHING_LAYER
				density_factor = 0
				appearance_flags = KEEP_TOGETHER
				New()
					..()
					name = "[src.name]"
					spawn()
						if(src) if(isturf(src.loc))
							src.name = "Singlet"
			sleeveless_shirt
				icon = 'Shirt_Sleeveless.dmi'
				name = "Sleeveless Shirt"
				value = 1000
				layer = CLOTHING_LAYER
				density_factor = 0
				appearance_flags = KEEP_TOGETHER
				New()
					..()
					name = "[src.name]"
					spawn()
						if(src) if(isturf(src.loc))
							src.name = "Sleeveless Shirt"
			shoes
				icon = 'Shoes.dmi'
				name = "Shoes"
				value = 1000
				layer = CLOTHING_LAYER
				density_factor = 0
				appearance_flags = KEEP_TOGETHER
				New()
					..()
					name = "[src.name]"
					spawn()
						if(src) if(isturf(src.loc))
							src.name = "Shoes"
			kid_shoes
				icon = 'shoes_kid.dmi'
				name = "Shoes(Kid)"
				value = 1000
				layer = CLOTHING_LAYER
				density_factor = 0
				appearance_flags = KEEP_TOGETHER
				New()
					..()
					name = "[src.name]"
					spawn()
						if(src) if(isturf(src.loc))
							src.name = "Shoes(Kid)"
			pants
				icon = 'Pants.dmi'
				name = "Pants"
				value = 1000
				layer = CLOTHING_LAYER
				density_factor = 0
				appearance_flags = KEEP_TOGETHER
				New()
					..()
					name = "[src.name] ([src.value])"
					spawn()
						if(src) if(isturf(src.loc))
							src.name = "Pants"
			kid_pants
				icon = 'pants_kid.dmi'
				name = "Pants(Kid)"
				value = 1000
				layer = CLOTHING_LAYER
				density_factor = 0
				appearance_flags = KEEP_TOGETHER
				New()
					..()
					name = "[src.name] ([src.value])"
					spawn()
						if(src) if(isturf(src.loc))
							src.name = "Pants(Kid)"
			shirt
				icon = 'Shirt.dmi'
				name = "Shirt"
				value = 1000
				layer = CLOTHING_LAYER
				density_factor = 0
				appearance_flags = KEEP_TOGETHER
				New()
					..()
					name = "[src.name] "
					spawn()
						if(src) if(isturf(src.loc))
							src.name = "Shirt"
			kid_shirt
				icon = 'shirt_kid.dmi'
				name = "Shirt(Kid)"
				value = 1000
				layer = CLOTHING_LAYER
				density_factor = 0
				appearance_flags = KEEP_TOGETHER
				New()
					..()
					name = "[src.name] "
					spawn()
						if(src) if(isturf(src.loc))
							src.name = "Shirt(Kid)"
			fur_skirt
				icon = 'Fur Skirt.dmi'
				name = "Fur"
				value = 1000
				layer = CLOTHING_LAYER
				density_factor = 0
				appearance_flags = KEEP_TOGETHER
				New()
					..()
					name = "[src.name]"
					spawn()
						src.name = "Fur"
			fur
				icon = 'Fur.dmi'
				name = "Fur"
				value = 1000
				layer = CLOTHING_LAYER
				density_factor = 0
				appearance_flags = KEEP_TOGETHER
				New()
					..()
					name = "[src.name]"
					spawn()
						src.name = "Fur"
			
			boots_fur
				icon = 'Boots_Fur.dmi'
				name = "Fur Boots"
				value = 1000
				layer = CLOTHING_LAYER + 1
				density_factor = 0
				appearance_flags = KEEP_TOGETHER
				New()
					..()
					name = "[src.name]"
					spawn()
						src.name = "Fur Boots"

			boots_fur_kid
				icon = 'Boots_Fur_Kid.dmi'
				name = "Fur Boots(Kid)"
				value = 1000
				layer = CLOTHING_LAYER
				density_factor = 0
				appearance_flags = KEEP_TOGETHER
				New()
					..()
					name = "[src.name]"
					spawn()
						src.name = "Fur Boots(Kid)"
			armour
				armour1
					icon = 'armour1.dmi'
					name = "Armour"
					value = 1000
					layer = ARMOUR_LAYER+1
					density_factor = 0
					appearance_flags = KEEP_TOGETHER
					New()
						var/image/sel = image('fx_medium.dmi',src,"select item",1000)
						src.img_select = sel
						name = "[src.name] ([src.value])"
						spawn()
							if(src) if(isturf(src.loc))
								src.icon_state = "ground"
								src.name = "Armour"
		tech
			hashadow = 1
			layer = 4
			weight = 2
			appearance_flags = TILE_BOUND
			stacks = -1
			var
				list/category = null //The category this tech is in.
				list/tech_give //A list of type paths that this tech will give on completion.
				list/tech_prerequisites //List of techs needed to unlock this one
				tmp/list/batteries //Set to the battery connected to this line, even if its not got energy stored.
				tmp/list/connections
				tmp/list/checked //Set to 1 for a second after being checked as a power line that is powered or not.
				organic = 0
				list_pos = 0 //The position of this tech inside the world.tech list. Used to make a comparison with the players tech lvls/xp

			MouseEntered(location,control,params)
				..()
				//if(src.loc == null && usr.build_tech == null)
					//usr.client.images += src.img_select
					//winset(usr,"tech.label_tech","text=\"[src.name] - [src.desc]\"")
					//src.mouse_opacity = 0;

			MouseExited(location,control,params)
				..()
				//if(src.loc == null)
					//usr.client.images -= src.img_select
					//src.mouse_opacity = 1;
			proc
				lvl_up_tech(var/mob/m)
					m.tech_xp[src.list_pos] = 100
					//src.tech_exp = 100
					//src.tech_exp_gain /= 1.25
					//var/time = round((100/src.tech_exp_gain)/60,0.1)
					//winset(m,"[src.info_path].label_research_time","text=\"Research Time: [round(time/m.mod_intelligence,0.1)] minutes\"")
					//src.tech_lvl += 1
					m.tech_lvls[src.list_pos] += 1
					//m.technology -= src
					m.tech_unlocked[src.list_pos] = src.type//src
					if(src.type == /obj/items/tech/sub_tech/Engineering/Structural_Engineering) m.tech_pos_se = src.list_pos
					src.skill_up(m)
					//if(src.act) call(src,src.act)(m)
					for(var/obj/items/tech/o in global.tech) //m.technology)
						for(var/x in src.tech_give)
							if(o.type == x)
								if(m.tech_unlocked.Find(o.type) == 0)
									//m.technology -= o
									//m.technology_researched += o
									m.tech_unlocked[o.list_pos] = o.type
									m.output_msg("[o] technology unlocked!")
					if(src.tech_repeatable) m.tech_xp[src.list_pos] = 0//src.tech_exp = 0
					else
						m.tech_focus = null
						m.hud_tech.vis_contents -= m.hud_tech.button_research
						//if(m.tech_focus == m.tech_display) winset(m,"[src.info_path].button_research","is-disabled = true")
			sub_tech
				// Add 336 to all the y coords.
				tech_display = 0;
				layer = 36
				plane = 34
				blend_mode = BLEND_INSET_OVERLAY
				appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
				var/obj/xp_bar
				MouseEntered(location,control,params)
					usr.client.images += src.img_over
				MouseExited(location,control,params)
					usr.client.images -= src.img_over
				Click()
					if(usr.tech_display)
						var/obj/items/tech/t = usr.tech_display
						usr.client.images -= t.img_over
					usr.tech_display = src
					usr.client.images += src.img_over
					if(usr.hud_tech)
						usr.hud_tech.vis_contents -= usr.hud_tech.button_use
						usr.hud_tech.vis_contents += usr.hud_tech.button_research
						//If the tech isn't repeatable and already researched, no need to display the research button
						if(src.tech_repeatable == 0 && usr.tech_lvls[src.list_pos] > 0) usr.hud_tech.vis_contents -= usr.hud_tech.button_research

						if(src == usr.tech_focus) usr.hud_tech.button_research.maptext = "[css_outline]<font size = 1><center>Pause"
						else
							usr.hud_tech.button_research.maptext = "[css_outline]<font size = 1><center>Research"

						//Finish setting the tech info up
						if(usr.hud_tech.txt)
							var/repeats = "No"
							if(src.tech_repeatable) repeats = "Yes"
							usr.hud_tech.txt.maptext = "[css_outline]<font size = 1><text align=center valign=top>[src.name]<text align=left valign=top>\n\n\n\nTech Tree: [src.tech_tree]\n\nTechnology Prerequisites: [src.tech_needed_txt]\n\nUnlocks Technology: [src.tech_give_txt]\n\nRepeatable: [repeats]\n\n[src.desc]"
				MouseWheel(delta_x,delta_y,location,control,params)
					if(usr.hud_tech)
						var/obj/hud/menus/tech_background/s = usr.hud_tech
						var/obj/hud/menus/tech_background/tech_scroller/sc = s.tech_tree_scroller1
						usr.check_mouse_loc(params)
						var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
						usr.mouse_y_true = true_y
						var/wheel_move = 0
						if(delta_y > 0) wheel_move = 16
						else if(delta_y < 0) wheel_move = -16
						var/result = sc.translated_y+wheel_move
						result = clamp(result,0,-227)
						var/matrix/m = matrix()
						m.Translate(0,result)
						sc.transform = m
						sc.translated_y = result

						s.scrl_transform[s.selected] = m

						var/ratio = -1 + ((-227 + result) / -227)
						ratio = clamp(ratio,0,1)
						var/scroll_y = round(200*ratio)

						s.bar_pos_y[s.selected] = scroll_y

						var/matrix/m2 = matrix()
						m2.Translate(s.tech_holder_special.hud_x-s.bar_pos_x_hori[s.selected],s.tech_holder_special.hud_y+s.bar_pos_y[s.selected])
						s.tech_holder_special.transform = m2
				Genetics //Unlocks item that lets you change your hair, skin, ect.
					icon = 'tech_tree_buttons_genetics.dmi'
					tech_repeatable = 0
					tech_tree = "Genetics"
					info_path = "tech_research_genetics"
					//tech_exp_gain = 0.333;
					tech_exp_gain = 3
					info_name = "Genetics"
					hud_x = 136
					hud_y = 628//292
					needed_qp = 1
					New()
						var/matrix/m = matrix()
						m.Translate(src.hud_x,src.hud_y)
						src.transform = m

						category = list("Primary Research")
						tag = name
						tech_give_txt = "Microbiology, Gene Engineering, Medical Theories"
						var/image/over = image('tech_tree_buttons_over.dmi',src,"hover",100)
						over.pixel_x = -1
						over.pixel_y = -1
						src.img_over = over
						src.needed_qp = 1
						..()
					Gene_Mapping
						info_name = "Gene_Mapping"
						tech_repeatable = 0
						tech_needed_txt = "Gene Engineering"
						needed_qp = 8000
						tech_give_txt = ""

						New()
							..()
							tech_prerequisites = list(/obj/items/tech/sub_tech/Genetics/Gene_Engineering)
							needed_qp = 8000


					Gene_Manipulation //Lets you create syringe that allows you to respec
						hud_x = 136
						hud_y = 474//138
						info_name = "Gene_Manipulation"
						tech_repeatable = 0
						tech_needed_txt = "Gene Mapping"
						needed_qp = 23000
						New()
							..()
							needed_qp = 23000
							tech_prerequisites = list(/obj/items/tech/sub_tech/Genetics/Gene_Mapping)
					Gene_Engineering
						info_name = "Gene_Engineering"
						tech_repeatable = 0
						hud_x = 136
						hud_y = 582//246
						tech_needed_txt = "Genetics"
						needed_qp = 4700
						New()
							..()
							needed_qp = 4700
							tech_prerequisites = list(/obj/items/tech/sub_tech/Genetics)
					Gene_Splicing
						hud_x = 136
						hud_y = 420//84
						info_name = "Gene_Splicing"
						tech_repeatable = 0
						tech_needed_txt = "Gene Manipulation"
						needed_qp = 24000

						New()
							..()
							needed_qp = 24000
							tech_prerequisites = list(/obj/items/tech/sub_tech/Genetics/Gene_Manipulation)
					Microbiology //Viruses, Bacteria
						info_name = "Microbiology"
						tech_repeatable = 0
						hud_x = 46
						hud_y = 582//246
						needed_qp = 900
						tech_needed_txt = "Genetics"
						tech_give_txt = "Mutagen Synthesis"

						New()
							..()
							tech_prerequisites = list(/obj/items/tech/sub_tech/Genetics/Microbiology)
							needed_qp = 900
					Biomolecular_Engineering //Allow the creation of custom organs
						info_name = "Biomolecular_Engineering"
						tech_repeatable = 0
						hud_x = 67
						hud_y = 528//192
						needed_qp = 4500
						tech_needed_txt = "Microbiology"
						New()
							..()
							needed_qp = 4500
							tech_prerequisites = list(/obj/items/tech/sub_tech/Genetics/Microbiology)
					Bioengineering_Master //Create the perfect biological warrior
						hud_x = 67
						hud_y = 358//22
						tech_needed_txt = "Synthetics, Gene Splicing"
						tech_give_txt = "Bio Engineering Tank"
						needed_qp = 10000
						tech_give = list (/obj/items/tech/Bio_Engineering_Tank)
						New()
							..()
							needed_qp = 10000
							tech_give = list (/obj/items/tech/Bio_Engineering_Tank)
							//tech_prerequisites = list(/obj/items/tech/sub_tech/Genetics/Synthetics,/obj/items/tech/sub_tech/Genetics/Gene_Splicing)
					Cloning
						info_name = "Cloning"
						tech_repeatable = 0
						hud_x = 101
						hud_y = 528//192
						tech_needed_txt = "Biomecular Engineering, Gene Mapping"
						tech_give_txt = "VAT Containers"
						needed_qp = 8000000000
						//tech_give = list(/obj/items/tech/Vat)
						New()
							..()
							needed_qp = 8000000000000000000000
							//tech_give = list(/obj/items/tech/Vat)
							//tech_prerequisites = list(/obj/items/tech/sub_tech/Genetics/Biomolecular_Engineering,/obj/items/tech/sub_tech/Genetics/Gene_Mapping)
					Cloning_Expertise
						info_name = "Cloning_Expertise"
						tech_repeatable = 0
						tech_give_txt = "+0.1 Multiplier Limit \n\n\ +0.1 Stat Limit"
						act = /obj/items/tech/sub_tech/Genetics/Cloning_Expertise/proc/activate
						hud_x = 101
						hud_y = 420//84
						tech_needed_txt = "Cloning"
						needed_qp = 36000
						proc
							activate(var/mob/m,var/obj/t)
								if(m.gene_limit <= 3) m.gene_limit += 0.1
						New()
							..()
							needed_qp = 36000
							tech_prerequisites = list(/obj/items/tech/sub_tech/Genetics/Biomolecular_Engineering,/obj/items/tech/sub_tech/Genetics/Cloning)
					Artifical_DNA
						hud_x = 67
						hud_y = 474//138
						tech_needed_txt = "Biomecular_Engineering"
						tech_give_txt = "DNA Drainer"
						tech_give = list(/obj/items/tech/drainers/DNA_Drainer)
						needed_qp = 10000
						New()
							..()
							needed_qp = 10000
							tech_give = list(/obj/items/tech/drainers/DNA_Drainer)
							//tech_prerequisites = list(/obj/items/tech/sub_tech/Genetics/Biomolecular_Engineering)
					Synthetics //Allows the creation of bio warriors.
						hud_x = 67
						hud_y = 420//84
						tech_needed_txt = "Artificial_DNA"
						tech_give_txt = "Leads to creation of bio-genetic species"
						needed_qp = 40000
						New()
							..()
							needed_qp = 40000
							tech_prerequisites = list(/obj/items/tech/sub_tech/Genetics/Artifical_DNA)
					Mutagen_Synthesis
						hud_x = 91
						hud_y = 582//246
						needed_qp = 1300
						tech_needed_txt = "Microbiology"
						tech_give_txt = ""

						New()
							..()
							tech_prerequisites = list(/obj/items/tech/sub_tech/Genetics/Microbiology)
							needed_qp = 1300
					Medical_Theories
						hud_x = 299
						hud_y = 582//246
						needed_qp = 877
						tech_needed_txt = "Genetics"
						New()
							..()
							needed_qp = 877
							tech_prerequisites = list(/obj/items/tech/sub_tech/Genetics)
					/*
					- Lets you use a kind of reverse Injury skill, where you can click a doctoring skill, then click on someone, which brings up a menu of the bodyparts. Like when you using Infusion.
					- Clicking a part helps heal it, based on your medical skill?
					*/
					Drug_Synthesis
						tech_repeatable = 0
						info_name = "Drug_Synthesis"
						hud_x = 204
						hud_y = 582//246
						needed_qp = 3500
						tech_needed_txt = "Gene Engineering, Medical Theories"
						tech_give_txt = "Creation of drugs"
						tech_give = list(/obj/items/tech/Drug_Synthesization)
						New()
							..()
							needed_qp = 3500
							tech_give = list(/obj/items/tech/Drug_Synthesization)
							tech_prerequisites = list(/obj/items/tech/sub_tech/Genetics/Gene_Engineering,/obj/items/tech/sub_tech/Genetics/Medical_Theories)
					Regenerators
						hud_x = 239
						hud_y = 537//201
						info_name = "Regenerators"
						needed_qp = 1500
						//tech_needed_txt = "Medical Theories, Medical Equipment"
						tech_give_txt = "Regeneration Tanks"
						tech_give = list(/obj/items/tech/Bio_Rejuvination_Tank)
						New()
							..()

							tech_give = list(/obj/items/tech/Bio_Rejuvination_Tank)
						//	tech_prerequisites = list(/obj/items/tech/sub_tech/Genetics/Medical_Theories,/obj/items/tech/sub_tech/Genetics/Medical_Equipment)
							needed_qp = 1500
					Medical_Equipment //Bandages, splints, casts, masks, bio-suits, ect
						hud_x = 209
						hud_y = 537//201
						info_name = "Medical_Equipment"
					//	tech_needed_txt = "Medical Theories"
						tech_give_txt = "Medical Packs"
						needed_qp =600
						tech_give = list(/obj/items/tech/Kid_Bandages,/obj/items/tech/Bandages,/obj/items/tech/Medical_Pack)
						New()
							..()
							needed_qp =600
							tech_give = list(/obj/items/tech/Kid_Bandages,/obj/items/tech/Bandages,/obj/items/tech/Medical_Pack)
						//	tech_prerequisites = list(/obj/items/tech/sub_tech/Genetics/Medical_Theories)

					Gene_Scanners //Lets you check someone for diasese, mutations, stats, health, ect ect.
						hud_x = 269
						hud_y = 537//201
						info_name = "Gene_Scanners"
						needed_qp = 900
					//	tech_needed_txt = "Medical Theories, Medical Equipment"
						tech_give_txt = "Gene Scanners to check for disease, mutations, and bloodline."
						tech_give = list(/obj/items/tech/Gene_Scanner)
						New()
							..()
							needed_qp = 900
							tech_give = list(/obj/items/tech/Gene_Scanner)
							//tech_prerequisites = list(/obj/items/tech/sub_tech/Genetics/Medical_Theories,/obj/items/tech/sub_tech/Genetics/Medical_Equipment)

				Physics
					tech_repeatable = 0
					//tech_exp_gain = 0.333;
					tech_exp_gain = 2
					info_path = "tech_research_physics"
					icon = 'tech_tree_buttons_physics.dmi'
					hud_x = 136
					hud_y = 628//292
					needed_qp = 1

					New()
						/*
						var/obj/bar = new
						bar.icon = 'tech_tree_bar.dmi'
						bar.icon_state = "100"
						bar.plane = 22
						bar.layer = 40
						bar.pixel_x = -22
						bar.blend_mode = BLEND_INSET_OVERLAY
						src.vis_contents += bar
						src.xp_bar = bar
						*/

						var/matrix/m = matrix()
						m.Translate(src.hud_x,src.hud_y)
						src.transform = m

						category = list("Primary Research")
						tag = name

						tech_give_txt = "Electromagnetism, Electrochemistry, Thermodynamics"

						var/image/over = image('tech_tree_buttons_over.dmi',src,"hover",100)
						over.pixel_x = -1
						over.pixel_y = -1
						src.img_over = over
						src.needed_qp = 1
						..()

					Electromagnetism //One component of scanners
						info_name = "Electromagnetism"
						hud_x = 191
						hud_y = 582//246
						needed_qp = 500000000000000
						tech_repeatable = 0
						//tech_give = list(/obj/items/tech/Battery)
					//	tech_give_txt = "Batteries"
						New()
							..()
						//	needed_qp = 500
						//	tech_give = list(/obj/items/tech/Battery)
						//	tech_prerequisites = list(/obj/items/tech/sub_tech/Physics)

					Scouters
						tech_repeatable = 0
						info_name = "Scouters"
						hud_x = 191
						hud_y = 542//206
						needed_qp = 1000
						tech_give = list(/obj/items/tech/Scouters/Kid_Scouter,/obj/items/tech/Scouters/Scouter)
						tech_give_txt = "Scouter"
						New()
							..()
							needed_qp = 1000
							tech_give = list(/obj/items/tech/Scouters/Kid_Scouter,/obj/items/tech/Scouters/Scouter)
							//tech_prerequisites = list(/obj/items/tech/sub_tech/Physics/Electromagnetism)
					Electrochemistry
						tech_give_txt = "Leads to Fuels"
						hud_x = 63
						hud_y = 582//246
						needed_qp = 19000
						tech_repeatable = 0
						New()
							..()
							needed_qp = 19000
							tech_prerequisites = list(/obj/items/tech/sub_tech/Physics)

					Sparring_Gloves
						tech_give = list(/obj/items/tech/Sparring_Gloves,/obj/items/tech/Kid_Sparring_Gloves)
						info_name = "Sparring Gloves"
						tech_repeatable = 0
						hud_x = 300
						hud_y = 508//172
						needed_qp = 150
						//tech_needed_txt = "Basic Storage"
						New()
							..()
							needed_qp = 150
							tech_give = list(/obj/items/tech/Sparring_Gloves, /obj/items/tech/Kid_Sparring_Gloves )
							//tech_prerequisites = list(/obj/items/tech/sub_tech/Engineering/Refridgerators)
					Thermodynamics
						hud_x = 121
						hud_y = 582//246
						needed_qp = 700
						desc = ""
						info_name = "Thermodynamics"
						tech_needed_txt = "Physics"
						tech_give_txt = "Power Lines"
						tech_give = (/obj/items/tech/Power_Line)
						New()
							..()
							needed_qp = 700
							tech_give = (/obj/items/tech/Power_Line)
							//tech_prerequisites = list(/obj/items/tech/sub_tech/Physics)

					Fossil_Fuels //Needed for fueled generators
						hud_x = 15
						hud_y = 559//223
						tech_give_txt = "Fuel"
						info_name = "Fossil_Fuels"
						//tech_needed_txt = "Electrochemistry"
						tech_repeatable = 0
						needed_qp = 1600
						tech_give = list(/obj/items/tech/Fuel)
						New()
							..()
							needed_qp = 1600
							tech_give = list(/obj/items/tech/Fuel)
							//tech_prerequisites = list(/obj/items/tech/sub_tech/Physics/Electrochemistry)


					Oxygen
						hud_x = 15
						hud_y = 511//175
						info_name = "Oxygen"
						tech_give_txt = "Oxygen"
						tech_needed_txt = "Electrochemistry, Fossil Fuels"
						needed_qp = 5000
						tech_repeatable = 0
						tech_give = list(/obj/items/tech/Oxygen)
						New()
							..()
							needed_qp = 5000
							tech_give = list(/obj/items/tech/Oxygen)
							//tech_prerequisites = list(/obj/items/tech/sub_tech/Physics/Electrochemistry,/obj/items/tech/sub_tech/Physics/Fossil_Fuels)


					Quantum_Mechanics //Needed for gravity machine
						hud_x = 345
						hud_y = 582//246
						info_name = "Quantum_Mechanics"
						tech_give_txt = "Leads to Gravity"
						tech_needed_txt = "Thermodynamics, Electromagnetism"
						tech_repeatable = 0
						needed_qp = 19000
						New()
							..()
							needed_qp = 19000
							tech_prerequisites = list(/obj/items/tech/sub_tech/Physics/Electromagnetism,/obj/items/tech/sub_tech/Physics/Thermodynamics)

					Gravitational_Fields
						hud_x = 345
						hud_y = 542//206
						info_name = "Gravitational_Fields"
						tech_give_txt = "Gravity Controller"
						tech_needed_txt = "Quantum Mechanics"
						tech_repeatable = 0
						needed_qp = 5000000000
					//	tech_give = list(/obj/items/tech/Gravity_Controller)
						New()
							..()
						//	needed_qp = 5000000000000000
							//tech_give = list(/obj/items/tech/Gravity_Controller)
							//tech_prerequisites = list(/obj/items/tech/sub_tech/Physics/Quantum_Mechanics)

					Gravity_Machine //Sit inside, gain strength and endurance
						hud_x = 345
						hud_y = 494//158
						info_name = "Gravity_Machine"
						tech_give_txt = "Gravity Machine"
						tech_needed_txt = "Gravitational Fields"
						tech_repeatable = 0
					//	needed_qp = 50000000000
						//tech_give = list(/obj/items/tech/Gravity_Machine)
						New()
							..()
						//	needed_qp = 500000000000
							//tech_give = list(/obj/items/tech/Gravity_Machine)
							//tech_prerequisites = list(/obj/items/tech/sub_tech/Physics/Gravitational_Fields)

					Weather_Manipulation
						hud_x = 238
						hud_y = 582//246
						desc = ""
						info_name = "Weather_Manipulation"
						tech_needed_txt = "Electrochemistry, Thermodynamics"
						tech_give_txt = "Leads to Weathering and Microwaves"
						needed_qp = 25000
						New()
							..()
							needed_qp = 25000
							tech_prerequisites = list(/obj/items/tech/sub_tech/Physics/Thermodynamics,/obj/items/tech/sub_tech/Physics/Electrochemistry)

					Microwave_Domes //Sit inside, get electricuted, gain resis
						hud_x = 269
						hud_y = 582//246
						desc = ""
						info_name = "Microwave_Domes"
						//tech_needed_txt = "Weather Manipulation"
						//tech_give_txt = "Microwave Generator"
						tech_give = list(/obj/items/tech/Microwave_Generator)
						needed_qp = 700000000000
						New()
							..()
							//needed_qp = 7000
						//	tech_give = list(/obj/items/tech/Microwave_Generator)
							//tech_prerequisites = list(/obj/items/tech/sub_tech/Physics/Weather_Manipulation)


					Weather_Control_Machine //Sets the weather in the area to whatever you want
						hud_x = 238
						hud_y = 520//184
						info_name = "Weather_Control_Machine"
						tech_needed_txt = "Weather Manipulation"
						//tech_give = list(/obj/items/tech/Wind_Turbine)
					//	tech_give_txt = "Wind Turbines"
						tech_repeatable = 0
						needed_qp = 170000000
						New()
							..()
						//	needed_qp = 1700
						//	tech_give = list(/obj/items/tech/Wind_Turbine)
						//	tech_prerequisites = list(/obj/items/tech/sub_tech/Physics/Weather_Manipulation)


					Terraforming //Help reverse global fuckery of the weather-kind
						hud_x = 238
						hud_y = 442//106
						info_name = "Terraforming"
						needed_qp = 18000000
						//tech_give_txt = "Solar Generators, Geothermal Generator"
						//tech_needed_txt = "Weather Control Machine"
						//tech_give = list(/obj/items/tech/Solar_Generator,/obj/items/tech/Geothermal_Generator)
						New()
							..()
							needed_qp = 1800000000
							//tech_give = list(/obj/items/tech/Solar_Generator,/obj/items/tech/Geothermal_Generator)
							//tech_prerequisites = list(/obj/items/tech/sub_tech/Physics/Weather_Control_Machine)


				Engineering
					icon = 'tech_tree_buttons_engineering.dmi'
					icon_state = "engineering"
					tech_repeatable = 0
					tech_tree = "Engineering"
					info_path = "tech_research_engineering"
					//tech_exp_gain = 0.333;
					tech_exp_gain = 3//10;
					info_name = "Engineering"
					needed_qp = 1
					desc = "Engineering, a vital catalyst for innovation, expertly applies scientific and mathematical principles to devise ingenious solutions to an array of complex challenges. As one delves into this intricate discipline, a veritable cornucopia of diverse subfields materializes, spanning the realms of civil, electrical, aerospace, and beyond. The pursuit of engineering research yields the invaluable benefits of pioneering technologies and bolstered infrastructure, resulting in a heightened level of efficiency and resilience. This ceaseless quest for knowledge fosters sustainable development and drives progress across myriad domains, ultimately refining and advancing the integration of engineering marvels into diverse environments and systems."
					hud_y = 628//292
					hud_x = 136
					New()
						/*
						var/obj/bar = new
						bar.icon = 'tech_tree_bar.dmi'
						bar.icon_state = "100"
						bar.plane = 22
						bar.layer = 40
						bar.pixel_x = -22
						bar.blend_mode = BLEND_INSET_OVERLAY
						src.vis_contents += bar
						src.xp_bar = bar
						*/

						var/matrix/m = matrix()
						m.Translate(src.hud_x,src.hud_y)
						src.transform = m

						category = list("Primary Research")
						tag = name
						//tech_give = list(/obj/items/tech/Defibrillator)
						tech_give_txt = "Mining, Material Theories, Aerospace Theories, Mechantropic Theory"

						var/image/over = image('tech_tree_buttons_over.dmi',src,"hover",100)
						over.pixel_x = -1
						over.pixel_y = -1
						src.img_over = over
						src.needed_qp = 1
						..()
					Shovels
						info_name = "Shovels"
						icon_state = "main"
						tech_repeatable = 0
						hud_x = 15
						hud_y = 574//238
						tech_give_txt = "Shovels"
						tech_needed_txt = "Mining"
						needed_qp = 500
						tech_give = list(/obj/items/tech/digging/Shovel)

						New()
							..()
							needed_qp = 500
							tech_give = list(/obj/items/tech/digging/Shovel)
							//tech_prerequisites = list(/obj/items/tech/sub_tech/Engineering/Mining)





					Hand_Drill
						info_name = "Hand_Drill"
						icon_state = "main"
						tech_repeatable = 0
						hud_x = 15
						hud_y = 536//200
						tech_give_txt = "Hand Drills"
						needed_qp = 1200
						tech_needed_txt = "Resource Extractions, Shovels"
						tech_give = list(/obj/items/tech/digging/Hand_Drill)

						New()
							..()
							needed_qp = 1200
						//	tech_prerequisites = list(/obj/items/tech/sub_tech/Engineering/Resource_Extractions,/obj/items/tech/sub_tech/Engineering/Shovels)
							tech_give = list(/obj/items/tech/digging/Hand_Drill)

					Super_Drill
						info_name = "Super_Drill"
						icon_state = "main"
						tech_repeatable = 0
						hud_x = 15
						hud_y = 498//200
						tech_give_txt = "Super Drills"
						needed_qp = 2000
						tech_needed_txt = "Advanced Resource Extractions, Hand Drill"
						tech_give = list(/obj/items/tech/digging/Super_Drill)

						New()
							..()
							needed_qp = 2000
							tech_give = list(/obj/items/tech/digging/Super_Drill)
							//tech_prerequisites = list(/obj/items/tech/sub_tech/Engineering/Advanced_Resource_Extractions,/obj/items/tech/sub_tech/Engineering/Hand_Drill)

					Mining
						info_name = "Mining"
						icon_state = "main"
						tech_repeatable = 0
						hud_x = 46
						hud_y = 574//238
						needed_qp = 500
						desc = "Mining, an indispensable component in resource extraction, employs sophisticated techniques and state-of-the-art technologies to delve into the planet's depths, unearthing precious minerals and geological treasures. As an interdisciplinary field, mining encompasses geochemistry, geophysics, and geomechanics, fostering comprehensive understanding of complex subterranean processes. Research in mining propels advancements in excavation methods, ore processing, and environmental remediation, optimizing the sustainability and efficiency of operations. By unlocking resources vital for technological innovation and infrastructural development, mining research contributes to a flourishing ecosystem of ingenuity and progress, expanding the horizons of possibility across multifarious domains, fostering resilience and adaptability in the face of ever-evolving challenges."
						tech_give_txt = "Leads to Resource Extractions"
						tech_needed_txt = "Engineering"
						New()
							..()
							needed_qp = 500
							tech_prerequisites = list(/obj/items/tech/sub_tech/Engineering)

					Advanced_Resource_Extractions
						info_name = "Advanced_Resource_Extractions"
						icon_state = "main"
						tech_repeatable = 0
						hud_x = 46
						hud_y = 498//162
						needed_qp = 2000
						tech_give_txt = "Leads to Automated Drill Towers"
						tech_needed_txt = "Resource Extractions"
						New()
							..()
							needed_qp = 2000
							tech_prerequisites = list(/obj/items/tech/sub_tech/Engineering/Resource_Extractions)

					Resource_Extractions
						info_name = "Resource_Extractions"
						icon_state = "main"
						tech_repeatable = 0
						hud_x = 46
						hud_y = 536//200
						needed_qp = 1200
						tech_needed_txt = "Mining"
						New()
							..()
							needed_qp = 1200
							tech_prerequisites = list(/obj/items/tech/sub_tech/Engineering/Mining)

					Automated_Drill_Towers
						info_name = "Automated_Drill_Towers"
						tech_give = list(/obj/items/tech/Automated_Drill_Tower)
						tech_give_txt = "Automated Drill Towers"
						tech_repeatable = 0
						tech_give_txt = "Buildable Automated Drill Towers"
						tech_needed_txt = "Advanced Resource Extractions"
						hud_x = 15
						hud_y = 498//162
						New()
							tech_prerequisites = list(/obj/items/tech/sub_tech/Engineering/Advanced_Resource_Extractions)
					Material_Theories
						info_name = "Material_Theories"
						icon_state = "material theories"
						tech_repeatable = 0
						hud_x = 121
						hud_y = 574//238
						needed_qp = 100
						tech_needed_txt = "Engineering"
						New()
							..()
							needed_qp = 100
							tech_prerequisites = list(/obj/items/tech/sub_tech/Engineering)

					Molecular_Engineering
						info_name = "Molecular_Engineering"
						icon_state = "main"
						tech_repeatable = 0
						hud_x = 90
						hud_y = 575//170
						needed_qp = 200
						tech_needed_txt = "Material Theories, Structural Engineering"
						New()
							..()
							needed_qp = 200
							tech_prerequisites = list(/obj/items/tech/sub_tech/Engineering/Material_Theories,/obj/items/tech/sub_tech/Engineering/Structural_Engineering)
					/*Bed_Rolls
						info_name = "Bed Rolls"
						icon_state = "material theories"
						tech_repeatable = 0
						hud_x = 121
						hud_y = 574//238
						needed_qp = 20
						tech_needed_txt = "Engineering"
						New()
							..()
							needed_qp = 20
							tech_give = list(/obj/items/tech/Bed_Roll)
							*/
					Weights
						tech_repeatable = 0
						info_name = "Weights"
						icon_state = "main"
						hud_x = 121
						hud_y = 506//238
						needed_qp = 300
						tech_needed_txt = "Material Theories, Structural Engineering, Molecular_Engineering"
						tech_give_txt = "Wrist Weights, Ankle Weights, Arm Weights, Leg Weights"
						tech_give = list(/obj/items/tech/weights/kid_wrist_bands,/obj/items/tech/weights/kid_ankle_bands,/obj/items/tech/weights/kid_arm_bands,/obj/items/tech/weights/kid_leg_bands,/obj/items/tech/weights/wrist_bands,/obj/items/tech/weights/ankle_bands,/obj/items/tech/weights/arm_bands,/obj/items/tech/weights/leg_bands)

						New()
							..()
							needed_qp = 300
							tech_give = list(/obj/items/tech/weights/kid_wrist_bands,/obj/items/tech/weights/kid_ankle_bands,/obj/items/tech/weights/kid_arm_bands,/obj/items/tech/weights/kid_leg_bands,/obj/items/tech/weights/wrist_bands,/obj/items/tech/weights/ankle_bands,/obj/items/tech/weights/arm_bands,/obj/items/tech/weights/leg_bands)
						//	tech_prerequisites = list(/obj/items/tech/sub_tech/Engineering/Material_Theories,/obj/items/tech/sub_tech/Engineering/Structural_Engineering,/obj/items/tech/sub_tech/Engineering/Molecular_Engineering)

					Water_Purifier
						tech_repeatable = 0
						info_name = "Water Purifier"
						icon_state = "main"
						hud_x = 140
						needed_qp = 20
						tech_needed_txt = "Material Theories, Structural Engineering"
						tech_give_txt = "Water Purifier"
						hud_y = 541//205
						tech_give = list(/obj/items/tech/Water_Purifier)
						New()
							..()
							needed_qp = 20
							tech_give = list(/obj/items/tech/Water_Purifier)
							//tech_prerequisites = list(/obj/items/tech/sub_tech/Engineering/Material_Theories,/obj/items/tech/sub_tech/Engineering/Structural_Engineering)

					Armors
						tech_repeatable = 0
						info_name = "Armors"
						icon_state = "main"
						hud_x = 140
						needed_qp = 100
						tech_needed_txt = "Material Theories, Structural Engineering"
						tech_give_txt = "Saiyan Style Armor, Alien Style Armor, Basic Style Armor"
						hud_y = 541//205
						tech_give = list(/obj/items/tech/armors/Kid_Saiyan_Armor_Full,/obj/items/tech/armors/Kid_Saiyan_Armor_Shoulderless,/obj/items/tech/armors/Kid_Saiyan_Armor_Single_Shoulder,/obj/items/tech/armors/Kid_Saiyan_Armor,/obj/items/tech/armors/Kid_Alien_Armor,/obj/items/tech/armors/Kid_Basic_Armor,/obj/items/tech/armors/Saiyan_Armor_Full,/obj/items/tech/armors/Saiyan_Armor_Shoulderless,/obj/items/tech/armors/Saiyan_Armor_Single_Shoulder,/obj/items/tech/armors/Saiyan_Armor,/obj/items/tech/armors/Alien_Armor,/obj/items/tech/armors/Basic_Armor)
						New()
							..()
							needed_qp = 100
							tech_give = list(/obj/items/tech/armors/Kid_Saiyan_Armor_Full,/obj/items/tech/armors/Kid_Saiyan_Armor_Shoulderless,/obj/items/tech/armors/Kid_Saiyan_Armor_Single_Shoulder,/obj/items/tech/armors/Kid_Saiyan_Armor,/obj/items/tech/armors/Kid_Alien_Armor,/obj/items/tech/armors/Kid_Basic_Armor,/obj/items/tech/armors/Saiyan_Armor_Full,/obj/items/tech/armors/Saiyan_Armor_Shoulderless,/obj/items/tech/armors/Saiyan_Armor_Single_Shoulder,/obj/items/tech/armors/Saiyan_Armor,/obj/items/tech/armors/Alien_Armor,/obj/items/tech/armors/Basic_Armor)
							//tech_prerequisites = list(/obj/items/tech/sub_tech/Engineering/Material_Theories,/obj/items/tech/sub_tech/Engineering/Structural_Engineering)
					Battle_Hammers
						tech_repeatable = 0
						info_name = "Battle Hammers"
						icon_state = "main"
						hud_x = 102
						hud_y = 541//205
						needed_qp = 400
						tech_needed_txt = "Material Theories, Structural Engineering"
						tech_give_txt = "Battle Hammers"
						tech_give = list(/obj/items/tech/weapons/Battle_Hammer)
						New()
							..()
							needed_qp = 400
							tech_give = list(/obj/items/tech/weapons/Battle_Hammer)
					Battle_Axes
						tech_repeatable = 0
						info_name = "Battle Axes"
						icon_state = "main"
						hud_x = 102
						hud_y = 541//205
						needed_qp = 400
						tech_needed_txt = "Material Theories, Structural Engineering"
						tech_give_txt = "Battle Axes"
						tech_give = list(/obj/items/tech/weapons/Battle_Axe)
						New()
							..()
							needed_qp = 400
							tech_give = list(/obj/items/tech/weapons/Battle_Axe)
					Swords
						tech_repeatable = 0
						info_name = "Swords"
						icon_state = "main"
						hud_x = 102
						hud_y = 541//205
						needed_qp = 400
						tech_needed_txt = "Material Theories, Structural Engineering"
						tech_give_txt = "Swords"
						tech_give = list(/obj/items/tech/weapons/Kid_Sword,/obj/items/tech/weapons/Sword)
						New()
							..()
							needed_qp = 400
							tech_give = list(/obj/items/tech/weapons/Kid_Sword,/obj/items/tech/weapons/Sword)
						//	tech_prerequisites = list(/obj/items/tech/sub_tech/Engineering/Material_Theories,/obj/items/tech/sub_tech/Engineering/Structural_Engineering)

					Structural_Engineering
						tech_repeatable = 1
						info_name = "Structural_Engineering"
						icon_state = "structural engineering"
						hud_x = 152
						hud_y = 574//238
						needed_qp = 20
						tech_needed_txt = "Material Theories"

						New()
							..()
							needed_qp = 20
							tech_prerequisites = list(/obj/items/tech/sub_tech/Engineering/Material_Theories)

					Mechatronics_Theory //Theory of robotics, electronics, ect.
						info_name = "Mechatronics_Theory"
						icon_state = "main"
						tech_repeatable = 0
						hud_x = 390
						hud_y = 574//238
						needed_qp = 5000
						tech_needed_txt = "Engineering"
						New()
							..()
							needed_qp = 5000
							tech_prerequisites = list(/obj/items/tech/sub_tech/Engineering)

					Robotics
						tech_repeatable = 0
						info_name = "Robotics"
						icon_state = "main"
						hud_x = 371
						hud_y = 532//196
						needed_qp = 16000
						tech_needed_txt = "Mechatronics Theory, Parts Passive Perk"
						tech_give = list(/obj/items/tech/Mining_Bot,/obj/items/tech/Upgrade_Kit)
						New()
							..()
							needed_qp = 16000
							tech_give = list(/obj/items/tech/Mining_Bot,/obj/items/tech/Upgrade_Kit)
							tech_prerequisites = list(/obj/items/tech/sub_tech/Engineering/Mechatronics_Theory)

					Cybernetics
						tech_repeatable = 0
						info_name = "Cybernetics"
						hud_x = 403
						needed_qp = 5
						hud_y = 532//196
						tech_needed_txt = "Mechatronics Theory, Cyborg Passive Perk"
						tech_give = list(/obj/items/tech/Cybertech)
						New()
							..()
							needed_qp = 24000
							tech_give = list(/obj/items/tech/Cybertech)
							tech_prerequisites = list(/obj/items/tech/sub_tech/Engineering/Mechatronics_Theory)

					Artifical_Inteligence
						info_name = "Artifical_Inteligence"
						tech_repeatable = 0
						hud_x = 371
						hud_y = 499//163
						needed_qp = 250
						tech_needed_txt = "Robotics, Androids Passive Perk"
						tech_give_txt = "Creation of Androids, and Security Doors"
						tech_give = list(/obj/items/tech/doors/Security_Door_MKI)
						New()
							..()
							needed_qp = 28000
							tech_give = list(/obj/items/tech/doors/Security_Door_MKI)
							tech_prerequisites = list(/obj/items/tech/sub_tech/Engineering/Robotics)


					Aerospace_Theories //Spaceship stuff
						info_name = "Aerospace_Theories"
						tech_repeatable = 0
						hud_x = 226
						hud_y = 574//238
						needed_qp = 22000
						tech_needed_txt = "Engineering"
						New()
							..()
							needed_qp = 22000
							tech_prerequisites = list(/obj/items/tech/sub_tech/Engineering)

					Spacecraft_Hulls
						info_name = "Spacecraft_Hulls"
						tech_repeatable = 0
						hud_x = 226
						hud_y = 529//193
						needed_qp = 1600
						tech_needed_txt = "Aerospace Theories, Spacecraft Propulsion"
						tech_give_txt = "Pod Control"
						tech_give = list(/obj/items/tech/Pod_Control)
						New()
							..()
							needed_qp = 1600
							tech_give = list(/obj/items/tech/Pod_Control)
							//tech_prerequisites = list(/obj/items/tech/sub_tech/Engineering/Aerospace_Theories,/obj/items/tech/sub_tech/Engineering/Spacecraft_Propulsion)

					Spacecraft_Propulsion
						info_name = "Spacecraft_Propulsion"
						tech_repeatable = 0
						hud_x = 196
						hud_y = 529//193
						needed_qp = 5000
						tech_needed_txt = "Aerospace Theories"
						tech_give_txt = "Leads to Spacecraft Hulls"
						New()
							..()
							needed_qp = 5000
							tech_prerequisites = list(/obj/items/tech/sub_tech/Engineering/Aerospace_Theories)

					Spacecraft_Enviromentals
						info_name = "Spacecraft_Enviromentals"
						tech_repeatable = 0
						hud_x = 256
						hud_y = 529//193
						needed_qp = 1600
						tech_needed_txt = "Aerospace Theories, Spacecraft Hulls"
						tech_give_txt = "Aero Installed Punching Bags, Aero Installed Gravitron"
						New()
							..()
							needed_qp = 1600
							tech_prerequisites = list(/obj/items/tech/sub_tech/Engineering/Aerospace_Theories,/obj/items/tech/sub_tech/Engineering/Spacecraft_Hulls)

					Space_Pods
						info_name = "Space_Pods"
						tech_repeatable = 0
						hud_x = 226
						hud_y = 484//148
						tech_needed_txt = "Spacecraft Hulls"
						tech_give_txt = "Space Pods"
						needed_qp = 1600
						tech_give = list(/obj/items/tech/Space_Pod)
						New()
							..()
							needed_qp = 1600
							tech_give = list(/obj/items/tech/Space_Pod)
							//tech_prerequisites = list(/obj/items/tech/sub_tech/Engineering/Spacecraft_Hulls,/obj/items/tech/sub_tech/Engineering/Spacecraft_Enviromentals,/obj/items/tech/sub_tech/Engineering/Spacecraft_Propulsion)

					Space_Ships
						tech_give_txt = "Ships"
						info_name = "Space_Ships"
						tech_repeatable = 0
						hud_x = 226
						hud_y = 448//112
						needed_qp = 5000
						//tech_needed_txt = "Space Pods, Spacecraft Enviornmentals"
						tech_give_txt = "C.C. Ships, Deluxe Ships, Namekian Ships"
						tech_give = list(/obj/items/tech/ships/CC_Ship,/obj/items/tech/ships/Deluxe_Ship,/obj/items/tech/ships/Namekian_Ship)
						New()
							..()
							needed_qp = 5000
							tech_give = list(/obj/items/tech/ships/CC_Ship,/obj/items/tech/ships/Deluxe_Ship,/obj/items/tech/ships/Namekian_Ship)
							//tech_prerequisites = list(/obj/items/tech/sub_tech/Engineering/Space_Pods)

					Storage_Theories
						info_name = "Storage_Theories"
						tech_repeatable = 0
						hud_x = 327
						hud_y = 574//238
						needed_qp = 1400
						//tech_needed_txt = "Engineering"
						New()
							..()
						//	needed_qp = 8000
							//tech_prerequisites = list(/obj/items/tech/sub_tech/Engineering)
							needed_qp = 1400
					Basic_Storage
						info_name = "Basic_Storage"
						tech_repeatable = 0
						hud_x = 327
						hud_y = 541//205
						needed_qp = 1400
					//	tech_needed_txt = "Storage Theories"
						New()
							..()
							needed_qp = 1400
							//tech_prerequisites = list(/obj/items/tech/sub_tech/Engineering/Storage_Theories)

					Refridgerators
						info_name = "Refridgerators"
						tech_repeatable = 0
						hud_x = 327
						hud_y = 508//172
						//tech_needed_txt = "Basic Storage"
						tech_give_txt = "Refridgerator, Mini Refridgerator"
						needed_qp = 1400
						tech_give = list(/obj/items/tech/Refridgerator,/obj/items/tech/Mini_Refridgerator)
						New()
							..()
							needed_qp = 1400
							tech_give = list(/obj/items/tech/Refridgerator,/obj/items/tech/Mini_Refridgerator)
							//tech_prerequisites = list(/obj/items/tech/sub_tech/Engineering/Basic_Storage)

					Locators
						tech_give = list(/obj/items/tech/Locator)
						info_name = "Locator"
						tech_repeatable = 0
						hud_x = 300
						hud_y = 508//172
						needed_qp = 1200
						//tech_needed_txt = "Basic Storage"
						New()
							..()
							needed_qp = 1200
							tech_give = list(/obj/items/tech/Locator)
							//tech_prerequisites = list(/obj/items/tech/sub_tech/Engineering/Refridgerators)

					Capsules
						tech_give = list(/obj/items/tech/Capsule)
						info_name = "Capsules"
						tech_repeatable = 0
						hud_x = 300
						hud_y = 508//172
						needed_qp = 1400
						//tech_needed_txt = "Basic Storage"
						New()
							..()
							needed_qp = 1400
							tech_give = list(/obj/items/tech/Capsule)
							//tech_prerequisites = list(/obj/items/tech/sub_tech/Engineering/Refridgerators)

			Drug_Synthesization
				icon = 'drugs.dmi'
				icon_state = "pills"
				info_name = "Drug_Synthesization"
				mouse_over_pointer = MOUSE_ACTIVE_POINTER
				value = 100000
				desc = ""
				stacks = 1
				tech_tree = "Genetics"
				tech_subtech = "Drug Synthesis"
				tech_parent_path = /obj/items/tech/sub_tech/Genetics/Drug_Synthesis
				tech_upgradable = 1
				has_subtech = 1
				Click()
					..()
					for(var/obj/items/tech/sub_tech/Genetics/Drug_Synthesis/DS in global.tech)//usr.technology_researched)
						if(usr.tech_unlocked[DS.list_pos] == DS.type)
							src.tech_lvl = usr.tech_lvls[DS.list_pos]//DS.tech_lvl
							break


			Cybertech
				icon = 'bodybits.dmi'
				icon_state = "cybertech"
				info_name = "Cybertech"
				mouse_over_pointer = MOUSE_ACTIVE_POINTER
				value = 1000000
				desc = ""
				stacks = -1
				tech_tree = "Engineering"
				tech_subtech = "Cybernetics"
				tech_parent_path = /obj/items/tech/sub_tech/Engineering/Cybernetics
				tech_upgradable = 1
				has_subtech = 1
				Click()
					..()
					if(usr.client) usr << output(null,"tech_customization.grid_type")
					var/techs = 0
					for(var/obj/O in cybertech)
						if(usr.client) usr << output(O,"tech_customization.grid_type:[++techs]")
					if(usr.client) winset(usr, "tech_customization.grid_type", "cells=\"[techs]\"")
			ships/CC_Ship
				info_name = "CC_Ship"
				icon = 'CCShipG (1).dmi'
				icon_state = "Open"
			//	pixel_x = -250
			//	pixel_y = -200
				hp = 1000
				layer = 3
				fuel = 100
				bolted = 2
				hashadow = 0
				capsule_storable = 1
				density_factor = 1
				needs_to_be_active = 1
				weight = 10
				bounds = "36,59 to 61,22"
				mystille_cost=1200
				titanium_cost=6800
				coal_cost=1500
				copper_cost=4000
				stone_cost=6000
				mouse_over_pointer = MOUSE_ACTIVE_POINTER
				tech_parent_path = /obj/items/tech/sub_tech/Engineering/Space_Ships
				var/obj/effects/Space_Ship_Aura/ShipAura = new
				value = 1000
				can_pocket = 0
				density_factor = 1
				weight = 100
				desc = "Drills operate much faster than other tools, and faster still than digging with bare hands. The amount dug up by these compared to basic digging is thrice times."
				tech_tree = "Engineering"
				tech_subtech = "Space Ships"
				has_subtech = 0
				appearance_flags = KEEP_TOGETHER
				active = 0
				var/list/inside_items = list()
				var/tmp/deferred_init = 0
				var/tmp/initialized = 0
				obj/items/tech/ships

				//Move(oldloc, dir)
					//..()
					//if(src.deferred_init && isturf(src.loc))
						//src.InitializeShip()

				New(var/bought_ship=0)
					category = list("Spacecraft")
					var/image/sel = image('fx.dmi',src,"select item",1000)
					src.img_select = sel
					..()

					// If it's being created inside an inventory/capsule/container, defer init.
					if(!isturf(src.loc))
						src.deferred_init = 1
						return

					// If it was placed directly on a turf, initialize immediately.
					src.InitializeShip()


				proc/InitializeShip()
					//if(initialized) return
					if(initialized && established)
						if(!isturf(entry_location) && panel)
							entry_location = locate(panel.savedX, panel.savedY - 1, panel.savedZ)
						return
					if(!isturf(src.loc)) return

					initialized = 1
					deferred_init = 0

				    // Generate ID etc (or skip ship_id entirely if you don't truly use it)
					src.ship_id = generate_ship_id()
					if(!src.ship_id) return

					var/obj/items/tech/Ship_Controls/C = src.find_ship_control()
					if(!C)
						if(src.panel && src.interior_z)
							src.entry_location = locate(src.panel.savedX, src.panel.savedY - 1, src.panel.savedZ)
							src.exit = get_turf(src)
							src.entrance = src.entry_location
							return
						else
							return


					src.interior_z = C.z
					src.panel = C
					C.claimed = 1
					C.ship_ref = src

					src.entry_location = locate(C.x, C.y - 1, C.z)
					src.signature_number = generate_signature()

					if(!isturf(src.entry_location))
						src.entry_location = locate(3, 34, src.interior_z)

					src.name = "CC Ship #[signature_number]"
					src.tag = C.tag

					C.savedX = C.x
					C.savedY = C.y
					C.savedZ = C.z

				    // IMPORTANT: exit must be the ship’s turf
					src.exit = get_turf(src)
					src.entrance = src.entry_location

					src.ProcessNewShipObjects()

				/*var

					landing = 0
					ship_id = 0
					established = 0
					started=0

					tmp/gravity_on=0
					tmp/setgrav = 0
					var/entry_location
					tmp/mob/pilot = null
					tmp/obj/tele = null
					obj/items/tech/Ship_Controls/panel
					obj/Door
					instance_id // Unique ID per ship
					interior_z // Z-level where the ship interior exists
					launched = 0
					tmp/manualtravel = 0
					tmp/autotravel = 0*/


				Del()
					for(var/mob/m in orange(60,src.panel.ship_ref))
						if(m.z == src.interior_z)

							m.letgo()

							m.loc=locate(src.panel.ship_ref.x,src.panel.ship_ref.y,src.panel.ship_ref.z)
							m.in_space_ship = 0
							if(m.z == 16 ) m.apply_space_glow(1)
							m.dir=SOUTH
						//	pilot.reset_view()
							m.client.eye=usr
							m.client.perspective=EYE_PERSPECTIVE
							m.client.perspective=MOB_PERSPECTIVE
					..()
				Click(location,control,params)
					..()
					if(usr.left_click_function != "capsule")
						params = params2list(params)
						if(params["left"])
							if(usr.left_click_function != "capsule")
								if(usr.looking_out_ship == 1)
									usr.client.eye = usr
									usr.client.perspective=EYE_PERSPECTIVE
									usr.client.perspective=MOB_PERSPECTIVE
									usr.looking_out_ship = 0
									if(src.panel.pilot)
										src.panel.pilot = null
										src.pilot = null
									if(src.panel.launched) src.panel.launched = 0
									if(src.panel.manualtravel) src.panel.manualtravel = 0


									usr.apply_space_glow(0)
							/*else if(src.icon_state=="Open")
								src.icon_state="Closed"
							else
								src.icon_state="Open"
								src.started=1
								sleep(2)
								//if(src.established == 0 && src.started ==1)
								//	src.CreateShipInstance()

								usr.loc = src.entry_location
								usr.in_space_ship = 1*/



				Bump(mob/m)
					if(m && m.client)
						m.loc = src.entry_location


				/*New(var/bought_ship=0)


					if(ismob(loc) && bought_ship == 0) return // Don't activate from inventory

					category = list("Spacecraft")
					var/image/sel = image('fx.dmi',src,"select item",1000)
					src.img_select = sel
					..()
					if(!isturf(loc) && bought_ship == 0 ) return
					// Generate a unique ship ID (small number used in tag)
					src.ship_id = generate_ship_id()
					if (!src.ship_id)
						return // avoid proceeding if ID failed

					// Attempt to find a ship panel with a matching tag
					var/obj/items/tech/Ship_Controls/C = find_ship_control(src.ship_id)

					if (!C)
						//world << "[src]: ERROR - No matching Ship Control tag found for ID #[src.ship_id]!"
						return

					src.interior_z = C.z
					src.panel = C
					C.claimed = 1
					C.ship_ref = src

					src.entry_location = locate(C.x, C.y - 1, C.z)
					src.signature_number = generate_signature()
					if (!isturf(src.entry_location))
						//world << "[src]: WARNING - entry_location not a turf! Using fallback."
						src.entry_location = locate(3, 34, src.interior_z)

					// Set name and tag using panel info
					src.name = "CC Ship #[signature_number]"
					src.tag = C.tag

					// Save panel positions
					C.savedX = C.x
					C.savedY = C.y
					C.savedZ = C.z

					// Assign entrance/exit
					src.exit = src.loc
					src.entrance = src.entry_location

					// Register interior objects like doors, controls, etc.
					src.ProcessNewShipObjects()*/

				proc/find_ship_control()
					for (var/obj/items/tech/Ship_Controls/C in world)
						if (!C.tag) continue
						if (findtext(C.tag, "shipinside_door") && !C.claimed)
						//	world << "Found control: [C.tag]"
							return C
					return null

				proc/ProcessNewShipObjects()
					set background = 1
					for (var/obj/O in world)
						if(O.insideofaship) continue
						if (O.z != src.interior_z) continue
						if (!O) continue
						//O.ship_ref = src
						O.tag = "[src.name]" // Optional for future tracking
						O.insideofaship = 1
						if (istype(O, /obj/items/tech/doors/Security_Ship_Doors))
							src.entry_location = locate(O.x, O.y - 1, O.z)
							src.established = 1
							src.Door = O
							O.ship_ref = src
							O.exit = locate(src.x + 4, src.y - 4, src.z)
							O.entrance = src.entry_location

						if (istype(O, /obj/items/tech/Ship_Controls))
							O.ship_ref = src
							O.ship_view = locate(src.x + 4, src.y, src.z)
							O.savedX = O.x
							O.savedY = O.y
							O.savedZ = O.z
							O.level = src.level
							src.panel = O

						//items += O
				proc
					generate_signature()
						return rand(100000,999999)


				proc
					copy_interior_cc()
						var/turf/start = locate(1,1,15) // Base ship template start
						var/turf/end = locate(57,36,15) // was org 80,80, 15Base ship template end

						world << "Start: [start] ([start.x],[start.y],[start.z])"
						world << "End: [end] ([end.x],[end.y],[end.z])"
						var/list/L = block(start, end)
						world << "Block size: [L.len]"
						//world<<"Interior Start Made."
						for(var/turf/T in block(start,end))
							var/turf/newT = new T.type(locate(T.x, T.y, src.interior_z))
							//world<<"Interior 2 Process."
							for(var/obj/O in T)
								if(O)
								//	world<<"Interior 3 Made."
									var/obj/newO = new O.type(locate(O.x, O.y, src.interior_z))
									//if(istype(newO,/obj/items/tech/))
									if(istype(newO, /obj/items/tech/doors/Security_Ship_Doors))
									//	world<<"Ship Door Made."
										entry_location = locate(O.x,O.y-1,interior_z)
										src.established = 1
										src.Door = newO
										newO.ship_ref = src
										newO.exit = locate(src.x+4,src.y-4,src.z)
										newO.entrance = locate(O.x,O.y-1,interior_z)
									if(istype(newO,/obj/items/tech/Ship_Controls))
									//	world<<"Ship Controls  Made."
										newO.ship_view = locate(src.x+4,src.y,src.z)
										newO.ship_ref = src
										src.panel = newO
										newO.savedX = newO.x
										newO.savedY = newO.y
										newO.savedZ = newO.z

									newO.tag = "[src.name]"
									//newO.Bolted = 1
									items += newO
								//	world<<"[newO] in Ship  and saved Made."
									//items += newO

							newT.tag = "[src.name]"
							items += newT
							//world<<"[newT] in Ship  and saved Made."
							//items += newT

							//items += newT
					//	world<<"(Ship Initiating.........)"
						src.CreateShipInstance()
					//	world<<"(Ship Initiated)"

					copy_interior()
						//set background = 1
						var/turf/start = locate(1,1,15) // Base ship template start
						var/turf/end = locate(57,36,15) // was org 80,80, 15Base ship template end

						for(var/turf/T in block(start, end))
							var/turf/newT = new T.type(locate(T.x, T.y, interior_z))

							for(var/obj/O in T)
								var/obj/newO = new O.type(locate(O.x, O.y, interior_z))
								if(istype(newO,/obj/items/tech/doors/Security_Ship_Doors))
									entry_location = locate(O.x,O.y-1,interior_z)
									src.established = 1
									src.Door = newO
									newO.ship_ref = src
									newO.exit = locate(src.x+4,src.y-4,src.z)
									newO.entrance = locate(O.x,O.y-1,interior_z)
								if(istype(newO,/obj/items/tech/Ship_Controls))
									newO.ship_view = locate(src.x+4,src.y,src.z)
									newO.ship_ref = src
									src.panel = newO

								newO.tag = "[src.name]"
								newO.bolted = 2
								items += newO

							newT.tag = "[src.name]"
							//items += newT

							//items += newT

						for(var/mob/m in world)
							m.set_alert("Interior Z: [interior_z](Confirmed:[entry_location])",'alert.dmi',"alert")

					allocate_ship_z(id)
						var/newz = 29 + (id % 72)
						for(var/obj/items/tech/ships/CC_Ship/s in items)
							if(newz == s.interior_z)
								id = regenerate_ship_id()
								newz = id
						return newz // Assigning a z-level dynamically

					generate_ship_id()
						var/list/used_ids = list()
						for(var/obj/items/tech/ships/CC_Ship/S in world)
							if(S)
								if(S.ship_id)
									used_ids |= S.ship_id // avoids duplicates

						for (var/i = 1 to 50)
							if (!(i in used_ids))
								return i

						world.log << "ERROR: All 50 ship IDs are used! Preventing infinite loop."
						return 0 // fail gracefully

					regenerate_ship_id()
						var/newid
						var/approved = 0
						while(approved == 0)
							newid = rand(100000,999999)
							for(var/obj/items/tech/ships/CC_Ship/s in items)
								if(newid != s.ship_id)
									approved =1
							sleep(30)
						return newid







				proc

					AllocateZLevel()
						for (var/z = starting_instance_z; z <= max_instance_z; z++)
							if (!(z in allocated_z_levels))
								allocated_z_levels += z
								return z
						return null  // No available Z-levels (handle this properly)

					CreateShipInstance()
						//if (ship_id in ship_instances)
						//	return ship_instances[ship_id]
						for(var/mob/m in world)
							//if(m.client)
							m.set_alert("Building Ship Interior...",'alert.dmi',"alert")
						var/obj/ship_interior_spawner/s = new /obj/ship_interior_spawner
						for(var/mob/m in world)
							//if(m.client)
							m.set_alert("Testing Allocation Z Level",'alert.dmi',"alert")
						var/zplane = AllocateZLevel()
						for(var/mob/m in world)
							m.set_alert("Testing Ship Instance Record.",'alert.dmi',"alert")
						//ship_instances[src.ship_id] = s
						//for(var/mob/m in world)
							//m.set_alert("Ship Instance Record Passed",'alert.dmi',"alert")
						/*if (world.Import("data/ship_interior/[ship_id].sav"))
							for(var/mob/m in world)
								m.set_alert("Test Prebuilt Ship Interior",'alert.dmi',"alert")
							LoadSavedShipInterior(s)
						else */
						s.loc = locate(24,11,zplane)
						for(var/mob/m in world)
							m.set_alert("Test Prebuilt Ship Interior",'alert.dmi',"alert")
						LoadPreBuiltShipInterior(s,"CC")
						src.established = 1
						for(var/mob/m in world)
							m.set_alert("Successfull Interior Build",'alert.dmi',"alert")

						//return ship_interior_spawner


			Gravitron
				name = "Gravitron"
				info_name = "Gravitron"
				icon = 'gravity_machine.dmi'
				hp = 1000000
				layer = 3
				bolted = 2
				hashadow = 0
				density_factor = 1
				cantStore=1
				weight = 10
				//bounds = "36,59 to 61,22"
				mystille_cost=4900
				titanium_cost=6800
				silver_cost = 8200
				gold_cost = 11200
				titanium_cost = 7900
				coal_cost=8900
				copper_cost=6200
				stone_cost=8800
				mouse_over_pointer = MOUSE_ACTIVE_POINTER
				tech_parent_path = /obj/items/tech/sub_tech/Engineering/Space_Ships
				value = 1000
				can_pocket = 0
				density_factor = 1
				weight = 100
				invul_melee = 1
				capsule_storable = 0
				desc = "Drills operate much faster than other tools, and faster still than digging with bare hands. The amount dug up by these compared to basic digging is thrice times."
				tech_tree = "Engineering"
				tech_subtech = "Space Ships"
				has_subtech = 0
				appearance_flags = KEEP_TOGETHER
				active = 0
				var/driving = 0
				var/has_gravitron = 0
				var/gravityon = 0

				var/max_gravity = 0
				var/current_gravity = 0

				proc
					calculate_max_gravity()
						return round(2 + (src.level * 0.05) * 1.5)

					apply_gravity(var/mob/m)
						if(m && !m.koed)
							m.grav = current_gravity
						//	m.check_quest("env_grav", 1, 1, 1)
							/*if(m.grav > m.gravity_mastered)
								var/DMG = (m.grav / m.gravity_mastered) / (1 + m.mod_immune_gravity)
								if(DMG > 0)
									m.percent_health -= DMG
									if(m.percent_health <= 0 && m.koed ==0)
										m.KO()*/

					activate_gravity(var/mob/m)
						current_gravity = input(m, "Set gravity level for this machine\n\nMax Gravity: [max_gravity]", "Gravitron", max_gravity) as num
						if(current_gravity>=max_gravity) current_gravity = max_gravity
						current_gravity = clamp(current_gravity, 1, max_gravity)
						gravityon = 1
						for(var/turf/t in range(60,src))
							t.grav = current_gravity
						for(var/mob/x in range(60, src))
							apply_gravity(x)
							if(m.grav>0) x.apply_gravity_glow(1,m.grav)
							//x.create_chat_entry("local","<font size= 0.3><center>[m.real_name] sets the Gravity to x[current_gravity]</center></font>",0,1)
							if(m.grav<0) x.apply_gravity_glow(0)
						src.ship_ref.gravity_on=1
						src.ship_ref.setgrav = current_gravity

					deactivate_gravity(var/mob/m)
						gravityon = 0
						for(var/turf/t in range(60,src))
							t.grav = initial(t.grav)
							if(t.grav !=0 ) t.grav = 0
						for(var/mob/x in range(60, src))
							x.grav = initial(x.grav)
							if(x.grav !=0 ) x.grav = 0
							//x.create_chat_entry("local","<center>[m.real_name] sets the Gravity to normal</center>",0,1)
							x.apply_gravity_glow(0)
						src.ship_ref.gravity_on=1
						src.ship_ref.setgrav = 0

				New()
					..()
					category = list("Gravitron")
					max_gravity = calculate_max_gravity()

				Click(location, control, params)
					..()
					params = params2list(params)
					if(params["left"])
						if(gravityon)
							deactivate_gravity(usr)
						else
							activate_gravity(usr)
					else if(params["right"])
						if(gravityon)
							deactivate_gravity(usr)
						else
							activate_gravity(usr)




						sleep(20)
			Ship_Controls
				name = "Ship Controls"
				info_name = "Ship_Controls"
				icon = 'item_ship_controls.dmi'
				hp = 10000000
				layer = 3
				fuel = 10
				bolted = 2
				hashadow = 0
				density_factor = 1
				weight = 10
				//bounds = "36,59 to 61,22"
				mystille_cost=1200
				titanium_cost=6800
				coal_cost=1500
				copper_cost=4000
				stone_cost=6000
				mouse_over_pointer = MOUSE_ACTIVE_POINTER
				tech_parent_path = /obj/items/tech/sub_tech/Engineering/Space_Ships
				value = 1000
				can_pocket = 0
				density_factor = 1
				weight = 100
				desc = "Drills operate much faster than other tools, and faster still than digging with bare hands. The amount dug up by these compared to basic digging is thrice times."
				tech_tree = "Engineering"
				tech_subtech = "Space Ships"
				has_subtech = 0
				appearance_flags = KEEP_TOGETHER
				active = 0


				var/list/known_locations = list("Random Exploration") // Default locations
				var/current_coordinates = null
				var/obj/items/Planets/Mains/autotravel_target = null
				var/launched = 0
				var/obj/effects/Space_Ship_Aura/ShipAura = new
				var/Speed = 8
				var/speed_ramp = 0
				var/speed_skip = 0
				var/obj/speed_effect
				var/sr
				var/driving = 0
				var/has_gravitron = 0
				var/obj/items/tech/Gravitron/gravtemplate = new()
				var
					landing = 0
					tmp/mob/pilot = null
					tmp/obj/tele = null
					tmp/autotravel = 0
					tmp/manualtravel = 0
					tmp/Travel = 0
					claimed = 0
				proc
					repair_prompt(var/mob/m,)
						if(m.intxp >= 1000) //m.race != "Tuffle" && m.race_class == "Technician" && m.race_class != "Namekian" && m.race_class!="Human" || m.race=="Tuffle"||m.race=="Namekian"||m.race =="Human")
							var/repairing = input("How much are you reparing? 1 titanium = 1 repair recovery\nYou currently have: [src.hp]% of space pod health") as num
							if(repairing == 0 ) return
							if(repairing <=-0) return
							if(m.titanium_count >= repairing)
								src.hp += repairing
								m.titanium_count -= repairing

								m << "Repaired the ship by [repairing]%"
							else
								m << "Not enough Titanium!"
								return
						else
							m << "You are not intelligent enough to upgrade.\nShips Health:[src.hp]%"
							return
					refuel_prompt(var/mob/m)

						for(var/obj/items/tech/Fuel/F in m)
							if(F)
								var/fueladd = input("Input the number to refuel\nYou currently have: [src.fuel]%") as num
								if(F.fuelamount >= fueladd && fueladd > 0)
									src.fuel += fueladd
									F.fuelamount -= fueladd
									if(F.fuelamount <= 0) F.destroy()
									m << "Added [fueladd] fuel to the Ship."
								else
									m << "Not enough fuel!"
									return


					locate_planet(destination)
						for(var/obj/items/Planets/Mains/P in world)
							if(P.name == destination)
								return P
						return null

					send_to_planet(var/destination)
						if(src.ship_ref)
							if(destination == "Namek")
								src.ship_ref.loc=locate(rand(2,489),rand(2,489),4)
							if(destination == "Earth")
								src.ship_ref.loc=locate(rand(2,489),rand(2,489),1)
							if(destination == "Vegeta")
								src.ship_ref.loc=locate(rand(2,489),rand(2,489),10)
							if(destination == "Icer")
								src.ship_ref.loc=locate(rand(2,489),rand(2,489),9)
							//if(pilot) pilot.loc = src.loc
							if(src.launched) src.launched=0
							//if(src.active) src.active =0
					HandleShipPlanetEntry(var/obj/items/Planets/Mains/P)
						if(!P || !src.ship_ref) return

						var/randomlocate

						if(P.name == "Vegeta")
							randomlocate = locate(rand(2,450),rand(2,450),10)

						if(P.name == "Earth")
							randomlocate = locate(rand(2,450),rand(2,450),1)

						if(P.name == "Namek")
							randomlocate = locate(rand(2,450),rand(2,450),4)

						if(P.name == "Icer")
							randomlocate = locate(rand(2,450),rand(2,450),9)

						if(!randomlocate) return

						// Move ship to planet surface
						src.ship_ref.loc = randomlocate

						// Move pilot if inside
						if(src.pilot)
							src.pilot.loc = randomlocate
							src.pilot.on_customplanet = P

							//spawn(1)
							//src.pilot.crash_landing(3)

							spawn(10)
							src.pilot.map_overlays()
						spawn(1)
							src.pilot.crash_landing(3)
							view(5,src.pilot)<<output("<b><u><font color=red>WARNING:</u> [P.name]'s gravity levels are at [P.setgrav]x</b>","actionoutput")
					begin_auto_travel(mob/m, destination)
						autotravel_target = locate_planet(destination)
						if(!autotravel_target)
							m << "Invalid destination."
							src.launched=0
							src.active=0
							return
						m.set_alert("Traveling to [destination]...",'alert.dmi',"alert")
						src.ship_ref.icon_state="Flight"
						var/pix_y = 0
						//	if(m.race == "Alien") pix_y = -16
						animate(src.ship_ref,pixel_y = 10, time = 20,loop = -1,flags = ANIMATION_PARALLEL + ANIMATION_END_NOW)
						animate(pixel_y = pix_y, time = 20)
						while(src && autotravel_target && hp > 0)
							//src.driving=1
							step_towards(src.ship_ref, autotravel_target)
						//	pilot.loc=src.loc
							hp -= 0.5


							if(get_dist(src.ship_ref,autotravel_target) < 8)
								// Physically move ship onto planet turf
								src.ship_ref.loc = autotravel_target.loc

								// Now manually trigger entry logic
								HandleShipPlanetEntry(autotravel_target)

								break
							if(src.ship_ref in autotravel_target.loc || src.ship_ref in orange(1,autotravel_target))
								src.ship_ref.loc = autotravel_target.loc

								// Now manually trigger entry logic
								HandleShipPlanetEntry(autotravel_target)

								break
							sleep(src.ship_ref.Speed)
						if(!autotravel_target || hp <= 0)
							m.set_alert("Travel interrupted, check your pod!",'alert.dmi',"alert")
							src.launched=0
						//	src.active=0
							return
						if(pilot) pilot.set_alert("Arrived at [destination].",'alert.dmi',"alert")
						src.ship_ref.icon_state=""
					//	src.overlays -= PodAura
						src.launched=0
						//src.active=0
						src.send_to_planet(destination) // Snap to destination
					//	pilot.apply_space_glow(0)
						sleep(2)
						//src.overlays -= /obj/effects/elec


					begin_free_travel(mob/m)
						if(!m) return
						m.stunned+=1
						src.pilot = m
						pilot.alpha = 0
						src.icon_state="Flight"
						src.autotravel = 0
						src.manualtravel = 1
						if(m && src.ship_ref != null)
							if(src.ship_ref.loc)
								m.set_view(src.ship_ref)
								m.looking_out_ship = 1
								if(src.ship_ref.z == 16)
									m.apply_space_glow(1)
							else
								m.set_alert("Error in finding ship!",'alert.dmi',"alert")

								return
						src.pilot.Ship = src.ship_ref
						var/pix_y = 0
						//	if(m.race == "Alien") pix_y = -16
						animate(src.ship_ref,pixel_y = 10, time = 20,loop = -1,flags = ANIMATION_PARALLEL + ANIMATION_END_NOW)
						animate(pixel_y = pix_y, time = 20)
						while(pilot == m && hp > 0)
							if(hp <= 0)
								m.set_alert("[src]: OV3RL0@D Repairs Needed!",'alert.dmi',"alert")
							//	m.create_chat_entry("alerts","Out of fuel! Drifting in space..")
								src.launched=0
								src.active=0
							sleep(src.Speed)
							//return


					launch(mob/m)
						if(launched) return

						if (current_coordinates == "Earth" && src.ship_ref.z == 1)
							usr.set_alert("[src]: Launch failed, you are already on Planet Earth!",'alert.dmi',"alert")
							return
						if (current_coordinates == "Vegeta" && src.ship_ref.z == 10)
							usr.set_alert("[src]: Launch failed, you are already on Planet Vegeta!",'alert.dmi',"alert")
							return
						if (current_coordinates == "Namek" && src.ship_ref.z == 3)
							usr.set_alert("[src]: Launch failed, you are already on Planet Namek!",'alert.dmi',"alert")
							return
						if (current_coordinates == "Icer" && src.ship_ref.z == 9)
							usr.set_alert("[src]: Launch failed, you are already on Planet Icer!",'alert.dmi',"alert")
							return
						if (current_coordinates != "Icer" && current_coordinates != "Earth" && current_coordinates != "Vegeta" && current_coordinates != "current_coordinates" && src.ship_ref.z == 13)
							usr.set_alert("[src]: Launch failed, you are already on [current_coordinates]!",'alert.dmi',"alert")
							return
						src.launched = 1
						var/LaunchTime = 10
						view(10,m) << output("<font color = white>[src] is preparing to launch in [LaunchTime] seconds", "actionoutput")
						//m.create_chat_entry("local","<font color = white>[src] is preparing to launch in [LaunchTime] seconds</font>",0,1)
						m.set_alert("[src] is preparing to launch in [LaunchTime] seconds",'alert.dmi',"alert")
						while (LaunchTime >= 4)
							sleep(10)
							spawn_smoke_effect(src.ship_ref, 4)
							LaunchTime--


						 // 10 seconds delay
					//	m.create_chat_entry("local","<font color = white>[src]: Blasting off in 3..</font>",0,1)
					//	view(10,m) << output("<font color = white>[src]: Blasting off in 3..", "chat.local")
						spawn_smoke_effect(src.ship_ref, 2)
						sleep(10)
						//m.create_chat_entry("local","<font color = white>[src]: 2..</font>",0,1)
						spawn_smoke_effect(src.ship_ref, 1)
						sleep(10)
					//	m.create_chat_entry("local","<font color = white>[src]: 1..</font>",0,1)
						sleep(10)
					//	m.create_chat_entry("local","<font color = white>[src]: BLAST OFF!</font>",0,1)
						animate(src.ship_ref, pixel_z = 155, time = 10)
						animate(src.ship_ref,transform = turn(matrix(), 1), time = 4)
					//	animate(pixel_z = 128, time = 6)
						animate(src.ship_ref,transform = turn(matrix(), -1), time = 4)

						src.active=1
						animate(src.ship_ref, pixel_z = 0, time = 1)
						animate(src.ship_ref,transform = turn(matrix(), 0), time = 1)
						if(m.onEarth) src.ship_ref.loc=locate(97,355,16)
						if(m.onNamek) src.ship_ref.loc=locate(467,367,16)
						if(m.onVegeta) src.ship_ref.loc=locate(451,89,16)
						if(m.onIcer) src.ship_ref.loc=locate(94,71,16)
						if (!ShipAura)
							ShipAura = new /obj/effects/Space_Ship_Aura
					//	src.overlays+=PodAura
					//	if(src.Speed >=0.8 && src.Speed <=1) src.overlays += /obj/effects/elec
						if(m.looking_out_ship) m.apply_space_glow(1)
						//src.loc = locate(src.x, src.y, 16) // Move to space Z-plane
						//m << "Launch successful! Entering space..."
						if(current_coordinates == "Random Exploration")
							current_coordinates = pick("Vegeta","Earth","Namek","Icer")
							//src.begin_free_travel(m)
							src.begin_auto_travel(m,current_coordinates)
							//src.begin_free_travel(m)
						else
							if(current_coordinates == null)
								current_coordinates = pick("Vegeta","Earth","Namek","Icer")
								//src.begin_free_travel(m)
								src.begin_auto_travel(m,current_coordinates)
							else
								src.begin_auto_travel(m, current_coordinates)



					set_coordinates(var/mob/m)
						var/location = input("Choose destination:", "Space Travel") as null|anything in known_locations
						if(!location) return
						current_coordinates = location
						m.set_alert("Coordinates set to [location].",'alert.dmi',"alert")
						view(10,m)<<output("[src.ship_ref] set coordinates to [location].","actionoutput")
						if(current_coordinates == "Random Exploration" && m.z == 16)
							current_coordinates = pick("Vegeta","Earth","Namek","Icer")
							//src.begin_free_travel(m)
							src.begin_auto_travel(m,current_coordinates)
						if(current_coordinates != "Random Exploration" && m.z == 16)
							src.begin_auto_travel(m,current_coordinates)

					look_outside(var/mob/m)
						if(m && src.ship_ref != null)
							if(src.ship_ref.loc)
								m.set_view(src.ship_ref)
								m.looking_out_ship = 1
								if(src.ship_ref.z == 16)
									m.apply_space_glow(1)
							else
								m.set_alert("Error in finding ship!",'alert.dmi',"alert")
								return
					lock(var/mob/m)
						if(src.ship_ref)
							if(src.ship_ref.locked == 0)
								src.ship_ref.icon_state = "Closed"
								src.ship_ref.locked = 1
								view(10,m)<<output("[src.ship_ref] was locked.","actionoutput")
								//for(var/mob/m in view(25,src))
							//		m.create_chat_entry("local","The doors were locked.",0,1)
								return
							if(src.ship_ref.locked == 1)
								src.ship_ref.icon_state = "Open"
								src.ship_ref.locked = 0
								view(10,m)<<output("[src.ship_ref] was unlocked.","actionoutput")
								//for(var/mob/m in view(25,src))
								//	m.create_chat_entry("local","The doors were unlocked.",0,1)
								return


					install_gravitron(var/mob/m,var/obj/items/tech/Gravitron/o)
						var/afford=1
						var/titanium_cost = src.titanium_cost //* val_multi
						var/mystille_cost = src.mystille_cost //* val_multi
						var/coal_cost = src.coal_cost //* val_multi
						var/gold_cost = src.gold_cost //* val_multi
						var/silver_cost = src.silver_cost //* val_multi
						var/copper_cost = src.copper_cost //* val_multi
						var/stone_cost = src.stone_cost //* val_multi
						var/required_metals = list(
							"Stone" = stone_cost,
							"Copper" = copper_cost,
							"Coal" = coal_cost,
							"Silver" = silver_cost,
							"Gold" = gold_cost,
							"Titanium" = titanium_cost,
							"Mystille" = mystille_cost,
						)
						for (var/material in required_metals)
							var/required_amount = required_metals[material]
							if (required_amount > 0) // Skip if no cost for this material
								var/inventory_amount = m.count_material(material)
								if (inventory_amount < required_amount)
									afford=0
									m << "You lack the required [material]! Needed: [required_amount], You have: [inventory_amount]."
									m.set_alert("You lack the required [material] needed: [required_amount], You have: [inventory_amount]",'alert.dmi',"alert")
									//m.create_chat_entry("alerts","You lack the required [material] needed: [required_amount], You have: [inventory_amount]")
									break
						/*if(m.key in StaffTeam)
							m.set_alert("Admin Pass: [o] created!",'alert.dmi',"alert")
						//	m.create_chat_entry("alerts","Admin Pass: [o] created!")
							afford = 1*/
						if(!afford) return
						var/lvltomake = input("Quality %:\nMax Quality: [m.intxp]%") as num
						if(lvltomake <=0 || lvltomake <=-0) return
						if(lvltomake >= m.intxp)
							m.set_alert("You cannot manifest tech of that quality",'alert.dmi',"alert")
						//	m.create_chat_entry("alerts","You cannot manifest tech of that quality!")
							return

					//	var/val = o.value*val_multi
					//	if(src.trait_ic) val/=2
						m.update_rsc()
						if(afford)
							src.has_gravitron=1
							for (var/material in required_metals)
								var/required_amount = required_metals[material]
								if (required_amount > 0)
									m.remove_material(material, required_amount)
							//var/obj/item = new o.type(src.loc)
							m.update_rsc()
							o.loc = src.loc
							o.weight = o.weight
							o.owner = m.real_name
							if(o.pixel_x > 0) o.step_x = abs(o.pixel_x)/2
							o.alpha = 100
							o.pixel_z = 32
							o.level = lvltomake
							o.tech_lvl = lvltomake
							//o.calculate_max_gravity()
							o.max_gravity = o.calculate_max_gravity()
							o.x += 1
							o.ship_ref = src.ship_ref
						//	item.tech_lvl = lvl
							animate(o, pixel_z = initial(o.pixel_z), alpha = 255,time = 2, easing = BOUNCE_EASING)
							//spawn(1)
							//	if(o) o.set_shadow()



				verb
					switch_ship_command(var/mob/m)
						var/list/commands = list("Launch","Set Coordinates","Look Outside","Lock/Unlock","Repair",)
						if(src.has_gravitron ==0) commands = list("Launch","Install Gravitron(Minerals Needed)","Set Coordinates","Look Outside","Lock/Unlock","Repair")
						var/command = input("Select a command:") as null|anything in commands
						if(command == "Set Coordinates") src.set_coordinates(m)
						else if(command == "Launch") src.launch(m)
						else if(command == "Repair") src.repair_prompt(m)
						else if (command == "Install Gravitron(Minerals Needed)") src.install_gravitron(m,src.gravtemplate) //return
						else if (command == "Look Outside") src.look_outside(m)
						else if (command == "Lock/Unlock") src.lock(m)
				Click(location,control,params)
					..()
					params = params2list(params)
					if(params["left"])
						switch_ship_command(usr,src)
					else if(params["right"])
						switch_ship_command(usr,src)

				verb/Launch()
					if(!ship_ref) return
				//	ship_ref.fly()
				New()
					category = list("Spacecraft")
					var/image/sel = image('fx.dmi',src,"select item",1000)
					src.img_select = sel

					while(src.active)
						if(src.loc == null) return
						if(src.active)
							src.ship_ref.Speed = src.ship_ref.get_ship_speed(src.ship_ref.level)
							if(!is_health_set)
								src.hp = 100*src.level
								is_health_set=1




						sleep(20)





			/*Ship
				info_name = "Ship"
				icon = 'ship.dmi'
				icon_state = "open"
				pixel_x = -250
				pixel_y = -200
				hp = 1000
				layer = 3
				fuel = 100
				bolted = 2
				hashadow = 0
				density_factor = 1
				weight = 10
				bounds = "-249,-199 to 285,126"
				tech_parent_path = /obj/items/tech/sub_tech/Engineering/Space_Ships
				var
					landing = 0
					tmp/mob/pilot = null
					tmp/obj/tele = null

				New()
					tag = name
					category = list("Spacecraft")
					var/image/sel = image('fx.dmi',src,"select item",1000)
					src.img_select = sel
					spawn(10)
						if(src.loc)
							var/obj/shad = new
							var/icon/I = new(src.icon)
							I.icon -= rgb(255,255,255)
							//I.Flip(NORTH)
							shad.icon = I
							shad.alpha = 100
							shad.pixel_y = -9
							src.underlays += shad
							while(src)
								if(src.loc == null) return
								if(src.active)
									animate(src, pixel_z = 134, time = 6)
									animate(transform = turn(matrix(), 1), time = 4)
									animate(pixel_z = 128, time = 6)
									animate(transform = turn(matrix(), -1), time = 4)
									var/found_someone = 0
									for(var/mob/m in range(6,src))
										animate(alpha = 175, time = 1)
										found_someone = 1
										break
									if(found_someone == 0) animate(alpha = 255, time = 1)
								sleep(20)*/
			ships/Deluxe_Ship
				info_name = "Deluxe_Ship"
				icon = 'Frieza_Ship_Genesis (1).dmi'
				icon_state = "Open"
			//	pixel_x = -250
			//	pixel_y = -200
				hp = 1000
				layer = 3
				fuel = 100
				bolted = 2
				hashadow = 0
				needs_to_be_active = 1
				capsule_storable = 1
				density_factor = 1
				weight = 10
				bounds = "36,59 to 61,22"
				mystille_cost=1200
				titanium_cost=6800
				coal_cost=1500
				copper_cost=4000
				stone_cost=6000
				mouse_over_pointer = MOUSE_ACTIVE_POINTER
				tech_parent_path = /obj/items/tech/sub_tech/Engineering/Space_Ships
				var/obj/effects/Space_Ship_Aura/ShipAura = new
				value = 1000
				can_pocket = 0
				density_factor = 1
				weight = 100
				desc = "Drills operate much faster than other tools, and faster still than digging with bare hands. The amount dug up by these compared to basic digging is thrice times."
				tech_tree = "Engineering"
				tech_subtech = "Space Ships"
				has_subtech = 0
				appearance_flags = KEEP_TOGETHER
				active = 0
				var/list/inside_items = list()
				var/tmp/deferred_init = 0
				var/tmp/initialized = 0
				obj/items/tech/ships

				//Move(oldloc, dir)
					//..()
					//if(src.deferred_init && isturf(src.loc))
						//src.InitializeShip()

				New(var/bought_ship=0)
					category = list("Spacecraft")
					var/image/sel = image('fx.dmi',src,"select item",1000)
					src.img_select = sel
					..()

					// If it's being created inside an inventory/capsule/container, defer init.
					if(!isturf(src.loc))
						src.deferred_init = 1
						return

					// If it was placed directly on a turf, initialize immediately.
					src.InitializeShip()


				proc/InitializeShip()
					if(initialized) return
					if(!isturf(src.loc)) return

					initialized = 1
					deferred_init = 0

				    // Generate ID etc (or skip ship_id entirely if you don't truly use it)
					src.ship_id = generate_ship_id()
					if(!src.ship_id) return

					var/obj/items/tech/Ship_Controls/C = src.find_ship_control()
					if(!C)
						if(src.panel && src.interior_z)
							src.entry_location = locate(src.panel.savedX, src.panel.savedY - 1, src.panel.savedZ)
							src.exit = get_turf(src)
							src.entrance = src.entry_location
							return
						else
							return

					src.interior_z = C.z
					src.panel = C
					C.claimed = 1
					C.ship_ref = src

					src.entry_location = locate(C.x, C.y - 1, C.z)
					src.signature_number = generate_signature()

					if(!isturf(src.entry_location))
						src.entry_location = locate(3, 34, src.interior_z)

					src.name = "Deluxe Ship #[signature_number]"
					src.tag = C.tag

					C.savedX = C.x
					C.savedY = C.y
					C.savedZ = C.z

				    // IMPORTANT: exit must be the ship’s turf
					src.exit = get_turf(src)
					src.entrance = src.entry_location

					src.ProcessNewShipObjects()

				/*var

					landing = 0
					ship_id = 0
					established = 0
					started=0

					tmp/gravity_on=0
					tmp/setgrav = 0
					var/entry_location
					tmp/mob/pilot = null
					tmp/obj/tele = null
					obj/items/tech/Ship_Controls/panel
					obj/Door
					instance_id // Unique ID per ship
					interior_z // Z-level where the ship interior exists
					launched = 0
					tmp/manualtravel = 0
					tmp/autotravel = 0*/


				Del()
					for(var/mob/m in orange(60,src.panel.ship_ref))
						if(m.z == src.interior_z)

							m.letgo()

							m.loc=locate(src.panel.ship_ref.x,src.panel.ship_ref.y,src.panel.ship_ref.z)
							m.in_space_ship = 0
							if(m.z == 16 ) m.apply_space_glow(1)
							m.dir=SOUTH
						//	pilot.reset_view()
							m.client.eye=usr
							m.client.perspective=EYE_PERSPECTIVE
							m.client.perspective=MOB_PERSPECTIVE
					..()
				Click(location,control,params)
					..()
					if(usr.left_click_function != "capsule")
						params = params2list(params)
						if(params["left"])

							if(usr.looking_out_ship == 1)
								usr.client.eye = usr
								usr.client.perspective=EYE_PERSPECTIVE
								usr.client.perspective=MOB_PERSPECTIVE
								usr.looking_out_ship = 0
								if(src.panel.pilot)
									src.panel.pilot = null
									src.pilot = null
								if(src.panel.launched) src.panel.launched = 0
								if(src.panel.manualtravel) src.panel.manualtravel = 0


								usr.apply_space_glow(0)
							/*else if(src.icon_state=="Open")
								src.icon_state="Closed"
							else
								src.icon_state="Open"
								src.started=1
								sleep(2)
								//if(src.established == 0 && src.started ==1)
								//	src.CreateShipInstance()

								usr.loc = src.entry_location
								usr.in_space_ship = 1*/



				Bump(mob/m)
					if(m && m.client)
						m.loc = src.entry_location


				/*New(var/bought_ship=0)


					if(ismob(loc) && bought_ship == 0) return // Don't activate from inventory

					category = list("Spacecraft")
					var/image/sel = image('fx.dmi',src,"select item",1000)
					src.img_select = sel
					..()
					if(!isturf(loc) && bought_ship == 0 ) return
					// Generate a unique ship ID (small number used in tag)
					src.ship_id = generate_ship_id()
					if (!src.ship_id)
						return // avoid proceeding if ID failed

					// Attempt to find a ship panel with a matching tag
					var/obj/items/tech/Ship_Controls/C = find_ship_control(src.ship_id)

					if (!C)
						//world << "[src]: ERROR - No matching Ship Control tag found for ID #[src.ship_id]!"
						return

					src.interior_z = C.z
					src.panel = C
					C.claimed = 1
					C.ship_ref = src

					src.entry_location = locate(C.x, C.y - 1, C.z)
					src.signature_number = generate_signature()
					if (!isturf(src.entry_location))
						//world << "[src]: WARNING - entry_location not a turf! Using fallback."
						src.entry_location = locate(3, 34, src.interior_z)

					// Set name and tag using panel info
					src.name = "CC Ship #[signature_number]"
					src.tag = C.tag

					// Save panel positions
					C.savedX = C.x
					C.savedY = C.y
					C.savedZ = C.z

					// Assign entrance/exit
					src.exit = src.loc
					src.entrance = src.entry_location

					// Register interior objects like doors, controls, etc.
					src.ProcessNewShipObjects()*/

				proc/find_ship_control()
					for (var/obj/items/tech/Ship_Controls/C in world)
						if (!C.tag) continue
						if (findtext(C.tag, "deluxeshipinside_door") && !C.claimed)
						//	world << "Found control: [C.tag]"
							return C
					return null

				proc/ProcessNewShipObjects()
					set background = 1
					for (var/obj/O in world)
						if(O.insideofaship) continue
						if (O.z != src.interior_z) continue
						if (!O) continue
						//O.ship_ref = src
						O.tag = "[src.name]" // Optional for future tracking
						O.insideofaship = 1
						if (istype(O, /obj/items/tech/doors/Security_Ship_Doors))
							src.entry_location = locate(O.x, O.y - 1, O.z)
							src.established = 1
							src.Door = O
							O.ship_ref = src
							O.exit = locate(src.x + 4, src.y - 4, src.z)
							O.entrance = src.entry_location

						if (istype(O, /obj/items/tech/Ship_Controls))
							O.ship_ref = src
							O.ship_view = locate(src.x + 4, src.y, src.z)
							O.savedX = O.x
							O.savedY = O.y
							O.savedZ = O.z
							src.panel = O

						//items += O
				proc
					generate_signature()
						return rand(100000,999999)


				proc
					copy_interior_cc()
						var/turf/start = locate(1,1,15) // Base ship template start
						var/turf/end = locate(57,36,15) // was org 80,80, 15Base ship template end

						world << "Start: [start] ([start.x],[start.y],[start.z])"
						world << "End: [end] ([end.x],[end.y],[end.z])"
						var/list/L = block(start, end)
						world << "Block size: [L.len]"
						//world<<"Interior Start Made."
						for(var/turf/T in block(start,end))
							var/turf/newT = new T.type(locate(T.x, T.y, src.interior_z))
							//world<<"Interior 2 Process."
							for(var/obj/O in T)
								if(O)
								//	world<<"Interior 3 Made."
									var/obj/newO = new O.type(locate(O.x, O.y, src.interior_z))
									//if(istype(newO,/obj/items/tech/))
									if(istype(newO, /obj/items/tech/doors/Security_Ship_Doors))
									//	world<<"Ship Door Made."
										entry_location = locate(O.x,O.y-1,interior_z)
										src.established = 1
										src.Door = newO
										newO.ship_ref = src
										newO.exit = locate(src.x+4,src.y-4,src.z)
										newO.entrance = locate(O.x,O.y-1,interior_z)
									if(istype(newO,/obj/items/tech/Ship_Controls))
									//	world<<"Ship Controls  Made."
										newO.ship_view = locate(src.x+4,src.y,src.z)
										newO.ship_ref = src
										src.panel = newO
										newO.savedX = newO.x
										newO.savedY = newO.y
										newO.savedZ = newO.z

									newO.tag = "[src.name]"
									//newO.Bolted = 1
									items += newO
								//	world<<"[newO] in Ship  and saved Made."
									//items += newO

							newT.tag = "[src.name]"
							items += newT
							//world<<"[newT] in Ship  and saved Made."
							//items += newT

							//items += newT
					//	world<<"(Ship Initiating.........)"
						src.CreateShipInstance()
					//	world<<"(Ship Initiated)"

					copy_interior()
						//set background = 1
						var/turf/start = locate(1,1,15) // Base ship template start
						var/turf/end = locate(57,36,15) // was org 80,80, 15Base ship template end

						for(var/turf/T in block(start, end))
							var/turf/newT = new T.type(locate(T.x, T.y, interior_z))

							for(var/obj/O in T)
								var/obj/newO = new O.type(locate(O.x, O.y, interior_z))
								if(istype(newO,/obj/items/tech/doors/Security_Ship_Doors))
									entry_location = locate(O.x,O.y-1,interior_z)
									src.established = 1
									src.Door = newO
									newO.ship_ref = src
									newO.exit = locate(src.x+4,src.y-4,src.z)
									newO.entrance = locate(O.x,O.y-1,interior_z)
								if(istype(newO,/obj/items/tech/Ship_Controls))
									newO.ship_view = locate(src.x+4,src.y,src.z)
									newO.ship_ref = src
									src.panel = newO

								newO.tag = "[src.name]"
								newO.bolted = 2
								items += newO

							newT.tag = "[src.name]"
							//items += newT

							//items += newT

						for(var/mob/m in world)
							m.set_alert("Interior Z: [interior_z](Confirmed:[entry_location])",'alert.dmi',"alert")

					allocate_ship_z(id)
						var/newz = 29 + (id % 72)
						for(var/obj/items/tech/ships/CC_Ship/s in items)
							if(newz == s.interior_z)
								id = regenerate_ship_id()
								newz = id
						return newz // Assigning a z-level dynamically

					generate_ship_id()
						var/list/used_ids = list()
						for (var/obj/items/tech/ships/CC_Ship/S in world)
							if (S.ship_id)
								used_ids |= S.ship_id // avoids duplicates

						for (var/i = 1 to 50)
							if (!(i in used_ids))
								return i

						world.log << "ERROR: All 50 ship IDs are used! Preventing infinite loop."
						return 0 // fail gracefully

					regenerate_ship_id()
						var/newid
						var/approved = 0
						while(approved == 0)
							newid = rand(100000,999999)
							for(var/obj/items/tech/ships/CC_Ship/s in items)
								if(newid != s.ship_id)
									approved =1
							sleep(30)
						return newid







				proc

					AllocateZLevel()
						for (var/z = starting_instance_z; z <= max_instance_z; z++)
							if (!(z in allocated_z_levels))
								allocated_z_levels += z
								return z
						return null  // No available Z-levels (handle this properly)

					CreateShipInstance()
						//if (ship_id in ship_instances)
						//	return ship_instances[ship_id]
						for(var/mob/m in world)
							//if(m.client)
							m.set_alert("Building Ship Interior...",'alert.dmi',"alert")
						var/obj/ship_interior_spawner/s = new /obj/ship_interior_spawner
						for(var/mob/m in world)
							//if(m.client)
							m.set_alert("Testing Allocation Z Level",'alert.dmi',"alert")
						var/zplane = AllocateZLevel()
						for(var/mob/m in world)
							m.set_alert("Testing Ship Instance Record.",'alert.dmi',"alert")
						//ship_instances[src.ship_id] = s
						//for(var/mob/m in world)
							//m.set_alert("Ship Instance Record Passed",'alert.dmi',"alert")
						/*if (world.Import("data/ship_interior/[ship_id].sav"))
							for(var/mob/m in world)
								m.set_alert("Test Prebuilt Ship Interior",'alert.dmi',"alert")
							LoadSavedShipInterior(s)
						else */
						s.loc = locate(24,11,zplane)
						for(var/mob/m in world)
							m.set_alert("Test Prebuilt Ship Interior",'alert.dmi',"alert")
						LoadPreBuiltShipInterior(s,"CC")
						src.established = 1
						for(var/mob/m in world)
							m.set_alert("Successfull Interior Build",'alert.dmi',"alert")

						//return ship_interior_spawner









			/*ships/Deluxe_Ship
				info_name = "Deluxe_Ship"
				icon = 'Frieza_Ship_Genesis (1).dmi'
				icon_state = "Open"
				pixel_x = -250
				pixel_y = -200
				hp = 1000
				layer = 3
				fuel = 100
				bolted = 2
				hashadow = 0
				density_factor = 1
				weight = 10
				bounds = "-249,-199 to 285,126"
				mouse_over_pointer = MOUSE_ACTIVE_POINTER
				tech_parent_path = /obj/items/tech/sub_tech/Engineering/Space_Ships
				value = 1000

				mystille_cost=1200
				titanium_cost=6800
				coal_cost=1500
				copper_cost=4000
				stone_cost=6000

				can_pocket = 0
				density_factor = 1
				weight = 100
				desc = "Drills operate much faster than other tools, and faster still than digging with bare hands. The amount dug up by these compared to basic digging is thrice times."
				tech_tree = "Engineering"
				tech_subtech = "Space Ships"
			//	act = /obj/items/tech/digging/Drill/proc/use
			//	act_drop = /obj/items/tech/digging/Drill/proc/drop
				appearance_flags = KEEP_TOGETHER
				has_subtech = 0
				var/list/inside_items = list()

			/*	var
					Speed = 8
					landing = 0
					ship_id = 0
					established = 0
					started=0
					locked = 0
					tmp/gravity_on=0
					tmp/setgrav = 0
					var/entry_location
					tmp/mob/pilot = null
					tmp/obj/tele = null
					obj/items/tech/Ship_Controls/panel
					obj/Door
					instance_id // Unique ID per ship
					interior_z // Z-level where the ship interior exists
					launched = 0
					tmp/manualtravel = 0
					tmp/autotravel = 0
					*/
				Del()
					for(var/mob/m in orange(60,src.panel.ship_ref))
						if(m.z == src.interior_z)

							m.letgo()

							m.loc=locate(src.panel.ship_ref.x,src.panel.ship_ref.y,src.panel.ship_ref.z)
							m.in_space_ship = 0
							if(m.z == 16 ) m.apply_space_glow(1)
							m.dir=SOUTH
						//	pilot.reset_view()
							m.client.eye=usr
							m.client.perspective=EYE_PERSPECTIVE
							m.client.perspective=MOB_PERSPECTIVE
					..()
				Bump(mob/m)
					if(m.client)
						usr.loc = src.entry_location

				Click(location,control,params)
					..()
					params = params2list(params)
					if(params["left"])
						if(usr.left_click_function != "capsule")
							if(usr.looking_out_ship == 1)
								usr.client.eye = usr
								usr.client.perspective=EYE_PERSPECTIVE
								usr.client.perspective=MOB_PERSPECTIVE
								usr.looking_out_ship = 0
								if(src.panel.pilot)
									src.panel.pilot = null
									src.pilot = null
								if(src.panel.launched) src.panel.launched = 0
								if(src.panel.manualtravel) src.panel.manualtravel = 0


								usr.apply_space_glow(0)
							else if(src.icon_state=="Open")
								src.icon_state="Closed"
							else
								src.icon_state="Open"
								src.started=1
								sleep(2)
								//if(src.established == 0 && src.started ==1)
								//	src.CreateShipInstance()

								usr.loc = src.entry_location
								usr.in_space_ship = 1

				New()
					if(ismob(loc)) return // Don't activate from inventory
					category = list("Spacecraft")
					var/image/sel = image('fx.dmi',src,"select item",1000)
					src.img_select = sel
					..()
					if(!isturf(loc)) return

					// Generate a unique ship ID (small number used in tag)
					src.ship_id = generate_ship_id()
					if (!src.ship_id)
						return // avoid proceeding if ID failed

					// Attempt to find a ship panel with a matching tag
					var/obj/items/tech/Ship_Controls/C = find_ship_control(src.ship_id)

					if (!C)
					//	world << "[src]: ERROR - No matching Ship Control tag found for ID #[src.ship_id]!"
						return

					src.interior_z = C.z
					src.panel = C
					C.claimed = 1
					C.ship_ref = src

					src.entry_location = locate(C.x, C.y - 1, C.z)
					src.signature_number = generate_signature()
					if (!isturf(src.entry_location))
					//	world << "[src]: WARNING - entry_location not a turf! Using fallback."
						src.entry_location = locate(3, 34, src.interior_z)

					// Set name and tag using panel info
					src.name = "Deluxe Ship #[signature_number]"
					src.tag = C.tag

					// Save panel positions
					C.savedX = C.x
					C.savedY = C.y
					C.savedZ = C.z

					// Assign entrance/exit
					src.exit = src.loc
					src.entrance = src.entry_location

					// Register interior objects like doors, controls, etc.
					src.ProcessNewShipObjects()

				proc/find_ship_control()
					for (var/obj/items/tech/Ship_Controls/C in world)
						if (!C.tag) continue
						if (findtext(C.tag, "deluxeshipinside_door") && !C.claimed)
						//	world << "Found control: [C.tag]"
							return C
					return null

				proc/ProcessNewShipObjects()
					set background = 1
					for (var/obj/O in world)
						if(O.insideofaship) continue
						if (O.z != src.interior_z) continue
						if (!O || istype(O,/obj/items/tech/Ship_Controls)) continue

						O.tag = "[src.name]" // Optional for future tracking
						O.insideofaship = 1
						if (istype(O, /obj/items/tech/doors/Security_Ship_Doors))
							src.entry_location = locate(O.x, O.y - 1, O.z)
							src.established = 1
							src.Door = O
							O.ship_ref = src
							O.exit = locate(src.x + 4, src.y - 4, src.z)
							O.entrance = src.entry_location

						if (istype(O, /obj/items/tech/Ship_Controls))
							O.ship_ref = src
							O.ship_view = locate(src.x + 4, src.y, src.z)
							O.savedX = O.x
							O.savedY = O.y
							O.savedZ = O.z
							src.panel = O
				proc
					generate_signature()
						return rand(100000,999999)

					generate_ship_id()
						var/list/used_ids = list()
						for (var/obj/items/tech/ships/Deluxe_Ship/S in world)
							if (S.ship_id)
								used_ids |= S.ship_id // avoids duplicates

						for (var/i = 1 to 50)
							if (!(i in used_ids))
								return i

						world.log << "ERROR: All 50 ship IDs are used! Preventing infinite loop."
						return 0 // fail gracefully

						*/
			ships/Namekian_Ship
				info_name = "Namekian_Ship"
				icon = 'Namekian_Ship_Genesis (1).dmi'
				icon_state = "Open"
			//	pixel_x = -250
			//	pixel_y = -200
				hp = 1000
				layer = 3
				fuel = 100
				bolted = 2
				hashadow = 0
				capsule_storable = 1
				needs_to_be_active = 1
				weight = 10
				mystille_cost=1200
				titanium_cost=6800
				coal_cost=1500
				copper_cost=4000
				stone_cost=6000
				mouse_over_pointer = MOUSE_ACTIVE_POINTER
				tech_parent_path = /obj/items/tech/sub_tech/Engineering/Space_Ships
				var/obj/effects/Space_Ship_Aura/ShipAura = new
				value = 1000
				can_pocket = 0
				density_factor = 1
				weight = 100
				desc = "Drills operate much faster than other tools, and faster still than digging with bare hands. The amount dug up by these compared to basic digging is thrice times."
				tech_tree = "Engineering"
				tech_subtech = "Space Ships"
				has_subtech = 0
				appearance_flags = KEEP_TOGETHER
				active = 0
				var/list/inside_items = list()
				var/tmp/deferred_init = 0
				var/tmp/initialized = 0
				obj/items/tech/ships

				//Move(oldloc, dir)
					//..()
					//if(src.deferred_init && isturf(src.loc))
						//src.InitializeShip()

				New(var/bought_ship=0)
					category = list("Spacecraft")
					var/image/sel = image('fx.dmi',src,"select item",1000)
					src.img_select = sel
					..()

					// If it's being created inside an inventory/capsule/container, defer init.
					if(!isturf(src.loc))
						src.deferred_init = 1
						return

					// If it was placed directly on a turf, initialize immediately.
					src.InitializeShip()


				proc/InitializeShip()
					//if(initialized)
					if(initialized && established)
						if(!isturf(entry_location) && panel)
							entry_location = locate(panel.savedX, panel.savedY - 1, panel.savedZ)
						return
						//return
					if(!isturf(src.loc)) return

					initialized = 1
					deferred_init = 0

				    // Generate ID etc (or skip ship_id entirely if you don't truly use it)
					src.ship_id = generate_ship_id()
					if(!src.ship_id) return

					var/obj/items/tech/Ship_Controls/C = src.find_ship_control()
					if(!C)
						if(src.panel && src.interior_z)
							src.entry_location = locate(src.panel.savedX, src.panel.savedY - 1, src.panel.savedZ)
							src.exit = get_turf(src)
							src.entrance = src.entry_location
							return
						else
							return

					src.interior_z = C.z
					src.panel = C
					C.claimed = 1
					C.ship_ref = src

					src.entry_location = locate(C.x, C.y - 1, C.z)
					src.signature_number = generate_signature()

					if(!isturf(src.entry_location))
						src.entry_location = locate(3, 34, src.interior_z)

					src.name = "Namekian Ship #[signature_number]"
					src.tag = C.tag

					C.savedX = C.x
					C.savedY = C.y
					C.savedZ = C.z

				    // IMPORTANT: exit must be the ship’s turf
					src.exit = get_turf(src)
					src.entrance = src.entry_location

					src.ProcessNewShipObjects()

				/*var

					landing = 0
					ship_id = 0
					established = 0
					started=0

					tmp/gravity_on=0
					tmp/setgrav = 0
					var/entry_location
					tmp/mob/pilot = null
					tmp/obj/tele = null
					obj/items/tech/Ship_Controls/panel
					obj/Door
					instance_id // Unique ID per ship
					interior_z // Z-level where the ship interior exists
					launched = 0
					tmp/manualtravel = 0
					tmp/autotravel = 0*/


				Del()
					for(var/mob/m in orange(60,src.panel.ship_ref))
						if(m.z == src.interior_z)

							m.letgo()

							m.loc=locate(src.panel.ship_ref.x,src.panel.ship_ref.y,src.panel.ship_ref.z)
							m.in_space_ship = 0
							if(m.z == 16 ) m.apply_space_glow(1)
							m.dir=SOUTH
						//	pilot.reset_view()
							m.client.eye=usr
							m.client.perspective=EYE_PERSPECTIVE
							m.client.perspective=MOB_PERSPECTIVE
					..()
				Click(location,control,params)
					..()
					if(usr.left_click_function != "capsule")
						params = params2list(params)
						if(params["left"])

							if(usr.looking_out_ship == 1)
								usr.client.eye = usr
								usr.client.perspective=EYE_PERSPECTIVE
								usr.client.perspective=MOB_PERSPECTIVE
								usr.looking_out_ship = 0
								if(src.panel.pilot)
									src.panel.pilot = null
									src.pilot = null
								if(src.panel.launched) src.panel.launched = 0
								if(src.panel.manualtravel) src.panel.manualtravel = 0


								usr.apply_space_glow(0)
							/*else if(src.icon_state=="Open")
								src.icon_state="Closed"
							else
								src.icon_state="Open"
								src.started=1
								sleep(2)
								//if(src.established == 0 && src.started ==1)
								//	src.CreateShipInstance()

								usr.loc = src.entry_location
								usr.in_space_ship = 1*/



				Bump(mob/m)
					if(m && m.client)
						m.loc = src.entry_location


				/*New(var/bought_ship=0)


					if(ismob(loc) && bought_ship == 0) return // Don't activate from inventory

					category = list("Spacecraft")
					var/image/sel = image('fx.dmi',src,"select item",1000)
					src.img_select = sel
					..()
					if(!isturf(loc) && bought_ship == 0 ) return
					// Generate a unique ship ID (small number used in tag)
					src.ship_id = generate_ship_id()
					if (!src.ship_id)
						return // avoid proceeding if ID failed

					// Attempt to find a ship panel with a matching tag
					var/obj/items/tech/Ship_Controls/C = find_ship_control(src.ship_id)

					if (!C)
						//world << "[src]: ERROR - No matching Ship Control tag found for ID #[src.ship_id]!"
						return

					src.interior_z = C.z
					src.panel = C
					C.claimed = 1
					C.ship_ref = src

					src.entry_location = locate(C.x, C.y - 1, C.z)
					src.signature_number = generate_signature()
					if (!isturf(src.entry_location))
						//world << "[src]: WARNING - entry_location not a turf! Using fallback."
						src.entry_location = locate(3, 34, src.interior_z)

					// Set name and tag using panel info
					src.name = "CC Ship #[signature_number]"
					src.tag = C.tag

					// Save panel positions
					C.savedX = C.x
					C.savedY = C.y
					C.savedZ = C.z

					// Assign entrance/exit
					src.exit = src.loc
					src.entrance = src.entry_location

					// Register interior objects like doors, controls, etc.
					src.ProcessNewShipObjects()*/

				proc/find_ship_control()
					for (var/obj/items/tech/Ship_Controls/C in world)
						if (!C.tag) continue
						if (findtext(C.tag, "namekianshipinside_door") && !C.claimed)
						//	world << "Found control: [C.tag]"
							return C
					return null

				proc/ProcessNewShipObjects()
					set background = 1
					for (var/obj/O in world)
						if(O.insideofaship) continue
						if (O.z != src.interior_z) continue
						if (!O) continue
						//O.ship_ref = src
						O.tag = "[src.name]" // Optional for future tracking
						O.insideofaship = 1
						if (istype(O, /obj/items/tech/doors/Security_Ship_Doors))
							src.entry_location = locate(O.x, O.y - 1, O.z)
							src.established = 1
							src.Door = O
							O.ship_ref = src
							O.exit = locate(src.x + 4, src.y - 4, src.z)
							O.entrance = src.entry_location

						if (istype(O, /obj/items/tech/Ship_Controls))
							O.ship_ref = src
							O.ship_view = locate(src.x + 4, src.y, src.z)
							O.savedX = O.x
							O.savedY = O.y
							O.savedZ = O.z
							src.panel = O

						//items += O
				proc
					generate_signature()
						return rand(100000,999999)


				proc
					copy_interior_cc()
						var/turf/start = locate(1,1,15) // Base ship template start
						var/turf/end = locate(57,36,15) // was org 80,80, 15Base ship template end

						world << "Start: [start] ([start.x],[start.y],[start.z])"
						world << "End: [end] ([end.x],[end.y],[end.z])"
						var/list/L = block(start, end)
						world << "Block size: [L.len]"
						//world<<"Interior Start Made."
						for(var/turf/T in block(start,end))
							var/turf/newT = new T.type(locate(T.x, T.y, src.interior_z))
							//world<<"Interior 2 Process."
							for(var/obj/O in T)
								if(O)
								//	world<<"Interior 3 Made."
									var/obj/newO = new O.type(locate(O.x, O.y, src.interior_z))
									//if(istype(newO,/obj/items/tech/))
									if(istype(newO, /obj/items/tech/doors/Security_Ship_Doors))
									//	world<<"Ship Door Made."
										entry_location = locate(O.x,O.y-1,interior_z)
										src.established = 1
										src.Door = newO
										newO.ship_ref = src
										newO.exit = locate(src.x+4,src.y-4,src.z)
										newO.entrance = locate(O.x,O.y-1,interior_z)
									if(istype(newO,/obj/items/tech/Ship_Controls))
									//	world<<"Ship Controls  Made."
										newO.ship_view = locate(src.x+4,src.y,src.z)
										newO.ship_ref = src
										src.panel = newO
										newO.savedX = newO.x
										newO.savedY = newO.y
										newO.savedZ = newO.z

									newO.tag = "[src.name]"
									//newO.Bolted = 1
									items += newO
								//	world<<"[newO] in Ship  and saved Made."
									//items += newO

							newT.tag = "[src.name]"
							items += newT
							//world<<"[newT] in Ship  and saved Made."
							//items += newT

							//items += newT
					//	world<<"(Ship Initiating.........)"
						src.CreateShipInstance()
					//	world<<"(Ship Initiated)"

					copy_interior()
						//set background = 1
						var/turf/start = locate(1,1,15) // Base ship template start
						var/turf/end = locate(57,36,15) // was org 80,80, 15Base ship template end

						for(var/turf/T in block(start, end))
							var/turf/newT = new T.type(locate(T.x, T.y, interior_z))

							for(var/obj/O in T)
								var/obj/newO = new O.type(locate(O.x, O.y, interior_z))
								if(istype(newO,/obj/items/tech/doors/Security_Ship_Doors))
									entry_location = locate(O.x,O.y-1,interior_z)
									src.established = 1
									src.Door = newO
									newO.ship_ref = src
									newO.exit = locate(src.x+4,src.y-4,src.z)
									newO.entrance = locate(O.x,O.y-1,interior_z)
								if(istype(newO,/obj/items/tech/Ship_Controls))
									newO.ship_view = locate(src.x+4,src.y,src.z)
									newO.ship_ref = src
									src.panel = newO

								newO.tag = "[src.name]"
								newO.bolted = 2
								items += newO

							newT.tag = "[src.name]"
							//items += newT

							//items += newT

						for(var/mob/m in world)
							m.set_alert("Interior Z: [interior_z](Confirmed:[entry_location])",'alert.dmi',"alert")

					allocate_ship_z(id)
						var/newz = 29 + (id % 72)
						for(var/obj/items/tech/ships/CC_Ship/s in items)
							if(newz == s.interior_z)
								id = regenerate_ship_id()
								newz = id
						return newz // Assigning a z-level dynamically

					generate_ship_id()
						var/list/used_ids = list()
						for (var/obj/items/tech/ships/CC_Ship/S in world)
							if (S.ship_id)
								used_ids |= S.ship_id // avoids duplicates

						for (var/i = 1 to 50)
							if (!(i in used_ids))
								return i

						world.log << "ERROR: All 50 ship IDs are used! Preventing infinite loop."
						return 0 // fail gracefully

					regenerate_ship_id()
						var/newid
						var/approved = 0
						while(approved == 0)
							newid = rand(100000,999999)
							for(var/obj/items/tech/ships/CC_Ship/s in items)
								if(newid != s.ship_id)
									approved =1
							sleep(30)
						return newid







				proc

					AllocateZLevel()
						for (var/z = starting_instance_z; z <= max_instance_z; z++)
							if (!(z in allocated_z_levels))
								allocated_z_levels += z
								return z
						return null  // No available Z-levels (handle this properly)

					CreateShipInstance()
						//if (ship_id in ship_instances)
						//	return ship_instances[ship_id]
						for(var/mob/m in world)
							//if(m.client)
							m.set_alert("Building Ship Interior...",'alert.dmi',"alert")
						var/obj/ship_interior_spawner/s = new /obj/ship_interior_spawner
						for(var/mob/m in world)
							//if(m.client)
							m.set_alert("Testing Allocation Z Level",'alert.dmi',"alert")
						var/zplane = AllocateZLevel()
						for(var/mob/m in world)
							m.set_alert("Testing Ship Instance Record.",'alert.dmi',"alert")
						//ship_instances[src.ship_id] = s
						//for(var/mob/m in world)
							//m.set_alert("Ship Instance Record Passed",'alert.dmi',"alert")
						/*if (world.Import("data/ship_interior/[ship_id].sav"))
							for(var/mob/m in world)
								m.set_alert("Test Prebuilt Ship Interior",'alert.dmi',"alert")
							LoadSavedShipInterior(s)
						else */
						s.loc = locate(24,11,zplane)
						for(var/mob/m in world)
							m.set_alert("Test Prebuilt Ship Interior",'alert.dmi',"alert")
						LoadPreBuiltShipInterior(s,"CC")
						src.established = 1
						for(var/mob/m in world)
							m.set_alert("Successfull Interior Build",'alert.dmi',"alert")


			/*ships/Namekian_Ship
				info_name = "Namekian_Ship"
				icon = 'Namekian_Ship_Genesis (1).dmi'
				icon_state = "Open"
				pixel_x = -250
				pixel_y = -200
				hp = 1000
				layer = 3
				fuel = 100
				bolted = 2
				hashadow = 0
				density_factor = 1
				weight = 10
			//	bounds = "-249,-199 to 285,126"
				mouse_over_pointer = MOUSE_ACTIVE_POINTER
				tech_parent_path = /obj/items/tech/sub_tech/Engineering/Space_Ships
				value = 1000

				mystille_cost=1200
				titanium_cost=6800
				coal_cost=1500
				copper_cost=4000
				stone_cost=6000

				can_pocket = 0
				density_factor = 1
				weight = 100
				desc = "Drills operate much faster than other tools, and faster still than digging with bare hands. The amount dug up by these compared to basic digging is thrice times."
				tech_tree = "Engineering"
				tech_subtech = "Space Ships"
			//	act = /obj/items/tech/digging/Drill/proc/use
			//	act_drop = /obj/items/tech/digging/Drill/proc/drop
				appearance_flags = KEEP_TOGETHER
				has_subtech = 0
				active = 0
				var/list/inside_items = list()

				/*var
					Speed = 8
					landing = 0
					ship_id = 0
					established = 0
					started=0
					locked = 0
					tmp/gravity_on=0
					tmp/setgrav = 0
					var/entry_location
					tmp/mob/pilot = null
					tmp/obj/tele = null
					obj/items/tech/Ship_Controls/panel
					obj/Door
					instance_id // Unique ID per ship
					interior_z // Z-level where the ship interior exists
					launched = 0
					tmp/manualtravel = 0
					tmp/autotravel = 0
					*/

				Del()
					for(var/mob/m in orange(60,src.panel.ship_ref))
						if(m.z == src.interior_z)

							m.letgo()

							m.loc=locate(src.panel.ship_ref.x,src.panel.ship_ref.y,src.panel.ship_ref.z)
							m.in_space_ship = 0
							if(m.z == 16 ) m.apply_space_glow(1)
							m.dir=SOUTH
						//	pilot.reset_view()
							m.client.eye=usr
							m.client.perspective=EYE_PERSPECTIVE
							m.client.perspective=MOB_PERSPECTIVE
					..()

				Bump(mob/m)
					if(m.client)
						usr.loc = src.entry_location

				Click(location,control,params)
					..()
					params = params2list(params)
					if(params["left"])
						if(usr.left_click_function != "capsule")
							if(usr.looking_out_ship == 1)
								usr.client.eye = usr
								usr.client.perspective=EYE_PERSPECTIVE
								usr.client.perspective=MOB_PERSPECTIVE
								usr.looking_out_ship = 0
								if(src.panel.pilot)
									src.panel.pilot = null
									src.pilot = null
								if(src.panel.launched) src.panel.launched = 0
								if(src.panel.manualtravel) src.panel.manualtravel = 0


								usr.apply_space_glow(0)
							else if(src.icon_state=="Open")
								src.icon_state="Closed"
							else
								src.icon_state="Open"
								src.started=1
								sleep(2)
								//if(src.established == 0 && src.started ==1)
								//	src.CreateShipInstance()

								usr.loc = src.entry_location
								usr.in_space_ship = 1

				New()
					if(ismob(loc)) return // Don't activate from inventory
					category = list("Spacecraft")
					var/image/sel = image('fx.dmi',src,"select item",1000)
					src.img_select = sel
					..()
					if(!isturf(loc)) return
					// Generate a unique ship ID (small number used in tag)
					src.ship_id = generate_ship_id()
					if (!src.ship_id)
						return // avoid proceeding if ID failed

					// Attempt to find a ship panel with a matching tag
					var/obj/items/tech/Ship_Controls/C = find_ship_control(src.ship_id)

					if (!C)
						//world << "[src]: ERROR - No matching Ship Control tag found for ID #[src.ship_id]!"
						return

					src.interior_z = C.z
					src.panel = C
					C.claimed = 1
					C.ship_ref = src

					src.entry_location = locate(C.x, C.y - 1, C.z)
					src.signature_number = generate_signature()
					if (!isturf(src.entry_location))
					//	world << "[src]: WARNING - entry_location not a turf! Using fallback."
						src.entry_location = locate(3, 34, src.interior_z)

					// Set name and tag using panel info
					src.name = "Namekian Ship #[signature_number]"
					src.tag = C.tag

					// Save panel positions
					C.savedX = C.x
					C.savedY = C.y
					C.savedZ = C.z

					// Assign entrance/exit
					src.exit = src.loc
					src.entrance = src.entry_location

					// Register interior objects like doors, controls, etc.
					src.ProcessNewShipObjects()

				proc/find_ship_control()
					for (var/obj/items/tech/Ship_Controls/C in world)
						if (!C.tag) continue
						if (findtext(C.tag, "namekianshipinside_door") && !C.claimed)
						//	world << "Found control: [C.tag]"
							return C
					return null

				proc/ProcessNewShipObjects()
					set background = 1
					for (var/obj/O in world)
						if(O.insideofaship) continue
						if (O.z != src.interior_z) continue
						if (!O || istype(O,/obj/items/tech/Ship_Controls)) continue

						O.tag = "[src.name]" // Optional for future tracking
						O.insideofaship = 1
						if (istype(O, /obj/items/tech/doors/Security_Ship_Doors))
							src.entry_location = locate(O.x, O.y - 1, O.z)
							src.established = 1
							src.Door = O
							O.ship_ref = src
							O.exit = locate(src.x + 4, src.y - 4, src.z)
							O.entrance = src.entry_location

						if (istype(O, /obj/items/tech/Ship_Controls))
							O.ship_ref = src
							O.ship_view = locate(src.x + 4, src.y, src.z)
							O.savedX = O.x
							O.savedY = O.y
							O.savedZ = O.z
							src.panel = O

						//items += O
				proc
					generate_signature()
						return rand(100000,999999)

					generate_ship_id()
						var/list/used_ids = list()
						for (var/obj/items/tech/ships/Namekian_Ship/S in world)
							if (S.ship_id)
								used_ids |= S.ship_id // avoids duplicates

						for (var/i = 1 to 50)
							if (!(i in used_ids))
								return i

						world.log << "ERROR: All 50 ship IDs are used! Preventing infinite loop."
						return 0 // fail gracefully
						*/


			Lightning_Rod
				info_name = "Lightning_Rod"
				icon = 'lightening_rod.dmi'
				icon_state = ""
				value = 1000
				density_factor = 1
				hashadow = 0
				bounds = "11,1 to 21,16"
				desc = "The lightning rod can be useful in support of solar panels or other power generators that aren't entirely reliable. Once a storm begins, there is around a 10% chance per every 10 seconds that a bolt of lightning will strike this rod, increasing the capacity of a near by battery by 25%"
				tech_tree = "Engineering"
				tech_subtech = ""
				New()
					..()
					tag = name
					category = list("Power Generation")
					var/image/sel = image('fx_large.dmi',src,"select item",1000)
					src.img_select = sel
					spawn(1)
						if(src.loc)
							var/obj/shad = new
							shad.icon = src.icon
							shad.icon_state = "shadow"
							shad.alpha = 100
							shad.pixel_y = -3
							shad.loc = src.loc
							shad.bolted = 2
							src.shadow = shad
		/*	world_tree
				icon = 'world_tree.dmi'
				icon_state = "stump"
				name = "Yukka Tree"
				bolted = 2
				hashadow = 0
				pixel_x = -1226 //moved 8
				density_factor = 2
				generator = 1;
				generates = 10000
				appearance_flags = 0
				organic = 1
				bounds = "-90,184 to 121,250"
				immune_dmg = 1
				invul_melee = 1
				mouse_opacity = 0
				//hashadow = 1
				var/image/wt_trunk
				var/image/wt_trunk_opaque
				var/image/wt_top
				var/list/wt_rays
				var/obj/wt_overlay
				var/setup = 0
				New()
					src.layer = 4.484
					spawn(10) //Make it spawn, so it doesn't land up creating things in 0,0,0
						if(src)
							if(src.setup) return

							src.setup = 1

							if(src.wt_overlay) src.wt_overlay.loc = src.loc

							src.wt_top = null
							src.wt_trunk = null
							src.wt_rays = null
							src.overlays = null
							src.underlays = null
							src.particles = null
							src.vis_contents = null


							var/image/top = image('world_tree.dmi',src,"tree top",src.layer+1)
							//top.filters = filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(102,0,204))
							src.wt_top = top
							top.mouse_opacity = 0

							var/image/trunk = image('world_tree.dmi',src,"trunk",4.484)
							src.wt_trunk = trunk
							trunk.mouse_opacity = 0

							var/image/trunk_opaque = image('world_tree.dmi',src,"trunk",4.484)
							trunk_opaque.alpha = 200
							src.wt_trunk_opaque = trunk_opaque
							trunk_opaque.mouse_opacity = 0

							//Creates the divine golden overlay for the tree top
							var/obj/items/misc/world_tree_overlay/o = new
							o.layer = src.layer+11;
							o.loc = src.loc
							o.pixel_x = src.pixel_x
							o.mouse_opacity = 0
							src.wt_overlay = o

							//Pulsates the world tree top, with some alpha. Makes it look like it's thrumming with power.
							var/obj/i = new
							i.icon = src.icon
							i.icon_state = "tree top"
							i.loc = src.loc
							i.step_x = src.step_x
							i.step_y = src.step_y
							i.pixel_x = src.pixel_x
							i.pixel_y = src.pixel_y
							i.layer = src.layer+10;
							i.alpha = 155
							i.mouse_opacity = 0
							animate(i, transform = matrix()*1.1,alpha = 0, time = 20, loop = -1)
							animate(transform = matrix()*1,alpha = 155,time = 0)

							//Creates spores infused with divine energy slowly drift from the tree. Makes use of particles and filters.
							var/obj/spores = new
							spores.icon = src.icon
							spores.icon_state = "empty"
							spores.loc = src.loc
							spores.pixel_x = src.pixel_x
							spores.layer = src.layer+11;
							spores.particles = new/particles/world_tree_spores
							spores.filters += filter(type="drop_shadow", x=0, y=0, size=2, offset=1, color=rgb(155,255,255))
							spores.filters += filter(type="bloom", threshold=rgb(0,0,0), size = 6,offset=1,alpha = 175)
							spores.invisibility = 1

							src.wt_rays = list()

							//----------------------------------------------------------------------------------------------------------
							//Creates a series of massive light rays that shine down from the tree tops like a divine beam of energy.
							var/image/rays = image('world_tree.dmi',src,"empty",2.1)
							rays.pixel_x = 833
							rays.pixel_y = 200
							rays.layer = 5
							rays.filters += filter(type="rays",x=0,y=0,size=1000,color=rgb(255,255,255),offset=0,density=15,threshold=0.5,factor=0,flags=FILTER_OVERLAY)
							animate(rays.filters[1],offset = 100,time = 10000, loop = -1)
							animate(offset = 0,time = 0)
							src.wt_rays += rays
							//----------------------------------------------------------------------------------------------------------
							var/image/rays2 = image('world_tree.dmi',src,"empty",2.1)
							rays2.pixel_x = -833
							rays2.pixel_y = 200
							//rays2.loc = src.loc
							rays2.layer = 5
							rays2.filters += filter(type="rays",x=0,y=0,size=1000,color=rgb(255,255,255),offset=0,density=15,threshold=0.5,factor=0,flags=FILTER_OVERLAY)
							animate(rays2.filters[1],offset = 200,time = 10000, loop = -1)
							animate(offset = 0,time = 0)
							src.wt_rays += rays2
							//----------------------------------------------------------------------------------------------------------
							var/image/rays3 = image('world_tree.dmi',src,"empty",2.1)
							rays3.pixel_x = 0
							rays3.pixel_y = 264
							//rays3.loc = src.loc
							rays3.layer = 4.3
							rays3.filters += filter(type="rays",x=0,y=0,size=1000,color=rgb(255,255,255),offset=0,density=15,threshold=0.5,factor=0,flags=FILTER_OVERLAY)
							animate(rays3.filters[1],offset = 300,time = 10000, loop = -1)
							animate(offset = 0,time = 0)
							src.wt_rays += rays3
							//----------------------------------------------------------------------------------------------------------
							for(var/mob/m in players)
								if(m.client && m.z == 4)
									m.show_worldtree(1)

									 */
			Conveyor_Belt
				info_name = "Conveyor_Belt"
				icon = 'conveyor_belt.dmi'
				icon_state = "move"
				value = 200
				bolted = 2
				hashadow = 0
				density_factor = 0
				dir = SOUTH
				New()
					..()
					tag = name
					var/image/sel = image('fx.dmi',src,"select item",1000)
					src.img_select = sel
					name = "[src.name] ([src.value])"
					spawn(10)
						layer = 2
						while(src)
							if(src.loc)
								for(var/atom/movable/a in src.loc)
									if(bounds_dist(a, src) < -14 )
										if(a != src)
											if(a.bolted == 0)
												//a.step_x = 0
												//a.step_y = 0
												step(a,src.dir,16)
												//Move(NewLoc,Dir=0,step_x=0,step_y=0)
											//	a.set_shadow()
							sleep(2)
						/*
						while(src)
							if(src.powered == null)
								for(var/obj/items/tech/Power_Line/p in range(0,src))
									if(p.powered) src.powered = p.powered
							if(src.powered == null)
								src.icon_state = "stop"
							if(src.powered)
								src.icon_state = "move"
								src.check_power_belts()
								var/n = 0
								for(var/atom/a in src.loc)
									if(!a.bolted)
										var/moves = 1
										n += 1
										if(n >= 50)
											return
										if(isobj(a))
											a.pixel_x = 0
											a.pixel_y = 0
										if(ismob(a))
											var/mob/m = a
											if(m.state == "fly")
												moves = 0
										if(moves) step(a,src.dir)
										for(var/obj/items/tech/t in a.loc)
											if(t.silo) if(istype(a,/obj/items/resources))
												t.value += a.value
												del(a)
												break
							sleep(3)
						*/
			Space_Pod
				info_name = "Space_Pod"
				icon = 'New SpacePod.dmi'
				icon_state = ""
			//	pixel_x = -64
			//	pixel_y = -64
				hp = 10000
				layer = 3
				fuel = 1000
				bolted = 0
				hashadow = 0
				density_factor = 0
				weight = 10
				bounds = "19,45 to 44,21"
				mouse_over_pointer = MOUSE_ACTIVE_POINTER
				value = 1000

				mystille_cost=1200
				titanium_cost=6800
				coal_cost=1500
				copper_cost=4000
				stone_cost=6000
				needs_to_be_active = 1

				can_pocket = 0
				weight = 100
				desc = "Drills operate much faster than other tools, and faster still than digging with bare hands. The amount dug up by these compared to basic digging is thrice times."
				tech_tree = "Engineering"
				tech_subtech = "Space Pods"
			//	act = /obj/items/tech/digging/Drill/proc/use
			//	act_drop = /obj/items/tech/digging/Drill/proc/drop
				appearance_flags = KEEP_TOGETHER
				tech_parent_path = /obj/items/tech/sub_tech/Engineering/Space_Pods
				has_subtech = 0
				act = /obj/items/tech/Space_Pod/proc/repair_prompt

				var/list/known_locations = list("Random Exploration") // Default locations
				var/current_coordinates = null
				var/obj/items/Planets/Mains/autotravel_target = null
				var/launched = 0
				var/obj/effects/Space_Pod_Aura/PodAura
				var/Speed = 8
				var/speed_ramp = 0
				var/speed_skip = 0
				var/obj/speed_effect
				var/sr
				var/driving = 0
				var
					landing = 0
					tmp/mob/pilot = null
					tmp/obj/tele = null
					tmp/autotravel = 0
					tmp/manualtravel = 0

				proc
					repair_prompt(var/obj/items/tech/Space_Pod/s, var/mob/m)
						if(m.intxp >= 1000) // m.race != "Tuffle" && m.race_class == "Technician" && m.race_class != "Namekian" && m.race_class!="Human" || m.race=="Tuffle"||m.race=="Namekian"||m.race =="Human")
							var/repairing = input("How much are you reparing? 1 titanium = 1 repair recovery\nYou currently have: [src.hp]% of space pod health") as num
							if(repairing == 0 ) return
							if(repairing <=-0) return
							if(m.titanium_count >= repairing)
								s.hp += repairing
								m.titanium_count -= repairing

								m << "Repaired the ship by [repairing]%"
							else
								m << "Not enough Titanium!"
								return
						else
							m << "You are not intelligent enough to upgrade.\nShips Health:[src.hp]%"
							return

					refuel_prompt(var/mob/m)
						for(var/obj/items/tech/Fuel/F in m)
							if(F)
								var/fuelamount = input("Input fuel amount:") as num
								if(F.fuelamount >= fuelamount && fuelamount > 0)
									fuel += fuelamount
									F.fuelamount -= fuelamount
									if(F.fuelamount <= 0)
										F.drop()
										F.destroy()
									m.refresh_inv()
									m.set_alert("[fuelamount] was added to [F]!",'alert.dmi',"alert")
								else
									m.set_alert("Not enough fuel!",'alert.dmi',"alert")
									return



					locate_planet(destination)
						for(var/obj/items/Planets/Mains/P in world)
							if(P.name == destination)
								return P
						return null

					send_to_planet(var/destination)
						if(src)
							if(destination == "Namek")
								src.loc=locate(rand(2,489),rand(2,489),4)
							if(destination == "Earth")
								src.loc=locate(rand(2,489),rand(2,489),1)
							if(destination == "Vegeta")
								src.loc=locate(rand(2,489),rand(2,489),10)
							if(destination == "Icer")
								src.loc=locate(rand(2,489),rand(2,489),9)
							if(pilot) pilot.loc = src.loc
							if(src.launched) src.launched=0
							//if(src.active) src.active =0
							if(!locate(destination) in known_locations)
								src.known_locations += destination
					begin_auto_travel(mob/m, destination)
						autotravel_target = locate_planet(destination)
						if(!autotravel_target)
							m << "Invalid destination."
							src.launched=0
							src.active=0
							return
						m.set_alert("Traveling to [destination]...",'alert.dmi',"alert")
						src.icon_state="Flight"
						if(src.manualtravel) src.manualtravel = 0
						while(src && autotravel_target && hp > 0)
							//src.driving=1
							step_towards(src, autotravel_target)
							pilot.loc=src.loc
							hp -= 0.1


							if(get_dist(src,autotravel_target) < 2)
								break
							if(src in autotravel_target.loc || src in orange(1,autotravel_target))
								break
							sleep(src.Speed)
						if(!autotravel_target || hp <= 0)
							m.set_alert("Travel interrupted, check your pod!",'alert.dmi',"alert")
							src.launched=0
							src.active=0
							return
						pilot.set_alert("Arrived at [destination].",'alert.dmi',"alert")
						src.icon_state=""
					//	src.overlays -= PodAura
						src.launched=0
						src.active=0
						src.send_to_planet(destination) // Snap to destination
						pilot.apply_space_glow(0)
						sleep(2)
						//src.overlays -= /obj/effects/elec


					begin_free_travel(mob/m)
						if(!m || !pilot) return
						pilot.alpha = 0
						src.icon_state="Flight"
						src.autotravel = 0
						src.manualtravel = 1
						while(pilot == m && hp > 0)
							if(hp <= 0)
								m.set_alert("[src]: OV3RL0@D Repairs Needed!",'alert.dmi',"alert")
							//	m.create_chat_entry("alerts","Out of fuel! Drifting in space..")
								src.launched=0
								src.active=0
							sleep(src.Speed)


						//return


					launch(mob/m)
						if(launched) return

						src.launched = 1
						var/LaunchTime = 10
						view(10,m) << output("<font color = white>[src] is preparing to launch in [LaunchTime] seconds", "chat.local")
					//	m.create_chat_entry("local","<font color = white>[src] is preparing to launch in [LaunchTime] seconds</font>",0,1)
						m.set_alert("[src] is preparing to launch in [LaunchTime] seconds",'alert.dmi',"alert")

						while (LaunchTime >= 4)
							sleep(10)
							spawn_smoke_effect(src, 4)
							LaunchTime--


						 // 10 seconds delay
						animate(src, pixel_z = 190, time = 6)
						animate(transform = turn(matrix(), 1), time = 2)
					//	animate(pixel_z = 128, time = 6)
						animate(transform = turn(matrix(), -1), time = 2)
					//	m.create_chat_entry("local","<font color = white>[src]: Blasting off in 3..</font>",0,1)
					//	view(10,m) << output("<font color = white>[src]: Blasting off in 3..", "chat.local")
						sleep(10)
						//m.create_chat_entry("local","<font color = white>[src]: 2..</font>",0,1)
						sleep(10)
					//	m.create_chat_entry("local","<font color = white>[src]: 1..</font>",0,1)
						sleep(10)
					//	m.create_chat_entry("local","<font color = white>[src]: BLAST OFF!</font>",0,1)
						src.active=1
						animate(src, pixel_z = 0, time = 1)
						animate(transform = turn(matrix(), 0), time = 1)

						if(m.onEarth) src.loc=locate(97,355,16)
						if(m.onNamek) src.loc=locate(467,367,16)
						if(m.onVegeta) src.loc=locate(451,89,16)
						if(m.onIcer) src.loc=locate(94,71,16)
						if(m.on_customplanet)
							src.loc=locate(m.on_customplanet.x,m.on_customplanet.y-2,m.on_customplanet.z)
							m.on_customplanet = 0
						if (!PodAura)
							PodAura = new /obj/effects/Space_Pod_Aura
					//	src.overlays+=PodAura
					//	if(src.Speed >=0.8 && src.Speed <=1) src.overlays += /obj/effects/elec
						m.apply_space_glow(1)
						src.loc = locate(src.x, src.y, 16) // Move to space Z-plane
						//m << "Launch successful! Entering space..."
						if(current_coordinates == "Random Exploration")
							current_coordinates = pick("Earth","Namek","Vegeta","Icer")
							src.begin_auto_travel(m, current_coordinates)
							//src.begin_free_travel(m)
						else
							if(current_coordinates == null)
								current_coordinates = pick("Earth","Namek","Vegeta","Icer")
								src.begin_auto_travel(m, current_coordinates)
								//src.begin_free_travel(m)
							else
								src.begin_auto_travel(m, current_coordinates)
						src.hp -= 250



					set_coordinates(mob/m)
						var/location = input("Choose destination:", "Space Travel") as null|anything in known_locations
						if(!location) return
						current_coordinates = location
						m.set_alert("Coordinates set to [location].",'alert.dmi',"alert")
						if(current_coordinates == "Random Exploration" && m.z == 16)
							current_coordinates = pick("Earth","Namek","Vegeta","Icer")
							src.begin_auto_travel(m,current_coordinates)
						if(current_coordinates != "Random Exploration" && m.z == 16)
							src.begin_auto_travel(m,current_coordinates)





					refuel(var/obj/items/tech/Space_Pod/s,var/mob/m)
						var/fuelamount = input("Input the number to refuel\nYou currently have: [s.fuel]%") as num
						if(fuelamount<=-0) return
						if(fuelamount<0) return
						for(var/obj/items/tech/Fuel/f in m)
							if(f)
								if(f.fuelamount>=fuelamount)

									s.fuel += fuelamount
									if(f.fuelamount<=0)
										f.drop()
										f.destroy()
									m.refresh_inv()
									m.set_alert("[fuelamount] was added to [s]!",'alert.dmi',"alert")
								else
									m.set_alert("Not enough fuel!",'alert.dmi',"alert")
									return
				verb
					switch_pod_command(obj/items/tech/Space_Pod/s)
						s = src
						var/command = input("Select a command:") as null|anything in list("Set Coordinates", "Launch", "Repair")
						if(command == "Set Coordinates") s.set_coordinates(usr)
						else if(command == "Launch") s.launch(usr)
						else if(command == "Repair") s.repair_prompt(s,usr)
				Del()
					if(pilot)
						pilot.letgo()
						pilot.loc=src.loc
						pilot.dir=SOUTH
					//	pilot.reset_view()
						pilot.client.eye=usr
						pilot.client.perspective=EYE_PERSPECTIVE
						pilot.client.perspective=MOB_PERSPECTIVE

						pilot.alpha=255
						pilot.layer=initial(pilot.layer)
						//Pilot.invisibility=0
						pilot.in_space_pod=0
						//if(Pilot.suffocating) Pilot.suffocating=0
						pilot.can_move=1
						pilot.stunned=0
						pilot.Pod=null
						pilot=null
					..()
				Click(location,control,params)
					..()
					params = params2list(params)
					if(params["left"])
						if(usr.left_click_function) return
						if(src.icon_state=="Opened")
							flick(src,"Close")
							sleep(2)
							src.icon_state=""
						else
							flick(src,"Open")
							sleep(2)
							src.icon_state="Opened"
						if(src.icon_state=="Opened")
							if(manualtravel) manualtravel=0
							if(autotravel) autotravel=0
							if(pilot)
								//if(pilot.client==null)
								//	pilot=null
								//	return

								pilot.letgo()
								pilot.loc=src.loc
								pilot.dir=SOUTH
							//	pilot.reset_view()
								pilot.client.eye=usr
								pilot.client.perspective=EYE_PERSPECTIVE
								pilot.client.perspective=MOB_PERSPECTIVE

								pilot.alpha=255
								pilot.layer=initial(pilot.layer)
								//Pilot.invisibility=0
								pilot.in_space_pod=0
								//if(Pilot.suffocating) Pilot.suffocating=0
								pilot.can_move=1
								pilot.stunned=0
								pilot.Pod=null
								pilot=null
							//	src.overlays.Remove(src.PodAura)
							//	PodAura:icon/=Pilot.auracolor
								src.occupied=0
								src.density=0
								if(src.launched) src.launched=0
								if(src.active) src.active=0

								return

						if(pilot != usr)
							for(var/mob/M in orange(1,src))
								if(bounds_dist(src,M) <= 32)
									pilot=M
									M.letgo()
									M.Pod=src
									M.client.eye=M.Pod
									M.client.perspective=EYE_PERSPECTIVE
									M.client.perspective=MOB_PERSPECTIVE
									M.alpha=0
									M.layer=1
									src.occupied=1
									M.in_space_pod=1
									M.loc=M.Pod
									M.can_move=0
									src.density=1
								//	M.isFloating=0
									//M.reset_view(src)
								//	PodAura:icon*=Pilot.auracolor
									return
					else if(params["right"] && pilot == usr)

						switch_pod_command(src)
					/*else if(params["right"])
						if(src.loc == null)
							for(var/obj/items/tech/Fuel/F in usr)
								if(F)
									call(act,src)(F,src,usr) */
				proc/GetPodSpeed(lvl)
					var/base_speed = 5.0
					var/deduction = 0.0

					if (lvl >= 20000)
						deduction = 4.3 // Ensures it caps at 0.8
					else if (lvl >= 15000)
						deduction = 3.5+(lvl*0.0001)
					else if (lvl >= 10000)
						deduction = 3+(lvl*0.0001)
					else if (lvl >= 1000)
						deduction = 2.5+(lvl*0.001)
					else if (lvl >= 100)
						deduction = 1.0+(lvl*0.001)
					else if (lvl >= 10)
						deduction = 0.7+(lvl*0.001)

					var/final_speed = max(base_speed - deduction, 4.9) // Ensure speed never goes below 0.8
					return final_speed
			/*	Move()

					var/old_x = src.x
					var/old_y = src.y
					var/old_z = src.z
					..()
					//PodAura.alpha=185
				//	var/icon/i = PodAura.icon
					if (src.x != last_step_x || src.y != last_step_y || src.step_x != last_step_x || src.step_y != last_step_y)
						if (!(PodAura in src.overlays)) // Ensure it's not added repeatedly
							src.overlays += PodAura
						else
							spawn(60)
								src.overlays -= PodAura
					if(src.Speed >=0.8 && src.Speed <=1) src.overlays += /obj/effects/elec
					src.lastloc = src.loc
					src.last_step_x = src.step_x
					src.last_step_y = src.step_y
				/*	if(src && pilot) while(sr)
						if(round(src.speed_ramp) >= 3)
							for(var/obj/effects/after_image/af in pilot.afterimages)
								if(af.in_use == 0)
									af.loc = src.loc
									af.in_use = 1;
									af.icon_state = src.icon_state
									af.overlays = src.overlays
									af.alpha = 50
									af.step_x = src.step_x
									af.step_y = src.step_y
									af.dir = src.dir
									spawn(1.5)
										if(af)
											af.in_use = 0;
											af.loc = null
									break;
						if(round(src.speed_ramp) >= 6)
							if(src.speed_effect)
								if(src.Speed >=0.8 && src.Speed <=3)
									var/obj/h = src.speed_effect
									h.loc = src.loc
									h.dir = src.dir
									if(src.dir == SOUTH || src.dir == NORTH) h.pixel_x = -32
									else h.pixel_x = -40
									h.step_x = src.step_x
									h.step_y = src.step_y
							if(src.speed_skip == 0)
								//src.dust_and_furrows(pick(1,2,3,4,5,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0))
								//src.icon_state = "Block"
								src.speed_skip = 1
							else src.speed_skip = 0
						sr -= 1
					if(src.speed_ramp <= 0)
						src.speed_ramp = 0
						//src.icon_state = src.state()
						src.overlays -= /obj/effects/elec
					src.layer = MOB_LAYER + src.laymod - (src.y + src.step_y / 32) / world.maxy
					//src.set_shadow()

					*/
					sleep(5)
					*/


				New()
					tag = name
					category = list("Spacecraft")
					var/image/sel = image('fx.dmi',src,"select item",1000)
					src.img_select = sel
					mystille_cost=1200
					titanium_cost=6800
					coal_cost=1500
					copper_cost=4000
					stone_cost=6000
					//PodAura = new/obj/effects/Space_Pod_Aura
					spawn(10)
						if(src.loc)
							var/obj/shad = new
							var/icon/I = new(src.icon)
							I.icon -= rgb(255,255,255)
							//I.Flip(NORTH)
							shad.icon = I
							shad.alpha = 100
							shad.pixel_y = -9
							src.underlays += shad
							while(src)
								if(src.loc == null) return
								if(src.active)
									Speed = get_pod_speed(src.level)
								//	if(src.launched && !(PodAura in src.overlays)|| src.manualtravel && !(PodAura in src.overlays)) src.overlays += PodAura
									if(src.pilot) pilot.loc = src.loc
									if(!src.is_health_set)
										src.hp = 100*src.level
										src.is_health_set = 1


								sleep(20)

			Planetary_Hub
				info_name = "Planetary_Hub"
				icon = 'Planet_Outpost_Turfs.dmi'
				icon_state = "hub"
			//	pixel_x = -64
			//	pixel_y = -64
				hp = 999999999999999
				layer = 90
				plane=1
				bolted = 2
				hashadow = 0
				density_factor = 0
				cantStore=1
				//bounds = "19,45 to 44,21"
				mouse_over_pointer = MOUSE_ACTIVE_POINTER
				value = 1000
				mystille_cost=1200
				titanium_cost=6800
				coal_cost=1500
				copper_cost=4000
				stone_cost=6000
				can_pocket = 0
				weight = 100
				desc = "Drills operate much faster than other tools, and faster still than digging with bare hands. The amount dug up by these compared to basic digging is thrice times."
				tech_tree = "Engineering"
				tech_subtech = "Space Pods"
			//	act = /obj/items/tech/digging/Drill/proc/use
			//	act_drop = /obj/items/tech/digging/Drill/proc/drop
				appearance_flags = KEEP_TOGETHER
				tech_parent_path = /obj/items/tech/sub_tech/Engineering/Space_Pods
				has_subtech = 0
			//	act = /obj/items/tech/Planetary_Hub/proc/

				var/list/known_locations = list("Explore Space","Earth","Vegeta","Icer","Namek") // Default locations
				var/current_coordinates = null
				var/obj/items/Planets/Mains/autotravel_target = null
				var/launched = 0
				var/obj/effects/Space_Pod_Aura/PodAura
				var/Speed = 5
				var/speed_ramp = 0
				var/speed_skip = 0
				var/obj/speed_effect
				var/sr
				var/driving = 0
				var/obj/items/Planets/planet
				var/planet_mystille = 1000
				var/planet_copper = 1000
				var/planet_coal = 1000
				var/planet_stone = 1000
				var/planet_gold = 1000
				var/planet_titanium = 1000
				var/planet_silver = 1000
				var/resources_lvl = 1
				var/defenses_lvl = 1
				var/defense_mode = 0

				var
					landing = 0
					mob/hubowner = null
					defender_count = 0
					tmp/obj/tele = null
					tmp/autotravel = 0
					tmp/Travel = 0
					claimed = 0
				proc
					conquer_check(var/obj/items/tech/Planetary_Hub/i)
						if(i.defender_count>0) return 0
						else if(i.defender_count<=0) return 1
					claiming_check(var/mob/races/m,var/obj/items/tech/Planetary_Hub/i)
						if(m)
							if(!claimed)
								view(50,src)<<output("<b>The Planet has been conquered by [m]!</b>","actionoutput")
								i.claimed=1
								i.hubowner = usr
							else
								i.hubowner <<output("[i.name] has been conquered!","actionputput")
								i.hubowner = null
								sleep(0.5)
								i.hubowner = usr
					collect_minerals(var/mob/m)
						if(src.hubowner == m)
							for(var/obj/items/minerals/s in m.accessing)
								if(s)
								//	m.create_chat_entry("alerts","[src.planet_ref] Collection:\n\nStone:[planet_stone]\nCopper:[planet_copper]\nCoal:[planet_coal]\nSilver:[planet_silver]\nGold:[planet_gold]\nTitanium:[planet_titanium]\nMystille:[planet_mystille]")
								//	m.create_chat_entry("local","<font size=0.5>[src.planet_ref] Collection:\n\nStone:[planet_stone]\nCopper:[planet_copper]\nCoal:[planet_coal]\nSilver:[planet_silver]\nGold:[planet_gold]\nTitanium:[planet_titanium]\nMystille:[planet_mystille]</font>",0,1)

									if(s.name == "Silver")
										m << output("Silver Collected: [planet_silver]","actionoutput")
										s.stacks += planet_silver
										planet_silver =0
									if(s.name == "Mystille")
										m << output("Mystille Collected: [planet_mystille]","actionoutput")
										s.stacks += planet_mystille
										planet_mystille = 0
									if(s.name == "Titanium")
										m << output("Titanium Collected: [planet_titanium]","actionoutput")
										s.stacks += planet_titanium
										planet_titanium = 0
									if(s.name == "Copper")
										m << output("Copper Collected: [planet_copper]","actionoutput")
										s.stacks += planet_copper
										planet_copper = 0
									if(s.name == "Coal")
										m << output("Coal Collected: [planet_coal]","actionoutput")
										s.stacks += planet_coal
										planet_coal = 0
									if(s.name == "Gold")
										m << output("Gold Collected: [planet_gold]","actionoutput")
										s.stacks += planet_gold
										planet_gold = 0
									if(s.name == "Stone")
										m << output("Stone Collected: [planet_stone]","actionoutput")
										s.stacks += planet_stone
										planet_stone = 0



					give_ownership(var/mob/m)
						if(src.hubowner == m)
							for(var/mob/newowner in oview(25,m))
								if(newowner.client)
									switch(alert(m,"Are you sure you wish to grant ownership to [newowner.real_name]? This will remove your access to the hub interally.","","Yes","No"))
										if("Yes")
											switch(alert(m,"ARE YOU SURE you wish to grant ownership to [newowner.real_name]? Last warning of access removal.","","Yes","Nevermind"))
												if("Yes")
													if(hubowner) hubowner = null
													hubowner = newowner
													newowner.set_alert("You are now sovereign of [src.planet_ref]",'alert.dmi',"alert")
													return



					activate_defense(destination)
						if(src.defense_mode == 0 )
							for(var/mob/NPC/Defenders/turret/defenders)
								if(defenders.tag == src.tag)
									defenders.turret_idle_ai()
									//defenders.activate()
							src.defense_mode = 1
							src.hubowner.set_alert("Defense Mode ACTIVATED",'alert.dmi',"alert")

						else if(src.defense_mode == 1)
							for(var/mob/NPC/Defenders/turret/defenders)
								if(defenders.tag == src.tag)
									defenders.turret_idle_ai()
									//defenders.activate()
							src.defense_mode = 0
							src.hubowner.set_alert("Defense Mode DEACTIVATED",'alert.dmi',"alert")




					rename_planet(var/mob/m)
						var/newname = input ("Current Planet Name is: [planet.name]\nWhat will you rename it too?") as text
						if(newname)
							switch(alert(m,"Are you sure you wish to rename [planet.name] to [newname]?","","Yes","Cancel"))
								if("Yes")
									planet.name = "[newname]"
									m<<"Planet was renamed to [planet.name]!"
									return



					upgrade_defenses(var/mob/m)
						var/zenni_input = input("How much are you willing to spend for your defense upgrades?\nCurrent Level: [src.defenses_lvl]\n\nZ:") as num
						if(zenni_input<=-0) return
						if(zenni_input<0) return
						if(m.resources>=zenni_input)

							src.defenses_lvl += (zenni_input)
							for(var/mob/NPC/Defenders/defenders)
								if(defenders.tag == src.tag)
									defenders.psionic_power += (src.defenses_lvl * 0.1) * 2
							if(m.resources<=0) m.resources = 0
							m.refresh_inv()
							m.set_alert("[zenni_input] was spent to upgrade [src.planet_ref]'s defenses",'alert.dmi',"alert")
						else
							m.set_alert("Not enough zenni!",'alert.dmi',"alert")
							return
					upgrade_resources(var/mob/m)
						var/zenni_input = input("How much are you willing to spend for your resource upgrades?\nCurrent Level: [src.resources_lvl]\n\nZ:") as num
						if(zenni_input<=-0) return
						if(zenni_input<0) return
						if(m.resources>=zenni_input)

							src.resources_lvl += (zenni_input)
							if(m.resources<=0) m.resources = 0
							m.refresh_inv()
							m.set_alert("[zenni_input] was spent to upgrade [src.planet_ref]'s resources",'alert.dmi',"alert")
						else
							m.set_alert("Not enough zenni!",'alert.dmi',"alert")
							return
				verb
					switch_hub_command(var/mob/m)
						var/list/commands = list("Activate/Deactivate Defenders","Collect Minerals","Give Ownership","Rename Planet","Upgrade Resources","Upgrade Defense")
						var/command = input("Select a command:") as null|anything in commands
						if(command == "Collect Minerals") src.collect_minerals(m)
						else if(command == "Give Ownership") src.give_ownership(m)
						else if(command == "Upgrade Resources") src.upgrade_resources(m)
						else if (command == "Upgrade Defense") src.upgrade_defenses(m)
						else if (command == "Activate/Deactivate Defenders") src.activate_defense(m)
						else if (command == "Rename Planet") src.rename_planet(m)
				Click(location,control,params)
					..()
					params = params2list(params)
					if(params["left"])
						if(hubowner != usr)
							var/access = src.conquer_check(src)
							if(access)
								src.claiming_check(usr,src)
							else
						//	src.conquer_check()
								usr.set_alert("Acess Denied",'alert.dmi',"alert")
								return
						else if(hubowner == usr)
							switch_hub_command(usr)
					else if(params["right"])
						if(hubowner != usr)
							var/access = src.conquer_check(src)
							if(access)
								src.claiming_check(usr,src)
							else
						//	src.conquer_check()
								usr.set_alert("Acess Denied",'alert.dmi',"alert")
								return
						else if(hubowner == usr)
							switch_hub_command(usr)
					/*else if(params["right"])
						if(src.loc == null)
							for(var/obj/items/tech/Fuel/F in usr)
								if(F)
									call(act,src)(F,src,usr) */



				New()
					var/rng = rand(1000,9999)
					name = "Planet #[rng]"
					//tag = name
					category = list("Planetary Hub")
					var/image/sel = image('fx.dmi',src,"select item",1000)
					src.img_select = sel
					mystille_cost=1200
					titanium_cost=6800
					coal_cost=1500
					copper_cost=4000
					stone_cost=6000
					defender_count = rand(5,9)
					//src.active=1
					spawn(10)
						if(src.loc)
							var/obj/shad = new
							var/icon/I = new(src.icon)
							I.icon -= rgb(255,255,255)
							//I.Flip(NORTH)
							shad.icon = I
							shad.alpha = 100
							shad.pixel_y = -9
							src.underlays += shad
							while(src)
								if(src.loc == null) return
								if(src.active)
									if(!locate(src) in PlanetaryHubs)
										PlanetaryHubs += src
									planet_mystille += 100
									planet_gold += 100
									planet_coal += 100
									planet_titanium += 100
									planet_gold += 100
									planet_copper += 100
									planet_stone += 100


								sleep(900)
			Kid_Sparring_Gloves
				info_name = "Sparring Gloves(Kid)"
				mouse_over_pointer = MOUSE_ACTIVE_POINTER
				icon = 'SparGlovesKid.dmi'
				name = "Sparring Gloves(Kid)"
				value = 1000
				stone_cost = 300
				coal_cost = 40
				can_pocket = 1
				density_factor = 0
				weight = 1
				desc = "A protective glove for your hands best for pillowing punches."
				tech_tree = "Physics"
				tech_subtech = "Sparring Gloves"
				act = /obj/items/tech/Kid_Sparring_Gloves/proc/use
				act_drop = /obj/items/tech/Kid_Sparring_Gloves/proc/drop
				appearance_flags = KEEP_TOGETHER
				tech_parent_path = /obj/items/tech/sub_tech/Physics/Sparring_Gloves
				has_subtech = 0
				proc
					use(var/mob/m,var/obj/items/tech/i)
						if(i in m)
							for(var/obj/items/tech/Kid_Sparring_Gloves/A in m) if(A!=i && A.suffix)
								m << "You already have sparring gloves equipped."
								m.set_alert("Another glove set is already equipped.",'alert.dmi',"alert")
								return
							if(!i.suffix)
								if(findtext(i.name,"(Kid)"))
									if(m.age>=13)
										m<<"You cannot fit this item."
										return
								if(!findtext(i.name,"(Kid)"))
									if(m.age<13)
										m<<"You cannot fit this item."
										return

								i.suffix = "equipped"
								i.name = "Sparring Gloves(Kid) *equipped*"
								m.overlays += i.icon
								m.refresh_inv()
								m.sparring_gloves = i
								return
							else

								i.suffix = null
								i.name = "Sparring Gloves(Kid)"
								m.overlays -= i.icon
								m.refresh_inv()
								m.sparring_gloves = null
								return
					drop(var/mob/m,var/obj/items/tech/i)
						if(i in m.accessing)
							if(i.suffix)

								i.suffix = null
								i.name = "Sparring Gloves(Kid)"
								m.overlays -= i
							i.overlays -= /obj/effects/select_item
							m.drop(i)
							m.sparring_gloves = null
				New()
					tag = name
					category = list("Gloves")
					var/image/sel = image('fx.dmi',src,"select item",1000)
					src.img_select = sel
					hp = src.level

				Click(location,control,params)
					..()
					//Removes this item from the global Items list.
					if(items)
						if(src in items) items -= src
					params = params2list(params)
					if(params["left"])
						if(isturf(src.loc))
							usr.pickup(src)
							if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up [src]","actionoutput")
						else if(ismob(src.loc))
							if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
							usr.item_selected = src
							usr.refresh_inv()
			Sparring_Gloves
				info_name = "Sparring Gloves"
				mouse_over_pointer = MOUSE_ACTIVE_POINTER
				icon = 'SparGloves.dmi'
				value = 1000
				stone_cost = 300
				coal_cost = 40
				can_pocket = 1
				density_factor = 0
				weight = 1
				desc = "A protective glove for your hands best for pillowing punches."
				tech_tree = "Physics"
				tech_subtech = "Sparring Gloves"
				act = /obj/items/tech/Sparring_Gloves/proc/use
				act_drop = /obj/items/tech/Sparring_Gloves/proc/drop
				appearance_flags = KEEP_TOGETHER
				tech_parent_path = /obj/items/tech/sub_tech/Physics/Sparring_Gloves
				has_subtech = 0
				proc
					use(var/mob/m,var/obj/items/tech/i)
						if(i in m)
							for(var/obj/items/tech/Sparring_Gloves/A in m) if(A!=i && A.suffix)
								m << "You already have sparring gloves equipped."
								m.set_alert("Another glove set is already equipped.",'alert.dmi',"alert")
								return
							if(!i.suffix)
								if(findtext(i.name,"(Kid)"))
									if(m.age>=13)
										m<<"You cannot fit this item."
										return
								if(!findtext(i.name,"(Kid)"))
									if(m.age<13)
										m<<"You cannot fit this item."
										return

								i.suffix = "equipped"
								i.name = "Sparring Gloves *equipped*"
								m.overlays += i.icon
								m.refresh_inv()
								m.sparring_gloves = i
								return
							else

								i.suffix = null
								i.name = "Sparring Gloves"
								m.overlays -= i.icon
								m.refresh_inv()
								m.sparring_gloves = null
								return
					drop(var/mob/m,var/obj/items/tech/i)
						if(i in m.accessing)
							if(i.suffix)

								i.suffix = null
								i.name = "Sparring Gloves"
								m.overlays -= i
							i.overlays -= /obj/effects/select_item
							m.drop(i)
							m.sparring_gloves = null
				New()
					tag = name
					category = list("Gloves")
					var/image/sel = image('fx.dmi',src,"select item",1000)
					src.img_select = sel
					hp = src.level

				Click(location,control,params)
					..()
					//Removes this item from the global Items list.
					if(items)
						if(src in items) items -= src
					params = params2list(params)
					if(params["left"])
						if(isturf(src.loc))
							usr.pickup(src)
							if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up [src]","actionoutput")
						else if(ismob(src.loc))
							if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
							usr.item_selected = src
							usr.refresh_inv()


			weights
				change_icon = 0
				can_pocket = 1;
				cantStore=1;
				stacks = -1
				weight = 1
				standby = 1
				mystille_cost=2
				titanium_cost=2
				stone_cost=2
				desc = "Weighted clothing can be very useful for increasing your Strength and Power. So long as you wear weights that are as heavy as half your Lift, you will gain benefit from using them.\n\nKeep in mind that wearing these will decrease your Agility slightly, making you slower in combat. And will also force your Power to half while worn, due to the strain of wearing them.\n\nRight clicking these in their creation menu will allow you to set their weight. The higher their weight, the higher the cost for their production."
				act = /obj/items/tech/weights/proc/use
				act_drop = /obj/items/tech/weights/proc/drop
				floor_state = "ground"
				appearance_flags = KEEP_TOGETHER
				var/weight_type
				has_subtech = 0
				tech_parent_path = /obj/items/tech/sub_tech/Engineering/Weights
				proc
					use(var/mob/m,var/obj/items/tech/weights/i)
						if(i in m.accessing)
							var/mob/x = m.accessing
							//Remove
							if(i.suffix == "worn")
								i.overlays -= /obj/effects/select_item
								i.icon_state = "ground"
								i.layer = 3
								i.suffix = null
								i.name = "[initial(i.name)] ([i.weight]kg)"
								x.update_weight()
								x.redraw_appearance()
								i.overlays += /obj/effects/select_item
								x.refresh_inv()
								return
							else
								//Wear
								if(findtext(i.name,"(Kid)"))
									if(m.age>=13)
										m<< "You cannot fit this item."
										return
								if(!findtext(i.name,"(Kid)"))
									if(m.age<13)
										m<< "You cannot fit this item."
										return
								//var/lift_raw = m.strength + (m.endurance * 4)
								//var/lift_kg = round(4.5 + lift_raw * 0.45359237 * 0.01, 0.01)
								//var/lift_kg = round(4.5 + lift_raw * 0.45359237 * 0.01, 0.01)
								//if((i.weight+4.5) > lift_kg)
								if(i.weight > m.lift_kg)
									m<< "Too heavy to fit."
									m.set_alert("Exceeds max lift",'alert.dmi',"alert")
									return

								var/w_num = 0
								var/w_current = i.weight
								for(var/obj/items/tech/weights/wgt in x)
									if(wgt.suffix == "worn" && i.weight_type != wgt.weight_type)
										w_num += 1
										w_current += wgt.weight
								if(w_num >= 4)
									m << "[x] cannot wear more than 4 sets of weighted clothing or items."
									m.set_alert("Too many weights",'alert.dmi',"alert")
									return
								if(w_current > m.lift_kg)
									m << "Too heavy to fit."
									m.set_alert("Exceeds max lift",'alert.dmi',"alert")
									return
								i.overlays -= /obj/effects/select_item
								i.icon_state = ""
								i.layer = FLOAT_LAYER
								i.suffix = "worn"
								i.name = "[i.name] *worn*"
								x.update_weight()
								x.redraw_appearance()
								i.overlays += /obj/effects/select_item
								x.refresh_inv()
								return
					drop(var/mob/m,var/obj/items/tech/weights/i)
						//Drop
						if(i in m.accessing)
							var/mob/x = m.accessing
							//Remove first
							if(i.suffix == "worn")
								i.icon_state = ""
								i.layer = 3
								i.suffix = null
								i.name = "[initial(i.name)] ([i.weight]kg)"
								i.desc_extra = "- [i.weight]kg weights\n\n"
								x.update_weight()
								x.redraw_appearance()
							m.drop(i)
							return
				Click(location,control,params)
					..()
					//Removes this item from the global Items list.
					if(items)
						if(src in items) items -= src
					params = params2list(params)
					if(params["left"])
						if(isturf(src.loc))
							usr.pickup(src)
							if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up [src]","actionoutput")
						else if(ismob(src.loc))
							if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
							usr.item_selected = src
							src.overlays -= /obj/effects/select_item
							src.overlays += /obj/effects/select_item
							usr.refresh_inv()
					else if(params["right"])
						if(src.loc == null)
							//winset(usr,"numbers.label_numbers","text=\"How heavy do you want to make these weights? Higher weights cost more.\"")
							//winshow(usr,"numbers",1)
							usr.numbers_text = "tech weights"
							usr.left_click_ref = src
							//winset(usr,"numbers.input_number","focus=true")
							usr.hud_confirm_nums.confirm_text(1,"How heavy do you want to make these weights?",usr)
				kid_wrist_bands
					icon = 'item_weights_wrist_kid.dmi'
					icon_state = ""
					name = "Wrist Weights(Kid)"
					value = 1000
					layer = 3
					density_factor = 0
					has_subtech = 0
					tech_tree = "Engineering"
					tech_subtech = "Weights"
					appearance_flags = KEEP_TOGETHER
					weight_type = "wrist"
					New()
						var/image/sel = image('fx_medium.dmi',src,"select item",1000)
						src.img_select = sel
						spawn(10)
							if(src && src.spawned == 0)
								if(isturf(src.loc) && src.standby == 0)
									src.icon_state = ""
									src.name = "[src.name] ([src.weight]kg)"
									src.desc_extra = "- [src.weight]kg weights\n\n"
									src.spawned = 1
									src.standby = 1
				kid_ankle_bands
					icon = 'item_weights_ankle_kid.dmi'
					icon_state = ""
					name = "Ankle Weights(Kid)"
					value = 1000
					layer = 3
					density_factor = 0
					has_subtech = 0
					tech_tree = "Engineering"
					tech_subtech = "Weights"
					weight_type = "ankle"
					appearance_flags = KEEP_TOGETHER
					New()
						var/image/sel = image('fx_medium.dmi',src,"select item",1000)
						src.img_select = sel
						spawn(6)
							if(src && src.spawned == 0) if(isturf(src.loc))
								src.icon_state = ""
								src.name = "[src.name] ([src.weight]kg)"
								src.desc_extra = "- [src.weight]kg weights\n\n"
								src.spawned = 1
				kid_arm_bands
					icon = 'item_weights_arm_kid.dmi'
					icon_state = ""
					name = "Arm Weights(Kid)"
					value = 1000
					layer = 3
					density_factor = 0
					has_subtech = 0
					tech_tree = "Engineering"
					tech_subtech = "Weights"
					weight_type = "arm"
					appearance_flags = KEEP_TOGETHER
					New()
						var/image/sel = image('fx_medium.dmi',src,"select item",1000)
						src.img_select = sel
						spawn(6)
							if(src && src.spawned == 0) if(isturf(src.loc))
								src.icon_state = ""
								src.name = "[src.name] ([src.weight]kg)"
								src.desc_extra = "- [src.weight]kg weights\n\n"
								src.spawned = 1
				kid_leg_bands
					icon = 'item_weights_leg_kid.dmi'
					icon_state = ""
					name = "Leg Weights(Kid)"
					value = 1000
					layer = 3
					density_factor = 0
					has_subtech = 0
					tech_tree = "Engineering"
					tech_subtech = "Weights"
					weight_type = "leg"
					appearance_flags = KEEP_TOGETHER
					New()
						var/image/sel = image('fx_medium.dmi',src,"select item",1000)
						src.img_select = sel
						spawn(6)
							if(src && src.spawned == 0) if(isturf(src.loc))
								src.icon_state = ""
								src.name = "[src.name] ([src.weight]kg)"
								src.desc_extra = "- [src.weight]kg weights\n\n"
								src.spawned = 1
				wrist_bands
					icon = 'item_weights_wrist.dmi'
					icon_state = ""
					name = "Wrist Weights"
					value = 1000
					layer = 3
					density_factor = 0
					has_subtech = 0
					tech_tree = "Engineering"
					tech_subtech = "Weights"
					appearance_flags = KEEP_TOGETHER
					weight_type = "wrist"
					New()
						var/image/sel = image('fx_medium.dmi',src,"select item",1000)
						src.img_select = sel
						spawn(6)
							if(src && src.spawned == 0) if(isturf(src.loc))
								src.icon_state = ""
								src.name = "[src.name] ([src.weight]kg)"
								src.desc_extra = "- [src.weight]kg weights\n\n"
								src.spawned = 1
				ankle_bands
					icon = 'item_weights_ankle.dmi'
					icon_state = ""
					name = "Ankle Weights"
					value = 1000
					layer = 3
					density_factor = 0
					has_subtech = 0
					tech_tree = "Engineering"
					tech_subtech = "Weights"
					weight_type = "ankle"
					appearance_flags = KEEP_TOGETHER
					New()
						var/image/sel = image('fx_medium.dmi',src,"select item",1000)
						src.img_select = sel
						spawn(6)
							if(src && src.spawned == 0) if(isturf(src.loc))
								src.icon_state = ""
								src.name = "[src.name] ([src.weight]kg)"
								src.desc_extra = "- [src.weight]kg weights\n\n"
								src.spawned = 1
				arm_bands
					icon = 'item_weights_arm.dmi'
					icon_state = ""
					name = "Arm Weights"
					value = 1000
					layer = 3
					density_factor = 0
					has_subtech = 0
					tech_tree = "Engineering"
					tech_subtech = "Weights"
					weight_type = "arm"
					appearance_flags = KEEP_TOGETHER
					New()
						var/image/sel = image('fx_medium.dmi',src,"select item",1000)
						src.img_select = sel
						spawn(6)
							if(src && src.spawned == 0) if(isturf(src.loc))
								src.icon_state = ""
								src.name = "[src.name] ([src.weight]kg)"
								src.desc_extra = "- [src.weight]kg weights\n\n"
								src.spawned = 1
				leg_bands
					icon = 'item_weights_leg.dmi'
					icon_state = ""
					name = "Leg Weights"
					value = 1000
					layer = 3
					density_factor = 0
					has_subtech = 0
					tech_tree = "Engineering"
					tech_subtech = "Weights"
					weight_type = "leg"
					appearance_flags = KEEP_TOGETHER
					New()
						var/image/sel = image('fx_medium.dmi',src,"select item",1000)
						src.img_select = sel
						spawn(6)
							if(src && src.spawned == 0) if(isturf(src.loc))
								src.icon_state = ""
								src.name = "[src.name] ([src.weight]kg)"
								src.desc_extra = "- [src.weight]kg weights\n\n"
								src.spawned = 1
			digging
				stacks = -1
				cantStore=1
				Drill
					info_name = "Drill"
					mouse_over_pointer = MOUSE_ACTIVE_POINTER
					icon = 'drill.dmi'
					value = 1000

					mystille_cost=1200
					titanium_cost=6800
					coal_cost=1500
					copper_cost=4000
					stone_cost=6000

					can_pocket = 1
					density_factor = 0
					weight = 1
					desc = "Drills operate much faster than other tools, and faster still than digging with bare hands. The amount dug up by these compared to basic digging is thrice times."
					tech_tree = "Engineering"
					act = /obj/items/tech/digging/Drill/proc/use
					act_drop = /obj/items/tech/digging/Drill/proc/drop
					appearance_flags = KEEP_TOGETHER
					has_subtech = 1
					proc
						use(var/mob/m,var/obj/items/tech/i)
							if(i in m.accessing)
								var/mob/x = m.accessing
								for(var/obj/items/tech/digging/A in x) if(A!=i && A.suffix)
									m << "Already have a tool equipped."
									m.set_alert("Another tool already equipped.",'alert.dmi',"alert")
								//	m.create_chat_entry("alerts","Another tool already equipped.")
									return
								if(!i.suffix)
									i.suffix = "equipped"
									i.name = "Drill *equipped*"
									if(m.skill_dig && m.skill_dig.active)
										m.skill_dig.dig_mod = 3
										m.overlays += 'drill_dig.dmi'
										m.icon_state = "drill"
									m.refresh_inv()
									return
								else
									i.suffix = null
									i.name = "Drill"
									if(m.skill_dig)
										m.skill_dig.dig_mod = 1
										m.overlays -= 'drill_dig.dmi'
										if(m.skill_dig.active) m.icon_state = "dig"
									m.refresh_inv()
									return
						drop(var/mob/m,var/obj/items/tech/i)
							if(i in m.accessing)
								if(i.suffix)
									i.suffix = null
									i.name = "Drill"
									if(m.skill_dig)
										m.skill_dig.dig_mod = 1
										m.overlays -= 'drill_dig.dmi'
										if(m.skill_dig.active) m.icon_state = "dig"
								m.drop(i)
					New()
						tag = name
						category = list("Resource Extraction")
						var/image/sel = image('fx.dmi',src,"select item",1000)
						src.img_select = sel
					Click(location,control,params)
						..()
						//Removes this item from the global Items list.
						if(items)
							if(src in items) items -= src
						params = params2list(params)
						if(params["left"])
							if(isturf(src.loc))
								usr.pickup(src)
								if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up [src]","actionoutput")
							else if(ismob(src.loc))
								if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
								usr.item_selected = src
								src.overlays -= /obj/effects/select_item
								src.overlays += /obj/effects/select_item
								usr.refresh_inv()
				Super_Drill
					info_name = "Super Drill"
					mouse_over_pointer = MOUSE_ACTIVE_POINTER
					icon = 'New_Drill.dmi'
					icon_state="still"

					value = 1000

					mystille_cost=400
					titanium_cost=180
					copper_cost=700

					can_pocket = 1
					density_factor = 0
					weight = 1
					desc = "Super Drills will help extremely with digging, helping you extract more resources. They are three times as good as digging with bare hands."
					tech_tree = "Engineering"
					tech_subtech = "Super Drills"
					act = /obj/items/tech/digging/Super_Drill/proc/use
					act_drop = /obj/items/tech/digging/Super_Drill/proc/drop
					appearance_flags = KEEP_TOGETHER
				//	tech_parent_path = /obj/items/tech/sub_tech/Engineering/Super_Drills
					has_subtech = 0
					proc
						use(var/mob/m,var/obj/items/tech/i)
							if(i in m)
								for(var/obj/items/tech/digging/A in m) if(A!=i && A.suffix)
									m << "You already have a tool equipped."
									m.set_alert("Another tool already equipped.",'alert.dmi',"alert")
								//	m.create_chat_entry("alerts","Another tool already equipped.")
									return
								if(!i.suffix)
									i.suffix = "equipped"
									i.name = "Super Drill *equipped*"
									if(m.skill_dig && m.skill_dig.active)
										m.skill_dig.dig_mod = 5 + i.tech_lvl
										m.overlays += /obj/effects/SuperDrill_Dig

									m.refresh_inv()
									return
								else
									i.suffix = null
									i.name = "Super Drill"
									if(m.skill_dig)
										m.skill_dig.dig_mod = 1
										m.overlays -= /obj/effects/SuperDrill_Dig
									///	if(m.skill_dig.active) m.icon_state = ""
									m.refresh_inv()
									return
						drop(var/mob/m,var/obj/items/tech/i)
							if(i in m.accessing)
								if(i.suffix)
									i.suffix = null
									i.name = "Super Drill"
									if(m.skill_dig)
										m.skill_dig.dig_mod = 1
										m.overlays -= /obj/effects/SuperDrill_Dig
									//	if(m.skill_dig.active) m.icon_state = ""
								m.drop(i)
					New()
						tag = name
						category = list("Advanced Resource Extraction")
						var/image/sel = image('fx.dmi',src,"select item",1000)
						src.img_select = sel
					Click(location,control,params)
						..()
						//Removes this item from the global Items list.
						if(items)
							if(src in items) items -= src
						params = params2list(params)
						if(params["left"])
							if(isturf(src.loc))
								usr.pickup(src)
								if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up [src]","actionoutput")
							else if(ismob(src.loc))
								if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
								usr.item_selected = src
								src.overlays -= /obj/effects/select_item
								src.overlays += /obj/effects/select_item
								usr.refresh_inv()
				Hand_Drill
					info_name = "Hand Drill"
					mouse_over_pointer = MOUSE_ACTIVE_POINTER
					icon = 'mining_hand_drill.dmi'

					value = 1000

					mystille_cost=400
					titanium_cost=180
					copper_cost=700

					can_pocket = 1
					density_factor = 0
					weight = 1
					desc = "Shovels will help with manual digging quite a bit, helping you extract more resources faster. They are twice as good as digging with bare hands."
					tech_tree = "Engineering"
					tech_subtech = "Hand Drills"
					act = /obj/items/tech/digging/Hand_Drill/proc/use
					act_drop = /obj/items/tech/digging/Hand_Drill/proc/drop
					appearance_flags = KEEP_TOGETHER
				//	tech_parent_path = /obj/items/tech/sub_tech/Engineering/Hand_Drills
					has_subtech = 0
					proc
						use(var/mob/m,var/obj/items/tech/i)
							if(i in m)
								for(var/obj/items/tech/digging/A in m) if(A!=i && A.suffix)
									m << "You already have a tool equipped."
									m.set_alert("Another tool already equipped.",'alert.dmi',"alert")
								//	m.create_chat_entry("alerts","Another tool already equipped.")
									return
								if(!i.suffix)
									i.suffix = "equipped"
									i.name = "Hand Drill *equipped*"
									if(m.skill_dig && m.skill_dig.active)
										m.skill_dig.dig_mod = 3 + i.tech_lvl
										m.overlays += /obj/effects/HandDrill_Dig

									m.refresh_inv()
									return
								else
									i.suffix = null
									i.name = "Hand Drill"
									if(m.skill_dig)
										m.skill_dig.dig_mod = 1
										m.overlays -= /obj/effects/HandDrill_Dig
									///	if(m.skill_dig.active) m.icon_state = ""
									m.refresh_inv()
									return
						drop(var/mob/m,var/obj/items/tech/i)
							if(i in m.accessing)
								if(i.suffix)
									i.suffix = null
									i.name = "Hand Drill"
									if(m.skill_dig)
										m.skill_dig.dig_mod = 1
										m.overlays -= /obj/effects/HandDrill_Dig
									//	if(m.skill_dig.active) m.icon_state = ""
								m.drop(i)
					New()
						tag = name
						category = list("Resource Extraction")
						var/image/sel = image('fx.dmi',src,"select item",1000)
						src.img_select = sel
					Click(location,control,params)
						..()
						//Removes this item from the global Items list.
						if(items)
							if(src in items) items -= src
						params = params2list(params)
						if(params["left"])
							if(isturf(src.loc))
								usr.pickup(src)
								if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up [src]","actionoutput")
							else if(ismob(src.loc))
								if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
								usr.item_selected = src
								src.overlays -= /obj/effects/select_item
								src.overlays += /obj/effects/select_item
								usr.refresh_inv()
				Shovel
					info_name = "Shovel"
					mouse_over_pointer = MOUSE_ACTIVE_POINTER
					icon = 'spade.dmi'
					value = 1000

					mystille_cost=400
					titanium_cost=180
					copper_cost=700

					can_pocket = 1
					density_factor = 0
					weight = 1
					desc = "Shovels will help with manual digging quite a bit, helping you extract more resources faster. They are twice as good as digging with bare hands."
					tech_tree = "Engineering"
					tech_subtech = "Shovels"
					act = /obj/items/tech/digging/Shovel/proc/use
					act_drop = /obj/items/tech/digging/Shovel/proc/drop
					appearance_flags = KEEP_TOGETHER
					tech_parent_path = /obj/items/tech/sub_tech/Engineering/Shovels
					has_subtech = 0
					proc
						use(var/mob/m,var/obj/items/tech/i)
							if(i in m)
								for(var/obj/items/tech/digging/A in m) if(A!=i && A.suffix)
									m << "You already have a tool equipped."
									m.set_alert("Another tool already equipped.",'alert.dmi',"alert")
								//	m.create_chat_entry("alerts","Another tool already equipped.")
									return
								if(!i.suffix)
									i.suffix = "equipped"
									i.name = "Shovel *equipped*"
									if(m.skill_dig && m.skill_dig.active)
										m.skill_dig.dig_mod = 2
										m.overlays += /obj/effects/HandDrill_Dig
										m.dir = SOUTH
									m.refresh_inv()
									return
								else
									i.suffix = null
									i.name = "Shovel"
									if(m.skill_dig)
										m.skill_dig.dig_mod = 1
										m.overlays -= /obj/effects/HandDrill_Dig
										if(m.skill_dig.active) m.icon_state = "dig"
									m.refresh_inv()
									return
						drop(var/mob/m,var/obj/items/tech/i)
							if(i in m.accessing)
								if(i.suffix)
									i.suffix = null
									i.name = "Shovel"
									if(m.skill_dig)
										m.skill_dig.dig_mod = 1
										m.overlays -= /obj/effects/HandDrill_Dig
										if(m.skill_dig.active) m.icon_state = "dig"
								m.drop(i)
					New()
						tag = name
						category = list("Resource Extraction")
						var/image/sel = image('fx.dmi',src,"select item",1000)
						src.img_select = sel
					Click(location,control,params)
						..()
						//Removes this item from the global Items list.
						if(items)
							if(src in items) items -= src
						params = params2list(params)
						if(params["left"])
							if(isturf(src.loc))
								usr.pickup(src)
								if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up [src]","actionoutput")
							else if(ismob(src.loc))
								if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
								usr.item_selected = src
								src.overlays -= /obj/effects/select_item
								src.overlays += /obj/effects/select_item
								usr.refresh_inv()
			doors
				opacity = 1
				var/pass = null
				cantStore=1
				layer=3
				Security_Ship_Doors
					info_name = "Security_Ship_Doors"
					mouse_over_pointer = MOUSE_ACTIVE_POINTER
					icon = 'GlassDoors.dmi'
					icon_state = "Closed"
					density_factor = 2
					bolted = 2
					hashadow = 0
					hp=9999999999999999999999999999999
					//can_attack = 0
					desc = ""
					tech_tree = "Engineering"
					var/icons = list('door_tech_01.dmi','door_tech_02.dmi','door_tech_03.dmi','door_tech_04.dmi')
					var/I = 1
					invul_melee = 1
					capsule_storable = 0


					New()
						tag = name
						category = list("Resource Extraction")
						var/image/sel = image('fx.dmi',src,"select item",1000)
						src.img_select = sel
					Click(location,control,params)
						..()
						winset(usr,"map.map","focus=true")
						params = params2list(params)

						if(params["right"])
							/*if(src.loc == null)
								var/L = length(src.icons)
								if(I+1 > L) I = 1
								else I += 1
								src.icon = src.icons[I]
								if(usr.build_tech_selected == src)
									var/icon/I = icon(src.icon,src.icon_state,SOUTH,1,0)
									I.Scale(src.scale_x,src.scale_y)
									var/Z = fcopy_rsc(I)
									winset(usr,"tech.label_img","image=\ref[Z]")*/
							if(src.density_factor >= 1 && src.loc)
								if(src.pass != null)
									if(winget(usr,"confirm","is-visible") == "false")
										winset(usr,"numbers.label_numbers","text=\"Enter door password.\"")
										winshow(usr,"numbers",1)
										usr.numbers_text = "door password"
										usr.left_click_ref = src
										winset(usr,"numbers.input_number","focus=true")
								else
									src.icon_state = "Opening"
									src.density_factor = 0
									sleep(60)
									src.icon_state = "Closing"
									src.density_factor = 2
						else if(src.loc)
							if(ismob(usr))
								if(src.ship_ref.locked == 1) return
								src.icon_state = "Opening"
								src.density_factor = 0
								src.opacity = 0
								spawn(10)
									src.icon_state = "Closing"
									src.density_factor = 1
									src.opacity = 1
									spawn(20) src.icon_state = "Closed"

								if(usr.in_space_ship == 1)
									if(src.ship_ref.locked == 0 )
										usr.loc=locate(src.ship_ref.x+2,src.ship_ref.y-2,src.ship_ref.z)
										if(usr.z == initial(usr.z)) usr.loc = src.exit
										spawn(1) usr.in_space_ship = 0
										if(usr.z == 16 ) usr.apply_space_glow(1)
										usr.apply_gravity_glow(0,0,0)


				Security_Door_MKI
					info_name = "Security Door Mk I"
					mouse_over_pointer = MOUSE_ACTIVE_POINTER
					icon = 'door_tech_01.dmi'
					icon_state = "closed"
					value = 0
					can_pocket = 0
					density_factor = 2
					bolted = 2
					hashadow = 0
					weight = 1
					cantStore=1
					desc = ""
					tech_tree = "Engineering"
					has_subtech = 0
					var/icons = list('door_tech_01.dmi','door_tech_02.dmi','door_tech_03.dmi','door_tech_04.dmi')
					var/I = 1
					New()
						tag = name
						category = list("Resource Extraction")
						var/image/sel = image('fx.dmi',src,"select item",1000)
						src.img_select = sel
					Click(location,control,params)
						..()
						winset(usr,"map.map","focus=true")
						params = params2list(params)
						if(params["right"])
							if(src.loc == null)
								var/L = length(src.icons)
								if(I+1 > L) I = 1
								else I += 1
								src.icon = src.icons[I]
								if(usr.build_tech_selected == src)
									var/icon/I = icon(src.icon,src.icon_state,SOUTH,1,0)
									I.Scale(src.scale_x,src.scale_y)
									var/Z = fcopy_rsc(I)
									winset(usr,"tech.label_img","image=\ref[Z]")
							else if(src.density_factor >= 1)
								if(src.pass != null)
									if(winget(usr,"confirm","is-visible") == "false")
										winset(usr,"numbers.label_numbers","text=\"Enter door password.\"")
										winshow(usr,"numbers",1)
										usr.numbers_text = "door password"
										usr.left_click_ref = src
										winset(usr,"numbers.input_number","focus=true")
								else
									src.icon_state = "opening"
									src.density_factor = 0
									sleep(60)
									src.icon_state = "closing"
									src.density_factor = 2
						else if(src.loc)
							if(get_dist(src,usr) <= 1)
								for(var/mob/m in range(8,src))
									m << output("There is a loud knock on the door!","chat.local")
			Refridgerator
				info_name = "Refridgerator"
				mouse_over_pointer = MOUSE_ACTIVE_POINTER
				icon = 'refridgerator.dmi'
				icon_state = ""
				value = 1000

				mystille_cost=50
				titanium_cost=180
				coal_cost=25
				stone_cost=280

				can_pocket = 0
				density_factor = 0
				weight = 1
				desc = "This handy portable container will let you store items inside that are far in excess the size of this device. It can fit just about anything within itself, so long as an item isn't bolted to the ground. To use the device, place it near something you want stored and then right click the canister. To unload it, simply right click again."
				tech_tree = "Engineering"
				tech_subtech = "Compression Techniques"
				act = /obj/items/tech/Refridgerator/proc/use
				act_drop = /obj/items/tech/Refridgerator/proc/drop
				appearance_flags = KEEP_TOGETHER
				tech_parent_path = /obj/items/tech/sub_tech/Engineering/Refridgerators
				stacks = -1
				has_subtech =0
				proc
					use(var/mob/m,var/obj/items/tech/i)
						if(i in m.accessing)
							var/mob/x = m.accessing
							x.drop(i)
							i.overlays -= /obj/effects/select_item
							x.refresh_inv()
					drop(var/mob/m,var/obj/items/tech/i)
						m.drop(i)

					AdjustCapacity()
						if(src.level>=1400 && src.level < 3500) src.maxlimit = 4
						if(src.level>=3500 && src.level < 5000) src.maxlimit = 5
						if(src.level>=5000 && src.level < 6000) src.maxlimit = 6
						if(src.level>=6000 && src.level < 7000) src.maxlimit = 7
						if(src.level>=7000) src.maxlimit = 8
					prompt_fridge(var/mob/m)
						switch(alert(m,"Select an option:","","Store Away","Retrieve"))
							if("Store Away")
								src.Store_Away(m)
							if("Retrieve")
								src.Open_Fridge(m)
				//verb
					Store_Away(var/mob/m)

						if (food_count >= maxlimit)
							m << "The refrigerator is full!"
							return

						var/list/food_options = list()
						for (var/obj/items/consumables/food/i in m)
							food_options += i

						if (!food_options.len)
							m << "You have no food items to store."
							return

						var/obj/items/consumables/food/selected_food = input(m, "Select the food to store:", "Store Food") in food_options
						if (!selected_food) return

						var/store_amount = input(m, "Enter amount to store (Max: [selected_food.stacks])", "Store Food") as num
						if (store_amount <= 0 || store_amount > selected_food.stacks)
							m << "Invalid amount."
							return

						if (store_amount > (maxlimit - food_count))
							m << "Not enough space in the refridgerator."
							return

						var/obj/items/consumables/food/new_food_item = new selected_food.type()
						new_food_item.CopyAttributes(selected_food)
						new_food_item.stacks = store_amount
						new_food_item.fridge = 1

						stored_items += new_food_item
						selected_food.stacks -= store_amount
						if (selected_food.stacks <= 0)
							del selected_food

						food_count += store_amount
						for (var/mob/M in view(25, m))
							M << output("[M.get_strangername(usr)] stored [store_amount] [new_food_item.name] in the refrigerator.","actionoutput")

					Open_Fridge(var/mob/m)
						if (food_count == 0)
							m << "The refrigerator is empty."
							return

						var/list/food_options = list()
						for (var/obj/items/consumables/food/i in stored_items)
							i.name += " (Amount: [i.stacks])"
							food_options += i

						if (!food_options.len)
							m << "The refrigerator is empty."
							return

						var/obj/items/consumables/food/selected_food = input(usr, "Select the food to retrieve:", "Retrieve Food") in food_options
						if (!selected_food) return

						var/retrieve_amount = input(usr, "Enter amount to retrieve (Max: [selected_food.stacks])", "Retrieve Food") as num
						if (retrieve_amount <= 0 || retrieve_amount > selected_food.stacks)
							usr << "Invalid amount."
							return
						selected_food.name = initial(selected_food.name)
						//var/obj/items/consumables/food/new_food_item = new selected_food.type()
						//new_food_item.CopyAttributes(selected_food)
						selected_food.stacks = retrieve_amount

						//selected_food.stacks -= retrieve_amount
						if (retrieve_amount >= selected_food.stacks)
							stored_items -= selected_food
							//del selected_food
						selected_food.fridge = 0
						food_count -= retrieve_amount
						m.pickup(selected_food,0)
						//new_food_item.Move(usr)


						for (var/mob/M in view(25, m))
							M << output("[M.get_strangername(usr)] retrieved [retrieve_amount] [selected_food.name] from the refrigerator.", "actionoutput")

					Check_Capacity()
						usr << "Current Capacity: [food_count]/[maxlimit]"
				New()
					..()
					tag = name
					category = list("Storage")
					var/image/sel = image('fx.dmi',src,"select item",1000)
					src.img_select = sel
					spawn(10)
						src.AdjustCapacity()
				Click(location,control,params)
					..()
					winset(usr,"map.map","focus=true")
					params = params2list(params)
					if(params["left"])
						if(isturf(src.loc))
							src.prompt_fridge(usr)
							return
						else if(ismob(src.loc))
							if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
							usr.item_selected = src
							src.overlays -= /obj/effects/select_item
							src.overlays += /obj/effects/select_item
					if(params["right"])
						if(isturf(src.loc))
							src.prompt_fridge(usr)
							return
			Mini_Refridgerator
				info_name = "Mini_Refridgerator"
				mouse_over_pointer = MOUSE_ACTIVE_POINTER
				icon = 'PortableFridgeA.dmi'
				icon_state = "closed"
				value = 1000

				mystille_cost=50
				titanium_cost=180
				coal_cost=25
				stone_cost=280

				can_pocket = 0
				density_factor = 0
				weight = 1
				desc = "This handy portable container will let you store items inside that are far in excess the size of this device. It can fit just about anything within itself, so long as an item isn't bolted to the ground. To use the device, place it near something you want stored and then right click the canister. To unload it, simply right click again."
				tech_tree = "Engineering"
				tech_subtech = "Compression Techniques"
				act = /obj/items/tech/Mini_Refridgerator/proc/use
				act_drop = /obj/items/tech/Mini_Refridgerator/proc/drop
				appearance_flags = KEEP_TOGETHER
				tech_parent_path = /obj/items/tech/sub_tech/Engineering/Basic_Storage
				stacks = -1
				has_subtech = 0
				proc
					use(var/mob/m,var/obj/items/tech/i)
						if(i in m.accessing)
							var/mob/x = m.accessing
							x.drop(i)
							i.compress("right",x)
							i.overlays -= /obj/effects/select_item
							x.refresh_inv()
					drop(var/mob/m,var/obj/items/tech/i)
						m.drop(i)
				New()
					tag = name
					category = list("Storage")
					var/image/sel = image('fx.dmi',src,"select item",1000)
					src.img_select = sel
				Click(location,control,params)
					..()
					winset(usr,"map.map","focus=true")
					params = params2list(params)
					if(params["left"])
						if(isturf(src.loc))
							usr.pickup(src)
							return
						else if(ismob(src.loc))
							if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
							usr.item_selected = src
							src.overlays -= /obj/effects/select_item
							src.overlays += /obj/effects/select_item
					if(params["right"])
						if(isturf(src.loc))
							src.compress("right",usr)
							return
			Gravity_Controller
				info_name = "Gravity_Controller"
				mouse_over_pointer = MOUSE_ACTIVE_POINTER
				icon = 'item_podcontrol.dmi'
				icon_state = ""
				value = 1000
				copper_cost=600
				silver_cost=200
				titanium_cost=800
				gold_cost=950

				can_pocket = 1
				density_factor = 0
				weight = 1
				desc = "This handy portable container will let you store items inside that are far in excess the size of this device. It can fit just about anything within itself, so long as an item isn't bolted to the ground. To use the device, place it near something you want stored and then right click the canister. To unload it, simply right click again."
				tech_tree = "Physics"
				tech_subtech = "Gravitational Fields"
				act = /obj/items/tech/Gravity_Controller/proc/use
				act_drop = /obj/items/tech/Gravity_Controller/proc/drop
				appearance_flags = KEEP_TOGETHER
				tech_parent_path = /obj/items/tech/sub_tech/Physics/Gravitational_Fields
				stacks = -1
				has_subtech= 0
				proc
					use(var/mob/m,var/obj/items/tech/i)
						if(i in m.accessing)
							var/mob/x = m.accessing
							x.drop(i)
							i.compress("right",x)
							i.overlays -= /obj/effects/select_item
							x.refresh_inv()
					drop(var/mob/m,var/obj/items/tech/i)
						m.drop(i)
				New()
					tag = name
					category = list("Gravitational Fields")
					var/image/sel = image('fx.dmi',src,"select item",1000)
					src.img_select = sel
				Click(location,control,params)
					..()
					winset(usr,"map.map","focus=true")
					params = params2list(params)
					if(params["left"])
						if(isturf(src.loc))
							usr.pickup(src)
							if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up [src]","actionoutput")
							return
						else if(ismob(src.loc))
							if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
							usr.item_selected = src
							src.overlays -= /obj/effects/select_item
							src.overlays += /obj/effects/select_item
					if(params["right"])
						if(isturf(src.loc))
							src.compress("right",usr)
							return
			/*Bed_Roll
				info_name = "Bed_Roll"
				mouse_over_pointer = MOUSE_ACTIVE_POINTER
				icon = 'BedRoll_Colorable (1).dmi'
				icon_state = ""
				value = 1000
				copper_cost=90
				stone_cost=140
				titanium_cost=90
			//	gold_cost=950

				can_pocket = 1
				density_factor = 0
				weight = 1
				desc = "This handy portable container will let you store items inside that are far in excess the size of this device. It can fit just about anything within itself, so long as an item isn't bolted to the ground. To use the device, place it near something you want stored and then right click the canister. To unload it, simply right click again."
				tech_tree = "Engineering"
				tech_subtech = "Bed Rolls"
				act = /obj/items/tech/Bed_Roll/proc/use
				act_drop = /obj/items/tech/Bed_Roll/proc/drop
				appearance_flags = KEEP_TOGETHER
				tech_parent_path = /obj/items/tech/sub_tech/Engineering/Spacecraft_Hulls
				stacks = -1
				has_subtech = 0
				proc
					use(var/mob/m,var/obj/items/tech/i)
						if(i in m.accessing)
							var/mob/x = m.accessing
							x.drop(i)
							i.compress("right",x)
							i.overlays -= /obj/effects/select_item
							x.refresh_inv()
					drop(var/mob/m,var/obj/items/tech/i)
						m.drop(i)
				New()
					tag = name
					category = list("Engineering")
					var/image/sel = image('fx.dmi',src,"select item",1000)
					src.img_select = sel
				Click(location,control,params)
					..()
					winset(usr,"map.map","focus=true")
					params = params2list(params)
					if(params["left"])
						if(isturf(src.loc))
							usr.pickup(src)
							return
						else if(ismob(src.loc))
							if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
							usr.item_selected = src
							usr.build_tech_selected = src
							src.overlays -= /obj/effects/select_item
							src.overlays += /obj/effects/select_item
					if(params["right"])
						if(isturf(src.loc))
							src.compress("right",usr)
							return

							*/
			Water_Purifier
				info_name = "Water_Purifier"
				mouse_over_pointer = MOUSE_ACTIVE_POINTER
				icon = 'purifier.dmi'
				icon_state = ""
				value = 1000
				copper_cost=32
				stone_cost=38
				titanium_cost=32
				coal_cost=38
			//	gold_cost=950

				can_pocket = 0
				density_factor = 1
				density=1
				weight = 1
				desc = "A compact purification unit capable of cleansing seawater and contaminated sources into clean, usable water. Designed for survival beyond established settlements, it provides safe hydration for travelers and a reliable water supply for crop irrigation. An essential tool for sustaining life in harsh or undeveloped environments."
				tech_tree = "Engineering"
				tech_subtech = "Water_Purifier"
				act = /obj/items/tech/Water_Purifier/proc/use
				//act_drop = /obj/items/tech/Water_Purifier/proc/drop
				appearance_flags = KEEP_TOGETHER
				tech_parent_path = /obj/items/tech/sub_tech/Engineering/Water_Purifier
				stacks = -1
				has_subtech = 0
				var
					purified = 0
					purifying = 0
					working = 0

				proc
					use(var/mob/m,var/obj/items/tech/i)
						if(i in m.accessing)
							var/mob/x = m.accessing
							x.drop(i)
							i.compress("right",x)
							i.overlays -= /obj/effects/select_item
							x.refresh_inv()
					drop(var/mob/m,var/obj/items/tech/i)
						m.drop(i)
				New()
					tag = name
					category = list("Engineering")
					var/image/sel = image('fx.dmi',src,"select item",1000)
					src.img_select = sel
					if(isturf(src.loc))
						spawn(4980)
							if(src && isturf(src.loc))
								view(10,src)<<output("The water purifier is going to decay soon!","actionoutput")


						spawn(6000)
							if(src && isturf(src.loc))
								view(10,src)<<output("The water purifier has decayed!","actionoutput")
								src.destroy()

				Click(location,control,params)
					..()
					winset(usr,"map.map","focus=true")
					params = params2list(params)
					if(params["left"])
						if(isturf(src.loc))
							if(src.purified==1&&src.purifying==0)
							//	usr.water+=(100/src.quality)*0.03
								var/collection=10
								view(20,src)<<output("[usr] collects [collection] water from the water purifier","actionoutput")

								//src.icon_state="Empty"
								src.purified=0
								src.purifying=0
								src.working=0
								var/obj/items/consumables/water/water_bottle/E=new/obj/items/consumables/water/water_bottle

								E.stacks+=(collection-1)

								usr.give_water(E,1)
								return
							else
								if(src.purifying==1&&src.working==1)
									usr<<output("It's still purfying water!","actionoutput")
									return
							if(src.purifying==0)

								var/seawaternumber = 10
								var/total_dirty = 0

								for(var/obj/items/consumables/water/water_bottle_dirty/E in usr)
									total_dirty += E.stacks

								if(total_dirty < seawaternumber)
									usr << output("You need [seawaternumber] sea water to use the water purifier","actionoutput")
									return

								// We have enough. Now remove across stacks.
								view(src) << output("The water purifier begins purifying water!","actionoutput")

								var/remaining = seawaternumber

								for(var/obj/items/consumables/water/water_bottle_dirty/E in usr)
									if(remaining <= 0) break

									if(E.stacks <= remaining)
										remaining -= E.stacks
										E.use_obj(usr, E.stacks)
									else
										E.use_obj(usr, remaining)
										remaining = 0

								usr.refresh_inv()

								src.purifying = 1
								src.working = 1

								spawn(3000)
									oview(30,src) << output("The water purifier has finished purifying water!","actionoutput")
									usr.set_alert("The water purifier has finished purifying water!",'alert.dmi',"alert")
									src.purified = 1
									src.working = 0
									src.purifying = 0


								/*for(var/obj/items/consumables/water/water_bottle_dirty/E in usr)
									if(E.stacks>seawaternumber)
										view(src)<<output("The water purifier begins purifying water!","actionoutput")
										//src.icon_state="Process"
										E.use_obj(usr,seawaternumber)
										usr.refresh_inv()
										//E.stacks-=seawaternumber
										src.purifying=1
										src.working=1
										//if(E.stacks<=0) del(E)

							//		for(var/obj/items/Sea_Water/S in usr)
								//		S.Amount-=seawaternumber

										spawn(3000)
											oview(30,src)<<output("The water purifier has finished purifying water!","actionoutput")
											usr.set_alert("The water purifier has finished purifying water!",'alert.dmi',"alert")
											//src.icon_state="Done"
											src.purified=1
											src.working=0
											src.purifying=0
										break

									else
										usr<<output("You need [seawaternumber] sea water to use the water purifier","actionoutput")
										return*/
								return
						else if(ismob(src.loc))
							if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
							usr.item_selected = src
							usr.build_tech_selected = src
							src.overlays -= /obj/effects/select_item
							src.overlays += /obj/effects/select_item
					if(params["right"])
						if(isturf(src.loc))
							src.compress("right",usr)
							return
			Pod_Control
				info_name = "Pod_Control"
				mouse_over_pointer = MOUSE_ACTIVE_POINTER
				icon = 'item_podcontrol.dmi'
				icon_state = ""
				value = 1000
				copper_cost=600
				silver_cost=200
				titanium_cost=800
				gold_cost=950

				can_pocket = 1
				density_factor = 0
				weight = 1
				desc = "A handheld control unit linked to a registered space pod, capable of remotely summoning it on demand. Includes secure authorization to trigger the pod’s self-destruct sequence in emergency situations. Commonly carried by pilots and off-world operators."
				tech_tree = "Engineering"
				tech_subtech = "Spacecraft Hulls"
				act = /obj/items/tech/Pod_Control/proc/use
				act_drop = /obj/items/tech/Pod_Control/proc/drop
				appearance_flags = KEEP_TOGETHER
				tech_parent_path = /obj/items/tech/sub_tech/Engineering/Spacecraft_Hulls
				stacks = -1
				has_subtech = 0
				proc
					use(var/mob/m,var/obj/items/tech/i)
						if(i in m.accessing)
							var/mob/x = m.accessing
							x.drop(i)
							i.compress("right",x)
							i.overlays -= /obj/effects/select_item
							x.refresh_inv()
					drop(var/mob/m,var/obj/items/tech/i)
						m.drop(i)
				New()
					tag = name
					category = list("Spacecraft Hulls")
					var/image/sel = image('fx.dmi',src,"select item",1000)
					src.img_select = sel
				Click(location,control,params)
					..()
					winset(usr,"map.map","focus=true")
					params = params2list(params)
					if(params["left"])
						if(isturf(src.loc))
							usr.pickup(src)
							if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up [src]","actionoutput")
							return
						else if(ismob(src.loc))
							if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
							usr.item_selected = src
							src.overlays -= /obj/effects/select_item
							src.overlays += /obj/effects/select_item
							usr.refresh_inv()
					if(params["right"])
						if(isturf(src.loc))
							src.compress("right",usr)
							return
			Locator
				info_name = "Locator"
				mouse_over_pointer = MOUSE_ACTIVE_POINTER
				icon = 'item_locator.dmi'
				icon_state = ""
				value = 1000

				mystille_cost=50
				titanium_cost=180
				coal_cost=25
				stone_cost=280

				can_pocket = 1
				density_factor = 0
				weight = 1
				desc = "A wearable navigation device that continuously tracks and displays the user’s precise spatial coordinates. By recording positional data over time, it allows key locations to be memorized and revisited with ease. Commonly used by explorers, scouts, and engineers operating across vast or unfamiliar terrain, the Locator serves as a reliable guide where landmarks and maps fall short."
				tech_tree = "Engineering"
				tech_subtech = "Compression Techniques"
				act = /obj/items/tech/Locator/proc/use
				act_drop = /obj/items/tech/Locator/proc/drop
				appearance_flags = KEEP_TOGETHER
				tech_parent_path = /obj/items/tech/sub_tech/Engineering/Locators
				stacks = -1
				has_subtech = 0



				proc
					use(var/mob/m,var/obj/items/tech/i)
						//i.compress("right",m)
						if(!i.suffix)
							if(!m.hud_coords)
								var/obj/hud/menus/locator_coords/coords = new
								m.hud_coords = coords
							m.hud_coords.coordinator = m
							m.client.screen += m.hud_coords
							i.suffix = "equipped"
							i.name = "Locator *equipped*"
							m.refresh_inv()
							return
						else if(i.suffix)
							if(m.hud_coords)
								m.client.screen -= m.hud_coords
							if(m.hud_coords.coordinator)
								m.hud_coords.coordinator = null
							i.suffix = ""
							i.name = "Locator"
							m.refresh_inv()
					drop(var/mob/m,var/obj/items/tech/i)
						i.overlays -= /obj/effects/select_item
						m.drop(i)
				New()
					tag = name
					category = list("Storage")
					var/image/sel = image('fx.dmi',src,"select item",1000)
					src.img_select = sel
				Click(location,control,params)
					..()
					winset(usr,"map.map","focus=true")
					params = params2list(params)
					if(params["left"])
						if(isturf(src.loc))
							usr.pickup(src)
							if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up [src]","actionoutput")
							return
						else if(ismob(src.loc))
							if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
							usr.item_selected = src
							usr.refresh_inv()

			Capsule
				info_name = "Capsule"
				mouse_over_pointer = MOUSE_ACTIVE_POINTER
				icon = 'item_capsule.dmi'
				icon_state = ""
				value = 1000

				mystille_cost=50
				titanium_cost=180
				coal_cost=25
				stone_cost=280

				can_pocket = 1
				density_factor = 0
				weight = 1
				desc = "This handy portable container will let you store items inside that are far in excess the size of this device. It can fit just about anything within itself, so long as an item isn't bolted to the ground. To use the device, click use from the inventory and select a target. To unload it, simply click use again in the inventory while it is selected.."
				desc_extra = "Stored Item: Empty"
				tech_tree = "Engineering"
				tech_subtech = "Compression Techniques"
				act = /obj/items/tech/Capsule/proc/use
				act_drop = /obj/items/tech/Capsule/proc/drop
				appearance_flags = KEEP_TOGETHER
				tech_parent_path = /obj/items/tech/sub_tech/Engineering/Capsules
				stacks = -1
				has_subtech = 0



				proc
					use(var/mob/m,var/obj/items/tech/i)
						//i.compress("right",m)
						if(i in m)
							if(i.occupied)
								i.Open(m)
								i.name = "Capsule"
								i.desc_extra = "Stored Item: Empty\n\n"
								m.refresh_inv()
								return

							m.left_click_function = "capsule"
							m.left_click_ref = i
							m.set_alert("Select an item to store inside",i.icon,i.icon_state)

								//var/obj/items/tech/target = input("Select an item to store") as null|obj in view(2,m)
							//	target.Move(i)
								//i.storeditem = target
								//i.Store(m)
								//i.name = "Capsule - [i.storeditem]"
							//m.refresh_inv()
							//return

						//	else if(i.occupied)
							//	i.Open(m)
							//	i.name = "Capsule"
							//	m.refresh_inv()
							//	return
					drop(var/mob/m,var/obj/items/tech/i)
						i.overlays -= /obj/effects/select_item
						m.drop(i)
				New()
					tag = name
					category = list("Storage")
					var/image/sel = image('fx.dmi',src,"select item",1000)
					src.img_select = sel
					src.occupied = 0

				Click(location,control,params)
					..()
					winset(usr,"map.map","focus=true")
					params = params2list(params)
					if(params["left"])
						if(isturf(src.loc))
							usr.pickup(src)
							if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up [src]","actionoutput")
							return
						else if(ismob(src.loc))
							if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
							usr.item_selected = src
							usr.refresh_inv()


			drainers/Witch_Pot
				info_name = "Witch_Pot"
				mouse_over_pointer = MOUSE_ACTIVE_POINTER
				icon = 'NewWaterPurifiers.dmi'
				icon_state ="Empty"
				value = 1000
				stone_cost = 6550
				copper_cost = 1250
				coal_cost = 550
				mystille_cost=2150
				titanium_cost=275
				can_pocket = 1
				density_factor = 0
				weight = 1
				var/batterylife = 1
				var/energy_supply = 0
				desc = "A reliable tool to absorb the energy from those nearby in close combat. For every successful attack, you'll be syphoning a portion of energy from your opponent.\n Current Energy Supply: 0"
				tech_tree = "Engineering"
			//	tech_subtech = "Artifical DNA"
				act = /obj/items/tech/drainers/Witch_Pot/proc/use
				act_drop = /obj/items/tech/drainers/Witch_Pot/proc/drop
				appearance_flags = KEEP_TOGETHER
				//tech_parent_path = /obj/items/tech/sub_tech/Engineering/Artifical_DNA
				has_subtech = 0

				proc
					activate(var/mob/m,var/obj/items/tech/drainers/Witch_Pot/i)
						if(!i in m)
							return
					use(var/mob/m,var/obj/items/tech/drainers/Witch_Pot/i)
						if(i in m)
							m.drop(i)
							return

					drop(var/mob/m,var/obj/items/tech/i)
						if(i in m.accessing)

							m.drop(i)
				New()
					tag = name
					category = list("Drainer")
					var/image/sel = image('fx.dmi',src,"select item",1000)
					src.img_select = sel
					desc = "A reliable tool to absorb the energy from those nearby in close combat. For every successful attack, you'll be syphoning a portion of energy from your opponent.\n\n<font color = green> Current Energy Supply: </font><b>[src.energy_supply]</b>"

				Click(location,control,params)
					..()
					//Removes this item from the global Items list.
					if(items)
						if(src in items) items -= src
					params = params2list(params)
					if(params["left"])
						if(isturf(src.loc))
							usr.pickup(src)
							if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up [src]","actionoutput")
						else if(ismob(src.loc))
							if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
							usr.item_selected = src

			drainers/Energy_Drainer
				info_name = "Energy_Drainer"
				mouse_over_pointer = MOUSE_ACTIVE_POINTER
				icon = 'Majin_Energy_Drainer_1.dmi'
				icon_state ="Drainer"
				value = 1000
				stone_cost = 6550
				copper_cost = 1250
				coal_cost = 550
				mystille_cost=2150
				titanium_cost=275
				can_pocket = 1
				density_factor = 0
				weight = 1
				var/batterylife = 1
				var/energy_supply = 0
				desc = "A reliable tool to absorb the energy from those nearby in close combat. For every successful attack, you'll be syphoning a portion of energy from your opponent.\n Current Energy Supply: 0"
				tech_tree = "Engineering"
			//	tech_subtech = "Artifical DNA"
				act = /obj/items/tech/drainers/Energy_Drainer/proc/use
				act_drop = /obj/items/tech/drainers/Energy_Drainer/proc/drop
				appearance_flags = KEEP_TOGETHER
				//tech_parent_path = /obj/items/tech/sub_tech/Engineering/Artifical_DNA
				has_subtech = 0
				proc
					use(var/mob/m,var/obj/items/tech/drainers/i)
						if(i in m)
							for(var/obj/items/tech/drainers/Energy_Drainer/A in m) if(A!=i && A.suffix)
								m << "You already have a draining device equipped."
								m.set_alert("Another draining device is already equipped.",'alert.dmi',"alert")
							//	m.create_chat_entry("alerts","Another draining device is already equipped.")
								return
							if(!i.suffix)
								i.suffix = "equipped"
								i.name = "Energy Drainer *equipped*"
								if(!m.e_drainer_equipped)

									m.e_drainer_equipped = i
									//m.overlays += i
								m.refresh_inv()
								return
							else
								i.suffix = null
								i.name = "Energy Drainer"
								if(m.e_drainer_equipped)
									m.e_drainer_equipped = null
									//m.overlays -= i
								m.refresh_inv()
								return
					drop(var/mob/m,var/obj/items/tech/i)
						if(i in m.accessing)
							if(i.suffix)
								i.suffix = null
								i.name = "Energy Drainer"
								if(m.e_drainer_equipped)
									m.sword_pl = 0
									m.e_drainer_equipped = null

							m.drop(i)
				New()
					tag = name
					category = list("Drainer")
					var/image/sel = image('fx.dmi',src,"select item",1000)
					src.img_select = sel
					desc = "A reliable tool to absorb the energy from those nearby in close combat. For every successful attack, you'll be syphoning a portion of energy from your opponent.\n\n<font color = green> Current Energy Supply: </font><b>[src.energy_supply]</b>"

				Click(location,control,params)
					..()
					//Removes this item from the global Items list.
					if(items)
						if(src in items) items -= src
					params = params2list(params)
					if(params["left"])
						if(isturf(src.loc))
							usr.pickup(src)
							if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up [src]","actionoutput")
						else if(ismob(src.loc))
							if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
							usr.item_selected = src
							usr.refresh_inv()

			drainers/DNA_Drainer
				info_name = "DNA_Drainer"
				mouse_over_pointer = MOUSE_ACTIVE_POINTER
				icon = 'Majin_Energy_Drainer_1.dmi'
				icon_state ="Drainer"
				value = 1000
				stone_cost = 6550
				copper_cost = 1250
				coal_cost = 550
				mystille_cost=2150
				titanium_cost=275
				can_pocket = 1
				density_factor = 0
				weight = 1
				var/batterylife = 1
				desc = "A close-range genetic extraction device that siphons DNA from living targets with each successful hit. Collected genetic material is stored internally for use in bio-engineering tanks and advanced research.\n Current DNA Supply: 0"
				tech_tree = "Engineering"
				tech_subtech = "Artifical DNA"
				act = /obj/items/tech/drainers/DNA_Drainer/proc/use
				act_drop = /obj/items/tech/drainers/DNA_Drainer/proc/drop
				appearance_flags = KEEP_TOGETHER
				//tech_parent_path = /obj/items/tech/sub_tech/Engineering/Artifical_DNA
				has_subtech = 0
				proc
					use(var/mob/m,var/obj/items/tech/i)
						if(i in m)
							for(var/obj/items/tech/digging/A in m) if(A!=i && A.suffix)
								m << "You already have a tool equipped."
								m.set_alert("Another tool already equipped.",'alert.dmi',"alert")
							//	m.create_chat_entry("alerts","Another tool already equipped.")
								return
							if(!i.suffix)
								i.suffix = "equipped"
								i.name = "Sword *equipped*"
								if(m.sword_pl == 0)

									m.sword_pl = i:sword_power
									m.overlays += i
								m.refresh_inv()
								return
							else
								i.suffix = null
								i.name = "Sword"
								if(m.sword_pl > 0)
									m.sword_pl = 0
									m.overlays -= i
								m.refresh_inv()
								return
					drop(var/mob/m,var/obj/items/tech/i)
						if(i in m.accessing)
							if(i.suffix)
								i.suffix = null
								i.name = "Sword"
								if(m.sword_pl > 0)
									m.sword_pl = 0
									m.overlays -= i
							i.overlays -= /obj/effects/select_item
							m.drop(i)
				New()
					tag = name
					category = list("Artifical DNA")
					var/image/sel = image('fx.dmi',src,"select item",1000)
					src.img_select = sel

				Click(location,control,params)
					..()
					//Removes this item from the global Items list.
					if(items)
						if(src in items) items -= src
					params = params2list(params)
					if(params["left"])
						if(isturf(src.loc))
							usr.pickup(src)
							if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up [src]","actionoutput")
						else if(ismob(src.loc))
							if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
							usr.item_selected = src
							usr.refresh_inv()

			Mining_Bot
				info_name = "Mining_Bot"
				mouse_over_pointer = MOUSE_ACTIVE_POINTER
				icon = 'LilRobo.dmi'
				value = 1000
				stone_cost = 3300
				coal_cost = 800
				mystille_cost=1150
				titanium_cost=380
				can_pocket = 1
				density_factor = 0
				weight = 1
				var/batterylife = 1
				desc = "An autonomous mining unit that extracts ore from nearby terrain using internal power reserves. Commonly deployed to automate resource gathering in hazardous or remote locations."
				tech_tree = "Engineering"
				tech_subtech = "Robotics"
				act = /obj/items/tech/Mining_Bot/proc/use
				act_drop = /obj/items/tech/Mining_Bot/proc/drop
				appearance_flags = KEEP_TOGETHER
				tech_parent_path = /obj/items/tech/sub_tech/Engineering/Robotics
				has_subtech = 0
				proc
					use(var/mob/m,var/obj/items/tech/i)
						if(i in m)
							for(var/obj/items/tech/digging/A in m) if(A!=i && A.suffix)
								m << "You already have a tool equipped."
								m.set_alert("Another tool already equipped.",'alert.dmi',"alert")
							//	m.create_chat_entry("alerts","Another tool already equipped.")
								return
							if(!i.suffix)
								i.suffix = "equipped"
								i.name = "Sword *equipped*"
								if(m.sword_pl == 0)
									m.sword_pl = i:sword_power
									m.overlays += i
								m.refresh_inv()
								return
							else
								i.suffix = null
								i.name = "Sword"
								if(m.sword_pl > 0)
									m.sword_pl = 0
									m.overlays -= i
								m.refresh_inv()
								return
					drop(var/mob/m,var/obj/items/tech/i)
						if(i in m.accessing)
							if(i.suffix)
								i.suffix = null
								i.name = "Sword"
								if(m.sword_pl > 0)
									m.sword_pl = 0
									m.overlays -= i
							i.overlays -= /obj/effects/select_item
							m.drop(i)
				New()
					tag = name
					category = list("Robotics")
					var/image/sel = image('fx.dmi',src,"select item",1000)
					src.img_select = sel
				Click(location,control,params)
					..()
					//Removes this item from the global Items list.
					if(items)
						if(src in items) items -= src
					params = params2list(params)
					if(params["left"])
						if(isturf(src.loc))
							usr.pickup(src)
							if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up [src]","actionoutput")
						else if(ismob(src.loc))
							if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
							usr.item_selected = src
							usr.refresh_inv()

			Kid_Bandages
				name = "Bandages(Kid)"
				info_name = "Kid_Bandages"
				mouse_over_pointer = MOUSE_ACTIVE_POINTER
				icon = 'item_bandages_kid.dmi'
				value = 1000
				stone_cost = 3300
				coal_cost = 800
				mystille_cost=1150
				titanium_cost=380
				can_pocket = 1
				density_factor = 0
				weight = 1
				desc = "A bundle of protective wrap best for recovering serious injuries."
				tech_tree = "Genetics"
				tech_subtech = "Medical Equipment"
				act = /obj/items/tech/Kid_Bandages/proc/use
				act_drop = /obj/items/tech/Kid_Bandages/proc/drop
				appearance_flags = KEEP_TOGETHER
				tech_parent_path = /obj/items/tech/sub_tech/Genetics/Medical_Equipment
				has_subtech = 0
				proc
					use(var/mob/m,var/obj/items/tech/i)
						if(i in m)
							for(var/obj/items/tech/Kid_Bandages/A in m) if(A!=i && A.suffix)
								m << "You already have bandages equipped."
								m.set_alert("Another bandage set is already equipped.",'alert.dmi',"alert")
								return
							if(!i.suffix)
								if(findtext(i.name,"(Kid)"))
									if(m.age>=13)
										m<<"You cannot fit this item."
										return
								if(!findtext(i.name,"(Kid)"))
									if(m.age<13)
										m<<"You cannot fit this item."
										return
								m.bandaged=1
								i.suffix = "equipped"
								i.name = "Bandages(Kid) (Equipped)"
								m.overlays += i.icon

								m.refresh_inv()
								return
							else
								m.bandaged=0
								i.suffix = null
								i.name = "Bandages(Kid)"
								m.overlays -= i

								m.refresh_inv()
								return
					drop(var/mob/m,var/obj/items/tech/i)
						if(i in m.accessing)
							if(i.suffix)
								m.bandaged=0
								i.suffix = null
								i.name = "Bandages(Kid)"
								m.overlays -= i
							i.overlays -= /obj/effects/select_item
							m.drop(i)
				New()
					tag = name
					category = list("Swords")
					var/image/sel = image('fx.dmi',src,"select item",1000)
					src.img_select = sel

				Click(location,control,params)
					..()
					//Removes this item from the global Items list.
					if(items)
						if(src in items) items -= src
					params = params2list(params)
					if(params["left"])
						if(isturf(src.loc))
							usr.pickup(src)
							if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up [src]","actionoutput")
						else if(ismob(src.loc))
							if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
							usr.item_selected = src
							usr.refresh_inv()

			Bandages
				info_name = "Bandages"
				mouse_over_pointer = MOUSE_ACTIVE_POINTER
				icon = 'item_bandages.dmi'
				value = 1000
				stone_cost = 3300
				coal_cost = 800
				mystille_cost=1150
				titanium_cost=380
				can_pocket = 1
				density_factor = 0
				weight = 1
				desc = "A bundle of protective wrap best for recovering serious injuries."
				tech_tree = "Genetics"
				tech_subtech = "Medical Equipment"
				act = /obj/items/tech/Bandages/proc/use
				act_drop = /obj/items/tech/Bandages/proc/drop
				appearance_flags = KEEP_TOGETHER
				tech_parent_path = /obj/items/tech/sub_tech/Genetics/Medical_Equipment
				has_subtech = 0
				proc
					use(var/mob/m,var/obj/items/tech/i)
						if(i in m)
							for(var/obj/items/tech/Kid_Bandages/A in m) if(A!=i && A.suffix)
								m << "You already have bandages equipped."
								m.set_alert("Another bandage set is already equipped.",'alert.dmi',"alert")
								return
							if(!i.suffix)
								if(findtext(i.name,"(Kid)"))
									if(m.age>=13)
										m<<"You cannot fit this item."
										return
								if(!findtext(i.name,"(Kid)"))
									if(m.age<13)
										m<<"You cannot fit this item."
										return
								m.bandaged=1
								i.suffix = "equipped"
								i.name = "Bandages (Equipped)"
								m.overlays += i.icon
								m.refresh_inv()
								return
							else
								m.bandaged=0
								i.suffix = null
								i.name = "Bandages"
								m.overlays -= i.icon
								m.refresh_inv()
								return
					drop(var/mob/m,var/obj/items/tech/i)
						if(i in m.accessing)
							if(i.suffix)
								m.bandaged=0
								i.suffix = null
								i.name = "Bandages"
								m.overlays -= i
							i.overlays -= /obj/effects/select_item
							m.drop(i)
				New()
					tag = name
					category = list("Swords")
					var/image/sel = image('fx.dmi',src,"select item",1000)
					src.img_select = sel

				Click(location,control,params)
					..()
					//Removes this item from the global Items list.
					if(items)
						if(src in items) items -= src
					params = params2list(params)
					if(params["left"])
						if(isturf(src.loc))
							usr.pickup(src)
							if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up [src]","actionoutput")
						else if(ismob(src.loc))
							if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
							usr.item_selected = src
							usr.refresh_inv()


			weapons
				Sword
					info_name = "Sword"
					mouse_over_pointer = MOUSE_ACTIVE_POINTER
					icon = 'item_sword.dmi'
					value = 1000
					stone_cost = 3300
					coal_cost = 800
					mystille_cost=1150
					titanium_cost=380
					can_pocket = 1
					density_factor = 0
					weight = 1
					var/sword_power = 1
					var/sword_spd = 0
					var/sword_off = 0
					weapon = 1
					desc = "A reliable weapon for close combat, swords offer precision and power with every swing. Whether you're clashing against enemies or training your technique, they’re a timeless tool of any skilled warrior."
					tech_tree = "Engineering"
					tech_subtech = "Swords"
					act = /obj/items/tech/weapons/Sword/proc/use
					//act_drop = /obj/items/tech/weapons/Sword/proc/drop
					appearance_flags = KEEP_TOGETHER
					tech_parent_path = /obj/items/tech/sub_tech/Engineering/Swords
					has_subtech = 0
					proc
						use(var/mob/m,var/obj/items/tech/weapons/i)
							if(i in m)
								for(var/obj/items/tech/weapons/A in m) if(A!=i && A.suffix)
									m << "You already have a weapon equipped."
									m.set_alert("Another weapon is already equipped.",'alert.dmi',"alert")
									//m.create_chat_entry("alerts","Another sword is already equipped.")
									return
								if(!i.suffix)
									if(findtext(i.name,"(Kid)"))
										if(m.age>=13)
											m<<"You cannot fit this item."
											return
									if(!findtext(i.name,"(Kid)"))
										if(m.age<13)
											m<<"You cannot fit this item."
											return
									i.suffix = "equipped"
									i.name = "Sword (Equipped)"
									if(m.sword_pl == 0 || m.sword_pl <=1)

										m.sword_pl = (i.level*0.125)
										m.overlays += i.icon
										var/sword_bonus = min(125, 125 * (m.weapon_stance / 250) ^ 0.75)
										i.desc_extra = null
										if(i:sword_spd) i.desc_extra = "Speed Quality: +[sword_bonus]%\n\n"
										if(i:sword_off) i.desc_extra = "Offence Quality: +[sword_bonus]%\n\n"


									m.refresh_inv()
									return
								else
									i.suffix = null
									i.name = "Sword"
									if(m.sword_pl > 0)
										m.sword_pl = 0
										m.overlays -= i.icon
									m.refresh_inv()
									return
						drop(var/mob/m,var/obj/items/tech/weapons/Sword/i)
							if(i in m.accessing)
								if(i.suffix)
									i.suffix = null
									i.name = "Sword"
									if(m.sword_pl > 0)
										m.sword_pl = 0
										m.overlays -= i
								src.overlays -= /obj/effects/select_item
								m.drop(i)
					New()
						tag = name
						category = list("Weapons")
						var/image/sel = image('fx.dmi',src,"select item",1000)
						src.img_select = sel

					Click(location,control,params)
						..()
						//Removes this item from the global Items list.
						if(items)
							if(src in items) items -= src
						params = params2list(params)
						if(params["left"])
							if(isturf(src.loc))
								usr.pickup(src)
								if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up [src]","actionoutput")
							else if(ismob(src.loc))
								if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
								usr.item_selected = src
								usr.refresh_inv()
				Kid_Sword
					name = "Sword(Kid)"
					info_name = "Kid_Sword"
					mouse_over_pointer = MOUSE_ACTIVE_POINTER
					icon = 'item_sword_kid.dmi'
					value = 1000
					stone_cost = 3300
					coal_cost = 800
					mystille_cost=1150
					titanium_cost=380
					can_pocket = 1
					density_factor = 0
					weight = 1
					var/sword_power = 1
					weapon = 1
					desc = "A reliable weapon for close combat, swords offer precision and power with every swing. Whether you're clashing against enemies or training your technique, they’re a timeless tool of any skilled warrior."
					tech_tree = "Engineering"
					tech_subtech = "Swords"
					act = /obj/items/tech/weapons/Kid_Sword/proc/use
					//act_drop = /obj/items/tech/weapons/Kid_Sword/proc/drop
					appearance_flags = KEEP_TOGETHER
					tech_parent_path = /obj/items/tech/sub_tech/Engineering/Swords
					has_subtech = 0
					proc
						use(var/mob/m,var/obj/items/tech/weapons/i)
							if(i in m)
								for(var/obj/items/tech/weapons/A in m) if(A!=i && A.suffix)
									m << "You already have a weapon equipped."
									m.set_alert("Another weapon is already equipped.",'alert.dmi',"alert")
									//m.create_chat_entry("alerts","Another sword is already equipped.")
									return
								if(!i.suffix)
									if(findtext(i.name,"(Kid)"))
										if(m.age>=13)
											m<<"You cannot fit this item."
											return
									if(!findtext(i.name,"(Kid)"))
										if(m.age<13)
											m<<"You cannot fit this item."
											return
									i.suffix = "equipped"
									i.name = "Sword(Kid) (Equipped)"
									if(m.sword_pl == 0 || m.sword_pl <=1)

										m.sword_pl = (i.level)
										m.overlays += i.icon
									m.refresh_inv()
									return
								else

									i.suffix = null
									i.name = "Sword(Kid)"
									if(m.sword_pl > 0)
										m.sword_pl = 0
										m.overlays -= i.icon
									m.refresh_inv()
									return
						drop(var/mob/m,var/obj/items/tech/weapons/i)
							if(i in m.accessing)
								if(i.suffix)
									i.suffix = null
									i.name = "Sword(Kid)"
									if(m.sword_pl > 0)
										m.sword_pl = 0
										m.overlays -= i
								i.overlays -= /obj/effects/select_item
								m.drop(i)
					New()
						tag = name
						category = list("Weapons")
						var/image/sel = image('fx.dmi',src,"select item",1000)
						src.img_select = sel

					Click(location,control,params)
						..()
						//Removes this item from the global Items list.
						if(items)
							if(src in items) items -= src
						params = params2list(params)
						if(params["left"])
							if(isturf(src.loc))
								usr.pickup(src)
								if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up [src]","actionoutput")
							else if(ismob(src.loc))
								if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
								usr.item_selected = src
								usr.refresh_inv()
				Battle_Hammer
					info_name = "Battle Hammer"
					mouse_over_pointer = MOUSE_ACTIVE_POINTER
					icon = 'Weapon_Hammer.dmi'
					value = 1000
					stone_cost = 3300
					coal_cost = 800
					mystille_cost=1150
					titanium_cost=380
					can_pocket = 1
					density_factor = 0
					weight = 1
					var/sword_power = 1
					var/sword_spd = 0
					var/sword_off = 0
					weapon = 1
					desc = "A heavy impact weapon designed to crush defenses and stagger foes. Its overwhelming force can occasionally stun targets, making it a favored choice for warriors who value control in close combat."
					tech_tree = "Engineering"
					tech_subtech = "Battle Hammer"
					act = /obj/items/tech/weapons/Battle_Hammer/proc/use
					act_drop = /obj/items/tech/weapons/Battle_Hammer/proc/drop
					appearance_flags = KEEP_TOGETHER
					tech_parent_path = /obj/items/tech/sub_tech/Engineering/Battle_Hammers
					has_subtech = 0
					proc
						use(var/mob/m,var/obj/items/tech/weapons/i)
							if(i in m)
								for(var/obj/items/tech/weapons/A in m) if(A!=i && A.suffix)
									m << "You already have a weapon equipped."
									m.set_alert("Another weapon is already equipped.",'alert.dmi',"alert")
									//m.create_chat_entry("alerts","Another sword is already equipped.")
									return
								if(!i.suffix)
									if(findtext(i.name,"(Kid)"))
										if(m.age>=13)
											m<<"You cannot fit this item."
											return
									if(!findtext(i.name,"(Kid)"))
										if(m.age<13)
											m<<"You cannot fit this item."
											return
									i.suffix = "equipped"
									i.name = "[i.name] (Equipped)"
									if(m.axe_pl == 0 || m.axe_pl <=1)

										m.axe_pl = (i.level)
										m.overlays += i.icon
										var/hammer_bonus = min(125, 125 * (m.weapon_stance / 250) ^ 0.75)
										i.desc_extra = null
										i.desc_extra = "Endurance Quality: +[hammer_bonus]%\n"//"Laceration Quality: +[(item.level)]%\n"
										i.desc_extra += "Defence Quality: -[hammer_bonus]%\n\n"
									m.refresh_inv()
									return
								else
									i.suffix = null
									i.name = "Battle Hammer"
									if(m.axe_pl > 0)
										m.axe_pl = 0
										m.overlays -= i.icon
									m.refresh_inv()
									return
						drop(var/mob/m,var/obj/items/tech/weapons/i)
							if(i in m.accessing)
								if(i.suffix)
									i.suffix = null
									i.name = "Battle Hammer"
									if(m.axe_pl > 0)
										m.axe_pl = 0
										m.overlays -= i
								src.overlays -= /obj/effects/select_item
								m.drop(i)
					New()
						tag = name
						category = list("Weapons")
						var/image/sel = image('fx.dmi',src,"select item",1000)
						src.img_select = sel

					Click(location,control,params)
						..()
						//Removes this item from the global Items list.
						if(items)
							if(src in items) items -= src
						params = params2list(params)
						if(params["left"])
							if(isturf(src.loc))
								usr.pickup(src)
								if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up [src]","actionoutput")
							else if(ismob(src.loc))
								if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
								usr.item_selected = src
								usr.refresh_inv()
				Battle_Axe
					info_name = "Battle Axe"
					mouse_over_pointer = MOUSE_ACTIVE_POINTER
					icon = 'Weapon_Battleaxe.dmi'
					value = 1000
					stone_cost = 3300
					coal_cost = 800
					mystille_cost=1150
					titanium_cost=380
					can_pocket = 1
					density_factor = 0
					weight = 1
					var/sword_power = 1
					var/sword_spd = 0
					var/sword_off = 0
					weapon = 1
					desc = "A reliable weapon for close combat, battle axes are heavy outputs and aims to shred with every swing. Whether you're clashing against enemies or training your technique, they’re a timeless tool of any skilled warrior."
					tech_tree = "Engineering"
					tech_subtech = "Battle Axe"
					act = /obj/items/tech/weapons/Battle_Axe/proc/use
					act_drop = /obj/items/tech/weapons/Battle_Axe/proc/drop
					appearance_flags = KEEP_TOGETHER
					tech_parent_path = /obj/items/tech/sub_tech/Engineering/Battle_Axes
					has_subtech = 0
					proc
						use(var/mob/m,var/obj/items/tech/i)
							if(i in m)
								for(var/obj/items/tech/weapons/A in m) if(A!=i && A.suffix)
									m << "You already have a weapon equipped."
									m.set_alert("Another weapon is already equipped.",'alert.dmi',"alert")
									//m.create_chat_entry("alerts","Another sword is already equipped.")
									return
								if(!i.suffix)
									if(findtext(i.name,"(Kid)"))
										if(m.age>=13)
											m<<"You cannot fit this item."
											return
									if(!findtext(i.name,"(Kid)"))
										if(m.age<13)
											m<<"You cannot fit this item."
											return
									i.suffix = "equipped"
									i.name = "[i.name] (Equipped)"
									if(m.axe_pl == 0 || m.axe_pl <=1)

										m.axe_pl = (i.level)
										m.overlays += i.icon
										var/laceration_bonus = min(125, 125 * (m.weapon_stance / 250) ^ 0.75)
										i.desc_extra = null
										i.desc_extra = "Laceration Quality: +[laceration_bonus]%\n"//"Laceration Quality: +[(item.level)]%\n"
										i.desc_extra += "Offence Quality: -[laceration_bonus]%\n\n"


									m.refresh_inv()
									return
								else
									i.suffix = null
									i.name = "Battle Axe"
									if(m.axe_pl > 0)
										m.axe_pl = 0
										m.overlays -= i.icon
									m.refresh_inv()
									return
						drop(var/mob/m,var/obj/items/tech/weapons/i)
							if(i in m.accessing)
								if(i.suffix)
									i.suffix = null
									i.name = "Battle Axe"
									if(m.axe_pl > 0)
										m.axe_pl = 0
										m.overlays -= i
								src.overlays -= /obj/effects/select_item
								m.drop(i)
					New()
						tag = name
						category = list("Weapons")
						var/image/sel = image('fx.dmi',src,"select item",1000)
						src.img_select = sel

					Click(location,control,params)
						..()
						//Removes this item from the global Items list.
						if(items)
							if(src in items) items -= src
						params = params2list(params)
						if(params["left"])
							if(isturf(src.loc))
								usr.pickup(src)
								if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up [src]","actionoutput")
							else if(ismob(src.loc))
								if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
								usr.item_selected = src
								usr.refresh_inv()


			/*Canister
				info_name = "Canister"
				mouse_over_pointer = MOUSE_ACTIVE_POINTER
				icon = 'canister.dmi'
				icon_state = "empty"
				value = 1000

				mystille_cost=50
				titanium_cost=180
				coal_cost=25
				stone_cost=280

				can_pocket = 1
				density_factor = 0
				weight = 1
				desc = "This handy portable container will let you store items inside that are far in excess the size of this device. It can fit just about anything within itself, so long as an item isn't bolted to the ground. To use the device, place it near something you want stored and then right click the canister. To unload it, simply right click again."
				tech_tree = "Engineering"
				tech_subtech = "Compression Techniques"
				act = /obj/items/tech/Canister/proc/use
				act_drop = /obj/items/tech/Canister/proc/drop
				appearance_flags = KEEP_TOGETHER
				stacks = -1
				has_subtech = 1
				proc
					use(var/mob/m,var/obj/items/tech/i)
						if(i in m.accessing)
							var/mob/x = m.accessing
							x.drop(i)
							i.compress("right",x)
							i.overlays -= /obj/effects/select_item
							x.refresh_inv()
					drop(var/mob/m,var/obj/items/tech/i)
						i.overlays -= /obj/effects/select_item
						m.drop(i)
				New()
					tag = name
					category = list("Storage")
					var/image/sel = image('fx.dmi',src,"select item",1000)
					src.img_select = sel
				Click(location,control,params)
					..()
					winset(usr,"map.map","focus=true")
					params = params2list(params)
					if(params["left"])
						if(isturf(src.loc))
							usr.pickup(src)
							return
						else if(ismob(src.loc))
							if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
							usr.item_selected = src
					if(params["right"])
						if(isturf(src.loc))
							src.compress("right",usr)
							return*/
			Gene_Scanner
				info_name = "Gene_Scanner"
				icon = 'electronics.dmi'
				icon_state = "gene scanner"
				//floor_state = "gene scanner"
				value = 1000
				copper_cost=3500
				titanium_cost=4500
				gold_cost=1600
				layer = 3.1
				density_factor = 0
				hashadow = 0
				can_pocket = 1;
				stacks = -1
				desc = "A handheld genetic analysis device used to scan and identify biological traits for research and bio-engineering applications."
				desc_extra = "- Maximum scan threshold: 1000"
				tech_tree = "Physics"
				tech_subtech = "Gene Scanners"
				tech_parent_path = /obj/items/tech/sub_tech/Genetics/Gene_Scanners
				tech_upgradable = 1
				act = /obj/items/tech/Gene_Scanner/proc/use
				act_drop = /obj/items/tech/Gene_Scanner/proc/drop
				appearance_flags = KEEP_TOGETHER
			//	tech_parent_path = /obj/items/tech/sub_tech/Engineering/Gene_Scanners
				has_subtech = 0
				proc
					use(var/mob/m,var/obj/items/tech/i)
						if(i in m.accessing)
							usr.left_click_function = "gene scan"
							usr.left_click_ref = src
							usr.set_alert("Select someone to scan",i.icon,i.icon_state)


					drop(var/mob/m,var/obj/items/tech/i)
						if(i in m.accessing)
							var/mob/x = m.accessing
							if(i.suffix)
								i.overlays -= /obj/effects/select_item
								//i.icon_state = "gene scanner"
								i.suffix = null
								i.name = "Gene Scanner"
								i.layer = initial(i.layer)
								x.redraw_appearance()
							i.overlays -= /obj/effects/select_item
							m.drop(i)
				Click(location,control,params)
					..()
					//Removes this item from the global Items list.
					if(items)
						if(src in items) items -= src
					params = params2list(params)
					if(params["left"])
						if(ismob(src.loc))
							if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
							usr.item_selected = src

						else if(isturf(src.loc))
							usr.pickup(src)
							if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up [src]","actionoutput")
						else if(ismob(src.loc))
							if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
							usr.item_selected = src
							usr.refresh_inv()


			Scouters
				var/AllowedScan = 1
				var/Channel = 1
				var/obj/portrait/portrait_scouter_base/ScouterBase = null
				var/obj/portrait/portrait_scouter_lens/ScouterLens = null
				var/lenscolor
				Kid_Scouter
					name = "Scouter(Kid)"
					info_name = "Kid_Scouter"
					icon = 'scouter_base_kid.dmi'
					icon_state = ""
					floor_state = "floor"
					value = 1000
					copper_cost=3500
					titanium_cost=4500
					gold_cost=1600
					layer = 3.1
					density_factor = 0
					hashadow = 0
					can_pocket = 1;
					stacks = -1
					desc = "Used to scan stuff.\n-Left-click the lens on your portrait to scan individuals, right click it to scan the planet\n-Left-click the base of the scouter on your portrait for more options."
					desc_extra = "- Maximum scan threshold: 1000\n"
					tech_tree = "Physics"
					tech_subtech = "Scouters"
					tech_parent_path = /obj/items/tech/sub_tech/Physics/Scouters
					tech_upgradable = 1
					act = /obj/items/tech/Scouters/Kid_Scouter/proc/use
					act_drop = /obj/items/tech/Scouters/Kid_Scouter/proc/drop
					appearance_flags = KEEP_TOGETHER
					var/scan_power = 1
				//	tech_parent_path = /obj/items/tech/sub_tech/Engineering/Scouters
					has_subtech = 0
					proc
						use(var/mob/m,var/obj/items/tech/Scouters/Kid_Scouter/i)
							if(i in m.accessing)
								var/mob/x = m.accessing
								for(var/obj/items/tech/Scouters/Kid_Scouter/A in x) if(A!=i && A.suffix)
									m.set_alert("Another scouter is already equipped.",'alert.dmi',"alert")
									return
								if(!i.suffix)
									if(findtext(i.name,"(Kid)"))
										if(m.age>=13)
											m<<"You cannot fit this item."
											return
									if(!findtext(i.name,"(Kid)"))
										if(m.age<13)
											m<<"You cannot fit this item."
											return
									if(i:scan_power == 1 ) i:scan_power = i.level
									i.overlays -= /obj/effects/select_item
									m.overlays -= i.icon
									i.suffix = "worn"
									i.name = "Scouter(Kid) (Equipped)"
									i.icon_state = ""
									i.layer = 13
									m.scouter_on = 1
									m.current_scouter = i
									x.redraw_appearance()

									m.overlays += i.icon
									m.update_icon(m)
									return
								else
									i.suffix = null
									i.name = "Scouter(Kid)"
									i.layer = initial(i.layer)
									x.redraw_appearance()
									m.overlays -= i.icon
									m.scouter_on = 0
									m.current_scouter = null
									m.update_icon(m)
									return
						drop(var/mob/m,var/obj/items/tech/i)
							if(i in m.accessing)
								var/mob/x = m.accessing
								if(i.suffix)
									i.overlays -= /obj/effects/select_item
									m.overlays -= i.icon
									i.suffix = null
									i.name = "Scouter(Kid)"
									i.layer = initial(i.layer)
									x.redraw_appearance()
								i.overlays -= /obj/effects/select_item
								m.drop(i)
					New()
						..()
						ScouterBase = new/obj/portrait/portrait_scouter_base
						ScouterLens = new/obj/portrait/portrait_scouter_lens
						ScouterLens.ScouterLens = src
						ScouterBase.ScouterBase = src
						if(lenscolor) ScouterLens.icon *= lenscolor
					Click(location,control,params)
						..()
						//Removes this item from the global Items list.
						if(items)
							if(src in items) items -= src
						params = params2list(params)
						var/dir = null
						if(params["left"] || usr.mouse_dir == "left")
							dir = "left"
						if(params["right"] || usr.mouse_dir == "right")
							dir = "right"
						if(dir == "right")
							winset(usr,"map.map","focus=true")
							if(usr.target == null || !usr.target)
								usr.set_alert("You need to select a target!",src.icon,src.icon_state)
								return
							if(src.AllowedScan==1 && usr.target)
								usr.set_alert("Scanning [usr.target]....",src.icon,src.icon_state)
								usr.ScouterScan(usr.target,src)
								src.AllowedScan=1
						//if(params["left"])
						if(dir=="left")
							//Upgrade scanner
							if(usr.left_click_function == "upgrade scanner")
								if(src.loc)
									if(src in range(2,usr))
										usr.left_click_function = null
										for(var/obj/items/tech/sub_tech/Physics/Scouters/SE in global.tech)//usr.technology_researched)
											if(usr.tech_unlocked[SE.list_pos] == SE.type)
												if(usr.tech_lvls[SE.list_pos] > 0)
													src.level = usr.tech_lvls[SE.list_pos]
													src.desc_extra = "- Maximum scan threshold: [src.level*1000]"
													usr << output("Upgraded Scouter to level [src.level].", "actionoutput")
													usr.set_alert("Upgraded Scouter",SE.icon,SE.icon_state)
													animate(SE, color = list("#000", "#000", "#000", "#fff"),time = 4)
													animate(color = initial(SE.color),time = 4)
													break
												else
													usr << output("Need at least one level in Scouters.", "actionoutput")
													usr.set_alert("Need Scouters technology",'alert.dmi',"alert")
													return
										return
									else
										usr << output("[src] is out of range for upgrading.", "actionoutput")
										usr.set_alert("Out of range",'alert.dmi',"alert")
										return
								else
									usr << output("[src] is out of range for upgrading.", "actionoutput")
									usr.set_alert("Out of range",'alert.dmi',"alert")
									return
							else if(isturf(src.loc))
								usr.pickup(src)
								if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up [src]","actionoutput")
							else if(ismob(src.loc))
								if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
								usr.item_selected = src
								usr.refresh_inv()

				Scouter
					info_name = "Scouter"
					icon = 'scouter_base.dmi'
					icon_state = ""
					floor_state = "floor"
					value = 1000
					copper_cost=3500
					titanium_cost=4500
					gold_cost=1600
					layer = 3.1
					density_factor = 0
					hashadow = 0
					can_pocket = 1;
					stacks = -1
					desc = "Used to scan stuff.\n-Left-click the lens on your portrait to scan individuals, right click it to scan the planet\n-Left-click the base of the scouter on your portrait for more options."
					desc_extra = "- Maximum scan threshold: 1000\n"
					tech_tree = "Physics"
					tech_subtech = "Scouters"
					tech_parent_path = /obj/items/tech/sub_tech/Physics/Scouters
					tech_upgradable = 1
					act = /obj/items/tech/Scouters/Scouter/proc/use
					act_drop = /obj/items/tech/Scouters/Scouter/proc/drop
					appearance_flags = KEEP_TOGETHER

					var/scan_power = 1

				//	tech_parent_path = /obj/items/tech/sub_tech/Engineering/Scouters
					has_subtech = 0
					New()
						..()
						ScouterBase = new/obj/portrait/portrait_scouter_base
						ScouterLens = new/obj/portrait/portrait_scouter_lens
						ScouterLens.ScouterLens = src
						ScouterBase.ScouterBase = src
						//..()
					proc
						use(var/mob/m,var/obj/items/tech/i)
							if(i in m.accessing)
								var/mob/x = m.accessing
								for(var/obj/items/tech/Scouters/Scouter/A in x) if(A!=i && A.suffix)
									m.set_alert("Another scouter is already equipped.",'alert.dmi',"alert")
								//	m.create_chat_entry("alerts","Another scouter is already equipped.")
									return
								if(!i.suffix)
									if(findtext(i.name,"(Kid)"))
										if(m.age>=13)
											m<<"You cannot fit this item."
											return
									if(!findtext(i.name,"(Kid)"))
										if(m.age<13)
											m<<"You cannot fit this item."
											return
									if(i:scan_power == 1 ) i:scan_power = i.level
									i.overlays -= /obj/effects/select_item
									m.overlays -= i.icon
									m.scouter_on = 1
									m.current_scouter = i
									i.suffix = "worn"
									i.name = "Scouter (Equipped)"
									i.icon_state = ""
									i.layer = 13
									x.redraw_appearance()
									m.overlays += i.icon
									m.update_icon(m)
									return
								else
									i.overlays -= /obj/effects/select_item
									i.suffix = null
									i.name = "Scouter"
									i.layer = initial(i.layer)
									x.redraw_appearance()
									m.overlays -= i.icon
									m.update_icon(m)
									m.scouter_on = 0
									m.current_scouter = null
									return
						drop(var/mob/m,var/obj/items/tech/i)
							if(i in m.accessing)
								var/mob/x = m.accessing
								if(i.suffix)
									i.overlays -= /obj/effects/select_item
									m.overlays -= i.icon
									i.suffix = null
									i.name = "Scouter"
									i.layer = initial(i.layer)
									x.redraw_appearance()
								i.overlays -= /obj/effects/select_item
								m.drop(i)
					Click(location,control,params)
						..()
						//Removes this item from the global Items list.
						if(items)
							if(src in items) items -= src
						params = params2list(params)
						var/dir = null
						if(params["left"] || usr.mouse_dir == "left")
							dir = "left"
						if(params["right"] || usr.mouse_dir == "right")
							dir = "right"
						if(dir == "right")
							winset(usr,"map.map","focus=true")
							if(usr.target == null || !usr.target)
								usr.set_alert("You need to select a target!",src.icon,src.icon_state)
								return
							if(src.AllowedScan==1 && usr.target)
								usr.set_alert("Scanning [usr.target]....",src.icon,src.icon_state)
								usr.ScouterScan(usr.target,src)
								src.AllowedScan=1
						//if(params["left"])
						if(dir=="left")
							//Upgrade scanner
							if(usr.left_click_function == "upgrade scanner")
								if(src.loc)
									if(src in range(2,usr))
										usr.left_click_function = null
										for(var/obj/items/tech/sub_tech/Physics/Scouters/SE in global.tech)//usr.technology_researched)
											if(usr.tech_unlocked[SE.list_pos] == SE.type)
												if(usr.tech_lvls[SE.list_pos] > 0)
													src.level = usr.tech_lvls[SE.list_pos]
													src.desc_extra = "- Maximum scan threshold: [src.level*1000]"
													usr << output("Upgraded Scouter to level [src.level].", "chat.system")
													usr.set_alert("Upgraded Scouter",SE.icon,SE.icon_state)
												//	usr.create_chat_entry("alerts","Upgraded scanner.")
													animate(SE, color = list("#000", "#000", "#000", "#fff"),time = 4)
													animate(color = initial(SE.color),time = 4)
													break
												else
													usr << output("Need at least one level in Scouters.", "chat.system")
													usr.set_alert("Need Scouters technology",'alert.dmi',"alert")
												//	usr.create_chat_entry("alerts","Need Scouters technology.")
													return
										return
									else
										usr << output("[src] is out of range for upgrading.", "chat.system")
										usr.set_alert("Out of range",'alert.dmi',"alert")
										//usr.create_chat_entry("alerts","Out of range.")
										return
								else
									usr << output("[src] is out of range for upgrading.", "chat.system")
									usr.set_alert("Out of range",'alert.dmi',"alert")
								//	usr.create_chat_entry("alerts","Out of range.")
									return
							else if(isturf(src.loc))
								usr.pickup(src)
								if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up [src]","actionoutput")
							else if(ismob(src.loc))
								if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
								usr.item_selected = src
								usr.refresh_inv()

			Oxygen
				info_name = "Oxygen"
				icon = 'item_fuel.dmi'
				icon_state = "oxygen"
				value = 100000
				titanium_cost=5
				silver_cost=1
				layer = 3.1
				density_factor = 0
				hashadow = 1
				can_pocket = 1;
				stacks = -1
				var/oxygenamount = 0
				desc = "A sealed oxygen canister containing a concentrated supply of breathable air. Used to replenish oxygen reserves in tanks, suits, and life-support systems, it is essential for survival in space, sealed environments, or regions with thin or hostile atmospheres. Commonly carried by explorers, pilots, and station crews operating beyond breathable zones."
				desc_extra = "- Refuel oxygen tanks"
				tech_tree = "Physics"
				tech_subtech = "Fossil Fuels"
				//act = /obj/items/tech/Oxygen/proc/use
				act_drop = /obj/items/tech/Oxygen/proc/drop
				appearance_flags = KEEP_TOGETHER
				tech_parent_path = /obj/items/tech/sub_tech/Physics/Fossil_Fuels
				has_subtech = 0
				proc

					drop(var/mob/m,var/obj/items/tech/i)
						if(i:oxygenamount>1)
							var/dropamount = input("How much are you dropping?") as num
							m.drop(i,dropamount)
				Click(location,control,params)
					..()
					params = params2list(params)
					if(params["left"])
						if(ismob(src.loc))
							if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
							usr.item_selected = src
							src.overlays -= /obj/effects/select_item
							src.overlays += /obj/effects/select_item
						else if(isturf(src.loc))
							usr.pickup(src)
							if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up [src]","actionoutput")
			Fuel
				info_name = "Fuel"
				icon = 'item_fuel.dmi'
				icon_state = ""
				value = 100000
				mystille_cost=5
				layer = 3.1
				density_factor = 0
				hashadow = 1
				can_pocket = 1;
				stacks = -1

				desc = "A refined fuel canister used to power space pods, spaceships, and other machinery."
				desc_extra = "- Refuel machinery"
				tech_tree = "Physics"
				tech_subtech = "Fossil Fuels"
				//act = /obj/items/tech/Fuel/proc/use
				act_drop = /obj/items/tech/Fuel/proc/drop
				appearance_flags = KEEP_TOGETHER
				tech_parent_path = /obj/items/tech/sub_tech/Physics/Fossil_Fuels
				has_subtech = 0
				proc
					drop(var/mob/m,var/obj/items/tech/i)
						if(i:fuelamount>1)
							var/dropamount = input("How much are you dropping?") as num
							m.drop(i,dropamount)
				Click(location,control,params)
					..()
					params = params2list(params)
					if(params["left"])
						if(ismob(src.loc))
							if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
							usr.item_selected = src
							src.overlays -= /obj/effects/select_item
							src.overlays += /obj/effects/select_item
							usr.refresh_inv()
						else if(isturf(src.loc))
							usr.pickup(src)
							if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up [src]","actionoutput")

			Medical_Pack
				info_name = "Medical_Pack"
				icon = 'item_medical_pack.dmi'
				icon_state = ""
				value = 100000
				copper_cost=5000
				coal_cost=2000
				titanium_cost=5000
				silver_cost=2000
				gold_cost=5000
				mystille_cost=2000
				layer = 3.1
				density_factor = 0
				hashadow = 1
				can_pocket = 1;
				stacks = -1
				desc = "A high-grade emergency medical kit packed with stimulants, stabilizers, and life-sustaining compounds. Designed for battlefield and deep-space use, it can restore life to recently deceased bodies by forcibly reactivating failing systems. Survivors revived this way suffer extreme fatigue and must recover before returning to full strength."
				desc_extra = "- One use only\n\n- Revive recently deceased\n\n- Dead less than 6 minutes"
				tech_tree = "Genetics"
				tech_subtech = "Medical Equipment"
				act = /obj/items/tech/Medical_Pack/proc/use
				act_drop = /obj/items/tech/Medical_Pack/proc/drop
				appearance_flags = KEEP_TOGETHER
				tech_parent_path = /obj/items/tech/sub_tech/Genetics/Medical_Equipment
				has_subtech = 0
				proc
					use(var/mob/m,var/obj/items/tech/i)
						if(i in m.accessing)
							m.left_click_function = "revive defibrillator"
							m.left_click_ref = i
							m.set_alert("Select target to zap",i.icon,i.icon_state)
					drop(var/mob/m,var/obj/items/tech/i)
						m.drop(i)
				Click(location,control,params)
					..()
					params = params2list(params)
					if(params["left"])
						if(ismob(src.loc))
							if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
							usr.item_selected = src
							src.overlays -= /obj/effects/select_item
							src.overlays += /obj/effects/select_item
							usr.refresh_inv()
						else if(isturf(src.loc))
							usr.pickup(src)
							if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up [src]","actionoutput")
			Defibrillator
				info_name = "Defibrillator"
				icon = 'artifacts_small.dmi'
				icon_state = "defibrillator"
				value = 100000
				copper_cost=5000
				coal_cost=2000
				titanium_cost=15000
				silver_cost=10000
				gold_cost=3800
				mystille_cost=5000
				layer = 3.1
				density_factor = 0
				hashadow = 1
				can_pocket = 1;
				stacks = -1
				desc = "This device is used to jump-start the heart of an organic being after it has stopped beating. \n\nIt only has one use, and only works on people who have been dead for less than 6 minutes. And only on bodies which haven't been destroyed. \n\nIt is also worth noting that a person revived in this manner will be in a weakened state, drained of energy and health until fully recovered."
				desc_extra = "- One use only\n\n- Revive recently deceased\n\n- Dead less than 6 minutes"
				tech_tree = "Genetics"
				tech_subtech = "Medical Equipment"
				act = /obj/items/tech/Defibrillator/proc/use
				act_drop = /obj/items/tech/Defibrillator/proc/drop
				appearance_flags = KEEP_TOGETHER
				proc
					use(var/mob/m,var/obj/items/tech/i)
						if(i in m.accessing)
							m.left_click_function = "revive defibrillator"
							m.left_click_ref = i
							m.set_alert("Select target to zap",i.icon,i.icon_state)
					drop(var/mob/m,var/obj/items/tech/i)
						m.drop(i)
				Click(location,control,params)
					..()
					params = params2list(params)
					if(params["left"])
						if(ismob(src.loc))
							if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
							usr.item_selected = src
							src.overlays -= /obj/effects/select_item
							src.overlays += /obj/effects/select_item
						else if(isturf(src.loc))
							usr.pickup(src)
							if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up [src]","actionoutput")
			Upgrade_Kit
				info_name = "Upgrade_Kit"
				icon = 'artifacts_small.dmi'
				icon_state = "android upgrade"
				value = 1000000
				layer = 3.1
				density_factor = 0
				hashadow = 0
				can_pocket = 1;
				desc = "This assortment of complicated tools is used to enhance, change and upgrade a mechanical bodypart. Able to interface with nearly any machine, the Upgrade Kit is of vital importance to Androids and Cyborgs seeking to have their forms optimized. This device can even be used by artifical beings on themselves and others.\n\nEach use of this device grants 10 levels in a mechanical bodypart, enhancing it up and beyond its normal operating parameters."
				desc_extra = "+10 levels to Mechanical parts"
				tech_tree = "Engineering"
				tech_subtech = "Robotics"
				tech_parent_path = /obj/items/tech/sub_tech/Engineering/Robotics
				Click(location,control,params)
					..()
					params = params2list(params)
					if(params["left"])
						if(ismob(src.loc))
							if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
							usr.item_selected = src
							src.overlays -= /obj/effects/select_item
							src.overlays += /obj/effects/select_item
						else if(isturf(src.loc))
							usr.pickup(src)
							if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up [src]","actionoutput")
			Power_Line
				info_name = "Power_Line"
				icon = 'power_lines_off.dmi'
				icon_state = "manifold"
				value = 100
				coal_cost=55
				titanium_cost=180
				mystille_cost=55
				bolted = 1
				layer = 3.1
				density_factor = 0
				//plane = 0
				hashadow = 0
				tech_water = 1
				//appearance_flags = PIXEL_SCALE
				desc = "Power lines can be placed along the ground and linked together to form an energy network. Most technological structures require that these be under them. Its also very important to remember that a battery must be connected along the energy network, along with some form of power producing structure. Otherwise, anything connected to these lines won't function."
				tech_tree = "Engineering"
				tech_subtech = "None"
				tech_parent_path = /obj/items/tech/sub_tech/Engineering
				var/damaged = 0
				var/grow_dir
				var/area/network = null
				var/built = 0
				var/skip = 0
				proc
					reconnect_power()
						var/pow_produced = 0 //Total power produced by all the tech connected to this network
						var/pow_used = 0 //Total power used on this network by the machines connected to it
						var/pow_excess = 0 //What's not being used currently
						var/pow_stored = 0 //How much power is stored inside batteries connected to this network. Used only when active power isn't enough.
						var/list/techs = list()

						if(src.network)
							src.network.bats_list = list()
							//----------Work out power used and whats left---------------
							for(var/obj/items/tech/tch in src.network)
								if(tch.type != /obj/items/tech/Power_Line)
									if(tch.grabbed_by == null)
										techs += tch
										if(tch.generator == 1 && tch.can_generate == 1)
											pow_produced += tch.generates;
										if(tch.type == /obj/items/tech/Battery)
											pow_stored += tch.capacity
											src.network.bats_list += tch
										if(tch.uses > 0 && tch.on == 1)
											pow_used += tch.uses;
											if(tch.on_always && tch.act) call(tch.act)(tch,src.network) //Will only change the visuals. (Although icon_state is important for checks)
							//-----------------------------------------------------------

							pow_excess = pow_produced - pow_used

							//----------Work out what to turn off, if needed-------------
							if(pow_excess < 0 && pow_stored <= 0)
								for(var/obj/items/tech/tch in techs)
									if(tch.on_always == 0 && tch.on && tch.act)
										pow_used -= tch.uses;
										call(tch.act)(tch) //These calls should shut down the machine
							//-----------------------------------------------------------

							pow_excess = pow_produced - pow_used
							src.network.currents_grid = pow_produced
							src.network.excess_grid = pow_excess
							src.network.used_grid = pow_used
							src.network.stored_grid = pow_stored

							var/power = 1
							var/I = 'power_lines.dmi'
							if(pow_produced <= 0) src.network.currents_grid = pow_stored
							if(pow_produced <= 0 && pow_stored <= 0)
								I = 'power_lines_off.dmi'
								power = 0
							src.network.power_grid = power

							for(var/obj/items/tech/Power_Line/p in src.network)
								p.icon = I
				MouseEntered()
					..()
					if(usr.toggled_info) usr.show_info(src.loc)
				proc
					check_lines(var/change = 0)
						var/obj/items/tech/Power_Line/found_north = null
						var/obj/items/tech/Power_Line/found_south = null
						var/obj/items/tech/Power_Line/found_east = null
						var/obj/items/tech/Power_Line/found_west = null
						src.icon_state = "dirs"
						for(var/obj/items/tech/Power_Line/p in locate(src.x+1,src.y,src.z))
							if(p.damaged == 0)
								found_east = p
								src.dir = EAST
								if(change) p.check_lines()
								break
						for(var/obj/items/tech/Power_Line/p in locate(src.x-1,src.y,src.z))
							if(p.damaged == 0)
								found_west = p
								src.dir = WEST
								if(change) p.check_lines()
								break
						for(var/obj/items/tech/Power_Line/p in locate(src.x,src.y+1,src.z))
							if(p.damaged == 0)
								found_north = p
								src.dir = NORTH
								if(change) p.check_lines()
								break
						for(var/obj/items/tech/Power_Line/p in locate(src.x,src.y-1,src.z))
							if(p.damaged == 0)
								found_south = p
								src.dir = SOUTH
								if(change) p.check_lines()
								break
						if(found_west && found_north)
							src.icon_state = "bottom left"
						if(found_east && found_north)
							src.icon_state = "bottom right"
						if(found_west && found_south)
							src.icon_state = "top right"
						if(found_east && found_south)
							src.icon_state = "top left"
						if(found_north && found_south && found_east)
							src.icon_state = "manifold left"
						if(found_north && found_south && found_west)
							src.icon_state = "manifold right"
						if(found_north && found_east && found_west)
							src.icon_state = "manifold bottom"
						if(found_south && found_east && found_west)
							src.icon_state = "manifold top"
						if(found_north && found_south && found_west && found_east)
							src.icon_state = "manifold"
						src.bounds = "1,1 to 32,32"
						if(src.icon_state == "dirs")
							if(dir == NORTH || dir == SOUTH)
								src.bounds = "12,1 to 21,32"
							if(dir == EAST || dir == WEST)
								src.bounds = "1,12 to 32,21"
						var/n = 0
						for(var/obj/items/tech/Power_Line/p in range(1,src))
							if(p != src) n += 1
						if(n < 2) src.icon_state = "dirs end"
					check_connections()
						if(src.network)
							var/list/lines = list()
							var/list/areas = list()
							for(var/obj/items/tech/Power_Line/pow in src.network)
								if(pow != src)
									src.network.contents -= pow.loc
									pow.network = null
									lines += pow
							src.network.contents -= src.loc
							src.network = null

							new /area (src.loc)
							src.damaged = 1
							for(var/obj/items/tech/Power_Line/p in range(1,src))
								p.check_lines(1)
							//var/this_needs_removing_later_IMPORTANT
							//src.loc = null

							for(var/obj/items/tech/Power_Line/pow in lines)
								pow.setting = 1
								pow.New()
							spawn(6)
								for(var/obj/items/tech/Power_Line/pow in lines)
									if(pow.network)
										if(areas.Find(pow.network) == 0) areas += pow.network
								spawn(0)
									for(var/area/a in areas)
										for(var/obj/items/tech/Power_Line/pow in a)
											pow.reconnect_power()
											break
				Click()
					..()
					//if(src.loc) src.check_connections()
				New()
					if(src.loc == null)
						tag = name
						category = list("Power Transference")
						var/image/sel = image('fx.dmi',src,"select item",1000)
						src.img_select = sel
					spawn(0)
						if(src.loc != null)
							if(src.setting == 0) src.check_lines(1)
							spawn(0)
								src.spawning = 0;
								if(src.network == null)
									var/create_new = 1
									var/list/networks = list()
									for(var/obj/items/tech/Power_Line/p in orange(1,src))
										if(p.network)
											if(networks.Find(p.network) == 0)
												networks += p.network
											create_new = 0
									var/area/main = null
									for(var/area/a in networks)
										if(main == null)
											main = a
											src.network = main
											main.contents += src.loc
										else
											for(var/obj/items/tech/Power_Line/p in a)
												p.network = main
												main.contents += p.loc
									if(create_new)
										var/area/new_network = new(null)
										//new_network.icon = 'terrain.dmi'
										//new_network.icon_state = "n[rand(1,8)]"
										new_network.power_grid = 1
										new_network.layer = 2.1
										src.network = new_network
										new_network.contents += src.loc
										//network_psionica.contents += src.loc
								//var/turf/t = src.loc
								//t.icon = null
								if(src.built) src.reconnect_power()
								if(src.organic)
									src.icon = 'power_lines_vines.dmi'
									src.layer = 3
									//src.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(155,255,255))
			/*
			Cage_Tech
				name = "Cage"
				icon = 'cages.dmi'
				icon_state = "cage tech closed"
				value = 1000
				pixel_x = -16
				desc = "This item is useful for locking away others so you may transport them, deal with them later or even use your technology on them. Whatever the intention, the cage will hold a single prisoner. Before dropping someone inside, they must be rendered unconscious first. Right clicking the cage opens and closes it."
				var
					tmp/mob/prisoner = null
				New()
					..()
					var/image/sel = image('fx.dmi',src,"select item",1000)
					src.img_select = sel
					name = "[src.name] ([src.value])"
					spawn(1)
						while(src)
							if(src.icon_state == "cage tech closed")
								if(src.prisoner)
									var/mob/m = src.prisoner
									m.loc = src.loc
									m.pixel_z = src.pixel_z
									m.layer = 2.1
									m.density_factor = 0
									m.building = 1
									m.can_attack = 0
									if(m.client) m.disable_skills(list(/obj/skills/Meditate))
							sleep(0.1)
				Click(location,control,params)
					if("ko" in usr.debuffs) return
					if(src in range(2,usr))
						params = params2list(params)
						winset(usr,"map.map","focus=true")
						if(usr == src.prisoner)
							return
						if(params["right"])
							if(src.icon_state == "cage tech closed")
								src.icon_state = "cage tech open"
								if(src.prisoner)
									var/mob/m = src.prisoner
									m.density_factor = initial(m.density_factor)
									m.layer = initial(m.layer)
									m.bolted = 0
									m.can_attack = 1
									m.building = 0
								src.prisoner = null
								return
							if(src.icon_state == "cage tech open")
								src.icon_state = "cage tech closed"
								for(var/mob/m in range(0,src))
									//if("ko" in m.debuffs)
									src.prisoner = m
									m.bolted = 1
								return
					..()
			*/
			Printer
				info_name = "Printer"
				name = "Printer"
				icon = 'droid_printer.dmi'
				icon_state = "off"
				value = 1000
				weight = 1
				hashadow = 0
				on = 1;
				bounds = "-7,2 to 38,18"
				density_factor = 1;
				pixel_x = -36;
				uses = 100
				var
					set_for = null;
					mob/in_use = null;
					growth_percent = 0
					points = 10;
					points_assigned = 0;
					points_limit = 2;
					cost = 0;
					lowest = 0;
					clone_type = "Clone"
					on_grid = 0;

					tech_psi_base = 1;
					tech_energy_base = 1
					tech_strength_base = 1
					tech_endurance_base = 1
					tech_agility_base = 1
					tech_force_base = 1
					tech_resistance_base = 1
					tech_offence_base = 1
					tech_defence_base = 1
					tech_regeneration_base = 1
					tech_recovery_base = 1

					tech_psi_mod_base = 1;
					tech_energy_mod_base = 1
					tech_strength_mod_base = 1
					tech_endurance_mod_base = 1
					tech_agility_mod_base = 1
					tech_force_mod_base = 1
					tech_resistance_mod_base = 1
					tech_offence_mod_base = 1
					tech_defence_mod_base = 1
					tech_regeneration_mod_base = 1
					tech_recovery_mod_base = 1

					tech_psi = 1;
					tech_energy = 1
					tech_strength = 1
					tech_endurance = 1
					tech_agility = 1
					tech_force = 1
					tech_resistance = 1
					tech_offence = 1
					tech_defence = 1
					tech_regeneration = 1
					tech_recovery = 1

					tech_psi_stat = 1;
					tech_energy_stat = 1
					tech_strength_stat = 1
					tech_endurance_stat = 1
					tech_agility_stat = 1
					tech_force_stat = 1
					tech_resistance_stat = 1
					tech_offence_stat = 1
					tech_defence_stat = 1
					tech_regeneration_stat = 1
					tech_recovery_stat = 1

					tech_stat_cap = 1;
					tech_total_stats = 0;
				Del()
					for(var/turf/trf in src.locs)
						for(var/obj/items/tech/Power_Line/p in trf)
							p.reconnect_power()
					..()
				New()
					..()
					tag = name
					category = list("Robotics")
					var/image/sel = image('fx.dmi',src,"select item",1000)
					src.img_select = sel
					src.icon_state = "off"
					src.desc_extra = "Power usage: [src.uses] \n\nProcess: Activated \n\nCan be toggled on or off"
					spawn(1)
						if(src)
							for(var/turf/trf in src.locs)
								for(var/obj/items/tech/Power_Line/p in trf)
									p.reconnect_power()
								//if(power_grid[trf.x][trf.y][trf.z] == 1)
								if(trf.power_grid == 1)
									if(trf.excess_grid >= 0 || trf.stored_grid > 0) src.icon_state = "tank on"
									//if(excess_grid[trf.x][trf.y][trf.z] >= 0 || stored_grid[trf.x][trf.y][trf.z] > 0) src.icon_state = "tank on"
							while(src)
								if(src.loc == null) return
								if(src.on)
									var/powered = 0;
									if(src.grabbed_by == null && src.tk == 0)
										for(var/turf/trf in src.locs)
											//if(power_grid[trf.x][trf.y][trf.z] == 1)
											if(trf.power_grid == 1)
												if(trf.excess_grid >= 0 || trf.stored_grid > 0) powered = 1;
												//if(excess_grid[trf.x][trf.y][trf.z] >= 0 || stored_grid[trf.x][trf.y][trf.z] > 0) powered = 1;
									if(powered) src.icon_state = "on"
									else src.icon_state = "off"
								sleep(60)
				Move()
					..()
					if(src.in_use)
						//src.in_use.SetCenter(src)
						src.in_use.loc = src.loc;
						src.in_use.step_x = src.step_x//+36;
						src.in_use.step_y = src.step_y+24;
						src.in_use.layer = src.layer+1
						/*
						for(var/turf/trf in src.locs)
							for(var/obj/items/tech/Power_Line/p in trf)
								p.reconnect_power()
						*/
				Click(location,control,params)
					..()
					return
					usr.mouse_down = null
					params = params2list(params)
					if(params["right"])
						if(src in range(1,usr))
							if(src.on)
								src.on = 0;
								src.icon_state = "off"
								if(usr.tech_using == src)
									winshow(usr,"robotics",0)
									usr.tech_using = null;
									src.used_by = null
							else src.on = 1;

							var/powered = 0;
							if(src.grabbed_by == null && src.tk == 0)
								for(var/turf/trf in src.locs)
									for(var/obj/items/tech/Power_Line/p in trf)
										p.reconnect_power()
									//if(power_grid[trf.x][trf.y][trf.z] == 1)
									if(trf.power_grid == 1)
										if(trf.excess_grid >= 0 || trf.stored_grid > 0) powered = 1;
										//if(excess_grid[trf.x][trf.y][trf.z] >= 0 || stored_grid[trf.x][trf.y][trf.z] > 0) powered = 1;
							if(powered && src.on) src.icon_state = "on"
							else src.icon_state = "off"
					if(params["left"])
						if(src.on == 0) return
						if(src in range(1,usr))
							var/power_on = 0
							for(var/turf/trf in src.locs)
								//if(power_grid[trf.x][trf.y][trf.z] == 1)
								if(trf.power_grid == 1)
									if(trf.excess_grid >= 0 || trf.stored_grid > 0) power_on = 1;
									//if(excess_grid[trf.x][trf.y][trf.z] >= 0 || stored_grid[trf.x][trf.y][trf.z] > 0) power_on = 1;
							if(power_on == 1)
								//Reset any tech we might be using first.
								if(usr.tech_using)
									var/obj/t = usr.tech_using
									if(t.used_by == usr) t.used_by = null
									usr.tech_using = null
								if(src.used_by) return

								//if(usr.tech_using != src)
								usr.tech_using = src;
								src.used_by = usr;
								//usr.disable_skills()
								winshow(usr,"robotics",1)
								if(src.in_use)
									winset(usr,"genetics.button_grow","is-disabled=true")
									winset(usr,"genetics.button_terminate","is-disabled=false")
									winset(usr,"genetics.button_clone","is-disabled=true")
									winset(usr,"genetics.button_new","is-disabled=true")
									if(src.growth_percent >= 100) winset(usr,"genetics.button_power","is-disabled=false")
									else winset(usr,"genetics.button_power","is-disabled=true")
									if(src.generator) winset(usr,"genetics.button_power","is-checked=true")
									else winset(usr,"genetics.button_power","is-checked=false")
									//usr.adjust_buttons_robotics(1,1)
									var/mob/m = src.in_use
									var/icon/I = icon(m.icon,"",SOUTH,1,0)
									I.Scale(128,128)
									var/X = fcopy_rsc(I)
									winset(usr,"genetics.creation_portrait","image=\ref[X]")
								else
									//usr.adjust_buttons_robotics(0,0)
									winset(usr,"genetics.button_grow","is-disabled=false")
									winset(usr,"genetics.button_terminate","is-disabled=true")
									winset(usr,"genetics.button_clone","is-disabled=false")
									winset(usr,"genetics.button_new","is-disabled=false")
									winset(usr,"genetics.button_reset","is-disabled=false")
									winset(usr,"genetics.button_power","is-disabled=true")
									winset(usr,"genetics.button_power","is-checked=false")
									var/icon/I = icon(usr.icon,"",SOUTH,1,0)
									I.Scale(128,128)
									var/X = fcopy_rsc(I)
									winset(usr,"genetics.creation_portrait","image=\ref[X]")
									if(winget(usr,"genetics.button_clone","is-checked") == "true")
										src.set_vat_stats(0,usr)
									else
										src.set_vat_stats(1,usr)
			Vat
				info_name = "Vat"
				name = "Vat"
				icon = 'vat.dmi'
				icon_state = "tank off"
				mouse_over_pointer = MOUSE_ACTIVE_POINTER
				value = 1000
				weight = 1
				hashadow = 1
				on = 1;
				on_always = 1
				bounds = "-7,2 to 39,18"
				density_factor = 1;
				pixel_x = -36;
				uses = 50
				can_activate = 1
				tech_parent_path = /obj/items/tech/sub_tech/Genetics/Cloning
				var
					set_for = null;
					mob/in_use = null;
					belongs = null
					growth_percent = 0
					points = 10;
					points_assigned = 0;
					points_limit = 2;
					cost = 0;
					lowest = 0;
					clone_type = "Clone"
					on_grid = 0;

					vat_psi_base = 1;
					vat_energy_base = 1
					vat_strength_base = 1
					vat_endurance_base = 1
					vat_agility_base = 1
					vat_force_base = 1
					vat_resistance_base = 1
					vat_offence_base = 1
					vat_defence_base = 1
					vat_regeneration_base = 1
					vat_recovery_base = 1

					vat_psi_mod_base = 1;
					vat_energy_mod_base = 1
					vat_strength_mod_base = 1
					vat_endurance_mod_base = 1
					vat_agility_mod_base = 1
					vat_force_mod_base = 1
					vat_resistance_mod_base = 1
					vat_offence_mod_base = 1
					vat_defence_mod_base = 1
					vat_regeneration_mod_base = 1
					vat_recovery_mod_base = 1

					vat_psi = 1;
					vat_energy = 1
					vat_strength = 1
					vat_endurance = 1
					vat_agility = 1
					vat_force = 1
					vat_resistance = 1
					vat_offence = 1
					vat_defence = 1
					vat_regeneration = 1
					vat_recovery = 1

					vat_psi_stat = 1;
					vat_energy_stat = 1
					vat_strength_stat = 1
					vat_endurance_stat = 1
					vat_agility_stat = 1
					vat_force_stat = 1
					vat_resistance_stat = 1
					vat_offence_stat = 1
					vat_defence_stat = 1
					vat_regeneration_stat = 1
					vat_recovery_stat = 1

					vat_stat_cap = 1;
					vat_total_stats = 0;

					vat_extra_heart = 0;
					vat_extra_kidneys = 0;
					vat_extra_lungs = 0;
					vat_extra_adrenal = 0;
					vat_extra_growth = 0;
					vat_extra_regen = 0;
					vat_extra_lobe = 0;
					vat_extra_spleen = 0;
					vat_extra_liver = 0;
					vat_extra_skin = 0;
					vat_has_hair = 0;
					vat_hair = 0;
					vat_hair_c = 0;
					vat_gen = 0;
					vat_ear = 0;
					vat_horn = 0;
					vat_skin = 0;
					vat_race = null;
					vat_clone_icon = null;
				proc
					round_mods()
						src.vat_psi = round(src.vat_psi,0.1)
						src.vat_energy = round(src.vat_energy,0.1)
						src.vat_strength = round(src.vat_strength,0.1)
						src.vat_agility = round(src.vat_agility,0.1)
						src.vat_endurance = round(src.vat_endurance,0.1)
						src.vat_force = round(src.vat_force,0.1)
						src.vat_resistance = round(src.vat_resistance,0.1)
						src.vat_offence = round(src.vat_offence,0.1)
						src.vat_defence = round(src.vat_defence,0.1)
						src.vat_regeneration = round(src.vat_regeneration,0.1)
						src.vat_recovery = round(src.vat_recovery,0.1)

						src.vat_psi_stat = round(src.vat_psi_stat,0.1)
						src.vat_energy_stat = round(src.vat_energy_stat,0.1)
						src.vat_strength_stat = round(src.vat_strength_stat,0.1)
						src.vat_endurance_stat = round(src.vat_endurance_stat,0.1)
						src.vat_agility_stat = round(src.vat_agility_stat,0.1)
						src.vat_force_stat = round(src.vat_force_stat,0.1)
						src.vat_resistance_stat = round(src.vat_resistance_stat,0.1)
						src.vat_offence_stat = round(src.vat_offence_stat,0.1)
						src.vat_defence_stat = round(src.vat_defence_stat,0.1)
						src.vat_regeneration_stat = round(src.vat_regeneration_stat,0.1)
						src.vat_recovery_stat = round(src.vat_recovery_stat,0.1)

						if(src.vat_psi_stat < 1) src.vat_psi_stat = 1;
						if(src.vat_energy_stat < 1) src.vat_energy_stat = 1;
						if(src.vat_endurance_stat < 1) src.vat_endurance_stat = 1;
						if(src.vat_strength_stat < 1) src.vat_strength_stat = 1;
						if(src.vat_resistance_stat < 1) src.vat_resistance_stat = 1;
						if(src.vat_force_stat < 1) src.vat_force_stat = 1;
						if(src.vat_offence_stat < 1) src.vat_offence_stat = 1;
						if(src.vat_defence_stat < 1) src.vat_defence_stat = 1;
					vat_grow(var/t = 100)
						if(t <= 0 || src.in_use == null) return
						t -= 1
						src.growth_percent += 1;
						spawn(1)
							if(src) src.vat_grow(t)
				Del()
					for(var/turf/trf in src.locs)
						for(var/obj/items/tech/Power_Line/p in trf)
							p.reconnect_power()
					..()
				New()
					..()
					tag = name
					category = list("Cloning")
					var/image/sel = image('fx.dmi',src,"select item",32)
					src.img_select = sel
					src.icon_state = "tank off"
					src.overlays += image('vat.dmi',src,"glass",32)
					src.desc_extra = "Power usage: [src.uses] \n\nProcess: Activated \n\nCan be toggled on or off"

					var/obj/hp_shell = new
					hp_shell.icon = 'bars_health.dmi'
					hp_shell.icon_state = "shell"
					hp_shell.pixel_y = 32
					hp_shell.plane = 6
					hp_shell.appearance_flags = KEEP_TOGETHER | TILE_BOUND
					hp_shell.loc = src

					spawn(1)
						if(src)
							if(src.in_use)
								var/mob/m = src.in_use
								m.loc = src.loc
								animate(m,pixel_y = 1,time = 10, loop = -1,flags = ANIMATION_PARALLEL)
								animate(pixel_y = 0,time = 10)
							if(src.organic) src.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(155,255,255))
							for(var/turf/trf in src.locs)
								for(var/obj/items/tech/Power_Line/p in trf)
									p.reconnect_power()
								//if(power_grid[trf.x][trf.y][trf.z] == 1)
								if(trf.power_grid == 1)
									if(trf.excess_grid >= 0 || trf.stored_grid > 0) src.icon_state = "tank on"
									//if(excess_grid[trf.x][trf.y][trf.z] >= 0 || stored_grid[trf.x][trf.y][trf.z] > 0) src.icon_state = "tank on"
							var/dying = 0;
							while(src)
								if(src.loc == null) return
								if(src.on)
									var/powered = 0;
									if(src.grabbed_by == null && src.tk == 0)
										for(var/turf/trf in src.locs)
											//if(power_grid[trf.x][trf.y][trf.z] == 1)
											if(trf.power_grid == 1)
												if(trf.excess_grid >= 0 || trf.stored_grid > 0)  powered = 1;
												//if(excess_grid[trf.x][trf.y][trf.z] >= 0 || stored_grid[trf.x][trf.y][trf.z] > 0) powered = 1;
									if(powered)
										src.icon_state = "tank on"
										dying = 0;
									else
										src.icon_state = "tank off"
										if(src.in_use) dying = 1;

								else if(src.in_use) dying = 1;

								if(src.in_use)
									var/mob/m = src.in_use;

									if(m.hp_bar_clone == null)
										var/obj/hp = new
										hp.icon = 'bars_health.dmi'
										hp.icon_state = "bar"
										hp.pixel_y = 32
										hp.plane = 6
										hp.appearance_flags = KEEP_TOGETHER
										m.hp_bar_clone = hp

										var/obj/hp_slice = new
										hp_slice.icon = 'bars_health.dmi'
										hp_slice.icon_state = "bar hp"
										hp_slice.pixel_x = 1
										hp_slice.loc = hp
										hp_slice.plane = FLOAT_PLANE
										hp_slice.layer = FLOAT_LAYER
										hp_slice.blend_mode = BLEND_INSET_OVERLAY
										hp_slice.appearance_flags = KEEP_TOGETHER | TILE_BOUND

										hp.vis_contents += hp_slice
									if(dying)
										if(m.being_grown == 0)
											m.vis_contents += m.hp_bar_clone
											m.vis_contents += hp_shell
											var/obj/hp_slice = m.hp_bar_clone.contents[1]
											m.percent_health -= 10;
											hp_slice.pixel_x = (m.percent_health/3)-33
											if(m.percent_health <= 0)
												src.clone_die()
												dying = 0;
									else if(m.percent_health < 100)
										m.percent_health += 10;
										var/obj/hp_slice = m.hp_bar_clone.contents[1]
										m.percent_health -= 10;
										hp_slice.pixel_x = (m.percent_health/3)-33
									if(m.percent_health >= 100)
										m.vis_contents -= m.hp_bar_clone
										m.vis_contents -= hp_shell
									//world << output("Percent hp is - [m.percent_health]", "chat.system")
								sleep(60)
				Move()
					..()
					if(src.in_use)
						//src.in_use.SetCenter(src)
						src.in_use.loc = src.loc;
						if(src.organic)
							src.in_use.step_x = src.step_x-16
							src.in_use.step_y = src.step_y+10;
						else
							src.in_use.step_y = src.step_y+24;
							src.in_use.step_x = src.step_x//+36;
							src.in_use.layer = src.layer+1
					/*
					if(src)
						for(var/turf/trf in src.locs)
							for(var/obj/items/tech/Power_Line/p in trf)
								p.reconnect_power()
					*/
				Click(location,control,params)
					..()
					//var/enable_vats_later
					return
					usr.mouse_down = null
					params = params2list(params)
					if(src.organic)
						if(src.belongs == usr.real_name)
							if(src in range(1,usr))
								var/power_on = 0
								for(var/turf/trf in src.locs)
									//if(power_grid[trf.x][trf.y][trf.z] == 1)
									if(trf.power_grid == 1)
										if(trf.excess_grid >= 0 || trf.stored_grid > 0) power_on = 1;
										//if(excess_grid[trf.x][trf.y][trf.z] >= 0 || stored_grid[trf.x][trf.y][trf.z] > 0) power_on = 1;
								if(power_on == 1)
									if(src.in_use == null)
										usr.tech_using = src
										usr.grow_clones()
										usr.tech_using = null
										usr.part_selected = null
						return
					if(params["right"])
						if(src in range(1,usr))
							if(src.on)
								src.on = 0;
								src.icon_state = "tank off"
								if(usr.tech_using == src)
									winshow(usr,"genetics",0)
									usr.tech_using = null;
									src.used_by = null
							else src.on = 1;

							var/powered = 0;
							if(src.grabbed_by == null && src.tk == 0)
								for(var/turf/trf in src.locs)
									for(var/obj/items/tech/Power_Line/p in trf)
										p.reconnect_power()
									//if(power_grid[trf.x][trf.y][trf.z] == 1)
									if(trf.power_grid == 1)
										if(trf.excess_grid >= 0 || trf.stored_grid > 0) powered = 1;
										//if(excess_grid[trf.x][trf.y][trf.z] >= 0 || stored_grid[trf.x][trf.y][trf.z] > 0) powered = 1;
							if(powered && src.on) src.icon_state = "tank on"
							else src.icon_state = "tank off"
					if(params["left"])
						if(src.on == 0) return
						if(src in range(1,usr))
							var/power_on = 0
							for(var/turf/trf in src.locs)
								//if(power_grid[trf.x][trf.y][trf.z] == 1)
								if(trf.power_grid == 1)
									if(trf.excess_grid >= 0 || trf.stored_grid > 0) power_on = 1;
									//if(excess_grid[trf.x][trf.y][trf.z] >= 0 || stored_grid[trf.x][trf.y][trf.z] > 0) power_on = 1;
							if(power_on == 1)
								//Reset any tech we might be using first.
								if(usr.tech_using)
									var/obj/t = usr.tech_using
									if(t.used_by == usr) t.used_by = null
									usr.tech_using = null
								if(src.used_by)
									usr.set_alert("Already in use.",'alert.dmi',"alert")
									return

								//if(usr.tech_using != src)
								usr.tech_using = src;
								src.used_by = usr;
								//usr.disable_skills()
								winshow(usr,"genetics",1)
								if(src.clone_type == "Clone")
									winset(usr,"genetics.button_clone","is-checked=true")
									winset(usr,"genetics.button_new","is-checked=false")
								if(src.clone_type == "New")
									winset(usr,"genetics.button_clone","is-checked=false")
									winset(usr,"genetics.button_new","is-checked=true")
								if(src.in_use)
									winset(usr,"genetics.button_grow","is-disabled=true")
									winset(usr,"genetics.button_terminate","is-disabled=false")
									winset(usr,"genetics.button_clone","is-disabled=true")
									winset(usr,"genetics.button_new","is-disabled=true")
									if(src.growth_percent >= 100) winset(usr,"genetics.button_power","is-disabled=false")
									else winset(usr,"genetics.button_power","is-disabled=true")
									if(src.generator) winset(usr,"genetics.button_power","is-checked=true")
									else winset(usr,"genetics.button_power","is-checked=false")
									var/mob/m = src.in_use
									var/icon/I = icon(m.icon,"",SOUTH,1,0)
									I.Scale(128,128)
									if(m.race == "Demon")
										var/icon/C = icon('Demon_Base_Male_Black.dmi',"",SOUTH,1,0)
										C.Scale(128,128)
										C.Blend(m.hair_c)
										I.Blend(C,ICON_OVERLAY)
									if(m.hair)
										var/icon/E = icon(m.hair.icon,"",SOUTH,1,0)
										E.Scale(128,128)

										I.Blend(E,ICON_OVERLAY,1,10)

									//I.Shift(NORTH,5)
									var/X = fcopy_rsc(I)
									winset(usr,"genetics.creation_portrait","image=\ref[X]")
									winset(usr,"genetics.hair_color","background-color=[src.vat_hair_c]")
								else
									winset(usr,"genetics.hair_color","background-color=#5F5F5F")
									winset(usr,"genetics.button_grow","is-disabled=false")
									winset(usr,"genetics.button_terminate","is-disabled=true")
									winset(usr,"genetics.button_clone","is-disabled=false")
									winset(usr,"genetics.button_new","is-disabled=false")
									winset(usr,"genetics.button_reset","is-disabled=false")
									winset(usr,"genetics.button_power","is-disabled=true")
									winset(usr,"genetics.button_power","is-checked=false")

									var/icon/I = icon(usr.icon,"",SOUTH,1,0)
									I.Scale(128,128)

									if(usr.hair)
										var/icon/E = icon(usr.hair.icon,"",SOUTH,1,0)
										E.Scale(128,128)

										I.Blend(E,ICON_OVERLAY,1,10)

									//I.Shift(NORTH,5)

									var/X = fcopy_rsc(I)
									winset(usr,"genetics.creation_portrait","image=\ref[X]")
									winset(usr,"genetics.hair_color","background-color=[usr.hair_c]")

									if(winget(usr,"genetics.button_clone","is-checked") == "true")
										src.set_vat_stats(0,usr)
									else
										src.set_vat_stats(1,usr)
								winset(usr,"genetics.growth_percent","text=\"Growth Percent: [round(src.growth_percent)]%\"")
								winset(usr,"genetics.growth","value=[round(src.growth_percent)]")
								usr.show_info_vat(src)
			armors
				var/armor_health = 0
				var/basecolor
				Kid_Saiyan_Armor_Full
					name = "Saiyan Full Armor(Kid)"
					info_name = "Kid_Saiyan_Armor_Full"
					mouse_over_pointer = MOUSE_ACTIVE_POINTER
					icon = 'Saiyan_Armor_Full_kid_padding.dmi'
					value = 1000

					stone_cost=680


					can_pocket = 1
					density_factor = 0
					armor = 1

					desc = "This full-body Saiyan armor covers you from head to toe, offering a sleek and intimidating appearance. It’s the traditional gear of elite warriors and fits comfortably during intense combat situations."
					tech_tree = "Engineering"
					act = /obj/items/tech/armors/Kid_Saiyan_Armor_Full/proc/use
					act_drop = /obj/items/tech/armors/Kid_Saiyan_Armor_Full/proc/drop
					appearance_flags = KEEP_TOGETHER
					tech_parent_path = /obj/items/tech/sub_tech/Engineering/Armors
					proc
						use(var/mob/m,var/obj/items/tech/armors/Kid_Saiyan_Armor_Full/i)
							if(i in m.accessing)
								var/mob/x = m.accessing
								for(var/obj/items/tech/armors/Kid_Saiyan_Armor_Full/A in x) if(A!=i && A.suffix)
									m.set_alert("Another armor is already equipped.",'alert.dmi',"alert")
									return
								if(!i.suffix)
									if(findtext(i.name,"(Kid)"))
										if(m.age>=13)
											m<<"You cannot fit this item."
											return
									if(!findtext(i.name,"(Kid)"))
										if(m.age<13)
											m<<"You cannot fit this item."
											return
									if(i:armor_health >0 ) i:armor_health = (i.level*0.10)
									i.overlays -= /obj/effects/select_item
									m.overlays -= i.icon
									i.suffix = "worn"
									i.name = "Saiyan Armor Full(Kid) (Equipped)"
									i.icon_state = ""
									i.layer = 13
									x.redraw_appearance()

									m.overlays += i.icon
									//m.update_icon(m)
									return
								else
									i.suffix = null
									i.name = "Saiyan Armor Full(Kid)"
									i.layer = initial(i.layer)
									x.redraw_appearance()
									m.overlays -= i.icon
								//	m.update_icon(m)
									return

						drop(var/mob/m,var/obj/items/tech/i)
							if(i in m.accessing)
								if(i.suffix)
									i.suffix = null
									i.name = "Saiyan Full Armor(Kid)"
									if(m.armored_hp)
										m.armored_hp = 0
										m.overlays -= i
								i.overlays -= /obj/effects/select_item
								m.drop(i)
				//	New()
						//tag = name
						//category = list("Armors")
						//var/image/sel = image('fx.dmi',src,"select item",1000)
						//src.img_select = sel

					Click(location,control,params)
						..()
						//Removes this item from the global Items list.
						if(items)
							if(src in items) items -= src
						params = params2list(params)
						if(params["left"])
							if(isturf(src.loc))
								usr.pickup(src)
								if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up [src]","actionoutput")
							else if(ismob(src.loc))
								if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
								usr.item_selected = src
								src.overlays -= /obj/effects/select_item
								src.overlays += /obj/effects/select_item
								usr.refresh_inv()
				Kid_Saiyan_Armor_Shoulderless
					name = "Saiyan Shoulderless Armor(Kid)"
					info_name = "Kid_Saiyan_Armor_Shuolderless"
					mouse_over_pointer = MOUSE_ACTIVE_POINTER
					icon = 'Saiyan_Armor_Shoulderless_kid_padding.dmi'
					value = 1000

					stone_cost=400


					can_pocket = 1
					density_factor = 0
					armor = 1

					desc = "A minimalistic take on the classic Saiyan armor, this design ditches the shoulder guards for a lightweight and agile fit. Perfect for fighters who rely on speed and flexibility in battle."
					tech_tree = "Engineering"
					act = /obj/items/tech/armors/Kid_Saiyan_Armor_Shoulderless/proc/use
					act_drop = /obj/items/tech/armors/Kid_Saiyan_Armor_Shoulderless/proc/drop
					appearance_flags = KEEP_TOGETHER
					tech_parent_path = /obj/items/tech/sub_tech/Engineering/Armors
					proc
						use(var/mob/m,var/obj/items/tech/armors/Kid_Saiyan_Armor_Shoulderless/i)
							if(i in m.accessing)
								var/mob/x = m.accessing
								for(var/obj/items/tech/armors/Kid_Saiyan_Armor_Shoulderless/A in x) if(A!=i && A.suffix)
									m.set_alert("Another armor is already equipped.",'alert.dmi',"alert")
									return
								if(!i.suffix)
									if(findtext(i.name,"(Kid)"))
										if(m.age>=13)
											m<<"You cannot fit this item."
											return
									if(!findtext(i.name,"(Kid)"))
										if(m.age<13)
											m<<"You cannot fit this item."
											return
									if(i:armor_health >0 ) i:armor_health = (i.level*0.10)
									i.overlays -= /obj/effects/select_item
									m.overlays -= i.icon
									i.suffix = "worn"
									i.name = "Saiyan Armor Shoulderless(Kid) (Equipped)"
									i.icon_state = ""
									i.layer = 13
									x.redraw_appearance()

									m.overlays += i.icon
								//	m.update_icon(m)
									return
								else
									i.suffix = null
									i.name = "Saiyan Armor Shoulderless(Kid)"
									i.layer = initial(i.layer)
									x.redraw_appearance()
									m.overlays -= i.icon
								//	m.update_icon(m)
									return
						drop(var/mob/m,var/obj/items/tech/i)
							if(i in m.accessing)
								if(i.suffix)
									i.suffix = null
									i.name = "Saiyan Shoulderless Armor(Kid)"
									if(m.armored_hp)
										m.armored_hp = 0
										m.overlays -= i

								m.drop(i)
					New()
						tag = name
						category = list("Armors")
						var/image/sel = image('fx.dmi',src,"select item",1000)
						src.img_select = sel
					Click(location,control,params)
						..()
						//Removes this item from the global Items list.
						if(items)
							if(src in items) items -= src
						params = params2list(params)
						if(params["left"])
							if(isturf(src.loc))
								usr.pickup(src)
								if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up [src]","actionoutput")
							else if(ismob(src.loc))
								if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
								usr.item_selected = src
								src.overlays -= /obj/effects/select_item
								src.overlays += /obj/effects/select_item
								usr.refresh_inv()
				Kid_Saiyan_Armor_Single_Shoulder
					name = "Saiyan Single Shoulder Armor(Kid)"
					info_name = "Kid_Saiyan_Armor_Single_Shoulder"
					mouse_over_pointer = MOUSE_ACTIVE_POINTER
					icon = 'Saiyan_Armor_SingleShoulder_kid_padding.dmi'
					value = 1000

					stone_cost=420


					can_pocket = 1
					density_factor = 0
					armor = 1

					desc = "A streamlined version of the classic Saiyan armor with a single shoulder guard. It provides a balanced look between style and freedom of movement, perfect for warriors who value agility"
					tech_tree = "Engineering"
					act = /obj/items/tech/armors/Kid_Saiyan_Armor_Single_Shoulder/proc/use
					act_drop = /obj/items/tech/armors/Kid_Saiyan_Armor_Single_Shoulder/proc/drop
					appearance_flags = KEEP_TOGETHER
					tech_parent_path = /obj/items/tech/sub_tech/Engineering/Armors
					proc
						use(var/mob/m,var/obj/items/tech/armors/Kid_Saiyan_Armor_Single_Shoulder/i)
							if(i in m.accessing)
								var/mob/x = m.accessing
								for(var/obj/items/tech/armors/Kid_Saiyan_Armor_Single_Shoulder/A in x) if(A!=i && A.suffix)
									m.set_alert("Another armor is already equipped.",'alert.dmi',"alert")
									return
								if(!i.suffix)
									if(findtext(i.name,"(Kid)"))
										if(m.age>=13)
											m<<"You cannot fit this item."
											return
									if(!findtext(i.name,"(Kid)"))
										if(m.age<13)
											m<<"You cannot fit this item."
											return
									if(i:armor_health >0 ) i:armor_health = (i.level*0.10)
									i.overlays -= /obj/effects/select_item
									m.overlays -= i.icon
									i.suffix = "worn"
									i.name = "Saiyan Armor Single Shoulder(Kid) (Equipped)"
									i.icon_state = ""
									i.layer = 13
									x.redraw_appearance()

									m.overlays += i.icon
								//	m.update_icon(m)
									return
								else
									i.suffix = null
									i.name = "Saiyan Armor Single Shoulder(Kid)"
									i.layer = initial(i.layer)
									x.redraw_appearance()
									m.overlays -= i.icon
								//	m.update_icon(m)
									return
						drop(var/mob/m,var/obj/items/tech/i)
							if(i in m.accessing)
								if(i.suffix)
									i.suffix = null
									i.name = "Saiyan Single Shoulder Armor(Kid)"
									if(m.armored_hp)
										m.armored_hp = 0
										m.overlays -= i

								m.drop(i)
								i.overlays -= /obj/effects/select_item
					New()
						tag = name
						category = list("Armors")
						var/image/sel = image('fx.dmi',src,"select item",1000)
						src.img_select = sel
					Click(location,control,params)
						..()
						//Removes this item from the global Items list.
						if(items)
							if(src in items) items -= src
						params = params2list(params)
						if(params["left"])
							if(isturf(src.loc))
								usr.pickup(src)
								if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up [src]","actionoutput")
							else if(ismob(src.loc))
								if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
								usr.item_selected = src
								src.overlays -= /obj/effects/select_item
								src.overlays += /obj/effects/select_item
								usr.refresh_inv()
				Kid_Saiyan_Armor
					name = "Saiyan Armor(Kid)"
					info_name = "Kid_Saiyan_Armor"
					mouse_over_pointer = MOUSE_ACTIVE_POINTER
					icon = 'Saiyan_Armor_kid_padding.dmi'
					value = 1000

					stone_cost=400


					can_pocket = 1
					density_factor = 0
					armor = 1

					desc = "The iconic Saiyan battle armor, designed for maximum durability and flexibility. Worn by legendary warriors, this armor ensures you look ready to conquer any challenge."
					tech_tree = "Engineering"
					act = /obj/items/tech/armors/Kid_Saiyan_Armor/proc/use
					act_drop = /obj/items/tech/armors/Kid_Saiyan_Armor/proc/drop
					appearance_flags = KEEP_TOGETHER
					tech_parent_path = /obj/items/tech/sub_tech/Engineering/Armors
					proc
						use(var/mob/m,var/obj/items/tech/armors/Kid_Saiyan_Armor/i)
							if(i in m.accessing)
								var/mob/x = m.accessing
								for(var/obj/items/tech/armors/Kid_Saiyan_Armor/A in x) if(A!=i && A.suffix)
									m.set_alert("Another armor is already equipped.",'alert.dmi',"alert")
									return
								if(!i.suffix)
									if(findtext(i.name,"(Kid)"))
										if(m.age>=13)
											m<<"You cannot fit this item."
											return
									if(!findtext(i.name,"(Kid)"))
										if(m.age<13)
											m<<"You cannot fit this item."
											return
									if(i:armor_health >0 ) i:armor_health = (i.level*0.10)
									i.overlays -= /obj/effects/select_item
									m.overlays -= i.icon
									i.suffix = "worn"
									i.name = "Saiyan Armor(Kid) (Equipped)"
									i.icon_state = ""
									i.layer = 13
									x.redraw_appearance()

									m.overlays += i.icon
							//		m.update_icon(m)
									return
								else
									i.suffix = null
									i.name = "Saiyan Armor(Kid)"
									i.layer = initial(i.layer)
									x.redraw_appearance()
									m.overlays -= i.icon
							//		m.update_icon(m)
									return
						drop(var/mob/m,var/obj/items/tech/i)
							if(i in m.accessing)
								if(i.suffix)
									i.suffix = null
									i.name = "Saiyan Armor(Kid)"
									if(m.armored_hp)
										m.armored_hp = 0
										m.overlays -= i.icon
								i.overlays -= /obj/effects/select_item
								m.drop(i)
					New()
						tag = name
						category = list("Armors")
						var/image/sel = image('fx.dmi',src,"select item",1000)
						src.img_select = sel
					Click(location,control,params)
						..()
						//Removes this item from the global Items list.
						if(items)
							if(src in items) items -= src
						params = params2list(params)
						if(params["left"])
							if(isturf(src.loc))
								usr.pickup(src)
								if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up [src]","actionoutput")
							else if(ismob(src.loc))
								if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
								usr.item_selected = src
								src.overlays -= /obj/effects/select_item
								src.overlays += /obj/effects/select_item
								usr.refresh_inv()
				Kid_Alien_Armor
					name = "Alien Armor(Kid)"
					info_name = "Kid_Alien_Armor"
					mouse_over_pointer = MOUSE_ACTIVE_POINTER
					icon = 'AlienArmorKid.dmi'
					value = 1000

					stone_cost=400


					can_pocket = 1
					density_factor = 0
					armor = 1

					desc = "Alien armor comes in exotic designs, reflecting its wearer’s diverse origins. Whether sleek or rugged, it’s built for style and adaptability, making you stand out in the battlefield."
					tech_tree = "Engineering"
					act = /obj/items/tech/armors/Kid_Alien_Armor/proc/use
					act_drop = /obj/items/tech/armors/Kid_Alien_Armor/proc/drop
					appearance_flags = KEEP_TOGETHER
					tech_parent_path = /obj/items/tech/sub_tech/Engineering/Armors
					proc
						use(var/mob/m,var/obj/items/tech/i)
							if(i in m)
								for(var/obj/items/tech/armors/A in m) if(A!=i && A.suffix)
									m << "You already have armor equipped."
									m.set_alert("Another armor is already equipped.",'alert.dmi',"alert")
									return
								if(!i.suffix)
									if(findtext(i.name,"(Kid)"))
										if(m.age>=13)
											m<<"You cannot fit this item."
											return
									if(!findtext(i.name,"(Kid)"))
										if(m.age<13)
											m<<"You cannot fit this item."
											return
									i.suffix = "equipped"
									i.name = "Alien Armor(Kid) (Equipped)"
									if(i:armor_health >0 ) i:armor_health = (i.level*0.10)

									m.overlays += i

									m.refresh_inv()
									return
								else
									i.suffix = null
									i.name = "Alien Armor(Kid)"
									if(m.armored_hp)
										m.armored_hp = 0
										m.overlays -= i

									m.refresh_inv()
									return
						drop(var/mob/m,var/obj/items/tech/i)
							if(i in m.accessing)
								if(i.suffix)
									i.suffix = null
									i.name = "Alien Armor(Kid)"
									if(m.armored_hp)
										m.armored_hp = 0
										m.overlays -= i
								i.overlays -= /obj/effects/select_item
								m.drop(i)

					New()
						tag = name
						category = list("Armors")
						var/image/sel = image('fx.dmi',src,"select item",1000)
						src.img_select = sel
					Click(location,control,params)
						..()
						//Removes this item from the global Items list.
						if(items)
							if(src in items) items -= src
						params = params2list(params)
						if(params["left"])
							if(isturf(src.loc))
								usr.pickup(src)
								if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up [src]","actionoutput")
							else if(ismob(src.loc))
								if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
								usr.item_selected = src
								src.overlays -= /obj/effects/select_item
								src.overlays += /obj/effects/select_item
								usr.refresh_inv()
				Kid_Basic_Armor
					name = "Basic Armor(Kid)"
					info_name = "Kid_Basic_Armor"
					mouse_over_pointer = MOUSE_ACTIVE_POINTER
					icon = 'Basic_Armor_kid.dmi'
					value = 1000

					stone_cost=150


					can_pocket = 1
					density_factor = 0
					armor = 1

					desc = "Basic armor offers a simple layer of protection, ideal for those just starting their journey. It’s reliable and easy to wear, giving you a classic look while keeping you battle-ready."
					tech_tree = "Engineering"
					act = /obj/items/tech/armors/Kid_Basic_Armor/proc/use
					act_drop = /obj/items/tech/armors/Kid_Basic_Armor/proc/drop
					appearance_flags = KEEP_TOGETHER
					tech_parent_path = /obj/items/tech/sub_tech/Engineering/Armors
					proc
						use(var/mob/m,var/obj/items/tech/i)
							if(i in m)
								for(var/obj/items/tech/armors/A in m) if(A!=i && A.suffix)
									m << "You already have armor equipped."
									m.set_alert("Another armor is already equipped.",'alert.dmi',"alert")
									return
								if(!i.suffix)
									if(findtext(i.name,"(Kid)"))
										if(m.age>=13)
											m<<"You cannot fit this item."
											return
									if(!findtext(i.name,"(Kid)"))
										if(m.age<13)
											m<<"You cannot fit this item."
											return
									i.suffix = "equipped"
									i.name = "Basic Armor (Equipped)"
									if(m.armored_hp == 0)
										m.armored_hp = (i.level*0.125)
										m.overlays += i

									m.refresh_inv()
									return
								else
									i.suffix = null
									i.name = "Basic Armor"
									if(m.armored_hp)
										m.armored_hp = 0
										m.overlays -= i.icon

									m.refresh_inv()
									return
						drop(var/mob/m,var/obj/items/tech/i)
							if(i in m.accessing)
								if(i.suffix)
									i.suffix = null
									i.name = "Basic Armor"
									if(m.armored_hp)
										m.armored_hp = 0
										m.overlays -= i.icon

								m.drop(i)
					New()
						tag = name
						category = list("Armors")
						var/image/sel = image('fx.dmi',src,"select item",1000)
						src.img_select = sel
					Click(location,control,params)
						..()
						//Removes this item from the global Items list.
						if(items)
							if(src in items) items -= src
						params = params2list(params)
						if(params["left"])
							if(isturf(src.loc))
								usr.pickup(src)
								if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up [src]","actionoutput")
							else if(ismob(src.loc))
								if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
								usr.item_selected = src
								src.overlays -= /obj/effects/select_item
								src.overlays += /obj/effects/select_item
								usr.refresh_inv()
				Saiyan_Armor_Full
					name = "Saiyan Full Armor"
					info_name = "Saiyan_Armor_Full"
					mouse_over_pointer = MOUSE_ACTIVE_POINTER
					icon = 'Saiyan_Armor_Full_Padding.dmi'
					value = 1000

					stone_cost=680


					can_pocket = 1
					density_factor = 0
					armor = 1

					desc = "This full-body Saiyan armor covers you from head to toe, offering a sleek and intimidating appearance. It’s the traditional gear of elite warriors and fits comfortably during intense combat situations."
					tech_tree = "Engineering"
					act = /obj/items/tech/armors/Saiyan_Armor_Full/proc/use
					act_drop = /obj/items/tech/armors/Saiyan_Armor_Full/proc/drop
					appearance_flags = KEEP_TOGETHER
					tech_parent_path = /obj/items/tech/sub_tech/Engineering/Armors
					proc
						use(var/mob/m,var/obj/items/tech/armors/Saiyan_Armor_Full/i)
							if(i in m.accessing)
								var/mob/x = m.accessing
								for(var/obj/items/tech/armors/Saiyan_Armor_Full/A in x) if(A!=i && A.suffix)
									m.set_alert("Another armor is already equipped.",'alert.dmi',"alert")
									return
								if(!i.suffix)
									if(findtext(i.name,"(Kid)"))
										if(m.age>=13)
											m<<"You cannot fit this item."
											return
									if(!findtext(i.name,"(Kid)"))
										if(m.age<13)
											m<<"You cannot fit this item."
											return
									if(i:armor_health >0 ) i:armor_health = (i.level*0.10)
									i.overlays -= /obj/effects/select_item
									m.overlays -= i.icon
									i.suffix = "worn"
									i.name = "Saiyan Full Armor(Equipped)"
									i.icon_state = ""
									i.layer = 13
									x.redraw_appearance()

									m.overlays += i.icon
									m.update_icon(m)
									return
								else
									i.suffix = null
									i.name = "Saiyan Armor"
									i.layer = initial(i.layer)
									x.redraw_appearance()
									m.overlays -= i.icon
									m.update_icon(m)
									return
						drop(var/mob/m,var/obj/items/tech/i)
							if(i in m.accessing)
								if(i.suffix)
									i.suffix = null
									i.name = "Saiyan Full Armor"
									if(m.armored_hp)
										m.armored_hp = 0
										m.overlays -= i.icon

								m.drop(i)
					New()
						tag = name
						category = list("Armors")
						var/image/sel = image('fx.dmi',src,"select item",1000)
						src.img_select = sel
					Click(location,control,params)
						..()
						//Removes this item from the global Items list.
						if(items)
							if(src in items) items -= src
						params = params2list(params)
						if(params["left"])
							if(isturf(src.loc))
								usr.pickup(src)
								if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up [src]","actionoutput")
							else if(ismob(src.loc))
								if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
								usr.item_selected = src
								src.overlays -= /obj/effects/select_item
								src.overlays += /obj/effects/select_item
								usr.refresh_inv()
				Saiyan_Armor_Shoulderless
					name = "Saiyan Shoulderless Armor"
					info_name = "Saiyan_Armor_Shuolderless"
					mouse_over_pointer = MOUSE_ACTIVE_POINTER
					icon = 'Saiyan_Armor_Shoulderless_Padding.dmi'
					value = 1000

					stone_cost=400


					can_pocket = 1
					density_factor = 0
					armor = 1

					desc = "A minimalistic take on the classic Saiyan armor, this design ditches the shoulder guards for a lightweight and agile fit. Perfect for fighters who rely on speed and flexibility in battle."
					tech_tree = "Engineering"
					act = /obj/items/tech/armors/Saiyan_Armor_Shoulderless/proc/use
					act_drop = /obj/items/tech/armors/Saiyan_Armor_Shoulderless/proc/drop
					appearance_flags = KEEP_TOGETHER
					tech_parent_path = /obj/items/tech/sub_tech/Engineering/Armors
					proc
						use(var/mob/m,var/obj/items/tech/armors/Saiyan_Armor_Shoulderless/i)
							if(i in m.accessing)
								var/mob/x = m.accessing
								for(var/obj/items/tech/armors/Saiyan_Armor_Shoulderless/A in x) if(A!=i && A.suffix)
									m.set_alert("Another armor is already equipped.",'alert.dmi',"alert")
									return
								if(!i.suffix)
									if(findtext(i.name,"(Kid)"))
										if(m.age>=13)
											m<<"You cannot fit this item."
											return
									if(!findtext(i.name,"(Kid)"))
										if(m.age<13)
											m<<"You cannot fit this item."
											return
									if(i:armor_health >0 ) i:armor_health = (i.level*0.10)
									i.overlays -= /obj/effects/select_item
									m.overlays -= i.icon
									i.suffix = "worn"
									i.name = "Saiyan Shoulderless Armor(Equipped)"
									i.icon_state = ""
									i.layer = 13
									x.redraw_appearance()

									m.overlays += i.icon
									m.update_icon(m)
									return
								else
									i.suffix = null
									i.name = "Saiyan Shouldrless Armor"
									i.layer = initial(i.layer)
									x.redraw_appearance()
									m.overlays -= i.icon
									m.update_icon(m)
									return
						drop(var/mob/m,var/obj/items/tech/i)
							if(i in m.accessing)
								if(i.suffix)
									i.suffix = null
									i.name = "Saiyan Shoulderless Armor"
									if(m.armored_hp)
										m.armored_hp = 0
										m.overlays -= i.icon

								m.drop(i)
					New()
						tag = name
						category = list("Armors")
						var/image/sel = image('fx.dmi',src,"select item",1000)
						src.img_select = sel
					Click(location,control,params)
						..()
						//Removes this item from the global Items list.
						if(items)
							if(src in items) items -= src
						params = params2list(params)
						if(params["left"])
							if(isturf(src.loc))
								usr.pickup(src)
								if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up [src]","actionoutput")
							else if(ismob(src.loc))
								if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
								usr.item_selected = src
								src.overlays -= /obj/effects/select_item
								src.overlays += /obj/effects/select_item
								usr.refresh_inv()
				Saiyan_Armor_Single_Shoulder
					name = "Saiyan Single Shoulder Armor"
					info_name = "Saiyan_Armor_Single_Shoulder"
					mouse_over_pointer = MOUSE_ACTIVE_POINTER
					icon = 'Saiyan_Armor_SingleShoulder_Padding.dmi'
					value = 1000

					stone_cost=420


					can_pocket = 1
					density_factor = 0
					armor = 1

					desc = "A streamlined version of the classic Saiyan armor with a single shoulder guard. It provides a balanced look between style and freedom of movement, perfect for warriors who value agility"
					tech_tree = "Engineering"
					act = /obj/items/tech/armors/Saiyan_Armor_Single_Shoulder/proc/use
					act_drop = /obj/items/tech/armors/Saiyan_Armor_Single_Shoulder/proc/drop
					appearance_flags = KEEP_TOGETHER
					tech_parent_path = /obj/items/tech/sub_tech/Engineering/Armors
					proc
						use(var/mob/m,var/obj/items/tech/armors/Saiyan_Armor_Single_Shoulder/i)
							if(i in m.accessing)
								var/mob/x = m.accessing
								for(var/obj/items/tech/armors/Saiyan_Armor_Single_Shoulder/A in x) if(A!=i && A.suffix)
									m.set_alert("Another armor is already equipped.",'alert.dmi',"alert")
									return
								if(!i.suffix)
									if(findtext(i.name,"(Kid)"))
										if(m.age>=13)
											m<<"You cannot fit this item."
											return
									if(!findtext(i.name,"(Kid)"))
										if(m.age<13)
											m<<"You cannot fit this item."
											return
									if(i:armor_health >0 ) i:armor_health = (i.level*0.10)
									i.overlays -= /obj/effects/select_item
									m.overlays -= i.icon
									i.suffix = "worn"
									i.name = "Saiyan Single Shoulder Armor(Equipped)"
									i.icon_state = ""
									i.layer = 13
									x.redraw_appearance()

									m.overlays += i.icon
									m.update_icon(m)
									return
								else
									i.suffix = null
									i.name = "Saiyan Single Shoulder Armor"
									i.layer = initial(i.layer)
									x.redraw_appearance()
									m.overlays -= i.icon
									m.update_icon(m)
									return
						drop(var/mob/m,var/obj/items/tech/i)
							if(i in m.accessing)
								if(i.suffix)
									i.suffix = null
									i.name = "Saiyan Single Shoulder Armor"
									if(m.armored_hp)
										m.armored_hp = 0
										m.overlays -= i.icon

								m.drop(i)
					New()
						tag = name
						category = list("Armors")
						var/image/sel = image('fx.dmi',src,"select item",1000)
						src.img_select = sel
					Click(location,control,params)
						..()
						//Removes this item from the global Items list.
						if(items)
							if(src in items) items -= src
						params = params2list(params)
						if(params["left"])
							if(isturf(src.loc))
								usr.pickup(src)
								if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up [src]","actionoutput")
							else if(ismob(src.loc))
								if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
								usr.item_selected = src
								src.overlays -= /obj/effects/select_item
								src.overlays += /obj/effects/select_item
								usr.refresh_inv()
				Saiyan_Armor
					info_name = "Saiyan_Armor"
					mouse_over_pointer = MOUSE_ACTIVE_POINTER
					icon = 'Saiyan_Armor_Padding.dmi'
					value = 1000

					stone_cost=400


					can_pocket = 1
					density_factor = 0
					armor = 1

					desc = "The iconic Saiyan battle armor, designed for maximum durability and flexibility. Worn by legendary warriors, this armor ensures you look ready to conquer any challenge."
					tech_tree = "Engineering"
					act = /obj/items/tech/armors/Saiyan_Armor/proc/use
					act_drop = /obj/items/tech/armors/Saiyan_Armor/proc/drop
					appearance_flags = KEEP_TOGETHER
					tech_parent_path = /obj/items/tech/sub_tech/Engineering/Armors
					proc
						use(var/mob/m,var/obj/items/tech/armors/Saiyan_Armor/i)
							if(i in m.accessing)
								var/mob/x = m.accessing
								for(var/obj/items/tech/armors/Saiyan_Armor/A in x) if(A!=i && A.suffix)
									m.set_alert("Another armor is already equipped.",'alert.dmi',"alert")
									return
								if(!i.suffix)
									if(findtext(i.name,"(Kid)"))
										if(m.age>=13)
											m<<"You cannot fit this item."
											return
									if(!findtext(i.name,"(Kid)"))
										if(m.age<13)
											m<<"You cannot fit this item."
											return
									if(i:armor_health >0 ) i:armor_health = (i.level*0.10)
									i.overlays -= /obj/effects/select_item
									m.overlays -= i.icon
									i.suffix = "worn"
									i.name = "Saiyan Armor(Equipped)"
									i.icon_state = ""
									i.layer = 13
									x.redraw_appearance()

									m.overlays += i.icon
									m.update_icon(m)
									return
								else
									i.suffix = null
									i.name = "Saiyan Armor"
									i.layer = initial(i.layer)
									x.redraw_appearance()
									m.overlays -= i.icon
									m.update_icon(m)
									return
						drop(var/mob/m,var/obj/items/tech/i)
							if(i in m.accessing)
								if(i.suffix)
									i.suffix = null
									i.name = "Saiyan Armor"
									if(m.armored_hp)
										m.armored_hp = 0
										m.overlays -= i.icon

								m.drop(i)
					New()
						tag = name
						category = list("Armors")
						var/image/sel = image('fx.dmi',src,"select item",1000)
						src.img_select = sel
					Click(location,control,params)
						..()
						//Removes this item from the global Items list.
						if(items)
							if(src in items) items -= src
						params = params2list(params)
						if(params["left"])
							if(isturf(src.loc))
								usr.pickup(src)
								if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up [src]","actionoutput")
							else if(ismob(src.loc))
								if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
								usr.item_selected = src
								src.overlays -= /obj/effects/select_item
								src.overlays += /obj/effects/select_item
								usr.refresh_inv()
				Alien_Armor
					info_name = "Alien_Armor"
					mouse_over_pointer = MOUSE_ACTIVE_POINTER
					icon = 'AlienArmor.dmi'
					value = 1000

					stone_cost=400


					can_pocket = 1
					density_factor = 0
					armor = 1

					desc = "Alien armor comes in exotic designs, reflecting its wearer’s diverse origins. Whether sleek or rugged, it’s built for style and adaptability, making you stand out in the battlefield."
					tech_tree = "Engineering"
					act = /obj/items/tech/armors/Alien_Armor/proc/use
					act_drop = /obj/items/tech/armors/Alien_Armor/proc/drop
					appearance_flags = KEEP_TOGETHER
					tech_parent_path = /obj/items/tech/sub_tech/Engineering/Armors
					proc
						use(var/mob/m,var/obj/items/tech/i)
							if(i in m)
								for(var/obj/items/tech/armors/A in m) if(A!=i && A.suffix)
									m << "You already have armor equipped."
									m.set_alert("Another armor is already equipped.",'alert.dmi',"alert")
									return
								if(!i.suffix)
									if(findtext(i.name,"(Kid)"))
										if(m.age>=13)
											m<<"You cannot fit this item."
											return
									if(!findtext(i.name,"(Kid)"))
										if(m.age<13)
											m<<"You cannot fit this item."
											return
									i.suffix = "equipped"
									i.name = "Alien Armor (Equipped)"
									if(m.armored_hp == 0)
										m.armored_hp = (i.level*0.125)
										m.overlays += i.icon

									m.refresh_inv()
									return
								else
									i.suffix = null
									i.name = "Alien Armor"
									if(m.armored_hp)
										m.armored_hp = 0
										m.overlays -= i.icon

									m.refresh_inv()
									return
						drop(var/mob/m,var/obj/items/tech/i)
							if(i in m.accessing)
								if(i.suffix)
									i.suffix = null
									i.name = "Alien Armor"
									if(m.armored_hp)
										m.armored_hp = 0
										m.overlays -= i.icon

								m.drop(i)
					New()
						tag = name
						category = list("Armors")
						var/image/sel = image('fx.dmi',src,"select item",1000)
						src.img_select = sel
					Click(location,control,params)
						..()
						//Removes this item from the global Items list.
						if(items)
							if(src in items) items -= src
						params = params2list(params)
						if(params["left"])
							if(isturf(src.loc))
								usr.pickup(src)
								if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up [src]","actionoutput")
							else if(ismob(src.loc))
								if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
								usr.item_selected = src
								src.overlays -= /obj/effects/select_item
								src.overlays += /obj/effects/select_item
								usr.refresh_inv()
				Basic_Armor
					info_name = "Basic_Armor"
					mouse_over_pointer = MOUSE_ACTIVE_POINTER
					icon = 'Basic_Armor.dmi'
					value = 1000

					stone_cost=150


					can_pocket = 1
					density_factor = 0
					armor = 1

					desc = "Basic armor offers a simple layer of protection, ideal for those just starting their journey. It’s reliable and easy to wear, giving you a classic look while keeping you battle-ready."
					tech_tree = "Engineering"
					act = /obj/items/tech/armors/Basic_Armor/proc/use
					act_drop = /obj/items/tech/armors/Basic_Armor/proc/drop
					appearance_flags = KEEP_TOGETHER
					tech_parent_path = /obj/items/tech/sub_tech/Engineering/Armors
					proc
						use(var/mob/m,var/obj/items/tech/i)
							if(i in m)
								for(var/obj/items/tech/armors/A in m) if(A!=i && A.suffix)
									m << "You already have armor equipped."
									m.set_alert("Another armor is already equipped.",'alert.dmi',"alert")
									return
								if(!i.suffix)
									if(findtext(i.name,"(Kid)"))
										if(m.age>=13)
											m<<"You cannot fit this item."
											return
									if(!findtext(i.name,"(Kid)"))
										if(m.age<13)
											m<<"You cannot fit this item."
											return
									i.suffix = "equipped"
									i.name = "Basic Armor (Equipped)"
									if(m.armored_hp == 0)
										m.armored_hp = (i.level*0.125)
										m.overlays += i.icon

									m.refresh_inv()
									return
								else
									i.suffix = null
									i.name = "Basic Armor"
									if(m.armored_hp)
										m.armored_hp = 0
										m.overlays -= i.icon

									m.refresh_inv()
									return
						drop(var/mob/m,var/obj/items/tech/i)
							if(i in m.accessing)
								if(i.suffix)
									i.suffix = null
									i.name = "Basic Armor"
									if(m.armored_hp)
										m.armored_hp = 0
										m.overlays -= i.icon

								m.drop(i)
					New()
						tag = name
						category = list("Armors")
						var/image/sel = image('fx.dmi',src,"select item",1000)
						src.img_select = sel
					Click(location,control,params)
						..()
						//Removes this item from the global Items list.
						if(items)
							if(src in items) items -= src
						params = params2list(params)
						if(params["left"])
							if(isturf(src.loc))
								usr.pickup(src)
								if(ismob(src.loc)) view(15,usr)<<output("[usr] picks up [src]","actionoutput")
							else if(ismob(src.loc))
								if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
								usr.item_selected = src
								src.overlays -= /obj/effects/select_item
								src.overlays += /obj/effects/select_item
								usr.refresh_inv()
			Container_Tech
				info_name = "Container_Tech"
				name = "Container"
				icon = 'containers.dmi'
				icon_state = "container tech closed"
				value = 1000
				weight = 1
				New()
					..()
					tag = name
					category = list("Storage")
					var/image/sel = image('fx.dmi',src,"select item",1000)
					src.img_select = sel
					name = "[src.name] ([src.value])"
			Silo
				info_name = "Silo"
				icon = 'silo.dmi'
				pixel_x = -32
				value = 2000
				density_factor = 1
				silo = 1
				New()
					..()
					tag = name
					var/image/sel = image('fx_large.dmi',src,"select item",1000)
					src.img_select = sel
					name = "[src.name] ([src.value])"
					spawn(1)
						if(src.loc == null) return
						else src.value = 0
			Resource_Cache
				info_name = "Resource_Cache"
				icon = 'crate.dmi'
				value = 10000
				density_factor = 1
				pixel_x = -16
				pixel_y = -10
				New()
					..()
					tag = name
					var/image/sel = image('fx_large.dmi',src,"select item",1000)
					src.img_select = sel
			Battery
				info_name = "Battery"
				icon = 'battery.dmi'
				icon_state = "battery"
				pixel_x = -32
				p_x = -32
				value = 2000
				density_factor = 1
				capacity = 0
				bounds = "-7,1 to 40,24"
				desc = "The battery vigilantly regulates the flow of electricity through all connected power lines. Its unwavering vigilance ensures that the entire network functions seamlessly, delivering power exactly where it's needed. A crucial element of modern technology, the battery is the cornerstone of countless machines and systems, and must always remain firmly connected to a power line in order to operate."
				tech_tree = "Physics"
				tech_subtech = "Electrochemistry"
				tech_upgradable = 1
				tech_parent_path = /obj/items/tech/sub_tech/Physics/Electrochemistry
				proc
					battery_power()
						for(var/turf/t in src.locs)
							for(var/obj/items/tech/Power_Line/p in t)
								if(p.network)
									var/area/a = p.network
									var/excess = a.excess_grid
									if(excess != null)
										var/bat_num = 0
										//If the battery is draining power
										if(excess < 0)
											for(var/obj/b in a.bats_list)
												if(b.capacity > 0) bat_num += 1
											if(bat_num > 0)
												src.capacity += excess/bat_num
												if(src.capacity <= 0) src.capacity = 0
											p.reconnect_power()
											break
										//If the battery is storing power
										if(excess > 0)
											for(var/obj/b in a.bats_list)
												if(b.capacity < b.capacity_max) bat_num += 1
											if(bat_num > 0)
												src.capacity += excess/bat_num
												if(src.capacity > src.capacity_max) src.capacity = src.capacity_max
											break
						src.overlays -= src.overlay_special
						src.overlay_special.icon_state = "[round(src.capacity/src.capacity_max*100,10)]"
						src.overlays += src.overlay_special
				New()
					..()
					category = list("Energy Storage")
					connections = list()
					var/image/sel = image('fx_large.dmi',src,"select item",1000)
					src.img_select = sel
					tag = name
					src.desc_extra = "Max capacity: [src.capacity_max]"
					spawn(1)
						if(src.loc == null)
							return
						for(var/turf/trf in src.locs)
							for(var/obj/items/tech/Power_Line/p in trf)
								p.reconnect_power()
								break
						var/obj/effects/tech/battery_overlay/o = new
						src.overlay_special = o
						src.overlays += src.overlay_special
						while(src)
							if(src.loc == null) return
							src.battery_power()
							sleep(100)
				Del()
					for(var/turf/trf in src.locs)
						for(var/obj/items/tech/Power_Line/p in trf)
							p.reconnect_power()
					..()
			Wind_Turbine
				icon = 'turbine_wind.dmi'
				icon_state = "turbine"
				info_name = "Wind_Turbine"
				pixel_y = 10
				density_factor = 1
				bounds = "7,11 to 27,19"
				value = 2000
				hashadow = 0
				generator = 1;
				generates = 50;
				scale_x = 32;
				scale_y = 64;
				desc = "This technological structure is very important for the production of clean power. It produces energy at a modest rate, depending on the weather, which is then sent to the nearest available battery. Like many technlogical structures, it must remain over a power line to send power to a battery."
				tech_tree = "Physics"
				tech_subtech = "Wind Generators"
			//	tech_parent_path = /obj/items/tech/sub_tech/Physics/Wind_Generators
				/*
				Move()
					for(var/turf/trf in src.locs)
						for(var/obj/items/tech/Power_Line/p in trf)
							p.reconnect_power()
					..()
				*/
				Del()
					for(var/turf/trf in src.locs)
						for(var/obj/items/tech/Power_Line/p in trf)
							p.reconnect_power()
					..()
				New()
					..()
					tag = name
					category = list("Power Generation")
					var/image/sel = image('fx_large.dmi',src,"select item",5)
					src.img_select = sel
					spawn(1)
						if(src.loc)
							var/obj/effects/tech/blade/o = new
							src.overlays += o
						spawn(10)
							for(var/turf/trf in src.locs)
								for(var/obj/items/tech/Power_Line/p in trf)
									p.reconnect_power()
						var/obj/shad = new
						shad.icon = src.icon
						shad.icon_state = "shadow"
						shad.alpha = 100
						shad.pixel_y = -3
						shad.loc = src.loc
						shad.bolted = 2
						src.shadow = shad
						while(src)
							if(src.loc == null) return
							for(var/obj/items/tech/Power_Line/p in range(1,src))
								if(bounds_dist(src, p) < 3)
									if(!src.grabbed_by) if(!src.tk)
										for(var/obj/b in p.batteries)
											if(b.capacity < b.capacity_max)
												b.capacity += 1
												if(b.capacity > b.capacity_max)
													b.capacity = b.capacity_max
												break
							sleep(10)
			Nuclear_Power_Plant
				info_name = "Nuclear_Power_Plant"
				icon = 'nuclear_plant.dmi'
				icon_state = "core"
				pixel_x = -110
				pixel_y = -32
				density_factor = 1
				bolted = 2
				bounds = "-15,24 to 48,69"
				generator = 1;
				generates = 3000;
				hashadow = 0;
				value = 20000
				scale_x = 80;
				scale_y = 32;
				radius = 4;
				desc = "This technological structure is very important for the production of clean power. At day, it will produce energy at a modest rate and send it into the nearest available battery. Like many technlogical structures, it must remain over a power line to send power to a battery."
				tech_tree = "Engineering"
				Del()
					for(var/turf/trf in src.locs)
						for(var/obj/items/tech/Power_Line/p in trf)
							p.reconnect_power()
					..()
				New()
					..()
					//src.icon = null
					src.invisibility = 100
					src.pixel_y = 16
					spawn(10)
						if(src)
							//sleep(0.1)
							var/obj/base = new
							base.icon = 'nuclear_plant.dmi'
							base.icon_state = "base"
							base.layer = 2.1 //src.layer - 0.1
							base.loc = src.loc
							base.pixel_x = src.pixel_x
							base.pixel_y = 16
							base.bolted = 2
							animate(base, pixel_y = -32 ,time = 2, easing = BOUNCE_EASING)
							sleep(2.1)
							//src.icon = 'nuclear_plant.dmi'
							src.invisibility = 0
							animate(src, pixel_y = -32 ,time = 2, easing = BOUNCE_EASING)
							src.layer = MOB_LAYER + src.laymod - ((src.y+1) + src.step_y / 32) / world.maxy
							sleep(2.1)
							//src.pixel_y = -32
							var/obj/coolant1 = new
							coolant1.icon = 'nuclear_plant.dmi'
							coolant1.icon_state = "coolant1"
							//coolant1.layer = src.layer + 0.2
							coolant1.loc = src.loc
							coolant1.pixel_x = src.pixel_x
							coolant1.pixel_y = 16
							coolant1.bolted = 2
							coolant1.layer = MOB_LAYER + src.laymod - ((src.y+2) + src.step_y / 32) / world.maxy
							animate(coolant1, pixel_y = -32 ,time = 2, easing = BOUNCE_EASING)
							sleep(2.1)
							var/obj/coolant2 = new
							coolant2.icon = 'nuclear_plant.dmi'
							coolant2.icon_state = "coolant2"
							//coolant2.layer = src.layer + 0.2
							coolant2.loc = src.loc
							coolant2.pixel_x = src.pixel_x
							coolant2.pixel_y = 16
							coolant2.bolted = 2
							coolant2.layer = MOB_LAYER + src.laymod - ((src.y+2) + src.step_y / 32) / world.maxy
							animate(coolant2, pixel_y = -32 ,time = 2, easing = BOUNCE_EASING)
							sleep(2.1)
							var/obj/fence_left_vert = new
							fence_left_vert.icon = 'nuclear_plant.dmi'
							fence_left_vert.icon_state = "left fence vert"
							fence_left_vert.layer = src.layer
							fence_left_vert.loc = src.loc
							fence_left_vert.pixel_x = src.pixel_x
							fence_left_vert.pixel_y = 16
							fence_left_vert.bounds = "-110,-32 to -106,150"
							fence_left_vert.density = 1
							fence_left_vert.bolted = 2
							fence_left_vert.density_factor = 2
							animate(fence_left_vert, pixel_y = -32 ,time = 2, easing = BOUNCE_EASING)
							sleep(2.1)
							var/obj/fence_right_vert = new
							fence_right_vert.icon = 'nuclear_plant.dmi'
							fence_right_vert.icon_state = "right fence vert"
							fence_right_vert.layer = src.layer
							fence_right_vert.loc = src.loc
							fence_right_vert.pixel_x = src.pixel_x
							fence_right_vert.pixel_y = 16
							fence_right_vert.bounds = "139,-32 to 143,150"
							fence_right_vert.density = 1
							fence_right_vert.bolted = 2
							fence_right_vert.density_factor = 2
							animate(fence_right_vert, pixel_y = -32 ,time = 2, easing = BOUNCE_EASING)
							sleep(2.1)
							var/obj/fence_top_left = new
							fence_top_left.icon = 'nuclear_plant.dmi'
							fence_top_left.icon_state = "tl"
							//fence_top_left.layer = src.layer - 0.01
							fence_top_left.loc = src.loc
							fence_top_left.pixel_x = src.pixel_x
							fence_top_left.pixel_y = 16
							fence_top_left.bounds = "-110,150 to 2,155"
							fence_top_left.density = 1
							fence_top_left.bolted = 2
							fence_top_left.density_factor = 2
							fence_top_left.layer = MOB_LAYER + src.laymod - ((src.y+5) + src.step_y / 32) / world.maxy
							animate(fence_top_left, pixel_y = -32 ,time = 2, easing = BOUNCE_EASING)
							sleep(2.1)
							var/obj/fence_top_right = new
							fence_top_right.icon = 'nuclear_plant.dmi'
							fence_top_right.icon_state = "tr"
							//fence_top_right.layer = src.layer - 0.01
							fence_top_right.loc = src.loc
							fence_top_right.pixel_x = src.pixel_x
							fence_top_right.pixel_y = 16
							fence_top_right.bounds = "31,150 to 142,155"
							fence_top_right.density = 1
							fence_top_right.bolted = 2
							fence_top_right.density_factor = 2
							fence_top_right.layer = MOB_LAYER + src.laymod - ((src.y+5) + src.step_y / 32) / world.maxy
							animate(fence_top_right, pixel_y = -32 ,time = 2, easing = BOUNCE_EASING)
							sleep(2.1)
							var/obj/fence_bottom_left = new
							fence_bottom_left.icon = 'nuclear_plant.dmi'
							fence_bottom_left.icon_state = "bl"
							//fence_bottom_left.layer = src.layer + 0.002
							fence_bottom_left.loc = src.loc
							fence_bottom_left.pixel_x = src.pixel_x
							fence_bottom_left.pixel_y = 16
							fence_bottom_left.bounds = "-110,-32 to 6,-26"
							fence_bottom_left.density = 1
							fence_bottom_left.bolted = 2
							fence_bottom_left.density_factor = 2
							fence_bottom_left.layer = MOB_LAYER + src.laymod - ((src.y-1) + src.step_y / 32) / world.maxy
							animate(fence_bottom_left, pixel_y = -32 ,time = 2, easing = BOUNCE_EASING)
							sleep(2.1)
							var/obj/fence_bottom_right = new
							fence_bottom_right.icon = 'nuclear_plant.dmi'
							fence_bottom_right.icon_state = "br"
							fence_bottom_right.loc = src.loc
							fence_bottom_right.pixel_x = src.pixel_x
							fence_bottom_right.pixel_y = 16
							fence_bottom_right.bounds = "27,-32 to 142,-26"
							fence_bottom_right.density = 1
							fence_bottom_right.bolted = 2
							fence_bottom_right.density_factor = 2
							fence_bottom_right.layer = MOB_LAYER + src.laymod - ((src.y-1) + src.step_y / 32) / world.maxy
							animate(fence_bottom_right, pixel_y = -32 ,time = 2, easing = BOUNCE_EASING)
			Hydroelectric_Generator
				info_name = "Hydroelectric_Generator"
				icon = 'hydro.dmi'
				pixel_x = -104
				pixel_y = -16
				density_factor = 1
				bolted = 2
				bounds = "-72,-14 to 98,6"
				generator = 1;
				generates = 10000;
				hashadow = 0;
				value = 20000
				scale_x = 80;
				scale_y = 32;
				radius = 4;
				desc = "This technological structure is very important for the production of clean power. At day, it will produce energy at a modest rate and send it into the nearest available battery. Like many technlogical structures, it must remain over a power line to send power to a battery."
				tech_tree = "Engineering"
				Del()
					for(var/turf/trf in src.locs)
						for(var/obj/items/tech/Power_Line/p in trf)
							p.reconnect_power()
					..()
				New()
					..()
					tag = name
					category = list("Power Generation")
					var/image/sel = image('fx_large.dmi',src,"select item",5)
					src.img_select = sel
					src.desc_extra = "Power generated: [src.generates] \n\nGeneration conditions: None \n\nGenerates heat"
					spawn(10)
						if(src.loc != null)
							for(var/turf/trf in src.locs)
								for(var/obj/items/tech/Power_Line/p in trf)
									p.reconnect_power()
			Fusion_Generator
				info_name = "Fusion_Generator"
				icon = 'fusion.dmi'
				pixel_x = -32
				density_factor = 1
				//bolted = 2
				bounds = "-21,1 to 54,64"
				generator = 1;
				generates = 100000000000;
				hashadow = 0;
				value = 20000
				scale_x = 80;
				scale_y = 32;
				radius = 4;
				desc = "This technological structure is very important for the production of clean power. At day, it will produce energy at a modest rate and send it into the nearest available battery. Like many technlogical structures, it must remain over a power line to send power to a battery."
				tech_tree = "Engineering"
				Del()
					for(var/turf/trf in src.locs)
						for(var/obj/items/tech/Power_Line/p in trf)
							p.reconnect_power()
					..()
				New()
					..()
					tag = name
					category = list("Power Generation")
					var/image/sel = image('fx_large.dmi',src,"select item",5)
					src.img_select = sel
					src.desc_extra = "Power generated: [src.generates] \n\nGeneration conditions: None \n\nGenerates heat"
					spawn(10)
						if(src.loc != null)
							for(var/turf/trf in src.locs)
								for(var/obj/items/tech/Power_Line/p in trf)
									p.reconnect_power()
			Geothermal_Generator
				info_name = "Geothermal_Generator"
				icon = 'Geothermal.dmi'
				icon_state = "main"
				pixel_x = -140
				pixel_y = -32
				density_factor = 1
				bolted = 2
				bounds = "-105,-30 to 140,50"
				generator = 1;
				generates = 1000;
				hashadow = 0;
				value = 20000
				scale_x = 80;
				scale_y = 32;
				radius = 4;
				desc = "A Geothermal Generator is a marvel of modern engineering that harnesses the power of a planets internal heat to produce electricity. The generator utilizes a process called binary cycle geothermal power, where a heat exchanger transfers thermal energy from hot geothermal fluids to a secondary fluid that vaporizes and drives a turbine. This ingenious system allows the generator to operate day and night, providing a constant stream of clean and sustainable energy. With its ability to convert natural geothermal energy into electrical power, the Geothermal Generator is the future of sustainable energy and a testament to human ingenuity."
				tech_tree = "Physics"
				tech_subtech = "Geothermal Generators"
				Del()
					for(var/turf/trf in src.locs)
						for(var/obj/items/tech/Power_Line/p in trf)
							p.reconnect_power()
					..()
				/*
				Move()
					for(var/turf/trf in src.locs)
						for(var/obj/items/tech/Power_Line/p in trf)
							p.reconnect_power()
					..()
				*/
				New()
					..()
					tag = name
					category = list("Power Generation")
					var/image/sel = image('fx_large.dmi',src,"select item",5)
					src.img_select = sel
					src.desc_extra = "Power generated: [src.generates] \n\nGeneration conditions: None \n\nGenerates heat"

					var/obj/light = new
					light.icon = src.icon
					light.icon_state = "lights"
					light.filters += filter(type="drop_shadow", x=0, y=0,size=5, offset=2, color=rgb(200,0,0))
					light.layer = src.layer+5;
					light.bolted = 2
					src.vis_contents += light
					spawn(10)
						if(src.loc != null)
							var/obj/i = new
							i.icon = src.icon
							i.icon_state = "lights"
							i.layer = src.layer+10;
							i.bolted = 2
							i.alpha = 155
							animate(i, transform = matrix()*1.1,alpha = 0, time = 10, loop = -1)
							animate(transform = matrix()*1,alpha = 155,time = 0)
							src.vis_contents += i
							for(var/turf/trf in src.locs)
								for(var/obj/items/tech/Power_Line/p in trf)
									p.reconnect_power()
									break
						src.heat_field()
			Solar_Generator
				info_name = "Solar_Generator"
				icon = 'solar_power.dmi'
				icon_state = "base"
				pixel_x = -32
				density_factor = 1
				bounds = "-12,1 to 44,20"
				generator = 1;
				generates = 100;
				value = 2000
				desc = "This technological structure is very important for the production of clean power. At day, it will produce energy at a modest rate and send it into the nearest available battery. Like many technlogical structures, it must remain over a power line to send power to a battery."
				tech_tree = "Physics"
				tech_subtech = "Solar Generators"
				Del()
					for(var/turf/trf in src.locs)
						for(var/obj/items/tech/Power_Line/p in trf)
							p.reconnect_power()
					..()
				/*
				Move()
					for(var/turf/trf in src.locs)
						for(var/obj/items/tech/Power_Line/p in trf)
							p.reconnect_power()
					..()
				*/
				New()
					..()
					tag = name
					category = list("Power Generation")
					var/image/sel = image('fx_large.dmi',src,"select item",5)
					src.img_select = sel
					src.item_info = "<p>Generator</p> <p>Power Generated: [src.generates]"
					src.desc_extra = "Power generated: [src.generates] \n\nGeneration conditions: Daylight"
					spawn(10)
						if(src.loc != null)
							//src.power_pulse(src.x,src.y)
							for(var/turf/trf in src.locs)
								for(var/obj/items/tech/Power_Line/p in trf)
									p.reconnect_power()
			Robot_Factory
				info_name = "Robot_Factory"
				icon = 'tech_robot_factory.dmi'
				pixel_x = -32
				value = 2000
				density_factor = 1
				icon_state = "open"
				New()
					..()
					tag = name
					var/image/sel = image('fx_large.dmi',src,"select item",1000)
					src.img_select = sel
			Recycler
				info_name = "Recycler"
				icon = 'tech_recycler.dmi'
				value = 2000
				density_factor = 1
				pixel_x = -32
				value = 2000
				bounds = "-21,1 to 54,64"
				icon_state = "open"
				desc = "The recycler can be used to break down and destroy anything into raw resources, including other tech items, rocks, plants, even living beings.. To do so, drop anything over the top of it whilst the machine is powered."
				tech_tree = "Engineering"
				New()
					..()
					tag = name
					category = list("Recycling")
					var/image/sel = image('fx_large.dmi',src,"select item",1000)
					src.img_select = sel
					spawn(1)
						if(src.loc == null) return
						while(src)
							if(src.loc == null) return
							src.on = 0
							var/obj/stay_on = null
							for(var/obj/items/tech/Power_Line/p in range(1,src))
								if(bounds_dist(src, p) < 3)
									if(!src.grabbed_by) if(!src.tk)
										for(var/obj/x in p.batteries)
											if(x.capacity > 0)
												stay_on = x
												break
							if(stay_on)
								stay_on.capacity -= 1
								src.on = 1
							sleep(10)
			Black_Hole_Generator_Underlay
				info_name = "Black_Hole_Generator_Underlay"
				icon = 'black_hole_generator_under.dmi'
				icon_state = "underlay"
				density_factor = 0
				bolted = 1
				bounds = "-21,1 to 54,64"
			Black_Hole_Generator
				info_name = "Black_Hole_Generator"
				icon = 'black_hole_generator.dmi'
				icon_state = "off"
				pixel_x = -80
				pixel_y = -80
				value = 20000
				density_factor = 1
				appearance_flags = TILE_BOUND
				//plane = 5
				on = 0
				bolted = 1
				generator = 1;
				generates = 0;
				hashadow = 0
				bounds = "-40,-20 to 73,35"
				desc = "The drill, once connected to a power network, will begin to extract resources from deep underground. These resources are then disgarded near for collection. The drill ceases to function if too many digarded resources are near. Like many technlogical structures, it must remain over a power line to function."
				tech_tree = "Engineering"
				proc
					Activate()
						src.icon_state = "overlay"
						src.plane = 5
						src.density_factor = 0
						src.generates = 1000;
						src.underlays += /obj/items/tech/Black_Hole_Generator_Underlay

						animate(src,pixel_y = -78, time = 10, loop = -1)
						animate(pixel_y = -82,time = 10)

						var/obj/o = new
						o.loc = src.loc
						o.icon = 'blackhole.dmi'
						o.plane = 1
						o.bolted = 2
						o.pixel_x = -48;
						o.pixel_y = -48;
						o.bounds = "-48,-48 to 80,80"
						o.transform = matrix()*0.1
						animate(o, transform = matrix()*1, time = 10)
						src.loc.explosion(6)
						sleep(10)
						var/obj/items/environmental/blackhole/b = new
						b.density_factor = 1
						b.loc = src.loc
						src.shockwave_huge()
						qdel(o)
				Click()
					if(src.icon_state != "overlay") src.Activate()
				/*
				Move()
					for(var/turf/trf in src.locs)
						for(var/obj/items/tech/Power_Line/p in trf)
							p.reconnect_power()
					..()
				*/
				Del()
					for(var/turf/trf in src.locs)
						for(var/obj/items/tech/Power_Line/p in trf)
							p.reconnect_power()
					..()
				New()
					..()
					tag = name
					category = list("Resource Extraction")
					var/image/sel = image('fx_large.dmi',src,"select item",1000)
					src.img_select = sel
					src.desc_extra = "Power usage: [src.uses] \n\nProcess: Passive \n\nCan be toggled on or off"
					spawn(1)
						if(src.loc == null) return
						//mouse_opacity = 0;
						for(var/turf/trf in src.locs)
							for(var/obj/items/tech/Power_Line/p in trf)
								p.reconnect_power()
			Automated_Drill_Tower
				info_name = "Drilling_Machine"
				mouse_over_pointer = MOUSE_ACTIVE_POINTER
				icon = 'tech_drill.dmi'
				icon_state = "off"
				pixel_x = -32
				value = 2000
				density_factor = 1
				can_activate = 1
				p_x = -32
				on = 1
				on_always = 1
				uses = 50
				stacks = -1
				bounds = "-21,1 to 54,64"
				desc = "The drill, once connected to a power network, will begin to extract resources from deep underground. These resources are then stored inside the machine for collection. Like many technlogical structures, it must remain over a power line to function."
				tech_tree = "Engineering"
				tech_subtech = "Automated Drill Towers"
				tech_upgradable = 1
				tech_parent_path = /obj/items/tech/sub_tech/Engineering/Automated_Drill_Towers
				act = /obj/items/tech/Automated_Drill_Tower/proc/activate
				has_subtech = 0
				var/lvl = 1
				var/last_clicked = 0
				proc
					activate(var/obj/items/tech/Automated_Drill_Tower/d,var/area/a)
						spawn(0)
							if(d && a)
								var/powered = 0
								if(a.excess_grid >= 0 || a.stored_grid > 0) powered = 1
								if(powered == 0)
									if(d.last_clicked > 0)
										d.vis_contents -= industrial_smoke
										d.resources += (world.timeofday-d.last_clicked)*(1+d.tech_lvl)
										d.last_clicked = -1 //-1 means its not powered
								else
									d.vis_contents += industrial_smoke
									d.last_clicked = world.timeofday
				Move()
					if(src)
						if(src.grabbed_by == null && src.tk == 0)
							var/powered = 0;
							for(var/turf/trf in src.locs)
								for(var/obj/items/tech/Power_Line/p in trf)
									if(p.network)
										var/area/a = p.network
										if(a.excess_grid >= 0 || a.stored_grid > 0) powered = 1;
										break
							if(powered == 0)
								src.vis_contents -= industrial_smoke
							else
								src.vis_contents -= industrial_smoke
								src.vis_contents += industrial_smoke
						else
							src.vis_contents -= industrial_smoke
					..()
				Click(location,control,params)
					..()
					/*
					Idea here is to track the time between clicks.
					Issue atm is that when the drill is turned off, it needs to account for its down time. It would store the current seconds*tech_lvl in last_clicked and reset it to 0,
					before storing it inside resources var.
					Resources would be something like seconds*tech_lvl
					*/
					//world << "Time is [world.timeofday]. Last clicked at [src.last_clicked]. Seconds passed [world.timeofday-src.last_clicked]"
					if(src.last_clicked >= 0)
						if((world.timeofday-src.last_clicked)*(1+src.tech_lvl) > 0)
							usr.resources += (world.timeofday-src.last_clicked)*(1+src.tech_lvl)
							usr.update_rsc()
						src.last_clicked = world.timeofday
					if(src.grabbed_by) return
					if(src.loc)
						winset(usr,"map.map","focus=true")
						params = params2list(params)
						if(params["left"])
							if(usr.left_click_function == "upgrade drill")
								if(usr.hud_tech) usr.client.screen += usr.hud_tech
								if(src.loc)
									if(src in range(2,usr))
										usr.left_click_function = null
										for(var/obj/items/tech/sub_tech/Engineering/Automated_Drill_Towers/SE in global.tech)//usr.technology_researched)
											if(usr.tech_unlocked[SE.list_pos] == SE.type)
												if(usr.tech_lvls[SE.list_pos] > 0)
													src.level = usr.tech_lvls[SE.list_pos]
													usr << output("Upgraded Drill to level [src.level].", "chat.system")
													usr.set_alert("Upgraded drill",SE.icon,SE.icon_state)
												//	usr.create_chat_entry("alerts","Upgraded drill.")
													break
												else
													usr << output("Need at least one level in Automated Drill Towers.", "chat.system")
													usr.set_alert("Need Automated Drill Towers technology",'alert.dmi',"alert")
												//	usr.create_chat_entry("alerts","Need Automated Drill Towers technology.")
													return
										return
									else
										usr << output("[src] is out of range for upgrading.", "chat.system")
										usr.set_alert("Out of range",'alert.dmi',"alert")
										//usr.create_chat_entry("alerts","Out of range.")
										return
								else
									usr << output("[src] is out of range for upgrading.", "chat.system")
									usr.set_alert("Out of range",'alert.dmi',"alert")
									//usr.create_chat_entry("alerts","Out of range.")
									return

				New()
					..()
					tag = name
					category = list("Resource Extraction")
					var/image/sel = image('fx_large.dmi',src,"select item",1000)
					src.img_select = sel
					src.desc_extra = "Power usage: [src.uses] \n\nProcess: Passive \n\nCan be toggled on or off"
					if(src.loc == null) return
					for(var/turf/trf in src.locs)
						for(var/obj/items/tech/Power_Line/p in trf)
							p.reconnect_power()
							break
			Bio_Engineering_Tank
				info_name = "Bio_Engineering_Tank"
				mouse_over_pointer = MOUSE_ACTIVE_POINTER
				//appearance_flags = KEEP_TOGETHER
				icon = 'ReproductionTank.dmi'
				icon_state = ""
				value = 3000
				pixel_x = -31
				pixel_y = -14
				uses = 50;
				on = 1
				on_always = 1
				bounds = "-11,5 to 46,53"
				desc = "A specialized bio-engineering containment tank designed for the cultivation and manipulation of living organisms. By combining harvested genetic material with controlled growth conditions, the tank enables the creation of bio-androids and engineered lifeforms from raw biological data. Requiring continuous power and careful operation, it serves as a cornerstone of advanced genetic research and artificial life development."
				var/obj/glass
				var/obj/bubbles
				can_activate = 1
				tech_tree = "Genetics"
				tech_subtech = "Bioengineering Master"
				has_subtech=0
				tech_parent_path = /obj/items/tech/sub_tech/Genetics/Bioengineering_Master
				act = /obj/items/tech/Bio_Engineering_Tank/proc/activate

				tech_upgradable = 1
				proc
					activate(var/obj/items/tech/Bio_Engineering_Tank/d,var/area/a)
						spawn(0)
							if(d && a)
								var/stacked = 0
								for(var/obj/items/tech/Bio_Engineering_Tank/rm in range(1,d))
									if(rm != d)
										if(bounds_dist(d, rm) <= 0)
											stacked = 1
											break
								if(stacked == 0)
									var/powered = 0
									if(a.excess_grid >= 0 || a.stored_grid > 0) powered = 1
									if(powered == 0)
										d.icon_state = "off"
										d.layer = initial(src.layer)
										d.overlays -= d.bubbles
									else
										d.icon_state = "on"
										d.overlays -= d.bubbles
										d.overlays += d.bubbles
				New()
					..()
					tag = name
					category = list("Healing")
					src.glass = new /obj/effects/tech/regen_overlay
					src.bubbles = new /obj/effects/tech/bubbles
					src.overlays += src.glass
					var/image/sel = image('fx_large.dmi',src,"select item",1000)
					src.img_select = sel
					src.desc_extra = "Power usage: [src.uses] \n\nProcess: Activated \n\nCan be toggled on or off"
					spawn(10)
						if(src.loc == null) return
						for(var/turf/trf in src.locs)
							for(var/obj/items/tech/Power_Line/p in trf)
								p.reconnect_power()
								break
						//var/stay_on = 0;
						while(src)
							if(src.loc == null) return

							if(src.icon_state == "on")
								for(var/mob/m in range(1,src))
									if(bounds_dist(src, m) <= 8 && m.icon_state == "Meditate")
										if(m.skill_flight == null || m.skill_flight && m.skill_flight.active == 0)
											if(m.skill_levitation == null || m.skill_levitation && m.skill_levitation.active == 0)
												m.set_shadow()
												m.percent_health += 1+(src.level/4)
												src.overlays -= src.glass
												src.glass.layer = m.layer+1
												src.overlays += src.glass
												if(m.stunned || m.koed || m.meditating)
													m.loc = src.loc
													m.step_x = src.step_x//+(src.pixel_x/2)
													m.step_y = src.step_y+6
													m.layer = src.layer+0.1
													m.icon_state = "Meditate"
													break
												else
													src.layer = initial(src.layer)

							var/turf/t = src.loc
							if(t.tmp_dmg >= 2)
								src.flash_red()
								src.shake()
								src.hp -= 5
								if(src.hp <= 0) src.destroy()

							sleep(10)
				Del()
					for(var/turf/trf in src.locs)
						for(var/obj/items/tech/Power_Line/p in trf)
							p.reconnect_power()
							break
					..()
				Move()
					src.icon_state = "off"
					src.overlays -= src.bubbles
					..()
			Bio_Reproduction_Tank
				info_name = "Bio_Reproduction_Tank"
				mouse_over_pointer = MOUSE_ACTIVE_POINTER
				//appearance_flags = KEEP_TOGETHER
				icon = 'ReproductionTank.dmi'
				icon_state = ""
				value = 3000
				pixel_x = -31
				pixel_y = -14
				uses = 50;
				on = 1
				on_always = 1
				bounds = "-11,5 to 46,53"
				desc = "The regeneration tank is a state-of-the-art medical technology designed to rapidly heal the body and mind. By entering a meditative state inside the tank, you can activate its advanced healing capabilities, which vary depending on its level of technology. It requires a steady power source to operate, much like other technological structures."
				var/obj/glass
				var/obj/bubbles
				can_activate = 1
				tech_tree = "Genetics"
				tech_subtech = "Gene Mapping"
				has_subtech=0
				tech_parent_path = /obj/items/tech/sub_tech/Genetics/Gene_Mapping
				act = /obj/items/tech/Bio_Reproduction_Tank/proc/activate
				tech_upgradable = 1
				proc
					activate(var/obj/items/tech/Bio_Reproduction_Tank/d,var/area/a)
						spawn(0)
							if(d && a)
								var/stacked = 0
								for(var/obj/items/tech/Bio_Reproduction_Tank/rm in range(1,d))
									if(rm != d)
										if(bounds_dist(d, rm) <= 0)
											stacked = 1
											break
								if(stacked == 0)
									var/powered = 0
									if(a.excess_grid >= 0 || a.stored_grid > 0) powered = 1
									if(powered == 0)
										d.icon_state = "off"
										d.layer = initial(src.layer)
										d.overlays -= d.bubbles
									else
										d.icon_state = "on"
										d.overlays -= d.bubbles
										d.overlays += d.bubbles
				New()
					..()
					tag = name
					category = list("Healing")
					src.glass = new /obj/effects/tech/regen_overlay
					src.bubbles = new /obj/effects/tech/bubbles
					src.overlays += src.glass
					var/image/sel = image('fx_large.dmi',src,"select item",1000)
					src.img_select = sel
					src.desc_extra = "Power usage: [src.uses] \n\nProcess: Activated \n\nCan be toggled on or off"
					spawn(10)
						if(src.loc == null) return
						for(var/turf/trf in src.locs)
							for(var/obj/items/tech/Power_Line/p in trf)
								p.reconnect_power()
								break
						//var/stay_on = 0;
						while(src)
							if(src.loc == null) return

							if(src.icon_state == "on")
								for(var/mob/m in range(1,src))
									if(bounds_dist(src, m) <= 8 && m.icon_state == "Meditate")
										if(m.skill_flight == null || m.skill_flight && m.skill_flight.active == 0)
											if(m.skill_levitation == null || m.skill_levitation && m.skill_levitation.active == 0)
											//	m.set_shadow()
												m.percent_health += 1+(src.level/4)
												src.overlays -= src.glass
												src.glass.layer = m.layer+1
												src.overlays += src.glass
												if(m.stunned || m.koed || m.meditating)
													m.loc = src.loc
													m.step_x = src.step_x//+(src.pixel_x/2)
													m.step_y = src.step_y+6
													m.layer = src.layer+0.1
													m.icon_state = "Meditate"
													break
												else
													src.layer = initial(src.layer)

							var/turf/t = src.loc
							if(t.tmp_dmg >= 2)
								src.flash_red()
								src.shake()
								src.hp -= 5
								if(src.hp <= 0) src.destroy()

							sleep(10)
				Del()
					for(var/turf/trf in src.locs)
						for(var/obj/items/tech/Power_Line/p in trf)
							p.reconnect_power()
							break
					..()
				Move()
					src.icon_state = "off"
					src.overlays -= src.bubbles
					..()
			Bio_Rejuvination_Tank
				info_name = "Bio_Rejuvination_Tank"
				mouse_over_pointer = MOUSE_ACTIVE_POINTER
				//appearance_flags = KEEP_TOGETHER
				icon = 'item_fullrejuvtank.dmi'
				icon_state = ""
				value = 3000
				pixel_x = -31
				pixel_y = -14
				uses = 50;
				on = 1
				on_always = 1
				bounds = "-11,5 to 46,53"
				desc = "The regeneration tank is a state-of-the-art medical technology designed to rapidly heal the body and mind. By entering a meditative state inside the tank, you can activate its advanced healing capabilities, which vary depending on its level of technology. It requires a steady power source to operate, much like other technological structures."
				var/obj/glass
				var/obj/bubbles
				can_activate = 1
				tech_tree = "Genetics"
				tech_subtech = "Regenerators"
				tech_parent_path = /obj/items/tech/sub_tech/Genetics/Regenerators
				act = /obj/items/tech/Bio_Rejuvination_Tank/proc/activate
				tech_upgradable = 1
				proc
					activate(var/obj/items/tech/Bio_Rejuvination_Tank/d,var/area/a)
						spawn(0)
							if(d && a)
								var/stacked = 0
								for(var/obj/items/tech/Bio_Rejuvination_Tank/rm in range(1,d))
									if(rm != d)
										if(bounds_dist(d, rm) <= 0)
											stacked = 1
											break
								if(stacked == 0)
									var/powered = 0
									if(a.excess_grid >= 0 || a.stored_grid > 0) powered = 1
									if(powered == 0)
										d.icon_state = "off"
										d.layer = initial(src.layer)
										//d.overlays -= d.bubbles
									else
										d.icon_state = "on"
										//d.overlays -= d.bubbles
										//d.overlays += d.bubbles
				New()
					..()
					tag = name
					category = list("Healing")
				//	src.glass = new /obj/effects/tech/regen_overlay
				//	src.bubbles = new /obj/effects/tech/bubbles
					//src.overlays += src.glass
					var/image/sel = image('fx_large.dmi',src,"select item",1000)
					src.img_select = sel
					src.desc_extra = "Power usage: [src.uses] \n\nProcess: Activated \n\nCan be toggled on or off"
					spawn(10)
						if(src.loc == null) return
						for(var/turf/trf in src.locs)
							for(var/obj/items/tech/Power_Line/p in trf)
								p.reconnect_power()
								break
						//var/stay_on = 0;
						while(src)
							if(src.loc == null)
								sleep(10)
								return

							if(src.icon_state == "on")
								for(var/mob/m in range(1,src))
									if(bounds_dist(src, m) <= 8 && m.icon_state == "Meditate")
										if(m.skill_flight == null || m.skill_flight && m.skill_flight.active == 0)
											if(m.skill_levitation == null || m.skill_levitation && m.skill_levitation.active == 0)
											//	m.set_shadow()
												m.percent_health += 1+(src.level/4)
												src.overlays -= src.glass
												src.glass.layer = m.layer+1
												src.overlays += src.glass
												if(m.stunned || m.koed || m.meditating)
													m.loc = src.loc
													m.step_x = src.step_x//+(src.pixel_x/2)
													m.step_y = src.step_y+6
													m.layer = src.layer+0.1
													m.icon_state = "Meditate"
													break
												else
													src.layer = initial(src.layer)

							var/turf/t = src.loc
							if(t.tmp_dmg >= 2)
								src.flash_red()
								src.shake()
								src.hp -= 5
								if(src.hp <= 0) src.destroy()

							sleep(10)
				Del()
					for(var/turf/trf in src.locs)
						for(var/obj/items/tech/Power_Line/p in trf)
							p.reconnect_power()
							break
					..()
				Move()
					src.icon_state = "off"
					src.overlays -= src.bubbles
					..()
				/*
				Click(location,control,params)
					if(src.grabbed_by) return
					if(src.loc)
						winset(usr,"map.map","focus=true")
						params = params2list(params)
						if(params["left"])
							if(src in range(1,usr))
								if(src.on == 0)
									var/power_on = 0
									for(var/turf/trf in src.locs)
										if(power_grid[trf.x][trf.y][trf.z] == 1)
											if(excess_grid[trf.x][trf.y][trf.z] >= 0 || stored_grid[trf.x][trf.y][trf.z] > 0) power_on = 1;
									if(power_on)
										src.on = 1
										src.icon_state = "on"
										src.overlays += src.bubbles
										for(var/turf/trf in src.locs)
											for(var/obj/items/tech/Power_Line/p in trf)
												p.reconnect_power()
								else
									src.on = 0
									src.icon_state = "off"
									src.layer = initial(src.layer)
									src.overlays -= src.bubbles
									for(var/turf/trf in src.locs)
										for(var/obj/items/tech/Power_Line/p in trf)
											p.reconnect_power()
							return
					..()
				*/
			Microwave_Generator
				info_name = "Microwave_Generator"
				mouse_over_pointer = MOUSE_ACTIVE_POINTER
				icon = 'glass_orb.dmi'
				icon_state = "whole"
				value = 1000
				pixel_x = -31
				density_factor = 1
				radius = 1;
				hashadow = 0
				setting = 0
				has_subtech=0
				uses = 100 //How much power needed to run this tech
				bounds = "-25,1 to 60,75"
				desc = "A Microwave Generator is a powerful and hazardous machine that emits intense electromagnetic radiation, which is precisely tuned to stimulate and train your character's energy-based abilities. The Generator works by subjecting your character to a controlled stream of high-frequency waves, which are able to penetrate deeply into their physical and spiritual body, enhancing their ability to harness and control energy. As your character undergoes this rigorous training, their resistance to energy-based attacks increases, and their own energy-based attacks become more potent and destructive. But be warned, the intense radiation emitted by the Microwave Generator can be harmful to those unprepared for its power"
				can_activate = 1
				tech_tree = "Physics"
				tech_subtech = "Thermodynamics"
				tech_upgradable = 1
				act = /obj/items/tech/Microwave_Generator/proc/turn_off
				tech_parent_path = /obj/items/tech/sub_tech/Physics/Thermodynamics
				var/obj/back
				var/obj/orb
				var/obj/elec
				var/obj/pulse
				var/obj/outline
				var/tmp/list/trfs = list()
				proc
					turn_off(var/obj/items/tech/Microwave_Generator/d)
						d.icon_state = "whole"
						d.setting = 0
						d.on = 0;
						d.vis_contents -= d.back
						d.vis_contents -= d.orb
						d.vis_contents -= d.elec
						d.vis_contents -= d.pulse
						d.vis_contents -= d.outline
						for(var/turf/t in d.trfs)
							t.microwaves = initial(t.og_microwaves)
							for(var/mob/m in t)
								m.microwaves = t.microwaves
							d.trfs -= t
				New()
					..()
					spawn(1)
						if(src.loc == null)
							return
						var/obj/back = new
						back.icon = src.icon
						back.icon_state = "back"
						back.layer = 3.2
						//g.vis_contents += back
						src.back = back

						var/obj/elec = new
						elec.icon = 'orb_elec.dmi'
						elec.icon_state = "elec"
						elec.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(0,160,230))
						elec.filters += filter(type="bloom", threshold=rgb(0,0,0), size = 6,offset=1,alpha = 175)
						elec.layer = 10
						elec.pixel_x = -16
						elec.pixel_y = -4
						elec.appearance_flags = KEEP_APART
						src.elec = elec
						//g.vis_contents += elec

						var/obj/o = new
						o.icon = src.icon
						o.icon_state = "overlay"
						o.layer = src.layer+1
						o.appearance_flags = KEEP_TOGETHER
						src.orb = o
						//g.vis_contents += o

						var/obj/outline = new
						outline.icon = src.icon
						outline.icon_state = "outline"
						outline.filters += filter(type="drop_shadow", x=0, y=0, size=1, offset=1, color=rgb(0,160,230))
						animate(outline.filters[1], size = 2,offset = 2, time = 15, loop = -1)
						animate(size = 0,offset = 0, time = 15, loop = -1)
						outline.layer = 9
						src.outline = outline
						//g.vis_contents += outline

						var/obj/pulse = new
						pulse.icon = 'orb_pulsate.dmi'
						pulse.pixel_x = -41
						pulse.appearance_flags = PIXEL_SCALE
						pulse.filters += filter(type="drop_shadow", x=0, y=0, size=1, offset=1, color=rgb(0,160,230))
						//g.vis_contents += pulse
						src.pulse = pulse
						pulse.transform *= 0.8
						animate(pulse, transform = matrix()*2, alpha = 0, time = 20,loop = -1)//,flags = ANIMATION_PARALLEL)
						animate(transform = matrix()*0.8, alpha = 255, time = 0)

						tag = name
						category = list("Artifical Training")
						var/image/sel = image('fx_large.dmi',src,"select item",1000)
						src.img_select = sel
						src.desc_extra = "Power usage: [src.uses] \n\nProcess: Activated \n\nCan be toggled on or off"
						//var/stay_on = 0;
						while(src)
							if(src.loc == null)
								return
							if(src.icon_state == "front")
								for(var/obj/items/tech/Bio_Rejuvination_Tank/tnk in range(2,src))
									tnk.flash_red()
									tnk.shake()
									tnk.hp -= 5
									if(tnk.hp <= 0) tnk.destroy()
							sleep(10)
				Del()
					for(var/turf/trf in src.locs)
						for(var/obj/items/tech/Power_Line/p in trf)
							p.reconnect_power()
					..()
				Move()
					if(src.icon_state == "front")
						var/stay_on = 0;
						for(var/turf/trf in src.locs)
							for(var/obj/items/tech/Power_Line/p in trf)
								if(p.network)
									var/area/a = p.network
									if(a.excess_grid >= 0 || a.stored_grid > 0) stay_on = 1;
									break
						if(src.grabbed_by || src.tk) stay_on = 0;
						if(stay_on == 0)
							src.icon_state = "whole"
							src.setting = 0
							src.on = 0;
							src.vis_contents -= src.back
							src.vis_contents -= src.orb
							src.vis_contents -= src.elec
							src.vis_contents -= src.pulse
							src.vis_contents -= src.outline
							for(var/turf/t in src.trfs)
								t.microwaves = initial(t.og_microwaves)
								for(var/mob/m in t)
									m.microwaves = t.microwaves
								src.trfs -= t
					..()
				Click(location,control,params)
					..()
					//usr << "test"
					if(src.grabbed_by) return
					if(src.loc)
						winset(usr,"map.map","focus=true")
						params = params2list(params)
						if(params["left"])
							if(src in range(2,usr))
								//world << "DEBUG - Clicked [src]"
								if(src.setting == 0)
									//world << "DEBUG - Setting = [src.setting]"
									var/power_on = 0
									for(var/turf/trf in src.locs)
										for(var/obj/items/tech/Power_Line/p in trf)
											if(p.network)
												var/area/a = p.network
												if(a.excess_grid >= 0 || a.stored_grid > 0) power_on = 1;
												break
									if(power_on == 1)
										for(var/obj/items/tech/Microwave_Generator/g in range(4,src))
											if(g != src)
												usr << "Unable to activate two microwave generators so near to one another."
												usr.set_alert("Too close to another generator",'alert.dmi',"alert")
											//	usr.create_chat_entry("alerts","Too close to another generator.")
												return
										//winset(usr,"numbers.label_numbers","text=\"Set microwave level of this machine.\"")
										//winset(usr,"numbers","pos=960,400")
										//winshow(usr,"numbers",1)
										usr.numbers_text = src
										//winset(usr,"numbers.input_number","focus=true")
										usr.hud_confirm_nums.confirm_text(1,"Set microwave level of this machine.",usr)
								else
									src.icon_state = "whole"
									src.setting = 0
									src.on = 0;
									src.vis_contents -= src.back
									src.vis_contents -= src.orb
									src.vis_contents -= src.elec
									src.vis_contents -= src.pulse
									src.vis_contents -= src.outline
									for(var/turf/t in src.trfs)
										t.microwaves = initial(t.og_microwaves)
										for(var/mob/m in t)
											m.microwaves = t.microwaves
										src.trfs -= t
									for(var/turf/trf in src.locs)
										for(var/obj/items/tech/Power_Line/p in trf)
											p.reconnect_power()
							return
			Gravity_Machine
				info_name = "Gravity_Machine"
				mouse_over_pointer = MOUSE_ACTIVE_POINTER
				icon = 'tech_gravity.dmi'
				icon_state = "off"
				value = 1000
				pixel_x = -31
				density_factor = 1
				radius = 2;
				setting = 0
				has_subtech=0
				uses = 100 //How much power needed to run this tech
				bounds = "-5,1 to 38,17"
				desc = "This device is very advanced and complex, producing a field of graviy waves that pulsate out in rhythmic paces. By clicking it, you are able to set the desired level of gravity within the confines of its radius. Once inside the field, you will become much stronger and more endurant over time, depending on the gravity setting. Whilst active, the gravity will slowly harm you. Like many technlogical structures, it must remain over a power line to function."
				can_activate = 1
				tech_tree = "Physics"
				tech_subtech = "Gravitational Fields"
				tech_parent_path = /obj/items/tech/sub_tech/Physics/Gravitational_Fields
				act = /obj/items/tech/Gravity_Machine/proc/turn_off
				tech_upgradable = 1
				var/obj/field
				var/tmp/list/trfs = list()
				proc
					turn_off(var/obj/items/tech/Gravity_Machine/d)
						if(d)
							d.icon_state = "off"
							d.setting = 0
							d.on = 0;
							if(d.field) d.field.loc = null
							for(var/turf/t in d.trfs)
								t.grav = initial(t.og_grav)
								for(var/mob/m in t)
									m.grav = t.grav
								d.trfs -= t
					/*
					---TEMPLATE---
					activate(var/obj/items/tech/Gravity_Machine/d,var/area/a)
						spawn(0)
							if(d && a)
								var/powered = 0
								if(a.excess_grid >= 0 || a.stored_grid > 0) powered = 1
								if(powered == 0)
									//Not powered
									return
								else
									//Powered
									return
					*/
				New()
					..()
					tag = name
					category = list("Artifical Training")
					var/image/sel = image('fx_large.dmi',src,"select item",1000)
					src.img_select = sel
					src.desc_extra = "Power usage: [src.uses] \n\nProcess: Activated \n\nCan be toggled on or off"
					spawn(1)
						if(src.loc == null)
							if(src.field) src.field.loc = null
							return
						while(src)
							if(src.loc == null)
								if(src.field) src.field.loc = null
								return
							if(src.icon_state == "on")
								for(var/obj/items/tech/Bio_Rejuvination_Tank/tnk in range(2,src))
									tnk.flash_red()
									tnk.shake()
									tnk.hp -= 5
									if(tnk.hp <= 0) tnk.destroy()
							sleep(10)
				Del()
					for(var/turf/trf in src.locs)
						for(var/obj/items/tech/Power_Line/p in trf)
							p.reconnect_power()
					..()
				Move()
					if(src.icon_state == "on")
						var/stay_on = 0;
						for(var/turf/trf in src.locs)
							for(var/obj/items/tech/Power_Line/p in trf)
								if(p.network)
									var/area/a = p.network
									if(a.excess_grid >= 0 || a.stored_grid > 0) stay_on = 1;
									break
						if(src.grabbed_by || src.tk) stay_on = 0;
						if(stay_on == 0)
							src.icon_state = "off"
							src.setting = 0
							src.on = 0;
							if(src.field) src.field.loc = null
							for(var/turf/t in src.trfs)
								t.grav = initial(t.og_grav)
								for(var/mob/m in t)
									m.grav = t.grav
								src.trfs -= t
					..()
				Click(location,control,params)
					..()
					//usr << "test"
					if(src.grabbed_by) return
					if(src.loc)
						winset(usr,"map.map","focus=true")
						params = params2list(params)
						if(params["left"])
							if(src in range(1,usr))
								if(src.setting == 0)
									var/power_on = 0
									for(var/turf/trf in src.locs)
										for(var/obj/items/tech/Power_Line/p in trf)
											if(p.network)
												var/area/a = p.network
												if(a.excess_grid >= 0 || a.stored_grid > 0) power_on = 1;
												break
									if(power_on == 1)
										for(var/obj/items/tech/Gravity_Machine/g in range(4,src))
											if(g != src)
												usr << "Unable to activate two gravity machines so near to one another."
												usr.set_alert("Too close to another Gravity Machine",'alert.dmi',"alert")
											//	usr.create_chat_entry("alerts","Too close to another Gravity Machine.")
												return
										usr.numbers_text = src
										usr.hud_confirm_nums.confirm_text(1,"Set the gravity level of this machine.",usr)
										winset(usr,"numbers.label_numbers","text=\"Set gravity level of this machine.\"")
										winset(usr,"numbers","pos=960,400")
										winshow(usr,"numbers",1)
										winset(usr,"numbers.input_number","focus=true")
										for(var/turf/trf in src.locs)
											for(var/obj/items/tech/Power_Line/p in trf)
												p.reconnect_power()
								else
									src.icon_state = "off"
									src.setting = 0
									src.on = 0;
									if(src.field) src.field.loc = null
									for(var/turf/t in src.trfs)
										t.grav = initial(t.og_grav)
										for(var/mob/m in t)
											m.grav = t.grav
										src.trfs -= t
							return
	tails
		layer = HAIR_LAYER
		density_factor = 0
		appearance_flags = KEEP_TOGETHER
		saiyan
			brown_tail
				icon = 'SaiyanTailBrown.dmi'
			black_tail
				icon = 'SaiyanTailBlack.dmi'
	horns
		layer = HAIR_LAYER
		density_factor = 0
		appearance_flags = KEEP_TOGETHER
		oni
			oni_horns1
				icon='OniHorns.dmi'
			oni_horns1_kid
				icon='oni_horns_kid.dmi'
		demon
			horns1_demon
				icon='demon_horns.dmi'
			horns2_demon
				icon='Demonic Horns.dmi'
			horns2_demon_kid
				icon ='demonic_horns_kid.dmi'
		/*yuk
			yuk_horns1
				icon = 'horns_yukopian_01.dmi'
			yuk_horns2
				icon = 'horns_yukopian_02.dmi'
			yuk_horns3
				icon = 'horns_yukopian_03.dmi'
			yuk_horns4
				icon = 'horns_yukopian_04.dmi'
			yuk_none*/
	portrait
		var/tmp/mob/p_owner
		var/obj/portrait/port_eyes
		var/obj/portrait/port_iris
		var/state_og
		appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
		plane = 25
		babybody

			layer = 5
			screen_loc = "1:1,16:13"

		body
			//appearance_flags = PIXEL_SCALE
			layer = 5
			screen_loc = "1:1,16:13"
		eyes
			//appearance_flags = PIXEL_SCALE
			layer = 5.1
			plane = 25
			New()
				spawn(120)
					if(src)
						if(src.state_og == null && src.icon) src.state_og = src.icon_state
						if(src.p_owner == null) return
						else if(src.p_owner.race == "Alien") return
						else src.blink(src.p_owner)
			proc/blink(var/mob/m)
				var/obj/portrait/p
				if(isobj(src.loc)) p = src.loc
				if(src.state_og == null && src.icon) src.state_og = src.icon_state
				if(src.p_owner && p)
					var/proceed = 1
					if(m.skill_active_meditation && m.skill_active_meditation.active) proceed = 0
					if(m.skill_meditation && m.skill_meditation.active) proceed = 0
					if(proceed)
						src.icon_state = "[src.state_og] blink"
						if(p.port_iris) p.vis_contents -= p.port_iris
						if(src.p_owner.eyes)
							src.p_owner.vis_contents -= src.p_owner.eyes
						if(src.p_owner.eyes_white)
							src.p_owner.vis_contents -= src.p_owner.eyes_white
				else
					src.destroy()
					return
				sleep(1.5)
				if(src)
					if(src.p_owner && p)
						var/proceed = 1
						if(m.skill_active_meditation && m.skill_active_meditation.active) proceed = 0
						if(m.skill_meditation && m.skill_meditation.active) proceed = 0
						if(proceed)
							src.icon_state = "[src.state_og]"
							if(p.port_iris) p.vis_contents += p.port_iris
							if(src.p_owner.eyes_white)
								src.p_owner.vis_contents += src.p_owner.eyes_white
							if(src.p_owner.eyes)
								src.p_owner.vis_contents += src.p_owner.eyes
					else
						src.destroy()
						return
					spawn(rand(40,70))
						if(src) src.blink(m)
		portrait_scouter
			layer=6
			plane=25
			icon = 'portrait_scouter.dmi'
			icon_state = "default"
			screen_loc = "1:1,16:13"
		portrait_scouter_base
			layer=6
			plane=25
			icon = 'portrait_scouter.dmi'
			icon_state = "base"
			screen_loc = "1:1,16:13"
			var/obj/items/tech/Scouters/ScouterBase

			Click(location,control,params)
				..()
				var/mob/m = usr
				if(m.koed) return
				params = params2list(params)
				winset(m,"map.map","focus=true")
				var/dir = null
				if(params["left"] || m.mouse_dir == "left")
					dir = "left"
				if(params["right"])
					dir = "right"
				if(dir == "left")
					switch(input(usr,"Select a function") in list ("Set Frequency", "Crush Scouter"))
						if("Set Frequency")
							ScouterBase.Channel=input("Choose a number for your frequency, can be any number.") as num
							usr<<"Your Scouter's frequency was set to [ScouterBase.Channel]."

						if("Crush Scouter")
							switch(alert(usr,"Are you sure you want to crush your scouter?","","Yes","No"))
								if("Yes")
									view(15,usr)<<sound('scoutercrush.ogg',volume=30)
									for(var/mob/player/P in view(20,usr))
										if(!P.npc)
											view(20,P) <<output( "<font color=red>[P.get_strangername(usr)] crushes their Scouter!","actionoutput")
									usr.overlays.Remove(ScouterBase.icon)
									ScouterBase.suffix=null
									usr.scoutercrushes++
									del(ScouterBase)
								if("No")
									return

		portrait_scouter_lens
			layer=6
			plane=25
			icon='portrait_scouter.dmi'
			icon_state="lens"
			var/obj/items/tech/Scouters/ScouterLens = null

			Click(location,control,params)
				..()
				var/mob/m = usr
				if(m.koed) return
				params = params2list(params)
				winset(m,"map.map","focus=true")
				var/dir = null
				if(params["left"] || m.mouse_dir == "left")
					dir = "left"
				if(params["right"])
					dir = "right"
				if(dir == "left")
					if(m.AllowedScan==1)
						var/list/nearby_players = list()
						for(var/mob/M in view(25,m))
							nearby_players += M
						var/mob/choice = input("Select a target to scan:") as null|obj|mob in nearby_players
						if(choice)
							for(var/obj/items/tech/Scouters/s in m)
								if(s.suffix == "worn")

									m.ScouterScan(choice,s)
									m.AllowedScan=1
				else if(dir == "right")

					if(m.AllowedScan==1)
					//	var/PlanetScan
						view(12,m) << sound('scouter.ogg',volume=30)
						m<<output("<font color=green>----------\nScanning Planet...\n","actionoutput")
						sleep(1)
						view(12,m) <<sound('scouterbeeps.ogg',volume=30)
						sleep(20)
						for(var/mob/P)
							if(P.z == m.z && !P.npc && P.psionic_power >0)
								if(!P.koed||P.icon_state!="KO")
									if(P.psionic_power >= 100000000)
										P.RecentScan = round(P.psionic_power / 1000000) * 1000000

									else
										if(P.psionic_power >= 10000000)
											P.RecentScan = round(P.psionic_power / 100000) * 100000

										else
											if(P.psionic_power >= 1000000)
												P.RecentScan = round(P.psionic_power / 10000) * 10000
											else
												if(P.psionic_power >= 100000)
													P.RecentScan = round(P.psionic_power / 1000) * 1000
												else
													if(P.psionic_power >=1000)
														P.RecentScan = round(P.psionic_power / 100) * 100
													else
														if(P.psionic_power >=100)
															P.RecentScan = round(P.psionic_power / 10) * 10
														else
															P.RecentScan = round(P.psionic_power)

							if(P.psionic_power>0)
								if(P.z==m.z)
									var/list/Powers=new
									Powers += P.RecentScan
									var/Power_Window=""
									for(var/E in Powers)
										var/Lowest_Power=min(Powers)
										if(Lowest_Power==P.RecentScan)
											if(P in Power_Window) continue
											var/directional = "[dir2text(get_dir(m.loc,P.loc))]"
											if(directional == "" || directional == null)
												directional = "CENTER"
											var/text = add_tspace("([directional]) - [m.get_strangername(P)]",10)
											text += " [Commas(min(Powers))]<br>"
											Power_Window += text
										Powers-=min(Powers)
									m << output("[Power_Window]","actionoutput")

									//PlanetScan+="<font color=green>([dir2text(get_dir(usr.loc,P.loc))]) - [usr.getStrangerName(P)]  -  [round(P.BP)]\n"

						m<<output("<font color=green>\nScanning Complete!\n----------","actionoutput")
						view(12,m) << sound('scouterend.ogg',volume=30)
		portrait_beard_moustache
			layer=8
			plane=25
			icon='portrait_beard_moustache.dmi'
		portrait_beard_goatee
			layer=8
			plane=25
			icon='portrait_beard_goatee.dmi'
		portrait_beard_chinstrap
			layer=8
			plane=25
			icon='portrait_beard_chinstrap.dmi'
		portrait_beard_short
			layer=8
			plane=25
			icon='portrait_beard_short.dmi'
		portrait_beard_full
			layer=8
			plane=25
			icon='portrait_beard_full.dmi'
		portrait_beard_big
			layer=8
			plane=25
			icon='portrait_beard_big.dmi'
		portrait_part
			//appearance_flags = PIXEL_SCALE
			layer = 5.1
			plane = 25
		border
			icon = 'portrait_human_male.dmi'
			icon_state = "border"
			plane = 25
			layer = 5.2
			//appearance_flags = PIXEL_SCALE
		background
			icon = 'portrait_human_male.dmi'
			icon_state = "background"
			plane = 25
			layer = 4.9
			//appearance_flags = PIXEL_SCALE
		kai
			female
				icon = 'portrait_celestial_female.dmi'
				eyes
					portrait_female_kai_eyes1
						icon_state = "eyes1"
					portrait_female_kai_eyes2
						icon_state = "eyes2"
					portrait_female_kai_eyes3
						icon_state = "eyes3"
			male
				icon = 'portrait_celestial_male.dmi'
				eyes
					portrait_male_kai_eyes1
						icon_state = "eyes1"
					portrait_male_kai_eyes2
						icon_state = "eyes2"
					portrait_male_kai_eyes3
						icon_state = "eyes3"
		demon
			icon = 'portrait_demon_female.dmi'
			female
				icon = 'portrait_demon_female.dmi'
				eyes
					portrait_female_demon_eyes1
						icon_state = "eyes1"
					portrait_female_demon_eyes2
						icon_state = "eyes2"
					portrait_female_demon_eyes3
						icon_state = "eyes3"
			male
				icon = 'portrait_demon_male.dmi'
				eyes
					portrait_male_demon_eyes1
						icon_state = "eyes1"
					portrait_male_demon_eyes2
						icon_state = "eyes2"
					portrait_male_demon_eyes3
						icon_state = "eyes3"
			horns
				horns1_demonic
					icon_state = "horns1"
				horns2_demonic
					icon_state = "horns2"
		android
			male
				icon = 'portrait_android_male.dmi'
				eyes
					android_male_eyes1
						icon_state = "eyes1"
					android_male_eyes2
						icon_state = "eyes2"
			female
				icon = 'portrait_android_male.dmi'
				eyes
					android_female_eyes1
						icon_state = "eyes1"
					android_female_eyes2
						icon_state = "eyes2"
					android_female_eyes3
						icon_state = "eyes3"
		alien
			icon = 'portrait_cerebroid.dmi'
			eyes
				portrait_cerebroid_eyes1
					icon_state = "eyes1"
		spiritdoll
			male
				icon = 'portrait_spiritdoll.dmi'
				eyes
					portrait_spiritdoll_eyes1
						icon_state = "eyes1"
					portrait_spiritdoll_eyes2
						icon_state = "eyes2"

			female
				icon = 'portrait_spiritdoll.dmi'
				eyes
					portrait_spiritdoll_eyes1
						icon_state = "eyes1"
					portrait_spiritdoll_eyes2
						icon_state = "eyes2"
					portrait_spiritdoll_eyes3
						icon_state = "eyes3"

		makyo
			icon = 'portrait_makyo.dmi'
			eyes
				portrait_makyo_eyes1
					icon_state = "eyes1"
				portrait_makyo_eyes2
					icon_state = "eyes2"


		oni
			icon = 'portrait_oni.dmi'
			eyes
				portrait_oni_eyes1
					icon_state ="eyes1"
				portrait_oni_eyes2
					icon_state = "eyes2"

			horns
				horns1_oni
					icon_state = "horns1"

		changeling
			icon = 'portrait_changeling.dmi'
			eyes
				portrait_changeling_eyes1
					icon_state="eyes1"

		yukopian
			icon = 'portrait_Namekian.dmi'
			eyes
				portrait_yuk_eyes1
					icon_state = "eyes1"
				portrait_yuk_eyes2
					icon_state = "eyes2"
			/*horns
				horns1_yuk
					icon_state = "horns1"
				horns2_yuk
					icon_state = "horns2"
				horns3_yuk
					icon_state = "horns3"
				horns4_yuk
					icon_state = "horns4"*/

		male
			icon = 'portrait_human_male.dmi'
			mouths
				portrait_mouth1_male
					icon_state = "mouth1"
				portrait_mouth2_male
					icon_state = "mouth2"
				portrait_mouth3_male
					icon_state = "mouth3"
				portrait_mouth4_male
					icon_state = "mouth4"
			eyes
				portrait_eyes1_male
					icon_state = "eyes1"
				portrait_eyes2_male
					icon_state = "eyes2"
			noses
				portrait_nose1_male
					icon_state = "nose1"
				portrait_nose2_male
					icon_state = "nose2"
				portrait_nose3_male
					icon_state = "nose3"
			hairs
				portrait_Hair1_male
					icon_state = "hair1"
				portrait_Hair2_male
					icon_state = "hair2"
				portrait_Hair3_male
					icon_state = "hair3"
				portrait_Hair4_male
					icon_state = "hair4"
				portrait_Hair5_male
					icon_state = "hair5"
				portrait_Hair6_male
					icon_state = "hair6"
				portrait_Hair7_male
					icon_state = "hair7"
				portrait_Hair8_male
					icon_state = "hair8"
				portrait_Hair9_male
					icon_state = "hair9"
				portrait_Hair10_male
					icon_state = "hair10"
				portrait_Hair11_male
					icon_state = "hair11"
				portrait_Hair22_male
					icon_state = "hair22"
				portrait_Hair24_male
					icon_state = "hair24"
				portrait_Hair25_male
					icon_state = "hair25"
				portrait_Hair26_male
					icon = 'portrait_human_female.dmi'
					icon_state = "hair3"
				portrait_Hair27_male
					icon = 'portrait_human_male.dmi'
					icon_state = "hair27"
		female
			icon = 'portrait_human_female.dmi'
			mouths
				portrait_mouth1_female
					icon_state = "mouth1"
				portrait_mouth2_female
					icon_state = "mouth2"
				portrait_mouth3_female
					icon_state = "mouth3"
				portrait_mouth4_female
					icon_state = "mouth4"
				portrait_mouth5_female
					icon_state = "mouth5"
			eyes
				portrait_eyes1_female
					icon_state = "eyes1"
				portrait_eyes2_female
					icon_state = "eyes2"
				portrait_eyes3_female
					icon_state = "eyes3"
			noses
				portrait_nose1_female
					icon_state = "nose1"
				portrait_nose2_female
					icon_state = "nose2"
				portrait_nose3_female
					icon_state = "nose3"
			hairs
				portrait_Hair1_female
					icon_state = "hair1"
				portrait_Hair2_female
					icon_state = "hair2"
				portrait_Hair3_female
					icon_state = "hair3"
				portrait_Hair4_female
					icon_state = "hair4"
				portrait_Hair5_female
					icon_state = "hair5"
				portrait_Hair6_female
					icon_state = "hair6"
				portrait_Hair7_female
					icon_state = "hair7"
				portrait_Hair8_female
					icon_state = "hair8"
				portrait_Hair9_female
					icon_state = "hair9"
	hairs
		layer = HAIR_LAYER
		density_factor = 0
		//appearance_flags = KEEP_TOGETHER
		female
			Hair1_female
				icon = 'Kale_Hair.dmi'
				name = "Hair1"
			Hair2_female
				icon = 'hair_female2.dmi'
				name = "Hair2"
			Hair3_female
				icon = 'hair_female1.dmi'
				name = "Hair3"
			Hair4_female
				icon = 'hair_04_female.dmi'
				name = "Hair4"
			Hair5_female
				icon = 'hair_long.dmi'
				name = "Hair5"
			Hair6_female
				icon = 'hair_06_female.dmi'
				name = "Hair6"
			Hair7_female
				icon = 'hair_07_female.dmi'
				name = "Hair7"
			Hair8_female
				icon = 'hair_08_female.dmi'
				name = "Hair8"
			Hair9_female
				icon = 'NewCauliflaHair.dmi'
				name ="Hair9"
			Hair10_female
				icon = 'Android17h.dmi'
				name ="Hair10"

			Hair11_female
				icon = 'Android_18.dmi'
				name ="Hair11"
		female_kid
			Hair1_female_kid
				icon = 'Kale_Hair_kid.dmi'
				name = "Hair1"
			Hair2_female_kid
				icon = 'hair_female2_kid.dmi'
				name = "Hair2"
			Hair3_female_kid
				icon = 'hair_female1_kid.dmi'
				name = "Hair3"
			Hair4_female_kid
				icon = 'hair_04_female.dmi'
				name = "Hair4"
			Hair5_female_kid
				icon = 'hair_long.dmi'
				name = "Hair5"
			Hair6_female_kid
				icon = 'hair_06_female.dmi'
				name = "Hair6"
			Hair7_female_kid
				icon = 'hair_07_female.dmi'
				name = "Hair7"
			Hair8_female_kid
				icon = 'hair_08_female.dmi'
				name = "Hair8"
			Hair9_female_kid
				icon = 'NewCauliflaHairKid.dmi'
				name ="Hair9"
			Hair10_female_kid
				icon = 'Android17hKid.dmi'
				name ="Hair10"
			Hair11_female_kid
				icon = 'Android_18_kid.dmi'
				name ="Hair11"
		male

			Hair1
				icon = 'GokuRHair.dmi'
			Hair2
				icon = 'hair_vegeta.dmi'
			Hair3
				icon = 'hair_yamcha.dmi'
			Hair4
				icon = 'UubHair.dmi'
			Hair5
				icon = 'hair_long.dmi'
			Hair6
				icon = 'hair_afro.dmi'
			Hair7
				icon = 'hair_kidd.dmi'
			Hair8
				icon = 'hair_raditz.dmi'
			Hair9
				icon = 'hair_muse.dmi'
			Hair10
				icon = 'hair_goten.dmi'
			Hair11
				icon = 'hair_short.dmi'
			Hair12
				icon = 'hair_vegetajr.dmi'
			Hair13
				icon = 'hair_strange.dmi'
			Hair13
				icon = 'hair_lan.dmi'
			Hair14
				icon = 'hair_kidgohan.dmi'
			Hair15
				icon = 'hair_trunks.dmi'
			Hair16
				icon = 'hair_futuregohan.dmi'
			Hair17
				icon = 'hair_adultgohan.dmi'
			Hair18
				icon = 'FT_Trunks_Hair.dmi'
			Hair19
				icon = 'GranolaHair.dmi'
			Hair20
				icon = 'Shallot_Hair.dmi'
			Hair21
				icon = 'TeenGohanHair (1).dmi'
			Hair22
				icon = 'YamchaGT.dmi'
			Hair23
				icon = 'YamchaS.dmi'
			Hair24
				icon = 'NewSpikeyH1.dmi'
			Hair25
				icon = 'nach_hair.dmi'
			Hair26
				icon = 'Stylish_Long_Hair.dmi'
			Hair27
				icon = 'VomiHair.dmi'


			None
		male_kid
			Hair1_kid
				name = "Hair1"
				icon = 'GokuRkidhair.dmi'
			Hair2_kid
				icon = 'hair_vegeta_kid.dmi'
			Hair3_kid
				icon = 'hair_yamcha_kid.dmi'
			Hair4_kid
				icon = 'UubHairkid.dmi'
			Hair5_kid
				icon = 'hair_long_kid.dmi'
			Hair6_kid
				icon = 'hair_afro_kid.dmi'
			Hair7_kid
				icon = 'hair_kidd_kid.dmi'
			Hair8_kid
				icon = 'hair_raditz_kid.dmi'
			Hair9_kid
				icon = 'hair_muse_kid.dmi'
			Hair10_kid
				icon = 'hair_goten_kid.dmi'
			Hair11_kid
				icon = 'hair_short_kid.dmi'
			Hair12_kid
				icon = 'hair_vegetajr_kid.dmi'
			Hair13_kid
				icon = 'hair_strange_kid.dmi'
			Hair13_kid
				icon = 'hair_lan_kid.dmi'
			Hair14_kid
				icon = 'hair_kidgohan_kid.dmi'
			Hair15_kid
				icon = 'hair_trunks_kid.dmi'
			Hair16_kid
				icon = 'hair_futuregohan_kid.dmi'
			Hair17_kid
				icon = 'hair_adultgohan_kid.dmi'
			Hair18_kid
				icon = 'FT_Trunks_Hair_Kid.dmi'
			Hair19_kid
				icon = 'GranolaKid.dmi'
			Hair20_kid
				icon = 'Shallot_Hair_Kid.dmi'
			Hair21_kid
				icon = 'KidTeenGohanHair.dmi'
			Hair22_kid
				icon = 'YamchaGTKid.dmi'
			Hair23_kid
				icon = 'YamchaSKid.dmi'
			Hair24_kid
				icon = 'NewSpikeyH1Kid.dmi'
			Hair25_kid
				icon = 'nach_hair.dmi'
				New()
					pixel_y=-5
			Hair26_kid
				icon = 'Stylish_Long_Hair_Kid.dmi'


obj/items/consumables/food
	New()
		..()
		spawn(10)
			src.active=1
			src.expiration_date()