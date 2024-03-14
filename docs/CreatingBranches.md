# Creating Branches

A feature branch is a copy of the main codebase where an individual or team of software developers can work on a new feature until it is complete.

A feature environment is a feature branch deployed in an on-demand ephemeral environment, which enables automated tests and QA to test that feature in isolation, before deploying to production.

## Preparation

In order to work with feature environments your GCP project must be in fully working condition.
Especially need to ensure:
1. Cloudbuild triggers **`infra-<application name>-create-environment`** and **`infra-<application name>-delete-environment`** are presented and activated.
2. Github repository with main codebase includes webhooks in successful state. **Github Repository -> Settings -> Webhooks -> :heavy_check_mark:Create :heavy_check_mark:Delete**

## Creating new feature branch

In creating a feature environmet you need to create a new branch in codebase repository with name must contain phrase **"env"**. For example as a prefix *"env-new-feature"* or postfix *"feature-new-env"*
After that the trigger `infra-<application name>-create-environment` is started. When work is completed, you could check that:
1. **Gitops repository** directory named *`<application name>-<branch name>`* with application manifests is created
2. **GKE cluster** has namespace *`<application name>-<branch name>`* with fully working components (deployments, pods, services etc.)
3. **Argocd server** contains new project *`<application name>-<branch name>`* and set of applications.

## Deleting feature branch

After deleting feature environment branch in the github repository, trigger *`infra-<application name>-delete-environment`* cleanups all resources associated with the branch: kubernetes namespaces, argocd applications, gitops repository manifests.

---
**NOTE**

Deleting process begins with a delay of up to 3 minutes.

---
