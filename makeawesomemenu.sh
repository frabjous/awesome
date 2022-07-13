#!/bin/bash
mkdir -p $HOME/.config/awesome

if [ -x /opt/xdg-menu/usr/bin/xdg_menu ] ; then
    /opt/xdg-menu/usr/bin/xdg_menu --format awesome --fullmenu --root-menu /opt/xdg-menu/etc/xdg/menus/arch-applications.menu > $HOME/.config/awesome/xdgmenu.lua
else
    xdg_menu --format awesome > $HOME/.config/awesome/xdgmenu.lua
fi
[ -z "$HOSTNAME" ] && HOSTNAME="unknown"
if [ "$HOSTNAME" = "kck-work" ] || [ "$HOSTNAME" = "kck-home" ] ; then
    sed -i 's|/usr/lib/firefox/firefox|/usr/lib/firefox/firefox -P default|g' $HOME/.config/awesome/xdgmenu.lua
fi
