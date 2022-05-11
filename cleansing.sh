#!/bin/sh

# Stop and kill the hostapd and dnsmasq services.
service hostapd stop
service dnsmasq stop
killall dnsmasq >/dev/null 2>&1
killall hostapd >/dev/null 2>&1
systemctl unmask systemd-resolved >/dev/null 2>&1
systemctl enable systemd-resolved.service >/dev/null 2>&1
systemctl start systemd-resolved >/dev/null 2>&1
 # drop all iptables rules
sudo iptables -F
sudo iptables -X
sudo iptables --table nat -F
sudo iptables --table nat -X
sudo iptables -P OUTPUT ACCEPT
sudo iptables -P INPUT ACCEPT
sudo iptables -P FORWARD ACCEPT
