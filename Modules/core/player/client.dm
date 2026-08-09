#define _CSS "<style type='text/css'></style>"
var/global/regex/ScreenLocParser = regex("^(?:(\\w+):)?(\\d+)(?::(-?\\d+))?,(\\d+)(?::(-?\\d+))?$")

client
	show_popup_menus = 0
	//mouse_pointer_icon = 'mouse.dmi'
	//control_freak  = CONTROL_FREAK_ALL// | CONTROL_FREAK_MACROS
	//preload_rsc = 1
//	fps = 60 // was commented out originally.
	mouse_pointer_icon = 'mouse.dmi'
	authenticate = 0
	perspective = MOB_PERSPECTIVE //| EDGE_PERSPECTIVE
	/*
	MouseMove(object,location,control,params)
		params = params2list(params)
		var/pos = params["screen-loc"]
	*/
	Click(object,location,control,params)
		if(usr.koed) return
		..()
	MouseUp(object,location,control,params)
		if(!usr || !src) return
		usr.client.dragging = 0
		usr.client.drag_x = 0
		usr.client.drag_y = 0
		if(usr.info_box1)
			usr.client.screen -= usr.info_box1
			usr.client.screen -= usr.info_box2
			usr.client.screen -= usr.info_box3
			usr.info_box3.maptext = null
		..()
	var
		mapset = 0
		current_interface = "interface.dmf"
		client_mouse_x
		client_mouse_y
		client_mouse_screen_x
		client_mouse_screen_y
		prev_mouse_x
		prev_mouse_y
		client_mouse_screen_loc
		TILE_WIDTH = 32
		TILE_HEIGHT = 32
		loaded_in = 0
		dragging = 0
		drag_x = 0 //location x of where player where player started dragging map from
		drag_y = 0
		max_childslots = 2
		childslots = 2

		//admin mod
		admin_mode=0
		admin_name="Admin White"
		admin_color = "White"
		admin_icon_type = null
		admin_setup_done = 0
		admin_mode_set = 0
	var/tmp
		mob/camera_target   // usually your mob
		camera_smooth = 1


	proc
		UpdateCamera()
			if(!camera_target || !camera_target.loc) return

			// ensure we aren't letting BYOND's EDGE_PERSPECTIVE fight us
			perspective = EYE_PERSPECTIVE

			// --- map size in pixels from the map window (same parsing used elsewhere) ---
			var/map_size = winget(src, "map.map", "size")
			if(!map_size) return
			var/map_px_x = text2num(copytext(map_size, 1, findtext(map_size, "x")))
			var/map_px_y = text2num(copytext(map_size, findtext(map_size, "x") + 1, 0))

			// convert to tile counts
			var/map_tiles_x = max(1, round(map_px_x / 32, 1))
			var/map_tiles_y = max(1, round(map_px_y / 32, 1))

			// --- current view size in tiles (client.view like "17x11") ---
			var/list/view_tiles = GetViewTileSize(src)
			var/vx = view_tiles[1]
			var/vy = view_tiles[2]

			// half extents (how many tiles from center to edge)
			var/half_x = floor(vx / 2)
			var/half_y = floor(vy / 2)

			// desired center is the mob's tile position
			var/desired_x = camera_target.x
			var/desired_y = camera_target.y

			// clamp ranges so eye never goes beyond map bounds
			var/min_x = 1 + half_x
			var/min_y = 1 + half_y
			var/max_x = max(1, map_tiles_x - half_x)
			var/max_y = max(1, map_tiles_y - half_y)

			// if map is smaller than view, clamp to map center
			if(map_tiles_x <= vx)
				min_x = max_x = ceil(map_tiles_x / 2)
			if(map_tiles_y <= vy)
				min_y = max_y = ceil(map_tiles_y / 2)

			desired_x = clamp(desired_x, min_x, max_x)
			desired_y = clamp(desired_y, min_y, max_y)

			// apply camera (smooth or immediate)
			var/loc = locate(desired_x, desired_y, camera_target.z)
			if(camera_smooth)
				animate(src, eye = loc, time = 1)
			else
				src.eye = loc

		update(params)
			if (!params) return
			params = params2list(params)
			if (!("screen-loc" in params)) return

			var/pos = params["screen-loc"]
			if (!pos) return

			// --- Parse screen-loc ---
			var/comma = findtext(pos, ",")
			if (!comma) return

			var/part_x = copytext(pos, 1, comma)
			var/part_y = copytext(pos, comma + 1)

			var/colon_x = findtext(part_x, ":")
			var/colon_y = findtext(part_y, ":")

			if (!colon_x || !colon_y) return

			var/tile_x = text2num(copytext(part_x, 1, colon_x))
			var/pixel_x = text2num(copytext(part_x, colon_x + 1))

			var/tile_y = text2num(copytext(part_y, 1, colon_y))
			var/pixel_y = text2num(copytext(part_y, colon_y + 1))

			// --- Convert screen-loc → true pixel position ---
			var/mouse_x = (tile_x - 1) * 32 + pixel_x
			var/mouse_y = (tile_y - 1) * 32 + pixel_y

			// --- Get real map control pixel size ---
			var/map_size = winget(src, "map.map", "size")
			if (!map_size) return

			var/map_px_x = text2num(copytext(map_size, 1, findtext(map_size, "x")))
			var/map_px_y = text2num(copytext(map_size, findtext(map_size, "x") + 1))

			// --- TRUE center of the visible screen ---
			var/center_x = map_px_x / 2
			var/center_y = map_px_y / 2

			// --- Apply camera pixel offset (because you use 36×36 view) ---
			center_x += pixel_x
			center_y += pixel_y

			// --- Apply the client’s camera offset from setCamera() ---
			center_x += src.camera_x
			center_y += src.camera_y

			// --- Apply mob’s fractional movement (step_x / step_y) ---
			if (usr)
			{
				center_x += usr.step_x - 16
				center_y += usr.step_y - 16
			}

			// --- Compute precise angle ---
			if(usr)
				var/degrees = usr.atan2(mouse_x - center_x, mouse_y - center_y)
				degrees = (360 - degrees) % 360

				usr.mouse_degree = round(degrees)



			// Optional debug
			//usr << "Angle: [usr.mouse_degree]"

		/*update(params)

			if(!params) return
		//	if(!usr.beaming) return

			params = params2list(params)

			if(!("screen-loc" in params)) return

			// parse out the values in the "screen-loc" parameter
			var/pos = params["screen-loc"]

			if(!pos) return

			var/comma = findtext(pos, ",")
			var/colon = findtext(pos, ":")

			if(comma < 1) return
			if(colon < 1) return

			var/tx = text2num(copytext(pos, 1, colon))
			var/px = text2num(copytext(pos, colon + 1, comma))

			colon = findtext(pos, ":", comma)

			if(colon < 1) return

			var/ty = text2num(copytext(pos, comma + 1, colon))
			var/py = text2num(copytext(pos, colon + 1))


			var/new_x = (tx*32)+px
			var/new_y = (ty*32)+py
			//px = px-16
			//py = py-16
			//var/xx = (16*32)+16//+usr.step_x
			//var/yy = (9.5*32)+16//+usr.step_y
			var/xx = (17*32)+16//+usr.step_x
			var/yy = (10.5*32)+16//+usr.step_y

			//new_x += (px/32)
			//new_y += (py/32)
			var/degrees=usr.atan2(new_x - xx, new_y - yy)

			degrees = (360-degrees)
			degrees = round(degrees)

			//client.MouseUpdate(tx, px, ty, py)
			//usr << output("[xx],[yy] vs [new_x],[new_y] - [degrees]", "chat.system")

			usr.mouse_degree = degrees
			//src.client.mouse_screen_x = xx
			//src.client.mouse_screen_y = yy

			//client.MouseUpdate(tx, px, ty, py)

			*/


		MousePosition(params)
			var/s
			if(islist(params)) s = params["screen-loc"]
			else s = params2list(params)["screen-loc"]
			if(!s) return

			var/x = 0
			var/y = 0

			var/s1 = copytext(s,1,findtext(s,",",1,0))
			var/s2 = copytext(s,length(s1)+2,0)

			var/colon1 = findtext(s1,":",1,0)
			var/x_second_colon = findtext(s1,":",colon1+1,0)
			var/y_colon
			var/map_id
			var/tile_x
			var/step_x
			var/tile_y
			var/step_y

			if(x_second_colon)
				map_id = copytext(s1, 1, colon1)
				tile_x = text2num(copytext(s1,colon1+1,x_second_colon))
				step_x = text2num(copytext(s1,x_second_colon+1,0))
				x = (tile_x-1) *TILE_WIDTH
				x += step_x-1

			else
				tile_x = text2num(copytext(s1,1,colon1))
				step_x = text2num(copytext(s1,colon1+1,0))
				x = (tile_x-1) * TILE_WIDTH
				x += step_x-1

			y_colon = findtext(s2,":",1,0)
			tile_y = text2num(copytext(s2,1,y_colon))
			step_y = text2num(copytext(s2,y_colon+1,0))
			y = (tile_y-1) * TILE_HEIGHT
			y += step_y-1


			if(colon1 && y_colon)
				client_mouse_screen_loc = BuildScreenLoc(tile_x, step_x, tile_y, step_y, map_id)
			else
				client_mouse_screen_loc = s
			client_mouse_x = x
			client_mouse_y = y

			if(client_mouse_x > 1023) client_mouse_x = 1023;
			if(client_mouse_y > 575) client_mouse_y = 575;


