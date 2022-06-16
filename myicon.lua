
-- determine Awesome Nerd Font Icon to use by Window name and class
function myicon(name, class)
    if ((name:match('YouTube — Mozilla Firefox')) or
        (name:match('Picture-in-Picture'))) then
        return ''
    end
    if (name:match('Outlook — Mozilla Firefox')) then
        return ''
    end
    if ((name:match('Zoom Video Conferencing')) or
        (name:match('Personal Meeting Room')) or
        (name:match('Zoom — Mozilla Firefox'))) then
        return ''
    end
    if ((name:match('Local Media — Mozilla Firefox')) or
        (name:match('Pi Media  — Mozilla Firefox'))) then
        return ''
    end
    if (name:match('^Reddit.*Firefox$')) then
        return '樓' -- cf 
    end
    if ((name:match('Stack Exchange.*Firefox')) or
        (name:match('Stack Overflow.*Firefox')) or
        (name:match('Super User.*Firefox')) or
        (name:match('Ask Ubuntu.*Firefox'))) then
        return ''
    end
    if (name:match('nvimpager$')) then
        return ''
    end
    if ((name:match('nvim$')) or (name:match("^wezterm nvim")) or
        (name:match('^wezterm $EDITOR'))) then
        return ''
    end
    if (name:match('Mozilla Firefox$')) then
        return ''
    end
    if (name:match('Chromium$')) then
        return ''
    end
    if ((class:match('^sioyek$')) or (class:match('^[Zz]athura$')) or
        (class:match('^llpp$')) or (class:match('^okular$')) or
        (class:match('^[Ee]vince$')) or (class:match('^qpdfview$')) or
        (class:match('^[Mm][Uu][Pp][Dd][Ff]$'))) then
        return ''
    end
    if (name:match('schedshowdelay')) then
        return ''
    end
    if (class:match('info_term')) then
        return ''
    end
    if (class:match('music_browse')) then
        return ''
    end
    if ((class:match('^kitty$')) or (class:match('^Alacritty$')) or
        (class:match('^[Uu][Rr][Xx][Vv][Tt]$')) or
        (name:match('^wezterm')) or (class:match('wezterm$')) or
        (class:match('^xterm$'))) then
        return ''
    end
    if ((class:match('^[Tt]hunar$')) or (class:match('^[Dd]olphin')) or
        (class:match('^[N]autilus$')) or 
        (class:match('[Pp][Cc][Mm][Aa][Nn][Ff][Mm]'))) then
        return ''
    end
    if (class:match('^[Mm][Pp][Vv]$')) then
        return ''
    end
    if (class:match('^[Xx]ournal')) then
        return ''
    end
    if (class:match('^[Gg]ucharmap$')) then
        return ''
    end
    if (class:match('^[Kk]denlive$')) then
        return '金'
    end
    if (class:match('^[Gg]imp$')) then
        return ''
    end
    if (class:match('[Ii]nkscape$')) then
        return ''
    end
    if (name:match('LibreOffice Writer')) then
        return ''
    end
    return ''
end

return myicon
