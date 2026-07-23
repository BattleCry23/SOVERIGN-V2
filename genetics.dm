mob
	verb
		power_grid_genetics()
			set name = ".power_grid_genetics"
			set hidden = 1
			if(usr.tech_using)
				if(get_dist(usr,usr.tech_using) > 2)
					return
				else if(istype(usr.tech_using,/obj/items/tech/Vat))
					var/obj/items/tech/Vat/v = usr.tech_using
					if(v.growth_percent >= 100)
						//Check for true/false in reverse, because the button is actually changed to true when clicked before this verb is activated, as a result of this button being clicked.
						if(winget(usr,"genetics.button_power","is-checked") == "true")
							v.generator = 1;
							v.generates = 100*v.vat_energy;
							winset(usr,"genetics.power_generated","text=\"Power Generated: [v.generates]\"")
							for(var/turf/trf in v.locs)
								for(var/obj/items/tech/Power_Line/p in trf)
									p.reconnect_power()
							usr << output("Clone now being used to power grid.", "chat.system")
							return
						if(winget(usr,"genetics.button_power","is-checked") == "false")
							v.generator = 0;
							v.generates = 0;
							winset(usr,"genetics.power_generated","text=\"Power Generated: 0\"")
							for(var/turf/trf in v.locs)
								for(var/obj/items/tech/Power_Line/p in trf)
									p.reconnect_power()
							return
		display_info_vat(var/t as text)
			set name = ".display_info_vat"
			set hidden = 1
			if(usr.tech_using)
				if(get_dist(usr,usr.tech_using) > 2)
					return
				else if(istype(usr.tech_using,/obj/items/tech/Vat))
					var/obj/items/tech/Vat/v = usr.tech_using
					if(t == "heart")
						if(v.vat_extra_heart == 0)
							v.cost += 1000000
							v.vat_extra_heart = 1;
						else
							v.cost -= 1000000
							v.vat_extra_heart = 0;

					if(t == "lungs")
						if(v.vat_extra_lungs == 0)
							v.cost += 1000000
							v.vat_extra_lungs = 1;
						else
							v.cost -= 1000000
							v.vat_extra_lungs = 0;

					if(t == "liver")
						if(v.vat_extra_liver == 0)
							v.cost += 1000000
							v.vat_extra_liver = 1;
						else
							v.cost -= 1000000
							v.vat_extra_liver = 0;

					if(t == "spleen")
						if(v.vat_extra_spleen == 0)
							v.cost += 1000000
							v.vat_extra_spleen = 1;
						else
							v.cost -= 1000000
							v.vat_extra_spleen = 0;

					if(t == "lobe")
						if(v.vat_extra_lobe == 0)
							v.cost += 1000000
							v.vat_extra_lobe = 1;
						else
							v.cost -= 1000000
							v.vat_extra_lobe = 0;

					if(t == "adrenal")
						if(v.vat_extra_adrenal == 0)
							v.cost += 1000000
							v.vat_extra_adrenal = 1;
						else
							v.cost -= 1000000
							v.vat_extra_adrenal = 0;

					if(t == "regen")
						if(v.vat_extra_regen == 0)
							v.cost += 1000000
							v.vat_extra_regen = 1;
						else
							v.cost -= 1000000
							v.vat_extra_regen = 0;

					if(t == "hide")
						if(v.vat_extra_skin == 0)
							v.cost += 1000000
							v.vat_extra_skin = 1;
						else
							v.cost -= 1000000
							v.vat_extra_skin = 0;

					if(t == "growth")
						if(v.vat_extra_growth == 0)
							v.cost += 1000000
							v.vat_extra_growth = 1;
						else
							v.cost -= 1000000
							v.vat_extra_growth = 0;
					usr.show_info_vat(v)
		close_genetics()
			set name = ".close_genetics"
			set hidden = 1
			if(usr.tech_using)
				var/obj/x = usr.tech_using
				x.used_by = null
				usr.tech_using = null;
			winshow(usr,"genetics",0)
		switch_clone_type(var/t as text)
			set name = ".switch_clone_type"
			set hidden = 1
			if(usr.tech_using)
				if(get_dist(usr,usr.tech_using) > 2)
					return
				else if(istype(usr.tech_using,/obj/items/tech/Vat))
					var/obj/items/tech/Vat/v = usr.tech_using
					if(t == "clone")
						v.set_vat_stats(0,usr)
						winset(usr,"genetics.button_new","is-checked=false")
						v.clone_type = "Clone"
					if(t == "new")
						v.set_vat_stats(1,usr)
						winset(usr,"genetics.button_clone","is-checked=false")
						v.clone_type = "New"
		adjust_stats_genetics(var/n as text,var/t as text)
			set name = ".adjust_stats_genetics"
			set hidden = 1
			if(usr.tech_using)
				if(get_dist(usr,usr.tech_using) > 2)
					return
				else if(istype(usr.tech_using,/obj/items/tech/Vat))
					//var/c = 0
					var/obj/items/tech/Vat/v = usr.tech_using
					var/clone = 0;
					var/multi = 1
					if(usr.client.shift) multi = 100
					if(winget(usr,"genetics.button_clone","is-checked") == "true") clone = 1;
					if(t == "psi")
						if(n == "+")
							while(multi)
								multi -= 1
								//if(v.vat_psi_stat < ((v.vat_psi_base/v.vat_psi_mod_base)*v.vat_psi)+(src.stat_limit*v.vat_psi))
								v.vat_psi_stat += v.vat_psi
								v.vat_psi_stat = round(v.vat_psi_stat,0.1)
								v.cost += round(v.vat_psi_stat/v.vat_psi,0.1)

						if(n == "-")
							if(v.vat_psi_stat > 1)
								while(multi)
									multi -= 1
									var/proceed = 1
									if(clone && v.vat_psi_stat <= (v.vat_psi_base/v.vat_psi_mod_base)*v.vat_psi)
										proceed = 0;
										multi = 0;
									if(proceed)
										v.vat_psi_stat -= v.vat_psi
										v.cost -= round(v.vat_psi_stat/v.vat_psi,0.1)

					if(t == "energy")
						if(n == "+")
							while(multi)
								multi -= 1
								//if(v.vat_energy_stat < ((v.vat_energy_base/v.vat_energy_mod_base)*v.vat_energy)+(src.stat_limit*v.vat_energy))
								v.vat_energy_stat += v.vat_energy
								v.vat_energy_stat = round(v.vat_energy_stat,0.1)
								v.cost += round(v.vat_energy_stat/v.vat_energy,0.1)
						if(n == "-")
							if(v.vat_energy_stat > 1)
								while(multi)
									multi -= 1
									var/proceed = 1
									if(clone && v.vat_energy_stat <= (v.vat_energy_base/v.vat_energy_mod_base)*v.vat_energy)
										proceed = 0;
										multi = 0;
									if(proceed)
										v.cost -= round(v.vat_energy_stat/v.vat_energy,0.1)
										v.vat_energy_stat -= v.vat_energy
										v.vat_energy_stat = round(v.vat_energy_stat,0.1)
					if(t == "strength")
						if(n == "+")
							while(multi)
								multi -= 1
								//if(v.vat_strength_stat < ((v.vat_strength_base/v.vat_strength_mod_base)*v.vat_strength)+(src.stat_limit*v.vat_strength))
								v.vat_strength_stat += v.vat_strength
								v.vat_strength_stat = round(v.vat_strength_stat,0.1)
								v.cost += round(v.vat_strength_stat/v.vat_strength,0.1)
						if(n == "-")
							if(v.vat_strength_stat > 1)
								while(multi)
									multi -= 1
									var/proceed = 1
									if(clone && v.vat_strength_stat <= (v.vat_strength_base/v.vat_strength_mod_base)*v.vat_strength)
										proceed = 0;
										multi = 0;
									if(proceed)
										v.cost -= round(v.vat_strength_stat/v.vat_strength,0.1)
										v.vat_strength_stat -= v.vat_strength
					if(t == "endurance")
						if(n == "+")
							while(multi)
								multi -= 1
								//if(v.vat_endurance_stat < ((v.vat_endurance_base/v.vat_endurance_mod_base)*v.vat_endurance)+(src.stat_limit*v.vat_endurance))
								v.vat_endurance_stat += v.vat_endurance
								v.vat_endurance_stat = round(v.vat_endurance_stat,0.1)
								v.cost += round(v.vat_endurance_stat/v.vat_endurance,0.1)
						if(n == "-")
							if(v.vat_endurance_stat > 1)
								while(multi)
									multi -= 1
									var/proceed = 1
									if(clone && v.vat_endurance_stat <= (v.vat_endurance_base/v.vat_endurance_mod_base)*v.vat_endurance)
										proceed = 0;
										multi = 0;
									if(proceed)
										v.cost -= round(v.vat_endurance_stat/v.vat_endurance,0.1)
										v.vat_endurance_stat -= v.vat_endurance
										v.vat_endurance_stat = round(v.vat_endurance_stat,0.1)
					if(t == "force")
						if(n == "+")
							while(multi)
								multi -= 1
								//if(v.vat_force_stat < ((v.vat_force_base/v.vat_force_mod_base)*v.vat_force)+(src.stat_limit*v.vat_force))
								v.vat_force_stat += v.vat_force
								v.vat_force_stat = round(v.vat_force_stat,0.1)
								v.cost += round(v.vat_force_stat/v.vat_force,0.1)
						if(n == "-")
							if(v.vat_force_stat > 1)
								while(multi)
									multi -= 1
									var/proceed = 1
									if(clone && v.vat_force_stat <= (v.vat_force_base/v.vat_force_mod_base)*v.vat_force)
										proceed = 0;
										multi = 0;
									if(proceed)
										v.cost -= round(v.vat_force_stat/v.vat_force,0.1)
										v.vat_force_stat -= v.vat_force
					if(t == "resistance")
						if(n == "+")
							while(multi)
								multi -= 1
								//if(v.vat_resistance_stat < ((v.vat_resistance_base/v.vat_resistance_mod_base)*v.vat_resistance)+(src.stat_limit*v.vat_resistance))
								v.vat_resistance_stat += v.vat_resistance
								v.vat_resistance_stat = round(v.vat_resistance_stat,0.1)
								v.cost += round(v.vat_resistance_stat/v.vat_resistance,0.1)
						if(n == "-")
							if(v.vat_resistance_stat > 1)
								while(multi)
									multi -= 1
									var/proceed = 1
									if(clone && v.vat_resistance_stat <= (v.vat_resistance_base/v.vat_resistance_mod_base)*v.vat_resistance)
										proceed = 0;
										multi = 0;
									if(proceed)
										v.cost -= round(v.vat_resistance_stat/v.vat_resistance,0.1)
										v.vat_resistance_stat -= v.vat_resistance
					if(t == "offence")
						if(n == "+")
							while(multi)
								multi -= 1
								//if(v.vat_offence_stat < ((v.vat_offence_base/v.vat_offence_mod_base)*v.vat_offence)+(src.stat_limit*v.vat_offence))
								v.vat_offence_stat += v.vat_offence
								v.vat_offence_stat = round(v.vat_offence_stat,0.1)
								v.cost += round(v.vat_offence_stat/v.vat_offence,0.1)
						if(n == "-")
							if(v.vat_offence_stat > 1)
								while(multi)
									multi -= 1
									var/proceed = 1
									if(clone && v.vat_offence_stat <= (v.vat_offence_base/v.vat_offence_mod_base)*v.vat_offence)
										proceed = 0;
										multi = 0;
									if(proceed)
										v.cost -= round(v.vat_offence_stat/v.vat_offence,0.1)
										v.vat_offence_stat -= v.vat_offence
					if(t == "defence")
						if(n == "+")
							while(multi)
								multi -= 1
								//if(v.vat_defence_stat < ((v.vat_defence_base/v.vat_defence_mod_base)*v.vat_defence)+(src.stat_limit*v.vat_defence))
								v.vat_defence_stat += v.vat_defence
								v.vat_defence_stat = round(v.vat_defence_stat,0.1)
								v.cost += round(v.vat_defence_stat/v.vat_defence,0.1)
						if(n == "-")
							if(v.vat_defence_stat > 1)
								while(multi)
									multi -= 1
									var/proceed = 1
									if(clone && v.vat_defence_stat <= (v.vat_defence_base/v.vat_defence_mod_base)*v.vat_defence)
										proceed = 0;
										multi = 0;
									if(proceed)
										v.cost -= round(v.vat_defence_stat/v.vat_defence,0.1)
										v.vat_defence_stat -= v.vat_defence
								v.vat_defence_stat = round(v.vat_defence_stat,0.1)
					if(v.cost < v.lowest) v.cost = v.lowest;
					v.cost = round(v.cost)
		adjust_points_genetics(var/n as text,var/t as text)
			set name = ".adjust_points_genetics"
			set hidden = 1
			var/c = 1000000
			if(winget(usr,"genetics.button_new","is-checked") == "true") c = 2000000
			if(usr.tech_using)
				if(get_dist(usr,usr.tech_using) > 2)
					return
				else if(istype(usr.tech_using,/obj/items/tech/Vat))
					var/obj/items/tech/Vat/v = usr.tech_using
					if(t == "psi")
						var/psi = v.vat_psi_stat/v.vat_psi
						if(n == "+")
							if(v.vat_psi < usr.gene_limit_psi || v.vat_psi < v.vat_psi_mod_base)
								v.points -= 1;
								v.points_assigned += 1;
								v.vat_psi += 0.1
								v.cost += (c*10)
						if(n == "-")
							if(v.vat_psi > 0.1)
								v.points += 1;
								v.points_assigned -= 1;
								v.vat_psi -= 0.1
								v.cost -= (c*10)
						v.vat_psi = round(v.vat_psi,0.1)
						v.vat_psi_stat = round(psi*v.vat_psi,0.1)
					if(t == "energy")
						var/eng = v.vat_energy_stat/v.vat_energy
						if(n == "+")
							if(v.vat_energy < usr.gene_limit_energy || v.vat_energy < v.vat_energy_mod_base)
								v.points -= 1;
								v.points_assigned += 1;
								v.vat_energy += 0.1
								v.cost += c
						if(n == "-")
							if(v.vat_energy > 0.1)
								v.points += 1;
								v.points_assigned -= 1;
								v.vat_energy -= 0.1
								v.cost -= c
						v.vat_energy = round(v.vat_energy,0.1)
						v.vat_energy_stat = round(eng*v.vat_energy,0.1)
					if(t == "strength")
						var/str = v.vat_strength_stat/v.vat_strength
						if(n == "+")
							if(v.vat_strength < usr.gene_limit_strength || v.vat_strength < v.vat_strength_mod_base)
								v.points -= 1;
								v.points_assigned += 1;
								v.vat_strength+= 0.1
								usr << output("Old cost = [v.cost]", "chat.system")
								v.cost += c
								usr << output("New cost = [v.cost]", "chat.system")
						if(n == "-")
							if(v.vat_strength > 0.1)
								v.points += 1;
								v.points_assigned -= 1;
								v.vat_strength -= 0.1
								v.cost -= c
						v.vat_strength = round(v.vat_strength,0.1)
						v.vat_strength_stat = round(str*v.vat_strength,0.1)
					if(t == "endurance")
						var/end = round(v.vat_endurance_stat/v.vat_endurance,0.1)
						if(n == "+")
							if(v.vat_endurance < usr.gene_limit_endurance || v.vat_endurance < v.vat_endurance_mod_base)
								v.points -= 1;
								v.points_assigned += 1;
								v.vat_endurance += 0.1
								usr << output("Old cost = [v.cost]", "chat.system")
								v.cost += c
								usr << output("New cost = [v.cost]", "chat.system")
								usr << output("Test = [v.cost - c]", "chat.system")
						if(n == "-")
							if(v.vat_endurance > 0.1)
								v.points += 1;
								v.points_assigned -= 1;
								v.vat_endurance -= 0.1
								v.cost -= c
						v.vat_endurance = round(v.vat_endurance,0.1)
						v.vat_endurance_stat = round(end*v.vat_endurance,0.1)
					if(t == "agility")
						if(n == "+")
							if(v.vat_agility < usr.gene_limit_agility || v.vat_agility < v.vat_agility_mod_base)
								v.points -= 1;
								v.points_assigned += 1;
								v.vat_agility += 0.1
								v.cost += c
						if(n == "-")
							if(v.vat_agility > 0.1)
								v.points += 1;
								v.points_assigned -= 1;
								v.vat_agility -= 0.1
								v.cost -= c
					if(t == "force")
						var/foc = v.vat_force_stat/v.vat_force
						if(n == "+")
							if(v.vat_force < usr.gene_limit_force || v.vat_force < v.vat_force_mod_base)
								v.points -= 1;
								v.points_assigned += 1;
								v.vat_force += 0.1
								v.cost += c
						if(n == "-")
							if(v.vat_force > 0.1)
								v.points += 1;
								v.points_assigned -= 1;
								v.vat_force -= 0.1
								v.cost -= c
						v.vat_force = round(v.vat_force,0.1)
						v.vat_force_stat = round(foc*v.vat_force,0.1)
					if(t == "resistance")
						var/res = v.vat_resistance_stat/v.vat_resistance
						if(n == "+")
							if(v.vat_resistance < usr.gene_limit_resistance || v.vat_resistance < v.vat_resistance_mod_base)
								v.points -= 1;
								v.points_assigned += 1;
								v.vat_resistance += 0.1
								v.cost += c
						if(n == "-")
							if(v.vat_resistance > 0.1)
								v.points += 1;
								v.points_assigned -= 1;
								v.vat_resistance -= 0.1
								v.cost -= c
						v.vat_resistance = round(v.vat_resistance,0.1)
						v.vat_resistance_stat = res*v.vat_resistance
					if(t == "offence")
						var/off = v.vat_offence_stat/v.vat_offence
						if(n == "+")
							if(v.vat_offence < usr.gene_limit_offence || v.vat_offence < v.vat_offence_mod_base)
								v.points -= 1;
								v.points_assigned += 1;
								v.vat_offence += 0.1
								v.cost += (c/2)
						if(n == "-")
							if(v.vat_offence > 0.1)
								v.points += 1;
								v.points_assigned -= 1;
								v.vat_offence -= 0.1
								v.cost -= (c/2)
						v.vat_offence = round(v.vat_offence,0.1)
						v.vat_offence_stat = round(off*v.vat_offence,0.1)
					if(t == "defence")
						var/def = v.vat_defence_stat/v.vat_defence
						if(n == "+")
							if(v.vat_defence < usr.gene_limit_defence || v.vat_defence < v.vat_defence_mod_base)
								v.points -= 1;
								v.points_assigned += 1;
								v.vat_defence += 0.1
								v.cost += (c/2)
						if(n == "-")
							if(v.vat_defence > 0.1)
								v.points += 1;
								v.points_assigned -= 1;
								v.vat_defence -= 0.1
								v.cost -= (c/2)
						v.vat_defence = round(v.vat_defence,0.1)
						v.vat_defence_stat = round(def*v.vat_defence,0.1)
					if(t == "regen")
						if(n == "+")
							if(v.vat_regeneration < usr.gene_limit_regen || v.vat_regeneration < v.vat_regeneration_mod_base)
								v.points -= 1;
								v.points_assigned += 1;
								v.vat_regeneration += 0.1
								v.cost += (c/2)
						if(n == "-")
							if(v.vat_regeneration > 0.1)
								v.points += 1;
								v.points_assigned -= 1;
								v.vat_regeneration -= 0.1
								v.cost -= (c/2)
						v.vat_regeneration = round(v.vat_regeneration,0.1)
					if(t == "recovery")
						if(n == "+")
							if(v.vat_recovery < usr.gene_limit_recov || v.vat_recovery < v.vat_recovery_mod_base)
								v.points -= 1;
								v.points_assigned += 1;
								v.vat_recovery += 0.1
								v.cost += c
						if(n == "-")
							if(v.vat_recovery > 0.1)
								v.points += 1;
								v.points_assigned -= 1;
								v.vat_recovery -= 0.1
								v.cost -= c
						v.vat_recovery = round(v.vat_recovery,0.1)
					if(v.cost < 0) v.lowest = v.cost
					if(v.cost > 0) v.lowest = 0
		terminate_clone()
			set name = ".terminate_clone"
			set hidden = 1
			if(usr.tech_using)
				if(get_dist(usr,usr.tech_using) > 2)
					return
				else
					if(istype(usr.tech_using,/obj/items/tech/Vat))
						//Kills the current clone then switches options back to a basic clone.
						var/obj/items/tech/Vat/v = usr.tech_using
						if(v.in_use)
							v.clone_die(usr)

							/*
							var/mob/m = v.in_use;
							animate(m,transform = matrix()*0.1,time = 10)
							if(m.id in usr.clones) usr.clones -= m.id
							winset(usr,"genetics.button_grow","is-disabled=false")
							winset(usr,"genetics.button_terminate","is-disabled=true")
							winset(usr,"genetics.button_clone","is-disabled=false")
							winset(usr,"genetics.button_new","is-disabled=false")
							winset(usr,"genetics.button_reset","is-disabled=false")
							winset(usr,"genetics.button_power","is-disabled=true")
							v.growth_percent = 0;
							winset(usr,"genetics.growth_percent","text=\"Growth Percent: 0%\"")
							winset(usr,"genetics.growth","value=0")
							v.in_use = null;
							v.set_for = null;
							v.set_vat_stats(0,usr)
							v.generator = 0;
							v.generates = 0;
							winset(usr,"genetics.power_generated","text=\"Power Generated: 0\"")
							winset(usr,"genetics.button_new","is-checked=false")
							winset(usr,"genetics.button_clone","is-checked=true")
							usr.adjust_buttons_genetics(0,0,0)
							usr.clone_stats(v)
							usr.show_info_vat(v)
							spawn(10)
								if(m) del(m)
							*/
		reset_clone()
			set name = ".reset_clone"
			set hidden = 1
			if(usr.tech_using)
				if(get_dist(usr,usr.tech_using) > 2)
					return
				else
					if(istype(usr.tech_using,/obj/items/tech/Vat))
						var/obj/items/tech/Vat/v = usr.tech_using
						if(v.in_use == null)
							winset(usr,"genetics.button_grow","is-disabled=false")
							winset(usr,"genetics.button_terminate","is-disabled=true")
							winset(usr,"genetics.button_clone","is-disabled=false")
							winset(usr,"genetics.button_new","is-disabled=false")
							winset(usr,"genetics.growth_percent","text=\"Growth Percent: 0%\"")
							winset(usr,"genetics.growth","value=0")
							v.clone_type = "Clone"
							v.set_vat_stats(0,usr)
							winset(usr,"genetics.button_new","is-checked=false")
							winset(usr,"genetics.button_clone","is-checked=true")
							usr.show_info_vat(v)
		grow_clone()
			set name = ".grow_clone"
			set hidden = 1
			usr.grow_clones()
