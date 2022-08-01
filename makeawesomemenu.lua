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
----------------------------------------
-- FUNCTIONS
----------------------------------------

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
    f:close()
    pretty.dump(props)
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
