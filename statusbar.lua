--required packages
--local awful         = require("layouts")
--local beautiful     = require("beautiful")
--local clientactions = require("clientactions")
--local lain          = require("lain")
--local gears         = require("gears")
--local myicon        = require("myicon")
--local wibox         = require("wibox")

-- layoutlist only used here?
local ll = require("layoutlist")

-- initialize return object
local _M = {}

-- Buttons for Taglist
taglist_buttons = gears.table.join(
    -- left click views only a tag clicked on
    awful.button({ }, 1, function(t) t:view_only() end),
    -- super-left click movies focuses client there
    awful.button({ RC.vars.modkey }, 1, function(t)
        if client.focus then
            client.focus:move_to_tag(t)
        end
    end),
    -- right click toggles whether tag is shown
    awful.button({}, 3, awful.tag.viewtoggle),
    -- super right click toggles whether focuses window has tag
    awful.button({ RC.vars.modkey }, 3, function(t)
        if client.focus then
            client.focus:toggle_tag(t)
        end
    end),
    -- wheel down views next tag
    awful.button({}, 5, function(t) awful.tag.viewnext(t.screen) end),
    -- wheel up views previous tag
    awful.button({}, 4, function(t) awful.tag.viewprev(t.screen) end)
)

-- Buttons for tasklist *** highly specialized now?
tasklist_buttons = gears.table.join(
    -- right click toggles whether window is showing
    awful.button({}, 3, function (c)
        -- toggle whether showing
        clientactions.toggle_showing(c)
    end),
    -- right click focuses exclusively
    awful.button({}, 1, function(c)
        -- OLD BEHAVIOR: mini menu
        -- awful.menu.client_list({ theme = { width = 250 } })
        -- new behavior: make it the only active window on screen
        local numminimized = clientactions.make_only_on_screen(
            c, awful.screen.focused()
        )
    end),
    -- wheel up focuses previous client in tasklist, smartly
    awful.button({}, 4, function(c)
        clientactions.smart_screen_next(c, -1)
    end),
    -- wheel down focuses next client in tasklist, smartly
    awful.button({ }, 5, function(c)
        clientactions.smart_screen_next(c, 1)
    end),
    -- super wheel up swaps with previous client
    awful.button({ RC.vars.modkey }, 4, function(c)
        awful.client.swap.byidx(-1,c)
    end),
    -- super wheel down swaps with next client
    awful.button({ RC.vars.modkey }, 5, function(c)
        awful.client.swap.byidx(1,c)
    end),
    -- middle click or super or shift right click gives context menu
    awful.button({}, 2, function(c)
        clientactions.context_menu(c)
    end),
    awful.button({ RC.vars.modkey }, 3, function(c)
        clientactions.context_menu(c)
    end),
    awful.button({ "Shift" }, 3, function(c)
        clientactions.context_menu(c)
    end)
)

-- MUSIC PLAYER DAEMON WIDGET
local mpd = lain.widget.mpd({
    timeout = 5,
    music_dir = os.getenv("HOME") .. "/music",
    followtag = true,
    settings = function()
        local icon=""
        if (mpd_now.state == "play") then
            icon=""
        end
        local m = '<span font_family="Symbols Nerd Font" font_size="12pt"'
            .. ' foreground="' .. beautiful.icon_color .. '">' .. icon ..
            '</span>'
        if (mpd_now.artist) and (widget.artistw) then
            local add = ''
            if (mpd_now.random_mode) then
                add = add .. ''
            end
            if (mpd_now.consume_mode) then
                add = add .. ''
            end
            if (mpd_now.repeat_mode) then
                add = add .. ''
            end
            if (add ~= '') then
                add = '<span font_family="Symbols Nerd Font">' .. add
                    .. '</span>'
            end
            widget.artistw:set_markup('<span foreground="' ..
                beautiful.info_color .. '">' .. mpd_now.artist ..
                '</span> — ' .. add)
        end
        if (mpd_now.title) and (widget.titlew) then
            widget.titlew:set_markup('<span font_style="italic">' ..
                mpd_now.title .. '</span>')
        end
        widget:set_markup(m)
    end
})

-- put in return val as well
_M.mpd = mpd

mpd.widget:buttons(awful.util.table.join(
    awful.button({}, 1, function() -- left click = play/pause
        awful.spawn.easy_async_with_shell("mpc toggle",
        function(stdout, stderr, reason, exit_code)
            mpd.update()
        end)
    end),
    awful.button({}, 3, function()  -- right click
        RC.statusbar.mpdtogglemenu:toggle()
    end),
    awful.button({}, 2, function() -- middle click
        awful.spawn("wezterm start --class info_term -- currentlyrics.sh")
    end),
    awful.button({}, 4, function() -- scroll up
        awful.spawn.easy_async("mpc prev",
        function()
            mpd.update()
        end)
    end),
    awful.button({}, 5, function() -- scroll down
        awful.spawn.easy_async("mpc next",
        function()
            mpd.update()
        end)
    end)
))

