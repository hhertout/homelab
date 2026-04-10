locals {
  letsencrypt_issuer = var.letsencrypt_staging ? "letsencrypt-staging" : "letsencrypt-prod"
}
