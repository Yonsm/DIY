# First: Tv Tool root

adb connect HiMedia

adb install OpenBlurayMode.apk
adb install Superuser.apk

adb remount
adb push xbin/su /system/xbin/

adb shell
cd /system/bin
ln -s busybox ftpd
ln -s busybox tcpsvd
#tcpsvd -vE 0.0.0.0 21 ftpd /

mkdir /system/etc/init.d
echo "#!/system/bin/sh" > /system/etc/init.d/99SuperSuDaemon
echo "/system/xbin/daemonsu --auto-daemon &" > /system/etc/init.d/99SuperSuDaemon
chmod 755 /system/etc/init.d/99SuperSuDaemon

echo "#!/system/bin/sh" > /system/etc/init.d/88HomeAssistant
echo "curl -k -d '{\"state\": \"on\", \"attributes\": {\"friendly_name\": \"播放器\"}}' https://192.168.1.10:8123/api/states/switch.himedia" >> /system/etc/init.d/88HomeAssistant
chmod 755 /system/etc/init.d/88HomeAssistant

#curl -k -d '{"state": "off", "attributes": {"friendly_name": "播放器"}}' https://192.168.1.10:8123/api/states/switch.himedia

#system settings-input->cofigure attached controllers，点Back键和Menu键再适配一次：选择中Back->按OK键->会有提示“press back”->再按一次遥控器的“back”后点击“OK”