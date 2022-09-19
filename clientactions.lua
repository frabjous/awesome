
-- required packages (made global)
-- local awful = require("awful")

-- initialize return value
local _M = {}

_M.tables_overlap = function(aa, bb)
    for _, a in pairs(aa) do
        for _, b in pairs(bb) do
            if (a == b) then
                return true
            end
        end
    end
    return false
end

_M.is_tagged_on_screen = function(c,s)
    -- tags on screen
    local stt = s.selected_tags
    -- tags on client
    local ctt = c:tags()
    return _M.tables_overlap(stt,ctt)
end

_M.is_showing_on_screen = function(c, s)
    if (c.screen ~= s) then
        return false
    end
    if ((c.minimized) or (c.hidden)) then
        return false
    end
    return _M.is_tagged_on_screen(c, s)
end

_M.is_showing_current_screen = function(c)
    local s = awful.screen.focused()
    return _M.is_showing_on_screen(c,s)
end

_M.make_only_on_screen = function(c, s)

    -- make sure unminimized
    c.minimized = false

    -- bring it to selected tag on screen
    if not (_M.is_showing_on_screen(c,s)) then
        c:move_to_screen(s)
        c:move_to_tag(s.selected_tag)
        return
    end

    -- minimize everything else
    local numminimized = 0
    for _,t in pairs(s.selected_tags) do
        for _,o in pairs(t:clients()) do
            -- skip the client in question
            if (o ~= c) and not (o.sticky) and not (o.ontop) and
                not (o.skip_taskbar) then
                -- check if showing
                if (_M.is_showing_on_screen(o, s)) then
                    o.minimized = true
                    numminimized = numminimized + 1
                end
            end
        end
    end

    -- activate client
    c:emit_signal("request::activate", "tasklist", { raise = true } )
    return numminimized
end

_M.unminimize_all_peers = function(c)
    local s = c.screen
    for _, t in pairs(s.selected_tags) do
        for _, o in pairs(t:clients()) do
            o.minimized = false
        end
    end
end

_M.toggle_showing = function(c)
    -- if sticky or on top, then jump to it
    if ((c.sticky) or (c.ontop)) then
        if (c.minimized) then
            c.minimized = false
        end
        c:jump_to(false)
        return
    end

    -- if not showing on current screen, then add current tag
    -- and activate
    if not (_M.is_showing_current_screen(c)) then
        c:move_to_screen(awful.screen.focused())
        c:move_to_tag(awful.screen.focused().selected_tag)
        c.minimized = false
        c:emit_signal("request::activate", "tasklist", { raise = true })
        return
    end

    -- if minimized, then unminimize and activate
    if (c.minimized) then
        c.minimized = false
        c:emit_signal("request::activate", "tasklist", { raise = true })
        return
    end

    -- check if only visible thing on window
    local isonly = true
    local s = c.screen
    for _, o in pairs(s.all_clients) do
        if (
                (o ~= c) and
                (_M.is_showing_on_screen(o,s))
        ) then
            isonly = false
            break
        end
    end

    -- if only thing on screen then unminimize all peers
    if (isonly) then
        _M.unminimize_all_peers(c)
        return
    end

    -- showing but the only thing on screen => just minimize
    c.minimized = true
end

