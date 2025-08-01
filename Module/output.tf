output "ec2_public_ips" {
  value = aws_instance.my_instance[*].public_ip
  description = "Public Ip addresses of the EC2 instances"
}

output "ec2_private_ips" {
  value = aws_instance.my_instance[*].private_ip
  description = "Private Ip addresses of the EC2 instances"
}