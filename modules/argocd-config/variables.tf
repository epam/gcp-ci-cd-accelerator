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

variable "namespace" {
  default = "argocd"
}

variable "argocd_version" {
  description = "ArgoCD chart version"
  type        = string
  default     = "5.46.7"
}

variable "argocd_image_repository" {
  description = "ArgoCD image repository"
  type        = string
  default     = "quay.io/argoproj/argocd"
}

variable "argocd_image_tag" {
  description = "ArgoCD image tag"
  type        = string
  default     = ""
}

variable "argocd_admin_password" {
  default   = null
  sensitive = true
}

variable "polling_interval" {
  description = "How often does Argo CD check for changes to my Git repository"
  default     = "180s"
}

# HA mode options
variable "redis_ha_enabled" {
  default = "false"
}
variable "server_autoscaling_enabled" {
  default = "false"
}
variable "server_autoscaling_minreplicas" {
  default = 1
}
variable "reposerver_autoscaling_enabled" {
  default = "false"
}
variable "reposerver_autoscaling_minreplicas" {
  default = 1
}
variable "applicationset_replicacount" {
  default = 1
}

variable "application_data" {
  default = []
}
