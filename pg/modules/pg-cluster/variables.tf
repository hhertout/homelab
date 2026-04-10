variable "name" {
  description = "Name of the PostgreSQL cluster"
  type        = string
}

variable "namespace" {
  description = "Namespace where the cluster is deployed"
  type        = string
}

variable "instances" {
  description = "Number of PostgreSQL instances (1 primary + N-1 replicas). Use 3 for HA."
  type        = number
  default     = 3
}

variable "postgresql_version" {
  description = "Major PostgreSQL version to deploy"
  type        = number
  default     = 17
}

variable "storage_size" {
  description = "Size of the persistent volume for each instance"
  type        = string
  default     = "10Gi"
}

variable "storage_class" {
  description = "StorageClass to use. Leave null to use the cluster default."
  type        = string
  default     = null
}

variable "superuser_secret_name" {
  description = "Name of the secret holding the superuser credentials (must contain 'username' and 'password')"
  type        = string
}

variable "superuser_username" {
  description = "Superuser username"
  type        = string
  default     = "postgres"
}

variable "superuser_password" {
  description = "Superuser password"
  type        = string
  sensitive   = true
}

variable "database_name" {
  description = "Name of the initial database to create"
  type        = string
  default     = null
}

variable "database_owner" {
  description = "Owner of the initial database"
  type        = string
  default     = null
}

variable "resources" {
  description = "Resource requests and limits for each PostgreSQL instance"
  type = object({
    requests = object({
      cpu    = string
      memory = string
    })
    limits = object({
      cpu    = string
      memory = string
    })
  })
  default = {
    requests = {
      cpu    = "250m"
      memory = "512Mi"
    }
    limits = {
      cpu    = "1"
      memory = "1Gi"
    }
  }
}

variable "backup_enabled" {
  description = "Enable scheduled backups to object storage"
  type        = bool
  default     = false
}

variable "backup_destination_path" {
  description = "S3/object storage path for backups (e.g. s3://my-bucket/pg-backups)"
  type        = string
  default     = null
}

variable "backup_schedule" {
  description = "Cron expression for scheduled backups (e.g. '0 2 * * *' for 2am daily)"
  type        = string
  default     = "0 2 * * *"
}
