# kube-admin

This directory is dedicated to the **internal management of Kubernetes** within the homelab.

It contains all resources related to cluster-level administration: RBAC, namespaces, storage classes, network policies, admission controllers, and any other configuration that governs how the cluster itself operates — as opposed to the workloads running on top of it.

## Scope

- **RBAC** — roles, cluster roles, service accounts, and bindings
- **Namespaces** — namespace definitions and resource quotas
- **Storage** — storage classes, persistent volume provisioners
- **Networking** — network policies, CNI configuration
- **Admission & policy** — admission webhooks, OPA/Kyverno policies
- **Cluster tooling** — operators and controllers that manage the cluster lifecycle

## Out of scope

Application workloads and user-facing services live in their own directories. This folder is strictly for infrastructure-level Kubernetes concerns.

---

## Traefik

Traefik is installed by default with k3s. This module patches its configuration to enable automatic TLS and dashboard access.

### Required variables (`variables.tf`)

```hcl
traefik_dashboard_domain     = "traefik.your-domain.com"
letsencrypt_email            = "you@email.com"
letsencrypt_staging          = true   # switch to false once everything works

# Generate with:
# htpasswd -nbB myuser mypassword
traefik_dashboard_basic_auth = "myuser:$2y$05$..."
```

### Resources

| Resource | Role |
|---|---|
| `HelmChartConfig` | Patches the k3s-managed Traefik to enable global HTTP → HTTPS redirect and the dashboard |
| `ClusterIssuer` staging + prod | Both issuers are created — `letsencrypt_staging` controls which one is active |
| `Middleware dashboard-auth` | Protects the dashboard with Basic Auth via the htpasswd secret |
| `Middleware security-headers` | Adds HSTS, X-Frame-Options, and XSS protection headers |
| `IngressRoute` | Exposes the dashboard on your domain over HTTPS with automatic TLS |

### Deployment order

cert-manager CRDs must exist before the ClusterIssuers can be applied:

```bash
terraform apply -target=helm_release.cert_manager
terraform apply
```

> **Let's Encrypt + homelab:** the HTTP-01 challenge requires port 80 on your domain to be reachable from the internet. If your homelab is behind a router without port forwarding, you will need to switch to a DNS-01 challenge instead.
