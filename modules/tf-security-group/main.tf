####################################################
# Use Default VPC Data Source
# - Fetches default VPC ID for security group association
####################################################
data "aws_vpc" "default" {
  default = true
}

####################################################
# Security Group Resource
# - Creates a security group in the default VPC
# - Applies dynamic ingress and egress rules from variables
####################################################
resource "aws_security_group" "open_port" {
  name        = var.sg_name
  description = "Security group managed by Terraform"
  vpc_id      = data.aws_vpc.default.id

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = "tcp"
      cidr_blocks = var.allowed_cidrs
      description = ingress.value.description
    }
  }

  dynamic "egress" {
    for_each = var.egress_rules
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = "-1"
      cidr_blocks = var.allowed_cidrs
      description = egress.value.description
    }
  }

  tags = {
    Name        = var.sg_name
    Environment = var.environment
    ManagedBy   = var.managed_by
  }
}

####################################################
# Reminder Local Exec Resource
# - Prints reminder to run configurePolicy.py script
####################################################
resource "null_resource" "reminder_to_run_script" {
  provisioner "local-exec" {
    command = "echo 'Hit the script inside tf-security-group: python configurePolicy.py'"
  }
}
