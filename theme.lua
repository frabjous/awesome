---------------------------
-- Custom awesome theme  --
---------------------------

--local theme_assets = require("beautiful.theme_assets")
local xresources   = require("beautiful.xresources")
local dpi          = xresources.apply_dpi
local gfs          = require("gears.filesystem")
local themes_path  = gfs.get_themes_dir()
local iconpath     = os.getenv("HOME") .. "/.config/awesome/icons/"
local theme = {}

theme.kckcolors = {
  black   = "#131518",
  gray1   = "#303236",
  gray2   = "#4d5053",
  gray3   = "#6a6d71",
  gray4   = "#878b8f",
  gray5   = "#a4a8ad",
  gray6   = "#c1c6ca",
  white   = "#dee3e8",
  red     = "#df8787",
  orange  = "#f5af71",
  yellow  = "#ffffaf",
  green   = "#afdf87",
  cyan    = "#afdfdf",
  blue    = "#87afdf",
  purple  = "#8f5ac9",
  magenta = "#dfafdf"
}

-- main settings
theme.font          = "Oswald 10"
theme.medfont       = "Oswald 11"
theme.largerfont    = "Sans 12"

theme.bg_normal     = theme.kckcolors.gray1
theme.bg_focus      = theme.kckcolors.black
theme.bg_urgent     = theme.kckcolors.red
theme.bg_minimize   = theme.kckcolors.gray3
theme.bg_systray    = theme.bg_normal

theme.fg_normal     = theme.kckcolors.gray6
theme.fg_focus      = theme.kckcolors.white
theme.fg_urgent     = theme.kckcolors.white
theme.fg_minimize   = theme.kckcolors.gray5

theme.useless_gap   = dpi(0)
theme.border_width  = dpi(3)
theme.border_normal = theme.kckcolors.black
theme.border_focus  = theme.kckcolors.blue
theme.border_marked = theme.kckcolors.orange

-- Generate Awesome icon:
--theme.awesome_icon = theme_assets.awesome_icon(
--    theme.menu_height, theme.bg_focus, theme.fg_focus
--    theme.menu_height, theme.kckcolors.green, theme.bg_normal
--)
theme.awesome_icon = os.getenv("HOME") ..
    '/.config/awesome/icons/awesome.png'

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
-- theme.icon_theme = nil
theme.icon_theme = 'ePapirus'

-- set master width factor
theme.master_width_factor = 0.6


-- kck additions: main categories

-- main theme highlight
theme.accent              = theme.kckcolors.blue
theme.secondary_highlight = theme.kckcolors.green
theme.icon_color          = theme.accent

-- update status
theme.all_ok              = theme.kckcolors.green

-- mpd artist, update postpone
theme.info_color = theme.kckcolors.yellow

-- critical wibox icons
theme.fg_alert = theme.kckcolors.red

-- clipboard icon, should be silverish?
theme.clipboard_icon = theme.kckcolors.gray6

-- dropdown icons
theme.dropdown_icon = theme.kckcolors.gray6

-- powerline and other separators
theme.separator_color  = theme.kckcolors.gray3
theme.separator_accent = theme.kckcolors.black

-- calendar day boxes
theme.cal_days = theme.kckcolors.gray5

---- end kck additions

-- TAGLIST
theme.taglist_fg_occupied = theme.kckcolors.black
theme.taglist_bg_occupied = theme.bg_normal
theme.taglist_fg_empty    = theme.kckcolors.gray1
theme.taglist_bg_empty    = theme.kckcolors.gray4
theme.taglist_fg_focus    = theme.kckcolors.black
theme.taglist_bg_focus    = theme.bg_normal
theme.taglist_fg_urgent   = theme.kckcolors.red
theme.taglist_bg_urgent   = theme.kckcolors.red

-- square to add to occupied tags (not used)
theme.taglist_squares_sel   = iconpath .. "squarez.png"
theme.taglist_squares_unsel = iconpath .. "squarefz.png"
-- resize taglist squares
theme.taglist_squares_resize = true

-- begin kckadditions
theme.taglist_shape               = theme.kckcolors.black
theme.taglist_shape_border        = theme.kckcolors.gray4
theme.taglist_shape_border_focus  = theme.accent
theme.taglist_index_empty         = theme.kckcolors.gray5
theme.taglist_index_occupied      = theme.kckcolors.white
theme.taglist_bg_hover            = theme.accent
-- end kckadditions

