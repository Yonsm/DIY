
#!/bin/sh
diy=`dirname $0`

ifconfig eth0 0.0.0.0

telnetd &

killall watch_process
killall mini_httpd
cd /home/web
$diy/mini_httpd &
/home/watch_process &

$diy/rtspsvr &