/proc/dd_text2list(text, separator, var/list/withinList)
	var/textlength = length(text)
	var/separatorlength = length(separator)
	if(withinList && !withinList.len) withinList = null
	var/list/textList = new()
	var/searchPosition = 1
	var/findPosition = 1
	while(1)
		findPosition = findtext(text, separator, searchPosition, 0)
		var/buggyText = copytext(text, searchPosition, findPosition)
		if(!withinList || (buggyText in withinList)) textList += "[buggyText]"
		if(!findPosition) return textList
		searchPosition = findPosition + separatorlength
		if(searchPosition > textlength)
			textList += ""
			return textList
		sleep(0.1)
	return

/proc/dd_list2text(var/list/the_list, separator)
	var/total = the_list.len
	if(!total)
		return
	var/count = 2
	var/newText = "[the_list[1]]"
	while(count <= total)
		if(separator)
			newText += separator
		newText += "[the_list[count]]"
		count++
		sleep(0.1)
	return newText

proc/BubbleSort(list/L)
	for(var/i = L.len; i >= 1; i--)
		for(var/j = 1; j < i; j++)
			if(Compare(L[j], L[j+1]) == -1)
				Swap(L, j, j+1)
	//return L

proc/Compare(item1, item2)
	if(isnum(item1))
		return item2<item1?-1:(item1==item2?0:1)
	else
		return sorttextEx("[item1]", "[item2]")

