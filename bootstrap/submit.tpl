
# Use this command to deploy all services

gcloud builds submit --config deploy.yaml ./  --substitutions _PROJECT_ID=${PROJECT_ID},_REGION=${REGION},_PROJECT_BUCKET=${TF_BUCKET},_IMAGE_REPO=${IMAGE_REPO},_TF_VERSION=${TF_VERSION},_RP_VERSION=${RP_VERSION},_KUBERNETES_VERSION=${K8S_VERSION},_SERVICE_ACCOUNT=${SERVICE_ACCOUNT},_LOGS_BUCKET=${LOGS_BUCKET},_ENVIRONMENT=${ENVIRONMENT} --impersonate-service-account=${SERVICE_ACCOUNT}

# Use this command to destroy all services

gcloud builds submit --config destroy.yaml ./  --substitutions _PROJECT_ID=${PROJECT_ID},_REGION=${REGION},_PROJECT_BUCKET=${TF_BUCKET},_TF_VERSION=${TF_VERSION},_SERVICE_ACCOUNT=${SERVICE_ACCOUNT},_LOGS_BUCKET=${LOGS_BUCKET},_ENVIRONMENT=${ENVIRONMENT} --impersonate-service-account=${SERVICE_ACCOUNT}
