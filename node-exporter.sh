#!/bin/bash
# This script is used to setup node-exporter role.
ansible-playbook node-exporter.yml -i inventory.ini --ask-vault-pass