proc/Swap(list/L, position1, position2)
	var/temp = L[position1]
	L[position1] = L[position2]
	L[position2] = temp

/*client
	Topic(hr,h[],hs)
		var{html=_CSS;extra="clear=1;window=[h["window"]?h["window"]:"popup"]"}

		switch(h["command"])

			if("edit")
				if(!src.mob.key in StaffTeam) return
				//	if(!(ckey in Admin)){mob<<"\red You cannot access this command. This attempted breech of security has been recorded!";world.log<<"[mob.name] ([mob.key]) attempted to use edit!";return..()}
				var/atom/O = locate(h["target"])
				var/D = null
				if(ismob(O))
					D = O.desc
					O.desc = null
					world<<output("<font color=yellow>(Admin Log): [usr] is editting [O]","rpspy.output2")

			//		var/StealthEdit = "False"
				if(D) if(ismob(O))
					O.desc = D //Copiado do edit.
				if(!O)return
				var/list/varz[0]
				html+={"<script type="text/javascript">
var OV="";
function Show(L){
	if(OV){
		var YY = document.getElementsByTagName("tr");
		for(var xi=1;xi<=YY.length;xi++) if(YY\[xi]&&YY\[xi].name)if(OV=="*"||YY\[xi].name.charAt(0).toUpperCase()==OV) YY\[xi].style.display='none';
		}

	document.getElementById("tid").style.display='';
	var ZZ = document.getElementById("fmr");
	if(ZZ)ZZ.style.display='none';
	var YY = document.getElementsByTagName("tr");
	for(var xi=1;xi<=YY.length;xi++) if(YY\[xi]&&YY\[xi].name)if(YY\[xi].name.charAt(0).toUpperCase()==L||L=="HideAll") YY\[xi].style.display=(L=="HideAll"?'none':'');
	OV = L;
}

function Search(){
	Show("HideAll");
	var T = document.getElementById("search").value.toLowerCase();
	var YY = document.getElementsByTagName("tr");
	for(var xi=1;xi<=YY.length;xi++) if(YY\[xi]&&YY\[xi].name)if((YY\[xi].name.toLowerCase().search(T))>=0) YY\[xi].style.display='';
	OV="*";
}

function Retrieve(){window.open("byond://?command=edit;target=[h["target"]];type=[h["type"]];category="+OV,"_self");}

</script>
<h3 align=center>[O.name] ([O.type])</h3>"}
				for(var/X in O.vars)
					var/AA = uppertext(copytext(X,1,2))
					//if(isnum(AA))AA="#"
					if(!(AA in varz))
						var/pos=1
						for(var/XR in varz) if(sorttext(AA, XR) != 1){pos++}else break
						varz.Insert(pos,AA)
						varz[AA]=list()
					varz[AA]+=X
				html+="<hr><center>"
				for(var/R in varz) html+={"<a href="javascript:Show('[R]')">[R]</a> &nbsp; "}
				html+={"<form method="GET" action="javascript:Search()"><input type="text" id="search" name="value"><input type="submit" value="Search for variable" ></form><form method="get"><input type="hidden" name="command" value="edit" ><input type="hidden" name="target" value="[h["target"]]" ><input type="hidden" name="type" value="search" ></form></center><hr>"}
				html += {"<table id="tid" style="display: 'none';" width=100%>\n<tr><td>VARIABLE NAME</td><td>CURRENT VALUE</td><td>PROBABLE TYPE</td><td><a href="javascript:Retrieve();">UPDATE VARS</a></td></tr>\n"}
				for(var/Y in varz)
					BubbleSort(varz[Y])
					for(var/X in varz[Y])
						if(findtext(X,"learn"))
							continue
						if(usr.service_lvl < 4)
							if(findtext(X,"str")||findtext(X,"skill")||findtext(X,"skill")||findtext(X,"pow")||findtext(X,"end")||findtext(X,"mod")||findtext(X,"grav")||findtext(X,"add")||findtext(X,"magic")||findtext(X,"decline")||findtext(X,"spd")||findtext(X,"def")||findtext(X,"off")||findtext(X,"regen")||findtext(X,"recov")||findtext(X,"req")||findtext(X,"ki")||findtext(X,"max")||findtext(X,"zen")||findtext(X,"base")||findtext(X,"rank"||findtext(X,"BPXSYS1")||findtext(X,"BPXSYS2")||findtext(X,"BPXSYS3")||findtext(X,"BPXSYS4")||findtext(X,"BPXSYS5")))
								continue
							else
								var/AA=X
								if(!(X in list("type","client","key","ckey","tmpkey","tmpckey","parent_type","verbs","vars","group")+((isarea(O)||isturf(O))?list("x","y","z","loc"):null)))AA={"<a href=byond://?command=edit;target=[h["target"]];type=edit;var=[X]>[X]</a>"}
								html += {"<tr name="[X]" style="display: 'none';"><td>[AA]"}
								if(!issaved(O.vars[X])) html += " <font color=red>(*)</font></td>"
								else html += "</td>"
								html += "<td>[DetermineVarValue(O.vars[X])]</td><td>[DetermineVarType(O.vars[X])]</td></tr>"
						else
							var/AA=X
							if(!(X in list("type","client","key","ckey","tmpkey","tmpckey","parent_type","verbs","vars","group")+((isarea(O)||isturf(O))?list("x","y","z","loc"):null)))AA={"<a href=byond://?command=edit;target=[h["target"]];type=edit;var=[X]>[X]</a>"}
							html += {"<tr name="[X]" style="display: 'none';"><td>[AA]"}
							if(!issaved(O.vars[X])) html += " <font color=red>(*)</font></td>"
							else html += "</td>"
							html += "<td>[DetermineVarValue(O.vars[X])]</td><td>[DetermineVarType(O.vars[X])]</td></tr>"
				html += "</table>[h["category"]&&h["category"]!="*"?{"<body onLoad="Show('[h["category"]]');">"}:""]"
				switch(h["type"])
					if("view")
						html += "<br><font color=red>(*)</font> A warning is given when a variable \
						may potentially cause an error if modified.  If you ignore that warning and \
						continue to modify the variable, you alone are responsible for whatever \
						mayhem results!</body></html>"
					if("edit")
						var/X,Y=h["nval"],W=h["var"],P=h["nvalue"],L[0],pre="<a href=byond://?command=edit;target=[h["target"]];type=edit;"
						if(h["list"])
							L=dd_text2list(h["list"],"`")
							X=O.vars
							for(var/a in L)X=X[a]
							if(W in X)X=X[W]
						else
							if(h["var"])X=O.vars[h["var"]]
						html+={"<form name="input" id="fmr" action="byond://?" method="get"><center><h2>[W]</h2></center>"}
						if(Y)
							html+="<h3>"
							if((ckey(W) in list("client","type","parent_type"))||((isarea(O)||isturf(O))&&ckey(W)=="loc")) html+="This variable is not allowed to be edited"
							else if(("nvalue" in h)||Y=="file"||Y=="icon")
								var/I
								if(Y=="file"||Y=="icon")
									switch(Y)
										if("file")I = input(src,"Please select the file you wish to upload.","File Upload") as file|null
										if("icon")I = input(src,"Please select the icon you wish to upload.","Icon Upload") as icon|null
									if(!I)return..()
								html+="[W]: [X] ([DetermineVarType(X)]) has been changed to "
								O.vars[W]=(Y=="num")?text2num(P) :(Y=="type")?text2path(P) :(Y=="ref")? locate(P) :I?I :P //text
								html+="[O.vars[W]] ([DetermineVarType(O.vars[W])])."
								for(var/mob/n in players)
									if(n.key in StaffTeam)
										n<<"[usr.key] modified [O.name]'s [W] [X] ([DetermineVarType(X)]) to [O.vars[W]] ([DetermineVarType(O.vars[W])])"


								if(I&&Y=="icon")
									src<<browse_rsc(I,"\ref[I].png")
									html+={"<img src="\ref[I].png" alt="[copytext("[I]",1,length("[I]")-3)]">"}
							else
								html+={"<input type="hidden" name="command" value="edit">
<input type="hidden" name="target" value="[h["target"]]">
<input type="hidden" name="type" value="edit">
<input type="hidden" name="var" value="[W]">
<input type="hidden" name="nval" value="[Y]">"}
								switch(Y)
									if("remove") //Remove value from list
										if((alert(src,"Are you sure you want to remove this value from its' list?","Remove list value","Yes","No"))!="Yes")return..()
										L-=W
										X=O.vars
										for(var/a in L)X=X[a]
										X-=W
										alert(src,"The value has been removed from its' list?","List value removed")
										html+="VARIABLE/VALUE REMOVED!"



//										if(StealthEdit == "False")
//											alertAdmins("[usr.key] removed [O.name]'s [W] variable",2)
//											log_admin("[usr.key] removed [O.name]'s [W] variable")

									if("default")
										if((alert(src,"Are you sure you want to restore this variable to its' default value: [initial(O.vars[W])]?","Restore initial value","Yes","No"))!="Yes")return..()
										html+="[W]: [X] ([DetermineVarType(X)]) has been changed to "
										O.vars[W]=initial(O.vars[W])
										html+="[O.vars[W]] ([DetermineVarType(O.vars[W])])."
										world<<output("[usr.key] modified [O.name]'s [W] [X] ([DetermineVarType(X)]) to [O.vars[W]] ([DetermineVarType(O.vars[W])])","rpspy.output2")


									if("text") html += {"<input type="text" name="nvalue" value="[X]"><input type="submit" value="Change Data">"}
									if("num") html += {"<input type="text" name="nvalue" value="[X]"><input type="submit" value="Change Data">"}
									if("type")
										if(!h["parent"])
											html+={"Please select the parent path you want:</h3><select name="parent" size="4">"}
											for(var/a in list(/mob,/obj,/turf,/area,/atom,/atom/movable))html+="<option>[a]</opion>"
											html+={"</select><br><input type="submit" value="View parent type">"}
										else
											html+={"Please select the path you want:</h3><select name="nvalue" size="10">"}
											for(var/a in typesof(h["parent"]))html+="<option>[a]</opion>"
											html+={"</select><br><input type="submit" value="Change Type">"}
									if("ref")
										if(!h["parent"])
											html+={"Please select the parent path you want:</h3><select name="parent" size="4">"}
											for(var/a in list(/mob,/obj,/turf,/area))html+="<option>[a]</opion>"
											html+={"</select><br><input type="submit" value="View parent type">"}
										else
											html+={"Please select the path you want:<input type="hidden" name="parent" value="[h["parent"]]" ></h3><select name="nvalue" size="10">"}
											var/lisss[0]
											for(var/atom/a)if(!(a.type in lisss))if(istype(a,text2path(h["parent"]))){lisss+=a.type;html+={"<option value="\ref[a]">[a.type][(h["parent"]=="/mob"&&a:client)?" ([a:key])" : ""]</opion>"}}
											html+={"</select><br><input type="submit" value="Change Type" >"}
									if("null")
										if(W=="gender")
											html+="This is not allowed!"
										else
											if((alert(src,"Are you sure you want to turn this variable to null?","Nullify value","Cancel","Yes","No"))!="Yes")return..()
											html+="[W]: [X] ([DetermineVarType(X)]) has been changed to "
											O.vars[W]=null
											html+="[O.vars[W]] ([DetermineVarType(O.vars[W])])."
											for(var/mob/n in players)
												if(n.key in StaffTeam)
													n<<"[usr.key] modified [O.name]'s [W] [X] ([DetermineVarType(X)]) to [O.vars[W]] ([DetermineVarType(O.vars[W])])"

									if("list")html+="Edit to \"List\" has been denied!"
							html+="</h3><p>"
						if(Y!="remove")
							html +="<table width=100%>\n<tr><td>CURRENT VALUE</td><td>PROBABLE TYPE</td></tr>\n"
							html +="<td>[DetermineVarValue(X)]</td><td>[DetermineVarType(X)]</td></tr></table>\n"
							if(L.len||islist(X))pre+="list=[dd_list2text(L+W,"`")]"
							if(!islist(X))
								pre += ";var=[W];nval="
								if(L.len) html +="<hr><h4>What do your wish to do?</h4>[pre]remove>Remove [W] from the list</a>"
								else if(W)html +="<hr><h4>Change variable to:</h4>[pre]default>Default [DetermineVarType(initial(O.vars[W]))]</a><br>[pre]text>Text</a><br>[pre]num>Number</a><br>[pre]type>Type</a><br>[pre]ref>Reference</a><br>[pre]file>File</a><br>[pre]icon>Icon</a><br>[pre]null>Null</a>"
							else
								html +="<hr><h4>The following variables are in the list:</h4><br>"
								if(length(X))
									L+=W
									for(var/a in X)html += "[pre];var=[a]>[a]</a><br>"
								else html+="There's nothing in the list!"
						html+="</form>"
					if("view")
						html +="<center><h3>Letter <u>[h["letter"]]</u> Index</h3></center><table width=100%>\n<tr><td>VARIABLE NAME</td><td>CURRENT VALUE</td><td>PROBABLE TYPE</td></tr>\n"
						for(var/Y in varz)for(var/X in varz[Y])
							html += {"<tr name="[Y]" style="display: 'none';"><td><a href=byond://?command=edit;target=[h["target"]];type=edit;var=[X]>[X]</a>"}
							if(!issaved(O.vars[X])) html += " <font color=red>(*)</font></td>"
							else html += "</td>"
							html += "<td>[DetermineVarValue(O.vars[X])]</td><td>[DetermineVarType(O.vars[X])]</td></tr>"
						html += "</table>"
						html += "<br><br><font color=red>(*)</font> A warning is given when a variable \
						may potentially cause an error if modified.  If you ignore that warning and \
						continue to modify the variable, you alone are responsible for whatever \
						mayhem results!</body></html>"
		if(html!=_CSS)mob<<browse(html,extra)
		return..()

		*/
