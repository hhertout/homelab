global:
  domain: ${argocd_domain}

configs:
  params:
    server.insecure: true
  secret:
    argocdServerAdminPassword: "${argocd_admin_password}"

server:
  replicas: 1
  ingress:
    enabled: true
    ingressClassName: traefik
    annotations:
      cert-manager.io/cluster-issuer: ${letsencrypt_issuer}
      traefik.ingress.kubernetes.io/router.tls: "true"
      traefik.ingress.kubernetes.io/router.middlewares: kube-system-security-headers@kubernetescrd
    tls: true
  resources:
    limits:
      cpu: 200m
      memory: 256Mi
    requests:
      cpu: 50m
      memory: 128Mi

redis:
  enabled: true
  resources:
    limits:
      cpu: 100m
      memory: 128Mi
    requests:
      cpu: 10m
      memory: 64Mi

repoServer:
  replicas: 1
  resources:
    limits:
      cpu: 100m
      memory: 256Mi
    requests:
      cpu: 50m
      memory: 128Mi

applicationSet:
  replicas: 1
  resources:
    limits:
      cpu: 100m
      memory: 128Mi
    requests:
      cpu: 10m
      memory: 64Mi

controller:
  resources:
    limits:
      cpu: 200m
      memory: 512Mi
    requests:
      cpu: 100m
      memory: 256Mi

dex:
  resources:
    limits:
      cpu: 250m
      memory: 256Mi
    requests:
      cpu: 50m
      memory: 128Mi

notifications:
  resources:
    limits:
      cpu: 50m
      memory: 128Mi
    requests:
      cpu: 10m
      memory: 64Mi
