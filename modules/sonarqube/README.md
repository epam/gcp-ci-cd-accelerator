<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 4.5.0, < 5.0.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 2.6.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.10.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | >= 4.5.0, < 5.0.0 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | ~> 2.6.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | ~> 2.10.0 |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_secret_manager"></a> [secret\_manager](#module\_secret\_manager) | ../../modules/gcp-secret-key | n/a |

## Resources

| Name | Type |
|------|------|
| [google_secret_manager_secret.token](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret) | resource |
| [helm_release.sonarqube](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_namespace.sonarqube](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [null_resource.token_create](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [google_container_cluster.gke_cluster](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/container_cluster) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloudbuild_logs_bucket"></a> [cloudbuild\_logs\_bucket](#input\_cloudbuild\_logs\_bucket) | n/a | `any` | n/a | yes |
| <a name="input_cloudbuild_service_account"></a> [cloudbuild\_service\_account](#input\_cloudbuild\_service\_account) | n/a | `any` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | n/a | `any` | n/a | yes |
| <a name="input_gke_cluster_location"></a> [gke\_cluster\_location](#input\_gke\_cluster\_location) | n/a | `any` | n/a | yes |
| <a name="input_gke_cluster_name"></a> [gke\_cluster\_name](#input\_gke\_cluster\_name) | n/a | `any` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | n/a | `any` | `null` | no |
| <a name="input_region"></a> [region](#input\_region) | n/a | `any` | `null` | no |
| <a name="input_sonarqube_admin"></a> [sonarqube\_admin](#input\_sonarqube\_admin) | Sonarqube admin | `string` | `"admin"` | no |
| <a name="input_sonarqube_image_repository"></a> [sonarqube\_image\_repository](#input\_sonarqube\_image\_repository) | SonarQube image repository | `string` | `"sonarqube"` | no |
| <a name="input_sonarqube_image_tag"></a> [sonarqube\_image\_tag](#input\_sonarqube\_image\_tag) | SonarQube image tag | `string` | `"10.2.1-community"` | no |
| <a name="input_sonarqube_namespace"></a> [sonarqube\_namespace](#input\_sonarqube\_namespace) | Kubernetes namespace | `string` | `"sonarqube"` | no |
| <a name="input_sonarqube_plugins"></a> [sonarqube\_plugins](#input\_sonarqube\_plugins) | The list of plugins that will be installed on SonarQube | `string` | `"{https://github.com/checkstyle/sonar-checkstyle/releases/download/10.4/checkstyle-sonar-plugin-10.4.jar,https://github.com/spotbugs/sonar-findbugs/releases/download/4.2.2/sonar-findbugs-plugin-4.2.2.jar}"` | no |
| <a name="input_sonarqube_version"></a> [sonarqube\_version](#input\_sonarqube\_version) | SonarQube chart version | `string` | `"10.2.1+800"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_namespace"></a> [namespace](#output\_namespace) | n/a |
<!-- END_TF_DOCS -->