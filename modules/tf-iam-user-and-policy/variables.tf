variable "iam_users" {
  description = "Map of IAM users and their roles"
  type        = map(string)
  default = {
    daniel = "DevOps"
    shira  = "Dev"
    tom    = "HR"
  }
}

resource "aws_iam_user" "users" {
  for_each = var.iam_users
  name     = each.key

  tags = {
    team = each.value
  }
}
