from scapy.all import *
import os

#######################################################################
# we build a dict to keep records of how much deauth packets
# we get from each specific address, if we get suspicious amount of deauth
# from the same ip he attacking us
# the use of ip tables ill drop any packet that come from him
# we can restart the dict every minute to keep it like normal networks
########################################################################3 
ap_dict = {}

def PacketHandler(packet):
    if packet.haslayer(Dot11Deauth):
        #addr2 = gateway mac address
        if packet.addr2 not in ap_list:
            ap_dict.update({packet.addr2 : 1})
        else:
            ap_dict.update({packet.addr2 : ap_dict.get(packet.addr2) + 1})
    #we use iptables to keep out attackers
    if(ap_dict.get(packet.addr2) > 20):
        os.system("iptables -t nat -A INPUT -m mac --mac-source "+ packet.addr2 +" -j DROP")
        
sniff(iface=interface, prn = PacketHandler)



    