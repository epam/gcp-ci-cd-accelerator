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
  description = "Project name on google."
  type        = string
}

variable "region" {
  description = "Project region in google."
  type        = string
}

variable "organization" {
  description = "GitHub organization"
  type        = string
}

variable "source_repository" {
  description = "GitHub repository"
  type        = string
}

variable "repository_branch" {
  description = "The branch that contains the source files."
  default     = "main"
  type        = string
}

variable "project_bucket" {
  description = "Terraform state GCS bucket"
  type        = string
}

variable "terraform_version" {
  description = "Terraform version for validation tests"
  type        = string
}

variable "cloudbuild_service_account" {
  description = "IAM service account to use in Cloud Build"
  type        = string
}

variable "cloudbuild_logs_bucket" {
  description = "GCS bucket for Cloud Build logs"
  type        = string
}

variable "terraform_docs_version" {
  description = "Terraform-docs version"
  type        = string
  default     = "0.16.0"
}

variable "tflint_version" {
  description = "TFlint version"
  type        = string
  default     = "0.43.0"
}

variable "tfsec_version" {
  description = "Tfsec version"
  type        = string
  default     = "1.28.1"
}

variable "open_policy_agent_version" {
  description = "Open Policy Agent version"
  type        = string
  default     = "0.46.1"
}

variable "checkov_version" {
  description = "Checkov version"
  type        = string
  default     = "2.2.114"
}

variable "run_terraform_plan" {
  description = "Show terraform plan (only if backend.tf is present)"
  type        = bool
  default     = true
}

variable "run_terraform_fmt" {
  description = "Verify code formatting"
  type        = bool
  default     = true
}

variable "run_terraform_docs" {
  description = "Ensure README.md is up to date with terraform-docs output"
  type        = bool
  default     = true
}

variable "report_print_readme" {
  description = "Print README.md content in report"
  type        = bool
  default     = false
}

variable "run_tflint" {
  description = "Check code using tflint"
  type        = bool
  default     = true
}

variable "run_tfsec" {
  description = "Check code using tfsec"
  type        = bool
  default     = true
}

variable "run_open_policy_agent" {
  description = "Check code using Open Policy Agent"
  type        = bool
  default     = true
}

variable "run_checkov" {
  description = "Check code using Checkov"
  type        = bool
  default     = true
}

variable "skip_errors" {
  description = "Don't fail pipeline in case of errors"
  type        = bool
  default     = false
}
