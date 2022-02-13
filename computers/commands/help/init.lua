function help(pos, input, data)
    local output = ""
    for command, def in pairs(computers.registered_confs) do
        output = output .. "\n" .. command .. ": " .. def.help
    end
    return output
end

return help