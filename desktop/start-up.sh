#!/bin/sh

# ~/.xbindkeysrc volume, backlight
xbindkeys

syndaemon -i 1 -d -t -K # Disable touchpad while typing
# speed (default=12.5)
xinput set-prop 'SynPS/2 Synaptics TouchPad' 'Device Accel Velocity Scaling' 14
# Acceleration: small is fast
#xinput set-prop 'SynPS/2 Synaptics TouchPad' 'Device Accel Constant Deceleration' 1.0
# Natural scrolling
xinput set-prop 'SynPS/2 Synaptics TouchPad' 'Synaptics Scrolling Distance' -119 -119
# Horizontal scrolling
xinput set-prop 'SynPS/2 Synaptics TouchPad' 'Synaptics Two-Finger Scrolling' 1 1

redshift -O 3200
dropbox lansync n
dropbox start
#sh ~/.dotfiles/always.sh &
#sudo tee brightness <<< 1

mvt $home/.local/share/recently-used.xbel

#pavucontrol
#pulseaudio
#amixer
mvt ~/.config/pulse
pulseaudio -k
pulseaudio --start

sudo apt update 
echo "\n" 
sudo apt upgrade -y 
echo "\n" 
sudo apt autoremove -y
echo "\n" 
sudo apt dist-upgrade

sleep 1s
setxkbmap -option "ctrl:swapcaps"
setxkbmap -option "swapcaps:ctrl"

xrandr --output eDP1 --mode 1600x900 --output DP1 --auto --above eDP1 #VGA@KRC
xrandr --output eDP1 --mode 1600x900 --output HDMI1 --auto --above eDP1 #DELL@Kuya
#xrandr --output eDP1 --mode 1600x900 --output HDMI1 --mode 1920x1080 --rotate normal --above eDP1
#xrandr --output eDP1 --mode 1600x900 --pos 0x0 --rotate normal --output HDMI1 --mode 1920x1080 --rotate normal --above eDP1

sudo ~/script/anti-virus.sh
