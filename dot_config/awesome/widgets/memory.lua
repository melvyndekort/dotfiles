local awful = require("awful")
local naughty = require("naughty")
local wibox = require("wibox")
local watch = require("awful.widget.watch")
local gears = require("gears")
local colors = require("colors")

local mywidget = {}

local function worker(user_args)
	local args = user_args or {}

	local image = wibox.widget {
		image = gears.filesystem.get_configuration_dir() .. "icons/memory.png",
    resize = true,
    widget = wibox.widget.imagebox,
	}

	local img_with_background = wibox.container.background(image)

	mywidget = wibox.widget({
		img_with_background,
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
		widget = wibox.container.arcchart,
	})

	local piechart_widget = wibox.widget({
		colors = {
			colors.red,
			colors.comment,
			colors.green,
		},
		forced_height = 300,
		forced_width = 500,
		border_width = 1,
		border_color = colors.background,
		widget = wibox.widget.piechart,
	})

	local popup = awful.popup({
		widget = {
			{
				{
					text = "Memory usage",
					align = "center",
					widget = wibox.widget.textbox,
				},
				{
					piechart_widget,
					widget = wibox.container.margin,
				},
				layout = wibox.layout.fixed.vertical,
			},
			bg = colors.background,
			shape = gears.shape.rounded_rect,
			widget = wibox.container.background,
		},
		ontop = true,
		visible = false,
		placement = awful.placement.top_right,
		shape = gears.shape.rounded_rect,
		border_width = 1,
		border_color = colors.background,
	})

	awful.spawn.easy_async_with_shell("free", function(stdout, _, _, _)
		local maxmem = string.match(stdout, "Mem:%s+(%d+).*")
		mywidget.max_value = tonumber(maxmem)
	end)

	local function update_widget(widget, stdout)
		local memused, memfree, memcache = string.match(stdout, "Mem:%s+%d+%s+(%d+)%s+(%d+)%s+%d+%s+(%d+)")
		widget.values = {
			tonumber(memused),
			tonumber(memcache),
			tonumber(memfree),
		}
	end

	watch("free", 10, update_widget, mywidget)

	mywidget:buttons(awful.util.table.join(awful.button({}, 1, function()
		awful.spawn.easy_async_with_shell("free", function(stdout, _, _, _)
			local memused, memfree, memcache = string.match(stdout, "Mem:%s+%d+%s+(%d+)%s+(%d+)%s+%d+%s+(%d+)")
			piechart_widget.data_list = {
				{ "Used", memused },
				{ "Cache", memcache },
				{ "Free", memfree },
			}
		end)

		-- Timer to hide the popup after 5 seconds
		gears.timer.start_new(5, function()
			popup.visible = false
			return false -- Returning false ensures the timer runs only once
		end)

		popup.visible = true
	end)))

	popup:connect_signal("button::press", function()
		popup.visible = false
	end)

	return mywidget
end

return setmetatable(mywidget, {
	__call = function(_, ...)
		return worker(...)
	end,
})
