from scapy.all import *
from threading import Thread
import pandas
import time
import os
import signal

networks = pandas.DataFrame(columns=["BSSID", "SSID", "Channel", "AUTH"])
networks.set_index("BSSID", inplace=True)

#Function to handle Crtl+C
def signal_handler(signal, frame):
	print('\n=================')
	print('Execution aborted')
	print('=================')
	os.system("kill -9 " + str(os.getpid()))
	sys.exit(1)


def callback(packet):
    
            # extract the MAC address of the network
            bssid = packet[Dot11].addr2
            # get the name of it
            ssid = packet[Dot11Elt].info.decode()
            # extract network stats
            stats = packet[Dot11Beacon].network_stats()
            # get the channel of the AP
            channel = stats.get("channel")
            # get the crypto
            auth = stats.get("crypto")
            networks.loc[bssid] = (ssid, dbm_signal, channel, auth)



def print_all():
    while True:
        os.system("clear")
        print(networks)
        time.sleep(1)

if __name__ == "__main__":
    signal.signal(signal.SIGINT, signal_handler)
