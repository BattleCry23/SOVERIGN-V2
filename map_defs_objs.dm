turf/buildables/walls
	wall = 1
turf/buildables/roofs
	wall = 1
obj
	bannedbackground
		icon = 'bannedbackground.dmi'
		screen_loc = "1,1"
		plane = 99
		layer=20

		//blend_mode = BLEND_OVERLAY
		//layer = 1.9
		appearance_flags = TILE_BOUND
		mouse_opacity = 0
	accessdeniedbackground
		icon = 'accessdeniedbackground.dmi'
		screen_loc = "1,1"
		plane = -2
		//blend_mode = BLEND_OVERLAY
		//layer = 1.9
		appearance_flags = TILE_BOUND
		mouse_opacity = 0
obj/Special
	KorinTower
		icon='KorinsTileset.dmi'

		BLeft
			icon_state="BLeft"
			density=1
			density_factor = 1
		BRight
			icon_state="BRight"
			density=1
			density_factor = 1
		BMiddle
			icon_state="BMiddle"
			density=1
			density_factor = 1
		BMiddle2
			icon_state="BMiddle2"
			density=1
			density_factor = 1
		BMiddle3
			icon_state="BMiddle3"
			density_factor = 1
	HBTC
		Red_Pillow
			icon = 'HBTC_RedP.dmi'
			density=1
			density_factor=1
			layer=10
		Blue_Pillow
			icon = 'HBTC_BlueP.dmi'
			density=1
			density_factor=1
			layer=10
		Chamber
			icon = 'HBTC_Chamber2.dmi'
			layer=12

turf
	HBTC
		Large_Floor
			icon = 'HBTC_Floors.dmi'
			layer=1
			appearance_flags = TILE_BOUND
			mouse_opacity = 0
		Medium_Floor
			icon = 'HBTC_Floortiles.dmi'
			layer=1
			appearance_flags = TILE_BOUND
			mouse_opacity = 0
		Blue_Tile
			icon = 'HBTC_FloorBlue.dmi'
		White_Tile
			icon = 'HBTC_FloorWhite.dmi'

obj
	map
		waterfalls
			top
				icon = 'waterfall.dmi'
				icon_state = "top"
			middle
				icon = 'waterfall.dmi'
				icon_state = "middle"
			bottom
				icon = 'waterfall.dmi'
				icon_state = "bottom"
				pixel_y = 6;
			left
				icon = 'waterfall.dmi'
				icon_state = "left"
				pixel_y = 6;
			right
				icon = 'waterfall.dmi'
				icon_state = "right"
				pixel_y = 6;
		cliffs
			icon = 'cliffs.dmi'
			density_factor = 1

			c1
				icon_state = "1"
			c2
				icon_state = "2"
			c3
				icon_state = "3"
			c4
				icon_state = "4"
				bounds = "1,1 to 32,28"
			c5
				icon_state = "5"
				bounds = "1,1 to 32,28"
			c6
				icon_state = "6"
				bounds = "1,1 to 32,28"
			c7
				icon_state = "7"
				bounds = "1,1 to 2,32"
			c8
				icon_state = "8"
				bounds = "30,1 to 32,32"
			c9
				icon_state = "9"
			c10
				icon_state = "10"
				bounds = "1,26 to 32,32"
			c11
				icon_state = "11"
			c12
				icon_state = "12"
			c13
				icon_state = "13"
				bounds = "30,1 to 32,26"
			c14
				icon_state = "14"
				bounds = "27,27 to 32,32"
			c15
				icon_state = "15"
				bounds = "1,27 to 6,32"
			c16
				icon_state = "16"
				bounds = "1,1 to 2,26"


/////////// FROM OLD SOVEREIGN


obj
	var
		P_BagG=1.00

obj/ShipStuff
	ShipInterior
		SpotLight
			pixel_x=-32
			icon='OpenShip.dmi'
			layer=1009
			alpha=250
			luminosity=1
			bolted = 2


			New()
				animate(src,src.alpha++,time=5)
				animate(src,src.alpha++,time=10)
				sleep(10)
				animate(src,src.alpha--,time=5)
				animate(src,src.alpha-=2,time=10)
				..()


		MetalFloor

			icon='metaltiles1.dmi'
			icon_state="metalfloora"
			layer=1
			bolted = 2

		Dark_Roof
			icon='tilesetship.dmi'
			icon_state="darkroof"
			density=1
			opacity=1
			layer=1
			bolted = 2
		BTile
			icon='tilesetship.dmi'
			icon_state="black"
			layer=1
			bolted = 2

		PTile
			icon='tilesetship.dmi'
			icon_state="purple"
			layer=1
			bolted = 2

		WTile2
			icon='tileset1.dmi'
			icon_state="tile3"
			layer=1
			bolted = 2

		Tech_Wall_5
			icon='Futuristic Sheet 1 Test.dmi'
			icon_state="Roof1"
			density=1
			luminosity=1
			layer=1
			density_factor = 1
			bolted = 2


turf

	TeleLeft
		Crossed(atom/o)
			if(ismob(o))
				var/mob/m = o
				if(m.icon_state=="KO") return
				m.loc=locate(m.x+477,m.y,m.z)


	TeleRight
		Crossed(atom/o)
			if(ismob(o))
				var/mob/m = o
				if(m.icon_state=="KO") return
				m.loc=locate(o.x-477,o.y,o.z)

	TeleUp
		Crossed(atom/o)
			if(ismob(o))
				var/mob/m = o
				if(m.icon_state=="KO") return
				m.loc=locate(o.x,o.y-477,o.z)

	TeleDown
		Crossed(atom/o)
			if(ismob(o))
				var/mob/m = o
				if(m.icon_state=="KO") return
				m.loc=locate(o.x,o.y+477,o.z)

area
	Inside //Placed where built things are, so it doesnt have weather inside.
area
	Outside //Outside, so it gets affected by weather.
	icon='atmosphere.dmi'
area
	Vegeta
		icon='atmosphere.dmi'
		icon_state=""
		layer=4
	Earth
		icon='atmosphere.dmi'
		icon_state=""
		layer=4
	Hell
		icon='atmosphere.dmi'
		icon_state=""
		layer=4
	Heaven
		icon='atmosphere.dmi'
		icon_state=""
		layer=4
	Namek
		icon='atmosphere.dmi'
		icon_state=""
		layer=4
	Icer
		icon='atmosphere.dmi'
		icon_state=""
		layer=4





var/builtobjects=0
mob/var/buildon
obj/var
	BUILDRES=1
	BUILDPASS
	BUILDOWNER
obj/buildables/var
	Base=1
	Res=1
turf/density
	density=1
	density_factor = 1
turf/Terrain/var
	Resistance=1
	Lava=0

	isbuilt

