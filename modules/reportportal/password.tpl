gcloud builds submit . --config password.yaml --suppress-logs --substitutions _PROJECT_ID=${PROJECT_ID},_REGION=${REGION},_CLUSTER=${CLUSTER},_NAMESPACE=${NAMESPACE},_SERVICE_NAME=${SERVICE_NAME},_HOST=${HOST},_USER=${USER},_DB_USER=${DB_USER},_HASH=${HASH},_LOGS_BUCKET=${LOGS_BUCKET},_SERVICE_ACCOUNT=${SERVICE_ACCOUNT} --impersonate-service-account=${SERVICE_ACCOUNT}