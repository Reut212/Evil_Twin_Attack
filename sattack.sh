#!/bin/bash



#Check if user is root
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit
fi

clear

iwconfig
echo "Enter the interface name"
read interface

clear

# Check if interface is up
ifconfig $interface | grep UP
if [ $? -eq 0 ]
then
    echo "Interface is up"
else
    echo "Interface is down"

    #Finish
    exit
fi



clear

# Check if interface is in monitor mode
iwconfig $interface | grep Monitor
if [ $? -eq 0 ]
then
    echo "Interface is in monitor mode"
else
    echo "Interface is not in monitor mode"
    
    # Start monitor mode
    ifconfig $interface down
    iwconfig $interface mode monitor
    ifconfig $interface up
    if [ $? -eq 0 ]
    then
        echo "Monitor mode started"
    else
        echo "Monitor mode failed to start"
        exit
    fi
fi


clear

# Perform a WLAN scan for 1 minute
echo "Scanning for WLAN networks..."
iwlist $interface scan 1



echo "Enter the BSSID you want to attack"
read ssid


# Exit if BSSID is not valid
if [ -z "$ssid" ]
then
    echo "BSSID is not valid"
    exit
fi


echo "Enter the channel you want to attack"
read channel


# Exit if channel is not valid
if [ -z "$channel" ]
then
    echo "Channel is not valid"
    exit
fi


















