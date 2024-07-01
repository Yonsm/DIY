#!/bin/sh

dnspod() {
	if [ "$1" = "AAAA" ]; then
		RECORD_TYPE=AAAA
		if [ -n "$IPV6" ]; then
			IP=$IPV6
		elif [ -n "$IFACE" ]; then
			IP=`ifconfig $IFACE|grep inet6|grep -v "inet6 addr: f"|tail -1|tr ' ' /|cut -d / -f 13`
		else
			IP=`curl -s http://6.ipw.cn`
		fi
	else
		RECORD_TYPE=A
		if [ -n "$IPV6" ]; then
			IP=$IPV4
		elif [ -n "$IFACE" ]; then
			IP=`ifconfig $IFACE|grep "inet addr:"|grep -v 127.|grep -v 192.|grep -v 10.|tr ' ' :|cut -d : -f 13`
		else
			IP=`curl -s http://4.ipw.cn`
		fi
	fi

	[ -z $IP ] && echo "Could not get IP for RECORD TYPE $RECORD_TYPE" && echo && return

	echo "$SUB_DOMAIN.$DOMAIN ($RECORD_ID) => [$IP]"
	curl -s -k https://dnsapi.cn/Record.Modify -d "login_token=$ID,$TOKEN&domain=$DOMAIN&sub_domain=$SUB_DOMAIN&record_id=$RECORD_ID$&record_line_id=0&record_type=$RECORD_TYPE&value=$IP" | jq
}

dnspod2() {
	RECORD_ID=`echo "$1" | jq -r ".records[] | select(.name == \"$SUB_DOMAIN\" and .type == \"$2\") | .id" 2>/dev/null`
	RET=$?
	if [ $RET != 0 ]; then
		echo "Could not find $2 record for $SUB_DOMAIN.$DOMAIN"
		[ $RET != 5 ] && echo "$1" || echo "$1" | jq
		exit $RET
	fi
	[ -z "$RECORD_ID" ] && return 1
	dnspod $2
}

[ $# -lt 3 ] && echo "Usage: $0 <ID> <TOKEN> <DOMAIN> [RECORD_ID] [AAAA]" && exit 0

ID=$1
TOKEN=$2
DOMAIN=${3#*.}
SUB_DOMAIN=${3%%.*}
case "$DOMAIN" in
	*.*)
		;;
	*)
		DOMAIN=$3
		SUB_DOMAIN=@
		;;
esac

RECORD_ID=$4
if [ -n "$RECORD_ID" ]; then
	dnspod $5
else
	RECORDS=`curl -s -k https://dnsapi.cn/Record.List -d "login_token=$ID,$TOKEN&domain=$DOMAIN"`
	dnspod2 "$RECORDS" A
	RETA=$?
	dnspod2 "$RECORDS" AAAA
	[ $? != 0 ] && [ $RETA != 0 ] && echo "Could not find A/AAAA record for $SUB_DOMAIN.$DOMAIN"
fi
