--Requirements (made global):
--local awful         = require("awful")
--local beautiful     = require("beautiful")
--local clientactions = require("clientactions")
--local gears         = require("gears")
--local myicon        = require("myicon")
--local wibox         = require("wibox")

-- initialize return
local _M = {}

_M.taskbuttons = gears.table.join(
    awful.button({}, 1, function(c)
        c:jump_to(false)
    end)
)

function update_switcher_item(widg, c, index, cc)
    local icon = myicon(c.name, c.class)
    widg:get_children_by_id("myicon")[1].markup =
        '<span foreground="' .. beautiful.icon_color .. '"> ' ..
        icon .. '</span>'
    local cname = c.name
    if (cname == '~') then cname = '~ kitty' end
    cname = gears.string.xml_escape(cname)
    local namecolor = beautiful.fg_normal
    local bordercolor = beautiful.switcher_bg
    if (c == client.focus) then
        namecolor = beautiful.switcher_fg_focus
        bordercolor = beautiful.switcher_item_focus_border
    end
    widg:get_children_by_id("namebox")[1].markup = '<span foreground="'
        .. namecolor .. '">' .. cname .. '</span>'
    widg:get_children_by_id("myitemmargin")[1].color = bordercolor
end

function init_switcher_item(widg, c, index, cc)
    update_switcher_item(widg, c, index, cc)
end

_M.switcher = awful.popup ({
    widget = awful.widget.tasklist({
        screen   = screen[1],
        filter   = awful.widget.tasklist.filter.allscreen,
        buttons  = _M.taskbuttons,
        style    = {
            shape = gears.shape.rounded_rect,
        },
        layout = {
            spacing = 2,
            layout = wibox.layout.fixed.vertical
        },
        widget_template = {
            {-- margin container
                { -- horizontal layout
                    { -- icon text box
                        id            = 'myicon',
                        widget        = wibox.widget.textbox,
                        forced_width  = 45,
                        valign        = "center",
                        align         = "center",
                        markup        = " ",
                        font          = "Symbols Nerd Font 25"
                    },
                    {
                        { -- name text box
                            id            = "namebox",
                            widget        = wibox.widget.textbox,
                            align         = "left",
                            valign        = "center",
                            markup        = "placeholder",
                            font          = beautiful.switcher_font
                        },
                        widget = wibox.container.margin,
                        right = 6,
                        top = 6,
                        bottom = 10,
                        left = 0
                    },
                    spacing = 4,
                    layout = wibox.layout.fixed.horizontal
                },
                margins = 4,
                id      = "myitemmargin",
                widget  = wibox.container.margin,
                color   = beautiful.switcher_bg
            },
            id              = 'mybackground',
            widget          = wibox.container.background,
            color           = beautiful.bg_normal,
            create_callback = init_switcher_item,
            update_callback = update_switcher_item
        },
    }),
    border_color = beautiful.switcher_border_color,
    border_width = 4,
    ontop        = true,
    visible      = false,
    placement    = awful.placement.centered,
    shape        = gears.shape.rounded_rect
})

_M.timer = gears.timer({
    timeout = 2,
    callback = function()
        _M.switcher.visible = false
    end
})

function badtarget(targ)
    return ((targ.hidden) or (targ.skip_taskbar) or not (targ.focusable)
        or not (targ.valid))
end

_M.tabexplore = function(inc)
    -- go through all clients, build list
    -- and find current one
    local allclients = {}
    local i = 0
    local focused_index = 0
    local msg = ''
    for c in awful.client.iterate(
            awful.widget.tasklist.filter.allscreen
        ) do
        if (not(badtarget(c))) then
            i = i + 1
            if (c == client.focus) then
                focused_index = i
            end
            table.insert(allclients, c)
        end
    end
    --local allclients = client.get(nil,false)

    -- if no clients, do nothing
    if (#allclients == 0) then
        return
    end

    -- open switch tasklist
    if (not(_M.switcher.visible)) then
        -- count open windows to restore number maybe
        for s in screen do
            s.preswitchclientnum = #s.clients
        end
        _M.switcher.screen = awful.screen.focused()
        _M.switcher.visible = true
    end

    -- adjust, or if not found, choose the first one
    local target_index = 0
    if (focused_index == 0) then
        target_index = 1
    else
        target_index = focused_index + inc
    end
    -- adjust position
    -- wrap around
    if (target_index > #allclients) then
        target_index = target_index - #allclients
    end
    local targ
    if (target_index < 1) then
        target_index = target_index + #allclients
    end
    -- get target
    targ = allclients[target_index]
    if not(targ) then return end
    -- jump to that target
    targ:jump_to(false)
    targ:emit_signal("request::activate", "client_switcher",
        { raise = true })
    if (targ.screen.preswitchclientnum == 1) then
        clientactions.make_only_on_screen(targ, targ.screen)
    end

    -- restart disappearing timer
    if (_M.timer.start) then
        _M.timer:stop()
        _M.timer:again()
    else
        _M.timer:start()
    end
end

return _M
