#!/usr/bin/env bash

APP_ROOT=$(dirname $0)/..
GO_DIST=${APP_ROOT}/proto/go
TS_DIST=${APP_ROOT}/web/src/rpc

rm -f ${GO_DIST}/*
mkdir -p ${GO_DIST}

rm -f ${TS_DIST}/*
mkdir -p ${TS_DIST}

PROTOC_GEN_TS_PATH="./node_modules/.bin/protoc-gen-ts"

protoc --proto_path=${APP_ROOT}/proto/. \
       --go_out=plugins=grpc:${GO_DIST} \
       ${APP_ROOT}/proto/*.proto

protoc --proto_path=${APP_ROOT}/proto/. \
       --plugin="protoc-gen-ts=${PROTOC_GEN_TS_PATH}" \
       --js_out=import_style=commonjs,binary:${TS_DIST} \
       --ts_out=service=grpc-web:${TS_DIST} \
       ${APP_ROOT}/proto/*.proto

find ${TS_DIST} -type f -name "*_pb.js" | xargs gsed -i -e "1i /* eslint-disable */"
find ${TS_DIST} -type f -name "*_pb_service.js" | xargs gsed -i -e "1i /* eslint-disable */"