obj/buildables
	hp=200
	Furniture
		icon='furniture.dmi'


		shelf1
			icon_state="shelf1"
			density=1
		shelf2
			icon_state="shelf2"
			density=1
		sink
			icon_state="sink"
			density=1


	DBSet
		icon='tileset2.dmi'
		hp=99999999999999999999999


		path1
			icon_state="path1"
			bolted = 2
		path2
			icon_state="path2"
			bolted = 2

		path3
			icon_state="path3"
			bolted = 2
		path4
			icon_state="path4"
			bolted = 2
		path5
			icon_state="path5"
			bolted = 2
		path6
			icon_state="path6"
			bolted = 2
		glass1
			icon_state="glass1"
		techwall1
			icon_state="techwall1"
		stonewall1
			icon_state="stoneewall1"
		stonewall2
			icon_state="stoneewall2"
		stonewall3
			icon_state="stoneewall3"
		stonewall4
			icon_state="stoneewall4"
		stonewall5
			icon_state="stoneewall5"
		stonewall6
			icon_state="stoneewall6"
		roof1
			density=1
			opacity=1
			density_factor=2
			icon_state="roof1"
			bolted = 2
		roof2
			density=1
			opacity=1
			density_factor=2
			icon_state="roof2"
			bolted = 2

		roof3
			density=1
			opacity=1
			icon_state="roof3"
			bolted = 2
			density_factor=2
		roof4
			density=1
			opacity=1
			icon_state="roof4"
			bolted = 2
			density_factor=2
		roof5
			density=1
			opacity=1
			icon_state="roof5"
			bolted = 2
			density_factor=2
		roof6
			density=1
			opacity=1
			icon_state="roof6"
			bolted = 2
			density_factor=2
		ice1
			icon_state="ice1"
		icerock1
			icon_state="icerock1"
		icerock2
			icon_state="icerock2"


	tpalm
		icon='tree_palm.dmi'
		icon_state="1"
		layer=MOB_LAYER+10000
		density = 1
		bound_x=32
		bound_y=32
		Tree=1
		hp=999999999999999999999

	PineFuschiaTree
		icon='TreeWorld1.dmi'
		icon_state="T4"
		suffix="T4"
		layer=MOB_LAYER+10000
		density = 1
		bound_x=32
		bound_y=-16

		Tree=1
		hp=999999999999999999999

	PineYellowTree
		icon='TreeWorld1.dmi'
		icon_state="T3"
		suffix="T3"
		layer=MOB_LAYER+10000
		density = 1
		bound_x=32
		bound_y=-16

		Tree=1
		hp=999999999999999999999

	PineGreenTree
		icon='TreeWorld1.dmi'
		icon_state="T2"
		suffix="T2"
		layer=MOB_LAYER+10000
		density = 1
		bound_x=32
		bound_y=-16
		bound_width=16

		Tree=1
		hp=999999999999999999999

	BareOakTree
		icon='TreeWorld1.dmi'
		icon_state="T8"
		suffix="T8"
		layer=MOB_LAYER+10000
		density = 1
		bound_x=32
		bound_y=-16

		Tree=1
		hp=999999999999999999999

	BareTree
		icon='TreeWorld1.dmi'
		icon_state="T7"
		suffix="T7"
		layer=MOB_LAYER+10000
		density = 1
		bound_x=32
		bound_y=-16

		Tree=1
		hp=999999999999999999999

	BlackOak
		icon='TreeWorld1.dmi'
		icon_state="T6"
		suffix="T6"
		layer=MOB_LAYER+10000
		density = 1
		bound_x=32
		bound_y=-16

		Tree=1
		hp=999999999999999999999

	WhiteOak
		icon='TreeWorld1.dmi'
		icon_state="T5"
		suffix="T5"
		layer=MOB_LAYER+10000
		density = 1
		bound_x=32
		bound_y=-16

		Tree=1
		hp=999999999999999999999

	RedTree
		icon='TreeWorld1.dmi'
		icon_state="T11"
		suffix="T11"
		layer=MOB_LAYER+10000
		density = 1
		bound_x=32
		bound_y=-16

		Tree=1
		hp=999999999999999999999


	GreenTree
		icon='TreeWorld1.dmi'
		icon_state="T1"
		suffix="T1"
		layer=MOB_LAYER+10000
		density = 1
		bound_x=32
		bound_y=-16

		Tree=1
		hp=999999999999999999999

	FuschiaTree
		icon='TreeWorld1.dmi'
		icon_state="T12"
		suffix="T12"
		layer=MOB_LAYER+10000
		density = 1
		bound_x=32
		bound_y=-16

		Tree=1
		hp=999999999999999999999

	YellowTree
		icon='TreeWorld1.dmi'
		icon_state="T10"
		suffix="T10"
		layer=MOB_LAYER+10000
		density = 1
		bound_x=32
		bound_y=-16

		Tree=1
		hp=999999999999999999999

	WhiteTree
		icon='TreeWorld1.dmi'
		icon_state="T13"
		suffix="T13"
		layer=MOB_LAYER+10000
		density = 1
		bound_x=32
		bound_y=-16

		Tree=1
		hp=999999999999999999999

	Door
		icon='door.dmi'
		icon_state="closed"
		density=1
		opacity=1
		bolted = 2
		layer=3
		density_factor = 1
		Click()
			if(icon_state=="closed")
				flick("opening",src)
				density=0
				density_factor = 0
				opacity=0
				icon_state="open"
				sleep(300)
				flick("closing",src)
				density=1
				opacity=1
				density_factor = 1
				icon_state="closed"
		verb/Knock()
			set category=null
			set src in oview(1)
			oview(src)<<"**There is a knock at the door**"
	table
		icon='tileset1.dmi'
		icon_state="table1"
		layer=MOB_LAYER
		density=1
	grain1
		icon='build2.dmi'
		icon_state="grain1"
	Sign
		icon='tileset2.dmi'
		icon_state="sign1"
		density=1
		var/Message="<font color=#FF0000>Nothing is written on this sign..."
		Click() usr<<"[Message]"
		verb/ChangeMessage()
			set category=null
			set src in oview(1)
			Message=input("") as text
	Statue
		icon='build7.dmi'
		icon_state="97"
		density=1
		var/Words="<font color=#FF0000>Nothing is written on this statue..."
		Click() usr<<"[Words]"
		verb/ChangeWords()
			set category=null
			set src in oview(1)
			Words=input("") as text
	glass1
		icon='tileset2.dmi'
		icon_state="glass1"
		density=1
		layer=MOB_LAYER+1
	borderN
		icon='Misc.dmi'
		icon_state="N"
		density=1
	borderS
		icon='Misc.dmi'
		icon_state="S"
		density=1
	borderE
		icon='Misc.dmi'
		icon_state="E"
		density=1
	borderW
		icon='Misc.dmi'
		icon_state="W"
		density=1
	waterfall
		icon='build2.dmi'
		icon_state="waterfall"
		density=1
		layer=MOB_LAYER+1
	lightwaterfall
		icon='build2.dmi'
		icon_state="lightwaterfall"
		density=1
		layer=MOB_LAYER+1
	flowers
		icon='build2.dmi'
		icon_state="flowers"
	Stall
		icon='stall.dmi'
		density=1
	barrel
		icon='furnishings.dmi'
		icon_state="barrel"
		density=1
	Bigchair
		icon='bigchair.dmi'
	chair
		icon='tileset1.dmi'
		icon_state="chair1"
	KOVThrone
		icon='Vegeta_Throne.dmi'
		bound_x = 33
	HellF
		name = "Fountain of HFIL"
		icon='fountainofdespair.dmi'
		icon_state="full"
		bound_x = 32



	guru
		icon='Guru_House.dmi'
		density=1
		bound_x = 64
		bound_y = 32
		layer=MOB_LAYER+1
	HellT1
		icon='Hell_Tree.dmi'
		icon_state="HT1"
		density=1
		layer=MOB_LAYER+1
		bound_x = 24
		bound_y=24
		Tree=1
		hp=999999999999999999999

	HellT2
		icon='Hell_Tree.dmi'
		icon_state="HT2"
		density=1
		layer=MOB_LAYER+1
		bound_x = 24
		bound_y=24
		Tree=1
		hp=999999999999999999999

	Canyon1
		icon='Canyon_Objects.dmi'
		icon_state="Canyon 1"
		density=1
		layer=MOB_LAYER
		bound_x = 33
		pixel_y=-32
		pixel_x=-32
		Tree=1
	Canyon2
		icon='Canyon_Objects.dmi'
		icon_state="Canyon 2"
		density=1
		layer=MOB_LAYER
		bound_x = 33
		pixel_y=-32
		pixel_x=-32
		Tree=1
	Appletree
		//icon='AppleTree_1.dmi'
		icon_state="3"
		layer=MOB_LAYER
		density=1

		/*verb/Gather()
			var/getApple
			set category = "Other"
			set src in oview(1)
			var/obj/items/Food/Eatable/Apple/A=new
			usr.itemAdd(A)
			usr<<"You have gathered [getApple] Apples" */

	strangetree
		icon='build2.dmi'
		icon_state="smalltree"
		density=1
		bound_x=32
		bound_y=32
		Tree=1
		tree=1

	tree1
		icon='Tree.dmi'
		density=1
		layer=MOB_LAYER+1
		bound_x = -16
		bound_y=-16

		hp=100
		Base=1000
		Res=1000
		Tree=1
		tree=1



	tree2
		icon='Tree2.dmi'
		density=1
		layer=MOB_LAYER+1
		bound_x=-16
		bound_y=-16
		Tree=1
		tree=1

	trees3
		icon='mighttree.dmi'
		density=1
		bound_x=32
		bound_y=32
		Tree=1
		tree=1
	smallcouch
		icon='tileset3.dmi'
		icon_state="couch_small"

	JellyBeans
		icon='JellyBeans.dmi'
		density=1
		Red_Bean
			Tree=1
			P_BagG=1.00
			icon_state="red"
			hp=100
		Yellow_Bean
			Tree=1
			P_BagG=1
			icon_state="yellow"
			hp=200
		Purple_Bean
			Tree=1
			P_BagG=1
			icon_state="purple"
			hp=300
		Blue_Bean
			Tree=1
			P_BagG=1
			icon_state="blue"
			hp=400
		Green_Bean
			Tree=1
			P_BagG=1
			icon_state="green"
			hp=500
	Torch1
		icon='build7.dmi'
		icon_state="83"
		density=1
		layer=MOB_LAYER

	Torch2
		icon='build7.dmi'
		icon_state="82"
		density=1
		layer=MOB_LAYER

	Chest
		icon='furnishings.dmi'
		icon_state="chest"
		layer=MOB_LAYER

	Bag
		icon='furnishings.dmi'
		icon_state="bag"
		layer=MOB_LAYER

	book
		icon='furnishings.dmi'
		icon_state="book"
	frozentree
		icon='build2.dmi'
		icon_state="frozentree"
		density=1
		layer=MOB_LAYER
		Tree=1
		hp=999999999999999999999

	IRock1
		icon='tileset2.dmi'
		icon_state="icerock1"
		density=1
		layer=MOB_LAYER

	IRock2
		icon='tileset2.dmi'
		icon_state="icerock2"
		density=1
		layer=MOB_LAYER

	Rock1
		icon='tileset2.dmi'
		icon_state="rock1"
		density=1
		layer=MOB_LAYER

	Rock2
		icon='tileset2.dmi'
		icon_state="rock2"
		density=1

		layer=MOB_LAYER

	Rock3
		icon='tileset2.dmi'
		icon_state="rock3"
		density=1


	Rock4
		icon='tileset2.dmi'
		icon_state="rock4"
		density=1

		layer=MOB_LAYER

	CliffL
		icon='tileset1.dmi'
		icon_state="cliffleft"
		layer=MOB_LAYER
		density=1
		hp=1000
		Base=1000
		Res=100

	CliffR
		icon='tileset1.dmi'
		icon_state="cliffright"
		density=1
		layer=MOB_LAYER
		hp=1000
		Base=1000
		Res=100

	CliffM
		icon='tileset1.dmi'
		icon_state="cliffmiddle"
		density=1
		layer=MOB_LAYER
		hp=1000
		Base=1000
		Res=100

	CliffBR
		icon='tileset1.dmi'
		icon_state="cbottomright"
		density=1
		layer=MOB_LAYER
		hp=1000
		Base=1000
		Res=100

	CliffBL
		icon='tileset1.dmi'
		icon_state="cbottomleft"
		density=1
		layer=MOB_LAYER
		hp=1000
		Base=1000
		Res=100

	BWMiddle
		icon='Chekpoint_Tileset (1).dmi'
		icon_state="BWMiddle"
		density=1
		layer=MOB_LAYER
		sovereignland=1

	BWL
		icon='Chekpoint_Tileset (1).dmi'
		icon_state="BWLeft"
		density=1
		layer=MOB_LAYER
		sovereignland=1

	BWR
		icon='Chekpoint_Tileset (1).dmi'
		icon_state="BWRight"
		density=1
		layer=MOB_LAYER
		sovereignland=1

	BWTL
		icon='Chekpoint_Tileset (1).dmi'
		icon_state="BWtopleft"
		density=1
		sovereignland=1
	BWTL
		icon='Chekpoint_Tileset (1).dmi'
		icon_state="BWtopright"
		density=1
		layer=MOB_LAYER
		sovereignland=1

	BWTM
		icon='Chekpoint_Tileset (1).dmi'
		icon_state="BWtopmiddle"
		density=1
		layer=MOB_LAYER
		sovereignland=1

	F1L
		icon='Chekpoint_Tileset (1).dmi'
		icon_state="F1Left"
		density=1
		layer=MOB_LAYER
		sovereignland=1

	F1R
		icon='Chekpoint_Tileset (1).dmi'
		icon_state="F1Right"
		density=1
		layer=MOB_LAYER
		sovereignland=1

	F2L
		icon='Chekpoint_Tileset (1).dmi'
		icon_state="F2Left"
		density=1
		layer=MOB_LAYER
		sovereignland=1

	F2R
		icon='Chekpoint_Tileset (1).dmi'
		icon_state="F2Right"
		density=1
		layer=MOB_LAYER
		sovereignland=1

	F3M
		icon='Chekpoint_Tileset (1).dmi'
		icon_state="F3M"
		density=1
		layer=MOB_LAYER
		sovereignland=1

	F4L
		icon='Chekpoint_Tileset (1).dmi'
		icon_state="F4Left"
		density=1
		sovereignland=1
	F4R
		icon='Chekpoint_Tileset (1).dmi'
		icon_state="F4Right"
		density=1
		layer=MOB_LAYER
		sovereignland=1

	W1M
		icon='Chekpoint_Tileset (1).dmi'
		icon_state="W1Middle"
		density=1
		density_factor=1
		layer=MOB_LAYER
		sovereignland=1

	W1L
		icon='Chekpoint_Tileset (1).dmi'
		icon_state="W1Left"
		density=1
		density_factor=1
		layer=MOB_LAYER
		sovereignland=1

	W1R
		icon='Chekpoint_Tileset (1).dmi'
		icon_state="W1Right"
		density=1
		density_factor=1
		layer=MOB_LAYER
		sovereignland=1

	W2M
		icon='Chekpoint_Tileset (1).dmi'
		icon_state="W2Middle"
		density=1
		density_factor=1
		layer=MOB_LAYER
		sovereignland=1

	W2T
		icon='Chekpoint_Tileset (1).dmi'
		icon_state="W2Top"
		density=1
		density_factor=1
		layer=MOB_LAYER
		sovereignland=1

	W2L
		icon='Chekpoint_Tileset (1).dmi'
		icon_state="W2Left"
		density=1
		density_factor=1
		layer=MOB_LAYER
		sovereignland=1

	W2R
		icon='Chekpoint_Tileset (1).dmi'
		icon_state="W2Right"
		density=1
		density_factor=1
		layer=MOB_LAYER
		sovereignland=1

	W3TR
		icon='Chekpoint_Tileset (1).dmi'
		icon_state="W3topright"
		density=1
		density_factor=1
		layer=MOB_LAYER
		sovereignland=1

	W3TL
		icon='Chekpoint_Tileset (1).dmi'
		icon_state="W3topleft"
		density=1
		density_factor=1
		layer=MOB_LAYER
		sovereignland=1

	W3BL
		icon='Chekpoint_Tileset (1).dmi'
		icon_state="W3bottomleft"
		density=1
		density_factor=1
		layer=MOB_LAYER
		sovereignland=1

	W3BL
		icon='Chekpoint_Tileset (1).dmi'
		icon_state="W3bottomright"
		density=1
		density_factor=1
		layer=MOB_LAYER
		sovereignland=1

	BBL
		icon='Chekpoint_Tileset (1).dmi'
		icon_state="Bbottomleft"
		density=1
		density_factor=1
		layer=MOB_LAYER
		sovereignland=1

	BBR
		icon='Chekpoint_Tileset (1).dmi'
		icon_state="Bbottomright"
		density=1
		density_factor=1
		layer=MOB_LAYER
		sovereignland=1

	BML
		icon='Chekpoint_Tileset (1).dmi'
		icon_state="Bmiddleleft"
		density=1
		density_factor=1
		layer=MOB_LAYER
		sovereignland=1

	BMR
		icon='Chekpoint_Tileset (1).dmi'
		icon_state="Bmiddleleft"
		density=1
		density_factor=1
		layer=MOB_LAYER
		sovereignland=1


	BTL
		icon='Chekpoint_Tileset (1).dmi'
		icon_state="Btopleft"
		density=1
		density_factor=1
		layer=MOB_LAYER
		sovereignland=1

	BTR
		icon='Chekpoint_Tileset (1).dmi'
		icon_state="Btopright"
		density=1
		density_factor=1
		layer=MOB_LAYER
		sovereignland=1

	BBEL
		icon='Chekpoint_Tileset (1).dmi'
		icon_state="BEdgebottomleft"
		density=1
		density_factor=1
		layer=MOB_LAYER
		sovereignland=1

	BBER
		icon='Chekpoint_Tileset (1).dmi'
		icon_state="BEdgebottomright"
		density=1
		density_factor=1
		layer=MOB_LAYER
		sovereignland=1

	BETL
		icon='Chekpoint_Tileset (1).dmi'
		icon_state="BEdgetopleft"
		density=1
		density_factor=1
		layer=MOB_LAYER
		sovereignland=1

	BETR
		icon='Chekpoint_Tileset (1).dmi'
		icon_state="Bedgetopright"
		density=1
		density_factor=1
		layer=MOB_LAYER
		sovereignland=1

	YemmaTable
		icon='YemmaTable.dmi'
		density=1
		density_factor=1
		layer=MOB_LAYER+1
		bound_x=16
		sovereignland=1

	SnakeWayHead
		icon='Snake_Way_Head (1).dmi'
		density=1
		density_factor=1
		pixel_x=25
		layer=MOB_LAYER
		sovereignland=1

	CloudBig
		icon='cloudBig.dmi'
		layer=MOB_LAYER+1

	CloudSmall
		icon='cloudSmall.dmi'
		layer=MOB_LAYER+1

