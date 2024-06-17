#!/bin/bash
# This script is used to setup prometheus, grafana, & node-exporter.
ansible-playbook main.yml -i inventory.ini --ask-vault-pass