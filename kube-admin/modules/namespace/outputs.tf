output "name" {
  description = "Namespace name"
  value       = kubernetes_namespace.this.metadata[0].name
}

output "role_name" {
  description = "Name of the created Role (null if RBAC disabled)"
  value       = local.has_rbac ? kubernetes_role.this[0].metadata[0].name : null
}
