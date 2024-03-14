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
  project = "my-test-project"
  region  = "europe-west1"
}

module "secret-key-test" {
  source = "../../../gcp-secret-key"

  project = local.project
}

module "secret-key-github" {
  source = "../../../gcp-secret-key"

  project = local.project

  // (Optional)
  region     = local.region
  name       = "github-token"
  key        = "mypasshere1"
  labels     = "github"
  depends_on = []
}

module "secret-key-sonar" {
  source = "../../../gcp-secret-key"

  project = local.project

  // (Optional)
  region     = local.region
  name       = "sonar-token"
  key        = "mypasshere2"
  labels     = "sonar"
  depends_on = []
}

module "secret-key-webhook" {
  source = "../../../gcp-secret-key"

  project = local.project

  // (Optional)
  name       = "webhook-token"
  labels     = "webhook"
  depends_on = []
}

output "module_secret-key_region" {
  value = module.secret-key-github.secret_key_region
}

output "module_secret-key_name" {
  value = module.secret-key-github.secret_key_name
}

output "module_secret-key_key" {
  value = module.secret-key-github.secret_key_key
}

output "module_secret_key" {
  value = module.secret-key-github.secret_key
}
