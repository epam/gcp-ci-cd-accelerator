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


resource "google_compute_subnetwork" "proxy_only_subnet" {
  name          = "proxy-only-subnet-${var.environment}"
  region        = var.region
  ip_cidr_range = var.proxy_ip_cidr_range
  purpose       = "INTERNAL_HTTPS_LOAD_BALANCER"
  role          = "ACTIVE"
  network       = data.google_compute_network.vpc_network.id
}

resource "kubernetes_manifest" "backend_internal" {
  manifest = {
    "apiVersion" = "cloud.google.com/v1"
    "kind"       = "BackendConfig"
    "metadata" = {
      "name"      = "nginx-internal-backend"
      "namespace" = var.ingress_nginx_namespace
    }
    "spec" = {
      "healthCheck" = {
        "requestPath" = "/healthz"
        "port"        = "80"
        "type"        = "HTTP"
      }
    }
  }

}

resource "kubernetes_annotations" "nginx_internal_annotation" {
  api_version = "v1"
  kind        = "Service"
  metadata {
    name      = "ingress-nginx-controller-internal"
    namespace = var.ingress_nginx_namespace
  }
  annotations = {
    "cloud.google.com/backend-config" = "{\"ports\": {\"80\":\"${kubernetes_manifest.backend_internal.manifest.metadata.name}\"}}"
  }

}

# Creating ingress for service
resource "kubernetes_ingress_v1" "service_ingress_internal" {
  for_each = local.filtered_service_data

  metadata {
    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
    }
    labels = {
      "app" = "${each.value.name}"
    }
    name      = "ingress-${each.value.name}-internal"
    namespace = each.value.name
  }

  spec {
    rule {
      host = "${each.value.name}.${var.environment}.${var.private_domain}"
      http {
        path {
          backend {
            service {
              name = each.value.service_ui
              port {
                number = each.value.service_port
              }
            }
          }
          path      = "/"
          path_type = "Prefix"
        }
      }
    }
  }
}

# Creating ingress for ReportPortal
resource "kubernetes_ingress_v1" "reportportal_ingress_internal" {
  count = var.reportportal_namespace != "" ? 1 : 0

  metadata {
    name      = "ingress-reportportal-internal"
    namespace = "reportportal"
    labels = {
      "app"     = "reportportal"
      "release" = "reportportal"
    }
    annotations = {
      "kubernetes.io/ingress.class"                         = "nginx"
      "nginx.ingress.kubernetes.io/proxy-body-size"         = "128m"
      "nginx.ingress.kubernetes.io/proxy-buffer-size"       = "512k"
      "nginx.ingress.kubernetes.io/proxy-buffers-number"    = "4"
      "nginx.ingress.kubernetes.io/proxy-busy-buffers-size" = "512k"
      "nginx.ingress.kubernetes.io/proxy-connect-timeout"   = "8000"
      "nginx.ingress.kubernetes.io/proxy-read-timeout"      = "4000"
      "nginx.ingress.kubernetes.io/proxy-send-timeout"      = "4000"
      "nginx.ingress.kubernetes.io/rewrite-target"          = "/$2"
      "nginx.ingress.kubernetes.io/ssl-redirect"            = "false"
      "nginx.ingress.kubernetes.io/x-forwarded-prefix"      = "/$1"
    }
  }
  spec {
    rule {
      host = "reportportal.${var.environment}.${var.private_domain}"
      http {

        path {
          backend {
            service {
              name = "reportportal-index"
              port {
                name = "headless"
              }
            }
          }
          path      = "/()?(.*)"
          path_type = "Prefix"
        }

        path {
          backend {
            service {
              name = "reportportal-ui"
              port {
                name = "headless"
              }
            }
          }
          path      = "/(ui)/?(.*)"
          path_type = "Prefix"
        }

        path {
          backend {
            service {
              name = "reportportal-uat"
              port {
                name = "headless"
              }
            }
          }
          path      = "/(uat)/?(.*)"
          path_type = "Prefix"
        }

        path {
          backend {
            service {
              name = "reportportal-api"
              port {
                name = "headless"
              }
            }
          }
          path      = "/(api)/?(.*)"
          path_type = "Prefix"
        }
      }
    }
  }
}

# Creating GCE Ingress
resource "kubernetes_ingress_v1" "gce_internal_ingress" {
  wait_for_load_balancer = true

  metadata {
    name      = "ingress-nginx-internal"
    namespace = var.ingress_nginx_namespace
    annotations = {
      "kubernetes.io/ingress.class" = "gce-internal"
    }
  }
  spec {
    dynamic "rule" {
      for_each = local.service_data
      content {
        host = "${rule.value.name}.${var.environment}.${var.private_domain}"
        http {
          path {
            backend {
              service {
                name = "ingress-nginx-controller-internal"
                port {
                  number = 80
                }
              }
            }
            path      = "/*"
            path_type = "ImplementationSpecific"
          }
        }
      }
    }
  }

  depends_on = [
    kubernetes_manifest.backend_internal,
    google_compute_subnetwork.proxy_only_subnet,
  ]
}
