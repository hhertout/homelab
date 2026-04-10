/* resource "helm_release" "kyverno_policies" {
  name      = "kyverno-policies"
  chart     = "${path.module}/charts/kyverno-policies"
  namespace = "kyverno"

  depends_on = [helm_release.kyverno]
}
 */