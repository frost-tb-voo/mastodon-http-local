#!/bin/bash

DIR=$(cd $(dirname ${BASH_SOURCE:-$0}); pwd)

if [[ -z ${INSTANCE} ]];then
  exit
fi
if [[ -z ${NGINX_IP} ]];then
  exit
fi

cp ../template/nginx_conf_prefix ./nginx.conf
cat ../template/nginx_conf_suffix >> ./nginx.conf
sed -i -e 's|${INSTANCE}|'${INSTANCE}'|g' ./nginx.conf
sed -i -e 's|${NGINX_IP}|'${NGINX_IP}'|g' ./nginx.conf
if [[ -n ${PUBLIC_DOMAIN_OR_IP} ]];then
  cat ../template/nginx_conf_suffix >> ./nginx.conf
  sed -i -e 's|${INSTANCE}|'${INSTANCE}'|g' ./nginx.conf
  sed -i -e 's|${NGINX_IP}|'${PRIVATE_DOMAIN_OR_IP}'|g' ./nginx.conf
fi

sudo docker pull nginx
sudo docker stop nginx
sudo docker rm nginx
sudo docker create --name=nginx \
 -p 80:80 \
 -v ${DIR}/../${INSTANCE}/nginx.conf:/etc/nginx/conf.d/mastodon.nginx.conf \
 nginx
sudo docker network connect ${INSTANCE}_external_network \
 --ip ${NGINX_IP} \
 nginx
# sudo docker start nginx -i -a
sudo docker start nginx
