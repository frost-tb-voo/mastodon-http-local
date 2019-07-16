#!/bin/sh

DIR=$(cd $(dirname ${BASH_SOURCE:-$0}); pwd)

echo purge containers for mstdn
cd ${DIR}
sudo docker-compose stop
sudo docker-compose rm
cd .. && sudo rm -rf ${DIR}
sudo docker stop nginx
sudo docker rm nginx
# sudo docker stop postfix
# sudo docker rm postfix

