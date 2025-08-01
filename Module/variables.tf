variable "env" {
  description = "This is the environment for which the resources are being created, e.g., dev, staging, prod"
  type = string
}

variable "instance_type" {
  description = "This is the type of EC2 instance to be created, e.g., t2.micro, m5.large"
  type = string
}

variable "instance_count" {
  description = "This is the number of EC2 instances to be created"
  type = number
}

variable "ami" {
  description = "This is the AMI ID for the EC2 instance"
  type = string
}

variable "volume_size" {
  description = "This is the size of the EBS volume in GB to be attached to the EC2 instance"
  type = number
}