-- mpd info widget
mpd.widget.artistw = wibox.widget({
    widget = wibox.widget.textbox,
    markup = 'artist',
    font = "Oswald 8"
})

mpd.widget.titlew = wibox.widget({
    widget = wibox.widget.textbox,
    markup = 'title',
    font = "Oswald 8"
})

mpd.widget.infow = wibox.widget({
    mpd.widget.artistw,
    mpd.widget.titlew,
    font = "Oswald 8",
    spacing = -4,
    layout = wibox.layout.fixed.vertical
})

mpd.widget.infow:buttons(awful.util.table.join(
    awful.button({}, 1, function() -- left click = play/pause
        awful.spawn.easy_async("mpc toggle",
        function()
            mpd.update()
        end)
    end),
    awful.button({}, 2, function() -- middle click
        awful.spawn("wezterm start --class info_term -- currentlyrics.sh")
    end),
    awful.button({}, 3, function()  -- right click
        RC.statusbar.mpdtogglemenu:toggle()
    end),
    awful.button({}, 4, function() -- scroll up
        awful.spawn.easy_async("mpc prev",
        function()
            mpd.update()
        end)
    end),
    awful.button({}, 5, function() -- scroll down
        awful.spawn.easy_async("mpc next",
        function()
            mpd.update()
        end)
    end)
))

-- tooltip
mpd.widget.tooltip = awful.tooltip({
    objects = { mpd.widget, mpd.widget.infow },
    text = 'play/pause mpd'
})

-- MEMORY USAGE INDICATOR

-- MPD toggler menu

function run_n_update(cmd)
    awful.spawn.easy_async(cmd, function() mpd.update() end)
end

_M.mpdtogglemenu = awful.menu({ items = {
    { "play/pause",  function() run_n_update("mpc toggle")      end },
    { "random on",   function() run_n_update("mpc random on")   end },
    { "random off",  function() run_n_update("mpc random off")  end },
    { "consume on",  function() run_n_update("mpc consume on")  end },
    { "consume off", function() run_n_update("mpc consume off") end },
    { "repeat on",   function() run_n_update("mpc repeat on")   end },
    { "repeat off",  function() run_n_update("mpc repeat off")  end },
    { "clear queue", function() run_n_update("mpc clear")       end },
    { "show lyrics", "wezterm start --class info_term -- " ..
        "currentlyrics.sh" },
    { "browse music", "wezterm start --class music_browse -- " ..
        "musicbrowse.sh" },
    { "media player page", RC.vars.browser ..
        " --app=" ..
        --" --target window -C " .. os.getenv("HOME") ..
        --"/misc/dotfiles/qutebrowser/config-noui.py --basedir " ..
        --os.getenv("HOME") .. "/.cache/altqute " ..
        --" --new-window --profile " ..
        -- os.getenv("HOME") .. "/.mozilla/firefox/hiddenui " ..
        "http://localhost:7306/" }
}})

local spacey = wibox.widget({
    text = ' ',
    widget = wibox.widget.textbox
})


-- DISK USAGE INDICATOR
local disk = lain.widget.fs({
    timeout = 10,
    showpopup = "off",
    settings = function()
        local path = "/"
        if (fs_now["/home"]) then
            path = "/home"
        end
        fsn=fs_now[path]
        local usage = tonumber(fsn.percentage)
        local iconcolor = beautiful.icon_color
        local textcolor = beautiful.fg_normal
        if (usage >= 90) then
            iconcolor = beautiful.fg_alert
            textcolor = beautiful.fg_alert
        end
        widget:set_markup('<span font_family="Symbols Nerd Font" ' ..
            'font_size="14pt" foreground="' .. iconcolor .. '">' ..
            '</span><span foreground="' .. textcolor .. '">' ..
            tostring(usage) .. '%</span>')
        tt = path .. ': ' .. string.format('%.3f', fsn.used) .. '/' ..
            string.format('%.3f', fsn.size) .. fsn.units .. ' used'
        if (path ~= '/') then
            fsn=fs_now['/']
            tt = tt .. '/: ' .. string.format('%.3f', fsn.used) .. '/' ..
                string.format('%.3f', fsn.size) .. fsn.units .. ' used'
        end
        if (widget.tooltip) then
            widget.tooltip.text = tt
        end
    end
})

disk.widget.tooltip = awful.tooltip({
    objects = { disk.widget },
    text = 'Disk usage'
})

