
variable "server_configs" {
  type = map(object({
    key_name            = string
    security_group_name = string
    ami                 = string
    instance_type       = string
    instance_name       = string
    public_key_path     = string
    user_data_path      = string
    ingress_rules       = list(object({
      description = string
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    }))
    tags               = map(string)
  }))
  
  description = "server configurations"
}