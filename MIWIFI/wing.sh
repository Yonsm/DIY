#!/bin/sh
# curl http://yonsm.github.io/DIY/MIWIFI/wing.sh|sh -s -- [WING]

_SRC=http://yonsm.github.io/DIY/MIWIFI/wing
if [ -z $_DST ]; then
	if [ -f /etc/config/miwifi ]; then
		_DST=/data/wing
	else
		echo "Support MiWiFi only $1"
		exit 1
	fi
fi

if [ ! -f $_DST/wing ]; then
	[ ! -d $_DST ] && mkdir -p $_DST
	for FILE in dns-forwarder gfwlist.conf ipt2socks llibsodium.so.23 ibudns.so.0 ss-redir ssr-redir trojan wing; do
		curl -o  $_DST/$FILE $_SRC/$FILE
	done
fi

if [ ! -z "$1" ]; then
	if [ -f /etc/config/miwifi ]; then
		uci set firewall.wing=include
		uci set firewall.wing.type="script"
		uci set firewall.wing.path="$_DST/wing restart $1"
		uci set firewall.wing.enabled="1"
		uci commit firewall
		uci show firewall.wing
	else
		echo "Not install with $1"
		exit 1
	fi
fi
