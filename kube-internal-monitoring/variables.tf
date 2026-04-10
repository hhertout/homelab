variable "kube_host" {
  type = string
}

variable "kube_ca_certificate" {
  type = string
}

variable "kube_token" {
  type = string
}

variable "namespace" {
  type    = string
  default = "default"
}

variable "cluster_name" {
  type    = string
  default = "my-cluster"
}

variable "destinations_prometheus_url" {
  type    = string
  default = "https://prometheus-prod-24-prod-eu-west-2.grafana.net./api/prom/push"
}

variable "destinations_prometheus_username" {
  type    = string
  default = "username"
}

variable "destinations_prometheus_password" {
  type    = string
  default = "my_token"
}

variable "destinations_loki_url" {
  type    = string
  default = "https://logs-prod-012.grafana.net./loki/api/v1/push"
}

variable "destinations_loki_username" {
  type    = string
  default = "username"
}

variable "destinations_loki_password" {
  type    = string
  default = "my_token"
}

variable "fleetmanagement_url" {
  type    = string
  default = "https://fleet-management-prod-011.grafana.net"
}

variable "fleetmanagement_username" {
  type    = string
  default = "username"
}

variable "fleetmanagement_password" {
  type    = string
  default = "my_token"
}