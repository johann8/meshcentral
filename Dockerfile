# Filename: Dockerfile

FROM ubuntu:latest

# Disable Prompt During Packages Installation
ARG DEBIAN_FRONTEND=noninteractive

#install dependencies
#RUN apt-get update && apt-get install -y nodejs npm nano \
RUN apt-get update && apt-get install -y gnupg2 nano iputils-ping tar xz-utils \
 && apt-get install -y curl wget \ 
 #&& curl -fsSL https://www.mongodb.org/static/pgp/server-4.4.asc | apt-key add - \
 && curl -sL https://www.mongodb.org/static/pgp/server-4.4.asc | gpg --dearmor | tee /etc/apt/trusted.gpg.d/server-4.4.gpg  >/dev/null \
 && echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/4.4 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-4.4.list \
 && cd /tmp \
 && curl -LO https://nodejs.org/dist/v18.4.0/node-v18.4.0-linux-x64.tar.xz \
 && tar -xvf node-v18.4.0-linux-x64.tar.xz \
 && cp -r node-v18.4.0-linux-x64/bin /usr/ \
 && cp -r node-v18.4.0-linux-x64/include /usr/ \
 && cp -r node-v18.4.0-linux-x64/lib /usr/ \
 && cp -r node-v18.4.0-linux-x64/share /usr/ \
 && node --version => v18.4.0 \
 && rm -rf /tmp/node-v18.4.0-linux* \
 #&& wget https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh \
 #&& bash install.sh \
 #&& . /root/.bashrc \
 #&& nvm install v18.4.0 \
 #&& node -v \
 #&& rm -rf install.sh \
 && apt-get update \
 && apt-get dist-upgrade -y \
 && apt-get install mongodb-org-tools -y \
 && apt-get --purge autoremove curl wget -y \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Update npm
RUN npm install -g npm@8.13.2

#Add non-root user, add installation directories and assign proper permissions
RUN mkdir -p /opt/meshcentral

#meshcentral installation
# Update to Version 1.0.50
WORKDIR /opt/meshcentral

RUN npm install meshcentral

# Update npm
#RUN npm install -g npm@8.13.1

#Copy config template and startup script
COPY config.json.template /opt/meshcentral/config.json.template
COPY startup.sh startup.sh
#environment variables

EXPOSE 80 443

#volumes
VOLUME /opt/meshcentral/meshcentral-data
VOLUME /opt/meshcentral/meshcentral-files

CMD ["bash","/opt/meshcentral/startup.sh"]
