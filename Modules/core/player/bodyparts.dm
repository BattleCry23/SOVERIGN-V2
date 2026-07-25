
/*
- Takes on average 12.5 hours to get a bodypart to lvl 1000 just from Meditation
- Would take 9.375 hours with the Iron Body trait (+25% more xp)
- Would take 4.68 hours while being a demon (+100% exp) and having Iron Body (+25%)



*/
obj
	body_related
		//filters = filter(type="drop_shadow", x=0, y=0,size=5, offset=2, color=rgb(255,255,170))
		var
			broken = 0
			bodypart_type = null
			list/needed_parts
			list/needed_parts_ref
			list/compatible //A list of parts that this cybernetic part can meld with
			list/steps //A list of steps that need to be completed before this ascension unlocks. So long as any 0's in this list exsist, unable to proceed with the ascension.
			part_hierarchy //Order rank of each limb part. For example, left_upper_arm_bones is 3, so 3 and lower are disabled if damaged.

			//Stats gains
			psi_gain = 0
			eng_gain = 0
			str_gain = 0
			end_gain = 0
			res_gain = 0
			force_gain = 0
			off_gain = 0
			def_gain = 0

			//Misc gains
			int_gain = 0
			lifespan_gain = 0
			rads_gain = 0
			cold_gain = 0
			heat_gain = 0
			gravity_gain = 0
			micro_gain = 0
			toxin_gain = 0
			divine_eng_gain = 0
			dark_matter_gain = 0
			divine_mod_gain = 0
			dark_matter_mod_gain = 0
			o2_gain = 0

			psi_needed = 0
			eng_needed = 0
			str_needed = 0
			end_needed = 0
			spd_needed = 0
			res_needed = 0
			force_needed = 0
			off_needed = 0
			def_needed = 0
			regen_needed = 0
			recov_needed = 0
			realm_needed = null
			divine_needed = 0


			eng_mod_gain = 0
			psi_mod_gain = 0
			spd_mod_gain = 0
			regen_mod_gain = 0
			recov_mod_gain = 0

			psi_gain_base = 0
			eng_gain_base = 0
			str_gain_base = 0
			end_gain_base = 0
			res_gain_base = 0
			force_gain_base = 0
			off_gain_base = 0
			def_gain_base = 0
			int_gain_base = 0
			divine_eng_gain_base = 0
			dark_matter_gain_base = 0

			gain_txt = null
			part_exp = 0
			part_exp_num = 2 //How hard this part is to train. This can also increase as the part lvls up.
			part_multi = 1 //How much each time you get for completing a body part special
			can_unlock = 0
			desc_fnt_siz = 7
			infused_divine = 0
			infused_dark = 0
			infused_petrified = 0
			i_state = null

			//Decides whether the ascension in question is a minor or major one.
			major_ascension = 0
			minor_ascension = 0
			ascension_type = null
			realm = "Pre-Psionic"

			//Status of body part
			needed_lvl = 0
			needed_rp = 0
			needs_soul = 0
			needs_body = 0
			lvl_max = 1000
			counters = null //The sin/virtue countered by this sin/viture.
			disabled = 0 //Makes sure this isn't disabled twice.
			disabled_perma = 0 //Makes sure this isn't disabled twice.
			disabled_by = ""
			damaged = 0 //This makes it so the limb doesn't just come back "online" once it starts to heal. It must reach 100% hp before this is set to 0 again.
			status = "Functional" //Sets the text status of this limb
			inside = null //Whether this bodypart is inside another limb
			txt_col = "white" //Shows the name of the bodyparts maptext as a certain color, depending on the damage sustained.
			effect = "None"
			deduction = 0

			//Cybernetics
			cybernetic = 0
			cybernetics_current = 0
			cybernetics_max = 10
			cybernetics_created = 0
			list/cybernetics = null//A list of cybernetics inside this bodypart

		MouseEntered()
			..()
			if(src != usr.part_selected && src != usr.part_focus)
				src.underlays = null
				if(bodypart_underlay) bodypart_underlay.icon_state = "menu hover"
				src.underlays += bodypart_underlay
		MouseExited()
			..()
			if(src != usr.part_selected && src != usr.part_focus)
				src.underlays = null
				if(bodypart_underlay) bodypart_underlay.icon_state = "menu"
				src.underlays += bodypart_underlay
		Click(location,control,params)
			src.select_part(usr,params)
		proc
			select_part(var/mob/player,var/params)
				if(params != "right" && params != null) params = params2list(params)
				var/mob/holder = player
				var/obj/o = null
				var/pass = 0
				if(params == "right" || params != null && params["right"])
					//Right click to remove cyberware
					if(istype(src,/obj/body_related/bodyparts/cybernetics/) == 1)
						if(isobj(src.loc))
							o = src.loc
							if(istype(o,/obj/body_related/bodyparts/) == 1)
								if(o.loc in player.body)
									//winset(player,"confirm.label_confirm","text=\"Are you sure you want to remove this cybertech?\"")
									//winshow(player,"confirm",1)
									player.hud_confirm.confirm_text(1,"Are you sure you want to remove this cybertech?",player)
									player.confirm = "confirm cybertech removal"
									player.left_click_ref = src
									return
				if(params == null || params["left"])
					if(isobj(src.loc))
						o = src.loc
						if(o in player.body) pass = 1
						else if(player.upgrading)
							if(o in player.upgrading.body)
								holder = player.upgrading
								if(get_dist(player,holder) <= 2)
									pass = 1
								else
									player.client.screen -= player.hud_body
									player.open_body = 0
									player.open_menus.Remove(".open_body")
									player.upgrading = null
									player.set_alert("Android too far away",'alert.dmi',"alert")
									//player.create_chat_entry("alerts","Android too far away.")
									player << output("Android is too far away to upgrade.", "chat.system")
						else
							var/obj/x = o.loc
							if(x in player.body) pass = 1 //Cyberware
					if(src in player.milestones) pass = 1
					if(src in player.meridians) pass = 1
					if(src in player.ascensions) pass = 1
					if(src in player.soul) pass = 1
					if(player.left_click_function == "apply cybertech" && player.left_click_ref)
						if(player.cyborging) pass = 1
					if(pass)
						//Handle cybernetic application
						if(player.cyber_selected)
							var/obj/hud/buttons/cybernetic_slot/cs = player.cyber_selected
							if(cs)
								cs.selected = 0
								if(cs.full == 0) cs.icon_state = "empty"
								else cs.icon_state = "full"
								player.cyber_selected = null
						if(src.cybernetics == null)
							src.cybernetics = list()
							src.cybernetics.len = src.cybernetics_max
						if(player.left_click_function == "apply cybertech" && player.left_click_ref)
							var/obj/body_related/i = player.left_click_ref
							if(i.loc == player && istype(i,/obj/body_related/bodyparts/cybernetics/) == 1)
								if(i.compatible && islist(i.compatible) && length(i.compatible) > 0)
									if(src.cybernetics_current >= src.cybernetics_max)
										player.set_alert("Bodypart cybernetic limit reached",'alert.dmi',"alert")
										//player.create_chat_entry("alerts","Bodypart cybernetic limit reached.")
										return
									for(var/obj/body_related/bodyparts/cybernetics/c in src)
										if(c.type == i.type)
											player.set_alert("Unable to stack cybernetics",'alert.dmi',"alert")
											//player.create_chat_entry("alerts","Unable to stack cybernetics.")
											return
									var/is_compatible = 0
									for(var/x in i.compatible)
										if(x == "All")
											is_compatible = 1
											break
										else if(x == "Muscle" && src.bodypart_type == "Muscle")
											is_compatible = 1
											break
										else if(x == "Bone" && src.bodypart_type == "Bone")
											is_compatible = 1
											break
										else if(x == "Skin" && findtext(src.name,"Skin"))
											is_compatible = 1
											break
										else if(x == src.type)
											is_compatible = 1
											break
										else if(ispath(src.type,x) == 1)
											is_compatible = 1
											break
									if(is_compatible)
										i.loc = src
										src.cybernetics_current += 1
										for(var/c=1, c<src.cybernetics.len, c++)
											if(src.cybernetics[c] == null)
												src.cybernetics[c] = i
												for(var/obj/hud/buttons/cybernetic_slot/cs in src)
													if(cs.slot == c)
														cs.icon_state = "full"
														cs.full = 1
														break
												break
										if(i.slot)
											if(player.hud_inv) player.hud_inv.vis_contents -= i
											if(i == player.item_selected)
												player.item_selected = null
												player.hud_inv.item_desc.maptext = null
											player.inv[i.slot] = null
											i.slot = -1
										player.refresh_inv()
										i.disabled = 1 // Make it disabled first, otherwise disable_parts() won't work. Bit of a hacky way to do it, but eh.
										var/list/parts = list(i)
										player.disable_parts(parts,0,0,0)
										player.set_alert("[i] applied to [src]",i.icon,i.icon_state)
										player<<output("[i] applied to [src].","actionoutput")
										player.left_click_ref = null
										player.left_click_function = null
										player.cyborging=0
										i.overlays -= /obj/effects/select_item
										player.refresh_cyber(src)

									else
										player.set_alert("Not compaitable with that bodypart",'alert.dmi',"alert")
										//player.create_chat_entry("alerts","Not compaitable with that bodypart.")
										player.left_click_ref = null
										player.left_click_function = null
									if(player.client) winset(player,"body.label_cyber","text=\"Cybernetic slots: [src.cybernetics_current]/[src.cybernetics_max]\"")
									return
						//Handles cleanse
						if(player.skill_cleanse && player.skill_cleanse.active == 1 && player.skill_cleanse.active != 2 && player.upgrading == null)
							if(src in player.meridians)
								player << output("<font color = red>Unable to select meridians.","chat.system")
								player.set_alert("Unable to select meridians",'alert.dmi',"alert")
							//	player.create_chat_entry("alerts","Unable to select meridians.")
								return
							if(src in player.ascensions)
								player << output("<font color = red>Must select a bodypart.","chat.system")
								player.set_alert("Must select bodypart",'alert.dmi',"alert")
								//player.create_chat_entry("alerts","Must select bodypart.")
								return
							if(src in player.milestones)
								player << output("<font color = red>Must select a bodypart.","chat.system")
								player.set_alert("Must select bodypart",'alert.dmi',"alert")
								//player.create_chat_entry("alerts","Must select bodypart.")
								return
							if(src in player.soul)
								player << output("<font color = red>Must select a bodypart.","chat.system")
								player.set_alert("Must select bodypart",'alert.dmi',"alert")
							//	player.create_chat_entry("alerts","Must select bodypart.")
								return
							/*
							if(src.damaged || src.disabled)
								player << output("<font color = red>Bodypart must not be damaged or disabled.","chat.system")
								player.set_alert("Must select healthy bodypart",'alert.dmi',"alert")
								return
							*/
							if(src.infused_divine >= 1 || src.infused_dark >= 1 || src.infused_petrified >= 1)
								for(var/obj/skills/Meditate/med in player)
									if(med.active) call(med.act)(player,med)
								player.skill_cleanse.active = 2
								player.client.screen -= player.hud_body
								player.open_body = 0
								player.open_menus.Remove(".open_body")
								player.icon_state = "Meditate"
								player.Move(player.loc,SOUTH,player.step_x,player.step_y)
								player.stunned += 1
								player.stunned_pending += 1
								player.client.screen += player.skill_cleanse.bar
								player.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(255,255,255))
								player.cleansing = src
								player.filters -= filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(102,0,204))
								var/obj/effects/shockwave_medium/b = new
								b.loc = player.loc
								b.step_x = player.step_x
								b.step_y = player.step_y
								b.pixel_x = -80
								b.pixel_y = -74
								b.transform *= 0.1
								player.skill_cleanse.wave = b
								animate(b, transform = matrix()*1, alpha = 0, time = 3, loop = -1)
								animate(layer = b.layer, time = 7)
								animate(transform = matrix()*0.1,alpha = 255,time = 0)
							return
						//Handles divine infusion
						if(player.skill_divine_infusion && player.skill_divine_infusion.active == 1 && player.skill_divine_infusion.active != 2 && player.upgrading == null)
							if(src in player.meridians)
								player << output("<font color = red>Unable to select meridians.","chat.system")
								player.set_alert("Unable to select meridians",'alert.dmi',"alert")
								//player.create_chat_entry("alerts","Unable to select meridians.")
								return
							if(src in player.ascensions)
								player << output("<font color = red>Must select a bodypart.","chat.system")
								player.set_alert("Must select bodypart",'alert.dmi',"alert")
							//	player.create_chat_entry("alerts","Must select bodypart.")
								return
							if(player.race == "Android")
								player << output("<font color = red>No beings are able to manipulate Divine Energy so it clings to inorganic matter.","chat.system")
								player.set_alert("Divine Energy incompatible with inorganics",'alert.dmi',"alert")
							//	player.create_chat_entry("alerts","Divine Energy incompatible with inorganics.")
								return
							if(src in player.milestones)
								player << output("<font color = red>Must select a bodypart.","chat.system")
								player.set_alert("Must select bodypart",'alert.dmi',"alert")
							//	player.create_chat_entry("alerts","Must select bodypart.")
								return
							if(src in player.soul)
								player << output("<font color = red>Must select a bodypart.","chat.system")
								player.set_alert("Must select bodypart",'alert.dmi',"alert")
							//	player.create_chat_entry("alerts","Must select bodypart.")
								return
							if(istype(src,/obj/body_related/bodyparts/cybernetics/) == 1)
								player << output("<font color = red>Unable to fuse divine energy with cyberware.","chat.system")
								player.set_alert("Unable to fuse divine energy with cyberware",'alert.dmi',"alert")
							//	player.create_chat_entry("alerts","Unable to fuse divine energy with cyberware.")
								return
							if(src.damaged || src.disabled)
								player << output("<font color = red>Bodypart must not be damaged or disabled.","chat.system")
								player.set_alert("Must select healthy bodypart",'alert.dmi',"alert")
							//	player.create_chat_entry("alerts","Must select healthy bodypart.")
								return
							if(src.infused_divine < 1)
								for(var/obj/skills/Meditate/med in player)
									if(med.active) call(med.act)(player,med)
								player.skill_divine_infusion.active = 2
								player.client.screen -= player.hud_body
								player.open_body = 0
								player.open_menus.Remove(".open_body")
								player.icon_state = "Meditate"
								player.Move(player.loc,SOUTH,player.step_x,player.step_y)
								player.stunned += 1
								player.stunned_pending += 1
								player.client.screen += player.skill_divine_infusion.bar
								player.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(255,255,170))
								player.infusing = src
								player.filters -= filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(102,0,204))
							else
								player << output("<font color = red>[src] is already infused with divine energy.","chat.system")
								player.set_alert("Already infused with divine energy",src.icon,src.icon_state)
							//	player.create_chat_entry("alerts","Already infused with divine energy.")
							return
						//Handles dark petrifaction
						if(player.skill_dark_petrifaction && player.skill_dark_petrifaction.active == 1 && player.skill_dark_petrifaction.active != 2 && player.upgrading == null)
							if(src in player.meridians)
								player << output("<font color = red>Unable to select meridians.","chat.system")
								player.set_alert("Unable to select meridians",'alert.dmi',"alert")
							//	player.create_chat_entry("alerts","Unable to select meridians.")
								return
							if(src in player.ascensions)
								player << output("<font color = red>Must select a bodypart.","chat.system")
								player.set_alert("Must select bodypart",'alert.dmi',"alert")
							//	player.create_chat_entry("alerts","Must select bodypart.")
								return
							if(player.race == "Android" || istype(src,/obj/body_related/bodyparts/cybernetics/))
								player << output("<font color = red>Unable to petrify inorganics material.","chat.system")
								player.set_alert("Unable to petrify inorganics material",'alert.dmi',"alert")
							//	player.create_chat_entry("alerts","Unable to petrify inorganics material.")
								return
							if(src in player.milestones)
								player << output("<font color = red>Must select a bodypart.","chat.system")
								player.set_alert("Must select bodypart",'alert.dmi',"alert")
							//	player.create_chat_entry("alerts","Must select bodypart.")
								return
							if(src in player.soul)
								player << output("<font color = red>Must select a bodypart.","chat.system")
								player.set_alert("Must select bodypart",'alert.dmi',"alert")
							//	player.create_chat_entry("alerts","Must select bodypart.")
								return
							/*
							if(src.damaged || src.disabled)
								player << output("<font color = red>Bodypart must not be damaged or disabled.","chat.system")
								player.set_alert("Must select healthy bodypart",'alert.dmi',"alert")
								return
							*/
							if(src.infused_petrified < 1)
								for(var/obj/skills/Meditate/med in player)
									if(med.active) call(med.act)(player,med)
								player.skill_dark_petrifaction.active = 2
								player.client.screen -= player.hud_body
								player.open_body = 0
								player.open_menus.Remove(".open_body")
								player.icon_state = "Meditate"
								player.Move(player.loc,SOUTH,player.step_x,player.step_y)
								player.stunned += 1
								player.stunned_pending += 1
								player.client.screen += player.skill_dark_petrifaction.bar
								player.energy = 1
								player.infusing = src
								player.filters -= filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(102,0,204))

								player.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(0,0,0))
								player.skill_dark_petrifaction.mob_filter_pos = player.filters.len
								animate(player.filters[player.filters.len], size = 3,offset = 1, time = 20, loop = -1)
								animate(size = -4,offset = -4, time = 20, loop = -1)
							else
								player << output("<font color = red>[src] is already petrified with dark matter energy.","chat.system")
								player.set_alert("Already petrified with dark energy",src.icon,src.icon_state)
								//player.create_chat_entry("alerts","Already petrified with dark energy.")
							return
						//Handles dark infusion
						if(player.skill_dark_infusion && player.skill_dark_infusion.active == 1 && player.skill_dark_infusion.active != 2 && player.upgrading == null)
							if(src in player.meridians)
								player << output("<font color = red>Unable to select meridians.","chat.system")
								player.set_alert("Unable to select meridians",'alert.dmi',"alert")
							//	player.create_chat_entry("alerts","Unable to select meridians.")
								return
							if(src in player.ascensions)
								player << output("<font color = red>Must select a bodypart.","chat.system")
								player.set_alert("Must select bodypart",'alert.dmi',"alert")
								//player.create_chat_entry("alerts","Must select bodypart.")
								return
							if(src in player.milestones)
								player << output("<font color = red>Must select a bodypart.","chat.system")
								player.set_alert("Must select bodypart",'alert.dmi',"alert")
							//	player.create_chat_entry("alerts","Must select bodypart.")
								return
							if(src in player.soul)
								player << output("<font color = red>Must select a bodypart.","chat.system")
								player.set_alert("Must select bodypart",'alert.dmi',"alert")
							//	player.create_chat_entry("alerts","Must select bodypart.")
								return
							if(src.damaged || src.disabled)
								player << output("<font color = red>Bodypart must not be damaged or disabled.","chat.system")
								player.set_alert("Must select healthy bodypart",'alert.dmi',"alert")
							//	player.create_chat_entry("alerts","Must select healthy bodypart.")
								return
							if(src.infused_divine < 1)
								for(var/obj/skills/Meditate/med in player)
									if(med.active) call(med.act)(player,med)
								player.skill_dark_infusion.active = 2
								player.client.screen -= player.hud_body
								player.open_body = 0
								player.open_menus.Remove(".open_body")
								player.icon_state = "Meditate"
								player.Move(player.loc,SOUTH,player.step_x,player.step_y)
								player.stunned += 1
								player.stunned_pending += 1
								player.client.screen += player.skill_dark_infusion.bar
								player.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(0,0,0))
								player.infusing = src
								player.filters -= filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(102,0,204))
							else
								player << output("<font color = red>[src] is already infused with dark matter energy.","chat.system")
								player.set_alert("Already infused with dark energy",src.icon,src.icon_state)
							//	player.create_chat_entry("alerts","Already infused with dark energy.")
							return
						//Default selection of bodypart
						if(holder.hud_body)
							var/obj/hud/menus/bodyparts_background/h = holder.hud_body
							if(h.bodypart_icon && h.bodypart_icon.menu == h)

								if(holder.part_selected && holder.part_selected != holder.part_focus)
									var/obj/body_related/p = holder.part_selected
									p.underlays = null
									if(bodypart_underlay) bodypart_underlay.icon_state = "menu"
									p.underlays += bodypart_underlay

								holder.part_selected = src;
								h.show_parts(player)

								src.part_stats(holder,player)
								//player.refresh_cyber(src)

								player.body_exp_hp()
								player.skill_exp()

								holder.refresh_part_info(src)

								/*
								h.psiforge_xp.hud_y = src.hud_y
								var/matrix/mp = matrix()
								mp.Scale(50,1)
								mp.Translate(h.psiforge_xp.hud_x+25,h.psiforge_xp.hud_y+1)
								h.psiforge_xp.transform = mp
								h.bodypart_holder.vis_contents -= h.psiforge_xp
								h.bodypart_holder.vis_contents += h.psiforge_xp
								*/

						//Switch tab to "Info" when selecting cybertech
						//if(istype(src,/obj/body_related/bodyparts/cybernetics/) == 1) winset(player,"body.tab_body","current-tab=body_pane_info")

						if(src.hp > 100) src.hp = 100
						else if(src.hp < 0) src.hp = 0

						//if(src.status == "Functional") winset(player,"body.status_txt","text-color=#00FF00")
						//else winset(player,"body.status_txt","text-color=#FF0000")
						//winset(player,"body.status_txt","text=\"[src.status]\"")

						/*
						//For any Meridians
						if(istype(holder.part_selected,/obj/body_related/bodyparts/meridians/) && holder.part_selected.type != /obj/body_related/bodyparts/meridians/dantian)
							winset(player,"body.body_exp","value=0")
							winset(player,"body.button_train","text=\"Forge\"")
							winset(player,"body.button_train","is-disabled=true")
						//For any Soul parts
						else if(istype(holder.part_selected,/obj/body_related/soul/))
							if(holder.part_selected.level == 0 && holder.part_selected.can_unlock == 0) winset(player,"body.button_train","text=\"Rejected\"")
							else winset(player,"body.button_train","text=\"Unlock\"")
							if(holder.part_selected.can_unlock == 0) winset(player,"body.button_train","is-disabled=true")
						//For any Ascenion milestone parts
						else if(istype(holder.part_selected,/obj/body_related/ascension_milestones/))
							winset(player,"body.button_train","text=\"Unlock\"")
							if(holder.part_selected.can_unlock == 0) winset(player,"body.button_train","is-disabled=true")
						//For any Body milestone parts
						else if(istype(holder.part_selected,/obj/body_related/body_milestones/))
							winset(player,"body.button_train","text=\"Unlock\"")
							if(holder.part_selected.can_unlock == 0) winset(player,"body.button_train","is-disabled=true")
						//For everything else
						else if(istype(holder.part_selected,/obj/body_related/bodyparts/))
							//For Yukopian divine seed
							if(istype(holder.part_selected,/obj/body_related/bodyparts/torso/heart))
								if(holder.part_selected.info_name == "Divine Seed")
									winset(player,"body.button_misc","text=\"Plant\"")
									winset(player,"body.button_misc","is-visible=true")
									winset(player,"body.bar_hp","is-visible=true")
									winset(player,"body.label_hp","is-visible=true")
						else
							winset(player,"body.button_train","text=\"Unlock\"")
						*/
			set_part_color()
				if(src.disabled) src.txt_col = "grey"
				else if(src.hp >= 100) src.txt_col = "white"
				else if(src.hp <= 33) src.txt_col = "red"
				else if(src.hp <= 66) src.txt_col = "#DF7126"
				else if(src.hp < 100) src.txt_col = "#DCD42F"
				src.maptext = "[css_outline]<font size = 1><left><font color = [src.txt_col]>[src.info_name]"
			part_stats(var/mob/m,var/mob/interfacer)
				if(interfacer == null) interfacer = m
				var/obj/hud/menus/bodyparts_background/h = m.hud_body
				var/part_stats = null
				if(m.part_selected)
					//Deals with the growing of a body for psionic realm beings
					if(istype(m.part_selected,/obj/body_related/ascension_milestones/whole_body))
						var/N = m.total_organs
						var/N_grown = 0
						for(var/obj/body_related/bodyparts/p1 in m.body)
							for(var/obj/body_related/bodyparts/p2 in p1)
								N_grown += 1
						if(N > 0)
							if(m.client)
								m.part_selected.part_exp = (100/N)*N_grown
								h.part_req.maptext = "[css_outline]<font size = 1><text align=left valign=top>Bodyparts grown [N_grown]/[N]"
								m.hud_body.max_scroll_reqs = 32
								if(N_grown >= N && m.part_selected.level <= 0) m.part_selected.can_unlock = 1
					//Deals with the DARK BODY ascension and displaying what is needed to unlock it
					else if(istype(m.part_selected,/obj/body_related/ascension_milestones/dark_body))
						var/N = m.total_organs
						var/N_infused = 0
						for(var/obj/body_related/bodyparts/p1 in m.body)
							for(var/obj/body_related/bodyparts/p2 in p1)
								if(p2.infused_dark) N_infused += 1
						if(N > 0)
							if(m.client)
								m.part_selected.part_exp = (100/N)*N_infused
								h.part_req.maptext = "[css_outline]<font size = 1><text align=center valign=top>Bodyparts infused with Dark Matter [N_infused]/[N]"
								m.hud_body.max_scroll_reqs = 32
								if(N_infused >= N && m.part_selected.level <= 0) m.part_selected.can_unlock = 1
								//m.part_selected.can_unlock = 1
								//Stops body-type ascensions stacking
								for(var/obj/body_related/a in m.ascensions)
									if(a.ascension_type == "body" && a.level > 0)
										m.part_selected.can_unlock = 0
					//Deals with the DIVINE BODY ascension and displaying what is needed to unlock it
					else if(istype(m.part_selected,/obj/body_related/ascension_milestones/divine_body))
						var/N = m.total_organs
						var/N_infused = 0
						for(var/obj/body_related/bodyparts/p1 in m.body)
							for(var/obj/body_related/bodyparts/p2 in p1)
								if(p2.infused_divine) N_infused += 1
						if(N > 0)
							if(m.client)
								m.part_selected.part_exp = (100/N)*N_infused
								h.part_req.maptext = "[css_outline]<font size = 1><text align=center valign=top>Bodyparts infused with Divine Energy [N_infused]/[N]"
								m.hud_body.max_scroll_reqs = 32
								if(N_infused >= N && m.part_selected.level <= 0) m.part_selected.can_unlock = 1
								//m.part_selected.can_unlock = 1
								//Stops body-type ascensions stacking
								for(var/obj/body_related/a in m.ascensions)
									if(a.ascension_type == "body" && a.level > 0)
										m.part_selected.can_unlock = 0
					//Deals with the PETRIFIED BODY ascension and displaying what is needed to unlock it
					else if(istype(m.part_selected,/obj/body_related/ascension_milestones/petrified_body))
						var/N = m.total_organs
						var/N_infused = 0
						for(var/obj/body_related/bodyparts/p1 in m.bodyparts)
							for(var/obj/body_related/bodyparts/p2 in p1)
								if(p2.infused_petrified) N_infused += 1
						if(N > 0)
							if(m.client)
								m.part_selected.part_exp = (100/N)*N_infused
								h.part_req.maptext = "[css_outline]<font size = 1><text align=center valign=top>Bodyparts petrified with Dark Matter [N_infused]/[N]"
								m.hud_body.max_scroll_reqs = 32
								if(N_infused >= N && m.part_selected.level <= 0) m.part_selected.can_unlock = 1
								//m.part_selected.can_unlock = 1
								//Stops body-type ascensions stacking
								for(var/obj/body_related/a in m.ascensions)
									if(a.ascension_type == "body" && a.level > 0)
										m.part_selected.can_unlock = 0
					//Deals with the divine MIND ascension and displaying what is needed to unlock it
					else if(istype(m.part_selected,/obj/body_related/ascension_milestones/divine_mind))
						var/N = 750
						var/skill_total = 0
						for(var/obj/skills/s in m)
							skill_total += s.skill_lvl
						if(skill_total > 0 && m.client)
							m.part_selected.part_exp = (100/N)*skill_total
							h.part_req.maptext = "[css_outline]<font size = 1><text align=center valign=top>Total combined skill levels [skill_total]/[N]"
							m.hud_body.max_scroll_reqs = 32
							if(skill_total >= N && m.part_selected.level <= 0) m.part_selected.can_unlock = 1
					//Deals with the BALANCED SOUL ascension and displaying what is needed to unlock it
					else if(istype(m.part_selected,/obj/body_related/ascension_milestones/balanced_soul))
						var/N_infused = 0
						var/nir = 0
						for(var/obj/body_related/soul/p1 in m.soul)
							if(p1.level > 0)
								if(p1.type == /obj/body_related/soul/nirvana) nir = 1
								else N_infused += 1
						m.part_selected.part_exp = (100/7)*N_infused
						if(m.part_selected.level <= 0)
							if(N_infused >= 7) m.part_selected.can_unlock = 1
							else if(nir)
								m.part_selected.can_unlock = 1
								m.part_selected.part_exp = 100
						//Stops soul-type ascensions stack
						for(var/obj/body_related/a in m.ascensions)
							if(a.ascension_type == "soul" && a.level > 0)
								m.part_selected.can_unlock = 0
						if(m.client)
							h.part_req.maptext = "[css_outline]<font size = 1><text align=center valign=top>Sins/Virtues accepted [N_infused]/7\n\nOr Nirvana embraced [nir]/1"
							m.hud_body.max_scroll_reqs = 32
					//Deals with the DIVINE SOUL ascension and displaying what is needed to unlock it
					else if(istype(m.part_selected,/obj/body_related/ascension_milestones/divine_soul))
						var/N_infused = 0
						for(var/obj/body_related/soul/virtues/p1 in m.soul)
							if(p1.level > 0) N_infused += 1
						m.part_selected.part_exp = (100/7)*N_infused
						if(N_infused >= 7 && m.part_selected.level <= 0) m.part_selected.can_unlock = 1
						//Stops soul-type ascensions stacking
						for(var/obj/body_related/a in m.ascensions)
							if(a.ascension_type == "soul" && a.level > 0)
								m.part_selected.can_unlock = 0
						if(m.client)
							h.part_req.maptext = "[css_outline]<font size = 1><text align=left valign=top>Virtues accepted [N_infused]/7"
							m.hud_body.max_scroll_reqs = 32
					//Deals with the DARK SOUL ascension and displaying what is needed to unlock it
					else if(istype(m.part_selected,/obj/body_related/ascension_milestones/dark_soul))
						var/N_infused = 0
						for(var/obj/body_related/soul/sins/p1 in m.soul)
							if(p1.level > 0) N_infused += 1
						m.part_selected.part_exp = (100/7)*N_infused
						if(N_infused >= 7 && m.part_selected.level <= 0) m.part_selected.can_unlock = 1
						//Stops soul-type ascensions stacking
						for(var/obj/body_related/a in m.ascensions)
							if(a.ascension_type == "soul" && a.level > 0)
								m.part_selected.can_unlock = 0
						if(m.client)
							h.part_req.maptext = "[css_outline]<font size = 1><text align=left valign=top>Sins accepted [N_infused]/7"
							m.hud_body.max_scroll_reqs = 32
					//Deals with the LICHDOM ascension and displaying what is needed to unlock it
					else if(istype(m.part_selected,/obj/body_related/ascension_milestones/lichdom))
						var/N = 0
						var/N_rdy = 0
						var/P = 0
						var/obj/body_related/part = m.part_selected
						for(var/obj/items/consumables/spirit_stone/s in m)
							if(s.infused == 2)
								N_rdy += 1
								part.steps[1] = 1
								P = 1
						if(part_stats == null)
							if(P) part_stats = "Phylactery obtained 1/1"
							else part_stats = "Phylactery obtained 0/1"
						else
							if(P) part_stats = "[part_stats]\n\nPhylactery obtained 1/1"
							else part_stats = "[part_stats]\n\nPhylactery obtained 0/1"
						if(part.major_ascension)
							for(var/obj/body_related/a1 in m.ascensions)
								for(var/x in part.needed_parts)
									if(a1.type == x)
										N += 1
										part_stats = "[part_stats]\n\n[a1] [a1.level]/[part.needed_lvl]"
										if(a1.level > 0) N_rdy += 1
							//for(var/x in part.needed_parts)
								//if(istext(x)) part_stats = "[part_stats]\n \n[x]"
							var/N_exp = 0
							if(N) N_exp = (100/N)*N_rdy
							if(N_exp >= 100 && m.part_selected.level <= 0) m.part_selected.can_unlock = 1
							//m.part_selected.can_unlock = 1
							if(m.client)
								h.part_req.maptext = "[css_outline]<font size = 1><text align=left valign=top>[part_stats]"
								m.hud_body.max_scroll_reqs = 32
					//Deals with the generic divine ascensions and displaying what is needed to unlock it
					else if(istype(m.part_selected,/obj/body_related/ascension_milestones/))
						var/N = 0
						var/N_rdy = 0
						var/obj/body_related/part = m.part_selected
						if(part.major_ascension)
							for(var/obj/body_related/a1 in m.ascensions)
								for(var/x in part.needed_parts)
									//if(istext(x)) part_stats = "[part_stats]\n \n[x]"
									if(a1.type == x)
										N += 1
										m.hud_body.max_scroll_reqs += 18
										//var/obj/o = x
										//if(o.type == a1.type)
										//if(a1.type in part.needed_parts)
										//if(part_stats == null) part_stats = "\n \n[a1] [a1.level]/[part.needed_lvl]"
										//else part_stats = "[part_stats]\n \n[a1] [a1.level]/[part.needed_lvl]"
										if(part_stats == null) part_stats = "[a1] [a1.level]/[part.needed_lvl]"
										else part_stats = "[part_stats]\n\n[a1] [a1.level]/[part.needed_lvl]"
										if(a1.level > 0) N_rdy += 1
							for(var/x in part.needed_parts)
								if(istext(x)) part_stats = "[part_stats]\n\n[x]"
							var/N_exp = 0
							if(N) N_exp = (100/N)*N_rdy
							if(N_exp >= 100 && m.part_selected.level <= 0) m.part_selected.can_unlock = 1
							if(m.client)
								h.part_req.maptext = "[css_outline]<font size = 1><text align=left valign=top>[part_stats]"
					//Deals with the body milestones and displaying what is needed to unlock them
					else if(istype(m.part_selected,/obj/body_related/body_milestones/))
						var/obj/body_related/part = m.part_selected
						var/L = 1
						if(part.needed_parts) L = length(part.needed_parts)
						var/N = 100/L
						var/N_true = 0
						var/N_current = 0
						var/col
						m.hud_body.max_scroll_reqs = 0
						if(part.level != part.lvl_max)
							for(var/p1 in part.needed_parts)
								for(var/obj/body_related/bodyparts/meridians/d in m.meridians)
									if(d.type == p1)
										col = "<font color = white>"
										m.hud_body.max_scroll_reqs += 18
										if(d.level >= part.needed_lvl)
											N_current += N
											N_true += 1
											col = "<font color = green>"
										if(part_stats == null) part_stats = "[col][d] [d.level]/[part.needed_lvl]</font>"
										else part_stats = "[part_stats]\n\n[col][d] [d.level]/[part.needed_lvl]</font>"
								for(var/obj/body_related/bodyparts/p2 in m.bodyparts)
									for(var/obj/body_related/bodyparts/p3 in p2)
										if(p3.type == p1)
											col = "<font color = white>"
											m.hud_body.max_scroll_reqs += 18
											if(p3.level >= part.needed_lvl)
												N_current += N
												N_true += 1
												col = "<font color = green>"
											if(part_stats == null) part_stats = "[col][p3] [p3.level]/[part.needed_lvl]</font>"
											else part_stats = "[part_stats]\n\n[col][p3] [p3.level]/[part.needed_lvl]</font>"
						if(N_true >= L) part.can_unlock = 1
						if(m.client)
							h.part_req.maptext = "[css_outline]<font size = 1><text align=left valign=top>[part_stats]"

				part_stats = null

				var/part_trained = "Current Training<font color = green>"

				var/list/buffs = list()

				//First unlock is correct, shows 200, which is 100 x mod of 1 + part mod of 1


				//src.psi_gain = (m.training_pp+m.bodypart_pp+src.psi_gain_base)*(m.mod_psionic_power+src.psi_mod_gain)
				src.psi_gain = src.psi_gain_base*(m.mod_psionic_power+src.psi_mod_gain)
				src.eng_gain = src.eng_gain_base*(m.mod_energy+src.eng_mod_gain)
				src.str_gain = src.str_gain_base*m.mod_strength
				src.end_gain = src.end_gain_base*m.mod_endurance
				src.res_gain = src.res_gain_base*m.mod_resistance
				src.force_gain = src.force_gain_base*m.mod_force
				src.off_gain = src.off_gain_base*m.mod_offence
				src.def_gain = src.def_gain_base*m.mod_defence
				src.int_gain = src.int_gain_base
				src.divine_eng_gain = src.divine_eng_gain_base*m.divine_energy_mod
				src.dark_matter_gain = src.dark_matter_gain_base*m.dark_matter_mod

				if(m.part_selected == src)
					//Determine energy mod gain and max energy gains from bodypart, visually. Takes into account parts without mod gains, so rewards aren't calculated based on bodypart pp/eng.
					if(src.eng_mod_gain > 0)
						buffs += "+ [src.eng_mod_gain]% Energy Mod"
					if(src.eng_gain > 0 && src.eng_mod_gain > 0)
						buffs += "+ [Commas(src.eng_gain+m.energy_max)]% Max Energy"
						part_trained = "[part_trained]\n[Commas(src.eng_gain_base*m.mod_energy*src.level)]% Max Energy"
					else if(src.eng_gain > 0)
						buffs += "+ [Commas(src.eng_gain)]% Max Energy"
						part_trained = "[part_trained]\n[Commas(src.eng_gain_base*m.mod_energy*src.level)]% Max Energy"
					//Determine psionic mod gain and max psionic gains from bodypart, visually. Takes into account parts without mod gains, so rewards aren't calculated based on bodypart pp/eng.
					if(src.psi_mod_gain > 0)
						buffs += "+ [src.psi_mod_gain]% Power Mod"
					if(src.psi_gain > 0 && src.psi_mod_gain > 0)
						buffs += "+ [Commas(src.psi_gain+m.gains_trained_power + m.gains_psiforged_power + m.gains_items_power + m.gains_temp_power)]% Power"
						part_trained = "[part_trained]\n[Commas(src.psi_gain_base*m.mod_psionic_power*src.level)]% Power"
					else if(src.psi_gain > 0)
						buffs += "+ [Commas(src.psi_gain)]% Power"
						part_trained = "[part_trained]\n[Commas(src.psi_gain_base*m.mod_psionic_power*src.level)]% Power"
					//Determines other stat gains.
					if(src.divine_eng_gain > 0)
						buffs += "+ [src.divine_eng_gain] Divine Energy"
						part_trained = "[part_trained]\n[src.divine_eng_gain*src.level] Divine Energy"
					if(src.dark_matter_gain > 0)
						buffs += "+ [src.dark_matter_gain] Dark Energy"
						part_trained = "[part_trained]\n[src.dark_matter_gain*src.level] Dark Matter"
					if(src.str_gain > 0)
						buffs += "+ [Commas(src.str_gain)]% Strength"
						part_trained = "[part_trained]\n[Commas(src.str_gain*src.level)]% Strength"
					if(src.end_gain > 0)
						buffs += "+ [Commas(src.end_gain)]% Endurance"
						part_trained = "[part_trained]\n[Commas(src.end_gain*src.level)]% Endurance"
					if(src.spd_mod_gain > 0)
						buffs += "+ [src.spd_mod_gain]% Agility"
						part_trained = "[part_trained]\n[src.spd_mod_gain*src.level]% Agility"
					if(src.res_gain > 0)
						buffs += "+ [Commas(src.res_gain)]% Resistance"
						part_trained = "[part_trained]\n[Commas(src.res_gain*src.level)]% Resistance"
					if(src.force_gain > 0)
						buffs += "+ [Commas(src.force_gain)]% Force"
						part_trained = "[part_trained]\n[Commas(src.force_gain*src.level)]% Force"
					if(src.off_gain > 0)
						buffs += "+ [Commas(src.off_gain)]% Offence"
						part_trained = "[part_trained]\n[Commas(src.off_gain*src.level)]% Offence"
					if(src.def_gain > 0)
						buffs += "+ [Commas(src.def_gain)]% Defence"
						part_trained = "[part_trained]\n[Commas(src.def_gain*src.level)]% Defence"
					if(src.regen_mod_gain > 0)
						buffs += "+ [src.regen_mod_gain]% Regeneration"
						part_trained = "[part_trained]\n[src.regen_mod_gain*src.level]% Regeneration"
					if(src.recov_mod_gain > 0)
						buffs += "+ [src.recov_mod_gain]% Recovery"
						part_trained = "[part_trained]\n[src.recov_mod_gain*src.level]% Recovery"
					if(src.int_gain > 0)
						buffs += "+ [Commas(src.int_gain)]% Intelligence"
						part_trained = "[part_trained]\n[Commas(src.int_gain*src.level)]% Intelligence"
					if(src.lifespan_gain > 0)
						buffs += "+ [Commas(src.lifespan_gain)]% Lifespan"
						part_trained = "[part_trained]\n[Commas(src.lifespan_gain*src.level)]% Lifespan"
					if(src.gain_txt)
						buffs += "[src.gain_txt]"
					if(src.rads_gain > 0)
						buffs += "+ [src.rads_gain]% Radiation Tolerance"
						part_trained = "[part_trained]\n[src.rads_gain*src.level]% Radiation Tolerance"
					if(src.cold_gain > 0)
						buffs += "+ [src.cold_gain]% Cold Tolerance"
						part_trained = "[part_trained]\n[src.cold_gain*src.level]% Cold Tolerance"
					if(src.heat_gain > 0)
						buffs += "+ [src.heat_gain]% Heat Tolerance"
						part_trained = "[part_trained]\n[src.heat_gain*src.level]% Heat Tolerance"
					if(src.gravity_gain > 0)
						buffs += "+ [src.gravity_gain]% Gravity Tolerance"
						part_trained = "[part_trained]\n[src.gravity_gain*src.level]% Gravity Tolerance"
					if(src.micro_gain > 0)
						buffs += "+ [src.micro_gain] Microwave Tolerance"
						part_trained = "[part_trained]\n[src.micro_gain*src.level] Microwave Tolerance"
					if(src.toxin_gain > 0)
						buffs += "+ [src.toxin_gain]% Toxin Tolerance"
						part_trained = "[part_trained]\n[src.toxin_gain*src.level]% Toxin Tolerance"
					if(src.divine_mod_gain > 0)
						buffs += "+ [src.divine_mod_gain]% Divine Energy Mod"
					if(src.dark_matter_mod_gain > 0)
						buffs += "+ [src.dark_matter_mod_gain]% Dark Energy Mod"
					if(src.o2_gain > 0)
						buffs += "+ [src.o2_gain]% Max Oxygen"
						part_trained = "[part_trained]\n[src.o2_gain*src.level]% Max Oxygen"

					//Calculate what the part gives and display it
					for(var/t in buffs)
						if(part_stats == null) part_stats = "[t]"
						else part_stats = "[part_stats]\n[t]"

					if(m.client)
						if(m.hud_body)
							if(h.bodypart_icon && h.bodypart_icon.menu == h)
								h.part_stats.maptext = "[css_outline]<font size = 1><text align=left valign=top>Training Results\n<font color = green>[part_stats]"

					//Calculate what the part has already given and display it
					if(m.client)
						if(m.hud_body)
							if(h.bodypart_icon && h.bodypart_icon.menu == h)
								h.part_stats_trained.maptext = "[css_outline]<font size = 1><text align=left valign=top>[part_trained]"

			part_reward(var/mob/m,var/xp = 1,var/mob/interfacer,var/group_msg_together = 0)
				if(m.has_body == 0 && src.type != /obj/body_related/bodyparts/meridians/dantian) return
				if(src.damaged || src.disabled) return
				if(interfacer == null) interfacer = m
				var/exp = (src.part_exp_num*(xp/100))*m.psiforging_speed
				src.part_exp += exp
				//Levels up and rewards for BODY MILESTONES
				if(istype(src,/obj/body_related/body_milestones/))
					src.needed_lvl += 100
					src.part_multi += 0.1
					src.part_exp = 100
					src.can_unlock = 0
					m.refresh_part_info(src)
				//Levels up and rewards for SOUL
				else if(istype(src,/obj/body_related/soul/))
					src.needed_lvl += 100
					src.part_multi += 0.1
					src.part_exp = 100
					src.can_unlock = 0
					m.RP_Points -= src.needed_rp
					src.icon_state = "[src.icon_state] unlocked"
					var/reject_all = 0
					var/reject_nirvana = 0
					if(istype(src,/obj/body_related/soul/nirvana)) reject_all = 1
					else reject_nirvana = 1
					for(var/obj/body_related/soul/s in m.soul)
						if(s.type == src.counters || reject_all)
							s.can_unlock = 0
						if(reject_nirvana && istype(s,/obj/body_related/soul/nirvana))
							s.can_unlock = 0
					m.refresh_part_info(src)
				//Levels up and rewards for ASCENSIONS
				else if(istype(src,/obj/body_related/ascension_milestones/))
					src.part_multi += 0.1
					src.part_exp = 100
					src.can_unlock = 0
					//Special Code for unlocking specific ascensions
					if(istype(src,/obj/body_related/ascension_milestones/celestial_ascension))
						m.filters = null
						if(m.gen == "Male")
							m.icon = 'Celestial_Base_Male_Ascended.dmi'
							if(m.port)
								m.set_icon(m,1)
								m.key_save()
								m.client.screen += m.port
						else if(m.gen == "Female")
							m.icon = 'Celestial_Base_Female_Ascended.dmi'
							if(m.port)
								m.set_icon(m,1)
								m.key_save()
								m.client.screen += m.port
						if(m.halo)
							m.overlays -= m.halo
							m.halo.icon = 'halo.dmi'
						m.redraw_appearance()
						m.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(255,204,0))
						if(m.hud_hud)
							m.hud_hud.filters = null
							m.hud_hud.filters += filter(type="outline",size=1, color=rgb(255,204,0))
							m.hud_hud.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(255,204,0))
					if(istype(src,/obj/body_related/ascension_milestones/human_ascension))
						var/obj/o = new
						o.icon = 'divine elec.dmi'
						o.appearance_flags = KEEP_APART
						o.layer = 10
						m.overlays += o
						m.divine_elec = o
					if(istype(src,/obj/body_related/ascension_milestones/divine_body))
						if(m.race != "Namekian")
							m.filters += filter(type="outline",size=1, color=rgb(255,255,170))
							m.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(255,255,170))
							if(m.hud_hud)
								m.hud_hud.filters += filter(type="outline",size=1, color=rgb(255,255,170))
								m.hud_hud.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(255,255,170))
							m.vis_contents += new/obj/effects/divine_energy
						//For Celestial, make this change their body to gold
						//For humans, make them have a golden hue over their forms
					if(istype(src,/obj/body_related/ascension_milestones/lichdom))
						m.open_close_eyes(1)
						m.icon = 'Lich_Base.dmi'
						m.lifespan = 1.#INF
						m.oldage = 1.#INF
						m.mod_immune_cold += 1
						m.mod_immune_rads += 1
						m.mod_immune_heat -= 0.5
						m.immune_cold_psiforged += 1
						m.immune_rads_psiforged += 1
						m.immune_heat_psiforged -= 0.5
						m.has_stomach = 0
						m.need_o2 = "No"
						m.need_food = "No"
						m.need_water = "No"
						m.need_sleep = "No"
						if(m.eyes)
							m.vis_contents -= m.eyes
							m.eyes = null
						if(m.eyes_white)
							m.vis_contents -= m.eyes_white
							m.eyes_white = null
						if(m.hair)
							m.overlays -= m.hair
							m.hair = null
						for(var/obj/body_related/bodyparts/p1 in m.bodyparts)
							for(var/obj/body_related/bodyparts/p2 in p1)
								p2.disabled_perma = 0
						for(var/obj/a in m.afterimages)
							a.icon = m.icon
						if(m.port)
							m.port.icon = 'portrait_lich.dmi'
							m.port.icon_state = "skin3"
							for(var/obj/portrait/p in m.port)
								m.port.vis_contents -= p
								p.p_owner = null
								p.destroy()
							m.key_save()
						for(var/obj/items/consumables/spirit_stone/s in m)
							if(s.infused == 2)
								s.infused = 3
								s.disable_logout = 1
								s.can_pocket = 0
								s.fused_key = m.key
								s.fused_name = m.real_name
								s.fused_id = m.id
								m.drop(s)
								//if(!items.Find(s)) items += s
								//world.Save_objs()
					m.refresh_part_info(src)
				//Levels up and rewards for BODY PARTS
				if(src.part_exp >= 100)
					//m.check_quest("tutorial_psiforge",1)


					//The idea here is to re-calculate the reward for the part, since the player might be buffed. Otherwise when they revert from their buff, they might lose stats forever.
					src.psi_gain = src.psi_gain_base
					src.eng_gain = src.eng_gain_base
					src.str_gain = src.str_gain_base*m.mod_strength
					src.end_gain = src.end_gain_base*m.mod_endurance
					src.res_gain = src.res_gain_base*m.mod_resistance
					src.force_gain = src.force_gain_base*m.mod_force
					src.off_gain = src.off_gain_base*m.mod_offence
					src.def_gain = src.def_gain_base*m.mod_defence
					src.divine_eng_gain = src.divine_eng_gain_base*m.divine_energy_mod
					src.dark_matter_gain = src.dark_matter_gain_base*m.dark_matter_mod

					var/lvled = 0
					if(src.part_exp > 10000) src.part_exp = 10000
					var/lvls = round(src.part_exp/100)

					if(src.type == /obj/body_related/bodyparts/meridians/dantian)
						m.lvl_typesof_bodypart(null,src.part_exp,0,1)
					src.part_exp -= round(lvls*100)
					src.part_exp_num -= 0.002*lvls
					if(src.part_exp_num <= 0.2) src.part_exp_num = 0.2
					if(src.level < 1000)
						lvled = 1
						src.level += 1*lvls
						m.milestonecurrent_lvls +=1


						//src.part_stats(m) //Recalculate the right mod info. So player doesn't unbuff and get more stats than intended.
						if(src.psi_mod_gain > 0)
							m.gains_psiforged_power_mod += src.psi_mod_gain*lvls
							m.mod_psionic_power += src.psi_mod_gain*lvls
						if(src.psi_gain > 0) m.gains_psiforged_power += src.psi_gain_base*lvls
						if(src.eng_mod_gain > 0)
							m.gains_psiforged_energy_mod += src.eng_mod_gain*lvls
							m.mod_energy += src.eng_mod_gain*lvls
						if(src.eng_gain > 0) m.gains_psiforged_energy += src.eng_gain_base*lvls
						//Continue adding normal stats here.
						if(src.divine_eng_gain > 0) m.divine_energy += src.divine_eng_gain*lvls
						if(src.dark_matter_gain > 0) m.dark_matter += src.dark_matter_gain*lvls
						if(src.str_gain > 0)
							m.gains_psiforged_strength += src.str_gain_base*lvls
							m.strength += src.str_gain*lvls
						if(src.spd_mod_gain > 0)
							m.gains_psiforged_agility_mod += src.spd_mod_gain*lvls
							m.mod_agility += src.spd_mod_gain*lvls
						if(src.end_gain > 0)
							m.gains_psiforged_endurance += src.end_gain_base*lvls
							m.endurance += src.end_gain*lvls
						if(src.res_gain > 0)
							m.gains_psiforged_resistance += src.res_gain_base*lvls
							m.resistance += src.res_gain*lvls
						if(src.force_gain > 0)
							m.gains_psiforged_force += src.force_gain_base*lvls
							m.force += src.force_gain*lvls
						if(src.off_gain > 0)
							m.gains_psiforged_off += src.off_gain_base*lvls
							m.offence += src.off_gain*lvls
						if(src.def_gain > 0)
							m.gains_psiforged_def += src.def_gain_base*lvls
							m.defence += src.def_gain*lvls
						if(src.regen_mod_gain > 0)
							m.gains_psiforged_regen_mod += src.regen_mod_gain*lvls
							m.mod_regeneration += src.regen_mod_gain*lvls
						if(src.recov_mod_gain > 0)
							m.gains_psiforged_recov_mod += src.recov_mod_gain*lvls
							m.mod_recovery += src.recov_mod_gain*lvls
						if(src.lifespan_gain > 0)
							m.lifespan += src.lifespan_gain*lvls
							//m.check_quest("tutorial_lifespan",1)
							m.set_decline()
						if(src.rads_gain > 0)
							m.mod_immune_rads += src.rads_gain*lvls
							m.immune_rads_psiforged += src.rads_gain*lvls
						if(src.cold_gain > 0)
							m.mod_immune_cold += src.cold_gain*lvls
							m.immune_cold_psiforged += src.cold_gain*lvls
						if(src.heat_gain > 0)
							m.mod_immune_heat += src.heat_gain*lvls
							m.immune_heat_psiforged += src.heat_gain*lvls
						if(src.toxin_gain > 0)
							m.mod_immune_toxins += src.toxin_gain*lvls
							m.immune_toxins_psiforged += src.toxin_gain*lvls
						if(src.micro_gain > 0)
							m.mod_immune_microwaves += src.micro_gain*lvls
							m.immune_microwaves_psiforged += src.micro_gain*lvls
						if(src.gravity_gain > 0)
							m.mod_immune_gravity += src.gravity_gain*lvls
							m.immune_gravity_psiforged += src.gravity_gain*lvls
						if(src.divine_mod_gain > 0) m.divine_energy_mod += src.divine_mod_gain*lvls
						if(src.dark_matter_mod_gain > 0) m.dark_matter_mod += src.dark_matter_mod_gain*lvls
						if(src.o2_gain > 0)
							m.o2_max += src.o2_gain*lvls
							m.gains_psiforged_o2 += src.o2_gain*lvls
					if(lvled && group_msg_together == 0) src.skill_up(m)

					m.refresh_part_info(src)
					//m.check_quest("lvl_bodypart",1,0,1)
					//m.check_quest("lvl_bodypart_specific",1,0,1,src)
					if(m.milestonecurrent_lvls >= m.max_milestonecurrent_lvls)
						m.milestonecurrent_lvls = 0
						m.client.screen -= m.hud_body
						m.open_body = 0
						for(var/obj/hud/h in m.milestone_hud)
							if(m.client) m.client.screen -= h
						m.milestone_checked = 0
		soul
			/*
			.:The Psionic Conflux:.
			As more and more thinking, feeling creatures evolve over time and reach sentience, a convergance of psionic brain waves gather into a nacent form in the space between spaces.
			This great Psionic stream pools slowly into higher dimensional space, just the same as gravity slowly bleeds into the space between universe membranes.
			From this rolling, primal storm of unbridled, untapped power is the potential for one to ascend to even higher states of godhood.

			- Player becomes aware of the Psionic Conflux once they unlock their first ascension
			- Been needing a way for players who ascend to gain more power and have another goal.
			- That new, higher goal could be tapping into a special universal cache of Psionic Power thats been sitting/building in the universe.
			- The idea is that a little bit of psionic power pools and collects into this cache every few months. Perhaps faster from players doing certain things?
			- Perhaps more Psionic power the more players that ascend also? This would encourage gods to help mortals ascend.
			- The more gods, the more excess psionic power is created?
			- Have the soul itself be an upgradeable part, and keep the other sins/virtues as part of the system

			.:What it gives in game:.

			For every upgrade of the soul, once ascended, have an option to do something fun

			- Convert a lump sum into lifespan
			- Convert a lump sum into resources
			- Convert a lump sum into a new mortal form, like the god emperor of mankind style and reincarnate
			- Convert a lump sum into divine energy
			- Convert a lump sum into dark matter
			- Convert a lump sum into a special spirit stone made from concentrated psionic power, which increases psionic power mod when absorbed
			- Convert a lump sum into a special follower made from psionic power
			- Convert a lump sum into a weapon
			- Add more psionic power to the pool
			- Convert a lump sum into a translocation stone, which lets you teleport once anywhere
			- Convert a lump sum into a permanment upgrade to a bodypart, allowing player to select a stat which is added to that part
			- Convert a lump sum into energy
			- Convert a lump sum into granting someone all their body parts as a Celestial/Demon
			- Convert a lump sum into infusing someones body parts with divine/dark energy in one burst
			- Convert a lump sum into lowering the cost of leveling the soul

			*/
			icon = 'bodybits.dmi'
			icon_state = "soul"
			level = 0
			lvl_max = 1
			needed_lvl = 1
			needed_rp = 10
			can_unlock = 1
			cybernetics_max = 0
			plane = 22
			layer = 35
			MouseWheel(delta_x,delta_y,location,control,params)
				var/obj/hud/menus/bodyparts_background/s = usr.hud_body
				var/obj/sc = s.scroller_p
				usr.check_mouse_loc(params)
				var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
				usr.mouse_y_true = true_y
				var/wheel_move = 0
				if(delta_y > 0) wheel_move = 16
				else if(delta_y < 0) wheel_move = -16
				var/result = sc.translated_y+wheel_move
				result = clamp(result,0,-169)
				var/matrix/m = matrix()
				m.Translate(0,result)
				sc.transform = m
				sc.translated_y = result

				var/ratio = -1 + ((-169 + result) / -169)
				ratio = clamp(ratio,0,1)
				var/scroll_y = round(s.max_scroll_parts*ratio)//760*ratio)

				for(var/obj/txt in s.bodypart_holder.vis_contents)
					var/matrix/m2 = matrix()
					m2.Translate(txt.hud_x,txt.hud_y+scroll_y)
					txt.transform = m2
				if(s.area_selected)
					s.area_selected.scroller_transform = m
					s.area_selected.scroller_translated = result
					s.area_selected.parts_transform = scroll_y
			the_soul
				info_name = "Soul"
				icon_state = "realm"
				eng_gain_base = 100
				info = "This is the sumtotal of your soul, your immortal spirit and the divine spark nestled in all beings. Within lies multifaceted aspects of your nature, powered by lashes of psionic waves produced by your mind. It is utterly invulnerable, both physically and spiritually and remains nesteled in higher dimensional vibrational space, tethered to your form by silver umbilical cord. As you ascend, the mysteries of the spirit will reveal themselves to you."
				can_unlock = 0
			consumption
				//Lets you use absorb to consume others, giving you xp toward this soul unlock, and also lifespan.
				//Possibly lets you gain in a random stat, based on who you absorb?
				info_name = "Consumption"
				icon_state = "enfeeble"
				eng_gain_base = 100
				info = "Eat the souls of other beings to empower your own. Consume their very essence to help fill your divine furance. Devour until satiated and bristling with godly energy. A slower method to cultivate ones soul than other means, but offers versatile rewards and great power."
			enfeeble
				info_name = "Enfeeble"
				icon_state = "enfeeble"
				eng_gain_base = 100
				info = "Weaken the soul, preparing it for its fated transference to another vessel. The path to Lichdom and immortality demands the soul be loosened, as to be easily pried and placed inside a phylactery."
			nirvana
				info_name = "Nirvana"
				icon_state = "nirvana"
				lifespan_gain = 10
				eng_gain_base = 100
				info = "The perfected state of voidness, realization of non-self and emptiness. Spiritual liberation of the soul from the distractions of physical embodiment, and of emotional suffering or want. Accepting Nirvana will reject all Sins/Virtues, but cost an extraordinary amount of Divine Energy to embrace enlightenment."
			sins
				icon_state = "sin"
				dark_matter_mod_gain = 0.1
				/*
				Accepting a sin or virtue will lock you out from their counterpart. Costs divine energy to fuse the concept to the soul.
				Rejecting a sin or virtue will remove the indicated stats
				Must accept 7 sins or virtues in any order to unlock Divine Soul
				Must reject their counterparts from your soul
				Must have the stats that would be removed to reject the sin/virtue
				Add way to cleanse soul of sins/virtues entirely, incase player accidently picks wrong ones.
				Can choose to reject all Sins/Virtues entirely, skipping the Divine Soul process to an extent. Costs a lot of Divine Energy. Basically Buddha enlightenment.
				*/
				pride //Counters humility
					info_name = "Pride"
					lifespan_gain = 10
					eng_gain_base = 100
					counters = /obj/body_related/soul/virtues/humility
					info = "One of the seven sins of the soul. Pride is often described as having an excessively high opinion of oneself or one's own importance. It is countered by Humility."
					//Perhaps gained from fighting stronger people, not holding back power. Training/fighting while below 10% or so hp? Big xp boost if you beat someone stronger?
				greed //Counters charity
					info_name = "Greed"
					lifespan_gain = 10
					eng_gain_base = 100
					counters = /obj/body_related/soul/virtues/charity
					info = "One of the seven sins of the soul. Greed is an unfettered desire to aquire material or immaterial gain, even if already in posession of considerable sums of either. It is countered by Charity."
					//Perhaps gain xp from having more than one of the same item in inventory? And/or having too many resources in your inventory.
				wrath //Counters patience
					info_name = "Wrath"
					lifespan_gain = 10
					eng_gain_base = 100
					counters = /obj/body_related/soul/virtues/patience
					//Perhaps gain xp from killing others, knocking them out, hurting them, ect?
				envy //Counters kindness
					info_name = "Envy"
					lifespan_gain = 10
					eng_gain_base = 100
					counters = /obj/body_related/soul/virtues/kindness
					//Perhaps gain it from stealing from others?
				lust //Counters chastity
					info_name = "Lust"
					lifespan_gain = 10
					eng_gain_base = 100
					counters = /obj/body_related/soul/virtues/chastity
					//Perhaps gain lust xp from training too hard and fast, to lust/desire after more power. Maybe from a desire for resources, gaining too many too quickly.
				gluttony //Counters temperance
					info_name = "Gluttony"
					lifespan_gain = 10
					eng_gain_base = 100
					counters = /obj/body_related/soul/virtues/temperance
					//Perhaps gain xp from eating too much?
				sloth //Counters diligence
					info_name = "Sloth"
					lifespan_gain = 10
					eng_gain_base = 100
					counters = /obj/body_related/soul/virtues/diligence
					//Perhaps gain slothful xp from doing nothing consecutively for 5-10 mins at a time?
			virtues
				divine_mod_gain = 0.1
				chastity //Counters lust
					info_name = "Chastity"
					lifespan_gain = 10
					eng_gain_base = 100
					counters = /obj/body_related/soul/sins/lust
				charity //Counters greed
					info_name = "Charity"
					lifespan_gain = 10
					eng_gain_base = 100
					counters = /obj/body_related/soul/sins/greed
					//Perhaps gain charity xp for not having more than one item type in inventory, and teaching others skills.
				diligence //Counters sloth
					info_name = "Diligence"
					lifespan_gain = 10
					eng_gain_base = 100
					counters = /obj/body_related/soul/sins/sloth
					//Perhaps gain diligence xp from training consecutively for 5-10 mins?
				kindness //Counters envy
					info_name = "Kindness"
					lifespan_gain = 10
					eng_gain_base = 100
					counters = /obj/body_related/soul/sins/envy
					//Perhaps gain kindess xp for putting injured people into healing tanks, healing them via abilties, reviving them? And allowing yourself to heal also?
				patience //Counters wrath
					info_name = "Patience"
					lifespan_gain = 10
					eng_gain_base = 100
					counters = /obj/body_related/soul/sins/wrath
				humility //Counters pride
					info_name = "Humility"
					lifespan_gain = 10
					eng_gain_base = 100
					counters = /obj/body_related/soul/sins/pride
					//Perhaps gained from fighting others while under full power, being beaten in battle.
				temperance //Counters gluttony
					info_name = "Temperance"
					lifespan_gain = 10
					eng_gain_base = 100
					counters = /obj/body_related/soul/sins/gluttony
					//Perhaps gain temperance xp from eating nothing consecutively for 5-10 mins at a time? Meditation?
		/*
				What we want for meridians is a way to basically use Xiandao type of cultivation. At the moment, we only really have body cultivation.
				The idea behind Xiandao for the most part is enhancing the meridians, and especially the dantian it connects to.
				So some ideas for Xiandao-style cultivation could be the following.

				.:The Dantian:.
				Every level that the dantian is increased by, sends a small wave of psionic power that levels up all the other meridians.
				Meridians can't be individually leveled like body parts, they are instead nourished/enhanced by the state of the dantian.
				What we're looking for here is fairly large spaces between power spikes to replicate the idea of "realms"
				Just before a dantian levels, it reaches a bottleneck, and players must push through in psionic storm tribulations to level the dantian
				Pushing through bottleneck completely empties the dantian
				Any divine energy left over is distributed to the meridians, giving them extra levels
				Any energy/psionic power left over given to player

				.:Filling the Dantian:.
				Fills slowly on own, quicker when meditating, quicker when meditating/breathing, fastest when meditating/breathing in place of power
				To fill the dantian, players must seek out places of energy. These are areas where psionic forces have gathered and become permeated in energy.
				Place examples, Soul Stream, special psionic/energy-saturated cave. Area on map where a psi-storm has manifested. Yukka tree, ect. Points of interest.
				Let players create energy gathering arrays using tech, which act as points of interest
				Being near these places or consuming things slowly "fills" the dantian, aka makes its exp bar rise.
				The process starts with gathering energy, which is converted by the brain into Psionic power (psionic brain waves), then the dantian converts psi power into divine energy
				Energy -> Psionic Power -> Divine Energy -> Dark Matter (Dead/Entropic divine energy)
				Being over your dantian limit slows the gathering quite a bit

				.:What it looks like in game:.
				Currently, it would just be sitting about waiting for the Dantian to fill. And maybe doing breathing. Could be boring?
				Staying in one area too long (map radius 100x100?) causes gains to stop
				Locating fresh places increases energy gathering
				Using Empty dantian option gives immediate boosts


				.:Triple cultivation:.
				Players can set their focus to psiforge, cultivate, gather belief
				Psiforge does what it does currently and sends all gains toward limb leveling
				Cultivate sends everything to the Dantian, filling it up slowly
				Gather belief attracts energy to the player from their followers


				.:Player options:.
				Player can interrupt the dantians "digestion" process for immeditate gains.
				Empty Dantian of energy - Empties the dantian of raw energy, giving it to the player
				Empty Dantian of psionic power - Empties the dantian of psionic power, giving it to the player
				Divine energy inside the dantian can either be used to break through bottlenecks, or for skills, ect
				Dantian can gather infinite divine energy, but it bottlenecks once a certain number is inside, which means players who horde it can't advance their power spikes unless tributlating


				.:Maths and Methods (MaD):.
				The players Divine Energy sits inside the dantian. So the players divine energy vars are just considered part of the dantian
				Cultivate (Or meditate?) slowly drains the players energy and sends it to the dantian
				Takes time for the Dantian to convert energy, Energy -> Psionic Power -> Divine Energy -> Dark Matter (Dead/Entropic divine energy)
				Miss out on Psiforging and Gathering while Cultivating
				Choosing a method locks the others, but can switch between them all
				Realms can be unlocked by all three Cultivation types. For example, a body cultivator levels their heart and gains enough to advance their realm. Or a Xiandao type manages to
				gather enough divine energy to advance. Whats important is getting enough Divine Energy to advance a realm.
				A player could body cultivate for half the time and gain divine energy, then switch to Xiandao cultivation and gain the rest needed, for example.

				.:Body Parts:.
				To stagger/limit the player, and also tie in Cultivation with Psiforging, each body part will be limited to level 100 until they breakthrough to the next realm
				Each realms gives +100 max body part levels
				Max body part level will then be 1000

				.:Ascension Milestones:.
				These are now a bit like body milestones, minor boosts along the way when doing different kinds of cultivation.

				.:Realms and Realm Levels:.
				Apparently the number 9 has a lot of symbolism in cultivation?
				9 levels to each realm
				Start at level 1, then at level 9 a tribulation can be challenged
				Each level before level 9 gives smaller bonus
				Once level 9 is completed, much bigger bonus

				.:Tribulations:.
				These are special storms, which can be challenged once the player reaches a bottleneck in their training.
				The divine energy inside the dantian is released,
				Summons a great psionic storm around the player.
				Maybe player has to survive being struck several times?
				Maybe Psionic demons attack the player too?
				If the player fails to pass, they lose a little of their divine energy
				If the player fails to pass, they could become very injured or even die (Can become injured even if suceeded)

				.:Golden Core Quality:.



				.:Realms:.
				Realms range in level from 1-9, and breaking through enters a new Realm.

				Pre-Psionic
					Description: This where our player starts. Their body parts can't level past 100 while here.
					Gains:
				Post-Psionic
					+100 max levels to body parts once reached
					+10 levels to all body parts
					Description: This is where our players will be once they become sensitive to Psionic Power
				Psionic Condensation
					+100 max levels to body parts once reached
					+10 levels to all body parts
					Description: An initial stage of cultivation which involves absorbing Qi from the natural world and refining it inside the body.
				Foundation Establishment
					+100 max levels to body parts once reached
					+10 levels to all body parts
					Description: The stage after Qi Condensation. Once a cultivator’s Qi crosses a certain threshold (in the volume and/or density of the Qi),
					they’ll be able to breakthrough to this stage.
				Core Formation
					+100 max levels to body parts once reached
					+10 levels to all body parts
					It involves forming a Golden Core by using the Dantian as a crucible and the Cultivation Base as raw material.
				Nascent Soul
					+100 max levels to body parts once reached
					+10 levels to all body parts
					Description: The stage after Core Formation (in some novels). The Nascent Soul resembles an infant or miniature person and resides in the Dantian,
					typically sitting in a meditative position. In some novels, the Nascent Soul can travel outside the body and is like a second life for cultivators - if their
					main body dies, their consciousness can continue to exist in the Nascent Soul. For Yukopians, this is where they need to link their soul with the Yukka tree.
					They unlock a special ascension milestone to link before being able to pass their
					tribulation.
				Soul Formation
					+100 max levels to body parts once reached
					+10 levels to all body parts
				Demigod
					+100 max levels to body parts once reached
					+10 levels to all body parts
				Godhood
					+100 max levels to body parts once reached
					+10 levels to all body parts
					Description: The stage wherein the cultivator becomes a Daoist Immortal. There are many differences between novels, but usually the cultivation/maturation of
					the Golden Core or Nascent Soul plays a key role in ascending to Immortality.
				*/
		/*
		Cool music starts playing as the player starts to transform, we're talking dbz-style synthwave, over the top and epic.

		The screen around the player begins to darken, starting from the inside-out until all they can see if themselves.

		Then they start to float, and rays of light or darkness begins to erupt from them

		Flecks of energy particles emerge from or around them, like embers

		*/
		ascension_milestones
			icon = 'bodybits.dmi'
			icon_state = "ascension"
			level = 0
			lvl_max = 1
			needed_lvl = 1
			cybernetics_max = 0
			plane = 22
			layer = 35
			MouseWheel(delta_x,delta_y,location,control,params)
				var/obj/hud/menus/bodyparts_background/s = usr.hud_body
				var/obj/sc = s.scroller_p
				usr.check_mouse_loc(params)
				var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
				usr.mouse_y_true = true_y
				var/wheel_move = 0
				if(delta_y > 0) wheel_move = 16
				else if(delta_y < 0) wheel_move = -16
				var/result = sc.translated_y+wheel_move
				result = clamp(result,0,-169)
				var/matrix/m = matrix()
				m.Translate(0,result)
				sc.transform = m
				sc.translated_y = result

				var/ratio = -1 + ((-169 + result) / -169)
				ratio = clamp(ratio,0,1)
				var/scroll_y = round(s.max_scroll_parts*ratio)//760*ratio)

				for(var/obj/txt in s.bodypart_holder.vis_contents)
					var/matrix/m2 = matrix()
					m2.Translate(txt.hud_x,txt.hud_y+scroll_y)
					txt.transform = m2
				if(s.area_selected)
					s.area_selected.scroller_transform = m
					s.area_selected.scroller_translated = result
					s.area_selected.parts_transform = scroll_y
			whole_body
				info_name = "Wholeness of Body"
				minor_ascension = 1
				psi_gain_base = 100
				lifespan_gain = 10
				divine_eng_gain_base = 25
				eng_gain_base = 250
				needs_body = 1
				psi_mod_gain = 1
				//Grows a body for beings from the psionic realm, first step toward them gaining divinity.
				//Last organ grown is one that unlocks the ability to use dark infusion or divine infusion
			dark_body
				info_name = "Dark Composition"
				icon_state = "dark ascension"
				minor_ascension = 1
				psi_gain_base = 100
				lifespan_gain = 100
				divine_eng_gain_base = 100
				eng_gain_base = 1000
				ascension_type = "body"
				needs_body = 1
				psi_mod_gain = 1
				//Complete large sections of the body psiforging process to unlock
				//Unlocked when all body parts are infused with dark matter energy, via dark infusion
			divine_body
				info_name = "Divine Body"
				minor_ascension = 1
				psi_gain_base = 100
				lifespan_gain = 100
				divine_eng_gain_base = 100
				eng_gain_base = 1000
				ascension_type = "body"
				needs_body = 1
				psi_mod_gain = 1
				//Complete large sections of the body psiforging process to unlock
				//Unlocked when all body parts are infused with divine energy
			petrified_body
				info_name = "Petrified Body"
				icon_state = "dark ascension"
				minor_ascension = 1
				psi_gain_base = 100
				lifespan_gain = 100
				divine_eng_gain_base = 100
				eng_gain_base = 1000
				ascension_type = "body"
				needs_body = 1
				psi_mod_gain = 1
				//Unlocked when all body parts are infused with dark matter
			dark_soul
				info_name = "Malevolent Soul"
				icon_state = "dark ascension"
				info = "The soul is corrupted, infused with sin and overflowing with baleful embers of the dying universe."
				minor_ascension = 1
				psi_gain_base = 100
				divine_eng_gain_base = 100
				ascension_type = "soul"
				needs_soul = 1
				psi_mod_gain = 1
				//Can be focused on seperately from divine body
			balanced_soul
				info_name = "Balanced Soul"
				info = "A perfect soul must understand imperfection before it can taste perfection, embracing both sin and virtue. No light without the darkness."
				minor_ascension = 1
				psi_gain_base = 100
				divine_eng_gain_base = 100
				ascension_type = "soul"
				needs_soul = 1
				psi_mod_gain = 1
				//Can use any combo of sin/virtue, or nirvanna to skip.
			divine_soul
				info_name = "Divine Soul"
				info = "The soul must overflow with divine energy and radiate its brilliance for all of creation to see."
				minor_ascension = 1
				psi_gain_base = 100
				divine_eng_gain_base = 100
				ascension_type = "soul"
				needs_soul = 1
				psi_mod_gain = 1
				//Can be focused on seperately from divine body
			divine_mind
				info_name = "Divine Mind"
				minor_ascension = 1
				psi_gain_base = 100
				divine_eng_gain_base = 100
				eng_gain_base = 1000
				psi_mod_gain = 1
				info = "For one to be a god, one must think like one. To comprehend the unknown and unknowable."
				//Can be focused on seperately from divine body
				//lvl 333-1000 infused brain?
				//Get to lvl 25+ in 10+ skills?
			golden_core_ascension
				info_name = "Golden Core Formation"
				major_ascension = 1
				psi_gain_base = 1000
				eng_gain_base = 1000
				info = "Reconfigure yourself into a perfectly optimized quantum state, transcending the comprehension of lesser beings and approaching - for all intents and purposes, a god."
				/*
				Golden Core Ascension
				- Can be used after other minor ascenions are finished unlocking
				- Stronger and better quality the more Divine Energy you have in reserve
				- Quality from 9 - 1
				*/
			yin_yang_ascension
				info_name = "Supreme Ultimate Yin Yang State"
				major_ascension = 1
				psi_gain_base = 1000
				eng_gain_base = 1000
				info = "Reconfigure yourself into a perfectly optimized quantum state, transcending the comprehension of lesser beings and approaching - for all intents and purposes, a god."
				/*
				Divine Energy/Dark Matter combo Ascension
				- Infuse limbs with both energy types
				- Harder to attain, takes longer than some other ascenions
				*/
			robotic_ascension
				info_name = "God Particle Configuration"
				icon_state = "dark realm"
				major_ascension = 1
				psi_gain_base = 1000
				eng_gain_base = 1000
				needs_body = 1
				info = "Reconfigure yourself into a perfectly optimized quantum state, transcending the comprehension of lesser beings and approaching - for all intents and purposes, a god."
				/*
				Robotic Ascension
				- Complete robotics research
				- Transform self into robot. Or as a robot, have scientist inject nanites into your bodyparts.
				- Infuse all bodyparts with nanites
				- Infuse all parts with dark matter too?
				- Reconfigure self into ascended form once other steps done
				- Doesn't need divine body, mind or soul, letting players focus on tech instead
				*/
			namekian_ascension //Place holder name?
				info_name = "Symbiotic Mutualistic Homogenization"
				major_ascension = 1
				psi_gain_base = 1000
				lifespan_gain = 100
				eng_gain_base = 1000
				needs_body = 1
				psi_mod_gain = 10
				New()
					needed_parts = list(/:divine_body,/:balanced_soul,/:divine_mind)
				/*
				Symbiotic Mutualistic Homogenization
				- Basically links Yukopians with other Yukopians
				- Rituals to enhance body, mind and soul
				- Ritual to link soul with tree
				- Ritual to link mind with other Yukopians
				- Ritual of divine body
				- The more plants and grass that tree spawns, more power everyone gets
				- Once all three are complete, share power equally between all others of race
				- If no tree, can't get power from tree directly, or for the number of plants spawned
				*/
			dark_matter_ascension //Place holder name?
				info_name = "Dark Matter Integration"
				icon_state = "dark ascension"
				major_ascension = 1
				psi_gain_base = 10000
				lifespan_gain = 100
				eng_gain_base = 1000
				needs_body = 1
				psi_mod_gain = 10
				/*
				Dark Matter Ascension notes
				- Unlocked by doing physics research
				- Use machine/dome to infuse body with dark matter in one large burst and transform into Dr.Manhattan/Buu style god-like being
				- Replaces body parts with other, stranger parts
				- Big regen/force boost and recovery?
				- Doesn't need divine body, mind or soul, letting players focus on tech instead
				*/
			cybernetic_synthesis //Place holder name?
				info_name = "Cybernetic Synthesis"
				icon_state = "dark ascension"
				major_ascension = 1
				psi_gain_base = 10000
				lifespan_gain = 100
				eng_gain_base = 1000
				needs_body = 1
				psi_mod_gain = 10
				/*
				Cybernetic Synthesis
				- Insert cybertech in every body part
				- Level every cybertech part to at least 100?
				- Infuse every cybertech part with darkmatter?
				- Doesn't need divine body, mind or soul, letting players focus on tech instead
				*/
			tatoo_ascension
				info_name = "Paradise Forever"
				icon_state = "realm"
				major_ascension = 1
				psi_gain_base = 10000
				lifespan_gain = 100
				divine_eng_gain_base = 100
				eng_gain_base = 1000
				psi_mod_gain = 10
				New()
					needed_parts = list(/:divine_body,/:balanced_soul,/:divine_mind)
				/*
				Tatoo Ascension
				- Use calligraphy/runes to imbue the flesh/skin with Divine/Dark energy
				- Draws protective runes and tatoo's directly onto the skin
				- Allows player to "upgrade" their tatoo's and ascend that way
				- Kind of like Vikings/Dwarves/Orcs, does different things depending on what type you draw
				- Dwarves get a special kind that's more powerful and one which they can use on items
				*/
			paradise_forever
				info_name = "Paradise Forever"
				icon_state = "realm"
				major_ascension = 1
				psi_gain_base = 10000
				lifespan_gain = 100
				divine_eng_gain_base = 100
				eng_gain_base = 1000
				psi_mod_gain = 10
				New()
					needed_parts = list(/:divine_body,/:balanced_soul,/:divine_mind)
				/*
				Paradise Forever notes
				- Only unlocked/appears once the player has combined all the Continuim Gems
				*/
			human_ascension
				info_name = "Divine Ascension"
				icon_state = "realm"
				major_ascension = 1
				psi_gain_base = 10000
				lifespan_gain = 100
				divine_eng_gain_base = 100
				eng_gain_base = 1000
				psi_mod_gain = 10
				New()
					needed_parts = list(/:divine_body,/:balanced_soul,/:divine_mind)
				/*
				Human Ascension notes
				- Turns player eyes golden?
				- Can choose to infuse body with either divine energy or dark matter?
				- Third eye appears and is needed for ascension?
				- Could make hair sway, like the avatars on xcom 2?
				*/
			psion_ascension_1
				info_name = "Divine Apotheosis"
				major_ascension = 1
				psi_gain_base = 1000
				divine_eng_gain_base = 100
				eng_gain_base = 1000
				psi_mod_gain = 10
				New()
					needed_parts = list(/:divine_body,/:divine_soul,/:divine_mind)
				/*
				Psion Ascension notes
				- Basically ssj1
				- Gives massive power boost
				- Gives strength and endurance
				- Need certain power to unlock?
				- Unlocked via mastering emotions?
				- Or unlocked from especially powerful emotional outburst?
				*/
			celestial_divine_thunder
				info_name = "Celestial Divine Thunder"
				major_ascension = 1
				psi_gain_base = 10000
				lifespan_gain = 100
				divine_eng_gain_base = 100
				eng_gain_base = 1000
				psi_mod_gain = 10
				New()
					needed_parts = list(/:whole_body,/:divine_body,/:divine_soul,/:divine_mind)
				/*
				Celestial Divine Thunder notes
				- A alternative acension where the user absorbs divine energy via lightning
				- Able to summon/produce storms, and use them to absorb power or attack others
				- Lightning trials, start off easy and get harder and harder
				- Range from normal storm lightning, to psionic, to golden divine
				- Easier with higer resistance
				- Each sucessful trial gives +0.1 or so resis mod
				- Each sucessful tril imbues a limb with lightning/divine energy?
				*/
			celestial_ascension
				info_name = "Divine Apotheosis"
				icon_state = "realm"
				major_ascension = 1
				psi_gain_base = 10000
				lifespan_gain = 100
				divine_eng_gain_base = 100
				eng_gain_base = 1000
				psi_mod_gain = 10
				New()
					needed_parts = list(/:whole_body,/:divine_body,/:divine_soul,/:divine_mind)
				/*
				Celestial Ascension notes
				- Gained from blessing mortals?
				- Perhaps a Shendao style of ascension, where having followers gives power?
				- First step, grow bodyparts
				- Second step, infuse body parts with divine energy
				- Third step, gain divine soul by some kind of worship? Or virtues/sins?
				- Turns player golden
				- Generates a lot of divine energy
				- Aura that gives others a boost to their divine energy regen/aquiring
				- Changes psionic power color to golden/white?
				*/
			dark_energy_saturation_ascension
				info_name = "Dark Saturation"
				icon_state = "dark realm"
				major_ascension = 1
				psi_gain_base = 10000
				lifespan_gain = 100
				divine_eng_gain_base = 100
				eng_gain_base = 500
				psi_mod_gain = 10
				/*
				- Requires the player to have a super high gravity tolerance
				- Lets them enter a blackhole unharmed
				- Opens the way to the Dark Energy Realm

				*/
			demonic_ascension
				info_name = "Dark Apotheosis"
				icon_state = "dark realm"
				major_ascension = 1
				psi_gain_base = 10000
				lifespan_gain = 100
				divine_eng_gain_base = 100
				eng_gain_base = 500
				psi_mod_gain = 10
				New()
					needed_parts = list(/:whole_body,/:dark_body,/:dark_soul) //Find way to make it detect if divine or dark matter energy was used
				/*
				Demonic Ascension notes
				- First step, grow body parts.
				- Second step, instead of using divine energy to infuse limbs, convert divine energy into dark matter
				- Third step, use dark matter to infuse limbs instead
				- Fourth step, produce divine soul using sin/virtues?
				- Needs divine body, soul and mind to be completed, but using dark matter
				- Changes psionic power color to black/purple?
				- Mutative aura that gives a bonus to psiforging to anyone near?
				*/
			elder_lichdom
				info_name = "Lichdom"
				icon_state = "dark realm"
				major_ascension = 1
				psi_gain_base = 10000
				dark_matter_gain_base = 1000
				eng_gain_base = 1000
				dark_matter_mod_gain = 1
				rads_gain = 2
				cold_gain = 2
				gain_txt = "+ Cold immunity\n+ Radiation immunity\n+ Immortality\n+ No air needed"
				psi_mod_gain = 10
				New()
					steps = list(0,1) //First is Phylactery creation, second is Soul in phylactery.
					needed_parts = list(/:petrified_body,/:dark_soul,/:divine_mind,"Phylactery obtained [src.steps[1]]/1","Elixir of Defilation taken [src.steps[2]]/1")
				/*
				Elder Lichdom notes
				- One step is to get to age 1000+, using various means.
				*/
			lichdom
				info_name = "Lichdom"
				icon_state = "dark realm"
				major_ascension = 1
				psi_gain_base = 10000
				dark_matter_gain_base = 1000
				eng_gain_base = 1000
				dark_matter_mod_gain = 1
				rads_gain = 2
				cold_gain = 2
				gain_txt = "+ Cold immunity\n+ Radiation immunity\n+ Immortality\n+ No air needed"
				psi_mod_gain = 10
				New()
					steps = list(0,1) //First is Phylactery creation, second is Soul in phylactery.
					needed_parts = list(/:petrified_body,/:dark_soul,/:divine_mind,"Phylactery obtained [src.steps[1]]/1","Elixir of Defilation taken [src.steps[2]]/1")
				/*
				Lichdom notes
				- Would be cool if part of the process was to absorb/ossify organs, causing bones/soul to become stronger as a result
				- Destroys organ/muscle when absorbed, kills it.
				- Immunity to cold, aging
				- Needs divine soul and mind to be completed
				- Generally gives a large boost to res/end and force?
				- Makes str and speed lower
				- Ritual to convert a black hole or neutron star into a phylactory
				- Ritual to place soul into phylactory
				- Ritual to create special potion that needs to be drank
				- Converts/Replaces any body milestones completed/unfinished that involve organs into extra power?
				*/
		body_milestones
			level = 0
			lvl_max = 10
			icon = 'bodybits.dmi'
			icon_state = "milestone"
			cybernetics_max = 0
			plane = 22
			layer = 35
			MouseWheel(delta_x,delta_y,location,control,params)
				var/obj/hud/menus/bodyparts_background/s = usr.hud_body
				var/obj/sc = s.scroller_p
				usr.check_mouse_loc(params)
				var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
				usr.mouse_y_true = true_y
				var/wheel_move = 0
				if(delta_y > 0) wheel_move = 16
				else if(delta_y < 0) wheel_move = -16
				var/result = sc.translated_y+wheel_move
				result = clamp(result,0,-169)
				var/matrix/m = matrix()
				m.Translate(0,result)
				sc.transform = m
				sc.translated_y = result

				var/ratio = -1 + ((-169 + result) / -169)
				ratio = clamp(ratio,0,1)
				var/scroll_y = round(s.max_scroll_parts*ratio)//760*ratio)

				for(var/obj/txt in s.bodypart_holder.vis_contents)
					var/matrix/m2 = matrix()
					m2.Translate(txt.hud_x,txt.hud_y+scroll_y)
					txt.transform = m2
				if(s.area_selected)
					s.area_selected.scroller_transform = m
					s.area_selected.scroller_translated = result
					s.area_selected.parts_transform = scroll_y
			microcosmic_orbit
				info_name = "Microcosmic Orbit"
				needed_lvl = 100
				lvl_max = 3
				desc_fnt_siz = 10
				eng_gain_base = 100
				eng_mod_gain = 1
				lifespan_gain = 10
				divine_eng_gain_base = 100
				New()
					needed_parts = list(/:dantian)
					needed_parts_ref = null

			//ALIENS AND SUBALIEN UNIQUES
			galatic_survivor
				info_name = "Galatic Survivor"
				info = "Known for thriving in hostile environments, aliens have developed exceptional endurance. After taking damage, they recover more quickly when given time to rest, making them highly durable explorers and long-term fighters."
				effect = "Passively increases stamina and recovery rate after taking damage, allowing the user to gradually regain HP and energy over time (but only outside of combat)."
				needed_lvl = 150
				lvl_max = 1
				desc_fnt_siz = 10
				needs_body = 1
				gain_txt = "+ 15% Regeneration outside of combat\n+ 15% Recovery outside of combat"
				New()
					needed_parts = list(/:spine,/:heart)
					needed_parts_ref = null
			//MAGIC ALIEN UNIQUE
			mimicry
				info_name = "Mimicry"
				info = "Mage-style aliens possess a highly adaptive and observational nature, allowing them to copy techniques and adapt them to their own fighting style. This ability grants temporary versatility without permanently overpowering them."
				effect = "The user can temporarily learn and use any skill they witness from another race. Cannot copy transformation-related abilities (e.g., Super Saiyan)."
				needed_lvl = 115
				lvl_max = 2
				desc_fnt_siz = 10
				needs_body = 1
				gain_txt = "+ Learn any skill by watching"
				New()
					needed_parts = list(/:brain,/:right_ear,/:left_eye,/:right_eye)
					needed_parts_ref = null
			//TECH ALIEN UNIQUE
			transmute
				info_name = "Transmute"
				info = "Using advanced technological manipulation, the Technology Alien can transmute raw materials into more desirable forms, making them essential for crafting and resource management."
				effect = "Allows the user to convert one type of mineral into another at a conversion rate of 1.5:1 (adjustable based on game economy). Higher levels of Transmute reduce the conversion cost."
				needed_lvl = 130
				lvl_max = 2
				desc_fnt_siz = 10
				needs_body = 1
				gain_txt = "+ Convert one type of mineral into another"
				New()
					needed_parts = list(/:brain,/:heart)
					needed_parts_ref = null
			//PHYSICAL ALIEN UNIQUE
			iron_will
				info_name = "Iron Will"
				info = "Their combat prowess is matched by their resilience. When pushed to the brink, they become tougher and stronger, making them excellent frontline fighters who thrive under pressure."
				effect = "Increases physical damage resistance by 10% and an extra 10% when below 20% HP"
				needed_lvl = 150
				lvl_max = 2
				desc_fnt_siz = 10
				needs_body = 1
				gain_txt = "+ 10% Strength damage\n+ Extra +10% Strength damage when below 20% HP"
				New()
					needed_parts = list(/:spine,/:torso_skin,/:head_skin)
					needed_parts_ref = null
			//SPEED ALIEN UNIQUE
			blitz_step
				info_name = "Blitz Step"
				info = "Known for their lightning-fast reflexes, this alien’s speed becomes even more dangerous after evading attacks. This trait rewards players who can react quickly, enhancing their combat efficiency without making them overly evasive."
				effect = "After dodging an attack, gain a 15% speed boost for 5 seconds. Can trigger once every 10 seconds."
				needed_lvl = 150
				lvl_max = 2
				desc_fnt_siz = 10
				needs_body = 1
				gain_txt = "+ 15% Speed boost after successful dodges"
				New()
					needed_parts = list(/:spine,/:left_leg,/:right_leg)
					needed_parts_ref = null
			//ENERGY ALIEN UNIQUE
			core_burst
				info_name = "Core Burst"
				info = "This alien race possesses an innate connection to raw energy, channeling massive bursts of power at the cost of increased ki consumption. It’s a balanced boost that rewards aggressive energy-based play while ensuring resource management."
				effect = "Increases the damage of all ki-based attacks by 10%, but also increases ki consumption by 5%."
				needed_lvl = 300
				lvl_max = 1
				desc_fnt_siz = 10
				needs_body = 1
				gain_txt = "+ 10% Ki Damage\n<font color=red>- 5% Ki Usage</font>"
				New()
					needed_parts = list(/:heart,/:spine,/:skull)
					needed_parts_ref = null
			//METAMORAN UNIQUE
			unified_ki
				info_name = "Unified Ki"
				info = "Metamoran warriors naturally excel in teamwork and combined energy techniques. This trait enhances their synergy with others, making them invaluable in group-based combat scenarios."
				effect = "Increases the effectiveness of energy techniques by 20% when fighting alongside friends(contancts related) (or fused entity)."
				needed_lvl = 150
				lvl_max = 1
				desc_fnt_siz = 10
				needs_body = 1
				gain_txt = "+ 20% Ki damage near friends."
				New()
					needed_parts = list(/:heart,/:torso_skin)
					needed_parts_ref = null
			//YARDRAT UNIQUE
			spirit_shift
				info_name = "Spirit Shift"
				info = "Drawing from their spiritual mastery, the Yardrats can temporarily phase out of danger using their control over space and spirit energy. This trait reflects their ability to manipulate dimensions and evasion."
				needed_lvl = 200
				lvl_max = 2
				desc_fnt_siz = 10
				needs_body = 1
				effect =  "Grants the ability of astral projection."
				gain_txt = "+ Grants astral projection technique"
				New()
					needed_parts = list(/:left_eye,/:right_eye,/:brain)
					needed_parts_ref = null
			//SPIRIT DOLL UNIQUES
			spirit_shield
				info_name = "Spirit Shield"
				info = "The Spirit Doll’s mastery over telekinetic defenses allows them to subconsciously shield themselves from harm. The psychic barrier subtly redirects a portion of the damage, channeling it back into their energy reserves."
				effect = "Passively reduces incoming damage by 10%, converting part of the absorbed damage into ki regeneration."
				needed_lvl = 200
				lvl_max = 1
				desc_fnt_siz = 10
				divine_eng_gain_base = 5
				needs_body = 1
				gain_txt = "+ Energy Shields absorb damage and convers into ki."
				New()
					needed_parts = list(/:brain,/:spine,/:heart,/:lungs)
					needed_parts_ref = null
			//MAKYO UNIQUES
			stars_favorite
				info_name = "Star's Favorite"
				info = "When exposed to the Makyo Star, the user gains an extra massive power boosts for a limited duration. This makes Makyos extremely dangerous during cosmic events, matching to their most relentless form."
				effect = "  Power level temporarily triples(instead of normal doubling) when the Makyo Star is present"
				needed_lvl = 300
				lvl_max = 1
				desc_fnt_siz = 10
				divine_eng_gain_base = 5
				needs_body = 1
				gain_txt = "+ 3x Power Level Increase under the Makyo Star"
				New()
					needed_parts = list(/:brain,/:left_ear,/:right_ear,/:ribcage,/:spine)
					needed_parts_ref = null
			//NAMEKIAN UNIQUES
			dragonball_progenitor
				info_name = "Dragonball Progenitor"
				info = "As a descendant of the original Dragon Clan, the Namekian gains the rare ability to create Dragonballs. The power of the wishes depends on the user’s spiritual strength and growth. Creating and protecting the Dragonballs becomes a vital responsibility for the Namekian."
				effect = "Allows the user to create a set of Dragonballs on a planet with customizable wishes (based on in-game limits)"
				needed_lvl = 300
				lvl_max = 1
				desc_fnt_siz = 10
				divine_eng_gain_base = 10
				needs_body = 1
				gain_txt = "Allows the user to create a set of Dragonballs on a planet with customizable wishes (based on in-game limits)"
				New()
					needed_parts = list(/:left_ear,/:right_ear,/:left_eye,/:right_eye,/:dragon_clan_awaken)
					needed_parts_ref = null
			dragon_clan_awaken
				info_name = "Dragon Clan Awaken"
				info = "As a descendant of the original Dragon Clan, the Namekian gains the rare ability to create Dragonballs. The power of the wishes depends on the user’s spiritual strength and growth. Creating and protecting the Dragonballs becomes a vital responsibility for the Namekian."
				effect = "Grants the ability to unlock hidden potential in players (1-time buff)"
				needed_lvl = 150
				lvl_max = 1
				desc_fnt_siz = 10
				divine_eng_gain_base = 5
				needs_body = 1
				gain_txt = "Grants the ability to unlock hidden potential in players (1-time buff)"
				New()
					needed_parts = list(/:brain,/:left_ear,/:right_ear,/:left_eye,/:right_eye,/:heart)
					needed_parts_ref = null
			//KAI UNIQUES
			wisdom
				info_name = "Wisdom"
				info = "The wisdom of the gods grants the user immunity to status effects related to mental attacks or curses from mages and alike."
				effect = " Grants resistance to mind-control and curse-based abilities"
				needed_lvl = 150
				lvl_max = 1
				desc_fnt_siz = 10
				divine_eng_gain_base = 5
				needs_body = 1
				gain_txt = "+ Resistance to mind control and cursed-based abilities."
				New()
					needed_parts = list(/:brain,/:left_ear,/:right_ear)
					needed_parts_ref = null
			radiance
				info_name = "Radiance"
				info = "Generates a field of healing energy around the user, restoring the HP and energy of anyone with pure aura closeby."
				effect = "Heal pure hearted users who are close by overtime"
				needed_lvl = 250
				lvl_max = 1
				desc_fnt_siz = 10
				needs_body = 1
				gain_txt = "Heal pure aligned players who are close by overtime"
				New()
					needed_parts = list(/:brain,/:left_ear,/:right_ear,/:heart,/:spine)
					needed_parts_ref = null
			//DEMON UNIQUES
			dark_pact
				info_name = "Dark Pact"
				info = "A pact with dark forces grants the user a boost to energy recovery at the cost of their -10 of their max health."
				effect = "Syphon power in energy recovery from the Dark Realm in exchange for your health."
				deduction = "health"
				needed_lvl = 200
				lvl_max = 1
				desc_fnt_siz = 10
				recov_mod_gain = 2.5
				divine_eng_gain_base = 5
				gain_txt = "<font color = red>- 10 Max Health</font>\n<font color=green>+ 25% Recovery</font>"
				needs_body = 1
				New()
					needed_parts = list(/:brain,/:left_eye,/:right_eye,/:heart)
					needed_parts_ref = null
			demonic_aura
				info_name = "Demonic Aura"
				info = "Engulfs the user in aura that damages nearby enemies and weakens their defenses. Ideal for close-combat fighters or those who thrive in chaos."
				effect = "Inflicts damage over time to nearby enemies"
				needed_lvl = 150
				lvl_max = 2
				desc_fnt_siz = 10
				needs_body = 1
				gain_txt = "+ Inflicts damage over time to nearby players of neutral or pure alignment."
				New()
					needed_parts = list(/:brain,/:left_eye,/:right_eye,/:heart,/:spine,/:skull)
					needed_parts_ref = null

			//CHANGELING UNIQUES
			limit_breaker
				info_name = "Limit Breaker"
				info = "The user perfects their body, achieving a state beyond normal limitations. In this form, all base stats receive a 2x multiplier, with energy drain slightly increased to balance power."
				effect = "An extra boost past your current form."
				needed_lvl = 300
				lvl_max = 1
				desc_fnt_siz = 10
				recov_mod_gain = 2.5
				divine_eng_gain_base = 10
				needs_body = 1
				New()
					needed_parts = list(/:brain,/:spine,/:skull,/:heart)
					needed_parts_ref = null
			// SAIYANS UNIQUES
			ape_mastery
				info_name = "Ape Mastery"
				info = "The Saiyan has complete control over their tail, allowing them to transform at will without succumbing to primal rage."
				effect = "Mastery over tail-based transformations (Oozaru)"
				needed_lvl = 100
				lvl_max = 1
				desc_fnt_siz = 10
				recov_mod_gain = 0.5
				divine_eng_gain_base = 10
				gain_txt = "+ 100% Oozaru Control"
				//oozaru_control = 100
				needs_body = 1
				New()
					needed_parts = list(/:brain,/:spine)
					needed_parts_ref = null
			battle_rage
				info_name = "Battle Rage"
				info = "Upon recovery from a near-death experience, Saiyans experience a heightened boost to their overall combat effectiveness."
				effect = "20% stat boost upon successful ressurection.(varies)"
				needed_lvl =100
				lvl_max = 2
				desc_fnt_siz = 10
				eng_gain_base = 1000
				recov_mod_gain = 1.5
				divine_eng_gain_base = 10
				needs_body = 1
				gain_txt = "+ 20% stat boost upon successful pull-through's."
				New()
					needed_parts = list(/:brain,/:heart,/:spine)
					needed_parts_ref = null
			//HUMAN UNIQUE
			third_eye
				info_name = "Third Eye"
				info = "A rare trait among humans, the Third Eye represents a heightened state of spiritual enlightenment. It allows the user to perceive energy and movement beyond normal limits, making them highly adept in both offensive and defensive scenarios. With this enhanced awareness, humans can sense threats before they happen and focus their energy more effectively, creating a bridge between combat and spiritual mastery."
				effect = "Grants heightened awareness, improving energy control, reaction time, and perception of enemy movements. At higher levels, it also increases energy regeneration and ki-based"
				needed_lvl = 100
				lvl_max = 3
				desc_fnt_siz = 10
				psi_gain_base = 300
				eng_gain_base = 1000
				recov_mod_gain = 1
				lifespan_gain = 10
				divine_eng_gain_base = 100
				needs_body = 1
				New()
					needed_parts = list(/:right_eye,/:left_eye,/:brain)
					needed_parts_ref = null
			resilient_hide
				info_name = "Resilient Hide"
				needed_lvl = 100
				psi_gain_base = 1000
				res_gain_base = 1000
				lvl_max = 3
				desc_fnt_siz = 10
				cold_gain = 1
				heat_gain = 1
				needs_body = 1
				New()
					needed_parts = list(/:torso_skin,/:head_skin)
					needed_parts_ref = null
			herculean_muscles
				info_name = "Herculean Muscles"
				needed_lvl = 100
				psi_gain_base = 2000
				str_gain_base = 2000
				desc_fnt_siz = 7
				lvl_max = 3
				needs_body = 1
				New()
					needed_parts = list(/:head_muscles,/:neck_muscles,/:chest_muscles,/:back_muscles,/:abdominal_muscles)
					needed_parts_ref = null
			fused_ribcage
				info_name = "Fused Ribcage"
				info = "Use Psi energy to meld and fuse the ribs together as a singular unit, greatly enhancing their structural strength and endurance."
				needed_lvl = 100
				end_gain_base = 200
				desc_fnt_siz = 10
				lvl_max = 1
				needs_body = 1
				New()
					needed_parts = list(/:ribcage)
					needed_parts_ref = null
			hardened_bones
				info_name = "Hardened Bones"
				info = "Using Psi energy, harden most of your core bones until they are like steel, able to withstand incredible punishment."
				needed_lvl = 100
				psi_gain_base = 2000
				end_gain_base = 2000
				desc_fnt_siz = 7
				lvl_max = 3
				needs_body = 1
				New()
					needed_parts = list(/:head_muscles,/:neck_muscles,/:chest_muscles,/:back_muscles,/:abdominal_muscles)

				//	needed_parts = list(/:skull,/:spine,/:sternum,/:pelvis,/:ribcage,/:left_clavicle,/:right_clavicle,/:left_forearm_bones,/:left_upper_arm_bones,/:left_scapula_bones,/:right_forearm_bones,/:right_upper_arm_bones,/:right_scapula_bones,/:left_foot_bones,/:left_lower_leg_bones,/:left_thigh_bone,/:right_foot_bones,/:right_lower_leg_bones,/:right_thigh_bone)
					needed_parts_ref = null
					//needed_parts = list(/:skull,/:spine,/:sternum,/:pelvis,/:left_ribs,/:right_ribs,/:left_forearm_bones,/:left_upper_arm_bones,/:left_scapula_bones,/:right_forearm_bones,/:right_upper_arm_bones,/:right_scapula_bones,/:left_foot_bones,/:left_lower_leg_bones,/:left_thigh_bone,/:right_foot_bones,/:right_lower_leg_bones,/:right_thigh_bone)
			unified_organs
				info_name = "Unifed Organs"
				info = "Cause the energy flow within your body to circulate flawlessly in a perpetual loop that drastically increases the power of your body as a whole."
				needed_lvl = 100
				psi_gain_base = 2000
				eng_gain_base = 2000
				spd_mod_gain = 1
				desc_fnt_siz = 7
				lifespan_gain = 10
				lvl_max = 3
				needs_body = 1
				New()
					needed_parts = list(/:head_muscles,/:neck_muscles,/:chest_muscles,/:back_muscles,/:abdominal_muscles)

					//needed_parts = list(/:brain,/:thyroid,/:left_eye,/:right_eye,/:left_ear,/:right_ear,/:nose,/:heart,/:large_intestines,/:small_intestines,/:stomach,/:left_kidney,/:right_kidney,/:liver,/:spleen,/:lungs,/:thymus,/:urinary_bladder,/:gall_bladder)
					needed_parts_ref = null
			obliteration_fists
				info_name = "Obliteration Fists"
				info = "Train your fists until they erase anything with a single hit."
				needed_lvl = 500
				psi_gain_base = 5000
				str_gain_base = 5000
				off_gain_base = 1000
				desc_fnt_siz = 7
				lvl_max = 1
				needs_body = 1
				New()
					needed_parts = list(/:head_muscles,/:neck_muscles,/:chest_muscles,/:back_muscles,/:abdominal_muscles)

				//	needed_parts = list(/:right_thumb_bones,/:right_index_finger_bones,/:right_middle_finger_bones,/:right_pinky_bones,/:right_ring_finger_bones,/:right_hand_muscles,/:left_thumb_bones,/:left_index_finger_bones,/:left_middle_finger_bones,/:left_pinky_bones,/:left_ring_finger_bones,/:left_hand_muscles)
					needed_parts_ref = null
		/*
		Two types of Android, liquid nanite and traditional? Or maybe the acended form of an android is nanites?
		CPU = Brain
		Coolant Pump = Heart
		Hearing Sensors = Ears
		Light Sensors = Eyes
		Generator = Lungs? Produces Energy
		Heatsink = Kidney? Transfer heat produced and puts it into the air or into a liquid system for cooling.
		Self-Repair systems = Spleen?
		Hydraulics = Muscles
		Endoskeleton = Bones
		*/
		bodyparts
			icon = 'bodybits.dmi'
			level = 0
			plane = 22
			layer = 35
			MouseWheel(delta_x,delta_y,location,control,params)
				var/obj/hud/menus/bodyparts_background/s = usr.hud_body
				var/obj/sc = s.scroller_p
				usr.check_mouse_loc(params)
				var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
				usr.mouse_y_true = true_y
				var/wheel_move = 0
				if(delta_y > 0) wheel_move = 16
				else if(delta_y < 0) wheel_move = -16
				var/result = sc.translated_y+wheel_move
				result = clamp(result,0,-169)
				var/matrix/m = matrix()
				m.Translate(0,result)
				sc.transform = m
				sc.translated_y = result

				var/ratio = -1 + ((-169 + result) / -169)
				ratio = clamp(ratio,0,1)
				var/scroll_y = round(s.max_scroll_parts*ratio)//760*ratio)

				for(var/obj/txt in s.bodypart_holder.vis_contents)
					var/matrix/m2 = matrix()
					m2.Translate(txt.hud_x,txt.hud_y+scroll_y)
					txt.transform = m2
				if(s.area_selected)
					s.area_selected.scroller_transform = m
					s.area_selected.scroller_translated = result
					s.area_selected.parts_transform = scroll_y
			chakras
				level = 0
				lvl_max = 1000
				icon = 'bodybits.dmi'
				icon_state = "meridian"
				cybernetics_max = 0

				root_chakra
					/*
					color = red
					*/
					info_name = "Root Chakra"
				sacral_chakra
					/*
					color = orange
					*/
					info_name = "Sacral Chakra"
				solar_plexus_chakra
					/*
					color = yellow
					*/
					info_name = "Solar Plexus Chakra"
				heart_chakra
					/*
					color = green
					*/
					info_name = "Heart Chakra"
				throat_chakra
					/*
					color = blue
					*/
					info_name = "Throat Chakra"
				third_eye_chakra
					/*
					color = indigo
					*/
					info_name = "Third Eye Chakra"
				crown_chakra
					/*
					color = violet
					*/
					info_name = "Crown Chakra"
			meridians //Like arteries that energy travel down
				level = 0
				lvl_max = 0
				icon = 'bodybits.dmi'
				icon_state = "meridian"
				cybernetics_max = 0

				//12 standard meridians - place 3 inside each limb
				meridian_veins //Gives dark matter, energy, force
					info_name = "Meridian Veins"
					info = "Meridians are a network of vessels/channels in the body through which Energy flows. These are smaller than the rest found inside this body part."
					bodypart_type = "Meridian"
					eng_gain_base = 2
				meridian_artery //Gives dark matter, energy, force
					info_name = "Meridian Artery"
					info = "Meridians are a network of vessels/channels in the body through which Energy flows. These are larger than the rest found inside this body part."
					bodypart_type = "Meridian"
					eng_gain_base = 2
					force_gain_base = 1

				//8 extraordinary meridians
				extraordinary_conception_meridian // Gives energy and intelligence mod
				extraordinary_governing_meridian //Gives resistance, energy
				extraordinary_penetrating_meridian //Gives force, energy
				extraordinary_girdle_meridian //Gives energy, endurance, lifespan
				extraordinary_dark_energy_linking_meridian //Gives dark matter and energy,lifespan
				extraordinary_divine_energy_linking_meridian //Gives divine energy and energy,lifespan
				extraordinary_dark_energy_vertical_meridian //Gives, agility, dark matter
				extraordinary_divine_energy_vertical_meridian //Gives, agility, divine energy
				dantian //Place inside toro
					info_name = "Dantian"
					icon_state = "dantian"
					psi_gain_base = 2
					eng_gain_base = 2
					force_gain_base = 2
					lifespan_gain = 1
					divine_eng_gain_base = 1
					bodypart_type = ""
					divine_mod_gain = 0.001
					lvl_max = 1000
					info = "The Dantian is the cornerstone of many ascensions, allowing Divine Energy to collect, flow and be distributed around the body in ever great waves. It is the seat of one's internal divine force, a divine furnace."
			head
				info_name = "Head"
				info = "The head could easily be considered the most important part of a body. It contains various important organs vital not only for the very survival of a being, but limitless potential in helping one hone their mind into a sharp, powerful tool."
				artifical_head_skin
					info_name = "Artifical Head Skin"
					icon_state = "cybernetic"
					res_gain_base = 2
					psi_gain_base = 1
					cybernetic = 1
					bodypart_type = "Organ"
					cybernetics_max = 0
				head_skin
					info_name = "Head Skin"
					icon_state = "organs"
					bodypart_type = "Organ"
					res_gain_base = 2
					psi_gain_base = 1
					heat_gain = 0.001
					cold_gain = 0.001
					micro_gain = 0.0001
					cybernetics_max = 1
					info = "Allow your hide to drink deeply of psionic power, quench it in ever-flowing energy, causing it to become harder, tougher and more resilient to damage."
				head_muscles
					info_name = "Head Muscles"
					str_gain_base = 1
					psi_gain_base = 1
					icon_state = "muscles"
					bodypart_type = "Muscle"
					cybernetics_max = 2
					info = "Although not as present or as pronounced as other parts of the body, head muscles will still contribute greatly to overall strength and power."
				neck_muscles
					info_name = "Neck Muscles"
					icon_state = "muscles"
					str_gain_base = 1
					psi_gain_base = 1
					bodypart_type = "Muscle"
					cybernetics_max = 1
					info = "The neck is a vitally important area that needs protection in most beings. Concentrating psionic energy here will strengthen the muscles and increase raw power."
				neck_bones
					info_name = "Neck Bones"
					icon_state = "bones"
					end_gain_base = 1
					psi_gain_base = 1
					bodypart_type = "Bone"
					cybernetics_max = 1
					info = "Delicate, sparse and vital. Enhanching this area will increase your overall endurance and power."
				skull
					info_name = "Skull"
					info = "A tough skull is a hard nut to crack. Training this bodypart will increase your overall endurance and psionic power slightly."
					end_gain_base = 1
					psi_gain_base = 1
					icon_state = "bones"
					bodypart_type = "Bone"
					cybernetics_max = 3
				teeth
					info_name = "Teeth"
					icon_state = "bones"
					end_gain_base = 1
					psi_gain_base = 1
					off_gain_base = 1
					bodypart_type = "Bone"
					cybernetics_max = 1
					info = "Strong teeth are vital for overall health. They could probably even be used in battle if needed."
				jaw
					info_name = "Jaw"
					icon_state = "bones"
					end_gain_base = 1
					psi_gain_base = 1
					def_gain_base = 1
					bodypart_type = "Bone"
					cybernetics_max = 2
					info = "A strong jaw is potent in both physical combat and philosophical debate. Knowing how to protect it from damage is important, and knowing when to clench it is too."
				artificial_brain
					info_name = "Artificial Brain"
					icon_state = "cybernetic"
					bodypart_type = "Organ"
					psi_gain_base = 5
					eng_gain_base = 1
					divine_eng_gain_base = 1
					int_gain = 0.001
					cybernetic = 1
					cybernetics_max = 0
					desc = "The artificial brain is a highly advanced synthetic device that utilizes quantum computing and mechanics to process information at unparalleled speeds. Its inner workings are shrouded in mystery, and its immense power is still not fully understood. The intricate network of quantum bits and algorithms that make up its structure allows for sophisticated and complex decision-making processes. The artificial brain is a technological marvel, one that only a select few have the expertise to fully comprehend."
				brain
					info_name = "Brain"
					icon_state = "organs"
					bodypart_type = "Organ"
					psi_gain_base = 5 //Makes sense brain would give most pp, since pp is psionic energy, and the brain prduces such.
					eng_gain_base = 1 //Changed from 5 to 1, makes more sense for the heart to give more energy, for obvious reasons.
					lifespan_gain = 1
					divine_eng_gain_base = 1
					cybernetics_max = 4
					int_gain = 0.001
					info = "When infused with psionic energy, the brain becomes an immensely powerful instrument, capable of extending lifespan, enhancing energy levels, and increasing physical and mental power. Psionic stimulation leads to a positive influence on the brain's waves, resulting in enhanced cognitive function and elevated performance. This process can be achieved through a range of methods such as psiforging or telekinetic training, with significant benefits for those who succeed. By manipulating brain waves, psionic energy unlocks vast potential for individuals, allowing them to reach previously unattainable levels of skill, ability, and overall power."
				voice_synthesizer
					info_name = "Voice Synthesizer"
					icon_state = "cybernetic"
					bodypart_type = "Organ"
					psi_gain_base = 1
					eng_gain_base = 1
					cybernetic = 1
					cybernetics_max = 0
				thyroid
					info_name = "Thyroid"
					icon_state = "organs"
					bodypart_type = "Organ"
					psi_gain_base = 1
					eng_gain_base = 1
					lifespan_gain = 1
					cybernetics_max = 1
				tongue
					info_name = "Tongue"
					icon_state = "organs"
					bodypart_type = "Organ"
					psi_gain_base = 1
					eng_gain_base = 1
					cybernetics_max = 1
				mouth
					info_name = "Mouth"
					icon_state = "organs"
					bodypart_type = "Organ"
					psi_gain_base = 1
					eng_gain_base = 1
					cybernetics_max = 2
				left_hearing_sensor
					info_name = "Left Hearing Sensor"
					def_gain_base = 1
					psi_gain_base = 1
					def_gain_base = 1
					icon_state = "cybernetic"
					bodypart_type = "Organ"
					cybernetic = 1
					cybernetics_max = 0
				right_hearing_sensor
					info_name = "Right Hearing Sensor"
					def_gain_base = 1
					psi_gain_base = 1
					def_gain_base = 1
					icon_state = "cybernetic"
					bodypart_type = "Organ"
					cybernetic = 1
					cybernetics_max = 0
				left_ear
					info_name = "Left Ear"
					def_gain_base = 1
					psi_gain_base = 1
					def_gain_base = 1
					icon_state = "organs"
					bodypart_type = "Organ"
					cybernetics_max = 2
				right_ear
					info_name = "Right Ear"
					def_gain_base = 1
					psi_gain_base = 1
					def_gain_base = 1
					icon_state = "organs"
					bodypart_type = "Organ"
					cybernetics_max = 2
				left_light_sensor
					info_name = "Left Light Sensor"
					off_gain_base = 1
					psi_gain_base = 1
					def_gain_base = 1
					icon_state = "cybernetic"
					bodypart_type = "Organ"
					cybernetic = 1
					cybernetics_max = 0
				right_light_sensor
					info_name = "Right Light Sensor"
					off_gain_base = 1
					psi_gain_base = 1
					def_gain_base = 1
					icon_state = "cybernetic"
					bodypart_type = "Organ"
					cybernetic = 1
					cybernetics_max = 0
				left_eye
					info_name = "Left Eye"
					off_gain_base = 1
					psi_gain_base = 1
					def_gain_base = 1
					icon_state = "organs"
					bodypart_type = "Organ"
					cybernetics_max = 2
				right_eye
					info_name = "Right Eye"
					off_gain_base = 1
					psi_gain_base = 1
					def_gain_base = 1
					icon_state = "organs"
					bodypart_type = "Organ"
					cybernetics_max = 2
				smell_sensor
					info_name = "Smell Sensor"
					icon_state = "cybernetic"
					eng_gain_base = 1
					end_gain_base = 1
					recov_mod_gain = 0.0005
					bodypart_type = "Organ"
					cybernetic = 1
					cybernetics_max = 0
				nose
					info_name = "Nose"
					icon_state = "organs"
					eng_gain_base = 1
					end_gain_base = 1
					recov_mod_gain = 0.0005
					bodypart_type = "Organ"
					cybernetics_max = 1
			torso
				info_name = "Torso"
				artifical_torso_skin //Resistant to outside elements
					info_name = "Artifical Torso Skin"
					icon_state = "cybernetic"
					res_gain_base = 2
					psi_gain_base = 1
					cybernetic = 1
					bodypart_type = "Organ"
					cybernetics_max = 0
				torso_skin //Resistant to outside elements
					info_name = "Torso Skin"
					icon_state = "organs"
					res_gain_base = 2
					psi_gain_base = 1
					bodypart_type = "Organ"
					heat_gain = 0.001
					cold_gain = 0.001
					micro_gain = 0.0001
					cybernetics_max = 3
					info = "Allow your hide to drink deeply of psionic power, quench it in ever-flowing energy, causing it to become harder, tougher and more resilient to damage. Through the infusion of psionic energy into your skin, your body can develop increased resistance against the harshness of the elements and disruptive energies. With this, your physical prowess can transcend to new heights of resilience, enabling you to withstand even the most potent forces. Let your training be the conduit for this transformation, and you shall reap the rewards of a body that can weather any storm."
				back_muscles
					info_name = "Back Muscles"
					icon_state = "muscles"
					str_gain_base = 1
					psi_gain_base = 1
					bodypart_type = "Muscle"
					cybernetics_max = 2
					info = "By imbuing your powerful back muscles with the potent energy of the mind, you can transform your physique into a formidable force to be reckoned with. The infusion of psionic might provides the essential foundation for increased endurance and remarkable strength, enabling you to face even the most grueling physical challenges with ease. The confluence of psionic power and muscle fiber is a synergy that sets the stage for unparalleled physical prowess."
				chest_muscles
					info_name = "Chest Muscles"
					icon_state = "muscles"
					str_gain_base = 1
					psi_gain_base = 1
					bodypart_type = "Muscle"
					cybernetics_max = 2
					info = "Infusing your pectoral muscles with psionic energy, achieved through arduous training, unlocks tremendous power. Psionic energy enhances the strength and endurance of muscle fibers, enabling them to contract with greater force, speed, and precision. The result is an increase in chest size and strength."
				hip_muscles
					info_name = "Hip Muscles"
					icon_state = "muscles"
					str_gain_base = 1
					psi_gain_base = 1
					bodypart_type = "Muscle"
					cybernetics_max = 1
					info = "The hip muscles are a vital source of power and stability, and through rigorous training and psionic infusion, they can become even more formidable. By tapping into the latent energy within these muscles, one can enhance their strength and agility, allowing them to move with a newfound grace and precision. The psionic energy amplifies the contraction and relaxation of these muscles, allowing for explosive movements and rapid changes in direction. In addition, the enhanced hip muscles provide a sturdy foundation for striking with force, ensuring maximum impact with every blow."
				abdominal_muscles
					info_name = "Abdominal Muscles"
					icon_state = "muscles"
					str_gain_base = 1
					psi_gain_base = 1
					bodypart_type = "Muscle"
					cybernetics_max = 2
					info = "Through rigorous training and focus, one can harness their body's potential, turning their abdominal muscles into a source of deadly power. With each movement, the muscles strengthen, their fibers knitting together in a weave of force and resilience. This conditioning creates a strong, unyielding core, capable of unleashing devastating attacks with blinding speed and accuracy. The abdominal muscles are the foundation upon which a powerful, deadly form is built."
				right_clavicle
					info_name = "Right Clavicle"
					icon_state = "bones"
					end_gain_base = 1
					psi_gain_base = 1
					bodypart_type = "Bone"
					cybernetics_max = 1
				left_clavicle
					info_name = "Left Clavicle"
					icon_state = "bones"
					end_gain_base = 1
					psi_gain_base = 1
					bodypart_type = "Bone"
					cybernetics_max = 1
				sternum
					info_name = "Sternum"
					icon_state = "bones"
					end_gain_base = 1
					psi_gain_base = 1
					bodypart_type = "Bone"
					cybernetics_max = 1
					info = "Suffusing your sternum with potent psionic power may bestow upon your body enhanced strength, resilience and durability. The numerous osteons and trabeculae that comprise this bone can readily absorb the energizing force, permeating every inch of the skeletal structure with rejuvenating vigor. The resulting augmentation of your physical attributes will grant you greater endurance and vitality, and prepare you for the rigors of battle or other demanding physical activities."
				ribcage
					info_name = "Ribcage"
					icon_state = "bones"
					end_gain_base = 1
					psi_gain_base = 1
					bodypart_type = "Bone"
					cybernetics_max = 1
					info = "Suffusing your ribcage with psychic energy can imbue your body with heightened endurance and resilience. The ribcage serves as a crucial protective barrier for your vital organs, and by strengthening it with psionic power, you can better withstand physical trauma and external forces. The porous structure of the ribs also facilitates the flow of psychic energy, making them an ideal conduit for the infusion of psionic might."
				spine
					info_name = "Spine"
					icon_state = "bones"
					end_gain_base = 1
					psi_gain_base = 1
					gravity_gain = 0.0005
					bodypart_type = "Bone"
					cybernetics_max = 2
					info = "The spine is the foundation of the body, and by suffusing it with the potent energy of the mind, one can awaken its full potential. A conduit for the flow of vital energy, the spine can be trained to withstand even the most intense gravitational forces. As the energy flows through each vertebra, it transforms the bones, muscles, and nerves into a superstructure of strength and resilience. With each passing day, the spine becomes more aligned, more powerful, and more attuned to the subtle energies of the universe. It is a testament to the power of the mind, and a symbol of the infinite potential that lies within every being."
				pelvis
					info_name = "Pelvis"
					icon_state = "bones"
					end_gain_base = 1
					psi_gain_base = 1
					bodypart_type = "Bone"
					cybernetics_max = 1
					info = "The pelvic bone is a crucial foundation for the frame, and by infusing it with psionic power, it can become a wellspring of strength and resilience. The dense and sturdy nature of the bone makes it a suitable canvas for the infusion of this power, resulting in an amplification of your physical might and endurance. As the power courses through your pelvis bone, it imbues you with a newfound vitality, allowing you to push your body to its limits and beyond."
				nuclear_core
					info_name = "Nuclear Core"
					icon_state = "cybernetic"
					psi_gain_base = 1
					recov_mod_gain = 0.001
					eng_gain_base = 5
					cybernetic = 1
					bodypart_type = "Organ"
					cybernetics_max = 0
					desc = "A Nuclear Core is the powerful, yet compact synthetic device that serves as the primary energy source for advanced androids. The inner workings of this device are based on intricate fusion and fission reactions, tightly controlled by quantum mechanics and complex algorithms. Upgrading this device could potentially unlock even more efficient energy production and improve the android's capabilities, while minimizing any radiation or thermal output. The Nuclear Core is a marvel of modern engineering and is essential to the operation of advanced synthetic beings."
				self_repair_system
					info_name = "Self-Repair System"
					icon_state = "cybernetic"
					psi_gain_base = 1
					regen_mod_gain = 0.001
					cybernetic = 1
					bodypart_type = "Organ"
					cybernetics_max = 0
					desc = "A Self-Repair System is a sophisticated technology embedded within an android, capable of repairing itself without external intervention. This device utilizes advanced materials, such as self-healing polymers, and cutting-edge sensors to detect damage and initiate the repair process. The system works by analyzing the extent of the damage and creating new materials to replace the damaged ones. Upgrading this technology would result in faster and more efficient repair times, thereby reducing maintenance costs for the android."
				coolant_pump //Android heart
					info_name = "Coolant Pump"
					icon_state = "cybernetic"
					psi_gain_base = 1
					eng_gain_base = 5
					recov_mod_gain = 0.001
					divine_eng_gain_base = 1
					cybernetic = 1
					bodypart_type = "Organ"
					cybernetics_max = 0
					desc = "The coolant pump, a highly advanced synthetic device, serves as the cooling system for an android's vital components, analogous to the human heart. Its inner workings rely on complex fluid dynamics and thermodynamics to remove excess heat generated by the android's electrical and mechanical components. Upgrading the coolant pump could enhance its efficiency, optimize heat transfer, and reduce energy consumption. These benefits could result in improved overall performance and reliability, reducing the likelihood of component failure and ensuring sustained operation of the android."
				thymus
					info_name = "Thymus"
					icon_state = "organs"
					psi_gain_base = 1
					eng_gain_base = 1
					lifespan_gain = 1
					end_gain_base = 1
					rads_gain = 0.0003
					bodypart_type = "Organ"
					cybernetics_max = 1
					info = "The thymus, a gland located in the upper chest, plays a vital role in immune system function. By infusing it with psionic power, you can increase your body's ability to resist radiation and other harmful elements, leading to improved health, energy, and a longer lifespan. The thymus is a critical mediator of immune function and the production of T-cells, the body's primary defense against pathogens. Thus, suffusing it with psionic power can confer significant benefits and enhance your overall physical resilience and power."
				heart //Derive great raw power from the heart, also helps you recover energy faster and better.
					info_name = "Heart"
					icon_state = "organs"
					psi_gain_base = 1 //Nerfed from 10 to 1, makes more sense for brain to be organ that gives the most pp.
					eng_gain_base = 5 //Makes sense for the heart to give the most energy, instead of the brain.
					recov_mod_gain = 0.001
					lifespan_gain = 1
					divine_eng_gain_base = 1
					bodypart_type = "Organ"
					cybernetics_max = 2
					info = "Suffusing your heart with psionic energy can significantly enhance your health, lifespan, energy, and rcovery while also supplying you with a unique type of energy known as divine energy. This energy functions as a conduit for the highest order of consciousness, imbuing you with an unparalleled strength and power. The heart's functionality as a central circulatory organ and electrical conduction system enables it to act as a resonator of psionic energy, generating an electromagnetic field that amplifies the energetic effects of psionic suffusion. Such enhancement of the heart's functionality represents a crucial step towards achieving optimal wellness and longevity."
				voltage_adaptor //Android liver
					info_name = "Voltage Adaptor"
					icon_state = "cybernetic"
					eng_gain_base = 2
					psi_gain_base = 1
					bodypart_type = "Organ"
					cybernetic = 1
					cybernetics_max = 0
					desc = "A Voltage Adaptor is a crucial component of an advanced synthetic device, such as an android, as it ensures stable and safe power delivery to all its internal components. Its inner workings involve advanced circuitry and electronic components that convert and regulate electrical signals to ensure the proper voltage and current are supplied. Upgrading the Voltage Adaptor can result in increased efficiency, improved power management, and enhanced overall performance of the synthetic device, allowing it to handle more demanding tasks and operations without risk of damage from power fluctuations."
				liver //Helps with the creation of energy and psi power
					info_name = "Liver"
					icon_state = "organs"
					lifespan_gain = 1
					eng_gain_base = 2
					psi_gain_base = 1
					bodypart_type = "Organ"
					cybernetics_max = 1
					toxin_gain = 0.0005
					info = "Suffusing your liver with psionic power can stimulate liver cell regeneration, activate detoxification pathways and promote a healthy immune system. This can enhance longevity, increase energy levels and fortify the body against toxins. Psionic energy acts as a potent antioxidant, neutralizing free radicals and reducing oxidative stress on the liver. The liver's detoxification capabilities are further bolstered by psionic energy, allowing for efficient clearance of harmful substances. The hepatic microenvironment is also modulated, providing an environment conducive to health and well-being. With psionic power, your liver can become a resilient fortress against toxic assault."
				heatsink //Android lungs
					info_name = "Heatsink"
					icon_state = "cybernetic"
					force_gain_base = 1
					eng_gain_base = 5
					recov_mod_gain = 0.001
					cybernetic = 1
					bodypart_type = "Organ"
					cybernetics_max = 0
					psi_gain_base = 1
					desc = "A heatsink is a highly advanced synthetic device embedded in an android that plays a crucial role in dissipating heat generated by its internal components. It works by absorbing and transferring heat away from the device, allowing it to operate at optimal temperatures, thereby increasing its energy efficiency and power output. Upgrading the heatsink can further enhance its performance by increasing its ability to dissipate heat, which improves recovery time between high-intensity operations and allows the android to operate for longer periods without overheating."
				lungs //Helps you recovery energy and increases max energy
					info_name = "Lungs"
					icon_state = "organs"
					force_gain_base = 1
					eng_gain_base = 5
					recov_mod_gain = 0.001
					lifespan_gain = 1
					bodypart_type = "Organ"
					cybernetics_max = 2
					divine_eng_gain_base = 1
					o2_gain = 1
					info = "The infusion of psionic power into the lungs can lead to a dramatic increase in lifespan, energy levels, and recovery rates, while also boosting the potency of energy attacks. The lungs possess the unique ability to transmute ordinary energy into divine energy through a process that involves the passage of energy through the lungs and into the dantian, a divine furnace within the body. This transmutation process is aided by the complex network of alveoli and capillaries within the lungs, which provide an ideal environment for the transformation of energy. The resulting divine energy can then be harnessed for a wide range of physical and spiritual purposes."
				left_battery //Android kidneys
					info_name = "Left Battery"
					icon_state = "cybernetic"
					eng_gain_base = 5
					recov_mod_gain = 0.0005
					cybernetic = 1
					bodypart_type = "Organ"
					cybernetics_max = 0
					psi_gain_base = 1
				right_battery //Android kidneys
					info_name = "Right Battery"
					icon_state = "cybernetic"
					eng_gain_base = 5
					recov_mod_gain = 0.0005
					cybernetic = 1
					bodypart_type = "Organ"
					cybernetics_max = 0
					psi_gain_base = 1
				gall_bladder //Helps keep the body flushed
					info_name = "Gall Bladder"
					icon_state = "organs"
					lifespan_gain = 1
					eng_gain_base = 1
					recov_mod_gain = 0.0005
					bodypart_type = "Organ"
					cybernetics_max = 1
					toxin_gain = 0.0005
					info = "when infusing your Gall Bladder with psionic power, you can enhance your health, longevity, vigor, and recuperative abilities. Psionic energy boosts the Gall Bladder's role in breaking down fats and toxins, aiding digestion and elimination, and regulating bodily functions. This amplifies the Gall Bladder's capacity to metabolize nutrients, eliminate waste, and improve bodily functions. With the enhanced power of psionic energy, your Gall Bladder can improve your overall health and well-being, energize your body, and promote faster recovery from illness and injury."
				urinary_bladder //Helps keep the body flushed
					info_name = "Urinary Bladder"
					icon_state = "organs"
					lifespan_gain = 1
					eng_gain_base = 1
					rads_gain = 0.0001
					bodypart_type = "Organ"
					cybernetics_max = 1
				left_kidney //Helps produce good, clean energy in the body
					info_name = "Left Kidney"
					icon_state = "organs"
					lifespan_gain = 1
					eng_gain_base = 2
					recov_mod_gain = 0.0005
					rads_gain = 0.0003
					bodypart_type = "Organ"
					cybernetics_max = 1
					toxin_gain = 0.00025
					info = "When infusing your kidneys with psionic power, you can increase your lifespan, energy, and recovery, while also enhancing your resistance to radiation and toxins. This is achieved by strengthening the kidneys' filtration and detoxification abilities, as well as improving the production and regulation of hormones that control bodily processes. The psionic energy enhances the cellular function of the kidneys, improving their overall performance and ability to fight off harmful elements. It's a powerful way to optimize your body's natural defenses and ensure your health and vitality for years to come."
				right_kidney //Helps produce good, clean energy in the body
					info_name = "Right Kidney"
					icon_state = "organs"
					lifespan_gain = 1
					eng_gain_base = 2
					recov_mod_gain = 0.0005
					rads_gain = 0.0003
					bodypart_type = "Organ"
					cybernetics_max = 1
					toxin_gain = 0.00025
					info = "When suffusing your kidneys with psionic power, you can increase your lifespan, energy, and recovery, while also enhancing your resistance to radiation and toxins. This is achieved by strengthening the kidneys' filtration and detoxification abilities, as well as improving the production and regulation of hormones that control bodily processes. The psionic energy enhances the cellular function of the kidneys, improving their overall performance and ability to fight off harmful elements. It's a powerful way to optimize your body's natural defenses and ensure your health and vitality for years to come."
				servomotors
					info_name = "Servomotors"
					icon_state = "cybernetic"
					eng_gain_base = 2
					psi_gain_base = 1
					bodypart_type = "Organ"
					cybernetic = 1
					cybernetics_max = 0
					desc = "A Servomotor is a highly advanced synthetic device that provides precise motion control in machines, robots, and other automated systems. It functions using a closed-loop control system that integrates feedback sensors, amplifiers, and an actuator to provide accurate and reliable motion control. The Servomotor is essential for the precise movement of limbs, fingers, and other body parts of an android, ensuring smooth and precise operation. Upgrading the Servomotor with more advanced technology can improve the speed, accuracy, and torque output, enabling an android to perform more complex tasks and maneuvers with greater efficiency and precision."
				pancreas
					info_name = "Pancreas"
					icon_state = "organs"
					lifespan_gain = 1
					eng_gain_base = 2
					bodypart_type = "Organ"
					psi_gain_base = 1
					cybernetics_max = 1
					info = "By infusing your pancreas with psionic power, you can stimulate the production of insulin and other important hormones, promoting balanced blood sugar levels, and thus increasing your overall health and energy. Additionally, psionic energy may protect pancreatic cells from oxidative stress and damage, potentially extending your lifespan. Harnessing the power of the pancreas in this way is an exciting prospect for those seeking to optimize their bodily functions and achieve greater vitality."
				spleen //Helps greatly with regen and resistance
					info_name = "Spleen"
					icon_state = "organs"
					regen_mod_gain = 0.001
					res_gain_base = 1
					lifespan_gain = 2
					bodypart_type = "Organ"
					cybernetics_max = 1
					info = "Toning your spleen with psionic power is a remarkable process that can enhance your longevity and vitality. Through this method, your spleen is imbued with a powerful energetic charge that strengthens its functions, resulting in improved immune system responses, enhanced nutrient absorption, and an increase in overall physical endurance. This process also fosters the production of red and white blood cells, making the spleen a critical factor in maintaining a healthy cardiovascular system. Toning the spleen is a transformational journey that unlocks its full potential, allowing for a more robust and resilient physical body."
				large_intestines //Good at creating energy and force power
					info_name = "Large Intestines"
					icon_state = "organs"
					lifespan_gain = 1
					eng_gain_base = 2
					force_gain_base = 1
					bodypart_type = "Organ"
					cybernetics_max = 1
					info = "Infusing your Large Intestines with psionic power can enhance your lifespan, energy, and spiritual force. This process stimulates the Large Intestine's immune and metabolic functions, leading to an increase in the production of ATP, which provides energy for cellular processes. Psionic power also aids in the absorption of nutrients and elimination of toxins, further contributing to overall vitality. Additionally, toning activates the Large Intestine's connection to the meridian system, promoting the flow of Qi, or vital energy, throughout the body, boosting spiritual force."
				small_intestines //Good at creating energy and force power
					info_name = "Small Intestines"
					icon_state = "organs"
					lifespan_gain = 1
					eng_gain_base = 1
					force_gain_base = 1
					bodypart_type = "Organ"
					cybernetics_max = 1
					info = "Through the process of toning, the infusion of psionic power into the small intestines has been shown to increase not only one's lifespan, but also their energy and spiritual force. This occurs through the enhancement of metabolic and immunological functions, as well as the stimulation of musculoskeletal tissue regeneration. The small intestine, as a key site of nutrient absorption and immune response, serves as a nexus for the exchange of energy and matter, and thus plays a critical role in the maintenance and optimization of the body's physiological processes."
				bio_processor //Android stomach
					info_name = "Bio-Processor"
					icon_state = "cybernetic"
					eng_gain_base = 2
					force_gain_base = 1
					cybernetic = 1
					bodypart_type = "Organ"
					cybernetics_max = 0
					psi_gain_base = 1
					desc = "An artificial stomach is a highly advanced synthetic device designed to simulate the digestive processes of a biological stomach. It consists of multiple layers of specialized membranes, advanced sensors, and a network of interconnected chambers and channels. When food or nutrients enter the stomach, the artificial digestive enzymes and acids are secreted to break down the nutrients into smaller molecules that can be absorbed and converted into energy by the android's systems. Upgrading the artificial stomach can improve the efficiency of nutrient absorption and energy conversion, resulting in increased power and energy for the android."
				stomach //Good at creating energy and force power
					info_name = "Stomach"
					icon_state = "organs"
					lifespan_gain = 1
					eng_gain_base = 2
					force_gain_base = 1
					bodypart_type = "Organ"
					cybernetics_max = 1
					info = "Toning your stomach with psionic energy can unleash a cascade of physiological and metabolic benefits, boosting lifespan, energy, and force. As the seat of the dantian and the starting point of digestion, the stomach is a critical site for psionic enhancement. By channelling divine energy from the lungs, toning the stomach enhances the gut-brain axis and optimizes the immune system, resulting in better digestion, improved energy utilization, and increased physical strength. This psionic infusion amplifies the body's natural regenerative capacity, fortifying you against the ravages of time and disease."

			cybernetics
				// Synthetics are completely new organs created from scratch using tech
				// Cybernetics are robotic enhancements that attach to organic parts
				/*
				Start off at lvl 10, then can be upgraded via techie or robotic upgrade kits?
				Maybe add a sub-menu for bodyparts, per part, that displays their cyberware?
				Counter for max cyberware? i.e 2/10
				*/
				vis_flags = VIS_INHERIT_PLANE | VIS_INHERIT_LAYER
				cybernetic = 1
				cybernetics_max = 0
				icon_state = "cybertech"
				bodypart_type = "Organ"
				value = 1000000
				can_pocket = 1
				stacks = -1
				level = 10
				tech_parent_path = /obj/items/tech/sub_tech/Engineering/Cybernetics
				act = /obj/body_related/bodyparts/cybernetics/proc/use
				act_drop = /obj/body_related/bodyparts/cybernetics/proc/drop
				proc
					use(var/mob/m,var/obj/i)
						if(i in m)
							for(var/mob/x in view(1,m))
								if(x)
									if(x.race == "Android")
										m.set_alert("Unable to apply cybertech as an Android",'alert.dmi',"alert")
									//	m.create_chat_entry("alerts","Unable to apply cybertech as an Android.")
										return
									if(m.open_body == 0)
										m.open_body = 1
										m.open_menus.Add(".open_body")
										if(x.hud_body) m.client.screen += x.hud_body
									m.set_alert("Choose bodypart",i.icon,i.icon_state)
									m.left_click_function = "apply cybertech"
									m.left_click_ref = i
									m.cyborging =1
					drop(var/mob/m,var/obj/items/i)
						m.drop(i)
				New()
					..()
					spawn(10)
						if(src && src.loc)
							src.name = src.info_name
				MouseEntered(location,control,params)
					usr.mouse_over = src
					if(src.loc)
						if(isturf(src.loc))
							if(src.over == null)
								var/image/sel = image(src.icon,src)
								sel.loc = src
								src.over = sel
							usr.client.images += src.over
						else if(length(src.filters) <= 0) src.filters += filter(type="outline", size=1, color=rgb(255,255,255))
						while(src && usr && usr.mouse_over && usr.mouse_over == src && src.over)
							src.over.icon = src.icon
							src.over.icon_state = src.icon_state
							src.over.overlays = src.overlays
							src.over.underlays = src.underlays
							if(src.grabbed_by || src.tk) src.over.pixel_z = src.pixel_z-16
							src.over.dir = src.dir
							src.over.filters = filter(type="outline", size=1, color="white")
							sleep(1)
				MouseExited(location,control,params)
					usr.client.images -= src.over
					usr.mouse_over = null
					if(!isturf(src.loc))
						if(length(src.filters) <= 1) src.filters -= filter(type="outline", size=1, color=rgb(255,255,255))
				Click(location,control,params)
					..()
					params = params2list(params)
					var/dir = null
					if(params["left"] || usr.mouse_dir == "left")
						dir = "left"
					if(params["right"] || usr.mouse_dir == "right")
						dir = "right"
					if(dir == "left")

						if(src.loc == null)
							usr.build_tech_selected = src
						else if(isturf(src.loc))
							usr.pickup(src)
						else if(src.loc == usr)
							usr.hud_inv.item_desc.maptext = "[css_outline]<font size = 1><text align=center valign=top>[src.name]<text align=left valign=top>\n\nRarity: [global.rarity_color[src.rarity]]\n\n[src.desc_extra][src.desc]"
							if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
							usr.item_selected = src
							src.overlays -= /obj/effects/select_item
							src.overlays += /obj/effects/select_item
				weaved_adamantium_reinforcement_bundles //Increase limb endurance
					end_gain_base = 1
					info_name = "Weaved Adamantium Reinforcement Bundles"
					desc_extra = "Applied to Muscles\n\n"
					compatible = list("Muscle")
					desc = "Weaved Adamantium Reinforcement Bundles are a cybernetic enhancement that consists of bundles of tightly woven Adamantium fibers placed through the user's muscles. These fibers increase the tensile strength of the muscles and provide reinforcement to the skeletal structure, resulting in increased endurance and resistance to physical trauma. The fibers are expertly woven to avoid muscle impingement, and the material's high biocompatibility ensures long-lasting integration with the body. This cutting-edge technology is a game-changer for those seeking to augment their physical abilities to new heights."
				threaded_steel_micro_fibers //Increase limb strength
					str_gain_base = 1
					info_name = "Threaded Steel Micro Fibers"
					desc_extra = "Applied to Muscles\n\n"
					compatible = list("Muscle")
					desc = "Threaded Steel Micro Fibers are a revolutionary cybernetic technology designed to augment the strength of musculature. These microfibers, composed of high-strength steel, are woven through the muscles of the user, increasing the force output of each individual muscle fiber. This technological marvel uses nanoscale threads to create a network of interwoven steel fibers, reinforcing the natural muscle structure and creating a synergistic effect that exponentially increases the overall strength of the user. The result is a massive increase in raw physical power, giving the user an unparalleled advantage in any situation requiring force or manual labor."
				molecularly_hardened_steel_coating //Increase bone endurance in limb
					end_gain_base = 1
					info_name = "Molecularly Hardened Steel Coating"
					desc_extra = "Applied to Bones\n\n"
					desc = "The Molecularly Hardened Steel Coatings are a highly advanced cybernetic coating that use cutting-edge nanotechnology to provide unmatched durability and endurance to the user's skeletal structure. The steel coatings are infused with specialized molecules that increase the tensile strength of the material, allowing the bones to withstand incredible amounts of force and pressure. The molecular hardening process also enhances the coating's ability to absorb and dissipate shock, protecting the user from the impact of heavy blows and falls. With this device, the user can push their physical limits to new heights, enduring even the most grueling physical challenges with ease."
					compatible = list("Bone")
				cybernetic_leg_implants
					servo_hydraulic_leg_enhancers //Increase agility
						spd_mod_gain = 0.001
						info_name = "Servo Hydraulic Leg Enhancers"
						desc_extra = "Applied to Leg parts\n\n"
						compatible = list(/obj/body_related/bodyparts/left_leg/,/obj/body_related/bodyparts/right_leg/)
						desc = "The Servo Hydraulic Leg Enhancers are a cybernetic device that attach to both legs, boosting agility through advanced servo-hydraulic technology. These devices utilize high-powered hydraulic actuators and precision-engineered servos to provide increased power output and precise control over the user's leg movements. By enhancing the strength and speed of the user's leg muscles, these devices enable faster, more agile movements, as well as enhanced jumping and acrobatic abilities. With these cybernetic leg enhancers, users can perform incredible feats of athleticism and maneuverability beyond the limitations of the body."
				cybernetic_arm_implants
					retractable_razor_talons //Extra bleeding damage on hit?
						info_name = "Retractable Razor Talons"
						desc_extra = "Applied to Fingers\n\n"
					radioactive_lancet_applicator //Does poison/radiation dmg on hit?
						info_name = "Radioactive Lancet Applicator"
						desc_extra = "Applied to Forearm\n\n"
					servo_hydraulic_arm_enhancers //Increase strength
						str_gain_base = 1
						info_name = "Servo Hydraulic Arm Enhancers"
						desc_extra = "Applied to Arm parts\n\n"
						compatible = list(/obj/body_related/bodyparts/left_arm/,/obj/body_related/bodyparts/right_arm/)
						desc = "The Servo Hydraulic Arm Enhancers are a cutting-edge cybernetic device that significantly augments the user's physical strength. These advanced bionic limbs are intricately engineered with hydraulic actuators, sophisticated sensors, and precision motors that provide the wearer with an unprecedented level of power and control. The device interfaces directly with the user's nervous system, allowing them to perform feats of strength previously impossible. The enhanced limbs are coated with advanced polymers to resist wear and tear, ensuring long-lasting performance even in the most demanding situations."
				cybernetic_skeletal_implants
				cybernetic_muscular_implants
				cybernetic_skin_implants
					compatible = list("Skin")
					subdermal_hardened_plating //Increase endurance
						end_gain_base = 1
						info_name = "Subdermal Hardened Plating"
						desc_extra = "Applied to Skin parts\n\n"
						desc = "Subdermal Hardened Plating is an advanced cybernetic implant that is surgically embedded beneath the skin to reinforce the body's natural structure and increase the user's endurance. The plating is made of an ultra-durable, lightweight material that is resistant to physical trauma and can absorb a significant amount of force. The implant's innovative design promotes rapid tissue regeneration and strengthens the body's natural defenses against environmental stressors. It functions by redirecting the energy from incoming forces, preventing damage to internal organs and tissues. This technology is the perfect solution for individuals seeking to enhance their physical durability, allowing them to endure more rigorous activity and combat challenging environments."
					subdermal_lead_plating //Radiation protecion
						rads_gain = 0.01
						info_name = "Subdermal Lead Plating"
						desc_extra = "Applied to Skin parts\n\n"
						desc = "The subdermal lead plating is a remarkable cybernetic device that offers a formidable defense against the harmful effects of radiation. It consists of thin sheets of lead alloy, which are strategically implanted under the skin to provide maximum protection while maintaining a sleek appearance. The device employs advanced metallurgical and biomechanical engineering to ensure optimal performance, stability, and biocompatibility with the host organism. The lead plating shields the body tissues from ionizing radiation by absorbing and scattering the energetic particles, thereby mitigating the damage and reducing the risk of cancer, tissue necrosis, and other radiation-related pathologies."
					subdermal_carbide_ceramic_plating //Heat protection
						heat_gain = 0.01
						info_name = "Subdermal Carbide Ceramic Plating"
						desc_extra = "Applied to Skin parts\n\n"
						desc = "The Subdermal Carbide Ceramic Plating is a state-of-the-art cybernetic device that enhances the user's endurance and resistance to heat by providing a reinforced ceramic layer beneath the skin. This cutting-edge plating system contains carbide, a compound that offers excellent thermal stability, hardness, and wear resistance. It also has a high melting point, allowing it to withstand high temperatures and protect the skin from burns or heat-related injuries. The subdermal implantation of the Carbide Ceramic Plating provides superior protection for individuals who require increased thermal resistance for extended periods."
					subdermal_photosynthesizing_panels //Increase energy
						eng_gain_base = 1
						info_name = "Subdermal Photosynthesizing Panels"
						desc_extra = "Applied to Skin parts\n\n"
						desc = "Subdermal Photosynthesizing Panels are a cutting-edge cybernetic implant designed to harness the power of photosynthesis and convert light into usable energy for the human body. The panels utilize a complex network of photovoltaic cells and specialized enzymes to catalyze the conversion of light into chemical energy, thereby providing the host with a renewable source of energy. With this implant, the host can enjoy increased stamina, endurance, and productivity, while also reducing their reliance on traditional sources of energy. "
					subdermal_polyurethane_sheets //Cold protection
						cold_gain = 0.01
						info_name = "Subdermal Polyurethane Sheets"
						desc_extra = "Applied to Skin parts\n\n"
						desc = "Subdermal Polyurethane Sheets are a revolutionary cybernetic device designed to improve the body's resistance to cold temperatures. This advanced technology is composed of layers of polyurethane material, a highly elastic polymer that can withstand extreme temperatures. When implanted beneath the skin, these sheets create a barrier that prevents heat loss, helping the user maintain their body temperature in cold environments. The flexible nature of the material also allows for natural movement and comfort, ensuring maximum effectiveness without impeding daily activities. This cutting-edge device is the ultimate solution for those seeking to enhance their cold resistance and thrive in frigid conditions."
					subdermal_nanoweave_threading//Increase resistance
						res_gain_base = 1
						info_name = "Subdermal Nanoweave Threading"
						desc_extra = "Applied to Skin parts\n\n"
						desc = "Subdermal Nanoweave Threading is a revolutionary cybernetic device that enhances the user's ability to withstand energy-based attacks. It is made up of millions of tiny, interwoven fibers that create a flexible and durable armor-like layer under the skin. The fibers are designed to disperse and absorb energy, minimizing the impact of harmful energy-based attacks. The threading is also able to seamlessly integrate with the user's natural tissue, ensuring optimal comfort and minimal side effects. This technology represents a significant advancement in the field of cybernetics, providing users with an unprecedented level of protection and safety."
				cybernetic_nervous_system_implants
					compatible = list("All")
					hyper_elastic_monomolecular_tendrils //Increase agility
						spd_mod_gain = 0.001
						info_name = "Hyper Elastic Monomolecular Tendrils"
						desc_extra = "Applied to any parts\n\n"
					bioelectric_electromagnetic_amalgamator //Increase offence
						off_gain_base = 1
						info_name = "Bioelectric Electromagnetic Amalgamator"
						desc_extra = "Applied to any parts\n\n"
					synaptic_necrosis_fibrils //Increase endurance
						end_gain_base = 1
						info_name = "Synaptic Necrosis Fibrils"
						desc_extra = "Applied to any parts\n\n"
				cybernetic_circulatory_implants
					compatible = list(/obj/body_related/bodyparts/torso/heart)
					cardiovascular_hyper_pump //Increase strength
						str_gain_base = 1
						info_name = "Cardiovascular Hyper Pump"
						desc_extra = "Applied to Heart\n\n"
						desc = "The cardiovascular hyper pump is a cybernetic device that provides a powerful boost to the user's physical strength. This innovative technology attaches to the heart and works by augmenting the heart's performance, increasing blood flow, and providing greater oxygenation to the muscles. The device's advanced design uses cutting-edge materials, including nanofibers and polymers, to optimize the flow of blood and enhance cardiovascular efficiency. Through this, the cardiovascular hyper pump enables the user to achieve greater feats of strength and endurance, enhancing their physical capabilities beyond what was previously thought possible."
					coagulation_regulation_stimulator //Increase endurance
						end_gain_base = 1
						info_name = "Coagulation Regulation Stimulator"
						desc_extra = "Applied to Heart\n\n"
						desc = "The coagulation regulation stimulator is a cutting-edge cybernetic device that attaches to the heart, bolstering the user's endurance and stamina. Using advanced technology, the device promotes the efficient clotting of blood and increases the oxygen-carrying capacity of the blood cells, enhancing the body's ability to withstand physical stressors. The stimulator works by modulating the activity of key enzymes and signaling pathways in the cardiovascular system, optimizing the transport of nutrients and waste products to and from the cells. With its state-of-the-art design and precise regulatory mechanisms, the coagulation regulation stimulator is a powerful tool for maximizing physical performance and overall health."
					electrolyte_distribution_optimizer //Increase energy
						eng_gain_base = 1
						info_name = "Electrolyte Distribution Optimizer"
						desc_extra = "Applied to Heart\n\n"
						desc = "The Electrolyte Distribution Optimizer is an advanced cybernetic device designed to improve the user's energy levels through optimizing the distribution of essential ions and minerals within the bloodstream. It features an intricate system of sensors, actuators, and control units that work in harmony with the user's cardiovascular system to precisely regulate the concentration and flow of electrolytes. The device's sophisticated algorithms and predictive models allow it to anticipate the body's energy requirements and respond with rapid adjustments, enabling the user to maintain peak performance and endurance even in demanding physical or mental activities."
				cybernetic_cortex_implants
					compatible = list(/obj/body_related/bodyparts/head/brain)
					limbic_cerebral_amplifier //Increase int mod
						info_name = "Limbic Cerebral Amplifier"
						desc_extra = "Applied to Brain\n\n"
					frontal_cortex_psi_intensifier //Increase psionic power mod on organ
						psi_gain_base = 1
						info_name = "Frontal Cortex Psi Intensifier"
						desc_extra = "Applied to Brain\n\n"
						desc = "The frontal cortex psi intensifier is a cutting-edge cybernetic implant that interfaces directly with the user's nervous system, augmenting their psionic abilities to previously unattainable levels. The device utilizes a complex array of neural pathways to stimulate and intensify the activity of the frontal cortex, the region of the brain responsible for higher cognitive functions such as reasoning, decision making, and psionic capabilities. The device's micro-nanotechnological components are designed to seamlessly integrate with the user's neurophysiology, creating an enhanced neural network that amplifies their psionic potential."
					cerebrum_potency_escalate //Increase energy mod on organ
						eng_gain_base = 1
						info_name = "Cerebrum Potency Escalate"
						desc_extra = "Applied to Brain\n\n"
						desc = "The cerebrum potency escalate is a sophisticated cybernetic implant that seamlessly integrates with the user's brain, enhancing the neurological activity and amplifying the bioelectric impulses. This device is equipped with state-of-the-art neural networks and nanobots that interact with the brain's synaptic network, stimulating the release of neurotransmitters and increasing the neural conductivity. The result is an unprecedented surge of bioenergy that powers up the user's physical and mental abilities to extraordinary levels. With the cerebrum potency escalate, the user can accomplish feats beyond imagination."
					neuro_filament_pain_suppressor //Increase endurance
						end_gain_base = 1
						info_name = "Neuro Filament Pain Suppressor"
						desc_extra = "Applied to Brain\n\n"
						desc = "The neuro filament pain suppressor is an extraordinary cybernetic device that interacts with the neural network to alleviate physical discomfort, increasing the user's resilience to painful stimuli. Using advanced biotechnology, the device modulates the transmission of pain signals, inhibiting the activation of nociceptive neurons, and improving the user's ability to endure adverse conditions. Its miniature size allows it to be integrated seamlessly into the user's neural system, rendering it virtually imperceptible. With the neuro filament pain suppressor, one can endure physical trials with greater ease and precision."
					micro_electromagnetic_agitator //Increase strength
						str_gain_base = 1
						info_name = "Micro Electromagnetic Agitator"
						desc_extra = "Applied to Brain\n\n"
						desc = "The microelectromagnetic agitator is a cutting-edge cybernetic device that interfaces with the brain's neural network to increase the user's physical strength. Utilizing advanced principles of electromagnetism and microscale engineering, this device induces targeted neural activity, enhancing motor neuron output and muscular contraction. The device's unique design incorporates a sophisticated algorithm that learns and adapts to the user's specific physiology, providing optimized performance gains over time. With the microelectromagnetic agitator, users can expect to achieve unprecedented levels of strength and power, revolutionizing their physical capabilities."
					sustained_oscillating_gyro //Increase force
						force_gain_base = 1
						info_name = "Sustained Oscillating Gyro"
						desc_extra = "Applied to Brain\n\n"
						desc = "The Sustained Oscillating Gyro is an advanced cybernetic implant that interfaces with the brain to modulate energy-based attacks. The device employs a unique feedback mechanism to resonate with the user's bioelectric fields, amplifying the power and accuracy of their energy-based attacks. Utilizing cutting-edge technology, the implant is capable of oscillating at precise frequencies, enhancing the synchronization between the user's neural pathways and energy output. With its exceptional performance and advanced engineering, the Sustained Oscillating Gyro is the ultimate tool for unleashing the full potential of ones Force."
					bioelectric_inverse_safeguard //Increase resistance
						res_gain_base = 1
						info_name = "Bioelectric Inverse Safeguard"
						desc_extra = "Applied to Brain\n\n"
						desc = "The bioelectric inverse safeguard is a marvel of cybernetic engineering that enhances the user's resilience to energy-based attacks. This intricate device harnesses cutting-edge biotechnology to establish a robust defense system against high-energy waves and rays. By utilizing complex algorithms and advanced neural interfacing, the safeguard converts the electrical signals within the brain into a protective electromagnetic shield. This process triggers the release of potent neurochemicals that work in tandem with the device's unique shielding technology to neutralize incoming energy-based threats. The result is an unparalleled level of protection that empowers the user to stand up against even the most formidable adversaries."
					forewarned_computation_matrix //Increase defence
						def_gain_base = 1
						info_name = "Forewarned Computation Matrix"
						desc_extra = "Applied to Brain\n\n"
						desc = "The forewarned computation matrix is an advanced cybernetic device that attaches to the brain, providing unparalleled situational awareness to its host. It employs sophisticated predictive algorithms and neural interfaces to enable the user to anticipate and dodge incoming melee and ranged attacks with remarkable precision and timing. The matrix also enhances the user's cognitive processing speed and reaction time, allowing for lightning-fast responses in high-pressure combat scenarios. With its cutting-edge technology and unparalleled performance, the forewarned computation matrix is a must-have for any combat-oriented cyborg seeking to gain an edge over their opponents."
					augmentative_probability_chip //Increase offence
						off_gain_base = 1
						info_name = "Augmentative Probability Chip"
						desc_extra = "Applied to Brain\n\n"
						desc = "The Augmentative Probability Chip is a sophisticated cybernetic device that enhances the probability of successful landings of melee attacks by generating and utilizing advanced algorithms based on neuro-mathematical models of movement and impact analysis. The chip's cutting-edge computational capabilities combined with high-speed neural interfaces provide users with an unparalleled advantage in close combat situations. By predicting and optimizing the user's movements, the chip increases the likelihood of delivering precise and devastating blows to opponents, leading to an overwhelming advantage in combat."
					quantum_foam_fluctuation_equalizer //Convert divine energy gain into dark matter gain
						info_name = "Quantum Foam Fluctuation Equalizer"
						desc_extra = "Applied to Brain\n\n"
						desc = "The quantum foam fluctuation equalizer is a highly advanced cybernetic device that integrates with the user's brain to enable the conversion of divine energy into dark matter. This cutting-edge technology operates on the principles of quantum mechanics and utilizes a sophisticated system of nanoscale quantum transducers to harness the energy of the universe itself. By manipulating the very fabric of space-time, the device is able to convert divine energy into dark matter, unleashing a tremendous amount of power that can be harnessed for various applications."
				cybernetic_ocular_implants
					compatible = list(/obj/body_related/bodyparts/head/left_eye,/obj/body_related/bodyparts/head/right_eye)
					optic_lens_magnificationator //Increase offence
						off_gain_base = 1
						info_name = "Optic Lens Magnificationator"
						desc_extra = "Applied to Eyes\n\n"
						desc = "The Optic Lens Magnificationator, a revolutionary cybernetic device that integrates seamlessly with the eye to enhance the user's ability to strike their targets with precision and accuracy. This advanced technology employs sophisticated optics and sophisticated image processing algorithms to magnify visual information, giving the user an unparalleled level of awareness of their surroundings. The device also incorporates cutting-edge targeting software, which allows the user to lock onto targets and execute attacks with exceptional speed and accuracy. With the Optic Lens Magnificationator, the user will have a formidable edge in combat situations."
					suspensory_filament_reflex_intensifier //Increase defence
						def_gain_base = 1
						info_name = "Suspensory Filament Reflex Intensifier"
						desc_extra = "Applied to Eyes\n\n"
						desc = "The Suspensory Filament Reflex Intensifier (SFRI) is a cutting-edge cybernetic ocular implant designed to enhance the user's visual reflexes and agility in high-stress combat situations. It utilizes advanced microfilament technology to strengthen the eye's suspensory ligaments and ciliary muscles, providing unparalleled control over lens shape and focal length. This allows the user to rapidly adjust to incoming threats, rapidly scanning their surroundings and accurately predicting incoming attacks. In addition, the SFRI incorporates high-speed sensory feedback and neuromuscular stimulation to optimize the user's reaction times and increase their ability to evade and dodge incoming melee attacks."
					phosphorescent_transparency_xray
						info_name = "Phosphorescent Transparency X-ray"
						desc_extra = "Applied to Eyes\n\n"
				cybernetic_spinal_mount
					compatible = list(/obj/body_related/bodyparts/torso/spine)
					neo_nanofiber_reinforcement_bundle //Increase gravity resistance
						gravity_gain = 0.01
						info_name = "Neo-Nanofiber Reinforcement Bundle"
						desc_extra = "Applied to Spine\n\n"
						desc = "The Neo-Nanofiber Reinforcement Bundle is a highly advanced cybernetic implant that integrates with the neural and musculoskeletal systems of the user, enhancing their physical performance and endurance to unprecedented levels. The bundle features a network of ultra-fine nanofibers that interweave with the spinal column, providing unparalleled structural reinforcement and stability. These nanofibers are interlaced with neural sensors that allow the user to control and adjust the performance of the bundle with their thoughts. The device also features an energy matrix that can convert kinetic energy into electrical power, providing the user with a sustained source of energy during demanding physical activity. The Neo-Nanofiber Reinforcement Bundle is the pinnacle of cybernetic engineering, granting its users unparalleled strength, agility, and endurance."
					bioelectric_spinal_thread //Increase agility
						spd_mod_gain = 0.001
						info_name = "Bioelectric Spinal Thread"
						desc_extra = "Applied to Spine\n\n"
						desc = "The Bioelectric Spinal Thread is a state-of-the-art cybernetic implant that is surgically integrated into the spinal column. It comprises a complex network of bio-electronic fibers that interface with the central nervous system, providing real-time feedback and enhancing sensory perception. These fibers are made of a proprietary composite material that is both flexible and incredibly durable, able to withstand high levels of physical stress without losing structural integrity. Once integrated, the user gains enhanced motor control, improved reflexes, and heightened sensitivity, enabling them to perceive and react to stimuli with unprecedented speed and precision."
					embedded_intervertebral_stabilizer //Increase endurance
						end_gain_base = 1
						info_name = "Embedded Intervertebral Stabilizer"
						desc_extra = "Applied to Spine\n\n"
						desc = "The embedded intervertebral stabilizer is an intricately designed cybernetic implant that forms a biomechanical bond with the spine. It utilizes a combination of high-strength alloys and bioresorbable materials to provide maximum stability to the spinal column, increasing the user's endurance and resistance to physical stresses. Its advanced neural interface allows for seamless integration with the central nervous system, allowing for precise control and modulation of muscle activation. This cutting-edge technology offers a new frontier in augmentation, revolutionizing the way we approach performance enhancement."
				synthetics
					synthetic_heart //Derive great raw power from the heart, also helps you recover energy faster and better.
						info_name = "Bionic Heart"
						icon_state = "organs"
						psi_gain_base = 10
						recov_mod_gain = 0.001
						force_gain_base = 1
						lifespan_gain = 0.1
						divine_eng_gain_base = 1
					synthetic_liver //Helps with the creation of energy and psi power
						info_name = "Bionic Liver"
						icon_state = "organs"
						lifespan_gain = 0.1
						eng_gain_base = 5
						psi_gain_base = 1
					synthetic_lungs //Helps you recovery energy and increases max energy
						info_name = "Bionic Lungs"
						icon_state = "organs"
						force_gain_base = 1
						eng_gain_base = 5
						recov_mod_gain = 0.001
						lifespan_gain = 0.1
					synthetic_kidneys //Helps produce good, clean energy in the body
						info_name = "Bionic Kidneys"
						icon_state = "organs"
						lifespan_gain = 0.1
						eng_gain_base = 10
						recov_mod_gain = 0.0005
					synthetic_spleen //Helps greatly with regen and resistance
						info_name = "Bionic Spleen"
						icon_state = "organs"
						regen_mod_gain = 0.001
						res_gain_base = 1
						lifespan_gain = 0.2
					synthetic_intestines //Good at creating energy and force power
						info_name = "Bionic Intestines"
						icon_state = "organs"
						lifespan_gain = 0.1
						eng_gain_base = 10
						force_gain_base = 1
					synthetic_stomach //Good at creating energy and force power
						info_name = "Bionic Stomach"
						icon_state = "organs"
						lifespan_gain = 0.1
						eng_gain_base = 10
						force_gain_base = 1
			left_arm
				info_name = "Left Arm"

				artifical_left_arm_skin
					info_name = "Artifical Left Arm Skin"
					icon_state = "cybernetic"
					res_gain_base = 2
					psi_gain_base = 1
					bodypart_type = "Organ"
					part_hierarchy = 7
					cybernetic = 1
					cybernetics_max = 0

				left_arm_skin
					name = "Left Arm"
					info_name = "Left Arm Skin"
					icon_state = "organs"
					res_gain_base = 2
					psi_gain_base = 1
					heat_gain = 0.001
					cold_gain = 0.001
					micro_gain = 0.0001
					bodypart_type = "Organ"
					part_hierarchy = 7
					cybernetics_max = 2
					info = "Allow your hide to drink deeply of psionic power, quench it in ever-flowing energy, causing it to become harder, tougher and more resilient to damage. The integumentary sheath of the left upper limb, an exquisite trinity of epidermis, dermis, and subcutaneous adipose stratum, protects and encases the arm's internal musculoskeletal architecture. Toning this dermal tapestry unveils a transcendent shield of resilience, enabling psionic warriors to channel heightened power, tolerance, and endurance."

				left_shoulder_muscles
					info_name = "Left Shoulder Muscles"
					icon_state = "muscles"
					str_gain_base = 1
					psi_gain_base = 1
					bodypart_type = "Muscle"
				//	part_hierarchy = 5
				//	cybernetics_max = 2
					info = "The deltoid and rotator cuff muscles, a synergistic cohort governing shoulder joint mobility, facilitate remarkable feats of arm movement. Toning these muscular marvels unveils untold psionic potential, elevating overall strength, and bestowing a sense of enigmatic mastery over the corporeal form."
				left_upper_arm_muscles
					info_name = "Left Upper Arm Muscles"
					icon_state = "muscles"
					str_gain_base = 1
					psi_gain_base = 1
					bodypart_type = "Muscle"
				//	part_hierarchy = 4
				//	cybernetics_max = 2
					info = "The biceps brachii and triceps brachii, a formidable duo, dictate elbow flexion and extension. Toning these prodigious upper arm muscles empowers the psionic adept to harness incredible strength, and otherworldly power, transforming the arm into a conduit of unparalleled might."
				left_forearm_muscles
					info_name = "Left Forearm Muscles"
					icon_state = "muscles"
					str_gain_base = 1
					psi_gain_base = 1
					bodypart_type = "Muscle"
				//	part_hierarchy = 3
				//	cybernetics_max = 1
					info = "The flexor and extensor muscle groups, the masters of wrist and hand articulation, enable the intricate dance of dexterity. Toning these sinewy sculptors of movement bestows upon the psionic practitioner an ethereal potency, elevating grip strength, fortifying power, and amplifying the mystical force within."
				left_hand_muscles
					info_name = "Left Hand Muscles"
					icon_state = "muscles"
					str_gain_base = 1
					psi_gain_base = 1
					bodypart_type = "Muscle"
				//	part_hierarchy = 2
				//	cybernetics_max = 1
					info = "The intrinsic and extrinsic hand musculature, a clandestine network of tactile virtuosos, governs dexterity and strength. Toning these enigmatic puppeteers of manipulation unlocks the secrets of preternatural finesse and power, augmenting psionic prowess, enhancing manual strength, and bolstering unwavering might."

				left_scapula_bones
					info_name = "Left Scapula Bones"
					icon_state = "bones"
					end_gain_base = 1
					psi_gain_base = 1
					bodypart_type = "Bone"
				//	part_hierarchy = 6
				//	cybernetics_max = 1
					info = "The scapulae, the twin guardians of the upper back, form the bedrock of shoulder stability and movement. Toning these osseous sentinels unveils a realm of mystic possibilities, strengthening the foundation for psionic energy, elevating structural fortitude, and sustaining transcendental endurance."
				left_upper_arm_bones
					info_name = "Left Upper Arm Bones"
					icon_state = "bones"
					end_gain_base = 1
					psi_gain_base = 1
					bodypart_type = "Bone"
				//	part_hierarchy = 5
				//	cybernetics_max = 1
					info = "The humerus, the paramount pillar of the upper arm, provides unwavering support between the scapula and elbow joint. Toning this indomitable bone unearths untold psionic potential, enhancing the osseous conduit for the flow of mystical power and amplifying arm endurance."
				left_forearm_bones
					info_name = "Left Forearm Bones"
					icon_state = "bones"
					end_gain_base = 1
					psi_gain_base = 1
					bodypart_type = "Bone"
			//		part_hierarchy = 4
				//	cybernetics_max = 1
					info = "The ulna and radius, the enigmatic duo of the forearm, collaborate to enable the arm's rotational prowess. Toning these sturdy osseous allies invokes the secrets of power, strengthening the bones' mystical properties, and bolstering forearm endurance."

				left_thumb_bones
					info_name = "Left Thumb Bones"
					icon_state = "bones"
					end_gain_base = 1
					psi_gain_base = 1
					bodypart_type = "Bone"
			//		part_hierarchy = 3
				//	cybernetics_max = 1
					info = "The phalanges and metacarpal of the thumb, the architects of opposability, enable the marvel of dexterous manipulation. Toning these skeletal masterminds unveils the hidden power of prehensile strength, magnifying psionic energies, and fortifying manual endurance."
				left_index_finger_bones
					info_name = "Left Index Finger Bones"
					icon_state = "bones"
					end_gain_base = 1
					psi_gain_base = 1
					bodypart_type = "Bone"
				//	part_hierarchy = 3
				//	cybernetics_max = 1
					info = "The index finger's metacarpal and phalanges, the precision instruments of the hand, guide the way to uncharted realms of dexterity. Toning these osseous maestros enhances psionic abilities, amplifies finger power, and sustains extraordinary endurance."
				left_middle_finger_bones
					info_name = "Left Middle Finger Bones"
					icon_state = "bones"
					end_gain_base = 1
					psi_gain_base = 1
					bodypart_type = "Bone"
				//	part_hierarchy = 3
					//cybernetics_max = 1
					info = "The metacarpal and phalanges of the middle finger, the hand's central pillar, provide balance and force in manual undertakings. Toning these skeletal fulcrums unlocks a world of transcendent power, amplifying psionic abilities, enhancing finger stability, and sustaining exceptional endurance."
				left_ring_finger_bones
					info_name = "Left Ring Finger Bones"
					icon_state = "bones"
					end_gain_base = 1
					psi_gain_base = 1
					bodypart_type = "Bone"
				//	part_hierarchy = 3
					//cybernetics_max = 1
					info = "The metacarpal and phalanges of the ring finger, the enigmatic accomplices of the hand's dynamic movements, contribute to the symphony of dexterity. Toning these osseous tissues unveils the arcane secrets of preternatural resilience, boosting psionic potential, and fortifying the hand's unwavering endurance."
				left_pinky_bones
					info_name = "Left Pinky Bones"
					icon_state = "bones"
					end_gain_base = 1
					psi_gain_base = 1
					bodypart_type = "Bone"
				//	part_hierarchy = 3
				//	cybernetics_max = 1
					info = "The metacarpal and phalanges of the pinky finger, the operatives of manual finesse, enable the hand's refined articulation. Toning these unassuming skeletal masterminds reveals the hidden power of mystical energies, magnifying psionic prowess, and bolstering the pinky's endurance."



			right_arm
				info_name = "Right Arm"
				artifical_right_arm_skin
					info_name = "Artifical Right Arm Skin"
					icon_state = "cybernetic"
					res_gain_base = 2
					psi_gain_base = 1
					cybernetic = 1
					bodypart_type = "Organ"
					part_hierarchy = 7
					cybernetics_max = 0
				right_arm_skin
					name = "Right Arm"
					info_name = "Right Arm Skin"
					icon_state = "organs"
					res_gain_base = 2
					psi_gain_base = 1
					heat_gain = 0.001
					cold_gain = 0.001
					micro_gain = 0.0001
					bodypart_type = "Organ"
				//	part_hierarchy = 7
				//	cybernetics_max = 2
					info = "Allow your hide to drink deeply of psionic power, quench it in ever-flowing energy, causing it to become harder, tougher and more resilient to damage. The integumentary sheath of the left upper limb, an exquisite trinity of epidermis, dermis, and subcutaneous adipose stratum, protects and encases the arm's internal musculoskeletal architecture. Toning this dermal tapestry unveils a transcendent shield of resilience, enabling psionic warriors to channel heightened power, tolerance, and endurance."

				right_shoulder_muscles
					info_name = "Right Shoulder Muscles"
					icon_state = "muscles"
					str_gain_base = 1
					psi_gain_base = 1
					bodypart_type = "Muscle"
				//	part_hierarchy = 5
				//	cybernetics_max = 2
					info = "The deltoid and rotator cuff muscles, a synergistic cohort governing shoulder joint mobility, facilitate remarkable feats of arm movement. Toning these muscular marvels unveils untold psionic potential, elevating overall strength, and bestowing a sense of enigmatic mastery over the corporeal form."

				right_upper_arm_muscles
					info_name = "Right Upper Arm Muscles"
					icon_state = "muscles"
					str_gain_base = 1
					psi_gain_base = 1
					bodypart_type = "Muscle"
				//	part_hierarchy = 4
				//	cybernetics_max = 2
					info = "The biceps brachii and triceps brachii, a formidable duo, dictate elbow flexion and extension. Toning these prodigious upper arm muscles empowers the psionic adept to harness incredible strength, and otherworldly power, transforming the arm into a conduit of unparalleled might."

				right_forearm_muscles
					info_name = "Right Forearm Muscles"
					icon_state = "muscles"
					str_gain_base = 1
					psi_gain_base = 1
					bodypart_type = "Muscle"
				//	part_hierarchy = 3
				//	cybernetics_max = 1
					info = "The flexor and extensor muscle groups, the masters of wrist and hand articulation, enable the intricate dance of dexterity. Toning these sinewy sculptors of movement bestows upon the psionic practitioner an ethereal potency, elevating grip strength, fortifying power, and amplifying the mystical force within."

				right_hand_muscles
					info_name = "Right Hand Muscles"
					icon_state = "muscles"
					str_gain_base = 1
					psi_gain_base = 1
					bodypart_type = "Muscle"
				//	part_hierarchy = 2
				//	cybernetics_max = 1
					info = "The intrinsic and extrinsic hand musculature, a clandestine network of tactile virtuosos, governs dexterity and strength. Toning these enigmatic puppeteers of manipulation unlocks the secrets of preternatural finesse and power, augmenting psionic prowess, enhancing manual strength, and bolstering unwavering might."


				right_scapula_bones
					info_name = "Right Scapula Bones"
					icon_state = "bones"
					end_gain_base = 1
					psi_gain_base = 1
					bodypart_type = "Bone"
				//	part_hierarchy = 6
				//	cybernetics_max = 1
					info = "The scapulae, the twin guardians of the upper back, form the bedrock of shoulder stability and movement. Toning these osseous sentinels unveils a realm of mystic possibilities, strengthening the foundation for psionic energy, elevating structural fortitude, and sustaining transcendental endurance."

				right_upper_arm_bones
					info_name = "Right Upper Arm Bones"
					icon_state = "bones"
					end_gain_base = 1
					psi_gain_base = 1
					bodypart_type = "Bone"
				//	part_hierarchy = 5
				//	cybernetics_max = 1
					info = "The humerus, the paramount pillar of the upper arm, provides unwavering support between the scapula and elbow joint. Toning this indomitable bone unearths untold psionic potential, enhancing the osseous conduit for the flow of mystical power and amplifying arm endurance."

				right_forearm_bones
					info_name = "Right Forearm Bones"
					icon_state = "bones"
					end_gain_base = 1
					psi_gain_base = 1
					bodypart_type = "Bone"
				//	part_hierarchy = 4
				//	cybernetics_max = 1
					info = "The ulna and radius, the enigmatic duo of the forearm, collaborate to enable the arm's rotational prowess. Toning these sturdy osseous allies invokes the secrets of power, strengthening the bones' mystical properties, and bolstering forearm endurance."

				right_thumb_bones
					info_name = "Right Thumb Bones"
					icon_state = "bones"
					end_gain_base = 1
					psi_gain_base = 1
					bodypart_type = "Bone"
				//	part_hierarchy = 3
				//	cybernetics_max = 1
					info = "The phalanges and metacarpal of the thumb, the architects of opposability, enable the marvel of dexterous manipulation. Toning these skeletal masterminds unveils the hidden power of prehensile strength, magnifying psionic energies, and fortifying manual endurance."

				right_index_finger_bones
					info_name = "Right Index Finger Bones"
					icon_state = "bones"
					end_gain_base = 1
					psi_gain_base = 1
					bodypart_type = "Bone"
					//part_hierarchy = 3
					//cybernetics_max = 1
					info = "The index finger's metacarpal and phalanges, the precision instruments of the hand, guide the way to uncharted realms of dexterity. Toning these osseous maestros enhances psionic abilities, amplifies finger power, and sustains extraordinary endurance."

				right_middle_finger_bones
					info_name = "Right Middle Finger Bones"
					icon_state = "bones"
					end_gain_base = 1
					psi_gain_base = 1
					bodypart_type = "Bone"
					//part_hierarchy = 3
					//cybernetics_max = 1
					info = "The metacarpal and phalanges of the middle finger, the hand's central pillar, provide balance and force in manual undertakings. Toning these skeletal fulcrums unlocks a world of transcendent power, amplifying psionic abilities, enhancing finger stability, and sustaining exceptional endurance."

				right_ring_finger_bones
					info_name = "Right Ring Finger Bones"
					icon_state = "bones"
					end_gain_base = 1
					psi_gain_base = 1
					bodypart_type = "Bone"
				//	part_hierarchy = 3
				//	cybernetics_max = 1
					info = "The metacarpal and phalanges of the ring finger, the enigmatic accomplices of the hand's dynamic movements, contribute to the symphony of dexterity. Toning these osseous tissues unveils the arcane secrets of preternatural resilience, boosting psionic potential, and fortifying the hand's unwavering endurance."

				right_pinky_bones
					info_name = "Right Pinky Bones"
					icon_state = "bones"
					end_gain_base = 1
					psi_gain_base = 1
					bodypart_type = "Bone"
				//	part_hierarchy = 3
					//cybernetics_max = 1
					info = "The metacarpal and phalanges of the pinky finger, the operatives of manual finesse, enable the hand's refined articulation. Toning these unassuming skeletal masterminds reveals the hidden power of mystical energies, magnifying psionic prowess, and bolstering the pinky's endurance."

			left_leg
				info_name = "Left Leg"
				artifical_left_leg_skin
					info_name = "Artifical Left Leg Skin"
					icon_state = "cybernetic"
					res_gain_base = 2
					psi_gain_base = 1
					cybernetic = 1
					bodypart_type = "Organ"
				//	part_hierarchy = 7
				//	cybernetics_max = 0
				left_leg_skin
					name = "Left Leg"
					info_name = "Left Leg Skin"
					icon_state = "organs"
					res_gain_base = 2
					bodypart_type = "Organ"
					psi_gain_base = 1
					heat_gain = 0.001
					cold_gain = 0.001
					micro_gain = 0.0001
					part_hierarchy = 7
					cybernetics_max = 2
					info = "Allow your hide to drink deeply of psionic power, quench it in ever-flowing energy, causing it to become harder, tougher and more resilient to damage. The skin encasing the leg, consisting of the epidermis, dermis, and subcutaneous adipose layer, serves as a protective barrier for underlying structures. Toning this essential envelope fortifies the body's natural shield and leads to increased resilience, while amplifying psionic power exponentially."

				left_thigh_muscles
					name = "Left Leg"
					info_name = "Left Thigh Muscles"
					icon_state = "muscles"
					str_gain_base = 1
					psi_gain_base = 1
					bodypart_type = "Muscle"
				//	part_hierarchy = 5
				//	cybernetics_max = 2
					info = "The Ultimate Powerhouses: The thigh muscles, comprised of quadriceps, hamstrings, and adductors, collaborate to provide hip and knee mobility. Toning these femoral titans elevates strength to new heights, unlocking untold psionic potential."
				left_lower_leg_muscles
					info_name = "Left Lower Leg Muscles"
					icon_state = "muscles"
					str_gain_base = 1
					psi_gain_base = 1
					bodypart_type = "Muscle"
					part_hierarchy = 4
					cybernetics_max = 1
					info = "Gastrocnemius, soleus, and tibialis anterior form a crucial trio, orchestrating ankle and foot articulation. Toning these crural architects of movement unleashes staggering potential, enhances locomotive capabilities, and transcends mortal estrength, boosting overall psionic potential."
				left_foot_muscles
					info_name = "Left Foot Muscles"
					icon_state = "muscles"
					str_gain_base = 1
					psi_gain_base = 1
					bodypart_type = "Muscle"
				//	part_hierarchy = 3
				//	cybernetics_max = 1
					info = "The intrinsic pedal musculature, including the plantar and dorsal interossei, governs stabilization and intricate foot movements. Toning these stabilizing muscles leads to elevated psionic mastery, improved balance, enhanced strength, and unrivaled agility."

				left_thigh_bone
					info_name = "Left Thigh Bone"
					icon_state = "bones"
					end_gain_base = 1
					psi_gain_base = 1
					bodypart_type = "Bone"
				//	part_hierarchy = 6
				//	cybernetics_max = 1
					info = "The formidable femur, the longest and strongest bone, links the pelvic girdle and knee, providing axial support. Toning this steadfast pillar unlocks untold psionic prowess, unyielding postural stability, and enhanced endurance."
				left_lower_leg_bones
					info_name = "Left Lower Leg Bones"
					icon_state = "bones"
					end_gain_base = 1
					psi_gain_base = 1
					bodypart_type = "Bone"
					//part_hierarchy = 5
				//	cybernetics_max = 1
					info = "Pillars of Endurance: The tibia and fibula, twin sentinels of the lower leg, provide unwavering structural integrity and flexible limb articulation. Toning these steadfast bones unleashes a torrent of psionic energy, bolsters lower extremity ability, and leads to unmatched endurance and agility."
				left_foot_bones
					info_name = "Left Foot Bones"
					icon_state = "bones"
					end_gain_base = 1
					psi_gain_base = 1
					bodypart_type = "Bone"
					//part_hierarchy = 4
					//cybernetics_max = 1
					info = "The complex interplay of tarsals, metatarsals, and phalanges forms the foundation of the foot's dexterity and load-bearing capacity. Toning this labyrinthine framework results in celestial psionic aptitude, supreme locomotive efficiency, and enhanced endurance and stability."
			right_leg
				info_name = "Right Leg"
				artifical_right_leg_skin
					info_name = "Artifical Right Leg Skin"
					icon_state = "cybernetic"
					res_gain_base = 2
					psi_gain_base = 1
					bodypart_type = "Organ"
					cybernetic = 1
					part_hierarchy = 7
					cybernetics_max = 0
				right_leg_skin
					name = "Right Leg"
					info_name = "Right Leg Skin"
					icon_state = "organs"
					res_gain_base = 2
					psi_gain_base = 1
					bodypart_type = "Organ"
					heat_gain = 0.001
					cold_gain = 0.001
					micro_gain = 0.0001
					part_hierarchy = 7
					cybernetics_max = 2
					info = "Allow your hide to drink deeply of psionic power, quench it in ever-flowing energy, causing it to become harder, tougher and more resilient to damage. The skin encasing the leg, consisting of the epidermis, dermis, and subcutaneous adipose layer, serves as a protective barrier for underlying structures. Toning this essential envelope fortifies the body's natural shield and leads to increased resilience, while amplifying psionic power exponentially."

				right_thigh_muscles
					name = "Right Leg"
					info_name = "Right Thigh Muscles"
					icon_state = "muscles"
					str_gain_base = 1
					psi_gain_base = 1
					bodypart_type = "Muscle"
				//	part_hierarchy = 5
				//	cybernetics_max = 2
					info = "The Ultimate Powerhouses: The thigh muscles, comprised of quadriceps, hamstrings, and adductors, collaborate to provide hip and knee mobility. Toning these femoral titans elevates strength to new heights, unlocking untold psionic potential."
				right_lower_leg_muscles
					info_name = "Right Lower Leg Muscles"
					icon_state = "muscles"
					str_gain_base = 1
					psi_gain_base = 1
					bodypart_type = "Muscle"
				//	part_hierarchy = 4
				//	cybernetics_max = 1
					info = "Gastrocnemius, soleus, and tibialis anterior form a crucial trio, orchestrating ankle and foot articulation. Toning these crural architects of movement unleashes staggering potential, enhances locomotive capabilities, and transcends mortal estrength, boosting overall psionic potential."
				right_foot_muscles
					info_name = "Right Foot Muscles"
					icon_state = "muscles"
					str_gain_base = 1
					psi_gain_base = 1
					bodypart_type = "Muscle"
					//part_hierarchy = 3
				//	cybernetics_max = 1
					info = "The intrinsic pedal musculature, including the plantar and dorsal interossei, governs stabilization and intricate foot movements. Toning these stabilizing muscles leads to elevated psionic mastery, improved balance, enhanced strength, and unrivaled agility."

				right_thigh_bone
					info_name = "Right Thigh Bone"
					icon_state = "bones"
					end_gain_base = 1
					psi_gain_base = 1
					bodypart_type = "Bone"
					//part_hierarchy = 6
					//cybernetics_max = 1
					info = "The formidable femur, the longest and strongest bone, links the pelvic girdle and knee, providing axial support. Toning this steadfast pillar unlocks untold psionic prowess, unyielding postural stability, and enhanced endurance."
				right_lower_leg_bones
					info_name = "Right Lower Leg Bones"
					icon_state = "bones"
					end_gain_base = 1
					psi_gain_base = 1
					bodypart_type = "Bone"
				//	part_hierarchy = 5
					//cybernetics_max = 1
					info = "Pillars of Endurance: The tibia and fibula, twin sentinels of the lower leg, provide unwavering structural integrity and flexible limb articulation. Toning these steadfast bones unleashes a torrent of psionic energy, bolsters lower extremity ability, and leads to unmatched endurance and agility."
				right_foot_bones
					info_name = "Right Foot Bones"
					icon_state = "bones"
					end_gain_base = 1
					psi_gain_base = 1
					bodypart_type = "Bone"
				//	part_hierarchy = 4
				//	cybernetics_max = 1
					info = "The complex interplay of tarsals, metatarsals, and phalanges forms the foundation of the foot's dexterity and load-bearing capacity. Toning this labyrinthine framework results in celestial psionic aptitude, supreme locomotive efficiency, and enhanced endurance and stability."