_M.smart_screen_next = function(c, inc)

    -- want it to take place on screen of client in question
    local s = c.screen
    -- get visible clients on that screen
    local vv = s:get_clients(false)
    -- do nothing if nothing is invisible
    if (#vv == 0) then
        return
    end
    -- if more than one is showing, go to next showing one
    if (#vv > 1) then
        -- find index of focused on
        local focused_index = 0
        local target_index  = 0
        for i, v in ipairs(vv) do
            if (v == client.focus) then
                focused_index = i
            end
            if (v == c) then
                target_index = i
            end
            -- both have been found, can break loop
            if (target_index > 0) and (focused_index > 0) then
                break
            end
        end
        -- use target if focus not found
        if (focused_index == 0) then focused_index = target_index end
        -- want to go to next one; notice if focused_index = 0,
        -- this will still give 1
        local next_index = focused_index + inc
        -- cycle around
        if (next_index > #vv) then
            next_index = 1
        end
        if (next_index < 1) then
            next_index = #vv
        end
        -- jump to that client
        vv[next_index]:jump_to(false)
        return
    end
    -- only one was found; let's also include minimized ones
    vv = s:get_all_clients(false)
    -- if still only one, do nothing
    if (#vv < 2) then
        return
    end
    -- find index in new list
    local focused_index = 0
    local target_index  = 0
    for i, v in ipairs(vv) do
        if (v == client.focus) then
            focused_index = i
        end
        if (v == c) then
            target_index = 0
        end
        -- both have been found, can break loop
        if (target_index > 0) and (focused_index > 0) then
            break
        end
    end
    -- use target if focus not found
    if (focused_index == 0) then focused_index = target_index end
    -- loop around until we find an appropriate one
    local search_index = focused_index + inc
    while (search_index ~= focused_index) do
        -- wrap around if need be
        if (search_index < 1) then
            search_index = #vv
        end
        if (search_index > #vv) then
            search_index = 1
        end
        local sc = vv[search_index]
        -- check if has right properties
        if (not (sc.hidden) and not (sc.skip_taskbar) and
            not (sc.below) and (sc.focusable) and (sc.valid) and
            (_M.is_tagged_on_screen(sc,s))) then
            -- if so, make it only focus, like previous one
            _M.make_only_on_screen(sc, s)
            return
        end
        -- increment!
        search_index = search_index + inc
    end
    -- shouldn't really be here, but fine to do nothing
end

_M.makeshape = function(shapename)
    c = _M.context_menu_target
    if not(c) then return end
    local shape = gears.shape[shapename]
    if (shape) then
        c.shape = shape
        c.isshaped = true
    end
end

_M.myshape = function(c, w, h)
    return gears.shape.partially_rounded_rect(
        c, w, h, true, false, true, false, 50
    )
end

_M.shapemenu = {
    { "rounded", function() _M.makeshape("rounded_rect") end },
    { "circle", function() _M.makeshape("circle") end },
    { "arrow", function() _M.makeshape("arrow") end },
    { "triangle", function() _M.makeshape("isosceles_triangle") end },
    { "hexagon", function() _M.makeshape("hexagon") end },
    { "octagon", function() _M.makeshape("octogon") end },
    { "parallelogram", function() _M.makeshape("parallelogram") end },
    { "diamond", function() _M.makeshape("losange") end },
    { "myshape", function()
            c = _M.context_menu_target
            if not(c) then return end
            c.shape = _M.myshape
            c.isshaped = true
        end
    }
}

_M.the_context_menu = awful.menu({ items = {
    { "(un)set show only", function()
        c = _M.context_menu_target
        if not(c) then return end
        local numminimized = 
            _M.make_only_on_screen(c,
                c.screen
            )
        if (numminimized == 0) then
            _M.unminimize_all_peers(c)
        end
    end },
    { "swap with master", function()
        c = _M.context_menu_target
        if (c) then _M.swap_with_master(c) end
    end },
    { "(un)minimize", function()
        if (_M.context_menu_target) then
            _M.context_menu_target.minimized = 
                not (_M.context_menu_target.minimized)
        end
    end },
    { "(un)maximize", function()
        if (_M.context_menu_target) then
            _M.context_menu_target.maximized =
                not (_M.context_menu_target.maximized)
        end
    end },
    { "(un)set floating", function()
        if (_M.context_menu_target) then
            _M.context_menu_target.floating =
                not (_M.context_menu_target.floating)
        end
    end },
    { "(un)set fullscreen", function()
        if (_M.context_menu_target) then
            _M.context_menu_target.fullscreen =
                not (_M.context_menu_target.fullscreen)
        end
    end },
    { "(un)set sticky", function()
        if (_M.context_menu_target) then
            _M.context_menu_target.sticky =
                not (_M.context_menu_target.sticky)
        end
    end },
    { "(un)set ontop", function()
        if (_M.context_menu_target) then
            _M.context_menu_target.ontop =
                not (_M.context_menu_target.ontop)
        end
    end },
    { "put on next screen", function()
        if (_M.context_menu_target) then
            _M.context_menu_target:move_to_screen()
        end
    end },
    { "make shape", _M.shapemenu },
    { "revert shape", function()
        c = _M.context_menu_target
        if (c) then
            c.shape = nil
        end
    end },
    { "close", function()
        if (_M.context_menu_target) then
            _M.context_menu_target:kill()
        end
    end },
    { "cancel", function() end }
}})


_M.context_menu = function(c)
    _M.context_menu_target = c
    _M.the_context_menu:toggle()
end

_M.swap_with_master = function(c)
    local m = awful.client.getmaster(c.screen)
    if (m ~= c) then
        c:swap(m)
    else
        awful.client.swap.byidx(1,c)
    end
end

return _M
