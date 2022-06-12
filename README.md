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
(7) The [Oswald font](https://fonts.google.com/specimen/Oswald)

There may be other things. I wasn't really intending to make these public. As is, there are some scripts called when you click things, and Firefox profiles, that won't be available; but hopefully you can modify to suit.

### Recommended but not required

+ [picom-jonaburg-git](https://github.com/jonaburg/picom) for blurring and window animations. Here is [my config](https://gist.github.com/frabjous/84ca0936309d39f9b796875696998acf), which is almost default.
+ My [wezterm config and theme](https://gist.github.com/frabjous/28263aadd401ebca85e693b766537379)
+ My [neovim color scheme](https://gist.github.com/frabjous/c1abf158657bcc3fc30cfeccb80eb5c0)

### Installation

(1) Clone this repo as your `~/.config/awesome` (I.e., `cd ~/.config && git clone git@github.com:frabjous/awesome.git`.)
(2) Copy or symlink the file `netstate-awesome.sh` to somewhere in your `$PATH`.

There are probably other steps I can't quite remember. Let me know if it doesn't work for you and it'll probably come to me.

### License

[GPL v3](https://www.gnu.org/licenses/gpl-3.0.en.html)
