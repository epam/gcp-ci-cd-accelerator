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

variable "sonarqube_namespace" {
  type        = string
  description = "Kubernetes namespace"
  default     = "sonarqube"
}

variable "sonarqube_version" {
  description = "SonarQube chart version"
  type        = string
  default     = "10.2.1+800"
}

variable "sonarqube_image_repository" {
  description = "SonarQube image repository"
  type        = string
  default     = "sonarqube"
}

variable "sonarqube_image_tag" {
  description = "SonarQube image tag"
  type        = string
  default     = "10.2.1-community"
}

variable "sonarqube_admin" {
  type        = string
  default     = "admin"
  description = "Sonarqube admin"
  sensitive   = true
}

variable "sonarqube_plugins" {
  description = "The list of plugins that will be installed on SonarQube"
  type        = string
  default     = "{https://github.com/checkstyle/sonar-checkstyle/releases/download/10.4/checkstyle-sonar-plugin-10.4.jar,https://github.com/spotbugs/sonar-findbugs/releases/download/4.2.2/sonar-findbugs-plugin-4.2.2.jar}"
}
