local materials = xcompat.materials

minetest.register_craft({
	output = "home_workshop_misc:tool_cabinet",
	recipe = {
		{ "basic_materials:motor", "default:axe_steel",               "default:pick_steel" },
		{ materials.steel_ingot,   "home_workshop_misc:drawer_small", materials.steel_ingot },
		{ materials.steel_ingot,   "home_workshop_misc:drawer_small", materials.steel_ingot }
	},
})

minetest.register_craft({
	output = "home_workshop_misc:beer_tap",
	recipe = {
		{ "group:stick",               materials.steel_ingot, "group:stick" },
		{ "basic_materials:steel_bar", materials.steel_ingot, "basic_materials:steel_bar" },
		{ materials.steel_ingot,       materials.steel_ingot, materials.steel_ingot }
	},
})