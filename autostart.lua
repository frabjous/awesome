-- Requirements (made global):
--local awful = require("awful")
--local gears = require("gears")
--local lain  = require("lain")

local host = awesome.hostname
local username = os.getenv("USER")

if not (gears.filesystem.dir_readable('/tmp/awesome.started')) then

    awful.spawn.once(
        'wezterm start --class info_term -- send-ip.sh', {}
    )

    if ((host == username .. "-home") or
        (host == username .. "-work")) then
        -- start outlook
        awful.spawn.once(RC.vars.browser .. ' --new-window ' ..
            '--profile ' .. os.getenv("HOME") ..
            '/.mozilla/firefox/hiddenui ' ..
            'https://outlook.office365.com/mail/inbox/',
        -- rules
            { screen = RC.startscreen, tag = "1" }
        )

        -- start youtube after 55 seconds
        gears.timer({
            timeout = 55,
            autostart = true,
            callback = function()
                awful.spawn.once(
                    RC.vars.browser .. ' --new-window --profile ' ..
                        os.getenv("HOME") .. '/.mozilla/firefox/hiddenui '
                        .. 'https://youtube.com',
                    { screen = RC.startscreen, tag = "1" }
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
