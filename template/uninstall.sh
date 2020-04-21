#!/bin/sh

DIR=$(cd $(dirname ${BASH_SOURCE:-$0}); pwd)

echo purge containers for mstdn
cd ${DIR}
docker-compose stop
docker-compose rm
# remove folder manually because there is files from containers not owned by user
# cd .. && rm -rf ${DIR}
docker stop nginx
docker rm nginx
# docker stop postfix
# docker rm postfix
