#!/bin/bash

#export NODE_ENV=production
export NODE_ENV
export HOSTNAME
export REVERSE_PROXY
export REVERSE_PROXY_TLS_PORT
export IFRAME
export ALLOW_NEW_ACCOUNTS
export WEBRTC
export TZ

if [ -f "meshcentral-data/config.json" ]
    then
        node node_modules/meshcentral 
    else
        cp config.json.template meshcentral-data/config.json
        sed -i "s/\"cert\": \"myserver.mydomain.com\"/\"cert\": \"$HOSTNAME\"/" meshcentral-data/config.json
        sed -i "s/\"NewAccounts\": true/\"NewAccounts\": \"$ALLOW_NEW_ACCOUNTS\"/" meshcentral-data/config.json
        sed -i "s/\"WebRTC\": false/\"WebRTC\": \"$WEBRTC\"/" meshcentral-data/config.json
        sed -i "s/\"AllowFraming\": false/\"AllowFraming\": \"$IFRAME\"/" meshcentral-data/config.json
        if [ "$REVERSE_PROXY" != "false" ]
            then 
                sed -i "s/\"_certUrl\": \"my\.reverse\.proxy\"/\"certUrl\": \"https:\/\/$REVERSE_PROXY:$REVERSE_PROXY_TLS_PORT\"/" meshcentral-data/config.json
                node node_modules/meshcentral
                exit
        fi
        node node_modules/meshcentral --cert "$HOSTNAME"     
fi

# Set Time Zone
if  [ ! ${TZ} ]; then

  # delete file timezone if exist
  if [ -f /etc/timezone ] ; then
    rm /etc/timezone 
  fi

  # delete file localtime if exist and create new one
  if [ -f /etc/localtime ] ; then
    rm /etc/localtime
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
  fi

fi

