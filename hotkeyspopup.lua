------------------------------
-- My other hotkey helpers ---
------------------------------
local hotkeys_popup = require("awful.hotkeys_popup.widget")
local gtable = require("gears").table

-- modifier abbreviations
local alt   = 'Mod1'
local ctrl  = 'Control'
local shift = 'Shift'
local super = 'Mod4'

local myhotkeys = {
    -- note: bash is same as ion
    bash = {
        abbrev = 'b',
        rules = { name = { 'wezterm' } },
        modsets = {
            {
                modifiers = { alt },
                keys = {
                    -- ion only ['a>h'] = 'history',
                    -- ion only ['a>s'] = 'set',
                    b = 'back word',
                    f = 'forward word',
                    bsp = 'del word ←',
                    ['.'] = 'cycle arg',
                    r = 'clear line',
                    d = 'del word →'-- bash only
                }
            },
            {
                modifiers = { ctrl },
                keys = {
                    a = 'start of line',
                    b = 'back char',
                    c = 'interrupt',
                    d = 'eof/del',
                    e = 'end of line',
                    f = 'forward char',
                    h = 'backspace',
                    k = 'clear to end',
                    l = 'clear screen',
                    n = 'next cmd',
                    p = 'prev cmd',
                    r = 'search history ↑',
                    s = 'search history ↓',
                    u = 'clear to start',
                    w = 'del word ←',
                    y = 'paste deleted',--bash only
                    -- ion only? x = 'undo',
                    z = 'pause',
                    left = 'word ←',--bash only
                    right = 'word →'--bash only
                }
            }
        }
    },
    firefox = {
        abbrev = 'ff',
        rules  = {
            class = { 'Firefox', 'firefox' },
            name = { 'Firefox' }
        },
        modsets = {
            {
                modifiers     = {},
                keys = {
                    ['backspace'] = 'back',
                    ['F5']        = 'refresh',
                    ['F6']        = 'address bar',
                    ['F11']       = 'full screen',
                    ['esc']       = 'stop',
                    ['home']      = 'top',
                    ['end']       = 'bottom',
                    ['tab']       = 'next input'
                }
            },
            {
                modifiers = { alt },
                keys = {
                    d         = 'address bar',
                    ['left']  = 'back',
                    ['right'] = 'forward',
                    ['home']  = 'home',
                    ['1..9']  = 'go to tab',
                    ['enter'] = 'save focused link',
                    ['down']  = 'next search engine',
                    ['up']    = 'prev search engine'
                }
            },
            {
                modifiers = { ctrl },
                keys = {
                    b         = 'bookmarks sidebar',
                    d         = 'bookmark',
                    h         = 'history',
                    i         = 'page info',
                    j         = 'focus address bar',
                    k         = 'focus address bar',
                    l         = 'focus address bar',
                    m         = '(un)mute',
                    o         = 'open file',
                    r         = 'reload',
                    t         = 'new tab',
                    u         = 'page source',
                    w         = 'close tab',
                    ['tab']   = 'next tab',
                    ['F5']    = 'hard reload',
                    ['up']    = 'top',
                    ['down']  = 'bottom',
                    ['left']  = 'word left',
                    ['right'] = 'word right',
                    ['+']     = 'zoom in',
                    ['-']     = 'zoom out',
                    ['0']     = 'reset zoom',
                    ['enter'] = 'open in new tab'
                }
            },
            {
                modifiers = { ctrl, shift },
                keys = {
                    b       = 'bookmarks toolbar',
                    c       = 'inspector',
                    e       = 'network',
                    j       = 'browser console',
                    m       = 'resp design mode',
                    n       = 'reopen window',
                    p       = 'private tab',
                    r       = 'hard reload',
                    t       = 'reopen tab',
                    y       = 'downloads',
                    a       = 'add ons',
                    i       = 'dev tools',
                    k       = 'web console',
                    ['tab'] = 'previous tab',
                    ['del'] = 'clear recent history',
                    w       = 'close window'
                }
            },
            {
                modifiers = { shift },
                keys = {
                    ['backspace'] = 'forward',
                    ['tab']       = 'focus prev',
                    ['F7']        = 'style editor',
                    ['F10']       = 'context menu',
                    ['F5']        = 'profiler'
                }
            }
        }
    },
    kitty = {
        abbrev = 'k',
        rules = { class = { 'kitty' } },
        modsets = {
            {
                modifiers = { ctrl },
                keys = {
                    v = 'paste',
                    c = 'copy or interrupt'
                }
            },
            {
                modifiers = { ctrl, shift },
                keys = {
                    up        = 'line up',
                    down      = 'line down',
                    pageup    = 'page up',
                    pagedown  = 'page down',
                    home      = 'top',
                    enter     = 'new window',
                    n         = 'new os window',
                    w         = 'close window',
                    [']']     = 'next window',
                    ['[']     = 'prev window',
                    f         = 'move window forw',
                    b         = 'move window back',
                    ['`']     = 'move to top',
                    ['F7']    = 'focus window',
                    ['F8']    = 'swap window',
                    ['0..9']  = 'go to window #',
                    ['end']   = 'bottom',
                    z         = 'previous prompt',
                    x         = 'next prompt',
                    h         = 'browse scrollback',
                    g         = 'browse last cmd',
                    t         = 'new tab',
                    q         = 'close tab',
                    right     = 'next tab',
                    left      = 'previous tab',
                    l         = 'next layout',
                    ['.']     = 'move tab forward',
                    [',']     = 'move tab back',
                    ['=']     = 'increase font',
                    ['-']     = 'decrease font',
                    backspace = 'reset font',
                    ['F11']   = 'fullscreen',
                    ['F10']   = 'maximize',
                    u         = 'unicode chars',
                    e         = 'open url',
                    del       = 'reset terminal',
                    ['F5']    = 'reload kitty.conf',
                    ['F6']    = 'debug kitty.conf',
                    o         = 'pipe selection',
                    ['F2']    = 'edit kitty.conf',
                    esc       = 'kitty shell',
                    ['a>m']   = 'increase opacity',
                    ['a>l']   = 'decrease opacity',
                    ['a>1']   = 'full opacity',
                    ['a>d']   = 'reset opacity'
                }
            },
            {
                modifiers = { ctrl, shift, alt },
                keys = {
                    t = 'set title'
                }
            }
        }
    },
    qutebrower = {
        abbrev = 'qb',
        rules = { class = { 'qutebrowser' } },
        modsets = {
            {
                modifiers = { },
                keys = {
                    ['F11'] = 'fullscreen',
                    ['F5']  = 'reload',
                    ['F2']  = 'tab-1',
                    ['F3']  = 'tab+1',
                    ins     = 'insert mode'
                }
            },
            {
                modifiers = { alt },
                keys = {
                    ['1..9'] = 'tab #',
                    left     = 'back',
                    right    = 'forward',
                    tab      = 'next tab',
                    ['d>%d'] = 'download',
                    ['d>x']  = 'cancel dl',
                    ['d>c']  = 'clear dl',
                    b        = 'add qmark',
                    l        = 'load qmark',
                    g        = 'load bmark tab',
                    h        = 'hint',
                    w        = 'detach tab',
                    s        = 'view source',
                    a        = 'caret mode',
                    j        = 'jump to mark',
                    m        = 'set mark',
                    space    = 'open'
                }
            },
            {
                modifiers = { alt, ctrl },
                keys = {
                    a    = 'caret line',
                    b    = 'auto qmark',
                    g    = 'scroll perc',
                    i    = 'private',
                    p    = 'print now',
                    s    = 'pin tab',
                    tab  = 'focus last tab',
                    home = 'homepage'
                }
            },
            {
                modifiers = { alt, ctrl, shift },
                keys = {
                    w   = 'tab close to prev',
                    q   = 'quit save state',
                    tab = 'clone tab'
                }
            },
            {
                modifiers = { alt, shift },
                keys = {
                    ['b>b'] = 'bmark list jump',
                    ['b>q'] = 'bmark list',
                    tab     = 'prev tab',
                    ['%']   = 'focus tab',
                    u       = 'nav up',
                    ['1']   = 'move tab',
                    left    = 'back new window',
                    right   = 'fwd new window',
                    s       = 'save session'
                }
            },
            {
                modifiers = { ctrl },
                keys = {
                    ['[']    = 'nav prev',
                    [']']    = 'nav next',
                    ['=']    = 'zoom in',
                    ['+']    = 'zoom in',
                    ['-']    = 'zoom out',
                    ['0']    = 'zoom reset',
                    b        = 'add qmark',
                    d        = 'close tab',
                    f        = 'search',
                    g        = 'search next',
                    e        = 'cmd mode',
                    i        = 'dev tools',
                    k        = 'change url',
                    l        = 'load qmark',
                    o        = 'open',
                    p        = 'print prev',
                    q        = 'close tab',
                    t        = 'new tab',
                    w        = 'close tab',
                    y        = 'yank url',
                    z        = 'reopen tab',
                    ['n>a']  = 'arch forums',
                    ['n>t']  = 'tex SE',
                    ['n>u']  = 'unix SE',
                    ['n>b']  = 'ask ubuntu',
                    ['n>r']  = 'reddit',
                    ['h>i']  = 'hint images',
                    ['h>a']  = 'hint image tab',
                    ['h>o']  = 'hint open',
                    ['h>c']  = 'hint new tab',
                    ['h>r']  = 'hint rapid',
                    ['h>g']  = 'hint pr yank',
                    ['h>b']  = 'hint bgtab',
                    ['h>d']  = 'hint dl',
                    ['h>f']  = 'hint tabs',
                    ['h>e']  = 'hint rapid bg tab',
                    ['h>t']  = 'hint inputs',
                    ['h>t']  = 'hint yank url',
                    ['h>^h'] = 'hint',
                    ['F4']   = 'stop',
                    ['F5']   = 'hard reload',
                    pgup     = 'prev tab',
                    pgdn     = 'next tab',
                    esc      = 'passthrough',
                    space    = 'follow',
                    left     = 'back',
                    right    = 'forward',
                    bksp     = 'back',
                    tab      = 'next tab',
                    enter    = 'open window'
                },
                {
                    modifiers = { ctrl, shift },
                    keys = {
                        ['F5'] = 'repeat cmd',
                        a      = 'nav +',
                        b      = 'bmark add',
                        e      = 'edit text',
                        f      = 'search up',
                        g      = 'prev search',
                        l      = 'qmark tab load',
                        o      = 'open new tab',
                        q      = 'close',
                        s      = 'follow new tab',
                        w      = 'close',
                        x      = 'nav −',
                        z      = 'reopen window',
                        tab    = 'prev tab',
                        ['{']  = 'move tab left',
                        ['}']  = 'move tab right'
                    }
                },
                {
                    modifiers = { shift },
                    keys = {
                        bksp   = 'back',
                        ['F5'] = 'hard reload'
                        --left   = 'scroll left',
                        --right  = 'scroll right',
                        --up     = 'scroll up',
                        --down   = 'scroll down'
                    }
                }
            },
        }
    },
    neovim = {
        abbrev = 'nv',
        rules = { name = { 'nvim' } },
        modsets = {
            {
                modifiers = {},
                keys = {
                    ['Tab'] = 'indent/autocomplete',
                    ['F1']  = 'fzf help search',
                    ['F2']  = 'show syntax',
                    ['F3']  = 'switch window',
                    ['F5']  = 'knap refresh',
                    ['F6']  = 'close viewer',
                    ['F7']  = 'toggle autopreview',
                    ['F8']  = 'synctex forward'
                }
            },
            {
                modifiers = { alt },
                keys = {
                    a        = 'restore selection',
                    b        = 'suggest spelling',
                    c        = 'clean LaTeX files',
                    d        = 'dictionary complete',
                    e        = 'show errors',
                    f        = 'filename complete',
                    g        = 'add word to dict.',
                    h        = 'jump last edit',
                    j        = 'jump to mark…',
                    m        = 'set mark…',
                    o        = 'toggle opacity',
                    t        = 'toggle fold',
                    u        = 'unicode/emoji',
                    v        = 'restore selection',
                    x        = 'xelatex check',
                    ['up']   = 'move line up',
                    ['down'] = 'move line down',
                    ['1..4'] = 'insert template',
                    ['5']    = 'match paren',
                    ['9']    = 'prev sentence',
                    ['0']    = 'next sentence',
                    ['(']    = 'prev sentence',
                    [')']    = 'next sentence',
                    ['=']    = 'increase num',
                    ['-']    = 'decrease num',
                    ['.']    = 'indent',
                    [',']    = 'unindent',
                    ['[']    = 'prev paragraph',
                    [']']    = 'next paragraph',
                    ['{']    = 'prev paragraph',
                    ['}']    = 'next paragraph',
                    ['tab']  = 'next tab',
                    ['/']    = 'toggle comments'
                }
            },
            {
                modifiers = { alt, ctrl },
                keys = {
                    c = 'colorschemes',
                    t = 'fzf open (home)'
                }
            },
            {
                modifiers = { alt, shift },
                keys = {
                    q        = 'force quit',
                    ['end']  = 'select to end',
                    ['home'] = 'select to start',
                    ['tab']  = 'previous tab'
                }
            },
            {
                modifiers = { ctrl },
                keys = {
                    a         = 'select all',
                    b         = 'clear highlights',
                    c         = 'copy/copy line',
                    d         = 'duplicate line',
                    e         = 'command mode',
                    f         = 'find',
                    g         = 'find next',
                    h         = 'jump last edit',
                    j         = 'join lines',
                    k         = 'kill remainder',
                    l         = 'get citation key',
                    n         = 'normal mode',
                    q         = 'quit',
                    r         = 'replace',
                    s         = 'save',
                    t         = 'fzf open (cwd)',
                    u         = 'unicode/emoji',
                    v         = 'paste',
                    w         = 'toggle wrap',
                    x         = 'cut/cut line',
                    y         = 'redo',
                    z         = 'undo',
                    ['space'] = 'omnicomplete',
                    ['up']    = 'put line above',
                    ['down']  = 'put line below',
                    ['\\']    = 'pipe selection',
                    ['ins']   = 'copy',
                    ['tab']   = 'next tab'
                }
            },
            {
                modifiers = { ctrl, shift },
                keys = {
                    ['tab'] = 'previous tab'
                }
            },
            {
                modifiers = { shift },
                keys = {
                    ['tab']    = 'autoindent selection',
                    ['del']    = 'cut',
                    ['insert'] = 'paste',
                    ['F1']     = 'prev tab',
                    ['F2']     = 'next tab'
                }
            }
        }
    },
    sioyek = {
        abbrev = 's',
        rules  = { class = { 'sioyek' } },
        modsets = {
            {
                modifiers = {},
                keys = {
                    b             = 'bookmark',
                    c             = 'dark mode',
                    db            = 'delete bookmark',
                    dh            = 'delete highlight',
                    dp            = 'delete portal',
                    f             = 'open link',
                    gb            = 'goto bookmark',
                    gB            = 'search bookmarks',
                    gg            = 'first page',
                    gh            = 'goto highlight',
                    gc            = 'next chapter',
                    gC            = 'prev chapter',
                    h             = 'move left',
                    j             = 'move down',
                    k             = 'move up',
                    l             = 'move right',
                    m             = 'set mark',
                    n             = 'custom color',
                    o             = 'open file',
                    p             = 'create portal',
                    q             = 'quit',
                    sl            = 'external search',
                    ss            = 'external search',
                    t             = 'contents',
                    v             = 'ref preview',
                    w             = 'fit width',
                    y             = 'pop state',
                    ['home']      = 'beginning',
                    [',']         = 'add highlight…',
                    ['=']         = 'zoom in',
                    ['-']         = 'zoom out',
                    ['F4']        = 'synctex mode',
                    ['F5']        = 'presentation mode',
                    ['F7']        = 'toggle visual scroll',
                    ['F8']        = 'synctex mode',
                    ['F9']        = 'margins fit width',
                    ['F10']       = 'fit width',
                    ['space']     = 'screen down',
                    ['backspace'] = 'history back',
                    ['`']         = 'goto mark',
                    [']']         = 'def portal',
                    [':']         = 'command mode'
                }
            },
            {
                modifiers = { alt },
                keys = {
                    ['right'] = 'history forward',
                    ['left']  = 'history back',
                    m         = 'set mark…',
                    j         = 'jump to mark…'
                }
            },
            {
                modifiers = { ctrl },
                keys = {
                    ['=']     = 'zoom in',
                    c         = 'copy',
                    f         = 'find',
                    g         = 'find next',
                    o         = 'browse files',
                    ['left']  = 'history back',
                    ['right'] = 'history forward',
                    [']']     = 'goto def'
                }
            },
            {
                modifiers = { shift, ctrl },
                keys = {
                    ['+'] = 'zoom in',
                    ['-'] = 'zoom out',
                    ['o'] = 'browse folder'
                }
            },
            {
                modifiers = { shift },
                keys = {
                    g             = 'last page',
                    q             = 'quit',
                    p             = 'edit portal',
                    ['+']         = 'zoom in',
                    ['-']         = 'zoom out',
                    ['o']         = 'open recent',
                    ['space']     = 'screen up',
                    ['backspace'] = 'history forward'
                }
            }
        }
    },
    wezterm = {
        abbrev = "w",
        rules = { class = { 'org.wezfurlong.wezterm' } },
        modsets = {
            {
                modifiers = {},
                keys = {
                    ['caps>c']     = 'copy',
                    ['caps>f']     = 'search',
                    ['caps>h']     = 'hor. split',
                    ['caps>k']     = 'clear scrollback',
                    ['caps>q']     = 'quick select',
                    ['caps>t']     = 'new tab',
                    ['caps>v']     = 'paste',
                    ['caps>w']     = 'close pane',
                    ['caps>x']     = 'copy mode',
                    ['caps>z']     = 'zoom pane',
                    ['caps>space'] = 'launcher',
                    ['caps>1..5']  = 'focus tab #',
                    ['caps>0']     = 'reset font size',
                    ['caps>enter'] = 'new window',
                    ['caps>F5']    = 'reload config',
                    ['caps>F11']   = 'fullscreen',
                    ['caps>\\']    = 'vert split',
                    ['caps>|']     = 'vert split',
                    ['caps>-']     = 'decrease font',
                    ['caps>=']     = 'increase font',
                    ['caps>+']     = 'increase font',
                    ['caps>tab']   = 'next tab',
                    ['caps>]']     = 'next tab',
                    ['caps>[']     = 'prev tab',
                    ['caps>pgup']  = 'scroll up',
                    ['caps>pgdn']  = 'scroll down',
                    ['caps>→']     = 'focus right',
                    ['caps>←']     = 'focus left',
                    ['caps>↑']     = 'focus up',
                    ['caps>↓']     = 'focus down'
                }
            },
            {
                modifiers = { ctrl },
                keys = {
                    c     = 'copy',
                    v     = 'paste',
                    ['0'] = 'reset font',
                    ins   = 'copy',
                    ['-'] = 'decrease font',
                    ['='] = 'increase font',
                    ['+'] = 'increase font'
                }
            },
            {
                modifiers = { ctrl, shift },
                keys = {
                    c = 'copy',
                    v = 'paste'
                }
            },
            {
                modifiers = { shift },
                keys = {
                    ins          = 'paste',
                    pgup         = 'scroll up',
                    pgdn         = 'scroll down',
                    ['caps>F']   = 'regex search',
                    ['caps>K']   = 'clear',
                    ['caps>T']   = 'new default tab',
                    ['caps>Tab'] = 'prev tab',
                    ['caps>→']   = 'resize right',
                    ['caps>←']   = 'resize left',
                    ['caps>↑']   = 'resize up',
                    ['caps>↓']   = 'resize down'
                }
            }
        }
    }
}

