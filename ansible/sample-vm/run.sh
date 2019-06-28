#!/bin/bash

NAME='stack-container'
IMAGE='ubuntu-ansible-stackday'

docker rm --force $NAME

docker run -d -p 2286:22 \
    --name $NAME \
    $IMAGE bash -c '/usr/sbin/sshd -D'

    
