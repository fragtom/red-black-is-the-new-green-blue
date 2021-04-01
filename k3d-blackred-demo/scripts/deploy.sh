#!/bin/bash

CURR_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )";
[ -d "$CURR_DIR" ] || { echo "FATAL: no current dir (maybe running in zsh?)";  exit 1; }

# shellcheck source=./common.sh
source "$CURR_DIR/common.sh";

section "Build and deploy demo apps w/ helm"

info_exec "Build the sample-black-app" "docker build sample-black/ -f sample-black/Dockerfile -t sample-black-app:local"
info_exec "Build the sample-app-red" "docker build sample-red/ -f sample-red/Dockerfile -t sample-red-app:local"

# info_pause_exec "Load the sample-red-app image into the cluster" "k3d image import -c blackred-demo-black sample-black-app:local"
# info_pause_exec "Load the sample-app-red image into the cluster" "k3d image import -c blackred-demo-red sample-red-app:local"

info_pause_exec "Create a new 'blackred-demo-black' namespace" "kubectl create namespace blackred-demo-black"
info_pause_exec "Create a new 'blackred-demo-red' namespace" "kubectl create namespace blackred-demo-red"

# info_pause_exec "Switch to the new 'blackred-demo' namespace" "kubens blackred-demo"
info_pause_exec "Deploy the black sample app with helm" "helm upgrade --install sample-black-app sample-black-app/conf/charts/sample-app --namespace blackred-demo-black --set app.image=sample-black-app:local"
info_pause_exec "Deploy the red sample app with helm" "helm upgrade --install sample-red-app sample-red-app/conf/charts/sample-red-app --namespace blackred-demo-red --set app.image=sample-red-app:local"
