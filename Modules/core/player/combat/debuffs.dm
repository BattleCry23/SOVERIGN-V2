/*
Create a list of debuffs that can be applied to mobs.

They should be in obj form and added or removed from the mob as needed.

Make an Enter() proc, so the debuff adjusts the mobs stats as needed. Then once a countdown has ended, remove the debuff, forcing the Exit() proc to be called.

Make an Exit() proc so when they are removed, they update the client screen and the mob stats as needed.

Make the debuff a HUD obj for the client screen and add or remove it as needed.

Make it so it displays how long the debuff or buff has left, like in WoW, with the number underneath it.

Make it so mousing over the debuff or buff gives you info about it.

Make it so some debuffs or buffs are just indications of something happening, like being too cold, hot, ect.

*/
mob
	var
		obj/debuff_underwater
		obj/debuff_hot
		obj/debuff_cold
		obj/debuff_gravity
		obj/debuff_microwaves
		obj/debuff_radiation
		obj/debuff_dead
		obj/debuff_weights
		obj/debuff_age
		obj/debuff_immortal
		obj/debuff_exalted
		obj/debuff_baleful
		obj/debuff_hunger
		obj/debuff_thirst
		obj/debuff_tired

		obj/buff_power
		obj/buff_energy
		obj/buff_divine
		obj/buff_dark_matter
		obj/buff_strength
		obj/buff_endurance
		obj/buff_majin
		obj/buff_mystic
		obj/buff_kaioken
		obj/buff_kaiosoku
		obj/buff_kaioenjin
		obj/buff_kaioryu
		obj/buff_resistance
		obj/buff_force
		obj/buff_offence
		obj/buff_defence
		obj/buffs_and_debuffs/buff_stance
		obj/buff_psionic_plane
		obj/buff_hunger
		obj/buff_thirst
		obj/buff_tired
		tmp/gaining_rating = -1;
		tmp/gaining_power = -1;
		tmp/gaining_energy = -1;
		tmp/gaining_divine = -1;
		tmp/gaining_dark_matter = -1;
		tmp/gaining_strength = -1;
		tmp/gaining_endurance = -1;
		tmp/gaining_resistance = -1;
		tmp/gaining_force = -1;
		tmp/gaining_offence = -1;
		tmp/gaining_defence = -1;
		tmp/blinding_light = -1;
		tmp/baleful_light = -1;

		in_gravity = 0;
		in_microwaves = 0;
		in_rads = 0;

	proc
		set_debuffs()
			src.debuff_underwater = new /:underwater
			src.debuff_hot = new /:hot
			src.debuff_cold = new /:cold
			src.debuff_gravity = new /:grav_debuff
			src.debuff_microwaves = new /:microwave_debuff
			src.debuff_radiation = new /:radiation
			src.debuff_dead = new /:dead
			//src.debuff_weights = new /:weights
			//src.debuff_age = new /:age_faster
			src.debuff_immortal = new /:immortal_drain
			src.debuff_exalted = new /:exalted_light
			src.debuff_baleful = new /:baleful_light
			src.debuff_hunger = new /:hungry
			src.debuff_thirst = new /:thirsty
			src.debuff_tired = new /:tired

			src.buff_power = new /:power_buff
			src.buff_energy = new /:energy_buff
			src.buff_divine = new /:divine_buff
			src.buff_dark_matter = new /:dark_matter_buff
			src.buff_strength = new /:strength_buff
			src.buff_majin = new /:majin_buff
			src.buff_mystic = new/:mystic_buff
			src.buff_kaioken = new/:kaioken_buff
			src.buff_kaiosoku = new/:kaiosoku_buff
			src.buff_kaioenjin = new/:kaioenjin_buff
			src.buff_kaioryu = new/:kaioryu_buff
			src.buff_endurance = new /:endurance_buff
			src.buff_resistance = new /:resistance_buff
			src.buff_force = new /:force_buff
			src.buff_offence = new /:offence_buff
			src.buff_defence = new /:defence_buff
			src.buff_stance = new /:stance_buff
			src.buff_psionic_plane = new /:psionic_plane_buff
			src.buff_hunger = new /:well_fed
			src.buff_thirst = new /:hydrated
			src.buff_tired = new /:well_rested

			src.buff_power.loc = src
			src.buff_energy.loc = src
			src.buff_divine.loc = src
			src.buff_majin.loc = src
			src.buff_mystic.loc = src
			src.buff_kaioken.loc = src
			src.buff_kaiosoku.loc = src
			src.buff_kaioenjin.loc = src
			src.buff_kaioryu.loc = src
			src.buff_dark_matter.loc = src
			src.buff_strength.loc = src
			src.buff_endurance.loc = src
			src.buff_resistance.loc = src
			src.buff_force.loc = src
			src.buff_offence.loc = src
			src.buff_defence.loc = src
			src.buff_stance.loc = src
			src.buff_psionic_plane.loc = src
			src.buff_hunger.loc = src
			src.buff_thirst.loc = src
			src.buff_tired.loc = src

			src.debuff_underwater.loc = src
			src.debuff_hot.loc = src
			src.debuff_cold.loc = src
			src.debuff_gravity.loc = src
			src.debuff_microwaves.loc = src
			src.debuff_radiation.loc = src
			src.debuff_dead.loc = src
			//src.debuff_weights.loc = src
		//	src.debuff_age.loc = src
			src.debuff_immortal.loc = src
			src.debuff_exalted.loc = src
			src.debuff_baleful.loc = src
			src.debuff_hunger.loc = src
			src.debuff_thirst.loc = src
			src.debuff_tired.loc = src

		debuffs()

			if(src.blinding_light < 0)
				src.debuff_exalted.active = 0;
				if(src.client) src.client.screen -= src.debuff_exalted
				src.blinding_light = 0;
			src.blinding_light -= 1;

			if(src.baleful_light < 0)
				src.debuff_baleful.active = 0;
				if(src.client) src.client.screen -= src.debuff_baleful
				src.baleful_light = 0;
			src.baleful_light -= 1;
			if(src.has_majin <=0)
				src.buff_majin.active = 0;
				if(src.client) src.client.screen -= src.buff_majin
			if(src.has_mystic <=0)
				src.buff_mystic.active = 0;
				if(src.client) src.client.screen -= src.buff_majin
			if(src.kaioken_pl <=1)
				src.buff_kaioken.active = 0;
				if(src.client) src.client.screen -= src.buff_kaioken
			if(src.kaiosoku_boost <=0)
				src.buff_kaiosoku.active = 0;
				if(src.client) src.client.screen -= src.buff_kaiosoku
			if(src.kaioenjin <=0)
				src.buff_kaioenjin.active = 0;
				if(src.client) src.client.screen -= src.buff_kaioenjin
			if(src.kaioryu <=0)
				src.buff_kaioryu.active = 0;
				if(src.client) src.client.screen -= src.buff_kaioryu

			if(src.dead)
				if(src.dead_ki_lock <= 0)
					src.dead_ki_lock = max(src.energy, 1)
				if(src.energy < src.dead_ki_lock)
					src.energy = src.dead_ki_lock
				if(!src.dead_skill_levels)
					src.dead_skill_levels = list()
				for(var/obj/skills/S in src)
					var/locked_lvl = src.dead_skill_levels[S]
					if(isnull(locked_lvl))
						src.dead_skill_levels[S] = S.skill_lvl
					else if(S.skill_lvl > locked_lvl)
						S.skill_lvl = locked_lvl
					if(S.skill_exp >= 100)
						S.skill_exp = 99
			if(src.gaining_rating < 0)

				src.gaining_rating = 0;


			if(src.gaining_power < 0)
				src.buff_power.active = 0;
				if(src.client) src.client.screen -= src.buff_power
				src.power_sources = list()
				src.gaining_power = 0;
			src.gaining_power -= 1;

			if(src.gaining_energy < 0)
				src.buff_energy.active = 0;
				if(src.client) src.client.screen -= src.buff_energy
				src.energy_sources = list()
				src.gaining_energy = 0;
			src.gaining_energy -= 1;

			if(src.gaining_divine < 0)
				src.buff_divine.active = 0;
				if(src.client) src.client.screen -= src.buff_divine
				src.divine_sources = list()
				src.gaining_divine = 0;
			src.gaining_divine -= 1;

			if(src.gaining_dark_matter < 0)
				src.buff_dark_matter.active = 0;
				if(src.client) src.client.screen -= src.buff_dark_matter
				src.dark_matter_sources = list()
				src.gaining_dark_matter = 0;
			src.gaining_dark_matter -= 1;


			if(src.gaining_strength < 0)
				src.buff_strength.active = 0;
				if(src.client) src.client.screen -= src.buff_strength
				src.strength_sources = list()
				src.gaining_strength = 0;
			src.gaining_strength -= 1;

			if(src.gaining_endurance < 0)
				src.buff_endurance.active = 0;
				if(src.client) src.client.screen -= src.buff_endurance
				src.endurance_sources = list()
				src.gaining_endurance = 0;
			src.gaining_endurance -= 1;

			if(src.gaining_resistance < 0)
				src.buff_resistance.active = 0;
				if(src.client) src.client.screen -= src.buff_resistance
				src.resistance_sources = list()
				src.gaining_resistance = 0;
			src.gaining_resistance -= 1;

			if(src.gaining_force < 0)
				src.buff_force.active = 0;
				if(src.client) src.client.screen -= src.buff_force
				src.force_sources = list()
				src.gaining_force = 0;
			src.gaining_force -= 1;

			if(src.gaining_offence < 0)
				src.buff_offence.active = 0;
				if(src.client) src.client.screen -= src.buff_offence
				src.offence_sources = list()
				src.gaining_offence = 0;
			src.gaining_offence -= 1;

			if(src.gaining_defence < 0)
				src.buff_defence.active = 0;
				if(src.client) src.client.screen -= src.buff_defence
				src.defence_sources = list()
				src.gaining_defence = 0;
			src.gaining_defence -= 1;


			if(src.stance == null)
				if(src.client) src.client.screen -= src.buff_stance
				src.buff_stance.active = 0;

			if(src.dead == 0)
				src.dead_ki_lock = 0
				src.dead_skill_levels = null
				if(src.debuff_dead && src.debuff_dead.active)
					src.debuff_dead.active = 0
					if(src.client) src.client.screen -= src.debuff_dead

			if(src.need_food == "Yes")
				if(src.hunger > 70 && src.buff_hunger.active == 0) call(src.buff_hunger.act)(src,src.buff_hunger)
				else if(src.hunger < 70 && src.buff_hunger.active)
					call(src.buff_hunger.act)(src,src.buff_hunger)
					if(src.client) src.client.screen -= src.buff_hunger
				if(src.hunger < 0 && src.debuff_hunger.active == 0) call(src.debuff_hunger.act)(src,src.debuff_hunger)
				else if(src.hunger > 0 && src.debuff_hunger.active)
					call(src.debuff_hunger.act)(src,src.debuff_hunger)
					if(src.client) src.client.screen -= src.debuff_hunger
			if(src.need_water == "Yes")
				if(src.thirst > 70 && src.buff_thirst.active == 0) call(src.buff_thirst.act)(src,src.buff_thirst)
				else if(src.thirst < 70 && src.buff_thirst.active)
					call(src.buff_thirst.act)(src,src.buff_thirst)
					if(src.client) src.client.screen -= src.buff_thirst
				if(src.thirst < 0 && src.debuff_thirst.active == 0) call(src.debuff_thirst.act)(src,src.debuff_thirst)
				else if(src.thirst > 0 && src.debuff_thirst.active)
					call(src.debuff_thirst.act)(src,src.debuff_thirst)
					if(src.client) src.client.screen -= src.debuff_thirst
			if(src.need_sleep == "Yes")
				if(src.restedness > 70 && src.buff_tired.active == 0) call(src.buff_tired.act)(src,src.buff_tired)
				else if(src.restedness < 70 && src.buff_tired.active)
					call(src.buff_tired.act)(src,src.buff_tired)
					if(src.client) src.client.screen -= src.buff_tired
				if(src.restedness < 0 && src.debuff_tired.active == 0) call(src.debuff_tired.act)(src,src.debuff_tired)
				else if(src.restedness > 0 && src.debuff_tired.active)
					call(src.debuff_tired.act)(src,src.debuff_tired)
					if(src.client) src.client.screen -= src.debuff_tired

			if(src.z == 6 || src.z == 2)
				if(src.buff_psionic_plane.active == 0 && src.race == "Demon" || src.buff_psionic_plane.active == 0 && src.race == "Kai") call(src.buff_psionic_plane.act)(src,src.buff_psionic_plane)
			//	if(src.mortal && src.debuff_age.active == 0) call(src.debuff_age.act)(src,src.debuff_age)
			//	else if(src.mortal == 0 && src.debuff_immortal.active)
				//	call(src.debuff_immortal.act)(src,src.debuff_immortal)
				//	if(src.client) src.client.screen -= src.debuff_immortal

			else
				if(src.buff_psionic_plane.active)
					call(src.buff_psionic_plane.act)(src,src.buff_psionic_plane)
					if(src.client) src.client.screen -= src.buff_psionic_plane
					src.energy_sources -= "Other Realm saturation"
					src.power_sources -= "Other Realm saturation"
				//if(src.debuff_age.active)
				//	call(src.debuff_age.act)(src,src.debuff_age)
					//if(src.client) src.client.screen -= src.debuff_age
			//	if(src.mortal == 0 && src.debuff_immortal.active == 0) call(src.debuff_immortal.act)(src,src.debuff_immortal)

			/*if(src.weight <= 1 && src.debuff_weights.active)
				call(src.debuff_weights.act)(src,src.debuff_weights)
				if(src.client) src.client.screen -= src.debuff_weights
				src.power_sources -= "Weights"
				src.strength_sources -= "Weights"*/

			if(src.in_rads > 0)
				src.in_rads -= 1;
				if(src.in_rads == 0 && src.debuff_radiation.active)
					call(src.debuff_radiation.act)(src,src.debuff_radiation)
					src.restedness_sources -= "Radiation"
					if(src.client) src.client.screen -= src.debuff_radiation
					//world << output("Removed radiation hud from screen", "chat.system")

			if(src.in_gravity > 0)
				src.in_gravity -= 1;
				if(src.in_gravity == 0 && src.debuff_gravity.active)
					call(src.debuff_gravity.act)(src,src.debuff_gravity)
					if(src.client) src.client.screen -= src.debuff_gravity
					src.power_sources -= "High gravity"
					src.strength_sources -= "High gravity"
					src.endurance_sources -= "High gravity"
					src.grav = 0
					//world << output("Removed gravity hud from screen", "chat.system")
			if(src.in_microwaves > 0)
				src.in_microwaves -= 1;
				if(src.in_microwaves == 0 && src.debuff_microwaves.active)
					call(src.debuff_microwaves.act)(src,src.debuff_microwaves)
					if(src.client) src.client.screen -= src.debuff_microwaves
					src.power_sources -= "High microwaves"
					src.force_sources -= "High microwaves"
					src.resistance_sources -= "High microwaves"
					src.microwaves = 0

			var debuffs = 0;
			var debuff_x = 32;
			for(var/obj/buffs_and_debuffs/b in src)
				//src.client.screen -= b;
				if(b.active)
					if(src.client && !locate((b) in src.client.screen)) b.screen_loc = BuildScreenLoc(debuff_x, null, 18)
					if(debuff_x == 32) b.info_txt.maptext_x = b.x_shift
					else b.info_txt.maptext_x = -38
					if(src.client && !locate((b) in src.client.screen)) src.client.screen += b;

					debuffs += 1;
					debuff_x -= 1;
			if(src && src.HUD)

				src.HUD.Rescale_Debuffs_Hud(src)
		clear_drugs()
			for(var/obj/buffs_and_debuffs/timed/d in src)
				d.timer = 0


