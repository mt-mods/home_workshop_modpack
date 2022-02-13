--local usage
local futil = computers.formspec

function computers.load_gui(pos, node, clicker)
    --minetest.chat_send_all("test")
    local function select_btn(form, btn)
        --to hardcoded
        for _, obtn in pairs({"terminal", "browser"}) do
            local cindex = futil.get_index_by_name(form, obtn .. "_btn")
            form[cindex].props.bgimg = "kuto_button.png^[combine:16x16^[noalpha^[colorize:#ffffff70"
            form[cindex].props.bgimg_hovered = "kuto_button.png^[combine:16x16^[noalpha^[colorize:#ffffff90"

            cindex = futil.get_index_by_name(form, obtn .. "_ctn")
            form[cindex].state = 1
        end

        local cindex = futil.get_index_by_name(form, btn .. "_btn")
        form[cindex].props.bgimg = "kuto_button.png^[combine:16x16^[noalpha^[colorize:#ffffff20"
        form[cindex].props.bgimg_hovered = "kuto_button.png^[combine:16x16^[noalpha^[colorize:#ffffff40"

        local aindex = futil.get_index_by_name(form, btn .. "_ctn")
        form[aindex].state = 0
    end

    local formspec = {
        formspec_version = 4,
        {
            type = "size",
            w = 10,
            h = 12,
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
            type = "button",
            x = 0,
            y = 0,
            w = 2,
            h = 1,
            name = "terminal_btn",
            label = "Terminal",
            on_event = function(form, player, element)
                select_btn(form, "terminal")

                return form
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
            x = 2,
            y = 0,
            w = 2,
            h = 1,
            name = "browser_btn",
            label = "Browser",
            on_event = function(form, player, element)
                select_btn(form, "browser")

                return form
            end,
            props = {
                border = false,
                bgimg = "kuto_button.png^[combine:16x16^[noalpha^[colorize:#ffffff70",
                bgimg_hovered = "kuto_button.png^[combine:16x16^[noalpha^[colorize:#ffffff90",
                bgimg_middle = "4,4",
            }
        },
        {
            type = "container",
            name = "terminal_ctn",
            state = 0,
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
                name = "terminal_output",
                read_only = 1,
                --label = "test",
                default = "welcome to kuto\nversion " .. computers.os.version .. "\n\nuser:~$ ",
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
                name = "terminal_input",
                close_on_enter = false,
                pwd = "",
                props = {
                    border = false,
                },
                on_event = function(form, player, element, value)
                    local cindex = futil.get_index_by_name(form, "terminal_ctn")
                    local eindex = futil.get_index_by_name(form[cindex], "terminal_output")
                    local text = form[cindex][eindex].default
                    local pass_table = {
                        element = element
                    }

                    if value == "clear" then
                        form[cindex][eindex].default = "user:~" .. element.pwd .."$" .."\n"
                    end

                    local cdata = value:split(" ", false, 1)

                    if computers.registered_commands[cdata[1]] then
                        form[cindex][eindex].default = text .. value .. "\n"
                        text = form[cindex][eindex].default
                        local output = computers.registered_commands[cdata[1]](pos, cdata[2], pass_table)
                        if output and type(output) == "string" then
                            form[cindex][eindex].default = text .. output .. "\n" .. "user:~" .. element.pwd .."$" .." "
                        end
                    elseif value == "clear" then
                        form[cindex][eindex].default = "user:~$ "
                    elseif value == "" then
                        form[cindex][eindex].default = text .. "user:~" .. element.pwd .."$" .. "\n"
                    else
                        form[cindex][eindex].default = text .. value ..
                            "\nERROR: command not found\n" .. "user:~" .. element.pwd .."$" .. " "
                    end

                    return form
                end,
            },
        },
        {
            type = "container",
            name = "browser_ctn",
            state = 1,
            x = 0,
            y = 1,
            {
                type = "background",
                x = 0,
                y = 0,
                w = 10,
                h = 11,
                texture_name = "kuto_button.png^[combine:16x16^[noalpha^[colorize:#ffffff70"
            },
            {
                type = "label",
                x = 1,
                y = 1.5,
                label = "browser pane",
            },
            {
                type = "button",
                x = 1,
                y = 2,
                w = 5,
                h = 2,
                name = "test_btn",
                label = "test btn",
                on_event = function(form, player, element)
                    local cindex = futil.get_index_by_name(form, "browser_ctn")
                    local eindex = futil.get_index_by_name(form[cindex], "test_btn")
                    form[cindex][eindex] = {type = "label", x=1, y=3, label = "test button label"}

                    return form
                end,
                props = {
                    border = false,
                    bgimg = "kuto_button.png^[combine:16x16^[noalpha^[colorize:#ffffff70",
                    bgimg_hovered = "kuto_button.png^[combine:16x16^[noalpha^[colorize:#ffffff90",
                    bgimg_middle = "4,4",
                }
            }
        },
    }

    futil.show_formspec(clicker, "computers:gui", formspec)
end