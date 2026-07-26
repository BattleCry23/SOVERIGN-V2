//this essentials handles how hair overlays work, the previous version handled hair overlays as a single overlay that changed its icon and color, but this version handles each hair as a separate overlay, which allows for more customization and less issues with things like the ssj hair not updating properly when changing colors or something like that. It also allows for things like the ssj2 hair to be added without needing to change the ssj1 hair's icon or color, which is something that was an issue with the previous version. It also allows for things like the ssj3 hair to be added without needing to change the ssj1 or ssj2 hair's icon or color, which is something that was an issue with the previous version. It also allows for things like the ssj4 hair to be added without needing to change the ssj1, ssj2, or ssj3 hair's icon or color, which is something that was an issue with the previous version. It also allows for things like the lssj hair to be added without needing to change the ssj1, ssj2, ssj3, or ssj4 hair's icon or color, which is something that was an issue with the previous version. It also allows for things like the rlssj hair to be added without needing to change the ssj1, ssj2, ssj3, ssj4, or lssj hair's icon or color, which is something that was an issue with the previous version. It also allows for things like the ussj hair to be added without needing to change the ssj1, ssj2, ssj3, ssj4, lssj, or rlssj hair's icon or color, which is something that was an issue with the previous version. It also allows for things like the mastered ssj1 hair to be added without needing to change the ssj1, ssj2, ssj3, ssj4, lssj, rlssj, or ussj hair's icon or color, which is something that was an issue with the previous version.
obj/overlay/hairs
	//plane = HAIR_LAYER
	layer = HAIR_LAYER
	appearance_flags = PIXEL_SCALE
	vis_flags = VIS_INHERIT_PLANE | VIS_INHERIT_LAYER
	name = "hair"
	transform = null
	ID = 3
	var
		tmp/gdkid = 0
		prevgdki = 0//this is for hair changes pretaining to future use of godki, but it can also be used for other things like the ssj2 hair or something like that if I decide to add it in the future.

		rssjed = 0
		lssjed = 0
		wrathed = 0//this is for wrathful state, the plan is to use the ssj hairs but turn it black sort of like Giji.

		list/added_color = list(0,0,0)
		list/prev_color = list(0,0,0)

	proc/applyrssj()
		rssjed = 1

	proc/removerssj()
		rssjed = 0

	proc/applylssj()
		lssjed = 1

	proc/removelssj()
		lssjed = 0

	proc/gdki_me()
		gdkid = 1

	proc/ungdki_me()
		gdkid = 0

	proc/update_color()
		icon -= rgb(prev_color[1],prev_color[2],prev_color[3])
		icon += rgb(added_color[1],added_color[2],added_color[3])

	proc/activate_proc()
		return
	
	proc/deactivate_proc()
		return

	proc/toggle_form(form_type, var/active, var/activate_proc, var/deactivate_proc, var/state_var)
		if(active)
			if(!state_var)
				state_var = 1
				call(src, activate_proc)()
				update_color()
		else
			if(state_var)
				state_var = 0
				call(src, deactivate_proc)()
	
	EffectorLoop()
		alpha = container.oozaru_form ? 1 : 255
		
		toggle_form("rssj", container.rssj_form, /obj/overlay/hairs/proc/applyrssj, /obj/overlay/hairs/proc/removerssj, rssjed)
		toggle_form("lssj", container.lssj_form, /obj/overlay/hairs/proc/applylssj, /obj/overlay/hairs/proc/removelssj, lssjed)

		EffectStarter()
	..()

	EffectStarter()
		.=..()
		if(!rssjed)
			rssjed = 1
			applyrssj()
			color_overlay(icon, SSJ_COLOR)

		if(!lssjed)
			lssjed = 1
			applylssj()
			update_color()