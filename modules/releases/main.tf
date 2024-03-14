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
  release_repository       = trimsuffix(trimprefix(var.release_repository, "https://github.com/"), ".git")
  release_repository_owner = split("/", local.release_repository)[0]
  trigger_path             = trimprefix(abspath(path.module), "/workspace/")
}

data "github_repository" "release" {
  full_name = local.release_repository
}

resource "google_cloudbuild_trigger" "create_release" {
  description = "cloudbuild trigger for github release creation"
  name        = var.trigger_name
  filename    = "${local.trigger_path}/cloudbuild.yaml"
  # to disable trigger
  disabled = var.disabled

  github {
    owner = local.release_repository_owner
    name  = data.github_repository.release.name
    push {
      tag = "^[0-9]+\\.[0-9]+\\.[0-9]+.*$"
    }
  }

  service_account = "projects/${var.project}/serviceAccounts/${var.cloudbuild_service_account}"

  substitutions = {
    _TAG_NAME         = ""
    _MAKE_LATEST      = "true"
    _GENERATE_NOTES   = "true"
    _DRAFT            = "false"
    _PRERELEASE       = "false"
    _PROJECT_ID       = var.project
    _DESCRIPTION      = "New Release"
    _SECRET           = var.git_token_secret
    _REPOSITORY       = local.release_repository
    _TARGET_COMMITISH = data.github_repository.release.default_branch
    _LOGS_BUCKET      = var.cloudbuild_logs_bucket
    _SERVICE_ACCOUNT  = var.cloudbuild_service_account
  }

  approval_config {
    approval_required = var.approval_required
  }
}
