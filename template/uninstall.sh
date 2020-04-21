#!/bin/sh

DIR=$(cd $(dirname ${BASH_SOURCE:-$0}); pwd)

echo Purging containers for mastodon in ${DIR} ...
cd ${DIR}
docker-compose stop
docker-compose rm
docker stop nginx
docker rm nginx
# docker stop postfix
# docker rm postfix

echo Note: please remove folder manually because there is files from containers not owned by user
# cd .. && rm -rf ${DIR}

