computers = {}
computers.modpath = minetest.get_modpath("computers")

computers.os = {
    version = 0.3,
    name = "kuto",
    authors = {"wsor", "luk3yx"},
    license = "MIT",
}

dofile(computers.modpath .. "/old_stuff/init.lua")

dofile(computers.modpath .. "/formspec.lua")
dofile(computers.modpath .. "/commands.lua")
dofile(computers.modpath .. "/gui.lua")
dofile(computers.modpath .. "/demo.lua")
