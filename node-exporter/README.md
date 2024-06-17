# Node Exporter Ansible Role

This Ansible role installs and configures the Node Exporter for Prometheus monitoring.

## File Structure
```
node_exporter/
├── handlers/
│ └── main.yml
├── tasks/
│ └── main.yml
├── templates/
│ ├── node_exporter_config.j2
│ └── node_exporter_service.j2
└── vars/
└── main.yml
```

Code Summary 
1. handlers/main.yml

This file contains handlers that are triggered by tasks. In this role, it is used to reload the Node Exporter systemd service.

```yaml
- name: Reload node systemd
  systemd:
    name: node_exporter
    state: restarted
```

2. tasks/main.yml

This file contains the main tasks for setting up the Node Exporter.

```yaml
- name: Create a new user without a home directory
  user:
    name: "{{ node_exp_user }}"
    create_home: false
    shell: /bin/false
    state: present

- name: Download "node_exporter" release archive to /tmp
  get_url:
    url: "https://github.com/prometheus/node_exporter/releases/download/v{{ node_exporter_version }}/node_exporter-{{ node_exporter_version }}.linux-amd64.tar.gz"
    dest: "/tmp/node_exporter-{{ node_exporter_version }}.linux-amd64.tar.gz"
    mode: '0644'

- name: Extract "node_exporter" release archive
  ansible.builtin.unarchive:
    src: "/tmp/node_exporter-{{ node_exporter_version }}.linux-amd64.tar.gz"
    dest: "/tmp"
    remote_src: yes

- name: Clean up the archive
  file:
    path: "/tmp/node_exporter-{{ node_exporter_version }}.linux-amd64.tar.gz"
    state: absent

- name: Copy "node_exporter" binary to /usr/local/bin
  copy:
    src: /tmp/node_exporter-{{ node_exporter_version }}.linux-amd64/node_exporter
    dest: /usr/local/bin/node_exporter
    owner: "{{ node_exp_user }}"
    group: "{{ node_exp_user }}"
    mode: 0755
    remote_src: true

- name: Delete /tmp/node_exporter-{{ node_exporter_version }}.linux-amd64 directory
  file:
    path: /tmp/node_exporter-{{ node_exporter_version }}.linux-amd64
    state: absent

- name: Render Node Exporter Configuration from Jinja2 Template
  template:
    src: node_exporter_config.j2 # Provide the path to your Jinja2 template
    dest: /tmp/node_exporter_config.yml # Temporary file to store the rendered configuration
  delegate_to: master1

- name: Read Rendered Configuration File Content
  command: cat /tmp/node_exporter_config.yml
  register: rendered_config
  delegate_to: master1

- name: Append Rendered Configuration to Prometheus Configuration
  blockinfile:
    path: /etc/prometheus/prometheus.yml
    insertafter: EOF
    content: "{{ rendered_config.stdout }}"
  delegate_to: master1

- name: Replace the content of /etc/systemd/system/node_exporter.service
  template:
    src: node_exporter_service.j2
    dest: /etc/systemd/system/node_exporter.service
    owner: root
    group: root
    mode: 0644
  notify: Reload node systemd

- name: Restart node_exporter
  systemd:
    name: "{{ node_exp_user }}"
    state: restarted

- name: Enable the node_exporter service
  systemd:
    name: "{{ node_exp_user }}"
    enabled: yes

- name: "UFW - Allow 9100 port"
  ufw:
    rule: allow
    port: 9100
    proto: tcp

- name: Restart node_exporter
  systemd:
    name: prometheus
    state: restarted
  delegate_to: master1

- name: Reload systemd daemon
  systemd:
    daemon_reload: yes
  delegate_to: master1
```

3.a. templates/node_exporter_config.j2

This Jinja2 template generates the Node Exporter configuration file. It dynamically sets the scrape targets based on the hosts in the workers group.

```yaml
- job_name: 'node_exporter'
  scrape_interval: 5s
  static_configs:
    - targets: [ {% for host in groups['workers'] %} '{{ hostvars[host]['ansible_host'] }}:9100'{% if not loop.last %}, {% endif %} {% endfor %}]
```

3.b. templates/node_exporter_service.j2

This Jinja2 template generates the systemd service file for Node Exporter.

```yaml
[Unit]
Description=Node Exporter
After=network.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=multi-user.target
```

4. vars/main.yml

This file contains variables used by the role.

```yaml
# vars file for node-exporter
node_exporter_version: "1.6.1"
node_exp_user: "node_exporter"
```

### How to Use This Role
- Clone the repository.
- Include this role in your playbook.
- Ensure you have the necessary variables defined (you can customize vars/main.yml).
