## Project Title:
Node Exporter Deployment Automation

## Description:
This project automates the deployment of Node Exporter, a Prometheus exporter for system metrics, using Ansible. It sets up Node Exporter by creating a new user, downloading the release archive, extracting binaries, configuring Node Exporter, setting up systemd service, allowing firewall traffic on port 9100, and integrating with Prometheus.

### File Tree Structure:
    node-exporter-automation/
    │
    ├── README.md
    ├── tasks
    │ └── main.yml
    ├── vars
    │ └── main.yml
    ├── handlers
    │ └── main.yml
    └── templates
    ├── node_exporter_config.j2
    └── node_exporter_service.j2

### Explanation:
1. `README.md:` Provides an overview of the project, its purpose, and instructions on using it.
2. `tasks/main.yml:` Contains Ansible tasks for deploying Node Exporter, including user creation, downloading and extracting binaries, configuring Node Exporter, managing systemd services, allowing firewall traffic, and integrating with Prometheus.
3. `vars/main.yml:` Defines variables used in the deployment process, such as Node Exporter version and user.
4. `handlers/main.yml:` Contains handlers for managing systemd services, specifically to reload systemd after service configuration changes.
5. `templates/node_exporter_config.j2:` Jinja2 template file for generating the Node Exporter configuration file based on provided variables.
6. `templates/node_exporter_service.j2:` Jinja2 template file for generating the systemd service unit file for Node Exporter based on provided variables.

## Usage

1. **Clone Repository**: Clone this repository to your local machine.

2. **Update Variables**: Navigate to `/node-exporter-automation/vars/main.yml` and update the variables as per your requirements.

3. **Execute Playbook**: Run the following command to execute the playbook:
    ```
    ansible-playbook -i inventory-file node_exporter.yml
    ```

## Note:
After cloning this repository, change variables in the `vars/main.yml` file according to your requirements. Then execute the playbook using the `ansible-playbook` command as shown above.
