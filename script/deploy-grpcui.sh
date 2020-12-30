#!/usr/bin/env bash

APP_ROOT=$(dirname $0)/..
PROJECT=akiho-playground
IMAGE=gcr.io/${PROJECT}/grpcui:latest

cd ${APP_ROOT}/grpcui

docker build -t ${IMAGE} --target deploy .
docker login -u oauth2accesstoken -p "$(gcloud auth print-access-token)" https://gcr.io
docker push ${IMAGE}

docker rmi -f `docker images | grep "gcr.io/${PROJECT}" | awk '{print $3}'`
docker rmi -f `docker images | grep "<none>" | awk '{print $3}'`