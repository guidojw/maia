output "seaweedfs_client_secret" {
  value     = keycloak_openid_client.clients["seaweedfs-admin"].client_secret
  sensitive = true
}
