/*var/global/list/lightning_bolts = list()
var/global/list/planet_positions = list()

proc/InitializePlanetPositions()
	planet_positions = list()
	for(var/obj/Planets/Mains/P in world)
		planet_positions[P] = list(P.x, P.y, P.z) // Store planet coordinates

proc/Register_Lightning_Bolt(var/obj/effects/lightning_bolt_space/B)
	//if(!(B in lightning_bolts))
	//lightning_bolts += B
	return


proc/Handle_Lightning_Bolts()
	set background = 1
	spawn while(TRUE) // Runs forever in the background
		sleep(5) // Adjust timing to balance performance

		if(!length(lightning_bolts)) continue

		for(var/obj/effects/lightning_bolt_space/B in world)
			if(!B) continue

			// Move Lightning Bolt
		//	B.loc = locate(rand(1,500), rand(1,500), 16)

			// Check if near any planet
			for(var/obj/Planets/Mains/P in world)
			//	var/list/pos = planet_positions[P]
				var/dist = get_dist(B, P)

				if(dist <= 99)
					switch(P.name)
						if("Namek") // namek
							B.filters -= filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(56,78,209))
							B.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(149,210,174))
							B.filters += filter(type="bloom", threshold=rgb(0,0,0), size=6, offset=1, alpha=175)

						if("Earth") // earth
							B.filters = null
							//B.filters -= filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(56,78,209))
							B.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(98,236,244))
							B.filters += filter(type="bloom", threshold=rgb(0,0,0), size=6, offset=1, alpha=175)

						if("Vegeta") // vegeta
							B.filters -= filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(56,78,209))
							B.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(131,3,62))
							B.filters += filter(type="bloom", threshold=rgb(0,0,0), size=6, offset=1, alpha=175)
						if("Icer") // icer
							B.filters -= filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(56,78,209))
							B.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(222,251,255))
							B.filters += filter(type="bloom", threshold=rgb(0,0,0), size=6, offset=1, alpha=175) */
/obj/items
	Click(location, control, params)
		// HARD INTERCEPT: delete mode always wins
		if(usr && usr.left_click_function == "delete stuff")
			var/obj/N = src
			usr.left_click_ref = N
			usr.hud_confirm.confirm_text(
				1,
				"You are about to delete [N]. Do you accept?",
				usr
			)
			usr.confirm = "accept delete obj"
			return  // ← THIS IS THE IMPORTANT PART

		// Otherwise, allow normal click behavior
		return ..()

/obj/items/clothing/proc/build_icon()
    if(!src.top_icon || !src.bottom_icon) return

    var/icon/combined = icon(src.top_icon, "south")
    combined *= src.top_color

    var/icon/bottom_layer = icon(src.bottom_icon, "south")
    bottom_layer *= src.bottom_color

    combined.Blend(bottom_layer, ICON_OVERLAY)

    src.icon = combined
    //world << "Top icon states: [icon_states(src.top_icon)]"
    //world << "Bottom icon states: [icon_states(src.bottom_icon)]"


