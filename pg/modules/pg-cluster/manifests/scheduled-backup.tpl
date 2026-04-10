apiVersion: postgresql.cnpg.io/v1
kind: ScheduledBackup
metadata:
  name: ${name}-backup
  namespace: ${namespace}
spec:
  schedule: "${backup_schedule}"
  backupOwnerReference: self
  cluster:
    name: ${name}
