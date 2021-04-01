#!/bin/bash

CURR_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )";
[ -d "$CURR_DIR" ] || { echo "FATAL: no current dir (maybe running in zsh?)";  exit 1; }

# shellcheck source=./common.sh
source "$CURR_DIR/common.sh";

section "say good bye to demo cluster"

info_exec "Stop the cluster" "k3d cluster stop -a"
info_exec "Delete the Cluster" "k3d cluster delete -a"

info_exec "delete all others " "/usr/local/bin/k3s-killall.sh" 