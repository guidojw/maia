output "seaweedfs_client_secret" {
  value     = keycloak_openid_client.clients["seaweedfs-admin"].client_secret
  sensitive = true
}

output "media_client_secret" {
  value     = keycloak_openid_client.clients["media"].client_secret
  sensitive = true
}
