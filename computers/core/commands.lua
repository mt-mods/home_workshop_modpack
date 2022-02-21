computers.registered_commands = {}
computers.registered_confs = {}

minetest.register_privilege("computers_filesystem", {
    description = "advanced use of computers filesystem",
    give_to_singleplayer = false,
    give_to_admin = false,
})

function computers.register_command(modpath)
    local func = dofile(modpath .. "/init.lua")
    local f = io.open(modpath .. "/conf.json")
    local conf = minetest.parse_json(f:read("*all"))
    f:close()
    if func and computers.os.version >= conf.engine then
        computers.registered_commands[conf.name] = func
        computers.registered_confs[conf.name] = conf
    end
end

--load default commands
local dirs = minetest.get_dir_list(computers.modpath .. "/commands", true)

for _, dir in pairs(dirs) do
    computers.register_command(computers.modpath .. "/commands/" .. dir)
end