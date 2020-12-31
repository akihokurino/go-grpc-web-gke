#!/usr/bin/env bash

APP_ROOT=$(dirname $0)/..
GO_DIST=${APP_ROOT}/proto/go

rm -f ${GO_DIST}/*
mkdir -p ${GO_DIST}

protoc --proto_path=${APP_ROOT}/proto/. \
       --go_out=plugins=grpc:${GO_DIST} \
       ${APP_ROOT}/proto/*.proto