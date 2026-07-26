obj/overlay/auras
	layer = AURA_LAYER
	name = "aura"
	temporary = 1
	appearance_flags = PIXEL_SCALE
	vis_flags = VIS_INHERIT_PLANE | VIS_INHERIT_LAYER
	ID = 5
	transform = null
	var
		setNJ
		presetAura
		centered
		lastSSJ
		scale = list(1,1) // MULTIPLICITIVE- a value of 2, 3, would turn a 32 by 32 icon into a 64x96 icon.
		prevscale = list(1,1)
		centy = 0
		lastpowermod
		storedicon
		setSSJ
		tmp/limiter = 4

var/const
	SSJ_COLOR = "#FFFF00"
	LSSJ_COLOR = "#00FF00"
	SSJ_MASTERED_COLOR = "#C0C0C0"

mob
    var
        Over = 1
        setAuracenter
        falseformaura = 'GijiAura.dmi'
        form1aura = 'SSJ1AuraNew.dmi'
        formussjaura = 'SSJ1AuraNew.dmi'
        form2aura = 'SSJ1AuraNew.dmi'
        form3aura = 'SSJ1AuraNew.dmi'
        form4aura = 'SSJ1AuraNew.dmi'
        aurabuffed = 0
        icon/AURA = 'ShadowsAura.dmi'


/*obj/overlay/auras/proc/centerAura() // todo: convert to matrixes
	var/icon/A = icon(icon)
	var/pixelList = list(0,0)
	var/iconwidth = A.Width()
	var/iconheight = A.Height()
	if(container.Over) layer = AURA_LAYER
	else layer = UNDERAURA_LAYER
	if(!lastpowermod) lastpowermod = 1
	var/image/I = image(A)
	I.transform = src.transform
	if(container.setAuracenter) pixelList = I.center(container.setAuracenter)
	else pixelList = I.center("center-bottom")
	A = I
	icon = A
	if(pixelList)
		centered = 1
		var/offset_x = (iconwidth - 32) / 2
		var/offset_y = iconheight - 32
		pixel_x = container.pixel_x - offset_x
		pixel_y = container.pixel_y - offset_y
		centy = container.pixel_y - offset_y
		container.overlayupdate = 1

obj/overlay/auras/proc/ScaleAura()
	var/scalewidth = 1
	var/scaleheight = 1
	if(scale[1] && scale[2] && lastpowermod) // matrix scaling is focused on the icon's center already
		scalewidth = round((((1.4 ** (scale[1] * lastpowermod)) / 8 ) + 0.825),0.25)
		scaleheight = round((((1.4 ** (scale[1] * lastpowermod)) / 8 ) + 0.825),0.25)
		prevscale = scale
	var/matrix/nM = new
	nM.Scale(scalewidth,scaleheight) // even though we want the scaling to be center-bottom (or whatever the person set it to be)
	animate(src,transform=nM,time=5)
	container.overlayupdate = 1

obj/overlay/auras/EffectStarter()
	if(icon)
		presetAura = 1
		storedicon = icon
	centerAura()
	..()*/

obj/overlay/auras/proc/ScaleAura()
	var/scalewidth = 1
	var/scaleheight = 1
	if(scale[1] && scale[2] && lastpowermod) // matrix scaling is focused on the icon's center already
		scalewidth = round((((1.4 ** (scale[1] * lastpowermod)) / 8 ) + 0.825),0.25)
		scaleheight = round((((1.4 ** (scale[2] * lastpowermod)) / 8 ) + 0.825),0.25)
		prevscale = scale
	var/matrix/nM = new
	nM.Scale(scalewidth,scaleheight) // even though we want the scaling to be center-bottom (or whatever the person set it to be)
	animate(src,transform=nM,time=5)
	sync_overlays(src, container.AURA)

obj/overlay/auras/proc/UpdatePowerScale()
	if(!container || lastpowermod == container.power_percent) return
	if(limiter <= 0 && prob(25))
		limiter = 4
		lastpowermod = container.power_percent
		ScaleAura()
	else limiter--

obj/overlay/auras/proc/UpdateFormAura()
	if(!container || container.aurabuffed) return
	if((container.superform> 0 && lastSSJ != container.superform) || (container.LSSJ > 0 && container.LSSJ != lastSSJ))
		ApplyFormSettings()

obj/overlay/auras/proc/ApplyFormSettings()
	setSSJ = 1
	setNJ = 0
	storedicon = null
	
	if(container.superform)
		lastSSJ = container.superform
		icon = container.AURA
		container.auracolor = SSJ_COLOR
		color_overlay(icon, container.auracolor, blend_mode="multiply", filter = container.auracolor)
		
		switch(container.superform)
			if(1)
				if(container.ssj_mastery < 100)
					replace_overlay(icon, container.form1aura, "SSJ")
					//icon_state = "SSJ"
					scale = list(1,1)
				else
					container.auracolor = SSJ_COLOR
					scale = list(1,1)
					color_overlay(icon, container.auracolor, blend_mode="multiply", filter = container.auracolor)
			if(1.5)
				icon_state = "Big"
				scale = list(1.25, 1)
			if(2)
				icon_state = "Big"
				scale = list(1, 1.25)
			if(3)
				icon_state = "Big"
				scale = list(1.25, 1.5)
		color_overlay(icon, container.auracolor, blend_mode="multiply", filter = container.auracolor)

	else if(container.LSSJ)
		lastSSJ = container.LSSJ
		icon = container.AURA
		container.auracolor = LSSJ_COLOR
		icon += filter(type="color", color=LSSJ_COLOR)
		
		switch(container.LSSJ)
			if(1)
				scale = list(1, 1)
			if(2)
				scale = list(1, 1.25)
			if(3)
				scale = list(1.25, 1.5)
	
	//centerAura()

obj/overlay/auras/proc/ResetToNormalAura()
	if(!container || setNJ || container.superform || container.LSSJ) return
	
	lastSSJ = 0
	setNJ = 1
	scale = list(1, 1)
	setSSJ = 0
	icon = container.AURA
	storedicon = null
	//centerAura()

obj/overlay/auras/effectloop()
	if(!presetAura)
		UpdatePowerScale()
		
		if(!icon)
			icon = container.AURA
			//centerAura()
		
		UpdateFormAura()
		ResetToNormalAura()

obj/overlay/auras/kaioken
	icon = 'KaiokenSov.dmi'
	layer = AURA_LAYER
	appearance_flags = KEEP_TOGETHER | PIXEL_SCALE
	presetAura = TRUE
	pixel_x=-16
	pixel_y=-4


obj/overlay/auras/regular_aura
	name = "Regular Aura"
	icon = 'ShadowsAura.dmi'
	pixel_x = -40
	pixel_y = -8

	starteffect()
		scale = list(1,1)
		//centerAura("center")
		..()