mob/proc/grow_clones()
	if(src.tech_using)
		if(get_dist(src,src.tech_using) > 2)
			return
		else
			if(istype(src.tech_using,/obj/items/tech/Vat))
				var/obj/items/tech/Vat/v = src.tech_using
				if(v.in_use == null)
					var/mob/m = new
					m.density = 0
					m.density_factor = 0
					m.Move(v.loc)
					m.pixel_x = src.pixel_x;
					m.pixel_y = src.pixel_y;
					m.bounds = src.bounds
					m.step_x = v.step_x
					m.step_y = v.step_y+22
					m.layer = v.layer - 20;
					m.transform = matrix()*0.1
					m.being_grown = 1;
					m.stunned += 1;
					m.stunned_pending += 1
					v.set_for = m.id;
					v.in_use = m;
					m.vat = v;
					spawn(100)
						if(m) m.being_grown = 0;
					m.copy_mob_genetics(src,1,1,1,1)
					if(m.icon == null) m.icon = src.icon
					m.icon_state = "Meditate"
					animate(m,transform = matrix()*1,time = 100)
					spawn(rand(1,10))
						if(m)
							animate(m,pixel_y = 1,time = 10, loop = -1,flags = ANIMATION_PARALLEL)
							animate(pixel_y = 0,time = 10)
					src.clones += m.id

					//world << output("Debug - Set cloning machine for [m].", "chat.system")

					winset(src,"genetics.button_grow","is-disabled=true")
					winset(src,"genetics.button_terminate","is-disabled=false")
					winset(src,"genetics.button_clone","is-disabled=true")
					winset(src,"genetics.button_new","is-disabled=true")
					winset(src,"genetics.button_reset","is-disabled=true")

					v.vat_grow(100)
					//v.set_vat_stats(0,m) //Imprint the players stats and mods onto the Vat
					m.copy_vat(v,1,1) //Make the bio creation copy the stats and mods of the Vat
					src.give_extra_organs(v,m)
