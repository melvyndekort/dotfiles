local awful = require("awful")
local naughty = require("naughty")
local gears = require("gears")
local wibox = require("wibox")
local colors = require("colors")

local mywidget = {}
local config_dir = gears.filesystem.get_configuration_dir()

local function worker(user_args)
  mywidget = wibox.widget {
    widget = wibox.container.background,
    {
      widget = wibox.container.place,
      valign = "center",
      {
        widget = wibox.widget.imagebox,
        image = config_dir .. "icons/disk.png",
        resize = true,
        forced_width = 27,
        forced_height = 27,
      },
    },
  }

  -- Function to get color based on value
  local function get_progress_color(value, max_value)
    local ratio = value / max_value
    if ratio < 0.7 then
        return "#4CAF50"
    elseif ratio < 0.9 then
        return "#FF9800"
    else
        return "#F44336"
    end
  end

  local function format_size(kb)
    if kb >= 1e9 then
        return string.format("%.1f TB", kb / 1e9)  -- TB
    elseif kb >= 1e6 then
        return string.format("%.1f GB", kb / 1e6)   -- GB
    elseif kb >= 1e3 then
        return string.format("%.1f MB", kb / 1e3)   -- MB
    else
        return string.format("%d KB", kb)           -- KB
    end
  end

  -- Function to create progress bars from the table
  local function create_progress_bars(data)
    local layout = wibox.layout.fixed.vertical()

    -- Add the title label
    local title_label = wibox.widget {
      text = "Disk usage",
      align = "center",
      valign = "center",
      font = "Hack Bold 14",
      widget = wibox.widget.textbox
    }

    -- Add the title label to the layout
    layout:add(title_label)

    for _, item in ipairs(data) do
        -- Label for the device
        local device_label = wibox.widget {
            text = item.label,
            widget = wibox.widget.textbox
        }

        -- Progress bar widget with dynamic color
        local progress_bar = wibox.widget {
            max_value = item.max_value,
            value = item.value,
            widget = wibox.widget.progressbar,
            forced_height = 20,
            forced_width = 200,
            color = get_progress_color(item.value, item.max_value),
            background_color = "#222222"
        }

        -- Overlay label showing "value / max_value" format in human-readable size
        local overlay_label = wibox.widget {
            text = string.format("%s / %s", format_size(item.value), format_size(item.max_value)),
            align = "center",
            valign = "center",
            widget = wibox.widget.textbox
        }

        -- Stack the progress bar and the overlay label
        local stacked_progress = wibox.widget {
            progress_bar,
            overlay_label,
            layout = wibox.layout.stack
        }

        -- Add device label and stacked progress bar to layout
        layout:add(wibox.container.margin(device_label, 0, 0, 5, 5))
        layout:add(wibox.container.margin(stacked_progress, 0, 0, 5, 10))
    end
    
    return layout
  end

  -- Create the popup with dynamically generated progress bars and overlay labels
  local progress_popup = awful.popup({
    widget = {
        margins = 15,
        widget = wibox.container.margin
    },
    ontop = true,
    visible = false, -- Start hidden
    shape = function(cr, width, height)
        gears.shape.rounded_rect(cr, width, height, 10)
    end,
    border_width = 2,
    border_color = "#444444",
    placement = awful.placement.centered, -- Center the popup on the screen
  })

  -- Function to retrieve disk usage data for block devices
  local function retrieve_block_device_data()
    local block_data = {}

    -- Run `df` command to get relevant information for specified filesystem types
    awful.spawn.easy_async_with_shell(
        "df -l -t ext2 -t ext3 -t ext4 -t xfs -t btrfs -t vfat -t ntfs --output=target,size,used | tail -n +2",
        function(stdout)
            -- Parse `df` output for mount point, size, and used space
            for line in stdout:gmatch("[^\r\n]+") do
                local target, size, used = line:match("(%S+)%s+(%S+)%s+(%S+)")
                
                if target and size and used then
                    size = tonumber(size)  -- Convert size to number (bytes)
                    used = tonumber(used)   -- Convert used space to number (bytes)

                    -- Add data for each device
                    table.insert(block_data, {
                        label = target,
                        value = used,
                        max_value = size
                    })
                end
            end
            
            -- Update the popup widget with the retrieved data
            progress_popup.widget:set_children{ create_progress_bars(block_data) }
        end
    )
  end

  mywidget:buttons(awful.util.table.join(awful.button({}, 1, function()
    if not progress_popup.visible then
      retrieve_block_device_data()
      gears.timer.start_new(10, function()
        progress_popup.visible = false
        return false -- Returning false ensures the timer runs only once
      end)
    end
    progress_popup.visible = not progress_popup.visible
  end)))

  progress_popup:connect_signal("button::press", function()
    progress_popup.visible = not progress_popup.visible
  end)

  return mywidget
end

return setmetatable(mywidget, {
  __call = function(_, ...)
    return worker(...)
  end,
})
