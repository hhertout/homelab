# ---
# Dashboard — Basic Auth secret
# ---

resource "kubernetes_secret" "traefik_dashboard_auth" {
  metadata {
    name      = "traefik-dashboard-auth"
    namespace = "kube-system"
  }

  data = {
    users = var.traefik_dashboard_basic_auth
  }
}

# ---
# Cloudflare API token — used by cert-manager for DNS-01 challenges
# ---

resource "kubernetes_secret" "cloudflare_api_token" {
  metadata {
    name      = "cloudflare-api-token"
    namespace = "cert-manager"
  }

  data = {
    api-token = var.cloudflare_api_token
  }
}

# ---
# Cluster manifests — CRD-dependent resources deployed via local Helm chart
# (Traefik config, ClusterIssuers, Middlewares, IngressRoute)
# ---

resource "helm_release" "cluster_manifests" {
  name      = "cluster-manifests"
  chart     = "${path.module}/charts/cluster-manifests"
  namespace = "kube-system"

  values = [templatefile("${path.module}/values/cluster-manifests.yaml.tpl", {
    letsencrypt_email        = var.letsencrypt_email
    letsencrypt_issuer       = local.letsencrypt_issuer
    traefik_dashboard_domain = var.traefik_dashboard_domain
  })]

  depends_on = [
    helm_release.cert_manager,
    kubernetes_secret.traefik_dashboard_auth,
    kubernetes_secret.cloudflare_api_token,
  ]
}
