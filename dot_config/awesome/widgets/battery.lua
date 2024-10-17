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
        widget = wibox.widget.textbox
    }

    local text_with_background = wibox.container.background(text)

    mywidget = wibox.widget {
        text_with_background,
        max_value = 100,
        rounded_edge = true,
        thickness = 2,
        start_angle = 2 * math.pi * 3/4,
        forced_height = 24,
        forced_width = 24,
        bg = colors.background,
        paddings = 2,
        widget = wibox.container.arcchart
    }

    local last_battery_check = os.time()

    local function show_battery_warning()
        naughty.notify {
            icon = "/home/melvyn/.config/awesome/widgets/warning.png",
            icon_size = 100,
            text = 'Connect a charger!',
            title = 'Battery is dying',
            timeout = 25,
            hover_timeout = 0.5,
            position = 'top_right',
            bg = colors.red,
            fg = colors.background,
            width = 300,
        }
    end

    local function update_widget(widget, stdout)
        local charge = 0
        local status
        for s in stdout:gmatch("[^\r\n]+") do
            local cur_status, charge_str, _ = string.match(s, '.+: ([%a%s]+), (%d?%d?%d)%%,?(.*)')
            if cur_status ~= nil and charge_str ~=nil then
                local cur_charge = tonumber(charge_str)
                if cur_charge > charge then
                    status = cur_status
                    charge = cur_charge
                end
            end
        end

        widget.value = charge

        if status == 'Charging' then
            text.text = ''
            text_with_background.bg = colors.purple
            text_with_background.fg = colors.background
        else
            text.text = ''
            if charge < 15 and charge > 0 then
                text_with_background.bg = colors.red
                text_with_background.fg = colors.background
                if status ~= 'Charging' and os.difftime(os.time(), last_battery_check) >= 300 then
                    -- if 5 minutes have elapsed since the last warning
                    last_battery_check = os.time()
                    show_battery_warning()
                end
            elseif charge > 15 and charge < 40 then
                text_with_background.bg = colors.orange
                text_with_background.fg = colors.background
            else
                text_with_background.bg = colors.green
                text_with_background.fg = colors.background
            end
        end
    end

    watch("acpi", 10, update_widget, mywidget)

    local tooltip = awful.tooltip {
        objects = { mywidget }
    }

    mywidget:connect_signal("mouse::enter", function()
        awful.spawn.easy_async_with_shell('acpi', function(stdout, _, _, _)
            tooltip.text = string.gsub(stdout, "\n$", "")
        end)
    end)

    return mywidget
end

return setmetatable(mywidget, { __call = function(_, ...)
    return worker(...)
end })
