#!/usr/bin/env luajit

require('pl')

package.path = os.getenv("HOME") .. "/misc/dotfiles/awesome/?.lua;" .. package.path
local icontheme = require("currenttheme").icon_theme

local parsed = {}

local cat_mapping = {
    ["2DGraphics"] = "Graphics",
    ["Audio"] = "Sound & Video",
    ["AudioVideo"] = "Sound & Video",
    ["AudioVideoEditing"] = "Sound & Video",
    ["DesktopSettings"] = "System Tools",
    --["Development"] = "Programming",
    --["Education"] = "Education",
    ["FileManager"] = "Accessories",
    ["FileTools"] = "Accessories",
    ["Filesystem"] = "Accessories",
    ["FlowChart"] = "Graphics",
    ["Graphics"] = "Graphics",
    ["HardwareSettings"] = "System Tools",
    --["Math"] = "Education",
    ["Mixer"] = "Accessories",
    ["Network"] = "Internet",
    ["Office"] = "Office",
    ["Player"] = "Sound & Video",
    ["Presentation"] = "Office",
    ["Printing"] = "System Tools",
    ["Publishing"] = "Office",
    ["RasterGraphics"] = "Graphics",
    ["Recorder"] = "Accessories",
    --["Science"] = "Education",
    ["Settings"] = "System Tools",
    ["Spreadsheet"] = "Office",
    ["System"] = "System Tools",
    ["TV"] = "Sound & Video",
    ["TerminalEmulator"] = "System Tools",
    ["TextEditor"] = "Accessories",
    ["Utility"] = "Accessories",
    ["VectorGraphics"] = "Graphics",
    ["Video"] = "Sound & Video",
    ["WebApps"] = "Internet",
    ["WebBrowser"] = "Internet",
    ["WordProcessor"] = "Office"
}

local menus = {
    {"Accessories", {}},
    --Education = {},
    {"Graphics", {}},
    {"Internet", {}},
    {"Office", {}},
    --Programming = {},
    {"Sound & Video", {}},
    {"System Tools", {}}
}

local desktop_folders = {
    os.getenv("HOME") .. '/.local/share/applications',
    '/usr/share/applications'
}

local iconlocations = {
    os.getenv("HOME") .. "/.local/share/icons/" .. icontheme,
    os.getenv("HOME") .. "/.local/share/icons/hicolor",
    "/usr/share/icons/" .. icontheme,
    "/usr/share/icons/hicolor"
}

local iconsizes = {
    '48x48',
    'scalable',
    '64x64',
    '96x96',
    '128x128',
    '144x144',
    '24x24',
    '32x32',
    '192x192',
    '16x16',
    '256x256',
    '512x512'
}

local iconfolders = {
    'apps',
    'categories',
    'mimetypes',
    'devices'
}

local importantkeys = {
    'Categories',
    'Name',
    'Exec',
    'Terminal',
    'Icon',
    'NoDisplay',
    'OnlyShowIn'
}

local outputfile = os.getenv("HOME") .. "/misc/dotfiles/awesome/xdgmenu.lua"

local termcmd='kitty'
-- local termcmd='wezterm start --'
----------------------------------------
-- FUNCTIONS
----------------------------------------

function categoryicon(cat)
    if (cat == "Accessories") then
        return iconpath('applications-accessories')
    elseif (cat == "Graphics") then
        return iconpath('applications-graphics')
    elseif (cat == "Internet") then
        return iconpath('applications-internet')
    elseif (cat == "Office") then
        return iconpath('applications-office')
    elseif (cat == "Sound & Videos") then
        return iconpath('applications-multimedia')
    elseif (cat == "System Tools") then
        return iconpath('applications-system')
    else
        return iconpath('applications-all')
    end
end

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
    if ((props.OnlyShowIn) and (not(props.OnlyShowIn:match('[Aa]wesome')))) then
        return
    end
    local newentry = {
        props.Name,
        fixedexec(props.Exec, props.Terminal),
        iconpath(props.Icon)
    }
    -- sioyek's categorization is nonsense
    if (props.Name == 'Sioyek') then
        props.Categories = "Office"
    end
    if (props.Categories) then
        local mycats = stringx.split(props.Categories,';')
        local submenus = {}
        for k, cat in ipairs(mycats) do
            if ((cat_mapping[cat]) and
                (tablex.find(submenus,cat_mapping[cat]) == nil)) then
                table.insert(submenus, cat_mapping[cat])
            end
        end
        local lowername = newentry[1]:lower()
        for l, submenu in ipairs(submenus) do
            for n, mgroup in ipairs(menus) do
                if (mgroup[1] == submenu) then
                    local entered = false
                    for m, oldentry in ipairs(mgroup[2]) do
                        local oldlowername = oldentry[1]:lower()
                        if (lowername < oldlowername) then
                            table.insert(mgroup[2], m, newentry)
                            entered = true
                            break
                        end
                    end
                    if (not(entered)) then
                        table.insert(mgroup[2], newentry)
                    end
                    break
                end
            end
        end
    end
end


function iconpath(iconname)
    iconname = iconname or 'application-default-icon'
    local prevext = path.extension(iconname)
    local hasext = ((prevext == ".png") or (prevext == ".svg"))
    local haspath = (iconname:sub(1,1) == '/')
    -- has both, check if it exists
    if (((hasext) and (haspath)) and (path.exists(iconname))) then
        return iconname
    else
        -- doesn't exist; try to look for icon with same basename
        iconname = path.basename(iconname)
        haspath = false
    end
    -- strip extensions
    if (hasext) then
        iconname = iconname:gsub('%.[^%.]*$','')
    end
    local searchexts = { '.svg', '.png' }
    -- look for pngs first if specified as png
    if (prevext == '.png') then
        searchexts = { '.png', '.svg' }
    end
    -- if has path, look there first
    if (haspath) then
        for e, ext in ipairs(searchexts) do
            if path.exists(iconname .. ext) then
                return iconname .. ext
            end
        end
        -- wasn't found; strip path
        iconname = path.basename(iconname)
    end
    for sn, isize in ipairs(iconsizes) do
        for sc, ifldr in ipairs(iconfolders) do
            for p, spath in ipairs(iconlocations) do
                local fullspath = spath .. '/' .. isize .. '/' .. ifldr
                if (path.isdir(fullspath)) then
                    for e, ext in ipairs(searchexts) do
                        local fulliconpath = fullspath .. '/' .. iconname .. ext
                        if (path.exists(fulliconpath)) then
                            return fulliconpath
                        end
                    end
                end
            end
        end
    end
    -- last ditch; look at top level (damn you sioyek!)
    for p, spath in ipairs(iconlocations) do
        local parpath = path.dirname(spath)
        for e, ext in ipairs(searchexts) do
            local fulliconpath = parpath .. '/' .. iconname .. ext
            if (path.exists(fulliconpath)) then
                return fulliconpath
            end
        end
    end
    return iconname
end

----------------------------------------
-- MAIN ROUTINE
----------------------------------------

-- fill in menu group icons
for x, mgroup in ipairs(menus) do
    table.insert(mgroup, categoryicon(mgroup[1]))
end

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

file.write(outputfile, 'xdgmenu = ' .. pretty.write(menus, '    '))


