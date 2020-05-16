#!/bin/bash
nginx
until (curl -i http://${GRPC_WEB_SERVER}/health_check | grep "200 OK") do sleep 5; done
grpcui -plaintext -port 4040 ${GRPC_SERVER}