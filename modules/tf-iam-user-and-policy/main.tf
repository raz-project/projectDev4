resource "aws_iam_user_policy_attachment" "admin_attachment" {
  for_each = {
    for name, role in var.iam_users : name => role if role == "DevOps"
  }
  user       = aws_iam_user.users[each.key].name
  policy_arn = data.aws_iam_policy.admin.arn

}

resource "aws_iam_user_policy_attachment" "readonly_attachment" {
  for_each = {
    for name, role in var.iam_users : name => role if role == "Dev"
  }
  user       = aws_iam_user.users[each.key].name
  policy_arn = data.aws_iam_policy.readonly.arn

}

resource "aws_iam_user_policy_attachment" "create_user_attachment" {
  for_each = {
    for name, role in var.iam_users : name => role if role == "HR"
  }
  user       = aws_iam_user.users[each.key].name
  policy_arn = aws_iam_policy.create_user_policy.arn

}

# Get built-in AWS policies
data "aws_iam_policy" "admin" {
  arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

data "aws_iam_policy" "readonly" {
  arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

# Custom policy for HR role - only allow CreateUser and ListUsers
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


