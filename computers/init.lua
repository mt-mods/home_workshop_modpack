computers = {}
computers.modpath = minetest.get_modpath("computers")
computers.storagepath = minetest.get_worldpath() .. "/computers"
computers.devicepath = computers.storagepath .. "/devices"
computers.networkpath = computers.storagepath .. "/networks"
minetest.mkdir(computers.storagepath) --make sure it exists
minetest.mkdir(computers.devicepath) --make sure it exists
minetest.mkdir(computers.networkpath) --make sure it exists

computers.os = {
    version = 0.44,
    name = "kuto",
    authors = {"wsor", "luk3yx"},
    license = "MIT",
}

dofile(computers.modpath .. "/core/init.lua")
dofile(computers.modpath .. "/nodes/init.lua")

dofile(computers.modpath .. "/demo.lua")
