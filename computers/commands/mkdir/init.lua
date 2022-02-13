function mkdir(pos, input, data)
    local path = computers.devicepath .. "/" .. minetest.hash_node_position(pos) .. data.element.pwd

    if input and input ~= "" and not input:find("/") then
        minetest.mkdir(path .. "/" .. input)
        return "folder " .. input .. " created"
    else
        return "invalid or missing input"
    end
end

return mkdir