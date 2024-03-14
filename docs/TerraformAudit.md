# Terraform Audit

Module `tf-audit` is used to setup CloudBuild trigger which will run Terraform checks for all changed directories (exception can be added to `.auditignore` file).

Those checks are:

- Verify Terraform code formatting
- Verify Terraform documentation
- Run TFLint
- Run TFsec
- Run Open Policy Agent
- Run Checkov
- Generate summary report

## Verify Terraform code formatting

Executes if `_RUN_TF_FMT` is `true` (default is `true`). Under the hood `terraform fmt` command is used to verify code is formatted according to best practices. Output from `terraform fmt` will be considered as failed check.

## Verify Terraform documentation

Executes if `_RUN_TF_DOCS` is `true` (default is `true`). Verifies that README.md file is present in Terraform module and it's content is up to date with [terraform-docs](https://github.com/terraform-docs/terraform-docs) output. Absense of README.md or content differences between `<!-- BEGIN_TF_DOCS -->` and `<!-- END_TF_DOCS -->` markers will be considered as failed check.

Readme file can be displayed at summary stage if `_SHOW_README` is `true` (default is `false`).

## Run TFLint

Executes if `_RUN_TF_LINT` is `true` (default is `true`). Any issues or errors reported by [TFLint](https://github.com/terraform-linters/tflint) linter will be considered as failed check.

## Run TFsec

Executes if `_RUN_TF_SEC` is `true` (default is `true`). Any issues reported by [TFsec](https://github.com/aquasecurity/tfsec) linter will be considered as failed check.

## Run Open Policy Agent

Executes if `_RUN_TF_OPA` is `true` (default is `true`). [Open Policy Agent](https://github.com/open-policy-agent/opa) uses [terraform.rego](../environments/non-prod/tf-audit/terraform.rego) policy. Any issues reported by OPA will be considered as failed check.

## Run Checkov

Executes if `_RUN_TF_CHECKOV` is `true` (default is `true`). Any issues reported by [Checkov](https://github.com/bridgecrewio/checkov) will be considered as failed check.

## Generate summary report

All reports from previous stages will be displayed in pipeline output at this stage. If any of reports is failed then then whole pipeline will fail. To skip errors configure `_SKIP_ERRORS` to `true` (default is `true`).

## Version selection

Tool versions can be customized in [tf-audit.yaml](../environments/non-prod/tf-audit/tf-audit.yaml) using the following parameters:

| Parameter | Value |
| --------- | ----- |
| _TF_VERSION | 1.1.3 |
| _TFDOCS_VERSION | 0.16.0 |
| _TFLINT_VERSION | 0.43.0 |
| _TFSEC_VERSION | 1.28.1 |
| _TFOPA_VERSION | 0.46.1 |
| _TFCHECKOV_VERSION | 2.2.114 |
