local awful = require("awful")
local naughty = require("naughty")
local gears = require("gears")
local wibox = require("wibox")
local colors = require("colors")

local mywidget = {}

local function worker(user_args)
  local args = user_args or {}

  local image = wibox.widget {
    image = gears.filesystem.get_configuration_dir() .. "icons/notification.png",
    resize = true,
    widget = wibox.widget.imagebox,
  }

  mywidget = wibox.container.background(image)

  local tooltip = awful.tooltip({
    objects = { mywidget },
  })

  local function update_widget()
    if naughty.is_suspended() then
      image.image = gears.filesystem.get_configuration_dir() .. "icons/notification_neg.png"
      mywidget.bg = colors.orange
      tooltip.text = "Notifications are OFF"
    else
      image.image = gears.filesystem.get_configuration_dir() .. "icons/notification.png"
      mywidget.bg = colors.background
      tooltip.text = "Notifications are ON"
    end
  end

  mywidget:buttons(awful.util.table.join(
    awful.button({}, 1, function()
      naughty.toggle()
      update_widget()
    end),
    awful.button({}, 3, function()
      naughty.destroy_all_notifications()
    end)
  ))

  mywidget:connect_signal("mouse::enter", function()
    update_widget()
  end)

  awesome.connect_signal("notifications_widget::update", function(value)
    update_widget()
  end)

  return mywidget
end

return setmetatable(mywidget, {
  __call = function(_, ...)
    return worker(...)
  end,
})
