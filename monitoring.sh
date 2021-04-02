#!/bin/bash

cd "$(dirname "$0")"

for MODULE in $( cat esp_modules.csv | grep -v ^# )
	do
	MODULE_ID=$( cat esp_modules.csv | grep -v ^# | cut -d";" -f1  )
	for SENSOR in $( cat esp_sensors.csv | grep $MODULE_ID )
		do
		echo '------------'
		echo $( echo $MODULE | cut -d';' -f 2 ) $( echo $SENSOR | cut -d';' -f 2 )
		POM=$( ./check.sh $( echo $MODULE | cut -d';' -f 2 ) $( echo $SENSOR | cut -d';' -f 2 ) )
		echo $POM
		echo $POM > /tmp/ramdisk/esp_$( echo $MODULE | cut -d';' -f 2 )-$( echo $SENSOR | cut -d';' -f 2 ).txt
		done	
	done
