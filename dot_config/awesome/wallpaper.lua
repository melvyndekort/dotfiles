local gears = require("gears")
local awful = require("awful")
local colors = require("colors")

-- Base directory for wallpapers
local wallpaper_base_dir = "/home/melvyn/Sync/pictures/wallpapers/"

-- Function to get a list of files in the specified directory
local function get_wallpaper_files(dir)
  local files = {}
  local p = io.popen('ls "' .. dir .. '"')
  if p then
    for file in p:lines() do
      table.insert(files, file)
    end
    p:close()
  end
  return files
end

-- Function to set a random wallpaper based on screen resolution
function set_random_wallpaper(s)
  -- Get the screen resolution
  local resolution_folder = s.geometry.width .. "x" .. s.geometry.height
  local wallpaper_dir = wallpaper_base_dir .. resolution_folder .. "/"

  -- Get the list of wallpapers in the matching resolution folder
  local files = get_wallpaper_files(wallpaper_dir)
  if #files > 0 then
    -- Select a random wallpaper from the list
    local wallpaper = wallpaper_dir .. files[math.random(#files)]
    -- Set the wallpaper for the screen, centered
    gears.wallpaper.centered(wallpaper, s, colors.background)  -- Background color around centered wallpaper
  else
    -- Optionally, handle the case when no wallpapers are found for the resolution
    gears.debug.print_warning("No wallpapers found in " .. wallpaper_dir)
    gears.wallpaper.centered(wallpaper_base_dir .. "default.png", s, colors.background)
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
