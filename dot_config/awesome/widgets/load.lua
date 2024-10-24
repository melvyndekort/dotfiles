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
        text = "",
        widget = wibox.widget.textbox
    }

    local text_with_background = wibox.container.background(text)

    mywidget = wibox.widget {
        --text_with_background,
        background_color = colors.background,
        border_color = colors.background,
        color = colors.pink,
        min_value = 0,
        step_width = 3,
        step_spacing = 2,
        forced_height = 24,
        forced_width = 100,
        widget = wibox.widget.graph
    }

    awful.spawn.easy_async_with_shell("nproc", function(stdout, _, _, _)
        mywidget.max_value = tonumber(stdout)
    end)

    local function update_widget(widget, stdout)
        local avg1min,avg5min,avg15min = string.match(stdout, "^(%S+)%s+(%S+)%s+(%S+)")
        widget:add_value(tonumber(avg1min))
    end

    watch("cat /proc/loadavg", 2, update_widget, mywidget)

    local tooltip = awful.tooltip {
        objects = { mywidget }
    }

    mywidget:connect_signal("mouse::enter", function()
        local myfile = io.open("/proc/loadavg", "r")
        tooltip.text = "  1m   5m  15m\n" .. myfile:read("*a")
        myfile:close()
    end)

    return mywidget
end

return setmetatable(mywidget, { __call = function(_, ...)
    return worker(...)
end })
