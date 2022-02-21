local networks = {}
local network_lookup = {}
computers.networks = {}

local function init_networks()
    local path = computers.networkpath
    local files = minetest.get_dir_list(computers.networkpath, false)
    for _, file in pairs(files) do
        local id = file:sub(1,-6)
        local f = io.open(path .. "/" .. file)
        networks[id] = minetest.parse_json(f:read("*all"))
        f:close()

        if not network_lookup[networks[id].pname] then network_lookup[networks[id].pname] = {} end
        network_lookup[networks[id].pname][networks[id].net_name] = id
    end
end

init_networks()

local function update_file(id)
    local data = networks[id]
    local path = computers.networkpath .. "/" .. id .. ".json"
    minetest.safe_file_write(path, minetest.write_json(data))
end

function computers.networks.create(player, net_name)
    local pname = player
    if type(player) == "userdata" then pname = player:get_player_name() end
    local id = pname .. "_" .. minetest.get_us_time()

    if net_name:match("%W") then return false end --pnly accept alphanumerics
    if not network_lookup[pname] then network_lookup[pname] = {} end
    if network_lookup[pname][net_name] then return false end
    if networks[id] then return false end

    --create storage on disk
    local path = computers.networkpath .. "/" .. id .. ".json"
    local data = {
        pname = pname,
        net_name = net_name,
        devices = {},
        dns = {
        }
    }
    minetest.safe_file_write(path, minetest.write_json(data))

    --store data in memory
    networks[id] = data
    network_lookup[pname][net_name] = id

    return true, id
end

function computers.networks.verify_network(id)
    if networks[id] then return true else return false end
end

function computers.networks.get_net_name(id)
    return networks[id].net_name
end

function computers.networks.get_network_devices(id)
    return table.copy(networks[id].devices)
end

function computers.networks.get_network_dns(id)
    return table.copy(networks[id].dns)
end

function computers.networks.get_id_by_net_name(player, net_name)
    local pname = player
    if type(player) == "userdata" then pname = player:get_player_name() end
    if not network_lookup[pname] then network_lookup[pname] = {} end
    return network_lookup[pname][net_name]
end

function computers.networks.get_networks_in_area(pos, rad)
    rad = rad or 10
    local locations = {}
    local keyed_locations = {}
    local meta_nodes = minetest.find_nodes_with_meta(
        vector.new(pos.x+rad, pos.y+rad, pos.z+rad),
        vector.new(pos.x-rad, pos.y-rad, pos.z-rad)
    )
    for _, location in pairs(meta_nodes) do
        local status = minetest.get_meta(location):get("net_id")
        if status and networks[status] then
            table.insert(locations, status)
            keyed_locations[status] = true
        end
    end
    return locations, keyed_locations
end

function computers.networks.get_net_names_in_area(pos, rad)
    rad = rad or 10
    local locations = {}
    local keyed_locations = {}
    local meta_nodes = minetest.find_nodes_with_meta(
        vector.new(pos.x+rad, pos.y+rad, pos.z+rad),
        vector.new(pos.x-rad, pos.y-rad, pos.z-rad)
    )
    for _, location in pairs(meta_nodes) do
        local status = minetest.get_meta(location):get("net_id")
        if status and networks[status] and not keyed_locations[networks[status].net_name] then
            table.insert(locations, networks[status].net_name)
            keyed_locations[networks[status].net_name] = true
        end
    end
    return locations, keyed_locations
end

function computers.networks.add_device(id, pos)
    if type(pos) ~= "table" or not networks[id] then return false end
    networks[id].devices[minetest.pos_to_string(pos)] = minetest.get_node(pos).name
    minetest.get_meta(pos):set_string("net_id", id)
    update_file(id)
    return true
end

function computers.networks.remove_device(id, pos)
    if type(pos) ~= "table" or not networks[id] then return false end
    networks[id].devices[minetest.pos_to_string(pos)] = nil
    minetest.get_meta(pos):set_string("net_id", "")
    update_file(id)
    return true
end

function computers.networks.set_dns(id, pos, url)
    if type(pos) ~= "table" or not networks[id] then return false end
    if url:match("%W") then return false end
    networks[id].dns = networks[id].dns or {}
    networks[id].dns[url] = minetest.hash_node_position(pos) .. "/public_pages"

    update_file(id)
    return true
end

function computers.networks.resolve_url(id, pos, url)
    if type(pos) ~= "table" or not networks[id] then return false end
    if networks[id].dns[url:split("/")[1]] then
        local path = computers.devicepath .. "/" .. networks[id].dns[url:split("/")[1]].."/index.page"
        local f = io.open(path)
        if not f then return false end
        local data = f:read("*all")
        f:close()
        if data then return true, data else return false end
    else
        return false
    end
end