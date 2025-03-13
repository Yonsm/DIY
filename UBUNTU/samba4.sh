
#!/bin/sh

hdparm -I /dev/sda
hdparm -B 127 /dev/sda
hdparm -S 180 /dev/sda
hdparm -I /dev/sda
hdparm -C /dev/sda
echo -e "LABEL=STORE\t/mnt/STORE\tntfs\t\tdefaults,noatime,nodiratime\t\t\t0 0" >> /etc/fstab
#reboot

apt install samba samba-vfs-modules
smbpasswd -a admin

cat <<\EOF > /etc/samba/smb.conf
# ?
EOF

#smbd -F --no-process-group -S -d=3
/etc/init.d/smbd restart
