#!/usr/bin/env bash
set -e

#############
## RUN ETL ##
#############
REGISTRY_ETL_RUNNER=harbor.honeur.org
REPOSITORY_ETL_RUNNER=library
IMAGE_ETL_RUNNER=etl-runner
VERSION_ETL_RUNNER=1.1.4
TAG_ETL_RUNNER=$VERSION_ETL_RUNNER

LOG_FOLDER_HOST=${PWD}/log
DATA_FOLDER_HOST=${PWD}/data
QA_FOLDER_HOST=${PWD}/qa

echo "Pull ETL runner image"
docker pull $REGISTRY_ETL_RUNNER/$REPOSITORY_ETL_RUNNER/$IMAGE_ETL_RUNNER:$TAG_ETL_RUNNER

REGISTRY=harbor.esfurn.org
REPOSITORY=etl
CDM_SCHEMA=omopcdm
VOCAB_SCHEMA=$CDM_SCHEMA

echo "Download ETL questions"
curl -fsSL https://raw.githubusercontent.com/solventrix/ESFURN-Setup/blob/master/RunETL/questions.json --output questions.json

touch etl-runner.env
# etl image
echo "THERAPEUTIC_AREA=esfurn" >> etl-runner.env
echo "REGISTRY=$REGISTRY" >> etl-runner.env
echo "ETL_IMAGE_NAME=$REPOSITORY/esfurn_etl" >> etl-runner.env
echo "ETL_IMAGE_TAG=current" >> etl-runner.env
# logs
echo "LOG_FOLDER_HOST=$LOG_FOLDER_HOST" >> etl-runner.env
echo "LOG_FOLDER=/log" >> etl-runner.env
echo "VERBOSITY_LEVEL=$VERBOSITY_LEVEL" >> etl-runner.env
# schemas 
echo "DB_SCHEMA=$CDM_SCHEMA" >> etl-runner.env
echo "VOCAB_SCHEMA=$VOCAB_SCHEMA" >> etl-runner.env 
# site 
echo "ESFURN_SITE=$ESFURN_SITE" >> etl-runner.env 
# source data
echo "DATA_FOLDER_HOST=$DATA_FOLDER_HOST" >> etl-runner.env
echo "DATA_FOLDER=/data" >> etl-runner.env
echo "INPUT_DATA=$INPUT_DATA" >> etl-runner.env
echo "DIAGNOSIS_CODE_MAPPING=$DIAGNOSIS_CODE_MAPPING" >> etl-runner.env
echo "DRUG_CODE_MAPPING=$DRUG_CODE_MAPPING" >> etl-runner.env
echo "SITE_COLLECTION_MAPPING=$SITE_COLLECTION_MAPPING" >> etl-runner.env
echo "OTHER_THERAPIES_MAPPING=$OTHER_THERAPIES_MAPPING" >> etl-runner.env
echo "LAST_DATA_EXPORT=$LAST_DATA_EXPORT" >> etl-runner.env
# others 
echo "INSIDE_DOCKER=True" >> etl-runner.env
# QA and DQD
echo "QA_FOLDER_HOST=$QA_FOLDER_HOST" >> etl-runner.env
echo "QA_FOLDER_ETL=/script/etl/gladel/reports" >> etl-runner.env
echo "RUN_DQD=false" >> etl-runner.env


echo "Run ETL"
docker run \
-it \
--rm \
--name etl-runner \
--env-file etl-runner.env \
-v /var/run/docker.sock:/var/run/docker.sock \
-v ${PWD}/questions.json:/script/questions.json \
--network feder8-net \
$REGISTRY_ETL_RUNNER/$REPOSITORY_ETL_RUNNER/$IMAGE_ETL_RUNNER:$TAG_ETL_RUNNER

echo "End of ETL run"
rm -rf etl-runner.env