obj
	proc


		CopyAttributes(from)
			name = from:name
			icon = from:icon
			icon_state = from:icon_state
			stacks = from:stacks
			// Copy any additional attributes as needed
			for (var/V in from:vars)
				if (V != "amount" && V != "name" && V != "icon" && V != "icon_state")
					vars[V] = from:vars[V]

		microwave_field()
			var/obj/items/tech/Microwave_Generator/gm = src
			//Otherwise continue
			if(src.setting)
				for(var/turf/t in view(src.radius,src))
					t.microwaves = src.setting
					gm.trfs += t
					for(var/mob/m in t)
						m.microwaves = src.setting
		pulsate_field()
			var/obj/items/tech/Gravity_Machine/gm = src
			//If we're dealing with a black hole.
			var/hole = 0
			if(src.icon == 'blackhole.dmi')
				hole = 1
				src.setting = 1
			//Otherwise continue
			if(src.setting)
				if(hole == 0)
					if(gm.field == null)
						var/obj/effects/shield/o = new
						o.appearance_flags = PIXEL_SCALE
						gm.field = o
				var/obj/s = gm.field
				s.loc = src.loc
				s.step_x = src.step_x
				s.step_y = src.step_y
				//for(var/mob/m in range(src.radius,src))
				for(var/turf/t in view(src.radius,src))
					//if(bounds_dist(src, m) < round(src.radius*32))
					if(hole) src.setting = 100
					t.grav = src.setting
					gm.trfs += t
					for(var/mob/m in t)
						m.grav = src.setting
				//sleep(5)
				//animate(o, transform = matrix()*1, alpha = 0, time = 20)
		furrow_fade()
			for(var/obj/items/plants/p in src.loc)
				if(p.bolted) p.destroy()//del(p)
			animate(src,alpha = 0, time = 2000)
			spawn(2000)
				if(src)
					src.loc = null
					src.alpha = 255
		display_gain_reset()
			spawn()
				if(src)
					animate(src,pixel_y = src.pixel_y+48,alpha = 10,time=15)
					spawn(15)
						if(src) src.loc = null
		del_obj(var/time)
			spawn(time)
				if(src) src.destroy()
		remove_obj(var/time)
			spawn(time)
				if(src) src.loc = null
		create_css_ref(var/action,var/ref,var/txt,var/size = 1,var/align)
			//var/result = {"<style> a { color: white; text-decoration: none; } a:link { color: white; } a:hover { color: red; } </style> <a href='?src=\ref[ref];action=[action]'>[txt]</a>"}
			var/result = {"<style> body { font-size: [size]px; text-align: [align]; } a { color: white; text-decoration: none; } a:link { color: white; } a:hover { color: red; } </style><body><a href='?src=\ref[ref];action=[action]'>[txt]</a></body>"}
			return result
		create_stack_display()
			var/display = src.stacks
			if(src.stacks < 0) display = 1
			var/image/dis = image(null,src,null,src.layer+35,0)
			dis.appearance_flags = PIXEL_SCALE | KEEP_APART
			dis.maptext_width = 32
			dis.maptext_height = 32
			//dis.maptext_y = -18
			dis.maptext_x = -2
			dis.maptext = "[css_outline]<font size = 1><text align=right valign=bottom>[display]"
			src.stack_display = dis

		expiration_date()
			set background = 1
			if(istype(src,/obj/items/consumables/))

				if(istype(src,/obj/items/consumables/food/) && !istype(src,/obj/items/consumables/food/special/))
					if(ismob(src.loc))
						var/mob/m = src.loc
						if(m.npc)
							src.active = 0
						//	world<<"Pausing Expiration - [src], found inside npc([m.name])"
					while(src)
						if( src.loc && src.active)
							//world<<"Starting Expirating - [src], timer: [src.expiry]/[src.expiration]"
							if(!src.fridge )
								if(src.expiry < src.expiration)
									src.expiry ++

								if(src.expiry == (src.expiration *0.5))
									if(ismob(src.loc))
										var/mob/m = src.loc
										if(src.expiration_cycle == 0 && src.stacks >1 )
											m<<output("[src] is about to expire.(Half)","actionoutput")
										else m<<output("[src] is about to expire.(Full)","actionoutput")
								if(src.expiry >= src.expiration )
									if(ismob(src.loc))
										var/mob/m = src.loc
										if(src.expiration_cycle == 1 || src.stacks <=1 )
											m<<output("[src] has expired(Full)","actionoutput")
											src.expiration_cycle = 1
										if(src.expiration_cycle == 0 )
											m<<output("[src] has expired.(Half)","actionoutput")

									if(src.expiration_cycle == 0)
										src.stacks = (src.stacks*0.5)
										src.expiry=0
										src.expiration_cycle = 1

									else if(ismob(src.loc))
										var/mob/m = src.loc

										remove_item_from_inventory(m,src)
										src.loc=null
						sleep(30)



				if(istype(src,/obj/items/consumables/water/))
					while(src)
						if(!src.fridge)
							if(src.expiry < src.expiration)
								src.expiry ++

							if(src.expiry == (src.expiration *0.5))
								if(ismob(src.loc))
									var/mob/m = src.loc
									if(src.expiration_cycle == 0 && src.stacks >1 )
										m<<output("[src] is about to expire.(Half)","actionoutput")
									else m<<m<<output("[src] is about to expire.(Full)","actionoutput")
							if(src.expiry >= src.expiration )
								if(ismob(src.loc))
									var/mob/m = src.loc
									if(src.expiration_cycle == 0)
										m<<output("[src] went bad.(Half)","actionoutput")
									else m<<m<<output("[src] went bad(Full)","actionoutput")
								if(src.expiration_cycle == 1 || src.stacks <=1 )
									if(ismob(src.loc))
										var/mob/m = src.loc
										if(istype(src,/obj/items/consumables/water/water_bottle))
											var/obj/items/consumables/water/water_bottle_dirty/wb = new/obj/items/consumables/water/water_bottle_dirty(m.loc)
											wb.stacks = (src.stacks)
											m.pickup(wb,0)
											qdel(src)
								if(src.expiration_cycle == 0 && src)
									if(ismob(src.loc))
										var/mob/m = src.loc
										if(istype(src,/obj/items/consumables/water/water_bottle))
											var/obj/items/consumables/water/water_bottle_dirty/wb = new/obj/items/consumables/water/water_bottle_dirty(m.loc)
											wb.stacks = (src.stacks*0.5)
											src.stacks = (src.stacks*0.5)

											m.pickup(wb,0)
											wb.expiry = 0
											src.expiry=0
											src.expiration_cycle = 1

						sleep(30)

		Boom(var/sploody)
			var/mob/M = ki_owner
			if(!M) return

			if(!M.explosion_ready)
				return
			M.explosion_ready = FALSE
			M.explosion_timer = 15  // 15 seconds @ 10 fps or whatever



			var/turf/T = src.loc
			var/max_dist = clamp(round(sploody / 5000), 1, 5)

			for(T as anything in block(locate(x - max_dist, y - max_dist, z), locate(x + max_dist, y + max_dist, z)))
				var/obj/ranged/Z = new /obj/ranged/Blow(T)
				Z.color = ki_owner?.auracolor
				Z.ki_owner = ki_owner


		boil_obj(var/mob/m)
			if (!src.loc)
				return

			var/fused_into_stack = 0

			if (src.stacks > 1)
				src.stacks -= 1
				if (src.stack_display)
					src.stack_display.maptext = "[css_outline]<font size=1><text align=right valign=bottom>[src.stacks]"

				if (!fused_into_stack)
					var/obj/new_item
					new_item = new src.cooked_type(m.loc)
					new_item.stacks = 1
					new_item.stack_display.maptext = "[css_outline]<font size=1><text align=right valign=bottom>[new_item.stacks]"
					new_item.stack_exempt = src.stack_exempt
					new_item.cooked = 1 // Or boiled level if you want to increase it
				if (prob(50))
					m.culinaryxp += m.mod_culinary
				if(src.stacks <=0)
					if(src) qdel(src)
			// Refresh inventory
				if (m.hud_inv)
					m.refresh_inv()
			else if (src.stacks == 1)
				var/obj/new_item
				new_item = new src.cooked_type(m.loc)
				new_item.cooked = 1
				if (prob(50)) m.culinaryxp += m.mod_culinary
				if(src)
					src.destroy()
					src.loc=null
					//del(src)



		/*boil_obj(var/mob/m)
			if (!src.loc)
				return // Exit early if the source object is not in a valid location

			// Modify object properties for "cooking"
			src.stacks -= 1
			var/obj/items/consumables/water/water_bottle_sea/nw = new /obj/items/consumables/water/water_bottle_sea/(m.loc)
			src.stack_display.maptext = "[css_outline]<font size=1><text align=right valign=bottom>[src.stacks]"
			if(src.cooked==2) nw.name = "Boiled [nw.name]"
			else if (src.cooked>=3) nw.name = "Boiled+ [nw.name]"

		//	src.color = rgb(165, 72, 62) // Tint the item brown

			// Check for quest requirements
			if (src.rarity >= 3)
				m.check_quest("needs_rare_food", 1, 0, 1)

			// Handle zero stacks
			if (src.stacks <= 1)
				remove_item_from_inventory(m, src)

			// Handle inventory stacking
			if(src.cooked<=3) nw.cooked+=1
			src.tech_lvl+=1
			nw.tech_lvl+=1
			handle_inventory_stacking(src, usr)
			//handle_inventory_adding(nw, usr)
			//handle_inventory_stacking(nw, usr)
		//	nw.apply_item_stats(usr,world.time)
		*/

		/*cook_obj(var/mob/m)
			if(!src || !m) return
			//if(!(src in m)) return   // must be in inventory

			// Remove one raw stack
			if(src.stacks > 1)
				src.stacks--
				if(src.stack_display)
					src.stack_display.maptext = "[css_outline]<font size=1><text align=right valign=bottom>[src.stacks]"
				else
					m.contents -= src
					del(src)

			// Create cooked item directly in inventory
			var/obj/new_item = new src.cooked_type(m)
			new_item.color = rgb(165,72,62)
			new_item.cooked = 1
			new_item.stacks = 1
			new_item.stack_exempt = src?.stack_exempt

			// Attempt stacking with existing cooked items
			new_item.handle_inventory_stacking(new_item, m)

			if(prob(50))
				m.culinaryxp += m.mod_culinary

			m.refresh_inv()*/
		cook_obj(var/mob/m)
			if(!src || !m) return
			if(!(src in m.contents)) return

			if(src.stacks > 1)
				src.stacks--

				if(src.stack_display)
					src.stack_display.maptext = "[css_outline]<font size=1><text align=right valign=bottom>[src.stacks]"

				var/obj/new_item = new src.cooked_type(m.loc)
				if(!istype(new_item,/obj/items/consumables/water/water_bottle_dirty)) new_item.color = rgb(165,72,62)
				new_item.cooked = 1
				new_item.stacks = 1

				new_item.stack_exempt = src.stack_exempt
				m.pickup(new_item)
				//new_item.handle_inventory_stacking(new_item, m)

			else
			    // Transform this object into cooked

				var/typepath = src.cooked_type

				var/obj/new_item = new typepath(m.loc)

				if(!istype(new_item,/obj/items/consumables/water/water_bottle_dirty)) new_item.color = rgb(165,72,62)
				new_item.cooked = 1
				new_item.stacks = 1
				new_item.stack_exempt = src.stack_exempt
				//if(!new_item.handle_cooked_obj_stacking(new_item,m))
				//new_item.loc=m
			//m.hud_inv.vis_contents -= src
			//m.inv[src.slot] = null
				/*m.inv[old_slot] = new_item
				new_item.slot = old_slot
				//m.refresh_inv()
				m.contents -= src
				src.loc=null
				src.destroy()*/
				remove_item_from_inventory(m,src)


				//del(src)
				m.refresh_inv()


		/*cook_obj(var/mob/m)
			if (!src.loc)
				return


			var/fused_into_stack = 0
			if (src.stacks >= 1)
				src.stacks -= 1
				world << "Fusion Cook"
				if (src.stack_display)
					src.stack_display.maptext = "[css_outline]<font size=1><text align=right valign=bottom>[src.stacks]"

				var/obj/new_item
				new_item = new src.cooked_type(m.loc)
				world << "Fusion food spawn"
				new_item.color = rgb(165, 72, 62)
				world << "Fusion Cook color"
				new_item.stacks = 1
				new_item.stack_display.maptext = "[css_outline]<font size=1><text align=right valign=bottom>[new_item.stacks]"
				//new_item.stack_exempt = src.stack_exempt
				new_item.cooked = 1
				world << "Fusion Cooked"

				//if(prob(50)) m.culinaryxp += m.mod_culinary
				if(src.stacks <=0)
					world << "Fusion food stack check"
					if(m.hud_inv) m.hud_inv.vis_contents -= src
					if(src == m.item_selected)
						m.item_selected = null
						m.hud_inv.item_desc.maptext = null
					m.inv[src.slot] = null
					src.slot = -1
					src.destroy()
					world<< "Fusion Removal!"
					//if(src) del(src)
			// Force HUD refresh
				if (m.hud_inv)
					m.refresh_inv()


			else if(src.stacks < 1)
				world<<"Non Fusion Cook!"
				var/obj/new_item
				new_item = new src.cooked_type(m.loc)
				new_item.stack_display.maptext = "[css_outline]<font size=1><text align=right valign=bottom>[new_item.stacks]"
				//new_item.stack_exempt = src.stack_exempt

				new_item.color = rgb(165, 72, 62)
				new_item.cooked = 1
				//m.pickup(new_item)
				world<<"Non Fusion Pickup!"
				//if(src.slot)
				if(m.hud_inv) m.hud_inv.vis_contents -= src
				if(src == m.item_selected)
					m.item_selected = null
					m.hud_inv.item_desc.maptext = null
				m.inv[src.slot] = null
				src.slot = -1
				src.destroy()


				//src.stacks=0
				//if(prob(50)) m.culinaryxp += m.mod_culinary
				//src.destroy()
				//src.loc=null
			m.refresh_inv()
			return
			*/
				//if(src) del(src)
			// Force HUD refresh





			// XP and quests
		//	if (m.culinaryxp >= 3)
			//	m.check_quest("needs_rare_food", 1, 0, 1)




		/*cook_obj(var/mob/m)
			if (!src.loc)
				return // Exit early if the source object is not in a valid location

			// Remove the word "Raw " from the start of the item name if it exists
			if(findtext(src.name, "Raw ") == 1) // Check if name starts with "Raw "
				src.name = copytext(src.name, 5) // Remove "Raw " (positions 1-4)

			// Modify object properties for "cooking"
		//	src.stacks -= 1
			src.stack_display.maptext = "[css_outline]<font size=1><text align=right valign=bottom>[src.stacks]"
			src.name = "Cooked [src.name]"
			src.color = rgb(165, 72, 62) // Tint the item brown
			src.rarity = round(m.culinaryxp)
			if(src.rarity>=5) src.rarity = 5
			// Check for quest requirements
			if (src.rarity >= 3)
				m.check_quest("needs_rare_food", 1, 0, 1)

			// Handle zero stacks
			if (src.stacks <= 0)
				remove_item_from_inventory(m, src)

			// Handle inventory stacking
			src.cooked=1
			m.culinaryxp += (m.mod_culinary)
			src.tech_lvl+=m.culinaryxp
			handle_inventory_stacking(src, usr)

*/
		remove_item_from_inventory(var/mob/m, var/obj/item)
			if (item.slot)
				if (m.hud_inv)
					m.hud_inv.vis_contents -= item
				if (item == m.item_selected)
					m.item_selected = null
					m.hud_inv.item_desc.maptext = null
				m.inv[item.slot] = null
				item.slot = -1
				if(item.slot<=0) item.slot = null
		handle_cooked_food_adding(var/obj/i, var/mob/target_user)
			var/found_stack = 0
			var/overflow = 0

			//If this item stacks, search for another stack of the same item and fuse them
			if(i.stacks > -1)
				if(i.stack_display == null) i.create_stack_display()
				for(var/sl=1, sl<49, sl++)
					if(target_user.inv[sl] != null)
						if(target_user.inv[sl] != i && target_user.inv[sl].name == i.name && target_user.inv[sl].stacks > -1 && target_user.inv[sl].stacks < 98 )
							if(target_user.inv[sl].stack_display == null) target_user.inv[sl].create_stack_display()
							var/total = (i.stacks + target_user.inv[sl].stacks)
							if(total > 99)
								overflow = total-99
								i.stacks = overflow
								total = 99
								target_user.inv[sl].stacks = total
								i.stack_display.maptext = "[css_outline]<font size = 1><text align=right valign=bottom>[i.stacks]"
								target_user.inv[sl].stack_display.maptext = "[css_outline]<font size = 1><text align=right valign=bottom>[target_user.inv[sl].stacks]"
							else
								target_user.inv[sl].stacks = total
								target_user.inv[sl].stack_display.maptext = "[css_outline]<font size = 1><text align=right valign=bottom>[target_user.inv[sl].stacks]"
								found_stack = 1
							break
			//If it doesn't stack, or we can't kind an existing stack, simply add it into the inventory as normal.
			if(found_stack == 0)
				//Find empty slot for this item to go into
				var/found_slot = 0
				for(var/sl=1, sl<49, sl++)
					if(target_user.inv[sl] == null)
						target_user.inv[sl] = i
						i.slot = sl
						i.vis_contents += global.inv_slot
						found_slot = sl
						break
				if(found_slot)
					i.loc = src
					animate(i)
					i.pixel_y = initial(i.pixel_y)
					if(i.shadow) i.shadow.loc = null
					if(i.inven_state) i.icon_state = i.inven_state
					i.overlays -= /obj/effects/select_item
					target_user.mouse_down = null
					target_user.mouse_over = null
					target_user.refresh_inv()
					return
				else
					target_user.set_alert("Inventory full",'alert.dmi',"alert")

					i.loc = locate(target_user.x, target_user.y, target_user.z)
					return
			else
				i.destroy()
				return
		handle_inventory_adding(var/obj/i, var/mob/target_user)
			var/found_stack = 0
			var/overflow = 0
			//If this item stacks, search for another stack of the same item and fuse them
			if(i.stacks > -1)
				if(i.stack_display == null) i.create_stack_display()
				for(var/sl=1, sl<49, sl++)
					if(target_user.inv[sl] != null)
						if(target_user.inv[sl] != i && target_user.inv[sl].type == i.type && target_user.inv[sl].stacks > -1 && target_user.inv[sl].stacks < 98 && i.tech_lvl == target_user.inv[sl].tech_lvl)
							if(target_user.inv[sl].stack_display == null) target_user.inv[sl].create_stack_display()
							var/total = (i.stacks + target_user.inv[sl].stacks)
							if(total > 99)
								overflow = total-99
								i.stacks = overflow
								total = 99
								target_user.inv[sl].stacks = total
								i.stack_display.maptext = "[css_outline]<font size = 1><text align=right valign=bottom>[i.stacks]"
								target_user.inv[sl].stack_display.maptext = "[css_outline]<font size = 1><text align=right valign=bottom>[target_user.inv[sl].stacks]"
							else
								target_user.inv[sl].stacks = total
								target_user.inv[sl].stack_display.maptext = "[css_outline]<font size = 1><text align=right valign=bottom>[target_user.inv[sl].stacks]"
								found_stack = 1
							break
			//If it doesn't stack, or we can't kind an existing stack, simply add it into the inventory as normal.
			if(found_stack == 0)
				//Find empty slot for this item to go into
				var/found_slot = 0
				for(var/sl=1, sl<49, sl++)
					if(target_user.inv[sl] == null)
						target_user.inv[sl] = i
						i.slot = sl
						i.vis_contents += global.inv_slot
						found_slot = sl
						break
				if(found_slot)
					i.loc = src
					animate(i)
					i.pixel_y = initial(i.pixel_y)
					if(i.shadow) i.shadow.loc = null
					if(i.inven_state) i.icon_state = i.inven_state
					i.overlays -= /obj/effects/select_item
					target_user.mouse_down = null
					target_user.mouse_over = null
					target_user.refresh_inv()
					return
				else
					target_user.set_alert("Inventory full",'alert.dmi',"alert")

					i.loc = locate(target_user.x, target_user.y, target_user.z)
					return
			else
				i.destroy()
				return

		handle_cooked_obj_stacking(var/obj/item, var/mob/target_user)
			var/base_name = "[item.name]"
			var/found = 0
			for (var/sl = 1 to 48)
				var/obj/inv_item = target_user.inv[sl]
				if (inv_item && inv_item != item && inv_item.name == base_name)
					if (inv_item.stacks > -1 && inv_item.stacks < 98)
						var/remaining_space = 98 - inv_item.stacks
						if (item.stacks <= remaining_space)
							inv_item.stacks += item.stacks
							item.stacks = 0
							found = 1
							break
						else
							item.stacks -= remaining_space
							inv_item.stacks = 98
							found = 1
			if(found)
				return TRUE
			return FALSE


		handle_inventory_stacking(var/obj/item, var/mob/target_user)
			for (var/sl = 1 to 48)
				var/obj/inv_item = target_user.inv[sl]
				if (inv_item && inv_item != item && inv_item.type == item.type)
					if (inv_item.stacks > -1 && inv_item.stacks < 98 && item.tech_lvl == inv_item.tech_lvl)
						var/remaining_space = 98 - inv_item.stacks
						if (item.stacks <= remaining_space)
							inv_item.stacks += item.stacks
							item.stacks = 0
							break
						else
							item.stacks -= remaining_space
							inv_item.stacks = 98

	/*	cook_obj(var/mob/m)
			if(src.loc != null)
				var/obj/items/newobj=new
				newobj=src
				src.stacks -= 1
				src.stack_display.maptext = "[css_outline]<font size = 1><text align=right valign=bottom>[src.stacks]"
				if(src.rarity >= 3) m.check_quest("needs_rare_food",1,0,1)
				if(src.stacks == 0 || src.stacks == -2)
					if(src.slot)
						if(m.hud_inv) m.hud_inv.vis_contents -= src
						if(src == m.item_selected)
							m.item_selected = null
							m.hud_inv.item_desc.maptext = null
						m.inv[src.slot] = null
						src.slot = -1
					var/T = world.time
					//src.destroy()
					src:apply_item_stats(usr,T)


					var/found_stack = 0
					var/overflow = 0
					src.name = "Cooked [src.name]"
					src.color = rgb(165, 72, 62) // Tint the item brown
					if(src.stack_display == null) src.create_stack_display()
					for(var/sl=1, sl<49, sl++)
						if(usr.inv[sl] != null)
							if(usr.inv[sl] != src && usr.inv[sl].type == src.type && usr.inv[sl].stacks > -1 && usr.inv[sl].stacks < 98 && src.tech_lvl == usr.inv[sl].tech_lvl)
								if(usr.inv[sl].stack_display == null) usr.inv[sl].create_stack_display()
								var/total = (src.stacks + usr.inv[sl].stacks)
								if(total > 99)
									overflow = total-99
									src.stacks = overflow
									total = 99
									usr.inv[sl].stacks = total
									src.stack_display.maptext = "[css_outline]<font size = 1><text align=right valign=bottom>[src.stacks]"
									usr.inv[sl].stack_display.maptext = "[css_outline]<font size = 1><text align=right valign=bottom>[usr.inv[sl].stacks]"
								else
									if(total == 0 ) total =1
									usr.inv[sl].stacks = total
									usr.inv[sl].stack_display.maptext = "[css_outline]<font size = 1><text align=right valign=bottom>[usr.inv[sl].stacks]"
									found_stack = 1
								break
					//If it doesn't stack, or we can't kind an existing stack, simply add it into the inventory as normal.
					if(found_stack == 0)
						//Find empty slot for this item to go into
						var/found_slot = 0
						for(var/sl=1, sl<49, sl++)
							if(usr.inv[sl] == null)
								usr.inv[sl] = src
								src.slot = sl
								src.vis_contents += global.inv_slot
								found_slot = sl
								break
						if(found_slot)
							src.loc = src
							animate(src)
							src.pixel_y = initial(src.pixel_y)
							if(src.shadow) src.shadow.loc = null
							if(src.inven_state) src.icon_state = src.inven_state
							src.overlays -= /obj/effects/select_item
							usr.mouse_down = null
							usr.mouse_over = null
							if(usr.client) usr.refresh_inv()
							return
						else
							usr.set_alert("Inventory full",'alert.dmi',"alert")
							usr.create_chat_entry("alerts","Inventory full.")
							return
					else
						src.destroy()*/

		use_obj(var/mob/m,var/amount=0)
			if(src.loc != null)
				if(amount<=0) src.stacks -= 1
				else if(amount>0) src.stacks -= amount
				src.stack_display.maptext = "[css_outline]<font size = 1><text align=right valign=bottom>[src.stacks]"
				//if(src.rarity >= 3) m.check_quest("needs_rare_food",1,0,1)
				if(src.stacks == 0 || src.stacks == -2)
					remove_item_from_inventory(m,src)
					/*if(src.slot)
						if(m.hud_inv) m.hud_inv.vis_contents -= src
						if(src == m.item_selected)
							m.item_selected = null
							m.hud_inv.item_desc.maptext = null
						m.inv[src.slot] = null
						src.slot = -1
					src.destroy()*/

		apply_skillbar(var/mob/m,var/obj/skill, var/remove = 0)
			src.overlays = null
			if(skill)
				if(remove == 0)
					src.overlays += skill
					src.skill_taken = skill
					if(src.name == "1")
						m.one = list(skill)
					if(src.name == "2")
						m.two = list(skill)
					if(src.name == "3")
						m.three = list(skill)
					if(src.name == "4")
						m.four = list(skill)
					if(src.name == "5")
						m.five = list(skill)
					if(src.name == "6")
						m.six = list(skill)
					if(src.name == "7")
						m.seven = list(skill)
					if(src.name == "8")
						m.eight = list(skill)
					if(src.name == "9")
						m.nine = list(skill)
					if(src.name == "0")
						m.zero = list(skill)
					if(src.name == "-")
						m.minus = list(skill)
					if(src.name == "=")
						m.equal = list(skill)
				else
					src.skill_taken = null
					if(src.name == "1")
						m.one = null
					if(src.name == "2")
						m.two = null
					if(src.name == "3")
						m.three = null
					if(src.name == "4")
						m.four = null
					if(src.name == "5")
						m.five = null
					if(src.name == "6")
						m.six = null
					if(src.name == "7")
						m.seven = null
					if(src.name == "8")
						m.eight = null
					if(src.name == "9")
						m.nine = null
					if(src.name == "0")
						m.zero = null
					if(src.name == "-")
						m.minus = null
					if(src.name == "=")
						m.equal = null
		/*
		check_connection(var/delete = 0)
			var/obj/items/tech/the_bat = src
			var/list/bats = list()
			for(var/obj/items/tech/btry in the_bat.batteries)
				bats += btry
				for(var/obj/items/tech/lines in btry.connections)
					lines.batteries = new()
					lines.checked = new()
					//lines.overlays -= /obj/items/tech/flow
				btry.connections = new()
				if(delete) src.bolted = 0
			for(var/obj/items/tech/Battery/b in bats)
				b.check_power_lines("battery movement")
		check_power_lines(var/check_type = null)
			var/obj/items/tech/the_src = src
			if(check_type == "battery movement")
				for(var/obj/items/tech/Power_Line/p in range(1,src))
					if(bounds_dist(src, p) < 3)
						if(p.bolted) if(!src.grabbed_by) if(!src.tk) if(!p.checked.Find(src))
							p.checked += src
							p.batteries += src
							the_src.connections += p
							p.check_power_lines()
			else
				var/lines = list()
				for(var/obj/items/tech/Power_Line/p in locate(src.x+1,src.y,src.z))
					lines += p
				for(var/obj/items/tech/Power_Line/p in locate(src.x-1,src.y,src.z))
					lines += p
				for(var/obj/items/tech/Power_Line/p in locate(src.x,src.y+1,src.z))
					lines += p
				for(var/obj/items/tech/Power_Line/p in locate(src.x,src.y-1,src.z))
					lines += p
				for(var/obj/items/tech/o in lines)
					if(o.bolted)
						for(var/obj/items/tech/btry in the_src.batteries)
							if(!o.checked.Find(btry))
								o.batteries += btry
								o.checked += btry
								btry.connections += o
								o.overlays = null
								//o.overlays += /obj/items/tech/flow
								o.check_power_lines()
		*/
		/*
		check_belt(var/mob/m)
			var/obj/found_north = null
			var/obj/found_south = null
			var/obj/found_east = null
			var/obj/found_west = null
			for(var/obj/items/tech/Conveyor_Belt/p in locate(src.x+1,src.y,src.z))
				found_east = p
			for(var/obj/items/tech/Conveyor_Belt/p in locate(src.x-1,src.y,src.z))
				found_west = p
			for(var/obj/items/tech/Conveyor_Belt/p in locate(src.x,src.y+1,src.z))
				found_north = p
			for(var/obj/items/tech/Conveyor_Belt/p in locate(src.x,src.y-1,src.z))
				found_south = p
			if(found_north)
				if(m.dir == EAST)
					var/obj/o = new
					o.icon = 'conveyor_belt.dmi'
					o.icon_state = "bottom left east"
					o.layer = 4.9
					src.overlays += o
			if(found_west)
				if(m.dir == NORTH)
					var/obj/o = new
					o.icon = 'conveyor_belt.dmi'
					o.icon_state = "bottom right north"
					o.layer = 4.9
					src.overlays += o
			if(found_south)
				if(m.dir == WEST)
					var/obj/o = new
					o.icon = 'conveyor_belt.dmi'
					o.icon_state = "top right west"
					o.layer = 4.9
					src.overlays += o
			if(found_east)
				if(m.dir == SOUTH)
					var/obj/o = new
					o.icon = 'conveyor_belt.dmi'
					o.icon_state = "top left south"
					o.layer = 4.9
					src.overlays += o
		*/

		spawn_smoke_effect(obj/src, count)
			var/smoke_quantity = 2  // Number of smoke objects to create
			for (var/i = 0; i < smoke_quantity; i++)
				spawn(2)  // Delay between each smoke spawn
				new /obj/effects/Smoke1(src.loc)  // Spawn smoke at the source location
		Store(var/mob/m)

			for(var/obj/items/tech/O in orange(1, m)) // range(1, m) is better for "same tile or adjacent"
				if(!istype(O, /obj/items/tech)) continue
				var/obj/items/tech/T = O
				if(T == src) continue // Don't store self
				if(T.loc == src) continue // Already stored
				if(cantStore)
					m << "You cannot store this!"
					return

				if(occupied)
					m << "This capsule is occupied!"
					return

				if(istype(T, /obj/items/tech/Capsule))
					return

				if(T.level > src.level)
					m << "This item is too advanced for your capsule."
					return
				if(T.shadow) T.shadow.loc = null
				storeditem = T
				src.contents += T

				T.loc = src

				for(var/mob/M in view(25, m))
					M << output("[M.get_strangername(m)] stores [storeditem] into a capsule!", "actionoutput")

				view(m) << sound('capsuleclick.ogg', volume=42)
				occupied = 1
				icon_state = "full"
				break
		Open(var/mob/m)
			if(!occupied || !storeditem)
				m << "There is nothing inside the capsule."
				return

			if(!(storeditem in src.contents))
				m << "The stored item appears to be missing or corrupted."
				storeditem = null
				occupied = 0
				return

			var/dir_offset = get_step(m, m.dir)
			if(isturf(dir_offset))
				storeditem.loc = dir_offset
			else
				storeditem.loc = m.loc // fallback
			if(items)
				if(!(src in items)) items += src
			view(m) << sound('capsuleboom.ogg', volume=22)
			for(var/mob/P in view(10, m))
				P << output("[P.get_strangername(m)] clicks and opens a capsule!", "actionoutput")

			// >>> IMPORTANT: force init for ships (and anything else that needs it)
			if(istype(storeditem, /obj/items/tech/ships/CC_Ship))
				if(storeditem:initialized) return
				if(storeditem:deferred_init || !storeditem:initialized)
					storeditem:InitializeShip()
					var/obj/items/tech/ships/S = storeditem

					if(!isturf(S.entry_location) && S.panel)
						S.entry_location = locate(S.panel.savedX, S.panel.savedY-1, S.panel.savedZ)
			if(istype(storeditem, /obj/items/tech/ships/Deluxe_Ship))
				if(storeditem:initialized) return
				if(storeditem:deferred_init || !storeditem:initialized)
					storeditem:InitializeShip()
					var/obj/items/tech/ships/S = storeditem

					if(!isturf(S.entry_location) && S.panel)
						S.entry_location = locate(S.panel.savedX, S.panel.savedY-1, S.panel.savedZ)
			if(istype(storeditem, /obj/items/tech/ships/Namekian_Ship))
				if(storeditem:initialized) return
				if(storeditem:deferred_init || !storeditem:initialized)
					storeditem:InitializeShip()
					var/obj/items/tech/ships/S = storeditem

					if(!isturf(S.entry_location) && S.panel)
						S.entry_location = locate(S.panel.savedX, S.panel.savedY-1, S.panel.savedZ)

			//if(!isturf(S.entry_location))
		//m << "Ship interior failed to load. Try reopening capsule."

			spawn_smoke_effect(storeditem, 2)
			if(storeditem:shadow) storeditem:shadow.loc = storeditem.loc

			src.contents -= storeditem
			storeditem = null
			occupied = 0
			icon_state = ""
		/*Open(var/mob/m)
			if(!storeditem)
				m << "There is nothing inside the capsule."
				return
			if(!occupied)
				return

			// Check if item was somehow deleted
			if(!storeditem in src.contents)
				m << "The stored item appears to be missing or corrupted."
				storeditem = null
				occupied = 0
				return

			view(m) << sound('capsuleboom.ogg', volume=22)
			for(var/mob/P in view(10, m))
				P << output("[P.get_strangername(m)] clicks and opens a capsule!", "actionoutput")

			// Move the item in front of the user (or to their tile)
			var/dir_offset = get_step(m, m.dir)
			if(isturf(dir_offset))
				storeditem.loc = dir_offset
			else
				storeditem.loc = m.loc // fallback



			spawn_smoke_effect(storeditem, 2)
			if(storeditem.shadow) storeditem.shadow.loc = storeditem.loc
			src.contents -= storeditem
			storeditem = null
			occupied = 0
			icon_state = ""*/

		compress(var/mouse_side, var/mob/m, var/dist = 1, var/breaks = 1)
			if(mouse_side != "right")
			//	world<<"Not right mouse"
				return
			if(!m)
			//	world<<"No Mob."
				return
			//if(!isturf(src.loc)) return
			if(src.icon_state == "")
				var/turf/og_loc = m.loc
				for(var/obj/items/tech/I in range(dist, m))
					if( I.type == src.type || I.legendary)
					//	world<<"Continue-capsule"
						continue
					if(get_dist(m, og_loc) > 3)
					//	world<<"og loc check- breaking."
						break

					var/den = I.density_factor
					I.density_factor = 0

					if(istype(I, /obj/items/tech/))
						for(var/turf/trf in I.locs)
							for(var/obj/items/tech/Power_Line/p in trf)
								spawn(2)
									if(p) p.reconnect_power()

					while(bounds_dist(I, m) > 0 && isturf(m.loc))
						step_towards(I, m, 6)
						sleep(0.1)

					I.density_factor = den
					I.shockwave()

					var/obj/o = new
					o.icon = I.icon
					o.icon_state = I.icon_state
					o.layer = I.layer
					o.loc = src.loc
					o.overlays = I.overlays
					o.pixel_x = I.pixel_x
					o.pixel_y = I.pixel_y
					o.step_x = src.step_x
					o.step_y = src.step_y

					// Allow animation to play before cleanup
					animate(o, transform = matrix().Scale(-1, -1), alpha = 0, pixel_y = o.pixel_y - 16, time = 5)
					spawn(5) if(o) del(o)

					I.Move(src)
					if(I.shadow) I.shadow.loc = I.loc

					src.icon_state = "full"
					if(breaks) break

			else
				var/create_dusts = 100
				var/make_smoke = 0
				for(var/obj/items/I in src)
					make_smoke = 1
					I.loc = src.loc
					//I.set_shadow()
					if(istype(I,/obj/items/tech/))
						for(var/obj/items/tech/Power_Line/p in src.loc)
							p.reconnect_power()
				if(make_smoke)
					var/obj/effects/dust_rock_medium/x = new
					x.loc = src.loc
					x.step_x = src.step_x
					x.step_y = src.step_y
					while(create_dusts)
						create_dusts -= 1
						var/X = rand(-200,200)
						var/Y = rand(-200,200)
						var/t = rand(15,30)
						for(var/obj/d in smokes)
							d.pixel_x = -8
							d.loc = locate(src.x,src.y,src.z)
							d.step_x = src.step_x
							d.step_y = src.step_y
							animate(d, pixel_y = Y,pixel_x = X,alpha = 0, time = t)
							smokes -= d
							spawn(t)
								smokes += d
								d.pixel_x = -8
								d.pixel_y = -15
								d.alpha = 255
								d.loc = null
							break
					src.icon_state = ""
		explode_rock()
			if(src.suffix != "exploding")
				src.density_factor = 0
				src.suffix = "exploding"
				var/list/rocks = list()
				//CHECK_TICK
				sleep(1)
				src.icon = null
				if(src.shadow) del(src.shadow)
				for(var/obj/o in rocks)
					var/pixel_x_up = rand(-64,64)
					var/pixel_y_up = rand(0,96)
					animate(o, pixel_x = pixel_x_up,pixel_y = pixel_y_up, time = 3,easing = QUAD_EASING)
				//CHECK_TICK
				sleep(3)
				for(var/obj/o in rocks)
					var/pixel_y_down = rand(-32,0)
					animate(o, pixel_y = pixel_y_down, time = 3)
				//CHECK_TICK
				sleep(3)

