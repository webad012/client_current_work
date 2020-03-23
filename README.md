# client_current_work

get information about current client work

result on successfull execution: json {active_process_name, active_process_additional_data, currently_logged_in_user, user_full_name, machine_id, hostname, screenshot_full_path}

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

# note
if active_process_name is chrome or firefox, active_process_additional_data will contain url of current active tab, otherwise will be empty
