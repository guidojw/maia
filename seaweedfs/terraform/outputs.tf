output "s3_production_access_key" {
  value     = aws_iam_access_key.tf_admin_keys.id
  sensitive = true
}

output "s3_production_secret_key" {
  value     = aws_iam_access_key.tf_admin_keys.secret
  sensitive = true
}

output "s3_sharex_access_key" {
  value     = aws_iam_access_key.sharex_keys.id
  sensitive = true
}

output "s3_sharex_secret_key" {
  value     = aws_iam_access_key.sharex_keys.secret
  sensitive = true
}
