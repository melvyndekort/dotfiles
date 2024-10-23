local awful = require("awful")
local gears = require("gears")
local modkey = require("keybindings.mod")
local hotkeys_popup = require("awful.hotkeys_popup")

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

	-- Standard program
	-- awful.key({ modkey }, "Return", function()
	--   awful.spawn(terminal)
	-- end, { description = "open a terminal", group = "launcher" }),
	awful.key({ modkey }, "n", function()
		naughty.toggle()
		awesome.emit_signal("notifications_widget::update", true)
	end, { description = "pause notifications", group = "awesome" }),
	awful.key({ modkey, "Control" }, "r", awesome.restart, { description = "reload awesome", group = "awesome" }),
	awful.key({ modkey, "Shift" }, "q", awesome.quit, { description = "quit awesome", group = "awesome" }),

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
