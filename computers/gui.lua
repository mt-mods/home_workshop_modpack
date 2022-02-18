computers.gui = {}

local futil = computers.formspec

local function select_btn(form, btn)
    --to hardcoded
    for _, obtn in pairs(form.tabs) do
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

function computers.gui.load(pos, node, clicker)

    local formspec = {
        formspec_version = 4,
        tabs = {"terminal", "browser"},
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
                        element = element,
                        player = player
                    }

                    if value == "clear" then
                        form[cindex][eindex].default = "user:~" .. element.pwd .."$" .."\n"
                    end

                    local cdata = value:split(" ", false, 1)

                    if value == "clear" then
                        form[cindex][eindex].default = "user:~$ "
                    elseif value == "" then
                        form[cindex][eindex].default = text .. "user:~" .. element.pwd .."$" .. "\n"
                    elseif computers.registered_commands[cdata[1]] and cdata[2] == "-v" then
                        form[cindex][eindex].default = text .. value .. "\n" ..
                            computers.registered_confs[cdata[1]].version .. "\nuser:~" .. element.pwd .."$" .. "\n"
                    elseif computers.registered_commands[cdata[1]] then
                        form[cindex][eindex].default = text .. value .. "\n"
                        text = form[cindex][eindex].default
                        local output = computers.registered_commands[cdata[1]](pos, cdata[2], pass_table)
                        if output and type(output) == "string" then
                            form[cindex][eindex].default = text .. output .. "\n" .. "user:~" .. element.pwd .."$" .." "
                        elseif output and type(output) == "table" then
                            form = output
                        end
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
                on_event = function(_, player, element)
                    --local cindex = futil.get_index_by_name(form, "browser_ctn")
                    --local eindex = futil.get_index_by_name(form[cindex], "test_btn")
                    --form[cindex][eindex] = {type = "label", x=1, y=3, label = "test button label"}
                    local form = computers.gui.add_tab(player, "Tname", {
                        type = "container",
                        name = "tname_ctn",
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
                            label = "Tname pane",
                        },
                    })

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

--legacy compat
computers.load_gui = computers.gui.load

--note you can create to many pages thuse overflowing the formspec, need to be fixed
function computers.gui.add_tab(player, tname, tab)
    local name = player
    if type(player) == "userdata" then name = player:get_player_name() end

    assert(tab, "[computers.sandbox]: new tab for " .. name .. " not found")
    assert(tab.type == "container", "[computers.sandbox]: invalid new tab format for " .. name)
    assert(tab.name:split("_")[2] == "ctn", "[computers.sandbox]: invalid tab name for " .. name)
    assert(tab.x == 0 and tab.y == 1, "[computers.sandbox]: invalid tab name for " .. name)


    local formspec = table.copy(computers.formspec.registered_kast[name])
    local fs = {}
    local btn

    for key, val in pairs(formspec) do
        if type(key) == "string" then
            fs[key] = val
        elseif type(val) == "table" then
            if val.name and #val.name:split("_") >= 2 and val.name:split("_")[2] == "btn" then
                btn = 1
            elseif btn and btn == 1 then
                table.insert(fs, {
                    type = "button",
                    x = #formspec.tabs*2,
                    y = 0,
                    w = 2,
                    h = 1,
                    name = tname:lower() .. "_btn",
                    label = tname,
                    on_event = function(form, _, element)
                        select_btn(form, tname:lower())

                        return form
                    end,
                    props = {
                        border = false,
                        bgimg = "kuto_button.png^[combine:16x16^[noalpha^[colorize:#ffffff70",
                        bgimg_hovered = "kuto_button.png^[combine:16x16^[noalpha^[colorize:#ffffff90",
                        bgimg_middle = "4,4",
                    }
                })

                btn = nil
            end

            table.insert(fs, val)

        end

    end

    table.insert(fs, tab)
    table.insert(fs.tabs, tname:lower())

    return fs
end