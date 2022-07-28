
local distroicon=''
if (awesome.hostname == 'kck-gentoo') then
    distroicon = ''
elseif (awesome.hostname == 'kck-laptop') then
    distroicon = ''
elseif ((awesome.hostname == 'kck-work')
    or (awesome.hostname == 'kck-home')) then
    distroicon = ''
end


-- determine Awesome Nerd Font Icon to use by Window name and class
function myicon(name, class)
    if (name:match('YouTube'))  then
        return ''
    end
    if (name:match('Mail.*Outlook')) then
        return ''
    end
    if (name:match('^Zoom')) then
        return ''
    end
    if ((name:match('^Local Media')) or
        (name:match('^Pi Media'))) then
        return ''
    end
    if (name:match('^Reddit')) then
        return '樓' -- cf 
    end
    if ((name:match('Stack Exchange')) or
        (name:match('Stack Overflow')) or
        (name:match('Super User')) or
        (name:match('Ask Ubuntu'))) then
        return ''
    end
    if (name:match('nvimpager$')) then
        return ''
    end
    if ((name:match('nvim$')) or (name:match("^wezterm nvim")) or
        (name:match('^wezterm $EDITOR'))) then
        return ''
    end
    if (name:match('qutebrowser$')) then
        return ''--
    end
    if ((name:match('Mozilla Firefox$')) or
        (name:match('Iceweasel'))) then
        return ''
    end
    if ((name:match('Chromium$')) or (name:match('[Ii]ridium$'))) then
        return ''
    end
    if (name:match('Brave$')) then
        return ''
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
    return distroicon
end

return myicon
