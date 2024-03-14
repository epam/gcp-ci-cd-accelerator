<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 4.5.0, < 5.0.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.10.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | >= 4.5.0, < 5.0.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | ~> 2.10.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_cloudbuild_worker_pool.private_pool](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloudbuild_worker_pool) | resource |
| [google_compute_global_address.worker_range](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_global_address) | resource |
| [google_compute_subnetwork.proxy_only_subnet](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork) | resource |
| [google_dns_managed_zone.private_zone](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/dns_managed_zone) | resource |
| [google_dns_record_set.internal_dns_record](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/dns_record_set) | resource |
| [google_project_service.servicenetworking](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service) | resource |
| [google_service_networking_connection.worker_pool_conn](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_networking_connection) | resource |
| [google_service_networking_peered_dns_domain.dns_peering](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_networking_peered_dns_domain) | resource |
| [kubernetes_annotations.nginx_internal_annotation](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/annotations) | resource |
| [kubernetes_ingress_v1.gce_internal_ingress](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/ingress_v1) | resource |
| [kubernetes_ingress_v1.reportportal_ingress_internal](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/ingress_v1) | resource |
| [kubernetes_ingress_v1.service_ingress_internal](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/ingress_v1) | resource |
| [kubernetes_manifest.backend_internal](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |
| [google_compute_network.vpc_network](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/compute_network) | data source |
| [google_container_cluster.gke_cluster](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/container_cluster) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_argocd"></a> [argocd](#input\_argocd) | n/a | `map` | <pre>{<br>  "name": "argocd",<br>  "service_port": "80",<br>  "service_ui": "argocd-server"<br>}</pre> | no |
| <a name="input_argocd_namespace"></a> [argocd\_namespace](#input\_argocd\_namespace) | n/a | `string` | `""` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | n/a | `any` | n/a | yes |
| <a name="input_gke_cluster_location"></a> [gke\_cluster\_location](#input\_gke\_cluster\_location) | n/a | `any` | n/a | yes |
| <a name="input_gke_cluster_name"></a> [gke\_cluster\_name](#input\_gke\_cluster\_name) | n/a | `any` | n/a | yes |
| <a name="input_ingress_nginx_namespace"></a> [ingress\_nginx\_namespace](#input\_ingress\_nginx\_namespace) | n/a | `string` | `"ingress_nginx"` | no |
| <a name="input_private_domain"></a> [private\_domain](#input\_private\_domain) | n/a | `string` | `"internal"` | no |
| <a name="input_project"></a> [project](#input\_project) | n/a | `any` | `null` | no |
| <a name="input_proxy_ip_cidr_range"></a> [proxy\_ip\_cidr\_range](#input\_proxy\_ip\_cidr\_range) | n/a | `string` | `"10.131.0.0/23"` | no |
| <a name="input_region"></a> [region](#input\_region) | n/a | `any` | `null` | no |
| <a name="input_reportportal"></a> [reportportal](#input\_reportportal) | n/a | `map` | <pre>{<br>  "name": "reportportal",<br>  "service_port": "8080",<br>  "service_ui": "reportportal-ui"<br>}</pre> | no |
| <a name="input_reportportal_namespace"></a> [reportportal\_namespace](#input\_reportportal\_namespace) | n/a | `string` | `""` | no |
| <a name="input_sonarqube"></a> [sonarqube](#input\_sonarqube) | n/a | `map` | <pre>{<br>  "name": "sonarqube",<br>  "service_port": "9000",<br>  "service_ui": "sonarqube-sonarqube"<br>}</pre> | no |
| <a name="input_sonarqube_namespace"></a> [sonarqube\_namespace](#input\_sonarqube\_namespace) | n/a | `string` | `""` | no |
| <a name="input_vpc_network"></a> [vpc\_network](#input\_vpc\_network) | n/a | `any` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->