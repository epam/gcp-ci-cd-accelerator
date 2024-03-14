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


resource "google_compute_global_address" "worker_range" {
  name          = "worker-pool-range-${var.environment}"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = data.google_compute_network.vpc_network.id
}

resource "google_project_service" "servicenetworking" {
  service            = "servicenetworking.googleapis.com"
  disable_on_destroy = false
}

resource "google_service_networking_connection" "worker_pool_conn" {
  network                 = data.google_compute_network.vpc_network.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.worker_range.name]

  depends_on = [google_project_service.servicenetworking]
}

resource "google_cloudbuild_worker_pool" "private_pool" {
  name     = "private-pool-${var.environment}"
  location = var.region

  worker_config {
    disk_size_gb   = 100
    machine_type   = "e2-medium"
    no_external_ip = false
  }

  network_config {
    peered_network = data.google_compute_network.vpc_network.id
  }

  depends_on = [google_service_networking_connection.worker_pool_conn]
}

resource "google_service_networking_peered_dns_domain" "dns_peering" {
  name       = "internal-dns-peering-${var.environment}"
  network    = data.google_compute_network.vpc_network.name
  dns_suffix = google_dns_managed_zone.private_zone.dns_name
  service    = "servicenetworking.googleapis.com"

  depends_on = [google_service_networking_connection.worker_pool_conn,
    google_dns_managed_zone.private_zone,
  ]
}
