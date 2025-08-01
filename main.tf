# dev-infra module configuration
module "dev-infra" {
    source = "./Module"
    env = "dev"
    instance_count = 2
    instance_type = "t2.micro"
    ami = "ami-020cba7c55df1f615"
    volume_size = 8
}

#stg-infra module configuration
module "stg-infra" {
    source = "./Module"
    env = "stg"
    instance_count = 2
    instance_type = "t2.micro"
    ami = "ami-020cba7c55df1f615"
    volume_size = 8
}

# prod-infra module configuration
module "prod-infra" {
    source = "./Module"
    env = "prod"
    instance_count = 3
    instance_type = "t2.micro"
    ami = "ami-020cba7c55df1f615"
    volume_size = 8
  
}

output "dev_infra_ec2_public_ips" {
  value = module.dev-infra.ec2_public_ips
  description = "Public IP addresses of the EC2 instances in the dev environment"
  
}

output "stg_infra_ec2_public_ips" {
  value = module.stg-infra.ec2_public_ips
  description = "Public IP addresses of the EC2 instances in the staging environment"

}

output "prod_infra_ec2_public_ips" {
  value = module.prod-infra.ec2_public_ips
  description = "Public IP addresses of the EC2 instances in the production environment"

}   