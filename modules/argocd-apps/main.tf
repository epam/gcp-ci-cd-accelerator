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

resource "kubernetes_namespace" "application_namespace" {
  for_each = local.argocd_project_list
  metadata {
    # Namespace name can't be more than 63 characters
    name = trimsuffix(substr("${each.value.app_name}-${each.value.env_name}", 0, 63), "-")
  }
}

resource "kubernetes_manifest" "argocd_project" {
  for_each = local.argocd_project_list

  manifest = {
    "apiVersion" = "argoproj.io/v1alpha1"
    "kind"       = "AppProject"
    "metadata" = {
      "name"      = trimsuffix(substr("${each.value.app_name}-${each.value.env_name}", 0, 63), "-")
      "namespace" = var.argocd_namespace
    }
    "spec" = {
      "description" = "Application project"
      "destinations" = [{
        "namespace" = trimsuffix(substr("${each.value.app_name}-${each.value.env_name}", 0, 63), "-"),
        "server"    = "https://kubernetes.default.svc"
      }]
      "sourceRepos" = [
        "${each.value.gitops_url}"
      ]
    }
  }

  depends_on = [kubernetes_namespace.application_namespace]
}

resource "kubernetes_manifest" "argocd_application" {
  for_each = local.argocd_app_list

  manifest = {
    "apiVersion" = "argoproj.io/v1alpha1"
    "kind"       = "Application"
    "metadata" = {
      "name"      = trimsuffix(substr("${each.value.app_name}-${each.value.service_name}-${each.value.env_name}", 0, 63), "-")
      "namespace" = var.argocd_namespace
      "labels" = {
        "app" = trimsuffix(substr("${each.value.service_name}", 0, 63), "-")
        "env" = trimsuffix(substr("${each.value.env_name}", 0, 63), "-")
      }
    }
    "spec" = {
      "project" = trimsuffix(substr("${each.value.app_name}-${each.value.env_name}", 0, 63), "-")
      "source" = {
        "path"           = "${var.environment}/${each.value.app_name}${each.value.env_suffix}/${each.value.service_name}"
        "repoURL"        = "${each.value.gitops_url}"
        "targetRevision" = "${each.value.gitops_branch}"
      }
      "destination" = {
        "namespace" = trimsuffix(substr("${each.value.app_name}-${each.value.env_name}", 0, 63), "-")
        "name"      = "in-cluster"
      }
      "syncPolicy" = {
        "automated" = {
          "prune"    = "${var.prune_enabled}"
          "selfHeal" = "${var.self_heal_enabled}"
        }
      }
    }
  }

  depends_on = [
    kubernetes_namespace.application_namespace,
    kubernetes_manifest.argocd_project
  ]
}
