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

locals {

  # convert string local.default_env to list and delete possible special characters between values
  env_list = length(regexall(",", var.environment)) > 0 ? split(",", replace(var.environment, "/\\s+/", "")) : split(" ", var.environment)

  # merge applications with environments
  gitops_list = merge([
    for app in local.project_data : {
      for env in local.env_list :
      "${env}-${app.name}" => {
        app_name    = app.name
        repo_url    = trimprefix(app.gitops_url, "https://")
        branch_name = app.gitops_branch
        org_name    = reverse(split("/", app.gitops_url))[1]
        env_name    = env
      }
    }
  ]...)

}

resource "time_sleep" "wait_30_seconds" {
  depends_on = [
    module.secret_manager,
    module.terraform_roles,
    google_container_registry.registry,
    google_storage_bucket.cloudbuild_logs,
    local.service_account,
  ]

  create_duration = "30s"
}

resource "null_resource" "gcloud_gitops" {
  for_each = local.gitops_list

  provisioner "local-exec" {
    # quiet = true
    command    = <<EOT
    gcloud builds submit . --config gitops.yaml --suppress-logs --substitutions _PROJECT_ID=${var.project},_GITOPS_REPO=${each.value.repo_url},_ENV_NAME=${each.value.env_name},_APP_NAME=${each.value.app_name},_ORG_NAME=${each.value.org_name},_BRANCH_NAME=${each.value.branch_name},_IMAGE_REPO=${data.google_container_registry_repository.image_repository.repository_url},_SERVICE_ACCOUNT=${local.service_account},_LOGS_BUCKET=${google_storage_bucket.cloudbuild_logs.name},_ENVIRONMENT=non-prod --impersonate-service-account=${local.service_account}
    EOT
    on_failure = continue
  }

  depends_on = [time_sleep.wait_30_seconds]
}
