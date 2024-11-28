local awful = require("awful")

require("config.layouts.centered")
require("config.layouts.fullscreen")

awful.layout.layouts = {
  awful.layout.suit.centered,
  awful.layout.suit.tile,
  awful.layout.suit.max,
  awful.layout.suit.fullscreen,
}
