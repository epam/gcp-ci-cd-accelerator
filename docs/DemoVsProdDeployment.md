# Difference Between Demo And Production Deployment

## Demo deployment

- non-HA services deployment for minimal resource footprint and infrastructure cost
- Service DNS records configured with `<env>` suffix (example: `sonarqube.dev.example.com`)
- Application DNS records configured with `<env>` prefix (example: `dev.app.example.com`)
- Application and service access is protected by IaP

## Production deployment

- HA deployment require larger resource footprint with higher infrastructure cost
- Service DNS records configured without environment suffix (example: `sonarqube.example.com`)
- Application DNS records configured without environment prefix (example: `app.example.com`)
- Application and service access is protected by IaP
