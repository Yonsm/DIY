#!/bin/sh

LAN_DOMAIN=lan
PPOE_NAME=
PPPOE_PASS=
ADMIN_PASS=admin
WIFI_PASS=12345678
WIFI_STA_SSID=
DDNS_NAME=
DDNS_PASS=
DDNS_HOST=


[ -z $1 ] && echo "Usage: $0 <NAME> [SSID]" && exit
[ "${1::1}" != "R" ] && ADMIN_PASS=$WIFI_PASS

# WIFI
if [ ! -z `nvram get rt_wpa_psk` ]; then
	if [ ! -z $2 ]; then
		nvram set rt_ssid=$2
		nvram set rt_ssid2=$2
		nvram set wl_ssid=${2}5
		nvram set wl_ssid2=${2}5
	fi
	nvram set rt_wpa_psk=$WIFI_PASS
	nvram set wl_wpa_psk=$WIFI_PASS
fi

# WISP
if [ "$1" = "ROUTER" ]; then
	nvram set wl_mode_x=3
	nvram set wl_sta_wisp=1
	nvram set wl_sta_ssid=$WIFI_STA_SSID
	nvram set wl_channel=157
	nvram set wl_sta_auto=1
fi

# LAN
LEN=$((${#1}-1))
lan_ip=${1:$LEN:1}
expr $lan_ip "+" 0 &> /dev/null || lan_ip=1
nvram set lan_ipaddr=192.168.1.$lan_ip
nvram set dhcp_start=192.168.1.70
nvram set dhcp_end=192.168.1.99
[ "${1::6}" = "Router" ] && nvram set lan_domain=$LAN_DOMAIN

if [ "$1" = "Router" ]; then
	# WAN
	nvram set wan_proto=pppoe
	nvram set wan_pppoe_username=$PPOE_NAME
	nvram set wan_pppoe_passwd=$PPPOE_PASS

	# VTS
	nvram set vts_enable_x=1
	nvram set vts_num_x=4
	nvram set vts_desc_x0=DSM
	nvram set vts_port_x0=5001
	nvram set vts_proto_x0=TCP
	nvram set vts_ipaddr_x0=192.168.1.4
	nvram set vts_desc_x1=HASS
	nvram set vts_port_x1=8123
	nvram set vts_proto_x1=TCP
	nvram set vts_ipaddr_x1=192.168.1.9
	nvram set vts_desc_x2=SSH
	nvram set vts_port_x2=22
	nvram set vts_proto_x2=TCP
	nvram set vts_ipaddr_x2=192.168.1.9
	nvram set vts_desc_x3=VNC
	nvram set vts_port_x3=5900
	nvram set vts_proto_x3=TCP
	nvram set vts_ipaddr_x3=192.168.1.10

	# IPTV
	nvram set udpxy_enable_x=4000
	nvram set viptv_mode=2
	nvram set vlan_vid_iptv=9
	nvram set vlan_vid_lan4=9
	nvram set viptv_ipaddr=10.198.137.188
	nvram set viptv_netmask=255.255.192.0
	nvram set viptv_gateway=10.198.128.1
	nvram set udpxy_wopen=1

	# DDNS
	nvram set ddns_server_x=CUSTOM
	nvram set ddns_username_x=$DDNS_NAME
	nvram set ddns_passwd_x=$DDNS_PASS
	nvram set ddns_hostname_x=$DDNS_HOST
fi

if [ "$lan_ip" = "1" ] && [ "$1" != "ROUTER" ]; then
	# FW
	nvram set https_wopen=1
	nvram set trmd_ropen=1
	nvram set aria_ropen=1
	nvram set ftpd_wopen=1

	# USB
	nvram set enable_samba=1
	nvram set enable_ftp=1
	nvram set trmd_enable=1
	nvram set aria_enable=1
	nvram set acc_username0=admin
	nvram set acc_password0=$ADMIN_PASS
	nvram set acc_num=1
fi

# SYS
nvram set computer_name=`echo ${1::1} | tr  '[a-z]' '[A-Z]'``echo ${1:1} | tr  '[A-Z]' '[a-z]'`
nvram set http_passwd=$ADMIN_PASS
if [ "$1" != "ROUTER" ]; then
	nvram set http_proto=2
	nvram set https_lport=8$lan_ip
fi

nvram commit
reboot
