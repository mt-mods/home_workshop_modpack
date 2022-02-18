function expr(pos, input, data)
    local output
    local func = computers.sandbox.loadstring("return " .. input, {env={}})

    if func then output = func() end

    if type(output) ~= "number" or output == nil then
        return "Error: invalid or missing input"
    end

    return tostring(output)
end

return expr