-- MEMORY USAGE INDICATOR
local mem = lain.widget.mem({
    settings = function()
        local usage = tonumber(mem_now.perc)
        local iconcolor = beautiful.icon_color
        local textcolor = beautiful.fg_normal
        if (usage >= 90) then
            iconcolor = beautiful.fg_alert
            textcolor = beautiful.fg_alert
        end
        widget:set_markup('<span font_family="Symbols Nerd Font" ' ..
            'font_size="12pt" foreground="' .. iconcolor .. '">' ..
            '</span><span foreground="' .. textcolor .. '">' ..
            tostring(usage) .. '%</span>')
        tt = 'Used: ' .. tostring(mem_now.used) .. ' MiB\n' ..
            'Swap Used: ' .. tostring(mem_now.swapused) .. ' MiB'
        if (widget.tooltip) then
            widget.tooltip.text = tt
        end
    end,
    timeout = 5
})

mem.widget.tooltip = awful.tooltip({
    objects = { mem.widget },
    text = 'RAM usage'
})


-- CPU USAGE INDICATOR
local cpu = lain.widget.cpu({
    settings = function()
        local usage = tonumber(cpu_now.usage)
        local iconcolor = beautiful.icon_color
        local textcolor = beautiful.fg_normal
        if (usage >= 90) then
            iconcolor = beautiful.fg_alert
            textcolor = beautiful.fg_alert
        end
        widget:set_markup('<span font_family="Symbols Nerd Font" ' ..
            'font_size="16pt" foreground="' .. iconcolor .. '">' ..
            '</span><span foreground="' .. textcolor .. '">' ..
            tostring(usage) .. '%</span>')
        local core = 1
        local tt = ''
        local neednewline = false
        while (cpu_now[core]) do
            if (neednewline) then
                tt = tt .. '\n'
            end
            tt = tt .. 'Core ' .. tostring(core) .. ': ' ..
                tostring(cpu_now[core].usage) .. '%'
            neednewline = true
            core = core + 1
        end
        if (widget.tooltip) then
            widget.tooltip.text = tt
        end
    end,
    timeout = 5
})

cpu.widget.tooltip = awful.tooltip({
    objects = { cpu.widget },
    text = 'cpu usage'
})

function volToHex(vol)
    local rlow = 68-- to 222
    local glow = 70-- to 227
    local blow = 74-- to 232
    local r = math.floor(rlow + ( (vol/100) * 154 ))
    local g = math.floor(glow + ( (vol/100) * 157 ))
    local b = math.floor(blow + ( (vol/100) * 158 ))
    if (r > 255) then r = 255 end
    if (g > 255) then g = 255 end
    if (b > 255) then b = 255 end
    return '#' .. string.format('%x',r) .. string.format('%x',g)
        .. string.format('%x',b)
end

-- PULSEAUDIO VOLUME CONTROL ICON
_M.volume = lain.widget.pulse({
    settings = function()
        local icon
        local color
        local newmarkup
        if (volume_now.muted == "yes") then
            icon = ''
            color = beautiful.fg_alert
            newmarkup = '<span foreground="' .. color ..
                '"><span font_family="Symbols Nerd Font" ' ..
                'font_size="12pt"></span> mute</span>'
        else
            local vol = tonumber(volume_now.left) or 0
            if (vol < 0) then vol = 0 end
            icon = ''
            color = volToHex(vol)
            if (vol > 20) and (vol <= 60) then
                icon = ''
            end
            if (vol > 60) then
                icon = ' '
            end
            newmarkup = '<span foreground="' .. beautiful.icon_color
                .. '" font_family="Symbols Nerd Font"  font_size="15pt">'
                .. icon .. '</span><span foreground="' ..
                color .. '">' .. tostring(vol) .. '%</span>'
        end
        widget:set_markup(newmarkup)
    end
})

_M.volume.widget:buttons(awful.util.table.join(
    awful.button({}, 1, function() -- left click
        awful.spawn("pavucontrol")
    end),
    awful.button({}, 3, function() -- right click
        awful.spawn.easy_async_with_shell("pactl set-sink-mute " ..
            "@DEFAULT_SINK@ toggle", function()
            RC.statusbar.volume.update()
        end)
    end),
    awful.button({}, 4, function() -- scroll up
        awful.spawn.easy_async_with_shell(
            "sh -c 'pactl set-sink-mute @DEFAULT_SINK@ 0 && pactl " ..
                "set-sink-volume @DEFAULT_SINK@ +4%'",
            function()
                RC.statusbar.volume.update()
            end
        )
    end),
    awful.button({}, 5, function() -- scroll down
        awful.spawn.easy_async_with_shell(
            "sh -c 'pactl set-sink-mute @DEFAULT_SINK@ 0 && pactl " ..
                "set-sink-volume @DEFAULT_SINK@ -4%'",
            function()
                RC.statusbar.volume.update()
            end
        )
    end)
))

_M.volume.widget.tooltip = awful.tooltip({
    objects = { _M.volume.widget },
    text = 'pulseuadio volume'
})

