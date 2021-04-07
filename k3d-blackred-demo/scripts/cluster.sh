#!/bin/bash

CURR_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )";
[ -d "$CURR_DIR" ] || { echo "FATAL: no current dir (maybe running in zsh?)";  exit 1; }

# shellcheck source=./common.sh
source "$CURR_DIR/common.sh";

section "Create registry"
info_exec "Create blackred registry" "k3d registry create blackred-registry --port 0.0.0.0:5111"

configfile=./assets/k3d-config.yaml
printf "${CYA}********************${END}\n$(cat $configfile | grep -v '^\s*#')\n${CYA}********************${END}\n"

section "Create blackred-demo cluster"

info_exec "Create k3d cluster: blackred-demo" "k3d cluster create --registry-use k3d-blackred-registry:5111 --config $configfile"
# info_exec "Create k3d cluster" "k3d cluster create blackred-demo --api-port 0.0.0.0:6550 --kubeconfig-update-default --kubeconfig-switch-context --no-lb --k3s-server-arg --disable=servicelb --k3s-server-arg --disable=traefik --registry-use k3d-blackred-registry:5111 -l --servers 1 --agents 3 --wait"
# info_exec "Create k3d cluster" "k3d cluster create blackred-demo --api-port 0.0.0.0:6550 --kubeconfig-update-default --kubeconfig-switch-context --port 80:80@loadbalancer --registry-use k3d-blackred-registry:5111 --servers 1 --agents 3 --wait"

info_exec "List clusters" "k3d cluster list"

section "Create blackred-demo cluster"

info_exec "List clusters" "k3d node list"
info_exec "Label nodes worker with k8s label" "kubectl label node node-role.kubernetes.io/worker=true -l node-role.kubernetes.io/master!=true"

info_exec "Use kubectl to checkout the nodes" "kubectl get nodes"

# section "Grow the Cluster"
# info_pause_exec "Add 2 agents to the cluster" "k3d node create new-agent --cluster blackred-demo --role agent --replicas 2"
# info_pause_exec '(Wait a bit for the nodes to get ready!) Use kubectl to see the new nodes' "kubectl get nodes"
