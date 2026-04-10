variable "kube_host" {
  description = "Kubernetes API server URL"
  type        = string
}

variable "kube_ca_certificate" {
  description = "Base64-encoded cluster CA certificate"
  type        = string
  sensitive   = true
}

variable "kube_token" {
  description = "Service account token for authentication"
  type        = string
  sensitive   = true
}

# ---
# PostgreSQL cluster credentials
# ---

variable "pg_homelab_superuser_password" {
  description = "Superuser password for the homelab PostgreSQL cluster"
  type        = string
  sensitive   = true
}