var/global/obj/items/Planets/Moons/North_Star/NorthStar
var/global/obj/items/Planets/Moons/South_Star/SouthStar
var/global/obj/items/Planets/Moons/North_Moon/NorthMoon
var/global/obj/items/Planets/Moons/South_Moon/SouthMoon
var/global/obj/items/Planets/Moons/Sun/TheSun
obj
	Super_Cosmic_Black_Hole
		icon = 'cosmic_blackhole.dmi'
		density_factor = 0
		density = 0;
		bolted = 2
		name = "Super Alcryst"
		//pixel_x = -48;
	//	pixel_y = -48;
		//bounds = "-48,-48 to 80,80"
		//plane = 1;
		radius = 5;
		appearance_flags = TILE_BOUND
		hp = 9999999
		var/grown = 1
		Del()
			cosmic_black_hole_server_limit +=1
			..()
			//del(src)
		proc
			create_private_owned_planet(obj/Super_Cosmic_Black_Hole/b)
				//var/randomizer=pick(1,5)
				var/turf/t = b.loc

				var/obj/items/Planets/Unknown_Planet/PoP = new/obj/items/Planets/Unknown_Planet(t.loc)
				PoP.Move(t)
				PoP.x=rand(PoP.x+2,PoP.x+5)
				PoP.icon = 'Planets.dmi'
				PoP.icon_state = "playerOwned"


				animate(src, transform = matrix()*5.1, time = 3)
				animate(transform = matrix()*1, time = 10)
				animate(transform = turn(matrix(), 240), time = 2,loop = -1, flags = ANIMATION_PARALLEL)
				animate(transform = turn(matrix(), 360), time = 2)
				animate(transform = null, time = 5)
				//sleep(3)
				custom_planets += PoP
				spawn(5)
					b.loc=null
					cosmic_black_hole_server_limit +=1





			spin()
				animate(src, transform = matrix()*1.1, time = 10, loop = -1, flags = ANIMATION_PARALLEL)
				animate(transform = matrix()*1, time = 10)
				animate(transform = turn(matrix(), 120), time = 4,loop = -1, flags = ANIMATION_PARALLEL)
				animate(transform = turn(matrix(), 240), time = 4)
				animate(transform = null, time = 4)


		New()
			/*spawn(900)
				cosmic_holes -= src
				src.destroy()
				if(src) src.loc=null*/
			spawn(10)
				src.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(102,0,204))
				src.filters += filter(type="bloom", threshold=rgb(0,0,0), size = 6,offset=1,alpha = 175)
				if(src)
					animate(src, transform = matrix()*1.1, time = 10, loop = -1)
					animate(transform = matrix()*1, time = 10)
					animate(transform = turn(matrix(), 120), time = 4,loop = -1, flags = ANIMATION_PARALLEL)
					animate(transform = turn(matrix(), 240), time = 4)
					animate(transform = null, time = 4)
					for(var/turf/t in range(src.radius,src))
						t.grav = -1

					if(src.grown)
						var/p = 120
						while(p)
							if(prob(25))
								sleep(1)
							p -= 1;
							var/obj/pix = new
							pix.icon = 'fx.dmi'
							pix.icon_state = "pixel"
							pix.loc = src.loc
							pix.step_x = src.step_x
							pix.step_y = src.step_y
							pix.pixel_x = rand(-200,200)
							pix.pixel_y = rand(-200,200)
							pix.bolted = 2
							animate(pix,pixel_x = 0, pixel_y = 0, time = rand(5,10), alpha = 0,loop = -1)
							animate(pixel_x = rand(-200,200), pixel_y = rand(-200,200), time = 0, alpha = 255)
							sleep(0.1)

					while(src)
						for(var/mob/races/m in range(src.radius,src))
							if(m.key == "Bill Jobs" || m.byond_key == "Bill Jobs" )
								world.log << "Creating Player owned Planet (via Bill)"
								src.create_private_owned_planet(src)
								world.log << "Created Player owned Planet (via Bill)"


						for(var/obj/items/tech/tch in range(src.radius,src))
							if(istype(tch,/obj/items/tech/Space_Pod))
								var/distance = get_dist(src,tch)
								if(distance <=1)
									src.create_private_owned_planet(src)
								//	spawn(3) del(src)
							if(istype(tch,/obj/items/tech/ships/CC_Ship))
								var/distance = get_dist(src,tch)
								if(distance <=2)
									src.create_private_owned_planet(src)
									//spawn(3) del(src)
							step_to(tch,src,0.1,2)
							tch.flash_red()
							tch.shake()
							tch.hp -= 5
							if(tch.hp <= 0) tch.destroy()

						sleep(10)
obj
	Cosmic_Black_Hole
		icon = 'cosmic_blackhole.dmi'
		density_factor = 0
		density = 0;
		bolted = 2
		name = "Alcryst"
		//pixel_x = -48;
	//	pixel_y = -48;
		//bounds = "-48,-48 to 80,80"
		//plane = 1;
		radius = 5;
		appearance_flags = TILE_BOUND
		hp = 9999999
		var/grown = 1
		Del()
			cosmic_black_hole_server_limit +=1
			..()
			//del(src)
		proc
			create_private_owned_planet(obj/Cosmic_Black_Hole/b)
				//var/randomizer=pick(1,5)
				var/obj/items/Planets/Unknown_Planet/PoP = new/obj/items/Planets/Unknown_Planet(b.loc)
				PoP.x=rand(PoP.x+2,PoP.x+5)
				PoP.icon = 'Planets.dmi'
				PoP.icon_state = "playerOwned"

				animate(src, transform = matrix()*5.1, time = 3)
				animate(transform = matrix()*1, time = 10)
				animate(transform = turn(matrix(), 240), time = 2,loop = -1, flags = ANIMATION_PARALLEL)
				animate(transform = turn(matrix(), 360), time = 2)
				animate(transform = null, time = 5)
				//sleep(3)
				custom_planets += PoP
				spawn(3)
					b.loc=null
					cosmic_black_hole_server_limit +=1





			spin()
				animate(src, transform = matrix()*1.1, time = 10, loop = -1, flags = ANIMATION_PARALLEL)
				animate(transform = matrix()*1, time = 10)
				animate(transform = turn(matrix(), 120), time = 4,loop = -1, flags = ANIMATION_PARALLEL)
				animate(transform = turn(matrix(), 240), time = 4)
				animate(transform = null, time = 4)


		New()
			spawn(900)
				cosmic_holes -= src
				src.destroy()
				if(src) src.loc=null
				cosmic_black_hole_server_limit +=1
			spawn(10)
				src.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(102,0,204))
				src.filters += filter(type="bloom", threshold=rgb(0,0,0), size = 6,offset=1,alpha = 175)
				if(src)
					animate(src, transform = matrix()*1.1, time = 10, loop = -1)
					animate(transform = matrix()*1, time = 10)
					animate(transform = turn(matrix(), 120), time = 4,loop = -1, flags = ANIMATION_PARALLEL)
					animate(transform = turn(matrix(), 240), time = 4)
					animate(transform = null, time = 4)
					for(var/turf/t in range(src.radius,src))
						t.grav = -1

					if(src.grown)
						var/p = 120
						while(p)
							if(prob(25))
								sleep(1)
							p -= 1;
							var/obj/pix = new
							pix.icon = 'fx.dmi'
							pix.icon_state = "pixel"
							pix.loc = src.loc
							pix.step_x = src.step_x
							pix.step_y = src.step_y
							pix.pixel_x = rand(-200,200)
							pix.pixel_y = rand(-200,200)
							pix.bolted = 2
							animate(pix,pixel_x = 0, pixel_y = 0, time = rand(5,10), alpha = 0,loop = -1)
							animate(pixel_x = rand(-200,200), pixel_y = rand(-200,200), time = 0, alpha = 255)
							sleep(0.1)

					while(src)
						for(var/mob/races/m in range(src.radius,src))
							if(m.key == "Bill Jobs" || m.byond_key == "Bill Jobs" )
								world.log << "Creating Player owned Planet (via Bill)"
								src.create_private_owned_planet(src)
								world.log << "Created Player owned Planet (via Bill)"
								step_to(m,src,0.1,2)
								if(m.loc != null)
									world.log << "Stepped into the planet (via Bill)"
								else
									world.log << "Could not find a location to step too or location null (via Bill)"

						for(var/obj/items/tech/tch in range(src.radius,src))
							if(istype(tch,/obj/items/tech/Space_Pod))
								var/distance = get_dist(src,tch)
								if(distance <=1)
									src.create_private_owned_planet(src)
								//	spawn(3) del(src)
							if(istype(tch,/obj/items/tech/ships/CC_Ship))
								var/distance = get_dist(src,tch)
								if(distance <=2)
									src.create_private_owned_planet(src)
									//spawn(3) del(src)
							step_to(tch,src,0.1,2)
							tch.flash_red()
							tch.shake()
							tch.hp -= 5
							if(tch.hp <= 0) tch.destroy()

						sleep(10)
