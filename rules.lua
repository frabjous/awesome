--Requirements (made global):
--local awful = require("awful")
--local beautiful = require("beautiful")

-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
        properties = { 
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = clientkeys,
            buttons = clientbuttons,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap +
                awful.placement.no_offscreen
        }
    },
    -- Floating clients.
    { rule_any = {
        instance = {
            "DTA",
            "copyq",
            "pinentry",
        },
        class = {
            "Arandr",
            "Blueman-manager",
            "Gpick",
            "Kruler",
            "MessageWin",
            "Sxiv",
            "Tor Browser",
            "Wpa_gui",
            "veromix",
            "xtightvncviewer",
            "float_term", -- KCK additions start here
            "music_browse",
            "zenity",
            "yad",
            "info_term",
            "mpv",
        },
        -- Note that the name property shown in xprop might be set
        -- slightly after creation of the client and the name shown
        -- there might not match defined rules here.
        name = {
            "Event Tester",
            "Picture-in-Picture",
            "Picture in picture",
            "Firefox — Sharing Indicator",
            "Open Files"
        },
        role = {
            "AlarmWindow",
            "ConfigManager"--,
            --"pop-up", -- was being applied to brave webapps!
        }
    }, properties = { floating = true } },
    -- make YouTube PiP sticky: on all tags
    { rule_any = {
        name = {
            "Picture-in-Picture",
            "Picture in picture"
        },
        class = {
            "mpv"
        },
    }, properties = { sticky = true, ontop = true } },
    -- make music browse full screen
    { rule_any = {
        class = { "music_browse", "info_term" }
    }, properties = { maximized = true, fullscreen = true } },

    -- Add titlebars to normal clients and dialogs
    -- (changed to only dialogs)
    --{ rule_any = {type = { "normal", "dialog" }
    { rule_any = { type = { "dialog" } },
        properties = { titlebars_enabled = true }
    },
    { rule_any = { name = { "—starter" } },
        properties = { screen = RC.startscreen }
    }
    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { screen = 1, tag = "2" } },
}

-- prevent firefox from stealing focus
--awful.ewmh.add_activate_filter(function(c)
--    if c.class == "Firefox" then return false end
--end, "ewmh")

-- prevent qutebrowser from stealing focus
--awful.ewmh.add_activate_filter(function(c)
--    if c.class == "qutebrowser" then return false end
--end, "ewmh")


