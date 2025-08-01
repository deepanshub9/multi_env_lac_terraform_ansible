#!/bin/bash

# Paths and Variables
TERRAFORM_OUTPUT_DIR=".."  
ANSIBLE_INVENTORY_DIR="./inventories"

# Navigate to the Terraform directory
cd "$TERRAFORM_OUTPUT_DIR" || { echo "Terraform directory not found"; exit 1; }

# Fetch IPs from Terraform outputs (without jq)
DEV_IPS=$(terraform output dev_infra_ec2_public_ips | tr -d '[]",' | tr '\n' ' ')
STG_IPS=$(terraform output stg_infra_ec2_public_ips | tr -d '[]",' | tr '\n' ' ')
PRD_IPS=$(terraform output prd_infra_ec2_public_ips | tr -d '[]",' | tr '\n' ' ')

# Function to update inventory file
update_inventory_file() {
    local ips="$1"
    local inventory_file="$2"
    local env="$3"

    # Navigate back to ansible directory for inventory creation
    cd - > /dev/null
    
    # Create or clear the inventory file
    > "$inventory_file"

    # Write the inventory header
    echo "[servers]" >> "$inventory_file"

    # Add dynamic hosts based on IPs
    local count=1
    for ip in $ips; do
        if [[ -n "$ip" ]]; then  # Only add non-empty IPs
            echo "server${count} ansible_host=$ip" >> "$inventory_file"
            count=$((count + 1))
        fi
    done

    # Add common variables
    echo "" >> "$inventory_file"
    echo "[servers:vars]" >> "$inventory_file"
    echo "ansible_user=ubuntu" >> "$inventory_file"
    echo "ansible_ssh_private_key_file=~/terraform-key" >> "$inventory_file"
    echo "ansible_python_interpreter=/usr/bin/python3" >> "$inventory_file"
    echo "ansible_ssh_common_args='-o StrictHostKeyChecking=no'" >> "$inventory_file"

    echo "Updated $env inventory: $inventory_file"
    
    # Go back to terraform directory
    cd "$TERRAFORM_OUTPUT_DIR"
}

# Update each inventory file
update_inventory_file "$DEV_IPS" "$ANSIBLE_INVENTORY_DIR/dev" "dev"
update_inventory_file "$STG_IPS" "$ANSIBLE_INVENTORY_DIR/stg" "stg"
update_inventory_file "$PRD_IPS" "$ANSIBLE_INVENTORY_DIR/prd" "prd"

echo "All inventory files updated successfully!"