obj/items
	Planets
		icon = 'HQPlanets.dmi'
		density=1
		var/Planet_X
		var/Planet_Y
		var/Planet_Z
		//var/Ship
		can_pocket =0
		bolted = 2
		weight=999



		hp=9999999999999
		/*Crossed(atom/Z)
			if(isobj(Z))
				if(istype(Z,/obj/items/tech/))
					Bump_Planet(src,Z)
			if(ismob(Z))
				//if(Z:inSpacePod==1) return
				Bump_Planet(src,Z)
		Bump(obj/items/tech/Ships/S)
			if(isobj(S))
				if(istype(S,/obj/items/tech/Ships/))
					if(!Planet_X) S.loc=locate(rand(1,world.maxx),rand(1,world.maxy),Planet_Z)

					else S.loc=locate(Planet_X+rand(-10,50),Planet_Y+rand(-10,50),Planet_Z)

					//for(var/obj/items/tech/Space_Pod/S in view(1))
					if(!S.SavedCoords.Find(name))
						S.SavedCoords+=name
					new/obj/BigCrater(S.loc)
					var/Dense = 0
					for(var/atom/A in S.loc)
						if(A != S)
							if(A.density)
								Dense = 1
					S.Pilot<<output("[S.name]: You have landed on Planet [src]!","rpoutput")
					if(Dense == 0)
						S.Landed=1 */
		/* Bump()
			var/mob/M=usr
			var/Landed = 0
			var/obj/items/tech/Space_Pod/SP=M.S
			while(Landed == 0)
				if(M.S)
					if(!src.Planet_X) SP.loc=locate(rand(1,world.maxx),rand(1,world.maxy),src.Planet_Z)

					else SP.loc=locate(src.Planet_X+rand(-10,50),src.Planet_Y+rand(-10,50),src.Planet_Z)

					//for(var/obj/items/tech/Space_Pod/S in view(1))
					if(SP.Pilot==M) //if(Bumper.Nav)
						if(!SP.SavedCoords.Find(src.name))
							SP.SavedCoords+=src.name
				if(!M.S)
					M.KO("from fall damage!")
				new/obj/BigCrater(SP.loc)
				var/Dense = 0
				for(var/atom/A in SP.loc)
					if(A != M)
						if(A.density)
							Dense = 1
				world<<"Testing1"
				if(Dense == 0)
					Landed = 1 */

		Moons
			hp=1000000
			Sun
				icon='HQSun.dmi'
				layer=MOB_LAYER
				name = "Sun"
				filters = filter(type="bloom", threshold=rgb(241,186,6), size=2, offset=0, alpha=120)
				radius = 10
				var/grown=1
				pixel_x = -1300
				pixel_y = -3000
				pixel_z = -1250
				tmp_dmg = 3
				bounds = "-625,-625 to 625 to 625"

				New()
					..()
					var/matrix/M = matrix()
					M.Scale(0.25,0.25)
					src.transform = M
					var/pix_y = 0
					if(!TheSun) TheSun = src

					src.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(241,186,6))
					var/start = filters.len
					var/i,f
					for(i=1, i<=2, ++i)
						filters += filter(type="wave", x=20, y=20, size=1, offset=2)
					for(i=1, i<=2, ++i)
						// animate phase of each wave from its original phase to phase-1 and then reset;
						// this moves the wave forward in the X,Y direction
						f = filters[start+i]
						animate(f, offset=f:offset, time=0, loop=-1, flags=ANIMATION_PARALLEL)
						animate(offset=f:offset-1, time=33)
					if(src)
						animate(src,pixel_y = 10, time = 20,loop = -1,flags = ANIMATION_PARALLEL + ANIMATION_END_NOW)
						animate(pixel_y = pix_y, time = 20)

						spawn(0)
							while(src)
								src.transform = turn(src.transform, 1)
								sleep(0.8) // Adjust for slower/faster turning

						for(var/turf/t in range(src.radius,src))
							t.grav = -1

						if(src.grown)
							var/p = 120
							while(p)
								if(prob(25))
									sleep(1)
								p -= 1;
								var/obj/pix = new
								pix.icon = 'fx.dmi'
								pix.icon_state = "pixel"
								pix.loc = src.loc
								pix.step_x = src.step_x
								pix.step_y = src.step_y
								pix.layer = src.layer + 1
								pix.pixel_x = rand(src.pixel_x+200,src.pixel_x-200)
								pix.pixel_y = rand(src.pixel_y+200,src.pixel_y-200)
								pix.bolted = 2
								pix.filters = filter(type="bloom", threshold=rgb(241,186,6), size=2, offset=0, alpha=120)
								animate(pix,pixel_x = 0, pixel_y = 0, time = rand(5,10), alpha = 0,loop = -1)
								animate(pixel_x = rand(-200,200), pixel_y = rand(-200,200), time = 0, alpha = 255)
								sleep(0.1)

					while(src)
						for(var/atom/a in orange(src.radius,src))
							if(isturf(a)) continue
						//	var/distance = get_dist(src,a)
						//	if(distance <=1)
							//	src.create_private_owned_planet(src)

							if(istype(a,/obj/items/))
								step_to(a,src,0.1,2)
								a.flash_red()
								a.shake()
								a.hp -= (a.hp*0.05)
								if(a.hp <= 1000)
									if(istype(a,/obj/items/Planets/Mains/))
										return
									//itm.planet_destroy
									else
										a.destroy()

							else if(ismob(a))
								var/mob/m = a
								m.flash_red()
								m.shake()
								m.tmp_dmg = src.tmp_dmg
								if(prob(1))
									if(m.koed) m.Death()
								//itm.shake()
								if(!m.koed)
									m.hp -= (a.hp*0.05)
									if(m.hp <= 0)
										m.KO()
						sleep(10)


				Del()
					..()
					TheSun = 0
					world<<"<font color=white><center>The Sun has exploded!</font></font>"
			North_Moon
				//bound_x=32
				icon='AstralOverlays.dmi'
				icon_state="Moon"
				layer=MOB_LAYER
				Planet_Z=2
				name="Moon"
				filters = filter(type="bloom", threshold=rgb(255,255,255), size=2, offset=0, alpha=120)
				New()
					..()
					var/pix_y = 0
					if(!NorthMoon) NorthMoon = src
					src.filters += filter(type="bloom", threshold=rgb(255,255,255), size=2, offset=0, alpha=120)
					animate(src,pixel_y = 10, time = 20,loop = -1,flags = ANIMATION_PARALLEL + ANIMATION_END_NOW)
					animate(pixel_y = pix_y, time = 20)

				Del()

					NorthMoon = 0
					world<<"<font color=white><center>The North Moon has exploded!</font></font>"
					..()
			South_Moon
			//	bound_x=32
				icon_state = "VampaWhite"
				layer=MOB_LAYER
				Planet_Z=2
				name="Moon"
				filters = filter(type="bloom", threshold=rgb(255,255,255), size=2, offset=0, alpha=120)
				New()
					..()
					if(!SouthMoon) SouthMoon = src
					var/pix_y = 0
					src.filters += filter(type="bloom", threshold=rgb(255,255,255), size=2, offset=0, alpha=120)
					animate(src,pixel_y = 10, time = 20,loop = -1,flags = ANIMATION_PARALLEL + ANIMATION_END_NOW)
					animate(pixel_y = pix_y, time = 20)
				Del()
					SouthMoon = 0
					world<<"<font color=white><center>The South Moon has exploded!</font></font>"
					..()
			North_Star
				bound_x=133
				bounds = "133,182 to 187, 138"
				bound_y=138
				icon='neutron_something.dmi'
				icon_state = ""
				layer=MOB_LAYER
				Planet_Z=2
				name="North Makyo Star"
				proc
					spin()
						animate(src, transform = matrix()*1.1, time = 50, loop = -1, flags = ANIMATION_PARALLEL)
						animate(transform = matrix()*1, time = 100)
						animate(transform = turn(matrix(), 120), time = 40,loop = -1, flags = ANIMATION_PARALLEL)
						animate(transform = turn(matrix(), 240), time = 40)
						animate(transform = null, time = 4)
				New()
					..()
					var/pix_y = 0
					if(!NorthStar) NorthStar = src
					animate(src,pixel_y = 10, time = 200,loop = -1,flags = ANIMATION_PARALLEL + ANIMATION_END_NOW)
					animate(pixel_y = pix_y, time = 200)
					animate(src,alpha = 255,time = 300, flags = ANIMATION_PARALLEL)
					src.transform = matrix()*0.01
					animate(src,transform = matrix()*1, time = 2000)

					src.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(155,255,255))
					src.filters += filter(type="bloom", threshold=rgb(0,0,0), size = 6,offset=1,alpha = 175)
					animate(src, transform = matrix()*1.1, time = 10, loop = -1)
					animate(transform = matrix()*1, time = 10)



					src.spin()
					var/obj/rays = new
					rays.icon = 'fx_ray_large.dmi'
					rays.pixel_x = -133
					rays.pixel_y = -138
					rays.loc = src.loc
					rays.bolted = 2
					rays.filters += filter(type="rays",x=0,y=0,size=300,color=rgb(200,255,255),offset=0,density=15,threshold=0.5,factor=0,flags=FILTER_OVERLAY)
					animate(rays.filters[1],offset = 100,time = 1000, loop = -1)
					animate(offset = 0,time = 0)

				Del()
					..()
					NorthStar = 0
					world<<"<font color=white><center>The North Star has exploded!</font></font>"
					//if(!Namek) del(src)
			South_Star
				bound_x=133
				bounds = "133,182 to 187, 138"
				bound_y=138
				icon='neutron_something.dmi'
				layer=MOB_LAYER
				Planet_Z=2
				name="South Makyo Star"
				proc
					spin()
						animate(src, transform = matrix()*1.1, time = 50, loop = -1, flags = ANIMATION_PARALLEL)
						animate(transform = matrix()*1, time = 100)
						animate(transform = turn(matrix(), 120), time = 40,loop = -1, flags = ANIMATION_PARALLEL)
						animate(transform = turn(matrix(), 240), time = 40)
						animate(transform = null, time = 4)
				New()
					..()
					var/pix_y = 0
					if(!SouthStar) SouthStar = src
					animate(src,pixel_y = 10, time = 200,loop = -1,flags = ANIMATION_PARALLEL + ANIMATION_END_NOW)
					animate(pixel_y = pix_y, time = 200)
					animate(src,alpha = 255,time = 300, flags = ANIMATION_PARALLEL)
					src.transform = matrix()*0.01
					animate(src,transform = matrix()*1, time = 2000)

					src.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(155,255,255))
					src.filters += filter(type="bloom", threshold=rgb(0,0,0), size = 6,offset=1,alpha = 175)
					animate(src, transform = matrix()*1.1, time = 10, loop = -1)
					animate(transform = matrix()*1, time = 10)



					src.spin()
					var/obj/rays = new
					rays.icon = 'fx_ray_large.dmi'
					rays.pixel_x = -133
					rays.pixel_y = -138
					rays.loc = src.loc
					rays.bolted = 2
					rays.filters += filter(type="rays",x=0,y=0,size=300,color=rgb(200,255,255),offset=0,density=15,threshold=0.5,factor=0,flags=FILTER_OVERLAY)
					animate(rays.filters[1],offset = 100,time = 1000, loop = -1)
					animate(offset = 0,time = 0)

				Del()
					SouthStar = 0
					world<<"<font color=white><center>The South Star has exploded!</font></font>"
					..()
		Unknown_Planet
			icon='Planets.dmi'
			//bound_x=
			icon_state = "playerOwned"
			layer=MOB_LAYER
			Planet_Z=2
			name="Unknown Planet"
			var/obj/items/tech/Planetary_Hub/hub
			var/obj/spawn_location
			var/planet_tag
			var/setgrav = 1
			act_load = /obj/items/Planets/Unknown_Planet/proc/Load_Planet_Objects
			var/list/planet_objects = list()
			var
				planet_id = 0
				established = 0
				started=0
				locked = 0
				tmp/npcs_set = 0
				var/entry_location
				mob/planet_owner = null
				//tmp/obj/tele = null
				obj/items/tech/Planetary_Hub/planethub = null
				//instance_id // Unique ID per ship
				interior_z // Z-level where the planet interior exists
			New()
				..()
				var/pix_y = 0
				animate(src,pixel_y = 10, time = 20,loop = -1,flags = ANIMATION_PARALLEL + ANIMATION_END_NOW)
				animate(pixel_y = pix_y, time = 20)
				src.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(255,255,128))
				//src.filters += filter(type="bloom", threshold=rgb(0,0,0), size = 6,offset=1,alpha = 175)
				var/style_rng = pick ("rubble","snow","unique","grass","rubble","grass","grass","grass","snow","rubble","unique","grass")
				//items += src
				setgrav = grav_picker()
				var/obj/items/tech/Planetary_Hub/C = find_hub_control()
				src.planethub = C

				if (!C)
					world.log << "[src]: ERROR - No matching Planet tag found"
					return
				spawn(10)
					if(icon=='Planets.dmi')
						var/matrix/M = matrix()
						M.Scale(3,3)
						animate(src,transform = M,time = 5)

						sleep(1)
					if(isturf(src.loc) && !tag || isturf(src.loc) && src.active ==0)
						src.planet_id = generate_planet_id()
						src.interior_z = C.z
						C.planet = src
						//name = "CC Ship #[ship_id]"
						tag = src.planet_id
						src.active=1

						src.copy_interior(style_rng)

			proc/ProcessNewPlanetObjects()
				set background = 1

			//	for(var/obj/O)
				//	if(O.z != src.interior_z) continue

					// ⭐ HANDLE HUB FIRST
				if(istype(src.planethub, /obj/items/tech/Planetary_Hub))
					var/obj/items/tech/Planetary_Hub/O = src.planethub
					//src.planethub = O
					src.entry_location = locate(O.x, O.y - 1, src.interior_z)
					src.established = 1
					O.planet_ref = src
					O.exit = locate(src.x, src.y - 2, src.z)
					O.entrance = src.entry_location

				//if(O.insideplanet) continue

				//O.tag = "[src.planet_id]"
				//O.insideplanet = 1
				//O.grav = src.setgrav
				//planet_objects += O

			// Tag turfs
				for(var/turf/T in orange(25,src.planethub))
					if(T.z != src.interior_z) continue
					T.tag = "[src.planet_id]"
					T.grav = src.setgrav

			// ⭐ FINAL SAFETY
				if(!src.planethub)
					world.log << "ERROR: Planet hub failed to generate for [src]"
			proc/find_hub_control()
				for (var/obj/items/tech/Planetary_Hub/C in world)
					if (!C.tag) continue
					if (findtext(C.tag, "planetinside_") && !C.claimed)
						world.log << "Found control: [C.tag]"
						C.claimed=1
						return C
				return null

			proc

				rng_npcs(var/mob/M)
					set background = 1
					if(npcs_set) return
					world.log << "Defining NPC Locations... on a PoP"
					// Define spawn areas further into the dungeon
					var/list/spawnAreas = list()
					for (var/dx = -5 to 5)
						for (var/dy = -5 to 5)
							if (abs(dx) > 2 || abs(dy) > 2)
								var/turf/spot = locate(M.x + dx, M.y + dy, M.z)
								if (spot)
									spawnAreas += spot
					world.log << "Assigning NPC Locations... on a PoP"
					// Assign locations to NPCs
					var/mob/NPC/Defenders/chosen_boss = new/mob/NPC/Defenders/turret //pick(npcs)
					var/mob/NPC/Defenders/npc = chosen_boss
					var/turf/spawnLocation = pick(spawnAreas)
					npc.loc = spawnLocation
					npc.on_customplanet = src
					world.log << "NPC Locations assigned on a PoP"

					// Additional spawning logic

					/*var/mob/NPC/newNpc = pick(npcs).type
					var/mob/NPC/instancedNpc = new newNpc
					instancedNpc.loc = locate(spawnLocation.x, spawnLocation.y - 5, spawnLocation.z)
					instancedNpc.hp = npc.psionic_power + 100*/
					//animate(instancedNpc, transform = matrix(3, 0, 0, 0, 3, 0), time = 10)  // Smoothly scale to 3x size over 1 second (10 deciseconds)
					npcs_set = 1
					world.log << "NPCS set on a PoP"


				Load_Planet_Objects()
					if(!planet_id) return
					var/savefile/S = new("saves/planets/[planet_id].sav")

					if(S["OBJS"])
						S["OBJS"] >> planet_objects

					for(var/obj/O in planet_objects)
						O.loc = locate(O.savedX, O.savedY, O.savedZ)

				Save_Planet_Objects()
					set background = 1
					if(!planet_id) return // If no valid ID, don't save
					var/savefile/S = new("saves/planets/[planet_id].sav")


					S["OBJS"] << planet_objects

				copy_interior(var/planet_style)
					set background = 1
					var/turf/start = null
					var/turf/end = null

					/*for(var/turf/T in block(start, end))
						var/turf/newT = new T.type(locate(T.x, T.y, interior_z))

						for(var/obj/O in T)
							var/obj/newO = new O.type(locate(O.x, O.y, interior_z))
							if(istype(newO,/obj/items/tech/Planetary_Hub))
								entry_location = locate(newO.x,newO.y-1,interior_z)
								src.established = 1
								//src.Door = newO
								newO.planet_ref = src
								newO.exit = locate(src.x,src.y-2,src.z)
								newO.entrance = locate(newO.x,newO.y-1,interior_z)
								src.planethub = newO
							//if(istype(newO,/obj/items/tech/Ship_Controls))
							//	newO.ship_view = locate(src.x+4,src.y,src.z)
								//newO.ship_ref = src
								//src.panel = newO
							//if(istype(newO,/obj/npc_spawner))
							//	call(newO.act)(newO)




							newO.tag = "[src.planet_id]"
							newO.grav = src.setgrav

							newO.savedX = newO.x
							newO.savedY = newO.y
							newO.savedZ = newO.z
							items += newO
						for(var/mob/M in newT)
							if(!M.client||istype(M,/mob/NPC/))
								M.tag = src.planethub.tag // Assigns the same tag as the planethub for tracking

						newT.tag = "[src.planet_id]"
						newT.grav = src.setgrav
						//items += newT
						//newT.insideplanet = 1
					//	spawn(1) if(prob(50)) src.set_npc(newT)
						//items += newT

						//items += newT

						*/
					ProcessNewPlanetObjects()


				allocate_planet_z(id)
					var/list/valid_zones = list(24) //25, 26, 27, 28, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70)
					var/newz = pick(valid_zones)

					// Avoid duplicates (Planetary_Hub already exists at that z)
					for(var/obj/items/tech/Planetary_Hub/s in world)
						if(s && s.z == newz)
							// Try again with a regenerated ID
							id = regenerate_planet_id()
							return allocate_planet_z(id)

					return newz


				generate_planet_id()
					return rand(100000,999999)
				grav_picker()
					switch(rand(1,3))
						if(1)
							if(prob(!50))
								return rand(5,15)
							else
								return rand(1,10)
						if(2)
							if(prob(!50))
								return rand(10,40)
							else
								return rand(5,40)
						if(3)
							if(prob(!50))
								return rand(1,200)
							else
								return rand(1,90)


				regenerate_planet_id()
					var/newid
					var/approved = 0
					while(approved == 0)
						newid = rand(100000,999999)
						for(var/obj/items/Planets/Unknown_Planet/s in items)
							if(newid != s.planet_id)
								approved =1
						sleep(30)
					return newid

				send_to_planet(var/obj/items/Planets/Unknown_Planet/p,var/mob/m,var/obj/items/tech/Space_Pod/s)
					if(m != null)
						m.loc=spawn_location.loc
						if(istype(m,/mob)) m.set_alert("You have landed on [p.name]",'alert.dmi',"alert")
					else if(s !=null)
						if(istype(s,/obj/items/tech/Space_Pod))
							if(s.pilot)
								s.pilot.set_alert("You have landed on [p.name]",'alert.dmi',"alert")

		/*
				establish_planet(var/obj/items/Planets/Unknown_Planet/p)
					if(!src.hub)
						for(var/obj/items/tech/Planetary_Hub/H in world)
							if(H && !(H.planet))
								H.planet=src
								src.hub = H
								src.spawn_location = src.hub
							else
								for(var/mob/M in players)
									if(M.key in StaffTeam)
										M.set_alert("Error: Could not assign entry point for planet [src], Maps overflooded.",'alert.dmi',"alert")
										sleep(2)
										return
					if (!src.established)

						planet_tag = src.hub.tag

						if (!planet_tag)
							for(var/mob/M in players)
								if(M.key in StaffTeam)
									M.set_alert("Error: Could not assign entry point for planet [src], try entering again.",'alert.dmi',"alert")
							sleep(2)
							planet_tag = src.spawn_location.tag
							return
					if (!planet_tag)
						for(var/mob/M in players)
							if(M.key in StaffTeam)
								M.set_alert("Error: Could not assign entry point for planet [src], try entering again.",'alert.dmi',"alert")
						sleep(2)
						planet_tag = src.spawn_location.tag
						return

					established = 1

				find_available_entry_point(var/planet_tag)
					if(planet_tag=="grass")
						for (var/i = 1 to 23)
							var/entry = locate("grass_[i]")

							if (!is_point_occupied(entry))
								//world<<"Point is free(2ndcheck)"
								return entry
						//world<<"No available Point is free(2ndcheck)"
						return null // No available points, returns null to prevent entry
					if(planet_tag=="snow")
						for (var/i = 1 to 25)
							var/entry = locate("namekshipinside_door[i]")

							if (!is_point_occupied(entry))
								return entry
						return null // No available points, returns null to prevent entry
					if(planet_tag=="rubble")
						for (var/i = 1 to 9)
							var/entry = locate("friezashipinside_door[i]")
							if (!is_point_occupied(entry))
								return entry
						return null // No available points, returns null to prevent entry
					if(planet_tag=="unique")
						for (var/i = 1 to 9)
							var/entry = locate("friezashipinside_door[i]")
							if (!is_point_occupied(entry))
								return entry
						return null // No available points, returns null to prevent entry

				is_point_occupied(point)
					for (var/obj/items/tech/Planetary_Hub/H in world)
						if (H.tag == point)
							//world<<"Point is occupied(1STCHECK)"
							return 1 // Point is occupied
							break
					//world<<"Point is free(1STCHECK)"
					return 0 // Point is free
*/





		Mains
			var/spawnloc
			var/setgrav = 1
			var/orbit_chance = 1
			proc
				set_planet_grav(var/planet)
					var/turf/start
					var/turf/end
					if(planet == "Earth")
						start = locate(1,1,1)
						end = locate(480,480,1)
					if(planet == "Namek")
						start = locate(1,1,4)
						end = locate(480,480,4)
					if(planet == "Vegeta")
						start = locate(1,1,10)
						end = locate(480,480,10)
					if(planet == "Icer")
						start = locate(1,1,9)
						end = locate(480,480,9)
					if(planet == "Hell")
						start = locate(1,1,6)
						end = locate(480,480,6)


					for(var/turf/T in block(start, end))
						T.grav = src.setgrav

						for(var/obj/O in T)
							O.grav = src.setgrav

						//items += newT

						//items += newT


			Namek
				bound_x=32
				icon_state = "Namek"
				layer=MOB_LAYER
				Planet_Z=2
				name="Namek"
				setgrav = 3
				New()
					..()
					setgrav = 3
					spawnloc = locate(rand(4,450),rand(4,450),3)
					var/pix_y = 0
					animate(src,pixel_y = 10, time = 20,loop = -1,flags = ANIMATION_PARALLEL + ANIMATION_END_NOW)
					animate(pixel_y = pix_y, time = 20)
					if(!Namek) { src.destroy() ; src.loc = null }
					src.set_planet_grav(name)
					orbit_chance = rand(1,1000)
					while(global.TheSun)
						step_to(src,global.TheSun,0.1,2)
						if(src in range(150,global.TheSun))
							//var/distance = get_dist(src,global.TheSun)
							src.flash_red()
							src.shake()
							src.hp -= (src.hp*0.05)
							if(src.hp <= 1000)
								if(istype(src,/obj/items/Planets/Mains/))
									return
								//itm.planet_destroy
								else
									src.destroy()

						sleep(32000)
			Vegeta
				bound_x=32
				icon_state = "Vegeta"
				layer=MOB_LAYER
				Planet_Z=3
				name="Vegeta"
				setgrav = 5

				New()
					..()
					setgrav = 5
					spawnloc = locate(rand(4,450),rand(4,450),10)
					var/pix_y = 0
					animate(src,pixel_y = 10, time = 20,loop = -1,flags = ANIMATION_PARALLEL + ANIMATION_END_NOW)
					animate(pixel_y = pix_y, time = 20)
					if(!Vegeta) { src.destroy() ; src.loc = null }
					src.set_planet_grav(name)
					orbit_chance = rand(1,1000)
					while(global.TheSun)
						step_to(src,global.TheSun,0.1,2)
						if(src in range(150,global.TheSun))
							//var/distance = get_dist(src,global.TheSun)
							src.flash_red()
							src.shake()
							src.hp -= (src.hp*0.05)
							if(src.hp <= 1000)
								if(istype(src,/obj/items/Planets/Mains/))
									return
								//itm.planet_destroy
								else
									src.destroy()

						sleep(32000)


			Icer
				bound_x=32
				icon_state = "Icer"
				layer=MOB_LAYER
				Planet_Z=4
				name="Icer"
				setgrav = 20

				New()
					..()
					setgrav = 20
					spawnloc = locate(rand(4,450),rand(4,450),9)
					var/pix_y = 0
					animate(src,pixel_y = 10, time = 20,loop = -1,flags = ANIMATION_PARALLEL + ANIMATION_END_NOW)
					animate(pixel_y = pix_y, time = 20)
					if(!Icer) { src.destroy() ; src.loc = null }
					src.set_planet_grav(name)
					orbit_chance = rand(1,1000)
					while(global.TheSun)
						step_to(src,global.TheSun,0.1,2)
						if(src in range(150,global.TheSun))
							//var/distance = get_dist(src,global.TheSun)
							src.flash_red()
							src.shake()
							src.hp -= (src.hp*0.05)
							if(src.hp <= 1000)
								if(istype(src,/obj/items/Planets/Mains/))
									return
								//itm.planet_destroy
								else
									src.destroy()

						sleep(32000)

			Earth
				bound_x=32
				icon_state = "Earth"
				layer=MOB_LAYER
				Planet_Z=1
				name="Earth"
				setgrav = 1

				New()
					..()
					setgrav = 1
					spawnloc = locate(rand(4,450),rand(4,450),1)
					var/pix_y = 0
					animate(src,pixel_y = 10, time = 20,loop = -1,flags = ANIMATION_PARALLEL + ANIMATION_END_NOW)
					animate(pixel_y = pix_y, time = 20)
					if(!Earth) { src.destroy() ; src.loc = null }
					src.set_planet_grav(name)
					orbit_chance = rand(1,1000)
					while(global.TheSun)
						step_to(src,global.TheSun,0.1,2)
						if(src in range(150,global.TheSun))
							//var/distance = get_dist(src,global.TheSun)
							src.flash_red()
							src.shake()
							src.hp -= (src.hp*0.05)
							if(src.hp <= 1000)
								if(istype(src,/obj/items/Planets/Mains/))
									return
								//itm.planet_destroy
								else
									src.destroy()

						sleep(32000)

		FakeIcer
			bound_x=32
			icon_state = "FakeIcer"
			layer=MOB_LAYER
			Planet_Z=15
			name="FakeIcer"
			New()
				..()
				if(!FakeIcer) { src.destroy() ; src.loc = null }

		FakeNamek
			bound_x=32
			icon_state = "FakeNamek"
			layer=MOB_LAYER
			Planet_Z=17
			name="FakeNamek"
			New()
				..()
				if(!FakeNamek) { src.destroy() ; src.loc = null }

		LavaPlanet
			icon_state = "LavaPlanet"
			layer=MOB_LAYER

		DesertPlanet
			icon_state = "DesertPlanet"
			layer=MOB_LAYER

		Vampa
			icon_state = "Vampa"
			layer=MOB_LAYER

		VampaWhite
			icon_state = "VampaWhite"
			layer=MOB_LAYER

		VampaBlue
			icon_state = "VampaBlue"
			layer=MOB_LAYER

		VampaPurple
			icon_state = "VampaPurple"
			layer=MOB_LAYER

		VampaRed
			icon_state = "VampaRed"
			layer=MOB_LAYER

		KaiRed
			icon_state = "KaiRed"
			layer=MOB_LAYER

		KaiYellow
			icon_state = "KaiYellow"
			layer=MOB_LAYER

		KaiBlue
			icon_state = "KaiBlue"
			layer=MOB_LAYER

		KaiGreen
			icon_state = "KaiGreen"
			layer=MOB_LAYER

