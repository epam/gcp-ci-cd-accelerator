<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.1.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 4.37.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 4.37.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_cloudbuild_trigger.tf_audit_trigger](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloudbuild_trigger) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloudbuild_logs_bucket"></a> [cloudbuild\_logs\_bucket](#input\_cloudbuild\_logs\_bucket) | GCS bucket for Cloud Build logs | `string` | n/a | yes |
| <a name="input_cloudbuild_service_account"></a> [cloudbuild\_service\_account](#input\_cloudbuild\_service\_account) | IAM service account to use in Cloud Build | `string` | n/a | yes |
| <a name="input_organization"></a> [organization](#input\_organization) | GitHub organization | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | Project name on google. | `string` | n/a | yes |
| <a name="input_project_bucket"></a> [project\_bucket](#input\_project\_bucket) | Terraform state GCS bucket | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Project region in google. | `string` | n/a | yes |
| <a name="input_repository_branch"></a> [repository\_branch](#input\_repository\_branch) | The branch that contains the source files. | `string` | `"main"` | no |
| <a name="input_source_repository"></a> [source\_repository](#input\_source\_repository) | GitHub repository | `string` | n/a | yes |
| <a name="input_terraform_version"></a> [terraform\_version](#input\_terraform\_version) | Terraform version for validation tests | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
