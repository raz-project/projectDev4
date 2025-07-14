####################################################
# IAM Users Outputs
####################################################

output "iam_user_names" {
  description = "List of IAM user names"
  value       = [for user in aws_iam_user.users : user.name]
}

output "iam_user_arns" {
  description = "Map of IAM user ARNs"
  value       = { for name, user in aws_iam_user.users : name => user.arn }
}

output "user_names" {
  description = "List of IAM user names"
  value       = [for user in aws_iam_user.users : user.name]
}

output "user_arns" {
  description = "Map of IAM user ARNs"
  value       = { for name, user in aws_iam_user.users : name => user.arn }
}

output "user_roles" {
  description = "Roles assigned to each user"
  value       = var.iam_users
}
