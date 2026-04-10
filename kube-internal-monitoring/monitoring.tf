resource "helm_release" "grafana-k8s-monitoring" {
  name             = "grafana-k8s-monitoring"
  repository       = "https://grafana.github.io/helm-charts"
  chart            = "k8s-monitoring"
  version          = "3.8.6"
  namespace        = var.namespace
  create_namespace = true
  atomic           = true
  timeout          = 300

  values = [file("${path.module}/values/values.yaml")]

  set = [
    { name = "cluster.name", value = var.cluster_name },
    { name = "destinations[0].url", value = var.destinations_prometheus_url },
    { name = "destinations[1].url", value = var.destinations_loki_url },
    { name = "clusterMetrics.opencost.opencost.exporter.defaultClusterId", value = var.cluster_name },
    { name = "clusterMetrics.opencost.opencost.prometheus.external.url", value = trimsuffix(var.destinations_prometheus_url, "/push") },
    { name = "alloy-metrics.remoteConfig.url", value = var.fleetmanagement_url },
    { name = "alloy-singleton.remoteConfig.url", value = var.fleetmanagement_url },
    { name = "alloy-logs.remoteConfig.url", value = var.fleetmanagement_url },
  ]

  set_sensitive = [
    { name = "destinations[0].auth.username", value = var.destinations_prometheus_username },
    { name = "destinations[0].auth.password", value = var.destinations_prometheus_password },
    { name = "destinations[1].auth.username", value = var.destinations_loki_username },
    { name = "destinations[1].auth.password", value = var.destinations_loki_password },
    { name = "alloy-metrics.remoteConfig.auth.username", value = var.fleetmanagement_username },
    { name = "alloy-metrics.remoteConfig.auth.password", value = var.fleetmanagement_password },
    { name = "alloy-singleton.remoteConfig.auth.username", value = var.fleetmanagement_username },
    { name = "alloy-singleton.remoteConfig.auth.password", value = var.fleetmanagement_password },
    { name = "alloy-logs.remoteConfig.auth.username", value = var.fleetmanagement_username },
    { name = "alloy-logs.remoteConfig.auth.password", value = var.fleetmanagement_password },
  ]
}