---------------------------------------------
-- Globally require main Awesome libraries --
---------------------------------------------
-- If LuaRocks is installed, make sure that packages installed through it
-- are found (e.g., lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Window management library
awful = require("awful")

-- load its autofocus submodule
require("awful.autofocus")

-- Utility library
gears = require("gears")

-- Theme handling library
beautiful = require("beautiful")
-- Define beautiful theme
beautiful.init(os.getenv("HOME") .. "/.config/awesome/theme.lua")

-- Menubar library
menubar = require("menubar")

-- Error reporting library
naughty = require("naughty")

-- generic widget library
wibox = require("wibox")

-- widget extension library, used by statusbar, autostart
lain = require("lain")

-------------------------
-- Load my own scripts --
-------------------------
-- enable error handling
require("errorhandling")

-- user variables
RC = {}
RC.vars = require("uservariables")

-- set layouts
require("layouts")

-- my settings for naughty
require("naughtyconfig")

-- hot keys popup used by mainmenu, statusbar so goes before them
hotkeys_popup = require("hotkeyspopup")

-- main menu
RC.mainmenu = require("mainmenu")

-- my client actions library, used by statusbar, others
clientactions = require("clientactions")

-- client to icon function used by statusbar, clientswitcher
myicon = require("myicon")

-- menu bar / panel
RC.statusbar = require("statusbar")
-- (Note layoutlist.lua called from within statusbar.lua)

-- wallpaper function
RC.wallpaper = require("wallpaper")

-- client switcher
RC.clientswitcher = require("clientswitcher")

-- keybinds and mouse binds
require("keybinds")

-- window rules
require("rules")

-- signals (i.e. event listeners)
require("signals")

-- programs to start on launch
RC.dropdowns = require("autostart")

-- record dbus address for root to find
require("dbusrecord")
