<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.3 |
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
| [google_compute_global_address.ip_address](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_global_address) | resource |
| [google_compute_ssl_policy.ssl_policy](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_ssl_policy) | resource |
| [google_dns_managed_zone.sub_zone](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/dns_managed_zone) | resource |
| [google_dns_record_set.app_dns_record](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/dns_record_set) | resource |
| [google_dns_record_set.app_ns_record](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/dns_record_set) | resource |
| [google_dns_record_set.service_dns_record](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/dns_record_set) | resource |
| [google_iap_client.iap_client](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/iap_client) | resource |
| [google_iap_web_iam_member.member_accessor](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/iap_web_iam_member) | resource |
| [google_project_iam_member.iam_accessor](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_project_service.iap_service](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service) | resource |
| [google_project_service.secretmanager](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service) | resource |
| [google_secret_manager_secret.iap_secret](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret) | resource |
| [google_secret_manager_secret_version.iap_secret](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret_version) | resource |
| [google_service_account.iap_accessor](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [google_service_account_iam_member.iam_token_creator](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account_iam_member) | resource |
| [kubernetes_annotations.nginx_service_annotation](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/annotations) | resource |
| [kubernetes_ingress_v1.app_ingress](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/ingress_v1) | resource |
| [kubernetes_ingress_v1.gce_ingress](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/ingress_v1) | resource |
| [kubernetes_ingress_v1.reportportal_ingress](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/ingress_v1) | resource |
| [kubernetes_ingress_v1.service_ingress](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/ingress_v1) | resource |
| [kubernetes_manifest.app_certificate](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |
| [kubernetes_manifest.backend_config](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |
| [kubernetes_manifest.frontend_config](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |
| [kubernetes_manifest.service_certificate](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |
| [kubernetes_secret.iap_client_secret](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [google_dns_managed_zone.dns_zone](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/dns_managed_zone) | data source |
| [google_project.project](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/project) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application_data"></a> [application\_data](#input\_application\_data) | Override for application configuration (see app-config/ directory) | `list(any)` | n/a | yes |
| <a name="input_application_environment"></a> [application\_environment](#input\_application\_environment) | Application environment (dev, stage, prod, etc) | `string` | n/a | yes |
| <a name="input_argocd"></a> [argocd](#input\_argocd) | n/a | `map(any)` | <pre>{<br>  "name": "argocd",<br>  "service_port": "80",<br>  "service_ui": "argocd-server"<br>}</pre> | no |
| <a name="input_argocd_namespace"></a> [argocd\_namespace](#input\_argocd\_namespace) | n/a | `string` | `""` | no |
| <a name="input_backstage"></a> [backstage](#input\_backstage) | n/a | `map(any)` | <pre>{<br>  "name": "backstage",<br>  "service_port": "7007",<br>  "service_ui": "backstage"<br>}</pre> | no |
| <a name="input_backstage_namespace"></a> [backstage\_namespace](#input\_backstage\_namespace) | n/a | `string` | `""` | no |
| <a name="input_dns_zone"></a> [dns\_zone](#input\_dns\_zone) | Existing public Cloud DNS zone with registered domain | `string` | `""` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment type (non-prod or prod) | `string` | n/a | yes |
| <a name="input_iap_access_members"></a> [iap\_access\_members](#input\_iap\_access\_members) | List of google user ids allowed to use the IAP | `list(string)` | `[]` | no |
| <a name="input_iap_client_id"></a> [iap\_client\_id](#input\_iap\_client\_id) | OAuth client ID | `string` | `""` | no |
| <a name="input_iap_client_secret"></a> [iap\_client\_secret](#input\_iap\_client\_secret) | OAuth client secret | `string` | `""` | no |
| <a name="input_iap_service_account"></a> [iap\_service\_account](#input\_iap\_service\_account) | Existing service account for IAP access | `string` | `""` | no |
| <a name="input_ingress_nginx_namespace"></a> [ingress\_nginx\_namespace](#input\_ingress\_nginx\_namespace) | n/a | `string` | `"ingress_nginx"` | no |
| <a name="input_project"></a> [project](#input\_project) | GCP project | `string` | `null` | no |
| <a name="input_region"></a> [region](#input\_region) | GCP region | `string` | `null` | no |
| <a name="input_reportportal"></a> [reportportal](#input\_reportportal) | n/a | `map(any)` | <pre>{<br>  "name": "reportportal",<br>  "service_port": "8080",<br>  "service_ui": "reportportal-ui"<br>}</pre> | no |
| <a name="input_reportportal_namespace"></a> [reportportal\_namespace](#input\_reportportal\_namespace) | n/a | `string` | `""` | no |
| <a name="input_sonarqube"></a> [sonarqube](#input\_sonarqube) | n/a | `map(any)` | <pre>{<br>  "name": "sonarqube",<br>  "service_port": "9000",<br>  "service_ui": "sonarqube-sonarqube"<br>}</pre> | no |
| <a name="input_sonarqube_namespace"></a> [sonarqube\_namespace](#input\_sonarqube\_namespace) | n/a | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_curl_command"></a> [curl\_command](#output\_curl\_command) | n/a |
<!-- END_TF_DOCS -->