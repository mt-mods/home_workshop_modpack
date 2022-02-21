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

minetest.override_item("computers:router", {
    on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
        local formspec = {
            formspec_version = 4,
            {
                type = "size",
                w = 10,
                h = 5,
            },
            {
                type = "no_prepend"
            },
            {
                type = "bgcolor",
                bgcolor = "black",
                fullscreen = "neither"
            },
            {
                type = "background9",
                x = 0,
                y = 0,
                w = 10,
                h = 5,
                texture_name = "kuto_button.png^[combine:16x16^[noalpha^[colorize:#ffffff70",
                auto_clip = false,
                middle_x = 4,
                middle_y = 4,
            },
            {
                type = "hypertext",
                name = "label",
                x = 0,
                y = 0,
                w = 10,
                h = 2,
                text = "<global valign=middle><center><big>Choose Option Below</big></center>",
            },
            {
                type = "button",
                x = 0.5,
                y = 3.5,
                w = 4,
                h = 1,
                name = "newnetwork_btn",
                label = "New Network",
                on_event = function(form, player, element, value, fields)
                    if element.label == "New Network" then
                        element.label = "Submit"
                        table.remove(form, computers.formspec.get_index_by_name(form, "existingnetwork_btn"))
                        form[computers.formspec.get_index_by_name(form, "label")].text = [[
                            <global valign=middle><center><big>Enter New Network Name</big></center>
                            ]]
                        table.insert(
                            form,
                            {
                                type = "box",
                                x = 3,
                                y = 1.75,
                                w = 4,
                                h = 1,
                                color = "#ffffff"
                            }
                        )
                        table.insert(
                            form,
                            {
                                type = "field",
                                x = 3,
                                y = 1.75,
                                w = 4,
                                h = 1,
                                name = "id_field",
                                close_on_enter = false,
                                props = {
                                    border = false,
                                },
                            }
                        )
                    else
                        if fields.id_field == "" and not computers.formspec.get_index_by_name(form, "warning") then
                            table.insert(
                                form,
                                {
                                    type = "hypertext",
                                    name = "warning",
                                    x = 5.5,
                                    y = 3.5,
                                    w = 4,
                                    h = 1,
                                    text = [[
                                        <global valign=middle>
                                        <center><style color=red>empty or invalid network name</style></center>
                                        ]]
                                }
                            )
                        elseif fields.id_field ~= "" then
                            local status, id = computers.networks.create(player, fields.id_field)
                            if status then
                                form = nil
                                minetest.get_meta(pos):set_string("net_id", id)
                                computers.networks.add_device(id, pos)
                                computers.api.chat_send_player(player, "network " .. fields.id_field .. " created")
                                computers.formspec.close_formspec(player)
                            elseif not computers.formspec.get_index_by_name(form, "warning") then
                                table.insert(
                                    form,
                                    {
                                        type = "hypertext",
                                        name = "warning",
                                        x = 5.5,
                                        y = 3.5,
                                        w = 4,
                                        h = 1,
                                        text = [[
                                            <global valign=middle>
                                            <center><style color=red>empty or invalid network name</style></center>
                                            ]]
                                    }
                                )
                            end
                        end
                    end
                    --minetest.chat_send_all("test")

                    if form then return form end
                end,
                props = {
                    border = false,
                    bgimg = "kuto_button.png^[combine:16x16^[noalpha^[colorize:#ffffff70",
                    bgimg_hovered = "kuto_button.png^[combine:16x16^[noalpha^[colorize:#ffffff90",
                    bgimg_middle = "4,4",
                }
            },
            {
                type = "button",
                x = 5.5,
                y = 3.5,
                w = 4,
                h = 1,
                name = "existingnetwork_btn",
                label = "Existing Network",
                on_event = function(form, player, element, value, fields)
                    if element.label == "Existing Network" then
                        element.label = "Submit"
                        table.remove(form, computers.formspec.get_index_by_name(form, "newnetwork_btn"))
                        form[computers.formspec.get_index_by_name(form, "label")].text = [[
                            <global valign=middle><center>Enter Network</center>
                            ]]
                        table.insert(
                            form,
                            {
                                type = "box",
                                x = 3,
                                y = 1.75,
                                w = 4,
                                h = 1,
                                color = "#ffffff"
                            }
                        )
                        table.insert(
                            form,
                            {
                                type = "field",
                                x = 3,
                                y = 1.75,
                                w = 4,
                                h = 1,
                                name = "id_field",
                                close_on_enter = false,
                                props = {
                                    border = false,
                                },
                            }
                        )
                    else
                        minetest.chat_send_all("submitted")
                    end

                    return form
                end,
                props = {
                    border = false,
                    bgimg = "kuto_button.png^[combine:16x16^[noalpha^[colorize:#ffffff70",
                    bgimg_hovered = "kuto_button.png^[combine:16x16^[noalpha^[colorize:#ffffff90",
                    bgimg_middle = "4,4",
                }
            },
        }

        if minetest.get_meta(pos):get("net_id") then
            local net_name = computers.networks.get_net_name(minetest.get_meta(pos):get("net_id"))
            computers.api.chat_send_player(clicker, "router attached to network: " .. net_name)
        else
            computers.formspec.show_formspec(clicker, "computers:router", formspec)
        end
    end
})