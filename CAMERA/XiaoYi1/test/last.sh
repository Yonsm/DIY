#!/bin/sh
while [ 1 -eq 1 ] 
do
  lastest=$(find /tmp/hd1/record -type f -name *.mp4 | tail -1)
  ln -sf $lastest /home/web/last.mp4
  sleep 60
done
