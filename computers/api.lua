--local usage
local futil = computers.formspec

computers.show_formspec = computers.formspec.show_formspec

function computers.load_gui(pos, node, clicker)
    --minetest.chat_send_all("test")

    local formspec = {
        formspec_version = 4,
        {
            type = "size",
            w = 10,
            h = 10,
        },
        {
            type = "label",
            x = 1,
            y = 1,
            label = "test label",
        },
        {
            type = "button",
            x = 1,
            y = 2,
            w = 5,
            h = 2,
            name = "test_btn",
            label = "test btn",
            on_event = function(form, player, element)
                local cindex = futil.get_index_by_name(form, "test_btn")
                form[cindex] = {type = "label", x=1, y=3, label = "test button label"}

                return form
            end,
            props = {
                border = false,
                bgimg = "kuto_button.png^[combine:16x16^[noalpha^[colorize:#ffffff70",
                bgimg_hovered = "kuto_button.png^[combine:16x16^[noalpha^[colorize:#ffffff90",
                bgimg_middle = "4,4",
            }
        }
    }

    computers.show_formspec(clicker, "computers:gui", formspec)
end