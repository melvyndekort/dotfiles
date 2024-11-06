local awful = require("awful")
local naughty = require("naughty")
local gears = require("gears")
local wibox = require("wibox")
local colors = require("colors")

local mywidget = {}

-- Define the radio stream URL
local radio_stream_url = "https://www.mp3streams.nl/zender/radio-538/stream/4-mp3-128"

local function worker(user_args)
    local args = user_args or {}

    -- Create the widget icon
    local image = wibox.widget {
        image = gears.filesystem.get_configuration_dir() .. "icons/radio.png",
        resize = true,
        widget = wibox.widget.imagebox,
    }

    -- Container for the widget
    mywidget = wibox.container.background(image)

    -- Tooltip for the widget
    local tooltip = awful.tooltip({
        objects = { mywidget },
    })

    -- Boolean to track whether the radio is playing
    local is_playing = false

    -- Function to toggle the radio playback
    local function toggle_radio()
        if is_playing then
            -- Stop the stream by killing mpv
            awful.spawn("pkill mpv")
            image.image = gears.filesystem.get_configuration_dir() .. "icons/radio.png"
            mywidget.bg = colors.background
            tooltip.text = "Radio: Stopped"
        else
            -- Start the stream using mpv
            awful.spawn("mpv --no-video " .. radio_stream_url, false)
            image.image = gears.filesystem.get_configuration_dir() .. "icons/radio_neg.png"
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
