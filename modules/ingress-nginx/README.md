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

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.nginx_ingress](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [google_container_cluster.gke_cluster](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/container_cluster) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | n/a | `any` | n/a | yes |
| <a name="input_gke_cluster_location"></a> [gke\_cluster\_location](#input\_gke\_cluster\_location) | n/a | `any` | n/a | yes |
| <a name="input_gke_cluster_name"></a> [gke\_cluster\_name](#input\_gke\_cluster\_name) | n/a | `any` | n/a | yes |
| <a name="input_nginx_ingress_namespace"></a> [nginx\_ingress\_namespace](#input\_nginx\_ingress\_namespace) | n/a | `string` | `"ingress-nginx"` | no |
| <a name="input_nginx_ingress_version"></a> [nginx\_ingress\_version](#input\_nginx\_ingress\_version) | Nginx Ingress chart version | `string` | `"4.4.2"` | no |
| <a name="input_project"></a> [project](#input\_project) | n/a | `any` | `null` | no |
| <a name="input_region"></a> [region](#input\_region) | n/a | `any` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_namespace"></a> [namespace](#output\_namespace) | n/a |
<!-- END_TF_DOCS -->