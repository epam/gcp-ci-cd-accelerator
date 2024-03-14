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

module "secret_manager" {
  source  = "../gcp-secret-key"
  project = var.project
  region  = var.region
  name    = "argocd-password-${var.environment}"
  # overrides admin password, default is the random value
  key    = var.argocd_admin_password
  labels = "argocd"
}

resource "kubernetes_namespace" "argocd" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  namespace  = kubernetes_namespace.argocd.metadata.0.name
  chart      = "argo-cd"
  version    = var.argocd_version == "" ? null : var.argocd_version
  timeout    = 600

  set {
    name  = "global.image.repository"
    value = var.argocd_image_repository
  }

  set {
    name  = "global.image.tag"
    value = var.argocd_image_tag
  }

  # Install and upgrade CRDs
  set {
    name  = "crds.install"
    value = "true"
  }

  # Keep CRDs on chart uninstall
  set {
    name  = "crds.keep"
    value = "false"
  }

  # Run server without TLS
  set {
    name  = "configs.params.server\\.insecure"
    value = "true"
  }

  # Timeout to discover if a new manifests version got published to the repository
  set {
    name  = "configs.cm.timeout\\.reconciliation"
    value = var.polling_interval
  }

  # Bcrypt hashed admin password
  set {
    name  = "configs.secret.argocdServerAdminPassword"
    value = bcrypt(module.secret_manager.secret_key)
  }

  # Enable exec feature in Argo UI
  set {
    name  = "server.config.exec\\.enabled"
    value = "true"
  }

  # Add capabilities for admin account
  # apiKey - allows generating API keys
  # login - allows to login using UI (default enabled)
  set {
    name  = "server.config.accounts\\.admin"
    value = "apiKey"
  }

  # HA mode with autoscaling

  # Enables the Redis HA subchart and disables the custom Redis single node deployment
  set {
    name  = "redis-ha.enabled"
    value = var.redis_ha_enabled
  }
  # Enable Horizontal Pod Autoscaler for the Argo CD server
  set {
    name  = "server.autoscaling.enabled"
    value = var.server_autoscaling_enabled
  }
  # Minimum number of replicas for the Argo CD server
  set {
    name  = "server.autoscaling.minReplicas"
    value = var.server_autoscaling_minreplicas
  }
  # Enable Horizontal Pod Autoscaler for the repo server
  set {
    name  = "repoServer.autoscaling.enabled"
    value = var.reposerver_autoscaling_enabled
  }
  # Minimum number of replicas for the repo server 
  set {
    name  = "repoServer.autoscaling.minReplicas"
    value = var.reposerver_autoscaling_minreplicas
  }
  # The number of ApplicationSet controller pods to run
  set {
    name  = "applicationSet.replicaCount"
    value = var.applicationset_replicacount
  }

  depends_on = [kubernetes_namespace.argocd]
}

# Creating kubernetes secret for gitops connection
resource "kubernetes_secret" "private_repo" {
  count = length(var.application_data)

  metadata {
    name      = "gitops-repo-secret-${var.application_data[count.index].name}"
    namespace = kubernetes_namespace.argocd.metadata.0.name
    labels = {
      "argocd.argoproj.io/secret-type" = "repository"
    }
  }
  data = {
    type     = "git"
    url      = var.application_data[count.index].gitops_url
    username = "not-used"
    password = data.google_secret_manager_secret_version.git_token.secret_data
  }

  depends_on = [kubernetes_namespace.argocd]
}
