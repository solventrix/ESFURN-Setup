#!/usr/bin/env bash
set -eux

REGISTRY=harbor.esfurn.org
REPOSITORY=study_55
IMAGE=fgfr-muc-survival-analysis
TAG=V1

docker pull $REGISTRY/$REPOSITORY/$IMAGE:$TAG

docker run --rm --name fgfr-muc-survival-analysis \
--env THERAPEUTIC_AREA=ESFURN \
--env SCRIPT_UUID=4035519b-be99-4d21-8f2b-3abd2972f8bd \
-v "$PWD/results":/script/outputs \
--network feder8-net \
$REGISTRY/$REPOSITORY/$IMAGE:$TAG
