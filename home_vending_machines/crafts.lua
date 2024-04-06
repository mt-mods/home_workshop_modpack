local materials = xcompat.materials

if minetest.get_modpath("default") then
    minetest.register_craft({
        output = "home_workshop_misc:soda_machine",
        recipe = {
            {materials.steel_ingot, materials.steel_ingot, materials.steel_ingot},
            {materials.steel_ingot, materials.dye_red, materials.steel_ingot},
            {materials.steel_ingot, "default:copperblock", materials.steel_ingot},
        },
    })
end
if minetest.get_modpath("vessels") then
    minetest.register_craft({
        output = "home_vending_machines:drink_machine",
        recipe = {
            {materials.steel_ingot, "group:vessel", materials.steel_ingot},
            {materials.steel_ingot, materials.steel_ingot, materials.steel_ingot},
            {materials.steel_ingot, "default:copperblock", materials.steel_ingot},
        },
    })
end
if minetest.global_exists("farming") and farming.mod == "redo" then
    minetest.register_craft({
        output = "home_vending_machines:sweet_machine",
        recipe = {
            {materials.steel_ingot, "group:food_sugar",    materials.steel_ingot},
            {materials.steel_ingot, materials.steel_ingot, materials.steel_ingot},
            {materials.steel_ingot, "default:copperblock", materials.steel_ingot},
        },
    })
end

