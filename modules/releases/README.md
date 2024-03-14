# Introduction

This is a small tool that helps create new releases on GitHub and automates the process of release creation.

## Deployment

The Releases module can be deployed using Terraform. The module should be included in the Terraform configuration.

Example code with comments:

```
module "releases" {
  source                     = <path to module>

  project                    = <gcp project id>
  region                     = <gcp region>
  release_repository         = <repository with releases>
  release_repository_branch  = <repository branch> empty value for default branch
  git_token_secret           = <gcp secret with github user token provided>
  cloudbuild_logs_bucket     = <cloud build logging gcs bucket>
  cloudbuild_service_account = <cloud build gcp service account>
  trigger_name               = <name for the cloud build trigger>
  disabled                   = <disable an automatic run the trigger> true/false

  providers = {
    # required providers
    google = google
    github = github
  }

}
```

## New release

Simply run the Cloud Build trigger to create new release with parameters:

**REPOSITORY** - The name of GitHub repository in the format `owner/name`.

**SECRET** - The name of gcp secret with github user token provided.

**TAG_NAME** - The name of the release tag. According to Semantic Versioning (2.0.0 2.0.0-rc1 1.0.0 1.0.0-beta) If name is specified, the specified name will be used. If the value is empty, it will increase the PATCH version of the latest release. For example: latest `0.0.1` will be `0.0.2`

**TARGET_COMMITISH** - Specifies the commitish value that determines where the Git tag is created from. Can be any branch or commit SHA. Default: the repository's default branch.

**DESCRIPTION** - Text describing the contents of the release.

**DRAFT** - true to create a draft (unpublished) release, false to create a published one. Default: `false`

**PRERELEASE** - true to identify the release as a prerelease. false to identify the release as a full release. Default: `false`

**GENERATE_NOTES** - Whether to automatically generate the body for this release. If body is specified, the body will be pre-pended to the automatically generated notes. Default: `true`

**MAKE_LATEST** - Specifies whether this release should be set as the latest release for the repository. Drafts and prereleases cannot be set as latest. Defaults to true for newly published releases. Legacy specifies that the latest release should be determined based on the release creation date and higher semantic version. Default: `true` Can be one of: `true`, `false`, `legacy`.
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=0.13 |
| <a name="requirement_github"></a> [github](#requirement\_github) | ~> 4.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 4.5.0, < 5.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_github"></a> [github](#provider\_github) | 4.31.0 |
| <a name="provider_google"></a> [google](#provider\_google) | 4.84.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_cloudbuild_trigger.create_release](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloudbuild_trigger) | resource |
| [github_repository.release](https://registry.terraform.io/providers/integrations/github/latest/docs/data-sources/repository) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_approval_required"></a> [approval\_required](#input\_approval\_required) | Require approval for release | `bool` | `true` | no |
| <a name="input_cloudbuild_logs_bucket"></a> [cloudbuild\_logs\_bucket](#input\_cloudbuild\_logs\_bucket) | GCS bucket name for Cloud Build logs | `string` | n/a | yes |
| <a name="input_cloudbuild_service_account"></a> [cloudbuild\_service\_account](#input\_cloudbuild\_service\_account) | Cloud Build service account name | `string` | n/a | yes |
| <a name="input_disabled"></a> [disabled](#input\_disabled) | Disable trigger | `bool` | `false` | no |
| <a name="input_git_token_secret"></a> [git\_token\_secret](#input\_git\_token\_secret) | Git token secret name | `string` | `"git-token"` | no |
| <a name="input_project"></a> [project](#input\_project) | Project name on google. | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Project region in google. | `string` | n/a | yes |
| <a name="input_release_repository"></a> [release\_repository](#input\_release\_repository) | GitHub repository | `string` | n/a | yes |
| <a name="input_trigger_name"></a> [trigger\_name](#input\_trigger\_name) | Trigger name | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->