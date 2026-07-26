obj
	//Make it so you can get a trait point once a skill reaches lvl 100.
	//Make it so mastering a skill gives extra benefits and damage and effects.
	//Wrestle system potentially, where clicking someone you have grabbed.
	traits
		icon = 'skills.dmi'
		icon_state = "origin"
		trait = 1
		info_point_cost = 1
		info_point_cost_type = "combat"
		plane = 33
		layer = 34
		blend_mode = BLEND_INSET_OVERLAY
		appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
		New()
			..()
			var/image/over = image('unlocks_over.dmi',src,"over",100)
			over.pixel_x = -1
			over.pixel_y = -1
			src.img_over = over
		/*
		DblClick(location,control,params)
			if(src in usr.traits)
				params = params2list(params)
				var/dir = null
				if(params["left"] || usr.mouse_dir == "left")
					dir = "left"
				if(params["right"] || usr.mouse_dir == "right")
					dir = "right"
				if(dir == "left")
					if(usr.skill_points_combat) if(src.active == 0)
						usr.skill_points_combat -= 1
						src.overlays = null
						src.overlays += /obj/effects/misc/trait_select
						call(src.act)(usr,src)
						src.active = 1
		*/
				/*
				if(dir == "right")
					if(src.active)
						usr.skill_points_combat += 1
						src.overlays = null
						call(src.act)(usr,src)
						src.active = 0
				*/
		Click()
			if(src.loc == null && usr.hud_unlocks)
				usr.skill_selected = src
				var/obj/hud/menus/unlocks_background/bg = usr.hud_unlocks
				var/stats = ""
				if(src.info_stats) stats = "\n\n[src.info_stats]"
				bg.info_txt.maptext = "[css_outline]<font size = 1><text align=left valign=top>Point Cost: [src.info_point_cost]\n\n[src.info_buffs][stats]\n\n[src.info]"

				var/icon/I = icon(src.icon,src.icon_state,SOUTH,1,0)
				I.Scale(64,64)
				bg.unlock_icon.icon = I
				var/matrix/m = matrix()
				m.Translate(464,280)
				bg.unlock_icon.hud_x = 464
				bg.unlock_icon.hud_y = 280
				bg.unlock_icon.transform = m

				if(isnum(src.info_dmg)) bg.bar_power.icon_state = "[src.info_dmg]"
				if(isnum(src.info_spd)) bg.bar_speed.icon_state = "[src.info_spd]"
				if(isnum(src.info_energy_cost)) bg.bar_energy.icon_state = "[src.info_energy_cost]"
				if(isnum(src.info_mastery)) bg.bar_mastery.icon_state = "[src.info_mastery]"
				if(isnum(src.info_cd)) bg.bar_cooldown.icon_state = "[src.info_cd]"

				bg.name_txt.maptext = "[css_outline]<font size = 1><center>[src.name]"
		MouseMove(location,control,params)
			usr.info_box(src,"[src.name]",params)
		MouseEntered(object,location,control,params)
			usr.mouse_saved_loc = src
			usr.client.images += src.img_over
			if(usr.info_box1)
				usr.client.screen += usr.info_box1
				usr.client.screen += usr.info_box2
				usr.client.screen += usr.info_box3
		MouseExited(location,control,params)
			usr.client.images -= src.img_over
			if(usr.info_box1)
				usr.client.screen -= usr.info_box1
				usr.client.screen -= usr.info_box2
				usr.client.screen -= usr.info_box3
				usr.info_box3.maptext = null
		//Iron_Bones
			//Increased health for limbs.
		Tough_as_Nails
			//Increased endurance
			info = "Your body has become incredibly resistant to physical attacks, making you withstand sundering blows with casual ease. With this trait, you gain an extra 10% to your endurance mod, making you weather blows much easier."
			info_name = "Tough_as_Nails"
			act = /obj/traits/Tough_as_Nails/proc/activate
			proc
				activate(var/mob/m,var/obj/s)
					if(s.active)
						m.mod_endurance/=1.1
					else
						m.mod_endurance*=1.1
						s.active = 1
		Quicksilver
			//Increased agility
			info = "You move like a leaf on the wind, graceful in your poise and elegance. With training, you’ve managed to make others seem sluggish in comparison, a veritable speed-demon with few equals. With this trait, you gain an extra 10% to your agility mod."
			info_name = "Quicksilver"
			act = /obj/traits/Quicksilver/proc/activate
			proc
				activate(var/mob/m,var/obj/s)
					if(s.active)
						m.mod_agility/=1.1
					else
						m.mod_agility*=1.1
						s.active = 1
		Titanic_Strength
			//Increased strength
			info = "Like some hero of old, you seem to possess godlike strength compared to the rest of your people. Your colossal blows turn even the most fortified opponent into a quivering pulp. With this trait, you gain an extra 10% to your strength mod."
			info_name = "Titanic_Strength"
			act = /obj/traits/Titanic_Strength/proc/activate
			proc
				activate(var/mob/m,var/obj/s)
					if(s.active)
						m.mod_strength/=1.1
					else
						m.mod_strength*=1.1
						s.active = 1
		Deep_Reserves
			//Increased energy
			info = "The depths of your forceual being seems boundless, oft times overflowing with excessive energy even after much physical and mental exertion. With some effort, you seem able to store more energy than others. With this trait, you gain an extra 10% to your energy mod."
			info_name = "Deep_Reserves"
			act = /obj/traits/Deep_Reserves/proc/activate
			proc
				activate(var/mob/m,var/obj/s)
					if(s.active)
						m.mod_energy/=1.1
					else
						m.mod_energy*=1.1
						s.active = 1
		Preternatural_Regeneration
			//Increased regen
			info = "Bones, sinew and muscle reknit at a rate which defies belief, granting you an increased regenerative bonus. Even the worst of attacks sent forth against you can cause lasting harm. With this trait, you gain an extra 10% to your regeneration mod."
			info_name = "Preternatural_Regeneration"
			act = /obj/traits/Preternatural_Regeneration/proc/activate
			proc
				activate(var/mob/m,var/obj/s)
					if(s.active)
						m.mod_regeneration/=1.1
					else
						m.mod_regeneration*=1.1
						s.active = 1
		Rapid_Recuperation
			//Increased recov
			info = "With some effort, you’ve learned to gather energy and redirect it much faster than others. When drained or exhausted, your reserves seem to replenish at incredible speeds, giving you second wind to use in your endeavours. With this trait, you gain an extra 10% to your recovery mod."
			info_name = "Rapid_Recuperation"
			act = /obj/traits/Rapid_Recuperation/proc/activate
			proc
				activate(var/mob/m,var/obj/s)
					if(s.active)
						m.mod_recovery/=1.1
					else
						m.mod_recovery*=1.1
						s.active = 1
		Surgical_Precision
			//Increased offence
			info = "You are no butcher, but a surgeon. Your strikes are accurate beyond compare, a precision few could hope to attain. The attacks of others seem sloppy and uncoordinated compared to yours. With this trait, you gain an extra 10% to your offence mod."
			info_name = "Surgical_Precision"
			act = /obj/traits/Surgical_Precision/proc/activate
			proc
				activate(var/mob/m,var/obj/s)
					if(s.active)
						m.mod_offence/=1.1
					else
						m.mod_offence*=1.1
						s.active = 1
		Profound_Avoidance
			//Increased defence
			info = "Your mind is fine-tuned to the movements of others, verging on paranoia or precognition. Your defensive skills are something to be admired, avoiding destruction at the hands of your foes or simply turning their attacks away as to do no harm. With this trait, you gain an extra 10% to your defence mod."
			info_name = "Profound_Avoidance"
			act = /obj/traits/Profound_Avoidance/proc/activate
			proc
				activate(var/mob/m,var/obj/s)
					if(s.active)
						m.mod_defence/=1.1
					else
						m.mod_defence*=1.1
						s.active = 1
		Psionic_Terror
			//Increased force
			info = "Your brain is a weapon and you know this better than any. You are limited by two things. The laws of physics, and your mind. Thankfully, you use the latter to bend and dominate the former; monstrous and terrifying to all. With this trait, you gain an extra 10% to your force mod. "
			info_name = "Psionic_Terror"
			act = /obj/traits/Psionic_Terror/proc/activate
			proc
				activate(var/mob/m,var/obj/s)
					if(s.active)
						m.mod_force/=1.1
					else
						m.mod_force*=1.1
						s.active = 1
		Null_Void_Nexus
			//Increased resistance
			info = "Like a void whose baleful caress negates the effects of light, your psionic presence is anathema to foreign assault, allowing you to ignore a portion of an enemies dangerous energies. With this trait, you gain an extra 10% to your resistance mod."
			info_name = "Null_Void_Nexus"
			act = /obj/traits/Null_Void_Nexus/proc/activate
			proc
				activate(var/mob/m,var/obj/s)
					if(s.active)
						m.mod_resistance/=1.1
					else
						m.mod_resistance*=1.1
						s.active = 1
		Prodigious_Intelligence
			//Increased intelligence potential
			info = "You overflow with a well of knowledge, retaining information at an incredible rate. Genius would probably be an insult to your greatness, for the depths of your study go well beyond even the extraordinary. With this trait, you gain +25% more xp toward your research projects."
			info_name = "Prodigious_Intelligence"
			act = /obj/traits/Prodigious_Intelligence/proc/activate
			proc
				activate(var/mob/m,var/obj/s)
					if(s.active)
						m.mod_tech_potential -= 1
					else
						m.mod_tech_potential += 1
						s.active = 1
		Iron_Body
			//Increased organ exp gains
			info = "You've managed to develop a special series of body techniques and breathing excersises to cause the body's natural energy to reinforce its structural strength. With such knowledge at hand, you gain +25% more xp toward saturating your bodyparts with Power."
			info_name = "Iron Body"
			act = /obj/traits/Iron_Body/proc/activate
			proc
				activate(var/mob/m,var/obj/s)
					if(s.active)
						m.trait_ironbody = null
					else
						m.trait_ironbody = s
						s.active = 1
						m.psiforging_speed += 0.25
		Prodigy
			//Increased combat exp gains
			info = "Everything seems just a little easier for you, compared to everyone else. You learn quickly and retain experiences better than others, allowing you to learn from your mistakes speedier and apply them to practical uses faster. With this trait, you gain +25% more xp in your combat stats."
			info_name = "Prodigy"
			act = /obj/traits/Prodigy/proc/activate
			proc
				activate(var/mob/m,var/obj/s)
					if(s.active)
						m.trait_prodigy = null
					else
						m.trait_prodigy = s
						s.active = 1
		Will_of_Steel
			//Decreased ko times
			info = "Your resolve is solid, a determination bordering on zealous which keeps you pushing hard than anyone else in the face of certain doom. Not even being unconscious or badly beaten can keep you down for long. With this trait, you stay unconscious for less time than others."
			info_name = "Will_of_Steel"
			act = /obj/traits/Will_of_Steel/proc/activate
			proc
				activate(var/mob/m,var/obj/s)
					if(s.active)
						m.trait_wos = null
					else
						m.trait_wos = s
						s.active = 1
		Unassailable
			//Enemies have no chance for a flanking bonus.
			info = "It’s like you have eyes in the back of your head! Nobody seems able to circumvent your seemingly impossible sense of awareness in combat. With this trait, enemies will be unable to gain a flanking bonus against you."
			info_name = "Unassailable"
			act = /obj/traits/Unassailable/proc/activate
			proc
				activate(var/mob/m,var/obj/s)
					if(s.active)
						m.trait_u = null
					else
						m.trait_u = s
						s.active = 1
		Unstoppable_Resilience
			//Much higher chance to survive a fatal attack - 50% chance
			info = "Stubborn refusal to accept or acknowledge injury has translated into the absolute denial of death itself. Even on the brink of oblivion, you pull yourself back and continue the fight for just a little longer. With this trait, there is a 50% chance that an attack that was meant to kill you, is completely ignored. "
			info_name = "Unstoppable_Resilience"
			act = /obj/traits/Unstoppable_Resilience/proc/activate
			proc
				activate(var/mob/m,var/obj/s)
					if(s.active)
						m.trait_ur = null
					else
						m.trait_ur = s
						s.active = 1
		Perfect_Adaption
			//Master gravity and weights quicker and don't feel their effects as much.
			info = "Environmental effects such as gravity are easily adapted by your body, offering increased opportunity to improve yourself in some of the harshest conditions imaginable. You’re also able to shake off their effects a little easier than others, allowing you to spend more time in them before succumbing to their damming effects."
			info_name = "Perfect_Adaption"
			act = /obj/traits/Perfect_Adaption/proc/activate
			proc
				activate(var/mob/m,var/obj/s)
					if(s.active)
						m.trait_pa = null
					else
						m.trait_pa = s
						s.active = 1
		//Ravenous_Metabolism
			//Get better bonus from eating
		Eternal_Flight
			//No energy drain on fly, normal drain on super fly.
			info = " Being able to suspend yourself via sheer force of will and psionic power has become second nature to you. You don’t even feel the effects any more, freeing your mind and concentration to focus on other activities. With this trait, flight no longer drains you and super flight only half as much."
			info_name = "Eternal_Flight"
			act = /obj/traits/Eternal_Flight/proc/activate
			proc
				activate(var/mob/m,var/obj/s)
					if(s.active)
						m.trait_ef = null
					else
						m.trait_ef = s
						s.active = 1
		Psionic_Manifestation
			//Create psi shards for 1k max energy loss.
			info = "Psi energy can manifest in a number of ways. Through sheer force of will, you learn to condense your own into crystalline form. Once taken, you can click this again anytime, producing a Psi Shard, costing you a permanent 1000 energy loss. "
			info_name = "Psionic_Manifestation"
			act = /obj/traits/Psionic_Manifestation/proc/activate
			proc
				activate(var/mob/m,var/obj/s)
					sleep(10)
					s.active = 2
		Total_Awareness
			//Double sense mod/ability, no need to see someone perfom an attack to find out their stats.
			info = "Unnatural are your senses, supernatural is your perception. The distance you're able to identify others is much higher compared to most and your ability to discern information about your opponents is effortless in nature. With this trait, sense range is doubled and all stats of your target are automatically revealed."
			info_name = "Total_Awareness"
			act = /obj/traits/Total_Awareness/proc/activate
			proc
				activate(var/mob/m,var/obj/s)
					if(s.active)
						m.trait_ta = null
					else
						m.trait_ta = s
						s.active = 1
		Grand_Architect
			//Half/No cost for building
			info = "You’ve a knack for architecture and a pioneer of revolutionary and innovative design. Patterns, symbols, angles and mathematics are all part of a singular, greater list of ingredients utilized toward the perfect of construction. With this trait, your buildings are half as expensive to create compared to others."
			info_name = "Grand_Architect"
			act = /obj/traits/Grand_Architect/proc/activate
			proc
				activate(var/mob/m,var/obj/s)
					if(s.active)
						m.trait_ga = null
					else
						m.trait_ga = s
						s.active = 1
		Ingenious_Conservation
			//Lower cost for tech items
			info = "You are meticulous with your measurements, conservative with your materials and productive with even the smallest amount of resources available to you. In this, there are none who can match your peerless, streamlined technology. With this trait, your technology items cost 25% less resources."
			info_name = "Ingenious_Conservation"
			act = /obj/traits/Ingenious_Conservation/proc/activate
			proc
				activate(var/mob/m,var/obj/s)
					if(s.active)
						m.trait_ic = null
					else
						m.trait_ic = s
						s.active = 1
		Iron_Grip
			//Much harder to break free from grip
			info = "Woe to all within your reach, grasped firmly in place by the might of your unnaturally strong grapple. Even the best counter moves or attacks don’t seem to loosen your grasp, allowing you more chances to utilize your advantage. With this trait, people who are grabbed have only a 25% chance to become loose if they land a hit."
			info_name = "Iron_Grip"
			act = /obj/traits/Iron_Grip/proc/activate
			proc
				activate(var/mob/m,var/obj/s)
					if(s.active)
						m.trait_ig = null
					else
						m.trait_ig = s
						s.active = 1
		Aerially_Dynamic
			//better at fighting in the air.
			info = "Your skill in flight is such that you cut through the air with a grace unmatched by most. Whilst suspending yourself via your own energy, you fight much more efficiently, darting around your foes and delivering aerial doom. With this trait, you gain a +10% bonus to your offence and defence while in flight."
			info_name = "Aerially_Dynamic"
			act = /obj/traits/Aerially_Dynamic/proc/activate
			proc
				activate(var/mob/m,var/obj/s)
					if(s.active)
						m.better = null
						//if(m.skill_flight && m.skill_flight.active)
					else
						m.better = "air"
						if(m.skill_flight && m.skill_flight.active)
							s.active = 1
		Firm_Footing
			//better at fighting on the ground
			info = "Nobody can dislodge your fortified stance whilst you remain firmly planted on the ground. You’ve mastered the art of ground-based combat, making a mockery of those foolish enough to battle you on your preferred turf. With this trait, you gain a +10% bonus to your offence and defence while fighting on the ground."
			info_name = "Firm_Footing"
			act = /obj/traits/Firm_Footing/proc/activate
			proc
				activate(var/mob/m,var/obj/s)
					if(s.active)
						m.better = null
						if(!m.skill_flight || m.skill_flight && m.skill_flight.active == 0)
							m.mod_offence/=1.1
							m.mod_defence/=1.1
					else
						m.better = "ground"
						if(!m.skill_flight || m.skill_flight && m.skill_flight.active == 0)
							m.mod_offence*=1.1
							m.mod_defence*=1.1
							s.active = 1
		/*
		Mercurial_Rage
			//quicker anger cd recovery
			info = "You like to get angry, it feeds and sustains you. You beyond all are able to harness your own emotions, turning them into a powerful tool to use against your foes and smite them down with furious vengeance.  With this trait, the cooldown between anger power boosts is decreased."
			act = /obj/traits/Mercurial_Rage/proc/activate
			proc
				activate(var/mob/m,var/obj/s)
					if(s.active)
						m.trait_mr = null
					else
						m.trait_mr = s
		Perpetual_Anger
			//Higher max anger
			info = "Your preferred state of existence seems to be a constant state of tension, perpetual rage jailed with barely contained caution just beneath the surface of your psyche. The limits of your emotions are much higher than others and when you unleash them upon your foes, the potency is much refined. With this trait, your maximum anger is increased by 25%"
			act = /obj/traits/Perpetual_Anger/proc/activate
			proc
				activate(var/mob/m,var/obj/s)
					if(s.active)
						m.mod_anger/=1.2
					else
						m.mod_anger*=1.2
		*/
		Herculean_Might
			//Bonus to weight lifting minigame,lets you lift heavier objects. Also lets you move bolted items.
			info = "You lift, even more so than others. The weight of an object doesn’t really seem to be an issue for your body. Your muscles adapt quickly, granting you better gains when trying to increase your raw strength. Furthermore, anything bolted to the floor, doesn’t remain that way for long once you summon your full might."
			info_name = "Herculean_Might"
			act = /obj/traits/Herculean_Might/proc/activate
			proc
				activate(var/mob/m,var/obj/s)
					if(s.active)
						m.trait_hm = null
					else
						m.trait_hm = s
						s.active = 1
		Inconceivable_Psyche
			//bonus to telekenis minigame, helps you lift heavier objects. Also lets you move bolted items.
			info = "Your mind is of steel and iron, not mere flesh and blood. Telekinesis is so effortless that even huge objects far beyond your physical ability to handle, become like putty in your hands, or mind in this case. You’re even so potent as to tear and rip up objects which are bolted to the ground; such is your power."
			info_name = "Inconceivable_Psyche"
			act = /obj/traits/Inconceivable_Psyche/proc/activate
			proc
				activate(var/mob/m,var/obj/s)
					if(s.active)
						m.trait_ip = null
					else
						m.trait_ip = s
						s.active = 1
		Phenomenal_Throw
			//Lets you throw objects much much further than others and maybe do more damage when it hits something?
			info = "Even the strongest of your species are unable to match the sheer velocity and power of your throws. Whip-like nerves and tendons of steel grant you the strength of force to toss an object far beyond what would be considered exceptional. With this trait, the distance of thrown objects is doubled for you."
			info_name = "Phenomenal_Throw"
			act = /obj/traits/Phenomenal_Throw/proc/activate
			proc
				activate(var/mob/m,var/obj/s)
					if(s.active)
						m.trait_pt = null
					else
						m.trait_pt = s
						s.active = 1
		//Energy_Nexus
			//Lightning strikes empower you for a time, giving you a buff. Maybe remove this and give it as a racial to the beastial race?
		Unyielding_Fortitude
			//Temperature no longer harms you as much, or at all.
			info = "The elements are yours to ignore! Cold and heat are unable to phase you, letting you train your endurance much easier than before. Most others would've frozen to death or baked in the heat of the sun, but you embrace these challenges and overcome them for the betterment of your overall health. With this trait, natural environmental effects no longer harm you."
			info_name = "Unyielding_Fortitude"
			act = /obj/traits/Unyielding_Fortitude/proc/activate
			proc
				activate(var/mob/m,var/obj/s)
					if(s.active)
						m.trait_uf = null
					else
						m.trait_uf = s
						s.active = 1
		Osmotic_Expertise
			//Splits and followers can use fly, super speed and some force skills
			info = "Your skill at creating Psionic clones of yourself is now peerless. Through means of an indescribable process, likened to both organic and gradual or unconscious assimilation of ideas and knowledge, your clones inherit much of your skill. With this trait, Psi clones are able to fly, use super speed and a limited number of energy attacks, so long as you yourself have them unlocked too."
			info_name = "Osmotic_Expertise"
			act = /obj/traits/Osmotic_Expertise/proc/activate
			proc
				activate(var/mob/m,var/obj/s)
					if(s.active)
						m.trait_aa = null
					else
						m.trait_aa = s
						s.active = 1
		Cognitive_Entanglement
			//Splits and followers can help with research
			info = "With this trait unlocked, you're able to passively link your mind on a quantum level to those who follow you. Each time you study, your followers are able to assist you with your work, pooling their own cognitive power and bolstering your own. For each follower you have who aids you, you gain +10% toward your studying."
			info_name = "Cognitive_Entanglement"
			act = /obj/traits/Cognitive_Entanglement/proc/activate
			proc
				activate(var/mob/m,var/obj/s)
					if(s.active)
						m.trait_aa = null
					else
						m.trait_aa = s
						s.active = 1
		Abnormal_Absorption
			//Absorb energy from attacks.
			info = "Somehow, you’re able to take the kinetic or psionic energy from an attack and absorb it into yourself, bolstering your own energy reserves. If an opponent isn’t careful or purely unlucky, they could see their own abilities becoming the very reason behind their defeat. "
			info_name = "Abnormal_Absorption"
			act = /obj/traits/Abnormal_Absorption/proc/activate
			proc
				activate(var/mob/m,var/obj/s)
					if(s.active)
						m.trait_aa = null
					else
						m.trait_aa = s
						s.active = 1
		//Unstoppable_Momentum
			//Fly through objects to destroy them and create lots of dust.
			//info = "You’re an unstoppable juggernaut and none shall bar your path! Flying into objects is more than likely going to end in that items immediate and total destruction. You’re also able to barge into and past others with some effort, sending them flying aside."

		Critical_Injury
			//Small chance for a critical strike on an enemy.
			info = " You hit with such puncturing force that any known material or mental defense fails to protect against such a terrifying onslaught. With a little effort, every few attacks you’re able to summon abnormal power and unleash it against a foe. With this trait, your attacks have a 25% chance to critically strike."
			info_name = "Critical_Injury"
			act = /obj/traits/Critical_Injury/proc/activate
			proc
				activate(var/mob/m,var/obj/s)
					if(s.active)
						m.trait_ci = null
					else
						m.trait_ci = s
						s.active = 1
		Corporeal_Negation
			//Small chance to ignore the damage of a melee attack or energy blast.
			info = "Such is your toughness that you’re sometimes able to shake off attacks of a lesser degree. Your foes will soon learn that their petty attempts are for naught as you stand amongst a legion and weather the storm like an unmoving stone washed over by the tide; indomitable and steadfast. With this trait, there's a 10% chance melee and energy attacks will be ignored. "
			info_name = "Corporeal_Negation"
			act = /obj/traits/Corporeal_Negation/proc/activate
			proc
				activate(var/mob/m,var/obj/s)
					if(s.active)
						m.trait_cn = null
					else
						m.trait_cn = s
						s.active = 1
		//Deathless
			//Regenerate after death
			//info = ""

		//Essence_Consumption
			//Absorb the body of another and gain their power in anger.
			//info = "Practice the unthinkable, then go one step beyond and not only devour the physical attributes of your enemies, but their psionic forces too. For every foe vanquished, gorge upon their meek forms. Individually they are but morsels, but with enough consumption even the weak may empower the strong. With this trait, you can consume unconscious enemies. "

		//Bioelectrical_Battery
			//Lets you automatically power one piece of machinery near by.
			//info = "Your psionic powers emanate forth in cascading waves, giving life to the lifeless. Machines and technological wonders alike swirl into action at your mere presence, the electromagnetic field which surrounds you lending its strength to their internal mechanisms. "
		//Precognition
			//Ability to deflect or dodge ranged attacks automatically.
			//info = "You are granted sight beyond sight, vision through space and time. These flashes of what will come to pass, although limited and fleeting, aid you in times of danger and need. With this trait, enemy ranged attacks have a 50% chance to be dodged automatically."

		//Pacifist
			 //increased intelligence gains, reduced damage, endurance,etc.
			//info = "You do not like fighting. It is an evolutionary dead end and lends nothing to the pursuits of order, knowledge or peace as far as you’re concerned. You may have neglected training, but your intelligence gains a +1 bonus while you lose 10% to your strength and endurance."
		/*
		Fervent_Fury
			info = "When you become angry, you become a killing machine. Not only can you control your rage, but it enchances your powers further than others. With much practice, you no longer succumb to a red haze, but instead harness your full potential when full of anger. With this trait, gain +20% to all your stats while angry."
			act = /obj/traits/Fervent_Fury/proc/activate
			proc
				activate(var/mob/m,var/obj/s)
					if(s.active)
						m.trait_ff = null
					else
						m.trait_ff = s
		*/
mob
	var
		obj/trait_ironbody
		obj/trait_prodigy
		obj/trait_wos
		obj/trait_pa
		obj/trait_ef
		obj/trait_mr
		obj/trait_pt
		obj/trait_uf
		obj/trait_aa
		obj/trait_ci
		obj/trait_cn
		obj/trait_ig
		obj/trait_hm
		obj/trait_ta
		obj/trait_ff
		obj/trait_ic
		obj/trait_ga
		obj/trait_ip
		obj/trait_ur
		obj/trait_u