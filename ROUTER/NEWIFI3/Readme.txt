
#https://www.right.com.cn/forum/thread-342918-1-1.html

Breed 方法如下：

1. 开启固件 SSH
    a) 开启路由器，进入管理界面 (假设路由器 IP 地址是 192.168.99.1)
    b) 在浏览器中输入 http://192.168.99.1/newifi/ifiwen_hss.html 并进入
    c) 页面显示 success 即表明已开启 SSH

2. 进入路由器 SSH 环境
    a) 略。使用 PuTTY/SecureCRT/ssh 均可

3. 上传解锁文件到路由器
    a) 下载附件，解压得到 newifi-d2-jail-break.ko
    b) 用 WinSCP 等工具将其上传到路由器的 /tmp 目录
    c) 或者用 HFS 搭建本地 HTTP 服务器，并在 SSH 里用 wget 命令下载
    d) 或者用 tftpd32/tftpd64 搭建本地 TFTP 服务器，并在 SSH 里用 tftp 命令下载
    e) 用 U 盘当然也行

4.  开始解锁
    a) SSH 进入 /tmp 目录
        cd /tmp
    b) 加载 newifi-d2-jail-break.ko
        insmod newifi-d2-jail-break.ko
    c) 此时 SSH 会停止响应，因为 newifi-d2-jail-break.ko 会冻结系统的其他功能，强制写入 Newifi D2 专用版 Breed 到 Flash
    d) 成功后路由器会自动重启。断电后按复位健/USB键开机均可进入 Breed

5. 说明
    本方法是【免解锁】刷机，因此如果重新刷回 pb-boot，那么路由器依然是未解锁状态。
    但是！刷了 Breed 就等于解锁了，下面的流程仅供强迫症患者使用！
    如果需要真正解锁，例如重新刷回 pb-boot，那么可以使用以下方法解锁：
    a) 进入 Breed 命令行，通过串口(TTL)或者 Telnet
    b) 执行 newifid2 unlock 即可解锁，此时依然可以恢复为未解锁状态：
        如果要恢复成未解锁状态，执行 newifid2 lock 即可
        如果想永久解锁，执行 newifid2 unlock permanently。这样会解锁并锁定 OTP，不能再次修改。

#自定义脚本0
/sbin/stop_samba
killall -9 nmbd
killall -9 smbd
sed -i '/\[global\]/a\veto files=/aria/transmission/.Trashes/._*/' /etc/smb.conf
/sbin/smbd -D -s /etc/smb.conf
/sbin/nmbd -D -s /etc/smb.conf

curl -o /tmp/ntfslabel  https://pkg.musl.cc/ntfs-3g-2017.3.23/mipsel-linux-musl/sbin/ntfslabel
