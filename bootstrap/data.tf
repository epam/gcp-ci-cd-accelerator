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

data "google_client_config" "default" {}

data "google_project" "project" {
  project_id = var.project
}

data "google_container_engine_versions" "versions" {
  location       = var.region
  version_prefix = var.kubernetes_version
}

data "google_container_registry_repository" "image_repository" {
  project = var.project
  # region = "eu"

  depends_on = [google_container_registry.registry]
}
