# Multi-Environment Infrastructure with Terraform and Ansible

[![Terraform](https://img.shields.io/badge/Terraform-v1.0+-7C3AED?logo=terraform&logoColor=white)](https://terraform.io)
[![Ansible](https://img.shields.io/badge/Ansible-v2.9+-EE0000?logo=ansible&logoColor=white)](https://ansible.com)
[![AWS](https://img.shields.io/badge/AWS-Cloud-FF9900?logo=amazon-aws&logoColor=white)](https://aws.amazon.com)

A robust Infrastructure as Code (IaC) solution that provisions and manages multi-environment AWS infrastructure using Terraform modules and automates application deployment with Ansible playbooks.

## 🎯 Purpose and Key Features

This project demonstrates a complete DevOps workflow for managing infrastructure across multiple environments:

### **Infrastructure Management (Terraform)**

- **Multi-Environment Support**: Separate infrastructure for Development, Staging, and Production
- **Modular Architecture**: Reusable Terraform modules for consistent infrastructure patterns
- **AWS Resources**: EC2 instances, VPC, subnets, security groups, S3 buckets, and DynamoDB tables
- **State Management**: Centralized Terraform state management with backup capabilities
- **Auto-scaling Ready**: Configurable instance counts per environment

### **Configuration Management (Ansible)**

- **Automated Provisioning**: Nginx installation and configuration via Ansible roles
- **Dynamic Inventories**: Automated inventory generation from Terraform outputs
- **Multi-Environment Playbooks**: Environment-specific configuration management
- **Idempotent Operations**: Consistent and repeatable deployment processes

### **DevOps Features**

- **Infrastructure as Code**: Version-controlled infrastructure definitions
- **Environment Isolation**: Separate AWS resources per environment
- **Automated Workflows**: Scripts for seamless infrastructure-to-configuration pipeline
- **Cost Optimization**: Environment-specific resource sizing

## 📋 Prerequisites

### **Required Software and Versions**

| Tool          | Version | Purpose                           |
| ------------- | ------- | --------------------------------- |
| **Terraform** | ≥ 1.0.0 | Infrastructure provisioning       |
| **Ansible**   | ≥ 2.9.0 | Configuration management          |
| **AWS CLI**   | ≥ 2.0.0 | AWS authentication and operations |
| **Python**    | ≥ 3.8   | Ansible runtime                   |
| **Git**       | ≥ 2.20  | Version control                   |
| **jq**        | ≥ 1.6   | JSON processing for scripts       |

### **AWS Requirements**

- AWS Account with appropriate permissions
- IAM user with programmatic access
- AWS CLI configured with credentials
- Required AWS permissions for EC2, VPC, S3, DynamoDB, and IAM

### **System Requirements**

- **OS**: Linux, macOS, or Windows with WSL
- **RAM**: Minimum 4GB (8GB recommended)
- **Storage**: 2GB free space
- **Network**: Internet connectivity for AWS API calls

## 🚀 Installation and Setup

### **1. Clone the Repository**

```bash
git clone https://github.com/deepanshub9/multi_env_lac_terraform_ansible.git
cd multi_env_lac_terraform_ansible
```

### **2. Install Required Tools**

#### **Ubuntu/Debian:**

```bash
# Update package manager
sudo apt update

# Install Terraform
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform

# Install Ansible
sudo apt install ansible python3-pip jq

# Install AWS CLI
pip3 install awscli
```

#### **macOS:**

```bash
# Using Homebrew
brew install terraform ansible awscli jq
```

#### **Windows (WSL):**

```powershell
# Install WSL if not already installed
wsl --install -d Ubuntu

# Then follow Ubuntu instructions inside WSL
```

### **3. Configure AWS Credentials**

```bash
# Configure AWS CLI
aws configure
# Enter your AWS Access Key ID, Secret Access Key, and default region (us-east-1)

# Verify AWS configuration
aws sts get-caller-identity
```

### **4. Generate SSH Key Pair**

```bash
# Generate SSH key for EC2 instances
ssh-keygen -t rsa -b 4096 -f terraform-key -N ""

# Move keys to project root
mv terraform-key terraform-key.pub ./
chmod 600 terraform-key
```

### **5. Set Up Python Virtual Environment (for Ansible)**

```bash
# Create virtual environment
python3 -m venv ansible_env

# Activate virtual environment
source ansible_env/bin/activate  # Linux/macOS
# or
ansible_env\Scripts\activate     # Windows

# Install Ansible requirements
pip install ansible boto3 botocore
```

## 🏗️ Building and Running

### **Infrastructure Deployment**

#### **1. Initialize Terraform**

```bash
# Initialize Terraform working directory
terraform init

# Validate configuration
terraform validate

# Format Terraform files
terraform fmt
```

#### **2. Plan Infrastructure**

```bash
# Review infrastructure changes
terraform plan

# Plan specific environment (optional)
terraform plan -var="env=dev"
```

#### **3. Deploy Infrastructure**

```bash
# Deploy all environments
terraform apply

# Auto-approve (for automation)
terraform apply -auto-approve

# Deploy specific environment
terraform apply -target=module.dev-infra
```

#### **4. Verify Deployment**

```bash
# Check Terraform outputs
terraform output

# List created resources
terraform state list

# Show specific resource details
terraform show
```

### **Configuration Management**

#### **1. Update Ansible Inventories**

```bash
# Navigate to ansible directory
cd ansible

# Make script executable
chmod +x update_inventories.sh

# Generate dynamic inventories from Terraform outputs
./update_inventories.sh
```

#### **2. Test Connectivity**

```bash
# Test connection to all environments
ansible all -i inventories/dev -m ping
ansible all -i inventories/stg -m ping
ansible all -i inventories/prod -m ping

# Test specific environment
ansible servers -i inventories/dev -m ping
```

#### **3. Deploy Applications**

```bash
# Install Nginx on all environments
ansible-playbook -i inventories/dev playbooks/install_ngnix.yml
ansible-playbook -i inventories/stg playbooks/install_ngnix.yml
ansible-playbook -i inventories/prod playbooks/install_ngnix.yml

# Deploy to specific environment with verbose output
ansible-playbook -i inventories/dev playbooks/install_ngnix.yml -v
```

## 🔧 Available Commands

### **Terraform Commands**

```bash
# Core operations
terraform init                    # Initialize working directory
terraform plan                    # Preview changes
terraform apply                   # Apply changes
terraform destroy                 # Destroy infrastructure
terraform refresh                 # Refresh state

# State management
terraform state list              # List resources in state
terraform state show <resource>   # Show resource details
terraform import <resource> <id>  # Import existing resource

# Workspace management
terraform workspace list          # List workspaces
terraform workspace new <name>    # Create workspace
terraform workspace select <name> # Switch workspace

# Output and formatting
terraform output                  # Show outputs
terraform fmt                     # Format files
terraform validate               # Validate configuration
```

### **Ansible Commands**

```bash
# Inventory management
ansible-inventory -i inventories/dev --list    # List inventory
ansible all -i inventories/dev --list-hosts    # List hosts

# Ad-hoc commands
ansible all -i inventories/dev -m ping         # Test connectivity
ansible all -i inventories/dev -m setup        # Gather facts
ansible all -i inventories/dev -a "uptime"     # Run command

# Playbook execution
ansible-playbook -i inventories/dev playbooks/install_ngnix.yml        # Run playbook
ansible-playbook -i inventories/dev playbooks/install_ngnix.yml --check # Dry run
ansible-playbook -i inventories/dev playbooks/install_ngnix.yml -v      # Verbose
ansible-playbook -i inventories/dev playbooks/install_ngnix.yml --limit server1 # Target specific host
```

### **Utility Scripts**

```bash
# Update inventories
./ansible/update_inventories.sh

# Make scripts executable
chmod +x ansible/update_inventories.sh
```

## 🧪 Running Tests

### **Infrastructure Testing**

```bash
# Terraform validation
terraform validate

# Terraform plan check
terraform plan -detailed-exitcode

# Check syntax
terraform fmt -check

# Infrastructure connectivity test
terraform apply -target=module.dev-infra && \
  ansible all -i ansible/inventories/dev -m ping
```

### **Ansible Testing**

```bash
# Syntax check
ansible-playbook --syntax-check -i ansible/inventories/dev ansible/playbooks/install_ngnix.yml

# Dry run
ansible-playbook --check -i ansible/inventories/dev ansible/playbooks/install_ngnix.yml

# Test connectivity
ansible all -i ansible/inventories/dev -m ping

# Test specific module
ansible all -i ansible/inventories/dev -m setup
```

### **End-to-End Testing**

```bash
#!/bin/bash
# Complete deployment test
echo "Testing complete infrastructure deployment..."

# Deploy infrastructure
terraform apply -auto-approve

# Update inventories
cd ansible && ./update_inventories.sh

# Test connectivity
ansible all -i inventories/dev -m ping

# Deploy application
ansible-playbook -i inventories/dev playbooks/install_ngnix.yml

# Verify web service
ansible all -i inventories/dev -m uri -a "url=http://{{ ansible_host }} method=GET"

echo "End-to-end test completed!"
```

## ⚙️ Configuration

### **Environment Variables**

```bash
# AWS Configuration
export AWS_ACCESS_KEY_ID="your-access-key"
export AWS_SECRET_ACCESS_KEY="your-secret-key"
export AWS_DEFAULT_REGION="us-east-1"

# Terraform Configuration
export TF_LOG="INFO"                    # Enable debug logging
export TF_LOG_PATH="./terraform.log"    # Log file path

# Ansible Configuration
export ANSIBLE_HOST_KEY_CHECKING=False  # Disable host key checking
export ANSIBLE_INVENTORY="./ansible/inventories/dev"
export ANSIBLE_PRIVATE_KEY_FILE="./terraform-key"
```

### **Terraform Variables**

Create `terraform.tfvars` file:

```hcl
# terraform.tfvars
aws_region = "us-east-1"

# Environment-specific configurations
dev_instance_count = 2
dev_instance_type = "t2.micro"

stg_instance_count = 2
stg_instance_type = "t2.small"

prod_instance_count = 3
prod_instance_type = "t2.medium"
```

### **Ansible Configuration**

Create `ansible/ansible.cfg`:

```ini
[defaults]
inventory = ./inventories/dev
private_key_file = ../terraform-key
host_key_checking = False
remote_user = ubuntu
timeout = 30
retry_files_enabled = False

[ssh_connection]
ssh_args = -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null
```

## 🐛 Troubleshooting

### **Common Issues and Solutions**

#### **Terraform Issues**

**Issue**: `Error: No valid credential sources found`

```bash
# Solution: Configure AWS credentials
aws configure
# Or set environment variables
export AWS_ACCESS_KEY_ID="your-key"
export AWS_SECRET_ACCESS_KEY="your-secret"
```

**Issue**: `Error: Resource already exists`

```bash
# Solution: Import existing resource or use different names
terraform import aws_instance.example i-1234567890abcdef0
# Or destroy and recreate
terraform destroy -target=aws_instance.example
```

**Issue**: `Error: Backend initialization required`

```bash
# Solution: Reinitialize Terraform
terraform init -reconfigure
```

#### **Ansible Issues**

**Issue**: `unreachable` hosts

```bash
# Solution: Check SSH connectivity and keys
ssh -i terraform-key ubuntu@<host-ip>
# Verify inventory file
cat ansible/inventories/dev
# Test connectivity
ansible all -i inventories/dev -m ping
```

**Issue**: `jq: command not found`

```bash
# Solution: Install jq
sudo apt install jq  # Ubuntu/Debian
brew install jq      # macOS
```

**Issue**: Permission denied for private key

```bash
# Solution: Fix key permissions
chmod 600 terraform-key
```

#### **AWS Issues**

**Issue**: `Access Denied` errors

```bash
# Solution: Check IAM permissions
aws sts get-caller-identity
# Ensure user has required permissions for EC2, VPC, S3, DynamoDB
```

**Issue**: `Instance limit exceeded`

```bash
# Solution: Request limit increase or use different instance types
# Check current limits
aws ec2 describe-account-attributes --attribute-names supported-platforms
```

### **Debug Commands**

```bash
# Terraform debugging
export TF_LOG=DEBUG
terraform apply

# Ansible debugging
ansible-playbook -vvv -i inventories/dev playbooks/install_ngnix.yml

# AWS CLI debugging
aws --debug ec2 describe-instances
```

### **Log Locations**

```bash
# Terraform logs
./terraform.log (if TF_LOG_PATH is set)

# Ansible logs
~/.ansible.log (if logging is enabled in ansible.cfg)

# AWS CLI logs
~/.aws/cli/cache/ (credential cache)
```

## 🔄 Deployment Workflow

### **Complete Deployment Process**

```bash
# 1. Initialize project
git clone <repository>
cd multi_env_lac_terraform_ansible

# 2. Setup environment
aws configure
ssh-keygen -t rsa -b 4096 -f terraform-key -N ""

# 3. Deploy infrastructure
terraform init
terraform plan
terraform apply -auto-approve

# 4. Configure applications
cd ansible
chmod +x update_inventories.sh
./update_inventories.sh
ansible-playbook -i inventories/dev playbooks/install_ngnix.yml

# 5. Verify deployment
ansible all -i inventories/dev -m uri -a "url=http://{{ ansible_host }}"
```

### **Environment Management**

```bash
# Deploy to specific environment
terraform apply -target=module.dev-infra
ansible-playbook -i inventories/dev playbooks/install_ngnix.yml

# Scale environment
# Edit main.tf to change instance_count
terraform plan
terraform apply

# Update configurations
./ansible/update_inventories.sh
ansible-playbook -i inventories/dev playbooks/install_ngnix.yml
```

## 📁 Project Structure

```
multi_env_lac_terraform_ansible/
├── README.md                          # This file
├── main.tf                            # Main Terraform configuration
├── provider.tf                        # AWS provider configuration
├── terraform.tf                       # Terraform version constraints
├── terraform.tfvars                   # Variable values (create this)
├── terraform-key                      # SSH private key (generated)
├── terraform-key.pub                  # SSH public key (generated)
├── terraform.tfstate                  # Terraform state file
├── terraform.tfstate.backup           # State backup
├── Module/                             # Terraform modules
│   ├── variables.tf                   # Module variables
│   ├── vpc.tf                         # VPC resources
│   ├── ec2.tf                         # EC2 resources
│   ├── bucket.tf                      # S3 bucket resources
│   ├── dynamodb.tf                    # DynamoDB resources
│   └── output.tf                      # Module outputs
├── ansible/                           # Ansible configuration
│   ├── ansible.cfg                    # Ansible configuration (create this)
│   ├── update_inventories.sh          # Dynamic inventory script
│   ├── inventories/                   # Environment inventories
│   │   ├── dev                        # Development inventory
│   │   ├── stg                        # Staging inventory
│   │   └── prd                        # Production inventory
│   └── playbooks/                     # Ansible playbooks
│       ├── install_ngnix.yml          # Nginx installation playbook
│       └── roles/                     # Ansible roles
│           └── nginx-role/            # Nginx role
│               ├── tasks/main.yml     # Role tasks
│               ├── handlers/main.yml  # Role handlers
│               ├── files/             # Static files
│               ├── templates/         # Jinja2 templates
│               ├── vars/              # Role variables
│               └── defaults/          # Default variables
└── ansible_env/                       # Python virtual environment
    ├── bin/                           # Virtual environment binaries
    ├── lib/                           # Python packages
    └── pyvenv.cfg                     # Virtual environment config
```

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🤝 Contributing

We welcome contributions! Please follow these steps:

1. **Fork the repository**
2. **Create a feature branch**: `git checkout -b feature/amazing-feature`
3. **Commit your changes**: `git commit -m 'Add amazing feature'`
4. **Push to the branch**: `git push origin feature/amazing-feature`
5. **Open a Pull Request**

### **Contribution Guidelines**

- Follow Terraform and Ansible best practices
- Add tests for new features
- Update documentation for changes
- Use conventional commit messages
- Ensure all tests pass before submitting

## 📞 Support and Contact

- **Repository**: [https://github.com/deepanshub9/multi_env_lac_terraform_ansible.git](https://github.com/deepanshub9/multi_env_lac_terraform_ansible)
- **Maintainer**: [@deepanshub9](https://github.com/deepanshub9)
- **Email**: Contact via GitHub issues for project-related questions

### **Getting Help**

1. **Check the troubleshooting section** in this README
2. **Search existing issues** in the GitHub repository
3. **Create a new issue** with detailed information about your problem
4. **Join the discussion** in existing issues

---

**⭐ If this project helps you, please give it a star on GitHub!**

_Built with ❤️ for the DevOps community_