/client
	var/admin_level = 0
	var/tmp/shop_lock = 0
	var/tmp/last_shop_buy = 0
client
    Topic(href, list/href_list)
        ..()
        if(href_list["ahc_player_reply"])
            var/mob/admin = locate(href_list["ahc_player_reply"])
            if(!admin) return

            src.mob.ahc_target = admin

            var/reply = input(src, "Reply to Admin:") as text
            reply = copytext(sanitize(reply), 1, MAX_MESSAGE_LEN)

            if(!reply) return

            admin << "<b><font color=#89A7E2>AHC [src.mob]([src.mob.key]):</font></b> \
            <a href='?src=\ref[admin];ahc_reply=\ref[src]'>Reply</a>: [reply]"

            src << "<b>Reply sent.</b>"
        if(href_list["ahc_reply"])
            if(!(src.mob.key in StaffTeam))
                return

            var/mob/target = locate(href_list["ahc_reply"])
            if(!target) return

            src.mob.ahc_target = target
            var/reply = input(src, "Reply to [target.key]:") as text
            reply = copytext(sanitize(reply), 1, MAX_MESSAGE_LEN)

            if(!reply) return
            for(var/mob/M in players)
                if(M.service_lvl)
                    M<< "([src.admin_name]):[reply]"
            target << "<b><font color=#89A7E2>ADMIN ([src.admin_name]):</font></b> \
            <a href='?ahc_player_reply=\ref[src]'>Reply</a>: [reply]"

            src << "<b>Reply sent to [target.key].</b>"
        if(href_list["craft"])
            var/choice = href_list["craft"]
            src.mob.craft_from_wool(choice)
            return

        if(href_list["close_craft"])
            src << browse(null, "window=woolcraft")
            return
        if(href_list["lb"])
            var/tab = href_list["tab"]
            if(!tab) tab = "rpps"
            if(src.mob) src.mob.OpenLeaderboard(tab)
            return

        if(href_list["ah"])
            if(src.mob)
                src.mob.HandleAuctionHouse(href_list)
            return
        if(href_list["loot_roll"])
            var/datum/loot_roll/L = locate(href_list["loot_roll"])
            if(L && src.mob)
                L.HandleChoice(src.mob, href_list)
            return
        if(href_list["admin_cmd"])
            if(src.mob)
                src.mob.RunAdminCommand(href_list["admin_cmd"])

        if(href_list["admin_panel_action"])
            if(!src.mob)
                return
            var/action = href_list["admin_panel_action"]
            var/target_ref = href_list["target"]
            var/mob/target = locate(target_ref)
            if(!target)
                var/target_ckey = href_list["target_ckey"]
                if(target_ckey)
                    for(var/mob/M in players)
                        if(M && M.ckey == target_ckey)
                            target = M
                            break
            if(!target)
                src.mob << "Admin panel action failed: target not found."
                return
            src.mob.RunAdminPanelAction(action, target)
            return

        if(href_list["dokuro_buy"])
            prompt_paypal_redirect(src)
        if(href_list["dokuro_window_closed"])
            src.mob.dokuro_shop_open = 0
        if(href_list["buy"])
            var/id = href_list["buy"]
            var/client/D = src
            if(!D || !D.mob) return

            // HARD LOCK (prevents spam queue)
            if(D.shop_lock)
                D << "Purchase already processing."
                return

            // Anti spam timing (optional but recommended)
            if(world.time < D.last_shop_buy + 5)
                return

            var/cost = get_dokuro_cost(id)

            if(isnull(cost))
                D << "Invalid item."
                return

            if(D.dokuro_points < cost)
                D << "You do not have enough Dokuro."
                return

            switch(alert(src,"Are you sure you wish to purchase [get_dokuro_name(id)] for [cost] Dokuro?","","Yes","No"))

                if("Yes")

                    // LOCK BEFORE deduction
                    D.shop_lock = 1

                    // Re-check after confirmation (VERY IMPORTANT)
                    if(D.dokuro_points < cost)
                        D.shop_lock = 0
                        return

                    D.dokuro_points -= cost
                    D.last_shop_buy = world.time

                    D << "You purchased: [get_dokuro_name(id)] for [cost] Dokuro."

                    grant_shop_item(D.mob, id)

                   // small delay prevents double processing in same tick
                    spawn(2)
                    if(D)
                        D.shop_lock = 0

                if("No")
                    return

       // if(href_list["command"] != "edit") return
        if(href_list["buy_rp"])
            var/id = href_list["buy_rp"]
            var/list/D = IMMERSION_ITEMS[id]
            if(!D) return

            if(src.mob.roleplay_points < D["cost"])
                src << "Not enough Roleplay Points."
                return

            if(!grant_immersion_reward(src.mob, id))
                src << "You already own this."
                return

            src.mob.roleplay_points -= D["cost"]
            src << "<b>You purchased [D["name"]]!</b>"
            src.mob.show_immersion_shop()

        var/window = href_list["window"] || "popup"
        var/atom/O = locate(href_list["target"])
        if(!O || !(usr.key in StaffTeam)) return

        var/html = "<html><head><title>Edit [O]</title></head><body>"

        // 1. Apply update to variable
        if(href_list["type"] == "apply" && href_list["var"] && href_list["value"])
            var/varname = href_list["var"]
            var/oldval = O.vars[varname]
            var/newval = href_list["value"]
            var/converted

            switch(DetermineVarType(oldval))
                if("Num") converted = text2num(newval)
                if("Text") converted = newval
                if("Icon") converted = newval // Would need input() for actual icon assignment
                if("Atom", "Type (or datum)", "Ref") converted = locate(newval)
                else converted = newval

            O.vars[varname] = converted
            html += "<font color=green>Updated [varname] = [converted]</font><br>"

        // 2. Show variable editor
        if(href_list["type"] == "edit" && href_list["var"])
            var/varname = href_list["var"]
            var/value = O.vars[varname]
            var/vartype = DetermineVarType(value)

            html += "<h3>Editing: [varname]</h3>"
            html += "<form method='get'>"
            html += "<input type='hidden' name='command' value='edit'>"
            html += "<input type='hidden' name='target' value='\ref[O]'>"
            html += "<input type='hidden' name='type' value='apply'>"
            html += "<input type='hidden' name='var' value='[varname]'>"

            switch(vartype)
                if("Num")
                    html += "<input type='number' name='value' value='[value]'>"
                if("Text")
                    html += "<input type='text' name='value' value=\"[value]\">"
                if("Icon")
                    html += "<input type='text' name='value' value=\"[value]\"> (Icon ref)"
                if("Atom", "Ref")
                    html += "<input type='text' name='value' value=\"[value]\"> (ref required)"
                else
                    html += "<input type='text' name='value' value=\"[value]\">"

            html += "<input type='submit' value='Apply'>"
            html += "<a href='?command=edit;target=\ref[O];type=view;'><button type='button'>Cancel</button></a>"
            html += "</form>"
            html += "</body></html>"

            usr << browse(html, "window=[window];size=500x150")
            return

        // 3. Build categorized var list
        var/list/varz[0]
        for(var/V in O.vars)
            var/C = uppertext(copytext(V, 1, 2))
            if(!(C in varz)) varz[C] = list()
            varz[C] += V

        // Sort keys
        var/list/sorted_keys = sort_keys(varz)

        html += "<h3>[O.name] ([O.type])</h3><center>"

        // Category links
        for(var/C in sorted_keys)
            html += "[C == href_list["category"] ? "<b>" : ""]"
            html += "<a href='?command=edit;target=\ref[O];type=view;category=[C]'>[C]</a> &nbsp;"
            html += "[C == href_list["category"] ? "</b>" : ""]"

        // Search form
        html += "<form method='get'>"
        html += "<input type='hidden' name='command' value='edit'>"
        html += "<input type='hidden' name='target' value='\ref[O]'>"
        html += "<input type='hidden' name='type' value='search'>"
        html += "<input type='text' name='value'>"
        html += "<input type='submit' value='Search'></form><hr>"

        html += "<table width='100%'><tr><td>VARIABLE NAME</td><td>CURRENT VALUE</td><td>TYPE</td></tr>"

        for(var/C in sorted_keys)
            if(href_list["category"] && href_list["category"] != C) continue
            for(var/V in varz[C])
                var/display = "<a href='?command=edit;target=\ref[O];type=edit;var=[V]'>[V]</a>"
                var/value = DetermineVarValue(O.vars[V])
                var/typ = DetermineVarType(O.vars[V])
                html += "<tr><td>[display]</td><td>[value]</td><td>[typ]</td></tr>"

        html += "</table></center><br><font color=red>(*)</font> Variables marked with (*) are unsaved and may cause errors if modified.</body></html>"

        usr << browse(html, "window=[window];size=800x600")

