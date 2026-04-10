# ---
# Superuser secret
# ---

resource "kubernetes_secret" "superuser" {
  metadata {
    name      = var.superuser_secret_name
    namespace = var.namespace
    labels = {
      "cnpg.io/cluster" = var.name
    }
  }

  type = "kubernetes.io/basic-auth"

  data = {
    username = var.superuser_username
    password = var.superuser_password
  }
}

# ---
# PostgreSQL Cluster (CRD)
# ---

resource "kubernetes_manifest" "cluster" {
  manifest = yamldecode(templatefile("${path.module}/manifests/cluster.tpl", {
    name                    = var.name
    namespace               = var.namespace
    instances               = var.instances
    postgresql_version      = var.postgresql_version
    superuser_secret_name   = kubernetes_secret.superuser.metadata[0].name
    storage_size            = var.storage_size
    storage_class           = var.storage_class != null ? var.storage_class : ""
    resources_requests_cpu  = var.resources.requests.cpu
    resources_requests_mem  = var.resources.requests.memory
    resources_limits_cpu    = var.resources.limits.cpu
    resources_limits_mem    = var.resources.limits.memory
    database_name           = var.database_name != null ? var.database_name : ""
    database_owner          = coalesce(var.database_owner, var.database_name, "")
    backup_enabled          = var.backup_enabled
    backup_destination_path = var.backup_destination_path != null ? var.backup_destination_path : ""
  }))

  depends_on = [kubernetes_secret.superuser]
}

# ---
# Scheduled backup (ScheduledBackup CRD)
# ---

resource "kubernetes_manifest" "scheduled_backup" {
  count = var.backup_enabled && var.backup_destination_path != null ? 1 : 0

  manifest = yamldecode(templatefile("${path.module}/manifests/scheduled-backup.tpl", {
    name            = var.name
    namespace       = var.namespace
    backup_schedule = var.backup_schedule
  }))

  depends_on = [kubernetes_manifest.cluster]
}
