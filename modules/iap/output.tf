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
  exports = {
    client_id = local.client_id
    service_account = (
      var.iap_service_account != "" ? var.iap_service_account :
      google_service_account.iap_accessor[0].email
    )
  }
}

resource "google_project_service" "secretmanager" {
  service            = "secretmanager.googleapis.com"
  disable_on_destroy = false
}

resource "google_secret_manager_secret" "iap_secret" {
  for_each  = local.exports
  secret_id = format("iap-%s-%s", each.key, var.environment)

  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }

  labels = {
    service = "iap"
  }

  depends_on = [google_project_service.secretmanager]
}

resource "google_secret_manager_secret_version" "iap_secret" {
  for_each = local.exports

  secret      = google_secret_manager_secret.iap_secret[each.key].id
  secret_data = each.value
}


output "curl_command" {
  value = <<EOF

ID_TOKEN=$(
   gcloud auth print-identity-token \
   --audiences  ${local.exports.client_id} \
   --include-email \
   --impersonate-service-account ${local.exports.service_account}
)
curl --header "Proxy-Authorization: Bearer $ID_TOKEN" https://example.com

EOF
}
