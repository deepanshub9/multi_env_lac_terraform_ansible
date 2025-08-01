resource "aws_key_pair" "deployer" {
  key_name   = "${var.env}-terra-automate-key"
  public_key = file("terraform-key.pub")
}



resource "aws_security_group" "allow_user_to_connect" {
  name        = "${var.env}-tws-app-sg"
  description = "Allow user to connect via SG"
  vpc_id      = aws_vpc.main.id


  ingress {
    description = "port 22 allow"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = " allow all outgoing traffic "
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "port 80 allow"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "port 443 allow"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.env}-tws-app-sg"
    Environment = var.env
  }
}

resource "aws_instance" "my_instance" {
  count                  = var.instance_count 
  ami                    = var.ami
  instance_type          = var.instance_type  
  key_name               = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.allow_user_to_connect.id] 
  subnet_id              = aws_subnet.public.id 
  
  tags = {
    Name = "${var.env}-tws-app-instance-${count.index + 1}"  
    Environment = var.env
  }
  
  root_block_device {
    volume_size = var.volume_size 
    volume_type = "gp3"
  }
}