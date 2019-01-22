#!/bin/sh

# ~/.xbindkeysrc volume, backlight
xbindkeys

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


redshift -O 4200

mvt $home/.local/share/recently-used.xbel

#pavucontrol
#pulseaudio
#amixer
mvt ~/.config/pulse
pulseaudio -k
pulseaudio --start

#sleep 1s
sleep 0.6s
setxkbmap -option "ctrl:swapcaps"

#xrandr --output DP2 --mode 1600x1200 --above eDP1 # KRC Projector

xrandr --output eDP1 --mode 1920x1080 #KRC
xrandr --output DP1 --mode 2560x1440 --above eDP1
xrandr --output DP2 --mode 1280x1024 --right-of DP1

xrandr --output eDP1 --mode 1920x1080 #KRC
xrandr --output DP2 --mode 2560x1440 --above eDP1
xrandr --output DP1 --mode 1280x1024 --right-of DP2

xrandr --output eDP1 --mode 1920x1080 #kuya
xrandr --output DP1 --mode 2560x1440 --above eDP1

#Acer@Kuya miniDisplayPort
#xrandr --newmode "2560x1440R" 241.50 2560 2608 2640 2720 1440 1443 1448 1481 +hsync -vsync
#xrandr --addmode HDMI1 2560x1440R
#xrandr --output eDP1 --mode 1920x1080 --output HDMI1 --mode 2560x1440R --above eDP1

xsetroot -solid "#000000"

dropbox lansync n
dropbox start

# disable suspend
sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target
# re-enable suspend
#sudo systemctl unmask sleep.target suspend.target hibernate.target hybrid-sleep.target

# working 2018.11.14.
sudo apt-get update 
sudo apt-get upgrade -y 
sudo apt-get autoremove -y
sudo apt-get dist-upgrade -y

udisksctl unlock -b /dev/sda && udisksctl mount -b /dev/dm-3
