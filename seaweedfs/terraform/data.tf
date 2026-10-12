data "kubernetes_secret_v1" "s3_credentials" {
  metadata {
    name      = "seaweedfs-s3-secret"
    namespace = "seaweedfs"
  }
}

data "kubernetes_secret_v1" "s3_cert" {
  metadata {
    name      = "s3-cert"
    namespace = "seaweedfs"
  }
}
