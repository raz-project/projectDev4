####################################################
# IAM Users Creation
####################################################
resource "aws_iam_user" "users" {
  for_each = var.iam_users
  name     = each.key

  tags = {
    team = each.value
  }
}

####################################################
# Attach Admin Policy to DevOps Users
####################################################
resource "aws_iam_user_policy_attachment" "admin_attachment" {
  for_each = {
    for name, role in var.iam_users : name => role if role == "DevOps"
  }
  user       = aws_iam_user.users[each.key].name
  policy_arn = data.aws_iam_policy.admin.arn
}

####################################################
# Attach ReadOnly Policy to Dev Users
####################################################
resource "aws_iam_user_policy_attachment" "readonly_attachment" {
  for_each = {
    for name, role in var.iam_users : name => role if role == "Dev"
  }
  user       = aws_iam_user.users[each.key].name
  policy_arn = data.aws_iam_policy.readonly.arn
}

####################################################
# Attach Custom Create User Policy to HR Users
####################################################
resource "aws_iam_user_policy_attachment" "create_user_attachment" {
  for_each = {
    for name, role in var.iam_users : name => role if role == "HR"
  }
  user       = aws_iam_user.users[each.key].name
  policy_arn = aws_iam_policy.create_user_policy.arn
}

####################################################
# AWS Managed Policies Data Sources
####################################################
data "aws_iam_policy" "admin" {
  arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

data "aws_iam_policy" "readonly" {
  arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

####################################################
# Custom IAM Policy for HR Role
####################################################
resource "aws_iam_policy" "create_user_policy" {
  name        = "CreateUserOnlyPolicy"
  description = "IAM policy to allow creating users only"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "iam:CreateUser",
          "iam:ListUsers"
        ],
        Resource = "*"
      }
    ]
  })
}
