#!/usr/bin/env bash

APP_ROOT=$(dirname $0)/..

export VER=${VER:-local-$(date +%Y%m%d%H%M)}
PROJECT=akiho-playground
SERVER_IMAGE=gcr.io/${PROJECT}/gke-grpc-sample-server:${VER}
WEB_IMAGE=gcr.io/${PROJECT}/gke-grpc-sample-web:${VER}

gcloud container clusters get-credentials gke-grpc-sample --zone=asia-northeast1-a

kubectl delete secret env
kubectl create secret generic gcp-credentials --from-file=credentials.json=${APP_ROOT}/gcp-service.json
kubectl create secret generic api-env --from-file=env=${APP_ROOT}/env

docker login -u oauth2accesstoken -p "$(gcloud auth print-access-token)" https://gcr.io

docker build -t ${SERVER_IMAGE} --target deploy .
docker push ${SERVER_IMAGE}

cd ${APP_ROOT}/web
docker build -t ${WEB_IMAGE} --target deploy .
docker push ${WEB_IMAGE}
cd ../

envsubst < k8s.yml | cat | kubectl apply -f -

docker rmi -f `docker images | grep "gcr.io/${PROJECT}" | awk '{print $3}'`
docker rmi -f `docker images | grep "<none>" | awk '{print $3}'`