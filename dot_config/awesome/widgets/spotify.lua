local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local naughty = require("naughty")
local watch = require("awful.widget.watch")

local function ellipsize(text, length)
    -- utf8 only available in Lua 5.3+
    if utf8 == nil then
        return text:sub(0, length)
    end
    return (utf8.len(text) > length and length > 0)
        and text:sub(0, utf8.offset(text, length - 2) - 1) .. '...'
        or text
end

local spotify_widget = {}

local function worker()

    local font = 'Hack Bold 9'
    local play_icon = gears.filesystem.get_configuration_dir() .. "icons/spotify_play.png"
    local pause_icon = gears.filesystem.get_configuration_dir() .. "icons/spotify_pause.png"

    local cur_artist = ''
    local cur_title = ''
    local cur_album = ''

    spotify_widget = wibox.widget {
        {
            id = 'artistw',
            font = font,
            widget = wibox.widget.textbox,
        },
        {
            layout = wibox.layout.stack,
            {
                widget = wibox.container.margin,
                left = 5,
                right = 5,
                {
                    widget = wibox.container.place,
                    valign = "center",
                    {
                        id = "icon",
                        widget = wibox.widget.imagebox,
                        forced_height = 20,
                        forced_width = 20,
                    }
                }
            },
            {
                widget = wibox.widget.textbox,
                font = font,
                text = ' ',
                forced_height = 1
            }
        },
        {
            layout = wibox.container.scroll.horizontal,
            max_size = 100,
            step_function = wibox.container.scroll.step_functions.waiting_nonlinear_back_and_forth,
            speed = 40,
            {
                id = 'titlew',
                font = font,
                widget = wibox.widget.textbox
            }
        },
        layout = wibox.layout.align.horizontal,
        set_status = function(self, is_playing)
            self:get_children_by_id('icon')[1]:set_image(is_playing and play_icon or pause_icon)
            self:get_children_by_id('icon')[1]:set_opacity(is_playing and 1 or 0.2)

            self:get_children_by_id('titlew')[1]:set_opacity(is_playing and 1 or 0.2)
            self:get_children_by_id('titlew')[1]:emit_signal('widget::redraw_needed')

            self:get_children_by_id('artistw')[1]:set_opacity(is_playing and 1 or 0.2)
            self:get_children_by_id('artistw')[1]:emit_signal('widget::redraw_needed')
        end,
        set_text = function(self, artist, song)
            local artist_to_display = ellipsize(artist, 15)
            if self:get_children_by_id('artistw')[1]:get_markup() ~= artist_to_display then
                self:get_children_by_id('artistw')[1]:set_markup(artist_to_display)
            end
            local title_to_display = ellipsize(song, 15)
            if self:get_children_by_id('titlew')[1]:get_markup() ~= title_to_display then
                self:get_children_by_id('titlew')[1]:set_markup(title_to_display)
            end
        end
    }

    local update_widget_icon = function(widget, stdout, _, _, _)
        stdout = string.gsub(stdout, "\n", "")
        widget:set_status(stdout == 'Playing' and true or false)
    end

    local update_widget_text = function(widget, stdout, _, _, _)
        if string.find(stdout, 'Error: Spotify is not running.') ~= nil then
            widget:set_text('','')
            return
        end

        local escaped = string.gsub(stdout, "&", '&amp;')
        local album, _, artist, title =
            string.match(escaped, 'Album%s*(.*)\nAlbumArtist%s*(.*)\nArtist%s*(.*)\nTitle%s*(.*)\n')

        if album ~= nil and title ~=nil and artist ~= nil then
            cur_artist = artist
            cur_title = title
            cur_album = album

            widget:set_text(artist, title)
            widget:set_visible(true)
        end
    end

    watch('sp status', 3, update_widget_icon, spotify_widget)
    watch('sp current', 3, update_widget_text, spotify_widget)

    spotify_widget:connect_signal("button::press", function(_, _, _, button)
        if (button == 1) then
            awful.spawn.easy_async('sp status', function(stdout, stderr, exitreason, exitcode)
                if string.find(stdout, 'Error: Spotify is not running.') ~= nil then
                    naughty.notify({
                        preset = naughty.config.presets.normal,
                        title = "Spotify",
                        text  = "Starting Spotify"
                    })
                    awful.spawn('spotify', false)
                else
                    awful.spawn('sp play', false)
                end
            end)
        elseif (button == 4) then
            awful.spawn('sp next', false)
        elseif (button == 5) then
            awful.spawn('sp prev', false)
        end

        gears.timer.start_new(0.2, function()
            awful.spawn.easy_async('sp status', function(stdout, stderr, exitreason, exitcode)
                update_widget_icon(spotify_widget, stdout, stderr, exitreason, exitcode)
            end)
            return false
        end)
    end)


    local spotify_tooltip = awful.tooltip {
        mode = 'outside',
        preferred_positions = {'bottom'},
    }

    spotify_tooltip:add_to_object(spotify_widget)

    spotify_widget:connect_signal('mouse::enter', function()
        spotify_tooltip.markup = '<b>Album</b>: ' .. cur_album
            .. '\n<b>Artist</b>: ' .. cur_artist
            .. '\n<b>Song</b>: ' .. cur_title
    end)

    return spotify_widget
end

return setmetatable(spotify_widget, { __call = function(_, ...)
    return worker(...)
end })