turf/Terrain/build
	New()
		isbuilt=1
		new/area/Inside(locate(x,y,z))


var/list/autotile_rules = list(
	"Grass"=list("grass"=1),
	"grass2"=list("grass2"=1),
	"dirt"=list("dirt"=1))
turf/Area
turf/var/destroyable=1
mob/var/tmp
	stepcounter=0
	foot="Left"
	speeddelay=0
turf/Terrain
	var
		HP=100
		BP=0
		Base=0
		Res=0

turf/Terrain
	ChainLinkFenceM
		icon='Urban.dmi'
		icon_state="ChainLink_M"
		density=1
		density_factor=1
	ChainLinkFenceT
		icon='Urban.dmi'
		icon_state="ChainLink_T"
		density=1
		density_factor=1
	VegetaTurf1
		icon='tileset2.dmi'
		icon_state="crackedGround3"
		destroyable=0
		HP=100
		BP=100
		Base=100
		Res=100


	VegetaTurf2
		name = "Dirt"
		icon='tileset2.dmi'
		icon_state="dirt3"
		destroyable=0
		HP=100
		BP=100
		Base=100
		Res=100



	Grass
		name = "Grass"
		icon='tileset2.dmi'
		icon_state="grass1"
		destroyable=1
		HP=100
		BP=100
		Base=100
		Res=100



	Grass2
		name = "Grass"
		icon='tileset2.dmi'
		icon_state="grass2"
		destroyable=1
		HP=100
		BP=100
		Base=100
		Res=100


	namekwaters
		name = "Namek Ocean"
		icon='LiquidTurfs.dmi'
		icon_state="Namekwater"
		liquid = "water"
		density=0
		destroyable=0
		HP=100
		BP=100
		Base=100
		Res=100
		layer=99999999999999


	Namek_Sand
		name = "Sand"
		icon='NewNamekTileset.dmi'
		destroyable=0
		HP=100
		BP=100
		Base=100
		Res=100
		layer=2
		ns1
			icon_state="ns1"
		ns2
			icon_state="ns2"
		ns3
			icon_state="ns3"
		ns4
			icon_state="ns4"
		ns5
			icon_state="ns5"
		ns6
			icon_state="ns6"
		ns7
			icon_state="ns7"
		ns8
			icon_state="ns8"
		ns9
			icon_state="ns9"

	Cliffs_Namek
		icon='NewNamekTileset.dmi'
		destroyable=0
		density=1
		HP=100
		BP=100
		Base=100
		Res=100
		layer=2
		wt1
			icon_state="wt1"
		wt2
			icon_state="wt2"
		wtg
			icon_state="wtg3"




		nbg2
			icon_state="nbg2"
		nbg3
			icon_state="nbg3"
		nbg4
			icon_state="nbg4"
		nbg5
			icon_state="nbg5"
		nbg6
			icon_state="nbg6"
		nbg7
			icon_state="nbg7"
		nbg8
			icon_state="nbg8"
		nbg9
			icon_state="nbg9"

	lavalake
		name = "Lava Lake"
		icon='LiquidTurfs.dmi'
		icon_state="LavaLake"
		density=0
		destroyable=0
		HP=100
		BP=100
		Base=100
		Res=100
		Lava=1


	lavabubble
		name = "Lava"
		icon='LiquidTurfs.dmi'
		icon_state="LavaBubble"
		destroyable=0
		HP=100
		BP=100
		Base=100
		Res=100
		Lava=1


	sand
		name = "Sand"
		icon='tileset1.dmi'
		icon_state="sand"
		destroyable=0
		HP=100
		BP=100
		Base=100
		Res=100

	dirt
		name = "Dirt"
		icon='namek_earth_andmisc.dmi'
		icon_state="dirt"
		destroyable=1
		HP=100
		BP=100
		Base=100
		Res=100

	pink_snow
		name = "Pink Snow"
		icon='fakeicerr.dmi'
		icon_state="pink"
		destroyable=0
		HP=100
		BP=100
		Base=100
		Res=100


	snow
		name = "Snow"
		icon='namek_earth_andmisc.dmi'
		icon_state="snow"
		destroyable=0
		HP=100
		BP=100
		Base=100
		Res=100


	tourneytiles
		icon='namek_earth_andmisc.dmi'
		icon_state="tourneytiles"
		destroyable=0
		HP=100
		BP=100
		Base=100
		Res=100


	cliff1
		icon='namek_earth_andmisc.dmi'
		icon_state="clif"
		destroyable=0
		HP=100
		BP=100
		Base=100
		Res=100


	cliff2
		icon='namek_earth_andmisc.dmi'
		icon_state="cliff2"
		destroyable=0
		HP=100
		BP=100
		Base=100
		Res=100


	cliffwater
		icon='namek_earth_andmisc.dmi'
		icon_state="cliff-water"
		destroyable=0

	Water1
		name = "Ocean Water"
		icon='LiquidTurfs.dmi'
		icon_state="OceanLight"
		density=0
		liquid = "water"
		destroyable=1
		HP=100
		BP=100
		Base=100
		Res=100
		alpha=255
		layer=99999999

		/*verb
			Gather()
				set category="Other"
				set src in oview(1)
				usr.SWater+=1
				usr.CheckMaterials()*/
	hellground1
		icon='tileset3.dmi'
		icon_state="hellground1"
		destroyable=0
		HP=100
		BP=100
		Base=100
		Res=100


	hellground2
		icon='tileset3.dmi'
		icon_state="hellground2"
		destroyable=0
		HP=100
		BP=100
		Base=100
		Res=100


	hellground3
		icon='tileset3.dmi'
		icon_state="hellground3"
		destroyable=0
		HP=100
		BP=100
		Base=100
		Res=100


	hellground4
		icon='tileset3.dmi'
		icon_state="hellground4"
		destroyable=0
		HP=100
		BP=100
		Base=100
		Res=100


	hellground5
		icon='tileset3.dmi'
		icon_state="hellground5"
		destroyable=0
		HP=100
		BP=100
		Base=100
		Res=100


	ash1
		icon='tileset3.dmi'
		icon_state="ash1"
		destroyable=0
		HP=100
		BP=100
		Base=100
		Res=100


	ash2
		icon='tileset3.dmi'
		icon_state="ash2"
		destroyable=0
		HP=100
		BP=100
		Base=100
		Res=100


	ash3
		icon='tileset3.dmi'
		icon_state="ash3"
		destroyable=0
		HP=100
		BP=100
		Base=100
		Res=100


	ash4
		icon='tileset3.dmi'
		icon_state="ash4"
		destroyable=0
		HP=100
		BP=100
		Base=100
		Res=100


	ash5
		icon='tileset3.dmi'
		icon_state="ash5"
		destroyable=0
		HP=100
		BP=100
		Base=100
		Res=100


	helldirt1
		icon='tileset3.dmi'
		icon_state="helldirt1"
		destroyable=0
		HP=100
		BP=100
		Base=100
		Res=100


	helldirt2
		icon='tileset3.dmi'
		icon_state="helldirt2"
		destroyable=0
		HP=100
		BP=100
		Base=100
		Res=100


	helldirt3
		icon='tileset3.dmi'
		icon_state="helldirt3"
		destroyable=0
		HP=100
		BP=100
		Base=100
		Res=100


	helldirt4
		icon='tileset3.dmi'
		icon_state="helldirt4"
		destroyable=0
		HP=100
		BP=100
		Base=100
		Res=100


	helldirt5
		icon='tileset3.dmi'
		icon_state="helldirt5"
		destroyable=0
		HP=100
		BP=100
		Base=100
		Res=100


	Clouds
		icon='build3.dmi'
		icon_state="Clouds"
		destroyable=0
		Crossed(mob/player/M)
			if(M.icon_state=="Flight"||!M.density)  return ..()
			if(prob(50))
				usr.loc=locate(rand(5,295),rand(5,295),5)
				usr<<output("You have fallen into the depths of hell!","rpoutput")
			else
				if(prob(75))
					usr<<"You are struggling to stay above!"
			..()


	WHTile
		icon='tileset1.dmi'
		icon_state="tile2"
		destroyable=0
		HP=100
		BP=100
		Base=100
		Res=100


	WTile2
		icon='tileset1.dmi'
		icon_state="tile3"
		destroyable=0
		HP=100
		BP=100
		Base=100
		Res=100



	Ice
		icon='tileset2.dmi'
		icon_state="ice1"
		destroyable=0
		HP=100
		BP=100
		Base=100
		Res=100


	Snow2
		icon='tileset2.dmi'
		icon_state="snow1"
		destroyable=0
		HP=100
		BP=100
		Base=100
		Res=100


	Ytile
		icon='Chekpoint_Tileset (1).dmi'
		icon_state="YTile"
		destroyable=0
		HP=100
		BP=100
		Base=100
		Res=100


	Wtile
		icon='Chekpoint_Tileset (1).dmi'
		icon_state="WTile"
		destroyable=0
		HP=100
		BP=100
		Base=100
		Res=100


	WtileE
		icon='Chekpoint_Tileset (1).dmi'
		icon_state="WTileEdge"
		HP=100
		BP=100
		Base=100
		Res=100

	GroofM
		icon='Chekpoint_Tileset (1).dmi'
		icon_state="Groofmiddle"
		density=1
		density_factor=1
		layer=MOB_LAYER+1

	GroofT
		icon='Chekpoint_Tileset (1).dmi'
		icon_state="Grooftop"
		density=1
		density_factor=1
		layer=MOB_LAYER+1

	GroofEM
		icon='Chekpoint_Tileset (1).dmi'
		icon_state="GEdgeMiddle"
		density=1
		density_factor=1
		layer=MOB_LAYER+1

	GroofEL
		icon='Chekpoint_Tileset (1).dmi'
		icon_state="GEdgeLeft"
		density=1
		density_factor=1
	GroofER
		icon='Chekpoint_Tileset (1).dmi'
		icon_state="GEdgeRight"
		density=1
		density_factor=1
		layer=MOB_LAYER+1

	SBM
		icon='Chekpoint_Tileset (1).dmi'
		icon_state="SBMiddle"
	SBTR
		icon='Chekpoint_Tileset (1).dmi'
		icon_state="SBtopright"
	SBTL
		icon='Chekpoint_Tileset (1).dmi'
		icon_state="SBTopleft"
	SBBL
		icon='Chekpoint_Tileset (1).dmi'
		icon_state="SBbottomleft"
	SBBR
		icon='Chekpoint_Tileset (1).dmi'
		icon_state="SBbottomright"
	SBMR
		icon='Chekpoint_Tileset (1).dmi'
		icon_state="SBmiddleright"
	SBML
		icon='Chekpoint_Tileset (1).dmi'
		icon_state="SBmiddleleft"
	SBMB
		icon='Chekpoint_Tileset (1).dmi'
		icon_state="SBmiddlebottom"
	SBMT
		icon='Chekpoint_Tileset (1).dmi'
		icon_state="SBmiddletop"
	W4M
		icon='Chekpoint_Tileset (1).dmi'
		icon_state="W4Middle"
		density=1
		density_factor=1
	W4T
		icon='Chekpoint_Tileset (1).dmi'
		icon_state="W4top"
		density=1
		density_factor=1
	SWB
		icon='SnakeWayRedo.dmi'
		icon_state="SnakeBrick"
	SWH
		icon='SnakeWayRedo.dmi'
		icon_state="S-Horizontal"
	SWV
		icon='SnakeWayRedo.dmi'
		icon_state="S-Vertical"

	SWC1
		icon='SnakeWayRedo.dmi'
		icon_state="S-Curve-1"
	SWC2
		icon='SnakeWayRedo.dmi'
		icon_state="S-Curve-2"
	SWC3
		icon='SnakeWayRedo.dmi'
		icon_state="S-Curve-3"
	SWC4
		icon='SnakeWayRedo.dmi'
		icon_state="S-Curve-4"
	SWE1
		icon='SnakeWayRedo.dmi'
		icon_state="S-End-1"
	SWE2
		icon='SnakeWayRedo.dmi'
		icon_state="S-End-2"
	SWEL
		icon='SnakeWayRedo.dmi'
		icon_state="S-Edge-Left"
	SWER
		icon='SnakeWayRedo.dmi'
		icon_state="S-Edge-Right"
	SWET
		icon='SnakeWayRedo.dmi'
		icon_state="S-Edge-Top"
	SWEB
		icon='SnakeWayRedo.dmi'
		icon_state="S-Edge-Bottom"
	SWP1
		icon='SnakeWayRedo.dmi'
		icon_state="C-Piece1"
	SWP2
		icon='SnakeWayRedo.dmi'
		icon_state="C-Piece2"
	SWP3
		icon='SnakeWayRedo.dmi'
		icon_state="C-Piece3"
	SWP4
		icon='SnakeWayRedo.dmi'
		icon_state="C-Piece4"
