from scapy.all import *

#######################################################
#####Change to variables we get from bash##############
mac = sys.argv[2]
#######################################################
CliList = []

def PacketHandler(p):
    if p.haslayer(Dot11):
        if p.addr1 and p.addr2:                                            
            p.addr1 = p.addr1.lower()                                        
            p.addr2 = p.addr2.lower() 
            #instead of this ap address we need a variable         
            if mac.lower() == p.addr1.lower():                    
                if p.type in [1, 2]:                                               
                    if p.addr2 not in CliList and p.addr2 != '':
                        CliList.append(p.addr2)
                        print("src MAC: %s dst MAC (which we can attack): %s " % (
                            p.addr1, p.addr2))
                        

def apScan(interface):
    sniff(iface=interface, prn = PacketHandler, timeout=10)
    
if __name__ == "__main__":
    apScan(sys.argv[1])
