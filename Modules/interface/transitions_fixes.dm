mob/proc/convert_inventory_minerals()

    for(var/sl=1, sl<49, sl++)
        var/obj/items/I = src.inv[sl]
        if(!I) continue

        if(istype(I, /obj/items/minerals))
            var/amount = I.stacks
            if(!amount) amount = 1

            if(istype(I, /obj/items/minerals/Stone))
                stone_count += amount

            else if(istype(I, /obj/items/minerals/Silver))
                silver_count += amount

            else if(istype(I, /obj/items/minerals/Copper))
                copper_count += amount

            else if(istype(I, /obj/items/minerals/Coal))
                coal_count += amount

            else if(istype(I, /obj/items/minerals/Gold))
                gold_count += amount

            else if(istype(I, /obj/items/minerals/Mystille))
                mystille_count += amount

            else if(istype(I, /obj/items/minerals/Titanium))
                titanium_count += amount

            del(I)
            src.inv[sl] = null

    src.refresh_inv()


obj/hud/mineral_icon
	plane = 30
	layer = 35
	mouse_opacity = 2
	appearance_flags = KEEP_TOGETHER | PIXEL_SCALE

	var/mineral_type

	Click(location,control,params)
		if(!usr) return

		var/mob/m = usr

		var/amount = input(m,"Drop how many?") as num

		if(amount <= 0) return

		switch(mineral_type)

			if("stone")
				if(amount > m.stone_count) return
				m.stone_count -= amount
				m.spawn_mineral(/obj/items/minerals/Stone,amount)

			if("silver")
				if(amount > m.silver_count) return
				m.silver_count -= amount
				m.spawn_mineral(/obj/items/minerals/Silver,amount)

			if("copper")
				if(amount > m.copper_count) return
				m.copper_count -= amount
				m.spawn_mineral(/obj/items/minerals/Copper,amount)

			if("coal")
				if(amount > m.coal_count) return
				m.coal_count -= amount
				m.spawn_mineral(/obj/items/minerals/Coal,amount)

			if("gold")
				if(amount > m.gold_count) return
				m.gold_count -= amount
				m.spawn_mineral(/obj/items/minerals/Gold,amount)

			if("mystille")
				if(amount > m.mystille_count) return
				m.mystille_count -= amount
				m.spawn_mineral(/obj/items/minerals/Mystille,amount)

			if("titanium")
				if(amount > m.titanium_count) return
				m.titanium_count -= amount
				m.spawn_mineral(/obj/items/minerals/Titanium,amount)

		m.refresh_inv()

mob/proc/spawn_mineral(type,amount)

    var/obj/items/minerals/M = new type
    M.stacks = amount

    M.loc = src.loc
    M.step_x = src.step_x
    M.step_y = src.step_y

    view(src) << output("[src] drops x[amount] [M]","actionoutput")