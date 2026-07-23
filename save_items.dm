obj/var/savedX = 0
obj/var/savedY = 0
obj/var/savedZ = 0
atom/var/insideplanet = 0

world
    proc
        Save_Planets()
            set background = 1
            for(var/obj/items/Planets/Unknown_Planet/P in custom_planets)
                P.Save_Planet_Objects()
                sleep(1)


world
	proc
		Load_Server()
			//Wipe all the default map items so the saved ones can be loaded in sucessfully without duping.
			for(var/obj/items/I in world)
				if(isturf(I.loc))
					del(I)
		Save_objs()
			set background =1
			var/savefile/S = new("saves/world/items.sav")
			for(var/obj/o in items)
				if(o.loc && isturf(o.loc))
					o.savedX = o.x
					o.savedY = o.y
					o.savedZ = o.z
					//o.filters = null
					//if(istype(o,/obj/items/Planets/Unknown_Planet)) o.particles = null
					o.loc = null
					sleep(1)
					//o.cleanse_all_vars()

					//o.cleanse_all_vars()
			for(var/obj/items/Planets/p in custom_planets)
				if(p) custom_planets -= p
				p.savedX = p.x
				p.savedY = p.y
				p.savedZ = p.z
				custom_planets += p

			S["ITEMS"] << items
			S["VINES"] << vines
			S["PLANETS"] << custom_planets
			for(var/obj/o in items)
				if(o.savedX && o.loc == null) o.loc = locate(o.savedX,o.savedY,o.savedZ)
				else items -= o

		Load_objs()
			if(fexists("saves/world/items.sav"))
				var/savefile/S = new("saves/world/items.sav")
				if(S["ITEMS"]) S["ITEMS"] >> items
				if(S["VINES"]) S["VINES"] >> vines
				if(S["PLANETS"]) S["PLANETS"] >> custom_planets
				for(var/obj/o in items)
					o.loc = locate(o.savedX,o.savedY,o.savedZ)
					if(o.act_load) call(o.act_load)(o)
				for(var/obj/items/Planets/p in custom_planets)
					if(p.savedX) p.loc = locate(p.savedX, p.savedY, p.savedZ)
				//	if(p.act_load) call(p.act_load)(p)