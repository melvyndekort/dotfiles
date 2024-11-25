local awful = require("awful")
local naughty = require("naughty")
local gears = require("gears")
local wibox = require("wibox")
local colors = require("config.colors")

local mywidget = {}
local config_dir = gears.filesystem.get_configuration_dir()

local function worker()
  mywidget = wibox.widget {
    widget = wibox.container.background,
    {
      widget = wibox.container.place,
      valign = "center",
      {
        id = "image",
        widget = wibox.widget.imagebox,
        image = config_dir .. "icons/notification.png",
        resize = true,
        forced_width = 27,
        forced_height = 27,
      },
    },
  }

  local tooltip = awful.tooltip({
    objects = { mywidget },
  })

  local function update_widget()
    if naughty.is_suspended() then
      mywidget:get_children_by_id("image")[1].image = config_dir .. "icons/notification_neg.png"
      mywidget.bg = colors.orange
      tooltip.text = "Notifications are OFF"
    else
      mywidget:get_children_by_id("image")[1].image = config_dir .. "icons/notification.png"
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
