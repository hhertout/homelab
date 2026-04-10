apiVersion: postgresql.cnpg.io/v1
kind: Cluster
metadata:
  name: ${name}
  namespace: ${namespace}
spec:
  instances: ${instances}
  imageName: "ghcr.io/cloudnative-pg/postgresql:${postgresql_version}"
  primaryUpdateStrategy: unsupervised

  superuserSecret:
    name: ${superuser_secret_name}

  storage:
    size: ${storage_size}
%{ if storage_class != "" ~}
    storageClass: ${storage_class}
%{ endif ~}

  resources:
    requests:
      cpu: "${resources_requests_cpu}"
      memory: "${resources_requests_memory}"
    limits:
      cpu: "${resources_limits_cpu}"
      memory: "${resources_limits_memory}"

  postgresql:
    parameters:
      max_connections: "200"
      shared_buffers: "256MB"
      effective_cache_size: "768MB"
      maintenance_work_mem: "64MB"
      checkpoint_completion_target: "0.9"
      wal_buffers: "16MB"
      default_statistics_target: "100"
      log_min_duration_statement: "1000"

  monitoring:
    enablePodMonitor: false

%{ if database_name != "" ~}
  bootstrap:
    initdb:
      database: ${database_name}
      owner: ${database_owner}
%{ endif ~}

%{ if backup_enabled && backup_destination_path != "" ~}
  backup:
    barmanObjectStore:
      destinationPath: ${backup_destination_path}
      s3Credentials:
        inheritFromIAMRole: true
      wal:
        compression: gzip
    retentionPolicy: 30d
%{ endif ~}
