#!/bin/bash
#

export ANSIBLE_CONFIG=ansible.cfg

readonly TARGET='vps'

ansible-playbook -i hosts playbooks/${TARGET}/${TARGET}.yml