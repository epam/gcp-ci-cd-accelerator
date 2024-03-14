<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.3 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 4.5.0, < 5.0.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 2.6.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.10.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | >= 4.5.0, < 5.0.0 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | ~> 2.6.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | ~> 2.10.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.backstage](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_namespace.backstage](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_secret.backstage](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [google_secret_manager_secret_version.git_token](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/secret_manager_secret_version) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_backstage_app_config"></a> [backstage\_app\_config](#input\_backstage\_app\_config) | Custom Backstage app-config.yaml | `string` | `""` | no |
| <a name="input_backstage_image_repository"></a> [backstage\_image\_repository](#input\_backstage\_image\_repository) | Backstage image repository | `string` | `"ghcr.io/backstage/backstage"` | no |
| <a name="input_backstage_image_tag"></a> [backstage\_image\_tag](#input\_backstage\_image\_tag) | Backstage image tag | `string` | `"1.13.2"` | no |
| <a name="input_backstage_namespace"></a> [backstage\_namespace](#input\_backstage\_namespace) | Backstage namespace | `string` | `"backstage"` | no |
| <a name="input_backstage_version"></a> [backstage\_version](#input\_backstage\_version) | Backstage chart version | `string` | `"0.21.0"` | no |
| <a name="input_postgresql_enabled"></a> [postgresql\_enabled](#input\_postgresql\_enabled) | Enable PostgreSQL installation | `bool` | `true` | no |
| <a name="input_project"></a> [project](#input\_project) | GCP project | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_namespace"></a> [namespace](#output\_namespace) | n/a |
<!-- END_TF_DOCS -->