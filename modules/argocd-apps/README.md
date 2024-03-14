<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=0.13 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 4.5.0, < 5.0.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.10.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | >= 4.5.0, < 5.0.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | >= 2.10.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [kubernetes_manifest.argocd_application](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |
| [kubernetes_manifest.argocd_project](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |
| [kubernetes_namespace.application_namespace](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [google_container_cluster.gke_cluster](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/container_cluster) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application_data"></a> [application\_data](#input\_application\_data) | n/a | `any` | n/a | yes |
| <a name="input_application_environment"></a> [application\_environment](#input\_application\_environment) | n/a | `any` | n/a | yes |
| <a name="input_argocd_namespace"></a> [argocd\_namespace](#input\_argocd\_namespace) | n/a | `any` | n/a | yes |
| <a name="input_custom_app"></a> [custom\_app](#input\_custom\_app) | n/a | `string` | `""` | no |
| <a name="input_custom_env"></a> [custom\_env](#input\_custom\_env) | n/a | `string` | `""` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | n/a | `any` | n/a | yes |
| <a name="input_gke_cluster_location"></a> [gke\_cluster\_location](#input\_gke\_cluster\_location) | n/a | `any` | n/a | yes |
| <a name="input_gke_cluster_name"></a> [gke\_cluster\_name](#input\_gke\_cluster\_name) | n/a | `any` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | n/a | `any` | `null` | no |
| <a name="input_prune_enabled"></a> [prune\_enabled](#input\_prune\_enabled) | delete resources when Argo CD detects the resource is no longer defined in Git | `string` | `"false"` | no |
| <a name="input_region"></a> [region](#input\_region) | n/a | `any` | `null` | no |
| <a name="input_self_heal_enabled"></a> [self\_heal\_enabled](#input\_self\_heal\_enabled) | automatic sync when the live cluster's state deviates from the state defined in Git | `string` | `"false"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->