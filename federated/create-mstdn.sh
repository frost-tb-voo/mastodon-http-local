#!/bin/bash

DIR=$(cd $(dirname ${BASH_SOURCE:-$0}); pwd)

if [[ -z ${INSTANCE} ]];then
  exit
fi
if [[ -z ${MSTDN_SUBNET} ]];then
  exit
fi
if [[ -z ${MSTDN_IPV4_WEB} ]];then
  exit
fi
if [[ -z ${MSTDN_IPV4_STREAMING} ]];then
  exit
fi
if [[ -z ${MSTDN_IPV4_SIDEKIQ} ]];then
  exit
fi
if [[ -z ${NGINX_IP} ]];then
  exit
fi
if [[ -z ${USER_NAME} ]];then
  exit
fi
if [[ -z ${USER_EMAIL} ]];then
  exit
fi

cp ../template/docker-compose.yml .
ENV_TEXT=`cat << _EOF_ > .env
MSTDN_SUBNET=${MSTDN_SUBNET}
MSTDN_IPV4_WEB=${MSTDN_IPV4_WEB}
MSTDN_IPV4_STREAMING=${MSTDN_IPV4_STREAMING}
MSTDN_IPV4_SIDEKIQ=${MSTDN_IPV4_SIDEKIQ}
INSTANCE=${INSTANCE}
NGINX_IP=${NGINX_IP}
_EOF_
`
cp ../template/.env.development .
echo "LOCAL_DOMAIN=${NGINX_IP}" >> .env.development


sudo docker-compose pull
# sudo docker-compose run web bundle exec rake --tasks
# sudo docker-compose run web bundle exec rake mastodon:setup
echo -n "SECRET_KEY_BASE=" >> .env.development
sudo docker-compose run web bundle exec rake secret >> .env.development
sudo docker-compose stop
echo -n "OTP_SECRET=" >> .env.development
sudo docker-compose run web bundle exec rake secret >> .env.development
sudo docker-compose stop
cat .env.development


sudo docker-compose run web rails db:migrate
sudo docker-compose stop
sudo docker-compose run web rails assets:precompile
sudo docker-compose stop
echo ${USER_EMAIL} > ./accounts-${USER_NAME}.md
sudo docker-compose run web bin/tootctl accounts create ${USER_NAME} --email ${USER_EMAIL} --confirmed --role admin >> ./accounts-${USER_NAME}.md
sudo docker-compose stop
sudo docker-compose up -d
