local old_node = minetest.registered_nodes["computers:shefriendSOO"]
old_node.groups.not_in_creative_inventory = 1
minetest.override_item("computers:shefriendSOO", {
    on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
        computers.load_gui(pos, node, clicker)
    end,
    groups = old_node.groups
})

old_node = minetest.registered_nodes["computers:shefriendSOO_off"]
old_node.groups.not_in_creative_inventory = nil
minetest.override_item("computers:shefriendSOO_off", {
    groups = old_node.groups
})

old_node = minetest.registered_nodes["computers:server_on"]
old_node.groups.computers_server = 1
minetest.override_item("computers:server_on", {
    on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
        computers.load_gui(pos, node, clicker)
    end,
    groups = old_node.groups
})