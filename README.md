# AwesomeWM Dotfiles

Here is my configuration for AwesomeWM.

For a video of the output: [YouTube Link](https://www.youtube.com/watch?v=YmlSYy_2CRY).

### Requirements

(1) [AwesomeWM](https://awesomewm.org/)
(2) [Lain](https://github.com/lcpz/lain) widgets
(3) [bwm-ng](https://www.gropp.org/?id=projects&sub=bwm-ng) for the bandwidth monitor; if using wifi it presupposed you're using [iwd](https://iwd.wiki.kernel.org/), but could be changed.
(4) [mpd](https://www.musicpd.org/) with [mpc](https://www.musicpd.org/clients/mpc/) for the music widget
(5) [clipmenu](https://github.com/cdown/clipmenu) and [rofi](https://github.com/davatorium/rofi) for the clipboard widget
(6) [wezterm](https://wezfurlong.org/wezterm/) is the default terminal and [neovim](https://neovim.io/) the default editor.

There may be other things. I wasn't really intending to make these public. As is, there are some scripts called when you click things, and Firefox profiles, that won't be available; but hopefully you can modify to suit.

### Recommended but not required

+ [picom-jonaburg-git](https://github.com/jonaburg/picom) for blurring and window animations. Here is [my config](https://gist.github.com/frabjous/84ca0936309d39f9b796875696998acf), which is almost default.
+ My [wezterm config and theme](https://gist.github.com/frabjous/28263aadd401ebca85e693b766537379)
+ My [neovim color scheme](https://gist.github.com/frabjous/c1abf158657bcc3fc30cfeccb80eb5c0)
+ The [Oswald](https://fonts.google.com/specimen/Oswald) and [Clear Sans](https://github.com/intel/clear-sans) fonts, if you wish to use the theme shown in the video.

### Installation

(1) Clone this repo as your `~/.config/awesome` (I.e., `cd ~/.config && git clone git@github.com:frabjous/awesome.git`.)
(2) Copy or symlink the file `netstate-awesome.sh` to somewhere in your `$PATH`.
(3) Create the theme files or symlinks mentioned below.

There are probably other steps I can't quite remember. Let me know if it doesn't work for you and it'll probably come to me.

### Theme files/symlinks

To make it easier to change the color/font theme without affecting the core operability, the dotfiles now rely on two things not tracked in the repository.

The first is a file `currenttheme.lua`. I usually have a symlink in the directory with this name which targets another file on my system. (Since that file is not awesome-specific, it is not included here.) However, if you wished to replicate the color/font theme in the YouTube video above, the contents would be this:

```lua

return {
    accent = "#87afdf",
    brightcolors = {
        black = "#898a8b",
        blue = "#c3d7ef",
        cyan = "#d7efef",
        gray1 = "#97989a",
        gray2 = "#a6a7a9",
        gray3 = "#b4b6b8",
        gray4 = "#c3c5c7",
        gray5 = "#d1d3d6",
        gray6 = "#e0e2e4",
        green = "#d7efc3",
        magenta = "#efd7ef",
        orange = "#fad7b8",
        purple = "#c7ace4",
        red = "#efc3c3",
        white = "#eef1f3",
        yellow = "#ffffd7"
    },
    fontfamily = "Oswald",
    icon_color = "#87afdf",
    icon_theme = "ePapirus",
    monofontfamily = "Fira Code",
    secondary_highlight = "#afdf87",
    themecolors = {
        black = "#131518",
        blue = "#87afdf",
        cyan = "#afdfdf",
        gray1 = "#303236",
        gray2 = "#4d5053",
        gray3 = "#6a6d71",
        gray4 = "#878b8f",
        gray5 = "#a4a8ad",
        gray6 = "#c1c6ca",
        green = "#afdf87",
        magenta = "#dfafdf",
        orange = "#f5af71",
        purple = "#8f5ac9",
        red = "#df8787",
        white = "#dee3e8",
        yellow = "#ffffaf"
    },
    uifontfamily = "Clear Sans"
}
```
Create a file with those or similar contents and create a symlink to it:

```
ln -s $HOME/.config/themes/mytheme.lua $HOME/.config/awesome/currenttheme.lua
```
(Or you could simply populate `currenttheme.lua` with those contents.) Of course, feel free to use different colors or fonts if you prefer.

The second is that there should be another symlink, `icons` that points to one of the subdirectories of the iconthemes subdirectory. To replicate the YouTube video you could do:

```
ln -s $HOME/.config/awesome/iconthemes/myoriginal $HOME/.config/awesome/icons
```
The icons in the different subdirectories are only different in color.

### License

[GPL v3](https://www.gnu.org/licenses/gpl-3.0.en.html)
