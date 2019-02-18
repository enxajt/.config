#!/bin/sh

#xrandr --output DP2 --mode 1600x1200 --above eDP1 # KRC Projector
# 起動時はDPのみ、後にVGA追加
# Ctrl Alt F1 and switch back to (the standard graphical) tty7 with Ctrl Alt F7
xrandr --output eDP1 --mode 1920x1080
xrandr --output DP1 --auto --above   eDP1 --rotate normal
xrandr --output DP2 --auto --right-of DP1 --rotate normal

redshift -O 4200
xsetroot -solid "#000000" # Desktop background

echo 0 | sudo tee /sys/class/leds/dell::kbd_backlight/brightness

STATE=`upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep state`
if [[ "$STATE" == *"discharging"* ]];
then xbacklight -set 1;
else xbacklight -set 10;
fi



syndaemon -i 1 -d -t -K # Disable touchpad while typing
synclient AreaRightEdge=5000 # Disable touchpad right edge
# speed (default=12.5)
xinput set-prop 'SynPS/2 Synaptics TouchPad' 'Device Accel Velocity Scaling' 14
# Acceleration: small is fast
xinput set-prop 'SynPS/2 Synaptics TouchPad' 'libinput Natural Scrolling Enabled' 1
xinput set-prop 'SynPS/2 Synaptics TouchPad' 'libinput Tapping Enabled' 1
xinput set-prop 'SynPS/2 Synaptics TouchPad' 'libinput Tapping Drag Lock Enabled' 1
xinput set-prop 'DELL07E6:00 06CB:76AF Touchpad' 'libinput Natural Scrolling Enabled' 1
xinput set-prop 'DELL07E6:00 06CB:76AF Touchpad' 'libinput Tapping Enabled' 1
xinput set-prop 'DELL07E6:00 06CB:76AF Touchpad' 'libinput Tapping Drag Lock Enabled' 1
xinput set-prop 'DELL07E6:00 06CB:76AF Touchpad' 'libinput Accel Speed' 1

# ~/.xbindkeysrc volume, backlight
xbindkeys

#pavucontrol
#alsamixer
#pulseaudio
amixer -M set Master 0
mvt ~/.config/pulse
pulseaudio -k
pulseaudio --start

#sleep 0.6s
sleep 0.5s
setxkbmap -option "ctrl:swapcaps"



# disable suspend
sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target
# re-enable suspend
#sudo systemctl unmask sleep.target suspend.target hibernate.target hybrid-sleep.target

mvt $home/.local/share/recently-used.xbel

dropbox lansync n
dropbox start
