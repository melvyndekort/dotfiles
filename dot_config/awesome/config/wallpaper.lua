local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")

wallpaper_basedir = "/home/melvyn/Sync/pictures/wallpapers/"
local default_wallpaper = wallpaper_basedir .. "default.png"
local cache_file = "/home/melvyn/.cache/wall"

local function set_wallpaper()
    local selected_wallpaper = default_wallpaper

    -- Check if the cache file exists and read its content
    local file = io.open(cache_file, "r")
    if file then
        local cached_wallpaper = file:read("*all"):match("^%s*(.-)%s*$") -- Trim whitespace
        file:close()

        -- If the cache file has a valid wallpaper, use it
        if cached_wallpaper and gears.filesystem.file_readable(cached_wallpaper) then
            selected_wallpaper = cached_wallpaper
        else
            print("Invalid wallpaper in cache, using default wallpaper.")
        end
    else
        print("Cache file not found, using default wallpaper.")
    end

    for s in screen do
      gears.wallpaper.fit(selected_wallpaper, s, beautiful.bg_normal)
    end
end

set_wallpaper()