mob/proc/copy_mob_genetics(var/mob/og,var/copy_mods = 0,var/copy_stats = 0,var/copy_parts = 0,var/copy_skills = 0,var/copy_type = "default")
	og.disable_skills()
	src.disable_skills()
	if(copy_type == "reincarnation")
		if(copy_mods)
			src.mod_psionic_power = (og.mod_psionic_power *0.25)
			src.mod_energy = (og.mod_energy*0.25)
			src.mod_strength = (og.mod_strength*0.25)
			src.mod_agility = (og.mod_agility*0.25)
			src.mod_endurance = (og.mod_endurance*0.25)
			src.mod_force = (og.mod_force*0.25)
			src.mod_resistance = og.mod_resistance*0.25
			src.mod_offence = og.mod_offence*0.25
			src.mod_defence = og.mod_defence*0.25
			src.mod_regeneration = og.mod_regeneration*0.25
			src.mod_recovery = og.mod_recovery*0.25
			src.mod_sense = og.mod_sense
			src.mod_tech_potential = (og.mod_tech_potential *0.50)
			src.mod_immune_rads = (og.mod_immune_rads*0.50)
			src.mod_immune_cold = (og.mod_immune_cold*0.50)
			src.mod_immune_heat = (og.mod_immune_heat*0.50)
			src.mod_immune_gravity = (og.mod_immune_gravity*0.25)

		if(copy_stats) //Re-calculate the stats, which basically adds the stats of the old mob to the new, but bases the values off the new mobs mods.
			src.energy_max = ((og.energy_max/og.mod_energy)*src.mod_energy*0.25)
			src.energy = og.energy_max



		if(copy_parts)
			//Clear original bodyparts.
			for(var/obj/b in src.bodyparts)
				for(var/obj/p in b)
					del(p)
				del(b)

			src.bodyparts = list()

			for(var/obj/body_related/bodyparts/b in og.bodyparts)
				var/obj/body_related/bodyparts/new_b = new b.type(null)

				src.bodyparts += new_b

				new_b.needed_lvl = b.needed_lvl
				new_b.part_multi = b.part_multi
				new_b.part_exp = b.part_exp
				new_b.can_unlock = b.can_unlock
				new_b.level = round((b.level *0.25))
				new_b.part_exp_num = b.part_exp_num
				new_b.infused_divine = b.infused_divine
				for(var/obj/body_related/bodyparts/p in b)
					var/obj/body_related/bodyparts/new_p = new p.type(null)

					new_p.needed_lvl = p.needed_lvl
					new_p.part_multi = p.part_multi
					new_p.part_exp = p.part_exp
					new_p.can_unlock = p.can_unlock
					new_p.level = round((p.level*0.25))
					new_p.part_exp_num = p.part_exp_num
					new_p.infused_divine = p.infused_divine

		src.strength_base = (og.strength*0.25)
		src.endurance_base = (og.endurance*0.25)
		src.force_base = (og.force*0.25)
		src.resistance_base = (og.resistance*0.25)
		src.offence_base = (og.offence*0.25)
		src.defence_base = (og.defence*0.25)

	if(copy_type == "copy clone")
		//Copy the stats of the player and devide them by the mod to get their true values.
		var/eng = src.energy_max/src.mod_energy
		var/str = src.strength/src.mod_strength
		var/end = src.endurance/src.mod_endurance
		var/res = src.resistance/src.mod_resistance
		var/foc = src.force/src.mod_force
		var/off = src.offence/src.mod_offence
		var/def = src.defence/src.mod_defence

		//Copy the stats of the clone and devide them by the mod to get their true values.
		var/eng_c = og.energy_max/og.mod_energy
		var/str_c = og.strength/og.mod_strength
		var/end_c = og.endurance/og.mod_endurance
		var/res_c = og.resistance/og.mod_resistance
		var/foc_c = og.force/og.mod_force
		var/off_c = og.offence/og.mod_offence
		var/def_c = og.defence/og.mod_defence

		//Compare the stats of the player vs their clone. If the clone has higher stats, apply them to the player.
		if(eng_c > eng) eng = eng_c
		if(str_c > str) str = str_c
		if(end_c > end) end = end_c
		if(res_c > res) res = res_c
		if(foc_c > foc) foc = foc_c
		if(off_c > off) off = off_c
		if(def_c > def) def = def_c


		//Copy the clones mods.
		src.mod_psionic_power = og.mod_psionic_power
		src.mod_energy = og.mod_energy
		src.mod_strength = og.mod_strength
		src.mod_agility = og.mod_agility
		src.mod_endurance = og.mod_endurance
		src.mod_force = og.mod_force
		src.mod_resistance = og.mod_resistance
		src.mod_offence = og.mod_offence
		src.mod_defence = og.mod_defence
		src.mod_regeneration = og.mod_regeneration
		src.mod_recovery = og.mod_recovery
		src.mod_sense = og.mod_sense
		src.mod_tech_potential = og.mod_tech_potential
		src.mod_immune_rads = og.mod_immune_rads
		src.mod_immune_cold = og.mod_immune_cold
		src.mod_immune_heat = og.mod_immune_heat
		src.mod_immune_gravity = og.mod_immune_gravity

		//Copy the clones misc stats
		src.icon = og.icon
		src.icon_original = src.icon
		src.gen = og.gen
		src.race = og.race
		src.hair_pos = og.hair_pos
		src.ear_pos = og.ear_pos
		src.has_hair = og.has_hair
		src.skin_pos = og.skin_pos
		src.hair = og.hair
		src.overlays = null
		src.overlays += src.hair

		//Now that we have the clones mods, calculate our previous stats and apply them to the new mods.
		src.strength = str*src.mod_strength
		src.endurance = end*src.mod_endurance
		src.force = foc*src.mod_force
		src.resistance = res*src.mod_resistance
		src.offence = off*src.mod_offence
		src.defence = def*src.mod_defence
		src.vigour = og.vigour
		src.energy_max = eng*src.mod_energy
		src.energy = src.energy_max

		//After we finish giving the correct stats, apply the correct base stats. This is so when the player trains their new stats, they have the correct difficulty scaling on that stat.
		src.strength_base = src.strength
		src.endurance_base = src.endurance
		src.force_base = src.force
		src.resistance_base = src.resistance
		src.offence_base = src.offence
		src.defence_base = src.defence
	if(copy_type == "default")

		//Disabled for now, pretty sure this resets stats to 0
		/*
		if(og.race == "Human") src.Human()
		if(og.race == "Demon") src.Demon()
		if(og.race == "Celestial") src.Celestial()
		if(og.race == "Imp") src.Imp()
		*/
		var/obj/items/tech/Vat/clone_tank = null
		if(og.tech_using)
			if(istype(og.tech_using,/obj/items/tech/Vat))
				clone_tank = og.tech_using

		if(clone_tank)
			src.icon = clone_tank.vat_clone_icon
			src.gen = clone_tank.vat_gen
			src.race = clone_tank.vat_race
			src.has_hair = clone_tank.vat_has_hair
			src.hair_pos = clone_tank.vat_hair
			src.hair_c = clone_tank.vat_hair_c
			src.ear_pos = clone_tank.vat_ear
			src.skin_pos = clone_tank.vat_skin
			if(src.gen == "Male") src.hair = hairs_male[src.hair_pos]
			if(src.gen == "Female") src.hair = hairs_female[src.hair_pos]

			//var/icon/E_hair = icon(src.hair)
			//E_hair.Blend(src.hair_c)

			if(src.race == "Demon")
				var/icon/C_overlay = icon('demon_default_male.dmi')
				C_overlay.Blend(src.hair_c)
				src.overlays += C_overlay
			if(src.hair)
				var/icon/E_hair = icon(src.hair.icon)
				if(src.hair_c)
					E_hair.Blend(src.hair_c)
				src.hair.icon = E_hair

			src.overlays += src.hair
		else
			src.icon = og.icon
			src.gen = og.gen
			src.race = og.race
			src.has_hair = og.has_hair
			src.hair_pos = og.hair_pos
			src.ear_pos = og.ear_pos
			src.skin_pos = og.skin_pos
			src.overlays = og.overlays
			src.hair_c = og.hair_c
			src.hair = og.hair

		if(copy_mods)
			src.mod_psionic_power = og.mod_psionic_power
			src.mod_energy = og.mod_energy
			src.mod_strength = og.mod_strength
			src.mod_agility = og.mod_agility
			src.mod_endurance = og.mod_endurance
			src.mod_force = og.mod_force
			src.mod_resistance = og.mod_resistance
			src.mod_offence = og.mod_offence
			src.mod_defence = og.mod_defence
			src.mod_regeneration = og.mod_regeneration
			src.mod_recovery = og.mod_recovery
			src.mod_sense = og.mod_sense
			src.mod_tech_potential = og.mod_tech_potential
			src.mod_immune_rads = og.mod_immune_rads
			src.mod_immune_cold = og.mod_immune_cold
			src.mod_immune_heat = og.mod_immune_heat
			src.mod_immune_gravity = og.mod_immune_gravity

		if(copy_stats) //Re-calculate the stats, which basically adds the stats of the old mob to the new, but bases the values off the new mobs mods.
			src.strength = (og.strength/og.mod_strength)*src.mod_strength
			src.endurance = (og.endurance/og.mod_endurance)*src.mod_endurance
			src.force = (og.force/og.mod_force)*src.mod_force
			src.resistance = (og.resistance/og.mod_resistance)*src.mod_resistance
			src.offence = (og.offence/og.mod_offence)*src.mod_offence
			src.defence = (og.defence/og.mod_defence)*src.mod_defence
			src.vigour = og.vigour
			src.energy_max = (og.energy_max/og.mod_energy)*src.mod_energy
			src.energy = og.energy_max

		if(copy_skills)
			for(var/obj/skills/s in og)
				new s.type(src)

			for(var/obj/stances/s in og)
				new s.type(src)

		if(copy_parts)
			//Clear original bodyparts.
			for(var/obj/b in src.bodyparts)
				for(var/obj/p in b)
					del(p)
				del(b)

			src.bodyparts = list()

			for(var/obj/body_related/bodyparts/b in og.bodyparts)
				var/obj/body_related/bodyparts/new_b = new b.type(null)

				src.bodyparts += new_b

				new_b.needed_lvl = b.needed_lvl
				new_b.part_multi = b.part_multi
				new_b.part_exp = b.part_exp
				new_b.can_unlock = b.can_unlock
				new_b.level = b.level
				new_b.part_exp_num = b.part_exp_num
				new_b.infused_divine = b.infused_divine
				for(var/obj/body_related/bodyparts/p in b)
					var/obj/body_related/bodyparts/new_p = new p.type(null)

					new_p.needed_lvl = p.needed_lvl
					new_p.part_multi = p.part_multi
					new_p.part_exp = p.part_exp
					new_p.can_unlock = p.can_unlock
					new_p.level = p.level
					new_p.part_exp_num = p.part_exp_num
					new_p.infused_divine = p.infused_divine
