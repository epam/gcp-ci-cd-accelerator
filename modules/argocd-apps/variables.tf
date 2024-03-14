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

variable "custom_env" {
  default = ""
}

variable "custom_app" {
  default = ""
}

variable "environment" {}

variable "gke_cluster_name" {}

variable "gke_cluster_location" {}

variable "application_data" {}

variable "application_environment" {}

variable "argocd_namespace" {}

variable "prune_enabled" {
  description = "delete resources when Argo CD detects the resource is no longer defined in Git"
  default     = "false"
}

variable "self_heal_enabled" {
  description = "automatic sync when the live cluster's state deviates from the state defined in Git"
  default     = "false"
}
