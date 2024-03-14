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

resource "google_cloudbuild_trigger" "tf_audit_trigger" {
  name        = "infra-tf-audit"
  description = "tf audit pull trigger"
  # to disable trigger
  disabled = false
  tags = [
    "tf-audit"
  ]

  github {
    owner = var.organization
    name  = var.source_repository
    pull_request {
      branch          = "^${var.repository_branch}$"
      comment_control = "COMMENTS_ENABLED_FOR_EXTERNAL_CONTRIBUTORS_ONLY"
    }
  }

  service_account = "projects/${var.project}/serviceAccounts/${var.cloudbuild_service_account}"

  substitutions = {
    _DIR               = ""
    _PROJECT_BUCKET    = var.project_bucket
    _RUN_TF_PLAN       = tostring(var.run_terraform_plan)
    _RUN_TF_FMT        = tostring(var.run_terraform_fmt)
    _RUN_TF_DOCS       = tostring(var.run_terraform_docs)
    _RUN_TF_LINT       = tostring(var.run_tflint)
    _RUN_TF_SEC        = tostring(var.run_tfsec)
    _RUN_TF_OPA        = tostring(var.run_open_policy_agent)
    _RUN_TF_CHECKOV    = tostring(var.run_checkov)
    _TF_VERSION        = var.terraform_version
    _TFDOCS_VERSION    = var.terraform_docs_version
    _TFLINT_VERSION    = var.tflint_version
    _TFSEC_VERSION     = var.tfsec_version
    _TFOPA_VERSION     = var.open_policy_agent_version
    _TFCHECKOV_VERSION = var.checkov_version
    _SHOW_README       = tostring(var.report_print_readme)
    _SKIP_ERRORS       = tostring(var.skip_errors)
    _LOGS_BUCKET       = var.cloudbuild_logs_bucket
    _SERVICE_ACCOUNT   = var.cloudbuild_service_account
  }

  filename = "modules/tf-audit/tf-audit.yaml"
}
