local awful = require("awful")

awful.layout.suit.fullscreen = {
    name = "fullscreen",
    arrange = function(p)
        -- Make all visible clients fullscreen
        for _, c in ipairs(p.clients) do
            c:geometry(p.workarea) -- Set client to use the entire workarea
            c.fullscreen = true   -- Enable fullscreen mode
        end
    end,
    skip_gap = true, -- Ignore gaps if you have gaps configured
}

-- Reset fullscreen state on layout change
tag.connect_signal("property::layout", function(t)
    if t.layout ~= awful.layout.suit.fullscreen then
        -- Disable fullscreen for all clients on this tag
        for _, c in ipairs(t:clients()) do
            c.fullscreen = false
        end
    end
end)
