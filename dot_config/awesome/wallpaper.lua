-- Required libraries
local gears = require("gears") -- For random wallpaper setting and directory walking
local beautiful = require("beautiful") -- For setting wallpaper
local awful = require("awful") -- For timer

-- Wallpaper directory
local wallpaper_dir = "/home/melvyn/Sync/pictures/wallpapers/"

-- Function to change wallpaper to a random file in the specified directory
local function set_random_wallpaper()
    -- Get a list of all files in the directory
    awful.spawn.easy_async_with_shell("find " .. wallpaper_dir .. " -type f | shuf -n 1", function(stdout)
        local wallpaper = stdout:gsub("%s+", "") -- Remove whitespace from output
        if wallpaper and gears.filesystem.file_readable(wallpaper) then
            -- Set the wallpaper
            gears.wallpaper.maximized(wallpaper, nil, true)
        end
    end)
end

-- Change wallpaper every minute
local wallpaper_timer = gears.timer {
    timeout = 60,
    autostart = true,
    callback = set_random_wallpaper
}

-- Set initial wallpaper when Awesome starts
set_random_wallpaper()

-- Return the function to allow further customization if needed
return {
  set_random_wallpaper = set_random_wallpaper,
}
