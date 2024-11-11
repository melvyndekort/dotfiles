local awful = require("awful")
local naughty = require("naughty")
local gears = require("gears")
local wibox = require("wibox")
local watch = require("awful.widget.watch")
local colors = require("colors")

local mywidget = {}

local function worker(user_args)
	local args = user_args or {}
	local cmd_get_volume = "pactl get-sink-volume @DEFAULT_SINK@"
	local cmd_get_mute = "pactl get-sink-mute @DEFAULT_SINK@"

	local mute = "no"

	local image = wibox.widget {
		image = gears.filesystem.get_configuration_dir() .. "icons/volume.png",
    resize = true,
    widget = wibox.widget.imagebox,
	}

	local img_with_background = wibox.container.background(image)

	mywidget = wibox.widget({
		img_with_background,
		max_value = 100,
		thickness = 2,
		start_angle = 2 * math.pi * 3 / 4,
		forced_height = 26,
		forced_width = 26,
		bg = colors.background,
		paddings = 2,
		widget = wibox.container.arcchart,
	})

	local tooltip = awful.tooltip({
		objects = { mywidget },
	})

	local function update_mute(widget, stdout)
		mute = string.match(stdout, "Mute:%s*(%a+)")
	end

	local function update_widget(widget, stdout)
		local volume_str = string.match(stdout, "(%d+)%s*%%")
		local volume = tonumber(volume_str)

		widget.value = volume
		tooltip.text = "Volume: " .. volume .. "%"

		if mute == "yes" or volume == 0 then
			img_with_background.bg = colors.current
		elseif volume < 50 then
			img_with_background.bg = colors.green
		elseif volume < 75 then
			img_with_background.bg = colors.orange
		else
			img_with_background.bg = colors.red
		end
	end

	local function mywidget_toggle()
		awful.spawn.with_shell("pactl set-sink-mute @DEFAULT_SINK@ toggle")
		awful.spawn.easy_async_with_shell(cmd_get_mute, function(stdout, _, _, _)
			update_mute(mywidget, stdout)
		end)
		awful.spawn.easy_async_with_shell(cmd_get_volume, function(stdout, _, _, _)
			update_widget(mywidget, stdout)
		end)
	end

	local function mywidget_mixer()
		awesome.spawn("kitty --single-instance --class=pulsemixer -e pulsemixer")
	end

	local function mywidget_inc()
		awful.spawn.with_shell("pactl set-sink-volume @DEFAULT_SINK@ +5%")
		awful.spawn.easy_async_with_shell(cmd_get_volume, function(stdout, _, _, _)
			update_widget(mywidget, stdout)
		end)
	end

	local function mywidget_dec()
		awful.spawn.with_shell("pactl set-sink-volume @DEFAULT_SINK@ -5%")
		awful.spawn.easy_async_with_shell(cmd_get_volume, function(stdout, _, _, _)
			update_widget(mywidget, stdout)
		end)
	end

	mywidget:buttons(awful.util.table.join(
		awful.button({}, 1, function()
			mywidget_toggle()
		end),
		awful.button({}, 3, function()
			mywidget_mixer()
		end),
		awful.button({}, 4, function()
			mywidget_inc()
		end),
		awful.button({}, 5, function()
			mywidget_dec()
		end)
	))

	watch(cmd_get_volume, 5, update_widget, mywidget)
	watch(cmd_get_mute, 5, update_mute, mywidget)

	mywidget:connect_signal("mouse::enter", function()
		awful.spawn.easy_async_with_shell(cmd_get_volume, function(stdout, _, _, _)
			tooltip.text = "Volume: " .. string.match(stdout, "(%d+%%)")
		end)
	end)

	awesome.connect_signal("pactl_out_widget::update", function(value)
		awful.spawn.easy_async_with_shell(cmd_get_mute, function(stdout, _, _, _)
			update_mute(mywidget, stdout)
		end)
		awful.spawn.easy_async_with_shell(cmd_get_volume, function(stdout, _, _, _)
			update_widget(mywidget, stdout)
		end)
	end)

	return mywidget
end

return setmetatable(mywidget, {
	__call = function(_, ...)
		return worker(...)
	end,
})
