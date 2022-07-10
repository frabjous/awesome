#!/bin/bash

goodcolor="$1"
badcolor="$2"

# get interface name
interface="none"
cd /sys/class/net
for dev in * ; do
    if [[ "$dev" == "eno1" ]] ; then
        interface="$dev"
        break
    fi
    firsttwo="${dev:0:2}"
    if [[ "$firsttwo" == "wl" ]] || [[ "$firsttwo" == "ww" ]] ; then
        interface="$dev"
        break
    fi
    if [[ "$interface" == "none" ]] ; then
        interface="$dev"
    fi
done

getNetName() {
   iwctl station $interface show | grep "Connected network" | sed 's/.*work\s*//' | sed 's/\s*$//g'
}

getNetNameWPA() {
    wpa_cli list_networks | grep CURRENT | sed -e 's/^[0-9]*\s*//' -e 's/\t.*//'
}

getIp() {
   ip addr show $interface | grep 'inet ' | sed 's/.*inet //' | sed 's:/.*::'
}

globe=''
badicon=''
wifiicon=''
ip="$(getIp)"

if [[ -z "$ip" ]] ; then
   fpart='<span foreground="'$badcolor'"><span font_family="Symbols Nerd Font" font_size="14pt">'$badicon'</span> offline</span>'
   echo -n "$fpart"
   exit 0
fi

if [[ "$firsttwo" == "wl" ]] || [[ "$firsttwo" == "ww" ]] ; then
    # part 1 for wifi
    nn="$(getNetName)"
    if [[ -z "$nn" ]] ; then
        nn="$(getNetNameWPA)"
    fi
    if [[ "$nn" == "castleponies2" ]] ; then
        nn="wifi"
    fi
    first='<span foreground="'$goodcolor'" font_family="Symbols Nerd Font" font_size="14pt">'$wifiicon'</span>'"$nn"
else
    # part 1 for wired
    first='<span foreground="'$goodcolor'" font_family="Symbols Nerd Font" font_size="14pt">'$globe'</span>'"$ip"
fi

second="$(bwm-ng --type avg --output plain --count 1 --dynamic 1 --ansiout | grep 'total:' | sed 's/\s\s*/\t/g' | cut -f 3-6 | sed -E 's/^([0-9]*)\.[0-9]*\t(.*)\t([0-9]*)\.[0-9]*\t(.*)$/<span font_family="Symbols Nerd Font" font_size="14pt" foreground="'$goodcolor'"><\/span>\1\2 <span font_family="Symbols Nerd Font" font_size="14pt" foreground="'$goodcolor'"><\/span>\3\4/g' | sed 's/KB\/s/k/g' | sed 's/MB\/s/m/g' | sed 's/B\/s/b/g')"

echo -n "$first $second"
exit 0
