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

resource "google_secret_manager_secret" "secret_key" {
  secret_id = var.name == null ? format("%s-%s", "secret-key-", random_id.key_suffix.hex) : var.name
  project   = var.project

  dynamic "replication" {
    for_each = var.region == null ? ["automatic"] : []

    content {
      automatic = true
    }
  }

  dynamic "replication" {
    for_each = var.region != null ? ["user_managed"] : []

    content {
      user_managed {
        replicas {
          location = var.region
        }
      }
    }

  }

  labels = {
    service = var.labels
  }

  depends_on = [var.module_depends_on]
}

resource "google_secret_manager_secret_version" "secret_key_data" {
  secret      = google_secret_manager_secret.secret_key.id
  secret_data = var.key == null ? random_password.random_key.result : var.key
}

resource "random_password" "random_key" {
  length  = 16
  special = false
}

resource "random_id" "key_suffix" {
  byte_length = 8
}