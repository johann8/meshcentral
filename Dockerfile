# Filename: Dockerfile

FROM ubuntu:latest

# Disable Prompt During Packages Installation
ARG DEBIAN_FRONTEND=noninteractive

#install dependencies
#RUN apt-get update && apt-get install -y nodejs npm nano \
RUN apt-get update && apt-get install -y gnupg2 nano iputils-ping \
 && apt-get install -y curl \ 
 && curl -fsSL https://www.mongodb.org/static/pgp/server-4.4.asc | apt-key add - \
 && echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/4.4 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-4.4.list \
 && curl -sL https://deb.nodesource.com/setup_14.x | bash - \ 
 && apt-get update \
 && apt-get install mongodb-org-tools nodejs -y \
 && apt-get --purge autoremove curl -y \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

#Add non-root user, add installation directories and assign proper permissions
RUN mkdir -p /opt/meshcentral

#meshcentral installation
# Update to Version 1.0.0
WORKDIR /opt/meshcentral

RUN npm install meshcentral

#Copy config template and startup script
COPY config.json.template /opt/meshcentral/config.json.template
COPY startup.sh startup.sh
#environment variables

EXPOSE 80 443

#volumes
VOLUME /opt/meshcentral/meshcentral-data
VOLUME /opt/meshcentral/meshcentral-files

CMD ["bash","/opt/meshcentral/startup.sh"]
