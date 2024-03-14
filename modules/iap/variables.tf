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

variable "region" {
  description = "GCP region"
  type        = string
  default     = null
}

variable "environment" {
  description = "Environment type (non-prod or prod)"
  type        = string
}

variable "application_data" {
  description = "Override for application configuration (see app-config/ directory)"
  type        = list(any)
}

variable "application_environment" {
  description = "Application environment (dev, stage, prod, etc)"
  type        = string
}

variable "iap_client_id" {
  description = "OAuth client ID"
  type        = string
  default     = ""
}

variable "iap_client_secret" {
  description = "OAuth client secret"
  type        = string
  default     = ""
  sensitive   = true
}

variable "iap_access_members" {
  description = "List of google user ids allowed to use the IAP"
  type        = list(string)
  default     = []
}

variable "argocd_namespace" {
  type    = string
  default = ""
}

variable "backstage_namespace" {
  type    = string
  default = ""
}

variable "sonarqube_namespace" {
  type    = string
  default = ""
}

variable "reportportal_namespace" {
  type    = string
  default = ""
}

variable "ingress_nginx_namespace" {
  type    = string
  default = "ingress_nginx"
}

variable "argocd" {
  type = map(any)
  default = {
    "name"         = "argocd"
    "service_ui"   = "argocd-server"
    "service_port" = "80"
  }
}

variable "backstage" {
  type = map(any)
  default = {
    "name"         = "backstage"
    "service_ui"   = "backstage"
    "service_port" = "7007"
  }
}

variable "sonarqube" {
  type = map(any)
  default = {
    "name"         = "sonarqube"
    "service_ui"   = "sonarqube-sonarqube"
    "service_port" = "9000"
  }
}

variable "reportportal" {
  type = map(any)
  default = {
    "name"         = "reportportal"
    "service_ui"   = "reportportal-ui"
    "service_port" = "8080"
  }
}

variable "iap_service_account" {
  description = "Existing service account for IAP access"
  type        = string
  default     = ""
}

variable "dns_zone" {
  description = "Existing public Cloud DNS zone with registered domain"
  type        = string
  default     = ""
}
