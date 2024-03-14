# Infrastructure Cleanup

## Automatic

```
# Export some vars
export PROJECT_ID=<gcp-project>

gcloud builds submit --config destroy.yaml ./ --substitutions ...

# Automated cleanup
./cleanup.sh
```

## Manual

In most cases you need to use [automatic](./InfrastructureCleanup.md#automatic) cleanup.

```
# Configure GCP project id and region
export PROJECT_ID=<gcp-project>
export REGION=<gcp-region>

# Init Terraform
cd bootstrap
terraform init -backend-config="bucket=${PROJECT_ID}-tf"
terraform output

# To clean environment use command from output
gcloud builds submit --config destroy.yaml ./ --substitutions _PROJECT_ID=${PROJECT_ID},_REGION=${REGION},_PROJECT_BUCKET=${PROJECT_ID}-tf,_TF_VERSION=1.1.3,_RP_VERSION=5.7.2,_SERVICE_ACCOUNT=terraform@${PROJECT_ID}.iam.gserviceaccount.com,_LOGS_BUCKET=${PROJECT_ID}-cloudbuild-logs,_ENVIRONMENT=non-prod

# Migrate terraform backend from "remote" to "local"
echo -e "terraform{\nbackend \"local\" {}\n}" > backend_override.tf
terraform init -force-copy

# Cleanup
terraform destroy -var=project=$PROJECT_ID -var=region=$REGION -var=git_token=anyvalue
```

### GCP project deletion

>**NOTE:** This step is optional, delete GCP project only if you absolutely sure that you don't need it.

```
gcloud projects delete $PROJECT_ID
gcloud beta billing accounts projects unlink $PROJECT_ID
```
