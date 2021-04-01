#!/bin/bash

CURR_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )";
[ -d "$CURR_DIR" ] || { echo "FATAL: no current dir (maybe running in zsh?)";  exit 1; }

# shellcheck source=./common.sh
source "$CURR_DIR/common.sh";

section "Create blackred-demo cluster"
# info "Cluster Name: blackred-demo"
# info "--api-port 6550: expose the Kubernetes API on localhost:6550 (via loadbalancer)"
# info "--servers 1: create 1 server node"
# info "--agents 3: create 3 agent nodes"
# info "--port 8080:80@loadbalancer: map localhost:8080 to port 80 on the loadbalancer (used for ingress)"
# info "--volume /tmp/src:/src@all: mount the local directory /tmp/src to /src in all nodes (used for code)"
# info "--wait: wait for all server nodes to be up before returning"
info_exec "Create k3d cluster" "k3d cluster create blackred-demo --api-port 0.0.0.0:6550 --kubeconfig-update-default --kubeconfig-switch-context --port 8080:80@loadbalancer --servers 1 --agents 3 --wait"

info_exec "List clusters" "k3d cluster list"
info_exec "List clusters" "k3d node list"

# info_pause_exec "Update the default kubeconfig with the new cluster details (Optional, included in 'k3d cluster create' by default)" "k3d kubeconfig merge blackred-demo --kubeconfig-merge-default --kubeconfig-switch-context"

# info "Cluster Name: blackred-demo"
# info "--merge-default-kubeconfig true: overwrite existing fields with the same name in kubeconfig (true by default)"
# info "--kubeconfig-switch-context true: set the kubeconfig's current-context to the new cluster context (false by default)"

info_pause_exec "Use kubectl to checkout the nodes" "kubectl get nodes"

# section "Grow the Cluster"
# info_pause_exec "Add 2 agents to the cluster" "k3d node create new-agent --cluster blackred-demo --role agent --replicas 2"
# info_pause_exec '(Wait a bit for the nodes to get ready!) Use kubectl to see the new nodes' "kubectl get nodes"
