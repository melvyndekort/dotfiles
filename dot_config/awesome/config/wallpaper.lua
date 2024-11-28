local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")

-- Wallpaper base directory and default wallpaper
local wallpaper_basedir = "/home/melvyn/Sync/pictures/wallpapers/"
local default_wallpaper = wallpaper_basedir .. "default.png"
local cache_file = "/home/melvyn/.cache/wall"

-- Function to get the wallpaper for a specific screen
local function get_wallpaper_for_resolution(resolution)
    local file = io.open(cache_file, "r")
    if not file then
        print("Cache file not found, using default wallpaper.")
        return default_wallpaper
    end

    -- Parse cache file for the specified resolution
    for line in file:lines() do
        local res, wallpaper = line:match("^(%d+x%d+)=(.+)$")
        if res == resolution and gears.filesystem.file_readable(wallpaper) then
            file:close()
            return wallpaper
        end
    end
    file:close()

    print("No valid wallpaper found for resolution " .. resolution .. ", using default wallpaper.")
    return default_wallpaper
end

-- Function to set wallpaper for all screens
local function set_wallpaper()
    for s in screen do
        local resolution = string.format("%dx%d", s.geometry.width, s.geometry.height)
        local wallpaper = get_wallpaper_for_resolution(resolution)
        gears.wallpaper.fit(wallpaper, s, beautiful.bg_normal)
    end
end

-- Set wallpaper at startup and when screen geometry changes
set_wallpaper()
screen.connect_signal("property::geometry", set_wallpaper)
