#!/bin/bash

cd "$(dirname "$0")"

PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/games:/usr/games

IFS=$'\n'

for MODULE in $( cat esp_modules.csv | grep -v ^# )
	do
	MODULE_ID=$( echo $MODULE | grep -v ^# | cut -d";" -f1  )
	for SENSOR in $( cat esp_sensors.csv | grep $MODULE_ID )
		do
		echo '------------'
		echo $( echo $MODULE | cut -d';' -f 2 ) $( echo $SENSOR | cut -d';' -f 2 )
		POM=$( ./check.sh $( echo $MODULE | cut -d';' -f 2 ) $( echo $SENSOR | cut -d';' -f 2 ) )
		echo $POM
		echo $POM > /tmp/ramdisk/esp_$( echo $MODULE | cut -d';' -f 2 )-$( echo $SENSOR | cut -d';' -f 2 ).txt
		chmod 755 /tmp/ramdisk/esp_$( echo $MODULE | cut -d';' -f 2 )-$( echo $SENSOR | cut -d';' -f 2 ).txt
		done	
	done
