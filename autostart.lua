-- Requirements (made global):
--local awful = require("awful")
--local gears = require("gears")
--local lain  = require("lain")

local host = awesome.hostname
local username = os.getenv("USER")

-- store dbus address
local dbusaddr = os.getenv("DBUS_SESSION_BUS_ADDRESS")
local runtimedir = os.getenv("XDG_RUNTIME_DIR")
local f = io.open(runtimedir .. '/awesome-dbus-addr', 'w')
f:write(dbusaddr)
f:close()

-- start browsers
if not (gears.filesystem.dir_readable('/tmp/awesome.started')) then

    awful.spawn.once(
        'wezterm start --class info_term -- send-ip.sh', {}
    )

    if ((host == username .. "-home") or
        (host == username .. "-gentoo") or
        (host == username .. "-work")) then
        -- start outlook
        awful.spawn.once(
            RC.vars.browser ..
            ' --app=' ..
            --' --target window -C ' .. os.getenv("HOME")
            --.. '/misc/dotfiles/qutebrowser/config-noui.py --basedir ' ..
            --os.getenv("HOME") .. '/.cache/altqute ' ..
            --'-s window.title_format "{perc}{current_title}—starter" ' ..
            --RC.vars.browser .. ' --new-window ' ..
            --'--profile ' .. os.getenv("HOME") ..
            --'/.mozilla/firefox/hiddenui ' ..
            'https://outlook.office365.com/mail/inbox/'
        )

        -- start youtube after 15 seconds
        gears.timer({
            timeout = 15,
            autostart = true,
            single_shot = true,
            callback = function()
                awful.spawn.once(
                    RC.vars.browser ..
                    ' --app=' ..
                    --' --target window -C ' .. os.getenv("HOME")
                    --.. '/misc/dotfiles/qutebrowser/config-noui.py --basedir ' ..
                    --os.getenv("HOME") .. '/.cache/altqute ' ..
                    --'-s window.title_format "{perc}{current_title}—starter" ' ..
                    --RC.vars.browser .. ' --new-window --profile ' ..
                    --os.getenv("HOME") .. '/.mozilla/firefox/hiddenui ' ..
                        'https://youtube.com'
                )
            end
        })
    end
    if (host == username .. "-laptop") then
        awful.spawn.once (
            RC.vars.browser .. ' "https://logic.umasscreate.net"', {}
        )
    end
    -- create a folder in /tmp to mark run since boot
    gears.filesystem.make_directories("/tmp/awesome.started")
end

-- dropdown terminal
local quake = lain.util.quake({
    app = "wezterm",
    argname = "start --class %s",
    followtag = true,
    height = 0.4,
    width = 0.99,
    border = 2,
    horiz = "center"
})

-- scratchpad
local scratch = lain.util.quake({
    app = "wezterm",
    extra = "-- nvim " .. os.getenv("HOME") .. "/notes/scratch.md",
    name = "QuakeSP",
    argname = "start --class %s",
    followtag = true,
    height = 0.4,
    width = 0.99,
    border = 2,
    horiz = "center",
    vert = "bottom"
})

-- return dropdowns for access by keybinds
return { quake = quake, scratch = scratch }
