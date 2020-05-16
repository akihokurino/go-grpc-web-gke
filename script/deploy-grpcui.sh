#!/usr/bin/env bash

APP_ROOT=$(dirname $0)/..
PROJECT=akiho-playground
IMAGE=gcr.io/${PROJECT}/grpcui:latest

docker build -f grpcui/Dockerfile -t ${IMAGE} --target deploy .
gcloud docker -- push ${IMAGE}