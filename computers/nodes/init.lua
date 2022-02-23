local path = computers.modpath .. "/nodes"

dofile(path .. "/node_api.lua")
dofile(path .. "/nodes.lua")
dofile(path .. "/router.lua")
dofile(path .. "/tetris.lua")
dofile(path .. "/aliases.lua")

if minetest.get_modpath("default") and minetest.get_modpath("basic_materials") then
	dofile(path .. "/recipes.lua")
end