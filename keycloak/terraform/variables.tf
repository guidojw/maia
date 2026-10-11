variable "keycloak_url" {
  type        = string
  description = "Keycloak URL"
}

variable "keycloak_username" {
  type        = string
  description = "Keycloak admin username"
}

variable "keycloak_password" {
  type        = string
  description = "Keycloak admin password"
  sensitive   = true
}

variable "smtp_host" {
  type        = string
  description = "SMTP host"
  sensitive   = true
}

variable "smtp_from" {
  type        = string
  description = "SMTP from mail address"
  sensitive   = true
}

variable "smtp_username" {
  type        = string
  description = "SMTP username"
  sensitive   = true
}

variable "smtp_password" {
  type        = string
  description = "SMTP password"
  sensitive   = true
}

variable "keycloak_clients" {
  type = list(object({
    client_id             = string
    name                  = string
    redirect_uri          = string
    web_origin            = string
    access_token_lifespan = optional(string)
  }))
  description = "Keycloak clients"
  sensitive   = true
}
