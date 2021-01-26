
#!/bin/sh

echo "root:12345678" | chpasswd

sd=`dirname $0`
ln -s $sd/init.sh /etc/init.d/S99init

cp $sd/www/index.html /home/web/
ln -s /tmp/hd1/record /home/web/
ln -s /tmp/hd1/record_sub /home/web/

#echo CST > /etc/TZ

if [ ! -f $sd/equip_alt.sh ]; then
    sed -i 's/^ifconfig eth0/#&/g' /etc/init.d/S80network
    sed -i 's/^ifconfig eth0/#&/' /home/init.sh
    sed -i 's/^killall telnetd/#&/' /home/init.sh

    echo n | mv -i /home/web/mini_httpd /home/web/mini_httpd.bak
    cp $sd/mini_httpd /home/web/
    cp $sd/rtspsvr /home/
fi

mv equip_test.sh equip_test.sh.bak
reboot
