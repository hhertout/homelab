letsencrypt:
  email: ${letsencrypt_email}
  issuer: ${letsencrypt_issuer}

traefik:
  dashboardDomain: ${traefik_dashboard_domain}

metallb:
  addresses:
    - ${metallb_address_range}
