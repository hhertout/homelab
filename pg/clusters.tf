# ---
# Namespaces
# ---

resource "kubernetes_namespace" "pg_homelab" {
  metadata {
    name = "pg-homelab"
    labels = {
      "app.kubernetes.io/managed-by" = "terraform"
    }
  }
}

# ---
# Clusters
# ---

# First apply: terraform apply -target=helm_release.cloudnative_pg
# so that the CRDs exist before creating clusters.

module "cluster_homelab" {
  source    = "./modules/pg-cluster"
  name      = "homelab"
  namespace = kubernetes_namespace.pg_homelab.metadata[0].name

  instances          = 3
  postgresql_version = 17
  storage_size       = "10Gi"

  superuser_secret_name = "homelab-pg-superuser"
  superuser_username    = "postgres"
  superuser_password    = var.pg_homelab_superuser_password

  database_name  = "homelab"
  database_owner = "homelab"

  resources = {
    requests = {
      cpu    = "250m"
      memory = "512Mi"
    }
    limits = {
      cpu    = "1"
      memory = "1Gi"
    }
  }

  depends_on = [helm_release.cloudnative_pg]
}

output "homelab_db_rw" {
  description = "Read-write endpoint for the homelab cluster"
  value       = module.cluster_homelab.connection_string
}

output "homelab_db_ro" {
  description = "Read-only endpoint for the homelab cluster"
  value       = module.cluster_homelab.connection_string_ro
}
