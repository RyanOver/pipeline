#!/bin/bash

cd ../Code/

export GOOGLE_APPLICATION_CREDENTIALS="../../SA/sa-pipeline-clrun.json"

export OPENWEATHER_API_KEY="cc6566b18fb703c7c5f1928bd738a82c"

pip3 install -r requirements.txt
# python3 main.py

cd ../Terraform

export TF_VAR_api_key=$OPENWEATHER_API_KEY 

echo TF_VAR_api_key

terraform init

terraform plan

terraform apply