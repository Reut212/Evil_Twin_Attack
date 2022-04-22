from scapy.all import *
import sys
import time
import signal
import pandas


# Function checks if the user has root privileges
def check_root():
    if os.geteuid() != 0:
        print("[-] You need to have root privileges to run this script.")
        sys.exit(1)

# Fucntion recieves the interface name, the access point BSSID and the access point channel and returns a list of all the MAC addresses of the clients connected to the access point
def scanConnecedToAP(interface,accessPointBSSID,accessPointChannel):
    # Scanning for the clients connected to the access point
    print("[+] Scanning for clients connected to the access point...")
    # Scapy function to scan for the clients connected to the access point
    clients = []
    # Scapy function to scan for the clients connected to the access point
    clients = sniff(iface=interface,count=0,prn=lambda x: clients.append(x.addr2))
    # List of MAC addresses of the clients connected to the access point
    clientsMAC = []
    clientsMAC = [x.addr2 for x in clients]
    clientsMAC = list(set(clientsMAC))
    clientsMAC = [x for x in clientsMAC if x != accessPointBSSID]
    clientsMAC = [x for x in clientsMAC if x != "ff:ff:ff:ff:ff:ff"]
    clientsMAC = [x for x in clientsMAC if x != "00:00:00:00:00:00"]
    return clientsMAC


if __name__ == "__main__":
    interface = int(sys.argv[1])
    accessPointBSSID = sys.argv[2]
    accessPointChannel = sys.argv[3]
    print(targetList=scanConnecedToAP(interface,accessPointBSSID,accessPointChannel))


