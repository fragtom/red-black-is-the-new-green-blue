#!/bin/bash

CURR_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )";
[ -d "$CURR_DIR" ] || { echo "FATAL: no current dir (maybe running in zsh?)";  exit 1; }

# shellcheck source=./common.sh
source "$CURR_DIR/common.sh";

section "Deploy demo sites"

info_exec "Create a new 'demo-black' namespace" "kubectl create namespace demo-black"
info_exec "Create a new 'demo-red' namespace" "kubectl create namespace demo-red"

# section "Static demo sites with nginx"
# info_exec "with index-black configmap" "kubectl -n demo-black apply -f assets/demo-site-black.cm.yaml"

# info_exec "with index-black configmap" "kubectl -n demo-red apply -f assets/demo-site-red.cm.yaml"

# info_exec "Deployments" "kubectl apply -f assets/demo-sites.yaml"

# printf "${CYA}********************${END}\n"
# printf "have a look on red - http://redblack.fragtom.de/red\n"
# printf "and black - http://redblack.fragtom.de/black\n"
# printf "${CYA}********************${END}\n"

section "Build and deploy demo apps w/ helm"

info_exec "Build the black-app" "docker build demo-black/ -f demo-black/Dockerfile -t demo-black:local"
info_exec "docker tag demo-black" "docker tag demo-black:local k3d-blackred-registry:5111/demo-black:local"
info_exec "Docker push black-app" "docker push k3d-blackred-registry:5111/demo-black:local"

info_pause_exec "Deploy the black app with helm" "helm upgrade --install demo-black demo-black --namespace demo-black --set app.image=k3d-blackred-registry:5111/demo-black:local"

# info_exec "Build the demo-red" "docker build demo-red/ -f demo-red/Dockerfile -t demo-red:local"
# info_exec "docker tag demo-red" "docker tag demo-red:local k3d-blackred-registry:5111/demo-red:local"
# info_exec "Docker push demo-red" "docker push k3d-blackred-registry:5111/demo-red:local"

# info_pause_exec "Deploy the black app with helm" "helm upgrade --install demo-red demo-red --namespace demo-red --set app.image=k3d-blackred-registry:5111/demo-red:local"

