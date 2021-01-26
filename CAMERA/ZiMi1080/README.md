# 米家智能摄像机1080P

1. 把 `diy`、`ft` 和 3.3.6_0099 固件中的 `tf_recovery.img` 拷贝到 TF 卡，并插入到摄像机中，重启设备，并等待降级完成；
2. `【可选】` 使用 root/空密码登录 `telnet camera_ip`；
3. 升级至最新固件，已知 3.5.8_0188 可以正常使用；
4. 然后访问 `http://camera_ip`。
5. 重签名：`【可选】仅当修改了 ft 或 新版私钥发生变化时需要操作`
    - 设备上执行 `md5sum ft/ft_boot.sh > secret.bin.dec`
    - 修改文件内容增加绝对路径 `sed -i 's/ ft/ \/tmp\/sd\/ft/' secret.bin.dec`
    - 从设备中获取私钥 `/mnt/data/ft/prikey.pem`（新版 3.5.8_0188 固件内只有公钥没有私钥，旧版 3.3.6_0099 私钥到目前都可用）
    - 电脑上执行 `openssl rsautl -encrypt -inkey prikey.pem -in secret.bin.dec -out ft/secret.bin`
