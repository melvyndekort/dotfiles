local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")

local modkey = require("config.keybindings.mod")

-- Custom widgets
local radio_widget = require("config.widgets.radio")
local spotify_widget = require("config.widgets.spotify")
local load_widget = require("config.widgets.load")
local memory_widget = require("config.widgets.memory")
local battery_widget = require("config.widgets.battery")
local pactl_out_widget = require("config.widgets.pactl-out")
local pactl_in_widget = require("config.widgets.pactl-in")
local notifications_widget = require("config.widgets.notifications")
local calendar_widget = require("config.widgets.calendar")
local disk_widget = require("config.widgets.disk")

-- Create a textclock widget
mytextclock = wibox.widget.textclock()
mytextclock.format = "%a %d %b %H:%M"
mytextclock.refresh = 10

local cw = calendar_widget()

mytextclock:connect_signal("button::press", function(_, _, _, button)
  if button == 1 then
    cw.toggle()
  end
end)

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
  awful.button({}, 1, function(t)
    t:view_only()
  end),
  awful.button({ modkey }, 1, function(t)
    if client.focus then
      client.focus:move_to_tag(t)
    end
  end),
  awful.button({}, 3, awful.tag.viewtoggle),
  awful.button({ modkey }, 3, function(t)
    if client.focus then
      client.focus:toggle_tag(t)
    end
  end),
  awful.button({}, 4, function(t)
    awful.tag.viewnext(t.screen)
  end),
  awful.button({}, 5, function(t)
    awful.tag.viewprev(t.screen)
  end)
)

awful.screen.connect_for_each_screen(function(s)
  -- Each screen has its own tag table.
  awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

  -- Create an imagebox widget which will contain an icon indicating which layout we're using.
  -- We need one layoutbox per screen.
  s.mylayoutbox = awful.widget.layoutbox(s)
  s.mylayoutbox:buttons(gears.table.join(
    awful.button({}, 1, function()
      awful.layout.inc(1)
    end),
    awful.button({}, 3, function()
      awful.layout.inc(-1)
    end),
    awful.button({}, 4, function()
      awful.layout.inc(1)
    end),
    awful.button({}, 5, function()
      awful.layout.inc(-1)
    end)
  ))

  -- Create a taglist widget
  s.mytaglist = awful.widget.taglist {
    screen  = s,
    filter  = awful.widget.taglist.filter.all,
    layout   = {
      layout  = wibox.layout.fixed.horizontal
    },
    widget_template = {
      {
        {
          {
            id = 'text_role',
            widget = wibox.widget.textbox,
          },
          left = 16,
          right = 16,
          widget = wibox.container.margin,
        },
        id = 'background_role',
        widget = wibox.container.background,
      },
      top = 3,
      bottom = 3,
      widget = wibox.container.margin
    },
    buttons = taglist_buttons
  }

  -- Create the wibox
  s.mywibox = awful.wibar({
    position = "top",
    screen = s,
  })

  local systray = wibox.widget.systray()
  systray:set_base_size(23)

  s.mywibox:setup({
    layout = wibox.layout.stack,
    {
      layout = wibox.layout.align.horizontal,
      {
        layout = wibox.layout.fixed.horizontal,
        s.mytaglist,
      },
      nil,
      {
        spacing = 15,
        layout = wibox.layout.fixed.horizontal,
        systray,
        load_widget({}),
        memory_widget({}),
        disk_widget({}),
        radio_widget({}),
        spotify_widget({}),
        pactl_out_widget({}),
        pactl_in_widget({}),
        battery_widget({}),
        notifications_widget({}),
        s.mylayoutbox,
      },
    },
    {
      layout = wibox.container.place,
      halign = "center",
      valign = "center",
      mytextclock,
    },
  })
end)
