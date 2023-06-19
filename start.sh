#!/usr/bin/env bash

set -euo pipefail

# start k3d cluster with nginx (and with disabled traefik)
echo "Starting K3d cluster"
k3d cluster create -p "80:80@loadbalancer" -p "443:443@loadbalancer" --k3s-arg="--disable=traefik@server:0" > /dev/null 2>&1 && echo "K3d cluster started"

echo "Creating Kubernetes namespace: monitoring"
kubectl create namespace monitoring > /dev/null 2>&1

# install kube prometheus stack helm chart
echo "Installing Kube Prometheus Stack"
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts && helm repo update && helm install -n monitoring -f terraform/modules/monitoring/config/monitoring.yaml kube-prometheus-stack  prometheus-community/kube-prometheus-stack > /dev/null 2>&1 && echo "Kube Prometheus Stack installed"

echo "Running Terraform"
cd environments/dev && terragrunt init > /dev/null 2>&1 && terragrunt apply -auto-approve > /dev/null 2>&1 && echo "Terraform apply was successful"