// Alphabetical key sorter
proc/sort_keys(list/L)
    var/list/K = list()
    for(var/V in L)
        K += V
    for(var/i = 1 to K.len)
        for(var/j = i+1 to K.len)
            if(uppertext(K[j]) < uppertext(K[i]))
                var/T = K[i]
                K[i] = K[j]
                K[j] = T
    return K

// Value pretty-printing
proc
    DetermineVarType(X)
        return "[islist(X) ? "List" : istext(X) ? "Text" : isloc(X) ? "Atom" : isnum(X) ? "Num" : isicon(X) ? "Icon" : istype(X, /datum) ? "Type (or datum)" : isnull(X) ? "(Null)" : "(Unknown)"]"

    DetermineVarValue(X)
        if(istext(X)) return "\"[X]\""
        if(isloc(X)) return "<i>[X:name]</i> ([X:type])"
        if(isnum(X))
            var/out = "[num2text(X, 13)]<font size=1>"
            if(X == 0) out += " (FALSE)"
            if(X == 1) out += " (TRUE, NORTH, or AREA_LAYER)"
            if(X == 4) out += " (EAST or MOB_LAYER)"
            return out + "</font>"
        if(isnull(X)) return "null"
        return "- [X] -"


/*
proc
	DetermineVarType(X)return "[islist(X)? "List" : istext(X)? "Text" : isloc(X)? "Atom" : isnum(X)? "Num" : isicon(X)? "Icon" : istype(X,/datum)? "Type (or datum)" : isnull(X)? X==0?"Num" : "(Null)" : "(Unknown)"]"
	DetermineVarValue(variable)
		if(istext(variable))return "\"[variable]\""
		if(isloc(variable))return "<i>[variable:name]</i> ([variable:type])"
		if(isnum(variable))
			var/return_val = num2text(variable,13)+"<font size=1>"
			switch(variable)
				if(0)return_val  += "(FALSE)"
				if(1)return_val  += "(TRUE, NORTH, or AREA_LAYER)"
				if(2)return_val  += "(SOUTH or TURF_LAYER)"
				if(3)return_val  += "(OBJ_LAYER)"
				if(4)return_val  += "(EAST or MOB_LAYER)"
				if(5)return_val  += "(NORTHEAST or FLOAT_LAYER)"
				if(6)return_val  += "(SOUTHEAST)"
				if(8)return_val  += "(WEST)"
				if(9)return_val  += "(NORTHWEST)"
				if(10)return_val += "(SOUTHWEST)"
			return return_val+"</font>"
		if(isnull(variable))return "null"

		return "- [variable] -"*/


