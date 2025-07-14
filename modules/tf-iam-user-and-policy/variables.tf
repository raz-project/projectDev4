####################################################
# IAM Users Variable
# - Map of IAM user names and their roles
####################################################
variable "iam_users" {
  description = "Map of IAM users and their roles"
  type        = map(string)
  default = {
    daniel = "DevOps"
    shira  = "Dev"
    tom    = "HR"
  }
}

