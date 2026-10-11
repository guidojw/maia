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

resource "aws_iam_user" "sharex" {
  name = "sharex"
}

resource "aws_iam_access_key" "sharex_keys" {
  user = aws_iam_user.sharex.name
}

resource "aws_iam_policy" "sharex_policy" {
  name        = "ShareXObjectAccessPolicy"
  description = "Provides object access to the ShareX bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:AbortMultipartUpload",
          "s3:DeleteObject",
          "s3:GetObject",
          "s3:ListMultipartUploadParts",
          "s3:PutObject"
        ]
        Resource = "${aws_s3_bucket.sharex.arn}/*"
      },
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket",
          "s3:ListBucketMultipartUploads"
        ]
        Resource = aws_s3_bucket.sharex.arn
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "attach_sharex" {
  user       = aws_iam_user.sharex.name
  policy_arn = aws_iam_policy.sharex_policy.arn
}

resource "aws_s3_bucket" "terraform_state_bucket" {
  bucket = "terraform-state"
}

resource "aws_s3_bucket" "sharex" {
  bucket = "sharex"
}

resource "aws_iam_user" "anonymous" {
  name = "anonymous"
}

resource "aws_iam_policy" "anonymous_sharex_policy" {
  name        = "SeaweedAnonymousShareXReadPolicy"
  description = "Allows anonymous read access to objects in the ShareX bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "s3:GetObject"
        Resource = "${aws_s3_bucket.sharex.arn}/*"
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "attach_anonymous_sharex" {
  user       = aws_iam_user.anonymous.name
  policy_arn = aws_iam_policy.anonymous_sharex_policy.arn
}
