#!/bin/bash

CURR_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )";
[ -d "$CURR_DIR" ] || { echo "FATAL: no current dir (maybe running in zsh?)";  exit 1; }

# shellcheck source=./common.sh
source "$CURR_DIR/common.sh";

section "Add traefik2 loadbalancer in front of kubernetes"

info_exec "traefik namespace" "kubectl create namespace traefik"
info_exec "switch" "kubens traefik"

info_exec "Create traefik Custom Resource Definitions" "kubectl apply -f assets/traefik-crd.yaml"
info_exec "Apply role-based accesses with RBAC" "kubectl apply -f assets/traefik-rbac.yaml"
info_exec "Deploy traefik as loadbalancer" "kubectl apply -f assets/traefik-lb.yaml"
info_exec "Traefik dashboard" "kubectl apply -f assets/traefik-dashboard.yaml"

