# Filename: Dockerfile

FROM ubuntu:latest

# Disable Prompt During Packages Installation
ARG DEBIAN_FRONTEND=noninteractive

ENV NODE_VERSION v18.5.0

#install dependencies
#RUN apt-get update && apt-get install -y nodejs npm nano \
RUN apt-get update && apt-get install -y gnupg2 nano iputils-ping tar xz-utils \
 && apt-get install -y curl wget \ 
 #&& curl -fsSL https://www.mongodb.org/static/pgp/server-4.4.asc | apt-key add - \
 && curl -sL https://www.mongodb.org/static/pgp/server-4.4.asc | gpg --dearmor | tee /etc/apt/trusted.gpg.d/server-4.4.gpg  >/dev/null \
 && echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/4.4 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-4.4.list \
 && cd /tmp \
 && curl -LO https://nodejs.org/dist/${NODE_VERSION}/node-${NODE_VERSION}-linux-x64.tar.xz \
 && tar -xvf node-${NODE_VERSION}-linux-x64.tar.xz \
 && cp -r node-${NODE_VERSION}-linux-x64/bin /usr/ \
 && cp -r node-${NODE_VERSION}-linux-x64/include /usr/ \
 && cp -r node-${NODE_VERSION}-linux-x64/lib /usr/ \
 && cp -r node-${NODE_VERSION}-linux-x64/share /usr/ \
 && node --version => ${NODE_VERSION} \
 && rm -rf /tmp/node-${NODE_VERSION}-linux* \
 #&& wget https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh \
 #&& bash install.sh \
 #&& . /root/.bashrc \
 #&& nvm install ${NODE_VERSION} \
 #&& node -v \
 #&& rm -rf install.sh \
 && apt-get update \
 && apt-get dist-upgrade -y \
 && apt-get install mongodb-org-tools -y \
 && apt-get --purge autoremove curl wget -y \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Update npm
RUN npm install -g npm@latest

#Add non-root user, add installation directories and assign proper permissions
RUN mkdir -p /opt/meshcentral

#meshcentral installation
# Update to Version 1.1.4
WORKDIR /opt/meshcentral

RUN npm install meshcentral

# Update npm
#RUN npm install -g npm@8.13.1

#Copy config template and startup script
COPY config.json.template /opt/meshcentral/config.json.template
COPY startup.sh startup.sh
#environment variables

EXPOSE 80 443 4433

#volumes
VOLUME /opt/meshcentral/meshcentral-data
VOLUME /opt/meshcentral/meshcentral-files

CMD ["bash","/opt/meshcentral/startup.sh"]
