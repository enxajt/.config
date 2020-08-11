#!/bin/zsh

xinput set-prop 'DELL07E6:00 06CB:76AF Touchpad' 'libinput Natural Scrolling Enabled' 1
xinput set-prop 'DELL07E6:00 06CB:76AF Touchpad' 'libinput Tapping Enabled' 1
xinput set-prop 'DELL07E6:00 06CB:76AF Touchpad' 'libinput Tapping Drag Lock Enabled' 1
xinput set-prop 'DELL07E6:00 06CB:76AF Touchpad' 'libinput Accel Speed' 1

# HP ELITEBOOK
#xinput set-prop 'ALP0018:00 044E:121B Touchpad' 'libinput Natural Scrolling Enabled' 1
#xinput set-prop 'ALP0018:00 044E:121B Touchpad' 'libinput Tapping Enabled' 1
#xinput set-prop 'ALP0018:00 044E:121B Touchpad' 'libinput Tapping Drag Lock Enabled' 1
#xinput set-prop 'ALP0018:00 044E:121B Touchpad' 'libinput Accel Speed' 1

sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target # disable suspend
#sudo systemctl unmask sleep.target suspend.target hibernate.target hybrid-sleep.target # re-enable suspend

rm $HOME/.local/share/recently-used.xbel

echo "\n# dropbox"
dropbox lansync n
dropbox start

echo "\n# xrandr"
xrandr --output eDP1 --mode 1920x1080
xrandr --output DP1 --auto --above eDP1 --rotate normal # Kuya-A, KRC40C
xrandr --output DP2 --auto --left-of DP1 --rotate left # Kuya-A, KRC40C
#xrandr --output DP1 --auto --above eDP1 --rotate normal # Kuya-B, KRC
#xrandr --output DP2 --auto --left-of DP1 --rotate left # Kuya-B
#xrandr --output DP2 --auto --right-of DP1 --rotate normal # KRC Princeton
xsetroot -solid "#000000" # Desktop background
#feh --bg-center $HOME/enx/log/enx-分類/DL/Art/Manabu_Ikeda_Rebirth.jpg
xset s 900 # 15m screensaver idling seconds

echo "\n# redshift, desktop background, kbd_backlight"
redshift -O 4200
echo 0 | sudo tee /sys/class/leds/dell::kbd_backlight/brightness

echo "\n# backlight"
STATE=`upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep state`
if [[ "$STATE" = *"discharging"* ]];
then xbacklight -set 1;
else xbacklight -set 10;
fi

echo "\n# key bind"
xbindkeys # ~/.xbindkeysrc volume, backlight
sleep 0.4s
setxkbmap -option "ctrl:swapcaps"

sleep 1s
#alsamixer
echo "# pulseaudio restart"
pulseaudio -k
pulseaudio --start
echo "\n# pavucontrol 0"
VOLUME='0'; for SINK in `pacmd list-sinks | grep 'index:' | cut -b12-`; do; pactl set-sink-volume $SINK $VOLUME; done;
rm -R ~/.config/pulse
