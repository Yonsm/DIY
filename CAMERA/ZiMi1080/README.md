# 米家智能摄像机1080P

## 一、升级固件`【可选】`

1. 升级至最新固件，已知 3.5.8_0188 可以正常使用。
2. 重签名：`【可选】仅当修改了 ft 或 新版私钥发生变化时需要操作`
    - 设备上执行 `md5sum ft/ft_boot.sh > secret.bin.dec`
    - 修改文件内容增加绝对路径 `sed -i 's/ ft/ \/tmp\/sd\/ft/' secret.bin.dec`
    - 从设备中获取私钥 `/mnt/data/ft/prikey.pem`（新版 3.5.8_0188 固件内只有公钥没有私钥，旧版 3.3.6_0099 私钥到目前都可用）
    - 电脑上执行 `openssl rsautl -encrypt -inkey prikey.pem -in secret.bin.dec -out ft/secret.bin`

## 二、破解使用

1. 把 `diy` `ft` 目录拷贝到 TF 卡上，并插入到设备；
2. 重启设备，然后访问 `http://camera_ip`。

