# This file is now used only for variable definitions that aren't stored in JSON files

# If you have any global variables you still want to define, you can put them here
# For example:

variable "project_name" {
  description = "The name of the project"
  type        = string
  default     = "k8s-cluster"
}

variable "environment" {
  description = "The environment (e.g. dev, staging, prod)"
  type        = string
  default     = "production"
}

variable "config" {
  description = "Server configuration"
  type = object({
    key_name            = string
    security_group_name = string
    ami                 = string
    instance_type       = string
    instance_name       = string
    public_key_path     = string
    private_key_path    = string
    user_data_path      = string
    ingress_rules       = list(object({
      description = string
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    }))
    tags                = map(string)
  })
  default = null
}