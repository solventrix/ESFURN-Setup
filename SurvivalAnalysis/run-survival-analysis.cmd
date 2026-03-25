@ECHO off

SET REGISTRY=harbor.esfurn.org
SET REPOSITORY=study_55
SET IMAGE=fgfr-muc-survival-analysis
SET TAG=V1

echo "Docker login @ %REGISTRY%"
docker pull %REGISTRY%/%REPOSITORY%/%IMAGE%:%TAG%
echo "Run survival analysis"
docker run --rm --name fgfr-muc-survival-analysis --env THERAPEUTIC_AREA=ESFURN --env SCRIPT_UUID=4035519b-be99-4d21-8f2b-3abd2972f8bd -v "%CD%/results":/script/outputs --network feder8-net %REGISTRY%/%REPOSITORY%/%IMAGE%:%TAG%
