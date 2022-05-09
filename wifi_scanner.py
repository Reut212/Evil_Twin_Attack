from scapy.all import *
                      

ap_list = []

def PacketHandler(packet):
    if packet.haslayer(Dot11Beacon):
        if packet.addr2 not in ap_list:
            ap_list.append(packet.addr2)
            # extract the MAC address of the network
            bssid = packet.addr2
            # get the name of it
            ssid = packet.info.decode()
            # get the channel of the AP
            channel = int(ord(packet[Dot11Elt:3].info))
            print("AP MAC: %s with SSID: %s  and CH: %d" %
                  (bssid, ssid, channel))




sniff(iface="wlx6c5ab03ab2f5", prn = PacketHandler)#, timeout=100)
print("likely to work")