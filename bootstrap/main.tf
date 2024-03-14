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


# Enable Google Cloud APIs
module "enable_google_apis" {
  source  = "terraform-google-modules/project-factory/google//modules/project_services"
  version = "~> 14.1"

  project_id                  = var.project
  disable_services_on_destroy = false
  disable_dependent_services  = false

  activate_apis = local.apis
}

# Create service account for terraform
resource "google_service_account" "terraform" {
  count = var.service_account == "" ? 1 : 0

  project      = var.project
  account_id   = "terraform"
  display_name = "Terraform SA"
  description  = "Service Account for Terraform"

  depends_on = [module.enable_google_apis]
}

# Assign cloudbuild service account role
module "cloudbuild_roles" {
  source  = "terraform-google-modules/iam/google//modules/member_iam"
  version = "7.5.0"

  project_id              = var.project
  prefix                  = "serviceAccount"
  service_account_address = "${data.google_project.project.number}@cloudbuild.gserviceaccount.com"
  project_roles           = ["roles/cloudbuild.builds.builder"]

  depends_on = [module.enable_google_apis]
}

# Assign terraform service account roles
module "terraform_roles" {
  count = var.service_account == "" ? 1 : 0

  source  = "terraform-google-modules/iam/google//modules/member_iam"
  version = "7.5.0"

  project_id              = var.project
  prefix                  = "serviceAccount"
  service_account_address = google_service_account.terraform[0].email
  project_roles           = local.iam_roles

  depends_on = [module.enable_google_apis]
}

# Add default region for project
resource "google_compute_project_metadata_item" "default" {
  project = var.project
  key     = "google-compute-default-region"
  value   = var.region

  depends_on = [module.enable_google_apis]
}

# Add git token to Secret Manager
module "secret_manager" {
  source  = "../modules/gcp-secret-key"
  project = var.project
  region  = var.region
  name    = "git-token"
  key     = var.git_token
  labels  = "git"

  depends_on = [module.enable_google_apis]
}

# Create a bucket for Terrafom State in Google cloud storage
resource "google_storage_bucket" "tfstate" {
  project       = var.project
  name          = "${var.project}-tf"
  location      = var.region
  storage_class = "REGIONAL"
  force_destroy = true
  versioning {
    enabled = true
  }
  uniform_bucket_level_access = true

  depends_on = [module.enable_google_apis]
}

# Ensure that the Google Cloud Container Registry exists.
resource "google_container_registry" "registry" {
  project = var.project

  depends_on = [module.enable_google_apis]
}

# Create a bucket for Cloudbuild Logs in GCS
resource "google_storage_bucket" "cloudbuild_logs" {
  project       = var.project
  name          = "${var.project}-cloudbuild-logs"
  storage_class = "REGIONAL"
  location      = var.region
  force_destroy = true

  depends_on = [module.enable_google_apis]
}

# Create Cloud DNS managed zone
module "cloud_dns_zone" {
  count   = var.domain != "" ? 1 : 0
  source  = "terraform-google-modules/cloud-dns/google"
  version = "4.2.1"

  project_id  = var.project
  type        = "public"
  name        = "cloud-dns-zone"
  description = "public DNS zone"
  domain      = "${var.domain}."

  depends_on = [module.enable_google_apis]
}
