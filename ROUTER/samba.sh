
#!/bin/sh

cat <<\EOF > /etc/smb.conf
[global]
# General
netbios name = Store
workgroup = WORKGROUP
server string = Storage
unix charset = UTF-8
interfaces = br0
bind interfaces only = yes

local master = yes
os level = 128
unix extensions = no
pam password change = no
#host msdfs = no

name resolve order = lmhosts hosts bcast
log file = /var/log/samba.log
log level = 0
max log size = 5

max protocol = SMB2
null passwords = yes
dos filemode = yes

# Account
passdb backend = smbpasswd
map to guest = Bad User
access based share enum = yes

# Content
veto files = /Thumbs.db/.DS_Store/._.DS_Store/.apdisk/
force create mode = 0644
force directory mode = 0755
load printers = no
disable spoolss = yes

# Connection
deadtime = 15
min receivefile size = 16384
write cache size = 524288
socket options = TCP_NODELAY IPTOS_LOWDELAY
aio read size = 16384
aio write size = 16384
use sendfile = yes

[Downloads]
path = /media/STORE/Downloads
public = yes
writable = yes

[Public]
path = /media/STORE/Public
public = yes
write list = admin

[Music]
path = /media/STORE/Music
public = yes
write list = admin

[Pictures]
path = /media/STORE/Pictures
writable = yes
valid users = admin

[Movies]
path = /media/STORE/Movies
writable = yes
valid users = admin

[Documents]
path = /media/STORE/Documents
writable = yes
valid users = admin

EOF

killall -9 nmbd
killall -9 smbd
/sbin/smbd -D -s /etc/smb.conf
/sbin/nmbd -D -s /etc/smb.conf
smbpasswd admin admin

