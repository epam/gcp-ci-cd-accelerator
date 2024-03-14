# Service Account

Authenticating Terraform against GCP in a complex environment can be painful, and even more so when you want to manage the lifecycle of keys and users. It’s a good idea to limit users own permissions and get into the habit of running Terraform code as one or more service accounts with just the right set of IAM roles. We use terraform service account with special permissions in Google Cloud project to access APIs and services.

## Creating Service Account

Bootstrap configuration automatically creates service account named *`"terraform@my_project_id.iam.gserviceaccount.com"`* by default. But you can create service account manually and set terraform variable "service_account" with full service account email e.g. *`service_account = "my_service_account@my_project_id.iam.gserviceaccount.com"`*.

## Accessing to APIs and services.

For this method, we added a few blocks into Terraform code (preferably in the `providers.tf` file) that will retrieve the service account credentials:
 + Provider that will be used to retrieve an access token for the service account. The provider is “google” but with the “impersonation” alias that’s assigned to it.
 + Data block to retrieve the access token that will be used to authenticate as the terraform service account. Block references the impersonation provider and the terraform service account.
 + Second “google” provider that will use the access token of your service account. With no alias, it’ll be the default provider used for any Google resources.

User, Group, or Service Account that should have access to impersonate terraform service account should be granted the role *`roles/iam.serviceAccountTokenCreator`* on the GCP IAM Policy.

## Conclusion

This method don’t require any service account keys to be generated or distributed. Instead of administrators creating, tracking, and rotating keys, the access to the service account is centralized to its corresponding IAM policy. By using impersonation, the code becomes usable by anyone on the project with the Service Account Token Creator role, which can be easily granted and revoked by an administrator.
