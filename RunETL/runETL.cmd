@echo off

::#############
::## RUN ETL ##
::#############
SET REGISTRY_ETL_RUNNER=harbor.honeur.org
SET REPOSITORY_ETL_RUNNER=library
SET IMAGE_ETL_RUNNER=etl-runner
SET VERSION_ETL_RUNNER=1.1.4
SET TAG_ETL_RUNNER=%VERSION_ETL_RUNNER%

set LOG_FOLDER_HOST=%CD%/log
set QA_FOLDER_HOST=%CD%/qa
SET QA_FOLDER_ETL=/script/etl/esfurn/reports

echo "Pull ETL runner image"

docker pull %REGISTRY_ETL_RUNNER%/%REPOSITORY_ETL_RUNNER%/%IMAGE_ETL_RUNNER%:%TAG_ETL_RUNNER%

SET REGISTRY=harbor.esfurn.org
SET REPOSITORY=etl
SET CDM_SCHEMA=omopcdm
SET VOCAB_SCHEMA=%CDM_SCHEMA%
SET THERAPEUTIC_AREA=esfurn
SET ETL_IMAGE_NAME=%REPOSITORY%/esfurn_etl
SET LOG_FOLDER=/log
SET DATA_FOLDER=/data

echo "Download ETL questions"
curl -fsSL https://raw.githubusercontent.com/solventrix/ESFURN-Setup/blob/master/RunETL/questions.json --output questions.json

echo "Run ETL"
docker run -it --rm --name etl-runner --env THERAPEUTIC_AREA=%THERAPEUTIC_AREA% --env REGISTRY=%REGISTRY% --env ETL_IMAGE_NAME=%ETL_IMAGE_NAME% --env LOG_FOLDER_HOST=%LOG_FOLDER_HOST% --env LOG_FOLDER=%LOG_FOLDER% --env DATA_FOLDER=%DATA_FOLDER% --env INSIDE_DOCKER=True --env QA_FOLDER_HOST=%QA_FOLDER_HOST% --env QA_FOLDER_ETL=%QA_FOLDER_ETL% --env RUN_DQD=false -v /var/run/docker.sock:/var/run/docker.sock -v %CD%/questions.json:/script/questions.json --network feder8-net %REGISTRY_ETL_RUNNER%/%REPOSITORY_ETL_RUNNER%/%IMAGE_ETL_RUNNER%:%TAG_ETL_RUNNER%

echo "End of ETL run"