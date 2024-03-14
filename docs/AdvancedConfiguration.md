# Advanced Configuration

## Full Components Deployment

```
# Terraform init
terraform -chdir=bootstrap init -backend-config="${PROJECT_ID}-tf"

# Terraform output
terraform -chdir=bootstrap output

# In console output you can find ready cloudbuild commands for deploying and destroying all components

# To deploy
gcloud builds submit --config deploy.yaml ./ --substitutions ...

# To destroy
gcloud builds submit --config destroy.yaml ./  --substitutions ...

```

If any component is failed and build stops with an error you can fix the issue and try to run command more times.  

## Single or Multiple Components Deployment

To test one or more steps in deploy scenario you can edit `deploy.yaml` and `destroy.yaml` files. Select components at the end of the file. Provide "true" flag next to component you want to deploy.

>**NOTE:** You must deploy Kubernetes (`_KUBERNETES_ENABLED: true`) if any of those components are enabled:
> - Nginx Ingress Controller (_NGINX_ENABLED)
> - SonarQube (_SONAR_ENABLED)
> - ReportPortal (_REPORT_ENABLED)
> - Argo CD (_ARGOCD_ENABLED)
> - Backstage (_BACKSTAGE_ENABLED)

>**NOTE:** You must deploy IaP (`_IAP_ENABLED`) if any of those items are true:
> - SonarQube (_SONAR_ENABLED)
> - ReportPortal (_REPORT_ENABLED)
> - Argo CD (_ARGOCD_ENABLED)
> - Backstage (_BACKSTAGE_ENABLED)
> - Any non-production environments for applications

```
# For example, to deploy only kubernetes cluster and argocd tool set "true" values for _KUBERNETES_ENABLED and _ARGOCD_ENABLED and "false" values for others services.
...
_REPORT_ENABLED: 'false'
_ARGOCD_ENABLED: 'true'
_WEBHOOK_ENABLED: 'false'
_KUBERNETES_ENABLED: 'true'
...
```

Then run CloudBuild commands from the previous section.

```
# To deploy
gcloud builds submit --config deploy.yaml ./ --substitutions ...

# To destroy
gcloud builds submit --config destroy.yaml ./  --substitutions ...
```
