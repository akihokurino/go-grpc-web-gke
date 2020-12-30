#!/usr/bin/env bash

APP_ROOT=$(dirname $0)/..

cd ${APP_ROOT}

ENV=$1
PROJECT=akiho-playground
REGION=asia-northeast1
VPC_NAME=gke-grpc-sample
SUBNET_NAME=gke-grpc-sample-subnet

gcloud config set project ${PROJECT}

echo -e "\n\033[1;32m----- VPC作成 -----\033[0;39m"
gcloud compute networks create ${VPC_NAME} \
  --project=${PROJECT} \
  --bgp-routing-mode=regional \
  --subnet-mode=custom

echo -e "\n\033[1;32m----- Subnet作成 -----\033[0;39m"
gcloud compute networks subnets create ${SUBNET_NAME} \
  --project=${PROJECT} \
  --region=${REGION} \
  --network=${VPC_NAME} \
  --range=192.168.1.0/24

echo -e "\n\033[1;32m----- IP作成 -----\033[0;39m"
# Nat用IP
gcloud compute addresses create gke-grpc-sample --region=${REGION}

# Ingressで扱う場合はグローバル
gcloud compute addresses create gke-grpc-sample-api-ip --global
gcloud compute addresses create gke-grpc-sample-api-debug-ip --global
gcloud compute addresses create gke-grpc-sample-web-ip --global

echo -e "\n\033[1;32m----- Router作成 -----\033[0;39m"
gcloud compute routers create gke-grpc-sample \
  --region=${REGION} \
  --network=${VPC_NAME} \
  --asn=65001

echo -e "\n\033[1;32m----- Nat作成 -----\033[0;39m"
gcloud compute routers nats create gke-grpc-sample \
  --region=${REGION} \
  --router=gke-grpc-sample \
  --nat-external-ip-pool="gke-grpc-sample" \
  --nat-custom-subnet-ip-ranges="${SUBNET_NAME}"

echo -e "\n\033[1;32m----- GKE Cluster作成 -----\033[0;39m"
gcloud container clusters create gke-grpc-sample \
  --project=${PROJECT} \
  --zone=asia-northeast1-a \
  --network=${VPC_NAME} \
  --subnetwork=${SUBNET_NAME} \
  --enable-ip-alias \
  --enable-private-nodes \
  --master-ipv4-cidr=172.16.0.0/28 \
  --enable-master-authorized-networks \
  --master-authorized-networks=0.0.0.0/0 \
  --no-enable-legacy-authorization \
  --no-enable-basic-auth \
  --no-issue-client-certificate

# gcloud container clusters resize gke-grpc-sample --zone=asia-northeast1-a --size=1