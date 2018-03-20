#!/bin/bash

docker build --build-arg HOME=/home/dluser --build-arg UID=$UID . -t dl_docker