mob/proc/give_divine_seed(var/levels = 1)
	for(var/obj/body_related/bodyparts/torso/t in src.bodyparts)
		var/obj/body_related/bodyparts/torso/heart/o = new(t)
		o.name = "Divine Seed"
		o.info_name = "Divine Seed"
		o.recov_mod_gain = 0
		o.level = levels

		src.gains_psiforged_resistance += o.res_gain_base*levels
		src.gains_psiforged_force += o.force_gain_base*levels
		src.divine_energy += o.divine_eng_gain_base*levels
		src.energy = src.energy_max
		src.lifespan += o.lifespan_gain*levels

	src.extra_lobe = 1
	//world << "Debug - Test spawned 3rd lobe?"
mob/proc/give_extra_lobe(var/levels = 1)
	for(var/obj/body_related/bodyparts/head/h in src.bodyparts)
		var/obj/body_related/bodyparts/head/brain/o = new(h)
		o.psi_gain_base = 0.5
		o.eng_gain_base = 2.5
		o.res_gain_base = 0.5
		o.force_gain_base = 1
		o.lifespan_gain = 0.1
		o.divine_eng_gain_base = 0.5
		o.name = "Extra Lobe"
		o.info_name = "Extra Lobe"
		o.level = levels

		src.gains_psiforged_resistance += o.res_gain_base*levels
		src.gains_psiforged_force += o.force_gain_base*levels
		src.divine_energy += o.divine_eng_gain_base*levels
		src.energy = src.energy_max
		src.lifespan += o.lifespan_gain*levels
		src.total_organs += 1

	src.extra_lobe = 1
	//world << "Debug - Test spawned 3rd lobe?"
