#!/bin/bash

cd ../Code/

export GOOGLE_APPLICATION_CREDENTIALS="../../SA/sa-pipeline-clrun.json"

export PROJECT_ID=ryan-cicd
export LOCATION=northamerica-northeast1
export REPOSITORY=clock-weather
export IMAGE=v1

gcloud alpha artifacts repositories create $REPOSITORY \
    --repository-format=Docker \
    --location=northamerica-northeast1 \
    --description="Clock and Weather repository"

gcloud artifacts repositories list

gcloud builds submit --config=cloudbuild.yaml \
  --substitutions=_LOCATION="${LOCATION}",_REPOSITORY="${REPOSITORY}",_IMAGE="${IMAGE}" .