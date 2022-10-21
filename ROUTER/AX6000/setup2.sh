mkdir /data/wing
cd /data/wing
curl -o dns-forwarder https://raw.githubusercontent.com/Yonsm/DIY/master/ROUTER/AX6000/dns-forwarder
curl -o gfwlist.conf https://raw.githubusercontent.com/Yonsm/DIY/master/ROUTER/AX6000/gfwlist.conf
curl -o ipt2socks https://raw.githubusercontent.com/Yonsm/DIY/master/ROUTER/AX6000/ipt2socks
curl -o ss-redir https://raw.githubusercontent.com/Yonsm/DIY/master/ROUTER/AX6000/ss-redir
curl -o trojan https://raw.githubusercontent.com/Yonsm/DIY/master/ROUTER/AX6000/trojan
curl -o wing https://raw.githubusercontent.com/Yonsm/DIY/master/ROUTER/AX6000/wing
/data/wing/wing install $1