turf
	var/Space=0
	Space
		Space=1
		icon='tileset1.dmi'


		DenseSpace
			icon_state= "space2"

		LightSpace
			icon_state= "space"
			Crossed(mob/player/M)
				if(M.icon_state=="KO") return
				if(!ismob(M)) return
				..()
				/*if(!M.isFloating)
					M.goSpace(src.name) // If they're a player, THEY GO SWIMMING. Send the name of the turf along so it can assign the proper overlay.
					return ..()*/


			/*Exited(mob/player/M)
				if(!istype(loc, /turf/Space))
					M.isFloating=0
					return..()
				return ..()*/
/*turf/proc/Destroy()
	if(src.destroyable)
		if(type==/turf/VegetaTurf1||type==/turf/VegetaTurf2||type==/turf/Grass||type==/turf/Grass2||type==/turf/namekwater||type==/turf/namekgrass||type==/turf/lavalake||type==/turf/lavabubble||type==/turf/sand||type==/turf/dirt||type==/turf/snow||type==/turf/tourneytiles||type==/turf/cliff1||type==/turf/cliff2||type==/turf/cliffwater||type==/turf/water1||type==/turf/hellground1||type==/turf/hellground2||type==/turf/hellground3||type==/turf/hellground4||type==/turf/hellground5||type==/turf/ash1||type==/turf/ash2||type==/turf/ash3||type==/turf/ash4||type==/turf/ash5||type==/turf/helldirt1||type==/turf/helldirt2||type==/turf/helldirt3||type==/turf/helldirt4||type==/turf/helldirt5||type==/turf/WHTile||type==/turf/WTile2||type==/turf/Snow2||type==/turf/Ytile||type==/turf/Wtile||type==/obj/buildables/tree1)
			new/turf/dirt(locate(x,y,z))*/

