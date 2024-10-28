local gears = require("gears")
local awful = require("awful")
local colors = require("colors")

-- Directory containing your wallpapers
local wallpaper_dir = "/home/melvyn/Sync/pictures/wallpapers/"

-- Function to get a list of files in the directory
local function get_wallpaper_files(dir)
  local files = {}
  local p = io.popen('ls "' .. dir .. '"')
  for file in p:lines() do
      table.insert(files, file)
  end
  p:close()
  return files
end

-- Function to set a random wallpaper (centered)
function set_random_wallpaper(s)
  -- Get list of all files in the wallpaper directory
  local files = get_wallpaper_files(wallpaper_dir)
  -- Select a random file
  local wallpaper = wallpaper_dir .. files[math.random(#files)]
  -- Set the wallpaper for the screen as centered
  gears.wallpaper.centered(wallpaper, s, colors.background)
end

-- Apply the wallpaper when Awesome starts or when screen geometry changes
screen.connect_signal("property::geometry", set_random_wallpaper)
awful.screen.connect_for_each_screen(set_random_wallpaper)

-- Timer to change the wallpaper every 60 seconds
local wallpaper_timer = gears.timer({
    timeout = 60,  -- Time in seconds
    autostart = true,
    call_now = true,
    callback = function()
        awful.screen.connect_for_each_screen(set_random_wallpaper)
    end,
})
