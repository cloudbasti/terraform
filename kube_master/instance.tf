# provision key pair for ssh access to node
 resource "aws_key_pair" "kube_master" {
  key_name   = var.key-name
  public_key = file("${path.module}/aws_kubernetes_master.pub")
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
    // here use IP adress of ansible controller node and also change communication
    // to be made available with kube workers
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
resource "aws_eip" "eip_kubemaster" {
instance = aws_instance.kube_master.id
}


# provision the instance itself
resource "aws_instance" "kube_master" {
  ami           = var.ami
  instance_type = var.instance-type
  key_name        = aws_key_pair.kube_master.key_name
  vpc_security_group_ids = [aws_security_group.network-security-group.id]
  tags = {
    Name = var.instance_name
   }
   //user_data = file("${path.module}/startup.sh")
  }


