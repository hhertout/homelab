output "cluster_name" {
  description = "Name of the PostgreSQL cluster"
  value       = kubernetes_manifest.cluster.manifest.metadata.name
}

output "namespace" {
  description = "Namespace of the PostgreSQL cluster"
  value       = var.namespace
}

output "superuser_secret_name" {
  description = "Name of the secret holding superuser credentials"
  value       = kubernetes_secret.superuser.metadata[0].name
}

output "connection_string" {
  description = "Service hostname to reach the primary (read-write)"
  value       = "${var.name}-rw.${var.namespace}.svc.cluster.local"
}

output "connection_string_ro" {
  description = "Service hostname to reach replicas (read-only)"
  value       = "${var.name}-ro.${var.namespace}.svc.cluster.local"
}
