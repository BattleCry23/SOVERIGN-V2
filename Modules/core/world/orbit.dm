proc/distsq(atom/a1, atom/a2)
  return (a1.x-a2.x)*(a1.x-a2.x) + (a1.y-a2.y)*(a1.y-a2.y)

atom/movable
	var/orbit_rsq
	var/orbit_clockwise

	proc/SetOrbitRadius(r)
		orbit_rsq = r*(r+1)    // roughly (r+0.5)**2

  // call this for each time you want this mob to move

	proc/Orbit(atom/A)
		var/nextdir = get_dir(A, src)
		// spiral outward or continue on a tangent if possible
		nextdir = turn(nextdir, (orbit_clockwise ? -45 : 45))
		var/turf/T = get_step(src, nextdir)
		if(distsq(T, A) <= orbit_rsq)
			return Move(T, nextdir)
		// try something closer in
		nextdir = turn(nextdir, (orbit_clockwise ? -45 : 45))
		T = get_step(src, nextdir)
		if(distsq(T, A) <= orbit_rsq)
			return Move(T, nextdir)
		// last chance; spiral inward
		nextdir = turn(nextdir, (orbit_clockwise ? -45 : 45))
		T = get_step(src, nextdir)
		return Move(T, nextdir)
	proc/orbit_turf(atom/movable/a,atom/movable/b, speed, dist,locale)
		var/s = sin(locale)
		var/c = cos(locale)
		var/nx = round(c * dist + b.x * 32 + b.bound_x + b.bound_width / 2, 1)
		var/ny = round(s * dist + b.y * 32 + b.bound_y + b.bound_height / 2, 1)
		var/turf/t = locate(round(nx / 32) + 1, round(ny / 32) + 1, a.z)
		return t
	proc/orbit_pos(atom/movable/a,atom/movable/b,dist,locale)
		var/s = sin(locale)
		var/c = cos(locale)
		var/nx = round(c * dist + b.x * 32 + b.bound_x + b.bound_width / 2, 1)
		var/ny = round(s * dist + b.y * 32 + b.bound_y + b.bound_height / 2, 1)
		var/turf/t = locate(round(nx / 32) + 1, round(ny / 32) + 1, a.z)
		return t
	proc/orbiting(atom/movable/a,atom/b, speed, dist,locale,func)
		var/dist_og = dist
		dist = 33
		var/dist_num = 1
		var/mob/m = null
		if(ismob(a)) m = a
		spawn()
		for(var/degrees = locale; 1; degrees += speed)
			dist += dist_num
			speed = 500/dist
			if(dist <= 24)
				dist_num = 1
			if(dist >= dist_og)
				dist_num = -1
			if(m && m.function != func || b == null)
				m.orbiting = 0
				if(m.floats)
					animate(m)
					animate(m,pixel_y = 10, time = 20,loop = -1)
					animate(pixel_y = 0, time = 20)
				return
			if(degrees >= 360) degrees -= 360
			if(degrees < 0) degrees += 360
			var/s = sin(degrees)
			var/c = cos(degrees)
			var/nx = round(c * dist + b.x * 32, 1)
			var/ny = round(s * dist + b.y * 32, 1)
			//var/nx = round(c * dist + b.x * 32 + b.bound_x + b.bound_width / 2, 1)
			//var/ny = round(s * dist + b.y * 32 + b.bound_y + b.bound_height / 2, 1)
			var/true_x = round(nx/32)
			var/true_y = round(ny/32)
			if(true_x >= 500 || true_x <= 1)
				m.orbiting = 0
				if(m.floats)
					animate(m)
					animate(m,pixel_y = 10, time = 20,loop = -1)
					animate(pixel_y = 0, time = 20)
				return
			else if(true_y >= 500 || true_y <= 1)
				m.orbiting = 0
				if(m.floats)
					animate(m)
					animate(m,pixel_y = 10, time = 20,loop = -1)
					animate(pixel_y = 0, time = 20)
				return
			a.loc = locate(round(nx / 32) + 1, round(ny / 32) + 1, a.z)
			//a.step_x = nx - a.x * 32 - a.bound_x - a.bound_width / 2
			//a.step_y = ny - a.y * 32 - a.bound_y - a.bound_height / 2
			a.step_x = nx - a.x * 32
			a.step_y = ny - a.y * 32
			a.set_shadow()
			sleep(0.1)
	proc/orbiting_blackhole(atom/movable/a,atom/b, speed, dist,locale,func)
		var/dist_og = dist
		//dist = 33
		var/dist_num = 1
		spawn()
		for(var/degrees = locale; 1; degrees += speed)
			dist += dist_num
			speed = 500/dist
			if(dist <= 18)
				dist_num = 1
				a.destroy()
				return
			if(dist >= dist_og)
				dist_num = -1
			if(degrees >= 360) degrees -= 360
			if(degrees < 0) degrees += 360
			var/s = sin(degrees)
			var/c = cos(degrees)
			var/nx = round(c * dist + b.x * 32, 1)
			var/ny = round(s * dist + b.y * 32, 1)
			//var/nx = round(c * dist + b.x * 32 + b.bound_x + b.bound_width / 2, 1)
			//var/ny = round(s * dist + b.y * 32 + b.bound_y + b.bound_height / 2, 1)
			var/true_x = round(nx/32)
			var/true_y = round(ny/32)
			if(true_x >= 500 || true_x <= 1)
				return
			else if(true_y >= 500 || true_y <= 1)
				return
			a.loc = locate(round(nx / 32) + 1, round(ny / 32) + 1, a.z)
			//a.step_x = nx - a.x * 32 - a.bound_x - a.bound_width / 2
			//a.step_y = ny - a.y * 32 - a.bound_y - a.bound_height / 2
			a.step_x = nx - a.x * 32
			a.step_y = ny - a.y * 32
			a.set_shadow()
			sleep(0.1)
