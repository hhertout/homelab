variable "user_name" {
  description = "Name of the service account / user"
  type        = string
}

variable "namespace" {
  description = "Namespace where the service account is created"
  type        = string
  default     = "kube-system"
}
