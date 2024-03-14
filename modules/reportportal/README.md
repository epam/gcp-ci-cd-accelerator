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
| <a name="provider_time"></a> [time](#provider\_time) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_secret_manager_password"></a> [secret\_manager\_password](#module\_secret\_manager\_password) | ../../modules/gcp-secret-key | n/a |

## Resources

| Name | Type |
|------|------|
| [google_secret_manager_secret.token](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret) | resource |
| [helm_release.elastic](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.minio](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.nginx_ingress](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.postgresql](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.rabbit](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.reportportal](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_namespace.reportportal](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [null_resource.password_update](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.token_create](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [time_sleep.wait_30_seconds](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [google_container_cluster.gke_cluster](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/container_cluster) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloudbuild_logs_bucket"></a> [cloudbuild\_logs\_bucket](#input\_cloudbuild\_logs\_bucket) | n/a | `any` | n/a | yes |
| <a name="input_cloudbuild_service_account"></a> [cloudbuild\_service\_account](#input\_cloudbuild\_service\_account) | n/a | `any` | n/a | yes |
| <a name="input_elastic_replicas"></a> [elastic\_replicas](#input\_elastic\_replicas) | Number of Elastic nodes: 3 is better, 1 is cheaper | `string` | `"1"` | no |
| <a name="input_elastic_version"></a> [elastic\_version](#input\_elastic\_version) | Elasticsearch Helm chart version | `string` | `"7.10.2"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | n/a | `any` | n/a | yes |
| <a name="input_gke_cluster_location"></a> [gke\_cluster\_location](#input\_gke\_cluster\_location) | n/a | `any` | n/a | yes |
| <a name="input_gke_cluster_name"></a> [gke\_cluster\_name](#input\_gke\_cluster\_name) | n/a | `any` | n/a | yes |
| <a name="input_ingress_nginx_version"></a> [ingress\_nginx\_version](#input\_ingress\_nginx\_version) | Ingress Nginx Helm chart version | `string` | `"4.4.2"` | no |
| <a name="input_minio_pass"></a> [minio\_pass](#input\_minio\_pass) | Minio SecretKey | `string` | `"secretkey"` | no |
| <a name="input_minio_persistence_size"></a> [minio\_persistence\_size](#input\_minio\_persistence\_size) | Minio Volume Size | `string` | `"2Gi"` | no |
| <a name="input_minio_user"></a> [minio\_user](#input\_minio\_user) | Minio AccessKey | `string` | `"accesskey"` | no |
| <a name="input_minio_version"></a> [minio\_version](#input\_minio\_version) | MinIO Helm chart version | `string` | `"7.1.9"` | no |
| <a name="input_pg_db"></a> [pg\_db](#input\_pg\_db) | ReportPortal DB name | `string` | `"reportportal"` | no |
| <a name="input_pg_pass"></a> [pg\_pass](#input\_pg\_pass) | PostgreSQL admin pass | `string` | `"rppass"` | no |
| <a name="input_pg_user"></a> [pg\_user](#input\_pg\_user) | PostgreSQL admin user | `string` | `"rpuser"` | no |
| <a name="input_postgresql_version"></a> [postgresql\_version](#input\_postgresql\_version) | PostgreSQL Helm chart version | `string` | `"10.9.4"` | no |
| <a name="input_project"></a> [project](#input\_project) | n/a | `any` | `null` | no |
| <a name="input_rabbit_pass"></a> [rabbit\_pass](#input\_rabbit\_pass) | RabbitMQ password | `string` | `"rabbitmq"` | no |
| <a name="input_rabbit_user"></a> [rabbit\_user](#input\_rabbit\_user) | RabbitMQ user | `string` | `"rabbitmq"` | no |
| <a name="input_rabbit_version"></a> [rabbit\_version](#input\_rabbit\_version) | RabbitMQ Helm chart version | `string` | `"10.3.9"` | no |
| <a name="input_region"></a> [region](#input\_region) | n/a | `any` | `null` | no |
| <a name="input_reportportal_metricsgatherer_image_repository"></a> [reportportal\_metricsgatherer\_image\_repository](#input\_reportportal\_metricsgatherer\_image\_repository) | ReportPortal ServiceMetricsGatherer image repository | `string` | `"reportportal/service-metrics-gatherer"` | no |
| <a name="input_reportportal_metricsgatherer_image_tag"></a> [reportportal\_metricsgatherer\_image\_tag](#input\_reportportal\_metricsgatherer\_image\_tag) | ReportPortal ServiceMetricsGatherer image tag | `string` | `"1.1.20"` | no |
| <a name="input_reportportal_migrations_image_repository"></a> [reportportal\_migrations\_image\_repository](#input\_reportportal\_migrations\_image\_repository) | ReportPortal Migrations image repository | `string` | `"reportportal/migrations"` | no |
| <a name="input_reportportal_migrations_image_tag"></a> [reportportal\_migrations\_image\_tag](#input\_reportportal\_migrations\_image\_tag) | ReportPortal Migrations image tag | `string` | `"5.7.0"` | no |
| <a name="input_reportportal_namespace"></a> [reportportal\_namespace](#input\_reportportal\_namespace) | Kubernetes namespace | `string` | `"reportportal"` | no |
| <a name="input_reportportal_serviceanalyzer_image_repository"></a> [reportportal\_serviceanalyzer\_image\_repository](#input\_reportportal\_serviceanalyzer\_image\_repository) | ReportPortal ServiceAutoAnalyzer image repository | `string` | `"reportportal/service-auto-analyzer"` | no |
| <a name="input_reportportal_serviceanalyzer_image_tag"></a> [reportportal\_serviceanalyzer\_image\_tag](#input\_reportportal\_serviceanalyzer\_image\_tag) | ReportPortal ServiceAutoAnalyzer image tag | `string` | `"5.7.2"` | no |
| <a name="input_reportportal_serviceapi_image_repository"></a> [reportportal\_serviceapi\_image\_repository](#input\_reportportal\_serviceapi\_image\_repository) | ReportPortal ServiceApi image repository | `string` | `"reportportal/service-api"` | no |
| <a name="input_reportportal_serviceapi_image_tag"></a> [reportportal\_serviceapi\_image\_tag](#input\_reportportal\_serviceapi\_image\_tag) | ReportPortal ServiceApi image tag | `string` | `"5.7.2"` | no |
| <a name="input_reportportal_serviceindex_image_repository"></a> [reportportal\_serviceindex\_image\_repository](#input\_reportportal\_serviceindex\_image\_repository) | ReportPortal ServiceIndex image repository | `string` | `"reportportal/service-index"` | no |
| <a name="input_reportportal_serviceindex_image_tag"></a> [reportportal\_serviceindex\_image\_tag](#input\_reportportal\_serviceindex\_image\_tag) | ReportPortal ServiceIndex image tag | `string` | `"5.0.11"` | no |
| <a name="input_reportportal_servicejobs_image_repository"></a> [reportportal\_servicejobs\_image\_repository](#input\_reportportal\_servicejobs\_image\_repository) | ReportPortal ServiceJobs image repository | `string` | `"reportportal/service-jobs"` | no |
| <a name="input_reportportal_servicejobs_image_tag"></a> [reportportal\_servicejobs\_image\_tag](#input\_reportportal\_servicejobs\_image\_tag) | ReportPortal ServiceJobs image tag | `string` | `"5.7.2"` | no |
| <a name="input_reportportal_serviceui_image_repository"></a> [reportportal\_serviceui\_image\_repository](#input\_reportportal\_serviceui\_image\_repository) | ReportPortal ServiceUi image repository | `string` | `"reportportal/service-ui"` | no |
| <a name="input_reportportal_serviceui_image_tag"></a> [reportportal\_serviceui\_image\_tag](#input\_reportportal\_serviceui\_image\_tag) | ReportPortal ServiceUi image tag | `string` | `"5.7.2"` | no |
| <a name="input_reportportal_uat_image_repository"></a> [reportportal\_uat\_image\_repository](#input\_reportportal\_uat\_image\_repository) | ReportPortal ServiceAuthorization image repository | `string` | `"reportportal/service-authorization"` | no |
| <a name="input_reportportal_uat_image_tag"></a> [reportportal\_uat\_image\_tag](#input\_reportportal\_uat\_image\_tag) | ReportPortal ServiceAuthorization image tag | `string` | `"5.7.0"` | no |
| <a name="input_reportportal_version"></a> [reportportal\_version](#input\_reportportal\_version) | ReportPortal chart version | `string` | `"5.7.2"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_namespace"></a> [namespace](#output\_namespace) | n/a |
<!-- END_TF_DOCS -->