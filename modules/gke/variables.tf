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
  description = "The ID of the project in which the resources belong"
  default     = null
}

variable "region" {
  description = "The Region of the project in which the resources belong"
  default     = null
}

variable "kubernetes_version" {
  description = "GKE cluster version. If empty, will be set to the version of the most recent STABLE release"
  default     = ""
}

variable "cluster_name" {
  description = "The name of the cluster, unique within the project and region"
  default     = "gke-cluster"
}

variable "zones" {
  description = "The zones to host the cluster"
  type        = list(string)
  default     = []
}

variable "network_name" {
  description = "The name of the VPC network to which the cluster is connected"
  default     = "gke-network"
}

variable "subnetwork_name" {
  description = "The name of the VPC subnetwork in which the cluster's instances are launched"
  default     = "gke-subnetwork"
}

variable "ip_cidr_range" {
  description = "The CIDR range of the VPC subnetwork"
  default     = "10.128.0.0/20"
}

variable "ip_range_pods_name" {
  description = "The name of the secondary range to be used as for the cluster CIDR block"
  default     = "ip-range-pods"
}

variable "ip_cidr_pods_range" {
  description = "The secondary range will be used for pod IP addresses"
  default     = "10.129.0.0/20"
}

variable "ip_range_services_name" {
  description = "The name of the secondary range to be used as for the services CIDR block"
  default     = "ip-range-services"
}

variable "ip_cidr_services_range" {
  description = "The secondary range will be used for service ClusterIPs"
  default     = "10.130.0.0/20"
}

variable "subnetwork_log_config" {
  description = "The logging options for the subnetwork flow logs. Setting this value to `null` will disable them."
  type = object({
    aggregation_interval = string
    flow_sampling        = number
    metadata             = string
  })

  default = {
    aggregation_interval = "INTERVAL_10_MIN"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
}

variable "regional_cluster" {
  type        = bool
  description = "A boolean to enable regional cluster"
  default     = false
}

variable "service_account" {
  type        = string
  description = "Service account for GKE cluster"
  default     = "gke-service-account"
}

variable "service_account_roles" {
  type        = list(string)
  description = "Grant cluster-specific service account roles"
  default = [
    "logging.logWriter",
    "monitoring.metricWriter",
    "monitoring.viewer",
    "storage.objectViewer",
    "artifactregistry.reader",
  ]
}

variable "node_pools" {
  type        = list(map(string))
  description = "The list of node pool configurations"
  default = [
    {
      name               = "default-node-pool"
      machine_type       = "e2-standard-2"
      initial_node_count = 1
      min_count          = 1
      max_count          = 1
      local_ssd_count    = 0
      disk_size_gb       = 15
      disk_type          = "pd-standard"
      image_type         = "COS_CONTAINERD"
      auto_repair        = true
      auto_upgrade       = false
      preemptible        = true
    },
  ]
}
