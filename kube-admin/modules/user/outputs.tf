output "token" {
  description = "Decoded service account token (equivalent of kubectl get secret ... -o jsonpath='{.data.token}' | base64 --decode)"
  value       = kubernetes_secret.token.data["token"]
  sensitive   = true
}

output "service_account_name" {
  description = "Name of the created service account"
  value       = kubernetes_service_account.this.metadata[0].name
}

output "namespace" {
  description = "Namespace of the created service account"
  value       = kubernetes_service_account.this.metadata[0].namespace
}
