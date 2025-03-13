

# adb connect 192.168.1.2
# 安装apk
adb shell settings put secure install_non_market_apps 1
# adb push com.he.ardc_2.1.1369.apk /data/local/tmp/
# adb shell /system/bin/pm install -t /data/local/tmp/com.he.ardc_2.1.1369.apk
# 截屏
# adb shell screencap -p /data/local/tmp/1.png && adb pull /data/local/tmp/1.png
# 模拟点击
# adb shell input tap 551 258
# 卸载应用
# adb shell /system/bin/pm uninstall com.he.ardc

adb shell am startservice -n com.github.neithern.airaudio/.AirAudioService -e name 小讯音箱

#!/usr/bin/env bash

adb push app/build/outputs/apk/release/app-release.apk /sdcard/
adb shell /system/bin/pm install -r -t /sdcard/app-release.apk

# Start parameters: -e name ServerName -e output system/music -e channel left/right/stereo
adb shell am startservice -n com.github.neithern.airaudio/.AirAudioService

brew install scrcpy
