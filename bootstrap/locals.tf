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
  apis = formatlist("%s.googleapis.com", var.google_apis)

  iam_roles = formatlist("roles/%s", var.iam_roles)

  repository_iac = trimsuffix(trimprefix(var.repository_iac_url, "https://github.com/"), ".git")

  service_account = (var.service_account == "" ? google_service_account.terraform[0].email :
  var.service_account)

  kubernetes_version = data.google_container_engine_versions.versions.release_channel_latest_version["STABLE"]

  # =====================================================================================================
  # create file list to processing
  json_files     = fileset("../${var.path_config}/${path.module}", "*.json")
  yaml_files_raw = fileset("../${var.path_config}/${path.module}", "*.yaml")

  # exclude special yaml files from processing
  yaml_files = toset([
    for yamlFile in local.yaml_files_raw :
    yamlFile if yamlFile != "deploy.yaml" &&
    yamlFile != "destroy.yaml" &&
    yamlFile != "cloudbuild.yaml"
  ])

  # processing files
  yaml_data = [for yaml_file in local.yaml_files : yamldecode(file("../${path.module}/${var.path_config}/${yaml_file}"))]
  json_data = [for json_file in local.json_files : jsondecode(file("../${path.module}/${var.path_config}/${json_file}"))]

  # choose type of incoming data: yaml or json
  project_data = local.yaml_data == [] ? local.json_data : local.yaml_data
}
