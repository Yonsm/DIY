
#!/bin/sh
sd=`dirname $0`

ifconfig eth0 0.0.0.0
#ifconfig eth0 down

telnetd &

killall watch_process
killall mini_httpd
cd /home/web
$sd/mini_httpd &
/home/watch_process &

$sd/rtspsvr &
