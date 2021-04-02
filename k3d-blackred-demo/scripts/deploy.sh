#!/bin/bash

CURR_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )";
[ -d "$CURR_DIR" ] || { echo "FATAL: no current dir (maybe running in zsh?)";  exit 1; }

# shellcheck source=./common.sh
source "$CURR_DIR/common.sh";

section "Build and deploy demo apps w/ helm"

info_exec "Build the sample-black-app" "docker build sample-black/ -f sample-black/Dockerfile -t sample-black-app:local"
info_exec "docker tag sample-black-app" "docker tag sample-black-app:local k3d-blackred-registry:5111/sample-black-app:local"
info_exec "Docker push sample-black-app" "docker push k3d-blackred-registry:5111/sample-black-app:local"

info_exec "Build the sample-red-app" "docker build sample-red/ -f sample-red/Dockerfile -t sample-red-app:local"
info_exec "docker tag sample-red-app" "docker tag sample-red-app:local k3d-blackred-registry:5111/sample-red-app:local"
info_exec "Docker push sample-red-app" "docker push k3d-blackred-registry:5111/sample-red-app:local"

info_exec "Create a new 'demo-black' namespace" "kubectl create namespace demo-black"
info_exec "Create a new 'demo-red' namespace" "kubectl create namespace demo-red"

# info_pause_exec "Switch to the new 'blackred-demo' namespace" "kubens blackred-demo"
info_pause_exec "Deploy the black sample app with helm" "helm upgrade --install sample-black sample-black/conf/charts/sample-app/ --namespace demo-black --set app.image=k3d-blackred-registry:5111/sample-black-app:local"
info_pause_exec "Deploy the red sample app with helm" "helm upgrade --install sample-red sample-red/conf/charts/sample-app/ --namespace demo-red --set app.image=k3d-blackred-registry:5111/sample-red-app:local"

