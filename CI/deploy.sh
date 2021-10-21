#!/bin/bash

cd ../Code/

export GOOGLE_APPLICATION_CREDENTIALS="../../SA/sa-pipeline-clrun.json"

export OPENWEATHER_API_KEY="cc6566b18fb703c7c5f1928bd738a82c"

python3 main.py
