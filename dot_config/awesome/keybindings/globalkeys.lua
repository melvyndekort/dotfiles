local awful = require("awful")
local gears = require("gears")
local naughty = require("naughty")
local modkey = require("keybindings.mod")
local hotkeys_popup = require("awful.hotkeys_popup")

-- Custom App Launcher
awful.keygrabber {
  mask_event_callback = false,
  root_keybindings = {
    {{"Mod4"}, "o", function() end},
  },
  stop_key = {"Escape"},
  keybindings = {
    {{}, "a", function()
      awful.spawn("rofi-emulator")
    end, { description = "foobar", group = "app launcher" }},
    {{}, "e", function()
      awful.spawn("subl")
    end, { description = "foobar", group = "app launcher" }},
    {{}, "i", function()
      awful.spawn("intellij-idea-ultimate-edition")
    end, { description = "foobar", group = "app launcher" }},
    {{}, "j", function()
      awful.spawn("rofi-java")
    end, { description = "foobar", group = "app launcher" }},
    {{}, "m", function()
      awful.spawn("rofi-samba")
    end, { description = "foobar", group = "app launcher" }},
    {{}, "p", function()
      awful.spawn("postman")
    end, { description = "foobar", group = "app launcher" }},
    {{}, "r", function()
      awful.spawn("galculator")
    end, { description = "foobar", group = "app launcher" }},
    {{}, "s", function()
      awful.spawn("rofi-ssh-config")
    end, { description = "foobar", group = "app launcher" }},
    {{}, "t", function()
      awful.spawn("rofi-terraform")
    end, { description = "foobar", group = "app launcher" }},
    {{}, 'v', function()
      awful.spawn("rofi-codium")
    end, { description = "foobar", group = "app launcher" }},
    {{}, 'w', function()
      awful.spawn("rofi-browser")
    end, { description = "foobar", group = "app launcher" }},
    {{}, "y", function()
      awful.spawn("rofi-yubikey clipboard")
    end, { description = "foobar", group = "app launcher" }},
    {{}, "Y", function()
      awful.spawn("rofi-yubikey direct")
    end, { description = "foobar", group = "app launcher" }},
    {{}, "z", function()
      awful.spawn("kitty --class=pulsemixer -e pulsemixer")
    end, { description = "foobar", group = "app launcher" }},
  },
  stop_event = "release",
  keypressed_callback = function(self, _, _)
    self:stop()
  end,
}

