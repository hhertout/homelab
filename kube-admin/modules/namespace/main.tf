locals {
  has_rbac = length(var.role_rules) > 0

  docker_config = var.enable_registry_secret && var.registry_server != null ? jsonencode({
    auths = {
      (var.registry_server) = {
        username = var.registry_username
        password = var.registry_password
        auth     = base64encode("${var.registry_username}:${var.registry_password}")
      }
    }
  }) : null
}

# ---
# Namespace
# ---

resource "kubernetes_namespace" "this" {
  metadata {
    name   = var.name
    labels = var.labels
  }
}

# ---
# Resource Quota
# ---

resource "kubernetes_resource_quota" "this" {
  count = var.quota != null ? 1 : 0

  metadata {
    name      = "${var.name}-quota"
    namespace = kubernetes_namespace.this.metadata[0].name
  }

  spec {
    hard = merge(
      {
        "requests.cpu"    = var.quota.requests_cpu
        "requests.memory" = var.quota.requests_memory
        "limits.cpu"      = var.quota.limits_cpu
        "limits.memory"   = var.quota.limits_memory
      },
      var.quota.requests_storage != null ? { "requests.storage" = var.quota.requests_storage } : {},
      var.quota.pods != null ? { "pods" = var.quota.pods } : {},
      var.quota.job_batch_limit != null ? { "count/jobs.batch" = var.quota.job_batch_limit } : {},
    )
  }
}

# ---
# LimitRange
# ---

resource "kubernetes_limit_range" "this" {
  count = var.limit_range != null ? 1 : 0

  metadata {
    name      = "${var.name}-limit-range"
    namespace = kubernetes_namespace.this.metadata[0].name
  }

  spec {
    limit {
      type = "Container"

      default = {
        cpu    = var.limit_range.default_cpu_limit
        memory = var.limit_range.default_memory_limit
      }

      default_request = {
        cpu    = var.limit_range.default_cpu_request
        memory = var.limit_range.default_memory_request
      }
    }
  }
}

# ---
# Role
# ---

resource "kubernetes_role" "this" {
  count = local.has_rbac ? 1 : 0

  metadata {
    name      = "${var.name}-role"
    namespace = kubernetes_namespace.this.metadata[0].name
  }

  dynamic "rule" {
    for_each = var.role_rules
    content {
      api_groups = rule.value.api_groups
      resources  = rule.value.resources
      verbs      = rule.value.verbs
    }
  }
}

# ---
# RoleBinding
# ---

resource "kubernetes_role_binding" "this" {
  count = local.has_rbac && length(var.role_binding_subjects) > 0 ? 1 : 0

  metadata {
    name      = "${var.name}-role-binding"
    namespace = kubernetes_namespace.this.metadata[0].name
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = kubernetes_role.this[0].metadata[0].name
  }

  dynamic "subject" {
    for_each = var.role_binding_subjects
    content {
      kind      = subject.value.kind
      name      = subject.value.name
      namespace = lookup(subject.value, "namespace", null)
    }
  }
}

# ---
# Registry secret
# ---

# ---
# Network Policies
# ---

# Deny all ingress and egress by default
resource "kubernetes_network_policy" "default_deny" {
  count = try(var.network_policy.default_deny, true) ? 1 : 0

  metadata {
    name      = "default-deny-all"
    namespace = kubernetes_namespace.this.metadata[0].name
  }

  spec {
    pod_selector {}
    policy_types = ["Ingress", "Egress"]
  }
}

# Allow traffic between pods within the same namespace
resource "kubernetes_network_policy" "allow_same_ns" {
  count = try(var.network_policy.allow_same_ns, true) ? 1 : 0

  metadata {
    name      = "allow-same-namespace"
    namespace = kubernetes_namespace.this.metadata[0].name
  }

  spec {
    pod_selector {}
    policy_types = ["Ingress", "Egress"]

    ingress {
      from {
        pod_selector {}
      }
    }

    egress {
      to {
        pod_selector {}
      }
    }
  }
}

# Allow egress to kube-dns (required for DNS resolution)
resource "kubernetes_network_policy" "allow_dns" {
  count = try(var.network_policy.allow_dns, true) ? 1 : 0

  metadata {
    name      = "allow-dns-egress"
    namespace = kubernetes_namespace.this.metadata[0].name
  }

  spec {
    pod_selector {}
    policy_types = ["Egress"]

    egress {
      to {
        namespace_selector {
          match_labels = {
            "kubernetes.io/metadata.name" = "kube-system"
          }
        }
      }
      ports {
        port     = "53"
        protocol = "UDP"
      }
      ports {
        port     = "53"
        protocol = "TCP"
      }
    }
  }
}

# Allow ingress from the monitoring namespace (Prometheus scraping)
resource "kubernetes_network_policy" "allow_monitoring" {
  count = try(var.network_policy.allow_monitoring, true) ? 1 : 0

  metadata {
    name      = "allow-monitoring-ingress"
    namespace = kubernetes_namespace.this.metadata[0].name
  }

  spec {
    pod_selector {}
    policy_types = ["Ingress"]

    ingress {
      from {
        namespace_selector {
          match_labels = {
            "kubernetes.io/metadata.name" = "monitoring"
          }
        }
      }
    }
  }
}

# Allow egress to the Kubernetes API server
resource "kubernetes_network_policy" "allow_apiserver" {
  count = try(var.network_policy.allow_apiserver, true) ? 1 : 0

  metadata {
    name      = "allow-apiserver-egress"
    namespace = kubernetes_namespace.this.metadata[0].name
  }

  spec {
    pod_selector {}
    policy_types = ["Egress"]

    egress {
      to {
        ip_block {
          cidr = "10.43.0.1/32"
        }
      }
      ports {
        port     = "443"
        protocol = "TCP"
      }
    }

    egress {
      to {
        ip_block {
          cidr = "192.168.1.0/24"
        }
      }
      ports {
        port     = "6443"
        protocol = "TCP"
      }
    }
  }
}

# ---
# Registry secret
# ---

resource "kubernetes_secret" "registry" {
  count = var.enable_registry_secret ? 1 : 0

  metadata {
    name      = "registry-credentials"
    namespace = kubernetes_namespace.this.metadata[0].name
  }

  type = "kubernetes.io/dockerconfigjson"

  data = {
    ".dockerconfigjson" = local.docker_config
  }
}
