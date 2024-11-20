local awful = require("awful")
local naughty = require("naughty")
local gears = require("gears")
local wibox = require("wibox")
local watch = require("awful.widget.watch")
local colors = require("colors")

local mywidget = {}
local config_dir = gears.filesystem.get_configuration_dir()

local function worker(user_args)
  local image = wibox.widget {
    resize = true,
    widget = wibox.widget.imagebox,
  }

  local img_with_background = wibox.container.background(image)

  mywidget = wibox.widget({
    img_with_background,
    max_value = 100,
    rounded_edge = true,
    thickness = 2,
    start_angle = 2 * math.pi * 3 / 4,
    forced_height = 26,
    forced_width = 26,
    bg = colors.background,
    paddings = 2,
    widget = wibox.container.arcchart,
  })

  local last_battery_check = os.time()

  local function show_battery_warning()
    naughty.notify({
      icon = config_dir .. "icons/warning.png",
      icon_size = 100,
      text = "Connect a charger!",
      title = "Battery is dying",
      timeout = 25,
      hover_timeout = 0.5,
      position = "top_right",
      bg = colors.red,
      fg = colors.background,
      width = 300,
    })
  end

  local function update_widget(widget, stdout)
    local charge = 0
    local status
    for s in stdout:gmatch("[^\r\n]+") do
      local cur_status, charge_str, _ = string.match(s, ".+: ([%a%s]+), (%d?%d?%d)%%,?(.*)")
      if cur_status ~= nil and charge_str ~= nil then
        local cur_charge = tonumber(charge_str)
        if cur_charge > charge then
          status = cur_status
          charge = cur_charge
        end
      end
    end

    widget.value = charge

    if status == "Charging" or charge == 100 then
      image.image = gears.filesystem.get_configuration_dir() .. "icons/bolt.png"
      img_with_background.bg = colors.purple
    elseif charge > 90 then
      image.image = gears.filesystem.get_configuration_dir() .. "icons/battery_full.png"
      img_with_background.bg = colors.green
    elseif charge > 74 then
      image.image = gears.filesystem.get_configuration_dir() .. "icons/battery_6.png"
      img_with_background.bg = colors.green
    elseif charge > 61 then
      image.image = gears.filesystem.get_configuration_dir() .. "icons/battery_5.png"
      img_with_background.bg = colors.yellow
    elseif charge > 48 then
      image.image = gears.filesystem.get_configuration_dir() .. "icons/battery_4.png"
      img_with_background.bg = colors.yellow
    elseif charge > 35 then
      image.image = gears.filesystem.get_configuration_dir() .. "icons/battery_3.png"
      img_with_background.bg = colors.orange
    elseif charge > 22 then
      image.image = gears.filesystem.get_configuration_dir() .. "icons/battery_2.png"
      img_with_background.bg = colors.orange
    elseif charge > 10 then
      image.image = gears.filesystem.get_configuration_dir() .. "icons/battery_1.png"
      img_with_background.bg = colors.red
    else
      image.image = gears.filesystem.get_configuration_dir() .. "icons/battery_0.png"
      img_with_background.bg = colors.red
      if os.difftime(os.time(), last_battery_check) >= 300 then
        -- if 5 minutes have elapsed since the last warning
        last_battery_check = os.time()
        show_battery_warning()
      end
    end
  end

  -- Check for battery
  local has_battery = false
  awful.spawn.easy_async_with_shell("acpi -b", function(stdout, stderr, _, _)
    if #stdout > 0 then
      -- Only watch if battery is present
      watch("acpi", 10, update_widget, mywidget)
    else
      -- No battery, display static bolt icon and exit
      image.image = gears.filesystem.get_configuration_dir() .. "icons/bolt.png"
      img_with_background.bg = colors.current
      mywidget.colors = { colors.current }
      mywidget.value = 100
    end
  end)

  local tooltip = awful.tooltip({
    objects = { mywidget },
  })

  mywidget:connect_signal("mouse::enter", function()
    awful.spawn.easy_async_with_shell("acpi", function(stdout, _, _, _)
      tooltip.text = stdout
    end)
  end)

  return mywidget
end

return setmetatable(mywidget, {
  __call = function(_, ...)
    return worker(...)
  end,
})
