local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")

local modkey = require("config.keybindings.mod")
local clientkeys = require("config.keybindings.clientkeys")

clientbuttons = gears.table.join(
  awful.button({}, 1, function(c)
    c:emit_signal("request::activate", "mouse_click", { raise = true })
  end),
  awful.button({ modkey }, 1, function(c)
    c:emit_signal("request::activate", "mouse_click", { raise = true })
    awful.mouse.client.move(c)
  end),
  awful.button({ modkey }, 3, function(c)
    c:emit_signal("request::activate", "mouse_click", { raise = true })
    awful.mouse.client.resize(c)
  end)
)

local rules = {
  -- All clients will match this rule.
  {
    rule = {},
    properties = {
      border_width = beautiful.border_width,
      border_color = beautiful.border_normal,
      focus = awful.client.focus.filter,
      raise = true,
      keys = clientkeys,
      buttons = clientbuttons,
      screen = awful.screen.preferred,
      placement = awful.placement.no_overlap + awful.placement.no_offscreen,
    },
  },

  -- Floating clients.
  {
    rule_any = {
      instance = {
        "DTA", -- Firefox addon DownThemAll.
        "copyq", -- Includes session name in class.
        "pinentry",
      },
      class = {
        "floating", -- my custom floating class
        "Arandr",
        "Blueman-manager",
        "Gpick",
        "Kruler",
        "MessageWin", -- kalarm.
        "Sxiv",
        "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
        "Wpa_gui",
        "veromix",
        "xtightvncviewer",
        "qv4l2",
        "Sublime_text",
        "Gcr-prompter",
        "Galculator",
        "Surf",
      },

      -- Note that the name property shown in xprop might be set slightly after creation of the client
      -- and the name shown there might not match defined rules here.
      name = {
        "Event Tester", -- xev.
      },
      role = {
        "AlarmWindow", -- Thunderbird's calendar.
        "ConfigManager", -- Thunderbird's about:config.
        "pop-up", -- e.g. Google Chrome's (detached) Developer Tools.
      },
    },
    properties = {
      floating = true,
      ontop = true,
      placement = awful.placement.centered
    },
  },

  -- Set applications to always appear on specific tags
  { rule = { class = "firefox" },
    properties = { screen = 1, tag = "2" } },
  { rule = { class = "Slack" },
    properties = { screen = 1, tag = "3" } },
  { rule = { class = "TelegramDesktop" },
    properties = { screen = 1, tag = "4" } },
  { rule = { class = "VSCodium" },
    properties = { screen = 1, tag = "6" } },
  { rule = { class = "Chromium" },
    properties = { screen = 1, tag = "7" } },
  { rule = { class = "Spotify" },
    properties = { screen = 1, tag = "9" } },
}

return rules
