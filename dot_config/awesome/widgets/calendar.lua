local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local gears = require("gears")
local naughty = require("naughty")
local colors = require("colors")

local mywidget = {}

local function worker(user_args)

    local calendar_theme = {
        bg = colors.background,
        fg = colors.foreground,
        focus_date_bg = colors.orange,
        focus_date_fg = colors.background,
        weekend_day_bg = colors.current,
        weekday_fg = colors.pink,
        header_fg = colors.cyan,
        border = beautiful.border_normal
    }

    local args = user_args or {}

    local styles = {}
    local function rounded_shape(size)
        return function(cr, width, height)
            gears.shape.rounded_rect(cr, width, height, size)
        end
    end

    styles.month = {
        padding = 4,
        bg_color = calendar_theme.bg,
        border_width = 0,
    }

    styles.normal = {
        markup = function(t) return t end,
        shape = rounded_shape(4)
    }

    styles.focus = {
        fg_color = calendar_theme.focus_date_fg,
        bg_color = calendar_theme.focus_date_bg,
        markup = function(t) return '<b>' .. t .. '</b>' end,
        shape = rounded_shape(4)
    }

    styles.header = {
        fg_color = calendar_theme.header_fg,
        bg_color = calendar_theme.bg,
        markup = function(t) return '<b>' .. t .. '</b>' end
    }

    styles.weekday = {
        fg_color = calendar_theme.weekday_fg,
        bg_color = calendar_theme.bg,
        markup = function(t) return '<b>' .. t .. '</b>' end,
    }

    local function decorate_cell(widget, flag, date)
        if flag == 'monthheader' and not styles.monthheader then
            flag = 'header'
        end

        -- highlight only today's day
        if flag == 'focus' then
            local today = os.date('*t')
            if not (today.month == date.month and today.year == date.year) then
                flag = 'normal'
            end
        end

        local props = styles[flag] or {}
        if props.markup and widget.get_text and widget.set_markup then
            widget:set_markup(props.markup(widget:get_text()))
        end
        -- Change bg color for weekends
        local default_bg
        if (flag == "normal") then
            local d = { year = date.year, month = (date.month or 1), day = (date.day or 1) }
            local weekday = tonumber(os.date('%w', os.time(d)))
            default_bg = (weekday == 0 or weekday == 6)
                and calendar_theme.weekend_day_bg
                or calendar_theme.bg
        end
        local ret = wibox.widget {
            {
                {
                    widget,
                    halign = 'center',
                    widget = wibox.container.place
                },
                margins = (props.padding or 2) + (props.border_width or 0),
                widget = wibox.container.margin
            },
            shape = props.shape,
            shape_border_color = props.border_color or '#000000',
            shape_border_width = props.border_width or 0,
            fg = props.fg_color or calendar_theme.fg,
            bg = props.bg_color or default_bg,
            widget = wibox.container.background
        }

        return ret
    end

    local cal = wibox.widget {
        date = os.date('*t'),
        font = beautiful.get_font(),
        fn_embed = decorate_cell,
        long_weekdays = true,
        start_sunday = false,
        week_numbers = true,
        widget = wibox.widget.calendar.month
    }

    local popup = awful.popup {
        ontop = true,
        visible = false,
        shape = rounded_shape(8),
        offset = { y = 5 },
        border_width = 1,
        border_color = calendar_theme.border,
        widget = cal
    }
    
	local auto_hide_timer = gears.timer({
		timeout = args.timeout or 2,
		single_shot = true,
		callback = function()
			mywidget.toggle()
		end,
	})

	popup:connect_signal("mouse::leave", function()
        if args.auto_hide then 
            auto_hide_timer:again()
        end
	end)
	popup:connect_signal("mouse::enter", function()
		auto_hide_timer:stop()
	end)

    popup:buttons(
            awful.util.table.join(
                    awful.button({}, 4, function()
                        local a = cal:get_date()
                        a.month = a.month + 1
                        cal:set_date(nil)
                        cal:set_date(a)
                        popup:set_widget(cal)
                    end),
                    awful.button({}, 5, function()
                        local a = cal:get_date()
                        a.month = a.month - 1
                        cal:set_date(nil)
                        cal:set_date(a)
                        popup:set_widget(cal)
                    end)
            )
    )

    function mywidget.toggle()
        if popup.visible then
            auto_hide_timer:stop()
            -- to faster render the calendar refresh it and just hide
            cal:set_date(nil) -- the new date is not set without removing the old one
            cal:set_date(os.date('*t'))
            popup:set_widget(nil) -- just in case
            popup:set_widget(cal)
            popup.visible = not popup.visible
        else
            awful.placement.top_right(popup, { margins = { top = 30, right = 10}, parent = awful.screen.focused() })
            popup.visible = true
            if args.auto_hide then
                auto_hide_timer:start()
            end
        end
    end

    return mywidget
end

return setmetatable(mywidget, { __call = function(_, ...)
    return worker(...)
end })
