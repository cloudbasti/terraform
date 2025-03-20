# provision key pair for ssh access to node
resource "aws_key_pair" "commander" {
  key_name   = var.key-name
  public_key = file("${path.module}/aws_commander_key.pub")
}

# aws security group rules
resource "aws_security_group" "network-security-group" {
  name        = var.network-security-group-name
  description = "Allow TLS inbound traffic"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }
   ingress {
    description = "https"
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}
  egress {
    description = "out"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}
  tags = {
    Name = "nsg-inbound"
  }
}

# create an elastic ip for the instance
resource "aws_eip" "eip_commander" {
instance = aws_instance.test_instance.id
}


# provision the instance itself
resource "aws_instance" "test_instance" {
  ami           = var.ami
  instance_type = var.instance-type
  key_name        = aws_key_pair.commander.key_name
  vpc_security_group_ids = [aws_security_group.network-security-group.id]
  tags = {
    Name = var.instance_name
   }
   user_data = file("${path.module}/startup.sh")
  }


