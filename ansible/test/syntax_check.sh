#!/bin/sh

export ANSIBLE_CONFIG=ansible.cfg
#chmod 700 ssh_files/id_rsa

for files in $(find playbooks -maxdepth 2 -type f -name "*.yml")
do
    ansible-playbook --syntax-check $files
done