mob
	proc
		SpaceCheck()
			var/turf/Space/A = locate(/turf/Space) in view(src)
			if(A)
				src.loc = A.loc
				return 1

			else

				return 0





///////// DBG Sets

obj
	var
		Tree=0
		MoveLv=1
obj/GDBGSet
	trees
		hp=999999999999999999999
		bound_x=-32
		bound_y=-32
		density=1
		Tree=1
		bolted = 2

		treegreen
			name = "Green Tree"
			icon='tree.dmi'
			layer=MOB_LAYER+1
			density=1
			density_factor = 1
			//Tree=1
			bolted = 1
			bounds = "-14,10 to 47,35"
			hashadow = 0
			weight = 2
			tree=1
			hp=1
		treered
			name = "Red Tree"
			icon='tree_red.dmi'
			layer=MOB_LAYER+1
			density=1
			density_factor = 1
			//Tree=1
			bolted = 1
			bounds = "22,88 to 76,6"
			hashadow = 0
			weight = 1
			tree=1
			hp=1
		treewhite
			name = "White Tree"
			icon='tree_white.dmi'
			layer=MOB_LAYER+1
			density=1
			density_factor = 1
			//Tree=1
			bolted = 1
			bounds = "-14,10 to 47,35"
			hashadow = 0
			weight = 2
			tree=1
			hp=1
	FountainofDespair
		name = "HFIL Fountain"
		icon='fountainofdespair.dmi'
		density=1
		density_factor = 1
		bolted = 2
		icon_state=""
		can_activate = 1
		var/infused = 0
		var/full = 1
		var/refill_timer = 1500
		Click(location,control,params)
			..()
			params = params2list(params)
			if(params["left"])
				if(src in range(1,usr))
					if(src.can_activate)
						if(src.full)
							if(usr.thirst >= 100)
								usr.set_alert("Already quenched",'alert.dmi',"alert")
								return
							else
								usr.thirst += rand(89,99)
								src.icon_state = "Empty"
								src.full = 0
							view(usr)<<output("[usr] consumes water from the fountain.","actionoutput")
							if(src.bolted > 0) src.refill_timer = 1500
							spawn(src.refill_timer)
								if(src)
									src.full = 1
									src.icon_state = ""

	Canyon_Objects

		icon='Canyon_Objects.dmi'
		bound_y=-32
		bound_x=-32

		Canyon1
			name = "Canyon"
			Tree=1
			hp=999999999999999999999
			icon_state="Canyon 1"
			density=1
		Canyon2
			name = "Canyon"
			Tree=1
			hp=999999999999999999999
			icon_state="Canyon 2"
			density=1

obj/Sheep_Statue
obj/Vegeta_Throne
turf/misc

	Sheep_Statue
		icon='animals (2).dmi'
		icon_state="Sheep Statue"
		density=1
	Vegeta_Throne

	icon='Vegeta_Throne.dmi'
	pixel_x=-32
	pixel_y=-32
turf/Statues
	icon='Statues.dmi'
	name="Statue"
	EarthStatue
		name = "Statue"
		density=1
		density_factor =1
		layer=2
		icon_state="Hero"
		bolted = 2
	VegetaStatue
		name = "Statue"
		density=1
		layer=2
		icon_state="Yamoshi"
		density_factor =1
		bolted = 2
	NamekStatue
		name = "Statue"
		density=1
		layer=2
		icon_state="Guru"
		density_factor =1
		bolted = 2
	IcerStatue
		name = "Statue"
		density=1
		layer=2
		icon_state="KingKold"
		density_factor =1
		bolted = 2
	HellStatue
		name = "Statue"
		density=1
		layer=2
		icon_state="Dabura"
		density_factor =1
		bolted = 2
	HeavenStatue
		name = "Statue"
		density=1
		layer=2
		icon_state="Elder"
		density_factor =1
		bolted = 2

var
	TournamentsOpen=0
mob/var
	inTournament=0
