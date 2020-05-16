#!/usr/bin/env bash

APP_ROOT=$(dirname $0)/..
GO_DIST=${APP_ROOT}/proto/go

protoc --proto_path=${APP_ROOT}/proto/. \
       --go_out=plugins=grpc:${GO_DIST} \
       ${APP_ROOT}/proto/*.proto