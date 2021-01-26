#!/bin/sh
cd ${0%/*}

[ -f equip_alt.sh ] && equip_alt.sh
./last.sh &
