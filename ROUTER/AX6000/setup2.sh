mkdir /data/wing
cd /data/wing
curl -k -o dns-forwarder https://raw.githubusercontent.com/Yonsm/DIY/master/ROUTER/AX6000/dns-forwarder
curl -k -o gfwlist.conf https://raw.githubusercontent.com/Yonsm/DIY/master/ROUTER/AX6000/gfwlist.conf
curl -k -o ipt2socks https://raw.githubusercontent.com/Yonsm/DIY/master/ROUTER/AX6000/ipt2socks
curl -k -o ss-redir https://raw.githubusercontent.com/Yonsm/DIY/master/ROUTER/AX6000/ss-redir
curl -k -o trojan https://raw.githubusercontent.com/Yonsm/DIY/master/ROUTER/AX6000/trojan
curl -k -o wing https://raw.githubusercontent.com/Yonsm/DIY/master/ROUTER/AX6000/wing
chmod +x /data/wing/wing
/data/wing/wing install $1
