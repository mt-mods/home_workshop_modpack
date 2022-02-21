function cat(pos, input, data)
    local path = computers.devicepath .. "/" .. minetest.hash_node_position(pos) .. data.element.pwd
    local files = computers.api.get_dir_keyed_list(path, false)

    if files[input] then
        local f = io.open(path .. "/" .. input)
        local fdata = f:read("*all")
        f:close()
        return fdata
    else
        return "file not found"
    end
end

return cat