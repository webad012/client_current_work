#!/bin/bash

# usage example: bash client_current_work.sh
# remote usage example: ssh -t user@host "bash client_current_work.sh"

# suggestion:
## setup script on client machine
## on local server when needed call remotely and retreive data

# get information about current client work
# result on successfull execution: json {active_process_name, active_process_additional_data, currently_logged_in_user, user_full_name, machine_id, hostname, screenshot_full_path}

# requirements: xdotool, xclip, imagemagick

# tested on ubuntu 16.04, ubuntu 18.04

if dpkg-query -W "xdotool" 2>&1 | grep -q "no packages found"; then
	echo "{'status':'failure', 'message':'xdotool not installed'}";
	exit 0;
fi
if dpkg-query -W "xclip" 2>&1 | grep -q "no packages found"; then
	echo "{'status':'failure', 'message':'xclip not installed'}";
	exit 0;
fi
if dpkg-query -W "imagemagick" 2>&1 | grep -q "no packages found"; then
	echo "{'status':'failure', 'message':'imagemagick not installed'}";
	exit 0;
fi

# COMMENT OUT
# to allow switching to any active browser
#sleep 1;

currently_logged_in_user=$(w | grep ' :1 ' | awk '{print $1;}')

current_display=$(w -oush | grep -Eo ' :[0-9]+' | uniq | cut -d \  -f 2)

export DISPLAY=$current_display
export XAUTHORITY=/home/$currently_logged_in_user/.Xauthority

active_window_id=$(xdotool getactivewindow)
active_window_pid=$(xdotool getwindowpid "$active_window_id")
active_process_name=$(ps -p $active_window_pid -o comm=)

active_process_additional_data="";
if [ "$active_process_name" = "chrome" ] || [ "$active_process_name" = "firefox" ]
then
	xdotool windowactivate --sync $active_window_id key "ctrl+l"
	xdotool windowactivate --sync $active_window_id key "ctrl+c"
	xdotool windowactivate --sync $active_window_id key "shift+F6"
	active_process_additional_data=$(xclip -o)
fi

user_full_name=$(getent passwd $currently_logged_in_user | cut -d ':' -f 5 | cut -d ',' -f 1)

# hwid is microsoft specific
# machine id depends on dbus
machine_id=$(cat /var/lib/dbus/machine-id)

hostname=$(hostname);

screenshot_current_datetime=$(date +"%Y%m%d_%H%M%S_%N");
current_path=$(pwd)
screenshot_full_path="$current_path/screenshot_$screenshot_current_datetime.png"
import -window root $screenshot_full_path

echo "{'status':'success', 'active_process_name':'$active_process_name', 'active_process_additional_data':'$active_process_additional_data', 'currently_logged_in_user':'$currently_logged_in_user', 'user_full_name':'$user_full_name', 'machine_id':'$machine_id', 'hostname':'$hostname', 'screenshot_full_path':'$screenshot_full_path'}";

# COMMENT OUT
# to notify on complete while working in browser
#notify-send 'done' 'done'
