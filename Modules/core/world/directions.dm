/*
Direction datum
	This datum's constants support bit flags and uses BYOND's built-in directional constants.

	Name		| Direction		| Value
	============+===============+===================

	Center		N/A				0

	North		+Y (up)			1	(NORTH)
	South		-Y (down)		2	(SOUTH)
	East		+X (right)		4	(EAST)
	West		-X (left)		8	(WEST)

	Northeast	+X, +Y			5	(North | East)
	Northwest	-X, +Y			6	(North | West)
	Southeast	+X, -Y			9	(South | East)
	Southwest	-X, -Y			10	(South | West)

	Up			+Z				16	(UP)
	Down		-Z				32	(DOWN)

	Horizontal	N/A				12	(East  | West)
	Vertical	N/A				3	(North | South)
	Planar		N/A				15	(North | South | East| West)

Direction methods
	This datum has methods in addition to the inherited methods of the /Constants type.

	IsDiagonal(Directions/Direction)
		Returns TRUE if Direction is a diagonal direction
		(i.e. northeast, southeast, northwest, southwest).

	IsCardinal(Directions/Direction)
		Returns TRUE if Direction is a cardinal direction
		(i.e. north, south, east, west, up, down).

	FromOffset(X, Y)
		Returns a Direction that is closest to the direction of (X, Y).

	FromOffsetToCardinal(X, Y)
		Returns a cardinal Direction that is closest to the direction of (X, Y).

	FromOffsetExact(X, Y)
		Returns a Direction that somewhat points in the direction of (X, Y).
		If either X or Y is zero, this results in a cardinal direction.
		If X and Y are non-zero, this results in a diagonal direction.
		This is similar to get_dir() in that it's a pretty
		bad approximation in a realistic sense.

	ToOffsetX(Directions/Direction)
		Returns 1 for directions pointing toward the east.
		Returns -1 for directions pointing toward the west.
		Returns 0 otherwise.

	ToOffsetY(Directions/Direction)
		Returns 1 for directions pointing toward the north.
		Returns -1 for directions pointing toward the south.
		Returns 0 otherwise.

	ToDegrees(Directions/Direction)
		Returns an angle in degrees pointing in the given direction.
		North is 0 degrees.
		East is 90 degrees.
		West is -90 degrees.

	FromDegrees(Degrees)
		Returns the closest Direction in the same direction as the given number of Degrees.

	FromOffsetToDegrees(X, Y)
		Returns an angle in degrees pointing in the direction of a given offset.
		(0, 1) is 0 degrees
		(1, 0) is 90 degrees
		(-1, 0) is -90 degrees.

*/

var Directions/Directions = new

Directions
	parent_type = /Constants

	var const
		Center = 0
		North = NORTH
		South = SOUTH
		East = EAST
		West = WEST
		Northeast = North | East
		Southeast = South | East
		Northwest = North | West
		Southwest = South | West
		Horizontal = East | West
		Vertical = North | South
		Planar = Horizontal | Vertical
		Up = UP
		Down = DOWN

	proc
		ToDegrees(Directions/Direction)
			var global/dir_to_angle[] = list(
				0, 180, 0, 90, 45, 135, 90, -90, -45, -135, -90, 0, 0, 180, 0)
			return dir_to_angle[Direction]

		FromOffsetToDegrees(X, Y)
			return (X || Y) && \
				(X >= 0 ? arccos(Y / sqrt(X*X + Y*Y)) : -arccos(Y / sqrt(X*X + Y*Y)))

		IsDiagonal(Directions/Direction)
			return !!(Direction & Direction - 1)

		IsCardinal(Directions/Direction)
			return !(Direction & Direction - 1)

		ToOffsetX(Directions/Direction)
			var global/to_offset_x[] = list(0, 0, 0, 1, 1, 1, 1, -1, -1, -1, -1, 0, 0, 0)
			return Direction && to_offset_x[Direction & Planar]

		ToOffsetY(Directions/Direction)
			var global/to_offset_y[] = list(1, -1, 0, 0, 1, -1, 0, 0, 1, -1, 0, 0, 1, -1, 0)
			return Direction && to_offset_y[Direction & Planar]

		FromDegrees(Degrees)
			var global/from_degrees[] = list(
				North, Northeast, East, Southeast, South, Southwest, West, Northwest)
			return from_degrees[1 + round(8 + Degrees * 8 / 360, 1) % 8]

		FromDegreesToCardinal(Degrees)
			var global/from_degrees[] = list(North, East, South, West)
			return from_degrees[1 + round(4 + Degrees * 4 / 360, 1) % 4]

		FromOffsetExact(X, Y)
			return (X ? X > 0 ? East : West : Center) | (Y ? Y > 0 ? North : South : Center)

		FromOffset(X, Y)
			var Directions/direction = FromOffsetExact(X, Y)
			if(IsDiagonal(direction))
				var ax = abs(X)
				var ay = abs(Y)
				if(ax >= ay * 2) return direction & Horizontal
				else if(ay >= ax * 2) return direction & Vertical
			return direction

		FromOffsetToCardinal(X, Y)
			var Directions/direction = FromOffsetExact(X, Y)
			if(IsDiagonal(direction))
				var ax = abs(X)
				var ay = abs(Y)
				if(ax >= ay) return direction & Horizontal
				else if(ay >= ax) return direction & Vertical
			return direction
