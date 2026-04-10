
resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "7.8.23"
  namespace  = "argo"

  create_namespace = true

  values = [templatefile("${path.module}/values/argocd.yaml.tpl", {
    argocd_domain         = var.argocd_domain
    argocd_admin_password = var.argocd_admin_password
    letsencrypt_issuer    = local.letsencrypt_issuer
  })]
}
