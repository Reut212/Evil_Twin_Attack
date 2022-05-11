from scapy.all import *
import os


ap_dict = {}

def PacketHandler(packet):
    if packet.haslayer(Dot11Deauth):
        #addr2 = gateway mac address
        if packet.addr2 not in ap_list:
            ap_dict.update({packet.addr2 : 1})
        else:
            ap_dict.update({packet.addr2 : ap_dict.get(packet.addr2) + 1})
    #we use iptables to 
    if(ap_dict.get(packet.addr2) > 20):
        os.system("iptables -t nat -A INPUT -m mac --mac-source 00:0F:EA:91:04:08 -j DROP")
        
sniff(iface=interface, prn = PacketHandler)



    