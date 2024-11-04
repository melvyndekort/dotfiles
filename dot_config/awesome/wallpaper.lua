local gears = require("gears")
local awful = require("awful")
local colors = require("colors")

-- Base directory for wallpapers
local wallpaper_base_dir = "/home/melvyn/Sync/pictures/wallpapers/"

-- Function to get a random wallpaper file from the specified directory using shuf
local function get_random_wallpaper_file(dir)
  local p = io.popen('find "' .. dir .. '" -type f | shuf -n 1')
  local wallpaper = p:read("*line") -- Read the randomly selected wallpaper file
  p:close()
  return wallpaper
end

-- Function to set a random wallpaper based on screen resolution
function set_random_wallpaper(s)
  -- Get the screen resolution
  local resolution_folder = s.geometry.width .. "x" .. s.geometry.height
  local wallpaper_dir = wallpaper_base_dir .. resolution_folder .. "/"

  -- Get a random wallpaper in the matching resolution folder
  local wallpaper = get_random_wallpaper_file(wallpaper_dir)
  if wallpaper then
    -- Set the wallpaper for the screen
    gears.wallpaper.fit(wallpaper, s, colors.background)
  else
    -- Optionally, handle the case when no wallpapers are found for the resolution
    gears.debug.print_warning("No wallpapers found in " .. wallpaper_dir)
    gears.wallpaper.fit(wallpaper_base_dir .. "default.png", s, colors.background)
  end
end

-- Apply the wallpaper when Awesome starts or when screen geometry changes
screen.connect_signal("property::geometry", set_random_wallpaper)

-- Timer to change the wallpaper every 60 seconds
local wallpaper_timer = gears.timer({
    timeout = 60, -- Time in seconds
    autostart = true,
    call_now = true,
    callback = function()
      awful.screen.connect_for_each_screen(set_random_wallpaper)
    end,
})
