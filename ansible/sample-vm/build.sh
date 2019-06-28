#!/bin/bash

IMAGE='ubuntu-ansible-stackday'

docker build -t $IMAGE .
docker system prune -f