#!/bin/bash

sudo useradd -u 2000 container-user-0
sudo groupadd -g 3000 container-group-0
sudo useradd -u 2001 container-user-1
sudo groupadd -g 3001 container-group-1
sudo mkdir -p /etc/message/
echo "Hello, World!" | sudo tee -a /etc/message/message.txt
sudo chown 2000:3000 /etc/message/message.txt
sudo chmod 640 /etc/message/message.tx
