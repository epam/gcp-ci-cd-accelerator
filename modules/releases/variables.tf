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

variable "release_repository" {
  description = "GitHub repository"
  type        = string
}

variable "trigger_name" {
  description = "Trigger name"
  type        = string
}

variable "disabled" {
  description = "Disable trigger"
  type        = bool
  default     = false
}

variable "git_token_secret" {
  description = "Git token secret name"
  type        = string
  default     = "git-token"
}

variable "cloudbuild_service_account" {
  description = "Cloud Build service account name"
  type        = string
}

variable "cloudbuild_logs_bucket" {
  description = "GCS bucket name for Cloud Build logs"
  type        = string
}

variable "approval_required" {
  type        = bool
  description = "Require approval for release"
  default     = true
}
