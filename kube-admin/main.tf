resource "kubernetes_namespace" "test" {
  metadata {
    name = "test"
  }
}

# ---
# cert-manager
# ---

resource "kubernetes_namespace" "cert_manager" {
  metadata {
    name = "cert-manager"
  }
}

resource "helm_release" "cert_manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = "v1.17.0"
  namespace  = kubernetes_namespace.cert_manager.metadata[0].name

  values = [file("${path.module}/values/cert-manager.yaml")]
}

# ---
# MetalLB
# ---

resource "kubernetes_namespace" "metallb" {
  metadata {
    name = "metallb-system"
  }
}

resource "helm_release" "metallb" {
  name       = "metallb"
  repository = "https://metallb.github.io/metallb"
  chart      = "metallb"
  version    = "v0.14.9"
  namespace  = kubernetes_namespace.metallb.metadata[0].name
}

# ---
# Longhorn — distributed block storage
# ---

resource "helm_release" "longhorn" {
  name       = "longhorn"
  repository = "https://charts.longhorn.io"
  chart      = "longhorn"
  version    = "1.7.2"
  namespace  = "longhorn-system"

  create_namespace = true

  values = [file("${path.module}/values/longhorn.yaml")]
}