resource "kubernetes_service_account" "this" {
  metadata {
    name      = var.user_name
    namespace = var.namespace
  }
}

resource "kubernetes_secret" "token" {
  metadata {
    name      = "${var.user_name}-token"
    namespace = var.namespace

    annotations = {
      "kubernetes.io/service-account.name" = kubernetes_service_account.this.metadata[0].name
    }
  }

  type = "kubernetes.io/service-account-token"
}
