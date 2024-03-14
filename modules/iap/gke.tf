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


# Creating an SSL policy
resource "google_compute_ssl_policy" "ssl_policy" {
  name            = "ingress-ssl-policy-${var.environment}"
  profile         = "MODERN"
  min_tls_version = "TLS_1_2"
}

# Configuring FrontendConfig, Enabling HTTPS redirects and SSL policy
resource "kubernetes_manifest" "frontend_config" {
  manifest = {
    "apiVersion" = "networking.gke.io/v1beta1"
    "kind"       = "FrontendConfig"
    "metadata" = {
      "name"      = "ingress-frontend-config"
      "namespace" = var.ingress_nginx_namespace
    }
    "spec" = {
      "redirectToHttps" = {
        enabled = "true"
      }
      "sslPolicy" = google_compute_ssl_policy.ssl_policy.name
    }
  }

}

# Configuring BackendConfig
resource "kubernetes_manifest" "backend_config" {
  manifest = {
    "apiVersion" = "cloud.google.com/v1"
    "kind"       = "BackendConfig"
    "metadata" = {
      "name"      = "nginx-iap-backend"
      "namespace" = var.ingress_nginx_namespace
    }
    "spec" = {
      "healthCheck" = {
        "requestPath" = "/healthz"
        "port"        = "80"
        "type"        = "HTTP"
      }
      "iap" = {
        "enabled" = "true"
        "oauthclientCredentials" = {
          "secretName" = kubernetes_secret.iap_client_secret.metadata[0].name
        }
      }
    }
  }

}

# Creating secret with IAP credentials
resource "kubernetes_secret" "iap_client_secret" {
  metadata {
    name      = "oauth-client-secret"
    namespace = var.ingress_nginx_namespace
  }

  data = {
    client_id     = local.client_id
    client_secret = local.client_secret
  }

}

# Creating Google-managed certificates
resource "kubernetes_manifest" "service_certificate" {
  for_each = local.service_data
  manifest = {
    "apiVersion" = "networking.gke.io/v1"
    "kind"       = "ManagedCertificate"
    "metadata" = {
      "name"      = "certificate-${each.value.env_prefix}${each.value.name}"
      "namespace" = var.ingress_nginx_namespace
    }
    "spec" = {
      "domains" = ["${each.value.name}.${each.value.env_prefix}${local.domain}"]
    }
  }

}

# Creating Google-managed certificates
resource "kubernetes_manifest" "app_certificate" {
  for_each = local.app_data
  manifest = {
    "apiVersion" = "networking.gke.io/v1"
    "kind"       = "ManagedCertificate"
    "metadata" = {
      "name"      = "certificate-${each.value.env_prefix}${each.value.app_name}"
      "namespace" = var.ingress_nginx_namespace
    }
    "spec" = {
      "domains" = ["${each.value.env_prefix}${each.value.app_name}.${local.domain}"]
    }
  }

}

# Creating ingress for application
resource "kubernetes_ingress_v1" "app_ingress" {
  for_each = local.app_data
  metadata {
    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
    }
    labels = {
      "app" = each.value.app_name
    }
    name      = "ingress-${each.value.app_name}-${each.value.env_name}"
    namespace = "${each.value.app_name}-${each.value.env_name}"
  }

  spec {
    rule {
      host = "${each.value.env_prefix}${each.value.app_name}.${local.domain}"
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

# Creating ingress for service
resource "kubernetes_ingress_v1" "service_ingress" {
  for_each = local.filtered_service_data
  metadata {
    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
    }
    labels = {
      "app" = each.value.name
    }
    name      = "ingress-${each.value.name}-${var.environment}"
    namespace = each.value.name
  }

  spec {
    rule {
      host = "${each.value.name}.${each.value.env_prefix}${local.domain}"
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
resource "kubernetes_ingress_v1" "reportportal_ingress" {
  count = var.reportportal_namespace != "" ? 1 : 0

  metadata {
    name      = "ingress-reportportal-${var.environment}"
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
      host = (
        var.environment == "prod" ? "reportportal.${local.domain}" :
        "reportportal.${var.environment}.${local.domain}"
      )
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

# Associating Service port with our BackendConfig to turn on IAP
resource "kubernetes_annotations" "nginx_service_annotation" {
  api_version = "v1"
  kind        = "Service"
  metadata {
    name      = "ingress-nginx-controller"
    namespace = var.ingress_nginx_namespace
  }
  annotations = {
    "cloud.google.com/backend-config" = "{\"ports\": {\"80\":\"${kubernetes_manifest.backend_config.manifest.metadata.name}\"}}"
  }

}

# Getting names of created objects ManagedCertificate
locals {
  service_certificates = values(kubernetes_manifest.service_certificate)[*].manifest.metadata.name
  app_certificates     = values(kubernetes_manifest.app_certificate)[*].manifest.metadata.name
  certificates         = join(", ", setunion(local.app_certificates, local.service_certificates))
}

# Creating GCE Ingress
resource "kubernetes_ingress_v1" "gce_ingress" {
  metadata {
    name      = "ingress-nginx-${var.environment}"
    namespace = var.ingress_nginx_namespace
    annotations = {
      "kubernetes.io/ingress.class"                 = "gce"
      "kubernetes.io/ingress.global-static-ip-name" = google_compute_global_address.ip_address.name
      "networking.gke.io/managed-certificates"      = local.certificates
      "networking.gke.io/v1beta1.FrontendConfig"    = kubernetes_manifest.frontend_config.manifest.metadata.name
    }
  }
  spec {
    dynamic "rule" {
      for_each = local.service_data
      content {
        host = "${rule.value.name}.${rule.value.env_prefix}${local.domain}"
        http {
          path {
            backend {
              service {
                name = "ingress-nginx-controller"
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
    dynamic "rule" {
      for_each = local.app_data
      content {
        host = "${rule.value.env_prefix}${rule.value.app_name}.${local.domain}"
        http {
          path {
            backend {
              service {
                name = "ingress-nginx-controller"
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
    google_compute_global_address.ip_address,
    google_iap_client.iap_client,
    kubernetes_manifest.frontend_config,
    kubernetes_manifest.backend_config,
    kubernetes_secret.iap_client_secret,
  ]
}
