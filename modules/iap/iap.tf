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


# Enabling Cloud Identity-Aware Proxy API
resource "google_project_service" "iap_service" {
  project            = var.project
  service            = "iap.googleapis.com"
  disable_on_destroy = false
}

# Creating OAuth credentials
resource "google_iap_client" "iap_client" {
  count = var.iap_client_id == "" && var.iap_client_secret == "" ? 1 : 0

  display_name = format("nginx-ingress-iap-%s", var.environment)
  brand = format("projects/%s/brands/%s",
    data.google_project.project.number,
    data.google_project.project.number,
  )

  depends_on = [google_project_service.iap_service]
}

# Creating service account for iap access
resource "google_service_account" "iap_accessor" {
  count = var.iap_service_account == "" ? 1 : 0

  account_id   = format("iap-accessor-%s", var.environment)
  display_name = "Service Account for IAP Access"
}

# Providing Token Creator iam role
resource "google_service_account_iam_member" "iam_token_creator" {
  count = var.iap_service_account == "" ? 1 : 0

  service_account_id = google_service_account.iap_accessor[0].id
  member             = google_service_account.iap_accessor[0].member
  role               = "roles/iam.serviceAccountTokenCreator"

  depends_on = [google_service_account.iap_accessor]
}

# Providing Resource Accessor iam role
resource "google_project_iam_member" "iam_accessor" {
  count = var.iap_service_account == "" ? 1 : 0

  project = var.project
  member  = google_service_account.iap_accessor[0].member
  role    = "roles/iap.httpsResourceAccessor"

  depends_on = [google_service_account.iap_accessor]
}

resource "google_iap_web_iam_member" "member_accessor" {
  for_each = var.iap_service_account == "" ? toset(var.iap_access_members) : []

  project = var.project
  role    = "roles/iap.httpsResourceAccessor"
  member  = each.value

  depends_on = [
    google_project_service.iap_service,
    google_service_account.iap_accessor,
  ]
}

# Using custom OAuth credentials (optional) instead of creating automatically (default)
locals {
  client_id     = var.iap_client_id != "" ? var.iap_client_id : google_iap_client.iap_client[0].client_id
  client_secret = var.iap_client_secret != "" ? var.iap_client_secret : google_iap_client.iap_client[0].secret
}
