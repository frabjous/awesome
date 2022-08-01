#!/usr/bin/env luajit

require('pl')

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

function categoryicon(cat)
    -- TODO
    return cat
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
    -- TODO
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

pretty.dump(menus)


