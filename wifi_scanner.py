from scapy.all import *
import sys

ap_list = []
packetList = []


def PacketHandler(packet):
    if packet.haslayer(Dot11Beacon):
        if packet.addr2 not in ap_list:
            packetList.append(packet)
            ap_list.append(packet.addr2)
            # extract the MAC address of the network
            bssid = packet.addr2
            # get the name of it
            ssid = packet.info.decode()
            # get the channel of the AP
            channel = int(ord(packet[Dot11Elt:3].info))
            print("AP MAC: %s with SSID: %s  and CH: %d" %
                  (bssid, ssid, channel))


def wifiScan(interface):
    sniff(iface=interface, prn=PacketHandler, timeout=60)


if __name__ == "__main__":
    wifiScan(sys.argv[1])
    print("Enter the MAC address of the AP")
    mac = input()
    for packet in packetList:
        if mac == packet.addr2:
            #create text filt assid.txt and write the packet.addr2
            with open("assid.txt", "w") as file1:
                file1.write(packet.addr2)
            # create text file ssid.txt and write the packet.info.decode()
            with open("ssid.txt", "w") as file2:
                file2.write(packet.info.decode())
            # create text file channel.txt and write the int(ord(packet[Dot11Elt:3].info))
            with open("channel.txt", "w") as file3:
                file3.write(str(int(ord(packet[Dot11Elt:3].info))))
            sys.exit(0)
    print("Wrong MAC address")