-- TASKLIST
theme.tasklist_fg_normal                    = theme.kckcolors.gray5
theme.tasklist_bg_normal                    = theme.kckcolors.black
theme.tasklist_bg_minimize                  = theme.bg_normal
theme.tasklist_fg_minimize                  = theme.kckcolors.gray4
theme.tasklist_icon_color_minimize          = theme.kckcolors.gray5
theme.tasklist_bg_focus                     = theme.kckcolors.black
theme.tasklist_fg_focus                     = theme.kckcolors.white
theme.tasklist_bg_urgent                    = theme.kckcolors.red
theme.tasklist_fg_urgent                    = theme.kckcolors.black
theme.tasklist_shape_border_color_focus     = theme.kckcolors.blue
theme.tasklist_shape_border_color_minimized = theme.kckcolors.black
theme.tasklist_shape_border_color_urgent    = theme.kckcolors.yellow
theme.tasklist_align                        = "center"

-- background on hover
theme.tasklist_bg_hover    = theme.kckcolors.blue
theme.tasklist_icon_hover  = theme.kckcolors.white
theme.tasklist_text_hover  = theme.kckcolors.black
-- color of small icons next to name for special windows
theme.tasklist_extra_info  = theme.kckcolors.gray3

-- disable additions to task names (reimplement my own?)
theme.tasklist_plain_task_name = true

-- begin kck additions
theme.tasklist_shape_border = theme.kckcolors.gray4
-- end kck additions

-- switcher tasklist
theme.switcher_border_color      = theme.kckcolors.cyan
theme.switcher_bg                = theme.kckcolors.gray5
theme.switcher_item_focus_border = theme.kckcolors.green
theme.switcher_font              = "Oswald 20"
theme.switcher_fg_focus          = theme.kckcolors.green

-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- prompt_[fg|bg|fg_cursor|bg_cursor|font]
theme.prompt_font = "Fira Code 12"
-- hotkeys_[bg|fg|border_width|border_color|shape|opacity|modifiers_fg|
--     label_bg|label_fg|group_margin|font|description_font]

-- Variables set for theming notifications:
-- notification_[bg|fg]
-- notification_[width|height|margin]
-- notification_[border_color|border_width|shape|opacity]

theme.notification_bg           = theme.kckcolors.black
theme.notification_font         = "Oswald 16"
theme.notification_border_color = theme.notification_bg
theme.notification_border_width = 0
theme.notification_shape        = gears.shape.rounded_bar
theme.notification_margin       = 30
theme.notification_opacity      = 0.6
--theme.notification_border_width = 8

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = themes_path.."default/submenu.png"
theme.menu_height = dpi(20)
theme.menu_width  = dpi(200)

-- Icons for titlebar; don't matter much
theme.titlebar_close_button_normal =
    themes_path.."default/titlebar/close_normal.png"
theme.titlebar_close_button_focus =
    themes_path.."default/titlebar/close_focus.png"
theme.titlebar_minimize_button_normal =
    themes_path.."default/titlebar/minimize_normal.png"
theme.titlebar_minimize_button_focus =
    themes_path.."default/titlebar/minimize_focus.png"
theme.titlebar_ontop_button_normal_inactive =
    themes_path.."default/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive =
    themes_path.."default/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active =
    themes_path.."default/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active =
    themes_path.."default/titlebar/ontop_focus_active.png"
theme.titlebar_sticky_button_normal_inactive =
    themes_path.."default/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive =
    themes_path.."default/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active =
    themes_path.."default/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active =
    themes_path.."default/titlebar/sticky_focus_active.png"
theme.titlebar_floating_button_normal_inactive =
    themes_path.."default/titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive =
    themes_path.."default/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active =
    themes_path.."default/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active =
    themes_path.."default/titlebar/floating_focus_active.png"
theme.titlebar_maximized_button_normal_inactive =
    themes_path.."default/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive =
    themes_path.."default/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active =
    themes_path.."default/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active =
    themes_path.."default/titlebar/maximized_focus_active.png"

-- Ignored by new wallpaper function
theme.wallpaper = themes_path.."default/background.png"

-- Use layout icons from zenburn theme, modified by color
theme.layout_fairh      = iconpath .. "fairh.png"
theme.layout_fairv      = iconpath .. "fairv.png"
theme.layout_floating   = iconpath .. "floating.png"
theme.layout_magnifier  = iconpath .. "magnifier.png"
theme.layout_max        = iconpath .. "max.png"
theme.layout_fullscreen = iconpath .. "fullscreen.png"
theme.layout_tilebottom = iconpath .. "tilebottom.png"
theme.layout_tileleft   = iconpath .. "tileleft.png"
theme.layout_tile       = iconpath .. "tile.png"
theme.layout_tiletop    = iconpath .. "tiletop.png"
theme.layout_spiral     = iconpath .. "spiral.png"
theme.layout_dwindle    = iconpath .. "dwindle.png"
theme.layout_cornernw   = iconpath .. "cornernw.png"
theme.layout_cornerne   = iconpath .. "cornerne.png"
theme.layout_cornersw   = iconpath .. "cornersw.png"
theme.layout_cornerse   = iconpath .. "cornerse.png"

return theme
