# Meshcentral-Docker
![Docker Pulls](https://img.shields.io/docker/pulls/johann8/meshcentral?style=flat-square)
![Docker Image Size (latest by date)](https://img.shields.io/docker/image-size/johann8/meshcentral)

## About
Docker Version of the amazing [MeshCentral software](https://github.com/Ylianst/MeshCentral).

While easier to setup and get up and running, you should still peer through the very informative official guides:

[- MeshCentral2InstallGuide](https://info.meshcentral.com/downloads/MeshCentral2/MeshCentral2InstallGuide.pdf)

[- MeshCentral2UserGuide](https://info.meshcentral.com/downloads/MeshCentral2/MeshCentral2UserGuide.pdf)

## Disclaimer

This image  make use of a specialized database solution (MongoDB).

## Installation

The preferred method to get this image up and running is through the use of *docker-compose* (examples below).

By filling out some of the options in the environment variables in the docker compose you can define some initial meshcentral settings and have it up and ready in no time. If you'd like to include settings not supported by the docker-compose file, you can also edit the config.json to your liking (you should really check the User's Guide for this) and place it in the meshcentral-data folder **before** initializing the container.

Updating settings is also easy after having the container initialized if you change your mind or want to tweak things. Just edit meshcentral-data/config.json and restart the container.

docker-compose.yml example:
```yaml
version: '3'
networks:
  meshcentralNet:
    ipam:
      driver: default
      config:
        - subnet: 172.26.8.0/24

services:
  meshcentral:
    restart: always
    container_name: meshcentral
    image: johann8/meshcentral
    ports:
      - 127.0.0.1:8084:443  #MeshCentral will moan and try everything not to use port 80, but you can also use it if you so desire, just change the config.json according to your needs
    environment:
      - HOSTNAME=my.domain.com    #your hostname
      - REVERSE_PROXY=false    #set to your reverse proxy IP if you want to put meshcentral behind a reverse proxy
      - REVERSE_PROXY_TLS_PORT=443
      - IFRAME=false    #set to true if you wish to enable iframe support
      - ALLOW_NEW_ACCOUNTS=false    #set to false if you want disable self-service creation of new accounts besides the first (admin)
      - WEBRTC=true  #set to true to enable WebRTC - per documentation it is not officially released with meshcentral, but is solid enough to work with. Use with caution
      - TZ=${TZ}
    networks:
      - meshcentralNet
    volumes:
      - "./meshc-data:/opt/meshcentral/meshcentral-data"    #config.json and other important files live here. A must for data persistence
      - "./meshc-user_files:/opt/meshcentral/meshcentral-files"    #where file uploads for users live
      - "./meshc-backup:/opt/meshcentral/meshcentral-backup"
    env_file:
      - ".env"
    depends_on:
      - mongodb

  # mongodb container for meshcentral
  mongodb:
    image: mongo:latest
    container_name: mongodb
    restart: "unless-stopped"
    volumes:
      - "./mongodb-data:/data/db"
      - "./mongodb-config:/data/configdb"
    networks:
      - meshcentralNet
```

If you do not wish to use the prebuilt image, you can also easily build it yourself. Just make sure to include **config.json.template** and **startup.sh** if you do not change the Dockerfile.

[- Dockerhub - johann8/meshcentral](https://hub.docker.com/repository/docker/johann8/meshcentral)
