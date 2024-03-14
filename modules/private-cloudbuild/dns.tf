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

# Create an internal DNS zone
resource "google_dns_managed_zone" "private_zone" {
  name        = "private-dns-zone-${var.environment}"
  dns_name    = "${var.environment}.${var.private_domain}."
  description = "private DNS zone"

  visibility    = "private"
  force_destroy = true

  private_visibility_config {
    networks {
      network_url = data.google_compute_network.vpc_network.id
    }
  }
}

resource "google_dns_record_set" "internal_dns_record" {
  for_each = local.service_data

  name         = "${each.value.name}.${google_dns_managed_zone.private_zone.dns_name}"
  managed_zone = google_dns_managed_zone.private_zone.name
  type         = "A"
  ttl          = 300

  rrdatas = [kubernetes_ingress_v1.gce_internal_ingress.status.0.load_balancer.0.ingress.0.ip]

  depends_on = [google_dns_managed_zone.private_zone,
    kubernetes_ingress_v1.gce_internal_ingress,
  ]
}
