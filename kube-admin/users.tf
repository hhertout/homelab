module "user_example" {
  source    = "./modules/user"
  user_name = "example"
  namespace = "kube-system"
}

output "user_example_token" {
  description = "Token for the example service account"
  value       = module.user_example.token
  sensitive   = true
}
