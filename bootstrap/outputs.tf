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

output "application_data" {
  value = local.project_data
}

output "project_bucket" {
  value = google_storage_bucket.tfstate.name
}

output "repository_iac" {
  value = local.repository_iac
}

output "default_env" {
  value = var.environment
}

output "domain" {
  value = var.domain
}

output "dns_zone" {
  value = length(module.cloud_dns_zone) > 0 ? module.cloud_dns_zone[0].name : null
}

output "kubernetes_version" {
  value = local.kubernetes_version
}

output "terraform_version" {
  value = var.terraform_version
}

output "reportportal_version" {
  value = var.reportportal_version
}

output "service_account" {
  value = local.service_account
}

output "logs_bucket" {
  value = google_storage_bucket.cloudbuild_logs.name
}

output "your_string_for_gcloud_build" {
  value = templatefile(
    "${path.module}/submit.tpl",
    {
      TF_VERSION      = var.terraform_version,
      PROJECT_ID      = data.google_client_config.default.project,
      REGION          = data.google_client_config.default.region,
      TF_BUCKET       = google_storage_bucket.tfstate.name,
      LOGS_BUCKET     = google_storage_bucket.cloudbuild_logs.name,
      IMAGE_REPO      = data.google_container_registry_repository.image_repository.repository_url,
      K8S_VERSION     = local.kubernetes_version,
      RP_VERSION      = var.reportportal_version,
      SERVICE_ACCOUNT = local.service_account,
      ENVIRONMENT     = var.environment == "prod" ? "prod" : "non-prod"
    }
  )
}
