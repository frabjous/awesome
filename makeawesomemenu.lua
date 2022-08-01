#!/usr/bin/env luajit

require('pl')

local parsed = {}

local menus = {
    Accessories = {},
    Education = {},
    Graphics = {},
    Internet = {},
    Office = {},
    Programming = {},
    ['Sound & Video'] = {},
    ['System Tools'] = {}
}

local desktop_folders = {
    os.getenv("HOME") .. '/.local/share/applications',
    '/usr/share/applications'
}

local importantkeys = {
    'Categories',
    'Name',
    'Exec',
    'Terminal',
    'Icon',
    'NoDisplay'
}

local termcmd='wezterm start --'
----------------------------------------
-- FUNCTIONS
----------------------------------------

function fixedexec(execstr, termstr)
    local rv = ''
    if (termstr == 'true') then
        rv = rv .. termcmd .. ' '
    end
    rv = rv .. execstr:gsub(' %%[A-Za-z]','')
    return rv
end

function handle_desktopfile(desktopfile)
    local props = {}
    local f = io.open(desktopfile)
    for line in f:lines() do
        if (line:match('=')) then
            local linesplit = stringx.split(line,'=',2)
            linekey, lineval = linesplit[1], linesplit[2]
            if ((props[linekey] == nil) and (tablex.find(importantkeys, linekey))) then
                props[linekey] = lineval
            end
        end
    end
    -- skip those with nodisplay
    if ((props.NoDisplay) and (props.NoDisplay == "true")) then
        return
    end
    local newentry = {
        props.Name,
        fixedexec(props.Exec, props.Terminal),
        iconpath(props.Icon)
    }
    if (props.Categories) then
        local mycats = stringx.split(props.Categories,';')
        pretty.dump(mycats)
    end
end


function iconpath(iconname)
    return iconname
end

----------------------------------------
-- ROUTINES
----------------------------------------
for i, folder in ipairs(desktop_folders) do
    local all_desktops = dir.getallfiles(folder, '*.desktop')
    for j, desktopfile in ipairs(all_desktops) do
        basename = path.basename(desktopfile)
        if (tablex.find(parsed, basename) == nil) then
            handle_desktopfile(desktopfile)
            table.insert(parsed, basename)
        end
    end
end
