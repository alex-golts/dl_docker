#!/bin/bash

open -a xquartz

IP=$(ifconfig en0 | grep inet | awk '$1=="inet" {print $2}')

xhost + $IP

docker run \
	-it \
	-e USER=$USER \
	-e DISPLAY=$IP:0 \
	-e QT_X11_NO_MITSHM=1 \
	-e LUID=$(id -u) \
        -e LGID=$(id -g) \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	-v /Users/$USER:/home/$USER \
	--name ${USER}_$(date +%d_%m_%Y_%H_%M_%S) \
	dl_docker

#	-v /Users/$USER/.Xauthority:/home/dluser/.Xauthority:rw \
