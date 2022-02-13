computers = {}
computers.modpath = minetest.get_modpath("computers")

dofile(computers.modpath .. "/old_stuff/init.lua")
dofile(computers.modpath .. "/formspec.lua")
dofile(computers.modpath .. "/gui.lua")
dofile(computers.modpath .. "/demo.lua")
