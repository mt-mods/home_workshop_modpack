function touch(pos, input, data)
    local path = computers.devicepath .. "/" .. minetest.hash_node_position(pos) .. data.element.pwd
    --make dir to be safe
    minetest.mkdir(path)

    if #minetest.get_dir_list(path, false) > 10
    and not minetest.check_player_privs(data.player, "computers_filesystem") then
        return "ERROR: you have reached your max file limit"
    end

    if input and input ~= "" and not input:find("/") then
        if computers.api.get_dir_keyed_list(path, nil)[input] then
            return "ERROR: trying to create already existing file/folder"
        end
        minetest.safe_file_write(path .. "/" .. input, "")
        return "file " .. input .. " created"
    else
        return "invalid or missing input"
    end
end

return touch