local globalkeys = gears.table.join(
  awful.key({ modkey }, "s", hotkeys_popup.show_help, { description = "show help", group = "awesome" }),
  awful.key({ modkey }, "Left", awful.tag.viewprev, { description = "view previous", group = "tag" }),
  awful.key({ modkey }, "Right", awful.tag.viewnext, { description = "view next", group = "tag" }),
  awful.key({ modkey }, "Escape", awful.tag.history.restore, { description = "go back", group = "tag" }),

  awful.key({ modkey }, "j", function()
    awful.client.focus.byidx(1)
  end, { description = "focus next by index", group = "client" }),
  awful.key({ modkey }, "k", function()
    awful.client.focus.byidx(-1)
  end, { description = "focus previous by index", group = "client" }),
  awful.key({ modkey }, "w", function()
    mymainmenu:show()
  end, { description = "show main menu", group = "awesome" }),

  -- Layout manipulation
  awful.key({ modkey, "Shift" }, "j", function()
    awful.client.swap.byidx(1)
  end, { description = "swap with next client by index", group = "client" }),
  awful.key({ modkey, "Shift" }, "k", function()
    awful.client.swap.byidx(-1)
  end, { description = "swap with previous client by index", group = "client" }),
  awful.key({ modkey, "Control" }, "j", function()
    awful.screen.focus_relative(1)
  end, { description = "focus the next screen", group = "screen" }),
  awful.key({ modkey, "Control" }, "k", function()
    awful.screen.focus_relative(-1)
  end, { description = "focus the previous screen", group = "screen" }),
  awful.key({ modkey }, "u", awful.client.urgent.jumpto, { description = "jump to urgent client", group = "client" }),
  awful.key({ modkey }, "Tab", function()
    awful.client.focus.history.previous()
    if client.focus then
      client.focus:raise()
    end
  end, { description = "go back", group = "client" }),

  -- Audio keybindings
  awful.key({ modkey }, "z", function()
    awful.spawn.with_shell("pactl set-source-mute @DEFAULT_SOURCE@ toggle")
    awesome.emit_signal("pactl_in_widget::update", true)
  end, { description = "toggle microphone", group = "audio" }),
  awful.key({ modkey }, "bracketleft", function()
    awful.spawn.with_shell("pactl set-sink-volume @DEFAULT_SINK@ -5%")
    awesome.emit_signal("pactl_out_widget::update", true)
  end, { description = "decrease volume", group = "audio" }),
  awful.key({ modkey }, "bracketright", function()
    awful.spawn.with_shell("pactl set-sink-volume @DEFAULT_SINK@ +5%")
    awesome.emit_signal("pactl_out_widget::update", true)
  end, { description = "increase volume", group = "audio" }),
  awful.key({ modkey }, "backslash", function()
    awful.spawn.with_shell("pactl set-sink-mute @DEFAULT_SINK@ toggle")
    awesome.emit_signal("pactl_out_widget::update", true)
  end, { description = "toggle volume", group = "audio" }),
  awful.key({}, "XF86AudioLowerVolume", function()
    awful.spawn.with_shell("pactl set-sink-volume @DEFAULT_SINK@ -5%")
    awesome.emit_signal("pactl_out_widget::update", true)
  end, { description = "decrease volume", group = "audio" }),
  awful.key({}, "XF86AudioRaiseVolume", function()
    awful.spawn.with_shell("pactl set-sink-volume @DEFAULT_SINK@ +5%")
    awesome.emit_signal("pactl_out_widget::update", true)
  end, { description = "increase volume", group = "audio" }),

  -- Brightness keys
  awful.key({}, "XF86MonBrightnessUp", function()
    awful.spawn.with_shell("brightnessctl s +10%")
  end, { description = "brightness up", group = "brightness" }),
  awful.key({}, "XF86MonBrightnessDown", function()
    awful.spawn.with_shell("brightnessctl s 10%-")
  end, { description = "brightness up", group = "brightness" }),
  awful.key({ modkey }, "Up", function()
    awful.spawn.with_shell("brightnessctl s +10%")
  end, { description = "brightness up", group = "brightness" }),
  awful.key({ modkey }, "Down", function()
    awful.spawn.with_shell("brightnessctl s 10%-")
  end, { description = "brightness up", group = "brightness" }),

  -- Awesome control
  awful.key({ modkey, "Control" }, "r", function()
    awesome.restart()
  end, { description = "reload awesome", group = "awesome" }),
  awful.key({ modkey, "Shift" }, "q", function()
    awesome.quit()
  end, { description = "quit awesome", group = "awesome" }),

  -- Awesome extra
  awful.key({ modkey }, "n", function()
    naughty.toggle()
    awesome.emit_signal("notifications_widget::update", true)
  end, { description = "pause notifications", group = "awesome extra" }),
  awful.key({ modkey }, "d", function()
    awful.spawn("rofi -show combi")
  end, { description = "program launcher", group = "awesome extra"}),
  awful.key({ modkey }, "x", function()
    awful.spawn("xset s activate")
  end, { description = "lock", group = "awesome extra"}),
  awful.key({ modkey, "Shift" }, "x", function()
    awful.spawn("systemctl suspend")
  end, { description = "suspend", group = "awesome extra"}),
  awful.key({ modkey }, "Home", function()
    awful.screen.connect_for_each_screen(set_random_wallpaper)
  end, { description = "Set random wallpaper", group = "awesome extra" }),

  -- Notifications
  awful.key({ modkey }, "Escape", function()
    naughty.destroy_all_notifications()
  end, {description = "Close all notifications", group = "notifications"}),

  -- Terminal programs
  awful.key({ modkey }, "Return", function()
    awful.spawn("kitty")
  end, { description = "Plain terminal", group = "terminal"}),
  awful.key({ modkey, "Control"}, "Return", function()
    awful.spawn("kitty -e cmatrix")
  end, { description = "Matrix window", group = "terminal"}),
  awful.key({ modkey, "Shift"}, "Return", function()
    awful.spawn("kitty -e ranger")
  end, { description = "Ranger filemanager", group = "terminal"}),

-- Launchers
  awful.key({ modkey }, "F1", function()
    awful.spawn("surf https://cheatsheets.mdekort.nl/")
  end, { description = "show help", group = "launchers"}),
  awful.key({ modkey }, "F7", function()
    awful.spawn("rofi-bluetooth")
  end, { description = "bluetooth control", group = "launchers"}),
  awful.key({ modkey }, "F8", function()
    awful.spawn("rofi-display")
  end, { description = "display control", group = "launchers"}),
  awful.key({ modkey, "Shift"}, "F8", function()
    awful.spawn("rofi-autolock")
  end, { description = "autolock control", group = "launchers"}),
  awful.key({ modkey }, "F9", function()
    awful.spawn("pass clip -r")
  end, { description = "pass menu", group = "launchers"}),
  awful.key({ modkey }, "F10", function()
    awful.spawn("rofi -modi Bitwarden:rofi-bw -show Bitwarden")
  end, { description = "bitwarden menu", group = "launchers"}),
  awful.key({ modkey }, "F12", function()
    awful.spawn("rofi -modi power:rofi-power -show power")
  end, { description = "power menu", group = "launchers"}),

-- Screenshot bindings
  awful.key({}, "Print", function()
    awful.spawn("screenshot all")
  end, { description = "screenshot all", group = "screenshot"}),
  awful.key({ modkey }, "Print", function()
    awful.spawn("screenshot window")
  end, { description = "screenshot window", group = "screenshot"}),
  awful.key({ modkey, "Shift" }, "Print", function()
    awful.spawn("flameshot gui")
  end, { description = "custom screenshot", group = "screenshot"}),

-- Layout bindings
  awful.key({ modkey }, "l", function()
    awful.tag.incmwfact(0.05)
  end, { description = "increase master width factor", group = "layout" }),
  awful.key({ modkey }, "h", function()
    awful.tag.incmwfact(-0.05)
  end, { description = "decrease master width factor", group = "layout" }),
  awful.key({ modkey, "Shift" }, "h", function()
    awful.tag.incnmaster(1, nil, true)
  end, { description = "increase the number of master clients", group = "layout" }),
  awful.key({ modkey, "Shift" }, "l", function()
    awful.tag.incnmaster(-1, nil, true)
  end, { description = "decrease the number of master clients", group = "layout" }),
  awful.key({ modkey, "Control" }, "h", function()
    awful.tag.incncol(1, nil, true)
  end, { description = "increase the number of columns", group = "layout" }),
  awful.key({ modkey, "Control" }, "l", function()
    awful.tag.incncol(-1, nil, true)
  end, { description = "decrease the number of columns", group = "layout" }),
  awful.key({ modkey }, "space", function()
    awful.layout.inc(1)
  end, { description = "select next", group = "layout" }),
  awful.key({ modkey, "Shift" }, "space", function()
    awful.layout.inc(-1)
  end, { description = "select previous", group = "layout" }),

  awful.key({ modkey, "Control" }, "n", function()
    local c = awful.client.restore()
    -- Focus restored client
    if c then
      c:emit_signal("request::activate", "key.unminimize", { raise = true })
    end
  end, { description = "restore minimized", group = "client" })
)

return globalkeys
