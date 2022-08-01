#!/usr/bin/env luajit

require('pl')

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

for i, folder in ipairs(desktop_folders) do
    local all_desktops = dir.getallfiles(folder, '*.desktop')
    pretty.dump(all_desktops)
end
