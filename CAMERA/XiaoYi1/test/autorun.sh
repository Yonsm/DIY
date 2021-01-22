
#!/bin/sh
sd=`dirname $0`
[ -f equip_alt.sh ] && equip_alt.sh

$sd/lastest.sh &
