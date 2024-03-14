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

variable "project" {}
variable "region" {}

variable "git_token" {
  sensitive = true
}
variable "environment" {
  default = "dev"
}
variable "repository_iac_url" {
  default = ""
}
variable "repository_iac_branch" {
  default = "main"
}
variable "domain" {
  default = ""
}
variable "path_config" {
  default = "app-config"
}
variable "terraform_version" {
  default = "1.1.3"
}
variable "kubernetes_version" {
  default = ""
}
variable "reportportal_version" {
  default = "5.7.2"
}
variable "service_account" {
  default = ""
}
variable "google_apis" {
  type = list(string)
  default = [
    "compute",
    "cloudresourcemanager",
    "servicemanagement",
    "secretmanager",
    "cloudbuild",
    "iap",
    "dns",
    "iam",
    "container",
    "containerregistry",
    "artifactregistry",
    "serviceusage",
    "apikeys",
    "certificatemanager",
  ]
}
variable "iam_roles" {
  type = list(string)
  default = [
    "editor",
    "compute.networkAdmin",
    "container.admin",
    "resourcemanager.projectIamAdmin",
    "secretmanager.admin",
    "dns.admin",
    "iam.securityAdmin",
    "storage.admin",
    "iam.serviceAccountTokenCreator",
    "logging.admin",
    "cloudbuild.builds.builder",
  ]
}
