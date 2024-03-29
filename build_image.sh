#!/bin/bash

# set variables
_VERSION=1.1.5

# create build
docker build -t johann8/meshcentral:${_VERSION} .
_BUILD=$?
if ! [ ${_BUILD} = 0 ]; then
   echo "ERROR: Docker Image build was not successful"
   exit 1
else
   echo "Docker Image build successful"
   docker images -a 
   docker tag johann8/meshcentral:${_VERSION} johann8/meshcentral:latest
fi

#push image to dockerhub
if [ ${_BUILD} = 0 ]; then
   echo "Pushing docker images to dockerhub..."
   docker push johann8/meshcentral:latest
   docker push johann8/meshcentral:${_VERSION}
   _PUSH=$?
   docker images -a |grep meshcentral
fi


#delete build
if [ ${_PUSH=} = 0 ]; then
   echo "Deleting docker images..."
   docker rmi johann8/meshcentral:latest
   #docker images -a
   docker rmi johann8/meshcentral:${_VERSION}
   #docker images -a
   docker rmi ubuntu
   docker images -a
fi

# Delete none images
# docker rmi $(docker images --filter "dangling=true" -q --no-trunc)