mob/proc/give_horns()
	for(var/obj/body_related/bodyparts/head/h in src.bodyparts)
		var/obj/body_related/bodyparts/head/skull/o = new(h)
		o.psi_gain_base = 1
		o.off_gain_base = 1
		o.name = "Horns"
		o.info_name = "Horns"

	//src.extra_lobe = 1
	//world << "Debug - Test spawned 3rd lobe?"
mob/proc/give_extra_organs(var/obj/items/tech/Vat/v,var/mob/clone)
	//Heart
	var/give_heart = 0;
	if(src.extra_heart && clone.extra_heart == 0) give_heart = 1 //For when the player becomes the clone
	if(v && v.vat_extra_heart && clone.extra_heart == 0) give_heart = 1
	if(give_heart)
		for(var/obj/body_related/bodyparts/torso/t in clone.bodyparts)
			var/obj/body_related/bodyparts/torso/heart/o = new(t)
			o.name = o.info_name
		clone.extra_heart = 1;
		//world << output("Successfully gave [clone] an extra heart", "chat.system")
	//Extra Lobe
	var/give_lobe = 0;
	if(src.extra_lobe && clone.extra_lobe == 0) give_lobe = 1 //For when the player becomes the clone
	if(v && v.vat_extra_lobe && clone.extra_lobe == 0) give_lobe = 1
	if(give_lobe)
		for(var/obj/body_related/bodyparts/head/h in clone.bodyparts)
			var/obj/body_related/bodyparts/head/brain/o = new(h)
			o.psi_gain_base = 0.5
			o.eng_gain_base = 2.5
			o.res_gain_base = 0.5
			o.force_gain_base = 1
			o.lifespan_gain = 0.1
			o.divine_eng_gain_base = 0.5
			o.name = "Extra Lobe"
		clone.extra_lobe = 1;
		//world << output("Successfully gave [clone] an extra lobe", "chat.system")
	//Liver
	var/give_liver = 0;
	if(src.extra_liver && clone.extra_liver == 0) give_liver = 1 //For when the player becomes the clone
	if(v && v.vat_extra_liver && clone.extra_liver == 0) give_liver = 1
	if(give_liver)
		for(var/obj/body_related/bodyparts/torso/t in clone.bodyparts)
			var/obj/body_related/bodyparts/torso/liver/o = new(t)
			o.name = o.info_name
		clone.extra_liver = 1;
		//world << output("Successfully gave [clone] an extra liver", "chat.system")
	//Lungs
	var/give_lungs = 0;
	if(src.extra_lungs && clone.extra_lungs == 0) give_lungs = 1 //For when the player becomes the clone
	if(v && v.vat_extra_lungs && clone.extra_lungs == 0) give_lungs = 1
	if(give_lungs)
		for(var/obj/body_related/bodyparts/torso/t in clone.bodyparts)
			var/obj/body_related/bodyparts/torso/lungs/o = new(t)
			o.name = o.info_name
		clone.extra_lungs = 1;
		//world << output("Successfully gave [clone] an extra lungs", "chat.system")
	//Hide
	var/give_hide = 0;
	if(src.extra_skin && clone.extra_skin == 0) give_hide = 1 //For when the player becomes the clone
	if(v && v.vat_extra_skin && clone.extra_skin == 0) give_hide = 1
	if(give_hide)
		clone.extra_skin = 1;
		//world << output("Successfully gave [clone] an enhanced skin", "chat.system")
	//Adrenal
	var/give_adrenal = 0;
	if(src.extra_adrenal && clone.extra_adrenal == 0) give_adrenal = 1 //For when the player becomes the clone
	if(v && v.vat_extra_adrenal && clone.extra_adrenal == 0) give_adrenal = 1
	if(give_adrenal)
		clone.extra_adrenal = 1;
		//world << output("Successfully gave [clone] an enhanced adrenal glands", "chat.system")
	//Spleen
	var/give_spleen = 0;
	if(src.extra_spleen && clone.extra_spleen == 0) give_spleen = 1 //For when the player becomes the clone
	if(v && v.vat_extra_spleen && clone.extra_spleen == 0) give_spleen = 1
	if(give_spleen)
		for(var/obj/body_related/bodyparts/torso/t in clone.bodyparts)
			var/obj/body_related/bodyparts/torso/spleen/o = new(t)
			o.name = o.info_name
		clone.extra_spleen = 1;
		//world << output("Successfully gave [clone] an extra spleen", "chat.system")
	//Extra Growth
	var/give_growth = 0;
	if(src.extra_growth && clone.extra_growth == 0) give_growth = 1 //For when the player becomes the clone
	if(v && v.vat_extra_growth && clone.extra_growth == 0) give_growth = 1
	if(give_growth)
		clone.extra_growth = 1;
		//world << output("Successfully gave [clone] an enhanced growth", "chat.system")
	//Extra Regen
	var/give_regen = 0;
	if(src.extra_regen && clone.extra_regen == 0) give_regen = 1 //For when the player becomes the clone
	if(v && v.vat_extra_regen && clone.extra_regen == 0) give_regen = 1
	if(give_regen)
		clone.extra_regen = 1;
		//world << output("Successfully gave [clone] an enhanced regen", "chat.system")
