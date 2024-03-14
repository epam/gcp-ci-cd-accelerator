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

  # get incoming data from project
  input_data              = var.application_data
  application_environment = var.environment == "prod" ? var.environment : var.application_environment

  # convert string local.application_environment to list and delete possible special characters between values
  env_list = (
    length(regexall(",", local.application_environment)) > 0 ?
    split(",", replace(local.application_environment, "/\\s+/", "")) : split(" ", local.application_environment)
  )

  # filter data by var.custom_app value if exists
  filtered_data = [
    for app in local.input_data : {
      name          = app.name
      source_url    = app.source_url
      source_branch = app.source_branch
      gitops_url    = app.gitops_url
      gitops_branch = app.gitops_branch
      service_list  = app.service_list
      source_path   = app.source_path
    }
    if app.name == var.custom_app
  ]

  # check environment conditions: if var.custom_env value exists and isn't default env and var.custom_app belongs to the project
  envs = length(var.custom_env) > 0 && !contains(local.env_list, var.custom_env) && length(local.filtered_data) > 0 ? tolist([var.custom_env]) : local.env_list

  # check application conditions: if var.custom_app value exists and belongs to the project and var.custom_env also exists 
  result_data = length(local.filtered_data) > 0 && !contains(local.env_list, var.custom_env) && length(var.custom_env) > 0 ? toset(local.filtered_data) : local.input_data

  # merge applications with environments, create list for argo projects
  argocd_project_list = merge([
    for app in local.result_data : {
      for env in local.envs :
      "${app.name}-${env}" => {
        app_name   = app.name
        gitops_url = trimsuffix(app.gitops_url, ".git")
        env_name   = env
      }
    }
    # create only if argocd server is in deployed state
    if var.argocd_namespace != ""
  ]...)

  # merge microservices with environments, create list for argo applications
  argocd_app_list = merge([
    for app in local.result_data :
    merge([
      for env in local.envs : {
        for service in app["service_list"] :
        "${app.name}-${service}-${env}" => {
          app_name      = app.name
          gitops_url    = trimsuffix(app.gitops_url, ".git")
          gitops_branch = app.gitops_branch
          service_name  = service
          env_name      = env
          env_suffix    = var.environment != "prod" ? "-${env}" : ""
        }
      }
      # create only if argocd server is in deployed state
      if var.argocd_namespace != ""
    ]...)
  ]...)

}
