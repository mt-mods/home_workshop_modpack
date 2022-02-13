computers = {}
computers.modpath = minetest.get_modpath("computers")
computers.storagepath = minetest.get_worldpath() .. "/computers"
computers.devicepath = computers.storagepath .. "/devices"
computers.networkpath = computers.storagepath .. "/networks"
minetest.mkdir(computers.storagepath) --make sure it exists
minetest.mkdir(computers.devicepath) --make sure it exists
minetest.mkdir(computers.networkpath) --make sure it exists

computers.os = {
    version = 0.41,
    name = "kuto",
    authors = {"wsor", "luk3yx"},
    license = "MIT",
}

dofile(computers.modpath .. "/old_stuff/init.lua")

dofile(computers.modpath .. "/formspec.lua")
dofile(computers.modpath .. "/commands.lua")
dofile(computers.modpath .. "/gui.lua")
dofile(computers.modpath .. "/demo.lua")
