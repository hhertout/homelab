# ---
# CloudNativePG Operator
# ---

resource "kubernetes_namespace" "cnpg_system" {
  metadata {
    name = "cnpg-system"
    labels = {
      "app.kubernetes.io/managed-by" = "terraform"
    }
  }
}

resource "helm_release" "cloudnative_pg" {
  name       = "cloudnative-pg"
  repository = "https://cloudnative-pg.github.io/charts"
  chart      = "cloudnative-pg"
  version    = "0.23.0" # operator v1.25 — check https://github.com/cloudnative-pg/charts for latest
  namespace  = kubernetes_namespace.cnpg_system.metadata[0].name

  # Enable leader election for HA (set replicaCount > 1)
  values = [yamlencode({
    replicaCount = 1
    config = {
      data = {
        ENABLE_INSTANCE_MANAGER_INPLACE_UPDATES = "true"
      }
    }
  })]
}
