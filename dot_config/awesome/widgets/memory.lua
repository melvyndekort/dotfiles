local awful = require("awful")
local naughty = require("naughty")
local wibox = require("wibox")
local watch = require("awful.widget.watch")
local gears = require("gears")
local colors = require("colors")

local mywidget = {}

local function worker(user_args)
    local args = user_args or {}

    local text = wibox.widget {
        font = "FontAwesome 8",
        align = 'center',
        valign = 'center',
        text = "",
        widget = wibox.widget.textbox
    }

    local text_with_background = wibox.container.background(text)

    mywidget = wibox.widget {
        text_with_background,
        rounded_edge = true,
        thickness = 3,
        forced_height = 24,
        forced_width = 24,
        bg = colors.background,
        colors = {
            colors.red,
            colors.comment,
            colors.green,
        },
        paddings = 2,
        widget = wibox.container.arcchart
    }

    local piechart_widget = wibox.widget {
        colors = {
            colors.orange,
            colors.cyan,
            colors.green,
        },
        forced_height = 300,
        forced_width = 500,
        border_width = 1,
        border_color = colors.background,
        widget = wibox.widget.piechart
    }

    local popup = awful.popup {
        widget = {
            {
                {
                    text   = 'Memory usage',
                    align  = 'center',
                    widget = wibox.widget.textbox
                },
                {
                    piechart_widget,
                    widget = wibox.container.margin
                },
                layout = wibox.layout.fixed.vertical,
            },
            bg = colors.background,
            shape = gears.shape.rounded_rect,
            widget = wibox.container.background
        },
        ontop = true,
        visible = false,
        placement = awful.placement.top_right,
        shape = gears.shape.rounded_rect,
        border_width = 2,
        border_color = "#ffffff"
    }

    awful.spawn.easy_async_with_shell("free", function(stdout, _, _, _)
        local maxmem = string.match(stdout, "Mem:%s+(%d+).*")
        mywidget.max_value = tonumber(maxmem)
    end)

    local function update_widget(widget, stdout)
        local memused,memfree,memcache = string.match(stdout, "Mem:%s+%d+%s+(%d+)%s+(%d+)%s+%d+%s+(%d+)")
        widget.values = {
            tonumber(memused),
            tonumber(memcache),
            tonumber(memfree),
        }
    end

    watch("free", 10, update_widget, mywidget)

    mywidget:buttons(
        awful.util.table.join(
            awful.button({}, 1, function()
                awful.spawn.easy_async_with_shell('free', function(stdout, _, _, _)
                    local memused,memfree,memcache = string.match(stdout, "Mem:%s+%d+%s+(%d+)%s+(%d+)%s+%d+%s+(%d+)")
                    piechart_widget.data_list = {
                        {"Used", memused},
                        {"Cache", memcache},
                        {"Free", memfree},
                    }
                end)
                popup.visible = true
            end)
        )
    )

    popup:connect_signal("button::press", function()
        popup.visible = false
    end)

    return mywidget
end

return setmetatable(mywidget, { __call = function(_, ...)
    return worker(...)
end })
