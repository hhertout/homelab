variable "name" {
  description = "Namespace name"
  type        = string
}

variable "labels" {
  description = "Labels to apply to the namespace"
  type        = map(string)
  default     = {}
}

# ---
# Resource Quota
# ---

variable "quota" {
  description = "Resource quota for the namespace. Set to null to disable."
  type = object({
    requests_cpu     = string
    requests_memory  = string
    requests_storage = optional(string)
    limits_cpu       = string
    limits_memory    = string
    pods             = optional(string)
    job_batch_limit  = optional(number)
  })
  default = {
    requests_cpu     = "4"
    requests_memory  = "7Gi"
    requests_storage = "10Gi"
    limits_cpu       = "6"
    limits_memory    = "8Gi"
    pods             = "20"
    job_batch_limit  = 1
  }
}

# ---
# LimitRange
# ---

variable "limit_range" {
  description = "Default container limits for the namespace. Set to null to disable."
  type = object({
    default_cpu_limit      = string
    default_memory_limit   = string
    default_cpu_request    = string
    default_memory_request = string
  })
  default = null
}

# ---
# RBAC
# ---

variable "role_rules" {
  description = "Rules for the namespace-scoped Role. Leave empty to skip Role and RoleBinding creation."
  type = list(object({
    api_groups = list(string)
    resources  = list(string)
    verbs      = list(string)
  }))
  default = []
}

variable "role_binding_subjects" {
  description = "Subjects to bind to the Role (users, groups, or service accounts)."
  type = list(object({
    kind      = string
    name      = string
    namespace = optional(string)
  }))
  default = []
}

# ---
# Network Policies
# ---

variable "network_policy" {
  description = "Default network policy configuration for the namespace."
  type = object({
    default_deny     = optional(bool, true)  # deny all ingress+egress by default
    allow_same_ns    = optional(bool, true)  # allow traffic within the same namespace
    allow_dns        = optional(bool, true)  # allow egress to kube-dns (port 53)
    allow_monitoring = optional(bool, true)  # allow ingress from monitoring namespace (Prometheus scraping)
  })
  default = {}
}

# ---
# Registry secret
# ---

variable "enable_registry_secret" {
  description = "Whether to create a Docker registry pull secret"
  type        = bool
  default     = false
}

variable "registry_server" {
  description = "Registry server URL (e.g. registry.example.com)"
  type        = string
  default     = null
}

variable "registry_username" {
  description = "Registry username"
  type        = string
  sensitive   = true
  default     = null
}

variable "registry_password" {
  description = "Registry password"
  type        = string
  sensitive   = true
  default     = null
}
