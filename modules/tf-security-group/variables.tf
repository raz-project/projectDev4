####################################################
# Ingress Rules Variable
# - List of ingress port rules with ports and description
####################################################
variable "ingress_rules" {
  type = list(object({
    from_port   = number
    to_port     = number
    description = string
  }))
}

####################################################
# Egress Rules Variable
# - List of egress port rules with ports and description
####################################################
variable "egress_rules" {
  type = list(object({
    from_port   = number
    to_port     = number
    description = string
  }))
}

####################################################
# Allowed CIDRs Variable
# - List of CIDR blocks allowed for ingress/egress
####################################################
variable "allowed_cidrs" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}

####################################################
# Security Group Name Variable
# - Name of the security group to create
####################################################
variable "sg_name" {
  type    = string
  default = "open-port"
}

####################################################
# Environment Variable
# - Environment tag for resources
####################################################
variable "environment" {
  type    = string
  default = "dev"
}

####################################################
# Managed By Variable
# - ManagedBy tag for resources
####################################################
variable "managed_by" {
  type    = string
  default = "terraform"
}
