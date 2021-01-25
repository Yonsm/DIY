小白智能摄像机1080P云台版

一、升级固件`【可选】`

1. 到[小蚁官方](http://www.imilab.com/wechat/software_upgrade.html)下载[最新固件](https://cdn.cnbj2.fds.api.mi-img.com/chuangmi-cdn/product/ipc004/firmware/IPC004_3.3.6_2018121218.zip)
2. 将 tf_recovery.img 文件放到 TF 卡，插入设备中；
3. 按压摄像机的 reset 键3秒（部分机型为针孔），摄像机状态变为“黄灯闪烁”，并伴有“等待连接”提示音；（若您的摄像机出现黄灯常亮，请忽略此步骤）
4. 摄像机断电→插入内存卡→摄像机通电，此时摄像机状态变为“黄灯常亮”，等待大约3分钟；当摄像机状态变为“黄灯闪烁”，并伴有“等待连接”提示音，表示内存卡升级成功。

二、破解使用

1. 把 `test` 目录拷贝到 TF 卡上（注意是整个 test 目录，而不是把里面的文件拷过去）。
2. telnet camera_ip with root
3. 执行 `[ ! -f /mnt/data/imi/imi_init/S89autorun ] && ln -s $sd/autorun.sh /mnt/data/imi/imi_init/S89autorun`
4. 访问 http://camera_ip。
