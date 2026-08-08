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

proc/Load_objs()
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