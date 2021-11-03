
# How to create a docker image for meshcentral

```
git clone https://github.com/johann8/meshcentral.git 
cd meshcentral
docker build -t meshcentral .
```

docker-compose.yml example:
```yaml
version: '2'
services:
    meshcentral:
        restart: always
        container_name: meshcentral
        image: meshcentral
        ports:
            - 443:443  #MeshCentral will moan and try everything not to use port 80, but you can also use it if you so desire, just change the config.json according to your needs
        environment:
            - HOSTNAME=my.domain.com     #your hostname
            - REVERSE_PROXY=false     #set to your reverse proxy IP if you want to put meshcentral behind a reverse proxy
            - REVERSE_PROXY_TLS_PORT=
            - IFRAME=false    #set to true if you wish to enable iframe support
            - ALLOW_NEW_ACCOUNTS=true    #set to false if you want disable self-service creation of new accounts besides the first (admin)
            - WEBRTC=false  #set to true to enable WebRTC - per documentation it is not officially released with meshcentral, but is solid enough to work with. Use with caution
        volumes:
            - ./meshcentral/data:/opt/meshcentral/meshcentral-data    #config.json and other important files live here. A must for data persistence
            - ./meshcentral/user_files:/opt/meshcentral/meshcentral-files    #where file uploads for users live
```
