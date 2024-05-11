## Project Title:
Prometheus Deployment Automation

## Description:
This project automates the deployment of Prometheus, an open-source monitoring and alerting toolkit, using Ansible. It sets up Prometheus by creating necessary directories, downloading the release archive, extracting binaries, configuring Prometheus, and setting up systemd service. Additionally, it ensures the firewall allows traffic on port 9090, the default Prometheus web UI port.

### File Tree Structure:
    prometheus-automation/
    │
    ├── README.md
    ├── tasks
    │   └── main.yml
    ├── vars
    │   └── main.yml
    ├── handlers
    │   └── main.yml
    └── templates
        ├── prometheus_config.j2
        └── prometheus_service.j2

### Explanation:

1. `README.md:` This file provides an overview of the project, its purpose, and instructions on using it.
2. `tasks/main.yml:` This YAML file contains the Ansible tasks necessary to deploy Prometheus. It includes tasks to create a new user, set up directories, download and extract Prometheus binaries, copy necessary files, configure Prometheus, and manage systemd services.
3. `vars/main.yml:` This YAML file defines variables used in the deployment process, such as the Prometheus username and version.
4. `handlers/main.yml:` This YAML file contains handlers used by Ansible to manage systemd services, specifically to reload systemd after service configuration changes.
5. `templates/prometheus_config.j2:` This Jinja2 template file is used to generate the Prometheus configuration file (prometheus.yml) based on the provided template and variables.
6. `templates/prometheus_service.j2:` This Jinja2 template file is used to generate the systemd service unit file (prometheus.service) based on the provided template and variables. It includes instructions for restarting the service if changes are made.

## Usage

1. **Clone Repository**: Clone this repository to your local machine.

2. **Update Variables**: Navigate to `/prometheus/vars/main.yml` and update the variables as per your requirements.

3. **Execute Playbook**: Run the following command to execute the playbook:
    ```
    ansible-playbook -i inventory-file prometheus.yml
    ```

## Note
After cloning this repository, change variables in the `vars/main.yml` file according to your requirements. Then execute the playbook using the `ansible-playbook` command as shown above.
