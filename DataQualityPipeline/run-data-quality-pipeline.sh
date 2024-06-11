#!/usr/bin/env bash
set -ex

REGISTRY=harbor.esfurn.org
REPOSITORY=distributed-analytics
IMAGE=data-quality-pipeline
VERSION=1.8
TAG=$VERSION

echo "Docker login @ $REGISTRY"
docker login $REGISTRY
docker pull $REGISTRY/$REPOSITORY/$IMAGE:$TAG

QA_FOLDER_HOST=${PWD}/qa

touch data-quality-pipeline.env
echo "REGISTRY=$REGISTRY" >> data-quality-pipeline.env
echo "THERAPEUTIC_AREA=esfurn" >> data-quality-pipeline.env
echo "INDICATION=uc" >> data-quality-pipeline.env
echo "QA_FOLDER_HOST=$QA_FOLDER_HOST" >> data-quality-pipeline.env
echo "SCRIPT_UUID=5eeb393c-b12b-41da-801a-382d77d8ab46" >> data-quality-pipeline.env

docker run \
--rm \
--name data-quality-pipeline \
--env-file data-quality-pipeline.env \
-v /var/run/docker.sock:/var/run/docker.sock \
--network feder8-net \
$REGISTRY/$REPOSITORY/$IMAGE:$TAG

rm -rf data-quality-pipeline.env