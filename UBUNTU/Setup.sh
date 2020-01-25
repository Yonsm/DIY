sudo mkdir /etc/systemd/system/getty@tty1.service.d

cat << EOF | sudo tee /etc/systemd/system/getty@tty1.service.d/override.conf
[Service]
ExecStart=
ExecStart=-/sbin/agetty --noissue --autologin admin %I $TERM
Type=idle

EOF

touch ~/.hushlogin

echo "cd /opt" >> ~/.bashrc
