@ECHO off

SET REGISTRY=harbor.esfurn.org
SET REPOSITORY=distributed-analytics
SET IMAGE=data-quality-pipeline
SET VERSION=1.10
SET TAG=%VERSION%
SET QA_FOLDER_HOST=%CD%/qa

echo "Docker login @ harbor.esfurn.org"
docker login %REGISTRY%

docker pull %REGISTRY%/%REPOSITORY%/%IMAGE%:%TAG%

docker run --rm --name data-quality-pipeline --env REGISTRY=%REGISTRY% --env THERAPEUTIC_AREA=esfurn --env INDICATION=uc --env QA_FOLDER_HOST=%QA_FOLDER_HOST% --env SCRIPT_UUID=660d2280-3217-4bb3-8aab-c26da116e499 -v /var/run/docker.sock:/var/run/docker.sock --network feder8-net %REGISTRY%/%REPOSITORY%/%IMAGE%:%TAG%