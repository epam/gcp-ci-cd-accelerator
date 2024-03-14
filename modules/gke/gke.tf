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


locals {

  # getting kubernetes version
  cluster_version = data.google_container_engine_versions.versions.release_channel_latest_version["STABLE"]

  # getting ip ranges from subnetwork resource
  ip_range_pods     = google_compute_subnetwork.subnetwork.secondary_ip_range.0.range_name
  ip_range_services = google_compute_subnetwork.subnetwork.secondary_ip_range.1.range_name

  # getting service account for GKE cluster
  service_account = (
    can(regex("iam.gserviceaccount.com", var.service_account)) ?
    var.service_account : google_service_account.default[0].email
  )

}

module "google_kubernetes_engine" {
  source  = "terraform-google-modules/kubernetes-engine/google"
  version = "27.0.0"

  name            = var.cluster_name
  regional        = var.regional_cluster
  project_id      = var.project
  region          = var.region
  zones           = var.zones
  service_account = local.service_account

  network           = google_compute_network.vpc.name
  subnetwork        = google_compute_subnetwork.subnetwork.name
  ip_range_pods     = local.ip_range_pods
  ip_range_services = local.ip_range_services

  kubernetes_version = local.cluster_version
  release_channel    = "UNSPECIFIED"

  create_service_account     = false
  remove_default_node_pool   = true
  http_load_balancing        = true
  horizontal_pod_autoscaling = true
  network_policy             = false

  node_pools = var.node_pools

  node_pools_labels = {
    all = {}
  }
  node_pools_metadata = {
    all = {}
  }
  node_pools_tags = {
    all = []
  }

}
