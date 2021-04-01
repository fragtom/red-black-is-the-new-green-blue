# k3d-blackred-demo

## Requirements

- [`docker`](https://docs.docker.com/get-docker/)
- [`k3d >= v4.1.0`](https://k3d.io/#installation)
- [`helm v3`](https://helm.sh/docs/intro/install/)


## Spinnaker deployment 

see [`setup spinnaker`](https://github.com/justmeandopensource/kubernetes/blob/master/docs/setup-spinnaker.md)

### spinnaker docker 
```
mkdir /root/.hal 
chmod +r /root/.hal

docker run -p 8084:8084 -p 9000:9000     --name halyard --rm     -v ~/.hal:/home/spinnaker/.hal     -it     us-docker.pkg.dev/spinnaker-community/docker/halyard:stable

docker run -p 8084:8084 -p 9000:9000     --name halyard --rm    -v ~/.kube/config:/home/spinnaker/.kube/config  -v ~/.hal:/home/spinnaker/.hal     -it     us-docker.pkg.dev/spinnaker-community/docker/halyard:stable
```


```
CONTEXT=$(kubectl config current-context)

kubectl apply --context $CONTEXT     -f https://www.spinnaker.io/downloads/kubernetes/service-account.yml
TOKEN=$(kubectl get secret --context $CONTEXT \
   $(kubectl get serviceaccount spinnaker-service-account \
       --context $CONTEXT \
       -n spinnaker \
       -o jsonpath='{.secrets[0].name}') \
   -n spinnaker \
   -o jsonpath='{.data.token}' | base64 --decode)
kubectl config set-credentials ${CONTEXT}-token-user --token $TOKEN
kubectl config set-context $CONTEXT --user ${CONTEXT}-token-user
```
