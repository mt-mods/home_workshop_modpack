function nano(pos, input, data)
    local path = computers.devicepath .. "/" .. minetest.hash_node_position(pos) .. data.element.pwd
    local files = computers.api.get_dir_keyed_list(path, false)

    if not input then return "no file designated" end
    if not files[input:split(" ")[1]] then return "file " .. input:split(" ")[1] .. " not found" end
    if computers.formspec.get_index_by_name(
        computers.formspec.registered_kast[data.player:get_player_name()],
        "nano_btn"
    ) then return "nano is already open, please close it" end

    local f = io.open(path .. "/" .. input:split(" ")[1])
    if not f then return "error reading file" end
    local file = f:read("*all")
    f:close()

    --clean up if there exists a legacy nano_ctn
    local nctn = computers.formspec.get_index_by_name(
        computers.formspec.registered_kast[data.player:get_player_name()],
        "nano_ctn"
    )
    if nctn then
        local fs = computers.formspec.registered_kast[data.player:get_player_name()]
        table.remove(fs, nctn)
        computers.formspec.registered_kast[data.player:get_player_name()] = fs
        minetest.chat_send_all(dump(fs))
    end

    local form = computers.gui.add_tab(data.player, "Nano", {
        type = "container",
        name = "nano_ctn",
        state = 1,
        x = 0,
        y = 1,
        {
            type = "background",
            x = 0,
            y = 0,
            w = 10,
            h = 11,
            texture_name = "[combine:16x16^[noalpha"
        },
        {
            type = "textarea",
            x = 0,
            y = 0,
            w = 10,
            h = 10,
            name = "nano_editor",
            --read_only = 1,
            --label = "test",
            default = file,
            close_on_enter = false,
            --this breaks the scrollbar
            --[[ props = {
                border = false,
            } ]]
        },
        {
            type = "box",
            x = 0,
            y = 10,
            w = 10,
            h = 1,
            color = "#ffffff"
        },
        {
            type = "field",
            x = 0,
            y = 10,
            w = 10,
            h = 1,
            name = "nano_commands",
            close_on_enter = false,
            pwd = "",
            props = {
                border = false,
            },
            on_event = function(form, player, element, value, fields)
                if value == "save" and fields.nano_editor then
                    --minetest.chat_send_all(fields.nano_editor)
                    if #fields.nano_editor < 12000 then --12000 is luacheck line length of 120 * 100 lines
                        minetest.safe_file_write(path .. "/" .. input:split(" ")[1], fields.nano_editor)
                    else
                        computers.api.chat_send_player(player, minetest.colorize("red", "[Nano]: file is to long"))
                    end
                elseif value == "exit" then
                    local btn = computers.formspec.get_index_by_name(form, "nano_btn")
                    local ctn = computers.formspec.get_index_by_name(form, "nano_ctn")
                    form[ctn].state = 1
                    table.remove(form, btn)
                    --table.remove(form, ctn) cant actually remove it from within itself, therefore we hide it
                    local tindex = 0
                    for index, tab in pairs(form.tabs) do
                        if tab == "nano" then tindex = index end
                    end
                    table.remove(form.tabs, tindex)
                    tindex = computers.formspec.get_index_by_name(form, "terminal_ctn")

                    form[tindex].state = 0
                else
                    computers.api.chat_send_player(player, minetest.colorize("red", "[Nano]: invalid command"))
                end

                return form
            end,
        },
    })

    return form
end

return nano