obj
	buffs_and_debuffs
		icon = 'buffs.dmi'
		layer = 31
		plane=29
		var
			image/info_txt
			waiting = 0;
			buff_pos = 0;
			x_shift = -80
			created = 0

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
			divine_mod_gain = 0
			dark_matter_mod_gain = 0
			o2_gain = 0
			eng_mod_gain = 0
			psi_mod_gain = 0
			metab_gain = 0
			hydro_gain = 0
			tiredness_gain = 0

			psi_loss = 0
			eng_loss = 0
			str_loss = 0
			end_loss = 0
			spd_loss = 0
			res_loss = 0
			force_loss = 0
			off_loss = 0
			def_loss = 0
			regen_loss = 0
			recov_loss = 0
			int_loss = 0
			lifespan_loss = 0
			rads_loss = 0
			cold_loss = 0
			heat_loss = 0
			toxin_loss = 0
			gravity_loss = 0
			divine_mod_loss = 0
			dark_matter_mod_loss = 0
			o2_loss = 0
			eng_mod_loss = 0
			psi_mod_loss = 0
			metab_loss = 0
			hydro_loss = 0
			tiredness_loss = 0

			timer = 0
			comedown_timer = 0
			buff_type = null
			buff_name = null
			origin_name = null //Name of the thing from which this buff orginated, i.e, "steroids"
			type_path = null
			comedown = 0

		MouseEntered(location,control,params)
			usr.mouse_over = src
			if(src.info_txt)
				if(src.type == /obj/buffs_and_debuffs/timed)
					var/txt = ""
					if(src.psi_mod_gain > 0) txt = "[txt]<font color = green>\n+[src.psi_mod_gain] Power Mod</font>"
					if(src.psi_gain > 0) txt = "[txt]\n<font color = green>+[src.psi_gain*usr.mod_psionic_power] Power</font>"
					if(src.eng_mod_gain > 0) txt = "[txt]\n<font color = green>+[src.eng_mod_gain] Energy Mod</font>"
					if(src.eng_gain > 0) txt = "[txt]\n<font color = green>+[src.eng_gain*usr.mod_energy] Max Energy</font>"
					if(src.str_gain > 0) txt = "[txt]\n<font color = green>+[src.str_gain*usr.mod_strength] Strength</font>"
					if(src.spd_gain > 0) txt = "[txt]\n<font color = green>+[src.spd_gain] Agility Mod</font>"
					if(src.end_gain > 0) txt = "[txt]\n<font color = green>+[src.end_gain*usr.mod_endurance] Endurance</font>"
					if(src.res_gain > 0) txt = "[txt]\n<font color = green>+[src.res_gain*usr.mod_resistance] Resistance</font>"
					if(src.force_gain > 0) txt = "[txt]\n<font color = green>+[src.force_gain*usr.mod_force] Force</font>"
					if(src.off_gain > 0) txt = "[txt]\n<font color = green>+[src.off_gain*usr.mod_offence] Offence</font>"
					if(src.def_gain > 0) txt = "[txt]\n<font color = green>+[src.def_gain*usr.mod_defence] Defence</font>"
					if(src.regen_gain > 0) txt = "[txt]\n<font color = green>+[src.regen_gain] Regeneration Mod</font>"
					if(src.recov_gain > 0) txt = "[txt]\n<font color = green>+[src.recov_gain] Recovery Mod</font>"
					if(src.rads_gain > 0) txt = "[txt]\n<font color = green>+[src.rads_gain*100]% Radiation Tolerance</font>"
					if(src.cold_gain > 0) txt = "[txt]\n<font color = green>+[src.cold_gain*100]% Cold Tolerance</font>"
					if(src.heat_gain > 0) txt = "[txt]\n<font color = green>+[src.heat_gain*100]% Heat Tolerance</font>"
					if(src.gravity_gain > 0) txt = "[txt]\n<font color = green>+[src.gravity_gain*100]% Gravity Tolerance</font>"
					if(src.toxin_gain > 0) txt = "[txt]\n<font color = green>+[src.toxin_gain*100]% Toxin Tolerance</font>"
					if(src.divine_mod_gain > 0) txt = "[txt]\n<font color = green>+[src.divine_mod_gain] Divine Energy Mod</font>"
					if(src.dark_matter_mod_gain > 0) txt = "[txt]\n<font color = green>+[src.dark_matter_mod_gain] Dark Matter Mod</font>"
					if(src.metab_gain < 0) txt = "[txt]\n<font color = green>-[src.metab_gain] Metabolic Rate</font>"
					if(src.hydro_gain < 0) txt = "[txt]\n<font color = green>-[src.hydro_gain] Dehydration Rate</font>"
					if(src.tiredness_gain < 0) txt = "[txt]\n<font color = green>-[src.tiredness_gain] Tiredness Rate</font>"

					if(src.dark_matter_mod_gain < 0) txt = "[txt]\n<font color = red>[src.dark_matter_mod_gain] Dark Matter Mod</font>"
					if(src.psi_mod_gain < 0) txt = "[txt]<font color = red>\n[src.psi_mod_gain] Power Mod</font>"
					if(src.psi_gain < 0) txt = "[txt]\n<font color = red>[src.psi_gain*usr.mod_psionic_power] Power</font>"
					if(src.eng_mod_gain < 0) txt = "[txt]\n<font color = red>[src.eng_mod_gain] Energy Mod</font>"
					if(src.eng_gain < 0) txt = "[txt]\n<font color = red>[src.eng_gain*usr.mod_energy] Max Energy</font>"
					if(src.str_gain < 0) txt = "[txt]\n<font color = red>[src.str_gain*usr.mod_strength] Strength</font>"
					if(src.spd_gain < 0) txt = "[txt]\n<font color = red>[src.spd_gain] Agility Mod</font>"
					if(src.end_gain < 0) txt = "[txt]\n<font color = red>[src.end_gain*usr.mod_endurance] Endurance</font>"
					if(src.res_gain < 0) txt = "[txt]\n<font color = red>[src.res_gain*usr.mod_resistance] Resistance</font>"
					if(src.force_gain < 0) txt = "[txt]\n<font color = red>[src.force_gain*usr.mod_force] Force</font>"
					if(src.off_gain < 0) txt = "[txt]\n<font color = red>[src.off_gain*usr.mod_offence] Offence</font>"
					if(src.def_gain < 0) txt = "[txt]\n<font color = red>[src.def_gain*usr.mod_defence] Defence</font>"
					if(src.regen_gain < 0) txt = "[txt]\n<font color = red>[src.regen_gain] Regeneration Mod</font>"
					if(src.recov_gain < 0) txt = "[txt]\n<font color = red>[src.recov_gain] Recovery Mod</font>"
					if(src.rads_gain < 0) txt = "[txt]\n<font color = red>[src.rads_gain*100]% Radiation Tolerance</font>"
					if(src.cold_gain < 0) txt = "[txt]\n<font color = red>[src.cold_gain*100]% Cold Tolerance</font>"
					if(src.heat_gain < 0) txt = "[txt]\n<font color = red>[src.heat_gain*100]% Heat Tolerance</font>"
					if(src.gravity_gain < 0) txt = "[txt]\n<font color = red>[src.gravity_gain*100]% Gravity Tolerance</font>"
					if(src.toxin_gain < 0) txt = "[txt]\n<font color = red>[src.toxin_gain*100]% Toxin Tolerance</font>"
					if(src.divine_mod_gain < 0) txt = "[txt]\n<font color = red>[src.divine_mod_gain] Divine Energy Mod</font>"
					if(src.metab_gain > 0) txt = "[txt]\n<font color = red>+[src.metab_gain] Metabolic Rate</font>"
					if(src.hydro_gain > 0) txt = "[txt]\n<font color = red>+[src.hydro_gain] Dehydration Rate</font>"
					if(src.tiredness_gain > 0) txt = "[txt]\n<font color = red>+[src.tiredness_gain] Tiredness Rate</font>"
					src.desc = txt
					var/time = "Expires: [round(src.timer/10)]"
					src.info_txt.maptext = "<SPAN STYLE='text-decoration: underline'><font size = 1><text align=left valign=top>[src.buff_name]</span><font size = 1><text align=left valign=top>[src.desc]\n[time]"

				src.info_txt.loc = src
				usr.client.images += src.info_txt

				if(src.type == /obj/buffs_and_debuffs/timed)
					while(src && src == usr.mouse_over)
						var/time = "Expires: [round(src.timer/10)]"
						src.info_txt.maptext = "<SPAN STYLE='text-decoration: underline'><font size = 1><text align=left valign=top>[src.buff_name]</span><font size = 1><text align=left valign=top>[src.desc]\n[time]"
						sleep(1)
		MouseExited(location,control,params)
			if(src.info_txt) usr.client.images -= src.info_txt
			usr.mouse_over = null
		timed
			//Should be able to apply this to drugs, hunger, thirst, curses, blessings and diseases, DoT's ,ect.
			icon_state = "drug buff"
			New()
				spawn(0)
					if(src)
						if(src.created == 0) src.create_txt()
						src.created = 1
						while(src.timer > 0)
							src.timer -= 1
							sleep(1)
						if(src && ismob(src.loc))
							var/mob/m = src.loc
							if(src.buff_type == "drug buff") src.apply_buff(m,src)
							if(src.comedown) src.apply_comedown(m,src)
							else
								if(m.client) m.client.screen -= src
								src.destroy()
			proc
				create_txt()
					var/image/txt = image(null,src,null,100)
					var/matrix/m = matrix()
					m.Translate(-1,-160)
					txt.transform = m
					txt.maptext_width = 144
					txt.maptext_height = 160
					txt.maptext = "<SPAN STYLE='text-decoration: underline'><font size = 1><text align=center valign=top>[src.buff_name]</span><font size = 1><text align=center valign=top>[src.desc]"
					txt.filters += filter(type="outline", size=1, color=rgb(0,0,0))
					src.info_txt = txt
				apply_comedown(var/mob/m,var/obj/buffs_and_debuffs/timed/b)
					//If this buff has a comedown debuff after it, transform the current buff into a debuff. This should only happen once the stats from the orginal buff are removed.
					if(b.icon_state == "drug buff") b.icon_state = "drug debuff"
					b.psi_gain = b.psi_loss
					b.eng_gain = b.eng_loss
					b.str_gain = b.str_loss
					b.end_gain = b.end_loss
					b.spd_gain = b.spd_loss
					b.res_gain = b.res_loss
					b.force_gain = b.force_loss
					b.off_gain = b.off_loss
					b.def_gain = b.def_loss
					b.regen_gain = b.regen_loss
					b.recov_gain = b.recov_loss
					b.int_gain = b.int_loss
					b.rads_gain = b.rads_loss
					b.cold_gain = b.cold_loss
					b.heat_gain = b.heat_loss
					b.toxin_gain = b.toxin_loss
					b.gravity_gain = b.gravity_loss
					b.divine_mod_gain = b.divine_mod_loss
					b.dark_matter_mod_gain = b.dark_matter_mod_loss
					b.eng_mod_gain = b.eng_mod_loss
					b.psi_mod_gain = b.psi_mod_loss
					b.metab_gain = b.metab_loss
					b.hydro_gain = b.hydro_loss
					b.tiredness_gain = b.tiredness_loss
					b.timer = b.comedown_timer
					b.buff_name = "[b.origin_name] comedown"
					b.comedown = 0
					b.apply_buff(m,b)
					if(m.client) m.client.screen -= b
					while(b.timer > 0)
						b.timer -= 1
						sleep(1)
					if(b && ismob(b.loc))
						if(b.buff_type == "drug buff") b.apply_buff(m,b)
						if(m.client) m.client.screen -= b
						b.destroy()
						m<<output("You start to come down from your last drug effects.","actionoutput")

				apply_buff(var/mob/m,var/obj/buffs_and_debuffs/b)
					if(b.timer == -1) return
					if(b.active == 0)
						b.active = 1
						if(src.psi_mod_gain != 0)
							if(m.mod_psionic_power+src.psi_mod_gain < 0) src.psi_mod_gain = m.mod_psionic_power-m.mod_psionic_power*2
							m.mod_psionic_power += src.psi_mod_gain
						if(src.psi_gain != 0)
							if(m.gains_temp_power+(src.psi_gain*m.mod_psionic_power) < 0) src.psi_gain = (m.gains_temp_power/m.mod_psionic_power)-(m.gains_temp_power/m.mod_psionic_power)*2
							m.gains_temp_power += (src.psi_gain*m.mod_psionic_power)
						if(src.eng_mod_gain != 0)
							if(m.mod_energy+src.eng_mod_gain < 0) src.eng_mod_gain = m.mod_energy-m.mod_energy*2
							m.mod_energy += src.eng_mod_gain
						if(src.eng_gain != 0)
							if(m.gains_temp_energy+(src.eng_gain*m.mod_energy) < 0) src.eng_gain = (m.gains_temp_energy/m.mod_energy)-(m.gains_temp_energy/m.mod_energy)*2
							m.gains_temp_energy += (src.eng_gain*m.mod_energy)
						if(src.str_gain != 0)
							if(m.strength+(src.str_gain*m.mod_strength) < 0) src.str_gain = (m.strength/m.mod_strength)-(m.strength/m.mod_strength)*2
							m.strength += (src.str_gain*m.mod_strength)
						if(src.spd_gain != 0)
							if(m.mod_agility+src.spd_gain < 0) src.spd_gain = m.mod_agility-m.mod_agility*2
							m.mod_agility += src.spd_gain
						if(src.end_gain != 0)
							if(m.endurance+(src.end_gain*m.mod_endurance) < 0) src.end_gain = (m.endurance/m.mod_endurance)-(m.endurance/m.mod_endurance)*2
							m.endurance += (src.end_gain*m.mod_endurance)
						if(src.res_gain != 0)
							if(m.resistance+(src.res_gain*m.mod_resistance) < 0) src.res_gain = (m.resistance/m.mod_resistance)-(m.resistance/m.mod_resistance)*2
							m.resistance += (src.res_gain*m.mod_resistance)
						if(src.force_gain != 0)
							if(m.force+(src.force_gain*m.mod_force) < 0) src.force_gain = (m.force/m.mod_force)-(m.force/m.mod_force)*2
							m.force += (src.force_gain*m.mod_force)
						if(src.off_gain != 0)
							if(m.offence+(src.off_gain*m.mod_offence) < 0) src.off_gain = (m.offence/m.mod_offence)-(m.offence/m.mod_offence)*2
							m.offence += (src.off_gain*m.mod_offence)
						if(src.def_gain != 0)
							if(m.defence+(src.def_gain*m.mod_defence) < 0) src.def_gain = (m.defence/m.mod_defence)-(m.defence/m.mod_defence)*2
							m.defence += (src.def_gain*m.mod_defence)
						if(src.regen_gain != 0)
							if(m.mod_regeneration+src.regen_gain < 0) src.regen_gain = m.mod_regeneration-m.mod_regeneration*2
							m.mod_regeneration += src.regen_gain
						if(src.recov_gain != 0)
							if(m.mod_recovery+src.recov_gain < 0) src.recov_gain = m.mod_recovery-m.mod_recovery*2
							m.mod_recovery += src.recov_gain
						if(src.rads_gain != 0)
							if(m.mod_immune_rads+src.rads_gain < 0) src.rads_gain = m.mod_immune_rads-m.mod_immune_rads*2
							m.mod_immune_rads += src.rads_gain
						if(src.cold_gain != 0)
							if(m.mod_immune_cold+src.cold_gain < 0) src.cold_gain = m.mod_immune_cold-m.mod_immune_cold*2
							m.mod_immune_cold += src.cold_gain
						if(src.heat_gain != 0)
							if(m.mod_immune_heat+src.heat_gain < 0) src.heat_gain = m.mod_immune_heat-m.mod_immune_heat*2
							m.mod_immune_heat += src.heat_gain
						if(src.gravity_gain != 0)
							if(m.mod_immune_gravity+src.gravity_gain < 0) src.gravity_gain = m.mod_immune_gravity-m.mod_immune_gravity*2
							m.mod_immune_gravity += src.gravity_gain
						if(src.toxin_gain != 0)
							if(m.mod_immune_toxins+src.toxin_gain < 0) src.toxin_gain = m.mod_immune_toxins-m.mod_immune_toxins*2
							m.mod_immune_toxins += src.toxin_gain
						if(src.divine_mod_gain != 0)
							if(m.divine_energy_mod+src.divine_mod_gain < 0) src.divine_mod_gain = m.divine_energy_mod-m.divine_energy_mod*2
							m.divine_energy_mod += src.divine_mod_gain
						if(src.dark_matter_mod_gain != 0)
							if(m.dark_matter_mod+src.dark_matter_mod_gain < 0) src.dark_matter_mod_gain = m.dark_matter_mod-m.dark_matter_mod*2
							m.dark_matter_mod += src.dark_matter_mod_gain
						if(src.o2_gain != 0)
							if(m.o2_max+src.o2_gain < 0) src.o2_gain = m.o2_max-m.o2_max*2
							m.o2_max += src.o2_gain
						if(src.hydro_gain != 0)
							if(m.dehydration_rate+src.hydro_gain < 0) src.hydro_gain = m.dehydration_rate-m.dehydration_rate*2
							m.dehydration_rate += src.hydro_gain
						if(src.metab_gain != 0)
							if(m.metabolic_rate+src.metab_gain < 0) src.metab_gain = m.metabolic_rate-m.metabolic_rate*2
							m.metabolic_rate += src.metab_gain
						if(src.tiredness_gain != 0)
							if(m.tiredness_rate+src.tiredness_gain < 0) src.tiredness_gain = m.tiredness_rate-m.tiredness_rate*2
							m.tiredness_rate += src.tiredness_gain
						return
					else
						b.active = 0
						if(src.psi_gain != 0)
							m.gains_psiforged_power -= src.psi_gain
						if(src.psi_mod_gain != 0)
							m.mod_psionic_power -= src.psi_mod_gain
						if(src.eng_gain != 0)
							m.gains_psiforged_energy -= src.eng_gain
						if(src.eng_mod_gain != 0)
							m.mod_energy -= src.eng_mod_gain
						if(src.str_gain != 0)
							m.strength -= (src.str_gain*m.mod_strength)
						if(src.spd_gain != 0)
							m.mod_agility -= src.spd_gain
						if(src.end_gain != 0)
							m.endurance -= (src.end_gain*m.mod_endurance)
						if(src.res_gain != 0)
							m.resistance -= (src.res_gain*m.mod_resistance)
						if(src.force_gain != 0)
							m.force -= (src.force_gain*m.mod_force)
						if(src.off_gain != 0)
							m.offence -= (src.off_gain*m.mod_offence)
						if(src.def_gain != 0)
							m.defence -= (src.def_gain*m.mod_defence)
						if(src.regen_gain != 0)
							m.mod_regeneration -= src.regen_gain
						if(src.recov_gain != 0)
							m.mod_recovery -= src.recov_gain
						if(src.rads_gain != 0)
							m.mod_immune_rads -= src.rads_gain
						if(src.cold_gain != 0)
							m.mod_immune_cold -= src.cold_gain
						if(src.heat_gain != 0)
							m.mod_immune_heat -= src.heat_gain
						if(src.gravity_gain != 0)
							m.mod_immune_gravity -= src.gravity_gain
						if(src.toxin_gain != 0)
							m.mod_immune_toxins -= src.toxin_gain
						if(src.divine_mod_gain != 0)
							m.divine_energy_mod -= src.divine_mod_gain
						if(src.dark_matter_mod_gain != 0)
							m.dark_matter_mod -= src.dark_matter_mod_gain
						if(src.o2_gain != 0)
							m.o2_max -= src.o2_gain
						if(src.hydro_gain != 0)
							m.dehydration_rate -= src.hydro_gain
						if(src.metab_gain != 0)
							m.metabolic_rate -= src.metab_gain
						if(src.tiredness_gain != 0)
							m.tiredness_rate -= src.tiredness_gain
						return
		power_buff
			icon_state = "power"
			desc = "Gaining Power xp"
			New()
				src.create_txt()
				//usr << output("Created new power_buff", "chat.system")
			proc
				create_txt()
					var/image/txt = image(null,src,null,100)
					var/matrix/m = matrix()
					m.Translate(-16,-160)
					txt.transform = m
					txt.maptext_width = 144
					txt.maptext_height = 160
					txt.maptext = "<font size = 1><text align=center valign=top>[src.desc]"
					txt.filters += filter(type="outline", size=1, color=rgb(0,0,0))
					src.info_txt = txt
		energy_buff
			icon_state = "energy"
			desc = "Gaining Energy xp"
			New()
				src.create_txt()
			proc
				create_txt()
					var/image/txt = image(null,src,null,100)
					var/matrix/m = matrix()
					m.Translate(-16,-160)
					txt.transform = m
					txt.maptext_width = 144
					txt.maptext_height = 160
					txt.maptext = "<font size = 1><text align=center valign=top>[src.desc]"
					txt.filters += filter(type="outline", size=1, color=rgb(0,0,0))
					src.info_txt = txt
		dark_matter_buff
			icon_state = "dark matter"
			desc = "Gaining Dark Matter"
			New()
				src.create_txt()
			proc
				create_txt()
					var/image/txt = image(null,src,null,100)
					var/matrix/m = matrix()
					m.Translate(-16,-160)
					txt.transform = m
					txt.maptext_width = 144
					txt.maptext_height = 160
					txt.maptext = "<font size = 1><text align=center valign=top>[src.desc]"
					txt.filters += filter(type="outline", size=1, color=rgb(0,0,0))
					src.info_txt = txt
		divine_buff
			icon_state = "divine"
			desc = "Gaining Divine Energy"
			New()
				src.create_txt()
			proc
				create_txt()
					var/image/txt = image(null,src,null,100)
					var/matrix/m = matrix()
					m.Translate(-16,-160)
					txt.transform = m
					txt.maptext_width = 144
					txt.maptext_height = 160
					txt.maptext = "<font size = 1><text align=center valign=top>[src.desc]"
					txt.filters += filter(type="outline", size=1, color=rgb(0,0,0))
					src.info_txt = txt
		defence_buff
			icon_state = "defence"
			desc = "Gaining Defence xp"
			New()
				src.create_txt()
			proc
				create_txt()
					var/image/txt = image(null,src,null,100)
					var/matrix/m = matrix()
					m.Translate(-16,-160)
					txt.transform = m
					txt.maptext_width = 144
					txt.maptext_height = 160
					txt.maptext = "<font size = 1><text align=center valign=top>[src.desc]"
					txt.filters += filter(type="outline", size=1, color=rgb(0,0,0))
					src.info_txt = txt
		offence_buff
			icon_state = "offence"
			desc = "Gaining Offence xp"
			New()
				src.create_txt()
			proc
				create_txt()
					var/image/txt = image(null,src,null,100)
					var/matrix/m = matrix()
					m.Translate(-16,-160)
					txt.transform = m
					txt.maptext_width = 144
					txt.maptext_height = 160
					txt.maptext = "<font size = 1><text align=center valign=top>[src.desc]"
					txt.filters += filter(type="outline", size=1, color=rgb(0,0,0))
					src.info_txt = txt
		force_buff
			icon_state = "force"
			desc = "Gaining Force xp"
			New()
				src.create_txt()
			proc
				create_txt()
					var/image/txt = image(null,src,null,100)
					var/matrix/m = matrix()
					m.Translate(-16,-160)
					txt.transform = m
					txt.maptext_width = 144
					txt.maptext_height = 160
					txt.maptext = "<font size = 1><text align=center valign=top>[src.desc]"
					txt.filters += filter(type="outline", size=1, color=rgb(0,0,0))
					src.info_txt = txt
		resistance_buff
			icon_state = "resistance"
			desc = "Gaining resistance xp"
			New()
				src.create_txt()
			proc
				create_txt()
					var/image/txt = image(null,src,null,100)
					var/matrix/m = matrix()
					m.Translate(-16,-160)
					txt.transform = m
					txt.maptext_width = 144
					txt.maptext_height = 160
					txt.maptext = "<font size = 1><text align=center valign=top>[src.desc]"
					txt.filters += filter(type="outline", size=1, color=rgb(0,0,0))
					src.info_txt = txt

		endurance_buff
			icon_state = "endurance"
			desc = "Gaining Endurance xp"
			New()
				src.create_txt()
			proc
				create_txt()
					var/image/txt = image(null,src,null,100)
					var/matrix/m = matrix()
					m.Translate(-16,-160)
					txt.transform = m
					txt.maptext_width = 144
					txt.maptext_height = 160
					txt.maptext = "<font size = 1><text align=center valign=top>[src.desc]"
					txt.filters += filter(type="outline", size=1, color=rgb(0,0,0))
					src.info_txt = txt
		strength_buff
			icon_state = "strength"
			desc = "Gaining Strength xp"
			New()
				src.create_txt()
			proc
				create_txt()
					var/image/txt = image(null,src,null,100)
					var/matrix/m = matrix()
					m.Translate(-16,-160)
					txt.transform = m
					txt.maptext_width = 144
					txt.maptext_height = 160
					txt.maptext = "<font size = 1><text align=center valign=top>[src.desc]"
					txt.filters += filter(type="outline", size=1, color=rgb(0,0,0))
					src.info_txt = txt
		stance_buff
			icon_state = "stance"
			desc = "In a stance"
			x_shift = -100
			New()
				src.create_txt()
			proc
				create_txt()
					var/image/txt = image(null,src,null,100)
					var/matrix/m = matrix()
					m.Translate(-16,-160)
					txt.transform = m
					txt.maptext_width = 144
					txt.maptext_height = 160
					txt.maptext = "<font size = 1><text align=center valign=top>[src.desc]"
					txt.filters += filter(type="outline", size=1, color=rgb(0,0,0))
					src.info_txt = txt
		dead
			icon_state = "dead bad"
			act = /obj/buffs_and_debuffs/dead/proc/activate
			desc = "Deceased\n Trouble leaving other realm. \n Immune to environmental damage."
			New()
				src.create_txt()
			proc
				create_txt()
					var/image/txt = image(null,src,null,100)
					var/matrix/m = matrix()
					m.Translate(-16,-160)
					txt.transform = m
					txt.maptext_width = 144
					txt.maptext_height = 160
					txt.maptext = "<font size = 1><text align=center valign=top>[src.desc]"
					txt.filters += filter(type="outline", size=1, color=rgb(0,0,0))
					src.info_txt = txt
				activate(var/mob/m,var/obj/b)
					if(b.active)
						b.active = 0;
						m.client.screen -= m.debuff_dead
					else
						b.active = 1;
		psionic_plane_buff
			icon_state = "dead"
			act = /obj/buffs_and_debuffs/psionic_plane_buff/proc/activate
			desc = "Other Plane\n Divine Energy every second."
			New()
				src.create_txt()
			proc
				create_txt()
					var/image/txt = image(null,src,null,100)
					var/matrix/m = matrix()
					m.Translate(-16,-160)
					txt.transform = m
					txt.maptext_width = 144
					txt.maptext_height = 160
					txt.maptext = "<font size = 1><text align=center valign=top>[src.desc]"
					txt.filters += filter(type="outline", size=1, color=rgb(0,0,0))
					src.info_txt = txt
				activate(var/mob/m,var/obj/b)
					if(b.active)
						b.active = 0;
					else
						b.active = 1;
		kaioken_buff
			icon_state = "kaioken"
			desc = "Kaioken"
			act = /obj/buffs_and_debuffs/kaioken_buff/proc/activate
			New()
				src.create_txt()

			proc

				create_txt()
					var/image/txt = image(null,src,null,100)
					var/matrix/m = matrix()
					m.Translate(-16,-160)
					txt.transform = m
					txt.maptext_width = 144
					txt.maptext_height = 160
					txt.maptext = "<font size = 1><text align=center valign=top>[src.desc]"
					txt.filters += filter(type="outline", size=1, color=rgb(0,0,0))
					src.info_txt = txt
				activate(var/mob/m,var/obj/b)
					//world << "DEBUG - [b] was called - current status = [b.active]"
					if(b.active)
						b.active = 0;
						m.kaioken_pl = 1
					else
						b.active = 1;
		kaiosoku_buff
			icon_state = "kaiosoku"
			desc = "Kaiosoku"
			act = /obj/buffs_and_debuffs/kaiosoku_buff/proc/activate
			New()
				src.create_txt()

			proc

				create_txt()
					var/image/txt = image(null,src,null,100)
					var/matrix/m = matrix()
					m.Translate(-16,-160)
					txt.transform = m
					txt.maptext_width = 144
					txt.maptext_height = 160
					txt.maptext = "<font size = 1><text align=center valign=top>[src.desc]"
					txt.filters += filter(type="outline", size=1, color=rgb(0,0,0))
					src.info_txt = txt
				activate(var/mob/m,var/obj/b)
					//world << "DEBUG - [b] was called - current status = [b.active]"
					if(b.active)
						b.active = 0;
						m.kaiosoku_boost = 0

					else
						b.active = 1;
		kaioenjin_buff
			icon_state = "kaioenjin"
			desc = "Kaioenjin"
			act = /obj/buffs_and_debuffs/kaioenjin_buff/proc/activate
			New()
				src.create_txt()

			proc

				create_txt()
					var/image/txt = image(null,src,null,100)
					var/matrix/m = matrix()
					m.Translate(-16,-160)
					txt.transform = m
					txt.maptext_width = 144
					txt.maptext_height = 160
					txt.maptext = "<font size = 1><text align=center valign=top>[src.desc]"
					txt.filters += filter(type="outline", size=1, color=rgb(0,0,0))
					src.info_txt = txt
				activate(var/mob/m,var/obj/b)
					//world << "DEBUG - [b] was called - current status = [b.active]"
					if(b.active)
						b.active = 0;
						m.kaioenjin=0

					else
						b.active = 1;
		kaioryu_buff
			icon_state = "kaioryu"
			desc = "Kaioryu"
			act = /obj/buffs_and_debuffs/kaioryu_buff/proc/activate
			New()
				src.create_txt()

			proc

				create_txt()
					var/image/txt = image(null,src,null,100)
					var/matrix/m = matrix()
					m.Translate(-16,-160)
					txt.transform = m
					txt.maptext_width = 144
					txt.maptext_height = 160
					txt.maptext = "<font size = 1><text align=center valign=top>[src.desc]"
					txt.filters += filter(type="outline", size=1, color=rgb(0,0,0))
					src.info_txt = txt
				activate(var/mob/m,var/obj/b)
					//world << "DEBUG - [b] was called - current status = [b.active]"
					if(b.active)
						b.active = 0;
						m.kaioryu=0

					else
						b.active = 1;
		mystic_buff
			icon_state = "endurance"
			desc = "Mystic"
			act = /obj/buffs_and_debuffs/mystic_buff/proc/activate
			New()
				src.create_txt()

			proc

				create_txt()
					var/image/txt = image(null,src,null,100)
					var/matrix/m = matrix()
					m.Translate(-16,-160)
					txt.transform = m
					txt.maptext_width = 144
					txt.maptext_height = 160
					txt.maptext = "<font size = 1><text align=center valign=top>[src.desc]"
					txt.filters += filter(type="outline", size=1, color=rgb(0,0,0))
					src.info_txt = txt
				activate(var/mob/m,var/obj/b)
					//world << "DEBUG - [b] was called - current status = [b.active]"
					if(b.active)
						b.active = 0;
						m.psionic_power /= 12.5
					else
						b.active = 1;
						m.psionic_power *= 12.5
		majin_buff
			icon_state = "endurance"
			desc = "Majinized"
			act = /obj/buffs_and_debuffs/majin_buff/proc/activate
			New()
				src.create_txt()

			proc
				majin_multiplier(majin_level)
					if(majin_level == 1) return 3.5    // 250% buff
					if(majin_level == 2) return 6      // 500% buff
					if(majin_level == 3) return 11     // 1000% buff

				create_txt()
					var/image/txt = image(null,src,null,100)
					var/matrix/m = matrix()
					m.Translate(-16,-160)
					txt.transform = m
					txt.maptext_width = 144
					txt.maptext_height = 160
					txt.maptext = "<font size = 1><text align=center valign=top>[src.desc]"
					txt.filters += filter(type="outline", size=1, color=rgb(0,0,0))
					src.info_txt = txt
				activate(var/mob/m,var/obj/b)
					//world << "DEBUG - [b] was called - current status = [b.active]"
					if(b.active)
						b.active = 0;
						m.psionic_power /= majin_multiplier(m.has_majin)
					else
						b.active = 1;
						m.psionic_power *= majin_multiplier(m.has_majin)
		underwater
			icon_state = "underwater"
			act = /obj/buffs_and_debuffs/underwater/proc/activate
			desc = "No Oxygen \n  -1% HP a second under low oxygen"
			New()
				src.create_txt()
			proc
				create_txt()
					var/image/txt = image(null,src,null,100)
					var/matrix/m = matrix()
					m.Translate(-16,-160)
					txt.transform = m
					txt.maptext_width = 144
					txt.maptext_height = 160
					txt.maptext = "<font size = 1><text align=center valign=top>[src.desc]"
					txt.filters += filter(type="outline", size=1, color=rgb(0,0,0))
					src.info_txt = txt
				activate(var/mob/m,var/obj/b)
					//world << "DEBUG - [b] was called - current status = [b.active]"
					if(b.active)
						b.active = 0;
					//	m.mod_recovery *= 1.1
					else
						b.active = 1;
					//	m.mod_recovery /= 1.1
		weights
			icon_state = "weights"
			act = /obj/buffs_and_debuffs/weights/proc/activate
			desc = "Weighted \n -10% Agility \n Strength & Power xp \n Suppressed power"
			New()
				src.create_txt()
			proc
				create_txt()
					var/image/txt = image(null,src,null,100)
					var/matrix/m = matrix()
					m.Translate(-16,-160)
					txt.transform = m
					txt.maptext_width = 144
					txt.maptext_height = 160
					txt.maptext = "<font size = 1><text align=center valign=top>[src.desc]"
					txt.filters += filter(type="outline", size=1, color=rgb(0,0,0))
					src.info_txt = txt
				activate(var/mob/m,var/obj/buffs_and_debuffs/b)
					if(b.active)
						b.active = 0;
						m.mod_agility *= 1.1
					else
						b.active = 1;
						m.mod_agility /= 1.1
		hungry
			icon_state = "hungry"
			act = /obj/buffs_and_debuffs/hungry/proc/activate
			desc = "Hungry \n Risk of death from starvation"
			New()
				src.create_txt()
			proc
				create_txt()
					var/image/txt = image(null,src,null,100)
					var/matrix/m = matrix()
					m.Translate(-16,-160)
					txt.transform = m
					txt.maptext_width = 144
					txt.maptext_height = 160
					txt.maptext = "<font size = 1><text align=center valign=top>[src.desc]"
					txt.filters += filter(type="outline", size=1, color=rgb(0,0,0))
					src.info_txt = txt
				activate(var/mob/m,var/obj/b)
					if(b.active)
						b.active = 0;
					//	m.mod_regeneration *= 1.1
					//	m.mod_endurance *= 1.1
					//	m.mod_immune_cold *= 1.1
					//	m.mod_strength *= 1.1
					//	m.strength *= 1.1
						//m.endurance *= 1.1
					else
						b.active = 1;
					//	m.mod_regeneration /= 1.1
					//	m.mod_strength /= 1.1
					//	m.mod_endurance /= 1.1
					//	m.mod_immune_cold /= 1.1
					//	m.strength /= 1.1
					//	m.endurance /= 1.1
					//	m.check_quest("needs_hunger_low",1,0,1)
		well_fed
			icon_state = "well fed"
			act = /obj/buffs_and_debuffs/well_fed/proc/activate
			desc = "Well Fed"
			New()
				src.create_txt()
			proc
				create_txt()
					var/image/txt = image(null,src,null,100)
					var/matrix/m = matrix()
					m.Translate(-16,-160)
					txt.transform = m
					txt.maptext_width = 144
					txt.maptext_height = 160
					txt.maptext = "<font size = 1><text align=center valign=top>[src.desc]"
					txt.filters += filter(type="outline", size=1, color=rgb(0,0,0))
					src.info_txt = txt
				activate(var/mob/m,var/obj/b)
					if(b.active)
						b.active = 0;
					//	m.mod_regeneration /= 1.1
					//	m.strength /= 1.1
					//	m.endurance /= 1.1
					//	m.mod_endurance /= 1.1
					//	m.mod_strength /= 1.1
					//	m.mod_immune_cold /= 1.1
					//	m.psiforging_speed -= 0.05
					else
						b.active = 1;
					//	m.mod_regeneration *= 1.1
					//	m.mod_endurance *= 1.1
					//	m.mod_strength *= 1.1
					//	m.mod_immune_cold *= 1.1
					//	m.strength *= 1.1
					//	m.endurance *= 1.1
					//	m.psiforging_speed += 0.05
					//	m.check_quest("needs_hunger_high",1,0,1)
		thirsty
			icon_state = "thirsty"
			act = /obj/buffs_and_debuffs/thirsty/proc/activate
			desc = "Thirsty \n Risk of death from starvation"
			New()
				src.create_txt()
			proc
				create_txt()
					var/image/txt = image(null,src,null,100)
					var/matrix/m = matrix()
					m.Translate(-16,-160)
					txt.transform = m
					txt.maptext_width = 144
					txt.maptext_height = 160
					txt.maptext = "<font size = 1><text align=center valign=top>[src.desc]"
					txt.filters += filter(type="outline", size=1, color=rgb(0,0,0))
					src.info_txt = txt
				activate(var/mob/m,var/obj/b)
					if(b.active)
						b.active = 0;
					//	m.mod_recovery *= 1.1
					//	m.force *= 1.1
					//	m.mod_force *= 1.1
					//	m.resistance *= 1.1
					//	m.mod_resistance *= 1.1
					//	m.mod_immune_heat *= 1.1
					else
						b.active = 1;
					//	m.mod_recovery /= 1.1
					//	m.force /= 1.1
					//	m.mod_force /= 1.1
					//	m.resistance /= 1.1
					//	m.mod_resistance /= 1.1
					//	m.mod_immune_heat /= 1.1
					//	m.check_quest("needs_thirst_low",1,0,1)
		hydrated
			icon_state = "hydrated"
			act = /obj/buffs_and_debuffs/hydrated/proc/activate
			desc = "Hydrated"
			New()
				src.create_txt()
			proc
				create_txt()
					var/image/txt = image(null,src,null,100)
					var/matrix/m = matrix()
					m.Translate(-16,-160)
					txt.transform = m
					txt.maptext_width = 144
					txt.maptext_height = 160
					txt.maptext = "<font size = 1><text align=center valign=top>[src.desc]"
					txt.filters += filter(type="outline", size=1, color=rgb(0,0,0))
					src.info_txt = txt
				activate(var/mob/m,var/obj/b)
					if(b.active)
						b.active = 0;
					//	m.mod_recovery /= 1.1
					//	m.force /= 1.1
					//	m.mod_force /= 1.1
					//	m.resistance /= 1.1
					//	m.mod_resistance /= 1.1
					//	m.mod_immune_heat /= 1.1
					//	m.psiforging_speed -= 0.05
					else
						b.active = 1;
					//	m.mod_recovery *= 1.1
					//	m.force *= 1.1
					//	m.mod_force *= 1.1
					//	m.resistance *= 1.1
					//	m.mod_resistance *= 1.1
					//	m.mod_immune_heat *= 1.1
					//	m.psiforging_speed += 0.05
					//	m.check_quest("needs_thirst_high",1,0,1)
		well_rested
			icon_state = "well rested"
			act = /obj/buffs_and_debuffs/well_rested/proc/activate
			desc = "Well Rested"
			New()
				src.create_txt()
			proc
				create_txt()
					var/image/txt = image(null,src,null,100)
					var/matrix/m = matrix()
					m.Translate(-16,-160)
					txt.transform = m
					txt.maptext_width = 144
					txt.maptext_height = 160
					txt.maptext = "<font size = 1><text align=center valign=top>[src.desc]"
					txt.filters += filter(type="outline", size=1, color=rgb(0,0,0))
					src.info_txt = txt
				activate(var/mob/m,var/obj/b)
					if(b.active)
						b.active = 0;
					//	m.offence /= 1.1
					//	m.defence /= 1.1
					//	m.mod_offence /= 1.1
					//	m.mod_defence /= 1.1
					//	m.mod_energy /= 1.1
					//	m.psiforging_speed -= 0.05
					else
						b.active = 1;
					//	m.offence *= 1.1
					//	m.defence *= 1.1
					//	m.mod_offence *= 1.1
					//	m.mod_defence *= 1.1
					//	m.mod_energy *= 1.1
					//	m.psiforging_speed += 0.05
					//	m.check_quest("needs_rest_high",1,0,1)
		tired
			icon_state = "tired"
			act = /obj/buffs_and_debuffs/tired/proc/activate
			desc = "Tired \n Risk of death from fatigue"
			New()
				src.create_txt()
			proc
				create_txt()
					var/image/txt = image(null,src,null,100)
					var/matrix/m = matrix()
					m.Translate(-16,-160)
					txt.transform = m
					txt.maptext_width = 144
					txt.maptext_height = 160
					txt.maptext = "<font size = 1><text align=center valign=top>[src.desc]"
					txt.filters += filter(type="outline", size=1, color=rgb(0,0,0))
					src.info_txt = txt
				activate(var/mob/m,var/obj/b)
					if(b.active)
						b.active = 0;
					//	m.mod_recovery *= 1.1
					//	m.offence *= 1.1
					//	m.defence *= 1.1
					//	m.mod_offence *= 1.1
					//	m.mod_defence *= 1.1
					//	m.mod_energy *= 1.1
					else
						b.active = 1;
					//	m.mod_recovery /= 1.1
					//	m.offence /= 1.1
					//	m.defence /= 1.1
					//	m.mod_offence /= 1.1
					//	m.mod_defence /= 1.1
					//	m.mod_energy /= 1.1
					//	m.check_quest("needs_rest_low",1,0,1)
		hot
			icon_state = "hot"
			act = /obj/buffs_and_debuffs/hot/proc/activate
			desc = "Hot(x1)\n -1% HP a second"
			New()
				src.create_txt()
				if(ismob(src.loc))
					var/mob/m = src.loc
					while(src)
						if(src.active)
							src.desc = "Hot(x[m.tmp_dmg])\n -1% HP a second"
						sleep(0.1)



			proc
				create_txt()
					var/image/txt = image(null,src,null,100)
					var/matrix/m = matrix()
					m.Translate(-16,-160)
					txt.transform = m
					txt.maptext_width = 144
					txt.maptext_height = 160
					txt.maptext = "<font size = 1><text align=center valign=top>[src.desc]"
					txt.filters += filter(type="outline", size=1, color=rgb(0,0,0))
					src.info_txt = txt
				activate(var/mob/m,var/obj/b)
					if(b.active)
						b.active = 0;
						b.desc = "Hot(x[m.tmp_dmg])\n -1% HP a second"

					else
						b.active = 1;
						b.desc = "Hot(x[m.tmp_dmg])\n -1% HP a second"

		immortal_drain
			icon_state = "immortal drain"
			act = /obj/buffs_and_debuffs/immortal_drain/proc/activate
			desc = "Psi being in material realm \n Recovering slower"
			New()
				src.create_txt()
			proc
				create_txt()
					var/image/txt = image(null,src,null,100)
					var/matrix/m = matrix()
					m.Translate(-16,-160)
					txt.transform = m
					txt.maptext_width = 144
					txt.maptext_height = 160
					txt.maptext = "<font size = 1><text align=center valign=top>[src.desc]"
					txt.filters += filter(type="outline", size=1, color=rgb(0,0,0))
					src.info_txt = txt
				activate(var/mob/m,var/obj/b)
					if(b.active)
						b.active = 0;
					else
						b.active = 1;
		baleful_light
			icon_state = "baleful"
			act = /obj/buffs_and_debuffs/baleful_light/proc/activate
			desc = "Baleful light. \n Energy drain every second."
			New()
				src.create_txt()
			proc
				create_txt()
					var/image/txt = image(null,src,null,100)
					var/matrix/m = matrix()
					m.Translate(-16,-160)
					txt.transform = m
					txt.maptext_width = 144
					txt.maptext_height = 160
					txt.maptext = "<font size = 1><text align=center valign=top>[src.desc]"
					txt.filters += filter(type="outline", size=1, color=rgb(0,0,0))
					src.info_txt = txt
				activate(var/mob/m,var/obj/b)
					if(b.active)
						b.active = 0;
					else
						b.active = 1;
		exalted_light
			icon_state = "exalted"
			act = /obj/buffs_and_debuffs/exalted_light/proc/activate
			desc = "Blinding light. \n -0.1% Eye HP a second."
			New()
				src.create_txt()
			proc
				create_txt()
					var/image/txt = image(null,src,null,100)
					var/matrix/m = matrix()
					m.Translate(-16,-160)
					txt.transform = m
					txt.maptext_width = 144
					txt.maptext_height = 160
					txt.maptext = "<font size = 1><text align=center valign=top>[src.desc]"
					txt.filters += filter(type="outline", size=1, color=rgb(0,0,0))
					src.info_txt = txt
				activate(var/mob/m,var/obj/b)
					if(b.active)
						b.active = 0;
					else
						b.active = 1;
		age_faster
			icon_state = "fast age"
			act = /obj/buffs_and_debuffs/age_faster/proc/activate
			desc = "Mortal in Other Realms \n Aging x10 faster"
			New()
				src.create_txt()
			proc
				create_txt()
					var/image/txt = image(null,src,null,100)
					var/matrix/m = matrix()
					m.Translate(-16,-160)
					txt.transform = m
					txt.maptext_width = 144
					txt.maptext_height = 160
					txt.maptext = "<font size = 1><text align=center valign=top>[src.desc]"
					txt.filters += filter(type="outline", size=1, color=rgb(0,0,0))
					src.info_txt = txt
				activate(var/mob/m,var/obj/b)
					if(b.active)
						b.active = 0;
					else
						b.active = 1;
		cold
			icon_state = "cold"
			act = /obj/buffs_and_debuffs/cold/proc/activate
			desc = "Cold(x1) \n  -1% HP a second"
			New()
				src.create_txt()
				if(ismob(src.loc))
					var/mob/m = src.loc
					while(src)
						if(src.active)
							src.desc = "Cold(x[m.tmp_dmg])\n -1% HP a second"
						sleep(0.1)

			proc
				create_txt()
					var/image/txt = image(null,src,null,100)
					var/matrix/m = matrix()
					m.Translate(-16,-160)
					txt.transform = m
					txt.maptext_width = 144
					txt.maptext_height = 160
					txt.maptext = "<font size = 1><text align=center valign=top>[src.desc]"
					txt.filters += filter(type="outline", size=1, color=rgb(0,0,0))
					src.info_txt = txt
				activate(var/mob/m,var/obj/b)
					if(b.active)
						b.active = 0;
						b.desc = "Cold(x[m.tmp_dmg])\n -1% HP a second"

					else
						b.active = 1;
						b.desc = "Cold(x[m.tmp_dmg])\n -1% HP a second"

		radiation
			icon_state = "radiation"
			act = /obj/buffs_and_debuffs/radiation/proc/activate
			desc = "Rads \n Slow decrease in tiredness"
			New()
				src.create_txt()
			proc
				create_txt()
					var/image/txt = image(null,src,null,100)
					var/matrix/m = matrix()
					m.Translate(-16,-160)
					txt.transform = m
					txt.maptext_width = 144
					txt.maptext_height = 160
					txt.maptext = "<font size = 1><text align=center valign=top>[src.desc]"
					txt.filters += filter(type="outline", size=1, color=rgb(0,0,0))
					src.info_txt = txt
				activate(var/mob/m,var/obj/buffs_and_debuffs/b)
					if(b.active)
						b.active = 0;
						//m.mod_regeneration /= 1.1
					//	m.mod_endurance *= 1.1
					//	m.endurance *= 1.1
					else
						b.active = 1;
					//	m.mod_regeneration *= 1.1
					//	m.mod_endurance /= 1.1
					//	m.endurance /= 1.1
				/*
				activate(var/mob/m,var/obj/buffs_and_debuffs/b)
					if(b.waiting == 0)
						b.active = 1;
						b.waiting = 1
						spawn(10)
							if(m && b)
								b.active = 0;
								b.waiting = 0;
				*/
		microwave_debuff
			icon_state = "microwaves"
			act = /obj/buffs_and_debuffs/microwave_debuff/proc/activate
			desc = "Microwaves \n -10% Agility \n HP damage a second \n Power, Resistance & Force xp while in High Microwaves"
			x_shift = -85
			New()
				src.create_txt()
			proc
				create_txt()
					var/image/txt = image(null,src,null,100)
					var/matrix/m = matrix()
					m.Translate(-16,-160)
					txt.transform = m
					txt.maptext_width = 144
					txt.maptext_height = 160
					txt.maptext = "<font size = 1><text align=center valign=top>[src.desc]"
					txt.filters += filter(type="outline", size=1, color=rgb(0,0,0))
					src.info_txt = txt
				activate(var/mob/m,var/obj/buffs_and_debuffs/b)
					if(b.active)
						b.active = 0;
						m.mod_agility *= 1.1
					else
						b.active = 1;
						m.mod_agility /= 1.1
		grav_debuff
			icon_state = "gravity"
			act = /obj/buffs_and_debuffs/grav_debuff/proc/activate
			desc = "Grav \n HP damage a second while in high gravity"
			x_shift = -85
			New()
				src.create_txt()
			proc
				create_txt()
					var/image/txt = image(null,src,null,100)
					var/matrix/m = matrix()
					m.Translate(-16,-160)
					txt.transform = m
					txt.maptext_width = 144
					txt.maptext_height = 160
					txt.maptext = "<font size = 1><text align=center valign=top>[src.desc]"
					txt.filters += filter(type="outline", size=1, color=rgb(0,0,0))
					src.info_txt = txt
				activate(var/mob/m,var/obj/buffs_and_debuffs/b)
					if(b.active)
						b.active = 0;
					//	m.mod_agility *= 1.1
					else
						b.active = 1;
					//	m.mod_agility /= 1.1
				/*
				activate(var/mob/m,var/obj/buffs_and_debuffs/b)
					if(b.waiting == 0)
						b.active = 1;
						b.waiting = 1
						m.mod_agility /= 1.1
						spawn(10)
							if(m && b)
								b.active = 0;
								b.waiting = 0;
								m.mod_agility *= 1.1
								var/Make_this_reset_when_reloading
				*/