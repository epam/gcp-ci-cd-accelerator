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


# Creating a static public IP address
resource "google_compute_global_address" "ip_address" {
  name = "ip-ingress-nginx-${var.environment}"
}

# Creating dns records for services
resource "google_dns_record_set" "service_dns_record" {
  for_each = local.service_data

  name         = "${each.value.name}.${each.value.env_prefix}${local.domain}."
  managed_zone = local.dns_zone
  type         = "A"
  ttl          = 300

  rrdatas = [google_compute_global_address.ip_address.address]

  depends_on = [google_compute_global_address.ip_address]
}

# Creating subdomains for applications
resource "google_dns_managed_zone" "sub_zone" {
  for_each = var.environment != "prod" ? local.app_data : { for v in [] : v => v } # empty object
  # checkov:skip=CKV_GCP_16:No decision on DNSSEC yet
  name          = "subdomain-${each.value.env_name}-${each.value.app_name}"
  description   = "public ${each.value.env_name}.${each.value.app_name} zone"
  dns_name      = "${each.value.env_name}.${each.value.app_name}.${local.domain}."
  force_destroy = true
}

resource "google_dns_record_set" "app_ns_record" {
  for_each = var.environment != "prod" ? local.app_data : { for v in [] : v => v } # empty object

  name = "${each.value.env_name}.${each.value.app_name}.${local.domain}."
  type = "NS"
  ttl  = 300

  managed_zone = local.dns_zone

  rrdatas = google_dns_managed_zone.sub_zone["${each.value.env_name}-${each.value.app_name}"].name_servers
}

# Creating dns records for applications
resource "google_dns_record_set" "app_dns_record" {
  for_each = local.app_data

  name = "${each.value.env_prefix}${each.value.app_name}.${local.domain}."
  managed_zone = (
    var.environment == "prod" ? local.dns_zone :
    google_dns_managed_zone.sub_zone["${each.value.env_name}-${each.value.app_name}"].name
  )
  type = "A"
  ttl  = 300

  rrdatas = [google_compute_global_address.ip_address.address]

  depends_on = [google_compute_global_address.ip_address]
}