local netw, netwtimer = awful.widget.watch(
    os.getenv("HOME") .. '/bin/netstate-awesome.sh "' ..
        beautiful.icon_color .. '" "' .. beautiful.fg_alert .. '"',
    5,
    function(widget, stdout, stderr, exitrason, exitcode)
        if (exitcode == 0) then
            stdout = stdout:gsub('\n','')
            widget:set_markup_silently(stdout)
        else
            widget:set_markup_silently(
                ' <span foreground="' .. beautiful.fg_alert ..
                    '">' .. exitreason .. '</span> '
            )
        end
    end
)

-- give it a tooltip
netw.tooltip = awful.tooltip({
    objects = { netw },
    text = 'network status and bandwidth'
})

-- update on mouse enter
netw:connect_signal("mouse::enter", function()
    netwtimer:emit_signal("timeout")
end)


local updatestatus, updstatustimer = awful.widget.watch(
    os.getenv("HOME") .. '/bin/kronstatus.sh',
    --os.getenv("HOME") .. '/bin/update-status.php awesome',
    30,
    function(widget, stdout, stderr, exitreason, exitcode)
        if (exitcode == 0) then
            -- strip off newline added somehow
            stdout = stdout:gsub('\n','')
            local nscolor = beautiful.all_ok
            if (stdout == '') then
                nscolor = beautiful.fg_alert
                if (widget.tooltip) then
                    widget.tooltip.text = 'update error!'
                end
            elseif (stdout == '') then
                nscolor = beautiful.info_color
                if (widget.tooltip) then
                    widget.tooltip.text = 'update postponed'
                end
            else
                if (widget.tooltip) then
                    widget.tooltip.text = 'update status ok'
                end
            end
            widget:set_markup_silently(
                ' <span font_family="Symbols Nerd Font" ' ..
                'font_size="14pt" ' .. 'foreground="' .. nscolor
                .. '">' .. stdout .. '</span> '
            )
        else
            widget:set_markup_silently(
            ' <span foreground="' .. beautiful.fg_alert ..
                '">' .. exitreason .. '</span> '
            )
        end
    end
)
-- give it a tooltip
updatestatus.tooltip = awful.tooltip({
    objects = { updatestatus },
    text = 'update status'
})
-- make it clickable
updatestatus:buttons(gears.table.join(
    updatestatus:buttons(),
    awful.button({}, 1, nil, function()
        awful.spawn(RC.vars.terminal .. ' start --class info_term '
        --.. '-- updstatusdelay.sh'
        .. '-- kronjob.sh statushold'
        )
    end)
))
-- update on mouse enter
updatestatus:connect_signal("mouse::enter", function()
    updstatustimer:emit_signal("timeout")
end)

_M.updateupdateicon = function()
    updstatustimer:emit_signal("timeout")
end

-- MUSIC BROWSE launcher

local musicbrowsew = wibox.widget({
    markup = '<span foreground="' .. beautiful.icon_color ..
        '" font_family="Symbols Nerd Font" font_size="13pt"></span>',
    align = 'center',
    valign = 'center',
    widget = wibox.widget.textbox
})

-- give it a tooltip
musicbrowsew.tooltip = awful.tooltip({
    objects = { musicbrowsew },
    text = 'browse music'
})

-- make it clickable
musicbrowsew:buttons(gears.table.join(
    musicbrowsew:buttons(),
    awful.button({}, 1, nil, function() -- left click for music browsing
        awful.spawn(
            'wezterm start --class music_browse -- musicbrowse.sh'
        )
    end),
    awful.button({}, 3, nil, function() -- right click for browser
        awful.spawn(
            RC.vars.browser ..
                ' -app=' ..
                --' --target window -C ' .. os.getenv("HOME") ..
                --'/misc/dotfiles/qutebrowser/config-noui.py ' ..
                --'--basedir ' .. os.getenv("HOME") .. '/.cache/altqute ' ..
                --' --new-window --profile ' ..
                --os.getenv("HOME") .. '/.mozilla/firefox/hiddenui ' ..
                'http://localhost:7306/'
        )
    end)
))


-- CLIPBOARD launcher

local clipboardw = wibox.widget({
    markup = '<span foreground="' .. beautiful.clipboard_icon ..
        '" font_family="Symbols Nerd Font" font_size="14pt"></span>',
    align = 'center',
    valign = 'center',
    widget = wibox.widget.textbox
})

-- give it a tooltip
clipboardw.tooltip = awful.tooltip({
    objects = { clipboardw },
    text = 'clipboard history (left click)\nsnippets (right click)'
})

-- make it clickable
clipboardw:buttons(gears.table.join(
    clipboardw:buttons(),
    awful.button({}, 1, nil, function() -- left click for history
        awful.spawn('clipmenu')
    end),
    awful.button({}, 3, nil, function() -- right click for snippets
        awful.spawn('snippets.sh')
    end)
))

-- Quake Terminal Toggler

local quakew = wibox.widget({
    markup = '<span foreground="' .. beautiful.dropdown_icon ..
        '" font_family="Symbols Nerd Font" font_size="14pt"></span>',
    align = 'center',
    valign = 'center',
    widget = wibox.widget.textbox
})

