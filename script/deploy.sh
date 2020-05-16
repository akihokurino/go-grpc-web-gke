#!/usr/bin/env bash

APP_ROOT=$(dirname $0)/..
VER=${VER:-local-$(date +%Y%m%d%H%M)}
PROJECT=akiho-playground
CLUSTER=grpc-k8s-sample
API_IMAGE=gcr.io/${PROJECT}/api:${VER}

gcloud container clusters get-credentials ${CLUSTER} --zone=asia-northeast1-a

kubectl create secret generic gcp-credentials --from-file=credentials.json=${APP_ROOT}/gcp-service.json
kubectl create secret generic api-env --from-file=env=${APP_ROOT}/env

docker build -t ${API_IMAGE} --target deploy .
gcloud docker -- push ${API_IMAGE}

cat k8s.yml | sed 's/\${VER}'"/${VER}/g" | kubectl apply -f -

docker rmi -f `docker images | grep "gcr.io/${PROJECT}" | awk '{print $3}'`
docker rmi -f `docker images | grep "<none>" | awk '{print $3}'`