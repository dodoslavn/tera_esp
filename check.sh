#!/bin/bash

cd "$(dirname "$0")"


if [ "$1" == "" ]
	then
	echo Chyba nazov modulu!
	echo
	echo Toto su moznosti:
	cat esp_modules.csv | cut -d';' -f2		
	exit 1
	fi
PARAM_MODUL=$1

POM=$( cat esp_modules.csv | grep -v ^# | grep \;$PARAM_MODUL\; )
if [ "$POM" == "" ]
        then
        echo Modul sa v zozname nenasiel!
        exit 1
        fi

MODUL_IP=$( cat esp_modules.csv | grep -v ^# | grep \;$PARAM_MODUL\; | cut -d';' -f3)
MODUL_ID=$( cat esp_modules.csv | grep -v ^# | grep \;$PARAM_MODUL\; | cut -d';' -f1)

if [ "$2" == "" ]
        then
        echo Chyba nazov senzora!
        echo
        echo Toto su moznosti:
        cat esp_sensors.csv | grep ^$MODUL_ID";" | cut -d';' -f2

        exit 1
        fi
PARAM_SENSOR=$2

POM=$( cat esp_sensors.csv | grep -v ^# | grep \;$PARAM_SENSOR$ )
if [ "$POM" == "" ]
        then
        echo Senzor sa v zozname nenasiel!
        exit 1
        fi

ping -c 1 $MODUL_IP 1>/dev/null 2>&1
if [ "$?" != 0 ]
        then
        echo Modul nieje aktivny!
        exit 1
        fi

wget --tries=2 --connect-timeout=5 --timeout=5 -O $PARAM_MODUL".html" $MODUL_IP  1>/dev/null 2>&1

cat $PARAM_MODUL".html" | grep -A 1 $PARAM_SENSOR | tail -1