-- give it a tooltip
quakew.tooltip = awful.tooltip({
    objects = { quakew },
    text = 'toggle dropdown terminal'
})

-- make it clickable
quakew:buttons(gears.table.join(
    quakew:buttons(),
    awful.button({}, 1, nil, function()
        RC.dropdowns.quake:toggle()
    end),
    awful.button({}, 4, nil, function()
        RC.dropdowns.quake:toggle()
    end),
    awful.button({}, 5, nil, function()
        RC.dropdowns.quake:toggle()
    end)
))

-- scratchpad toggler
local scratchw = wibox.widget({
    markup = '<span foreground="' .. beautiful.dropdown_icon ..
        '" font_family="Symbols Nerd Font" font_size="14pt"></span>',
    align = 'center',
    valign = 'center',
    widget = wibox.widget.textbox
})

-- give it a tooltip
scratchw.tooltip = awful.tooltip({
    objects = { scratchw },
    text = 'toggle scratchpad'
})

-- make it clickable
scratchw:buttons(gears.table.join(
    scratchw:buttons(),
    awful.button({}, 1, nil, function() -- left click for history
        RC.dropdowns.scratch:toggle()
    end),
    awful.button({}, 4, nil, function() -- left click for history
        RC.dropdowns.scratch:toggle()
    end),
    awful.button({}, 5, nil, function() -- left click for history
        RC.dropdowns.scratch:toggle()
    end)
))

-- QUIT Launcher

local icon_loc = "/usr/share/icons/" .. beautiful.icon_theme .. "/24x24/"
local quitmenu = awful.menu({
    items = {
        { "suspend", "sudo sh -c '[[ $(uname -r) =~ gentoo ]] && loginctl suspend || systemctl suspend'",
            icon_loc .. "panel/night-light-symbolic.svg"  },
        { "poweroff", "sudo sh -c '[[ $(uname -r) =~ gentoo ]] && openrc-shutdown --poweroff now ||  poweroff'",
            icon_loc .. "actions/system-shutdown-symbolic.svg" },
        { "reboot", "sudo sh -c '[[ $(uname -r) =~ gentoo ]] && openrc-shutdown --reboot now || reboot'",
            icon_loc .. "actions/vm-restart.svg" },
        { "quit awesome",
            function() awesome.quit() end, icon_loc .. "actions/exit.svg" },
        { "restart awesome",
            awesome.restart, icon_loc .. "actions/media-repeat-all.svg" },
        { "cancel", function() end, icon_loc .. "actions/cancel.svg" }
    },
    theme = {
        width = 200,
        height = 28,
        font = "Oswald 16"
    }
})

local quitlauncher = awful.widget.launcher({
    image = os.getenv("HOME") .. "/.config/awesome/icons/shutdown.png",
    menu = quitmenu,
    resize = false
})

-- give it a tooltip
quitlauncher.tooltip = awful.tooltip({
    objects = { quitlauncher },
    text = 'shutdown, reboot or quit'
})
-- make it clickable

-- left pointing powerline arrow shape
function lpwline(cr, w, h)
    return gears.shape.powerline(cr, w*1.2, h, -0.3*h)
end

-- left powerline separator
local arleft = wibox.widget {
    widget = wibox.widget.separator,
    shape = lpwline,
    color = beautiful.separator_color,
    forced_width = 10,
    border_color = beautiful.separator_accent,
    border_width = 0.1,
    thickness = 1
}

-- right powerline separator
function rpwline(cr, w, h)
    return gears.shape.transform(gears.shape.powerline) :
        translate (-3, 0) (cr, w*1.2, h, 0.3*h)
end


local arright = wibox.widget {
    align = "center",
    widget = wibox.widget.separator,
    shape = rpwline,
    color = beautiful.separator_color,
    forced_width = 10,
    border_color = beautiful.separator_accent,
    border_width = 0.1,
    thickness = 1
}

-- taglist tag update function
function update_taglist_tag(widg, t, index, tt)
    local tagbg = widg:get_children_by_id("background_shape")[1]
    if (tagbg) then
        local selected = t.selected
        if (selected) then
            tagbg.shape_border_color =
                beautiful.taglist_shape_border_focus
        else
            tagbg.shape_border_color = beautiful.taglist_shape_border
        end
    end
    local occupied = false
    for _,c in pairs(t:clients()) do
        if not (c.skip_taskbar) then
            occupied = true
            break
        end
    end
    local indexcolor = beautiful.taglist_index_empty
    if (occupied) then
        indexcolor = beautiful.taglist_index_occupied
    end
    widg:get_children_by_id("index_role")[1].markup =
        '<span foreground="' .. indexcolor .. '"><b>' ..
            index .. '</b></span>'
    if (widg.tooltip) then
        local ttt = ''
        local needlb = false
        for _, cl in ipairs(t:clients()) do
            if not (cl.hidden) and (cl.name) and
                not (cl.skip_taskbar) and (cl.valid) then
                if (needlb) then
                    ttt = ttt .. '\n'
                end
                ttt = ttt .. cl.name
                needlb = true
            end
        end
        if (ttt == '') then
            widg.tooltip.text = "view tag " .. tostring(index) ..
            " (empty)"
        else
            widg.tooltip.text = ttt
        end
    end