mob/proc/copy_vat(var/obj/items/tech/Vat/v,var/copy_mods,var/copy_stats)
	src.disable_skills()
	if(copy_mods)
		src.mod_psionic_power = v.vat_psi
		src.mod_energy = v.vat_energy
		src.mod_strength = v.vat_strength
		src.mod_agility = v.vat_agility
		src.mod_endurance = v.vat_endurance
		src.mod_force = v.vat_force
		src.mod_resistance = v.vat_resistance
		src.mod_offence = v.vat_offence
		src.mod_defence = v.vat_defence
		src.mod_regeneration = v.vat_regeneration
		src.mod_recovery = v.vat_recovery

	if(copy_stats) //Re-calculate the stats, which basically adds the stats of the old mob to the new, but bases the values off the new mobs mods.
		src.strength = v.vat_strength_stat
		src.endurance = v.vat_endurance_stat
		src.force = v.vat_force_stat
		src.resistance = v.vat_resistance_stat
		src.offence = v.vat_offence_stat
		src.defence = v.vat_defence_stat
		src.energy_max = v.vat_energy_stat
		src.energy = src.energy_max

	/*
	if(copy_parts)
		src.extra_heart = v.vat_extra_heart
		src.extra_kidneys = v.vat_extra_kidneys
		src.extra_lungs = v.vat_extra_lungs
		src.extra_adrenal = v.vat_extra_adrenal
		src.extra_growth = v.vat_extra_growth
		src.extra_regen = v.vat_extra_regen
		src.extra_lobe = v.vat_extra_lobe
		src.extra_spleen = v.vat_extra_spleen
		src.extra_liver = v.vat_extra_liver
		src.extra_skin = v.vat_extra_skin
	*/

	src << output("[src]'s psi is [src.psionic_power]([src.mod_psionic_power])", "chat.system")
	src << output("[src]'s energy is [src.energy_max]([src.mod_energy])", "chat.system")
	src << output("[src]'s strength is [src.strength]([src.mod_strength])", "chat.system")
	src << output("[src]'s endurance is [src.endurance]([src.mod_endurance])", "chat.system")
	src << output("[src]'s agility is [src.mod_agility]", "chat.system")
	src << output("[src]'s force is [src.force]([src.mod_force])", "chat.system")
	src << output("[src]'s resistance is [src.resistance]([src.mod_resistance])", "chat.system")
	src << output("[src]'s offence is [src.offence]([src.mod_offence])", "chat.system")
	src << output("[src]'s defence is [src.defence]([src.mod_defence])", "chat.system")
	src << output("[src]'s regen is [src.mod_regeneration]", "chat.system")
	src << output("[src]'s recovery is [src.mod_recovery]", "chat.system")
