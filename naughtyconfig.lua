naughty.config.defaults.margin=beautiful.notification_margin

naughty.mynotify = function(msg, pos)
    pos = pos or 'bottom_middle'
    naughty.notify({
        --color = beautiful.accent,
        font = 'Oswald 30',
        position = pos,
        bg = beautiful.themecolors.white,
        fg = beautiful.themecolors.gray2,
        opacity = 0.4,
        timeout = 2,
        text = msg
    })
end
