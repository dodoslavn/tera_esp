# tera_esp
Set of scripts which are part of my "tera_" project.
Goal is to monitor ESP-32/ESP-.. modules which have HTTP server running.
This script will call the modules and retrieve data from them (temperature/humidity) and store them in file. 
Files are then collected and values stored in database - for my case its managed by Zabbix server.
Script can also make a call to turn off or turn on some pins of the module so it could turn on heating or lights.
Arduino folder contains simple code for the modules.

# TODO
Need GUI / web interface for this