end

function fixwname(cname)
    if (cname == '~') then cname = '~ kitty' end
    if (cname == 'wezterm ~') then cname = '~ wezterm' end
    if (cname:match('^wezterm ')) then cname = cname:sub(9) end
    cname = cname:gsub('$EDITOR',os.getenv('EDITOR'))
    cname = cname:gsub('—starter$','')
    return cname
end

-- tasklist widgets set up function
function init_tasklist_widget(widg, c, index, cc)
    update_tasklist_widget(widg, c, index, cc)
    -- change color when hovering
    widg:connect_signal('mouse::enter', function()
        if (widg.has_backup) then
            widg.bg = beautiful.tasklist_bg_hover
            local ics = widg:get_children_by_id("icon_symbol")[1]
            ics.markup = '<span foreground="' .. 
                beautiful.tasklist_icon_hover .. '">' .. 
                widg.backupicon .. ' </span>'
            local cn = widg:get_children_by_id("client_name")[1]
            cn.markup = '<span foreground="' .. 
                beautiful.tasklist_text_hover  .. '">' .. widg.backuptext ..
                '</span>'
        end
    end)
    widg:connect_signal('mouse::leave', function()
        update_tasklist_widget(widg, c, 1, {})
        if (widg.has_backup) then
            widg.bg = widg.backup
        end
    end)
end

-- tasklist items update function
function update_tasklist_widget(widg, c, index, cc)
    if not (c.valid) then return end
    if (((c.name:match('Outlook.*—starter')) or
        (c.name:match('YouTube.*—starter'))) and
        not (c.screen == RC.startscreen)) then
        c.screen = RC.startscreen
    end
    local iconcolor = beautiful.icon_color
    local bgcolor = beautiful.tasklist_bg_normal
    if (c.minimized) then
        iconcolor = beautiful.tasklist_icon_color_minimize
        bgcolor = beautiful.tasklist_bg_minimize
    end
    local icon = myicon(c.name, c.class)
    local ics = widg:get_children_by_id("icon_symbol")[1]
    ics.markup = '<span foreground="' .. iconcolor .. '">' .. icon ..
        ' </span>'
    local cn = widg:get_children_by_id("client_name")[1]
    local namecolor = beautiful.tasklist_fg_normal
    if (c.urgent) then
        namecolor = beautiful.tasklist_fg_urgent
        bgcolor = beautiful.tasklist_bg_urgent
    elseif (c == client.focus) then
        namecolor = beautiful.tasklist_fg_focus
        bgcolor = beautiful.tasklist_bg_focus
    elseif (c.minimized) then
        namecolor = beautiful.tasklist_fg_minimize
        bgcolor = beautiful.tasklist_bg_minimize
    end
    local cname = c.name
    cname = gears.string.xml_escape(fixwname(cname))
    cn.markup = '<span foreground="' .. namecolor .. '">' .. cname
        .. '</span>'
    -- little additions for special windows
    local infoadd = widg:get_children_by_id("info_add")[1]
    local addition = ''
    if (c.sticky) then
        addition = addition .. ' '
    end
    if (c.floating) then
        addition = addition .. ' '
    end
    if (c.ontop) then
        addition = addition .. ' '
    end
    if (c.maximized) or (c.maximized_horizontal) or (c.maximized_vertical) then
        addition = addition .. ' '
    end
    if (addition == '') then
        infoadd.markup = ''
    else
        infoadd.markup = '<span foreground="' .. 
            beautiful.tasklist_extra_info .. '">' .. addition .. '</span>'
    end
    -- save background color!
    widg.bg = bgcolor
    if (widg.bg) and (widg.bg ~= beautiful.tasklist_bg_hover) then
        widg.backup = widg.bg
        widg.backupicon = icon
        widg.backuptext = cname
        widg.has_backup = true
    end
end

local bg = wibox.container.background()
bg:set_bg("#ff0000")

local tb1 = wibox.widget.textbox()
local tb2 = wibox.widget.textbox("bar")

tb1:set_text("foo")
tb2:set_text("bar")

local l = wibox.layout.fixed.vertical()
l:add(tb1)
l:add(tb2)

bg:set_widget(l)

