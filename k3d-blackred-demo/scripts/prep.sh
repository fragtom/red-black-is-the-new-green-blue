#!/bin/bash

CURR_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
[ -d "$CURR_DIR" ] || { echo "FATAL: no current dir (maybe running in zsh?)";  exit 1; }

# shellcheck source=./common.sh
source "$CURR_DIR/common.sh"

# Check Helm
if ! type helm > /dev/null; then
    echo "Helm could not be found. Installing it ..."
    curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
    chmod +x ./get_helm.sh
    ./get_helm.sh
    
    # Add default repos
    helm repo add stable https://charts.helm.sh/stable
    # Add kubernetes-dashboard repository
    helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/
    # Add bitnami helm repos
    helm repo add bitnami https://charts.bitnami.com/bitnami
    # Add Prometheus helm repos
    helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
    # Update helm
    helm repo update
    exit
fi

section "Cleaning up docker environment..."
docker rm -f $(docker ps -qa)
docker network prune -f
docker volume prune -f
docker system prune -a -f

section "Pulling images..."
# docker pull rancher/k3s:v1.20.0-k3s2
docker pull rancher/k3d-proxy:v4.4.0
docker pull rancher/k3d-tools:v4.4.0
docker pull python:3.7-slim

section "Preparing Filesystem..."
mkdir /tmp/src