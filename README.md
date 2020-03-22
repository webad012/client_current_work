# client_current_work

get information about current client work

result on successfull execution: json {current_active_url, currently_logged_in_user, user_full_name, machine_id, hostname, screenshot_full_path}

tested on ubuntu 16.04, ubuntu 18.04


# requirements
xdotool, xclip, imagemagick

tested on ubuntu 16.04, ubuntu 18.04

# usage example
bash client_current_work.sh

remote usage example: ssh -t user@host "bash client_current_work.sh"

# suggestion:
setup script on client machine

on local server when needed call remotely and retreive data
