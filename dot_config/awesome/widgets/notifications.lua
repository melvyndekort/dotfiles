local awful = require("awful")
local naughty = require("naughty")
local wibox = require("wibox")
local colors = require("colors")

local mywidget = {}

local function worker(user_args)
    local args = user_args or {}

    local text = wibox.widget {
        font = "FontAwesome 12",
        align = 'center',
        valign = 'center',
        forced_height = 24,
        forced_width = 24,
        text = '',
        widget = wibox.widget.textbox
    }

    mywidget = wibox.container.background(text)

    local tooltip = awful.tooltip {
        objects = { mywidget }
    }

    local function update_widget()
        if naughty.is_suspended() then
            mywidget.fg = colors.orange
            tooltip.text = "Notifications are OFF"
        else
            mywidget.fg = colors.foreground
            tooltip.text = "Notifications are ON"
        end
    end

    mywidget:buttons(
        awful.util.table.join(
            awful.button({}, 1, function() naughty.toggle(); update_widget() end),
            awful.button({}, 3, function() naughty.destroy_all_notifications() end)
        )
    )

    mywidget:connect_signal("mouse::enter", function()
        update_widget()
    end)

    awesome.connect_signal("notifications_widget::update", function(value)
        update_widget()
    end)

    return mywidget
end

return setmetatable(mywidget, { __call = function(_, ...)
    return worker(...)
end })
