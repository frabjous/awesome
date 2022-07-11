-- Requirements (made global):
--local awful = require("awful")
--local beautiful = require("beautiful")
--local gears = require("gears")
--local hotkeys_popup = require("hotkeyspopup")

local _M = {}

-- Create a launcher widget and a main menu
local icon_loc = "/usr/share/icons/" .. beautiful.icon_theme .. "/24x24/"
_M.myawesomemenu = {
    { "hotkeys", function()
            hotkeys_popup.show_help(nil, awful.screen.focused())
        end,
        icon_loc .. "panel/dialog-information-symbolic.svg"
    },
    { "edit config", RC.vars.editor_cmd .. " " .. awesome.conffile,
        icon_loc .. "actions/fcitx-handwriting-active.svg" },
    { "man page", RC.vars.terminal .. " start -- man awesome",
        icon_loc .. "actions/contents.svg" },
    { "restart awesome", awesome.restart,
        icon_loc .. "actions/media-repeat-all.svg" },
    { "quit awesome", function() awesome.quit() end,
        icon_loc .. "actions/exit.svg" }
}

_M.myrunmenu = {
    { "browser", RC.vars.browser
        -- .. ' --target window',
        --' --new-window --profile ' ..
        --os.getenv("HOME") .. '/.mozilla/firefox/default'
        ,
        icon_loc .. "actions/gtk-connect.svg"
    },
    { "terminal", RC.vars.terminal .. ' start',
        icon_loc .. "categories/utilities-terminal.svg" },
    { "editor",   RC.vars.terminal .. " start -- " .. RC.vars.editor,
        icon_loc .. "actions/document-edit.svg" },
    { "character map", "gucharmap",
        icon_loc .. "actions/format-text-symbol.svg" },
    { "xournal", "xournalpp",
        icon_loc .. "actions/document-page-setup.svg" },
    { "dolphin", "dolphin", icon_loc .. "places/folder-black-open.svg" }
}

require("xdgmenu")

_M.mymainmenu = awful.menu({
    items = {
        { "awesome", _M.myawesomemenu,
            os.getenv("HOME") .. "/.config/awesome/icons/awesome.png"
        },
        { "quick run", _M.myrunmenu,
            icon_loc .. "panel/superproductivity-tray-0.svg" },
        { "applications", xdgmenu,
            icon_loc .. "categories/tux.svg" },
        { "clipboard", function()
            awful.spawn.with_shell("sleep 0.1 && clipmenu")
            end, icon_loc .. "actions/editpaste.svg"
        },
        { "suspend", "kexit.sh suspend",
            icon_loc .. "panel/night-light-symbolic.svg" },
        { "reboot", "kexit.sh reboot",
            icon_loc .. "actions/vm-restart.svg" },
        { "shutdown", "kexit.sh poweroff'",
            icon_loc .. "actions/system-shutdown-symbolic.svg" }
    },
    theme = {
        width = 200,
        height = 28,
        font = "Oswald 16"
    }
})

_M.mylauncher = awful.widget.launcher({
    image = beautiful.awesome_icon,
    menu = _M.mymainmenu
})

_M.mylauncher.tooltip = awful.tooltip({
    objects = { _M.mylauncher },
    text = 'main menu'
})

-- rofi on right click
_M.mylauncher:buttons(gears.table.join(
    _M.mylauncher:buttons(),
    awful.button({}, 3, function () 
        awful.spawn(
            "rofi -modi combi -combi-modi drun,run,ssh -show combi"
        )
    end)
))
return _M
