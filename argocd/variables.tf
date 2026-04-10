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

variable "argocd_domain" {
  description = "Domain for the ArgoCD UI (e.g. argocd.homelab.local)"
  type        = string
}

variable "argocd_admin_password" {
  description = "Bcrypt hash of the ArgoCD admin password (generate with: htpasswd -nbBC 10 '' 'password' | tr -d ':')"
  type        = string
  sensitive   = true
}

variable "letsencrypt_staging" {
  description = "Use Let's Encrypt staging server (true) or production (false). Use staging first to avoid rate limits."
  type        = bool
  default     = true
}
