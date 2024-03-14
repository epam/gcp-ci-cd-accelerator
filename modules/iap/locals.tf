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

  # get incoming data project
  input_data              = var.application_data
  dns_zone                = data.google_dns_managed_zone.dns_zone.name
  domain                  = trimsuffix(data.google_dns_managed_zone.dns_zone.dns_name, ".")
  application_environment = var.environment == "prod" ? var.environment : var.application_environment

  # convert string local.application_environment to list and delete possible special characters between values
  envs = (
    length(regexall(",", local.application_environment)) > 0 ?
    split(",", replace(local.application_environment, "/\\s+/", "")) : split(" ", local.application_environment)
  )

  # Create list of objects with default services if they are in deployed state
  service_list = flatten([
    var.argocd_namespace != "" ? [var.argocd] : [],
    var.backstage_namespace != "" ? [var.backstage] : [],
    var.sonarqube_namespace != "" ? [var.sonarqube] : [],
    var.reportportal_namespace != "" ? [var.reportportal] : [],
  ])

  service_data = merge([
    for service in local.service_list : {
      (service.name) = {
        name         = service.name
        service_ui   = service.service_ui
        service_port = service.service_port
        env_prefix   = var.environment != "prod" ? "${var.environment}." : ""
      }
    }
  ]...)

  # filter services to exclude reportportal
  filtered_service_data = merge([
    for service in local.service_list : {
      (service.name) = {
        name         = service.name
        service_ui   = service.service_ui
        service_port = service.service_port
        env_prefix   = var.environment != "prod" ? "${var.environment}." : ""
      }
    }
    if service.name != "reportportal"
  ]...)

  # merge applications with environments
  app_data = merge([
    for app in local.input_data : {
      for env in local.envs :
      "${env}-${app.name}" => {
        app_name     = app.name
        service_ui   = app.service_ui
        service_port = app.service_port
        env_name     = env
        env_prefix   = var.environment != "prod" ? "${env}." : ""
      }
    }
    if var.argocd_namespace != ""
  ]...)

}