obj/Tourny
	icon='tileset3.dmi'
	var/ZPlane=0
	Entry_Board
		icon_state="Entry_Board"
		Click()
			set src in oview(1)
			if(ZPlane==1)
				if(TournamentsOpen==1&&EarthTourny==1)
					if(Earth_Contestants<8)
						usr.loc=locate(233,131,1)
						usr.inTournament=1
						Earth_Contestants+=1
						EarthParticipants+=usr
					else
						switch(alert(usr,"The tournament is full, do you wish to spectate?","","Spectate","Cancel"))
							if("Spectate")
								usr.loc=locate(233,131,1)
								usr.inTournament=1
							if("Cancel")
								return
				else
					usr<<"No tournaments are active at the moment."
					return

			if(ZPlane==2)
				if(TournamentsOpen==1&&NamekTourny==1)
					if(Namek_Contestants<8)
						usr.loc=locate(106,185,2)
						usr.inTournament=1
						Namek_Contestants+=1
						NamekParticipants+=usr
					else
						switch(alert(usr,"The tournament is full, do you wish to spectate?","","Spectate","Cancel"))
							if("Spectate")
								usr.loc=locate(106,185,2)
								usr.inTournament=1
							if("Cancel")
								return
				else
					usr<<"No tournaments are active at the moment."
					return
			if(ZPlane==3)
				if(TournamentsOpen==1&&VegetaTourny==1)
					if(Vegeta_Contestants<8)
						usr.loc=locate(234,77,3)
						usr.inTournament=1
						Vegeta_Contestants+=1
						VegetaParticipants+=usr
					else
						switch(alert(usr,"The tournament is full, do you wish to spectate?","","Spectate","Cancel"))
							if("Spectate")
								usr.loc=locate(234,77,3)
								usr.inTournament=1
							if("Cancel")
								return
				else
					usr<<"No tournaments are active at the moment."
					return
			if(ZPlane==4)
				if(TournamentsOpen==1&&IcerTourny==1)
					if(Icer_Contestants<8)
						usr.loc=locate(84,122,4)
						usr.inTournament=1
						Icer_Contestants+=1
						IcerParticipants+=usr
					else
						switch(alert(usr,"The tournament is full, do you wish to spectate?","","Spectate","Cancel"))
							if("Spectate")
								usr.loc=locate(84,122,4)
								usr.inTournament=1
							if("Cancel")
								return
				else
					usr<<"No tournaments are active at the moment."
					return
			if(ZPlane==5)
				if(TournamentsOpen==1&&HellTourny==1)
					if(Hell_Contestants<8)
						usr.loc=locate(215,238,5)
						usr.inTournament=1
						Hell_Contestants+=1
						HellParticipants+=usr
					else
						switch(alert(usr,"The tournament is full, do you wish to spectate?","","Spectate","Cancel"))
							if("Spectate")
								usr.loc=locate(215,238,5)
								usr.inTournament=1
							if("Cancel")
								return
				else
					usr<<"No tournaments are active at the moment."
					return
			if(ZPlane==7)
				if(TournamentsOpen==1&&HeavenTourny==1)
					if(Heaven_Contestants<8)
						usr.loc=locate(71,30,7)
						usr.inTournament=1
						Heaven_Contestants+=1
						HeavenParticipants+=usr
					else
						switch(alert(usr,"The tournament is full, do you wish to spectate?","","Spectate","Cancel"))
							if("Spectate")
								usr.loc=locate(71,30,7)
								usr.inTournament=1
							if("Cancel")
								return
				else
					usr<<"No tournaments are active at the moment."
					return

	Exit
		icon_state="Exit"
		Click()
			set src in oview(1)
			if(ZPlane==1)
				usr.loc=locate(rand(234,235),129,1)
				usr.inTournament=0
				if(EarthParticipants.Find(usr))
					EarthParticipants-=usr
					Earth_Contestants-=1
					if(Earth_Contestants<0)
						Earth_Contestants=0
			if(ZPlane==2)
				usr.loc=locate(rand(109,110),183,2)
				usr.inTournament=0
				if(NamekParticipants.Find(usr))
					NamekParticipants-=usr
					Namek_Contestants-=1
					if(Namek_Contestants<0)
						Namek_Contestants=0
			if(ZPlane==3)
				usr.loc=locate(rand(235,236),75,3)
				usr.inTournament=0
				if(VegetaParticipants.Find(usr))
					VegetaParticipants-=usr
					Vegeta_Contestants-=1
					if(Vegeta_Contestants<0)
						Vegeta_Contestants=0
			if(ZPlane==4)
				usr.loc=locate(rand(85,86),120,4)
				usr.inTournament=0
				if(IcerParticipants.Find(usr))
					IcerParticipants-=usr
					Icer_Contestants-=1
					if(Icer_Contestants<0)
						Icer_Contestants=0
			if(ZPlane==5)
				usr.loc=locate(rand(216,217),236,5)
				usr.inTournament=0
				if(HellParticipants.Find(usr))
					HellParticipants-=usr
					Hell_Contestants-=1
					if(Hell_Contestants<0)
						Hell_Contestants=0
			if(ZPlane==7)
				usr.loc=locate(rand(72,73),28,7)
				usr.inTournament=0
				if(HeavenParticipants.Find(usr))
					HeavenParticipants-=usr
					Heaven_Contestants-=1
					if(Heaven_Contestants<0)
						Heaven_Contestants=0
	View_Tournament
		icon_state="View_Tournament"
		Click()
			set src in oview(1)
			//src<<"Test."
turf/Terrain/tilesets3
	icon='tileset3.dmi'
	ash1
		icon_state="ash1"
	ash2
		icon_state="ash2"
	ash3
		icon_state="ash3"
	ash4
		icon_state="ash4"
	ash5
		icon_state="ash5"
	helldirt1
		icon_state="helldirt1"
	helldirt2
		icon_state="helldirt2"
	helldirt3
		icon_state="helldirt3"
	helldirt4
		icon_state="helldirt4"
	helldirt5
		icon_state="helldirt5"

	couch_small
		icon_state="couch_small"
turf/Terrain/tilesets2
	icon='tileset2.dmi'
	book1
		icon_state="book1"
	book2
		icon_state="book2"
	bridge1
		icon_state="bridge1"
	bridge2
		icon_state="bridge2"
	clock1
		icon_state="clock1"
	cave1
		icon_state="cave1"
	crackedGround1
		name = "Ground"
		icon_state="crackedGround1"


	crackedGround2
		name = "Ground"
		icon_state="crackedGround2"

	crackedGround3
		name = "Ground"
		icon_state="crackedGround3"

	crackedGround4
		name = "Ground"
		icon_state="crackedGround4"

	crackedGround5
		name = "Ground"
		icon_state="crackedGround5"

	crackedGround6
		name = "Ground"
		icon_state="crackedGround6"

	crackedGround7
		name = "Ground"
		icon_state="crackedGround7"


	grass1
		name = "Grass"
		icon_state="grass1"

	grass2
		name = "Grass"
		icon_state="grass2"

	grass3
		name = "Grass"
		icon_state="grass3"

	snow1
		name = "Snow"
		icon_state="snow1"

	mushroomsBlue
		name = "Blue Mushroom"
		icon_state="mushroomsBlue"
	mushroomsRed
		name = "Red Mushroom"
		icon_state="mushroomsRed"
	lava1
		name = "Lava"
		icon_state="lava1"
	log1
		icon_state="log1"
	sand1
		icon_state="sand1"


	sand2
		icon_state="sand2"

	sand3
		icon_state="sand3"

	sand4
		icon_state="sand4"

	stonefloor1
		icon_state="stonefloor1"

	stonefloor2
		icon_state="stonefloor2"

	stonefloor3
		icon_state="stonefloor3"

	tiles1
		icon_state="tiles1"
		Crossed(mob/M)
			..()
	tiles2
		icon_state="tiles2"
		Crossed(mob/M)
			..()
	tiles3
		icon_state="tiles3"
		Crossed(mob/M)
			..()
	tiles4
		icon_state="tiles4"
		Crossed(mob/M)
			..()
	water1
		icon_state="water1"
		Crossed(mob/M)
			..()
	water2
		icon_state="water2"
		Crossed(mob/M)
			..()
	water3
		icon_state="water3"
		Crossed(mob/M)
			..()
	glassfloor1
		icon_state="glassfloor1"
		Crossed(mob/M)
			..()
	glassfloor2
		icon_state="glassfloor2"
		Crossed(mob/M)
			..()
	/*namekgrass
		icon = 'NewNamekTileset.dmi'
		icon_state="nbg1"*/

	sign1
		icon_state="sign1"
	bush1
		icon_state="bush1"
	bush2
		icon_state="bush2"
	bush3
		icon_state="bush3"
	bush4
		icon_state="bush4"
	bush5
		icon_state="bush5"
	bush6
		icon_state="bush6"
	log2
		icon_state="log2"
turf/Terrain/tilesets1
	icon='tileset1.dmi'
	tile1
		icon_state="tile1"
		Crossed(mob/M)
			..()
	tile2
		icon_state="tile2"
		Crossed(mob/M)
			..()
	tile3
		icon_state="tile3"
		Crossed(mob/M)
			..()
	tile4
		icon_state="tile4"
		Crossed(mob/M)
			..()
	stone4
		icon_state="stone4"
		Crossed(mob/M)
			..()

	stone5
		icon_state="stone5"
		Crossed(mob/M)
			..()
	stone6
		icon_state="stone6"
		Crossed(mob/M)
			..()
	carpetstairs
		icon_state="carpetstairs"
		Crossed(mob/M)
			..()
	stonestairs
		icon_state="stonestairs"
		Crossed(mob/M)
			..()
	whitestairs
		icon_state="whitestairs"
		Crossed(mob/M)
			..()
	woodstairs
		icon_state="woodstairs"
		Crossed(mob/M)
			..()
	kitchentile
		icon_state="kitchentitle"
		Crossed(mob/M)
			..()
	droof
		icon_state="droof"
		Crossed(mob/M)
			..()
	dredroof
		opacity=1
		density=1
		icon_state="dredroof"
	water5
		icon_state="water5"
		Crossed(mob/M)
			..()
	stonefloor1
		icon_state="stonefloor1"

	stonefloor2
		icon_state="stonefloor2"

	stonefloor3
		icon_state="stonefloor3"


	grass4
		icon_state="grass4"
	grass5
		icon_state="grass5"

	grass6
		icon_state="grass6"

	grass7
		icon_state="grass7"

	table1
		icon_state="table1"
		Crossed(mob/M)
			..()
	chair1
		icon_state="chair1"
		Crossed(mob/M)
			..()
	plank
		name = "Floor"
		icon_state="plank"
		Crossed(mob/M)
			..()
	plank2
		icon_state="plank2"
		Crossed(mob/M)
			..()
	plank3
		icon_state="plank3"
		Crossed(mob/M)
			..()
	desktopmiddle
		density=1
		density_factor=1
		icon_state="desktopmiddle"
		Crossed(mob/M)
			..()
	desktopleft
		icon_state="desktopleft"
		Crossed(mob/M)
			..()
	desktopright
		icon_state="desktopright"
		Crossed(mob/M)
			..()
	deskleft
		icon_state="deskleft"
		density=1
		density_factor=1
		Crossed(mob/M)
			..()
	deskright
		icon_state="deskright"
		density=1
		density_factor=1
		Crossed(mob/M)
			..()
	deskmiddle
		icon_state="deskmiddle"
		density=1
		density_factor=1
		Crossed(mob/M)
			..()

turf/Terrains/WestCity
	icon='WestCity.dmi'
	sovereignland=1
	Street1
		icon_state="street1"

	Street2
		icon_state="street2"

	Street3
		icon_state="street3"

	Street4
		icon_state="street4"

	Street5
		icon_state="street5"

	Street6
		icon_state="street6"

	Street7
		icon_state="street7"

	Street8
		icon_state="street8"

	Floor1
		icon_state="floor1"

	Floor2
		icon_state="floor2"

	Floor3
		icon_state="floor3"

	Floor4
		icon_state="floor4"

	Floor5
		icon_state="floor5"

	Floor6
		icon_state="floor6"

	Floor7
		icon_state="floor7"

	Floor8
		icon_state="floor8"


	Floor9
		icon_state="floor9"


	Drain
		icon_state="drain"
		Crossed(mob/M)
			..()
	Wall1
		icon_state="wall1"
		density=1
		Crossed(mob/M)
			..()
	Wall2
		icon_state="wall2"
		density=1
		Crossed(mob/M)
			..()
	Wall3
		icon_state="wall3"
		density=1
		Crossed(mob/M)
			..()
	Wall4
		icon_state="wall4"
		density=1
		Crossed(mob/M)
			..()
	Wall5
		icon_state="wall5"
		density=1
		Crossed(mob/M)
			..()
	Wall6
		icon_state="wall6"
		density=1
		Crossed(mob/M)
			..()
	Wall7
		icon_state="wall7"
		density=1
		Crossed(mob/M)
			..()
	Wall8
		icon_state="wall8"
		density=1
		Crossed(mob/M)
			..()
	Wall9
		icon_state="wall9"
		density=1
		Crossed(mob/M)
			..()
	Wall10
		icon_state="wall10"
		density=1
		Crossed(mob/M)
			..()
	Wall11
		icon_state="wall11"
		density=1
		Crossed(mob/M)
			..()
	Wall12
		icon_state="wall12"
		density=1
	Wall13
		icon_state="wall13"
		density=1
	Wall14
		icon_state="wall14"
		density=1
		Crossed(mob/M)
			..()
	Wall15
		icon_state="wall15"
		density=1
		Crossed(mob/M)
			..()
	Wall16
		icon_state="wall16"
		density=1
		Crossed(mob/M)
			..()
	Wall17
		icon_state="wall17"
		density=1
		Crossed(mob/M)
			..()
	Wall18
		icon_state="wall18"
		density=1
		Crossed(mob/M)
			..()
	NewsStand
		icon_state="40"
		density=1
		Crossed(mob/M)
			..()
	Table
		icon_state="table"
		density=1
		Crossed(mob/M)
			..()

