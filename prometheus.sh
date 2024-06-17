#!/bin/bash
# This script is used to setup prometheus.
ansible-playbook prometheus.yml -i inventory.ini --ask-vault-pass