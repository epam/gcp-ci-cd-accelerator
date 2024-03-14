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

output "cluster_name" {
  value = module.google_kubernetes_engine.name
}

output "cluster_ip" {
  value     = module.google_kubernetes_engine.endpoint
  sensitive = true
}

output "location" {
  value = module.google_kubernetes_engine.location
}

output "vpc_network" {
  value = google_compute_network.vpc.name
}

output "kubectl_config_command" {
  value = "gcloud container clusters get-credentials ${module.google_kubernetes_engine.name} --project ${var.project} --region ${module.google_kubernetes_engine.location}"
}
