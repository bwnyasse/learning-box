#!/bin/sh

export ANSIBLE_CONFIG=ansible.cfg

ansible all \
        -m ping \
        -i hosts