FROM mhart/alpine-node:12 as builder-base
RUN apk update && apk add --no-cache git build-base autoconf automake libtool bash && \
  npm install typescript -g

FROM builder-base as local-dev

FROM builder-base as builder
WORKDIR /app
COPY . .
RUN npm run build

FROM alpine as deploy
RUN apk update && apk add --no-cache nginx
WORKDIR /app
COPY --from=builder /app/build/. .
ADD server.conf /etc/nginx/conf.d/default.conf
RUN mkdir -p /run/nginx