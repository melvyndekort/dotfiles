local awful = require("awful")
local naughty = require("naughty")
local gears = require("gears")
local wibox = require("wibox")
local colors = require("colors")

local mywidget = {}

local function worker(user_args)
	local args = user_args or {}

	local image = wibox.widget {
		image = gears.filesystem.get_configuration_dir() .. "icons/disk.png",
    resize = true,
    widget = wibox.widget.imagebox,
	}

	mywidget = wibox.container.background(image)

	return mywidget
end

return setmetatable(mywidget, {
	__call = function(_, ...)
		return worker(...)
	end,
})
