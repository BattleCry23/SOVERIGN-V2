mob
	proc
		ranks(var/r)
			/*
			Arbiter
			 - Like Kaioshin, ultimate figure in the psi realms for the good guys. Always a Celestial.
			 - Gets Revive and Reformation, and unlock potential.
			 - Gets all bodyparts right away and 20 lvls in each.
			 - When people speak their name, no matter where, they hear it.
			 */
			if(r == "Arbiter")
				if(!locate(/obj/skills/Germination) in src)
					new /obj/skills/Germination(src)
				if(!locate(/obj/skills/Restoration) in src)
					new /obj/skills/Restoration(src)
				if(!locate(/obj/skills/Reincarnation) in src)
					new /obj/skills/Reincarnation(src)
				if(!locate(/obj/skills/Ressurect) in src)
					new /obj/skills/Ressurect(src)
				if(!locate(/obj/skills/Flight) in src)
					new /obj/skills/Flight(src)
				if(!locate(/obj/skills/Astral_Projection) in src)
					new /obj/skills/Astral_Projection(src)
				if(!locate(/obj/skills/Blast) in src)
					new /obj/skills/Blast(src)
				if(!locate(/obj/skills/Telepathy) in src)
					new /obj/skills/Telepathy(src)
				if(!locate(/obj/skills/Sense) in src)
					new /obj/skills/Sense(src)
				if(!locate(/obj/skills/Focus) in src)
					new /obj/skills/Focus(src)
				if(!locate(/obj/skills/Remote_Viewing) in src)
					new /obj/skills/Remote_Viewing(src)
				if(!locate(/obj/skills/Teleportation) in src)
					new /obj/skills/Teleportation(src)
				if(!locate(/obj/skills/Telekinesis) in src)
					new /obj/skills/Telekinesis(src)
				if(!locate(/obj/skills/Charge) in src)
					new /obj/skills/Charge(src)
				if(!locate(/obj/skills/Beam) in src)
					new /obj/skills/Beam(src)
				if(!locate(/obj/skills/Divine_Infusion) in src)
					new /obj/skills/Divine_Infusion(src)
				sleep(0.1)
				src.age_soul = 14000
				src.divine_energy += 500*src.divine_energy_mod
				sleep(0.1)
				src.lvl_typesof_bodypart(list("Muscle","Bone","Organ"),2000)
				return
			 /*
			 Imperator
			 	- Basically north kaio, the Arbiters main warrior and commander in matters of war
			 	- Gets a special kaioken-style technique.
			 */
			if(r == "Imperator")
				return
			 /*
			Judicator
			 - Judge, helps direct the flow of souls.
			 - Gets Reformation, Give body.
			 */
			if(r == "Judicator")
				return
			 /*
			 Demon Lord
			 - Like Zarth, ultimate figure in psi realms for the bad guys. Always a Demon.
			 - Gets Revive and Reformation, Give body and unlock potential.
			 - Gets all bodyparts right away and 10 lvls in each.
			 - When people speak their name, no matter where, they hear it.
			 */
			if(r == "Demon Lord")
				return
			 /*
			 Chronicler - Always an Imp, likes to keep notes and tabs on everyone and everything.
			 - Can banish supernatural beings back to the psi realms
			 - Gets Banish, Bind.
			 */
			if(r == "Chronicler")
				return
			/*
			Yukopian Elder - Leader of the Yukopians, helps keep peace on the planet.
			*/
			if(r == "Yukopian Elder")
				return