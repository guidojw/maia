variable "s3_endpoint" {
  type        = string
  description = "S3 endpoint"
  sensitive   = true
}

variable "s3_access_key" {
  type        = string
  description = "S3 access key"
  sensitive   = true
}

variable "s3_secret_key" {
  type        = string
  description = "S3 secret key"
  sensitive   = true
}
