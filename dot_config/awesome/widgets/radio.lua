local awful = require("awful")
local naughty = require("naughty")
local gears = require("gears")
local wibox = require("wibox")
local colors = require("colors")

local mywidget = {}
local config_dir = gears.filesystem.get_configuration_dir()

-- Define the radio stream URL
local radio_stream_url = "https://www.mp3streams.nl/zender/radio-538/stream/4-mp3-128"

local function worker()
  mywidget = wibox.widget {
    widget = wibox.container.background,
    {
      widget = wibox.container.place,
      valign = "center",
      {
        id = "image",
        widget = wibox.widget.imagebox,
        image = config_dir .. "icons/radio.png",
        resize = true,
        forced_width = 27,
        forced_height = 27,
      },
    },
  }

  -- Tooltip for the widget
  local tooltip = awful.tooltip({
    objects = { mywidget },
    text = "Radio: Stopped",
  })

  -- Boolean to track whether the radio is playing
  local is_playing = false

  -- Function to toggle the radio playback
  local function toggle_radio()
    if is_playing then
      -- Stop the stream by killing mpv
      awful.spawn("pkill mpv")
      mywidget:get_children_by_id("image")[1].image = config_dir .. "icons/radio.png"
      mywidget.bg = colors.background
      tooltip.text = "Radio: Stopped"
    else
      -- Start the stream using mpv
      awful.spawn("mpv --no-config --terminal=no --no-video --loop --volume=100 --cache-secs=60 " .. radio_stream_url, false)
      mywidget:get_children_by_id("image")[1].image = config_dir .. "icons/radio_neg.png"
      mywidget.bg = colors.green
      tooltip.text = "Radio: Playing"
    end
    is_playing = not is_playing  -- Toggle the state
  end

  -- Update widget when clicked
  mywidget:buttons(awful.util.table.join(
    awful.button({}, 1, function()
      toggle_radio()
    end)
  ))

  return mywidget
end

return setmetatable(mywidget, {
  __call = function(_, ...)
    return worker(...)
  end,
})
