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


resource "kubernetes_namespace" "sonarqube" {
  metadata {
    name = var.sonarqube_namespace
  }
}

resource "helm_release" "sonarqube" {
  name              = "sonarqube"
  chart             = "sonarqube"
  repository        = "https://sonarsource.github.io/helm-chart-sonarqube"
  version           = var.sonarqube_version
  dependency_update = true
  namespace         = kubernetes_namespace.sonarqube.metadata[0].name
  timeout           = 600

  set {
    name = "account.adminPassword"
    # value = var.sonarqube_pass
    value = module.secret_manager.secret_key
  }

  set {
    name  = "image.repository"
    value = var.sonarqube_image_repository
  }

  set {
    name  = "image.tag"
    value = var.sonarqube_image_tag
  }

  # plugins disabled
  # set {
  #   name  = "plugins.install"
  #   value = var.sonarqube_plugins
  # }
}

module "secret_manager" {
  source = "../../modules/gcp-secret-key"

  project = var.project
  region  = var.region
  name    = "sonarqube-password-${var.environment}"
  # key        = var.sonarqube_pass
  # random password by default
  labels = "sonarqube"
}
