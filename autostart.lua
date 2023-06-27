-- Requirements (made global):
--local awful = require("awful")
--local gears = require("gears")
--local lain  = require("lain")

local host = awesome.hostname
local username = os.getenv("USER")

-- start browsers
--if not (gears.filesystem.dir_readable('/tmp/awesome.started')) then
--
--    if (os.getenv("KCK_START_LECTURE") == "yes") then
--        awful.spawn.once (
--            RC.vars.browser .. ' "https://logic.umasscreate.net"', {}
--        )
--    else
--        if (os.getenv("KCK_START_WEBAPPS") == "yes") then
--            awful.spawn.once( RC.vars.browser )
--        end
--
--    end
--
--    -- create a folder in /tmp to mark run since boot
--    gears.filesystem.make_directories("/tmp/awesome.started")
--end

-- start browser
if not (gears.filesystem.dir_readable('/tmp/awesome.started')) then
    awful.spawn.once( RC.vars.browser )
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
