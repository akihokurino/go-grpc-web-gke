FROM golang:1.13-alpine as builder-base
RUN apk update && apk add --no-cache g++ gcc git
ENV GO111MODULE=on
RUN go get -u github.com/fullstorydev/grpcui
RUN go install github.com/fullstorydev/grpcui/cmd/grpcui

FROM alpine:3.10.2 as local-dev
COPY --from=builder-base /go/bin/grpcui /usr/bin/grpcui
RUN apk update && apk add --no-cache bash curl nginx
ADD server.conf /etc/nginx/conf.d/default.conf
RUN mkdir -p /run/nginx

FROM alpine:3.10.2 as deploy
COPY --from=builder-base /go/bin/grpcui /usr/bin/grpcui
RUN apk update && apk add --no-cache bash curl nginx
ADD server.conf /etc/nginx/conf.d/default.conf
RUN mkdir -p /run/nginx
WORKDIR /app
COPY ./script/. .
EXPOSE 8080
CMD ["./start.sh"]