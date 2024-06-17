#!/bin/bash
# This script is used to setup grafana.
ansible-playbook grafana.yml -i inventory.ini --ask-vault-pass