--Requirements (made global):
--local awful     = require("awful")
--local beautiful = require("beautiful")
--local gears     = require("gears")
--local wibox     = require("wibox")

local ll = awful.widget.layoutlist({
    base_layout = wibox.widget {
        spacing         = 0,
        forced_num_cols = 4,
        layout          = wibox.layout.grid.vertical
    },
    widget_template = {
        {
            {
                id            = 'icon_role',
                forced_height = 64,
                forced_width  = 48,
                widget        = wibox.widget.imagebox,
            },
            top = 10,
            left = 10,
            bottom = 10,
            right = 10,
            widget  = wibox.container.margin,
        },
        id              = 'background_role',
        forced_height   = 80,
        forced_width    = 80,
        shape           = gears.shape.rounded_rect,
        widget          = wibox.container.background
    }
})

awful.screen.connect_for_each_screen(function(s)
    s.layout_popup = awful.popup({
        widget = wibox.widget {
            ll,
            margins = 4,
            widget  = wibox.container.margin,
        },
        border_color = beautiful.border_color,
        border_width = beautiful.border_width,
        placement    = awful.placement.centered,
        screen       = s,
        ontop        = true,
        visible      = false,
        shape        = gears.shape.rounded_rect
    })
end)

layout_popup_timer = gears.timer({
    timeout = 2,
    callback = function()
        awful.screen.connect_for_each_screen(function(s)
            s.layout_popup.visible = false
        end)
    end
})

_G.awful_layout_change = function (n)
    awful.screen.focused().layout_popup.visible = true
    awful.layout.inc(n)
    if (layout_popup_timer.start) then
        layout_popup_timer:stop()
        layout_popup_timer:again()
    else
        layout_popup_timer:start()
    end
end

