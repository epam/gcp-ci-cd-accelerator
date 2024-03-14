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

variable "secrets" {
  description = "(Required) This is the configuration of the gcp-secret-key module. (Optional) All parameters are optional."
  type = list(object({
    region     = optional(string)
    name       = optional(string)
    pass       = optional(string)
    label      = optional(string)
    depends_on = optional(list(any))
  }))
  default = [
    {},
    {
      region = "europe-west1",
      name   = "github-token",
      pass   = "mypasshere1",
      label  = "github",
    },
    {
      region     = "europe-west1",
      name       = "sonar-token",
      pass       = "mypasshere2",
      label      = "sonar",
      depends_on = []
    },
    {
      name  = "webhook-token",
      label = "webhook",
    }
  ]
}

module "keys" {
  source = "../../../gcp-secret-key"

  for_each = { for i, v in var.secrets : i => v }

  project = local.project

  region            = each.value.region
  name              = each.value.name
  key               = each.value.pass
  labels            = each.value.label
  module_depends_on = each.value.depends_on
}

output "module_secret-key_region" {
  value = module.keys[0].secret_key_region
}

output "module_secret-key_all-keys" {
  value = values(module.keys)[*].secret_key_key
}
