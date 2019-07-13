#!/bin/bash

DIR=$(cd $(dirname ${BASH_SOURCE:-$0}); pwd)

export USER_NAME=admin
export USER_EMAIL=admin@example.com


export INSTANCE=mastodon-http-local-34
export NGINX_IP=172.34.0.32
export MSTDN_SUBNET=172.34.0.0/24
export MSTDN_IPV4_WEB=172.34.0.4
export MSTDN_IPV4_STREAMING=172.34.0.6
export MSTDN_IPV4_SIDEKIQ=172.34.0.8

cd ${DIR}/..
if [[ -e ${INSTANCE} ]]; then
  exit
fi
mkdir -p ${INSTANCE}
cd ${INSTANCE}
sudo -E chown -hR ${USER} .

cp ../template/uninstall.sh .
bash ${DIR}/create-mstdn.sh


export INSTANCE=mastodon-http-local-36
export NGINX_IP=172.36.0.32
export MSTDN_SUBNET=172.36.0.0/24
export MSTDN_IPV4_WEB=172.36.0.4
export MSTDN_IPV4_STREAMING=172.36.0.6
export MSTDN_IPV4_SIDEKIQ=172.36.0.8

cd ${DIR}/..
if [[ -e ${INSTANCE} ]]; then
  exit
fi
mkdir -p ${INSTANCE}
cd ${INSTANCE}
sudo -E chown -hR ${USER} .

cp ../template/uninstall.sh .
bash ${DIR}/create-mstdn.sh


export INSTANCE=mastodon-http-local-38
export NGINX_IP=172.38.0.32
export MSTDN_SUBNET=172.38.0.0/24
export MSTDN_IPV4_WEB=172.38.0.4
export MSTDN_IPV4_STREAMING=172.38.0.6
export MSTDN_IPV4_SIDEKIQ=172.38.0.8

cd ${DIR}/..
if [[ -e ${INSTANCE} ]]; then
  exit
fi
mkdir -p ${INSTANCE}
cd ${INSTANCE}
sudo -E chown -hR ${USER} .

cp ../template/uninstall.sh .
bash ${DIR}/create-mstdn.sh


export INSTANCE1=mastodon-http-local-34
export NGINX_IP1=172.34.0.32
export INSTANCE2=mastodon-http-local-36
export NGINX_IP2=172.36.0.32
export INSTANCE3=mastodon-http-local-38
export NGINX_IP3=172.38.0.32

bash ${DIR}/create-nginx.sh

# sudo -E chown -hR ${USER} .

