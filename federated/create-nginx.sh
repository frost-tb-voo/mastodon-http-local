#!/bin/bash

DIR=$(cd $(dirname ${BASH_SOURCE:-$0}); pwd)

if [[ -z ${INSTANCE1} ]];then
  exit
fi
if [[ -z ${NGINX_IP1} ]];then
  exit
fi

cp ../template/nginx_conf_prefix ./nginx.conf
cat ../template/nginx_conf_suffix >> ./nginx.conf
sed -i -e 's|${INSTANCE}|'${INSTANCE1}'|g' ./nginx.conf
sed -i -e 's|${NGINX_IP}|'${NGINX_IP1}'|g' ./nginx.conf
cat ../template/nginx_conf_suffix >> ./nginx.conf
sed -i -e 's|${INSTANCE}|'${INSTANCE2}'|g' ./nginx.conf
sed -i -e 's|${NGINX_IP}|'${NGINX_IP2}'|g' ./nginx.conf
cat ../template/nginx_conf_suffix >> ./nginx.conf
sed -i -e 's|${INSTANCE}|'${INSTANCE3}'|g' ./nginx.conf
sed -i -e 's|${NGINX_IP}|'${NGINX_IP3}'|g' ./nginx.conf

docker pull nginx
docker stop nginx
docker rm nginx
docker create --name=nginx \
 --restart=always \
 -p 80:80 \
 -v ${DIR}/../${INSTANCE}/nginx.conf:/etc/nginx/conf.d/mastodon.nginx.conf \
 nginx
docker network connect ${INSTANCE1}_external_network \
 --ip ${NGINX_IP1} \
 nginx
docker network connect ${INSTANCE2}_external_network \
 --ip ${NGINX_IP2} \
 nginx
docker network connect ${INSTANCE3}_external_network \
 --ip ${NGINX_IP3} \
 nginx
docker network connect ${INSTANCE1}_external_network ${INSTANCE3}_web_1
docker network connect ${INSTANCE1}_external_network ${INSTANCE3}_sidekiq_1
docker network connect ${INSTANCE1}_external_network ${INSTANCE3}_streaming_1
docker network connect ${INSTANCE2}_external_network ${INSTANCE3}_web_1
docker network connect ${INSTANCE2}_external_network ${INSTANCE3}_sidekiq_1
docker network connect ${INSTANCE2}_external_network ${INSTANCE3}_streaming_1

docker network connect ${INSTANCE2}_external_network ${INSTANCE1}_web_1
docker network connect ${INSTANCE2}_external_network ${INSTANCE1}_sidekiq_1
docker network connect ${INSTANCE2}_external_network ${INSTANCE1}_streaming_1
docker network connect ${INSTANCE3}_external_network ${INSTANCE1}_web_1
docker network connect ${INSTANCE3}_external_network ${INSTANCE1}_sidekiq_1
docker network connect ${INSTANCE3}_external_network ${INSTANCE1}_streaming_1

docker network connect ${INSTANCE3}_external_network ${INSTANCE2}_web_1
docker network connect ${INSTANCE3}_external_network ${INSTANCE2}_sidekiq_1
docker network connect ${INSTANCE3}_external_network ${INSTANCE2}_streaming_1
docker network connect ${INSTANCE1}_external_network ${INSTANCE2}_web_1
docker network connect ${INSTANCE1}_external_network ${INSTANCE2}_sidekiq_1
docker network connect ${INSTANCE1}_external_network ${INSTANCE2}_streaming_1
# docker start nginx -i -a
docker start nginx
