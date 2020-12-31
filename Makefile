MAKEFLAGS=--no-builtin-rules --no-builtin-variables --always-make
ROOT := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))
export PATH := $(ROOT)/script:$(PATH)

gen:
	gen-proto.sh

gen-client:
	gen-proto-client.sh

build:
	go run main.go

run-local:
	docker-compose up

run-debug:
	grpcui -plaintext -port 4040 localhost:4000

run-batch:
	docker-compose run --rm batch go run /app/main.go batch

setup-k8s:
	setup-k8s.sh

deploy:
	deploy.sh

deploy-grpcui:
	deploy-grpcui.sh