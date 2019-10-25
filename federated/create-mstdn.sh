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


# Comment out pull command if build in local.
sudo -E docker-compose pull
echo -n "SECRET_KEY_BASE=" >> .env.development
sudo -E docker-compose run --rm web bundle exec rake secret >> .env.development
sudo -E docker-compose stop
echo -n "OTP_SECRET=" >> .env.development
sudo -E docker-compose run --rm web bundle exec rake secret >> .env.development
sudo -E docker-compose stop
cat .env.development


sudo -E docker-compose run --rm web rails db:migrate
sudo -E docker-compose stop
sudo -E docker-compose run --rm web rails assets:precompile
sudo -E docker-compose stop
echo ${USER_EMAIL} > ./accounts-${USER_NAME}.md
sudo -E docker-compose run --rm web bin/tootctl accounts create ${USER_NAME} --email ${USER_EMAIL} --confirmed --role admin >> ./accounts-${USER_NAME}.md
sudo -E docker-compose stop
sudo -E docker-compose up -d
sudo -E docker-compose exec -u root web chown -hR mastodon public
