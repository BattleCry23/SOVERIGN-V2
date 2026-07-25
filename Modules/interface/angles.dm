
proc
	NumToAngle(num)//Converts a facing direction to an angle
		if(isnum(num)) num=num2text(num)
		if(num=="4")		//East
			num=0
		else if(num=="5")	//Northeast
			num=45
		else if(num=="1")	//North
			num=90
		else if(num=="9")	//Northwest
			num=135
		else if(num=="8") 	//West
			num=180
		else if(num=="10") 	//Southwest
			num=225
		else if(num=="2") 	//South
			num=270
		else if(num=="6") 	//South east
			num=315
		if(istext(num)) num=text2num(num)
		return num
	NumToAngle2(num)//Converts a facing direction to an angle
		if(isnum(num)) num=num2text(num)
		if(num=="4")		//East
			num=0
		else if(num=="5")	//Northeast
			num=315
		else if(num=="1")	//North
			num=270
		else if(num=="9")	//Northwest
			num=225
		else if(num=="8") 	//West
			num=180
		else if(num=="10") 	//Southwest
			num=135
		else if(num=="2") 	//South
			num=90
		else if(num=="6") 	//South east
			num=45
		if(istext(num)) num=text2num(num)
		return num
	NumToAngle3(var/num)//Converts an angle into the opposite direction of that angle
		var/d = 0
		if(num==0)		//East
			d = WEST
		else if(num==45)	//Northeast
			d = SOUTHWEST
		else if(num==90)	//North
			d = SOUTH
		else if(num==135)	//Northwest
			d = SOUTHEAST
		else if(num==180) 	//West
			d = EAST
		else if(num==225) 	//Southwest
			d = NORTHEAST
		else if(num==270) 	//South
			d = NORTH
		else if(num==315) 	//South east
			d = NORTHWEST
		return d
atom
	proc
		GetAngle(var/turf/t)//Calculate angle from src to t works on nonmovable
			if(istype(src,/atom/movable)&&istype(t,/atom/movable)) return src.GetAngleStep(t)
			else
				if(t==null) return
				var/sx=t.x-src.x
				var/sy=t.y-src.y
				var/sz=sqrt(sx*sx+sy*sy)
				if(sz==0)
					sz+=0.1
				var/degrees=arccos(sx/sz)
				if(t.y>src.y) degrees=(360-degrees)
				return round(degrees)
		GetAngleStep(var/atom/movable/t)//Calculate angle from src to t works on movables
			if(t==null) return
			if(istype(src,/atom/movable)&&istype(t,/atom/movable))
				var/sizex=(t:bound_height-32)/2
				var/sizey=(t:bound_width-32)/2
				var/sx=(t.x+(t.step_x+sizex)/32)-(src.x+src:step_x/32)
				var/sy=(t.y+(t.step_y+sizey)/32)-(src.y+src:step_y/32)
				var/sz=sqrt(sx*sx+sy*sy)
				if(sz==0)
					sz+=0.1
				var/degrees=arccos(sx/sz)
				if(t.y>src.y) degrees=(360-degrees)
				return round(degrees)
			else return src.GetAngle(t)
	movable
		var/movedelay=0
		proc
			MoveAngInstant(ang,pixels,walk=0,wait=1,target)//Calls move ang without the waiting
				set waitfor=FALSE
				MoveAng(ang,pixels,walk,wait,target)
			MoveAng(ang,pixels,walk=0,wait=1,target)//Moves an objects at specified distance and angle, set walk to 1 to check inbetween destination, set wait for a delay per step
				var/a=step_x,var/b=step_y,var/r=pixels
				if(r<0)
					ang+=180
					r=abs(r)
				movedelay=0
				if(walk&&r>32)
					var/dcovering=r
					var/turf/begin=src.loc
					while(dcovering>0)
						r=dcovering
						if(dcovering>32) r=32
						dcovering-=32
						var/x=a+r*(cos(ang)); var/y=b-r*(sin(ang));
						var/movesx=round((x)/32);var/movesy=round((y)/32)
						x-=movesx*32; y-=movesy*32;
						if(begin)
							begin=locate(begin.x+movesx,begin.y+movesy,begin.z)
							var/returnvalue=src.Move(begin,,x,y,2)
							if(returnvalue==0) break
							if(wait) sleep(wait)
						//sleep(0.1)
				else
					var/x=a+r*(cos(ang)); var/y=b-r*(sin(ang));
					var/movesx=round((x)/32);var/movesy=round((y)/32)
					x-=movesx*32; y-=movesy*32;
					var/turf/begin=locate(src.x+movesx,src.y+movesy,src.z)
					if(begin) src.Move(begin,,x,y)
				src.set_shadow()


