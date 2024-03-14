# Infrastructure Deployment

After making any changes of the terraform configuration code you have to check infrastructure deployment of updated components or check deployment of hole environment as well.
This scenario helps you to perform all steps: deploying and destroying services, environments and applications.

## Prerequisites

1. [Install Google Cloud SDK](https://cloud.google.com/sdk/docs/install).
2. [Install Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli). Pay attention to license change after Terraform 1.5.5 (more details [here](https://www.hashicorp.com/blog/hashicorp-adopts-business-source-license)).
3. Install Git
4. GCP IAM roles:
   - Setup IAM policy on project level (`Project IAM Admin`)
   - Create IAM service account (`Service Account Admin`)
   - Create secret manager secret (`Secret Manager Admin`)
   - Create storage bucket (`Storage Admin`)
   - Create DNS zone (`DNS Administrator`)
   - Create build (`Cloud Build Editor`)
   - Enable GCP APIs (`Service Usage Admin`)
   - Configure GCP project metadata (`Compute Instance Admin (v1)`)
   - Impersonate Terraform service account (`Service Account User`)
   - Submit Terraform builds (`Service Account Token Creator`)
5. DNS domain name (required for IAP and TLS setup)


## Prepare GitHub repository and access token 

Create GitHub access token with `repo` and `admin:repo_hook` access scopes.

Clone infrastructure repository

```
git clone https://github.com/epam/gcp-ci-cd-accelerator.git
cd ./tf
```

## Configure Google Cloud SDK

```
# Export GCP Project and Region variables. You can find these values in extravars.tfvars file.
export PROJECT_ID=<gcp-project>
export REGION=<gcp-region>

# Or automatically
export PROJECT_ID=$(cat extravars.tfvars | grep 'project' | sed -n '2p' | cut -d'=' -f2 | cut -d'"' -f2)
export REGION=$(cat extravars.tfvars | grep 'region' | sed -n '2p' | cut -d'=' -f2 | cut -d'"' -f2)

# Authenticate to GCP
gcloud init
gcloud auth login
gcloud config set project $PROJECT_ID
```

## Create GCP project

>**NOTE:** You can skip this step if you already have GCP project with billing account assigned.

Ensure that [Configure Google Cloud SDK](./InfrastructureDeployment.md#configure-google-cloud-sdk) step is done.

```
export ACCOUNT_ID=$(gcloud beta billing accounts list --format="value(ACCOUNT_ID)")

gcloud projects create $PROJECT_ID
gcloud beta billing projects link $PROJECT_ID --billing-account=$ACCOUNT_ID
```

## Prepare Terraform

```
# Export Terraform variables
export TF_VAR_project=$(gcloud config get project)
export TF_VAR_region=$(gcloud compute project-info describe --project $TF_VAR_project --format="table[no-heading](commonInstanceMetadata.items.google-compute-default-region)")

# Provide credentials for application
gcloud auth application-default login
```

## Configure parameters

- Application parameters in files `app-config/*.yaml`
- Project parameters in file `extravars.tfvars`

## Automated bootstrap

***Attention! All steps below could damage or cause malfunction components of your GCP project! Use it at your own risk and responsibility!***

Create new [personal access token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens) with `repo` and `admin:repo_hook` access scopes.

>**Note:** Replace `<git-token>` with GitHub token value.

```
# Configure GitHub access token
export GIT_TOKEN=<git-token>

# Run bootstrap
./bootstrap.sh
```

## Deploy services and applications

Execute `Use this command to deploy all services` command from `bootstrap.sh` output

**Example:**

```
gcloud builds submit --config deploy.yaml ./  --substitutions _PROJECT_ID=${PROJECT_ID},_REGION=${REGION},_PROJECT_BUCKET=${PROJECT_ID}-tf,_IMAGE_REPO=gcr.io/${PROJECT_ID},_TF_VERSION=1.1.3,_RP_VERSION=5.7.2,_KUBERNETES_VERSION=1.24.16-gke.500,_SERVICE_ACCOUNT=terraform@${PROJECT_ID}.iam.gserviceaccount.com,_LOGS_BUCKET=${PROJECT_ID}-cloudbuild-logs,_ENVIRONMENT=non-prod --impersonate-service-account=terraform@${PROJECT_ID}.iam.gserviceaccount.com
```

Configured passwords for Argo CD, ReportPortal and SonarQube can be found in [Secret Manager](https://console.cloud.google.com/security/secret-manager):

- Argo CD
    - username: `admin`, password: `argocd-password-<environment>` secret
- ReportPortal
    - username: `superadmin`, password: `reportportal-superadmin-password-<environment>` secret
    - username: `default`, password: `reportportal-default-password-<environment>` secret
- SonarQube
    - username: `admin`, password: `sonarqube-password-<environment>` secret

## Post deployment steps

After successful infrastructure deployment complete [post deployment steps](/docs/PostDeploymentSteps.md).

## Update infrastructure

Use this case only if bootstrap configuration update is needed or `boostrap` folder and file `extravars.tfvars` were changed

>**Note:** Replace `<git-token>` with GitHub token value.

```
# Additionally export git token value as variable
export TF_VAR_git_token=<git-token>

# Terraform init
terraform -chdir=bootstrap init -backend-config="bucket=${PROJECT_ID}-tf"

# Terraform plan
terraform -chdir=bootstrap plan -var-file=../extravars.tfvars

# Terraform apply
terraform -chdir=bootstrap apply -var-file=../extravars.tfvars
```
