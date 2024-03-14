# New application onboarding

## Application configuration

Create new application configuration according to [application onboarding](./Repositories.md#repository-with-cicd-infrastructure-and-pipelines-definition).

## GitOps manifests

Create new application kubernetes manifests in GitOps repository using `<environment>/<stage>-<application>/<service>/<service>.yaml`.

Example:

- Environment: non-prod
- Stage: dev
- Application: sampleapp
- Service: hello

Kubernetes manifests should be present in `non-prod/dev-sampleapp/hello/hello.yaml` file in GitOps repository (see `gitops_url` in application configuration).

## CloudBuild configuration

Create CloudBuild configuration for CI (`<source_path>/<name>/<service>/cloudbuild-ci.yaml`) and CD (`<source_path>/<name>/<service>/cloudbuild-cd.yaml`).

<details>
<summary markdown="span">cloudbuild-ci.yaml example (click to expand):</summary>

```
---
steps:
  - id: Build image
    name: 'gcr.io/cloud-builders/docker'
    args: ['build', '-t', 'gcr.io/$_PROJECT_ID/sampleapp/hello:$SHORT_SHA', '-t', 'gcr.io/$_PROJECT_ID/sampleapp/hello:latest', '.']
    dir: /workspace/src/$_SERVICE_NAME

  - name: gcr.io/cloud-builders/gcloud
    args:
      - '-c'
      - |
        [[ $BRANCH_NAME =~ ^(main|master)$ ]] || [[ $BRANCH_NAME == *"env"* ]] || exit 0

        gcloud builds triggers run app-$_APP_NAME-$_SERVICE_NAME-cd \
          --branch=$BRANCH_NAME --quiet --no-user-output-enabled
    id: Run Deployment
    entrypoint: bash

substitutions:
  _REGION: ''
  _CLUSTER: ''
  _APP_NAME: ''
  _PROJECT_ID: ''
  _SOURCE_PATH: ''
  _SERVICE_NAME: ''
  _SONAR_HOST: ''
  _SONAR_SECRET: ''
  _RP_SECRET : ''
  _RP_ENDPOINT: ''
  _RP_PROJECT_NAME: ''
  _LOGS_BUCKET: ''
  _SERVICE_ACCOUNT: ''

options:
  logging: GCS_ONLY
logsBucket: gs://$_LOGS_BUCKET

serviceAccount: projects/$_PROJECT_ID/serviceAccounts/$_SERVICE_ACCOUNT
```
</details>

<details>
<summary markdown="span">cloudbuild-ci.yaml example (click to expand):</summary>

```
steps:
  - id: Clone & Check Repository
    name: gcr.io/cloud-builders/gcloud
    args:
      - '-c'
      - |
        [[ $BRANCH_NAME =~ ^(main|master)$ ]] || [[ $BRANCH_NAME == *"env"* ]] || exit 0

        if [[ $BRANCH_NAME =~ ^(main|master)$ ]]; then
            # For mainline branches use default env configuration
            _BRANCH_NAME=$_DEFAULT_ENV
        else
            _BRANCH_NAME=$BRANCH_NAME
        fi
        _BRANCH_NAME=$${_BRANCH_NAME//_/-}

        git clone --depth 2 \
            https://$$GIT_TOKEN@$_GITOPS_REPO gitops

        if [ -d "/workspace/gitops/$_ENVIRONMENT/$$_BRANCH_NAME-$_APP_NAME" ];
        then
              echo "Directory $$_BRANCH_NAME-$_APP_NAME doesn't need to create"
              exit 0
        else
              echo "Creating Gitops Directory $$_BRANCH_NAME-$_APP_NAME..."
              cp -avr /workspace/gitops/$_ENVIRONMENT/$_DEFAULT_ENV-$_APP_NAME \
                /workspace/gitops/$_ENVIRONMENT/$$_BRANCH_NAME-$_APP_NAME

              echo "Pushing changes to gitops repo ..."
              git config --global user.name $_ORG_NAME
              git config --global user.email $_ORG_NAME@gmail.com

              cd /workspace/gitops

              git status
              git add . && git commit -a -m \
              "created new environment $$_BRANCH_NAME-$_APP_NAME" || true

              git push https://$$GIT_TOKEN@$_GITOPS_REPO || \
                sleep $((RANDOM % 10)) && git pull --rebase origin && git push origin
        fi
    entrypoint: bash
    secretEnv:
      - GIT_TOKEN
  - id: Version Update
    name: gcr.io/cloud-builders/gcloud
    args:
      - '-c'
      - |
        [[ $BRANCH_NAME =~ ^(main|master)$ ]] || [[ $BRANCH_NAME == *"env"* ]] || exit 0

        if [[ $BRANCH_NAME =~ ^(main|master)$ ]]; then
            increment_version() {
              local delimiter=.
              local array=($(echo "$1" | tr $delimiter '\n'))
              array[$2]=$((array[$2]+1))
              if [ $2 -lt 2 ]; then array[2]=0; fi
              if [ $2 -lt 1 ]; then array[1]=0; fi
              echo $(local IFS=$delimiter ; echo "${array[*]}")
            }

            TAG_NAME=$(sed -n /image:/p /workspace/gitops/$_ENVIRONMENT/$_DEFAULT_ENV-$_APP_NAME/$_SERVICE_NAME/$_SERVICE_NAME.yaml)
            TAG_NAME=$${TAG_NAME##*:}

            echo "old version $$TAG_NAME"

            [[ $$TAG_NAME =~ ^[0-9]+\.[0-9]+\.[0-9] ]] || TAG_NAME="0.0.0"

            if grep -iq "MAJOR" <<< "$(git log -1 --pretty=%B)"; then

              TAG_NAME=$(increment_version $$TAG_NAME 0)

            elif grep -iq "MINOR" <<< "$(git log -1 --pretty=%B)"; then 
            
              TAG_NAME=$(increment_version $$TAG_NAME 1)
    
            else
              TAG_NAME=$(increment_version $$TAG_NAME 2)
            fi
    
            echo -n "new version " && echo $$TAG_NAME | tee /workspace/version_tag
        else
            echo "version $SHORT_SHA"
            exit 0
        fi
    entrypoint: bash
  - id: Docker Build
    name: google/cloud-sdk:slim
    args:
      - '-c'
      - |
        [[ $BRANCH_NAME =~ ^(main|master)$ ]] || [[ $BRANCH_NAME == *"env"* ]] || exit 0

        if [[ $BRANCH_NAME =~ ^(main|master)$ ]]; then
            TAG_NAME=$(cat /workspace/version_tag)

            PULL_REQUEST_NUMBER=$(git log -1 --format=%B --oneline | sed -e "s/.*#\([0-9]\+\).*/\1/g")
            PULL_REQUEST_TAG_NAME=$(git ls-remote https://$$GIT_TOKEN@$_SOURCE_REPO \
              pull/$${PULL_REQUEST_NUMBER}/head | cut -c -7)

            if gcloud container images describe --verbosity=none --no-user-output-enabled --quiet \
              $_IMAGE_REPO/$_APP_NAME/$_SERVICE_NAME:$$PULL_REQUEST_TAG_NAME; then
            
                gcloud container images add-tag --verbosity=none --quiet \
                  $_IMAGE_REPO/$_APP_NAME/$_SERVICE_NAME:$$PULL_REQUEST_TAG_NAME \
                  $_IMAGE_REPO/$_APP_NAME/$_SERVICE_NAME:$$TAG_NAME
            else
                cd $(dirname $(find . -type f -name Dockerfile | head -1))
                docker build -t $_IMAGE_REPO/$_APP_NAME/$_SERVICE_NAME:$$TAG_NAME .
                docker push $_IMAGE_REPO/$_APP_NAME/$_SERVICE_NAME:$$TAG_NAME
            fi
        else
            TAG_NAME=$SHORT_SHA

            cd $(dirname $(find . -type f -name Dockerfile | head -1))
            docker build -t $_IMAGE_REPO/$_APP_NAME/$_SERVICE_NAME:$$TAG_NAME .
            docker push $_IMAGE_REPO/$_APP_NAME/$_SERVICE_NAME:$$TAG_NAME
        fi
    dir: /workspace/$_SOURCE_PATH/$_SERVICE_NAME
    entrypoint: bash
    secretEnv:
      - GIT_TOKEN
  - id: Update Deploy Repository
    name: gcr.io/cloud-builders/gcloud
    args:
      - '-c'
      - |
        [[ $BRANCH_NAME =~ ^(main|master)$ ]] || [[ $BRANCH_NAME == *"env"* ]] || exit 0

        echo "Downloading yq ..."
        curl -sLO \
        'https://github.com/mikefarah/yq/releases/download/v4.30.5/yq_linux_amd64.tar.gz'
        tar -xzf yq_linux_amd64.tar.gz && mv yq_linux_amd64 /usr/bin/yq
        yq --version

        echo "Getting artifact version ..."

        if [[ $BRANCH_NAME =~ ^(main|master)$ ]]; then
            TAG_NAME=$(cat /workspace/version_tag)
        else
            TAG_NAME=$SHORT_SHA
        fi

        echo "Updating manifest ..."

        if [[ $BRANCH_NAME =~ ^(main|master)$ ]]; then
            _BRANCH_NAME=$_DEFAULT_ENV
        else
            _BRANCH_NAME=$BRANCH_NAME
        fi
        _BRANCH_NAME=$${_BRANCH_NAME//_/-}

        cd /workspace/gitops/$_ENVIRONMENT/$$_BRANCH_NAME-$_APP_NAME/$_SERVICE_NAME

        yq -i 'with(select(.kind=="Deployment"); .spec.template.metadata.labels.short-sha |= "$SHORT_SHA")' \
          $_SERVICE_NAME.yaml

        yq -i 'with(select(.kind=="Deployment"); .spec.template.metadata.labels.commit-sha |= "$COMMIT_SHA")' \
          $_SERVICE_NAME.yaml

        yq -i 'with(select(.kind=="Deployment"); .spec.template.spec.containers[0].image |= "$_IMAGE_REPO/$_APP_NAME/$_SERVICE_NAME:'$$TAG_NAME'")' \
          $_SERVICE_NAME.yaml

        echo "Pushing changes to gitops repo ..."
        git config --global user.name $_ORG_NAME
        git config --global user.email $_ORG_NAME@gmail.com

        git status
        git commit -a -m \
        "manifest $$_BRANCH_NAME-$_APP_NAME/$_SERVICE_NAME updated with image $_SERVICE_NAME:$$TAG_NAME" || true

        git diff HEAD^ HEAD
        git push https://$$GIT_TOKEN@$_GITOPS_REPO || \
          sleep $((RANDOM % 10)) && git pull --rebase origin && git push origin
    entrypoint: bash
    secretEnv:
      - GIT_TOKEN

substitutions:
  _SECRET: ''
  _ORG_NAME: ''
  _APP_NAME: ''
  _IMAGE_REPO: ''
  _GITOPS_REPO: ''
  _SOURCE_REPO: ''
  _SOURCE_PATH: ''
  _ENVIRONMENT: ''
  _DEFAULT_ENV: ''
  _SERVICE_NAME: ''
  _LOGS_BUCKET: ''
  _SERVICE_ACCOUNT: ''

availableSecrets:
  secretManager:
    - versionName: projects/$PROJECT_ID/secrets/$_SECRET/versions/latest
      env: GIT_TOKEN

options:
  logging: GCS_ONLY
logsBucket: gs://$_LOGS_BUCKET

serviceAccount: projects/$_PROJECT_ID/serviceAccounts/$_SERVICE_ACCOUNT

```
</details>

## Connect GitHub repository

Connect CloudBuild to application repository using [this instruction](./PostDeploymentSteps.md#manage-repositories).
