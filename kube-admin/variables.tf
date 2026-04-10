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
# Traefik
# ---

variable "traefik_dashboard_domain" {
  description = "Domain for the Traefik dashboard (e.g. traefik.homelab.local)"
  type        = string
}

variable "traefik_dashboard_basic_auth" {
  description = "Basic auth credentials in htpasswd format (generate with: htpasswd -nbB user password)"
  type        = string
  sensitive   = true
}

# ---
# Let's Encrypt
# ---

variable "letsencrypt_email" {
  description = "Email address for Let's Encrypt certificate notifications"
  type        = string
}

variable "letsencrypt_staging" {
  description = "Use Let's Encrypt staging server (true) or production (false). Use staging first to avoid rate limits."
  type        = bool
  default     = true
}

# ---
# Cloudflare
# ---

variable "cloudflare_api_token" {
  description = "Cloudflare API token with DNS:Edit permission for the zone (used by cert-manager DNS-01 solver)"
  type        = string
  sensitive   = true
}
