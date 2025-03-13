#!/bin/sh

MI_DOCKER=`find /mnt -name mi_docker -maxdepth 2 -mindepth 2`
[ -z $MI_DOCKER ] && ls /mnt/* && echo && echo No mi_docker found! && echo && return 1
HASS_DIR=${MI_DOCKER%/*}/.homeassistant

alias docker='$MI_DOCKER/docker-binaries/docker'
alias dockre='dockre() { cat /dev/null > `docker inspect -f "{{json .LogPath}}" $1 | tr -d \"`; docker restart $1; }; dockre'
alias docksh='docksh() { docker exec -it $1 /bin/bash; }; docksh'
alias docklog='docker logs -f'
alias hasssh='docksh homeassistant'
alias hassre='dockre homeassistant'
alias hasslog="docklog homeassistant"
alias mqttsub='mqttsub() { mosquitto_sub -v -t "$1#"; }; mqttsub'

if [ "$1" == "install" ]; then
docker run -d --name=homeassistant --restart=unless-stopped -e TZ=Asia/Shanghai --net=host -v $HASS_DIR:/config ghcr.nju.edu.cn/home-assistant/home-assistant:stable
hasssh << \EOF
	ln -s /config /root/.homeassistant
	cat <<\EOF2 >> ~/.bashrc
	alias l='ls -lF'
	alias ll='ls -alF --color=auto'
	EOF2
EOF
fi
