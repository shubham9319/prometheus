## Project Title:
Grafana Deployment Automation

## Description:
This project automates the deployment of Grafana, an open-source platform for monitoring and observability, using Ansible. It adds Grafana's GPG key to the keyring, adds the Grafana repository to the sources.list, installs Grafana, enables the Grafana service, allows firewall traffic on port 3000, and restarts the Grafana service.

### File Tree Structure:
    grafana-automation/
    │
    ├── README.md
    ├── tasks
    │ └── main.yml
    ├── handlers
    │ └── main.yml
    └── vars
    └── main.yml

### Explanation:
1. `README.md:` Provides an overview of the project, its purpose, and instructions on using it.
2. `tasks/main.yml:` Contains Ansible tasks for deploying Grafana, including adding a GPG key, adding a repository, updating the APT cache, installing Grafana, enabling service, allowing firewall traffic, and restarting the service.
3. `handlers/main.yml:` Contains a handler to restart the Grafana service after changes are made.
4. `vars/main.yml:` Defines variables used in the deployment process, such as Grafana GPG key and repository URL.

## Usage

1. **Clone Repository**: Clone this repository to your local machine.

2. **Update Variables**: Navigate to `/grafana/vars/main.yml` and update the variables as per your requirements.

3. **Execute Playbook**: Run the following command to execute the playbook:
    ```
    ansible-playbook -i inventory-file grafana.yml
    ```

## Note:
After cloning this repository, execute the playbook using the `ansible-playbook` command as shown above.
