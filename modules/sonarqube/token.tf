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


### Creating secret for api token
resource "google_secret_manager_secret" "token" {
  secret_id = format("sonarqube-token-%s", var.environment)

  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }

  labels = {
    service = "sonarqube"
  }

}

### Creating sonarqube api token
resource "null_resource" "token_create" {

  provisioner "local-exec" {
    # quiet = true
    working_dir = path.module
    command = templatefile(
      "${path.module}/token.tpl",
      {
        PROJECT_ID      = var.project,
        REGION          = var.gke_cluster_location,
        CLUSTER         = var.gke_cluster_name,
        NAMESPACE       = kubernetes_namespace.sonarqube.metadata.0.name,
        SERVICE_NAME    = "sonarqube",
        HOST            = "localhost",
        USER            = var.sonarqube_admin,
        SECRET          = module.secret_manager.secret_key_id,
        SECRET_TOKEN    = google_secret_manager_secret.token.secret_id,
        LOGS_BUCKET     = var.cloudbuild_logs_bucket,
        SERVICE_ACCOUNT = var.cloudbuild_service_account
      }
    )

    on_failure = continue
  }

  depends_on = [
    helm_release.sonarqube,
    google_secret_manager_secret.token,
  ]
}
