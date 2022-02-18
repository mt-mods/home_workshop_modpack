function exit(pos, input, data)
    minetest.close_formspec(data.player:get_player_name(), "")

    return "you shouldnt see this"
end

return exit