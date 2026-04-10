# Example — namespace with quota, limits and RBAC
module "namespace_example" {
  source = "./modules/namespace"

  name = "kafka"
  labels = {
    env = "homelab"
  }

  quota = {
    requests_cpu    = "2"
    requests_memory = "2Gi"
    limits_cpu      = "4"
    limits_memory   = "4Gi"
    pods            = "20"
  }

  limit_range = {
    default_cpu_limit      = "500m"
    default_memory_limit   = "512Mi"
    default_cpu_request    = "100m"
    default_memory_request = "128Mi"
  }

  role_rules = [
    {
      api_groups = [""]
      resources  = ["pods", "services", "configmaps", "secrets"]
      verbs      = ["get", "list", "watch", "create", "update", "delete"]
    },
    {
      api_groups = ["apps"]
      resources  = ["deployments", "replicasets", "statefulsets"]
      verbs      = ["get", "list", "watch", "create", "update", "delete"]
    },
  ]

  role_binding_subjects = [
    {
      kind      = "ServiceAccount"
      name      = "example"
      namespace = "kube-system"
    },
  ]

  # Uncomment to enable registry pull secret
  # enable_registry_secret = true
  # registry_server        = "registry.example.com"
  # registry_username      = var.registry_username
  # registry_password      = var.registry_password
}
