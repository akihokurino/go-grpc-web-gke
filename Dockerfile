FROM golang:1.13-alpine as builder-base
ENV GO111MODULE=on
RUN apk update && \
  apk add --no-cache g++ gcc git make bash protobuf-dev && \
  go get -u github.com/golang/protobuf/protoc-gen-go

FROM builder-base as local-dev
RUN go get github.com/go-delve/delve/cmd/dlv \
  && go build -o /go/bin/dlv github.com/go-delve/delve/cmd/dlv

FROM builder-base as builder
WORKDIR /app
COPY . .
RUN make gen && go build main.go

FROM alpine as deploy
RUN apk update && apk add --no-cache tzdata
COPY --from=builder /app/main /