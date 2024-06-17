# Prometheus project:
This project is used to set up Prometheus, node_exporter & grafana using Ansible playbooks.

Roles
- [Prometheus](https://github.com/shubham9319/prometheus/tree/main/prometheus): This role installs and configures Prometheus on the specified host.
- [Grafana](https://github.com/shubham9319/prometheus/tree/main/grafana): This role installs and configures Grafana on the specified host.
- [Node-exporter](https://github.com/shubham9319/prometheus/tree/main/node-exporter): This role installs and configures Node Exporter on the specified host.

# Ansible Playbook for Prometheus, Grafana, and Node Exporter Setup

This repository contains Ansible playbooks to install and configure Prometheus on a master node and Node Exporter on a worker node. Additionally, it includes the setup of Grafana on the master node for monitoring and visualization purposes.

## Prerequisites

- Ansible installed on your local machine.
- SSH access to the target hosts (`master1` and `worker1`).
- `sudo` privileges on the target hosts.
- A `vars/sudo_password.yml` file containing the necessary sudo passwords for the hosts, encrypted using Ansible Vault.

## Playbooks Overview

### 1. Prometheus and Grafana Setup
--> main.yml
- This playbook installs and configures Prometheus and Grafana on the `master1` host. And node-exporter on the worker nodes.

```yaml
- name: Install and configure Prometheus & Grafana
  hosts: master1
  become: true
  vars_files:
  - vars/sudo_password.yml
  roles:
  - prometheus
  - grafana

- name: Install and configure node-exporter
  hosts: worker1
  become: true
  vars_files:
  - vars/sudo_password.yml
  roles:
  - node-exporter
```

#### Explanation:

- hosts: master1: Specifies that the Prometheus and Grafana roles run on the master1 host.
- hosts: worker1: Specifies that the Node Exporter role runs on the worker1 host.
- become: true: Allows the playbook to execute commands with sudo privileges.
- vars_files: Includes external variables from vars/sudo_password.yml, which contains the sudo password for the hosts.
- roles: Specifies the roles to be executed on the respective hosts.

#### Shell Script
--> main.sh
- This script runs the main.yml playbook and prompts for the Ansible Vault password.

```bash
#!/bin/bash
# This script is used to setup Prometheus, Grafana, & Node Exporter.
ansible-playbook main.yml -i inventory.ini --ask-vault-pass
```

#### Explanation:

- The script executes the main.yml playbook using the inventory file inventory.ini and prompts for the Ansible Vault password with --ask-vault-pass.


#### Setting Up the Environment
1. Clone the repository:
```
git clone https://github.com/yourusername/your-repo-name.git
cd your-repo-name
```

2. Create the vars/sudo_password.yml file and add your sudo password:
```
---
ansible_become_pass: your_sudo_password
```

3. Encrypt the vars/sudo_password.yml file using Ansible Vault:
```
ansible-vault encrypt vars/sudo_password.yml
```
You will be prompted to enter a password for encrypting the file. This password will be required whenever you run the playbooks.

4. Ensure that your inventory file (inventory.ini) is set up correctly with the master1 and worker1 hosts.

5. Run the shell script to execute the playbooks, providing the vault password when prompted:

```
./main.sh
```
