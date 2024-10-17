local wibox = require("wibox")
local watch = require("awful.widget.watch")

local widget = {}

local function worker(user_args)
  local args = user_args or {}
  local arc_thickness = args.arc_thickness or 2
  local size = args.size or 18
  local bg_color = args.bg_color or '#ffffff11'
  local timeout = args.timeout or 2
  local count = 0

  local text = wibox.widget {
    align = 'center',
    valign = 'center',
    widget = wibox.widget.textbox
  }

  local text_with_background = wibox.container.background(text)

  widget = wibox.widget {
    text_with_background,
    max_value = 100,
    rounded_edge = false,
    thickness = arc_thickness,
    start_angle = 2 * math.pi * (3/4),
    forced_height = size,
    forced_width = size,
    bg = bg_color,
    paddings = 2,
    widget = wibox.container.arcchart
  }

  local function update_widget(widget, stdout)
    if count >= 100 then
      count = 0
    else
      count = count + 5
    end
    widget.value = count
  end

  watch("acpi", timeout, update_widget, widget)

  return widget
end

return setmetatable(widget, { __call = function(_, ...)
  return worker(...)
end })
