gen:
	./script/gen-proto.sh

build:
	go run main.go

run-local:
	docker-compose up

run-debug:
	grpcui -plaintext -port 4040 localhost:4000

deploy:
	./script/deploy.sh

deploy-grpcui:
	./script/deploy-grpcui.sh