function togroups(aggregate)
    local groups = {}
    local rules = {}
    for app, appset in pairs(myhotkeys) do
        local abbrev = appset.abbrev
        if not (appset.modsets) or (#appset.modsets == 0) then
            return {}, {}
        end
        for _, modset in ipairs(appset.modsets) do
            -- determine group name from modifiers
            local gname = ''
            if (gtable.hasitem(modset.modifiers, alt)) then
                gname = gname .. 'Alt'
            end
            if (gtable.hasitem(modset.modifiers, ctrl)) then
                if (gname ~= '') then
                    gname = gname .. '-'
                end
                gname = gname .. 'Ctrl'
            end
            if (gtable.hasitem(modset.modifiers, shift)) then
                if (gname ~= '') then
                    gname = gname .. '-'
                end
                gname = gname .. 'Shift'
            end
            if (gtable.hasitem(modset.modifiers, super)) then
                if (gname ~= '') then
                    gname = gname .. '-'
                end
                gname = gname .. 'Super'
            end
            if (gname == '') then gname = "Normal" end
            if not (aggregate) then
                gname = gname .. ' – ' .. app
            end
            -- create a rule with that name in output
            rules[gname] = rules[gname] or { rule_any = appset.rules }
            -- create a group with that name in output
            groups[gname] = groups[gname] or {}
            if (not(groups[gname][1])) then
                table.insert(groups[gname],{})
            end
            -- set modifiers
            groups[gname][1].modifiers = groups[gname][1].modifiers
                or modset.modifiers
            -- either add to keys or start new keys table
            groups[gname][1].keys = groups[gname][1].keys or {}
            if (modset.keys) then
                -- iterate over keys in modset
                for k, v in pairs(modset.keys) do
                    -- start with empty string
                    if not (groups[gname][1].keys[k]) then
                        groups[gname][1].keys[k] = ''
                    else
                        groups[gname][1].keys[k] =
                            groups[gname][1].keys[k] .. '/'
                    end
                    -- add this app's binding
                    groups[gname][1].keys[k] =
                        groups[gname][1].keys[k] .. v
                    -- add abbreviation
                    if (abbrev) and (aggregate) then
                        groups[gname][1].keys[k] = groups[gname][1].
                            keys[k] ..' (' .. abbrev .. ')'
                    end
                end
            end
        end
    end
    return groups, rules
end
local myhotkeygroups, myhotkeyrules = togroups()

-- add rules
for gname, grules in pairs(myhotkeyrules) do
    hotkeys_popup.add_group_rules(gname,grules)
end

-- add key listings
hotkeys_popup.add_hotkeys(myhotkeygroups)

return hotkeys_popup