mob
	verb
		train_part()
			set name = ".train_part"
			set hidden = 1
			if(usr.typing) return
			if(usr.upgrading)
				var/mob/m = usr.upgrading
				if(get_dist(src,m) <= 2)
					if(usr.resources >= 100000)
						//usr.resources -= 100000
						usr.update_rsc()
						if(m.part_selected)
							var/obj/body_related/bodyparts/p = m.part_selected
							if(p)
								p.part_exp = 100
								p.part_reward(m,1,usr)
				else
					usr.client.screen -= usr.hud_body
					usr.open_body = 0
					usr.open_menus.Remove(".open_body")
					usr.upgrading = null
					usr.set_alert("Android too far away",'alert.dmi',"alert")
				//	usr.create_chat_entry("alerts","Android too far away.")
					usr << output("Android is too far away to upgrade.", "chat.system")
				return
			if(usr.part_focus)
				var/obj/body_related/bodyparts/p = usr.part_focus
				p.icon_state = "[p.i_state]" //Reset previous part_focus to orginal icon
			if(istype(usr.part_selected,/obj/body_related/bodyparts/))  //If we click train and the part selected isn't a body milestone
				//Someone uses an Mechanical Upgrade Kit
				var/obj/body_related/bodyparts/p = usr.part_selected
				if(p.cybernetic)
				//if(usr.race == "Android")
					var/found_kit = 0
					for(var/obj/items/tech/Upgrade_Kit/auk in usr)
						//var/obj/body_related/bodyparts/p = usr.part_selected
						p.part_exp = 1000
						p.part_reward(usr,1)
						found_kit = 1
						auk.use_obj(usr)
						usr.refresh_inv()
						break
					if(found_kit == 0)
						usr.set_alert("Need Mechanical Upgrade Kit",'alert.dmi',"alert")
					//	usr.create_chat_entry("alerts","Need Mechanical Upgrade Kit.")
						usr << output("Need Mechanical Upgrade Kit.", "chat.system")
					return
				else if(usr.part_selected && usr.part_selected != usr.part_focus)
					if(p.infused_divine) p.icon_state = "[initial(p.icon_state)] divine selected"
					else if(p.infused_dark) p.icon_state = "[initial(p.icon_state)] dark selected"
					else if(p.infused_petrified) p.icon_state = "[initial(p.icon_state)] petrified selected"
					else p.icon_state = "[initial(p.icon_state)] selected"
					usr.part_focus = usr.part_selected
					winset(usr,"body.button_train","text=\"Cancel\"")
					var/icon/I = icon(p.icon,p.icon_state,SOUTH,1,0)
					I.Scale(64,64)
					var/Z = fcopy_rsc(I)
					winset(usr,"body.label_img","image=\ref[Z]")
					return
				else if(usr.part_selected && usr.part_selected == usr.part_focus)
					if(usr.race == "Android") winset(usr,"body.button_train","text=\"Upgrade\"")
					else winset(usr,"body.button_train","text=\"Forge\"")
					usr.part_focus = null
					return
			if(istype(usr.part_selected,/obj/body_related/body_milestones/))
				if(usr.has_body == 0)
					usr << output("<font color = teal>Unable to unlock body milestones with no body.","chat.system")
					usr.set_alert("Need body to unlock milestones",'alert.dmi',"alert")
					//usr.create_chat_entry("alerts","Need body to unlock milestones.")
					return
				var/obj/body_related/body_milestones/o = usr.part_selected
				if(o.can_unlock)
					o.part_reward(usr)
			if(istype(usr.part_selected,/obj/body_related/ascension_milestones/))
				if(usr.part_selected.needs_body && usr.has_body == 0)
					usr << output("<font color = teal>Unable to unlock this ascension without a body.","chat.system")
					usr.set_alert("Need body to unlock this ascension",'alert.dmi',"alert")
				//	usr.create_chat_entry("alerts","Need body to unlock this ascension.")
					return
				if(usr.part_selected.needs_soul && usr.dead)
					usr << output("<font color = teal>Unable to unlock this ascension while deceased.","chat.system")
					usr.set_alert("Need life to unlock this ascension",'alert.dmi',"alert")
				//	usr.create_chat_entry("alerts","Need life to unlock this ascension.")
					return
				var/obj/body_related/ascension_milestones/o = usr.part_selected
				if(o.can_unlock)
					o.part_reward(usr)
			if(istype(usr.part_selected,/obj/body_related/soul/))
				if(usr.part_selected.needs_soul && usr.dead)
					usr << output("<font color = teal>Unable to unlock soul while deceased.","chat.system")
					usr.set_alert("Need life to unlock this soul",'alert.dmi',"alert")
				//	usr.create_chat_entry("alerts","Need life to unlock this soul.")
					return
				if(usr.RP_Points < usr.part_selected.needed_rp)
					usr << output("<font color = teal>You need [usr.part_selected.needed_rp] Roleplay points to unlock [usr.part_selected]. You have [usr.RP_Points].","chat.system")
					usr.set_alert("Need more rp points",'alert.dmi',"alert")
				//	usr.create_chat_entry("alerts","Need more rp points.")
					return
				var/obj/body_related/soul/o = usr.part_selected
				if(o.can_unlock)
					o.part_reward(usr)
		click_misc()
			set name = ".click_misc"
			set hidden = 1
			if(usr.typing) return
			if(usr.part_selected)
				if(istype(usr.part_selected,/obj/body_related/bodyparts/torso/heart))
					if(usr.part_selected.info_name == "Divine Seed")
						var/obj/body_related/bodyparts/torso/heart/o = usr.part_selected
						o.can_unlock = 1
						if(o.can_unlock)
						//if(o.level >= 100)
							o.destroy()
							winset(usr,"body.button_misc","is-visible=false")
							usr.client.screen -= usr.hud_body
							usr.open_body = 0
							usr.open_menus.Remove(".open_body")
							usr.upgrading = null
							if(usr.skill_divine_infusion && usr.skill_divine_infusion.active == 1) call(usr.skill_divine_infusion.act)(usr,usr.skill_divine_infusion)

							var/obj/items/tech/Vat/v = new
							v.loc = usr.loc
							v.step_x = usr.step_x
							v.step_y = usr.step_y
							v.pixel_x += 16
							v.organic = 1
							v.icon = 'seed_pod.dmi'
							v.overlays = null
							v.bounds = "-23,2 to 23,18"
							v.belongs = usr.real_name

							usr.tech_using = v
							usr.grow_clones()
							usr.tech_using = null
							usr.part_selected = null
						else
							usr.set_alert("Need level 100",'alert.dmi',"alert")
						//	usr.create_chat_entry("alerts","Need level 100.")
	proc
		part_train()
			if(src.typing) return
			if(src.upgrading)
				var/mob/m = src.upgrading
				if(get_dist(src,m) <= 2)
					if(src.resources >= 100000)
					//	src.resources -= 100000
						src.update_rsc()
						if(m.part_selected)
							var/obj/body_related/bodyparts/p = m.part_selected
							if(p)
								p.part_exp = 100
								p.part_reward(m,1,src)
				else
					src.client.screen -= src.hud_body
					src.open_body = 0
					src.open_menus.Remove(".open_body")
					src.upgrading = null
					src.set_alert("Android too far away",'alert.dmi',"alert")
					//src.create_chat_entry("alerts","Android too far away.")
					src << output("Android is too far away to upgrade.", "chat.system")
				return
			/*
			if(src.part_focus)
				var/obj/body_related/bodyparts/p = src.part_focus
				p.icon_state = "[p.i_state]" //Reset previous part_focus to orginal icon
			*/
			if(istype(src.part_selected,/obj/body_related/bodyparts/))  //If we click train and the part selected isn't a body milestone
				//Someone uses an Mechanical Upgrade Kit
				var/obj/body_related/bodyparts/p = src.part_selected
				if(p.cybernetic)
				//if(src.race == "Android")
					var/found_kit = 0
					for(var/obj/items/tech/Upgrade_Kit/auk in src)
						//var/obj/body_related/bodyparts/p = src.part_selected
						p.part_exp = 1000
						p.part_reward(src,1)
						found_kit = 1
						auk.use_obj(src)
						src.refresh_inv()
						break
					if(found_kit == 0)
						src.set_alert("Need Upgrade Kit",'alert.dmi',"alert")
					//	src.create_chat_entry("alerts","Need Mechanical Upgrade Kit.")
						src << output("Need Upgrade Kit.", "chat.system")
					return
				else if(src.part_selected && src.part_selected != src.part_focus)
					/*
					if(p.infused_divine) p.icon_state = "[initial(p.icon_state)] divine selected"
					else if(p.infused_dark) p.icon_state = "[initial(p.icon_state)] dark selected"
					else if(p.infused_petrified) p.icon_state = "[initial(p.icon_state)] petrified selected"
					else p.icon_state = "[initial(p.icon_state)] selected"
					*/
					src.part_focus = src.part_selected
					winset(src,"body.button_train","text=\"Cancel\"")
					var/icon/I = icon(p.icon,p.icon_state,SOUTH,1,0)
					I.Scale(64,64)
					var/Z = fcopy_rsc(I)
					winset(src,"body.label_img","image=\ref[Z]")
					return
				else if(src.part_selected && src.part_selected == src.part_focus)
					if(src.race == "Android") winset(src,"body.button_train","text=\"Upgrade\"")
					else winset(src,"body.button_train","text=\"Forge\"")
					src.part_focus = null
					return
			if(istype(src.part_selected,/obj/body_related/body_milestones/))
				if(src.has_body == 0)
					src << output("<font color = teal>Unable to unlock body milestones with no body.","chat.system")
					src.set_alert("Need body to unlock milestones",'alert.dmi',"alert")
					//src.create_chat_entry("alerts","Need body to unlock milestones.")
					return
				var/obj/body_related/body_milestones/o = src.part_selected
				if(o.can_unlock)
					o.part_reward(src)
			if(istype(src.part_selected,/obj/body_related/ascension_milestones/))
				if(src.part_selected.needs_body && src.has_body == 0)
					src << output("<font color = teal>Unable to unlock this ascension without a body.","chat.system")
					src.set_alert("Need body to unlock this ascension",'alert.dmi',"alert")
					//src.create_chat_entry("alerts","Need body to unlock this ascension.")
					return
				if(src.part_selected.needs_soul && src.dead)
					src << output("<font color = teal>Unable to unlock this ascension while deceased.","chat.system")
					src.set_alert("Need life to unlock this ascension",'alert.dmi',"alert")
					//src.create_chat_entry("alerts","Need life to unlock this ascension.")
					return
				var/obj/body_related/ascension_milestones/o = src.part_selected
				if(o.can_unlock)
					o.part_reward(src)
			if(istype(src.part_selected,/obj/body_related/soul/))
				if(src.part_selected.needs_soul && src.dead)
					src << output("<font color = teal>Unable to unlock soul while deceased.","chat.system")
					src.set_alert("Need life to unlock this soul",'alert.dmi',"alert")
					//src.create_chat_entry("alerts","Need life to unlock this soul.")
					return
				if(src.RP_Points < src.part_selected.needed_rp)
					src << output("<font color = teal>You need [src.part_selected.needed_rp] Roleplay points to unlock [src.part_selected]. You have [src.RP_Points].","chat.system")
					src.set_alert("Need more rp points",'alert.dmi',"alert")
					//src.create_chat_entry("alerts","Need more rp points.")
					return
				var/obj/body_related/soul/o = src.part_selected
				if(o.can_unlock)
					o.part_reward(src)
		remove_part_stats(var/obj/body_related/p,var/remove = 1)
			//Remove different stats based on the part and its level
			if(remove)
				//Remove environmental tolerances
				src.o2_max -= p.o2_gain*p.level
				src.mod_immune_rads -= p.rads_gain*p.level
				src.mod_immune_cold -= p.cold_gain*p.level
				src.mod_immune_heat -= p.heat_gain*p.level
				src.mod_immune_toxins -= p.toxin_gain*p.level
				src.mod_immune_gravity -= p.gravity_gain*p.level
				src.mod_immune_microwaves -= p.micro_gain*p.level

				//Make sure to track injuries for the player

				//Injury stats
				src.injury_power += p.psi_gain_base*p.level
				src.injury_energy += p.eng_gain_base*p.level
				src.injury_strength += p.str_gain_base*p.level
				src.injury_endurance += p.end_gain_base*p.level
				src.injury_force += p.force_gain_base*p.level
				src.injury_resistance += p.res_gain_base*p.level
				src.injury_off += p.off_gain_base*p.level
				src.injury_def += p.def_gain_base*p.level

				//Injury mods
				src.injury_power_mod += p.psi_mod_gain*p.level
				src.injury_energy_mod += p.eng_mod_gain*p.level
				src.injury_agility_mod += p.spd_mod_gain*p.level
				src.injury_regen_mod += p.regen_mod_gain*p.level
				src.injury_recov_mod += p.recov_mod_gain*p.level

				//Injury environmental tolerances
				src.immune_rads_injury += p.rads_gain*p.level
				src.immune_cold_injury += p.cold_gain*p.level
				src.immune_heat_injury += p.heat_gain*p.level
				src.immune_gravity_injury += p.gravity_gain*p.level
				src.immune_microwaves_injury += p.micro_gain*p.level
				src.immune_toxins_injury += p.toxin_gain*p.level
				src.injury_o2 += p.o2_gain*p.level

				//Remove the stats

				//No psionic or energy because they are calculated differently
				src.strength -= (p.str_gain_base*src.mod_strength)*p.level
				src.endurance -= (p.end_gain_base*src.mod_endurance)*p.level
				src.resistance -= (p.res_gain_base*src.mod_resistance)*p.level
				src.force -= (p.force_gain_base*src.mod_force)*p.level
				src.offence -= (p.off_gain_base*src.mod_offence)*p.level
				src.defence -= (p.def_gain_base*src.mod_defence)*p.level

				//Remove the stat mods
				src.mod_psionic_power -= p.psi_mod_gain*p.level
				src.mod_energy -= p.eng_mod_gain*p.level
				src.mod_agility -= p.spd_mod_gain*p.level
				src.mod_regeneration -= p.regen_mod_gain*p.level
				src.mod_recovery -= p.recov_mod_gain*p.level
			//Add different stats based on the part and its level
			else
				//Add environmental tolerances
				src.o2_max += p.o2_gain*p.level
				src.mod_immune_rads += p.rads_gain*p.level
				src.mod_immune_cold += p.cold_gain*p.level
				src.mod_immune_heat += p.heat_gain*p.level
				src.mod_immune_toxins += p.toxin_gain*p.level
				src.mod_immune_gravity += p.gravity_gain*p.level
				src.mod_immune_microwaves += p.micro_gain*p.level

				//Make sure to track injuries for the player

				//Injury stats
				src.injury_power -= p.psi_gain_base*p.level
				src.injury_energy -= p.eng_gain_base*p.level
				src.injury_strength -= p.str_gain_base*p.level
				src.injury_endurance -= p.end_gain_base*p.level
				src.injury_force -= p.force_gain_base*p.level
				src.injury_resistance -= p.res_gain_base*p.level
				src.injury_off -= p.off_gain_base*p.level
				src.injury_def -= p.def_gain_base*p.level

				//Injury mods
				src.injury_power_mod -= p.psi_mod_gain*p.level
				src.injury_energy_mod -= p.eng_mod_gain*p.level
				src.injury_agility_mod -= p.spd_mod_gain*p.level
				src.injury_regen_mod -= p.regen_mod_gain*p.level
				src.injury_recov_mod -= p.recov_mod_gain*p.level

				//Injury environmental tolerances
				src.immune_rads_injury -= p.rads_gain*p.level
				src.immune_cold_injury -= p.cold_gain*p.level
				src.immune_heat_injury -= p.heat_gain*p.level
				src.immune_gravity_injury -= p.gravity_gain*p.level
				src.immune_microwaves_injury -= p.micro_gain*p.level
				src.immune_toxins_injury -= p.toxin_gain*p.level
				src.injury_o2 -= p.o2_gain*p.level

				//Add the stats

				//Add the stat mods
				src.mod_psionic_power += p.psi_mod_gain*p.level
				src.mod_energy += p.eng_mod_gain*p.level
				src.mod_agility += p.spd_mod_gain*p.level
				src.mod_regeneration += p.regen_mod_gain*p.level
				src.mod_recovery += p.recov_mod_gain*p.level

				//No psionic or energy because they are calculated differently
				src.strength += (p.str_gain_base*src.mod_strength)*p.level
				src.endurance += (p.end_gain_base*src.mod_endurance)*p.level
				src.resistance += (p.res_gain_base*src.mod_resistance)*p.level
				src.force += (p.force_gain_base*src.mod_force)*p.level
				src.offence += (p.off_gain_base*src.mod_offence)*p.level
				src.defence += (p.def_gain_base*src.mod_defence)*p.level

		damage_part(var/obj/body_related/p, var/damage = 1,var/msg = "damaged",var/show_alert = 1) //Singular part, for when broken or mangled. Or healed.
			//This should be the only place/proc where a limb is set to damaged

			//If the part is broken or mangled, disable it and re-calculate stats for that part.
			if(damage)
				if(p.damaged == 0)
					p.damaged = 1 //This should be the only place a limb is ever set to damaged = 1
					p.status = "[msg]"
					if(src.client && show_alert)
						src.set_alert("[p] [lowertext(msg)]",p.icon,p.icon_state)
						//src.create_chat_entry("alerts","[p] [lowertext(msg)]")
					//If the part wasn't already disabled or damaged, proceed. Just so we don't take stats away twice.
					if(p.disabled == 0)
						src.remove_part_stats(p,1)
					else
						p.status = "Disabled, [msg]"
				// === Zenkai per-hit pooling ===
				if(src.race == "Saiyan")
				// compute current health percent for this part
					var/cur = 0
					var/maxv = 0
					for(var/obj/body_related/part_sub in p)
						cur += part_sub.hp
						maxv += part_sub.hp_max
					if(maxv <= 0) maxv = 1
					var/hp_percent = round((cur / maxv) * 100)

				// give zenkai hit gain based on damage state
					src.zenkai_pool_hit(hp_percent)

			//If the part is healed, re-add stats.
			else
				//Makes sure we don't enable a disabled part. This stops players from having a busted body, then using body reformation to repair everything all at once.
				if(p.damaged)
					p.damaged = 0
					if(src.client && show_alert)
						src.set_alert("[p] fully healed",p.icon,p.icon_state)
					//	src.create_chat_entry("alerts","[p] fully healed")
					if(p.disabled == 0)
						src.remove_part_stats(p,0)
						p.status = "Functional"
					else
						p.status = "Disabled"
			//if(src.hud_paperdoll) src.hud_paperdoll.color_paperdoll(src)
			if(src.hud_body) src.hud_body.color_paperdoll(src)
			if(src.part_selected == p && src.client)
				if(p.status == "Functional") winset(src,"body.status_txt","text-color=#00FF00")
				else winset(src,"body.status_txt","text-color=#FF0000")
				winset(src,"body.status_txt","text=\"[p.status]\"")
			p.set_part_color()

		disable_parts(var/list/parts,var/all = 0, var/disable = 1,var/show_alert = 0,var/reason) //Multiple parts, for when killed or body is restored.
			if(parts == null) parts = list()
			if(disable)
				if(all)
					if(show_alert)
						src.set_alert("All bodyparts disabled due to death",'bodyparts_smaller.dmi',null)
						//src.create_chat_entry("alerts","All bodyparts disabled due to death.")
					for(var/obj/body_related/b in src.milestones)
						if(b.level > 0)
							if(b.needs_body) parts += b
							if(b.needs_soul && src.dead) parts += b
					for(var/obj/body_related/b in src.ascensions)
						if(b.level > 0)
							if(b.needs_body) parts += b
							if(b.needs_soul && src.dead) parts += b
					for(var/obj/body_related/b in src.soul)
						if(b.level > 0) parts += b
					for(var/obj/body_related/b in src.bodyparts)
						parts += b
						for(var/obj/body_related/p in b)
							parts += p
				//Disable bodyparts
				for(var/obj/body_related/p in parts)
					if(p.disabled == 0)
						p.disabled = 1
						p.status = "Disabled"
						p.disabled_by = "<font color = white>Disabled by [reason]\n\n"
					//So a part's stats aren't taken twice, if already damaged/broken for example
					if(p.damaged == 0)

						if(all == 0 && src.client && show_alert)
							src.set_alert("[p] disabled",p.icon,p.icon_state)
							//src.create_chat_entry("alerts","[p] disabled.")

						src.remove_part_stats(p,1)

					if(src.part_selected == p && src.client)
						if(p.status == "Functional") winset(src,"body.status_txt","text-color=#00FF00")
						else winset(src,"body.status_txt","text-color=#FF0000")
						winset(src,"body.status_txt","text=\"[p.status]\"")
						src.refresh_part_info(p)
					p.set_part_color()
			else
				if(all)
					if(show_alert)
						src.set_alert("All bodyparts restored",'bodyparts_smaller.dmi',null)
						//src.create_chat_entry("alerts","All bodyparts restored.")
					for(var/obj/body_related/b in src.milestones)
						if(b.level > 0)
							if(b.needs_body) parts += b
					for(var/obj/body_related/b in src.ascensions)
						if(b.level > 0)
							if(b.needs_body) parts += b
					for(var/obj/body_related/b in src.bodyparts)
						parts += b
						for(var/obj/body_related/p in b)
							parts += p
				//Enable bodyparts
				for(var/obj/body_related/p in parts)
					if(p.disabled && p.disabled_perma == 0)
						p.disabled = 0
						if(p.damaged == 0)
							p.status = "Functional"
							p.disabled_by = ""

							if(all == 0 && src.client && show_alert)
								src.set_alert("[p] functional",p.icon,p.icon_state)
								//src.create_chat_entry("alerts","[p] functional.")

							src.remove_part_stats(p,0)
						else
							if(p.bodypart_type == "Bone") p.status = "Broken"
							else p.status = "Damaged"
					if(src.part_selected == p && src.client)
						if(p.status == "Functional") winset(src,"body.status_txt","text-color=#00FF00")
						else winset(src,"body.status_txt","text-color=#FF0000")
						winset(src,"body.status_txt","text=\"[p.status]\"")
						src.refresh_part_info(p)
					p.hp = 100
					p.set_part_color()
					src.hud_body.color_paperdoll(src)
			//if(src.hud_paperdoll) src.hud_paperdoll.color_paperdoll(src)
			if(src.hud_body) src.hud_body.color_paperdoll(src)
		refresh_cyber(var/obj/part)
			src << output(null,"body_pane_cyber.grid_cyber")
			if(src.client) winset(src, "body_pane_cyber.grid_cyber", "cells=\"0\"")
			var/count = 0
			if(part)
				for(var/obj/x in part)
					if(istype(x,/obj/body_related/bodyparts/cybernetics/) == 1) src << output(x,"body_pane_cyber.grid_cyber:[++count]")
			else if(src.part_selected)
				for(var/obj/x in src.part_selected)
					for(var/obj/y in x)
						for(var/obj/z in y)
							if(istype(z,/obj/body_related/bodyparts/cybernetics/) == 1) src << output(z,"body_pane_cyber.grid_cyber:[++count]")
			if(src.client) winset(src, "body_pane_cyber.grid_cyber", "cells=\"[count]\"")
		refresh_part_info(var/obj/body_related/part)
			/*
			Going to try and make this proc update all the body part text info in the game, when needed.

			Only needs to be called when a part is being selected, or is already selected
			This is because a player can't look at more than part at a time

			---Hopefully called when one of the following happens---

			---While selected-------------------
			- When the part levels
			- When a part is infused
			- When a part(ascension,milestone,soul) is unlocked
			- When a part is healing
			- When a part is disabled
			- When a part is restored
			------------------------------------
			*/
			if(src.part_selected == part)
				var/obj/hud/menus/bodyparts_background/h = src.hud_body
				if(h.bodypart_icon && h.bodypart_icon.menu == h)

					//Update the display icon for that bodypart, inside the info_holder
					h.bodypart_icon.icon = part.icon
					h.bodypart_icon.icon_state = part.icon_state
					h.info_holder.vis_contents -= h.bodypart_icon
					h.info_holder.vis_contents += h.bodypart_icon

					/*
					- Update the cybernetics used slots, then
					- Check if the part is cybernetic or not
					- Name the button either "Psiforge", "Upgrade" or "Cancel" based on certain factors
					- Add or remove the "Remove" button for cybernetics, if needed. Defaults to always remove it
					*/
					h.part_cyber.maptext = "[css_outline]<font size = 1><left>Cybernetic Slots: [part.cybernetics_current]/[part.cybernetics_max]"
					h.info_holder.vis_contents -= h.button_remove
					if(part.cybernetic)
						h.psiforge.maptext = "[css_outline]<font size = 1><center>Upgrade"
						h.psiforge.info = "[css_outline]<font size = 1><text align=left valign=top><u>Upgrading</u>\n\nClicking this button will search your inventory for a Mechanical Upgrade Kit and use it to increase the level of this cybernetic bodypart. Unlike normal bodyparts, cybernetic and artificial parts increase in multiple levels."
						h.info_holder.vis_contents += h.button_remove
					else if(src.part_focus == part) h.psiforge.maptext = "[css_outline]<font size = 1><center>Cancel"
					else if(istype(part,/obj/body_related/body_milestones) || istype(part,/obj/body_related/soul) || istype(part,/obj/body_related/ascension_milestones)) h.psiforge.maptext = "[css_outline]<font size = 1><center>Unlock"
					else
						h.psiforge.info = "[css_outline]<font size = 1><text align=left valign=top><u>Toning</u>\n\nClicking this button starts the Psiforging process on the associated bodypart. Then whenever you gain xp toward your core stats, a portion of that xp converts into xp for this bodypart."
						h.psiforge.maptext = "[css_outline]<font size = 1><center>Tone"

					/*
					- Update the name of the part
					- Set the status of the part and color it red/green, ect.
					*/
					h.part_name.maptext = "[css_outline]<font size = 1><left>Name: [part.info_name]"
					var/col
					if(part.status == "Functional") col = "green"
					else col = "red"
					h.part_status.maptext = "[css_outline]<font size = 1><left>Status: <font color = [col]>[part.status]"

					/*
					- Update the main bulk of the part text
					- First displays the Training Results, which forces the "Disabled By:" and "Info" parts to be shifted correctly.
					*/
					h.part_stats.maptext = "[h.part_stats.maptext]\n\n[part.disabled_by]<font color = white>[part.info]"

					//Add/Remove the hp_bar/xp_bars for the parts
					h.info_holder.vis_contents -= h.hp_bar
					h.info_holder.vis_contents += h.hp_bar
					h.info_holder.vis_contents -= h.xp_bar
					h.info_holder.vis_contents += h.xp_bar

					//If the part isn't what we're psiforging, remove the more pronounced version of the "menu selected" and add the lesser one
					if(part != src.part_focus)
						part.underlays = null
						if(bodypart_underlay) bodypart_underlay.icon_state = "menu selected"
						part.underlays += bodypart_underlay
		skill_exp()
			if(src.open_skills && src.skill_selected)
				if(src.skill_selected.loc)
					var/obj/skills/sk = src.skill_selected

					if(sk.clone_of == null)
						for(var/obj/skills/s in src)
							if(sk.cloned == "[s.name] aa_clone_aa")
								sk.clone_of = s
								s.clone = sk
								break

					var/obj/skills/og = sk.clone_of

					var/obj/hud/menus/skills_background/skills_exp_bar/xp = src.hud_skills.skill_xp
					var/obj/lvl = src.hud_skills.skills_level
					var/matrix/m = matrix()
					m.Scale(og.skill_exp/2,1)
					m.Translate(xp.hud_x+og.skill_exp/4,xp.hud_y+xp.translated_y)
					xp.transform = m
					lvl.maptext = "[css_outline]<font size = 1><center>Level: [og.skill_lvl]"
		body_exp_hp()
			if(src.open_body)
				var/obj/hud/menus/bodyparts_background/b = src.hud_body
				if(b.selected == 1) b.txt_requirements.maptext = "[css_outline]<font size = 1><center>Toning Speed: [round(src.psiforging_speed*100)]%"
				if(src.part_selected)
					var/obj/body_related/sk = src.part_selected

					//Bodypart exp bar
					var/obj/hud/menus/bodyparts_background/part_xp_bar/xp = src.hud_body.xp_bar
					var/obj/lvl = src.hud_body.part_level
					var/matrix/m = matrix()
					m.Scale(sk.part_exp/2,1)
					m.Translate(xp.hud_x+sk.part_exp/4,xp.hud_y+xp.translated_y)
					xp.transform = m
					lvl.maptext = "[css_outline]<font size = 1><left>Level: [sk.level]/[sk.lvl_max]"

					//Bodypart hp bar
					var/obj/hud/menus/bodyparts_background/part_hp_bar/hp = src.hud_body.hp_bar
					var/matrix/m2 = matrix()
					m2.Scale(sk.hp/2,1)
					m2.Translate(hp.hud_x+sk.hp/4,hp.hud_y+hp.translated_y)
					hp.transform = m2


		add_chakras()
			src.chakras = list(new /:crown_chakra,new /:third_eye_chakra,new /:throat_chakra,new /:heart_chakra,new /:solar_plexus_chakra,new /:sacral_chakra,new /:root_chakra)
			for(var/obj/c in src.chakras)
				c.name = c.info_name
		add_meridians()
			src.meridians = list()
			var/minor_meridians = 6
			while(minor_meridians)

				var/obj/body_related/bodyparts/meridians/meridian_veins/m_v = new
				m_v.inside = src.bodyparts[minor_meridians]
				m_v.name = m_v.info_name
				m_v.i_state = m_v.icon_state
				src.meridians += m_v
				var/obj/body_related/bodyparts/meridians/meridian_artery/m_a = new
				m_a.inside = src.bodyparts[minor_meridians]
				m_a.name = m_a.info_name
				m_a.i_state = m_a.icon_state
				src.meridians += m_a
				minor_meridians -= 1
				//sleep(1)
		create_body()
			src.body = list()

			var/obj/body_related/bodyparts/LA = new
			LA.name = "Left Arm"
			LA.hp = 100
			LA.hp_max = 100

			var/obj/body_related/bodyparts/RA = new
			RA.name = "Right Arm"
			RA.hp = 100
			RA.hp_max = 100

			var/obj/body_related/bodyparts/LL = new
			LL.name = "Left Leg"
			LL.hp = 100
			LL.hp_max = 100

			var/obj/body_related/bodyparts/RL = new
			RL.name = "Right Leg"
			RL.hp = 100
			RL.hp_max = 100

			src.body += LA
			src.body += RA
			src.body += LL
			src.body += RL
		/*create_body()
			/*if(src.race == "Demon" || src.race == "Kai")
				src.bodyparts = list(new/obj/body_related/bodyparts/head,new/obj/body_related/bodyparts/torso,new/obj/body_related/bodyparts/left_arm,
				new/obj/body_related/bodyparts/right_arm,new/obj/body_related/bodyparts/right_leg,new/obj/body_related/bodyparts/left_leg)

				src.add_meridians()
				src.add_chakras()*/
		//	else
			src.bodyparts = list()
			src.body = list()
			var/obj/hud/menus/bodyparts_background/bodypart/bodypart1 = new
			var/obj/body_related/bodyparts/head/h = new
		/*	var/obj/body_related/bodyparts/head/h = new
			var/list/head_parts = typesof(/obj/body_related/bodyparts/head/)
			for(var/p in head_parts)
				if(p != /obj/body_related/bodyparts/head)
					var/obj/body_related/part = new p(h)
					if(src.race == "Android")
						if(part.cybernetic == 0)
							if(part.bodypart_type != "Muscle" && part.bodypart_type != "Bone")
								part.destroy()
							else if(part.bodypart_type == "Muscle")
								part.info_name = "Cybernetic [part.info_name]"
								part.cybernetic = 1
								part.cybernetics_max = 0
								part.icon_state = "cybernetic muscle"
							else if(part.bodypart_type == "Bone")
								part.info_name = "Metal [part.info_name]"
								part.icon_state = "metal bones"
								part.cybernetics_max = 0
								part.cybernetic = 1
					else if(part.cybernetic)
						part.destroy()
					if(src.race == "Namekian")
						if(part.bodypart_type == "Bone") part.destroy()*/
			src.bodyparts += bodypart1
			src.body += bodypart1

			var/obj/hud/menus/bodyparts_background/bodypart/bodypart2 = new
			/*var/obj/body_related/bodyparts/torso/t = new
			var/list/torso_parts = typesof(/obj/body_related/bodyparts/torso/)
			torso_parts -= /obj/body_related/bodyparts/torso/bio_processor
			for(var/p in torso_parts)
				if(p != /obj/body_related/bodyparts/torso)
					var/obj/body_related/part = new p(t)
					if(src.race == "Android")
						if(part.cybernetic == 0)
							if(part.bodypart_type != "Muscle" && part.bodypart_type != "Bone")
								part.destroy()
							else if(part.bodypart_type == "Muscle")
								part.info_name = "Cybernetic [part.info_name]"
								part.icon_state = "cybernetic muscle"
								part.cybernetics_max = 0
								part.cybernetic = 1
							else if(part.bodypart_type == "Bone")
								part.info_name = "Metal [part.info_name]"
								part.icon_state = "metal bones"
								part.cybernetic = 1
								part.cybernetics_max = 0
					else if(part.cybernetic)
						part.destroy()
					if(src.race == "Namekian")
						if(part.bodypart_type == "Bone") part.destroy() */

			src.bodyparts += bodypart2
			src.body += bodypart2

			var/obj/hud/menus/bodyparts_background/bodypart/bodypart3 = new
			/*var/obj/body_related/bodyparts/left_arm/la = new
			var/list/left_arm_parts = typesof(/obj/body_related/bodyparts/left_arm/)
			for(var/p in left_arm_parts)
				if(p != /obj/body_related/bodyparts/left_arm)
					var/obj/body_related/part = new p(la)
					if(src.race == "Android")
						if(part.cybernetic == 0)
							if(part.bodypart_type != "Muscle" && part.bodypart_type != "Bone")
								part.destroy()
							else if(part.bodypart_type == "Muscle")
								part.info_name = "Cybernetic [part.info_name]"
								part.icon_state = "cybernetic muscle"
								part.cybernetics_max = 0
								part.cybernetic = 1
							else if(part.bodypart_type == "Bone")
								part.info_name = "Metal [part.info_name]"
								part.icon_state = "metal bones"
								part.cybernetic = 1
								part.cybernetics_max = 0
					else if(part.cybernetic)
						part.destroy()
					if(src.race == "Namekian")
						if(part.bodypart_type == "Bone") part.destroy()*/

			src.bodyparts += bodypart3
			src.body += bodypart3

			var/obj/hud/menus/bodyparts_background/bodypart/bodypart4 = new
			/*var/obj/body_related/bodyparts/right_arm/ra = new
			var/list/right_arm_parts = typesof(/obj/body_related/bodyparts/right_arm/)
			for(var/p in right_arm_parts)
				if(p != /obj/body_related/bodyparts/right_arm)
					var/obj/body_related/part = new p(ra)
					if(src.race == "Android")
						if(part.cybernetic == 0)
							if(part.bodypart_type != "Muscle" && part.bodypart_type != "Bone")
								part.destroy()
							else if(part.bodypart_type == "Muscle")
								part.info_name = "Cybernetic [part.info_name]"
								part.icon_state = "cybernetic muscle"
								part.cybernetic = 1
								part.cybernetics_max = 0
							else if(part.bodypart_type == "Bone")
								part.info_name = "Metal [part.info_name]"
								part.icon_state = "metal bones"
								part.cybernetic = 1
								part.cybernetics_max = 0
					else if(part.cybernetic)
						part.destroy()
					if(src.race == "Namekian")
						if(part.bodypart_type == "Bone") part.destroy()*/
			src.bodyparts += bodypart4
			src.body += bodypart4

			/*var/obj/body_related/bodyparts/right_leg/rl = new
			var/list/right_leg_parts = typesof(/obj/body_related/bodyparts/right_leg/)
			for(var/p in right_leg_parts)
				if(p != /obj/body_related/bodyparts/right_leg)
					var/obj/body_related/part = new p(rl)
					if(src.race == "Android")
						if(part.cybernetic == 0)
							if(part.bodypart_type != "Muscle" && part.bodypart_type != "Bone")
								part.destroy()
							else if(part.bodypart_type == "Muscle")
								part.info_name = "Cybernetic [part.info_name]"
								part.icon_state = "cybernetic muscle"
								part.cybernetic = 1
								part.cybernetics_max = 0
							else if(part.bodypart_type == "Bone")
								part.info_name = "Metal [part.info_name]"
								part.icon_state = "metal bones"
								part.cybernetic = 1
								part.cybernetics_max = 0
					else if(part.cybernetic)
						part.destroy()
					if(src.race == "Namekian")
						if(part.bodypart_type == "Bone") part.destroy()
			src.bodyparts += bodypart2
			src.body + bodypart2

			var/obj/body_related/bodyparts/left_leg/ll = new
			var/list/left_leg_parts = typesof(/obj/body_related/bodyparts/left_leg/)
			for(var/p in left_leg_parts)
				if(p != /obj/body_related/bodyparts/left_leg)
					var/obj/body_related/part = new p(ll)
					if(src.race == "Android")
						if(part.cybernetic == 0)
							if(part.bodypart_type != "Muscle" && part.bodypart_type != "Bone")
								part.destroy()
							else if(part.bodypart_type == "Muscle")
								part.info_name = "Cybernetic [part.info_name]"
								part.icon_state = "cybernetic muscle"
								part.cybernetic = 1
								part.cybernetics_max = 0
							else if(part.bodypart_type == "Bone")
								part.info_name = "Metal [part.info_name]"
								part.icon_state = "metal bones"
								part.cybernetic = 1
								part.cybernetics_max = 0
					else if(part.cybernetic)
						part.destroy()
					if(src.race == "Namekian")
						if(part.bodypart_type == "Bone") part.destroy()
			src.bodyparts += bodypart2
			src.body + bodypart2*/

			/*if(src.race != "Android")
				src.add_meridians()
				src.add_chakras()*/

			for(var/obj/p in src.bodyparts)
				p.name = p.info_name
				//world << output("Created [p.name]","chat.system")
				for(var/obj/body_related/o in p)
					o.name = o.info_name
					o.i_state = o.icon_state
					src.total_organs += 1
					//world << output("Created [o.name]","chat.system")
				//world << output("Created [p.name]","chat.system")


				*/