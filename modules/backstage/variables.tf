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
  description = "GCP project"
  type        = string
  default     = null
}

variable "backstage_namespace" {
  description = "Backstage namespace"
  type        = string
  default     = "backstage"
}

variable "backstage_version" {
  description = "Backstage chart version"
  type        = string
  default     = "0.21.0"
}

variable "backstage_image_repository" {
  description = "Backstage image repository"
  type        = string
  default     = "ghcr.io/backstage/backstage"
}

variable "backstage_image_tag" {
  description = "Backstage image tag"
  type        = string
  default     = "1.13.2"
}

variable "postgresql_enabled" {
  description = "Enable PostgreSQL installation"
  type        = bool
  default     = true
}

variable "backstage_app_config" {
  description = "Custom Backstage app-config.yaml"
  type        = string
  default     = ""
  # if enabled requires full backstage app config in yaml format
  # for example
  # value = <<-EOT
  #     app:
  #       title: Backstage
  #       baseUrl: http://localhost:7007 
  #     ...
  #
  # EOT
}
