resource "aws_key_pair" "key" {
  key_name   = var.config.key_name
  public_key = file(var.config.public_key_path)
}

resource "aws_security_group" "security_group" {
  name        = var.config.security_group_name
  description = "Security group for ${var.config.instance_name}"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }
  
  dynamic "ingress" {
    for_each = var.config.ingress_rules
    content {
      description = ingress.value.description
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
  
  egress {
    description = "Outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = var.config.tags
}

resource "aws_instance" "instance" {
  ami                    = var.config.ami
  instance_type          = var.config.instance_type
  key_name               = aws_key_pair.key.key_name
  vpc_security_group_ids = [aws_security_group.security_group.id]
  
  tags = merge(
    var.config.tags,
    {
      Name = var.config.instance_name
    }
  )
  
  user_data = file(var.config.user_data_path)

  lifecycle {
    ignore_changes = [user_data]
  }
}

resource "aws_eip" "eip" {
  instance = aws_instance.instance.id
}