local awful = require("awful")
local naughty = require("naughty")
local wibox = require("wibox")
local watch = require("awful.widget.watch")
local colors = require("colors")

local mywidget = {}

local function worker(user_args)
    local args = user_args or {}

    local text = wibox.widget {
        font = "FontAwesome 10",
        align = 'center',
        valign = 'center',
        text = "",
        widget = wibox.widget.textbox
    }

    local text_with_background = wibox.container.background(text)

    mywidget = wibox.widget {
        text_with_background,
        rounded_edge = true,
        thickness = 2,
        start_angle = 2 * math.pi * 3/4,
        forced_height = 24,
        forced_width = 24,
        bg = colors.background,
        paddings = 2,
        widget = wibox.container.arcchart
    }

    awful.spawn.easy_async_with_shell("brightnessctl m", function(stdout, _, _, _)
        mywidget.max_value = tonumber(stdout)
    end)

    local function update_widget(widget, stdout)
        widget.value = tonumber(stdout)
    end

    local function mywidget_inc()
        awful.spawn.with_shell("brightnessctl s +5%")
    end

    local function mywidget_dec()
        awful.spawn.with_shell("brightnessctl s 5%-")
    end

    mywidget:buttons(
        awful.util.table.join(
            awful.button({}, 4, function() mywidget_inc() end),
            awful.button({}, 5, function() mywidget_dec() end)
        )
    )

    watch("brightnessctl g", 10, update_widget, mywidget)

    return mywidget
end

return setmetatable(mywidget, { __call = function(_, ...)
    return worker(...)
end })
