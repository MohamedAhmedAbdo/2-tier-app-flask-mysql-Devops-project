# 2-Tier App Deployment with CI/CD
## Overview
This project focuses on the deployment of a 2-tier application on AWS infrastructure using Terraform, Ansible, and Jenkins. The application consists of a Flask web server and a MySQL database. The infrastructure includes an EKS cluster, full network setup, and an ECR repository. The CI/CD pipeline is built with Jenkins to automate the deployment process.

## Architecture
<img src=https://github.com/MohamedAhmedAbdo/2-tier-app-flask---MySql---Devops-project/blob/main/Diagrams/project-diagram%20.png>



## Installation and Setup
Follow the steps below to set up and deploy the application:

### 1. Building Infrastructure with Terraform

1. Navigate to the Terraform directory.
2. Run "terraform init" to initialize Terraform.
3. Execute "terraform apply" to create the infrastructure components.
4. Copy the key.pem file to the ansible directory.

### 2. Installing and Configuring Jenkins with Ansible
1. Navigate to the Terraform directory and give key file read permission   .
```bash
cd /ansible
```
```bash
chmod 400 key.pem
```
2. Edit the inventory file and add the public IP of the EC2 instance.
3. Run the Ansible playbook:
```bash
ansible-playbook -i 'instance public ip' -u ubuntu --private-key ./key.pem playbook.yaml
```
### 3. Manual Configuration Steps
1. Connect to the EC2 instance where Jenkins is installed.
2. Retrieve the initial admin password:
```bash
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```
3. Access the Jenkins web interface using the EC2 instance's public IP and port 8080.
4. Install required plugins and create a user account.
5. Create a new pipeline in Jenkins called "FlaskApp-MySQL-Pipeline".
6. Install the "Cloud AWS credentials" plugin from the Jenkins "Manage Plugins" section.
7. Add AWS credentials with an access key and secret key in the Jenkins "Manage Credentials" section, naming it "Terraform".
8. Configure the pipeline by selecting the GitHub project and providing the repository URL.
9. Build the pipeline script from SCM, specifying the Jenkinsfile in the Git repository.
10. Get the DNS name of load balancer and put it in the browser
<https://github.com/MohamedAhmedAbdo/2-tier-app-flask---MySql---Devops-project/blob/main/Diagrams/Bucket%20List.png>

## Usage
1. Once the pipeline is set up, Jenkins will automatically trigger the deployment process whenever there is a new commit to the repository.
2. Monitor the pipeline execution in the Jenkins interface.
3. Retrieve the DNS name of the load balancer from the Jenkins output.
4. Access the deployed Flask application using the load balancer's DNS name in a web browser.


## Conclusion
By following the installation and setup instructions, you can successfully deploy a 2-tier application on AWS infrastructure using Terraform, Ansible, and Jenkins. The CI/CD pipeline automates the deployment process, providing a streamlined and efficient workflow.
