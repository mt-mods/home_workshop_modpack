function pwd(pos, input, data)
    local output = data.element.pwd
    if output == "" then output = "/" end
    return output
end

return pwd