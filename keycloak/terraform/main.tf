resource "keycloak_realm" "homelab_realm" {
  realm        = "homelab"
  enabled      = true
  display_name = "My Homelab Services"

  sso_session_idle_timeout = "8h0m0s"
  sso_session_max_lifespan = "24h0m0s"

  smtp_server {
    host              = var.smtp_host
    port              = "465"
    from              = var.smtp_from
    from_display_name = "Homelab Auth"

    ssl      = true
    starttls = false

    auth {
      username = var.smtp_username
      password = var.smtp_password
    }
  }

  attributes = {
    "smtpServer.authType" = "basic"
  }
}

resource "keycloak_openid_client" "clients" {
  for_each = toset(keys(local.keycloak_clients))

  realm_id              = keycloak_realm.homelab_realm.id
  client_id             = each.key
  name                  = local.keycloak_clients[each.key].name
  enabled               = true
  access_type           = "CONFIDENTIAL"
  standard_flow_enabled = true
  access_token_lifespan = local.keycloak_clients[each.key].access_token_lifespan

  valid_redirect_uris = [
    local.keycloak_clients[each.key].redirect_uri
  ]

  web_origins = [
    local.keycloak_clients[each.key].web_origin
  ]
}

resource "keycloak_group" "storage_admins" {
  realm_id = keycloak_realm.homelab_realm.id
  name     = "storage-admins"
}

resource "keycloak_openid_group_membership_protocol_mapper" "group_mapper" {
  realm_id  = keycloak_realm.homelab_realm.id
  client_id = keycloak_openid_client.clients["seaweedfs-admin"].id
  name      = "group-membership-mapper"

  claim_name = "groups"
  full_path  = false

  add_to_id_token     = true
  add_to_access_token = true
  add_to_userinfo     = true
}
