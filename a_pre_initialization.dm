pre_init
	New()
		startup(null,0,"-verbose","-trusted")
		world.log = file("ErrorLog.txt")
		pre_startup = 1

var/pre_init/pre_init = new()

/*
This special code -should- create a means to do things before the map loads.

To get code to run BEFORE the game/map is loaded, you can force a proc to run before world initialization by defining a datum as a variable.
For example, pre_init >> New(). var/pre_init/pre_init = new().

"However order of operations is important with this, it must be placed before any other code is written in your game
(As in, literally line 1 of the first .dm included in your file) to avoid running into any strange issues."
*/