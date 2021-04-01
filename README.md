# DEMO black/red deployment Tom Stark #

Demo on running spinnaker black/green (black/red) deployment on kubernetes stack


 In blue-green deployment, both versions may be getting requests at the same time temporarily, while in red-black only one of the versions is getting traffic at any point in time.

The answer then goes on to say that:

 But red-black deployment is a newer term being used by Netflix, Istio, and other frameworks/platforms that support container orchestration.

 
 Spinnaker supports the red/black (a.k.a. blue/green) strategy, with rolling red/black and canary strategies in active development.


Preparing lightweightet kubernetes in ```/k3d-blackred-demo```  

- Demo k3d setup: `make prep cluster`
- Deploy demo app: `make deploy`
