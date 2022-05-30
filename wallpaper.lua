
-- Requirements (made global):
--local awful = require("awful")
--local gears = require("gears")

local function set_wallpaper(s)
    -- get random wallpaper file
    local proc = io.popen("find /home/kck/images/wallpaper -type f | shuf -n 1")
    wallpaper = proc:read("*a")
    proc:close()
    -- remove newlines at end of output
    wallpaper = wallpaper:gsub("\n","")
    -- setwallpaper on screen
    gears.wallpaper.maximized(wallpaper, s, false)
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

-- set wallpaper for each screen
function set_wallpaper_all_screens()
    awful.screen.connect_for_each_screen(function(s)
        set_wallpaper(s)
    end)
end
-- set them right away
set_wallpaper_all_screens()

-- change wallpaper every hour
local wallpapertimer = gears.timer({
    timeout = 3600,
    call_now = false,
    callback = function()
        set_wallpaper_all_screens()
        RC.wallpaper:restart()
    end
}):start()

return wallpapertimer
