-- Requirements (made global):
--local awful = require("awful")
--local gears = require("gears")
--local lain  = require("lain")

local host = awesome.hostname
local username = os.getenv("USER")

-- start browsers
if not (gears.filesystem.dir_readable('/tmp/awesome.started')) then

    if (os.getenv("KCK_START_WEBAPPS") == "yes") then

        -- start outlook
        awful.spawn.once(
            RC.vars.browser ..
            ' --app=' ..
            'https://outlook.office365.com/mail/inbox/',
            { screen = RC.startscreen }
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
                    'https://youtube.com',
                    { screen = RC.startscreen }
                )
            end
        })
    end

    if (os.getenv("KCK_START_LECTURE") == "yes") then
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
