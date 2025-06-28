#!/bin/sh

if [ -f /etc/config/miwifi ]; then
	_SRC=http://yonsm.github.io/DIY/MIWIFI/wing
	_DST=/data/wing
else
	echo Support MiWiFi only
	exit 1
fi

[ ! -d $_DST ] && mkdir -p $_DST

for FILE in dns-forwarder gfwlist.conf ipt2socks llibsodium.so.23 ibudns.so.0 ss-redir ssr-redir trojan wing; do
	curl -o  $_DST/$FILE $_SRC/$FILE
done

[ ! -z "$1" ] && $_DST/wing install "$1"
