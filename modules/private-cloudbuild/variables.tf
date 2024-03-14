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

variable "vpc_network" {}

variable "proxy_ip_cidr_range" {
  default = "10.131.0.0/23"
}

variable "private_domain" {
  default = "internal"
}

variable "argocd" {
  type = map(any)
  default = {
    "name"         = "argocd"
    "service_ui"   = "argocd-server"
    "service_port" = "80"
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

variable "argocd_namespace" {
  default = ""
}

variable "sonarqube_namespace" {
  default = ""
}

variable "reportportal_namespace" {
  default = ""
}

variable "ingress_nginx_namespace" {
  default = "ingress_nginx"
}
