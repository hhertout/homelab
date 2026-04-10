# ---
# ClusterRole: homelab:admin
# Full access to all resources (except cluster-scoped destructive ops)
# ---

resource "kubernetes_cluster_role" "admin" {
  metadata {
    name = "homelab:admin"
  }

  rule {
    api_groups = ["*"]
    resources  = ["*"]
    verbs      = ["*"]
  }
}

# ---
# ClusterRole: homelab:readonly
# Read-only access across the entire cluster
# ---

resource "kubernetes_cluster_role" "readonly" {
  metadata {
    name = "homelab:readonly"
  }

  rule {
    api_groups = ["", "apps", "batch", "extensions", "networking.k8s.io", "storage.k8s.io"]
    resources = [
      "pods", "pods/log",
      "deployments", "replicasets", "statefulsets", "daemonsets",
      "services", "endpoints", "ingresses",
      "configmaps",
      "persistentvolumeclaims", "persistentvolumes",
      "namespaces", "nodes",
      "jobs", "cronjobs",
    ]
    verbs = ["get", "list", "watch"]
  }
}

# ---
# ClusterRole: homelab:monitoring
# Access needed by Prometheus to scrape metrics across namespaces
# ---

resource "kubernetes_cluster_role" "monitoring" {
  metadata {
    name = "homelab:monitoring"
  }

  rule {
    api_groups = [""]
    resources  = ["nodes", "nodes/metrics", "nodes/proxy", "pods", "pods/log", "services", "endpoints"]
    verbs      = ["get", "list", "watch"]
  }

  rule {
    api_groups = [""]
    resources  = ["configmaps"]
    verbs      = ["get"]
  }

  rule {
    non_resource_urls = ["/metrics", "/metrics/cadvisor"]
    verbs             = ["get"]
  }
}

# ---
# ClusterRoleBindings — bind your service accounts here
# ---

# Example: bind the 'kube' service account to homelab:admin
# resource "kubernetes_cluster_role_binding" "admin_kube" {
#   metadata {
#     name = "homelab:admin:kube"
#   }
#   role_ref {
#     api_group = "rbac.authorization.k8s.io"
#     kind      = "ClusterRole"
#     name      = kubernetes_cluster_role.admin.metadata[0].name
#   }
#   subject {
#     kind      = "ServiceAccount"
#     name      = "kube"
#     namespace = "kube-system"
#   }
# }
