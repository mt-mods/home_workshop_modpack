function ls(pos, input, data)
    local path = computers.devicepath .. "/" .. minetest.hash_node_position(pos) .. data.element.pwd
    --make dir to be safe
    minetest.mkdir(path)

    return table.concat(minetest.get_dir_list(path), "  ")
end

return ls