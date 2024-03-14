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

# Deploying the NGINX Ingress Controller
resource "helm_release" "nginx_ingress" {
  name             = "ingress-nginx"
  namespace        = var.nginx_ingress_namespace
  create_namespace = true
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  version          = var.nginx_ingress_version

  set {
    name  = "ingress.enable"
    value = false
  }

  set {
    name  = "controller.service.type"
    value = "ClusterIP"
  }

  set {
    name  = "controller.service.internal.enabled"
    value = "true"
  }

  set {
    name  = "controller.service.internal.annotations.networking\\.gke\\.io/load-balancer-type"
    value = "Internal"
    type  = "string"
  }

}

output "namespace" {
  value = helm_release.nginx_ingress.namespace
}
