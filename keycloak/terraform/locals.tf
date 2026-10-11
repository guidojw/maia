locals {
  keycloak_clients = {
    for index, client in nonsensitive(var.keycloak_clients) :
    client.client_id => {
      for key, value in client :
      key => (contains(["redirect_uri", "web_origin"], key) ? sensitive(value) : value)
    }
  }
}
