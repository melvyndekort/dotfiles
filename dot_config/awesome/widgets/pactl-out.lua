local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local watch = require("awful.widget.watch")
local colors = require("colors")

local config_dir = gears.filesystem.get_configuration_dir()

local mywidget = {}
local mute = "no"

local function worker()
  local cmd_get_volume = "pactl get-sink-volume @DEFAULT_SINK@"
  local cmd_get_mute = "pactl get-sink-mute @DEFAULT_SINK@"

  mywidget = wibox.widget {
    {
      widget = wibox.container.margin,
      top = 4,
      bottom = 4,
      {
        id = "progressbar",
        max_value = 100,
        forced_height = 16,
        forced_width = 65,
        color = colors.green,
        shape = gears.shape.rounded_rect,
        widget = wibox.widget.progressbar,
      },
    },
    {
      layout = wibox.layout.fixed.horizontal,
      {
        widget = wibox.container.place,
        valign = "center",
        {
          id = "image",
          widget = wibox.widget.imagebox,
          resize = true,
          forced_height = 21,
          forced_width = 21,
        }
      },
      {
        id = "text_color",
        widget = wibox.container.background,
        {
          id = "text",
          align = "center",
          valign = "center",
          font = "Hack 11",
          widget = wibox.widget.textbox,
        },
      },
    },
    layout = wibox.layout.stack,
  }

  local tooltip = awful.tooltip({
    objects = { mywidget },
  })

  local function update_mute(widget, stdout)
    mute = string.match(stdout, "Mute:%s*(%a+)")
  end

  local function update_widget(widget, stdout)
    local volume_str = string.match(stdout, "(%d+)%s*%%")
    local volume = tonumber(volume_str)
    tooltip.text = "Volume: " .. volume .. "%"

    if mute == "yes" or volume == 0 then
      mywidget:get_children_by_id("progressbar")[1].background_color = colors.current
      mywidget:get_children_by_id("progressbar")[1].value = 0
      mywidget:get_children_by_id("text_color")[1].fg = colors.foreground
      mywidget:get_children_by_id("image")[1].image = config_dir .. "icons/volume_neg.png"
      mywidget:get_children_by_id("text")[1].text = "mute"
    else
      mywidget:get_children_by_id("progressbar")[1].background_color = colors.foreground
      mywidget:get_children_by_id("progressbar")[1].value = volume
      mywidget:get_children_by_id("text_color")[1].fg = "#000000"
      mywidget:get_children_by_id("image")[1].image = config_dir .. "icons/volume.png"
      mywidget:get_children_by_id("text")[1].text = tostring(volume) .. "%"
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
    awesome.spawn("kitty --single-instance --class=floating -e pulsemixer")
  end

  local function mywidget_inc()
    awful.spawn.with_shell("pactl set-sink-volume @DEFAULT_SINK@ +2%")
    awful.spawn.easy_async_with_shell(cmd_get_volume, function(stdout, _, _, _)
      update_widget(mywidget, stdout)
    end)
  end

  local function mywidget_dec()
    awful.spawn.with_shell("pactl set-sink-volume @DEFAULT_SINK@ -2%")
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
      local volume_str = string.match(stdout, "(%d+)%s*%%")
      local volume = tonumber(volume_str)
      mywidget.value = volume
      tooltip.text = "Volume: " .. volume .. "%"
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
