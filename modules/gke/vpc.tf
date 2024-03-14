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


resource "google_compute_network" "vpc" {
  project                         = var.project
  name                            = var.network_name
  routing_mode                    = "REGIONAL"
  auto_create_subnetworks         = "false"
  delete_default_routes_on_create = "false"
}

resource "google_compute_subnetwork" "subnetwork" {
  name          = var.subnetwork_name
  ip_cidr_range = var.ip_cidr_range
  region        = var.region
  network       = google_compute_network.vpc.id

  secondary_ip_range {
    range_name    = var.ip_range_pods_name
    ip_cidr_range = var.ip_cidr_pods_range
  }

  secondary_ip_range {
    range_name    = var.ip_range_services_name
    ip_cidr_range = var.ip_cidr_services_range
  }

  dynamic "log_config" {
    for_each = var.subnetwork_log_config == null ? [] : tolist([var.subnetwork_log_config])

    content {
      aggregation_interval = var.subnetwork_log_config.aggregation_interval
      flow_sampling        = var.subnetwork_log_config.flow_sampling
      metadata             = var.subnetwork_log_config.metadata
    }
  }
}
