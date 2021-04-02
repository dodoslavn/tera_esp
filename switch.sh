#!/bin/bash

cd "$(dirname "$0")"

if [ "$1" == "" ]
	then
	echo Chyba nazov modulu!
	exit 1
	fi
PARAM_MODUL=$1

if [ "$2" == "" ]
        then
        echo Chyba nazov spinaca!
        exit 1
        fi
PARAM_SPINAC=$2

if [ "$3" == "" ]
        then
        echo Chyba stav spinaca!
        exit 1
        fi
PARAM_STAV=$3


POM=$( cat esp_modules.csv | grep -v ^# | grep \;$PARAM_MODUL\; )
if [ "$POM" == "" ]
	then
	echo Modul sa v zozname nenasiel!
	exit 1
	fi

MODUL_ID=$( cat esp_modules.csv | grep -v ^# | grep \;$PARAM_MODUL\; | cut -d';' -f1)
POM=$( cat esp_switches.csv | grep -v ^# | grep \;$PARAM_SPINAC\; | grep ^$MODUL_ID\; )
if [ "$POM" == "" ]
        then
        echo Spinac sa v zozname nenasiel!
        exit 1
        fi

SPINAC_PIN=$( cat esp_switches.csv | grep -v ^# | grep \;$PARAM_SPINAC\; | grep ^$MODUL_ID\; | cut -d';' -f 3)
MODUL_IP=$( cat esp_modules.csv | grep -v ^# | grep \;$PARAM_MODUL\; | cut -d';' -f3)

ping -c 1 $MODUL_IP 1>/dev/null 2>&1
if [ "$?" != 0 ]
	then
	echo Modul nieje aktivny!
	exit 1
	fi

if [ "$PARAM_STAV" == "ZAP" ]
	then
	PARAM_STAV=1
else
	PARAM_STAV=0
	fi

wget -O - $MODUL_IP"/status="$PARAM_STAV"&pin="$SPINAC_PIN 1>/dev/null 2>&1

