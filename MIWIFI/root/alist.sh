#!/bin/sh

MI_DOCKER=`find /mnt -name mi_docker -maxdepth 2 -mindepth 2`
[ -z $MI_DOCKER ] && XY_DIR=/etc/.alist || XY_DIR=${MI_DOCKER%/*}/.alist

[ ! -d $XY_DIR ] && mkdir $XY_DIR

mytokenfilesize=$(cat $XY_DIR/mytoken.txt)
mytokenstringsize=${#mytokenfilesize}
if [ $mytokenstringsize -le 31 ]; then
	echo -e "\033[32m"
	read -p "输入你的阿里云盘 Token（32位长）: " token
	token_len=${#token}
	if [ $token_len -ne 32 ]; then
		echo "长度不对,阿里云盘 Token是32位长"
		echo -e "安装停止，请参考指南配置文件\nhttps://xiaoyaliu.notion.site/xiaoya-docker-69404af849504fa5bcf9f2dd5ecaa75f \n"
		echo -e "\033[0m"
		exit
	else	
		echo $token > $XY_DIR/mytoken.txt
	fi
	echo -e "\033[0m"
fi

myopentokenfilesize=$(cat $XY_DIR/myopentoken.txt)
myopentokenstringsize=${#myopentokenfilesize}
if [ $myopentokenstringsize -le 279 ]; then
	echo -e "\033[33m"
        read -p "输入你的阿里云盘 Open Token（280位长或者335位长）: " opentoken
	opentoken_len=${#opentoken}
        if [[ $opentoken_len -ne 280 ]] && [[ $opentoken_len -ne 335 ]]; then
                echo "长度不对,阿里云盘 Open Token是280位长或者335位"
		echo -e "安装停止，请参考指南配置文件\nhttps://xiaoyaliu.notion.site/xiaoya-docker-69404af849504fa5bcf9f2dd5ecaa75f \n"
		echo -e "\033[0m"
                exit
        else
        	echo $opentoken > $XY_DIR/myopentoken.txt
	fi
	echo -e "\033[0m"
fi

folderidfilesize=$(cat $XY_DIR/temp_transfer_folder_id.txt)
folderidstringsize=${#folderidfilesize}
if [ $folderidstringsize -le 39 ]; then
	echo -e "\033[36m"
        read -p "输入你的阿里云盘转存目录folder id: " folderid
	folder_id_len=${#folderid}
	if [ $folder_id_len -ne 40 ]; then
                echo "长度不对,阿里云盘 folder id是40位长"
		echo -e "安装停止，请参考指南配置文件\nhttps://xiaoyaliu.notion.site/xiaoya-docker-69404af849504fa5bcf9f2dd5ecaa75f \n"
		echo -e "\033[0m"
                exit
        else
        	echo $folderid > $XY_DIR/temp_transfer_folder_id.txt
	fi	
	echo -e "\033[0m"
fi

#echo "new" > $XY_DIR/show_my_ali.txt
[ "$1" == 'host' ] && XY_PORT=6789 || XY_SRC=5678
if [ ! -s $XY_DIR/docker_address.txt ]; then
	XY_IP=$(ifconfig -a|grep inet|grep -v 127.0.0.1|grep -v inet6|awk '{print $2}'|tr -d "addr:"|grep -v 172|head -n1)
	echo "http://$XY_IP:$XY_PORT" > $XY_DIR/docker_address.txt
fi

[ "$1" == 'host' ] && XY_SRC=xiaoyaliu/alist:hostmode || XY_SRC=xiaoyaliu/alist:latest
[ "$1" == 'host' ] && XY_NET=--network=host || XY_NET="-p 5678:80 -p 2345:2345 -p 2346:2346"
# docker stop alist
# docker rm alist
# docker rmi $XY_SRC
docker pull $XY_SRC
if [ -s $XY_DIR/proxy.txt ]; then
	proxy_url=$(head -n1 $XY_DIR/proxy.txt)
	docker run -d $XY_NET --env HTTP_PROXY="$proxy_url" --env HTTPS_PROXY="$proxy_url" --env no_proxy="*.aliyundrive.com" -v $XY_DIR:/data --restart=always --name=alist $XY_SRC
else
	docker run -d $XY_NET -v $XY_DIR:/data --restart=always --name=alist $XY_SRC
fi	
