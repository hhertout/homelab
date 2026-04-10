# ---
# Reloader — restarts pods when ConfigMap/Secret changes
# ---

resource "kubernetes_namespace" "reloader" {
  metadata {
    name = "reloader"
  }
}

resource "helm_release" "reloader" {
  name       = "reloader"
  repository = "https://stakater.github.io/stakater-charts"
  chart      = "reloader"
  version    = "1.1.0"
  namespace  = kubernetes_namespace.reloader.metadata[0].name
}
