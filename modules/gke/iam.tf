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


resource "google_service_account" "default" {
  count = !can(regex("iam.gserviceaccount.com", var.service_account)) ? 1 : 0

  account_id   = var.service_account
  display_name = "Service account for GKE cluster"
  project      = var.project
}

resource "google_project_iam_member" "roles" {
  for_each = (
    !can(regex("iam.gserviceaccount.com", var.service_account)) ?
    toset(var.service_account_roles) : []
  )

  project = var.project
  member  = "serviceAccount:${google_service_account.default[0].email}"
  role    = "roles/${each.value}"
}
