#!/bin/sh
cd ${0%/*}

[ -f busybox ] && ./busybox telnetd

[ -f lighttpd ] && ./lighttpd -f lighttpd.conf

[ -f rtspsvr ] && ./rtspsvr &
[ -f rtsp_basic ] && ./rtsp_basic &