-- LOOP OVER THE TWO SCREENS
awful.screen.connect_for_each_screen(function(s)

    -- Each screen has its own tag table.
    awful.tag(
        { "1", "2", "3", "4" },
        s,
        awful.layout.layouts[1]
    )

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt({ with_shell = true })

    -- Create an imagebox widget indicating which layout we're using.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
        -- left clicking moves to next layout
        awful.button({ }, 1, function () awful_layout_change( 1) end),
        -- right clicking moves to previous layout
        awful.button({ }, 3, function () awful_layout_change(-1) end),
        -- wheel down moves to next layout
        awful.button({ }, 4, function () awful.layout.inc( 1) end),
        -- wheel up moves to previous layout
        awful.button({ }, 5, function () awful.layout.inc(-1) end)
    ))

    ---------------------------------------------------------------
    -- TAGLIST WIDGET                                            --
    ---------------------------------------------------------------
    s.mytaglist = awful.widget.taglist({
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        layout = {
            layout = wibox.layout.fixed.horizontal
        },
        widget_template = {
        -- main template for tag items
            {--container for tag items
                {--layout for tag items
                    { -- background container with tag shape
                        {-- margin container for index textbox
                            {-- index textbox
                                id = "index_role",
                                widget = wibox.widget.textbox,
                            },
                            left = 9,
                            widget = wibox.container.margin
                        },

                        bg = beautiful.taglist_shape,
                        shape = gears.shape.rectangular_tag,
                        shape_border_width = 1.5,
                        shape_border_color =
                            beautiful.taglist_shape_border,
                        id = "background_shape",
                        widget = wibox.container.background,
                        forced_width = 20
                    },
                    { -- spacer?
                        margins = 1,
                        widget = wibox.container.margin
                    },
                    layout = wibox.layout.fixed.horizontal,
                },
                left = 2,
                right = 2,
                top = 7,
                bottom = 7,
                widget = wibox.container.margin
            },
            widget = wibox.container.background,
            -- hover colors
            create_callback = function(self, t, index, tt)
                -- change bg color when hovering
                self:connect_signal('mouse::enter', function()
                    if self.bg ~= beautiful.taglist_bg_hover then
                        self.backup = self.bg
                        self.has_backup = true
                    end
                    self.bg = beautiful.taglist_bg_hover
                end)
                -- restore bg color when leaving hover
                self:connect_signal('mouse::leave', function()
                    if self.has_backup then self.bg = self.backup end
                end)
                -- give tooltip
                self.tooltip = awful.tooltip({
                    objects = { self },
                    text = 'view tag ' .. tostring(index)
                })
                -- update
                update_taglist_tag(self, t, index, tt)
            end,
            update_callback = update_taglist_tag
        },
        buttons = taglist_buttons
    })

    ------------------------------------------------------------------
    -- TASKLIST WIDGET                                              --
    -- ---------------------------------------------------------------
    s.mytasklist = awful.widget.tasklist({
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons,
        style = {
            shape_border_width = 1.5,
            shape_border_color = beautiful.tasklist_shape_border,
            shape = gears.shape.rounded_bar
        },
        layout = {
            spacing = 16,
            spacing_widget = {
                {
                    forced_width  = 8,
                    forced_height = 8,
                    shape         = gears.shape.losange,
                    widget        = wibox.widget.separator,
                    color         = beautiful.separator_color
                },
                valign = 'center',
                halign = 'center',
                widget = wibox.container.place,
            },
            layout = wibox.layout.flex.horizontal
        },
        -- template for task items
        widget_template = {
            { -- container for placement
                { -- container for layout
                    { -- layout for both icon and name
                        { -- container for icon
                            { -- icon textbox
                                id     = 'icon_symbol',
                                widget = wibox.widget.textbox,
                                font   = 'Symbols Nerd Font 14',
                                markup = '<span foreground="' .. 
                                    beautiful.icon_color .. '"></span>'
                            },
                            margins = 2,
                            widget = wibox.container.margin
                        },
                        { -- container for window name
                            { -- window name textbox
                                id     = 'client_name',
                                widget = wibox.widget.textbox,
                                font   = beautiful.medfont,
                                markup = "placeholder",
                            },
                            bottom = 2,
                            widget = wibox.container.margin
                        },
                        {-- space for extra info
                            id     = 'info_add',
                            widget = wibox.widget.textbox,
                            font   = 'Symbols Nerd Font 8'
                        },
                        layout = wibox.layout.fixed.horizontal,
                    },
                    left = 8,
                    right = 8,
                    widget = wibox.container.margin
                },
                widget = wibox.container.place,
                halign = "center"
            },
            id = 'background_role',
            widget = wibox.container.background,
            create_callback = init_tasklist_widget,
            update_callback = update_tasklist_widget
        }
    })

    -- Create a textclock widget
    s.mytextclock = wibox.widget.textclock(
        '<span foreground="' .. beautiful.icon_color .. 
        '" font_family="Symbols Nerd Font" font_size="14pt"> </span>' ..
        '%a %b %-d <span foreground="' .. beautiful.icon_color .. '" ' ..
        'font_family="Symbols Nerd Font" font_size="14pt"></span> ' ..
        '%-I:%M%P'
    )

    --  update at mousein
    s.mytextclock:connect_signal(
        'mouse::enter',
        function()
            s.mytextclock:force_update()
        end
    )

    -- create calendar popup for clock
    s.mycalpopup =awful.widget.calendar_popup.month({
        screen = s,
        spacing = 0,
        start_sunday = true,
        font = beautiful.largerfont,
        margin = 2,
        style_weekday = {
            border_width = 0,
            padding = 2,
            fg_color =  beautiful.secondary_highlight
        },
        style_normal = { border_width = 0, padding = 2 },
        style_focus = { border_width = 0, padding = 2 },
        style_header = {
            fg_color = beautiful.cal_days,
            bg_color = beautiful.bg_normal,
            border_color = beautiful.secondary_highlight
        }
    })
    s.mycalpopup:attach(s.mytextclock, "tr")

    -- make clock clickable
    s.mytextclock:buttons(gears.table.join(
        s.mytextclock:buttons(),
        -- left click for today's schedule
        awful.button({}, 1, nil, function()
            awful.spawn('wezterm start --class info_term -- ' ..
                'schedshowdelay.sh')
        end),
        -- right click for another day's schedule
        awful.button({}, 3, nil, function()
            awful.spawn(
                'wezterm start --class info_term -- ' ..
                    'schedshowdelay.sh another'
            )
        end),
        -- any modifier + click for scheduling
        awful.button({ RC.vars.modkey }, 1, nil, function()
            awful.spawn(
                'wezterm start --class info_term -- schedshowdelay.sh ' ..
                    'schedule'
            )
        end),
        awful.button({ RC.vars.altkey }, 1, nil, function()
            awful.spawn(
                'wezterm start --class info_term -- schedshowdelay.sh ' ..
                    'schedule'
            )
        end),
        awful.button({ "Shift" }, 1, nil, function()
            awful.spawn(
                'wezterm start --class info_term -- schedshowdelay.sh ' ..
                    'schedule'
            )
        end),
        awful.button({ "Control" }, 1, nil, function()
            awful.spawn(
                'wezterm start --class info_term -- schedshowdelay.sh ' ..
                    'schedule'
            )
        end),
        awful.button({}, 2, nil, function()
            awful.spawn(
                'wezterm start --class info_term -- schedshowdelay.sh ' ..
                    'schedule'
            )
        end)
    ))

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s })
    local setbg = wibox.widget.background

    -- determine if primary; determine autolaunch screen
    s.isprimary = (s == screen.primary)
    if not (RC.startscreen) then
        RC.startscreen = s
    else
        if (not (s.isprimary)) then
            RC.startscreen = s
        end
    end

    s.rightwidgets = {}
    if (s.isprimary) then
        -- right widgets for primary screen
        s.rightwidgets = {
            layout = wibox.layout.fixed.horizontal,
            spacey,
            arleft,
            netw,
            arleft,
            cpu,
            spacey,
            mem,
            spacey,
            disk,
            arleft,
            updatestatus,
            _M.volume,
            wibox.widget.systray(),
            arleft,
            spacey,
            s.mytextclock,
            arleft,
            clipboardw,
            spacey,
            scratchw,
            spacey,
            quakew,
            spacey,
            quitlauncher
        }
    else
        -- widgets for secondary screen
        s.rightwidgets = {
            layout = wibox.layout.fixed.horizontal,
            arleft,
            mpd,
            spacey,
            mpd.widget.infow,
            spacey,
            musicbrowsew,
            spacey,
            arleft,
            updatestatus,
            _M.volume,
            wibox.widget.systray(),
            arleft,
            spacey,
            s.mytextclock,
            arleft,
            clipboardw,
            spacey,
            scratchw,
            spacey,
            quakew,
            spacey,
            quitlauncher
        }
    end

    -- Add widgets to the wibox
    s.mywibox:setup({
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            spacey,
            {
                widget = wibox.container.margin,
                left = 0,
                right = 0,
                top = 7,
                bottom = 7,
                {
                    layout = wibox.layout.fixed.horizontal,
                    RC.mainmenu.mylauncher
                }
            },
            spacey,
            spacey,
            arright,
            spacey,
            s.mytaglist,
            spacey,
            {
                widget = wibox.container.margin,
                left = 0,
                right = 0,
                top = 7,
                bottom = 7,
                {
                    layout = wibox.layout.fixed.horizontal,
                    s.mylayoutbox,
                }
            },
            spacey,
            spacey,
            arright,
            s.mypromptbox,
        },
        {
            widget = wibox.container.margin,
            left = 4,
            right = 4,
            top = 3,
            bottom = 3,
            {
                layout = wibox.layout.flex.horizontal,
                s.mytasklist -- Middle widget
            }
        },
        s.rightwidgets
    })
end)

return _M
