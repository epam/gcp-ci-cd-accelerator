<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=0.13 |
| <a name="requirement_github"></a> [github](#requirement\_github) | ~> 4.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 4.5.0, < 5.0.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 2.6.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.10.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | >= 4.5.0, < 5.0.0 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | ~> 2.6.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | >= 2.10.0 |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_secret_manager"></a> [secret\_manager](#module\_secret\_manager) | ../gcp-secret-key | n/a |

## Resources

| Name | Type |
|------|------|
| [google_secret_manager_secret.token](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret) | resource |
| [helm_release.argocd](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_namespace.argocd](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_secret.private_repo](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [null_resource.token_create](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [google_container_cluster.gke_cluster](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/container_cluster) | data source |
| [google_secret_manager_secret_version.git_token](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/secret_manager_secret_version) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application_data"></a> [application\_data](#input\_application\_data) | n/a | `list` | `[]` | no |
| <a name="input_applicationset_replicacount"></a> [applicationset\_replicacount](#input\_applicationset\_replicacount) | n/a | `number` | `1` | no |
| <a name="input_argocd_admin_password"></a> [argocd\_admin\_password](#input\_argocd\_admin\_password) | n/a | `any` | `null` | no |
| <a name="input_argocd_image_repository"></a> [argocd\_image\_repository](#input\_argocd\_image\_repository) | ArgoCD image repository | `string` | `"quay.io/argoproj/argocd"` | no |
| <a name="input_argocd_image_tag"></a> [argocd\_image\_tag](#input\_argocd\_image\_tag) | ArgoCD image tag | `string` | `""` | no |
| <a name="input_argocd_version"></a> [argocd\_version](#input\_argocd\_version) | ArgoCD chart version | `string` | `"5.46.7"` | no |
| <a name="input_cloudbuild_logs_bucket"></a> [cloudbuild\_logs\_bucket](#input\_cloudbuild\_logs\_bucket) | n/a | `any` | n/a | yes |
| <a name="input_cloudbuild_service_account"></a> [cloudbuild\_service\_account](#input\_cloudbuild\_service\_account) | n/a | `any` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | n/a | `any` | n/a | yes |
| <a name="input_gke_cluster_location"></a> [gke\_cluster\_location](#input\_gke\_cluster\_location) | n/a | `any` | n/a | yes |
| <a name="input_gke_cluster_name"></a> [gke\_cluster\_name](#input\_gke\_cluster\_name) | n/a | `any` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | n/a | `string` | `"argocd"` | no |
| <a name="input_polling_interval"></a> [polling\_interval](#input\_polling\_interval) | How often does Argo CD check for changes to my Git repository | `string` | `"180s"` | no |
| <a name="input_project"></a> [project](#input\_project) | n/a | `any` | `null` | no |
| <a name="input_redis_ha_enabled"></a> [redis\_ha\_enabled](#input\_redis\_ha\_enabled) | HA mode options | `string` | `"false"` | no |
| <a name="input_region"></a> [region](#input\_region) | n/a | `any` | `null` | no |
| <a name="input_reposerver_autoscaling_enabled"></a> [reposerver\_autoscaling\_enabled](#input\_reposerver\_autoscaling\_enabled) | n/a | `string` | `"false"` | no |
| <a name="input_reposerver_autoscaling_minreplicas"></a> [reposerver\_autoscaling\_minreplicas](#input\_reposerver\_autoscaling\_minreplicas) | n/a | `number` | `1` | no |
| <a name="input_server_autoscaling_enabled"></a> [server\_autoscaling\_enabled](#input\_server\_autoscaling\_enabled) | n/a | `string` | `"false"` | no |
| <a name="input_server_autoscaling_minreplicas"></a> [server\_autoscaling\_minreplicas](#input\_server\_autoscaling\_minreplicas) | n/a | `number` | `1` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_kubernetes_namespace"></a> [kubernetes\_namespace](#output\_kubernetes\_namespace) | n/a |
<!-- END_TF_DOCS -->