
#!/bin/sh

cat <<\EOF > /etc/smb.conf
[global]
workgroup = WORKGROUP
netbios name = Router
server string = Router
local master = yes
os level = 128
name resolve order = lmhosts hosts bcast
log file = /var/log/samba.log
log level = 0
max log size = 5
socket options = TCP_NODELAY SO_KEEPALIVE
unix charset = UTF8
display charset = UTF8
bind interfaces only = yes
interfaces = br0
unix extensions = no
encrypt passwords = yes
pam password change = no
obey pam restrictions = no
host msdfs = no
disable spoolss = yes
max protocol = SMB2
passdb backend = smbpasswd
security = USER
username level = 8
guest ok = no
map to guest = Bad User
hide unreadable = yes
writeable = yes
directory mode = 0777
create mask = 0777
force directory mode = 0777
max connections = 10
use spnego = no
client use spnego = no
null passwords = yes
strict allocate = no
use sendfile = yes
dos filemode = yes
dos filetimes = yes
dos filetime resolution = yes

[transmission]
comment = transmission
path = /media/STORE/transmission
writeable = no
valid users = admin
invalid users = 
read list = admin
write list = admin
[aria]
comment = aria
path = /media/STORE/aria
writeable = no
valid users = admin
invalid users = 
read list = admin
write list = admin
[Documents]
comment = Documents
path = /media/STORE/Documents
writeable = no
valid users = admin
invalid users = 
read list = admin
write list = admin
[opt]
comment = opt
path = /media/STORE/opt
writeable = no
valid users = admin
invalid users = 
read list = admin
write list = admin
[Music]
comment = Music
path = /media/STORE/Music
writeable = no
valid users = admin
invalid users = 
read list = admin
write list = admin
[Pictures]
comment = Pictures
path = /media/STORE/Pictures
writeable = no
valid users = admin
invalid users = 
read list = admin
write list = admin
[Downloads]
comment = Downloads
path = /media/STORE/Downloads
writeable = no
valid users = admin
invalid users = 
read list = admin
write list = admin
[Movies]
comment = Movies
path = /media/STORE/Movies
writeable = no
valid users = admin
invalid users = 
read list = admin
write list = admin
[Public]
comment = Public
path = /media/STORE/Public
writeable = no
valid users = admin
invalid users = 
read list = admin
write list = admin

EOF

killall -9 nmbd
killall -9 smbd
/sbin/smbd -D -s /etc/smb.conf
/sbin/nmbd -D -s /etc/smb.conf
smbpasswd admin admin

