proc/FreeZLevel(z)
    if (z in allocated_z_levels)
        allocated_z_levels -= z
proc/CopyObjects(source_x, source_y, source_z, destination_x, destination_y, destination_z)
    for (var/x = 0; x < 38; x++) // Assuming a 57x36 ship size
        for (var/y = 0; y < 24; y++)
            usr<<"Gathered 38x24 Ship Interior"

            var/obj/T = locate(source_x + x, source_y + y, source_z)
            if (T)

                // Copy the turf to the new ship instance
              //  usr<<"Testing NewT and NewO...Standby"
                var/obj/newT = new T.type(locate(destination_x + x, destination_y + y, destination_z))
                var/obj/newO = new T.type(newT)
                newO.dir = T.dir
                newO.icon = T.icon
                newO.icon_state = T.icon_state
               // usr<<"NewO and NewT sanctioned."
                // Copy objects inside the turf
                for (var/turf/O in range(57,T))

                    usr<<"Checking for turfs in obj contents.. Standby"
                    var/obj/newTT = new O.type(newT)
                    newTT.dir = O.dir
                    newTT.icon = O.icon
                    newTT.icon_state = O.icon_state
                    usr<<"Check Done"

                    for (var/v in O.vars)
                        newTT.vars[v] = T.vars[v]  // Copy all variables dynamically
                        usr<<"Vars established"
                usr<<"Successful Copy!"

proc/CopyObjectsNamek(source_x, source_y, source_z, destination_x, destination_y, destination_z)
    for (var/x = 0; x < 18; x++) // Assuming a 18x68 ship size
        for (var/y = 0; y < 68; y++)
           // usr<<"Gathered 18x68 Ship Interior"

            var/obj/T = locate(source_x + x, source_y + y, source_z)
            if (T)

                // Copy the turf to the new ship instance
               // usr<<"Testing NewT and NewO...Standby"
                var/obj/newT = new T.type(locate(destination_x + x, destination_y + y, destination_z))
                var/obj/newO = new T.type(newT)
                newO.dir = T.dir
                newO.icon = T.icon
                newO.icon_state = T.icon_state
              //  usr<<"NewO and NewT sanctioned."
                // Copy objects inside the turf
                for (var/turf/O in range(37,T))

                   // usr<<"Checking for turfs in obj contents.. Standby"
                    var/obj/newTT = new O.type(newT)
                    newTT.dir = O.dir
                    newTT.icon = O.icon
                    newTT.icon_state = O.icon_state
                  //  usr<<"Check Done"

                    for (var/v in O.vars)
                        newTT.vars[v] = T.vars[v]  // Copy all variables dynamically
                 //       usr<<"Vars established"
               // usr<<"Successful Copy!"

proc/CopyObjectsFrieza(source_x, source_y, source_z, destination_x, destination_y, destination_z)
    for (var/x = 0; x < 64; x++) // Assuming a 64x213 ship size
        for (var/y = 0; y < 213; y++)
            //usr<<"Gathered 64x213 Ship Interior"

            var/obj/T = locate(source_x + x, source_y + y, source_z)
            if (T)

                // Copy the turf to the new ship instance
               // usr<<"Testing NewT and NewO...Standby"
                var/obj/newT = new T.type(locate(destination_x + x, destination_y + y, destination_z))
                var/obj/newO = new T.type(newT)
                newO.dir = T.dir
                newO.icon = T.icon
                newO.icon_state = T.icon_state
              //  usr<<"NewO and NewT sanctioned."
                // Copy objects inside the turf
                for (var/turf/O in range(90,T))

                  //  usr<<"Checking for turfs in obj contents.. Standby"
                    var/obj/newTT = new O.type(newT)
                    newTT.dir = O.dir
                    newTT.icon = O.icon
                    newTT.icon_state = O.icon_state
                 //   usr<<"Check Done"

                    for (var/v in O.vars)
                        newTT.vars[v] = T.vars[v]  // Copy all variables dynamically
                  //      usr<<"Vars established"
                //usr<<"Successful Copy!"
proc/LoadPreBuiltShipInterior(var/obj/ship_interior_spawner/ship_interior,shipstyle)
    if(shipstyle == "CC")
        var/turf/origin = locate(24, 10, 20)  // Example prebuilt location on map
        //world<<"[origin] Origin created."
        CopyObjects(origin.x, origin.y, origin.z, 24, 11, ship_interior.z)  // Copy to new ship instance
        //world<<"Objects Copied"
    if(shipstyle == "Namek")
        var/turf/origin = locate(9, 58, 20)  // Example prebuilt location on map
        CopyObjectsNamek(origin.x, origin.y, origin.z, 9, 59, ship_interior.z)  // Copy to new ship instance
    if(shipstyle == "Frieza")
        var/turf/origin = locate(24, 10, 20)  // Example prebuilt location on map
        CopyObjects(origin.x, origin.y, origin.z, 24, 11, ship_interior.z)  // Copy to new ship instance


proc/SaveShipInterior(ship_id, ship_interior)
    var/list/data = list()

    for (var/turf/T in ship_interior)
    {
        var/list/turf_data = list(T.type, T.x, T.y)
        data += list(turf_data)

        for (var/obj/O in T.contents)
        {
            var/list/obj_data = list(O.type, O.x, O.y, O.vars)
            data += list(obj_data)
        }
    }

    world.Export("data/ship_interior/[ship_id].sav", data)

proc/LoadSavedShipInterior(ship_id, var/obj/ship_interior)
    var/list/data = world.Import("data/ship_interior/[ship_id].sav")
    if (!data) return

    for (var/entry in data)
    {
        if (length(entry) == 3) // Turf
        {
            var/type = entry[1]
            var/x = entry[2]
            var/y = entry[3]
            new type(ship_interior, x, y, ship_interior.z)
        }
        else if (length(entry) == 4) // Object
        {
            var/type = entry[1]
            var/x = entry[2]
            var/y = entry[3]
            var/vars = entry[4]

            var/obj/O = new type(ship_interior)
            O.x = x
            O.y = y

            for (var/v in vars)
                O.vars[v] = vars[v]
        }
    }



var/global/list/allocated_z_levels = list()
var/global/starting_instance_z = 20  // Start ship interiors from z-level 20
var/global/max_instance_z = 200  // Limit to avoid infinite z-levels
