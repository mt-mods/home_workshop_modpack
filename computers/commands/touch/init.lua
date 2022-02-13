function touch(pos, input, data)
    local path = computers.devicepath .. "/" .. minetest.hash_node_position(pos) .. data.element.pwd
    --make dir to be safe
    minetest.mkdir(path)

    if input and input ~= "" and not input:find("/") then
        minetest.safe_file_write(path .. "/" .. input, "")
        return "file " .. input .. " created"
    else
        return "invalid or missing input"
    end
end

return touch