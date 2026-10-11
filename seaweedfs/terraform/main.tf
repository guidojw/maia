resource "aws_iam_user" "tf_admin" {
  name = "terraform-admin"
}

resource "aws_iam_access_key" "tf_admin_keys" {
  user = aws_iam_user.tf_admin.name
}

resource "aws_iam_policy" "admin_policy" {
  name        = "SeaweedFullAdminPolicy"
  description = "Provides full root administrative access to SeaweedFS"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "*"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "attach_admin" {
  user       = aws_iam_user.tf_admin.name
  policy_arn = aws_iam_policy.admin_policy.arn
}

resource "aws_s3_bucket" "terraform_state_bucket" {
  bucket = "terraform-state"
}
