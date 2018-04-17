#!/bin/bash

################################################################################
# This is supposedly insecure... use Google to find a safer solution if you like
#xhost +local:root
################################################################################
#IP=$(ifconfig en0 | grep inet | awk '$1=="inet" {print $2}')

IP=$(hostname -I|cut -f1 -d ' ')
xhost + $IP

nvidia-docker run \
	-it \
	-e USER=$USER \
	-e DISPLAY=$DISPLAY \
	-e QT_X11_NO_MITSHM=1 \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	-v /home/$USER:/home/$USER \
	--user dluser \
	dl_docker
