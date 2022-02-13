computers.registered_commands = {}

function computers.register_command(modpath)
    local func = dofile(modpath .. "/init.lua")
    local f = io.open(modpath .. "/conf.json")
    local conf = minetest.parse_json(f:read("*all"))
    f:close()
    if func and computers.os.version >= conf.engine then computers.registered_commands[conf.name] = func end
end

--load default commands
local dirs = minetest.get_dir_list(computers.modpath .. "/commands", true)

for _, dir in pairs(dirs) do
    computers.register_command(computers.modpath .. "/commands/" .. dir)
end