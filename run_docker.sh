#!/bin/bash

nvidia-docker run \
	-it \
	-e USER=alexgo \
	-e DISPLAY=$DISPLAY \
	-e QT_X11_NO_MITSHM=1 \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	-v /home/alexgo:/home/alexgo \
	dl_docker
