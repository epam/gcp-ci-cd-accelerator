#!/bin/bash
# Copyright 2023 EPAM Systems
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -e

# export PROJECT_ID=
# gcloud config set project $PROJECT_ID
# gcloud auth application-default login

read -p "Do you want to delete project data? (yes/no) " yn

case $yn in 
    yes ) cd bootstrap
          # migrate terraform backend from "remote" to "local"
          rm -f backend_override.tf
          terraform init -backend-config="bucket=${PROJECT_ID}-tf" -reconfigure
          
          # delete project data
          echo -e "terraform{\nbackend \"local\" {}\n}" > backend_override.tf
          
          terraform init -force-copy
              
          terraform destroy -auto-approve -var-file=../extravars.tfvars \
              -compact-warnings -var=git_token=secret
          ;;
    * ) echo exiting...;
        exit;;
esac
