variable "key-name" {
  type        = string
  description = "Key name for SSH access"
}

variable "network-security-group-name" {
  type        = string
  description = "Name for the security group"
}

variable "ami" {
  type        = string
  description = "AMI ID for the instance"
}

variable "instance-type" {
  type        = string
  description = "EC2 instance type"
}

variable "instance_name" {
  type        = string
  description = "Value of the Name tag for the EC2 instance"
}