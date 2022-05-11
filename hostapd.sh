#!bin/bash

sudo ifconfig wlx6c5ab03ab2f5 down
sleep 3s
sudo iwconfig wlx6c5ab03ab2f5 mode monitor
sleep 2s
sudo ifconfig wlx6c5ab03ab2f5 up
sleep 2s

# iwconfig

hostapd pap/hostapd.conf 


