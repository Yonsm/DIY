#!/bin/sh
# Install Home Assistant on MiFi

# BASE
zpkg install python3 python3-pip
zpkg install python3-dev gcc
zpkg install python3-cffi
source /mnt/usb-e19ddc2b/usr/bin/gcc_env.sh
export C_INCLUDE_PATH=/mnt/usb-e19ddc2b/usr/include

# TODO: MQTT not work since numpy failure
# zpkg install python3-numpy?

# PIP
echo -e "[global]\nindex-url = https://pypi.tuna.tsinghua.edu.cn/simple/" > /etc/pip.conf
python3 -m pip install --upgrade pip

cd /mnt/usb-e19ddc2b
mkdir root
mount --bind /mnt/usb-e19ddc2b/root /root

# PIP SO Fix
cat <<\EOF > usr/bin/pip3sofix
#!/bin/sh
FILE="${1##*/}"
ln -s "$FILE" "${1%/*}/${FILE%%.*}.so"
EOF
cat <<\EOF > usr/bin/pip3fix
#!/bin/sh
cd /mnt/usb-e19ddc2b/usr/lib/python3.10/site-packages && find . -name "*cpython-*.so" -exec pip3sofix {} \;
cd /root/.homeassistant/deps/lib/python3.10/site-packages && find . -name "*cpython-*.so" -exec pip3sofix {} \;
EOF
chmod +x usr/bin/pip*fix

# HASS
pip install homeassistant tzdata

# Fix
rm -rf /root/.homeassistant/deps/lib/python3.10/site-packages/zeroconf*
pip3fix
hass
pip3fix
hass -v

# Launch
sed -i '/exit 0/d' /etc/rc.local
echo -e 'hass -c /root/.homeassistant > dev/null &\nexit 0' >> /etc/rc.local

# MQTT
opkg install mosquitto-nossl
cat << \EOF > /etc/mosquitto/mosquitto.conf
listener 1883
allow_anonymous true
allow_zero_length_clientid true
EOF

# MISC
opkg install ffmpeg #adb ...