obj/proc/set_vat_stats(var/reset = 0,var/mob/m)
	var/obj/items/tech/Vat/v = src
	if(reset == 0)
		m.disable_skills()

		v.vat_psi = m.mod_psionic_power
		v.vat_energy = m.mod_energy
		v.vat_strength = m.mod_strength
		v.vat_endurance = m.mod_endurance
		v.vat_agility = m.mod_agility
		v.vat_force = m.mod_force
		v.vat_resistance = m.mod_resistance
		v.vat_offence= m.mod_offence
		v.vat_defence = m.mod_defence
		v.vat_regeneration = m.mod_regeneration
		v.vat_recovery = m.mod_recovery

		v.vat_psi_mod_base = m.mod_psionic_power
		v.vat_energy_mod_base = m.mod_energy
		v.vat_strength_mod_base = m.mod_strength
		v.vat_endurance_mod_base = m.mod_endurance
		v.vat_agility_mod_base = m.mod_agility
		v.vat_force_mod_base = m.mod_force
		v.vat_resistance_mod_base = m.mod_resistance
		v.vat_offence_mod_base = m.mod_offence
		v.vat_defence_mod_base = m.mod_defence
		v.vat_regeneration_mod_base = m.mod_regeneration
		v.vat_recovery_mod_base = m.mod_recovery

		v.vat_psi_stat = m.psionic_power
		v.vat_energy_stat = m.energy_max
		v.vat_strength_stat = m.strength
		v.vat_endurance_stat = m.endurance
		v.vat_force_stat = m.force
		v.vat_resistance_stat = m.resistance
		v.vat_offence_stat = m.offence
		v.vat_defence_stat = m.defence

		v.vat_psi_base = m.psionic_power
		v.vat_energy_base = m.energy_max
		v.vat_strength_base = m.strength
		v.vat_endurance_base = m.endurance
		v.vat_force_base = m.force
		v.vat_resistance_base = m.resistance
		v.vat_offence_base = m.offence
		v.vat_defence_base = m.defence

		v.vat_extra_heart = m.extra_heart
		v.vat_extra_kidneys = m.extra_kidneys
		v.vat_extra_lungs = m.extra_lungs
		v.vat_extra_adrenal = m.extra_adrenal
		v.vat_extra_growth = m.extra_growth
		v.vat_extra_regen = m.extra_regen
		v.vat_extra_lobe = m.extra_lobe
		v.vat_extra_spleen = m.extra_spleen
		v.vat_extra_liver = m.extra_liver
		v.vat_extra_skin = m.extra_skin

		v.vat_clone_icon = m.icon
		v.vat_race = m.race
		v.vat_hair = m.hair_pos
		v.vat_hair_c = m.hair_c
		v.vat_has_hair = m.has_hair
		v.vat_ear = m.ear_pos
		v.vat_gen = m.gen
		v.vat_skin = m.skin_pos

		v.vat_total_stats = (v.vat_psi_stat/v.vat_psi)+(v.vat_energy_stat/v.vat_energy)+(v.vat_strength_stat/v.vat_strength)+(v.vat_endurance_stat/v.vat_endurance)+(v.vat_force_stat/v.vat_force)+(v.vat_resistance_stat/v.vat_resistance)+(v.vat_offence_stat/v.vat_offence)+(v.vat_defence_stat/v.vat_defence)
	else
		v.vat_psi = 1;
		v.vat_energy = 1
		v.vat_strength = 1
		v.vat_endurance = 1
		v.vat_agility = 1
		v.vat_force = 1
		v.vat_resistance = 1
		v.vat_offence= 1
		v.vat_defence = 1
		v.vat_regeneration = 1
		v.vat_recovery = 1

		v.vat_psi_mod_base = 1;
		v.vat_energy_mod_base = 1
		v.vat_strength_mod_base = 1
		v.vat_endurance_mod_base = 1
		v.vat_agility_mod_base = 1
		v.vat_force_mod_base = 1
		v.vat_resistance_mod_base = 1
		v.vat_offence_mod_base = 1
		v.vat_defence_mod_base = 1
		v.vat_regeneration_mod_base = 1
		v.vat_recovery_mod_base = 1

		v.vat_extra_heart = 0;
		v.vat_extra_kidneys = 0;
		v.vat_extra_lungs = 0;
		v.vat_extra_adrenal = 0;
		v.vat_extra_growth = 0;
		v.vat_extra_regen = 0;
		v.vat_extra_lobe = 0;
		v.vat_extra_spleen = 0;
		v.vat_extra_liver = 0;
		v.vat_extra_skin = 0;

		v.vat_clone_icon = null
		v.vat_race = null
		v.vat_hair = 0
		v.vat_hair_c = null
		v.vat_has_hair = 0
		v.vat_ear = 0
		v.vat_gen = null
		v.vat_skin = 0

	v.cost = 0;
	v.points = m.gene_points;
	v.points_assigned = 0;
	v.round_mods()
