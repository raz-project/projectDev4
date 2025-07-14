variable "ingress_rules" {
  type = list(object({
    from_port   = number
    to_port     = number
    description = string
  }))
}

variable "egress_rules" {
  type = list(object({
    from_port   = number
    to_port     = number
    description = string
  }))
}

variable "allowed_cidrs" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}

variable "sg_name" {
  type    = string
  default = "open-port"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "managed_by" {
  type    = string
  default = "terraform"
}
