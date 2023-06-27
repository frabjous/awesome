--Requirements (made global):
--local awful         = require("awful")
--local clientactions = require("clientactions")
--local gears         = require("gears")
--local hotkeys_popup = require("hotkeyspopup")
--local menubar       = require("menubar")

-- Menubar configuration
-- set terminal for those that require it
menubar.utils.terminal = RC.vars.terminal

-- Mouse bindings
root.buttons(gears.table.join(
    -- left clicking root window brings up menu
    awful.button({ }, 3, function () RC.mainmenu.mymainmenu:toggle() end),
    -- wheel down root window goes to next tag
    awful.button({ }, 4, awful.tag.viewnext),
    -- wheel up root window goes to prev tag
    awful.button({ }, 5, awful.tag.viewprev)
))

-- Key bindings
globalkeys = gears.table.join(
    -- super F1 shows keybindings
    awful.key({ RC.vars.modkey }, "F1", hotkeys_popup.show_help,
        { description="show help", group = "Super" }),
    -- super left = previous tag
    awful.key({ "Control", RC.vars.altkey }, "Left", awful.tag.viewprev,
        { description = "view previous tag", group = "Alt-Ctrl" }),
    -- super right = next tag
    awful.key({ "Control", RC.vars.altkey }, "Right", awful.tag.viewnext,
        { description = "view next tag", group = "Alt-Ctrl" }),
    -- super shift escape = restore previous tag history
    awful.key({ RC.vars.modkey, "Shift" }, "Escape",
        awful.tag.history.restore,
        { description = "go back", group = "Shift-Super" }
    ),
    -- alt super right bracket focus next client (old way)
    awful.key({ RC.vars.modkey, RC.vars.altkey }, "]",
        function ()
            awful.client.focus.byidx( 1)
        end,
        { description = "focus next old", group = "Alt-Super" }
    ),
    -- super alt left bracket focus previous client (old way)
    awful.key({ RC.vars.modkey, RC.vars.altkey }, "[",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous old", group = "Alt-Super" }
    ),
    -- super shift W to show menu
    awful.key({ RC.vars.modkey, "Shift" }, "w", function ()
            RC.mainmenu.mymainmenu:show()
        end,
        {description = "show main menu", group = "Shift-Super" }
    ),

    -- Layout manipulation
    -- super shift right bracket to swap with next client
    awful.key({ RC.vars.modkey, "Shift" }, "]", function ()
            awful.client.swap.byidx(1)
        end,
        { description = "swap with next client",
            group = "Shift-Super" }
    ),
    -- super shift left bracket to swap with previous client
    awful.key({ RC.vars.modkey, "Shift" }, "[", function ()
            awful.client.swap.byidx( -1)
        end,
        { description = "swap with previous client",
            group = "Shift-Super" }
    ),
    -- super < / comma to focus previous screen
    awful.key({ RC.vars.modkey }, ",", function ()
            awful.screen.focus_relative( 1)
        end,
        { description = "focus previous screen",
            group = "Super" }
    ),
    -- super > / period to focus next screen
    awful.key({ RC.vars.modkey }, ".", function ()
            awful.screen.focus_relative(-1)
        end,
        { description = "focus next screen", group = "Super" }
    ),
    -- super shift u to jump to urgent client
    awful.key({ RC.vars.modkey, "Shift" }, "u",
        awful.client.urgent.jumpto,
        {description = "focus urgent client", group = "Shift-Super" }
    ),
    -- super tab for client switcher
    awful.key({ RC.vars.modkey }, "Tab",
        function()
            RC.clientswitcher.tabexplore(1)
        end,
        { description = "client switcher", group = "Super" }
    ),
    -- super shift tab for moving backwards in client switcher
    awful.key({ RC.vars.modkey, "Shift" }, "Tab",
        function()
            RC.clientswitcher.tabexplore(-1)
        end,
        { descrption = "client switcher previous", group = "Shift-Super" }
    ),
    --
    -- Standard program
    -- super return to spawn terminal
    awful.key({ RC.vars.modkey }, "Return", function ()
            awful.screen.focused().tags[3]:view_only()
            awful.spawn(RC.vars.terminal .. ' start' )
        end,
        { description = "terminal", group = "Super" }
    ),
    -- super shift return to spawn floating terminal
    awful.key({ RC.vars.modkey, "Shift" }, "Return", function ()
            awful.spawn(RC.vars.terminal .. ' start --class float_term')
        end,
        { description = "floating terminal", group = "Shift-Super" }
    ),
    -- super w to open ssh to work
    awful.key({ RC.vars.modkey }, "w", function()
            awful.screen.focused().tags[3]:view_only()
            awful.spawn('wezterm ssh work')
        end,
        { description = "ssh work", group = "Super" }
    ),
    -- super c to launch default browser
    awful.key({ RC.vars.modkey }, "c", function ()
            awful.screen.focused().tags[1]:view_only()
            awful.spawn(RC.vars.browser)
        end,
        { description = "browser", group = "Super" }
    ),
    -- control super o to open O
    -- outlook webapp
    --[[ COMMENTED OUT WEBAPPS
    awful.key({ RC.vars.modkey, "Control" }, "o", function()
            awful.spawn('outlookapp')
        end,
        { description = "outlook", group = "Ctrl-Super" }
    ),
    -- control super y to open youtube webapp
    awful.key({ RC.vars.modkey, "Control" }, "y", function()
            awful.spawn('youtubeapp')
        end,
        { description = "youtube", group = "Ctrl-Super" }
    ),
    -- control super m to open media server window
    awful.key({ RC.vars.modkey, "Control" }, "m", function()
            awful.spawn('pimediaapp')
        end,
        { description = "media server", group = "Ctrl-Super" }
    ),
    --]]
    -- super alt c to open alternative browser
    awful.key({ RC.vars.modkey, RC.vars.altkey }, "c", function()
            awful.screen.focused().tags[1]:view_only()
            awful.spawn('chromium')
        end,
        { description = "chromium", group = "Alt-Super" }
    ),
    -- super e for editor
    awful.key({ RC.vars.modkey }, "e", function()
            awful.screen.focused().tags[2]:view_only()
            awful.spawn(RC.vars.editor_cmd)
        end,
        { description = "editor", group = "Super" }
    ),
    -- super n for logs
    awful.key({ RC.vars.modkey }, "n", function()
            awful.screen.focused().tags[4]:view_only()
            awful.spawn(RC.vars.logs_cmd)
        end,
        { description = "server logs", group = "Super" }
    ),
    -- super v for clipboard menu
    awful.key({ RC.vars.modkey }, "v", function()
            awful.spawn('clipmenu')
        end,
        { description = "clipboard menu", group = "Super" }
    ),
    -- super a to read xclip current selection
    awful.key({ RC.vars.modkey }, "a", function()
            awful.spawn('readit.sh')
        end,
        { description = "read clipboard selection", group = "Super" }
    ),
    -- super o for file opener menu
    awful.key({ RC.vars.modkey }, "o", function()
        awful.spawn.with_shell('fd . ~ --type file | rofi ' ..
        '-dmenu -i -matching fuzzy -sort -sorting-method ' ..
        'fzf | xargs o.sh')
        end,
        { description = "open file", group = "Super" }
    ),
    -- super p for password menu
    awful.key({ RC.vars.modkey }, "p", function()
            awful.spawn('rofi-pass.sh')
        end,
        { description = "password menu", group = "Super" }
    ),
    -- super r for rofi launcher
    awful.key({ RC.vars.modkey }, "r", function() awful.spawn('rofi ' ..
            '-modi combi -combi-modi drun,run,ssh -show combi')
        end,
        { description = "rofi", group = "Super" }
    ),
    -- super s for snippets
    awful.key({ RC.vars.modkey }, "s", function()
            awful.spawn('snippets.sh')
        end,
        { description = "snippets", group = "Super" }
    ),
    -- super t for latex test file
    awful.key({ RC.vars.modkey }, "t", function()
            awful.screen.focused().tags[2]:view_only()
            awful.spawn(RC.vars.terminal .. ' start -- nvim ' ..
                os.getenv("HOME") .. '/tmp/scratch.tex')
        end,
        { description = "latex test", group = "Super" }
    ),
    -- super u for rofi unicode chooser
    awful.key({ RC.vars.modkey }, "u", function()
            awful.spawn.with_shell("cat $HOME/misc/charpicker/*.csv | rofi " ..
                "-dmenu -i -matching fuzzy -sort -sorting-method fzf | rg -o " ..
                "--color=never '^\\S*' | tr -d '\\n' | xsel --clipboard")
        end,
        { description = "unicode/emojis", group = "Super" }
    ),
    -- super F2 to browse music collection with terminal
    awful.key({ RC.vars.modkey }, "F2", function()
            awful.spawn(RC.vars.terminal ..
                ' start --class music_browse -- musicbrowse.sh')
        end,
        { description = "browse music", group = "Super" }
    ),
    -- super control r to restart awesome
    awful.key({ RC.vars.modkey, "Control" }, "r", awesome.restart,
        { description = "reload awesome", group = "Ctrl-Super" }),
    -- super shift alt control e or q to quit awesome
    awful.key({ RC.vars.modkey, "Shift", "Control", RC.vars.altkey },
        "e", awesome.quit,
        { description = "quit awesome", group = "Alt-Ctrl-Shift-Super" }
    ),
    awful.key({ RC.vars.modkey, "Shift", "Control", RC.vars.altkey },
        "q", awesome.quit,
        { description = "quit awesome", group = "Alt-Ctrl-Shift-Super" }
    ),
    -- super shift e, or super-escape for fshutdown menu
    awful.key({ RC.vars.modkey, "Shift" }, "e", function()
            awful.spawn("kexit.sh ask")
        end,
        { description = "power menu", group = "Shift-Super" }
        ),
    awful.key({ RC.vars.modkey }, "Escape", function()
            awful.spawn("kexit.sh ask")
        end,
        { description = "power menu", group = "Super" }
    ),
    -- Print or F12 or Super-backtick for quake terminal
    awful.key({}, "Print", function() RC.dropdowns.quake:toggle() end,
        { description = "dropdown terminal", group = "Normal" }),
    awful.key({}, "F12", function() RC.dropdowns.quake:toggle() end,
        { description = "dropdown terminal", group = "Normal" }),
    awful.key({ RC.vars.modkey }, "`", function() RC.dropdowns.quake:toggle() end,
        { description = "dropdown terminal", group = "Super" }),
    -- Super print or shift Print or Super F12 or shift F12 
    -- or Super Shift backtick for quake scratchpad
    awful.key({ RC.vars.modkey }, "Print", function()
            RC.dropdowns.scratch:toggle()
        end,
        { description = "scratchpad", group = "Super" }
    ),
    awful.key({ "Shift" }, "Print", function()
            RC.dropdowns.scratch:toggle()
        end,
        { description = "scratchpad", group = "Normal" }
    ),

    awful.key({ RC.vars.modkey }, "F12", function()
            RC.dropdowns.scratch:toggle()
        end,
        { description = "scratchpad", group = "Super" }
    ),
    awful.key({ "Shift" }, "F12", function()
            RC.dropdowns.scratch:toggle()
        end,
        { description = "scratchpad", group = "Normal" }
    ),
        awful.key({ RC.vars.modkey, "Shift" }, "`", function()
            RC.dropdowns.scratch:toggle()
        end,
        { description = "scratchpad", group = "Shift-Super" }
    ),
    -- super equals (plus) to decrease master width
    awful.key({ RC.vars.modkey }, "=", function ()
            awful.tag.incmwfact( 0.1)
        end,
        { description = "decrease master", group = "Super" }
    ),
    -- super hyphen (minus) to increase master width
    awful.key({ RC.vars.modkey }, "-", function ()
            awful.tag.incmwfact(-0.1)
        end,
        { description = "increase master", group = "Super" }
    ),
    -- super shift minus/hyphen to increase number of master clients
    awful.key({ RC.vars.modkey, "Shift" }, "-", function ()
            awful.tag.incnmaster( 1, nil, true)
        end,
        { description = "increase master number",
            group = "Shift-Super" }
    ),
    -- super shift equals/plus to decrease number of master clients
    awful.key({ RC.vars.modkey, "Shift" }, "=", function ()
            awful.tag.incnmaster(-1, nil, true)
        end,
        { description = "decrease master number",
            group = "Shift-Super" }
    ),
    -- control super plus to add a column
    awful.key({ RC.vars.modkey, "Control" }, "=", function ()
            awful.tag.incncol( 1, nil, true)
        end,
        { description = "increase columns",
            group = "Ctrl-Super"}
    ),
    -- control super minus/hyphen to remove a column
    awful.key({ RC.vars.modkey, "Control" }, "-", function ()
            awful.tag.incncol(-1, nil, true)
        end,
        { description = "decrease columns",
            group = "Ctrl-Super" }
    ),
    -- super l = next layout
    awful.key({ RC.vars.modkey }, "l", function ()
            awful_layout_change(1)
        end,
        { description = "next layout", group = "Super" }
    ),
    -- super shift l = previous layout
    awful.key({ RC.vars.modkey, "Shift" }, "l", function ()
            awful_layout_change(-1)
        end,
        { description = "previous layout", group = "Shift-Super" }
    ),
    -- super left, up, right, bottom = place master there
    awful.key({ RC.vars.modkey }, "Left", function()
            awful.layout.set(awful.layout.suit.tile)
        end,
        { description = "master on left", group = "Super" }
    ),
    awful.key({ RC.vars.modkey }, "Up", function()
            awful.layout.set(awful.layout.suit.tile.bottom)
        end,
        { description = "master on top", group = "Super" }
    ),
    awful.key({ RC.vars.modkey }, "Down", function()
            awful.layout.set(awful.layout.suit.tile.top)
        end,
        { description = "master on bottom", group = "Super" }
    ),
    awful.key({ RC.vars.modkey }, "Right", function()
            awful.layout.set(awful.layout.suit.tile.left)
        end,
        { description = "master on right", group = "Super" }
    ),
    -- super shift z for magnifier layout
    awful.key({ RC.vars.modkey, "Shift" }, "z", function()
            awful.layout.set(awful.layout.suit.magnifier)
        end,
        { description = "magnifier layout", group = "Shift-Super" }
    ),
    -- super e for fair layout
    awful.key({ RC.vars.modkey, "Shift" }, "f", function()
            awful.layout.set(awful.layout.suit.fair)
        end,
        { description = "fair layout", group = "Shift-Super" }
    ),
    -- super backslash to cycle windows
    awful.key({ RC.vars.modkey }, "\\", function()
            awful.client.cycle(true)
        end,
        { description = "cycle windows", group = "Super" }
    ),
    -- super control n = restore minimized
    awful.key({ RC.vars.modkey, "Control" }, "n",
        function ()
            local c = awful.client.restore()
            -- Focus restored client
            if c then
                c:emit_signal(
                    "request::activate",
                    "key.unminimize",
                    { raise = true }
                )
            end
        end,
        { description = "restore minimized", group = "Ctrl-Super" }
    ),

    -- Prompt
    -- super r = run prompt box
    awful.key({ RC.vars.modkey, "Shift" }, "r",
        function () awful.screen.focused().mypromptbox:run() end,
        { description = "run prompt", group = "Shift-Super" }
    ),
    -- super x = run lua code
    awful.key({ RC.vars.modkey }, "x",
        function ()
            awful.prompt.run({
                prompt = "Run Lua code: ",
                textbox = awful.screen.focused().mypromptbox.widget,
                exe_callback = awful.util.eval,
                with_shell = false,
                history_path = awful.util.get_cache_dir() ..
                    "/history_eval"
            })
        end,
        { description = "lua prompt", group = "Super" }
    ),
    -- super shift p to bring up traditional menubar
    awful.key({ RC.vars.modkey, "Shift" }, "p", function()
            menubar.show()
        end,
        { description = "menubar", group = "Shift-Super" }
    ),
    -- super 0 focuses all tags
    awful.key({ RC.vars.modkey }, "0",
        function ()
            local screen = awful.screen.focused()
            for i = 1,4 do
                local tag = screen.tags[i]
                if tag then
                    tag.selected = true
                end
            end
        end,
        { description = "all tags", group = "Super" }
    ),
    -- move and resize for floating
    awful.key({ RC.vars.modkey, "Control" }, "Down",
        function () awful.client.moveresize( 0, 0, 0, -20) end,
        { description = "resize- floater vertically",
            group = "Ctrl-Super" }
    ),
    awful.key({ RC.vars.modkey, "Control" }, "Up",
        function () awful.client.moveresize( 0, 0, 0, 20) end,
        { description = "resize+ floater vertically",
            group = "Ctrl-Super" }
    ),
    awful.key({ RC.vars.modkey, "Control" }, "Left",
        function () awful.client.moveresize( 0, 0, -20, 0) end,
        { description = "resize- floater horizontally",
            group = "Ctrl-Super" }
    ),
    awful.key({ RC.vars.modkey, "Control" }, "Right",
        function () awful.client.moveresize( 0, 0, 20, 0) end,
        { description = "resize+ floater horizontally",
            group = "Ctrl-Super" }
    ),
    awful.key({ RC.vars.modkey, RC.vars.altkey }, "Down",
        function () awful.client.moveresize(0, 20, 0, 0) end,
        { description = "move floater down", group = "Alt-Super" }),
    awful.key({ RC.vars.modkey, RC.vars.altkey }, "Up",
        function () awful.client.moveresize(0, -20, 0, 0) end,
        { description = "move floater up", group = "Alt-Super" }),
    awful.key({ RC.vars.modkey, RC.vars.altkey }, "Left",
        function () awful.client.moveresize(-20, 0, 0, 0) end,
        { description = "move floater left", group = "Alt-Super" }),
    awful.key({ RC.vars.modkey, RC.vars.altkey }, "Right",
        function () awful.client.moveresize( 20, 0, 0, 0) end,
        { description = "move floater right", group = "Alt-Super" }),

    -- MULTIMEDIA KEYS
    -- Volume Keys
    awful.key({}, "XF86AudioLowerVolume", function ()
        awful.spawn.easy_async_with_shell(
            "sh -c 'pactl set-sink-mute @DEFAULT_SINK@ 0 && pactl " ..
                "set-sink-volume @DEFAULT_SINK@ -4%'",
            function()
                RC.statusbar.volume.update()
            end
        ) end
    ),
    awful.key({}, "XF86AudioRaiseVolume", function ()
        awful.spawn.easy_async_with_shell(
            "sh -c 'pactl set-sink-mute @DEFAULT_SINK@ 0 && pactl " ..
                "set-sink-volume @DEFAULT_SINK@ +4%'",
            function()
                RC.statusbar.volume.update()
            end
        ) end
    ),
    awful.key({}, "XF86AudioMute", function ()
        awful.spawn.easy_async_with_shell(
            "pactl set-sink-mute @DEFAULT_SINK@ toggle",
            function()
                RC.statusbar.volume.update()
            end
        )
    end),
    awful.key({ RC.vars.modkey, "Shift" }, "Down", function ()
        awful.spawn.easy_async_with_shell(
            "sh -c 'pactl set-sink-mute @DEFAULT_SINK@ 0 && pactl " ..
                "set-sink-volume @DEFAULT_SINK@ -4%'",
            function()
                RC.statusbar.volume.update()
            end
        )
    end, { description = "volume down", group = "Shift-Super" }),
    awful.key({ RC.vars.modkey, "Shift" }, "Up", function ()
            awful.spawn.easy_async_with_shell(
                "sh -c 'pactl set-sink-mute @DEFAULT_SINK@ 0 && pactl " ..
                    "set-sink-volume @DEFAULT_SINK@ +4%'",
            function()
                RC.statusbar.volume.update()
            end
        )
    end, { description = "volume up", group = "Shift-Super" }),
    awful.key({ RC.vars.modkey, "Shift" }, "m", function ()
        awful.spawn.easy_async_with_shell(
            "pactl set-sink-mute @DEFAULT_SINK@ toggle",
            function()
                RC.statusbar.volume.update()
            end
        )
    end, { description = "toggle mute", group = "Shift-Super" }),
    -- Media Keys
    awful.key({}, "XF86AudioMedia", function()
        awful.util.spawn("playerctl play-pause", false) end),
    awful.key({}, "XF86AudioPlay", function()
        awful.util.spawn("playerctl play-pause", false) end),
    awful.key({}, "XF86AudioNext", function()
        awful.util.spawn("playerctl next", false) end),
    awful.key({}, "XF86AudioPrev", function()
        awful.util.spawn("playerctl previous", false) end),
    awful.key({}, "XF86Eject", function()
        awful.util.spawn("eject -T", false) end),
    -- Brightness Keys
    awful.key({}, "XF86MonBrightnessUp", function()
        awful.util.spawn("light -A 5", false) end),
    awful.key({}, "XF86MonBrightnessDown", function()
        awful.util.spawn("light -U 5", false) end)
)

