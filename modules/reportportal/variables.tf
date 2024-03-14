# Copyright 2023 EPAM Systems
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

variable "project" {
  default = null
}

variable "region" {
  default = null
}

variable "environment" {}

variable "gke_cluster_name" {}

variable "gke_cluster_location" {}

variable "cloudbuild_logs_bucket" {}

variable "cloudbuild_service_account" {}

variable "reportportal_namespace" {
  type        = string
  description = "Kubernetes namespace"
  default     = "reportportal"
}

variable "reportportal_version" {
  description = "ReportPortal chart version"
  type        = string
  default     = "5.7.2"
}

variable "reportportal_serviceindex_image_repository" {
  description = "ReportPortal ServiceIndex image repository"
  type        = string
  default     = "reportportal/service-index"
}

variable "reportportal_serviceindex_image_tag" {
  description = "ReportPortal ServiceIndex image tag"
  type        = string
  default     = "5.0.11"
}

variable "reportportal_uat_image_repository" {
  description = "ReportPortal ServiceAuthorization image repository"
  type        = string
  default     = "reportportal/service-authorization"
}

variable "reportportal_uat_image_tag" {
  description = "ReportPortal ServiceAuthorization image tag"
  type        = string
  default     = "5.7.0"
}

variable "reportportal_serviceui_image_repository" {
  description = "ReportPortal ServiceUi image repository"
  type        = string
  default     = "reportportal/service-ui"
}

variable "reportportal_serviceui_image_tag" {
  description = "ReportPortal ServiceUi image tag"
  type        = string
  default     = "5.7.2"
}

variable "reportportal_serviceapi_image_repository" {
  description = "ReportPortal ServiceApi image repository"
  type        = string
  default     = "reportportal/service-api"
}

variable "reportportal_serviceapi_image_tag" {
  description = "ReportPortal ServiceApi image tag"
  type        = string
  default     = "5.7.2"
}

variable "reportportal_servicejobs_image_repository" {
  description = "ReportPortal ServiceJobs image repository"
  type        = string
  default     = "reportportal/service-jobs"
}

variable "reportportal_servicejobs_image_tag" {
  description = "ReportPortal ServiceJobs image tag"
  type        = string
  default     = "5.7.2"
}

variable "reportportal_migrations_image_repository" {
  description = "ReportPortal Migrations image repository"
  type        = string
  default     = "reportportal/migrations"
}

variable "reportportal_migrations_image_tag" {
  description = "ReportPortal Migrations image tag"
  type        = string
  default     = "5.7.0"
}

variable "reportportal_serviceanalyzer_image_repository" {
  description = "ReportPortal ServiceAutoAnalyzer image repository"
  type        = string
  default     = "reportportal/service-auto-analyzer"
}

variable "reportportal_serviceanalyzer_image_tag" {
  description = "ReportPortal ServiceAutoAnalyzer image tag"
  type        = string
  default     = "5.7.2"
}

variable "reportportal_metricsgatherer_image_repository" {
  description = "ReportPortal ServiceMetricsGatherer image repository"
  type        = string
  default     = "reportportal/service-metrics-gatherer"
}

variable "reportportal_metricsgatherer_image_tag" {
  description = "ReportPortal ServiceMetricsGatherer image tag"
  type        = string
  default     = "1.1.20"
}

variable "pg_db" {
  type        = string
  description = "ReportPortal DB name"
  default     = "reportportal"
  sensitive   = true
}

variable "pg_user" {
  type        = string
  description = "PostgreSQL admin user"
  default     = "rpuser"
  sensitive   = true
}

variable "pg_pass" {
  type        = string
  description = "PostgreSQL admin pass"
  default     = "rppass"
  sensitive   = true

  validation {
    condition     = length(var.pg_pass) > 0
    error_message = "The pg_pass valid should not be empty."
  }
}

variable "rabbit_user" {
  type        = string
  description = "RabbitMQ user"
  default     = "rabbitmq"
  sensitive   = true
}

variable "rabbit_pass" {
  type        = string
  description = "RabbitMQ password"
  default     = "rabbitmq"
  sensitive   = true
}

variable "elastic_replicas" {
  type        = string
  description = "Number of Elastic nodes: 3 is better, 1 is cheaper"
  default     = "1"
}
variable "minio_user" {
  type        = string
  description = "Minio AccessKey"
  default     = "accesskey"
  sensitive   = true
}

variable "minio_pass" {
  type        = string
  description = "Minio SecretKey"
  default     = "secretkey"
  sensitive   = true
}

variable "minio_persistence_size" {
  type        = string
  description = "Minio Volume Size"
  default     = "2Gi"
}

variable "postgresql_version" {
  description = "PostgreSQL Helm chart version"
  type        = string
  default     = "10.9.4"
}

variable "rabbit_version" {
  description = "RabbitMQ Helm chart version"
  type        = string
  default     = "10.3.9"
}

variable "elastic_version" {
  description = "Elasticsearch Helm chart version"
  type        = string
  default     = "7.10.2"
}

variable "minio_version" {
  description = "MinIO Helm chart version"
  type        = string
  default     = "7.1.9"
}

variable "ingress_nginx_version" {
  description = "Ingress Nginx Helm chart version"
  type        = string
  default     = "4.4.2"
}
