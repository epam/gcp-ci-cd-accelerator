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

output "secret_key_region" {
  value = var.region
}

output "secret_key_name" {
  value = var.name
}

output "secret_key_key" {
  value = var.key
}

output "secret_key" {
  value     = google_secret_manager_secret_version.secret_key_data.secret_data
  sensitive = true
}

output "secret_key_config" {
  value = google_secret_manager_secret_version.secret_key_data.id
}

output "secret_key_id" {
  value = google_secret_manager_secret.secret_key.secret_id
}
