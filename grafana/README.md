File Tree Structure
===================
```
grafana/
├── handlers/
│   └── main.yml
├── tasks/
│   └── main.yml
└── vars/
    └── main.yml
```

Code Summary
1. handlers/main.yml: This file defines actions that are triggered by notifications from other tasks.

```
- name: Start Grafana Service
  systemd:
    name: grafana-server
    state: restarted
```
- Purpose: Restart the Grafana service.
- Systemd Module: Uses the systemd Ansible module to manage the grafana-server service, ensuring it is restarted.

2. tasks/main.yml: This file contains the main tasks that will be executed to set up Grafana.

```
# tasks file for grafana
- name: Add Grafana GPG key to keyring
  shell: "{{ grafana_gpg_key }}"
  ignore_errors: true
  changed_when: false

- name: Add Grafana repository to sources.list
  shell: "{{ grafana_repo }}"

- name: Update APT cache
  apt:
    update_cache: yes

- name: Install Grafana
  apt:
    name: grafana
    state: present
  notify:
  - Start Grafana Service

- name: Enable the Grafana service
  systemd:
    name: grafana-server
    enabled: yes
  become: true

- name: "UFW - Allow 3000 port"
  ufw:
    rule: allow
    port: 3000
    proto: TCP
```

- Add Grafana GPG key to keyring: Runs a shell command to add the Grafana GPG key to the keyring, ignoring errors and not marking the task as changed.
- Add Grafana repository to sources.list: Runs a shell command to add the Grafana repository to the system's sources list.
- Update APT cache: Uses the apt module to update the package cache.
- Install Grafana: Uses the apt module to install the Grafana package. This task triggers a notification to restart the Grafana service.
- Enable the Grafana service: Uses the systemd module to ensure the Grafana service is enabled to start on boot, with elevated privileges.
- UFW - Allow 3000 port: Configures the firewall to allow TCP traffic on port 3000, which is the default port for Grafana.

3. vars/main.yml:
This file defines variables used in the playbook.
```
# vars file for grafana
grafana_gpg_key: "wget -q -O - https://apt.grafana.com/gpg.key | gpg --dearmor | sudo tee /etc/apt/keyrings/grafana.gpg > /dev/null"
grafana_repo: 'echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list'
```

- grafana_gpg_key: Command to download and add the Grafana GPG key to the system's keyring.
- grafana_repo: Command to add the Grafana repository to the system's sources list.

### Overall Workflow
1. Handlers: Define actions to manage the Grafana service, particularly restarting it.
2. Tasks:
- Add the Grafana GPG key and repository.
- Update the package list.
- Install Grafana and notify the service to restart.
- Enable the Grafana service to start on boot.
- Configure the firewall to allow traffic on Grafana's port.
3. Variables: Store commands used in tasks for managing the GPG key and repository.