mob/proc/show_info_vat(var/obj/items/tech/Vat/v = null)
	var/txt = "Active Bodyparts"
	var/clone = 0;
	if(winget(src,"genetics.button_clone","is-checked") == "true") clone = 1;
	if(v.vat_extra_heart || src.extra_heart && clone)
		txt = "[txt] \n\n Extra Heart"

	if(v.vat_extra_lungs || src.extra_lungs && clone)
		txt = "[txt] \n\n Extra Lungs"

	if(v.vat_extra_liver || src.extra_liver && clone)
		txt = "[txt] \n\n Extra Liver"

	if(v.vat_extra_spleen || src.extra_spleen && clone)
		txt = "[txt] \n\n Extra Spleen"

	if(v.vat_extra_lobe || src.extra_lobe && clone)
		txt = "[txt] \n\n Third Lobe"

	if(v.vat_extra_adrenal || src.extra_adrenal && clone)
		txt = "[txt] \n\n Enhanced Adrenal Glands"

	if(v.vat_extra_regen || src.extra_regen && clone)
		txt = "[txt] \n\n Enhanced Regeneration"

	if(v.vat_extra_skin || src.extra_skin && clone)
		txt = "[txt] \n\n Thicker Hide"

	if(v.vat_extra_growth || src.extra_growth && clone)
		txt = "[txt] \n\n Enhanced Growth"

	winset(src,"genetics.label_parts","text=\"[txt]\"")

obj/proc/clone_die(var/mob/scientist)
	var/obj/items/tech/Vat/v = src
	var/mob/m = v.in_use;
	animate(m,transform = matrix()*0.1,time = 10)
	if(scientist)
		if(m.id in scientist.clones) scientist.clones -= m.id
	if(scientist)
		winset(scientist,"genetics.button_grow","is-disabled=false")
		winset(scientist,"genetics.button_terminate","is-disabled=true")
		winset(scientist,"genetics.button_clone","is-disabled=false")
		winset(scientist,"genetics.button_new","is-disabled=false")
		winset(scientist,"genetics.button_reset","is-disabled=false")
		winset(scientist,"genetics.button_power","is-disabled=true")
	v.growth_percent = 0;
	if(scientist)
		winset(scientist,"genetics.growth_percent","text=\"Growth Percent: 0%\"")
		winset(scientist,"genetics.growth","value=0")
	v.in_use = null;
	v.set_for = null;
	if(scientist) v.set_vat_stats(0,scientist)
	v.generator = 0;
	v.generates = 0;
	if(scientist)
		winset(scientist,"genetics.power_generated","text=\"Power Generated: 0\"")
		winset(scientist,"genetics.button_new","is-checked=false")
		winset(scientist,"genetics.button_clone","is-checked=true")
		scientist.show_info_vat(v)
	spawn(10)
		if(m) del(m)