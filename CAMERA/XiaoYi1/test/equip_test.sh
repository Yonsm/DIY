
#!/bin/sh

echo "root:1234" | chpasswd

diy=`dirname $0`
echo "$diy/diy.sh" > /etc/init.d/S99diy
chmod +x /etc/init.d/S99diy

cp $diy/www/index.html /home/web/
ln -s /tmp/hd1/record /home/web/
ln -s /tmp/hd1/record_sub /home/web/

#echo CST > /etc/TZ

if [ ! -f $diy/equip_alt.sh ]; then
    sed -i 's/^ifconfig eth0/#&/g' /etc/init.d/S80network
    sed -i 's/^ifconfig eth0/#&/' /home/init.sh
    sed -i 's/^killall telnetd/#&/' /home/init.sh

    echo n | mv -i /home/web/mini_httpd /home/web/mini_httpd.bak
    cp $diy/mini_httpd /home/web/
    cp $diy/rtspsvr /home/
fi

mv equip_test.sh equip_test.sh.bak
reboot
