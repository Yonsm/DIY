
#!/bin/sh
[ "$1" == "stop" ] && exit

sd=`dirname $0`
[ -f ../test/equip_alt.sh ] && ../test/equip_alt.sh

$sd/last.sh &
