--[[
    computers.sandbox code is from https://github.com/kikito/lua-sandbox
    License MIT 2013 Enrique García Cota
    additionally modified by wsor to work with lua 5.1/luajit
    modifications include:
        * additional protections
        * tweaking of structure
        * modifications to the default env
]]
computers.sandbox = {}
computers.api = {}

--default sandbox enviroment used if none is provided
computers.sandbox.default_env = {}

([[
    _VERSION assert   error    ipairs next pairs
    select   tonumber tostring type   unpack

    math.abs   math.acos math.asin  math.atan math.atan2 math.ceil
    math.cos   math.cosh math.deg   math.exp  math.fmod  math.floor
    math.frexp math.huge math.ldexp math.log  math.log10 math.max
    math.min   math.modf math.pi    math.pow  math.rad   math.random
    math.sin   math.sinh math.sqrt  math.tan  math.tanh

    os.clock os.difftime os.time

    string.byte string.char  string.format
    string.len  string.lower string.reverse
    string.sub  string.upper

    table.insert table.maxn table.remove table.sort table.concat
]]):gsub('%S+', function(id)
    local module, method = id:match('([^%.]+)%.([^%.]+)')
    if module then
        computers.sandbox.default_env[module] = computers.sandbox.default_env[module] or {}
        computers.sandbox.default_env[module][method] = _G[module][method]
    else
        computers.sandbox.default_env[id] = _G[id]
    end
end)

--takes a code string, returns a sandboxed function to exicute
function computers.sandbox.loadstring(code, options)
    local defaults = {
        env = table.copy(computers.sandbox.default_env),
        quota = 5000
    }

    options = options or {}
    for k, v in pairs(defaults) do
        if not options[k] then options[k] = v end
    end

    assert(type(code) == "string", "[computers.sandbox]: passed is not a string")

    local env = options.env
    env._G = env

    if code:byte(1) == 27 then
        minetest.log("warning", "[computers.sandbox]: attempted bytecode execution termminated")
        return nil, "bytecode disallowed"
    end

    local f, err = loadstring(code)
    if not f then return nil, err end
    setfenv(f, env)

    if jit then jit.off(f, true) end

    local function timeout()
        debug.sethook()
        error("quota exceeded: " .. tostring(options.quota))
    end

    return function(...)
        debug.sethook(timeout, "", options.quota)
        local string_metatable = getmetatable("")
        assert(string_metatable.__index == string, "[computers.sandbox]: error with the string metatable")
        string_metatable.__index = env.string

        local status, ret = pcall(f, ...)

        debug.sethook()
        string_metatable.__index = string

        if not status then error(ret) end
        return ret
    end

end

--supports string input or table env input with a default env of the base
function computers.sandbox.merge_env(nenv, denv)
    local base_env = table.copy(denv or computers.sandbox.default_env)

    if type(nenv) == "table" then
        for k, v in pairs(nenv) do
            base_env[k] = base_env[k] or {}
            for key, value in pairs(v) do
                base_env[k][key] = value
            end
        end
    elseif type(nenv) == "string" then
        nenv:gsub('%S+', function(id)
            local module, method = id:match('([^%.]+)%.([^%.]+)')
            if module then
                base_env[module] = base_env[module] or {}
                base_env[module][method] = _G[module][method]
            else
                base_env[id] = _G[id]
            end
        end)
    end

    return base_env
end

function computers.api.get_dir_keyed_list(path, is_dir)
    local files = minetest.get_dir_list(path, is_dir)
    local keyed = {}
    for _, file in pairs(files) do
        keyed[file] = true
    end

    return keyed
end

function computers.api.chat_send_player(player, msg)
    local name = player
    if type(name) == "userdata" then name = player:get_player_name() end
    minetest.chat_send_player(name, msg)
end