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


resource "kubernetes_namespace" "backstage" {
  metadata {
    name = var.backstage_namespace
  }
}

resource "kubernetes_secret" "backstage" {
  metadata {
    name      = "backstage-secret"
    namespace = kubernetes_namespace.backstage.metadata[0].name
  }
  data = {
    "GITHUB_TOKEN" = data.google_secret_manager_secret_version.git_token.secret_data
  }

  depends_on = [kubernetes_namespace.backstage]
}

resource "helm_release" "backstage" {
  name       = "backstage"
  chart      = "backstage"
  repository = "https://backstage.github.io/charts"
  namespace  = kubernetes_namespace.backstage.metadata[0].name
  version    = var.backstage_version
  timeout    = 600

  set {
    name  = "backstage.image.registry"
    value = ""
  }

  set {
    name  = "backstage.image.repository"
    value = var.backstage_image_repository
  }

  set {
    name  = "backstage.image.tag"
    value = var.backstage_image_tag
  }

  set {
    name  = "backstage.extraEnvVarsSecrets[0]"
    value = kubernetes_secret.backstage.metadata[0].name
  }

  set {
    name  = "postgresql.enabled"
    value = var.postgresql_enabled
  }

  set {
    name  = "backstage.appConfig"
    value = var.backstage_app_config
  }

  depends_on = [kubernetes_secret.backstage]
}
