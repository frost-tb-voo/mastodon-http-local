#!/bin/bash

DIR=$(cd $(dirname ${BASH_SOURCE:-$0}); pwd)

export USER_NAME=admin
export USER_EMAIL=admin@example.local
export PRIVATE_DOMAIN_OR_IP=

export INSTANCE=mastodon-http-local-32
export NGINX_IP=172.32.0.10
export MSTDN_SUBNET=172.32.0.0/24
export MSTDN_IPV4_WEB=172.32.0.4
export MSTDN_IPV4_STREAMING=172.32.0.6
export MSTDN_IPV4_SIDEKIQ=172.32.0.8
# export SMTP_HOSTNAME=postfix
# export POSTFIX_IP=172.32.0.12

cd ${DIR}/..
if [[ -e ${INSTANCE} ]]; then
  exit
fi
mkdir -p ${INSTANCE}
cd ${INSTANCE}
sudo -E chown -hR ${USER} .

cp ../template/uninstall.sh .
echo "sudo docker network rm ${INSTANCE}_external_network ${INSTANCE}_internal_network" >> ./uninstall.sh
bash ${DIR}/create-mstdn.sh
bash ${DIR}/create-nginx.sh
# bash ${DIR}/create-postfix.sh

echo
echo
if [[ -n ${PRIVATE_DOMAIN_OR_IP} ]]; then
  echo "open ${PRIVATE_DOMAIN_OR_IP}:80 with :"
else
  echo "open ${NGINX_IP}:80 with :"
fi
cat ./accounts-${USER_NAME}.md
# sudo -E chown -hR ${USER} .

