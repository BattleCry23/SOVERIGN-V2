obj/overlay/hairs/superform
	name = "Super Saiyan"
	plane = HAIR_LAYER
	ID = 6


	ssj
		name = "ssj hair"
		starteffect()
			if(!container.ssjhair)
				icon = container.hair
				color_overlay(container.ssjhair, "#FFF27A")
			else
				icon = container.ssjhair
			..()

	ussj
		name = "ussj hair"
		starteffect()
			icon = container.assjhair
			..()

	ssjfp
		name = "mastered ssj hair"
		starteffect()
			icon = container.ssjhair
			color_overlay(icon, "#C0C0C0")
			..()

	ssj2
		name = "ssj2 hair"
		starteffect()
			icon = container.ssj2hair
			..()

	ssj3
		name = "ssj3 hair"
		starteffect()
			icon = container.ssj3hair
			..()

/*ssj4
	name = "ssj4 hair"
	EffectStarter()
		icon = container.ssj4hair
		..()*/

	rlssjhair
		name = "restrained lssjhair"
		starteffect()
			color_overlay(container.hair, "#0000FF")
			..()

	lssjhair
		name = "legendary super saiyan hair"
		starteffect()
			if(!container.ssjhair)
				icon = container.hair
				desaturate_overlay(icon, "black")
				spawn(1) color_overlay(icon, "#caf27f")
			else
				icon = container.ssjhair
				desaturate_overlay(icon, "black")
				spawn(1) color_overlay(icon, "#caf27f")
			..()

	fssjhair
		name = "Omen SSJ Hair"
		starteffect()
			icon = container.ssjhair
			desaturate_overlay(icon, "black")
			//icon += filter(type="color", color="#0b0a0a")
			..()



/*mob/proc/Applyhair()
	if(!transformed)
		updateOverlay(/obj/overlay/hairs/hair)
	switch(ssjform)
		if(1)
			if(ssjdrain<=0.010)
				sleep updateOverlay(/obj/overlay/hairs/ssj/ssj1fp)
			else
				sleep updateOverlay(/obj/overlay/hairs/ssj/ssj1)
		if(1.5)
			sleep updateOverlay(/obj/overlay/hairs/ssj/ussj)
		if(2)
			sleep updateOverlay(/obj/overlay/hairs/ssj/ssj2)
		if(3)
			sleep updateOverlay(/obj/overlay/hairs/ssj/ssj3)
		if(4)
			sleep updateOverlay(/obj/overlay/hairs/ssj/ssj4)
	switch(lssj)
		if(1)
			sleep updateOverlay(/obj/overlay/hairs/ssj/rlssjhair,hair,0,0,100)
		if(2)
			sleep updateOverlay(/obj/overlay/hairs/ssj/ssj1,ssjhair)
		if(3)
			sleep updateOverlay(/obj/overlay/hairs/ssj/lssjhair,ussjhair,0,100,0)*/
