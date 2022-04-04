#!/bin/bash

# Time to pretend we do know a bit about newer devops method
# Using minkube this is a 3 replica deployment with multiple containers in pod
# the pattern for containers is main and Adapter
# I used haproxy as the Adapter because proxyfying NGINX with NGINX is doable
# without resorting to an adapter and looks like bad design.

# Here I assume that minikube can't pull images from the Net
# So I am packaging a ready made image. But you have the docker file in the "2" folder if you want

# Switch to the script directory 
SCRIPT_PATH=$(dirname "$0")
cd $SCRIPT_PATH

# make sure docker uses the doker local repo
eval $(minikube -p minikube docker-env)

# alias minikube kubectl if needed
if ! [ -x "$(command -v kubectl)" ]; then
    shopt -s expand_aliases
    alias kubectl="minikube kubectl --"   #we assume minikube at least is on the path to cut the boring stuff
fi;

# Let us add a cleaning option
if ! [ -z "$1" ]; then
if [ $1 == "clean" ]; then 
    SCRIPT_PATH=$(dirname "$0")
    cd $SCRIPT_PATH
    kubectl delete service simple-service
    kubectl delete deploy simple-deploy
    sleep 15s    
    docker image rm jhassignement/nginx_simple
    rm 2/nginx_simple.tar
    echo "\"Installation\" cleaned"
    exit 0 
fi;fi;

# unzip the nginx image
bzip2 -dk 2/nginx_simple.tar.bz2

# load the custom nginx into the local repo
docker load < 2/nginx_simple.tar

# start the deployment
kubectl create -f 2/simple_deployment.yml

# start the service
kubectl create -f 2/simple_service.yml

# finaly give the access
URL=$(minikube service simple-service --url)

echo "The page can be accessed by $URL"


