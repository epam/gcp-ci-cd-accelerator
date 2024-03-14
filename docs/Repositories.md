# Repositories

Basic setup for CI/CD accelerator requires 3 different repositories:

- Repository with CI/CD infrastructure and pipelines definition (so-called tf)
- Repository with application deployment configuration (so-called gitops)
- At least one repository with application source code (so-called application)

## Repository with CI/CD infrastructure and pipelines definition

This repository is an entry point for every CI/CD solution installation. Every infrastructure change should be done via this repository. Supports pull request validation for Terraform code.

**Repository structure**

- `app-config/<APPLICATION>.yaml` - application configuration for CloudBuild setup
- `bootstrap/` - GCP resource definition for CI/CD platform
- `docs/` - documentation area
- `environments/` - CI/CD services (like Argo CD, SonarQube, ReportPortal, etc) definition per environment (`non-prod` or `prod`).
- `modules/` - Terraform modules

Before deployment [extra-vars.tfvars](../extravars.tfvars) file must be updated with proper values. For details check [infrastructure deployment](./InfrastructureDeployment.md) document.

**Application onboarding**

To onboard new application you need to know application Git repository and application deployment configuration URLs (currently only GitHub is supported).

Create new YAML file in `app-config/` directory (example: `app-config/my-app.yaml`) with the following content

>**Note:** replace `<APPLICATION NAME>`, `<APPLICATION GIT REPOSITORY>`, `<APPLICATION GIT BRANCH>`, `<APPLICATION SOURCE DIRECTORY>`, `<GITOPS GIT REPOSITORY>` and `<GITOPS GIT BRANCH>` with your values. Use only alpha-numerics and dashes for `<APPLICATION NAME>`. If application has different Kubernetes services definition then update `service_list`, `service_ui` and `service_port` with correct values.

```
name: <APPLICATION NAME>
source_url: <APPLICATION GIT REPOSITORY>
source_branch: <APPLICATION GIT BRANCH>
source_path: <APPLICATION SOURCE DIRECTORY>
gitops_url: <GITOPS GIT REPOSITORY>
gitops_branch: <GITOPS GIT BRANCH>
service_list:
  - frontend
service_ui: frontend
service_port: 80
```

>**NOTE:** Parameter `service_list` is mandatory and contains list of application services to setup CI/CD triggers. At least one service must be declared here.

>**NOTE:** Parameters `service_ui` and `service_port` are mandatory and used to expose application with `https://<env>.<app>.<base-domain>/` (non-prod environments) / `https://<app>.<base-domain>` (prod environment) URLs and `service_ui`:`service_port` as backend service for ingress resource.

<details>
<summary markdown="span">Example (click to expand):</summary>

```
name: hipster-shop
source_url: https://github.com/example/hipster-shop
source_branch: dev
source_path: src
gitops_url: https://github.com/example/gitops
gitops_branch: main
service_list:
  - adservice
  - cartservice
  - checkoutservice
  - currencyservice
  - emailservice
  - frontend
  - paymentservice
  - productcatalogservice
  - recommendationservice
  - redis
  - shippingservice
service_ui: frontend
service_port: 80
```
</details>

## Repository with application deployment configuration

This repository is the source of truth for Argo CD which is implementing GitOps approach. All applications that are intended to be handled by CI/CD platform must be managed via this single repository.

**Repository structure**

- `example/` - example application for demo purposes
- `non-prod/<APPLICATION>/` - contains Kubernetes manifests for **non-production** environment of application configured via `app-config/<APPLICATION>.yaml`. This section is automatically updated by CI/CD pipelines.
- `prod/<APPLICATION>/` - contains Kubernetes manifests for **production** environment of application configured via `app-config/<APPLICATION>.yaml`. This section is automatically updated by CI/CD pipelines.

## Repository with application source code

Such kind of repository contain application source code and definition for Docker image(s).
