#!/bin/sh

# ~/.xbindkeysrc volume, backlight
xbindkeys

syndaemon -i 1 -d -t -K # Disable touchpad while typing
synclient AreaRightEdge=5000 # Disable touchpad right edge
# speed (default=12.5)
xinput set-prop 'SynPS/2 Synaptics TouchPad' 'Device Accel Velocity Scaling' 14
# Acceleration: small is fast
#xinput set-prop 'SynPS/2 Synaptics TouchPad' 'Device Accel Constant Deceleration' 1.0
# Natural scrolling
xinput set-prop 'SynPS/2 Synaptics TouchPad' 'Synaptics Scrolling Distance' -119 -119
# Horizontal scrolling
xinput set-prop 'SynPS/2 Synaptics TouchPad' 'Synaptics Two-Finger Scrolling' 1 1

redshift -O 4200

mvt $home/.local/share/recently-used.xbel

#pavucontrol
#pulseaudio
#amixer
mvt ~/.config/pulse
pulseaudio -k
pulseaudio --start

sleep 1s
setxkbmap -option "ctrl:swapcaps"
#setxkbmap -option "swapcaps:ctrl"

#xrandr --output eDP1 --mode 1920x1080 --output DP1 --auto --above eDP1 #VGA@KRC
#xrandr --output eDP-1 --mode 1920x1080 --output HDMI-2 --auto --above eDP-1 #projector extend
#xrandr --output eDP-1 --mode 1920x1080 --output HDMI-2 --auto --same-as eDP-1 #projector duplicate
#xrandr --output eDP1 --mode 1920x1080 --output HDMI1 --mode 1920x1080 --rotate normal --above eDP1
#xrandr --output eDP1 --mode 1920x1080 --pos 0x0 --rotate normal --output HDMI1 --mode 1920x1080 --rotate normal --above eDP1
xrandr --output eDP1 --mode 1920x1080 

#Acer@Kuya HDMI-direct
xrandr --output eDP1 --mode 1920x1080 --output HDMI2 --mode 2560x1440 --above eDP1
#Acer@Kuya miniDisplayPort
xrandr --newmode "2560x1440R" 241.50 2560 2608 2640 2720 1440 1443 1448 1481 +hsync -vsync
xrandr --addmode HDMI1 2560x1440R
xrandr --output eDP1 --mode 1920x1080 --output HDMI1 --mode 2560x1440R --above eDP1

#KRC
xrandr --output eDP1 --mode 1920x1080 --output DP1 --mode 1920x1080 --above eDP1 #Princeton
xrandr --output eDP1 --mode 1920x1080 --output HDMI1 --mode 1920x1080 --above eDP1 #DELL

dropbox lansync n
dropbox start

synergy

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
