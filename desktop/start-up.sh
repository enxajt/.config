#!/bin/zsh

xinput set-prop 'DELL07E6:00 06CB:76AF Touchpad' 'libinput Natural Scrolling Enabled' 1
xinput set-prop 'DELL07E6:00 06CB:76AF Touchpad' 'libinput Tapping Enabled' 1
xinput set-prop 'DELL07E6:00 06CB:76AF Touchpad' 'libinput Tapping Drag Lock Enabled' 1
xinput set-prop 'DELL07E6:00 06CB:76AF Touchpad' 'libinput Accel Speed' 1

sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target # disable suspend
#sudo systemctl unmask sleep.target suspend.target hibernate.target hybrid-sleep.target # re-enable suspend

rm $home/.local/share/recently-used.xbel

echo "\n# dropbox"
dropbox lansync n
dropbox start

echo "\n# redshift, desktop background, kbd_backlight"
redshift -O 4200
xsetroot -solid "#000000" # Desktop background
echo 0 | sudo tee /sys/class/leds/dell::kbd_backlight/brightness

echo "\n# xrandr"
#xrandr --output DP2 --mode 1600x1200 --above eDP1 # KRC Projector
xrandr --output eDP1 --mode 1920x1080
xrandr --output DP1 --auto --above   eDP1 --rotate normal
xrandr --output DP2 --auto --right-of DP1 --rotate normal # 起動時はDPのみ、後にVGA追加

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
