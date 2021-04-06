#!/bin/bash

CURR_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )";
[ -d "$CURR_DIR" ] || { echo "FATAL: no current dir (maybe running in zsh?)";  exit 1; }

# shellcheck source=./common.sh
source "$CURR_DIR/common.sh";

section "Add traefik2 loadbalancer in front of kubernetes"

info_exec "traefik namespace" "kubectl create namespace traefik"
info_exec "traefik namespace" "kubectl create namespace demo"
info_exec "traefik namespace" "kubectl create namespace demo2"
info_exec "switch" "kubens traefik"

info_exec "Custom Resource Definitions" "kubectl apply -f assets/traefik-crd.yaml"
info_exec "RBAC" "kubectl apply -f assets/traefik-rbac.yaml"
info_exec "Services" "kubectl apply -f assets/traefik-svc.yaml"
info_exec "Ingressroute" "kubectl apply -f assets/traefik-ingressroute.yaml"
info_exec "Middlewares" "kubectl apply -f assets/traefik-middleware.yaml"
info_exec "Deployments" "kubectl apply -f assets/traefik-deployment.yaml"

