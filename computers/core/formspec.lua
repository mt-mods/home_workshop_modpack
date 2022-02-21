computers.formspec = {}
computers.formspec.registered_kast = {}

computers.formspec.get_element_by_name = formspec_ast.get_element_by_name

function computers.formspec.get_index_by_name(tree, name)
    --this doesnt support containers, use this to get container index and then pass container as tree
    if type(tree) ~= "table" then return end

    for key, element in pairs(tree) do
        if type(element) == "table" and element.name and element.name == name then
            return key
        end
    end
end

--note this is terrible hard coded
local function insert_styles(form, styles)
    local headers = {size = true, position = true, anchor = true, no_prepend = true, real_cordinates = true}
    local cindex = 0
    local fs = {}

    for key, val in pairs(form) do
        if type(val) == "number" and not tonumber(key) then
            fs[key] = val
        elseif type(val) == "table" and val.type and headers[val.type] then
            table.insert(fs, val)
            cindex = key
        end
    end

    for _, val in pairs(styles) do
        table.insert(fs, val)
    end

    cindex = cindex+1
    for i=cindex, #form do
        table.insert(fs, form[i])
    end

    return fs
end

function computers.formspec.convert_to_ast(form)
    local styles = {}

    local function rfind(fs)
        for key, val in pairs(fs) do
            if type(val) == "table" then
                if val.type and val.type:find("container") then
                    if val.state and val.state == 1 then
                        --cant use nil so swaping in thing that will never render
                        fs[key] = {type = "label",x = 100,y = 100,label = "nil",}
                    else
                        rfind(val)
                    end
                elseif val.props then
                    table.insert(styles, {type = "style", selectors = val.selectors or {val.name}, props = val.props})
                elseif val.read_only == 1 then
                    val.name = nil
                end
                if val.type == "field" then
                    table.insert(
                        styles,
                        {type = "field_close_on_enter", name = val.name, close_on_enter = val.close_on_enter}
                    )
                end
            end
        end
    end

    rfind(form)

    local fs = insert_styles(form, styles)
    return fs
end

local forms = {}

function computers.formspec.show_formspec(player, formname, fs)
    local playername = player
    local formspec = fs

    if type(player) == "userdata" then
        playername = player:get_player_name()
    end
    if type(fs) == "table" then
        computers.formspec.registered_kast[playername] = table.copy(fs)
        formspec = formspec_ast.unparse(computers.formspec.convert_to_ast(fs))
    end

    forms[formname] = true

    minetest.show_formspec(playername, formname, formspec)
end

function computers.formspec.close_formspec(player, formname)
    local name = player
    if type(name) == "userdata" then name = player:get_player_name() end

    minetest.close_formspec(name, formname or "")
end

minetest.register_on_player_receive_fields(function(player, formname, fields)
    --if formname ~= "computers:gui" then return end
    if not forms[formname] then return end
    local pname = player:get_player_name()

    if fields.quit then computers.formspec.registered_kast[pname] = nil return end

    --[[
        trying to figure out what a player actually did can be a mess
        input can validly be nil for a text field sometimes, othertimes it can come in first
        when a user has actual selected a button. buttons only come in when selected,
        so we override whatever the first key is if there a button since we are sure it was pressed
        since we cant get types from fields, we rely on the button being named name_btn with _btn being a suffix
    ]]

    local keys = {}
    local btn_override
    for key, val in pairs(fields) do
        table.insert(keys, key)
        local split = key:split("_")
        if #split >= 2 and split[2] == "btn" then btn_override = key end
    end

    local element = computers.formspec.get_element_by_name(
        computers.formspec.registered_kast[pname],
        btn_override or keys[1]
    )

    --minetest.chat_send_all(btn_override or keys[1])
    --minetest.chat_send_all(fields[keys[1]])

    if element and element.on_event then
        --on_event(form, player, element)
        local form = element.on_event(
            computers.formspec.registered_kast[pname],
            player,
            element,
            fields[btn_override or keys[1]],
            fields
        )

        if form then computers.formspec.show_formspec(player, formname, form) end
    end
end)

--[[
    yes, i know this isnt perfect
    requires a name field in the subtags
    returns a table keyed by the name field with sub tables containing the other sub tags
]]
function computers.formspec.get_hypertext_subtags(hypertext, tag)
    local adata = {}
    for a in string.gmatch(hypertext, "<"..tag..".->.-</"..tag..">") do
        local len = #tag+1
        local tags = string.split(string.sub(a:split(">")[1], len, -1), " ")
        local name
        local storage = {}
        for _, tag_string in pairs(tags) do
            local split = tag_string:split("=")
            if split[1] == "name" then
                name = split[2]
            else
                storage[split[1]] = split[2]
            end
        end
        adata[name] = storage
    end
    --minetest.chat_send_all(dump(adata))
    return adata
end