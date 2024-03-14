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
  user_list = toset(["superadmin", "default"])
}

### Creating secret for user password
module "secret_manager_password" {
  for_each = local.user_list

  source  = "../../modules/gcp-secret-key"
  project = var.project
  region  = var.region
  name    = "reportportal-${each.value}-password-${var.environment}"
  labels  = "reportportal"
}

### Updating default passwords
resource "null_resource" "password_update" {
  for_each = local.user_list

  provisioner "local-exec" {
    # quiet     = true
    working_dir = path.module
    command = templatefile(
      "${path.module}/password.tpl",
      {
        PROJECT_ID   = var.project,
        REGION       = var.gke_cluster_location,
        CLUSTER      = var.gke_cluster_name,
        NAMESPACE    = kubernetes_namespace.reportportal.metadata.0.name,
        SERVICE_NAME = "reportportal",
        HOST         = "localhost",
        DB_USER      = var.pg_user,
        USER         = each.value,
        HASH = base64encode(
          (bcrypt(module.secret_manager_password[each.value].secret_key))
        ),
        LOGS_BUCKET     = var.cloudbuild_logs_bucket,
        SERVICE_ACCOUNT = var.cloudbuild_service_account
      }
    )

    on_failure = continue
  }

  depends_on = [
    helm_release.reportportal,
    module.secret_manager_password,
  ]
}

### Creating secret for api token
resource "google_secret_manager_secret" "token" {
  for_each = local.user_list

  secret_id = format("reportportal-%s-token-%s",
    each.value,
    var.environment
  )

  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }

  labels = {
    service = "reportportal"
  }

}

resource "time_sleep" "wait_30_seconds" {
  depends_on = [null_resource.password_update]

  create_duration = "30s"
}

### Creating api tokens
resource "null_resource" "token_create" {
  for_each = local.user_list

  provisioner "local-exec" {
    # quiet = true
    working_dir = path.module
    command = templatefile(
      "${path.module}/token.tpl",
      {
        PROJECT_ID      = var.project,
        REGION          = var.gke_cluster_location,
        CLUSTER         = var.gke_cluster_name,
        NAMESPACE       = helm_release.nginx_ingress.namespace,
        SERVICE_NAME    = "reportportal",
        HOST            = "localhost",
        USER            = each.value,
        SECRET          = module.secret_manager_password[each.value].secret_key_id,
        SECRET_TOKEN    = google_secret_manager_secret.token[each.value].secret_id,
        LOGS_BUCKET     = var.cloudbuild_logs_bucket,
        SERVICE_ACCOUNT = var.cloudbuild_service_account
      }
    )

    on_failure = continue
  }

  depends_on = [
    helm_release.reportportal,
    helm_release.nginx_ingress,
    time_sleep.wait_30_seconds,
    google_secret_manager_secret.token,
  ]
}