clientkeys = gears.table.join(
    -- super f toggles fullscreen and raises
    awful.key({ RC.vars.modkey }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "Super"}),
    -- super shift c to quit
    awful.key({ RC.vars.modkey, "Shift" }, "c", function (c) c:kill() end,
        { description = "close", group = "Shift-Super" }),
    -- super space to toggle floating
    awful.key({ RC.vars.modkey }, "space", awful.client.floating.toggle,
        { description = "toggle floating", group = "Super" }),
    -- super z to make master
    awful.key({ RC.vars.modkey }, "z", function (c)
            clientactions.swap_with_master(c)
        end,
        { description = "move to master", group = "Super"}
    ),
    -- super k = switch screens
    awful.key({ RC.vars.modkey }, "k", function (c) c:move_to_screen() end,
        { description = "move to screen", group = "Super" }),
    -- super shift t to toggle on top
    awful.key({ RC.vars.modkey, "Shift" }, "t", function (c)
            c.ontop = not c.ontop
        end,
        { description = "toggle keep on top", group = "Shift-Super" }
    ),
    -- super y to make sticky
    awful.key({ RC.vars.modkey }, "y", function (c)
            c.sticky = not c.sticky
        end,
        { description = "toggle sticky", group = "Super" }
    ),
    -- super g to minimize
    awful.key({ RC.vars.modkey }, "g",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end,
        { description = "minimize", group = "Super" }
    ),
    -- super m to toggle maximized
    awful.key({ RC.vars.modkey }, "b",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end,
        { description = "(un)maximize", group = "Super" }
    ),
    -- super alt m to toggle maximized vertically
    awful.key({ RC.vars.modkey, RC.vars.altkey }, "b",
        function (c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end,
        { description = "(un)maximize vertically", group = "Alt-Super" }
    ),
    -- super shift m to toggle maximized horizontally
    awful.key({ RC.vars.modkey, "Shift" }, "b",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end,
        { description = "(un)maximize horizontally",
            group = "Shift-Super" }
    ),
        -- super m to make only showing client on screen
        awful.key({ RC.vars.modkey }, "m",
            function(c)
                local numminimized = 
                    clientactions.make_only_on_screen(c,
                        awful.screen.focused()
                    )
                if (numminimized == 0) then
                    clientactions.unminimize_all_peers(c)
                end
            end,
            { description = "toggle only on screen",
                group = "Super" }
        ),
    -- super right bracket focus next client (smart way)
    awful.key({ RC.vars.modkey }, "]",
        function (c)
            clientactions.smart_screen_next(c,1)
        end,
        { description = "focus next client", group = "Super" }
    ),
    -- super alt left bracket focus previous client (smart way)
    awful.key({ RC.vars.modkey }, "[",
        function (c)
            clientactions.smart_screen_next(c,-1)
        end,
        { description = "focus previous client", group = "Super" }
    ),
    awful.key({ RC.vars.modkey }, "F10",
        function(c)
            clientactions.context_menu(c)
        end,
        { description = "context menu", group = "Super" }
    )
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 4 do
    globalkeys = gears.table.join(globalkeys,
        -- Super 1 - 9; View tag only.
        awful.key({ RC.vars.modkey }, "#" .. i + 9,
            function ()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    tag:view_only()
                end
            end,
            { description = "view tag #"..i, group = "Super" }
        ),
        -- Super Control 1-9 Toggle tag display.
        awful.key({ RC.vars.modkey, "Control" }, "#" .. i + 9,
            function ()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    awful.tag.viewtoggle(tag)
                end
            end,
            { description = "toggle tag #" .. i, group = "Ctrl-Super" }
        ),
        -- Super Shift 1-9: Move client to tag.
        awful.key({ RC.vars.modkey, "Shift" }, "#" .. i + 9,
            function ()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:move_to_tag(tag)
                    end
                end
            end,
            { description = "move to tag #" .. i,
                group = "Shift-Super" }
        ),
        -- Super Shift Control Num = Toggle tag on focused client.
        awful.key({ RC.vars.modkey, "Control", "Shift" }, "#" .. i + 9,
            function ()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:toggle_tag(tag)
                    end
                end
            end,
            { description = "toggle focused client on tag #" .. i,
                group = "Ctrl-Shift-Super" }
        )
    )
end

clientbuttons = gears.table.join(
    -- click a client activates it
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
    end),
    -- super-click grabs to move
    awful.button({ RC.vars.modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
        awful.mouse.client.move(c)
    end),
    -- super right click grab to resize
    awful.button({ RC.vars.modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
        awful.mouse.client.resize(c)
    end),
    -- super shift right click to open context menu (TODO: fix this?)
    awful.button({ RC.vars.modkey, "Shift" }, 3, function(c)
        clientactions.context_menu(c)
    end)
)

-- Set keys
root.keys(globalkeys)