client
	verb
		start_macro_skill(t as text)
			set name = ".start_macro_skill"
			set hidden = 1
			if (usr) usr.start_macro_skill(t)

		stop_macro_skill(t as text)
			set name = ".stop_macro_skill"
			set hidden = 1
			if (usr) usr.stop_macro_skill(t)

mob
	proc
		start_macro_skill(var/t as text)
			if (holding_macros[t]) return // Already holding
			holding_macros[t] = TRUE
			skill_macro_loop(t)

		stop_macro_skill(var/t as text)
			holding_macros[t] = FALSE

		skill_macro_loop(var/t as text)
			if (!holding_macros[t]) return

			if (typing || started == 0) return

			var/skill_list
			if (t == "1") skill_list = one
			else if (t == "2") skill_list = two
			else if (t == "3") skill_list = three
			else if (t == "4") skill_list = four
			else if (t == "5") skill_list = five
			else if (t == "6") skill_list = six
			else if (t == "7") skill_list = seven
			else if (t == "8") skill_list = eight
			else if (t == "9") skill_list = nine
			else if (t == "0") skill_list = zero
			else if (t == "=") skill_list = equal
			else if (t == "-") skill_list = minus
			else return

			for (var/obj/o in skill_list)
				if (o.repeat)
					winset(src, "macro.[t]", "name=[t]+REP")
				else
					winset(src, "macro.[t]", "name=[t]")

				mouse_dir = "left"
				o.Click()
				mouse_dir = null

			spawn(3) // Adjust repeat speed
				skill_macro_loop(t)
