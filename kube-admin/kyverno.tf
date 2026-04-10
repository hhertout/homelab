/*
resource "helm_release" "kyverno" {
  name       = "kyverno"
  repository = "https://kyverno.github.io/kyverno"
  chart      = "kyverno"
  version    = "3.2.6"
  namespace  = "kyverno"
  create_namespace = true

  values = [yamlencode({
    admissionController  = { replicas = 1 }
    backgroundController = { enabled = true }
    cleanupJobs = {
      admissionReports = {
        image = {
          registry   = "docker.io"
          repository = "bitnami/kubectl"
          tag        = "1.31"
        }
      }
      clusterAdmissionReports = {
        image = {
          registry   = "docker.io"
          repository = "bitnami/kubectl"
          tag        = "1.31"
        }
      }
    }
  })]
}
 */