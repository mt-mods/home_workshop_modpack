function net(pos, input, data)
    input = input or ""
    local lookup = {
        list = function(param)
            if param == "-ids" then
                return table.concat(computers.networks.get_networks_in_area(pos), " ")
            elseif not param or param == "" then
                return table.concat(computers.networks.get_net_names_in_area(pos), " ")
            else
                return "invalid sub command"
            end
        end,
        join = function(param)
            local id = computers.networks.get_id_by_net_name(data.player, param)
            if not id then
                return "invalid network name"
            elseif minetest.get_meta(pos):get("net_id") then
                return "already joined to a network"
            else
                local _, networks = computers.networks.get_net_names_in_area(pos)
                if not networks[param] then return "network not in range" end
                minetest.get_meta(pos):set_string("net_id", id)
                local status = computers.networks.add_device(id, pos)
                if status then return "joined network " .. param else return "network join failed" end
            end
        end,
        leave = function(param)
            local id = minetest.get_meta(pos):get("net_id")
            if id then
                computers.networks.remove_device(id, pos)
                return "removed device from network " .. computers.networks.get_net_name(id)
            else
                return "not currently connected to any network"
            end
        end,
        status = function(param)
            local id = minetest.get_meta(pos):get("net_id")
            if id then
                return "connected to network " .. computers.networks.get_net_name(id)
            else
                return "not connected to any network"
            end
        end,
        dns = function(param)
            if minetest.get_item_group(minetest.get_node(pos).name, "computers_server") == 0 then
                return "command only available to servers"
            end
            if not param or param == "" then return "invalid or missing input" end
            if param:match("%W") then return "only alphanumerics allowed" end
            local id = minetest.get_meta(pos):get("net_id")
            if id then
                computers.networks.set_dns(id, pos, param)
                return "created dns record"
            else
                return "not connected to network"
            end
        end
    }

    if not lookup[input:split(" ")[1]] then return "invalid sub command" end
    return lookup[input:split(" ")[1]](input:split(" ", 1)[2])
end

return net