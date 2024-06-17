# Prometheus Ansible Role

This Ansible role installs and configures the prometheus for monitoring.

## File Structure
```
prometheus/
├── handlers/
│   └── main.yml
├── tasks/
│   └── main.yml
├── templates/
│   ├── prometheus_config.j2
│   └── prometheus_service.j2
└── vars/
    └── main.yml
```

### Files and Their Purposes

1. handlers/main.yml

This handler reloads systemd to apply changes after configuring Prometheus.

```yaml
- name: Reload systemd
  systemd:
    name: prometheus
    state: restarted
```

2. tasks/main.yml

This file contains tasks for setting up Prometheus:

```yaml
- name: Create a new user without a home directory
  user:
    name: "{{ username }}"
    create_home: false
    shell: /bin/false
    state: present

- name: Create /etc/prometheus directory
  file:
    path: /etc/prometheus
    owner: "{{ username }}"
    group: "{{ username }}"
    state: directory

- name: Create /var/lib/prometheus directory
  file:
    path: /var/lib/prometheus
    owner: "{{ username }}"
    group: "{{ username }}"
    state: directory

- name: Download Prometheus release archive to /tmp
  get_url:
    url: "https://github.com/prometheus/prometheus/releases/download/v{{ prometheus_version }}/prometheus-{{ prometheus_version }}.linux-amd64.tar.gz"
    dest: "/tmp/prometheus-{{ prometheus_version }}.linux-amd64.tar.gz"
    mode: '0644'

- name: Extract Prometheus release archive
  ansible.builtin.unarchive:
    src: "/tmp/prometheus-{{ prometheus_version }}.linux-amd64.tar.gz"
    dest: "/tmp"
    remote_src: yes

- name: Clean up the archive
  file:
    path: "/tmp/prometheus-{{ prometheus_version }}.linux-amd64.tar.gz"
    state: absent

- name: Copy Prometheus binary to /usr/local/bin
  copy:
    src: /tmp/prometheus-{{ prometheus_version }}.linux-amd64/prometheus
    dest: /usr/local/bin/prometheus
    owner: "{{ username }}"
    group: "{{ username }}"
    mode: 0755
    remote_src: true
  become: true

- name: Copy promtool binary to /usr/local/bin
  copy:
    src: /tmp/prometheus-{{ prometheus_version }}.linux-amd64/promtool
    dest: /usr/local/bin/promtool
    owner: "{{ username }}"
    group: "{{ username }}"
    mode: 0755
    remote_src: true
  become: true

- name: Copy Prometheus consoles to /etc/prometheus
  copy:
    src: /tmp/prometheus-{{ prometheus_version }}.linux-amd64/consoles
    dest: /etc/prometheus
    owner: "{{ username }}"
    group: "{{ username }}"
    mode: 0755
    remote_src: true
  become: true

- name: Copy promtool console_libraries to /usr/local/bin
  copy:
    src: /tmp/prometheus-{{ prometheus_version }}.linux-amd64/console_libraries
    dest: /etc/prometheus
    owner: "{{ username }}"
    group: "{{ username }}"
    mode: 0755
    remote_src: true
  become: true

- name: Delete /tmp/prometheus directory
  file:
    path: /tmp/prometheus-{{ prometheus_version }}.linux-amd64
    state: absent

- name: Replace the content of /etc/prometheus/prometheus.yml
  template:
    src: prometheus_config.j2
    dest: /etc/prometheus/prometheus.yml
    owner: "{{ username }}"
    group: "{{ username }}"
    mode: 0644
  become: true

- name: Replace the content of /etc/systemd/system/prometheus.service
  template:
    src: prometheus_service.j2
    dest: /etc/systemd/system/prometheus.service
    owner: root
    group: root
    mode: 0644
  become: true
  notify: Reload systemd

- name: Reload systemd to apply changes
  systemd:
    name: prometheus
    state: restarted
  become: true

- name: Enable the prometheus service
  systemd:
    name: "{{ username }}"
    enabled: yes
  become: true

- name: "UFW - Allow 9090 port"
  ufw:
    rule: allow
    port: 9090
    proto: tcp
```

- Create a new user: Creates a user without a home directory.
- Create directories: Sets up directories /etc/prometheus and /var/lib/prometheus.
- Download and extract Prometheus: Fetches the Prometheus release archive, extracts it, and cleans up.
- Copy binaries and resources: Installs Prometheus binaries (prometheus and promtool) and copies consoles and libraries.
- Configure Prometheus: Generates configuration file (prometheus.yml) and systemd service unit file (prometheus.service).
- Manage systemd service: Ensures Prometheus service is restarted and enabled.
- Manage firewall: Allows port 9090 through UFW.

3.a. templates/prometheus_config.j2

Template for Prometheus configuration (prometheus.yml), specifying scrape targets and intervals.

```yaml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'prometheus'
    scrape_interval: 5s
    static_configs:
      - targets: ['localhost:9090']
```

3.b. templates/prometheus_service.j2

Template for Prometheus systemd service (prometheus.service), defining startup parameters and paths.

```yaml
[Unit]
Description=Prometheus Monitoring
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/bin/prometheus \
    --config.file=/etc/prometheus/prometheus.yml \
    --storage.tsdb.path=/var/lib/prometheus/ \
    --web.console.templates=/etc/prometheus/consoles \
    --web.console.libraries=/etc/prometheus/console_libraries

[Install]
WantedBy=multi-user.target
```

4. vars/main.yml

Variables used in the role (username and prometheus_version).

```yaml
# vars file for prometheus
username: "prometheus"
prometheus_version: "2.47.1"
```

### Usage
- Clone this repository into your Ansible roles directory.

- Customize vars/main.yml if necessary.

- Include prometheus in your playbook.

- Run your playbook to deploy and configure Prometheus:

```yaml
ansible-playbook -i inventory playbook.yml
```
